Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C009F61FFE;
	Thu, 24 Jul 2025 00:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753318718; cv=none; b=V3I95EbSC6wUnvGlqUnCLx8RU8YVOQUSGxlKqs+R069Fodwqr8IhjpByNOcteLG1Y2LaROzBhFGECKsNqCxzk0PStGgsQYWmMSudCCeGNQZxTWYnGPPyZU0BkoXHfK8wEIPnj4x1IxQn5yiiusfFCbpCrgmoWbLY7aJleIzlFkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753318718; c=relaxed/simple;
	bh=aeNOdkpst+H3RxGW9+/APqV1DMPFE1EPMf73zoYY3KY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jRjQpMoxu7myihX788VB4uqrOOY69LePmJ4CKJyv/BKsTR0mGyfKiVCfLoiMbmPDr0/BwFXK8Synt3t33XYTE+vQfzz6JiwelwjD3WDS+KQTolwGZLXsIWrOYUJF90S1wM+D/Gnh+043mTw9LnbciaLS8By/bsW5VivT7ZkPl98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7+oln4Z; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7+oln4Z"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-719c4aa9b19so5501897b3.0;
        Wed, 23 Jul 2025 17:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753318714; x=1753923514; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iPFpMxy87NH4c5TqUDIA7jr+NS6eKhkoz9Gcmalsvpw=;
        b=A7+oln4ZeR7HjoE7Ahx/5+4oowv1UKatI+KVJLXmwOExZGrT5FP4GSwNNqEnkp4dPG
         sZWPiuxzFh1wHZCi1aTFDFwpxnfONyVweepf+hUUbX53T719qzwXYpslBnByfb8vUzTS
         vyTXA6XV0Lsz4j9iD2wEfpvbewiEbe1Up/k4nWAc+vpUYMNeVO4/mwfMh+FM5E9wVKbp
         WOFOcyvksgrI+EP+b2Wj3IhddGwHAweFk1U+EmXaubtZ2wrYkUxxo4MOaXFzS61HN/Ty
         o9+/dxWlNS17BH/amiSVf4YlRNjiTv4H3odbUdut2uBw/9CFq2K8AgtbvhYSsYoiWtwK
         BQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753318714; x=1753923514;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iPFpMxy87NH4c5TqUDIA7jr+NS6eKhkoz9Gcmalsvpw=;
        b=NIjlozqxkq8EA0BVh6Z6KALjMJHq+f7eur6BMEzgWXUzMqspW4zsLb5sGSFphBCJVR
         lOTOAjUxDzNTsztGk35wUOOwPPmP2PUSBZN+g6yixQoljlTdraxD4rYsONSEkDjZSI9V
         ZsVzJKHhV79RbslZzM/qdTXXq1SjYOZ2HcuHsYxbqAGpcDAErPJlU3ipD7UzeC8oYs0P
         HYMR5HwJDQFhMnH9mCFLEd03+cjTfUEQoqdKIDeZV2zHd97zPxVn0H3+E6+x28cLan3I
         BOiuRcUB+1WCNKL2bG9X5UhmiHbSveIjrmHNO2nV2NDRJre4T4hF7ji7iKI3q8GAokiJ
         6K3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWGkI0o3Ip7iCeoxCC9+Mh4C/ZyhNp3iN62Jru4cGXMCCyQpLbEMmtDYQlMu8xeRqX5Xua6LOnju3tpXlg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb0vMr1ATmmOkU3NW7V1CX5LN5sBFsWB6yQ3PMJocQb+Bmtvfk
	5bEpSY6SiVPReQ9eZGRVwcCtxzYm3UeQwkPmpiBCPk2dyKLdRo1uxoz+dnUyoclYKe7bEdo7dpd
	7yg8zSEU8FRC8m50YxmLg0zH/rMzRnKE=
X-Gm-Gg: ASbGncvE/x7/guPpcOeQQdQ6nZXGwvN8WNcy6LEx30CEx1TFrQfcCJak4fT21b731PA
	oz2O3KSTDVKRXbU4OT9SfTfU+/xTrxH/kwXMIzBbz+KjvDwrdw1xkT+OCUJJAYvkaush07MVugu
	IJjkR8LLyGqcyRifQmNAiPSDeId3H+3+AQwL5N4IMDnZeBofJ1BgxB1oc1UFZIrMmjGSlQmUsFL
	Z2eb/a8nhPLk/3X4g==
X-Google-Smtp-Source: AGHT+IEKWhln8H30QD7NO+17lYtb8FhsmUsXEZDWPI+9p2I/3xxnBz0+VdNNkrB6fsBjUTJVRlBe0+fZdoIRqSeyITM=
X-Received: by 2002:a81:d20b:0:b0:719:cd4b:c30b with SMTP id
 00721157ae682-719cd4bc86bmr2117827b3.16.1753318714567; Wed, 23 Jul 2025
 17:58:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Rujra Bhatt <braker.noob.kernel@gmail.com>
Date: Thu, 24 Jul 2025 06:28:23 +0530
X-Gm-Features: Ac12FXzWLZCu9_iFO4o3Y-QlOvSlPpvCwUteuoM3xt4L68v9cQ8Aw1J0zIlz5eQ
Message-ID: <CAG+54DbmHbw4MWUSF3x1qQC4bF7Uuu8mDD7aAZyBtbJ1D51MUw@mail.gmail.com>
Subject: [PATCH] scsi:st.c replace snprintf() with sysfs_emit()
To: Kai.Makisara@kolumbus.fi, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

replace snprintf() with sysfs_emit() or sysfs_emit_at() in st.c file to
follow kernel's guidelines from Documentation/filesystems/sysfs.rst
This improves safety, consistency and easier to maintain and update it
in the future.

Signed-off-by: Rujra Bhatt <braker.noob.kernel@gmail.com>
---
 drivers/scsi/st.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 74a6830b7ed8..38badba472d7 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4564,25 +4564,25 @@ module_exit(exit_st);
 /* The sysfs driver interface. Read-only at the moment */
 static ssize_t try_direct_io_show(struct device_driver *ddp, char *buf)
 {
-       return scnprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
+       return sysfs_emit_at(buf, PAGE_SIZE, "%d\n", try_direct_io);
 }
 static DRIVER_ATTR_RO(try_direct_io);

 static ssize_t fixed_buffer_size_show(struct device_driver *ddp, char *buf)
 {
-       return scnprintf(buf, PAGE_SIZE, "%d\n", st_fixed_buffer_size);
+       return sysfs_emit_at(buf, PAGE_SIZE, "%d\n", st_fixed_buffer_size);
 }
 static DRIVER_ATTR_RO(fixed_buffer_size);

 static ssize_t max_sg_segs_show(struct device_driver *ddp, char *buf)
 {
-       return scnprintf(buf, PAGE_SIZE, "%d\n", st_max_sg_segs);
+       return sysfs_emit_at(buf, PAGE_SIZE, "%d\n", st_max_sg_segs);
 }
 static DRIVER_ATTR_RO(max_sg_segs);

 static ssize_t version_show(struct device_driver *ddd, char *buf)
 {
-       return scnprintf(buf, PAGE_SIZE, "[%s]\n", verstr);
+       return sysfs_emit_at(buf, PAGE_SIZE, "[%s]\n", verstr);
 }
 static DRIVER_ATTR_RO(version);

@@ -4608,7 +4608,7 @@ static ssize_t debug_flag_store(struct device_driver *ddp,

 static ssize_t debug_flag_show(struct device_driver *ddp, char *buf)
 {
-       return scnprintf(buf, PAGE_SIZE, "%d\n", debugging);
+       return sysfs_emit_at(buf, PAGE_SIZE, "%d\n", debugging);
 }
 static DRIVER_ATTR_RW(debug_flag);
 #endif
@@ -4632,7 +4632,7 @@ defined_show(struct device *dev, struct
device_attribute *attr, char *buf)
        struct st_modedef *STm = dev_get_drvdata(dev);
        ssize_t l = 0;

-       l = snprintf(buf, PAGE_SIZE, "%d\n", STm->defined);
+       l = sysfs_emit_at(buf, PAGE_SIZE, "%d\n", STm->defined);
        return l;
 }
 static DEVICE_ATTR_RO(defined);
@@ -4644,7 +4644,7 @@ default_blksize_show(struct device *dev, struct
device_attribute *attr,
        struct st_modedef *STm = dev_get_drvdata(dev);
        ssize_t l = 0;

-       l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_blksize);
+       l = sysfs_emit_at(buf, PAGE_SIZE, "%d\n", STm->default_blksize);
        return l;
 }
 static DEVICE_ATTR_RO(default_blksize);
@@ -4658,7 +4658,7 @@ default_density_show(struct device *dev, struct
device_attribute *attr,
        char *fmt;

        fmt = STm->default_density >= 0 ? "0x%02x\n" : "%d\n";
-       l = snprintf(buf, PAGE_SIZE, fmt, STm->default_density);
+       l = sysfs_emit_at(buf, PAGE_SIZE, fmt, STm->default_density);
        return l;
 }
 static DEVICE_ATTR_RO(default_density);
@@ -4670,7 +4670,7 @@ default_compression_show(struct device *dev,
struct device_attribute *attr,
        struct st_modedef *STm = dev_get_drvdata(dev);
        ssize_t l = 0;

-       l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_compression - 1);
+       l = sysfs_emit_at(buf, PAGE_SIZE, "%d\n", STm->default_compression - 1);
        return l;
 }
 static DEVICE_ATTR_RO(default_compression);
@@ -4699,7 +4699,7 @@ options_show(struct device *dev, struct
device_attribute *attr, char *buf)
        options |= STp->immediate_filemark ? MT_ST_NOWAIT_EOF : 0;
        options |= STp->sili ? MT_ST_SILI : 0;

-       l = snprintf(buf, PAGE_SIZE, "0x%08x\n", options);
+       l = sysfs_emit_at(buf, PAGE_SIZE, "0x%08x\n", options);
        return l;
 }
 static DEVICE_ATTR_RO(options);
@@ -4718,7 +4718,7 @@ static ssize_t
position_lost_in_reset_show(struct device *dev,
        struct st_modedef *STm = dev_get_drvdata(dev);
        struct scsi_tape *STp = STm->tape;

-       return sprintf(buf, "%d", STp->pos_unknown);
+       return sysfs_emit(buf, "%d", STp->pos_unknown);
 }
 static DEVICE_ATTR_RO(position_lost_in_reset);

@@ -4735,7 +4735,7 @@ static ssize_t read_cnt_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long long)atomic64_read(&STm->tape->stats->read_cnt));
 }
 static DEVICE_ATTR_RO(read_cnt);
@@ -4753,7 +4753,7 @@ static ssize_t read_byte_cnt_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long
long)atomic64_read(&STm->tape->stats->read_byte_cnt));
 }
 static DEVICE_ATTR_RO(read_byte_cnt);
@@ -4769,7 +4769,7 @@ static ssize_t read_ns_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long
long)atomic64_read(&STm->tape->stats->tot_read_time));
 }
 static DEVICE_ATTR_RO(read_ns);
@@ -4786,7 +4786,7 @@ static ssize_t write_cnt_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long long)atomic64_read(&STm->tape->stats->write_cnt));
 }
 static DEVICE_ATTR_RO(write_cnt);
@@ -4803,7 +4803,7 @@ static ssize_t write_byte_cnt_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long
long)atomic64_read(&STm->tape->stats->write_byte_cnt));
 }
 static DEVICE_ATTR_RO(write_byte_cnt);
@@ -4820,7 +4820,7 @@ static ssize_t write_ns_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long
long)atomic64_read(&STm->tape->stats->tot_write_time));
 }
 static DEVICE_ATTR_RO(write_ns);
@@ -4838,7 +4838,7 @@ static ssize_t in_flight_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long long)atomic64_read(&STm->tape->stats->in_flight));
 }
 static DEVICE_ATTR_RO(in_flight);
@@ -4858,7 +4858,7 @@ static ssize_t io_ns_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long
long)atomic64_read(&STm->tape->stats->tot_io_time));
 }
 static DEVICE_ATTR_RO(io_ns);
@@ -4877,7 +4877,7 @@ static ssize_t other_cnt_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long long)atomic64_read(&STm->tape->stats->other_cnt));
 }
 static DEVICE_ATTR_RO(other_cnt);
@@ -4895,7 +4895,7 @@ static ssize_t resid_cnt_show(struct device *dev,
 {
        struct st_modedef *STm = dev_get_drvdata(dev);

-       return sprintf(buf, "%lld",
+       return sysfs_emit(buf, "%lld",
                       (long long)atomic64_read(&STm->tape->stats->resid_cnt));
 }
 static DEVICE_ATTR_RO(resid_cnt);
--
2.43.0
