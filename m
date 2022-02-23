Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57497C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 12:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiBWMVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 07:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbiBWMVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 07:21:43 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E7E9F6FA;
        Wed, 23 Feb 2022 04:21:15 -0800 (PST)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K3ZqZ6hlJz6H72s;
        Wed, 23 Feb 2022 20:20:10 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 23 Feb 2022 13:21:13 +0100
Received: from [10.47.92.123] (10.47.92.123) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 23 Feb
 2022 12:21:13 +0000
Message-ID: <f5c2f7e0-6b14-222f-ba16-696b29517296@huawei.com>
Date:   Wed, 23 Feb 2022 12:21:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 3/8] scsi: don't memset the entire scsi_cmnd in
 scsi_init_command
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-4-hch@lst.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220222140443.589882-4-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.92.123]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2022 14:04, Christoph Hellwig wrote:

Hi Christoph,

>   static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
> @@ -1586,10 +1558,35 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>   	struct scsi_device *sdev = req->q->queuedata;
>   	struct Scsi_Host *shost = sdev->host;
> +	bool in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>   	struct scatterlist *sg;
>   
>   	scsi_init_command(sdev, cmd);
>   
> +	cmd->eh_eflags = 0;
> +	cmd->allowed = 0;
> +	cmd->prot_type = 0;
> +	cmd->prot_flags = 0;
> +	cmd->submitter = 0;
> +	cmd->cmd_len = 0;
> +	cmd->cmnd = NULL;
> +	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
> +	cmd->underflow = 0;
> +	cmd->transfersize = 0;
> +	cmd->host_scribble = NULL;
> +	cmd->result = 0;
> +	cmd->extra_len = 0;
> +	cmd->state = 0;

I am just wondering did you consider using struct_group() for safety?

I don't think the scsi_cmnd members have special ordering apart from 
co-locating related members.

Here's how it could look (on top of yours):

---8<----

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0b5c4606f641..51d2afa2d4c9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1549,18 +1549,8 @@ static blk_status_t scsi_prepare_cmd(struct 
request *req)

  	scsi_init_command(sdev, cmd);

-	cmd->eh_eflags = 0;
-	cmd->allowed = 0;
-	cmd->prot_type = 0;
-	cmd->prot_flags = 0;
-	cmd->submitter = 0;
-	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
-	cmd->underflow = 0;
-	cmd->transfersize = 0;
-	cmd->host_scribble = NULL;
-	cmd->result = 0;
-	cmd->extra_len = 0;
-	cmd->state = 0;
+	memset((char *)cmd + offsetof(struct scsi_cmnd, to_be_zeroed), 0, 
sizeof(cmd->to_be_zeroed));
+
  	if (in_flight)
  		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 76c5eaeeb3b5..8d7a7186a3ab 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -73,10 +73,46 @@ struct scsi_cmnd {

  	struct rcu_head rcu;

-	int eh_eflags;		/* Used by error handlr */
-
  	int budget_token;

+	struct_group(to_be_zeroed,
+		int eh_eflags;		/* Used by error handlr */
+		int allowed;
+		unsigned char prot_type;
+		unsigned char prot_flags;
+		enum scsi_cmnd_submitter submitter;

...

---->8---

Thanks,
John
