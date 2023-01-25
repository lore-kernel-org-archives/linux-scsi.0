Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA94C54E94
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 18:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbjAYSh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 13:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjAYSh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 13:37:57 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25AD113E8;
        Wed, 25 Jan 2023 10:37:55 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso2983497pjg.2;
        Wed, 25 Jan 2023 10:37:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kuEv51EG0zNMhrIvpDUzfQvpav0zuBUyyhhMrhPuDU=;
        b=YHbtP6IQ4xnXMVZvdnC+iBxvWJDgTLxqjIPfg2L/ezur/RikdA8uqjtkXhlvMKr3oy
         fwwhamILbA7/qty19OxzTTCLbBIJpPOFnvxcz3sXD6PEabqcXP6JhZc/j2T6oPRKNvVl
         wSqepjN0pCszKI8WZxN/KFF3i2bWklxO/zBHN7gyoLGdsrO9Gr9pYsOeEj1gUFktMMY1
         zFQDWbm5QYc0/yFTDeQuqUOMqy55NWvP53AuxupVSEu4aG4gv57xO3Ywm87Dzo/yhUFi
         bgDRm7B2s50reVZStoEGJ7PKMyzaQQCTyPqiK/1fvQxmTtMp1iPZ2Z7r2ok0WiWWPC+T
         59nA==
X-Gm-Message-State: AO0yUKWFTENIzV2L78/isS1gCaFcj8i+4IIIVH4WdGCXefXgg62I/5cC
        lz6P8LEcPP5A4kCmJrmNaaE=
X-Google-Smtp-Source: AK7set/eyzU5R1T8RxHzrGu8mMDZMxDBM+2Wemi9pKnGYeykwIi4w4++/Z8BzcQHI35taNc4h0qMxw==
X-Received: by 2002:a17:90b:3e8e:b0:22c:1613:1656 with SMTP id rj14-20020a17090b3e8e00b0022c16131656mr976291pjb.26.1674671874852;
        Wed, 25 Jan 2023 10:37:54 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:7512:ed47:db25:4294? ([2620:15c:211:201:7512:ed47:db25:4294])
        by smtp.gmail.com with ESMTPSA id j3-20020a17090a3e0300b002263faf8431sm1986677pjc.17.2023.01.25.10.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 10:37:54 -0800 (PST)
Message-ID: <e8324901-7c18-153f-b47f-112a394832bd@acm.org>
Date:   Wed, 25 Jan 2023 10:37:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 17:19, Damien Le Moal wrote:
> On 1/25/23 09:05, Bart Van Assche wrote:
>> Thanks again for the detailed reply. Your replies are very informative
>> and help me understand the context better.
>>
>> However, I'm still less than enthusiast about the introduction of the
>> I/O priority class IOPRIO_CLASS_DL. To me command duration limits (CDL)
>> is a mechanism that is supported by one storage standard (SCSI) and of
> 
> And ATA (ACS) too. Not just SCSI. This is actually an improvement over IO
> priority (command priority) that is supported only by ATA NCQ and does not
> exist with SCSI/SBC.
> 
>> which it is not sure that it will be integrated in other storage
>> standards (NVMe, ...). Isn't the purpose of the block layer to provide
>> an interface that is independent of the specifics of a single storage
>> standard? This is why I'm in favor of letting the ATA core translate one
>> of the existing I/O priority classes into a CDL instead of introducing a
>> new I/O priority class (IOPRIO_CLASS_DL) in the block layer.
> 
> We discussed CDL with Hannes in the context of NVMe over fabrics. Their
> may be interesting extensions to consider for NVMe in that context (the
> value for local PCI attached NVMe drive is more limited at best).
> 
> I would argue that IO priority is the same: that is not supported by all
> device classes either, and for those that support it, the semantic is not
> identical (ATA vs NVMe). Yet, we have the RT class that maps to high
> priority for ATA, and nothing else as far as I know.
> 
> CDL at least covers SCSI *and* ATA, and as mentioned above, could be used
> by NVMe-of host drivers to do fancy link selection for a multipath setup
> based on the link speed for instance.
> 
> We could overload the RT class with a mapping to CDL feature on scsi and
> ata, but I think this is more confusing/messy than a separate class as we
> implemented.

Hi Damien,

The more I think about this, the more I'm convinced that it would be wrong
to introduce IOPRIO_CLASS_DL. Datacenters will have a mix of drives that
support CDL and drives that do not support CDL. It seems wrong to me to
make user space software responsible for figuring out whether or not the
drive supports CDL before it can be decided which I/O priority class should
be used. This is something the kernel should do instead of user space
software.

If we would ask Android storage vendors to implement CDL then IOPRIO_CLASS_DL
would cause trouble too. Android has support since considerable time to give
the foreground application a higher I/O priority than background applications.
The cgroup settings for foreground and background applications come from the
task_profiles.json file (see also
https://android.googlesource.com/platform/system/core/+/master/libprocessgroup/profiles/task_profiles.json).
As one can see all the settings in that file are independent of the features
of the storage device. Introducing IOPRIO_CLASS_DL in the kernel and using it
in task_profiles.json would imply that the storage device type has to be
determined before it can be decided whether or not IOPRIO_CLASS_DL can be used.
This seems wrong to me.

I downloaded the patch series in its entirety and applied it on a local kernel
branch. I verified which changes would be needed to replace IOPRIO_CLASS_DL
with IOPRIO_CLASS_RT. Can you help me with verifying the patch below?

Regarding the BFQ changes in the patch below, is an I/O scheduler useful at all
if CDL is used since a comment in the BFQ driver says that the disk should do
the scheduling instead of BFQ if CDL is used?

Thanks,

Bart.


diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7add9346c585..815b884d6c5a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5545,14 +5545,6 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
  		bfqq->new_ioprio_class = IOPRIO_CLASS_IDLE;
  		bfqq->new_ioprio = 7;
  		break;
-	case IOPRIO_CLASS_DL:
-		/*
-		 * For the duration-limits class, we want the disk to do the
-		 * scheduling. So map all levels to the highest RT level.
-		 */
-		bfqq->new_ioprio = 0;
-		bfqq->new_ioprio_class = IOPRIO_CLASS_RT;
-		break;
  	}

  	if (bfqq->new_ioprio >= IOPRIO_NR_LEVELS) {
@@ -5681,8 +5673,6 @@ static struct bfq_queue **bfq_async_queue_prio(struct bfq_data *bfqd,
  		return &bfqg->async_bfqq[1][ioprio][act_idx];
  	case IOPRIO_CLASS_IDLE:
  		return &bfqg->async_idle_bfqq[act_idx];
-	case IOPRIO_CLASS_DL:
-		return &bfqg->async_bfqq[0][0][act_idx];
  	default:
  		return NULL;
  	}
diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index dfb5c3f447f4..8bb6b8eba4ce 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -27,7 +27,6 @@
   * @POLICY_RESTRICT_TO_BE: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_RT into
   *		IOPRIO_CLASS_BE.
   * @POLICY_ALL_TO_IDLE: change the I/O priority class into IOPRIO_CLASS_IDLE.
- * @POLICY_ALL_TO_DL: change the I/O priority class into IOPRIO_CLASS_DL.
   *
   * See also <linux/ioprio.h>.
   */
@@ -36,7 +35,6 @@ enum prio_policy {
  	POLICY_NONE_TO_RT	= 1,
  	POLICY_RESTRICT_TO_BE	= 2,
  	POLICY_ALL_TO_IDLE	= 3,
-	POLICY_ALL_TO_DL	= 4,
  };

  static const char *policy_name[] = {
@@ -44,7 +42,6 @@ static const char *policy_name[] = {
  	[POLICY_NONE_TO_RT]	= "none-to-rt",
  	[POLICY_RESTRICT_TO_BE]	= "restrict-to-be",
  	[POLICY_ALL_TO_IDLE]	= "idle",
-	[POLICY_ALL_TO_DL]	= "duration-limits",
  };

  static struct blkcg_policy ioprio_policy;
diff --git a/block/ioprio.c b/block/ioprio.c
index 1b3a9da82597..32a456b45804 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -37,7 +37,6 @@ int ioprio_check_cap(int ioprio)

  	switch (class) {
  		case IOPRIO_CLASS_RT:
-		case IOPRIO_CLASS_DL:
  			/*
  			 * Originally this only checked for CAP_SYS_ADMIN,
  			 * which was implicitly allowed for pid 0 by security
@@ -48,7 +47,7 @@ int ioprio_check_cap(int ioprio)
  			if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
  				return -EPERM;
  			fallthrough;
-			/* RT and DL have prio field too */
+			/* rt has prio field too */
  		case IOPRIO_CLASS_BE:
  			if (data >= IOPRIO_NR_LEVELS || data < 0)
  				return -EINVAL;
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 526d0ea4dbf9..f10c2a0d18d4 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -113,7 +113,6 @@ static const enum dd_prio ioprio_class_to_prio[] = {
  	[IOPRIO_CLASS_RT]	= DD_RT_PRIO,
  	[IOPRIO_CLASS_BE]	= DD_BE_PRIO,
  	[IOPRIO_CLASS_IDLE]	= DD_IDLE_PRIO,
-	[IOPRIO_CLASS_DL]	= DD_RT_PRIO,
  };

  static inline struct rb_root *
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b4761c3c4b91..3065b632e6ae 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -673,7 +673,7 @@ static inline void ata_set_tf_cdl(struct ata_queued_cmd *qc, int ioprio)
  	struct ata_taskfile *tf = &qc->tf;
  	int cdl;

-	if (IOPRIO_PRIO_CLASS(ioprio) != IOPRIO_CLASS_DL)
+	if (IOPRIO_PRIO_CLASS(ioprio) != IOPRIO_CLASS_RT)
  		return;

  	cdl = IOPRIO_PRIO_DATA(ioprio) & 0x07;
diff --git a/drivers/scsi/sd_cdl.c b/drivers/scsi/sd_cdl.c
index 59d02dbb5ea1..c5286f5ddae4 100644
--- a/drivers/scsi/sd_cdl.c
+++ b/drivers/scsi/sd_cdl.c
@@ -880,10 +880,10 @@ int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
  	unsigned int dld;

  	/*
-	 * Use "no limit" if the request ioprio class is not IOPRIO_CLASS_DL
+	 * Use "no limit" if the request ioprio class is not IOPRIO_CLASS_RT
  	 * or if the user specified an invalid CDL descriptor index.
  	 */
-	if (IOPRIO_PRIO_CLASS(ioprio) != IOPRIO_CLASS_DL)
+	if (IOPRIO_PRIO_CLASS(ioprio) != IOPRIO_CLASS_RT)
  		return 0;

  	dld = IOPRIO_PRIO_DATA(ioprio);
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 2f3fc2fbd668..7578d4f6a969 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -20,7 +20,7 @@ static inline bool ioprio_valid(unsigned short ioprio)
  {
  	unsigned short class = IOPRIO_PRIO_CLASS(ioprio);

-	return class > IOPRIO_CLASS_NONE && class <= IOPRIO_CLASS_DL;
+	return class > IOPRIO_CLASS_NONE && class <= IOPRIO_CLASS_IDLE;
  }

  /*
diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
index 15908b9e9d8c..f70f2596a6bf 100644
--- a/include/uapi/linux/ioprio.h
+++ b/include/uapi/linux/ioprio.h
@@ -29,7 +29,6 @@ enum {
  	IOPRIO_CLASS_RT,
  	IOPRIO_CLASS_BE,
  	IOPRIO_CLASS_IDLE,
-	IOPRIO_CLASS_DL,
  };

  /*
@@ -38,12 +37,6 @@ enum {
  #define IOPRIO_NR_LEVELS	8
  #define IOPRIO_BE_NR		IOPRIO_NR_LEVELS

-/*
- * The Duration limits class allows 8 levels: level 0 for "no limit" and levels
- * 1 to 7, each corresponding to a read or write limit descriptor.
- */
-#define IOPRIO_DL_NR_LEVELS	8
-
  enum {
  	IOPRIO_WHO_PROCESS = 1,
  	IOPRIO_WHO_PGRP,

