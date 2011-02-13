From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCH 1/3] qla2xxx: Remove check to return DID_NO_CONNECT when
 FC device is lost.
Date: Sat, 12 Feb 2011 19:20:21 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8722614B053@AVEXMB1.qlogic.org>
References: <1296256677-11572-1-git-send-email-madhu.iyengar@qlogic.com>
	 <1296256677-11572-2-git-send-email-madhu.iyengar@qlogic.com>
 <1297529533.3026.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:58491
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298Ab1BMDf2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Feb 2011 22:35:28 -0500
In-Reply-To: <1297529533.3026.8.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Madhu Iyengar <madhu.iyengar@qlogic.com>

James,

Sorry about that. Here's the commit message, which explains the patch. Can you please add this to the patch? Thanks in advance:

---
If the target device gets lost, this fix is needed, as it causes negative unintended responses on basic I/O tests. If the target device gets lost, the upstream qla2xxx driver returns SCSI_MLQUEUE_TARGET_BUSY which causes an immediate retry without drop in the number of allowed retries. This semantic change, as a result of removing FC_DEVICE_LOST check is reasonable, as it only extends a short transitional period, until the transport is called to notify that the rport as lost (fc_remote_port_delete()). Once transport notification is done, fc_remote_port_chkready() check will take over.
---

Cheers,
Madhu

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@suse.de]
> Sent: Saturday, February 12, 2011 8:52 AM
> To: Madhu Iyengar
> Cc: Giridhar Malavali; Andrew Vasquez; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/3] qla2xxx: Remove check to return DID_NO_CONNECT
> when FC device is lost.
>
> On Fri, 2011-01-28 at 15:17 -0800, madhu.iyengar@qlogic.com wrote:
> > From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> >
> > Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_os.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c
> b/drivers/scsi/qla2xxx/qla_os.c
> > index c194c23..5dc548b 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -562,7 +562,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void
> (*done)(struct scsi_cmnd *)
> >     }
> >     if (atomic_read(&fcport->state) != FCS_ONLINE) {
> >             if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
> > -                   atomic_read(&fcport->state) == FCS_DEVICE_LOST ||
>
> This looks like you're actually *not* returning DID_NO_CONNECT when the
> device is lost ... what are you returning instead, and why is this an
> important bug fix?
>
> James
>
>
> >                     atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
> >                     cmd->result = DID_NO_CONNECT << 16;
> >                     goto qc24_fail_command;
>
>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

