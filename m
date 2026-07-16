Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61C5348C52
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 02:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256114; cv=none; b=im7/W0+LLmRuLcj19r1Ic/ktxCvtbgEYeuK3rE6z2a7eX509Qr+TeTwmgCtfpgtBUAEmODXnaO87TiKcmmmFze6siftURdFu0yEcUW9GijLnT7hyLX6xLLdfDNugf4Vv9TvdaSq8yijjUw6NALeGdG03FyREOrIAere1i73X3BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256114; c=relaxed/simple;
	bh=tzn/iEqTad6dQhUjU9RzDdcmlVaMSOCPaaD5tYvzKjM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N9A2Z+tZmpact5w5JH+QneDo4hFMkRpgEQwnvueGL82WGEbU2QvERF2kgXO6R16iPy2pyCHSMnobIUds2FkfcCUHNFa9guu4wAZKXGyNITYxUij5dNjMGCWnMrM5RWG6DHMbnvNOKmIwOmjFcz/d/vjh82uZku8yNQbXxfqzjPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GRqA6RIE; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GRqA6RIE"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-698a99b6140so8426838a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 19:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784256110; x=1784860910; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hJfRBT3Ki0wq3tOrZx9x5Dfjc24sd8ItMQ1cbR5ZfR8=;
        b=GRqA6RIEtpo0UeJaKQcIICezzadIEn6yz99Ovs0SeinsFju8niM+huD/Ql+fVjl/hu
         ytMzk16cNIESuopiLH0SW9NydPEFZzZxeYlofCvnURlgshUuUnRMocpqgg7FlDur8f1H
         S1ElLhZe+4R0ZO9bi2mzg9QwXpldrmqKrVviwoyqsS5scM7lhWE+RBXgIavnowpmqkzp
         5GJF3LqmSr8EbMa1lq881LIFxb04GGkMKbFaW+KRVBKeymM9KWZyIvcDlBGpb49JkS0O
         2ZNshLtvQeYRfau3sz9PO+64I1kk1zLfFB2dIlhx9ZCgrn4rGL3HIQaJRMnL6r4JDxuo
         +JGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784256110; x=1784860910;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hJfRBT3Ki0wq3tOrZx9x5Dfjc24sd8ItMQ1cbR5ZfR8=;
        b=I+dBpfswoS65clg08E97XnCvVaKhwzffPDCXLDb0mrWChIDGjaP5m0AhD8dx2BpES2
         7wZX0D9A1mrEKgUS0y3JaAw/rIjcn3iT8po/RgfNQyYKu/MY/XI1YQA01tiGoNpBOiwM
         IjbuUAiNyC3sWi9/e40OXm01GgSDxcr+s5PYh8VK/6vSM/K+yRb6QISfF9c4k6DEQ4TQ
         8FYsJ1A8gSqpxuKKW1QXPZOgc5iJqGxpFtu7hzEkY36bsSj6v9njzttMLyBPWWgmlNeB
         hXEUnNR7oXJej0VyNxVYbK2uMzjcfC8vXUXavzgcOpCx4Hp8Pki3eBZ3jjaPZzZs5zoo
         edvQ==
X-Forwarded-Encrypted: i=1; AHgh+RpoG67WVFF6W3uGqARyi5Oaj5lhlFknmyWYr3OLU8iPvqMdfwfb01Vr1sG4PMAwmRQ+UCQVu4KoidqZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy785BxmIsdOIZglI16NjpUq5W6P/Uwhrrkm2qPYpB+0GRxity0
	eoohcqn4pS4QQvg1bEhcdb9/UIwUxjSPmiIeXHw2v3/FMkpGMYCFeGvCc70vrM8QWvJkYprE9v1
	GLUzy8yCZqD+cXMpI2Q==
X-Received: from edvu22.prod.google.com ([2002:a05:6402:1116:b0:69a:9bdd:206f])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:11c8:b0:698:3b7c:be65 with SMTP id 4fb4d7f45d1cf-69e652c5662mr148592a12.33.1784256109719;
 Thu, 16 Jul 2026 19:41:49 -0700 (PDT)
Date: Thu, 16 Jul 2026 23:04:11 +0000
In-Reply-To: <20260716230411.2767394-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260716230411.2767394-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260716230411.2767394-8-tarunsahu@google.com>
Subject: [PATCH v19 7/7] scsi: Enable async shutdown support
From: Tarun Sahu <tarunsahu@google.com>
To: Shuah Khan <skhan@linuxfoundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>
Cc: bvanassche@acm.org, john.g.garry@oracle.com, mlombard@redhat.com, 
	loberman@redhat.com, mclapinski@google.com, dmatlack@google.com, 
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, jordanrichards@google.com, souravsgl@google.com, 
	stuart.w.hayes@gmail.com, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, emilne@redhat.com, jmeneghi@redhat.com, 
	linux-scsi@vger.kernel.org, David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: David Jeffery <djeffery@redhat.com>

Like scsi's async suspend support, allow scsi devices to be shut down
asynchronously to reduce system shutdown time.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/hosts.c      | 2 ++
 drivers/scsi/scsi_sysfs.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf..bf691acc7a67 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -273,6 +273,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_set_active(&shost->shost_gendev);
 	pm_runtime_enable(&shost->shost_gendev);
 	device_enable_async_suspend(&shost->shost_gendev);
+	dev_set_async_shutdown(&shost->shost_gendev);
 
 	error = device_add(&shost->shost_gendev);
 	if (error)
@@ -282,6 +283,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	get_device(shost->shost_gendev.parent);
 
 	device_enable_async_suspend(&shost->shost_dev);
+	dev_set_async_shutdown(&shost->shost_dev);
 
 	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..8fd317aef37b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1386,6 +1386,7 @@ static int scsi_target_add(struct scsi_target *starget)
 	pm_runtime_set_active(&starget->dev);
 	pm_runtime_enable(&starget->dev);
 	device_enable_async_suspend(&starget->dev);
+	dev_set_async_shutdown(&starget->dev);
 
 	return 0;
 }
@@ -1412,6 +1413,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_configure_device(&starget->dev);
 
 	device_enable_async_suspend(&sdev->sdev_gendev);
+	dev_set_async_shutdown(&sdev->sdev_gendev);
 	scsi_autopm_get_target(starget);
 	pm_runtime_set_active(&sdev->sdev_gendev);
 	if (!sdev->rpm_autosuspend)
@@ -1431,6 +1433,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	}
 
 	device_enable_async_suspend(&sdev->sdev_dev);
+	dev_set_async_shutdown(&sdev->sdev_dev);
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
-- 
2.55.0.229.g6434b31f56-goog

