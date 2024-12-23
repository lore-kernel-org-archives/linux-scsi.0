Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C145C28DA1;
	Mon, 23 Dec 2024 19:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734982298; cv=none; b=AhTR1EI8Bxn31xtueHvTOrnba0JGi6oRHda691ELMpDGCy0B5y3Gx9OZlnFukbxDbeJmJEsSQ3MLfLqLV63JSo+nrzKLZiSb6NeDq0inBrL7Q76mgBbVhn7k73GMKn/EjSQVEXWcFQTrlOmStN4KuNaFfhm4d1gzTarUXLEL1qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734982298; c=relaxed/simple;
	bh=QgRNRj78knXDngnKc16a7nkbz9IBqFky6+XDfD+lum0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRFOCtSi7pCKkCQNRdGdwPs58IRL1ko6Lgi1lhjE1zMpEZ6gXlV+B5mjdVBh5axDfMayjCSEkKyBmfqTvjggDnBlwvdvFFubpdLbQXGte/Rb3Tf3wQOn7bSgrbu37FFoOYl+I1hR/IR0p69t5SR2plPYE7tRDJDyqknbeCvdgy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAGjKCAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAGjKCAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62F4C4CED3;
	Mon, 23 Dec 2024 19:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734982298;
	bh=QgRNRj78knXDngnKc16a7nkbz9IBqFky6+XDfD+lum0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mAGjKCApoN8q1iYUtBRkT1ZF+011kVBhEWrjl2RUv03Hqxujpg+kZap/Y3bMVfoN+
	 +DnMmZ3uAKbBHLxfQlCyaXwIoP1jXkcSKtVjlMYaRouFuwJNPsNcWqOKeiHg8Vg6jl
	 KH//6RrwyE7zj3bVbqyNBhSHuKrExc6gNqxC2K0Vhqw3+u5Iy6H3CYcIoH68y3pPDm
	 OWl0hj5+Sd8i2+lmcq/NqsCACg7LbPGjWcDNrvekQgXlHUC51IVljaTXWLnYvBvj+F
	 TCXACx48T5lDrcFxnSzMW+BbrQshaYCcjkVhROAkCQGJszYmjcRki3Uv7IXkpJmZOc
	 1D3np/ZEieohg==
Date: Mon, 23 Dec 2024 11:31:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Cc: manivannan.sadhasivam@linaro.org, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, andersson@kernel.org,
	bvanassche@acm.org, linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>
Subject: Re: [PATCH V6] scsi: ufs: qcom: Enable UFS Shared ICE Feature
Message-ID: <20241223193130.GA2032@quark.localdomain>
References: <20241223132033.11706-1-quic_rdwivedi@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223132033.11706-1-quic_rdwivedi@quicinc.com>

On Mon, Dec 23, 2024 at 06:50:33PM +0530, Ram Kumar Dwivedi wrote:
>  #ifdef CONFIG_SCSI_UFS_CRYPTO
> +/**
> + * ufs_qcom_config_ice_allocator() - ICE core allocator configuration
> + *
> + * @host: pointer to qcom specific variant structure.
> + */
> +static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
> +{
> +	struct ufs_hba *hba = host->hba;
> +	static const uint8_t val[4] = { NUM_RX_R1W0, NUM_TX_R0W1, NUM_RX_R1W1, NUM_TX_R1W1 };
> +	u32 config;
> +
> +	if (!is_ice_config_supported(host))
> +		return;

This is the only place that is_ice_config_supported() is called, so the helper
function seems unnecessary vs. just checking UFS_QCOM_CAP_ICE_CONFIG directly.

Also, shouldn't any ICE configuration also be conditional on UFSHCD_CAP_CRYPTO?
Just in case the ICE support got turned off for some reason.

- Eric
