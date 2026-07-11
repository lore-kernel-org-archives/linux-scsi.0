Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E292E7BD9
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783782463; cv=none; b=Gyxa75W5e/JI1YPTy782+grrJIjsk17xQWo+aW/awzxOLeq517nxHHY3ZmTj8yeyoYnIxCTmwQCFRxQ911YqXWgAXIp1nE3kuUuIrpWhKsu6mVk/Nv8B7pHSzjaMcYPcq4LkS/V2SOb2As8mS1i6iebptP45FrLiVN4axSOximo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783782463; c=relaxed/simple;
	bh=C6OXZLDcXKYzr72BNOQU/VVln5KF7AQKUiA2CLDJY7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pH2X3LCyHf2fq2RW4BsiWPWAE9xlrNPxKX+jmtOmjOJCtQ1m1IU42GVOEbWxEWpf1KWAx3uLm1arPgPgX4iowOWijmYoSl1LCvzWB006lylCVzkN0JoYe0iNrm6qbmBSiBNvHMZXF3zd1+PxsyZV+Uk1fMV36DmfBGioTl9GIRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NdZG2C0E; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NdZG2C0E"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-902e4af2d9dso11022296d6.0
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 08:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783782460; x=1784387260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3aoCw1gmDBSrdw433SXik9FK3EyXMsmdMSQruhZZCAY=;
        b=NdZG2C0EnoR25Ae3+4Fo8YXMm8WjmQcsT+ZoLm7TRj49HMzsXwVMUAfJJZq/ODtuA+
         oc5ySaeQdfCQLyV4VAUVKstWfL5qdu64qjmARElbj/PBJzxI/P2T6BkbEVn4rb7L9HbB
         TPstmQ4Q5pQCdkYBnc6eoMQM2m7kcfoBSpUQsQttYewkKDoegflwsD3ZbhDzpO+a3yhq
         zlc2/q9fyFcOjo5rbAC1bBiHN1lTbCMROJlum+c7hX8Usjj8OUSiE91ZvOnq60OiqONO
         OleScjAfyTbG0LP4cBU/InRSfxsRfHUbXY3hLQ13N4xUYJGpdjv4iujR4FaRUa0m1xUr
         zvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783782460; x=1784387260;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3aoCw1gmDBSrdw433SXik9FK3EyXMsmdMSQruhZZCAY=;
        b=bBg6wOhFwuoFo1Lw6Y++TQdWYs+USGBbzgOs60GfSn18M8qqhdh19G5Ks2Uw9h16Lr
         Ki4K9PMrJ0qpcVpvxMumBKGMMcVR/AA8SQWLdvppfKCpvN7/EpgLMn5/2w0aOu7ZMhwh
         La8xqSwXCyP5uiXoeLmPJhVPbmL7zKk4J4QcpNoY94VzHmrNCmV5djqpGnxlMwPjY/zv
         tGdjLCnAmEt1qUyrhNaaekyZS93MVlaGBncnH5w46+ey5A7hEITE45DJDgsH2yYS5jTF
         KEJTt2yQH47y6dNKU+IQ++7CQiJV6lb80StMsQ/Z/z5sUWMihKlBFsOqPbTKyv4uc68s
         mgtw==
X-Gm-Message-State: AOJu0YyUSKhYaMUYjQU2qFCTozbjMKn5N7qxjvFcPzwI3KQCETKgHKWk
	XDSCgAs+lX9/eebgV+1toPi/2E/4/rrrZSeuqHj5JuVqFUI4fHGqk6AEO82NQlsSw+E=
X-Gm-Gg: AfdE7ckuAFg3PWunysYvloIvdU6YKmyGuwEh9rYx8Nxa4lLzzZ3zA2yR9exd1UeE2mk
	KPORvlVxquX7KK5UMW1Bs9p6Sjo5Jeii6wuF4ZJquzN2kcp56tK5C8XaH9JRmAyX4YiCsjrvCSI
	L+BrToQ7n9ew7LaroU4ZryIKWxahxaS5GLvcTI6B+x/EXCNH1dondCpoFFKNuouaAPqfflbqWJF
	OoCLES+mXSkumIBGXUCltj+YNdTeHBdRDeDFOs2Z78O6SoML5W6diYju3p/MkrsaYGmhVIZNDX4
	rDnJM2ju5IAq3T7YXm/bETa+r8567Ixsxsuz95ryJ8ta6yZgXaX79ce3zZtn8nLLwodAW8aNzp4
	prM1AcA7UuDV20jO9LisPdxF6HRY5gzq+EQnxQHuF/gLEKlIRpf7yJbVJl+ExZhQ8xGiUn8rhQA
	NFrP3JjYeZQofjjg+Mss7610//A1mgGoOhLf93c4c/qne2OEXPZesGCBnSmzpKkelaw4xhm+eh9
	CuEiZWFYw==
X-Received: by 2002:a05:620a:4398:b0:92e:56ea:ec69 with SMTP id af79cd13be357-92ef3ed554dmr283777685a.31.1783782460256;
        Sat, 11 Jul 2026 08:07:40 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d69a78sm472464485a.44.2026.07.11.08.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 08:07:39 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: sd: bound the IO hints descriptor walk to the buffer
Date: Sat, 11 Jul 2026 11:07:36 -0400
Message-ID: <20260711150736.2917641-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

sd_read_io_hints() computes the end of the IO group descriptor list from
the mode-sense reply as buffer + (data.header_length + data.length),
where data.length is the device-reported mode data length. A device (or a
compromised virtio/hypervisor block backend) that reports a length larger
than the SD_BUF_SIZE buffer scsi_mode_sense() actually filled makes the
subsequent "for (desc = start; desc < end; desc++)" loop read past the
buffer.

Impact: a malicious or malfunctioning SCSI/SATA device, or a compromised
hypervisor block backend, drives an out-of-bounds read of the mode-sense
buffer (KASAN) while parsing permanent-stream IO hints at attach time.

Clamp the descriptor region to SD_BUF_SIZE before deriving the end
pointer.

Fixes: 4f53138fffc2 ("scsi: sd: Translate data lifetime information")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 drivers/scsi/sd.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f333343..eec383cbc39f1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3304,6 +3304,7 @@ static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_mode_data data;
 	int res;
+	u32 len;
 
 	if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
 		return;
@@ -3313,9 +3314,17 @@ static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
 			      sdkp->max_retries, &data, &sshdr);
 	if (res < 0)
 		return;
+	/*
+	 * The device-reported mode data length can exceed the buffer that
+	 * was actually transferred; clamp it so the descriptor walk stays
+	 * within buffer[SD_BUF_SIZE].
+	 */
+	if (data.length > SD_BUF_SIZE - data.header_length)
+		len = SD_BUF_SIZE;
+	else
+		len = data.header_length + data.length;
 	start = (void *)buffer + data.header_length + 16;
-	end = (void *)buffer + ALIGN_DOWN(data.header_length + data.length,
-					  sizeof(*end));
+	end = (void *)buffer + ALIGN_DOWN(len, sizeof(*end));
 	/*
 	 * From "SBC-5 Constrained Streams with Data Lifetimes": Device severs
 	 * should assign the lowest numbered stream identifiers to permanent
-- 
2.53.0

