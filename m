Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65677C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 06:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D72E617E4
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 06:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348206AbhI3GEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 02:04:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:4003 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348184AbhI3GEb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 02:04:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="204593418"
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="204593418"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 23:02:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="708873824"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga005.fm.intel.com with ESMTP; 29 Sep 2021 23:02:39 -0700
Subject: Re: [PATCH] scsi: ufs: Fix a possible dead lock in clock scaling
To:     Can Guo <cang@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1631843521-2863-1-git-send-email-cang@codeaurora.org>
 <cc9cb9e7-68bd-3bfa-9310-5fbf99a86544@acm.org>
 <fbc4d03a07f03fe4fbe697813111471f@codeaurora.org>
 <644dcd92-25ae-e951-d9f3-607306a02370@acm.org>
 <27e9265371e96d0bcc06139ce5f0e026@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <bd99231e-1831-5384-1c01-30b158d0affe@intel.com>
Date:   Thu, 30 Sep 2021 09:02:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <27e9265371e96d0bcc06139ce5f0e026@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/09/2021 06:57, Can Guo wrote:
> On 2021-09-30 02:15, Bart Van Assche wrote:
>> On 9/28/21 8:31 PM, Can Guo wrote:
>>> On 2021-09-18 01:27, Bart Van Assche wrote:
>>>> On 9/16/21 6:51 PM, Can Guo wrote:
>>>>> Assume a scenario where task A and B call ufshcd_devfreq_scale()
>>>>> simultaneously. After task B calls downgrade_write() [1], but before it
>>>>> calls down_read() [3], if task A calls down_write() [2], when task B calls
>>>>> down_read() [3], it will lead to dead lock.
>>>>
>>>> Something is wrong with the above description. The downgrade_write() call is
>>>> not followed by down_read() but by up_read(). Additionally, I don't see how
>>>> concurrent calls of ufshcd_devfreq_scale() could lead to a deadlock.
>>>
>>> As mentioned in the commit msg, the down_read() [3] is from ufshcd_wb_ctrl().
>>>
>>> Task A -
>>> down_write [2]
>>> ufshcd_clock_scaling_prepare
>>> ufshcd_devfreq_scale
>>> ufshcd_clkscale_enable_store
>>>
>>> Task B -
>>> down_read [3]
>>> ufshcd_exec_dev_cmd
>>> ufshcd_query_flag
>>> ufshcd_wb_ctrl
>>> downgrade_write [1]
>>> ufshcd_devfreq_scale
>>> ufshcd_devfreq_target
>>> devfreq_set_target
>>> update_devfreq
>>> devfreq_performance_handler
>>> governor_store
>>>
>>>
>>>> If one thread calls downgrade_write() and another thread calls down_write()
>>>> immediately, that down_write() call will block until the other thread has called up_read()
>>>> without triggering a deadlock.
>>>
>>> Since the down_write() caller is blocked, the down_read() caller, which comes after
>>> down_write(), is blocked too, no? downgrade_write() keeps lock owner as it is, but
>>> it does not change the fact that readers and writers can be blocked by each other.
>>
>> Please use the upstream function names when posting upstream patches.
>> I think that
>> ufshcd_wb_ctrl() has been renamed into ufshcd_wb_toggle().
>>
>> So the deadlock is caused by nested locking - one task holding a
>> reader lock, another
>> task calling down_write() and next the first task grabbing the reader
>> lock recursively?
>> I prefer one of the following two solutions above the patch that has
>> been posted since
>> I expect that both alternatives will result in easier to maintain UFS code:
>> - Fix the down_read() implementation. Making down_read() wait in case
>> of nested locking
>>   seems wrong to me.
>> - Modify the UFS driver such that it does not lock
>> hba->clk_scaling_lock recursively.
> 
> My current change is the 2nd solution - drop the hba->clk_scaling_lock
> before calls ufshcd_wb_toggle() to avoid recursive lock.

I have been looking at elevating hba->clk_scaling_lock to be a general purpose
lock for ufshcd.  That includes allowing down_read if down_write is held already.
The plan being to hold down_write during the error handler instead of releasing it,
which would plug some gaps in synchronization.

So the locking code would look like this:

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a42a289eaef93..63b6a26e3a327 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -898,7 +898,8 @@ struct ufs_hba {
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
 
-	struct rw_semaphore clk_scaling_lock;
+	struct rw_semaphore host_rw_sem;
+	struct task_struct *excl_task;
 	unsigned char desc_size[QUERY_DESC_IDN_MAX];
 	atomic_t scsi_block_reqs_cnt;
 
@@ -1418,4 +1419,42 @@ static inline int ufshcd_rpmb_rpm_put(struct ufs_hba *hba)
 	return pm_runtime_put(&hba->sdev_rpmb->sdev_gendev);
 }
 
+static inline void ufshcd_down_read(struct ufs_hba *hba)
+{
+	if (hba->excl_task != current)
+		down_read(&hba->host_rw_sem);
+}
+
+static inline void ufshcd_up_read(struct ufs_hba *hba)
+{
+	if (hba->excl_task != current)
+		up_read(&hba->host_rw_sem);
+}
+
+static inline int ufshcd_down_read_trylock(struct ufs_hba *hba)
+{
+	if (hba->excl_task == current)
+		return 1;
+
+	return down_read_trylock(&hba->host_rw_sem);
+}
+
+static inline void ufshcd_down_write(struct ufs_hba *hba)
+{
+	down_write(&hba->host_rw_sem);
+	hba->excl_task = current;
+}
+
+static inline void ufshcd_up_write(struct ufs_hba *hba)
+{
+	hba->excl_task = NULL;
+	up_write(&hba->host_rw_sem);
+}
+
+static inline void ufshcd_downgrade_write(struct ufs_hba *hba)
+{
+	hba->excl_task = NULL;
+	downgrade_write(&hba->host_rw_sem);
+}
+
 #endif /* End of Header */




