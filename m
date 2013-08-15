From: Ben Collins <ben.c@servergy.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Wed, 14 Aug 2013 22:52:58 -0400
Message-ID: <FE68512D-F375-456B-948A-492634A02F0F@servergy.com>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com> <yq1zjskgn1x.fsf@sermon.lab.mkp.net> <D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com> <yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46301 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610Ab3HOCxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2013 22:53:02 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so265629pbb.27
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2013 19:53:01 -0700 (PDT)
In-Reply-To: <yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, aradford@gmail.com

On Aug 14, 2013, at 3:44 PM, "Martin K. Petersen" <martin.petersen@oracle.com> wrote:

>>>>>> "Ben" == Ben Collins <ben.c@servergy.com> writes:
> 
> Ben> You're the man. Forward ported this to 3.11-rc code base. Worked
> Ben> like a charm.
> 
> Heh, you just beat me to it :)
> 
> Formatting differences aside there were a few glitches, however. I
> outlined them below...
> 
> Btw. the reason I did cpu_to_le16(0) etc. was mostly to annotate the
> endian-sensitive parameters in case somebody changes them in the future.

Right, I had over done it to make it consistent between similar code blocks. I'd like to see this (and the previous patch I sent for resource_size_t) included upstream. Considering your patch has had two success stories (I suspect yours was on SPARC, so that would even make two different platforms) and low likelihood of regression on little endian, I think it's pretty safe.

The only thing I think that could make it better is to annotate the structures in megaraid_sas.h as __le32 where applicable.

Thanks again Martin.

> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 7bf9c5c..154e9e1 100644
> @@ -1170,7 +1170,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
> 	 * Construct SGL
> 	 */
> 	if (instance->flag_ieee == 1) {
> -		flags |= MFI_FRAME_SGL64;
> +		flags |= MFI_FRAME_SGL64 | MFI_FRAME_IEEE;
> 		pthru->sge_count = megasas_make_sgl_skinny(instance, scp,
> 						      &pthru->sgl);
> 	} else if (IS_DMA64) {
> @@ -1328,8 +1328,10 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
> 	 * Sense info specific
> 	 */
> 	ldio->sense_len = SCSI_SENSE_BUFFERSIZE;
> -	ldio->sense_buf_phys_addr_hi = 0;
> -	ldio->sense_buf_phys_addr_lo = cmd->sense_phys_addr;
> +	ldio->sense_buf_phys_addr_hi =
> +		cpu_to_le32(upper_32_bits(cmd->sense_phys_addr));
> +	ldio->sense_buf_phys_addr_lo =
> +		cpu_to_le32(lower_32_bits(cmd->sense_phys_addr));
> 
> 	/*
> 	 * Compute the total number of frames this command consumes. FW uses
> @@ -3944,14 +3945,15 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
> 	dcmd->sge_count = 1;
> 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
> 	dcmd->timeout = cpu_to_le16(0);
> -	dcmd->pad_0 = cpu_to_le16(0);
> +	dcmd->pad_0 = 0;
> 	instance->last_seq_num = seq_num;
> 	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct megasas_evt_detail));
> 	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_EVENT_WAIT);
> -	dcmd->mbox.w[0] = seq_num;
> -	dcmd->mbox.w[1] = curr_aen.word;
> +	dcmd->mbox.w[0] = cpu_to_le32(seq_num);
> +	dcmd->mbox.w[1] = cpu_to_le32(curr_aen.word);
> 	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(instance->evt_detail_h);
> -	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct megasas_evt_detail));
> +	dcmd->sgl.sge32[0].length =
> +		cpu_to_le32(sizeof(struct megasas_evt_detail));
> 
> 	if (instance->aen_cmd != NULL) {
> 		megasas_return_cmd(instance, cmd);
> @@ -5358,9 +5360,9 @@ megasas_aen_polling(struct work_struct *work)
> 	}
> 	instance->ev = NULL;
> 	host = instance->host;
> -	if (le32_to_cpu(instance->evt_detail)) {
> +	if (instance->evt_detail) {
> 
> -		switch (instance->evt_detail->code) {
> +		switch (le32_to_cpu(instance->evt_detail->code)) {
> 		case MR_EVT_PD_INSERTED:
> 			if (megasas_get_pd_list(instance) == 0) {
> 			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
> 

--
Ben Collins - Principal Architect
Servergy, Inc. - www.servergy.com

