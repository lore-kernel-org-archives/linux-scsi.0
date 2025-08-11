Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC72E311C01;
	Mon, 11 Aug 2025 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754932050; cv=none; b=b4cIvBx5Wd7uY8u9ldd41J0N3RVMxC1rEMVqur3l14hWzHK8gh+u3LzymRidiOh6MCfPsOgmmsT2GsMGDce9ayRGt7QXNjGVxEum+l5fONW2BF1LjEVm3Ws7iJSmTLFO6UN9D8AwCHw/87rkt10DQgI6kTm7PNW9NTClPw0a+Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754932050; c=relaxed/simple;
	bh=RVszgM0um3eMUdt3IRVk6zljjfpf0+MIb3XriCiYPwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tLCwufx3khI9W8r7yP2aDtOmGbxJYb4Yy3BgtYpyESVSRI/ZzDxSXDMxrIVCEjVtdrR3dVBu9Ppc2pMNR2XEqv05tEH/HNdmG/xhVdvWzgqIUCgv1HhoneHOP1IoPCkrsVmYQOZ0lXtHT9vM6xYpUmpLpeM+/2o7fORQnPo1Ua0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.us; spf=pass smtp.mailfrom=gmx.us; dkim=pass (2048-bit key) header.d=gmx.us header.i=len.bao@gmx.us header.b=AQcfRg8Q; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.us header.i=len.bao@gmx.us header.b="AQcfRg8Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.us;
	s=s31663417; t=1754932039; x=1755536839; i=len.bao@gmx.us;
	bh=yC2S/wEi8KGENwurWbzuHG8Vw4xK4n4Tr7WdMBlsZNY=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=AQcfRg8QTRxKmHBWPhU+1wfBC6Hv7yZOLvYwAVieTRhEqpFkeCY/lsOSyjpECLWJ
	 LGo1yIXIytIvRuVBpYkoqKP/717GmNlpWt9EBO841DtOGR1oVmKNlVh4rXo0u0Ijg
	 rAkSaKFU+zcl1fFhCN/8mwkyvXhZ77t63O2bCTqj2njC95OCLRnkdbO+ddjZ7sk9G
	 iaBbN92PuVMcVAKBYEnssu54oKDgW40D6Xg0gzVbAahBuw3X7KMQjCQkPjCyisZH3
	 d+s9e7BJETRu0zgBEjTNFOJGwYEopdESTECv1mMWKRbhfqRfQm+u6cbzdf5CVDaKH
	 umZlLNPZPTeBNoSMKA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from ubuntu ([79.159.189.119]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N4hvb-1udiJm3SZL-00zS69; Mon, 11
 Aug 2025 19:07:19 +0200
From: Len Bao <len.bao@gmx.us>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Len Bao <len.bao@gmx.us>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla4xxx: Replace snprintf() with sysfs_emit()
Date: Mon, 11 Aug 2025 17:06:32 +0000
Message-ID: <20250811170639.65597-1-len.bao@gmx.us>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Gn610vzH3ffqIXqi2c1uPmtHJ6iYhVlU3jBNuc3qxl1uW7N3hwT
 Jdnh3zIKLGPdz7/vuio87pz5xWS+9C8+eJ/CDPbGGl3vM0Fp8a3tD9s5vJeega1ar+slFie
 MkO/7USMWO1CbN8z/1NVbUyiao58BxKxonaiY6kyN9Ox2Bw0hY4brf8AQti2PyqL4SNeNuI
 zII+kN1BkoKGO55jTlb0g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:VjPdibdsRno=;v7HzDnBSX1aiUyumOQIg/kJtETo
 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
 H1N1F7vUevA==

Documentation/filesystems/sysfs.rst mentions that show() should only
use sysfs_emit() or sysfs_emit_at() when formating the value to be
returned to user space. So replace snprintf() with sysfs_emit().

Signed-off-by: Len Bao <len.bao@gmx.us>
=2D--
 drivers/scsi/qla4xxx/ql4_attr.c | 52 ++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_at=
tr.c
index 84f99ff8e69..a9b75b29c8a 100644
=2D-- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -156,13 +156,13 @@ qla4xxx_fw_version_show(struct device *dev,
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
=20
 	if (is_qla80XX(ha))
-		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
-				ha->fw_info.fw_major, ha->fw_info.fw_minor,
-				ha->fw_info.fw_patch, ha->fw_info.fw_build);
+		return sysfs_emit(buf, "%d.%02d.%02d (%x)\n",
+				  ha->fw_info.fw_major, ha->fw_info.fw_minor,
+				  ha->fw_info.fw_patch, ha->fw_info.fw_build);
 	else
-		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d.%02d\n",
-				ha->fw_info.fw_major, ha->fw_info.fw_minor,
-				ha->fw_info.fw_patch, ha->fw_info.fw_build);
+		return sysfs_emit(buf, "%d.%02d.%02d.%02d\n",
+				  ha->fw_info.fw_major, ha->fw_info.fw_minor,
+				  ha->fw_info.fw_patch, ha->fw_info.fw_build);
 }
=20
 static ssize_t
@@ -170,7 +170,7 @@ qla4xxx_serial_num_show(struct device *dev, struct dev=
ice_attribute *attr,
 			char *buf)
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->serial_number);
+	return sysfs_emit(buf, "%s\n", ha->serial_number);
 }
=20
 static ssize_t
@@ -178,8 +178,8 @@ qla4xxx_iscsi_version_show(struct device *dev, struct =
device_attribute *attr,
 			   char *buf)
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->fw_info.iscsi_major,
-			ha->fw_info.iscsi_minor);
+	return sysfs_emit(buf, "%d.%02d\n", ha->fw_info.iscsi_major,
+			  ha->fw_info.iscsi_minor);
 }
=20
 static ssize_t
@@ -187,9 +187,9 @@ qla4xxx_optrom_version_show(struct device *dev, struct=
 device_attribute *attr,
 			    char *buf)
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d.%02d\n",
-			ha->fw_info.bootload_major, ha->fw_info.bootload_minor,
-			ha->fw_info.bootload_patch, ha->fw_info.bootload_build);
+	return sysfs_emit(buf, "%d.%02d.%02d.%02d\n",
+			  ha->fw_info.bootload_major, ha->fw_info.bootload_minor,
+			  ha->fw_info.bootload_patch, ha->fw_info.bootload_build);
 }
=20
 static ssize_t
@@ -197,7 +197,7 @@ qla4xxx_board_id_show(struct device *dev, struct devic=
e_attribute *attr,
 		      char *buf)
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "0x%08X\n", ha->board_id);
+	return sysfs_emit(buf, "0x%08X\n", ha->board_id);
 }
=20
 static ssize_t
@@ -207,8 +207,8 @@ qla4xxx_fw_state_show(struct device *dev, struct devic=
e_attribute *attr,
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
=20
 	qla4xxx_get_firmware_state(ha);
-	return snprintf(buf, PAGE_SIZE, "0x%08X%8X\n", ha->firmware_state,
-			ha->addl_fw_state);
+	return sysfs_emit(buf, "0x%08X%8X\n", ha->firmware_state,
+			  ha->addl_fw_state);
 }
=20
 static ssize_t
@@ -220,7 +220,7 @@ qla4xxx_phy_port_cnt_show(struct device *dev, struct d=
evice_attribute *attr,
 	if (is_qla40XX(ha))
 		return -ENOSYS;
=20
-	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->phy_port_cnt);
+	return sysfs_emit(buf, "0x%04X\n", ha->phy_port_cnt);
 }
=20
 static ssize_t
@@ -232,7 +232,7 @@ qla4xxx_phy_port_num_show(struct device *dev, struct d=
evice_attribute *attr,
 	if (is_qla40XX(ha))
 		return -ENOSYS;
=20
-	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->phy_port_num);
+	return sysfs_emit(buf, "0x%04X\n", ha->phy_port_num);
 }
=20
 static ssize_t
@@ -244,7 +244,7 @@ qla4xxx_iscsi_func_cnt_show(struct device *dev, struct=
 device_attribute *attr,
 	if (is_qla40XX(ha))
 		return -ENOSYS;
=20
-	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->iscsi_pci_func_cnt);
+	return sysfs_emit(buf, "0x%04X\n", ha->iscsi_pci_func_cnt);
 }
=20
 static ssize_t
@@ -253,7 +253,7 @@ qla4xxx_hba_model_show(struct device *dev, struct devi=
ce_attribute *attr,
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
=20
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->model_name);
+	return sysfs_emit(buf, "%s\n", ha->model_name);
 }
=20
 static ssize_t
@@ -261,8 +261,8 @@ qla4xxx_fw_timestamp_show(struct device *dev, struct d=
evice_attribute *attr,
 			  char *buf)
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s %s\n", ha->fw_info.fw_build_date,
-			ha->fw_info.fw_build_time);
+	return sysfs_emit(buf, "%s %s\n", ha->fw_info.fw_build_date,
+			  ha->fw_info.fw_build_time);
 }
=20
 static ssize_t
@@ -270,7 +270,7 @@ qla4xxx_fw_build_user_show(struct device *dev, struct =
device_attribute *attr,
 			   char *buf)
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->fw_info.fw_build_user);
+	return sysfs_emit(buf, "%s\n", ha->fw_info.fw_build_user);
 }
=20
 static ssize_t
@@ -278,7 +278,7 @@ qla4xxx_fw_ext_timestamp_show(struct device *dev, stru=
ct device_attribute *attr,
 			      char *buf)
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->fw_info.extended_timestamp);
+	return sysfs_emit(buf, "%s\n", ha->fw_info.extended_timestamp);
 }
=20
 static ssize_t
@@ -300,7 +300,7 @@ qla4xxx_fw_load_src_show(struct device *dev, struct de=
vice_attribute *attr,
 		break;
 	}
=20
-	return snprintf(buf, PAGE_SIZE, "%s\n", load_src);
+	return sysfs_emit(buf, "%s\n", load_src);
 }
=20
 static ssize_t
@@ -309,8 +309,8 @@ qla4xxx_fw_uptime_show(struct device *dev, struct devi=
ce_attribute *attr,
 {
 	struct scsi_qla_host *ha =3D to_qla_host(class_to_shost(dev));
 	qla4xxx_about_firmware(ha);
-	return snprintf(buf, PAGE_SIZE, "%u.%u secs\n", ha->fw_uptime_secs,
-			ha->fw_uptime_msecs);
+	return sysfs_emit(buf, "%u.%u secs\n", ha->fw_uptime_secs,
+			  ha->fw_uptime_msecs);
 }
=20
 static DEVICE_ATTR(fw_version, S_IRUGO, qla4xxx_fw_version_show, NULL);
=2D-=20
2.43.0

