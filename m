From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 03/39] megaraid_sas: raid 1 fast path code optimize
Date: Thu, 9 Feb 2017 14:15:27 +0100
Message-ID: <62a66ddc-152c-8056-1c6d-63da18e6591e@redhat.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <e37a18bc-34f9-d627-5440-1f787d21e4e9@redhat.com>
 <339b3daf3916e0ac6a1bb44f5040e172@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752716AbdBINdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Feb 2017 08:33:24 -0500
In-Reply-To: <339b3daf3916e0ac6a1bb44f5040e172@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

On 8.2.2017 19:51, Kashyap Desai wrote:
>>> +static inline void
>>> +megasas_complete_r1_command(struct megasas_instance *instance,
>>> +			    struct megasas_cmd_fusion *cmd) {
>>> +	u8 *sense, status, ex_status;
>>> +	u32 data_length;
>>> +	u16 peer_smid;
>>> +	struct fusion_context *fusion;
>>> +	struct megasas_cmd_fusion *r1_cmd = NULL;
>>> +	struct scsi_cmnd *scmd_local = NULL;
>>> +	struct RAID_CONTEXT_G35 *rctx_g35;
>>> +
>>> +	rctx_g35 = &cmd->io_request->RaidContext.raid_context_g35;
>>> +	fusion = instance->ctrl_context;
>>> +	peer_smid = le16_to_cpu(rctx_g35->smid.peer_smid);
>>> +
>>> +	r1_cmd = fusion->cmd_list[peer_smid - 1];
>>> +	scmd_local = cmd->scmd;
>>> +	status = rctx_g35->status;
>>> +	ex_status = rctx_g35->ex_status;
>>> +	data_length = cmd->io_request->DataLength;
>>> +	sense = cmd->sense;
>>> +
>>> +	cmd->cmd_completed = true;
>> Please help me understand how this works
>> - there are two peer commands sent to the controller
>> - both are completed and the later calls scsi_done and returns both
> r1_cmd
>> + cmd
>> - if both commands can be completed at the same time, is it possible
> that
>> the
>>   above line is executed at the same moment for both completions ?
>> How is the code  protected against a double completion when both
>> completed commands see the peer cmd_completed as set ?
>
> Tomas,  cmd and r1_cmd (part of  same Raid 1 FP) will be always completed
> on same reply queue by firmware. That is one of the key requirement here
> for raid 1 fast path.
> What you ask is possible if FW completes cmd and r1_cmd on different reply
> queue. If you notice when we clone r1_cmd, we also clone MSI-x index from
> parent command.
> So eventually, FW is aware of binding of both cmd and r1_cmd w.r.t reply
> queue index.

ok, thanks

>
> ` Kashyap
>
>>> +
