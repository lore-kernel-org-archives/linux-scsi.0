Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101612192E4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609086; cv=none; b=WurPyreOF8aotiwGGRiPKN7kttfSFV82Dr2cE2ojl47dKPLu/bgK81J4thANMUxLCGLPxIgkvbetAcDun5nxFxusmTafK786DiMZ+75rmALkjK9kwNShpt8sIG/vEEQu/9+8IZqjRXSJpyXApuRvRxa4i2JreGCczNclB42Cyfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609086; c=relaxed/simple;
	bh=CRm4p7LF+pCg6J2N9r6mrSVhXUNB0AGvOgRTApIlemA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WzaMsDOYDXqAoEF28UBDWoUBBoewFK1CyT9XksTOKZGBmxjOhSxhKI0W23Dd7Cisw5ZY4zAJa0LWroGCWV90UUEm6kuK4JKLt10wJVjXafAZgfF3SM7WbptgYZCpUZuvfPVMNnBiqH2R3S6WQmFdKIc7S09ry3c1TWnyxeCiNX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f75tO6U+; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f75tO6U+"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7394945d37eso2375379b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609084; x=1746213884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTKGkVCgnaqhLDMH0uVOvq4krRkqQK8k2phVHceZtBU=;
        b=f75tO6U+UjxXFsef+BjTXEIp5Cg6eg0UKYggPkSIam2RL5kC0ZJCjvZGQrpoip5BYa
         nMyj+1eYL/mo9g1TxfEmObPgL8K+ewp4+7zDrXuTDyxlw8+5Cy7z17a1YvjKwGhu4AiX
         9eD+1/TSDkORrX+uAfXhOjeHObFU0zY/Gbwhqp9Jt7O6xBA6ud98dWdrX97Uu/CbasWc
         eW8SKn5hq+W+SkekEv+yukLOvH7Ck6yBIAlTwyztpMMGQZNeJ9z7bE8zis2y0oW5WA9l
         AZpqy0rgb3rZZXv8RucxfNXF3xkClfU2TP3r3EQBTaEvvwLM+ssJjAs1ua4ZMF/dfGsX
         51dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609084; x=1746213884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KTKGkVCgnaqhLDMH0uVOvq4krRkqQK8k2phVHceZtBU=;
        b=d/L6RgY7Ck0nSTJ99hKCBbp2m1tMaqyx3qLZH581D6Vp348JCTpnEG2lvSDA4hiLLG
         tBpQo5UgWk9xhmSeLk/55U4tnVWUTar2dvasthl255hM/K+UoyKUWmVuBSJ3OzpVEI/5
         bytbowC7AVitOv5AmoVmVVQGNoBTPI+WRG4g2o3y9CQh6zF0Fcg/O7RhvBnWtUm/cITy
         PiWO1xFsrkWhiYO3a9jINeBRUZdOo8Tpevmbs40M29XDOnrIRW84fim7+2SrtbEcrd0Z
         AITPmVuDa0CpKbsK2QgA9byOJbNSwnHUHv5vV0c/aKGXgvRD0H9ZzXdXfZc9bRpv3plP
         ANOw==
X-Gm-Message-State: AOJu0Yzv+3zEG5fbGqzsuX70kwl6rR5KqbXVghk0ptkK1VEIuDOU0xTR
	VkjjDcwJmXLFiWtNCE8r4yMn6qnn2uO1OPmjQdMMHrjMg+UHRNUhHXQSUQ==
X-Gm-Gg: ASbGnctVD6et/dhFm/TqBSbacGyoELqg+QnkMoWRaEoRRmTtt3ZWIFrZ/ILHePbS1yZ
	JA9MU9rDDx2wpSZ08+xGf0l/91z21X39/JXCbAPZWI+IC3q1d71h0ooEamrHgx4+VTlLztro4N5
	w1CPODuDFbtGrC1V0aVSdjkG/FMgiwQiWeIvTHCUwghdkcrsvvsSkOK82ryHGQRJWt69M8rBLyh
	ZsxbpjwfJZywG5LjMC92Ee3dFkS6BM1+FljU/9HWx9Upnjsf0kpONv4m+ReMKTIWJHiwbUH1GSt
	VxL9mb3a9quABfjqzQiqaUy8/U6qfxbKz1IODBItKyF4X+SE8aUcmCxY+U6b6ipl30TO91Hd5cz
	kvMAkk6YFMubOU0r7QnNSJqNe8B6MdhM6bzmF
X-Google-Smtp-Source: AGHT+IEUoDmzA3+rKhXHNBt+nPcTZUu4DNc0yc6D5lApgpy/r1HNezPv6b+ld1CSQzp8ewVVlTMY4Q==
X-Received: by 2002:a05:6a00:3d4c:b0:73e:96f:d4c1 with SMTP id d2e1a72fcca58-73ff72e40a1mr889411b3a.13.1745609084186;
        Fri, 25 Apr 2025 12:24:44 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:43 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/8] lpfc: Create lpfc_vmid_info sysfs entry
Date: Fri, 25 Apr 2025 12:48:04 -0700
Message-Id: <20250425194806.3585-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A vmid_info sysfs entry is created as a convenience designed for users to
obtain VMID information without having to log into fabrics for similar
info.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 134 ++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 397216ff2c7e..efd02c464549 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -291,6 +291,138 @@ lpfc_cmf_info_show(struct device *dev, struct device_attribute *attr,
 	return len;
 }
 
+static ssize_t
+lpfc_vmid_info_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_vmid  *vmp;
+	int  len = 0, i, j, k, cpu;
+	char hxstr[LPFC_MAX_VMID_SIZE * 3] = {0};
+	struct timespec64 curr_tm;
+	struct lpfc_vmid_priority_range *vr;
+	u64 *lta, rct_acc = 0, max_lta = 0;
+	struct tm tm_val;
+
+	ktime_get_ts64(&curr_tm);
+
+	len += scnprintf(buf + len, PAGE_SIZE - len, "Key 'vmid':\n");
+
+	/* if enabled continue, else return */
+	if (lpfc_is_vmid_enabled(phba)) {
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+				 "lpfc VMID Page: ON\n\n");
+	} else {
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+				 "lpfc VMID Page: OFF\n\n");
+		return len;
+	}
+
+	/* if using priority tagging */
+	if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO) {
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+				"VMID priority ranges:\n");
+		vr = vport->vmid_priority.vmid_range;
+		for (i = 0; i < vport->vmid_priority.num_descriptors; ++i) {
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					"\t[x%x - x%x], qos: x%x\n",
+					vr->low, vr->high, vr->qos);
+			vr++;
+		}
+	}
+
+	for (i = 0; i < phba->cfg_max_vmid; i++) {
+		vmp = &vport->vmid[i];
+		max_lta = 0;
+
+		/* only if the slot is used */
+		if (!(vmp->flag & LPFC_VMID_SLOT_USED) ||
+		    !(vmp->flag & LPFC_VMID_REGISTERED))
+			continue;
+
+		/* if using priority tagging */
+		if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO) {
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					"VEM ID: %02x:%02x:%02x:%02x:"
+					"%02x:%02x:%02x:%02x:%02x:%02x:"
+					"%02x:%02x:%02x:%02x:%02x:%02x\n",
+					vport->lpfc_vmid_host_uuid[0],
+					vport->lpfc_vmid_host_uuid[1],
+					vport->lpfc_vmid_host_uuid[2],
+					vport->lpfc_vmid_host_uuid[3],
+					vport->lpfc_vmid_host_uuid[4],
+					vport->lpfc_vmid_host_uuid[5],
+					vport->lpfc_vmid_host_uuid[6],
+					vport->lpfc_vmid_host_uuid[7],
+					vport->lpfc_vmid_host_uuid[8],
+					vport->lpfc_vmid_host_uuid[9],
+					vport->lpfc_vmid_host_uuid[10],
+					vport->lpfc_vmid_host_uuid[11],
+					vport->lpfc_vmid_host_uuid[12],
+					vport->lpfc_vmid_host_uuid[13],
+					vport->lpfc_vmid_host_uuid[14],
+					vport->lpfc_vmid_host_uuid[15]);
+		}
+
+		/* IO stats */
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+				"ID00 READs:%llx WRITEs:%llx\n",
+				vmp->io_rd_cnt,
+				vmp->io_wr_cnt);
+		for (j = 0, k = 0; j < strlen(vmp->host_vmid); j++, k += 3)
+			sprintf((char *)(hxstr + k), "%2x ", vmp->host_vmid[j]);
+		/* UUIDs */
+		len += scnprintf(buf + len, PAGE_SIZE - len, "UUID:\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%s\n", hxstr);
+
+		len += scnprintf(buf + len, PAGE_SIZE - len, "String (%s)\n",
+				vmp->host_vmid);
+
+		if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					"CS_CTL VMID: 0x%x\n",
+					vmp->un.cs_ctl_vmid);
+		else
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					"Application id: 0x%x\n",
+					vmp->un.app_id);
+
+		/* calculate the last access time */
+		for_each_possible_cpu(cpu) {
+			lta = per_cpu_ptr(vmp->last_io_time, cpu);
+			if (!lta)
+				continue;
+
+			/* if last access time is less than timeout */
+			if (time_after((unsigned long)*lta, jiffies))
+				continue;
+
+			if (*lta > max_lta)
+				max_lta = *lta;
+		}
+
+		rct_acc = jiffies_to_msecs(jiffies - max_lta) / 1000;
+		/* current time */
+		time64_to_tm(ktime_get_real_seconds(),
+			     -(sys_tz.tz_minuteswest * 60) - rct_acc, &tm_val);
+
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+				 "Last Access Time :"
+				 "%ld-%d-%dT%02d:%02d:%02d\n\n",
+				 1900 + tm_val.tm_year, tm_val.tm_mon + 1,
+				 tm_val.tm_mday, tm_val.tm_hour,
+				 tm_val.tm_min, tm_val.tm_sec);
+
+		if (len >= PAGE_SIZE)
+			return len;
+
+		memset(hxstr, 0, LPFC_MAX_VMID_SIZE * 3);
+	}
+	return len;
+}
+
 /**
  * lpfc_drvr_version_show - Return the Emulex driver string with version number
  * @dev: class unused variable.
@@ -3011,6 +3143,7 @@ static DEVICE_ATTR(protocol, S_IRUGO, lpfc_sli4_protocol_show, NULL);
 static DEVICE_ATTR(lpfc_xlane_supported, S_IRUGO, lpfc_oas_supported_show,
 		   NULL);
 static DEVICE_ATTR(cmf_info, 0444, lpfc_cmf_info_show, NULL);
+static DEVICE_ATTR_RO(lpfc_vmid_info);
 
 #define WWN_SZ 8
 /**
@@ -6117,6 +6250,7 @@ static struct attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_vmid_inactivity_timeout.attr,
 	&dev_attr_lpfc_vmid_app_header.attr,
 	&dev_attr_lpfc_vmid_priority_tagging.attr,
+	&dev_attr_lpfc_vmid_info.attr,
 	NULL,
 };
 
-- 
2.38.0

