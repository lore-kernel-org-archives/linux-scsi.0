From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Fri, 25 Mar 2011 13:13:20 -0700
Message-ID: <1301084000.6087.63.camel@haakon2.linux-iscsi.org>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	 <1299508803.12730.1.camel@mulgrave.site>
	 <4D83C78D.5040908@linux.vnet.ibm.com>
	 <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
	 <4D87CF99.7040008@linux.vnet.ibm.com> <4D87D1B3.2030106@linux.vnet.ibm.com>
	 <1300747720.21880.95.camel@haakon2.linux-iscsi.org>
	 <4D889BB4.4010102@linux.vnet.ibm.com>
	 <1300831607.21880.365.camel@haakon2.linux-iscsi.org>
	 <4D8A0F89.201@linux.vnet.ibm.com>
	 <1300912481.18039.25.camel@haakon2.linux-iscsi.org>
	 <4D8CA7B4.3010800@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56473 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1CYUUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 16:20:38 -0400
In-Reply-To: <4D8CA7B4.3010800@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Fri, 2011-03-25 at 09:33 -0500, Brian King wrote:
> On 03/23/2011 03:34 PM, Nicholas A. Bellinger wrote:
> > On Wed, 2011-03-23 at 10:19 -0500, Brian King wrote:
> >> On 03/22/2011 05:06 PM, Nicholas A. Bellinger wrote:
> >>>>>> I'm also seeing disktest complain on the client about commands taking longer than 120 seconds
> >>>>>> on occasion, which may play into the performance issue I mentioned in my previous mail.
> >>>>>>
> >>>>>
> >>>>> Mmmm, please verify with RAMDISK_MCP backends as well, as by default
> >>>>> FILEIO has O_SYNC enabled..  This does seem strange for LTP disktest
> >>>>> however..
> >>
> >> With RAMDISK_MCP I don't see any of the problems seen with RAMDISK_DR. Additionally,
> >> disktest is running much snappier. I'm seeing between 30 and 60 MB/sec on the read workload
> >> and between 100 and 300 MB/sec on the writes. 
> >>
> > 
> > Thanks for the update Brian!  I am glad to hear we have a stable
> > baseline for large block throughput with RAMDISK_MCP.
> > 
> > I would also be interested to see how small block performance looks with
> > RAMDISK_MCP, and for IBLOCK/FILEIO/PSCSI export on top of some fast
> > physical storage as well.  :)
> 
> Not too good. I've tried both FILEIO and IBLOCK and am seeing in the neighborhood
> of 1 MB/sec read throughput and 5 MB/sec write throughput. I also continue
> to see warnings from disktest indicating I/O's are taking longer than 120 seconds.
> This is all with data integrity testing enabled, but I would still expect to see
> much better numbers... Not sure where the bottleneck is at this point. If I run with
> both a ramdisk LUN and an iblock LUN, I am seeing the ramdisk performance significantly
> reduced to be on par with the iblock performance.
> 

Hmmmm..  There have recently been some reports of poor performance on
bleeding edge .38 target FILEIO+IBLOCK backends with iscsi-target
export.  One tester notes they appears to go away when he went back to
a .36.4 kernel with current stable v3.5.2 target code from the
lio-core-backports.git tree.

I am not sure if these are related yet to what you are observing with
ibmvscsis with .38, but would be interested to see if using the pSCSI
backend passthrough makes any difference for struct block_device
backends, eg: it's a submit_bio() or higher regression with the block
layer, or some form of v3.5 -> v4.0 target regression.

Also just FYI, the plan is to provide an out-of-tree v4.0 target stable
backport build tree back to ~.32 stable code into lio-core-backports.git
in the next weeks that will allow v4 modules like ibmvscsis to function
(which appears is going to require your libsrp bugfix as well) for
current stable distro kernels.

So first trying /sys/kernel/config/target/core/pscsi_0/scsi_dev
passthrough device export on .38, and a backport of ibmvscsis to .36
kernel with v4 code for an IBLOCK/FILEIO control should help diagnoise
the issue.  For the latter, it should be really easy to get
drivers/target/ on .36.4 you want to try this ahead of the offical v4
backport to verify.

> >> I'm having some trouble with multiple LUNs, however. Perhaps this is more
> >> configuration issues, but if I create a lun_1 directory and link to a second
> >> device, the client just sees two devices which seems to be both mapped to
> >> the device mapped at lun_0.
> >>
> > 
> > Mmmm, this sounds like some a bug in incoming LUN unpack or outgoing LUN
> > pack issue.  From a quick look it appears we are missing a
> > scsi_lun_to_int() call for transport_get_lun_for_cmd which is currently
> > expecting an unpacked LUN.
> > 
> > @@ -880,7 +901,7 @@ static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
> >                               srp_cmd_direction(cmd),
> >                               attr, vsc->sense_buf);
> > 
> > -       ret = transport_get_lun_for_cmd(se_cmd, cmd->lun);
> > +       ret = transport_get_lun_for_cmd(se_cmd, scsi_lun_to_int(cmd->lun));
> >         if (ret) {
> >                 printk(KERN_ERR "invalid lun %u\n", GETLUN(cmd->lun));
> >                 transport_send_check_condition_and_sense(se_cmd,
> 
> This worked. I had to move the scsi_lun_to_int function further up the file in order
> to be able to build it, but once I did this multiple LUNs seems to be working.
> 

Ok great, thank you for the clarification here.

I still need to review my patch in the next days for Tomo-san for active
I/O shutdown items previously discussed.  Please feel free to send this
tested bugfix to him directly, and please let us know if you find
anything else that needs to be addressed.

Thanks!

--nab



