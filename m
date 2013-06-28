From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 1/2] scsi: ufs: Add support for host assisted background
 operations
Date: Fri, 28 Jun 2013 17:31:35 +0530
Message-ID: <51CD7B1F.3020200@codeaurora.org>
References: <1371133205-17377-1-git-send-email-sthumma@codeaurora.org> <1371133205-17377-2-git-send-email-sthumma@codeaurora.org> <CALMYJDuzvMQxNa_715odFs-jg8q5aEtpKSE5Dyve6wrqD8TwFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CALMYJDuzvMQxNa_715odFs-jg8q5aEtpKSE5Dyve6wrqD8TwFg@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/26/2013 11:06 PM, Santosh Y wrote:
>> +/**
>> >   * ufshcd_memory_alloc - allocate memory for host memory space data
>> >structures
>> >   * @hba: per adapter instance
>> >   *
>> >@@ -1803,6 +1904,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
>> >struct ufshcd_lrb *lrbp)
>> >                          */
>> >                         scsi_status = result & MASK_SCSI_STATUS;
>> >                         result = ufshcd_scsi_cmd_status(lrbp,
>> >scsi_status);
>> >+
>> >+                       if (ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
>                                  ^^^^^
> This condition will not satisfy until a runtime suspend/resume cycle
> completes. Is there any specific reason it is only being enabled in
> runtime-resume routine?
> As the fBackgroundOpsEn = 1 by default, shouldn't the sequence be 1.
> ufshcd_disable_auto_bkops() 2. ufshcd_enable_ee() during the startup.
>

According to the specification, the host should put in all measures to 
ensure that the device doesn't enter into URGENT_BKOPS need because the 
device may not operate optimally in that case. If your sequence is used 
then we expect a case where URGENT_BKOPS is needed if the runtime PM is 
disabled or prohibited soon after startup.

We wouldn't want to disable auto bkops by default without knowing that 
the runtime PM is enabled, since the device/host/software idleness is 
determined by runtime PM operation as explained in the commit text.

-- 
Regards,
Sujit
