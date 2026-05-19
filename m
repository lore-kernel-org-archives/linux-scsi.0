Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CBE368284
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 18:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779215298; cv=none; b=ZslsToUyaOOXRstNrrvuqwm00gF3aLVLJ4nMmH9kjXff5YcztVqOBZ6KOLyUZZ83SYoLc3PtWcouxnxfUelCnJ7hwUD7dqBFECD5Xb//d+HT4Q8zbbhtPejwhw/zChdyH5BEkjKyYumMFRC+Jz7kxHczPqjAJ3S7GVCVYPmQezE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779215298; c=relaxed/simple;
	bh=ZYy7AyagFbhXUs8i0IS8O1mXlw+MjSvkkJjQsdnjHik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=YZsAPqk7R5UEkSWR6kTxMnnYH9aEWVTGevUe0EOa2uhWzExBg6WpYViMBWLQZC0HO0kmzknJ8zz/PSnpH/tUhGxJwSfEBv/3l1a7ieUCLcMOWLxhWvoEw20MEoiX8SSWhROsiGpJyf1DTj0syoh8iUxs757P2rpZz+S/O6OO7Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QyPdqPdz; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QyPdqPdz"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260519182808euoutp028b73b3527e571a2741594ca4581aaacc~xCuDc5sJp2597025970euoutp02Z
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 18:28:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260519182808euoutp028b73b3527e571a2741594ca4581aaacc~xCuDc5sJp2597025970euoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1779215288;
	bh=6Aw2ndmfLHqyqQwTrXJJ2vHQHf37eMyA+Fao/TfiRW8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=QyPdqPdzD1xNdeJeC3pOPQsoct71tuNPtxC9NXKV6mN4csgWrbmPtRcjAFQCKrjQ5
	 qI4RWKre/TepnEICp4l2rGIn/1lR7eF8GHu2AKJzlLQNUVrqrcg5tjH7sndS6maXbp
	 S8pk2XqZ8oLddFWl+I/JcbjA2l7lEfSaSNagW1UM=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260519182807eucas1p11ec910d88283c3ebb2fa7e7bcbe3cbe2~xCuCRLCiK2109121091eucas1p1S;
	Tue, 19 May 2026 18:28:07 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260519182805eusmtip242bc666b57d32978a0c25a17a96be586~xCuATtLHa1506115061eusmtip2I;
	Tue, 19 May 2026 18:28:05 +0000 (GMT)
Message-ID: <8bac0358-9da0-4cbb-98ee-333b85ba4908@samsung.com>
Date: Tue, 19 May 2026 20:28:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v7 3/5] soc: qcom: ice: Return proper error codes from
 devm_of_qcom_ice_get() instead of NULL
To: manivannan.sadhasivam@oss.qualcomm.com, Bjorn Andersson
	<andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa
	<abelvesa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson
	<ulfh@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Sumit Garg
	<sumit.garg@oss.qualcomm.com>, Konrad Dybcio
	<konrad.dybcio@oss.qualcomm.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260518-qcom-ice-fix-v7-3-2a595382185b@oss.qualcomm.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260519182807eucas1p11ec910d88283c3ebb2fa7e7bcbe3cbe2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260519182807eucas1p11ec910d88283c3ebb2fa7e7bcbe3cbe2
X-EPHeader: CA
X-CMS-RootMailID: 20260519182807eucas1p11ec910d88283c3ebb2fa7e7bcbe3cbe2
References: <20260518-qcom-ice-fix-v7-0-2a595382185b@oss.qualcomm.com>
	<20260518-qcom-ice-fix-v7-3-2a595382185b@oss.qualcomm.com>
	<CGME20260519182807eucas1p11ec910d88283c3ebb2fa7e7bcbe3cbe2@eucas1p1.samsung.com>

On 18.05.2026 15:52, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>
> devm_of_qcom_ice_get() currently returns NULL if ICE SCM is not available
> or "qcom,ice" property is not found in DT. But this confuses the clients
> since NULL doesn't convey the reason for failure. So return proper error
> codes instead of NULL.
>
> Reported-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Tested-by: Sumit Garg <sumit.garg@oss.qualcomm.com> # OP-TEE as TZ
> Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
This patch landed in today's linux-next as commit b9ab7217dd7d ("soc: qcom: ice:
Return proper error codes from devm_of_qcom_ice_get() instead of NULL"). In my
tests I found that it breaks booting from the UFS storage on the RB5 board:

ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find vdd-hba-supply regulator, assuming enabled
ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find vdd-hba-supply regulator, assuming enabled
ufshcd-qcom 1d84000.ufshc: error -ENODEV: ufshcd_variant_hba_init: variant qcom init failed with err -19
ufshcd-qcom 1d84000.ufshc: error -ENODEV: Initialization failed with error -19
ufshcd-qcom 1d84000.ufshc: error -ENODEV: ufshcd_pltfrm_init() failed
/dev/root: Can't open blockdev
VFS: Cannot open root device "/dev/sda8" or unknown-block(0,0): error -6

...

Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
CPU: 7 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.1.0-rc1+ #12707 PREEMPT
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)


> ---
>  drivers/soc/qcom/ice.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 85deb9ea4a68..2b592aa42941 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -563,7 +563,7 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>  
>  	if (!qcom_scm_ice_available()) {
>  		dev_warn(dev, "ICE SCM interface not found\n");
> -		return NULL;
> +		return ERR_PTR(-EOPNOTSUPP);
>  	}
>  
>  	engine = devm_kzalloc(dev, sizeof(*engine), GFP_KERNEL);
> @@ -645,7 +645,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
>  	struct device_node *node __free(device_node) = of_parse_phandle(dev->of_node,
>  									"qcom,ice", 0);
>  	if (!node)
> -		return NULL;
> +		return ERR_PTR(-ENODEV);
>  
>  	pdev = of_find_device_by_node(node);
>  	if (!pdev) {
> @@ -698,8 +698,7 @@ static void devm_of_qcom_ice_put(struct device *dev, void *res)
>   * phandle via 'qcom,ice' property to an ICE DT, the ICE instance will already
>   * be created and so this function will return that instead.
>   *
> - * Return: ICE pointer on success, NULL if there is no ICE data provided by the
> - * consumer or ERR_PTR() on error.
> + * Return: ICE pointer on success, ERR_PTR() on error.
>   */
>  struct qcom_ice *devm_of_qcom_ice_get(struct device *dev)
>  {
> @@ -710,7 +709,7 @@ struct qcom_ice *devm_of_qcom_ice_get(struct device *dev)
>  		return ERR_PTR(-ENOMEM);
>  
>  	ice = of_qcom_ice_get(dev);
> -	if (!IS_ERR_OR_NULL(ice)) {
> +	if (!IS_ERR(ice)) {
>  		*dr = ice;
>  		devres_add(dev, dr);
>  	} else {
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

