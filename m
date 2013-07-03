From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH V2 3/4] scsi: ufs: Fix device and host reset methods
Date: Wed, 03 Jul 2013 22:05:27 +0530
Message-ID: <51D452CF.80402@codeaurora.org>
References: <1372444531-24340-1-git-send-email-sthumma@codeaurora.org> <1372444531-24340-4-git-send-email-sthumma@codeaurora.org> <CALMYJDuq17Q6WBSy6BkFnbXwSRc3no4wopK0eToQ2=y2DCqM-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42687 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3GCQfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 12:35:31 -0400
In-Reply-To: <CALMYJDuq17Q6WBSy6BkFnbXwSRc3no4wopK0eToQ2=y2DCqM-g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

On 7/3/2013 11:19 AM, Santosh Y wrote:
>> +
>> >+/**
>> >+ * ufshcd_eh_device_reset_handler - device reset handler registered to
>> >+ *                                    scsi layer.
>> >+ * @cmd - SCSI command pointer
>> >+ *
>> >+ * Returns SUCCESS/FAILED
>> >+ */
>> >+static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
>> >+{
>> >+       struct ufs_hba *hba;
>> >+       int err;
>> >+       unsigned long flags;
>> >+
>> >+       hba = shost_priv(cmd->device->host);
>> >+
>> >+       spin_lock_irqsave(hba->host->host_lock, flags);
>> >+       if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
>> >+               dev_warn(hba->dev, "%s: reset in progress\n", __func__);
>> >+               err = SUCCESS;
>> >+               spin_unlock_irqrestore(hba->host->host_lock, flags);
>> >+               goto out;
> It is better to wait here until the state changes to 'operational' or
> 'error' before returning success.

Okay. Sounds good.

-- 
Regards,
Sujit
