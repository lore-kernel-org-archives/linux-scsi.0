From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.18-rc6
Date: Fri, 28 Nov 2014 23:48:50 -0800
Message-ID: <1417247330.2202.33.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42144 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbaK2Hsw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2014 02:48:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of ten fixes: 8 for UFS including four static checker
warnings, a potential null deref in the voltage regulator code, a race
on module unload, a ref counting fix on the well known LUNs which made
it impossible to remove the ufs module and fix to correct the
information in pwr_info.  In addition to UFS, there's a blacklist for
the Intel Multi-Flex array which chokes on report supported operation
codes and a fix to an oops in bnx2fc caused by shared skbs.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Akinobu Mita (3):
      ufs: fix NULL dereference when no regulators are defined
      ufs: ensure clk gating work is finished before module unloading
      ufs: fix reference counting of W-LUs

Christian S=C3=BCnkenberg (1):
      scsi: add Intel Multi-Flex to scsi scan blacklist

Dolev Raviv (4):
      scsi: ufs: fix static checker warning in ufshcd_parse_clock_info
      scsi: ufs: fix static checker warning in __ufshcd_setup_clocks
      scsi: ufs: fix static checker warning in ufshcd_populate_vreg
      scsi: ufs: fix static checker errors in ufshcd_system_suspend

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Yaniv Gardi (1):
      ufs: fix power info after link start-up

and the diffstat:

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   7 +++
 drivers/scsi/scsi_devinfo.c       |   1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c  |  15 ++----
 drivers/scsi/ufs/ufshcd.c         | 104 +++++++++++++++++++++++-------=
--------
 drivers/scsi/ufs/ufshcd.h         |   2 -
 5 files changed, 77 insertions(+), 52 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bn=
x2fc_fcoe.c
index 79e5c94..72533c5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -412,6 +412,7 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct n=
et_device *dev,
 	struct fc_frame_header *fh;
 	struct fcoe_rcv_info *fr;
 	struct fcoe_percpu_s *bg;
+	struct sk_buff *tmp_skb;
 	unsigned short oxid;
=20
 	interface =3D container_of(ptype, struct bnx2fc_interface,
@@ -424,6 +425,12 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct =
net_device *dev,
 		goto err;
 	}
=20
+	tmp_skb =3D skb_share_check(skb, GFP_ATOMIC);
+	if (!tmp_skb)
+		goto err;
+
+	skb =3D tmp_skb;
+
 	if (unlikely(eth_hdr(skb)->h_proto !=3D htons(ETH_P_FCOE))) {
 		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
 		goto err;
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 49014a1..c1d04d4 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -202,6 +202,7 @@ static struct {
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
+	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIR=
Y_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd=
-pltfrm.c
index 8adf067..1c3467b 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -102,7 +102,6 @@ static int ufshcd_parse_clock_info(struct ufs_hba *=
hba)
 	clkfreq =3D devm_kzalloc(dev, sz * sizeof(*clkfreq),
 			GFP_KERNEL);
 	if (!clkfreq) {
-		dev_err(dev, "%s: no memory\n", "freq-table-hz");
 		ret =3D -ENOMEM;
 		goto out;
 	}
@@ -112,19 +111,19 @@ static int ufshcd_parse_clock_info(struct ufs_hba=
 *hba)
 	if (ret && (ret !=3D -EINVAL)) {
 		dev_err(dev, "%s: error reading array %d\n",
 				"freq-table-hz", ret);
-		goto free_clkfreq;
+		return ret;
 	}
=20
 	for (i =3D 0; i < sz; i +=3D 2) {
 		ret =3D of_property_read_string_index(np,
 				"clock-names", i/2, (const char **)&name);
 		if (ret)
-			goto free_clkfreq;
+			goto out;
=20
 		clki =3D devm_kzalloc(dev, sizeof(*clki), GFP_KERNEL);
 		if (!clki) {
 			ret =3D -ENOMEM;
-			goto free_clkfreq;
+			goto out;
 		}
=20
 		clki->min_freq =3D clkfreq[i];
@@ -134,8 +133,6 @@ static int ufshcd_parse_clock_info(struct ufs_hba *=
hba)
 				clki->min_freq, clki->max_freq, clki->name);
 		list_add_tail(&clki->list, &hba->clk_list_head);
 	}
-free_clkfreq:
-	kfree(clkfreq);
 out:
 	return ret;
 }
@@ -162,10 +159,8 @@ static int ufshcd_populate_vreg(struct device *dev=
, const char *name,
 	}
=20
 	vreg =3D devm_kzalloc(dev, sizeof(*vreg), GFP_KERNEL);
-	if (!vreg) {
-		dev_err(dev, "No memory for %s regulator\n", name);
-		goto out;
-	}
+	if (!vreg)
+		return -ENOMEM;
=20
 	vreg->name =3D kstrdup(name, GFP_KERNEL);
=20
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 497c38a..605ca60 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -744,6 +744,8 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *=
hba)
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 	device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
+	cancel_work_sync(&hba->clk_gating.ungate_work);
+	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
 }
=20
 /* Must be called with host lock acquired */
@@ -2246,6 +2248,22 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hb=
a *hba)
 	return ret;
 }
=20
+ /**
+ * ufshcd_init_pwr_info - setting the POR (power on reset)
+ * values in hba power info
+ * @hba: per-adapter instance
+ */
+static void ufshcd_init_pwr_info(struct ufs_hba *hba)
+{
+	hba->pwr_info.gear_rx =3D UFS_PWM_G1;
+	hba->pwr_info.gear_tx =3D UFS_PWM_G1;
+	hba->pwr_info.lane_rx =3D 1;
+	hba->pwr_info.lane_tx =3D 1;
+	hba->pwr_info.pwr_rx =3D SLOWAUTO_MODE;
+	hba->pwr_info.pwr_tx =3D SLOWAUTO_MODE;
+	hba->pwr_info.hs_rate =3D 0;
+}
+
 /**
  * ufshcd_get_max_pwr_mode - reads the max power mode negotiated with =
device
  * @hba: per-adapter instance
@@ -2844,8 +2862,13 @@ static void ufshcd_slave_destroy(struct scsi_dev=
ice *sdev)
 	hba =3D shost_priv(sdev->host);
 	scsi_deactivate_tcq(sdev, hba->nutrs);
 	/* Drop the reference as it won't be needed anymore */
-	if (ufshcd_scsi_to_upiu_lun(sdev->lun) =3D=3D UFS_UPIU_UFS_DEVICE_WLU=
N)
+	if (ufshcd_scsi_to_upiu_lun(sdev->lun) =3D=3D UFS_UPIU_UFS_DEVICE_WLU=
N) {
+		unsigned long flags;
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->sdev_ufs_device =3D NULL;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 }
=20
 /**
@@ -4062,6 +4085,8 @@ static void ufshcd_init_icc_levels(struct ufs_hba=
 *hba)
 static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 {
 	int ret =3D 0;
+	struct scsi_device *sdev_rpmb;
+	struct scsi_device *sdev_boot;
=20
 	hba->sdev_ufs_device =3D __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
@@ -4070,26 +4095,27 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba =
*hba)
 		hba->sdev_ufs_device =3D NULL;
 		goto out;
 	}
+	scsi_device_put(hba->sdev_ufs_device);
=20
-	hba->sdev_boot =3D __scsi_add_device(hba->host, 0, 0,
+	sdev_boot =3D __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
-	if (IS_ERR(hba->sdev_boot)) {
-		ret =3D PTR_ERR(hba->sdev_boot);
-		hba->sdev_boot =3D NULL;
+	if (IS_ERR(sdev_boot)) {
+		ret =3D PTR_ERR(sdev_boot);
 		goto remove_sdev_ufs_device;
 	}
+	scsi_device_put(sdev_boot);
=20
-	hba->sdev_rpmb =3D __scsi_add_device(hba->host, 0, 0,
+	sdev_rpmb =3D __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
-	if (IS_ERR(hba->sdev_rpmb)) {
-		ret =3D PTR_ERR(hba->sdev_rpmb);
-		hba->sdev_rpmb =3D NULL;
+	if (IS_ERR(sdev_rpmb)) {
+		ret =3D PTR_ERR(sdev_rpmb);
 		goto remove_sdev_boot;
 	}
+	scsi_device_put(sdev_rpmb);
 	goto out;
=20
 remove_sdev_boot:
-	scsi_remove_device(hba->sdev_boot);
+	scsi_remove_device(sdev_boot);
 remove_sdev_ufs_device:
 	scsi_remove_device(hba->sdev_ufs_device);
 out:
@@ -4097,30 +4123,6 @@ out:
 }
=20
 /**
- * ufshcd_scsi_remove_wlus - Removes the W-LUs which were added by
- *			     ufshcd_scsi_add_wlus()
- * @hba: per-adapter instance
- *
- */
-static void ufshcd_scsi_remove_wlus(struct ufs_hba *hba)
-{
-	if (hba->sdev_ufs_device) {
-		scsi_remove_device(hba->sdev_ufs_device);
-		hba->sdev_ufs_device =3D NULL;
-	}
-
-	if (hba->sdev_boot) {
-		scsi_remove_device(hba->sdev_boot);
-		hba->sdev_boot =3D NULL;
-	}
-
-	if (hba->sdev_rpmb) {
-		scsi_remove_device(hba->sdev_rpmb);
-		hba->sdev_rpmb =3D NULL;
-	}
-}
-
-/**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
  *
@@ -4134,6 +4136,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
=20
+	ufshcd_init_pwr_info(hba);
+
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
=20
@@ -4264,12 +4268,18 @@ static int ufshcd_config_vreg_load(struct devic=
e *dev, struct ufs_vreg *vreg,
 static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
 }
=20
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
=20
@@ -4471,7 +4481,7 @@ out:
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
-	} else if (!ret && on) {
+	} else if (on) {
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->clk_gating.state =3D CLKS_ON;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -4675,11 +4685,25 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_h=
ba *hba,
 {
 	unsigned char cmd[6] =3D { START_STOP };
 	struct scsi_sense_hdr sshdr;
-	struct scsi_device *sdp =3D hba->sdev_ufs_device;
+	struct scsi_device *sdp;
+	unsigned long flags;
 	int ret;
=20
-	if (!sdp || !scsi_device_online(sdp))
-		return -ENODEV;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	sdp =3D hba->sdev_ufs_device;
+	if (sdp) {
+		ret =3D scsi_device_get(sdp);
+		if (!ret && !scsi_device_online(sdp)) {
+			ret =3D -ENODEV;
+			scsi_device_put(sdp);
+		}
+	} else {
+		ret =3D -ENODEV;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (ret)
+		return ret;
=20
 	/*
 	 * If scsi commands fail, the scsi mid-layer schedules scsi error-
@@ -4718,6 +4742,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba=
 *hba,
 	if (!ret)
 		hba->curr_dev_pwr_mode =3D pwr_mode;
 out:
+	scsi_device_put(sdp);
 	hba->host->eh_noresume =3D 0;
 	return ret;
 }
@@ -5087,7 +5112,7 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret =3D 0;
=20
 	if (!hba || !hba->is_powered)
-		goto out;
+		return 0;
=20
 	if (pm_runtime_suspended(hba->dev)) {
 		if (hba->rpm_lvl =3D=3D hba->spm_lvl)
@@ -5231,7 +5256,6 @@ EXPORT_SYMBOL(ufshcd_shutdown);
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	scsi_remove_host(hba->host);
-	ufshcd_scsi_remove_wlus(hba);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 58ecdff..4a574aa 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -392,8 +392,6 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
-	struct scsi_device *sdev_rpmb;
-	struct scsi_device *sdev_boot;
=20
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
