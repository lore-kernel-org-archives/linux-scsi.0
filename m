Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C70C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 09:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0FC6044F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 09:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhHLJGL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:06:11 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3640 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbhHLJGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 05:06:10 -0400
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlgkX4JYqz6F86L;
        Thu, 12 Aug 2021 17:05:08 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 12 Aug 2021 11:05:44 +0200
Received: from [10.47.80.186] (10.47.80.186) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 12 Aug
 2021 10:05:42 +0100
Subject: Re: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
        "Hannes Reinecke" <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-15-bvanassche@acm.org>
 <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
 <95223f29-1ced-a7a7-7fc7-90a3578f0447@acm.org>
 <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
 <a8d96139-dcff-d37e-06fa-c2e46c75a309@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <798dbe0f-8ad0-6aa8-39e6-059dea4267b3@huawei.com>
Date:   Thu, 12 Aug 2021 10:05:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <a8d96139-dcff-d37e-06fa-c2e46c75a309@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.186]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/08/2021 07:03, Hannes Reinecke wrote:
> Go for it.
> I'm not particularly keen on the 'scsi_cmd_to_rq(cmd)->tag' construct, 
> as this implies that 'scsi_cmd_to_rq()' has to be a define, not a function.

What is the problem exactly?

> Having a wrapper for scsi_cmd_to_tag() resolves that.

So which tag does scsi_cmd_to_tag() return? The request tag? 
scsi_cmnd.tag? Or, if there is an ata_queued_cmd associated with the 
scsi_cmnd, ata_queued_cmd.tag? Maybe it's blindingly obvious, but I 
don't see value in introducing possibility of misuse.

Having said that, scsi_cmnd.tag could be removed:

---->8----

[PATCH 1/3] scsi: wd719: Stop using scsi_cmnd.tag

Use scsi_cmd_to_rq(cmd)->tag instead.

Signed-off-by: John Garry <john.garry@huawei.com>
---
  drivers/scsi/wd719x.c | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index edc8a139a60d..4f4ebb9c5b09 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -467,13 +467,13 @@ static int wd719x_abort(struct scsi_cmnd *cmd)
  	struct wd719x_scb *scb = scsi_cmd_priv(cmd);
  	struct wd719x *wd = shost_priv(cmd->device->host);

-	dev_info(&wd->pdev->dev, "abort command, tag: %x\n", cmd->tag);
+	dev_info(&wd->pdev->dev, "abort command, tag: %x\n", 
scsi_cmd_to_rq(cmd)->tag);

-	action = /*cmd->tag ? WD719X_CMD_ABORT_TAG : */WD719X_CMD_ABORT;
+	action = /*scsi_cmd_to_rq(cmd)->tag ? WD719X_CMD_ABORT_TAG : 
*/WD719X_CMD_ABORT;

  	spin_lock_irqsave(wd->sh->host_lock, flags);
  	result = wd719x_direct_cmd(wd, action, cmd->device->id,
-				   cmd->device->lun, cmd->tag, scb->phys, 0);
+				   cmd->device->lun, scsi_cmd_to_rq(cmd)->tag, scb->phys, 0);
  	wd719x_finish_cmd(scb, DID_ABORT);
  	spin_unlock_irqrestore(wd->sh->host_lock, flags);
  	if (result)
-- 
[PATCH 2/3] scsi: fnic: Stop setting scsi_cmnd.tag

It is never read. Setting it and the request tag seems dodgy
anyway.

Signed-off-by: John Garry <john.garry@huawei.com>
---
  drivers/scsi/fnic/fnic_scsi.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 0f9cedf78872..f8afbfb468dc 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2213,7 +2213,7 @@ fnic_scsi_host_start_tag(struct fnic *fnic, struct 
scsi_cmnd *sc)
  	if (IS_ERR(dummy))
  		return SCSI_NO_TAG;

-	sc->tag = rq->tag = dummy->tag;
+	rq->tag = dummy->tag;
  	sc->host_scribble = (unsigned char *)dummy;

  	return dummy->tag;
-- 
[PATCH 3/3] scsi: Remove scsi_cmnd.tag

There are no users.

Signed-off-by: John Garry <john.garry@huawei.com>
---
  drivers/scsi/scsi_lib.c  | 1 -
  include/scsi/scsi_cmnd.h | 1 -
  2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ba1aa7530a9..572673873ddf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1540,7 +1540,6 @@ static blk_status_t scsi_prepare_cmd(struct 
request *req)

  	scsi_init_command(sdev, cmd);

-	cmd->tag = req->tag;
  	cmd->prot_op = SCSI_PROT_NORMAL;
  	if (blk_rq_bytes(req))
  		cmd->sc_data_direction = rq_dma_dir(req);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6c5a1c1c6b1e..eaf04c9a1dfc 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -139,7 +139,6 @@ struct scsi_cmnd {
  	int flags;		/* Command flags */
  	unsigned long state;	/* Command completion state */

-	unsigned char tag;	/* SCSI-II queued command tag */
  	unsigned int extra_len;	/* length of alignment and padding */
  };

-- 

----8<-----

Bart, feel free to make a similar change - I don't want you to think I'm 
hijacking your work.

Thanks!
