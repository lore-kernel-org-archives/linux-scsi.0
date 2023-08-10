Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCFBC001E0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 12:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjHJMGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 08:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjHJMGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 08:06:53 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8131310F3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 05:06:51 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RM5Ds06w1zqT1N;
        Thu, 10 Aug 2023 20:03:57 +0800 (CST)
Received: from [10.67.110.142] (10.67.110.142) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 20:06:47 +0800
Message-ID: <553db7b2-78b0-424a-83d2-f33f2fcc32d4@huawei.com>
Date:   Thu, 10 Aug 2023 20:06:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] scsi: snic: Fix possible memory leak if device_add()
 fails
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
CC:     <linux-scsi@vger.kernel.org>
References: <955e65d7-bdb5-4c81-90fb-abc414e8176a@moroto.mountain>
From:   wangzhu <wangzhu9@huawei.com>
In-Reply-To: <955e65d7-bdb5-4c81-90fb-abc414e8176a@moroto.mountain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.142]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Dan Carpenter:


Sorry for the patch 41320b18a0e0 I submitted, I thought 
put_dev(&tgt->dev) is not the same as kfree(tgt).

Then should I submit a revert patch again, or you can fix it yourself? 
please let me know what I can do.

Sorry for the inconvenience again.


Best regards,

Zhu Wang.


On 2023/8/10 18:26, Dan Carpenter wrote:
> Hello Zhu Wang,
>
> The patch 41320b18a0e0: "scsi: snic: Fix possible memory leak if
> device_add() fails" from Aug 1, 2023 (linux-next), leads to the
> following Smatch static checker warning:
>
> 	drivers/scsi/snic/snic_disc.c:311 snic_tgt_create()
> 	warn: freeing device managed memory (UAF): 'tgt'
>
> drivers/scsi/snic/snic_disc.c
>      234 static struct snic_tgt *
>      235 snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
>      236 {
>      237         struct snic_tgt *tgt = NULL;
>      238         unsigned long flags;
>      239         int ret;
>      240
>      241         tgt = snic_tgt_lookup(snic, tgtid);
>      242         if (tgt) {
>      243                 /* update the information if required */
>      244                 return tgt;
>      245         }
>      246
>      247         tgt = kzalloc(sizeof(*tgt), GFP_KERNEL);
>      248         if (!tgt) {
>      249                 SNIC_HOST_ERR(snic->shost, "Failure to allocate snic_tgt.\n");
>      250                 ret = -ENOMEM;
>      251
>      252                 return tgt;
>      253         }
>      254
>      255         INIT_LIST_HEAD(&tgt->list);
>      256         tgt->id = le32_to_cpu(tgtid->tgt_id);
>      257         tgt->channel = 0;
>      258
>      259         SNIC_BUG_ON(le16_to_cpu(tgtid->tgt_type) > SNIC_TGT_SAN);
>      260         tgt->tdata.typ = le16_to_cpu(tgtid->tgt_type);
>      261
>      262         /*
>      263          * Plugging into SML Device Tree
>      264          */
>      265         tgt->tdata.disc_id = 0;
>      266         tgt->state = SNIC_TGT_STAT_INIT;
>      267         device_initialize(&tgt->dev);
>      268         tgt->dev.parent = get_device(&snic->shost->shost_gendev);
>      269         tgt->dev.release = snic_tgt_dev_release;
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This is a similar bug to the one I reported earlier.
>
>      270         INIT_WORK(&tgt->scan_work, snic_scsi_scan_tgt);
>      271         INIT_WORK(&tgt->del_work, snic_tgt_del);
>      272         switch (tgt->tdata.typ) {
>      273         case SNIC_TGT_DAS:
>      274                 dev_set_name(&tgt->dev, "snic_das_tgt:%d:%d-%d",
>      275                              snic->shost->host_no, tgt->channel, tgt->id);
>      276                 break;
>      277
>      278         case SNIC_TGT_SAN:
>      279                 dev_set_name(&tgt->dev, "snic_san_tgt:%d:%d-%d",
>      280                              snic->shost->host_no, tgt->channel, tgt->id);
>      281                 break;
>      282
>      283         default:
>      284                 SNIC_HOST_INFO(snic->shost, "Target type Unknown Detected.\n");
>      285                 dev_set_name(&tgt->dev, "snic_das_tgt:%d:%d-%d",
>      286                              snic->shost->host_no, tgt->channel, tgt->id);
>      287                 break;
>      288         }
>      289
>      290         spin_lock_irqsave(snic->shost->host_lock, flags);
>      291         list_add_tail(&tgt->list, &snic->disc.tgt_list);
>      292         tgt->scsi_tgt_id = snic->disc.nxt_tgt_id++;
>      293         tgt->state = SNIC_TGT_STAT_ONLINE;
>      294         spin_unlock_irqrestore(snic->shost->host_lock, flags);
>      295
>      296         SNIC_HOST_INFO(snic->shost,
>      297                        "Tgt %d, type = %s detected. Adding..\n",
>      298                        tgt->id, snic_tgt_type_to_str(tgt->tdata.typ));
>      299
>      300         ret = device_add(&tgt->dev);
>      301         if (ret) {
>      302                 SNIC_HOST_ERR(snic->shost,
>      303                               "Snic Tgt: device_add, with err = %d\n",
>      304                               ret);
>      305
>      306                 put_device(&tgt->dev);
>                          ^^^^^^^^^^^^^^^^^^^^
>
> The put_device() will free tgt.
>
>      307                 put_device(&snic->shost->shost_gendev);
>      308                 spin_lock_irqsave(snic->shost->host_lock, flags);
>      309                 list_del(&tgt->list);
>
> Use after free
>
>      310                 spin_unlock_irqrestore(snic->shost->host_lock, flags);
> --> 311                 kfree(tgt);
>
> Double free.
>
>      312                 tgt = NULL;
>      313
>      314                 return tgt;
>      315         }
>      316
>      317         SNIC_HOST_INFO(snic->shost, "Scanning %s.\n", dev_name(&tgt->dev));
>      318
>      319         scsi_queue_work(snic->shost, &tgt->scan_work);
>      320
>      321         return tgt;
>      322 } /* end of snic_tgt_create */
>
> regards,
> dan carpenter
