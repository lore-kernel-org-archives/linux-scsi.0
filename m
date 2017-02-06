From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 03/39] megaraid_sas: raid 1 fast path code optimize
Date: Mon, 6 Feb 2017 18:57:10 +0530
Message-ID: <47ae74d6db3626e7839b3c3b0acb8738@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-4-git-send-email-shivasharan.srikanteshwara@broadcom.com> <79d89239-30cc-0161-24fa-57800f12460c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:32938 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdBFN1M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 08:27:12 -0500
Received: by mail-qt0-f177.google.com with SMTP id v23so104581171qtb.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 05:27:12 -0800 (PST)
In-Reply-To: <79d89239-30cc-0161-24fa-57800f12460c@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

> >
> >  /**
> > + * megasas_complete_r1_command -
> > + * completes R1 FP write commands which has valid peer smid
> > + * @instance:			Adapter soft state
> > + * @cmd_fusion:			MPT command frame
> > + *
> > + */
> > +static inline void
> > +megasas_complete_r1_command(struct megasas_instance *instance,
> > +			    struct megasas_cmd_fusion *cmd) {
> > +	u8 *sense, status, ex_status;
> > +	u32 data_length;
> > +	u16 peer_smid;
> > +	struct fusion_context *fusion;
> > +	struct megasas_cmd_fusion *r1_cmd = NULL;
> > +	struct scsi_cmnd *scmd_local = NULL;
> > +	struct RAID_CONTEXT_G35 *rctx_g35;
> > +
> > +	rctx_g35 = &cmd->io_request->RaidContext.raid_context_g35;
> > +	fusion = instance->ctrl_context;
> > +	peer_smid = le16_to_cpu(rctx_g35->smid.peer_smid);
> > +
> > +	r1_cmd = fusion->cmd_list[peer_smid - 1];
> > +	scmd_local = cmd->scmd;
> > +	status = rctx_g35->status;
> > +	ex_status = rctx_g35->ex_status;
> > +	data_length = cmd->io_request->DataLength;
> > +	sense = cmd->sense;
> > +
> > +	cmd->cmd_completed = true;
> > +
> > +	/* Check if peer command is completed or not*/
> > +	if (r1_cmd->cmd_completed) {
> > +		if (rctx_g35->status != MFI_STAT_OK) {
> > +			status = rctx_g35->status;
> > +			ex_status = rctx_g35->ex_status;
>
> Both status + ex_status were already set to the same value, why is it
> repeated here ?

Tomas, This need a fix. Raid context should be switch to r1_cmd, but it
that is not done here.
We want if r1 cmd is completed with failure, check status and extended
status from r1_cmd to send final status to mid layer.

We will fix this and resend patch. It will be like this -

	if (r1_cmd->cmd_completed) {
		rctx_g35 =
&r1_cmd->io_request->RaidContext.raid_context_g35;        << -This line
should be added.
		if (rctx_g35->status != MFI_STAT_OK) {
			status = rctx_g35->status;
			ex_status = rctx_g35->ex_status;

Thanks, Kashyap

>
> Tomas
>
