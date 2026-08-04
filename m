Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52313E92BD
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 14:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785853722; cv=none; b=XD97rk2KGGGmcebcv+dihC43gbdCi24mxORTqUm1UJXCGL2pmlYNxjZwLBMGEbWwPzCWNIOycDP6nnlxGlUghRuqakFjQ5ToLUFuhVdpCQEa0O8dr87y+sS43g91cJouGwYPTLUQT8uH0PWesKSL9ElAljNSte/LuTiERM+0vg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785853722; c=relaxed/simple;
	bh=bsWjYObHJsXoFHI/HjZRmVWuqy426x5I9O0ER1ILobI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l4uaVIcjaRPyWYrwgROMxqlLSiidA7WdmVgeDXANGy7Ek+D2Qi50P2sjU1WbXQVuSSArakWBocW11yyjU2xGvs18JXQ1Wlinbd18ukQ4bsTaBpgozXvKoSNAIWwsYL85/YZQfWLOztfjxTaOoLUDVzhRctUb4zpxLZENWcbqVOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p0LkBHId; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p0LkBHId"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aec6360133so4177678e87.1
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 07:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785853705; x=1786458505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gll1NPiGFUih/ZjZ/8FSJN48lAj1cn9L2KE3KQ17M6w=;
        b=p0LkBHId3vFPAzTlntEaxN4wpJUJZkp26FCCzOXdm62kPt1DuvwgWsMDdLkU2T5mpp
         iaUcEB2EJGUGXyQ3K3A2eW+tLnnqGGj7v2FJMl6ZKawHDgyQrTUU+J9PWM9vd43VQesC
         Sks9ZAgAQTU4z6lcM6WNcpPYJCx4E5agrbA447fA0hJzDmPVAjY7aagDIF6HN9bLemg8
         ibKSmG9DFB+fFCE0VeUBgwygpfPa7FuzTbBApqmYP1gDXcEfUq6C7kKHB1Jgww/FgChQ
         krCnGZAa5qsy7xBkkEsxqb7gqKwLscVwSAZJRctoqITlDWYApYds+9ngwgKL63Rkd0Tt
         vZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785853705; x=1786458505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gll1NPiGFUih/ZjZ/8FSJN48lAj1cn9L2KE3KQ17M6w=;
        b=sTowc3p1lP3vIHLfyTtFy7LqSZWZk45r2fmfX0AsWsqPBjZPCTayiVeMoVl76ywlfp
         gozd5vKYPmNbqupmIL9btZ8ip2G5//iyeMXoDISAQaj6Nv0lQoIyEdrMsCS6LAnaCKcB
         DDQ5mJULvqvAUgbXO6pMjPQS84zZppRCeGYXnyaR7DMwpKGFcoM3vn2w8r9DXdlKX48A
         US2TmQ+EH5TvC5t89whIAN7MQuE0tJKaHQsDKW/d8MbNJ47ELQvVqFsWFAoP39KW7DnP
         poYgc+f8BPMbXHi1XOSyoGSzb4mytkVQjEnl1qynaytTUoG1LtjZq2KOfzNOFHsxJ6cb
         M6+Q==
X-Forwarded-Encrypted: i=1; AHgh+Rorqq7JswOl596g61soVFsDgrUtmDnHHMA/fZgakJUMeb23HWf1PYgjclbR9B/Z4nOd/rMn6U4RRvjm@vger.kernel.org
X-Gm-Message-State: AOJu0YxgKs7Ndg24TAgROaYIOMab7aYs0ll6oXa0ZoQ5rJfWl+/PXIYA
	U6zy7jzh2lGm40bG7wzjlmrOnlX+68FhRFB37tCkiN2f+CVK8jk6ggMc
X-Gm-Gg: AR+sD10mscCsrgA/qoMFhrvKEpS/YjZPmsyuw1CIt0LBTmz7hsGO+OjDxKk8XywfjhB
	Qoi0TUDY0C7qiAl5F4rjEhy5eT+zGiOFr6TbD888rD3181qwZB1RI1HwAK+I3iSoXP5KPAReSHv
	gy/B/sYK1FzcejEbJ381IKaG9fOik827DWyOGxKe5ur9K6mNUIsgLqGDerCrEDeA3m7vfi5ImkL
	xU+XApqjrhtXEvADpk/af2wJxirMyiNZ/oO5N7nwPUkdgKhCH5+wfQbtQ4DQzYOYpZtUP6hN6JT
	9EIXfwG6Gv18bTlzc2DdEtWFmp+p7IC6L0Sg71k94gdDjX9IwXeeGPuHXxbrqt81sY0jziZCQfq
	edshqAjV8Da4APf+YYOOl5se3T2Ggo50V3Hj0pY0yD/3ekm0S6Ju555E2BB31V4qWKtpc8us6Yg
	AtjxSfQgurSZubBaZFFy6mEVOVskCBWsTmI3f8aodLewB33tGl5gGa54K2N5oBJEM5VKlKHTvNO
	DCFrprCs8l+7l9X
X-Received: by 2002:a05:6512:3e03:b0:5b2:f437:2a88 with SMTP id 2adb3069b0e04-5b2f4372c35mr139220e87.36.1785853704781;
        Tue, 04 Aug 2026 07:28:24 -0700 (PDT)
Received: from NB-9797.corp.yadro.com ([89.207.88.244])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e245c435sm2647990e87.82.2026.08.04.07.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:28:24 -0700 (PDT)
From: Ilya Khomyakov <khomyakovilya@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	regressions@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: [PATCH] scsi: mpi3mr: use DevicePage0 link rate only for direct-attached targets
Date: Tue,  4 Aug 2026 17:28:00 +0300
Message-ID: <20260804142800.4326-1-khomyakovilya@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes a regression in the Broadcom MPI3 Storage Controller
driver under drivers/scsi/mpi3mr/.

Commit c273c14b0294 ("scsi: mpi3mr: Use negotiated link rate from
DevicePage0") changed mpi3mr to prefer the cached DevicePage0 rate.

DevicePage0 stores negotiated_link_rate as one standalone MPI3 SAS
link-rate code, while SAS PHY Page 0 and SAS Expander Page 1 store logical
and physical rates as two nibbles of one packed byte.

mpi3mr_get_sas_negotiated_logical_linkrate() currently sends both formats
through the same high-nibble extraction at its common exit. A valid
DevicePage0 value of 0x0b or 0x0c is therefore converted to zero. The later
minimum-rate safeguard then publishes the value as 1.5 Gbit/s.

For example:

  DevicePage0 value:            0x0b
  packed-field extraction:      (0x0b & 0xf0) >> 4 = 0x00
  minimum-rate substitution:    0x00 -> 0x08
  Linux SAS transport result:   1.5 Gbit/s

There is also a topology distinction. The caller uses the returned value to
update the parent sas_phy. In an expander topology with the HBA-to-expander
link limited to 12 Gbit/s, DevicePage0 reported 0x0b for every tested
target, while Expander Page 1 reported 0xcc for several disk-facing PHYs
that were operating at 22.5 Gbit/s. The cached target value therefore
cannot unconditionally replace the local parent expander PHY value.

The original failure was reproduced on an eHBA 9600 controller with a
SAS4016 IOC and a 46-PHY Microchip expander. Before the fix, a target with
DevicePage0 negotiated_link_rate 0x0b could remain visible in sysfs as
1.5 Gbit/s when a replayed topology event contained current=0x0b and
previous=0x0b and therefore skipped the Linux-side update.

Validate the standalone DevicePage0 code and use it directly only for a
directly attached target. For an expander-attached target, retain the
existing Expander Page 1 path because it describes the local parent
expander PHY being updated. Retain the SAS PHY Page 0 fallback when a
directly attached cached value is invalid.

The topology-aware variant was tested in an out-of-tree mpi3mr 8.17.1.0.
build. After boot, Linux reported:

  PHY 18: 12.0 Gbit/s
  PHY 19: 12.0 Gbit/s
  PHY 24: 22.5 Gbit/s
  PHY 25: 22.5 Gbit/s
  PHY 26: 22.5 Gbit/s
  PHY 27: 22.5 Gbit/s
  PHY 28: 12.0 Gbit/s
  PHY 30: 22.5 Gbit/s

No tested PHY was incorrectly reported as 1.5 Gbit/s, and the 22.5 Gbit/s
disk-facing rates were preserved even though DevicePage0 contained 0x0b.

Fixes: c273c14b0294 ("scsi: mpi3mr: Use negotiated link rate from DevicePage0")
Signed-off-by: Ilya Khomyakov <khomyakovilya@gmail.com>

---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 46 ++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a..740fccc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -587,6 +587,30 @@ static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
 	return rc;
 }
 
+/**
+ * mpi3mr_sas_link_rate_valid - validate a standalone SAS link-rate code
+ * @link_rate: MPI3 standalone SAS negotiated link-rate code
+ *
+ * DevicePage0 stores one plain negotiated link-rate code. Accept only
+ * negotiated data rates supported by the SAS transport conversion code;
+ * reserved or transitional values must use the existing PHY-page path.
+ *
+ * Return: true for a supported negotiated data rate, false otherwise.
+ */
+static bool mpi3mr_sas_link_rate_valid(u8 link_rate)
+{
+	switch (link_rate) {
+	case MPI3_SAS_NEG_LINK_RATE_1_5:
+	case MPI3_SAS_NEG_LINK_RATE_3_0:
+	case MPI3_SAS_NEG_LINK_RATE_6_0:
+	case MPI3_SAS_NEG_LINK_RATE_12_0:
+	case MPI3_SAS_NEG_LINK_RATE_22_5:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * mpi3mr_delete_sas_phy - Remove a single phy from port
  * @mrioc: Adapter instance reference
@@ -2292,18 +2316,26 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 static u8 mpi3mr_get_sas_negotiated_logical_linkrate(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_tgt_dev *tgtdev)
 {
-	u8 link_rate = MPI3_SAS_NEG_LINK_RATE_1_5, phy_number;
+	u8 cached_link_rate, link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
+	u8 phy_number;
 	struct mpi3_sas_expander_page1 expander_pg1;
 	struct mpi3_sas_phy_page0 phy_pg0;
 	u32 phynum_handle;
 	u16 ioc_status;
 
-	/* First, try to use link rate from DevicePage0 (populated by firmware) */
-	if (tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate >=
-	    MPI3_SAS_NEG_LINK_RATE_1_5) {
-		link_rate = tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate;
-		goto out;
-	}
+	cached_link_rate =
+		tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate;
+
+	/*
+	 * For a directly attached target, DevicePage0 and the parent host PHY
+	 * describe the same link, so the standalone cached code can be used
+	 * without packed-field decoding. For an expander-attached target, the
+	 * caller updates the parent expander PHY and DevicePage0 can differ from
+	 * that local segment; retain the Expander Page 1 read in that case.
+	 */
+	if ((tgtdev->devpg0_flag & MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED) &&
+	    mpi3mr_sas_link_rate_valid(cached_link_rate))
+		return cached_link_rate;
 
 	/* Fallback to reading from phy pages if DevicePage0 value not available */
 	phy_number = tgtdev->dev_spec.sas_sata_inf.phy_id;
