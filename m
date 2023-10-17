Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2912CDB482
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 20:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344262AbjJQUs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 16:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbjJQUsp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 16:48:45 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29829123;
        Tue, 17 Oct 2023 13:48:38 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6b201a93c9cso3848270b3a.0;
        Tue, 17 Oct 2023 13:48:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697575717; x=1698180517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UCPfzQ6gGXtCtFoEWf6GEkmetjqJd0PL6BZnUtAtOy0=;
        b=Vt9NNOBlYD9kps5hkBuzIzBzuEX7eTobKnJipO0JmS6b/aGhjPzSXuYwbrSMViPhfw
         R8jqN/Uy72ZXRMzzHb3viTV3+DLjmdpGnfqejLaage8a/UJ6Ie938Cx2Jp9vRN3RWgrK
         yNc15P7Me8c6oEWzYul8bKpA5U0L98M88YwsWcF375kAaNCCGpINGpwlOdal1ccGbxhB
         xX/JB4LLNVva982S7XpzXVkSXdwurwmU9BkEbsw9vDlyefHPpgVHIe8li4KVLCoDopjD
         k8CiLnUJHquYOuck6/aMf7As1+AMcS81SpxQqaA2nkkMdT7EOcVwLoHPooDi8pGTeDy/
         WUGw==
X-Gm-Message-State: AOJu0YyL88HeXpOGBXjNUTKNxJ8J+OjUbPuJM8/BRG6saqFAK/rJBjsx
        mgY0kdzwcmRQDIbCWBAzxkg=
X-Google-Smtp-Source: AGHT+IGLtf5JVJbh8jxsrak07fhOzuFs0F8KGhRSffVSrD/2+5/2uK0jdz4gTrgWw4uM63DNmxrcOA==
X-Received: by 2002:a05:6a00:218f:b0:693:3783:4a29 with SMTP id h15-20020a056a00218f00b0069337834a29mr3669286pfi.20.1697575717354;
        Tue, 17 Oct 2023 13:48:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8f02:2919:9600:ac09])
        by smtp.gmail.com with ESMTPSA id fa36-20020a056a002d2400b006b2e07a6235sm1874704pfb.136.2023.10.17.13.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 13:48:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 14/14] scsi_debug: Maintain write statistics per group number
Date:   Tue, 17 Oct 2023 13:47:22 -0700
Message-ID: <20231017204739.3409052-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231017204739.3409052-1-bvanassche@acm.org>
References: <20231017204739.3409052-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Track per GROUP NUMBER how many write commands have been processed. Make
this information available in sysfs. Reset these statistics if any data
is written into the sysfs attribute.

Note: SCSI devices should only interpret the information in the GROUP
NUMBER field as a stream identifier if the ST_ENBLE bit has been set to
one. This patch follows a simpler approach: count the number of writes
per GROUP NUMBER whether or not the group number represents a stream
identifier.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 51 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 801448570960..c2102c0046ad 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -846,6 +846,8 @@ static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
 static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static int poll_queues; /* iouring iopoll interface.*/
 
+static atomic_long_t writes_by_group_number[64];
+
 static char sdebug_proc_name[] = MY_NAME;
 static const char *my_name = MY_NAME;
 
@@ -3040,7 +3042,8 @@ static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
 
 /* Returns number of bytes copied or -1 if error. */
 static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
-			    u32 sg_skip, u64 lba, u32 num, bool do_write)
+			    u32 sg_skip, u64 lba, u32 num, bool do_write,
+			    u8 group_number)
 {
 	int ret;
 	u64 block, rest = 0;
@@ -3059,6 +3062,10 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 		return 0;
 	if (scp->sc_data_direction != dir)
 		return -1;
+
+	if (do_write && group_number < ARRAY_SIZE(writes_by_group_number))
+		atomic_long_inc(&writes_by_group_number[group_number]);
+
 	fsp = sip->storep;
 
 	block = do_div(lba, sdebug_store_sectors);
@@ -3432,7 +3439,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		}
 	}
 
-	ret = do_device_access(sip, scp, 0, lba, num, false);
+	ret = do_device_access(sip, scp, 0, lba, num, false, 0);
 	sdeb_read_unlock(sip);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
@@ -3617,6 +3624,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	bool check_prot;
 	u32 num;
+	u8 group = 0;
 	u32 ei_lba;
 	int ret;
 	u64 lba;
@@ -3628,11 +3636,13 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		ei_lba = 0;
 		lba = get_unaligned_be64(cmd + 2);
 		num = get_unaligned_be32(cmd + 10);
+		group = cmd[14] & 0x3f;
 		check_prot = true;
 		break;
 	case WRITE_10:
 		ei_lba = 0;
 		lba = get_unaligned_be32(cmd + 2);
+		group = cmd[6] & 0x3f;
 		num = get_unaligned_be16(cmd + 7);
 		check_prot = true;
 		break;
@@ -3647,15 +3657,18 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		ei_lba = 0;
 		lba = get_unaligned_be32(cmd + 2);
 		num = get_unaligned_be32(cmd + 6);
+		group = cmd[6] & 0x3f;
 		check_prot = true;
 		break;
 	case 0x53:	/* XDWRITEREAD(10) */
 		ei_lba = 0;
 		lba = get_unaligned_be32(cmd + 2);
+		group = cmd[6] & 0x1f;
 		num = get_unaligned_be16(cmd + 7);
 		check_prot = false;
 		break;
 	default:	/* assume WRITE(32) */
+		group = cmd[6] & 0x3f;
 		lba = get_unaligned_be64(cmd + 12);
 		ei_lba = get_unaligned_be32(cmd + 20);
 		num = get_unaligned_be32(cmd + 28);
@@ -3710,7 +3723,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		}
 	}
 
-	ret = do_device_access(sip, scp, 0, lba, num, true);
+	ret = do_device_access(sip, scp, 0, lba, num, true, group);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, num);
 	/* If ZBC zone then bump its write pointer */
@@ -3762,12 +3775,14 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	u32 lb_size = sdebug_sector_size;
 	u32 ei_lba;
 	u64 lba;
+	u8 group;
 	int ret, res;
 	bool is_16;
 	static const u32 lrd_size = 32; /* + parameter list header size */
 
 	if (cmd[0] == VARIABLE_LENGTH_CMD) {
 		is_16 = false;
+		group = cmd[6] & 0x3f;
 		wrprotect = (cmd[10] >> 5) & 0x7;
 		lbdof = get_unaligned_be16(cmd + 12);
 		num_lrd = get_unaligned_be16(cmd + 16);
@@ -3778,6 +3793,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		lbdof = get_unaligned_be16(cmd + 4);
 		num_lrd = get_unaligned_be16(cmd + 8);
 		bt_len = get_unaligned_be32(cmd + 10);
+		group = cmd[14] & 0x3f;
 		if (unlikely(have_dif_prot)) {
 			if (sdebug_dif == T10_PI_TYPE2_PROTECTION &&
 			    wrprotect) {
@@ -3866,7 +3882,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			}
 		}
 
-		ret = do_device_access(sip, scp, sg_off, lba, num, true);
+		ret = do_device_access(sip, scp, sg_off, lba, num, true,
+				       group);
 		/* If ZBC zone then bump its write pointer */
 		if (sdebug_dev_is_zoned(devip))
 			zbc_inc_wp(devip, lba, num);
@@ -6828,6 +6845,31 @@ static ssize_t tur_ms_to_ready_show(struct device_driver *ddp, char *buf)
 }
 static DRIVER_ATTR_RO(tur_ms_to_ready);
 
+static ssize_t group_number_stats_show(struct device_driver *ddp, char *buf)
+{
+	char *p = buf, *end = buf + PAGE_SIZE;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(writes_by_group_number); i++)
+		p += scnprintf(p, end - p, "%d %ld\n", i,
+			       atomic_long_read(&writes_by_group_number[i]));
+
+	return p - buf;
+}
+
+static ssize_t group_number_stats_store(struct device_driver *ddp,
+					const char *buf,
+				  size_t count)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(writes_by_group_number); i++)
+		atomic_long_set(&writes_by_group_number[i], 0);
+
+	return 0;
+}
+static DRIVER_ATTR_RW(group_number_stats);
+
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
@@ -6874,6 +6916,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_cdb_len.attr,
 	&driver_attr_tur_ms_to_ready.attr,
 	&driver_attr_zbc.attr,
+	&driver_attr_group_number_stats.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
