Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C2FC636CA
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 17:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 834D1611AE
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 17:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhGPRya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 13:54:30 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:43875 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhGPRy3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 13:54:29 -0400
Received: by mail-pl1-f180.google.com with SMTP id b12so5666334plh.10
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2021 10:51:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AInIr+ahEfttKXvo1t72Mys8wkl/lDx8asn0xOI+BIM=;
        b=Qhh02qz8uzU+U85RCFQ7+kRgIJ91VHP0CrqiZa4AYjcoNoPh5YcnAlqaWk7Fdcf4Ck
         iJF6VCY73Bcz2YuyxfQU6UER30SAWGNxUTNO6XnZqLCEq0nvDS1svlkOwtgRWd0gnn5p
         UoszpWr6wUtkjQWxaUsWCcDxtMRT0+4+UeY5wYEh82vRcGmBqt6F38Cgx85XPni0fNwQ
         4ssND2PYNYoFlGGu4nBtz1WoZkLgLdKCbQOxZb52gF9Apu7+OT2owUYHvWByS1jy7kNm
         YZutADGWpMy8Y71+tDtnAkCE+1yfwqpsWd0ebsprB6PK0cGTGrmonc5Axn4aLy3E23qc
         hajQ==
X-Gm-Message-State: AOAM5300yw+esLyjV+SFdLmPV6HfamISCm0eQWKritvgURuJBmZ2coPX
        jQZucHJrI+BLxrYXGk7tW9E=
X-Google-Smtp-Source: ABdhPJxjfKxFJYoUDZQv+xOBdXQMKDfCMV7YCYaZeka44AmhjZGhuG3cEzXN6TriAfraQFldozsPsA==
X-Received: by 2002:a17:902:728f:b029:12b:374:c149 with SMTP id d15-20020a170902728fb029012b0374c149mr8658365pll.80.1626457893254;
        Fri, 16 Jul 2021 10:51:33 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:ad12:9dbc:6e29:6c02? ([2620:0:1000:2004:ad12:9dbc:6e29:6c02])
        by smtp.gmail.com with ESMTPSA id v14sm12052858pgo.89.2021.07.16.10.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 10:51:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
 <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
 <fe3076c3-f835-b7e4-c5be-4ba55d5e0e41@acm.org>
 <1b35777f-bea2-9443-0bac-c42b37acf8b3@acm.org>
 <DM6PR04MB65759F6FCD2293AC9FED6C9CFC119@DM6PR04MB6575.namprd04.prod.outlook.com>
 <d43d94f4-8f9d-7391-a166-f839c03fb7b3@codeaurora.org>
 <b041051d-fc03-830a-f4b8-9ba2fe733954@acm.org>
Message-ID: <5186a7c5-6cd8-90a4-0f3b-cb741475c588@acm.org>
Date:   Fri, 16 Jul 2021 10:51:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b041051d-fc03-830a-f4b8-9ba2fe733954@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/21 9:54 AM, Bart Van Assche wrote:
> On 7/16/21 9:26 AM, Asutosh Das (asd) wrote:
>> I agree. We saw substantial improvement with RR and RW too with the 
>> 'Optimize host lock change'.
> 
> Recent UFS driver patches introduced three changes:
> (1) Use the UTRLCNR register instead of the doorbell register in the 
> completion path.
> (2) Use atomic instructions instead of the host lock for updating the 
> outstanding_reqs structure member.
> (3) Reduce lock contention on the SCSI host lock.
> 
> My patch preserves (3) so it should preserve the performance 
> improvements that are the result of eliminating lock contention for 
> outstanding_reqs updates.

For clarity, this is the patch for which I reported a 1% performance improvement:

Subject: [PATCH] ufs: Fix a race in the completion path

The following unlikely races can be triggered by the completion path
(ufshcd_trc_handler()):
- After the UTRLCNR register has been read from interrupt context and
   before it is cleared, the UFS error handler reads the UTRLCNR register.
   Hold the SCSI host lock until the UTRLCNR register has been cleared to
   prevent that this register is accessed from another CPU before it has
   been cleared.
- After the doorbell register has been read and before outstanding_reqs
   is cleared, the error handler reads the doorbell register. This can also
   result in double completions. Fix this by clearing outstanding_reqs
   before calling ufshcd_transfer_req_compl().

Due to this change ufshcd_trc_handler() no longer updates outstanding_reqs
atomically. Hence protect all other outstanding_reqs changes with the SCSI
host lock.

This patch is a performance improvement because it reduces the number of
atomic operations in the hot path (test_and_clear_bit()).

See also commit a45f937110fa ("scsi: ufs: Optimize host lock on transfer
requests send/compl paths").

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/ufs/ufshcd.c | 52 ++++++++++++++++++---------------------
  drivers/scsi/ufs/ufshcd.h |  2 ++
  2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0cb84a744dad..7b8d3928fed8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2088,6 +2088,7 @@ static inline
  void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
  {
  	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
+	unsigned long flags;

  	lrbp->issue_time_stamp = ktime_get();
  	lrbp->compl_time_stamp = ktime_set(0, 0);
@@ -2096,19 +2097,12 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
  	ufshcd_clk_scaling_start_busy(hba);
  	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
  		ufshcd_start_monitor(hba, lrbp);
-	if (ufshcd_has_utrlcnr(hba)) {
-		set_bit(task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	} else {
-		unsigned long flags;

-		spin_lock_irqsave(hba->host->host_lock, flags);
-		set_bit(task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	__set_bit(task_tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
  	/* Make sure that doorbell is committed immediately */
  	wmb();
  }
@@ -2890,7 +2884,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
  		 * we also need to clear the outstanding_request
  		 * field in hba
  		 */
-		clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
+		spin_lock_irqsave(&hba->outstanding_lock, flags);
+		__clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
+		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
  	}

  	return err;
@@ -5197,8 +5193,6 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
  	bool update_scaling = false;

  	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
-		if (!test_and_clear_bit(index, &hba->outstanding_reqs))
-			continue;
  		lrbp = &hba->lrb[index];
  		lrbp->compl_time_stamp = ktime_get();
  		cmd = lrbp->cmd;
@@ -5241,6 +5235,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
  static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
  {
  	unsigned long completed_reqs = 0;
+	unsigned long flags;

  	/* Resetting interrupt aggregation counters first and reading the
  	 * DOOR_BELL afterward allows us to handle all the completed requests.
@@ -5253,24 +5248,24 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
  	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
  		ufshcd_reset_intr_aggr(hba);

+	spin_lock_irqsave(&hba->outstanding_lock, flags);
  	if (use_utrlcnr) {
-		u32 utrlcnr;
-
-		utrlcnr = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_LIST_COMPL);
-		if (utrlcnr) {
-			ufshcd_writel(hba, utrlcnr,
+		completed_reqs = ufshcd_readl(hba,
+					      REG_UTP_TRANSFER_REQ_LIST_COMPL);
+		if (completed_reqs)
+			ufshcd_writel(hba, completed_reqs,
  				      REG_UTP_TRANSFER_REQ_LIST_COMPL);
-			completed_reqs = utrlcnr;
-		}
  	} else {
-		unsigned long flags;
  		u32 tr_doorbell;

-		spin_lock_irqsave(hba->host->host_lock, flags);
  		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
  	}
+	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
+		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
+		  hba->outstanding_reqs);
+	hba->outstanding_reqs &= ~completed_reqs;
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);

  	if (completed_reqs) {
  		ufshcd_transfer_req_compl(hba, completed_reqs);
@@ -9357,10 +9352,11 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
  	hba = shost_priv(host);
  	hba->host = host;
  	hba->dev = dev;
-	*hba_handle = hba;
  	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
-
  	INIT_LIST_HEAD(&hba->clk_list_head);
+	spin_lock_init(&hba->outstanding_lock);
+
+	*hba_handle = hba;

  out_error:
  	return err;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f8766e8f3cac..e47a796bc114 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -695,6 +695,7 @@ struct ufs_hba_monitor {
   * @lrb: local reference block
   * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
   * @outstanding_tasks: Bits representing outstanding task requests
+ * @outstanding_lock: Protects @outstanding_reqs.
   * @outstanding_reqs: Bits representing outstanding transfer requests
   * @capabilities: UFS Controller Capabilities
   * @nutrs: Transfer Request Queue depth supported by controller
@@ -781,6 +782,7 @@ struct ufs_hba {
  	struct ufshcd_lrb *lrb;

  	unsigned long outstanding_tasks;
+	spinlock_t outstanding_lock;
  	unsigned long outstanding_reqs;

  	u32 capabilities;
