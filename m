Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E8E284693;
	Sat, 29 Aug 2026 07:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787990010; cv=none; b=Vx0K6X28F00Z3zvjh6jGI9K3Imlt89YtgB9aiCQ8GDxP8q7FaC7dE+B+vwsp2RA02RtZSAtsiEInP7ibD7CpShrHxroaHU3c/+3HRE9pIGJpOr2Yj9l9JkBfKOgHOkKoF6qPNarTOF6I1nHOLLrtdFO09bl+rPvb2p6igbc7EHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787990010; c=relaxed/simple;
	bh=5FDn16gPl5WvH6TVmRyzmlZKiawpkgsYL7vZvSP1dns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SFepH0WAXfTefI8n7fao/2lr49bBqffqnthYTw3wxENi0dTRbzjmnA93ixA1F0EpVLRGebAW9wY7yIXyKFk+LlzJFCVPH8pNBXuRFfN2mF3FWPcon3A9TEI9oBTLqyVR6Jv1hVxuabUTDZzZ6MOHTrd245PSB6P4/cRLkCGHyp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6WT1pjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6WT1pjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB4D1F000E9;
	Sat, 29 Aug 2026 07:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787990008;
	bh=YO640cg4KkDoPu6JIxmzDpTtvCZfNIwwo21iVY383+Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R6WT1pjppF0BEjcsHyoOuIgN6jdyq19SgViRjsJ9H3jL9Ni+knU49FYyZ8AjUDJAw
	 3v0D19Dwv0cnzS2PMjlKfcvboAlLpc+2mE/xsfUg3DciQsKseCQyLLfGnCDNbeHgBG
	 /LU1Is6FkuTdZDuMM9InJH5C92uXOHAyqasn69IQAg/lj+5F+SamwnT7doChnHmw2r
	 gBvsP51AiLKIoRIOm39lnSQ+nhQ7Jg0FM592wrYbHp4Xl1ba921tCobqU1eCva21n7
	 EU7pVo06xHaG+fxFhmleAi6Iqso+/5wF/OQj9XkgB0ec1ZfE6KmSGs8wdb5mknfZ9y
	 xqfwRqWmiOKzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 2/2] arm64: dts: qcom: Set specified gear
 configuration for Hamoa
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nitin Rawat" <nitin.rawat@oss.qualcomm.com>
Cc: devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260829074355.946543-3-nitin.rawat@oss.qualcomm.com>
References: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
 <20260829074355.946543-3-nitin.rawat@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 07:53:27 +0000
Message-Id: <20260829075328.5BB4D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incorrect fallback logic when DT-specified `opp-level` exceeds the=
 negotiated maximum gear.
--

commit 1074dd135232851ffc9d0417dea7de1323a012a4
Author: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

arm64: dts: qcom: Set specified gear configuration for Hamoa

Assign the appropriate UFS HS gear speed levels to each OPP frequency
entry in the device tree, enabling proper per-frequency gear
scaling (G1 at 75MHz, G3 at 150MHz, G5 at 300MHz).

> diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qc=
om/hamoa.dtsi
> index 4ba751a65142b..bc7383937a293 100644
> --- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
> +++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
[ ... ]
> @@ -3992,6 +3994,7 @@ opp-300000000 {
>  						 /bits/ 64 <0>,
>  						 /bits/ 64 <0>,
>  						 /bits/ 64 <0>;
> +					opp-level =3D <5>; /* HS-G5 */

[Severity: High]
Will adding this HS-G5 opp-level break devfreq gear scaling if the host is
paired with a slower UFS memory device, such as one with a maximum of G4?

Looking at ufs_qcom_freq_to_gear_speed() in drivers/ufs/host/ufs-qcom.c, the
retrieved opp-level is checked against the negotiated maximum gear:

    gear =3D dev_pm_opp_get_level(dev, freq);
    /* ... */
    /*
     * Greater than max gear means that there is no specified gear configur=
ed
     * in DT or the specified gear is invalid.
     */
    if (gear <=3D hba->max_pwr_info.info.gear_rx)
        return gear;

    gear =3D UFS_HS_DONT_CHANGE;

If this DT configures a gear level of 5 (HS-G5), but the attached UFS device
only supports gear 4 (HS-G4), the check `5 <=3D 4` evaluates to false.

Because dev_pm_opp_get_level() returns OPP_LEVEL_UNSET (U32_MAX) when the
property is missing, the code seems to conflate a missing property with a
gear that simply exceeds the attached device's maximum capability.

When the check fails, instead of capping the gear to the device's maximum,
the code falls through to the legacy hardcoded switch block. If the new
frequency is missing from that legacy block, it hits the default case, logs
an "Unsupported clock freq" error, and fails to scale entirely.

Does ufs_qcom_freq_to_gear_speed() need to explicitly check against
OPP_LEVEL_UNSET and cap the DT gear to the negotiated maximum instead of
falling back to the legacy behavior?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260829074355.9465=
43-1-nitin.rawat@oss.qualcomm.com?part=3D2
