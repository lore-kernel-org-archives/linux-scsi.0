Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4F1356A37;
	Wed,  9 Sep 2026 07:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937362; cv=none; b=r8IzeP/3cbwVAN/dMHpDRRV804cQ+mitnLYws7C2XWdwTrvMoVN/c7ajfmWCt6CYBkeCLyRAujCCpPX+GdohFbSdN0DBcqPSrth+Rz6UQoCZif9Yx7mlfLujUH7CAqGFtMqun7Nc2V6T4sqCtLsnPxlm4CzwWnwYaybsQ6evN1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937362; c=relaxed/simple;
	bh=X+p/elP5znXz4MB+5bGyv4tE0rEZTl6txlKb1psgtMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fu2en4aQCd/We6vCnd0Kma7hKUjV48zSzgaWEeUUdZw6Ec4TUFJsA6kE8TmeZoj4R2Uspf9GkIUE8GuQpId/TFjkqePEYBtiCbLZ51a+0Je1d8/1lI2lRZwUyi5Oh3Sl1WC01EdcF4AXrEs+MSlEH+XuCB2E33QoNnUoo27Sq50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sp7q3RS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sp7q3RS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B8F1F00A3A;
	Wed,  9 Sep 2026 07:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788937360;
	bh=MN+dOdcZgKnOYNLGoEa/8edxId6RZtSoX5rv7uwx14c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sp7q3RS/k1YrPFVv5B0KdxlDcBrWuM8hOB+yNshAo8fRKBeoJn0Blhxyn3re1+I8f
	 WxOIaRR1h6UxwtPTyjr1T/OZzKHuYsAfiJWI/WMXF3/cwR6c3G2fbe6kXRI6AYmDy+
	 CtfCL7awHNkCHeeqrnBWx9wSGN6rd5UnuH3qnV+/SJqMnEkg//zH+EhtYRRd0KMz3A
	 RrxTrwNzrkQv5ueS/xj5v9Q6RsCjLyZI3G+RwjU8fFiCTIhDVXH3YGFy+ZIc+iTvIa
	 K6i40NEM/5m35CZKkv8rs0OEi9Wo+5rij0nJ9r0th1xpR2xbQplhmkDF71xJqnh1/S
	 K1JJk/ZRUXFZg==
Date: Wed, 9 Sep 2026 09:02:31 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: krzk+dt@kernel.org, robh@kernel.org, conor+dt@kernel.org, 
	andersson@kernel.org, konradybcio@kernel.org, James.Bottomley@hansenpartnership.com, 
	mkp@kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Ziqi Chen <ziqi.chen@oss.qualcomm.com>
Subject: Re: [PATCH V1 1/2] scsi: ufs: ufs-qcom: Add specified gear support
 for multi gear scaling
Message-ID: <4vpqu77mkga4syxisysq2mvby7fhf7qfasasvnzubskj3tq34n@5hm56swqkuqg>
References: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
 <20260829074355.946543-2-nitin.rawat@oss.qualcomm.com>
 <stik7u2o6ydje6ws7cyrltmdw4wz6iyximnxeyegw2f562b2bv@4m2sueuuzisb>
 <50e348ef-2d9a-4197-84ca-99d3902cbc37@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50e348ef-2d9a-4197-84ca-99d3902cbc37@oss.qualcomm.com>

On Wed, Sep 09, 2026 at 10:34:58AM +0530, Nitin Rawat wrote:
> 
> 
> On 9/2/2026 9:32 PM, Manivannan Sadhasivam wrote:
> > On Sat, Aug 29, 2026 at 01:13:54PM +0530, Nitin Rawat wrote:
> > > From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
> > > 
> > > The UFS clock frequency and gear speed do not necessarily have a strict
> > > one-to-one correspondence on all platforms. Introduce a device tree
> > > based configuration interface that allows specifying the HS gear
> > > speed for each supported operating frequency via the "opp-level"
> > > property in the OPP table. When this property is not configured, the
> > > driver falls back to the default frequency-to-gear mapping table.
> > > 
> > > Signed-off-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
> > > Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> > > ---
> > >   drivers/ufs/host/ufs-qcom.c | 30 ++++++++++++++++++++++++++----
> > >   1 file changed, 26 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > > index 0f2e083b04fd..aa2ac2cd2b69 100644
> > > --- a/drivers/ufs/host/ufs-qcom.c
> > > +++ b/drivers/ufs/host/ufs-qcom.c
> > > @@ -2460,8 +2460,9 @@ static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
> > >   	bool found = false;
> > > 
> > >   	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
> > > -	if (IS_ERR(opp)) {
> > > -		dev_err(hba->dev, "Failed to find OPP for exact frequency %lu\n", freq);
> > > +	if (IS_ERR_OR_NULL(opp)) {
> > > +		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
> > > +			__func__, freq);
> > 
> > Don't bring back the '__func__' marking please...
> Sure, will take in next patchset
> 
> 
> > 
> > >   		return 0;
> > >   	}
> > > 
> > > @@ -2489,12 +2490,32 @@ static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
> > > 
> > >   static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
> > >   {
> > > -	u32 gear = UFS_HS_DONT_CHANGE;
> > > +	struct dev_pm_opp *opp;
> > >   	unsigned long unipro_freq;
> > > +	u32 gear = UFS_HS_DONT_CHANGE;
> > 
> > Nit: Preserve reverse Xmas order.
> Sure, will take in next patchset
> 
> > 
> > > 
> > >   	if (!hba->use_pm_opp)
> > >   		return gear;
> > > 
> > > +	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
> > > +	if (IS_ERR_OR_NULL(opp)) {
> > > +		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
> > > +			__func__, freq);
> > 
> > Drop '__func__' here and below.
> Sure, will take in next patchset
> 
> > 
> > > +		return gear;
> > > +	}
> > > +
> > > +	/* Get HS gear speed from 'opp-level' */
> > > +	gear = dev_pm_opp_get_level(opp);
> > > +	dev_pm_opp_put(opp);
> > > +
> > > +	/*
> > > +	 * Greater than max gear means that there is no specified gear configured in DT
> > > +	 * or the specified gear is invalid.
> > > +	 */
> > > +	if (gear <= hba->max_pwr_info.info.gear_rx)
> > > +		return gear;
> > 
> > Sashiko pointed out a valid concern with this check, please take a look.
> 
> I reviewed the bot's comment. The concern raised applies to the case where
> the gear value provided through the device tree is higher (for example, 5)
> than what a UFS 3.x device can support. After link startup and negotiation,
> hba->max_pwr_info.info.gear_rx would be 4. In this scenario, the condition
> below evaluates to false:
> 
> 
> > +	if (gear <= hba->max_pwr_info.info.gear_rx)
> > +		return gear;
> 
> Execution then falls back to the switch-case logic. If the current frequency
> does not match any of the predefined entries, the function returns
> UFS_HS_DONT_CHANGE, which effectively maps to the minimum gear. Shahiko's
> suggestion is to instead return the device's maximum negotiated gear using:
> 
> A couple of points to note:
> 
> 1. If the current frequency does not match any of the expected frequency
> entries, that is already an existing issue. In such a case, simply returning
> the maximum negotiated gear may not be correct because we do not know the
> actual gear corresponding to the currently programmed frequency.
> 
> 2. The patch under review does not change this existing behavior. It only
> addresses the handling of gear values that are within the negotiated device
> capabilities and does not alter the fallback path when the frequency lookup
> fails.
> 
> 
> Considering the above points, I believe no changes are required for this
> patch at this time.
> We can revisit this behavior separately and evaluate potential optimizations
> in a future patch if needed.
> 

Fair enough.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
