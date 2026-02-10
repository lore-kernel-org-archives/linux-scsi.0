Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F017328617;
	Tue, 10 Feb 2026 12:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770726000; cv=none; b=oleKhdU1kCbKctneOzY3JIqN7DnLaAgfbQfd4SxoBJH8eJ/Ac+KHPUNEpiiwG/aQ7+yBa2U0tXx1xIkz5LtAbyKDLZOq6R8ZMOx6RDHwI20FptBjBG9jZgOLeSsR9PGMZV4V4wLIaA6u638Lz7xdFrXilj/+durlco4HxZKXx+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770726000; c=relaxed/simple;
	bh=G3w7w/M12b1y8s8JwhoN6B8RqzPJL8yAIqrI0BvdHf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exeth8vxDzG8VZyYuDdnnD9tVfPDnutApBkmkHhYMejhy8UOur/y1aXIYsdTmtmumqi4DPvB8QlOBpxW/tn+4CA3xjefp8DQ+tZal+6ghfKqySLU62I+sgnxCq93N9r8Pq8uSMdKmQSO/2ytrEaxN3h3u6MGIzqdkpSmuMsp/y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmwWh7cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmwWh7cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF0DC16AAE;
	Tue, 10 Feb 2026 12:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770725999;
	bh=G3w7w/M12b1y8s8JwhoN6B8RqzPJL8yAIqrI0BvdHf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kmwWh7cxh4E7U0Kf13hXdxvwWjKF7ZqDH5zsQ9mSSUtpYHe+YEeBN1/pdPoS/Zrr8
	 R/DepvEp0S5K4on39SFZHPkJmSc+xyAQrv+FMUucVDWEehLRL0z7FejPDRqbXORyVc
	 n89PBae4gZ0lJfWhK+jAqTPdi9L5E4rTZETd9Wb/urDk0dt5921E48E5s3fmhZer4c
	 MTiJKSQpvpQrqXQG/InxqTViz7n7xWsApzQh0Ro5ExFubwvEn2TLOwtRYYaU0SfyiL
	 lzKjAeoAsGn92Sk2XA471YtJDFKvuiFF9bOSadnHJE0euBHj8ay2DIkwdAnY6B0xdr
	 Zh86PrlUwnRkw==
Date: Tue, 10 Feb 2026 17:49:49 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: manivannan.sadhasivam@oss.qualcomm.com, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abel.vesa@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, stable@vger.kernel.org, Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: Re: [PATCH v2 1/4] soc: qcom: ice: Remove platform_driver support
 and expose as a pure library
Message-ID: <jkrkp74jgjg6d63ro4inl7ily4p6s35hmhpxeroyzue3o55tto@sgl2b4uv6ysv>
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
 <20260210-qcom-ice-fix-v2-1-9c1ab5d6502c@oss.qualcomm.com>
 <7d61d324-0d26-47ce-aac6-d17abdcf05cd@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d61d324-0d26-47ce-aac6-d17abdcf05cd@oss.qualcomm.com>

On Tue, Feb 10, 2026 at 10:39:54AM +0100, Konrad Dybcio wrote:
> On 2/10/26 7:56 AM, Manivannan Sadhasivam via B4 Relay wrote:
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > 
> > The current platform driver design causes probe ordering races with
> > consumers (UFS, eMMC) due to ICE's dependency on SCM firmware calls. If ICE
> > probe fails (missing ICE SCM or DT registers), devm_of_qcom_ice_get() loops
> > with -EPROBE_DEFER, leaving consumers non-functional even when ICE should
> > be gracefully disabled. devm_of_qcom_ice_get() cannot know if the ICE
> > driver probe has failed due to above reasons or it is waiting for the SCM
> > driver.
> 
> [...]
> 
> > -static void qcom_ice_put(const struct qcom_ice *ice)
> > +static void qcom_ice_put(struct kref *kref)
> >  {
> > -	struct platform_device *pdev = to_platform_device(ice->dev);
> > -
> > -	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> > -		platform_device_put(pdev);
> > +	platform_device_put(to_platform_device(ice_handle->dev));
> > +	ice_handle = NULL;
> >  }
> >  
> >  static void devm_of_qcom_ice_put(struct device *dev, void *res)
> >  {
> > -	qcom_ice_put(*(struct qcom_ice **)res);
> > +	const struct qcom_ice *ice = *(struct qcom_ice **)res;
> > +	struct platform_device *pdev = to_platform_device(ice->dev);
> > +
> > +	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> > +		kref_put(&ice_handle->refcount, qcom_ice_put);
> 
> IIUC this makes the refcount go down only in the legacy DT case - why?
> 

It is the other way around, no? Absence of 'ice' reg range in the consumer node
means it is using *new* binding.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
