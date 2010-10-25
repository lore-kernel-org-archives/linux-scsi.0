From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 06/15] qla4xxx: Do not wait for the outstanding
 commands to complete
Date: Mon, 25 Oct 2010 14:56:50 -0500
Message-ID: <1288036610.5487.704.camel@mulgrave.site>
References: <5E4F49720D0BAD499EE1F01232234BA87129406789@AVEXMB1.qlogic.org>
	 <4CAE8604.1020702@cs.wisc.edu>
	 <5E4F49720D0BAD499EE1F01232234BA87129406BE7@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab0JYT44 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 15:56:56 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA87129406BE7@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Nilesh Javali <nilesh.javali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

On Mon, 2010-10-11 at 02:24 -0700, Vikas Chaudhary wrote:
> >-----Original Message-----
> >From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> >Sent: Friday, October 08, 2010 8:16 AM
> >To: Vikas Chaudhary
> >Cc: James.Bottomley@suse.de; linux-scsi@vger.kernel.org; Nilesh Javali;
> >Ravi Anand
> >Subject: Re: [PATCH 06/15] qla4xxx: Do not wait for the outstanding
> >commands to complete
> >
> >On 10/07/2010 12:49 AM, Vikas Chaudhary wrote:
> >> From: Nilesh Javali<nilesh.javali@qlogic.com>
> >>
> >> Do not wait for the outstanding commands to complete in case of
> >> firmware hang.
> >>
> >> Signed-off-by: Nilesh Javali<nilesh.javali@qlogic.com>
> >> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> >> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> >> ---
> >>   drivers/scsi/qla4xxx/ql4_os.c |    6 ++++--
> >>   1 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/qla4xxx/ql4_os.c
> >> b/drivers/scsi/qla4xxx/ql4_os.c index 56962e5..a6455fb 100644
> >> --- a/drivers/scsi/qla4xxx/ql4_os.c
> >> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> >> @@ -1102,7 +1102,8 @@ static int qla4xxx_recover_adapter(struct
> >scsi_qla_host *ha)
> >>   		    ha->host_no, __func__));
> >>   		status = ha->isp_ops->reset_firmware(ha);
> >>   		if (status == QLA_SUCCESS) {
> >> -			qla4xxx_cmd_wait(ha);
> >> +			if (!test_bit(AF_FW_RECOVERY,&ha->flags))
> >> +				qla4xxx_cmd_wait(ha);
> >>   			ha->isp_ops->disable_intrs(ha);
> >>   			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
> >>   			qla4xxx_abort_active_cmds(ha, DID_RESET<<  16); @@ -
> >1119,7
> >> +1120,8 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
> >>   	 * or if stop_firmware fails for ISP-82xx.
> >>   	 * This is the default case for ISP-4xxx */
> >>   	if (!is_qla8022(ha) || reset_chip) {
> >> -		qla4xxx_cmd_wait(ha);
> >> +		if (!test_bit(AF_FW_RECOVERY,&ha->flags))
> >> +			qla4xxx_cmd_wait(ha);
> >>   		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
> >>   		qla4xxx_abort_active_cmds(ha, DID_RESET<<  16);
> >>   		DEBUG2(ql4_printk(KERN_INFO, ha,
> >
> >If we go from qla4xxx_eh_host_reset->qla4xxx_recover_adapter and you do not
> >wait, is is possible for the driver to be accessing scsi commands after
> >qla4xxx_eh_host_reset returns? If so I think there is a problem where the
> >scsi eh will fail or retry the cmd so the memory for the scsi command could
> >be reallocated/freed.
> >
> 
> We do not access command after qla4xxx_eh_host_reset returns.
> 
> >On a related note, has qla4xxx_eh_host_reset ever returned SUCCESS? I think
> >there is a problem in qla4xxx_cmd_wait when the scsi eh is running. At that
> >time blk_finish_request->blk_queue_end_tag is not going to be run, because
> >if the driver were to call scsi_done the block layer would do
> >blk_complete_request and the blk_mark_rq_complete would fail (this is
> >because the scsi/block eh timeout could has already marked it complete).
> >
> >I think you need the attached patch.
> 
> Yes. We need attached patch. I am doing some testing with this patch.
> I will send out this patch for inclusion soon.

Is there an update on this?  It would be nice to include it before the
merge window closes.

James


