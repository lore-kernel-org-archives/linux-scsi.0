Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6733A36E47B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 12:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773404519; cv=none; b=JN+T2fVWGHgRSW4IN4keQNM+BHM319UulgbUV84bJsdKeSQafo6SKYEKC7j1S13Tm74zGPUV6iNN0Wx+vcKnxNgClA2k1E6WjjnsVEM+RdFXrTQG9CwbjiIHDOk4DSxQ+bCq1KzwaDFasco16rcElIxsO5bLBPfa1fdxUVoaQBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773404519; c=relaxed/simple;
	bh=AJGpXmDrUPBdtvW9aSuAbhP6GwiLGVccEpCoB2Y4N/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XoZ47f2jBihmgADQn/cgyz4hSirdBacPaSlk3rsNow3P4j0MOtmQj2ArlNRE5OYU+Gqo2Kw/8KCbo5Yd31ZbcR6gMjVjHie1EWQhJk1HgoF10E1v8uTTPKXWtrT+OqvI7LSKNP4WZF4PbgUBo8SLpl/qMKUMyv62mYhG19GuOc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=orqwxLlr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XgTTd/5S; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="orqwxLlr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XgTTd/5S"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62DAsH6O526440
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 12:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ncKVZp6XtiWfN25Y+BVjRXsXzdPkB+4zTH8BJYoYgGQ=; b=orqwxLlrS/9Ywxqj
	Bvz92jzH+oYMtGt20OCM3gr3SDKkoVANZRarBlonAz05FhS2a7MJncV6x5Hxe4ks
	C6lKsi2wIg1BJLZ90pFDJx1YSXkPECOAkRptqdNcZzdE+3KjVWbyLoPeN5PDR4J/
	TbLSH8LXLDbqsJIdjJNW68MLNLbe/6y+7Qnfzpxr6NV06To2J1Cvw1VVXxMx61Mx
	fFUq/WoaoOUGzcuac8Ce+NV3m//8i3NQ3QraRjG03nrwetVQC9B0cCjQFbERToK2
	T8+GetsECcFtIOqW6YdqJksmJyVkchsw5g97epYEBhi0YeCU768D9OrGq2Crd650
	ujnVRw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cvh84r7vh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 12:21:57 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ae57228f64so21581565ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 05:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773404516; x=1774009316; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ncKVZp6XtiWfN25Y+BVjRXsXzdPkB+4zTH8BJYoYgGQ=;
        b=XgTTd/5StA46X8FfLJzZShfVIJ5PS7327rChveMxhOG8rq8+z49wBrSpbybNG9MWXl
         NsWSCOsapm7YkI93aKeN0Ft+ZZ+2HLdDf/fonKIYp3H0M0IH/i46/ZADa4zON/Acrf51
         wOOfz8QHVmQgwLPM7pcdZ+6sm90rLpMVgRwWluoKrYBw2IMe1sTh2hB8oCGRQtbzwQTi
         KsZ3vP4fbM9YhRY88wQWQfQrlZUvoD6YhcyaB09jLtAR+G6vTBNBYg15AED//IZC9C2g
         GnIDR8FNyUhcDX5olcwVq7eUODEBPNWc9Ohv9vBnzvg7HOa5U5AgkqJBc3hnRp6NJrv6
         qYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773404516; x=1774009316;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncKVZp6XtiWfN25Y+BVjRXsXzdPkB+4zTH8BJYoYgGQ=;
        b=d59c3zIXEL8hCy8WddwdDnmc0sfkTNYnUPF/Fxbze8vaqGM6WeUh2PGzw+8n+8dg5M
         WX7cKBU2mSZFGr8m5U69wGjbM0/FnMypgMEbv9h8wtWvgjjeH/4aeqrUshtgnX0KeBJ4
         ybZMubO3GcfqGvlgErJbRAaEmUc/7vzuFlInbymFzPiFoKRcWsIRTJgvTKdQPmBacsmE
         qV/ORfTbEF2PYFdwueZ55uLp4sBACypF0SFW/oEQGjDzQCoA35vDb8MILjcgNBMR9ydu
         gRoEnN0kP02fiD7iZSFUoXiBAZklj1LMhH5ZaG2plxF1ksSg0F9HmVDBOFU2t6865mgm
         DvjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbEx4vCKgJ1etfK7PG3+k8/r0Jk1C01vevIVXOkLkrcHJEhNDcMJj5NR9VOLsNblGPiReNGmdkPiSK@vger.kernel.org
X-Gm-Message-State: AOJu0YzRvy0hxq1pdDEMqMtNarlsz1xtxLeladVEsOH8dooiHjuX+f6y
	paKCkAUW9cfBYumx30MjSK19A7TQYEMoqAg3EZjNl8A1xB6AZdiocvcK2l8FmB8KJdBH7PbF6H9
	6khWkDu2MkDJjf1Qw6CXBVDeZRp8G3e6EFfpeweTZCsooYYAEOL4h/NaFwgvPf1Pe
X-Gm-Gg: ATEYQzz+nH1qpzLIAkj2+8yV6BfCYPTfPxgAYfC9rfmfVdoLn0NseaWPweQiEnbTnEV
	SPBWsScLV7rRAsf+GRHdF+4y9JRjnPXm2/L1x/6JZChIKjuKYED6shWXGm7mDnncIwKahxrGuAO
	cOyJBGzqseQLa23vYz/KlyOQzmYhCVH9IUA1YFCVvV39dNCg5dpSq6aZxawAmGCnPCDOK8lJEcC
	eQxa6+EaPQRFOfHLYfIp1gcqdEkXorS2dCJM9ZWjLzHzxV60NGs1JwPrdUzYWJlVVDyKpYwnZ1H
	nrl6TN5PRZ437yLfHdaXUO0N33i1y0Uoy3N6PuWE33YCu4Z1dW2ILkT1tu9nTS3uBvwiKoPaIE8
	A+Dw8vkugcOhY+UM7iNtma3EHhK5TWFqNmxddFBYVKbDvkpx/RhCL6OBb5nw=
X-Received: by 2002:a17:903:1503:b0:2af:c7c:afbc with SMTP id d9443c01a7336-2af0c7cb19amr7817095ad.31.1773404516357;
        Fri, 13 Mar 2026 05:21:56 -0700 (PDT)
X-Received: by 2002:a17:903:1503:b0:2af:c7c:afbc with SMTP id d9443c01a7336-2af0c7cb19amr7816555ad.31.1773404515583;
        Fri, 13 Mar 2026 05:21:55 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed9cdsm22318995ad.60.2026.03.13.05.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 05:21:55 -0700 (PDT)
Date: Fri, 13 Mar 2026 17:51:48 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v7 0/3] Enable ICE clock scaling
Message-ID: <abQBXBNcrwgBpQYH@hu-arakshit-hyd.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=OMoqHCaB c=1 sm=1 tr=0 ts=69b40165 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=FNyBlpCuAAAA:8 a=EUspDBNiAAAA:8 a=nmp4smzA0mTOGrukFIAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA5NyBTYWx0ZWRfX2Zte0KCmBWXM
 2awURyTEe85fERJsQTA1NGEDCPch3aWpNCvjlvP5q4bUQsEiqPhhLvIsZjMxlYOJHiz3D52blgW
 Aqgaow2uOlp3NoOfSelLBX5xzlxV6M0YralxfWWDQK1clMf3vh2/nlqzcVrpUwIK1WIwWHFSs8e
 1KHfsM7uCHYBugUOWPBU7WbP/MQDUxKeHBjdg0kY8I5pBqbKv/F7PpRUMq8yWxb5TTgHfW6/1WK
 lja6qJaS1g8MJ6M4zlCFgq9cV+ZO4m8f74cLvrmqKKqakTNBNITTr/W+QbmU1kpnr7x3nV3hg4r
 MkRU/pUZNfg8ohJEaAvsxwu5RsgicJEs8rIx9BXhP9L/nAjPpCKu5N7fOdmc1hiNu1E+SzUxzdD
 FJP+GRdR7APqWMiN+B+SQGY8OBqbnK8/4s71fFliqGsik2yQ6cX4zGslF/2nV9f07wxCHSdZ/uF
 PulHjCb46J8SMsUr8VA==
X-Proofpoint-ORIG-GUID: meqemqugy6ps-glFP9vCTI63yYPqd6yz
X-Proofpoint-GUID: meqemqugy6ps-glFP9vCTI63yYPqd6yz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603130097

On Mon, Mar 02, 2026 at 04:19:12PM +0530, Abhinaba Rakshit wrote:
> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> using the OPP framework. During ICE device probe, the driver now attempts to
> parse an optional OPP table from the ICE-specific device tree node for
> DVFS-aware operations. API qcom_ice_scale_clk is exposed by ICE driver
> and is invoked by UFS host controller driver in response to clock scaling
> requests, ensuring coordination between ICE and host controller.
> 
> For MMC controllers that do not support clock scaling, the ICE clock frequency
> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> consistent operation.
> 
> Dynamic clock scaling based on OPP tables enables better power-performance
> trade-offs. By adjusting ICE clock frequencies according to workload and power
> constraints, the system can achieve higher throughput when needed and
> reduce power consumption during idle or low-load conditions.
> 
> The OPP table remains optional, absence of the table will not cause
> probe failure. However, in the absence of an OPP table, ICE clocks will
> remain at their default rates, which may limit performance under
> high-load scenarios or prevent performance optimizations during idle periods.
> 
> Merge Order and Dependencies
> ============================
> 
> Patch 1/4 (dt-bindings) from the previous series
> (https://lore.kernel.org/all/aaKt9PET6lVkBcif@gondor.apana.org.au/) has already
> been applied. This v7 series therefore includes only the ICE driver and
> UFS driver changes (previously patches 2–4).
> 
> Patch 1 is the change which should be merged first.
> 
> Patch 2 is dependent on patch 1 for the qcom_ice_scale_clk API to be available.
> Patch 3 is dependent on patch 1 for opp-table parsing to be enabled in the
> ICE driver.
> 
> Patch 2 and patch 3 are *not* dependent on each other. Once patch 1 is
> merged, patch (2,3) can be applied independently by their respective
> maintainers.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
> Changes in v7:
> - Replace the custom rounding flags with 'bool round_ceil' as suggested.
> - Update the dev_info log-line.
> - Dropped dt-bindings patch (already applied by in previous patchseries).
> - Add merge order and dependencies as suggested.
> - Link to v6: https://lore.kernel.org/r/20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com
> 
> Changes in v6:
> - Remove scale_up parameter from qcom_ice_scale_clk API.
> - Remove having max_freq and min_freq as the checks for overclocking and underclocking is no-longer needed.
> - UFS driver passes rounding flags depending on scale_up value.
> - Ensure UFS driver does not fail devfreq requests if ICE OPP is not supported.
> - Link to v5: https://lore.kernel.org/r/3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com
> 
> Changes in v5:
> - Update operating-points-v2 property in dtbindings as suggested.
> - Fix comment styles.
> - Add argument in qcom_ice_create to distinguish between legacy bindings and newer bindings.
> - Ensure to drop votes in suspend and enable the last vote in resume.
> - Link to v4: https://lore.kernel.org/r/20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com
> 
> Changes in v4:
> - Enable multiple frequency scaling based OPP-entries as suggested in v3 patchset.
> - Include bindings change: https://lore.kernel.org/all/20260123-add-operating-points-v2-property-for-qcom-ice-bindings-v1-1-2155f7aacc28@oss.qualcomm.com/.
> - Link to v3: https://lore.kernel.org/r/20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com
> 
> Changes in v3:
> - Avoid clock scaling in case of legacy bindings as suggested.
> - Use of_device_is_compatible to distinguish between legacy and non-legacy bindings.
> - Link to v2: https://lore.kernel.org/r/20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com
> 
> Changes in v2:
> - Use OPP-table instead of freq-table-hz for clock scaling.
> - Enable clock scaling for legacy targets as well, by fetching frequencies from storage opp-table.
> - Introduce has_opp variable in qcom_ice structure to keep track, if ICE instance has dedicated OPP-table registered.
> - Combined the changes for patch-series <20251001-set-ice-clock-to-turbo-v1-1-7b802cf61dda@oss.qualcomm.com> as suggested.
> - Link to v1: https://lore.kernel.org/r/20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com
> 
> ---
> Abhinaba Rakshit (3):
>       soc: qcom: ice: Add OPP-based clock scaling support for ICE
>       ufs: host: Add ICE clock scaling during UFS clock changes
>       soc: qcom: ice: Set ICE clk to TURBO on probe
> 
>  drivers/soc/qcom/ice.c      | 89 +++++++++++++++++++++++++++++++++++++++++++--
>  drivers/ufs/host/ufs-qcom.c | 19 +++++++++-
>  include/soc/qcom/ice.h      |  2 +
>  3 files changed, 106 insertions(+), 4 deletions(-)
> ---
> base-commit: fe4d0dea039f2befb93f27569593ec209843b0f5
> change-id: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9
> 
> Best regards,
> -- 
> Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Just a gentle reminder regarding this patch series.  
Whenever any maintainers got a chance, I’d appreciate a review.
Please let me know, anything pending from myside.

Abhinaba Rakshit
