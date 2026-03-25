Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F441379EDF;
	Wed, 25 Mar 2026 07:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774424700; cv=none; b=YfiXfTHxw8P+MV+zEJnLyu3KsLJrKaKvVDo1dM/DtnlkgYLhWNu78Es2DTfnSDkU8Te/xgpLYj7CxCJGfq1uF77JJMOg4/ywlPMgydldwTfFu5WC8kmzEESh11pI9p7W6EcTunqu1Km08ZyWeMuo4Wfnrd7LBSMdPRZzAR6loSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774424700; c=relaxed/simple;
	bh=TU/OFqzjt4dvTkCR4pHt2wjtA/+vw6HgDiM6NHHMtpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeP0eZxAKglhXtNuIDAEBggQ54YK3OMCUzoS2M1PT5plCsTXV321Jj3zxHB4N9xLPV4pCEygUVlM088m9Flibg1sWs1OgchXnoFCeeaxzyeiUwZ8F4wTUTrsQ82VHYLTnRQDHa0zXl95mmRBE6sXQ/hV7f+qPMsJh5M5MKWcSSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=felix.busch1@gmx.net header.b=js1k9bRA; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=felix.busch1@gmx.net header.b="js1k9bRA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1774424690; x=1775029490; i=felix.busch1@gmx.net;
	bh=NYtmW0+encGN9QePloZpAsaAIeYVTNXZPqT7gpTAWzM=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=js1k9bRA/exduZMJ3KISIJ9QZSwAkKtXffNczslyaQ2oU+xSKMyVj8R4XsgK9gPs
	 lHyI1l36zSkrwqRl7oqmHCdc5cxf7CJu6jV+zBwVEtbzKrX6R/WoLtjkdRLVFGJ84
	 yh1lNVmZjLECp0bjQxPCX0nY1GYfA//WyedHuqoAOujtDfX1H1WLvRGoukhDKZxNe
	 wFyh0M8HJCGHvcnPy2NJV7LvteFjCxQuDJxz8QzFMPDJZIc+meGIVBB+8vskt47hB
	 X94bCprd4tcZ1kz6kny1aW5uHA0RM/JyZaCpW34hhMAvD9dK0yKBi1ob2HX+n/NPc
	 3NjXh9c9jq7FyowRWg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MLzFr-1vnV3L0zHl-00Oep8; Wed, 25
 Mar 2026 08:44:50 +0100
From: Felix Busch <felix.busch1@gmx.net>
To: phil@philpotter.co.uk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Felix Busch <felix.busch1@gmx.net>
Subject: [PATCH 1/1] CD-ROM: Additional LBA bound check
Date: Wed, 25 Mar 2026 08:44:01 +0100
Message-ID: <20260325074401.6530-1-felix.busch1@gmx.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260325065335.7783-1-felix.busch1@gmx.net>
References: <20260325065335.7783-1-felix.busch1@gmx.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:t90Lp0noiEB9UPn3AP2M8D6tcFcHZgBJKjXKrk4zDhYUpGySjFy
 IWbFQuO/Pl1mJuZTfSSiyDP3GBN7yiUb0R4Exw+IqPozBS60DrlRMusrDadhtXOhfu5mcZF
 csSB8+iijVcJXtgcUGWiVWfuDxJR+fA1kl8TIxuHOl66pfi4NEjVmyRljDcbxjrv7LM7Gss
 DN2Hal+69HyyqzYLwvVGw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:pFO+QfcGHAc=;zdao84UdwXEFeBFe70W2Qw7d/Ty
 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

Upper bound check for the logical block address
in mmc_ioctl_cdrom_read_data() of the CD-ROM driver.
This prevents trying to read a block when the LBA is
greater than the number of available blocks.

Signed-off-by: Felix Busch <felix.busch1@gmx.net>
=2D--
 drivers/cdrom/cdrom.c |  7 +++++--
 drivers/scsi/sr.c     | 12 +++++++++++-
 include/linux/cdrom.h |  2 ++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index fc049612d6dc..cc0a6c0ae9e7 100644
=2D-- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2926,6 +2926,8 @@ static noinline int mmc_ioctl_cdrom_read_data(struct=
 cdrom_device_info *cdi,
 {
 	struct scsi_sense_hdr sshdr;
 	struct cdrom_msf msf;
+	const struct cdrom_device_ops *cdo =3D cdi->ops;
+	u64 nr_blocks;
 	int blocksize =3D 0, format =3D 0, lba;
 	int ret;
=20
@@ -2944,8 +2946,9 @@ static noinline int mmc_ioctl_cdrom_read_data(struct=
 cdrom_device_info *cdi,
 	if (copy_from_user(&msf, (struct cdrom_msf __user *)arg, sizeof(msf)))
 		return -EFAULT;
 	lba =3D msf_to_lba(msf.cdmsf_min0, msf.cdmsf_sec0, msf.cdmsf_frame0);
-	/* FIXME: we need upper bound checking, too!! */
-	if (lba < 0)
+	nr_blocks =3D cdo->get_capacity(cdi);
+	/* Lower and upper bound check for logical block address. */
+	if ((lba < 0) || (lba > nr_blocks - 1))
 		return -EINVAL;
=20
 	cgc->buffer =3D kzalloc(blocksize, GFP_KERNEL);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7adb2573f50d..a056c72341c4 100644
=2D-- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -120,6 +120,8 @@ static int sr_packet(struct cdrom_device_info *, struc=
t packet_command *);
 static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *u=
buf,
 		u32 lba, u32 nr, u8 *last_sense);
=20
+static u64 sr_get_nr_blocks(struct cdrom_device_info *cdi);
+
 static const struct cdrom_device_ops sr_dops =3D {
 	.open			=3D sr_open,
 	.release	 	=3D sr_release,
@@ -134,6 +136,7 @@ static const struct cdrom_device_ops sr_dops =3D {
 	.audio_ioctl		=3D sr_audio_ioctl,
 	.generic_packet		=3D sr_packet,
 	.read_cdda_bpc		=3D sr_read_cdda_bpc,
+	.get_capacity		=3D sr_get_nr_blocks,
 	.capability		=3D SR_CAPABILITIES,
 };
=20
@@ -142,6 +145,13 @@ static inline struct scsi_cd *scsi_cd(struct gendisk =
*disk)
 	return disk->private_data;
 }
=20
+static inline u64 sr_get_nr_blocks(struct cdrom_device_info *cdi)
+{
+	struct scsi_cd *cd =3D scsi_cd(cdi->disk);
+
+	return cd->capacity;
+}
+
 static int sr_runtime_suspend(struct device *dev)
 {
 	struct scsi_cd *cd =3D dev_get_drvdata(dev);
@@ -782,7 +792,7 @@ static int get_sectorsize(struct scsi_cd *cd)
 			sector_size =3D 2048;
 			fallthrough;
 		case 2048:
-			cd->capacity *=3D 4;
+			//cd->capacity *=3D 4;
 			fallthrough;
 		case 512:
 			break;
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index b907e6c2307d..406e6f4a55bb 100644
=2D-- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -91,6 +91,8 @@ struct cdrom_device_ops {
 			       struct packet_command *);
 	int (*read_cdda_bpc)(struct cdrom_device_info *cdi, void __user *ubuf,
 			       u32 lba, u32 nframes, u8 *last_sense);
+	/* Get size in blocks */
+	u64 (*get_capacity)(struct cdrom_device_info *cdi);
 /* driver specifications */
 	const int capability;   /* capability flags */
 };
=2D-=20
2.53.0

