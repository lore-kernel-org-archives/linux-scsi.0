Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF9FC61D97
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 03:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjA2Dwm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Jan 2023 22:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjA2Dwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jan 2023 22:52:41 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B7523338
        for <linux-scsi@vger.kernel.org>; Sat, 28 Jan 2023 19:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674964356; x=1706500356;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LEsO2ljg4poKO5J/KyVdVrexuBr3wa8pSkyN/fXlNWc=;
  b=EaCEtNCgTDLqx5cj+GIRptx8aUAT1QACAQoYFhqp9j1BLZ+Z2AnI46PB
   WuSVuGkL3XNtpVhmVZI/52zO4hSlFQF7KBquHAmCoajm1n2d52Qi7yeG5
   lbmvG866c+0fCIBTIdX4t9/uw25vKLoXgdzxycL1w2NJo87BaXuMF6OGc
   /a1ZyKhxl2kNyB9x7Y9eP9hFNA9na01By5Bq5g0DMQmBwCKXvR/iMsn/u
   A0oe8SMWFkW/XDUocJmHm5uV4aU8vkM5H4uvASRf+LLdfncJdWJ6HSmqw
   varvrm/pz7CtngxbGklWGoZCN3KnYEiuPb1dp6sZUJz4bayDlWARx/vKw
   w==;
X-IronPort-AV: E=Sophos;i="5.97,254,1669046400"; 
   d="scan'208";a="222054284"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jan 2023 11:52:35 +0800
IronPort-SDR: aGV88DVRwI3+jLeVgHXcjVYXngtPHAcam03niI7PY920CmWlEVRzn4E+t6/C4SCkWITlUk+xQt
 WrmHTtgzaA98eQDD+IErLmBhc+NkyeQ+anLfDC5OoMvs14DhFImfuIEHMY0VUUYkUMnGSFq4LE
 LznjO070ZCDa3fLQ7lTxQ0FNpTguacmi61h/u/uyCfyECoF9DGjSeIMv/6U+MnfvfRut6zIsXy
 fiHWBscS+6HecPVQw18uZ9xAEdxssYJ6zo5ItfdVVDZWYkFwLkmeGfBd7D3qgTaLU+ZSCyq7ph
 QeE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2023 19:04:18 -0800
IronPort-SDR: pUKCjMyqMVbraSKjVf1/wMdIhMoyDEYQcNzDPpeX7jbcI4/iJoyMmcJqCur73rmvW5Me7huQiL
 O3GhR6J4fNK3cduNLXRxMbzrsA9gf+M3rofXw7iD1QqAsobjZTylBN4vnuz8jEpTjX1diLZ1eD
 q94RRf/oZuBDVW6yvcBznNfcfTmncZfTU/1s8QvyjfUWtQi73oAC/+ggrsHQ+NEmJ4UxiTzqM3
 4ydL4YwHkviXUFWQ8zV2RGLJSCl0GAHJDP0BY9O+vhXVDuhdCwK/nw6+L/ZUv7moAIG1aLnkZl
 ggE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2023 19:52:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P4HSy6Sb7z1RvTr
        for <linux-scsi@vger.kernel.org>; Sat, 28 Jan 2023 19:52:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674964353; x=1677556354; bh=LEsO2ljg4poKO5J/KyVdVrexuBr3wa8pSky
        N/fXlNWc=; b=D0VGkskg/VR9kpl6HBgT1oseNHN9Q6nKlCZbEhQqjHaXxSto5Kb
        DgfEFiaffao2wTIokhh0OQHzjW5yC/Z2o4NOj1dCTHC2gTo9t3W7UCzh49ZT2JRD
        JSbMlPJEuogtlLMVraUl7dA9IPyEPJEYLgEtUISPmyI/MVbPMiftG85goP/PaIvv
        I2NnCbQjSCCNupTTLtq1dZ0U6jKgQ4IRMpEceJ+NYDgVIeUQC0E1Olp6PBeXVkOP
        G3lxeHhM+zA2cqitLI1Fer7RwjLIHM5O02S/LGxsgUVCzM+2ymQKaRQRBbV0e3Z2
        QYmUdUXiSQ18fXCOdkIyGQorA4XwjDfICbg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vNqus0fK0SPF for <linux-scsi@vger.kernel.org>;
        Sat, 28 Jan 2023 19:52:33 -0800 (PST)
Received: from [10.225.163.66] (unknown [10.225.163.66])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P4HSv476Lz1RvLy;
        Sat, 28 Jan 2023 19:52:31 -0800 (PST)
Message-ID: <f8320ff3-0f52-aa0c-635e-c1e7c28ffe25@opensource.wdc.com>
Date:   Sun, 29 Jan 2023 12:52:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
 <e8324901-7c18-153f-b47f-112a394832bd@acm.org> <Y9Gd0eI1t8V61yzO@x1-carbon>
 <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
 <Y9KF5z/v0Qp5E4sI@x1-carbon> <7f0a2464-673a-f64a-4ebb-e599c3123a24@acm.org>
 <29b50dbd-76e9-cdce-4227-a22223850c9a@opensource.wdc.com>
 <c8ef76be-c285-c797-5bdb-3a960821048b@opensource.wdc.com>
 <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
 <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
 <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
 <4e803108-9526-6a75-f209-789a06ef52f9@opensource.wdc.com>
 <yq1r0veh2fa.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <yq1r0veh2fa.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/29/23 05:25, Martin K. Petersen wrote:
> 
> Damien,
> 
> Finally had a window where I could sit down a read this extremely long
> thread.
> 
>> I am not denying anything. I simply keep telling you that CDL is not a
>> generic feature for random applications to use, including those that
>> already use RT/BE/IDLE. It is for applications that know and expect
>> it, and so have a setup suited for CDL use down to the drive CDL
>> descriptors. That includes DM setups.
>>
>> Thinking about CDL in a generic setup for any random application to
>> use is nonsense. And even if that happens and a user not knowing about
>> it still tries it, than as mentioned, nothing bad will happen. Using
>> CDL in a setup that does not support it is a NOP. That would be the
>> same as not using it.
> 
> My observations:
> 
>  - Wrt. ioprio as conduit, I personally really dislike the idea of
>    conflating priority (relative performance wrt. other I/O) with CDL
>    (which is a QoS concept). I would really prefer those things to be
>    separate. However, I do think that the ioprio *interface* is a good
>    fit. A tool like ionice seems like a reasonable approach to letting
>    generic applications set their CDL.

The definition of IOPRIO_CLASS_CDL was more about reusing the ioprio *interface*
rather than having CDL support defined as a fully functional IO priority class.
As I argued in this thread, and I think you agreee, CDL semantic is more than
the simple priority class/level ordering.

>    If bio space wasn't a premium, I'd say just keep things separate.
>    But given the inherent incompatibility between kernel I/O scheduling
>    and CDL, it's probably not worth the hassle to separate them. As much
>    as it pains me to mix two concepts which should be completely
>    orthogonal.
> 
>    I wish we could let applications specify both a priority and a CDL at
>    the same time, though. Even if the kernel plumbing in the short term
>    ends up using bi_ioprio as conduit. It's much harder to make changes
>    in the application interface at a later date.

See below. There may be a solution about that.

>  - Wrt. "CDL is not a generic feature", I think you are underestimating
>    how many applications actually want something like this. We have
>    many.
> 
>    I don't think we should design for "special interest only, needs
>    custom device tweaking to be usable". We have been down that path
>    before (streams, etc.). And with poor results.

OK.

>    I/O hints also tanked but at least we tried to pre-define performance
>    classes that made sense in an abstract fashion. And programmed the
>    mode page on discovered devices so that the classes were identical
>    across all disks, regardless of whether they were SSDs or million
>    dollar arrays. This allowed filesystems to communicate "this is
>    metadata" regardless of the device the I/O was going to. Instead of
>    "index 5 on this device" but "index 42 on the mirror".
> 
>    As such, I don't like the "just customize your settings with
>    cdltools" approach. I'd much rather see us try to define a few QoS
>    classes that make sense that would apply to every app and use those
>    to define the application interface. And then have the kernel program
>    those CDL classes into SCSI/ATA devices by default.

Makes sense. Though I think it will be hard to define a set of QoS hints that
are useful for a wide range of applications, and even harder to convert the
defined hint classes to CDL descriptors. I fear that we may end up with the same
issues as IO hints/streams.

>    Having the kernel provide an abstract interface for bio QoS and
>    configuring a new disk with a sane handful of classes does not
>    prevent $CLOUD_VENDOR from overriding what Linux configured. But at
>    least we'd have a generic approach to block QoS in Linux. Similar to
>    the existing I/O priority infrastructure which is also not tied to
>    any particular hardware feature.

OK. See below about this.

>    A generic implementation also allows us to do fancy things in the
>    hypervisor where we would like to be able to do QoS across multiple
>    devices as well. Without having ATA or SCSI with CDL involved. Or
>    whatever things might look like in NVMe.

Fair point, especially given that virtio actually already forwards a guest
ioprio to the host through the virtio block command. Thinking of that particular
point together with what you said, I came up with the change show below as a
replacement for this patch 1/18.

This changes the 13-bits ioprio data into a 3-bits QOS hint + 3-bits of IO prio
level. This is consistent with the IO prio interface since IO priority levels
have to be between 0 and 7 (otherwise, errors are returned). So in fact, the
upper 10-bits of the ioprio data are ignored and we can safely use 3 of these
bits for an IO hint.

This hint applies to all priority classes and levels, that is, for the CDL case,
we can enrich any priority with a hint that specifies the CDL index to use for
an IO.

This falls short of actually defining generic IO hints, but this has the
advantage to not break anything for current applications using IO priorities,
not require any change to existing IO schedulers, while still allowing to pass
CDL indexes for IOs down to the scsi & ATA layers (which for now would be the
only layers in the kernel acting on the ioprio qos hints).

I think that this approach still allows us to enable CDL support, and on top of
it, go further and define generic QOS hints that IO scheduler can use and that
also potentially map to CDL for scsi & ata (similarly to the RT class IOs
mapping to the NCQ priority feature if the user enabled that feature).

As mentioned above, I think that defining generic IO hint classes will be
difficult. But the change below is I think a good a starting point that should
not prevent working on that.

Thoughts ?

Bart,

Given that you did not like the IOPRIO_CLASS_CDL, what do you think of this
approach ?


diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index ccf2204477a5..9b3c8fb806f1 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5378,11 +5378,11 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct
bfq_io_cq *bic)
 		bfqq->new_ioprio_class = task_nice_ioclass(tsk);
 		break;
 	case IOPRIO_CLASS_RT:
-		bfqq->new_ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+		bfqq->new_ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 		bfqq->new_ioprio_class = IOPRIO_CLASS_RT;
 		break;
 	case IOPRIO_CLASS_BE:
-		bfqq->new_ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+		bfqq->new_ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 		bfqq->new_ioprio_class = IOPRIO_CLASS_BE;
 		break;
 	case IOPRIO_CLASS_IDLE:
@@ -5671,7 +5671,7 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 				       struct bfq_io_cq *bic,
 				       bool respawn)
 {
-	const int ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+	const int ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 	const int ioprio_class = IOPRIO_PRIO_CLASS(bic->ioprio);
 	struct bfq_queue **async_bfqq = NULL;
 	struct bfq_queue *bfqq;
diff --git a/block/ioprio.c b/block/ioprio.c
index 32a456b45804..33f327a10811 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -33,7 +33,7 @@
 int ioprio_check_cap(int ioprio)
 {
 	int class = IOPRIO_PRIO_CLASS(ioprio);
-	int data = IOPRIO_PRIO_DATA(ioprio);
+	int level = IOPRIO_PRIO_LEVEL(ioprio);

 	switch (class) {
 		case IOPRIO_CLASS_RT:
@@ -49,13 +49,13 @@ int ioprio_check_cap(int ioprio)
 			fallthrough;
 			/* rt has prio field too */
 		case IOPRIO_CLASS_BE:
-			if (data >= IOPRIO_NR_LEVELS || data < 0)
+			if (level >= IOPRIO_NR_LEVELS || level < 0)
 				return -EINVAL;
 			break;
 		case IOPRIO_CLASS_IDLE:
 			break;
 		case IOPRIO_CLASS_NONE:
-			if (data)
+			if (level)
 				return -EINVAL;
 			break;
 		default:
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 83a366f3ee80..eba23e6a7bf6 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -314,7 +314,7 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 		struct ckpt_req_control *cprc = &sbi->cprc_info;
 		int len = 0;
 		int class = IOPRIO_PRIO_CLASS(cprc->ckpt_thread_ioprio);
-		int data = IOPRIO_PRIO_DATA(cprc->ckpt_thread_ioprio);
+		int level = IOPRIO_PRIO_LEVEL(cprc->ckpt_thread_ioprio);

 		if (class == IOPRIO_CLASS_RT)
 			len += scnprintf(buf + len, PAGE_SIZE - len, "rt,");
@@ -323,7 +323,7 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 		else
 			return -EINVAL;

-		len += scnprintf(buf + len, PAGE_SIZE - len, "%d\n", data);
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%d\n", level);
 		return len;
 	}

diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
index f70f2596a6bf..1d90349a19c9 100644
--- a/include/uapi/linux/ioprio.h
+++ b/include/uapi/linux/ioprio.h
@@ -37,6 +37,18 @@ enum {
 #define IOPRIO_NR_LEVELS	8
 #define IOPRIO_BE_NR		IOPRIO_NR_LEVELS

+/*
+ * The 13-bits of ioprio data for each class provide up to 8 QOS hints and
+ * up to 8 priority levels.
+ */
+#define IOPRIO_PRIO_LEVEL_MASK	(IOPRIO_NR_LEVELS - 1)
+#define IOPRIO_QOS_HINT_SHIFT	10
+#define IOPRIO_NR_QOS_HINTS	8
+#define IOPRIO_QOS_HINT_MASK	(IOPRIO_NR_QOS_HINTS - 1)
+#define IOPRIO_PRIO_LEVEL(ioprio)	((ioprio) & IOPRIO_PRIO_LEVEL_MASK)
+#define IOPRIO_QOS_HINT(ioprio)	\
+	(((ioprio) >> IOPRIO_QOS_HINT_SHIFT) & IOPRIO_QOS_HINT_MASK)
+
 enum {
 	IOPRIO_WHO_PROCESS = 1,
 	IOPRIO_WHO_PGRP,


-- 
Damien Le Moal
Western Digital Research

