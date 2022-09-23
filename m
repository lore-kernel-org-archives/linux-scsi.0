Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AC1C6FA83
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiIWUxC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiIWUxA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:53:00 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00D8F1D78
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:52:56 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id a2so754305iln.13
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=0pguD5ERzMg1kriRPNLUHasBeFWgUGfxhoverUsEc0M=;
        b=W4fL5OpwMiLHCLHE6MA2VCMfatp1lEDsHdXjApFf75g7A4o+b8aKbVcI2KDIo696Sf
         ts4bZDR0j+B276oegyXKnN+/RxXID8cue/ScCc97/2L+SgbpwsyoD/qVuEJ3vgHecKgm
         QhBq/Coo3EkCwb0NWw1nV3SYN8cZYAfdGPOV2KuoKrZ2uXLiKOMUW5Zq4h1e9brDFza7
         KZYpR/a7iPwI7CH9yCogOVqua9QX48YTJgn6iLkamB8YCjrs38jCEChdL4oWULr37DVZ
         vEbPIOVck+OooX2/aeTEvnEsSJgpQh79dHs4hOCXuzbmiIFdBvTolv7lLs+kfig45Bfj
         YE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0pguD5ERzMg1kriRPNLUHasBeFWgUGfxhoverUsEc0M=;
        b=NFQEeDdDpzqzZHAzIToS/Gh47ixTUg+AUzRT5BVd4NOmQ+/MQ7cEXV7Y3LH0rwlG+I
         I/ZlQsR2uYqSyHoXhNltKqJ6kePCl0q8Gz6bUcdKLf/XHcpBsOdg1s+Nq/CSm2HsNA9j
         JPBqXr98dbxztYX+kTrVyFvjkDs52NHViwj6Q960XLZ1hzXU5VB7a8CEwZ3C2lI2UrrK
         6QeAe0YtG0uF4D7sSoBxH+yZ6AdScPrvVl7IWyGjMz/e4MbxTuZg3bPhO0pumb4SlwJ8
         +sJCQRxifMcl1kXBVAT+BW7hCVV3IcnRukB7i4/bw6lop7xKFjh5I3xWBIoZpWPP8lSM
         /Mug==
X-Gm-Message-State: ACrzQf1ACEZvzvghCqazAUxaiyPxs+GAikymnXvbqCcTp9ZqG6ra618l
        VFhPspnyIHDkKkz0uwKgXfgjcg==
X-Google-Smtp-Source: AMsMyM51Ya2I8nFxvsCDC+9xPjmakd9dYpKCi1drkHVeMaH4beOmC4A8dpyYLut3dXaUzPsJEosJQQ==
X-Received: by 2002:a05:6e02:15c5:b0:2d7:a1cf:6f87 with SMTP id q5-20020a056e0215c500b002d7a1cf6f87mr5040089ilu.30.1663966376003;
        Fri, 23 Sep 2022 13:52:56 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e23-20020a0566380cd700b00352ce4f5e72sm1201219jak.179.2022.09.23.13.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 13:52:55 -0700 (PDT)
Message-ID: <d09e1645-919f-9239-f86d-a8e85a133e5c@kernel.dk>
Date:   Fri, 23 Sep 2022 14:52:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4/5] nvme: split out metadata vs non metadata end_io
 uring_cmd completions
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, Stefan Roesch <shr@fb.com>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-5-axboe@kernel.dk> <Yy3O7wH16t6AhC3j@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yy3O7wH16t6AhC3j@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/22 9:21 AM, Christoph Hellwig wrote:
>> +	union {
>> +		struct {
>> +			void *meta; /* kernel-resident buffer */
>> +			void __user *meta_buffer;
>> +		};
>> +		struct {
>> +			u32 nvme_flags;
>> +			u32 nvme_status;
>> +			u64 result;
>> +		};
>> +	};
> 
> Without naming the arms of the union this is becoming a bit too much
> of a mess..
> 
>> +static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
>> +{
>> +	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>> +	int status;
>> +
>> +	if (pdu->nvme_flags & NVME_REQ_CANCELLED)
>> +		status = -EINTR;
>> +	else
>> +		status = pdu->nvme_status;
> 
> If you add a signed int field you only need one field instead of
> two in the pdu for this (the nvme status is only 15 bits anyway).

For both of these, how about we just simplify like below? I think
at that point it's useless to name them anyway.


diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 25f2f6df1602..6f955984ca14 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -350,16 +350,13 @@ struct nvme_uring_cmd_pdu {
 		struct request *req;
 	};
 	u32 meta_len;
+	u32 nvme_status;
 	union {
 		struct {
 			void *meta; /* kernel-resident buffer */
 			void __user *meta_buffer;
 		};
-		struct {
-			u32 nvme_flags;
-			u32 nvme_status;
-			u64 result;
-		};
+		u64 result;
 	};
 };
 
@@ -396,17 +393,11 @@ static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
 static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-	int status;
-
-	if (pdu->nvme_flags & NVME_REQ_CANCELLED)
-		status = -EINTR;
-	else
-		status = pdu->nvme_status;
 
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
 
-	io_uring_cmd_done(ioucmd, status, pdu->result);
+	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->result);
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
@@ -417,8 +408,10 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	void *cookie = READ_ONCE(ioucmd->cookie);
 
 	req->bio = pdu->bio;
-	pdu->nvme_flags = nvme_req(req)->flags;
-	pdu->nvme_status = nvme_req(req)->status;
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		pdu->nvme_status = -EINTR;
+	else
+		pdu->nvme_status = nvme_req(req)->status;
 	pdu->result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/*

-- 
Jens Axboe
