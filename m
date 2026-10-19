Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448062;
	b=ufXgxhrm7KZo7MpUlwd2AnN8gtdzV5ktJjQS5P7CbSfuroOA8OmIgpy/pvZsYDxRUb5p
	 05idmI2V0zJByKtO4c0HbFoB3unAjSd9ZacgzwcumeoRU0uJEF0Hx5e2WKaZV37lMQXuZ
	 8BScOKaR5NjS3zq1MPOpAYCVsX3sozLDHJp9mfnvNRjLLqZUvJHJw394bA+7kziHtClok
	 q6uvHRaDhf6kwFJJ368Yx4hIuS7NV3Ix6ojVFGEc+AF8lwS1IfCJHVh66oRI5H+0JlEEP
	 U74u26irda9WjeJwKTvDv0l61uUT6sJUOYi0iW0pg4jkFcxFQ8WpNKQK/lqZ+/r3pfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448062;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ew1HqIAHqoKcahzNKgT9vYAgySTU/9yYh6NNiqMoFqc=;
	b=2VVtr3Pj2Dh940pSc017JegOGGWUMz3CbQr3Cw32SOk2/rjzIIZEkezcTM174/UgmfZt
	 P1K3iuHO6zsTN8anKDwAeRGxkp9pzIZH5oKzONSnRJv5RVfMOrx0Vq9MkvXi9eoCRHCB3
	 9IbkHQSVRpHxDxmRWwW1uw70S8nh5o88Ca1EAKFXvYLPRyJd4k3z4TuV3iZ6XZXMi1z8s
	 mIhbefd9IACBmNvlLLYjNd1pgAOy4gDxdrmFowE+k+5cjNSE19y74oLN+tq1TUJEuqrf2
	 ZM23Bo/G9At9nmWsSduuG1g89BN9bG0qOYhkfs2q85A7gK3vUGijZw3sbyBIMLxOVQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=GeMnvoLt;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E96606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:14:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3E96606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=GeMnvoLt
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-17bc533fda3so3061751c88.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 15:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792448061; x=1793052861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ew1HqIAHqoKcahzNKgT9vYAgySTU/9yYh6NNiqMoFqc=;
        b=GeMnvoLtdVWJQhgXDVC9pWt4KFQBp0B+4oDXeqxEQ8uHWgLr/uH1MWcR/7DvnpS9lS
         iUiI1XXWxM9dK105x9cqAIZrIqN+EPN8qDJynYHFAcQ2L+KZ5io+QyVfY0nY5SNVHUgW
         8Bjo5Qi878fgPM5iXsB71/XFA+GQH6xIb3fnJyk+mHrYdRuhew46j8xCr6Bjp5PdY0lR
         GWLhmkhKb4iHoZoHD8j44HEq1ArO5PUqomlAQ23plMUEu0orWcWYvLX3aH/0SjwJelHy
         xztOcfBuZOtKIkrwv7vsfZQFzR36AkRuSOqFBYbi7NSUvXgipEkWBKK7oIgCCUvn0A1H
         GYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792448061; x=1793052861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ew1HqIAHqoKcahzNKgT9vYAgySTU/9yYh6NNiqMoFqc=;
        b=qXDgNKEC2ywom6ASEjIyMHwxNJ1ISJt8dfsvm+lWTlwRIU2NbJk4UOvse5JPDAjys4
         eH6SZUzI6277Ut4Sq9dcNZUM2yry8qLPTUxtQHAkIfJHTdlIumXgXhl/k20OtawjJLaB
         y5KGH+FlIt5lyfXU79YwRHsE09u0wVDgVNBq01DUGNU2c79hwwSGCWVTijcW1cuLeLyI
         o8vHXtQvn261jVmzXIvjl/M1awI7XQXktun/wDfurwYt7pm/o/BfQdoBX33LtOq5sdng
         OSALLYGU0HxjqE+yejG59UZ7II5vYDLE5meskcLwnJJ/8DZuXPceFOu/X8qNHpBO+TDS
         Oe8w==
X-Gm-Message-State: AFq9FYKjfc1JnGrXPUWyWZDIkqTh09UrU47fXH8+ZbhUwufQ4KNhfsQJ
	Dh3dXBQws4T6MfJ7HtrLtlPrGxc2l6knwHCIsIBXBzPhIPjm8sZUbXdnhBiWK5VlMQh000ENcWC
	3BzzvY1Vxr7ungNZg/gXy9pr8oyp9ljxaegIObQM/mHy4v74ZLLjpHflCKqevCNh9uHeiGDuVn2
	8xqABGQRhD4siTg3KQHe4rCCBuiBmuD0+eoPtwDEGDt8vAGI5sDA==
X-Gm-Gg: AYBFou0ijVcFFtdUAlSTOrJpde+Dbm1j0vfrNCzWU9xNksAMz8F8lqqIM9yzEsDM5fl
	k8Ls4A+3Nfg2yO6+nnJMVutdQciRmvtzSmt5YQn49j1fNmQ7dXummCv/FtEPmoMhJRGF0etsy11
	p3wLJ0KT3dkoEfz2KwjRAjZjsheCAzIAXfTEpWIa/0WMS4Y7YPlLlA7XZW54OWrsCQsM64GO1Xn
	Y4SSF3bYTXJQph8p0bjiwq4wDThmnKXahEiSze3ooN8NsNIrQ0ywJeiiGFyM85FGG3WZV8+CQiB
	p5unI0Wlewyc+JysC/50FshFTLuzVUyzVldLADoDwMZ7AYtNDbF6zOeMesGK1Mz0fQkPrjWL2kH
	/NwZnsCGGeKDEHDlC7tkomb1j9Hhek4DeZMoaRB1FEbdVgcS0l9DRzhhws1NU3de8n4nlgXNGId
	iBPkOYfMPopmcCpi6kfGVzBmuB/7j1pbK4vF9N6xOSWlTYnZIgXGYhrYyNUQipi71YRCKNqOqw/
	P8eD0dpPacACr/0iwtZswNpNKiXkyeELAM8sCXKz5vMe4mz1jz/ZvUcurXC/qMWNvHBwfn7gMQL
	APQdHAxuQQ5pDsVU3HhreFgXSli+1ekSHKtsPFlXL7AFQ3O26qGFUQwErgIvYla8LeHtPHk=
X-Received: by 2002:a05:701b:4551:20b0:143:5cb4:30 with SMTP id a92af1059eb24-1850c40d8c5mr11800101c88.3.1792448060601;
        Mon, 19 Oct 2026 15:14:20 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-18319d3b880sm29429839c88.10.2026.10.19.15.14.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 15:14:20 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v8 1/5] scsi: core: Protect INQUIRY sysfs attributes with mutex
Date: Mon, 19 Oct 2026 15:14:00 -0700
Message-ID: <20261019221405.40614-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019221405.40614-1-brian@purestorage.com>
References: <20261019221405.40614-1-brian@purestorage.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All INQUIRY-derived sysfs attributes (type, scsi_level, vendor, model,
rev, cdl_supported, modalias, and the binary inquiry attribute) read
data that can be updated during device rescan. These reads must be
protected against concurrent updates.

Use the existing inquiry_mutex to protect access to these sysfs
attributes. This ensures that userspace always sees consistent INQUIRY
data, even if a rescan is updating the buffer concurrently.

Update the sdev_rd_attr macro to take inquiry_mutex around the field
access and switch to sysfs_emit. Since vendor, model, and rev are
NUL-terminated fixed-size arrays, %s format handles all field types
correctly.

scsi_bus_uevent() gets a const device and only needs the single-byte
type for MODALIAS, so read it with READ_ONCE() instead of taking the
mutex.

This is preparatory work for adding INQUIRY data update support during
device rescan operations.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_sysfs.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fe54792ed69e..5f3e3fcdbad3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -551,7 +551,13 @@ static int scsi_bus_uevent(const struct device *dev, struct kobj_uevent_env *env
 
 	sdev = to_scsi_device(dev);
 
-	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
+	/*
+	 * sdev->type is a single byte that a rescan may update under
+	 * inquiry_mutex, so a lockless read sees either the old or the new
+	 * type.
+	 */
+	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT,
+		       READ_ONCE(sdev->type));
 	return 0;
 }
 
@@ -638,21 +644,30 @@ sdev_show_##field (struct device *dev, struct device_attribute *attr,	\
 
 /*
  * sdev_rd_attr: macro to create a function and attribute variable for a
- * read only field.
+ * read-only field. inquiry_mutex protects INQUIRY-derived fields against
+ * concurrent updates during device rescan.
  */
 #define sdev_rd_attr(field, format_string)				\
-	sdev_show_function(field, format_string)			\
-static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
+static ssize_t								\
+sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
+		  char *buf)						\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+									\
+	guard(mutex)(&sdev->inquiry_mutex);				\
+	return sysfs_emit(buf, format_string, sdev->field);		\
+}									\
+static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
 
 /*
  * Create the actual show/store functions and data structures.
  */
-sdev_rd_attr (type, "%d\n");
-sdev_rd_attr (scsi_level, "%d\n");
-sdev_rd_attr (vendor, "%.8s\n");
-sdev_rd_attr (model, "%.16s\n");
-sdev_rd_attr (rev, "%.4s\n");
-sdev_rd_attr (cdl_supported, "%d\n");
+sdev_rd_attr(type, "%d\n");
+sdev_rd_attr(scsi_level, "%d\n");
+sdev_rd_attr(cdl_supported, "%d\n");
+sdev_rd_attr(vendor, "%s\n");
+sdev_rd_attr(model, "%s\n");
+sdev_rd_attr(rev, "%s\n");
 
 static ssize_t
 sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
@@ -917,6 +932,7 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
 
+	guard(mutex)(&sdev->inquiry_mutex);
 	if (!sdev->inquiry)
 		return -EINVAL;
 
@@ -963,6 +979,7 @@ sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
+	guard(mutex)(&sdev->inquiry_mutex);
 	return snprintf (buf, 20, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
 }
 static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
-- 
2.56.0

