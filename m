Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D041D3FAE11;
	Thu, 30 Jul 2026 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785406431; cv=none; b=k9sfugb2rtHJyX2t1kQ7omdOvHdW2xt7wdyQURHHvnmyoYje8C6mGBBDUoxuFSf3q1h2LDpGDUmXxFfMisofUwiErUW8SVXeAoP5y9diP7LjZ6oWx7GSJ2+s5gxr8qqzJaPvddMO9k3UGTXIhMhNVPB2xccjGoucnRFDzBs4pWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785406431; c=relaxed/simple;
	bh=OX8l8dHUWyCADygYW1WT2yUHxcWI/LID/rjI6NJe2Vc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D2IjrTGV5xE4txUetDQnW4V6owgE3Hb01iVe/P0MxueyVvnUqc8oXe2hlIKeAfvnA+wb7AADt+RwFVmCipjO44xs/UtpaRS3poSZhvm36KUx6/bx8f+06iU6XX0PQv3uyjUBoLhvSHrIdRalpuMhVReNXQDr/fw0dCBvD7HVmHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lb2Aqw5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lb2Aqw5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0C21F000E9;
	Thu, 30 Jul 2026 10:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785406430;
	bh=OX8l8dHUWyCADygYW1WT2yUHxcWI/LID/rjI6NJe2Vc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lb2Aqw5tXYJrGvhXNcajZh6kZRVxEj4TgYd+q4MlOlbLgY85iL7kERtye6K+YUtVv
	 eBQWhjmzQtuQenRwMQ2AsFvdGl2M52eDZ/HjTkthBcUIjOOpk59XJOKWOAFn5Vhjq1
	 2GxN7cCBPPhcJPodp0Piwf/ib5tlDDOhGoXTHNQEL9gLumpILKwohmVhbaS5ZNHUJq
	 V2KR4h8KNK1ESxjAnsIQ0rbsIUbi2UzTx33iheiPrEBPuY+DDDrA6gN+ZZB9i0XMOr
	 H5cgMHqiaqxLav2I7y9YL6TudFgY7GDWEd77Jz0iz4/2JWpjNvhxljb5RCmLLY+V+z
	 Z/FNk9OmZpNPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 07/26] scsi: ufs: mediatek: Rework 0.9V regulator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: robh@kernel.org, devicetree@vger.kernel.org, vkoul@kernel.org, linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, neil.armstrong@linaro.org, conor+dt@kernel.org, olteanv@gmail.com
In-Reply-To: <20260730-mt8196-ufs-v10-7-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-7-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:13:49 +0000
Message-Id: <20260730101349.EF0C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] `ufs_mtk_get_supplies()` uses `dev_err()` instead of `dev_err_pr=
obe()`, resulting in excessive log spam when the regulator probe defers.

Pre-existing issues:
- [High] Missing error handling in `ufs_mtk_mphy_power_on()` leads to PHY f=
ramework reference count underflow and state desynchronization.
--

--- Patch [7]: [PATCH v10 07/26] scsi: ufs: mediatek: Rework 0.9V regulator=
 ---
Note: The format of this report has been altered due to recitation restrict=
ions. The original patch diff is not quoted, and findings are provided as a=
 free-form summary.

commit 53fa70c9d3d751e82ebb61d97d0c2282f65046c5
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
scsi: ufs: mediatek: Rework 0.9V regulator

This commit reworks the 0.9V regulator handling in the Mediatek UFS host
driver. It removes the custom downstream naming, uses the standard regulator
API with the avdd09 supply name, and eliminates manual stabilization delays.

[Severity: High]
This is a pre-existing issue, but does ufs_mtk_mphy_power_on() handle
failures correctly during PHY power transitions?

When calling phy_power_on(), the return value is not checked. If hardware
initialization fails, host->mphy_powered_on is still set to true.

Additionally, on the power-off path, if the newly added ufs_mtk_09v_off()
fails, the function returns early without setting host->mphy_powered_on
to false.

Could this desynchronize the driver's state from the PHY hardware state?
If the driver incorrectly records the power state as true, subsequent
suspend or error handling paths might blindly call phy_power_off() again,
which would lead to power_count underflows in the PHY framework and
permanently break the PHY until a system reboot.

[Severity: Medium]
In the newly added ufs_mtk_get_supplies(), dev_err() is used to log
failures from devm_regulator_get_optional() for the avdd09 regulator.

If the regulator returns -EPROBE_DEFER, will this dev_err() call cause
excessive log spam during the device probe phase?

Would it make sense to use dev_err_probe() here instead to properly handle
and suppress expected probe deferral messages?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D7
