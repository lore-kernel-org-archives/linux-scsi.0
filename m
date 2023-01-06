Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678ECC3DA7A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Jan 2023 09:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjAFJCF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Jan 2023 04:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjAFJCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2023 04:02:04 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8387A68C94
        for <linux-scsi@vger.kernel.org>; Fri,  6 Jan 2023 01:01:56 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d4so684598wrw.6
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2023 01:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oeoUVwbyr4T0WhSWYBbCj9LHSWdSauqLNBIHP/UJ/i8=;
        b=jFwCEv3OjdJFI1FFvAXD9B5iaSureTg5EcD0/kOS3sXy5O1Tqr0HIFlzRUnCs8s9S3
         m91tfwHBy6P8tZ2I+JhTKcp/H0us2FuTL4ho1WfHCOhsBKFS8Woc/wAc1hiaU35ABMDF
         pKQiMwPUBQ1aE1lOisWJ+i9IwR6XIKTIebtoIfR8MwARO1vHbwUIMWiZ/fNdENeMibAa
         EGmUihyVj+NtsfGnRdxqlfGoqnPRMuG6ZoEQJx+sptCBEP/H6FP0u4n447CUb+NbiRHl
         NqPyKXrlpT28qRa5w6FEoyIM0n4NOA2WBzCMW9DAmfPFdmXcN/vdF4cagiqe+AKfDfJi
         0w2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oeoUVwbyr4T0WhSWYBbCj9LHSWdSauqLNBIHP/UJ/i8=;
        b=MUZfCw8BRjMkRBWEWBTijWIjedhQSe7ciobUXxejSEE/WUBcBe3VENYOCuh48aXLsd
         XAfkhZUIe8FR/uPfmRYdCpNYTkIHRKcJv2DpzbsD2Pyxc4uR25ljtsTbtb8gd0siJmlc
         kaW0LBRJgH9N6ZeS23ILyGGuP1kyliWUKEVRpHso3LRDdE77ssWt51RNFeE7xaSd3xQJ
         vkKTh1H3hmvNo1n9cD1IGk2VVhHkRrkxgDDWwzza3xWosphTvEatq+nPS4w4xOgZ4Ve8
         s+q3Vmvac9+VBBPXSasikpAxpN/7nutEAa9zdUwzQUN3AK9a5OZsMP8DbW2IpBJ1TE+K
         Bf6A==
X-Gm-Message-State: AFqh2kpVdqPkL1br4uLEB2Tc7XONcMCrA0CmuJZsW6MnaBQGKflEryrH
        u0KODCnbyFMImVG9jCnyiwc=
X-Google-Smtp-Source: AMrXdXvJQ8AS0SjJ5/3wsXRs4WVVPqs6JHdN1c/ihusDZIOrWaTWIJnzY8guFyrtd1R8AT/jUw4J6A==
X-Received: by 2002:a5d:4849:0:b0:284:58c:b125 with SMTP id n9-20020a5d4849000000b00284058cb125mr24132316wrs.52.1672995715073;
        Fri, 06 Jan 2023 01:01:55 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g1-20020a5d46c1000000b00241cfe6e286sm532804wrs.98.2023.01.06.01.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 01:01:54 -0800 (PST)
Date:   Fri, 6 Jan 2023 12:01:47 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     beanhuo@micron.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: core: bsg: Add advanced RPMB support in
 ufs_bsg
Message-ID: <Y7fje9NDkF/NDZus@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bean Huo,

The patch 6ff265fc5ef6: "scsi: ufs: core: bsg: Add advanced RPMB
support in ufs_bsg" from Dec 1, 2022, leads to the following Smatch
static checker warning:

	drivers/ufs/core/ufs_bsg.c:121 ufs_bsg_exec_advanced_rpmb_req()
	error: uninitialized symbol 'sg_cnt'.

drivers/ufs/core/ufs_bsg.c
    67 static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hba *hba, struct bsg_job *job)
    68 {
    69         struct ufs_rpmb_request *rpmb_request = job->request;
    70         struct ufs_rpmb_reply *rpmb_reply = job->reply;
    71         struct bsg_buffer *payload = NULL;
    72         enum dma_data_direction dir;
    73         struct scatterlist *sg_list;
    74         int rpmb_req_type;
    75         int sg_cnt;
    76         int ret;
    77         int data_len;
    78 
    79         if (hba->ufs_version < ufshci_version(4, 0) || !hba->dev_info.b_advanced_rpmb_en ||
    80             !(hba->capabilities & MASK_EHSLUTRD_SUPPORTED))
    81                 return -EINVAL;
    82 
    83         if (rpmb_request->ehs_req.length != 2 || rpmb_request->ehs_req.ehs_type != 1)
    84                 return -EINVAL;
    85 
    86         rpmb_req_type = be16_to_cpu(rpmb_request->ehs_req.meta.req_resp_type);
    87 
    88         switch (rpmb_req_type) {
    89         case UFS_RPMB_WRITE_KEY:
    90         case UFS_RPMB_READ_CNT:
    91         case UFS_RPMB_PURGE_ENABLE:
    92                 dir = DMA_NONE;
    93                 break;
    94         case UFS_RPMB_WRITE:
    95         case UFS_RPMB_SEC_CONF_WRITE:
    96                 dir = DMA_TO_DEVICE;
    97                 break;
    98         case UFS_RPMB_READ:
    99         case UFS_RPMB_SEC_CONF_READ:
    100         case UFS_RPMB_PURGE_STATUS_READ:
    101                 dir = DMA_FROM_DEVICE;
    102                 break;
    103         default:
    104                 return -EINVAL;
    105         }
    106 
    107         if (dir != DMA_NONE) {
    108                 payload = &job->request_payload;
    109                 if (!payload || !payload->payload_len || !payload->sg_cnt)
    110                         return -EINVAL;
    111 
    112                 sg_cnt = dma_map_sg(hba->host->dma_dev, payload->sg_list, payload->sg_cnt, dir);
    113                 if (unlikely(!sg_cnt))
    114                         return -ENOMEM;
    115                 sg_list = payload->sg_list;
    116                 data_len = payload->payload_len;
    117         }

"sg_cnt" not initialized on else path.

    118 
    119         ret = ufshcd_advanced_rpmb_req_handler(hba, &rpmb_request->bsg_request.upiu_req,
    120                                    &rpmb_reply->bsg_reply.upiu_rsp, &rpmb_request->ehs_req,
--> 121                                    &rpmb_reply->ehs_rsp, sg_cnt, sg_list, dir);
                                                                 ^^^^^^

    122 
    123         if (dir != DMA_NONE) {
    124                 dma_unmap_sg(hba->host->dma_dev, payload->sg_list, payload->sg_cnt, dir);
    125 
    126                 if (!ret)
    127                         rpmb_reply->bsg_reply.reply_payload_rcv_len = data_len;
    128         }
    129 
    130         return ret;
    131 }

regards,
dan carpenter
