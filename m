From: "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Subject: Re: [PATCH 9/9] scsi: ufs: Add clock ungating to a separate workqueue
Date: Mon, 26 Feb 2018 09:25:14 +0530
Message-ID: <68880931-6f39-1ffc-92f6-f3b90cec396c@codeaurora.org>
References: <cover.1519120988.git.asutoshd@codeaurora.org>
 <1c92a979dce897db920d9b9a625923d64cba2266.1519120988.git.asutoshd@codeaurora.org>
 <CANiq72==rFxaw7+ZQv41Zbr+-fJvHiQVzVucrRFpUzrQtN750w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANiq72==rFxaw7+ZQv41Zbr+-fJvHiQVzVucrRFpUzrQtN750w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Vijay Viswanath <vviswana@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2/24/2018 5:27 AM, Miguel Ojeda wrote:
> On Wed, Feb 21, 2018 at 5:56 AM, Asutosh Das <asutoshd@codeaurora.org> wrote:
>> From: Vijay Viswanath <vviswana@codeaurora.org>
>>
>> UFS driver can receive a request during memory reclaim by kswapd.
>> So when ufs driver puts the ungate work in queue, and if there are no
>> idle workers, kthreadd is invoked to create a new kworker. Since
>> kswapd task holds a mutex which kthreadd also needs, this can cause
>> a deadlock situation. So ungate work must be done in a separate
>> work queue with WQ__RECLAIM flag enabled.Such a workqueue will have
> 
> WQ_MEM_RECLAIM here. Also space after dot.
> 
>> a rescue thread which will be called when the above deadlock
>> condition is possible.
>>
>> Signed-off-by: Vijay Viswanath <vviswana@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 10 +++++++++-
>>   drivers/scsi/ufs/ufshcd.h |  1 +
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 6541e1d..bb3382a 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1503,7 +1503,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>>                  hba->clk_gating.state = REQ_CLKS_ON;
>>                  trace_ufshcd_clk_gating(dev_name(hba->dev),
>>                                          hba->clk_gating.state);
>> -               schedule_work(&hba->clk_gating.ungate_work);
>> +               queue_work(hba->clk_gating.clk_gating_workq,
>> +                          &hba->clk_gating.ungate_work);
>>                  /*
>>                   * fall through to check if we should wait for this
>>                   * work to be done or not.
>> @@ -1689,6 +1690,8 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
>>
>>   static void ufshcd_init_clk_gating(struct ufs_hba *hba)
>>   {
>> +       char wq_name[sizeof("ufs_clk_gating_00")];
>> +
>>          if (!ufshcd_is_clkgating_allowed(hba))
>>                  return;
>>
>> @@ -1696,6 +1699,10 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
>>          INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
>>          INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
>>
>> +       snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
>> +                hba->host->host_no);
>> +       hba->clk_gating.clk_gating_workq = create_singlethread_workqueue(wq_name);
> 
> Shouldn't this be alloc_ordered_workqueue() with WQ_MEM_RECLAIM then?
> (create_singlethread_workqueue() and friends are deprecated).
> 
> Cheers,
> Miguel
> 
>> +
>>          hba->clk_gating.is_enabled = true;
>>
>>          hba->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
>> @@ -1723,6 +1730,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
>>          device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
>>          cancel_work_sync(&hba->clk_gating.ungate_work);
>>          cancel_delayed_work_sync(&hba->clk_gating.gate_work);
>> +       destroy_workqueue(hba->clk_gating.clk_gating_workq);
>>   }
>>
>>   /* Must be called with host lock acquired */
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 4385741..570c33e 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -361,6 +361,7 @@ struct ufs_clk_gating {
>>          struct device_attribute enable_attr;
>>          bool is_enabled;
>>          int active_reqs;
>> +       struct workqueue_struct *clk_gating_workq;
>>   };
>>
>>   struct ufs_saved_pwr_info {
>> --
>> Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
>>

Hi Miguel
Thanks for the review.

I'll check this and put up the changes in v2.


-asd

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
