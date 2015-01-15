From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: Re: [PATCH v7 5/5] scsi: ufs-qcom-ice: add Inline Crypto Engine
 (ICE) support for UFS
Date: Thu, 15 Jan 2015 15:21:13 -0000
Message-ID: <ce7ea50b148b427f7bb41e0c676ae9d3.squirrel@www.codeaurora.org>
References: <1421332359-31785-1-git-send-email-ygardi@codeaurora.org>
    <1421332359-31785-6-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1421332359-31785-6-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Yaniv Gardi <ygardi@qti.qualcomm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Dov Levenglick <dovl@codeaurora.org>

> From: Yaniv Gardi <ygardi@qti.qualcomm.com>
>
> In-order to enhance storage encryption performance,
> an Inline Cryptographic Engine is introduced to UFS.
> This patch adds in-line encryption capabilities to the UFS
> driver.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/Kconfig        |  12 +
>  drivers/scsi/ufs/Makefile       |   1 +
>  drivers/scsi/ufs/ufs-qcom-ice.c | 520
> ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-qcom-ice.h | 113 +++++++++
>  drivers/scsi/ufs/ufs-qcom.c     |  56 ++++-
>  drivers/scsi/ufs/ufs-qcom.h     |  25 ++
>  6 files changed, 726 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.h
>
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 8a1f4b3..ecf34ed 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -83,3 +83,15 @@ config SCSI_UFS_QCOM
>
>  	  Select this if you have UFS controller on QCOM chipset.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_QCOM_ICE
> +	bool "QCOM specific hooks to Inline Crypto Engine for UFS driver"
> +	depends on SCSI_UFS_QCOM && CRYPTO_DEV_QCOM_ICE
> +	help
> +	  This selects the QCOM specific additions to support Inline
> Crypto
> +	  Engine (ICE).
> +	  ICE accelerates the crypto operations and maintains the high UFS
> +	  performance.
> +
> +	  Select this if you have ICE supported for UFS on QCOM chipset.
> +	  If unsure, say N.
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 8303bcc..31adca5 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -1,5 +1,6 @@
>  # UFSHCD makefile
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
> +obj-$(CONFIG_SCSI_UFS_QCOM_ICE) += ufs-qcom-ice.o
>  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
> diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c
> b/drivers/scsi/ufs/ufs-qcom-ice.c
> new file mode 100644
> index 0000000..9202b73
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-qcom-ice.c
> @@ -0,0 +1,520 @@
> +/* Copyright (c) 2014-2015, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of.h>
> +#include <linux/async.h>
> +#include <linux/blkdev.h>
> +#include <crypto/ice.h>
> +
> +#include "ufs-qcom-ice.h"
> +#include "ufshcd.h"
> +
> +#define UFS_QCOM_CRYPTO_LABEL "ufs-qcom-crypto"
> +/* Timeout waiting for ICE initialization, that requires TZ access */
> +#define UFS_QCOM_ICE_COMPLETION_TIMEOUT_MS 500
> +
> +static void ufs_qcom_ice_success_cb(void *host_ctrl,
> +				enum ice_event_completion evt)
> +{
> +	struct ufs_qcom_host *qcom_host = (struct ufs_qcom_host
> *)host_ctrl;
> +
> +	if (qcom_host->ice.state == UFS_QCOM_ICE_STATE_DISABLED &&
> +	    evt == ICE_INIT_COMPLETION)
> +		qcom_host->ice.state = UFS_QCOM_ICE_STATE_ACTIVE;
> +	 else if (qcom_host->ice.state == UFS_QCOM_ICE_STATE_SUSPENDED &&
> +		   evt == ICE_RESUME_COMPLETION)
> +		qcom_host->ice.state = UFS_QCOM_ICE_STATE_ACTIVE;
> +
> +	complete(&qcom_host->ice.async_done);
> +}
> +
> +static void ufs_qcom_ice_error_cb(void *host_ctrl, enum ice_error_code
> evt)
> +{
> +	struct ufs_qcom_host *qcom_host = (struct ufs_qcom_host
> *)host_ctrl;
> +
> +	dev_err(qcom_host->hba->dev, "%s: Error in ice operation %d",
> +		__func__, evt);
> +
> +	if (qcom_host->ice.state == UFS_QCOM_ICE_STATE_ACTIVE)
> +		qcom_host->ice.state = UFS_QCOM_ICE_STATE_DISABLED;
> +
> +	complete(&qcom_host->ice.async_done);
> +}
> +
> +static struct platform_device *ufs_qcom_ice_get_pdevice(struct device
> *ufs_dev)
> +{
> +	struct device_node *node;
> +	struct platform_device *ice_pdev = NULL;
> +
> +	node = of_parse_phandle(ufs_dev->of_node, UFS_QCOM_CRYPTO_LABEL,
> 0);
> +
> +	if (!node) {
> +		dev_err(ufs_dev, "%s: ufs-qcom-crypto property not
> specified\n",
> +			__func__);
> +		goto out;
> +	}
> +
> +	ice_pdev = qcom_ice_get_pdevice(node);
> +out:
> +	return ice_pdev;
> +}
> +
> +static
> +struct qcom_ice_variant_ops *ufs_qcom_ice_get_vops(struct device
> *ufs_dev)
> +{
> +	struct qcom_ice_variant_ops *ice_vops = NULL;
> +	struct device_node *node;
> +
> +	node = of_parse_phandle(ufs_dev->of_node, UFS_QCOM_CRYPTO_LABEL,
> 0);
> +
> +	if (!node) {
> +		dev_err(ufs_dev, "%s: ufs-qcom-crypto property not
> specified\n",
> +			__func__);
> +		goto out;
> +	}
> +
> +	ice_vops = qcom_ice_get_variant_ops(node);
> +
> +	if (!ice_vops)
> +		dev_err(ufs_dev, "%s: invalid ice_vops\n", __func__);
> +
> +	of_node_put(node);
> +out:
> +	return ice_vops;
> +}
> +
> +/**
> + * ufs_qcom_ice_get_dev() - sets pointers to ICE data structs in UFS QCom
> host
> + * @qcom_host:	Pointer to a UFS QCom internal host structure.
> + *
> + * Sets ICE platform device pointer and ICE vops structure
> + * corresponding to the current UFS device.
> + *
> + * Return: -EINVAL in-case of invalid input parameters:
> + *  qcom_host, qcom_host->hba or qcom_host->hba->dev
> + *         -ENODEV in-case ICE device is not required
> + *         -EPROBE_DEFER in-case ICE is required and hasn't been probed
> yet
> + *         0 otherwise
> + */
> +int ufs_qcom_ice_get_dev(struct ufs_qcom_host *qcom_host)
> +{
> +	struct device *ufs_dev;
> +	int err = 0;
> +
> +	if (!qcom_host || !qcom_host->hba || !qcom_host->hba->dev) {
> +		pr_err("%s: invalid qcom_host %p or qcom_host->hba or
> qcom_host->hba->dev\n",
> +			__func__, qcom_host);
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	ufs_dev = qcom_host->hba->dev;
> +
> +	qcom_host->ice.vops  = ufs_qcom_ice_get_vops(ufs_dev);
> +	qcom_host->ice.pdev = ufs_qcom_ice_get_pdevice(ufs_dev);
> +
> +	if (qcom_host->ice.pdev == ERR_PTR(-EPROBE_DEFER)) {
> +		dev_err(ufs_dev, "%s: ICE device not probed yet\n",
> +			__func__);
> +		qcom_host->ice.pdev = NULL;
> +		qcom_host->ice.vops = NULL;
> +		err = -EPROBE_DEFER;
> +		goto out;
> +	}
> +
> +	if (!qcom_host->ice.pdev || !qcom_host->ice.vops) {
> +		dev_err(ufs_dev, "%s: invalid platform device %p or vops
> %p\n",
> +			__func__, qcom_host->ice.pdev,
> qcom_host->ice.vops);
> +		qcom_host->ice.pdev = NULL;
> +		qcom_host->ice.vops = NULL;
> +		err = -ENODEV;
> +		goto out;
> +	}
> +
> +	qcom_host->ice.state = UFS_QCOM_ICE_STATE_DISABLED;
> +
> +out:
> +	return err;
> +
> +}
> +
> +/**
> + * ufs_qcom_ice_init() - initializes the ICE-UFS interface and ICE device
> + * @qcom_host:	Pointer to a UFS QCom internal host structure.
> + *		qcom_host, qcom_host->hba and qcom_host->hba->dev should
> all
> + *		be valid pointers.
> + *
> + * Return: -EINVAL in-case of an error
> + *         0 otherwise
> + */
> +int ufs_qcom_ice_init(struct ufs_qcom_host *qcom_host)
> +{
> +	struct device *ufs_dev = qcom_host->hba->dev;
> +	int err = -EINVAL;
> +
> +	init_completion(&qcom_host->ice.async_done);
> +	err = qcom_host->ice.vops->init(qcom_host->ice.pdev,
> +				qcom_host,
> +				ufs_qcom_ice_success_cb,
> +				ufs_qcom_ice_error_cb);
> +	if (err) {
> +		dev_err(ufs_dev, "%s: ice init failed. err = %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	if (!wait_for_completion_timeout(&qcom_host->ice.async_done,
> +
> msecs_to_jiffies(UFS_QCOM_ICE_COMPLETION_TIMEOUT_MS))) {
> +		dev_err(qcom_host->hba->dev,
> +			"%s: error. got timeout after %d ms\n",
> +			__func__, UFS_QCOM_ICE_COMPLETION_TIMEOUT_MS);
> +		err = -ETIMEDOUT;
> +		goto out;
> +	}
> +
> +	if (qcom_host->ice.state != UFS_QCOM_ICE_STATE_ACTIVE) {
> +		dev_err(qcom_host->hba->dev,
> +			"%s: error. ice.state (%d) is not in active
> state\n",
> +			__func__, qcom_host->ice.state);
> +		err = -EINVAL;
> +	}
> +
> +out:
> +	return err;
> +}
> +
> +static inline bool ufs_qcom_is_data_cmd(char cmd_op, bool is_write)
> +{
> +	if (is_write) {
> +		if (cmd_op == WRITE_6 || cmd_op == WRITE_10 ||
> +		    cmd_op == WRITE_16)
> +			return true;
> +	} else {
> +		if (cmd_op == READ_6 || cmd_op == READ_10 ||
> +		    cmd_op == READ_16)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/**
> + * ufs_qcom_ice_cfg() - configures UFS's ICE registers for an ICE
> transaction
> + * @qcom_host:	Pointer to a UFS QCom internal host structure.
> + *		qcom_host, qcom_host->hba and qcom_host->hba->dev should
> all
> + *		be valid pointers.
> + * @cmd:	Pointer to a valid scsi command. cmd->request should also
> be
> + *              a valid pointer.
> + *
> + * Return: -EINVAL in-case of an error
> + *         0 otherwise
> + */
> +int ufs_qcom_ice_cfg(struct ufs_qcom_host *qcom_host, struct scsi_cmnd
> *cmd)
> +{
> +	struct device *dev = qcom_host->hba->dev;
> +	int err = 0;
> +	struct ice_data_setting ice_set;
> +	unsigned int slot = 0;
> +	sector_t lba = 0;
> +	unsigned int ctrl_info_2_val = 0;
> +	unsigned int bypass = 0;
> +	struct request *req;
> +	char cmd_op;
> +
> +	if (!qcom_host->ice.pdev || !qcom_host->ice.vops) {
> +		dev_dbg(dev, "%s: ice device is not enabled\n", __func__);
> +		goto out;
> +	}
> +
> +	if (qcom_host->ice.state != UFS_QCOM_ICE_STATE_ACTIVE) {
> +		dev_err(dev, "%s: ice state (%d) is not active\n",
> +			__func__, qcom_host->ice.state);
> +		return -EINVAL;
> +	}
> +
> +	req = cmd->request;
> +	if (req->bio)
> +		lba = req->bio->bi_sector;
> +
> +	slot = req->tag;
> +	if (slot < 0 || slot > qcom_host->hba->nutrs) {
> +		dev_err(dev, "%s: slot (%d) is out of boundaries
> (0...%d)\n",
> +			__func__, slot, qcom_host->hba->nutrs);
> +		return -EINVAL;
> +	}
> +
> +	memset(&ice_set, sizeof(ice_set), 0);
> +	if (qcom_host->ice.vops->config) {
> +		err = qcom_host->ice.vops->config(qcom_host->ice.pdev,
> +							req, &ice_set);
> +
> +		if (err) {
> +			dev_err(dev, "%s: error in ice_vops->config %d\n",
> +				__func__, err);
> +			goto out;
> +		}
> +	}
> +
> +	cmd_op = cmd->cmnd[0];
> +
> +#define UFS_QCOM_DIR_WRITE	true
> +#define UFS_QCOM_DIR_READ	false
> +	/* if non data command, bypass shall be enabled */
> +	if (!ufs_qcom_is_data_cmd(cmd_op, UFS_QCOM_DIR_WRITE) &&
> +	    !ufs_qcom_is_data_cmd(cmd_op, UFS_QCOM_DIR_READ))
> +		bypass = UFS_QCOM_ICE_ENABLE_BYPASS;
> +	/* if writing data command */
> +	else if (ufs_qcom_is_data_cmd(cmd_op, UFS_QCOM_DIR_WRITE))
> +		bypass = ice_set.encr_bypass ? UFS_QCOM_ICE_ENABLE_BYPASS
> :
> +
> UFS_QCOM_ICE_DISABLE_BYPASS;
> +	/* if reading data command */
> +	else if (ufs_qcom_is_data_cmd(cmd_op, UFS_QCOM_DIR_READ))
> +		bypass = ice_set.decr_bypass ? UFS_QCOM_ICE_ENABLE_BYPASS
> :
> +
> UFS_QCOM_ICE_DISABLE_BYPASS;
> +
> +	/* Configure ICE index */
> +	ctrl_info_2_val =
> +		(ice_set.crypto_data.key_index &
> +		 MASK_UFS_QCOM_ICE_CTRL_INFO_2_KEY_INDEX)
> +		 << OFFSET_UFS_QCOM_ICE_CTRL_INFO_2_KEY_INDEX;
> +
> +	/* Configure data unit size of transfer request */
> +	ctrl_info_2_val |=
> +		(UFS_QCOM_ICE_TR_DATA_UNIT_4_KB &
> +		 MASK_UFS_QCOM_ICE_CTRL_INFO_2_CDU)
> +		 << OFFSET_UFS_QCOM_ICE_CTRL_INFO_2_CDU;
> +
> +	/* Configure ICE bypass mode */
> +	ctrl_info_2_val |=
> +		(bypass & MASK_UFS_QCOM_ICE_CTRL_INFO_2_BYPASS)
> +		 << OFFSET_UFS_QCOM_ICE_CTRL_INFO_2_BYPASS;
> +
> +	ufshcd_writel(qcom_host->hba, lba,
> +		     (REG_UFS_QCOM_ICE_CTRL_INFO_1_n + 8 * slot));
> +
> +	ufshcd_writel(qcom_host->hba, ctrl_info_2_val,
> +		     (REG_UFS_QCOM_ICE_CTRL_INFO_2_n + 8 * slot));
> +
> +	/*
> +	 * Ensure UFS-ICE registers are being configured
> +	 * before next operation, otherwise UFS Host Controller might
> +	 * set get errors
> +	 */
> +	mb();
> +out:
> +	return err;
> +}
> +
> +/**
> + * ufs_qcom_ice_reset() - resets UFS-ICE interface and ICE device
> + * @qcom_host:	Pointer to a UFS QCom internal host structure.
> + *		qcom_host, qcom_host->hba and qcom_host->hba->dev should
> all
> + *		be valid pointers.
> + *
> + * Return: -EINVAL in-case of an error
> + *         0 otherwise
> + */
> +int ufs_qcom_ice_reset(struct ufs_qcom_host *qcom_host)
> +{
> +	struct device *dev = qcom_host->hba->dev;
> +	int err = 0;
> +
> +	if (!qcom_host->ice.pdev) {
> +		dev_dbg(dev, "%s: ice device is not enabled\n", __func__);
> +		goto out;
> +	}
> +
> +	if (!qcom_host->ice.vops) {
> +		dev_err(dev, "%s: invalid ice_vops\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (qcom_host->ice.state != UFS_QCOM_ICE_STATE_ACTIVE)
> +		goto out;
> +
> +	init_completion(&qcom_host->ice.async_done);
> +
> +	if (qcom_host->ice.vops->reset) {
> +		err = qcom_host->ice.vops->reset(qcom_host->ice.pdev);
> +		if (err) {
> +			dev_err(dev, "%s: ice_vops->reset failed. err
> %d\n",
> +				__func__, err);
> +			goto out;
> +		}
> +	}
> +
> +	if (!wait_for_completion_timeout(&qcom_host->ice.async_done,
> +	     msecs_to_jiffies(UFS_QCOM_ICE_COMPLETION_TIMEOUT_MS))) {
> +		dev_err(dev,
> +			"%s: error. got timeout after %d ms\n",
> +			__func__, UFS_QCOM_ICE_COMPLETION_TIMEOUT_MS);
> +		err = -ETIMEDOUT;
> +	}
> +
> +out:
> +	return err;
> +}
> +
> +/**
> + * ufs_qcom_ice_resume() - resumes UFS-ICE interface and ICE device from
> power
> + * collapse
> + * @qcom_host:	Pointer to a UFS QCom internal host structure.
> + *		qcom_host, qcom_host->hba and qcom_host->hba->dev should
> all
> + *		be valid pointers.
> + *
> + * Return: -EINVAL in-case of an error
> + *         0 otherwise
> + */
> +int ufs_qcom_ice_resume(struct ufs_qcom_host *qcom_host)
> +{
> +	struct device *dev = qcom_host->hba->dev;
> +	int err = 0;
> +
> +	if (!qcom_host->ice.pdev) {
> +		dev_dbg(dev, "%s: ice device is not enabled\n", __func__);
> +		goto out;
> +	}
> +
> +	if (qcom_host->ice.state !=
> +			UFS_QCOM_ICE_STATE_SUSPENDED) {
> +		goto out;
> +	}
> +
> +	if (!qcom_host->ice.vops) {
> +		dev_err(dev, "%s: invalid ice_vops\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	init_completion(&qcom_host->ice.async_done);
> +
> +	if (qcom_host->ice.vops->resume) {
> +		err = qcom_host->ice.vops->resume(qcom_host->ice.pdev);
> +		if (err) {
> +			dev_err(dev, "%s: ice_vops->resume failed. err
> %d\n",
> +				__func__, err);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (!wait_for_completion_timeout(&qcom_host->ice.async_done,
> +
> msecs_to_jiffies(UFS_QCOM_ICE_COMPLETION_TIMEOUT_MS))) {
> +		dev_err(dev,
> +			"%s: error. got timeout after %d ms\n",
> +			__func__, UFS_QCOM_ICE_COMPLETION_TIMEOUT_MS);
> +		err = -ETIMEDOUT;
> +		goto out;
> +	}
> +
> +	if (qcom_host->ice.state != UFS_QCOM_ICE_STATE_ACTIVE)
> +		err = -EINVAL;
> +out:
> +	return err;
> +}
> +
> +/**
> + * ufs_qcom_ice_suspend() - suspends UFS-ICE interface and ICE device
> + * @qcom_host:	Pointer to a UFS QCom internal host structure.
> + *		qcom_host, qcom_host->hba and qcom_host->hba->dev should
> all
> + *		be valid pointers.
> + *
> + * Return: -EINVAL in-case of an error
> + *         0 otherwise
> + */
> +int ufs_qcom_ice_suspend(struct ufs_qcom_host *qcom_host)
> +{
> +	struct device *dev = qcom_host->hba->dev;
> +	int err = 0;
> +
> +	if (!qcom_host->ice.pdev) {
> +		dev_dbg(dev, "%s: ice device is not enabled\n", __func__);
> +		goto out;
> +	}
> +
> +	if (qcom_host->ice.vops->suspend) {
> +		err = qcom_host->ice.vops->suspend(qcom_host->ice.pdev);
> +		if (err) {
> +			dev_err(qcom_host->hba->dev,
> +				"%s: ice_vops->suspend failed. err %d\n",
> +				__func__, err);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (qcom_host->ice.state == UFS_QCOM_ICE_STATE_ACTIVE) {
> +		qcom_host->ice.state = UFS_QCOM_ICE_STATE_SUSPENDED;
> +	} else if (qcom_host->ice.state == UFS_QCOM_ICE_STATE_DISABLED) {
> +		dev_err(qcom_host->hba->dev,
> +				"%s: ice state is invalid: disabled\n",
> +				__func__);
> +		err = -EINVAL;
> +	}
> +
> +out:
> +	return err;
> +}
> +
> +/**
> + * ufs_qcom_ice_get_status() - returns the status of an ICE transaction
> + * @qcom_host:	Pointer to a UFS QCom internal host structure.
> + *		qcom_host, qcom_host->hba and qcom_host->hba->dev should
> all
> + *		be valid pointers.
> + * @ice_status:	Pointer to a valid output parameter.
> + *		< 0 in case of ICE transaction failure.
> + *		0 otherwise.
> + *
> + * Return: -EINVAL in-case of an error
> + *         0 otherwise
> + */
> +int ufs_qcom_ice_get_status(struct ufs_qcom_host *qcom_host, int
> *ice_status)
> +{
> +	struct device *dev = NULL;
> +	int err = 0;
> +	int stat = -EINVAL;
> +
> +	ice_status = 0;
> +
> +	dev = qcom_host->hba->dev;
> +	if (!dev) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!qcom_host->ice.pdev) {
> +		dev_dbg(dev, "%s: ice device is not enabled\n", __func__);
> +		goto out;
> +	}
> +
> +	if (qcom_host->ice.state != UFS_QCOM_ICE_STATE_ACTIVE) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!qcom_host->ice.vops) {
> +		dev_err(dev, "%s: invalid ice_vops\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (qcom_host->ice.vops->status) {
> +		stat = qcom_host->ice.vops->status(qcom_host->ice.pdev);
> +		if (stat < 0) {
> +			dev_err(dev, "%s: ice_vops->status failed. stat
> %d\n",
> +				__func__, stat);
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		*ice_status = stat;
> +	}
> +
> +out:
> +	return err;
> +}
> diff --git a/drivers/scsi/ufs/ufs-qcom-ice.h
> b/drivers/scsi/ufs/ufs-qcom-ice.h
> new file mode 100644
> index 0000000..5ccbf5f
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-qcom-ice.h
> @@ -0,0 +1,113 @@
> +/* Copyright (c) 2014-2015, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _UFS_QCOM_ICE_H_
> +#define _UFS_QCOM_ICE_H_
> +
> +#include <scsi/scsi_cmnd.h>
> +
> +#include "ufs-qcom.h"
> +
> +/*
> + * UFS host controller ICE registers. There are n [0..31]
> + * of each of these registers
> + */
> +enum {
> +	REG_UFS_QCOM_ICE_CTRL_INFO_1_n           = 0x2204,
> +	REG_UFS_QCOM_ICE_CTRL_INFO_2_n           = 0x2208,
> +};
> +
> +/* UFS QCOM ICE CTRL Info 2 register offset */
> +enum {
> +	OFFSET_UFS_QCOM_ICE_CTRL_INFO_2_BYPASS     = 0,
> +	OFFSET_UFS_QCOM_ICE_CTRL_INFO_2_KEY_INDEX  = 0x1,
> +	OFFSET_UFS_QCOM_ICE_CTRL_INFO_2_CDU        = 0x6,
> +};
> +
> +/* UFS QCOM ICE CTRL Info 2 register masks */
> +enum {
> +	MASK_UFS_QCOM_ICE_CTRL_INFO_2_BYPASS     = 0x1,
> +	MASK_UFS_QCOM_ICE_CTRL_INFO_2_KEY_INDEX  = 0x1F,
> +	MASK_UFS_QCOM_ICE_CTRL_INFO_2_CDU        = 0x8,
> +};
> +
> +/* UFS QCOM ICE encryption/decryption bypass state */
> +enum {
> +	UFS_QCOM_ICE_DISABLE_BYPASS  = 0,
> +	UFS_QCOM_ICE_ENABLE_BYPASS = 1,
> +};
> +
> +/* UFS QCOM ICE Crypto Data Unit of target DUN of Transfer Request */
> +enum {
> +	UFS_QCOM_ICE_TR_DATA_UNIT_512_B          = 0,
> +	UFS_QCOM_ICE_TR_DATA_UNIT_1_KB           = 1,
> +	UFS_QCOM_ICE_TR_DATA_UNIT_2_KB           = 2,
> +	UFS_QCOM_ICE_TR_DATA_UNIT_4_KB           = 3,
> +	UFS_QCOM_ICE_TR_DATA_UNIT_8_KB           = 4,
> +	UFS_QCOM_ICE_TR_DATA_UNIT_16_KB          = 5,
> +	UFS_QCOM_ICE_TR_DATA_UNIT_32_KB          = 6,
> +};
> +
> +/* UFS QCOM ICE internal state */
> +enum {
> +	UFS_QCOM_ICE_STATE_DISABLED   = 0,
> +	UFS_QCOM_ICE_STATE_ACTIVE     = 1,
> +	UFS_QCOM_ICE_STATE_SUSPENDED  = 2,
> +};
> +
> +#ifdef CONFIG_SCSI_UFS_QCOM_ICE
> +int ufs_qcom_ice_get_dev(struct ufs_qcom_host *qcom_host);
> +int ufs_qcom_ice_init(struct ufs_qcom_host *qcom_host);
> +int ufs_qcom_ice_cfg(struct ufs_qcom_host *qcom_host, struct scsi_cmnd
> *cmd);
> +int ufs_qcom_ice_reset(struct ufs_qcom_host *qcom_host);
> +int ufs_qcom_ice_resume(struct ufs_qcom_host *qcom_host);
> +int ufs_qcom_ice_suspend(struct ufs_qcom_host *qcom_host);
> +int ufs_qcom_ice_get_status(struct ufs_qcom_host *qcom_host, int
> *ice_status);
> +#else
> +inline int ufs_qcom_ice_get_dev(struct ufs_qcom_host *qcom_host)
> +{
> +	if (qcom_host) {
> +		qcom_host->ice.pdev = NULL;
> +		qcom_host->ice.vops = NULL;
> +	}
> +	return -ENODEV;
> +}
> +inline int ufs_qcom_ice_init(struct ufs_qcom_host *qcom_host)
> +{
> +	return 0;
> +}
> +inline int ufs_qcom_ice_cfg(struct ufs_qcom_host *qcom_host,
> +			    struct scsi_cmnd *cmd)
> +{
> +	return 0;
> +}
> +inline int ufs_qcom_ice_reset(struct ufs_qcom_host *qcom_host)
> +{
> +	return 0;
> +}
> +inline int ufs_qcom_ice_resume(struct ufs_qcom_host *qcom_host)
> +{
> +	return 0;
> +}
> +inline int ufs_qcom_ice_suspend(struct ufs_qcom_host *qcom_host)
> +{
> +	return 0;
> +}
> +inline int ufs_qcom_ice_get_status(struct ufs_qcom_host *qcom_host,
> +				   int *ice_status)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_SCSI_UFS_QCOM_ICE */
> +
> +#endif /* UFS_QCOM_ICE_H_ */
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 9217af9..fd01255 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -22,6 +22,7 @@
>  #include "unipro.h"
>  #include "ufs-qcom.h"
>  #include "ufshci.h"
> +#include "ufs-qcom-ice.h"
>
>  static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];
>
> @@ -294,6 +295,13 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba
> *hba, bool status)
>  		/* check if UFS PHY moved from DISABLED to HIBERN8 */
>  		err = ufs_qcom_check_hibern8(hba);
>  		ufs_qcom_enable_hw_clk_gating(hba);
> +		if (!err) {
> +			err = ufs_qcom_ice_reset(host);
> +			if (err)
> +				dev_err(hba->dev,
> +					"%s: ufs_qcom_ice_reset() failed
> %d\n",
> +					__func__, err);
> +		}
>
>  		break;
>  	default:
> @@ -453,6 +461,10 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  		 */
>  		ufs_qcom_disable_lane_clks(host);
>  		phy_power_off(phy);
> +		ret = ufs_qcom_ice_suspend(host);
> +		if (ret)
> +			dev_err(hba->dev, "%s: failed ufs_qcom_ice_suspend
> %d\n",
> +					__func__, ret);
>
>  		/* Assert PHY soft reset */
>  		ufs_qcom_assert_reset(hba);
> @@ -463,8 +475,10 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  	 * If UniPro link is not active, PHY ref_clk, main PHY analog
> power
>  	 * rail and low noise analog power rail for PLL can be switched
> off.
>  	 */
> -	if (!ufs_qcom_is_link_active(hba))
> +	if (!ufs_qcom_is_link_active(hba)) {
>  		phy_power_off(phy);
> +		ufs_qcom_ice_suspend(host);
> +	}
>
>  out:
>  	return ret;
> @@ -483,6 +497,13 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  		goto out;
>  	}
>
> +	err = ufs_qcom_ice_resume(host);
> +	if (err) {
> +		dev_err(hba->dev, "%s: ufs_qcom_ice_resume failed, err =
> %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
>  	hba->is_sys_suspended = false;
>
>  out:
> @@ -917,6 +938,30 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	host->hba = hba;
>  	hba->priv = (void *)host;
>
> +	err = ufs_qcom_ice_get_dev(host);
> +	if (err == -EPROBE_DEFER) {
> +		/*
> +		 * UFS driver might be probed before ICE driver does.
> +		 * In that case we would like to return EPROBE_DEFER code
> +		 * in order to delay its probing.
> +		 */
> +		dev_err(dev, "%s: required ICE device not probed yet err =
> %d\n",
> +			__func__, err);
> +		goto out_host_free;
> +
> +	} else if (err == -ENODEV) {
> +		/*
> +		 * ICE device is not enabled in DTS file. No need for
> further
> +		 * initialization of ICE driver.
> +		 */
> +		dev_warn(dev, "%s: ICE device is not enabled",
> +			__func__);
> +	} else if (err) {
> +		dev_err(dev, "%s: ufs_qcom_ice_get_dev failed %d\n",
> +			__func__, err);
> +		goto out_host_free;
> +	}
> +
>  	host->generic_phy = devm_phy_get(dev, "ufsphy");
>
>  	if (IS_ERR(host->generic_phy)) {
> @@ -944,6 +989,15 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
>
>  	ufs_qcom_setup_clocks(hba, true);
> +	if (host->ice.pdev) {
> +		err = ufs_qcom_ice_init(host);
> +		if (err) {
> +			dev_err(dev, "%s: ICE driver initialization failed
> (%d)\n",
> +				__func__, err);
> +			device_remove_file(dev,
> &host->bus_vote.max_bus_bw);
> +			goto out_disable_phy;
> +		}
> +	}
>
>  	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
>  		ufs_qcom_hosts[hba->dev->id] = host;
> diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
> index 9a6febd..8340f2c 100644
> --- a/drivers/scsi/ufs/ufs-qcom.h
> +++ b/drivers/scsi/ufs/ufs-qcom.h
> @@ -151,6 +151,30 @@ struct ufs_qcom_bus_vote {
>  	struct device_attribute max_bus_bw;
>  };
>
> +/**
> + * struct ufs_qcom_ice_data - ICE related information
> + * @vops:	pointer to variant operations of ICE
> + * @async_done:	completion for supporting ICE's driver
> asynchronous nature
> + * @pdev:	pointer to the proper ICE platform device
> + * @state:      UFS-ICE interface's internal state (see
> + *       ufs-qcom-ice.h for possible internal states)
> + * @quirks:     UFS-ICE interface related quirks
> + */
> +struct ufs_qcom_ice_data {
> +	struct qcom_ice_variant_ops *vops;
> +	struct completion async_done;
> +	struct platform_device *pdev;
> +	int state;
> +
> +	/*
> +	 * If UFS host controller should handle cryptographic engine's
> +	 * errors, enables this quirk.
> +	 */
> +	#define UFS_QCOM_ICE_QUIRK_HANDLE_CRYPTO_ENGINE_ERRORS	UFS_BIT(0)
> +
> +	u16 quirks;
> +};
> +
>  struct ufs_qcom_host {
>  	struct phy *generic_phy;
>  	struct ufs_hba *hba;
> @@ -161,6 +185,7 @@ struct ufs_qcom_host {
>  	struct clk *rx_l1_sync_clk;
>  	struct clk *tx_l1_sync_clk;
>  	bool is_lane_clks_enabled;
> +	struct ufs_qcom_ice_data ice;
>  };
>
>  #define ufs_qcom_is_link_off(hba) ufshcd_is_link_off(hba)
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
