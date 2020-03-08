Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6121C10F27
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 21:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE4820684
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 21:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCHVpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Mar 2020 17:45:07 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34828 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgCHVpH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2020 17:45:07 -0400
Received: by mail-pj1-f66.google.com with SMTP id s8so3525606pjq.0;
        Sun, 08 Mar 2020 14:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4F53RjDlw97BH0lkA5noyK4t9LWwAN0mbB/TrVCqLJk=;
        b=uBU+wwNtczSi+j5MEBy5stW7msjzRicg3fh9yZ9i+QcOOMyzP5sjiV8UBZtAyN8v77
         KcJ3MG/jeT++QR1ZfSfnIIWQdCrIkn3rQpVYlLs7fuYZD8oj3ZWXwXLwiIWBtLzlDtYy
         aaybQgj34Cq2If2ScPJIztOYSgfdRyj813ZBgMZZ3YUzQzkO1xtxMUWrJONzeWoBkQ2K
         jw1+zMHCxzd+8lXW1G3H0MPMpPO3dYTNlmMWATtuo8IWdxLO9xkJSBtPr2RRXuMGfhdx
         EJ8mqsp3URgy9HiNy/asQhYwQ5wTwF8kTddjyL8MBj2mG0NnaH7qYOZBFNlzCD2vGAcT
         YMhg==
X-Gm-Message-State: ANhLgQ1MNHD69tZG81dzZkEBLfkyqTeKI+nfByKtMuon2jRuSDsTZ/7T
        Kgcn5Oe617yaOZgWATrotKwQAkpj
X-Google-Smtp-Source: ADFU+vvaBhjhuQGCIRG4IwUxxrUsYWhp8yen5Bz9m4b9tRd8snmsAWpnuA7fYQ7t9kJ87zTNYZtL8g==
X-Received: by 2002:a17:902:44d:: with SMTP id 71mr12766896ple.95.1583703905160;
        Sun, 08 Mar 2020 14:45:05 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:1b6:6e46:9c16:a30? ([2601:647:4000:d7:1b6:6e46:9c16:a30])
        by smtp.gmail.com with ESMTPSA id u12sm42286480pgr.3.2020.03.08.14.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 14:45:04 -0700 (PDT)
Subject: Re: [RFC PATCH v2 1/1] scsi: ufs: fix lrbp pointer incorrect
 initialization issue
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200308145648.28675-1-beanhuo@micron.com>
 <20200308145648.28675-2-beanhuo@micron.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <e44de0a9-1864-d074-19cd-902a534f5c61@acm.org>
Date:   Sun, 8 Mar 2020 14:45:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200308145648.28675-2-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-08 07:56, Bean Huo wrote:
> The parameter cmd of ufshcd_init_cmd_priv() wasn't given a correct tag
> value while the SCSI layer calls back ufshcd_init_cmd_priv(), this results
> in all pointers of lrbp in UFS driver point to first the lrbp.
> 
> As this is just observed, the patch is for reference so others
> who want to use the latest UFS driver can avoid this issue. Any recommend
> is welcomed.

How about also removing ufshcd_init_cmd_priv(), like in the untested patch
below?

Thanks,

Bart.

Subject: [PATCH] ufs: Fix LRB initialization

There are two issues with the ufshcd_init_lrb() call in
ufshcd_init_cmd_priv():
- cmd->tag is set from inside scsi_mq_prep_fn() and hence is not yet set
  when ufshcd_init_cmd_priv() is set.
- Inside ufshcd_init_cmd_priv() the tag can only be derived from the SCSI
  command pointer if no scheduler has been associated with the UFS block
  device. If no scheduler is associated with a block device, the
  relationship between hctx->tags->static_rqs[] and rq->tag is static.
  If a scheduler has been configured, a single tag can be associated
  with a different struct request if a request is reallocated.

Fixes: 34656dda81ac ("ufs: Let the SCSI core allocate per-command UFS data")
---
 drivers/scsi/ufs/ufshcd.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e987fa3a77c7..1589ba70672f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2473,6 +2473,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)

 	WARN_ON_ONCE(!ufshcd_is_scsi(cmd->request));

+	ufshcd_init_lrb(hba, lrbp, tag);
+
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;

@@ -2707,6 +2709,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,

 	init_completion(&wait);
 	lrbp = ufshcd_req_to_lrb(req);
+	ufshcd_init_lrb(hba, lrbp, tag);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
 		goto out_put_tag;
@@ -3504,14 +3507,6 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 	}
 }

-static int ufshcd_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	struct ufs_hba *hba = shost_priv(shost);
-
-	ufshcd_init_lrb(hba, scsi_cmd_priv(cmd), cmd->tag);
-	return 0;
-}
-
 /**
  * ufshcd_dme_link_startup - Notify Unipro to perform link startup
  * @hba: per adapter instance
@@ -5900,6 +5895,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,

 	init_completion(&wait);
 	lrbp = ufshcd_req_to_lrb(req);
+	ufshcd_init_lrb(hba, lrbp, tag);
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
@@ -7180,7 +7176,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
-	.init_cmd_priv		= ufshcd_init_cmd_priv,
 	.queuecommand		= ufshcd_queuecommand,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_configure	= ufshcd_slave_configure,
