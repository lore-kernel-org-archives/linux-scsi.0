Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0911A4F22
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 20:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036745; cv=none; b=BUVWCbME9PXDv9FEQO1ahNE4qBDj0syIYUKfSC/a191BJzrx2BaJkvtcdFF2dARKlGP58ozvi8adKflfe/GOVzbMJSvbsusgmnWk83nSvdEx4wkG8H6bZ0xiGec7c5vcPuOksEwSUH5OsdZDUPxrnGyuFRDDkvGuYTjm6/u/dac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036745; c=relaxed/simple;
	bh=++GVuqGnOdqduHfgyfRPg2vHaMJGQK29XZRdvyQ4xdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcMKTzJsoejiQHJ5IMklTyJAP+ie9CjpYiWsykYJiaJpAQFbaTjlpm8uCSHbr+BVVTEdKcWUcswCyOyjukevyCP4pKK9G3cLLYw9y9EHNDv7L+nlTbIgY5n+VmRo1NRPlcu+rBnbKBnAHH2AzVKvIzYx4rt+X2LFFjWnb99yyfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R4ErBP3w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R4ErBP3w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PXEkCulTFjRJ7qcn0gnZBXZ52hajeLcq5bPwWoTRmsw=; b=R4ErBP3wUKR7i2rSZf2jzdjP1v
	j6yc/0OCXLgsLVJjvdE4i1QKTkfSISb2p7rUWCh32uD89zFwAFw7PNfmkZCXWINXhfGjdzjg03IEN
	DeiRDpvqa0KiyoPB8FU6V18m8mEvjIzs989TtiO9uNmXRkJA3egIeDC3jQnotgyPwOG8tA1dJkK7p
	6RqAfwfpfQGtgkN8FisXB0c2fXD4xzlPeU/BoKC/ZoCVmu3/Q1OMArcKJpAu6QPn/5pYvkg0XnfvS
	k9lWJqLqhIst8BkXJ7CizTlpdhQe0zYZa4VCMb5v5KRsfQfnGoPQxdUgjglAhvTkzVWlHRtmLbpw2
	mhK2ZTzQ==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLqAX-00000001rO5-3S4w;
	Thu, 12 Dec 2024 20:52:21 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/5] scsi: scsi_ioctl: add kernel-doc for exported functions
Date: Thu, 12 Dec 2024 12:52:14 -0800
Message-ID: <20241212205217.597844-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212205217.597844-1-rdunlap@infradead.org>
References: <20241212205217.597844-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add kernel-doc for scsi_set_medium_removal(), scsi_cmd_allowed(), and
scsi_ioctl_block_when_processing_errors() since these are exported.
This allows them to be part of the SCSI driver-api docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_ioctl.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

--- linux-next-20241212.orig/drivers/scsi/scsi_ioctl.c
+++ linux-next-20241212/drivers/scsi/scsi_ioctl.c
@@ -37,8 +37,10 @@
  * @host:	host to identify
  * @buffer:	userspace buffer for identification
  *
- * Return an identifying string at @buffer, if @buffer is non-NULL, filling
- * to the length stored at * (int *) @buffer.
+ * Return:
+ * * if successful, %1 and an identifying string at @buffer, if @buffer
+ * is non-NULL, filling to the length stored at * (int *) @buffer.
+ * * <0 error code on failure.
  */
 static int ioctl_probe(struct Scsi_Host *host, void __user *buffer)
 {
@@ -121,6 +123,16 @@ out:
 	return result;
 }
 
+/**
+ * scsi_set_medium_removal() - send command to allow or prevent medium removal
+ * @sdev: target scsi device
+ * @state: removal state to set (prevent or allow)
+ *
+ * Returns:
+ * * %0 if @sdev is not removable or not lockable or successful.
+ * * non-%0 is a SCSI result code if > 0 or kernel error code if < 0.
+ * * Sets @sdev->locked to the new state on success.
+ */
 int scsi_set_medium_removal(struct scsi_device *sdev, char state)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
@@ -242,11 +254,15 @@ static int scsi_send_start_stop(struct s
 				      NORMAL_RETRIES);
 }
 
-/*
- * Check if the given command is allowed.
+/**
+ * scsi_cmd_allowed() - Check if the given command is allowed.
+ * @cmd:            SCSI command to check
+ * @open_for_write: is the file / block device opened for writing?
  *
  * Only a subset of commands are allowed for unprivileged users. Commands used
  * to format the media, update the firmware, etc. are not permitted.
+ *
+ * Return: %true if the cmd is allowed, otherwise @false.
  */
 bool scsi_cmd_allowed(unsigned char *cmd, bool open_for_write)
 {
@@ -859,6 +875,8 @@ static int scsi_ioctl_sg_io(struct scsi_
  * Description: The scsi_ioctl() function differs from most ioctls in that it
  * does not take a major/minor number as the dev field.  Rather, it takes
  * a pointer to a &struct scsi_device.
+ *
+ * Return: varies depending on the @cmd
  */
 int scsi_ioctl(struct scsi_device *sdev, bool open_for_write, int cmd,
 		void __user *arg)
@@ -941,8 +959,15 @@ int scsi_ioctl(struct scsi_device *sdev,
 }
 EXPORT_SYMBOL(scsi_ioctl);
 
-/*
+/**
+ * scsi_ioctl_block_when_processing_errors - prevent commands from being queued
+ * @sdev: target scsi device
+ * @cmd: which ioctl is it
+ * @ndelay: no delay (non-blocking)
+ *
  * We can process a reset even when a device isn't fully operable.
+ *
+ * Return: %0 on success, <0 error code.
  */
 int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev, int cmd,
 		bool ndelay)
