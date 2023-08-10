Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E19C001DB
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 10:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbjHJK0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 06:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbjHJK0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 06:26:45 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2477CDF
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 03:26:44 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3fe5eb84dceso6428625e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 03:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691663202; x=1692268002;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wIEfNpkeqnM4bWi6NE18thUT3Yq5+t4LrDHzLygEdxY=;
        b=r0tooVfstwYcO6wNMH7tPKQBGvHuFuYNaA8lPsoNYd3HLbxHZYfvkxdE3BK8tp14dU
         o/3W+k8kLAsgWFmQYX9RiORJL4ktKZoBhxjPp4NM87+ljFek6L54hPpOOQF66gHwMVkB
         DyigTCB4sBJ7D95kJ6vYNDlJIRHARmBf0Wd2XUJFDadVmj+iqhPCpbWrovB+xDOJNGOY
         Rtdli/dQVAl1kHtEIG8Z+pezqvN90h2y1gL7lf20ZSkrdWgz1kuyjuP4uTp54BsFxD5w
         aBbkhgMV9TR5WaKD78KTLRkh5A4dN8RXJ9bOQ3hvB/+Wx3iTNGIUjsyhonUpV43F4b0j
         U26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691663202; x=1692268002;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wIEfNpkeqnM4bWi6NE18thUT3Yq5+t4LrDHzLygEdxY=;
        b=eOzzIDIkZWFpjYsqVY4LgPyYunB2oUtm2SIi/FuKEcBADkevJQ3+xqblt7WxQ1FNC8
         xZFugZRVdslmHLicStoxo9BdA6gze2MN+uqW2l1yxBkv9hEgIT38w8BzB15opS6+rII7
         5KaeJ9xslOkQPZPQ817w9WfYtzgdt+QnancsBnwGYFvBPXkmPl6TrJofqQVlUU8lChH4
         QTh/kRSH/iOLO7y4RXVkDJ3dATLO3wp+nOGUp75GsgXkUfI851ZfpmaheopoCuQseLph
         udqQeRdo2Ypy2BsNWKHPLrECjL925O+b94hySDKfD4Z4gNWb4soHAjZ5owiR4YZQPGhw
         27Wg==
X-Gm-Message-State: AOJu0YwgN4ngzYxizGJ2wha7RLaciHu/PvO5hLj80RBp9JFNNRzBeQl5
        yPMM/3NAJEIE9F1X2gFWYIeGXhQmf3bsNcr72rI=
X-Google-Smtp-Source: AGHT+IGeIcHsz2AatVRlZlmVroWUNr8zUCtrXQ69jEl4iQjUOOVyHkECXvwbU4+qQLxUlMpU6X2g1Q==
X-Received: by 2002:a7b:c398:0:b0:3fe:173e:4a54 with SMTP id s24-20020a7bc398000000b003fe173e4a54mr1558376wmj.17.1691663202413;
        Thu, 10 Aug 2023 03:26:42 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l24-20020a7bc458000000b003fbb25da65bsm1669252wmi.30.2023.08.10.03.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 03:26:42 -0700 (PDT)
Date:   Thu, 10 Aug 2023 13:26:38 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     wangzhu9@huawei.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: snic: Fix possible memory leak if device_add()
 fails
Message-ID: <955e65d7-bdb5-4c81-90fb-abc414e8176a@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Zhu Wang,

The patch 41320b18a0e0: "scsi: snic: Fix possible memory leak if
device_add() fails" from Aug 1, 2023 (linux-next), leads to the
following Smatch static checker warning:

	drivers/scsi/snic/snic_disc.c:311 snic_tgt_create()
	warn: freeing device managed memory (UAF): 'tgt'

drivers/scsi/snic/snic_disc.c
    234 static struct snic_tgt *
    235 snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
    236 {
    237         struct snic_tgt *tgt = NULL;
    238         unsigned long flags;
    239         int ret;
    240 
    241         tgt = snic_tgt_lookup(snic, tgtid);
    242         if (tgt) {
    243                 /* update the information if required */
    244                 return tgt;
    245         }
    246 
    247         tgt = kzalloc(sizeof(*tgt), GFP_KERNEL);
    248         if (!tgt) {
    249                 SNIC_HOST_ERR(snic->shost, "Failure to allocate snic_tgt.\n");
    250                 ret = -ENOMEM;
    251 
    252                 return tgt;
    253         }
    254 
    255         INIT_LIST_HEAD(&tgt->list);
    256         tgt->id = le32_to_cpu(tgtid->tgt_id);
    257         tgt->channel = 0;
    258 
    259         SNIC_BUG_ON(le16_to_cpu(tgtid->tgt_type) > SNIC_TGT_SAN);
    260         tgt->tdata.typ = le16_to_cpu(tgtid->tgt_type);
    261 
    262         /*
    263          * Plugging into SML Device Tree
    264          */
    265         tgt->tdata.disc_id = 0;
    266         tgt->state = SNIC_TGT_STAT_INIT;
    267         device_initialize(&tgt->dev);
    268         tgt->dev.parent = get_device(&snic->shost->shost_gendev);
    269         tgt->dev.release = snic_tgt_dev_release;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is a similar bug to the one I reported earlier.

    270         INIT_WORK(&tgt->scan_work, snic_scsi_scan_tgt);
    271         INIT_WORK(&tgt->del_work, snic_tgt_del);
    272         switch (tgt->tdata.typ) {
    273         case SNIC_TGT_DAS:
    274                 dev_set_name(&tgt->dev, "snic_das_tgt:%d:%d-%d",
    275                              snic->shost->host_no, tgt->channel, tgt->id);
    276                 break;
    277 
    278         case SNIC_TGT_SAN:
    279                 dev_set_name(&tgt->dev, "snic_san_tgt:%d:%d-%d",
    280                              snic->shost->host_no, tgt->channel, tgt->id);
    281                 break;
    282 
    283         default:
    284                 SNIC_HOST_INFO(snic->shost, "Target type Unknown Detected.\n");
    285                 dev_set_name(&tgt->dev, "snic_das_tgt:%d:%d-%d",
    286                              snic->shost->host_no, tgt->channel, tgt->id);
    287                 break;
    288         }
    289 
    290         spin_lock_irqsave(snic->shost->host_lock, flags);
    291         list_add_tail(&tgt->list, &snic->disc.tgt_list);
    292         tgt->scsi_tgt_id = snic->disc.nxt_tgt_id++;
    293         tgt->state = SNIC_TGT_STAT_ONLINE;
    294         spin_unlock_irqrestore(snic->shost->host_lock, flags);
    295 
    296         SNIC_HOST_INFO(snic->shost,
    297                        "Tgt %d, type = %s detected. Adding..\n",
    298                        tgt->id, snic_tgt_type_to_str(tgt->tdata.typ));
    299 
    300         ret = device_add(&tgt->dev);
    301         if (ret) {
    302                 SNIC_HOST_ERR(snic->shost,
    303                               "Snic Tgt: device_add, with err = %d\n",
    304                               ret);
    305 
    306                 put_device(&tgt->dev);
                        ^^^^^^^^^^^^^^^^^^^^

The put_device() will free tgt.

    307                 put_device(&snic->shost->shost_gendev);
    308                 spin_lock_irqsave(snic->shost->host_lock, flags);
    309                 list_del(&tgt->list);

Use after free

    310                 spin_unlock_irqrestore(snic->shost->host_lock, flags);
--> 311                 kfree(tgt);

Double free.

    312                 tgt = NULL;
    313 
    314                 return tgt;
    315         }
    316 
    317         SNIC_HOST_INFO(snic->shost, "Scanning %s.\n", dev_name(&tgt->dev));
    318 
    319         scsi_queue_work(snic->shost, &tgt->scan_work);
    320 
    321         return tgt;
    322 } /* end of snic_tgt_create */

regards,
dan carpenter
