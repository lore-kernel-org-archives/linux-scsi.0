From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Tue, 15 Nov 2016 15:48:25 +0100
Message-ID: <20161115144825.flfj2uuioj7fp3pd@linux-x5ow.site>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <bbc682928173d64848ab0cbff689b1ad3d715fb7.1476369687.git.jthumshirn@suse.de>
 <ebc46cfa-0bee-aa71-ba0b-d7c86628df0c@linux.vnet.ibm.com>
 <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
 <20161025074313.4ma4czgdj46imaei@linux-x5ow.site>
 <20161115115622.j4ker3atejcodqrc@linux-x5ow.site>
 <8647eacd-a029-dff0-4f78-dafef89a5ad9@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8647eacd-a029-dff0-4f78-dafef89a5ad9@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>s
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 15, 2016 at 03:31:27PM +0100, Steffen Maier wrote:
> Hi Johannes,
> 
> On 11/15/2016 12:56 PM, Johannes Thumshirn wrote:
> > On Tue, Oct 25, 2016 at 09:43:14AM +0200, Johannes Thumshirn wrote:
> > > On Fri, Oct 14, 2016 at 09:38:21AM +0200, Johannes Thumshirn wrote:
> > > > On Thu, Oct 13, 2016 at 05:55:11PM +0200, Steffen Maier wrote:
> > > > > Hm, still behaves for me like I reported for v2:
> > > > > http://marc.info/?l=linux-scsi&m=147637177902937&w=2
> > 
> > [...]
> > 
> > > > 
> > > > The rational behind this is, in fc_req_to_bsgjob() we're assigning
> > > > job->request as req->cmd and job->request_len = req->cmd_len. But without
> > > > checkinf job->request_len we don't know whether we're save to touch
> > > > job->request (a.k.a. bsg_request).
> > > 
> > > Hi Steffen,
> > > Did you have any chance testing this? I hacked fcping to work with non-FCoE
> > > and rports as well and tested with FCoE and lpfc. No problems seen from my
> > > side. I've also pused the series (With this change folded in) to my git
> > > tree at [1] if this helps you in any way.
> > > 
> > > [1] https://git.kernel.org/cgit/linux/kernel/git/jth/linux.git/log/?h=scsi-bsg-rewrite-v4
> > > 
> > 
> > So I finally have a test system up and running. I have good and bad news. The
> > good news is, I can't get the system crashing with my patches, the bad news is
> > I can't get zfcp_ping and zfcp_show to output something but HBA_STATUS_ERROR
> > with my patches and without.
> 
> Assuming you run the latest package version on s390x:
> 
> Do steps 2 and 3 of the procedure in
> http://www.ibm.com/support/knowledgecenter/linuxonibm/com.ibm.linux.z.lhdd/lhdd_t_fcp_api_runappl.html
> help?

No, I do have a correct /etc/hba.conf:
$ grep libzfcphbaapi /etc/hba.conf 
com.ibm.libzfcphbaapi /usr/lib64/libzfcphbaapi.so.0
and bumping the log level via export LIB_ZFCP_HBAAPI_LOG_LEVEL=1 just adds 
'(vlib.c:105)_initvlib: libzfcphbaapi.so loaded at Nov 15 15:43:23' to the 1st
line of zfcp_ping output.

Here's the full output:
$ zfcp_ping -v -a 0.0.fc00 -d 0x50050763051b473a
(vlib.c:105)_initvlib: libzfcphbaapi.so loaded at Nov 15 15:45:33
Sending PNG from BUS_ID=0.0.fc00 WWPN=0xc05076e0f3002344 ID=0x760c1c
dev=/dev/bsg/fc_host1 speed=8 GBit/s
--- REQUEST cmd = 0x0401 ---
03 00 00 00 fa 01 00 00 
04 01 00 01 00 00 00 00 
00 00 00 01 00 02 00 08 
50 05 07 63 05 1b 47 3a 
00 00 00 00 
--- RESPONSE rc = 0x1 ---
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 00 
--- REQUEST cmd = 0x0401 ---
03 00 00 00 fa 01 00 00 
04 01 00 01 00 00 00 00 
00 00 00 01 00 02 00 08 
50 05 07 63 05 1b 47 3a 
00 00 00 00 
--- RESPONSE rc = 0x1 ---
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 00 
--- REQUEST cmd = 0x0401 ---
03 00 00 00 fa 01 00 00 
04 01 00 01 00 00 00 00 
00 00 00 01 00 02 00 08 
50 05 07 63 05 1b 47 3a 
00 00 00 00 
--- RESPONSE rc = 0x1 ---
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 00 
Error received for FPNG request, aborting.

---------- ping statistics -----------
min/avg/max = 0.000/0.000/0.000 ms
--------------------------------------

I agree this looks a bit suspicious and I'll add some debugs in the kernel to
see what's going on.

> 
> The only other thing I can think of from the top of my head is that BSG
> ioctls are sensitive regarding ABI and I once had the kernel ioctl return
> EINVAL due to unmatching kernel-headers and libzfcphbaapi maps this EINVAL
> to HBA_STATUS_ERROR because there is no more specifically suitable HBA
> constant [old SUSE bugs 834498 and 834500].
> 
> > And btw, I renamed the branch to fc-bsg-rewrite-v4 in case you want to clone
> > from it (it has patch 2/16 changed to the v3 submission).
> > 
> > Can you please have a look with your setup?
> 
> I'm going to re-test hopefully within the next few days.

That'll be great, thanks.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
