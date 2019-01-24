From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [<PATCH v1> 1/1] scsi: qcom-ufs: Add support for bus voting using ICB framework
Date: Thu, 24 Jan 2019 12:31:02 +0530
Message-ID: <d6aa4d9bd29bbb2c3ee78e6635d4704e4113a26e.1548312692.git.asutoshd@codeaurora.org>
References: <cover.1548312692.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1548312692.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1548312692.git.asutoshd@codeaurora.org>
References: <cover.1548312692.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Asutosh Das <asutoshd@codeaurora.org>, linux-arm-msm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Adapt to the new ICB framework for bus bandwidth voting.

This requires the source/destination port ids.
Also this requires a tuple of values.

The tuple is for two different paths - from UFS master
to BIMC slave. The other is from CPU master to UFS slave.
This tuple consists of the average and peak bandwidth.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  12 ++
 drivers/scsi/ufs/ufs-qcom.c                        | 234 ++++++++++++++++-----
 drivers/scsi/ufs/ufs-qcom.h                        |  20 ++
 3 files changed, 218 insertions(+), 48 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index a99ed55..94249ef 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -45,6 +45,18 @@ Optional properties:
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
 
+* Following bus parameters are required:
+interconnects
+interconnect-names
+- Please refer to Documentation/devicetree/bindings/interconnect/
+  for more details on the above.
+qcom,msm-bus,name - string describing the bus path
+qcom,msm-bus,num-cases - number of configurations in which ufs can operate in
+qcom,msm-bus,num-paths - number of paths to vote for
+qcom,msm-bus,vectors-KBps - Takes a tuple <ib ab>, <ib ab> (2 tuples for 2 num-paths)
+			    The number of these entries *must* be same as
+			    num-cases.
+
 Example:
 	ufshc@0xfc598000 {
 		compatible = "jedec,ufs-1.1";
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2b38db2..213e975 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
+#include <linux/interconnect.h>
 #include <linux/phy/phy-qcom-ufs.h>
 
 #include "ufshcd.h"
@@ -27,6 +28,10 @@
 #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
 	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
 
+#define UFS_DDR "ufs-ddr"
+#define CPU_UFS "cpu-ufs"
+
+
 enum {
 	TSTBUS_UAWM,
 	TSTBUS_UARM,
@@ -714,7 +719,6 @@ static int ufs_qcom_get_pwr_dev_param(struct ufs_qcom_dev_params *qcom_param,
 	return 0;
 }
 
-#ifdef CONFIG_MSM_BUS_SCALING
 static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
 		const char *speed_mode)
 {
@@ -768,24 +772,83 @@ static void ufs_qcom_get_speed_mode(struct ufs_pa_layer_attr *p, char *result)
 	}
 }
 
+static int ufs_qcom_get_ib_ab(struct ufs_qcom_host *host, int index,
+			      struct qcom_bus_vectors *ufs_ddr_vec,
+			      struct qcom_bus_vectors *cpu_ufs_vec)
+{
+	struct qcom_bus_path *usecase;
+
+	if (!host->qbsd)
+		return -EINVAL;
+
+	if (index > host->qbsd->num_usecase)
+		return -EINVAL;
+
+	usecase = host->qbsd->usecase;
+
+	/*
+	 *
+	 * usecase:0  usecase:0
+	 * ufs->ddr   cpu->ufs
+	 * |vec[0&1] | vec[2&3]|
+	 * +----+----+----+----+
+	 * | ab | ib | ab | ib |
+	 * |----+----+----+----+
+	 * .
+	 * .
+	 * .
+	 * usecase:n  usecase:n
+	 * ufs->ddr   cpu->ufs
+	 * |vec[0&1] | vec[2&3]|
+	 * +----+----+----+----+
+	 * | ab | ib | ab | ib |
+	 * |----+----+----+----+
+	 */
+
+	/* index refers to offset in usecase */
+	ufs_ddr_vec->ab = usecase[index].vec[0].ab;
+	ufs_ddr_vec->ib = usecase[index].vec[0].ib;
+
+	cpu_ufs_vec->ab = usecase[index].vec[1].ab;
+	cpu_ufs_vec->ib = usecase[index].vec[1].ib;
+
+	return 0;
+}
+
 static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote)
 {
 	int err = 0;
+	struct qcom_bus_scale_data *d = host->qbsd;
+	struct qcom_bus_vectors path0, path1;
+	struct device *dev = host->hba->dev;
 
-	if (vote != host->bus_vote.curr_vote) {
-		err = msm_bus_scale_client_update_request(
-				host->bus_vote.client_handle, vote);
-		if (err) {
-			dev_err(host->hba->dev,
-				"%s: msm_bus_scale_client_update_request() failed: bus_client_handle=0x%x, vote=%d, err=%d\n",
-				__func__, host->bus_vote.client_handle,
-				vote, err);
-			goto out;
-		}
+	err = ufs_qcom_get_ib_ab(host, vote, &path0, &path1);
+	if (err) {
+		dev_err(dev, "Error: failed (%d) to get ib/ab\n",
+			err);
+		return err;
+	}
 
-		host->bus_vote.curr_vote = vote;
+	dev_dbg(dev, "Setting vote: %d: ufs-ddr: ab: %llu ib: %llu\n", vote,
+		path0.ab, path0.ib);
+	err = icc_set_bw(d->ufs_ddr, path0.ab, path0.ib);
+	if (err) {
+		dev_err(dev, "Error: (%d) failed setting (%s) bus vote\n", err,
+			UFS_DDR);
+		return err;
 	}
-out:
+
+	dev_dbg(dev, "Setting: cpu-ufs: ab: %llu ib: %llu\n", path1.ab,
+		path1.ib);
+	err = icc_set(d->cpu_ufs, path1.ab, path1.ib);
+	if (err) {
+		dev_err(dev, "Error: (%d) failed setting (%s) bus vote\n", err,
+			CPU_UFS);
+		return err;
+	}
+
+	host->bus_vote.curr_vote = vote;
+
 	return err;
 }
 
@@ -807,6 +870,7 @@ static int ufs_qcom_update_bus_bw_vote(struct ufs_qcom_host *host)
 		dev_err(host->hba->dev, "%s: failed %d\n", __func__, err);
 	else
 		host->bus_vote.saved_vote = vote;
+
 	return err;
 }
 
@@ -837,34 +901,114 @@ static int ufs_qcom_update_bus_bw_vote(struct ufs_qcom_host *host)
 	return count;
 }
 
+static struct qcom_bus_scale_data *ufs_qcom_get_bus_scale_data(struct device
+							       *dev)
+
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct device_node *of_node = dev->of_node;
+	struct qcom_bus_scale_data *qsd;
+	struct qcom_bus_path *usecase = NULL;
+	int ret = 0, i = 0, j, num_paths, len;
+	const uint32_t *vec_arr = NULL;
+	bool mem_err = false;
+
+	if (!pdev) {
+		dev_err(dev, "Null platform device!\n");
+		return NULL;
+	}
+
+	qsd = devm_kzalloc(dev, sizeof(struct qcom_bus_scale_data), GFP_KERNEL);
+	if (!qsd)
+		return NULL;
+
+	ret = of_property_read_string(of_node, "qcom,msm-bus,name", &qsd->name);
+	if (ret) {
+		dev_err(dev, "Error: (%d) Bus name missing!\n", ret);
+		return NULL;
+	}
+
+	ret = of_property_read_u32(of_node, "qcom,msm-bus,num-cases",
+		&qsd->num_usecase);
+	if (ret) {
+		pr_err("Error: num-usecases not found\n");
+		goto err;
+	}
+
+	usecase = devm_kzalloc(dev, (sizeof(struct qcom_bus_path) *
+				   qsd->num_usecase), GFP_KERNEL);
+	if (!usecase)
+		return NULL;
+
+	ret = of_property_read_u32(of_node, "qcom,msm-bus,num-paths",
+				   &num_paths);
+	if (ret) {
+		pr_err("Error: num_paths not found\n");
+		return NULL;
+	}
+
+	vec_arr = of_get_property(of_node, "qcom,msm-bus,vectors-KBps", &len);
+	if (vec_arr == NULL) {
+		pr_err("Error: Vector array not found\n");
+		return NULL;
+	}
+
+	for (i = 0; i < qsd->num_usecase; i++) {
+		usecase[i].num_paths = num_paths;
+		usecase[i].vec = devm_kzalloc(dev, num_paths *
+					      sizeof(struct qcom_bus_vectors),
+					      GFP_KERNEL);
+		if (!usecase[i].vec) {
+			mem_err = true;
+			dev_err(dev, "Error: Failed to alloc mem for vectors\n");
+			goto err;
+		}
+
+		for (j = 0; j < num_paths; j++) {
+			int idx = ((i * num_paths) + j) * 2;
+
+			usecase[i].vec[j].ab = (uint64_t)
+				be32_to_cpu(vec_arr[idx]);
+			usecase[i].vec[j].ib = (uint64_t)
+				be32_to_cpu(vec_arr[idx + 1]);
+		}
+	}
+
+	qsd->usecase = usecase;
+	return qsd;
+err:
+	if (mem_err) {
+		for (; i > 0; i--)
+			kfree(usecase[i].vec);
+	}
+	return NULL;
+}
+
 static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
 {
 	int err;
-	struct msm_bus_scale_pdata *bus_pdata;
 	struct device *dev = host->hba->dev;
-	struct platform_device *pdev = to_platform_device(dev);
-	struct device_node *np = dev->of_node;
+	struct qcom_bus_scale_data *qsd;
 
-	bus_pdata = msm_bus_cl_get_pdata(pdev);
-	if (!bus_pdata) {
-		dev_err(dev, "%s: failed to get bus vectors\n", __func__);
-		err = -ENODATA;
-		goto out;
+	qsd = ufs_qcom_get_bus_scale_data(dev);
+	if (!qsd) {
+		dev_err(dev, "Failed: getting bus_scale data\n");
+		return 0;
 	}
+	host->qbsd = qsd;
 
-	err = of_property_count_strings(np, "qcom,bus-vector-names");
-	if (err < 0 || err != bus_pdata->num_usecases) {
-		dev_err(dev, "%s: qcom,bus-vector-names not specified correctly %d\n",
-				__func__, err);
-		goto out;
+	qsd->ufs_ddr = of_icc_get(dev, UFS_DDR);
+	if (IS_ERR(qsd->ufs_ddr)) {
+		dev_err(dev, "Error: (%d) failed getting %s path\n",
+			PTR_ERR(qsd->ufs_ddr), UFS_DDR);
+		return PTR_ERR(qsd->ufs_ddr);
 	}
 
-	host->bus_vote.client_handle = msm_bus_scale_register_client(bus_pdata);
-	if (!host->bus_vote.client_handle) {
-		dev_err(dev, "%s: msm_bus_scale_register_client failed\n",
-				__func__);
-		err = -EFAULT;
-		goto out;
+	qsd->cpu_ufs = of_icc_get(dev, CPU_UFS);
+	if (IS_ERR(qsd->cpu_ufs)) {
+		dev_err(dev, "Error: (%d) failed getting %s path\n",
+			PTR_ERR(qsd->cpu_ufs), CPU_UFS);
+		return PTR_ERR(qsd->cpu_ufs);
 	}
 
 	/* cache the vote index for minimum and maximum bandwidth */
@@ -877,25 +1021,19 @@ static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
 	host->bus_vote.max_bus_bw.attr.name = "max_bus_bw";
 	host->bus_vote.max_bus_bw.attr.mode = S_IRUGO | S_IWUSR;
 	err = device_create_file(dev, &host->bus_vote.max_bus_bw);
-out:
-	return err;
-}
-#else /* CONFIG_MSM_BUS_SCALING */
-static int ufs_qcom_update_bus_bw_vote(struct ufs_qcom_host *host)
-{
-	return 0;
-}
+	if (err)
+		dev_err(dev, "Error: (%d) Failed to create sysfs entries\n",
+			err);
 
-static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote)
-{
-	return 0;
-}
+	/* Full throttle */
+	err = ufs_qcom_set_bus_vote(host, host->bus_vote.max_bw_vote);
+	if (err)
+		dev_err(dev, "Error: (%d) Failed to set max bus vote\n", err);
 
-static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
-{
-	return 0;
+	dev_info(dev, "-- (%s) Registered bus voting! (%d) --\n", err);
+
+	return err;
 }
-#endif /* CONFIG_MSM_BUS_SCALING */
 
 static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
 {
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 295f4be..02140bd 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -207,6 +207,25 @@ struct ufs_qcom_testbus {
 	u8 select_minor;
 };
 
+struct qcom_bus_vectors {
+	uint64_t ab;
+	uint64_t ib;
+};
+
+struct qcom_bus_path {
+	unsigned int num_paths;
+	struct qcom_bus_vectors *vec;
+};
+
+struct qcom_bus_scale_data {
+	struct qcom_bus_path *usecase;
+	unsigned int num_usecase;
+	struct icc_path *ufs_ddr;
+	struct icc_path *cpu_ufs;
+
+	const char *name;
+};
+
 struct ufs_qcom_host {
 	/*
 	 * Set this capability if host controller supports the QUniPro mode
@@ -242,6 +261,7 @@ struct ufs_qcom_host {
 	/* Bitmask for enabling debug prints */
 	u32 dbg_print_en;
 	struct ufs_qcom_testbus testbus;
+	struct qcom_bus_scale_data *qbsd;
 };
 
 static inline u32
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
