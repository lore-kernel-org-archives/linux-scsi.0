From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: Re: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: Fri, 25 Feb 2005 11:32:45 -0800
Message-ID: <1109359965.5848.110.camel@haakon>
References: <1109187935.15154.164.camel@haakon>
	 <x05mzttr8aw.fsf@null.msp.redhat.com> <1109317829.5848.22.camel@haakon>
	 <20050225.091824.97479573.alewis@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp815.mail.sc5.yahoo.com ([66.163.170.1]:53857 "HELO
	smtp815.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261179AbVBYTgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 14:36:15 -0500
In-Reply-To: <20050225.091824.97479573.alewis@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: AJ Lewis <alewis@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2005-02-25 at 09:18 -0600, AJ Lewis wrote:
> On Thu, 24 Feb 2005 23:50:29 -0800, "Nicholas A. Bellinger" <nick@pyxtechnologies.com> wrote:
> > On Thu, 2005-02-24 at 14:51 -0600, AJ Lewis wrote:
> > > I've gotten this setup and
> > > running, but I can't seem to talk to my iscsi target.  The initiator
> > > detects it, but it can't recognize the type:
> > > 
> > > iCHANNEL[0] - No defined iSCSI Authentication Methods, skipping SecurityNegotiation phase.
> > > iCHANNEL[0] - iSCSI login successful on CID: 0 to 192.168.44.19:3260,2
> > > iCHANNEL[0] - Incremented iSCSI connection count to 1 to node: iqn.1992-08.com.netapp:sn.33615311
> > > iCHANNEL[0] - Established iSCSI session to node: iqn.1992-08.com.netapp:sn.33615311
> > > iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 1.
> > > scsi: unknown device type 31
> > >   Vendor: NETAPP    Model: LUN               Rev: 0.2 
> > >   Type:   Unknown                            ANSI SCSI revision: 04
> > > 
> > > Any ideas on why this wouldn't be working?  Is there a configuration
> > > step I'm missing?
> > > 
> > 
> > This looks like an unknown/unsupported SCSI Peripheral device type in
> > the INQUIRY response data.  Is this LU just a sequential access device
> > that is setting those bits to some different value?
> 
> Well, the cisco linux-iscsi initiator works just fine with it, so I
> don't think it's an issue with the NetApp and linux.  With the
> linux-iscsi initiator, /proc/scsi/scsi looks like this:
> 
> Host: scsi4 Channel: 00 Id: 00 Lun: 00
>   Vendor: NETAPP   Model: LUN              Rev: 0.2 
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> 
> 
> With the pyx initiator, it looks like this:
>  Host: scsi6 Channel: 00 Id: 00 Lun: 00
>   Vendor: NETAPP   Model: LUN              Rev: 0.2 
>   Type:   Unknown                          ANSI SCSI revision: 04
>

This is strange indeed.  I am not sure how the peripheral device type
could get set incorrectly during the DataIN transfer, but the
Vendor/Model/Rev still be intact.

> > It would certainly be interesting to see with Ethereal what is in the
> > INQUIRY response data that Linux could possibly not support. :-)
> 
> Hrm...don't have anything setup to do that ATM, but I could probably
> get something going...
> 

This would definately help.

> > > Also, are you planning on updating the docs for the user tools at all?
> > > There are several steps missing in the current README, and the man
> > > page lists some parameters incorrectly and misses other entirely.
> > > 
> > 
> > There are a couple of things I would like to be accomplished in the near
> > feature for the user tools:
> > 
> > 1) Complete documentation of iSCSI Channel Management optertions by way
> > of updated initiator-ctl manual pages and basic HOWTO for iSCSI Logical
> > Unit Management Screnarios for iSCSI SAN Adminstitrators.
> > 2) Initial release of authentication daemon using CHAP, with eventual
> > support for RFC 3720 defined SRP.
> > 3) Work towards supporting the Internet Storage Naming Service (iSNS)
> > standard and assoicated open source implementations for discovery and
> > device information for iSCSI Target Nodes and other storage resources.
> 
> And for the kernel side, it looks like:
> 
>  1) /proc -> sysfs conversion

I am working on this one.

>  2) ioctl -> sysfs conversion

This may take a bit longer than #1.

>  Both of which include integration of the iscsi transport class discussed
>  on this list

I have a patch for that that I am working on as well.

> Out of curiousity, what does this initiator offer that the linux-iscsi
> initiator doesn't?  (http://linux-iscsi.sourceforge.net/) I'm just
> curious what you see as advantages this implementation has.

I took the the important iSCSI features from RELEASE_NOTES:

3) Full support for Multiple Connections per Session that can be brought
up and down on the fly.
4) Full support for DataPDUInOrder=No, DataSequenceInOrder=No,
MaxOutstandingR2T>1.
5) Full support for Sync and Steering using Fixed Interval Markers. (See
RFC 3720 Appendix A) 
6) Full support for TCP and SCTP network transports.
7) Robust set of iSCSI Channel management options for iSCSI SAN
Administrators
*8) Persisant mapping of iSCSI Logical Units to mount points.

Also, a fair amount of code not directly related to but required for
ERL=1 logic has been included as well.  Over time we will be releasing
parts of ERL=1 functionality until all of within command and within
connection recovery as defined by 6.1.4.1 and 6.1.4.2 of RFC 3720 is
supported.

Thanks,

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

