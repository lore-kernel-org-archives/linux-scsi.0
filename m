Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E5138DC5C
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787309237; cv=none; b=HfKfWmodAPdpzSGf/s3PAx67ceP1WSxSMdL51FtpbOOaqANtJ8ky7AoyNGDW3EnDuho8td49Ps/KX+yglc163V1i6g2Gr7Ain8ZgAR17f1vjVyHvH84G7Dtfcuk491iuFs1truG2vFFxhUN6O/IWvcgaPBxGdKPuqpBOwo3pFPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787309237; c=relaxed/simple;
	bh=wHFpYhrsskZl/4X9KYmQfWjR7O3bXLxtO1Q5X0MfZ5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FrY4cyNll1XKwbBeKyOfm+jjB/7JPKxhCEMPihJcXoJRXGjjvfyAIpmce8wKrxd8RyC6SnO5Cw7o/MHbc+fVB8v9C48h9S6yh6iQVAZM0zcYzLEg0nN0HCFziDgYTblCf3qk+P55DWARzMPSsTeU1V8folFeD+RxeRu/5Vhaz+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gDwBtTsa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fHl7uNu8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gDwBtTsa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fHl7uNu8"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67L9LgFY3029274
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 10:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=/GrfHFATM8H0RtN2PKqwEH8d
	UdUp25j7RsmR3cGWD1s=; b=gDwBtTsaPCxejIm7DbM5S0ioImRhsHM3wZJPuaRO
	9TitT0VGlaZIIM77IzRWAXa6HyzkuYGcGoXK+PB+XG4xPQW7BWk44CGZPzYHIWFq
	pqU02Tz7YEEDOgPEu/+hI3CTvUpg9O36brvWzfd9EMDVSqqohElJzHcukZ3bs6rf
	bVLnY9u0eTtnMdDJfAhWHQhjaeQtoggLjKgDSFgpqJD+Xf00bYNaUQRo/f1tHWzW
	+BJYgQNWCxlMRz8P3LFlPCigVhXxZrhlFY6HE0SCAjMkgpHklF92YQS1Ybbwue7S
	l4Nfh3kR/Aen0916w3iEdxJgyMTMXo4TMWhIJEkjMGN87w==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g6fg9sa3v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 10:47:14 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso1244178a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 03:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787309234; x=1787914034; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/GrfHFATM8H0RtN2PKqwEH8dUdUp25j7RsmR3cGWD1s=;
        b=fHl7uNu8qORl0zQg/PC0lrqESxeGGoK57akXqzKzrQkjqP1mX4eTUWng6CUTMFtZs4
         /2Dv2stb88mnkorAsw0xMQVBh2LjqZ3VSXxnl1plhqdFFBx27iOBv0S7I3wVeIOLYkJi
         qEu0ayLPpKunzPoIU5Mqyd9xE1tP0VPMy1H85eCBJTj5w6TD2H6mfORXZVy9+Y9wEJAu
         lkbWblZpkaB4ZSw8sE3uLWKSQJA1yY01zzCpsvjY3SE315oQ+9F6IqqghrzZSjt9XASq
         qneoaisqWXNGx4rUd94/Mu3dIwULroJ4E5A5N+J7n9IFj6S3mDQ9qQQL5MwucRb9706Y
         1wXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787309234; x=1787914034;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/GrfHFATM8H0RtN2PKqwEH8dUdUp25j7RsmR3cGWD1s=;
        b=TgYkn8j3KiHAWSfYpzAIGb/1BoJ97PdDrdy8NgsRSUVqR1YZKeAWfEtLFoeLpSA/K4
         tfubG6G+PFrrgUyrVBNIVY9wxnhfsl2RRLWuImHX7IIWoDBE5es3kl/MlGiI/poLTW/i
         Ja6rvmuy8neSEasZ+HG5dzXojcjmBJ07kHUhy9DuOMhZXrvvKldCrtzk9oCSnnZXY/GI
         rcamCcxafwof14zALAZSNtMFBYAFZ497UP+boWBqxVqy+D2XJz1zeJlnZq1JufwpTpTv
         tATbZngnyYGpl7EmY7TonNGmhKU1/09eJP4N0iz4//lUt1HAfNq9Et+4kjnCaRmomK0j
         X7uQ==
X-Forwarded-Encrypted: i=1; AHgh+RpuoW8LPXtiKqDlkc9AfwUCeCZ7/AywU3HWINPtoPCiMF6/bWT29IAVj31nEVOUKCT88VMk70rHNg7P@vger.kernel.org
X-Gm-Message-State: AFuF++lBMp7oDdygXzeINQAFsc3CUCXbmL70S/A7SPaXuGl8y9Vsbvko
	oeJsAQ+ZRh63/tmrb/tkxbpnN0DZmCCrrYEoO3j7ky6CtYP0T7LPH9snYk343YR/I052jf4wfVV
	7Vr0mAoCIcjcXqdWZ2yul4J/re4ownra1YHAicKC83S8EABhe0LoRz2vA2vZQJppm
X-Gm-Gg: AR+sD11hnH1Vd41fzMBXZOEXjUViHa0/HgyawRF613NEL7PmaHA2lLFxuIMGAGI5JEi
	/cjz3DVrBPeHVpCREUszqN91kb50/22vn08gV09QjiOz3I221MEppVJAa0wIF+YELbU1aQVAapi
	McsfqOBip8fAQXo9AZJnk/9Pa7X6ymDYJybTEB798fi57ZKAXARCmUgWk3BZjSedA66GUUTRqnt
	W8d9fvq2Co+AZhejhqI6thvzqkwSpn893fNgojDTsAspVfX7ibRsl8MMCXGqodCHXt3ttDqqW0O
	vPhq1hYUK6UZ0VXDCNb9vCtSvqeW3T/YioT3/4g+5NKXpTNwPQ1vZmjRY6dOuUZnzdYEnDkgsRZ
	OfL0XkBt2UwWWU2BPauqj4GCnmj7PD1NBgpSYLQ==
X-Received: by 2002:a17:90b:2ccb:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-395c35ba5aemr10466208a91.10.1787309234127;
        Fri, 21 Aug 2026 03:47:14 -0700 (PDT)
X-Received: by 2002:a17:90b:2ccb:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-395c35ba5aemr10466124a91.10.1787309233685;
        Fri, 21 Aug 2026 03:47:13 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c42076b6sm2693547a91.0.2026.08.21.03.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 03:47:12 -0700 (PDT)
Date: Fri, 21 Aug 2026 16:17:05 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v11 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aogsqRRgc0is5wBj@hu-arakshit-hyd.qualcomm.com>
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-1-1cebc8b3275b@oss.qualcomm.com>
 <d1232243-2f23-423b-84ac-4463eac79f9a@oss.qualcomm.com>
 <ajjloqm9eOkrr5W9@hu-arakshit-hyd.qualcomm.com>
 <cc8678f2-49ab-4754-8102-d567b94e52e9@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc8678f2-49ab-4754-8102-d567b94e52e9@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDA4MSBTYWx0ZWRfXz/WMpb0PQQil
 8OZLxMyLdJG9adHlQ4789lI7nJfgkjdTkoCxklF9vzorrWthlVcMLO8w9wly55eZhKJeq9mSsVB
 pRz9vNmRcT779dc/GKTqclGvKQ3/t8FBYMY5bmnneUyzk8RzUctN9Qmx4xCtvofU03pyjZwm8Io
 EGI2Tx8ku6d1mmftNwlSjls8ffSvQteuts/YpVyq1PixZy0dL0pj7iR3QwaPIJPhdMxnW23qYbH
 XcjMNMCOvFSaVEAc0l2Cfy11xAr3QPkUYpz+GrqVOk+I2sh+NUIzHNWhtH9DnGR/ccsDto9lMhy
 fTUzuI3n9TY/V2SqeU8s5qK2ZaEQqrj4rBPr/Ka7Gh/5j9VkmVtgJvCCg3H/td5PuEzI2L4zDxb
 UkgES76UJ8JVd538CMGXsOXdQIopdZSzcWeTK1P6L+SdzpWXasoPQFOrKnrjxR7qv8GpurB9PNo
 0dzEs3uV+MWFRj11wVg==
X-Proofpoint-ORIG-GUID: UJ7yKjD5ljbHqiR-ocE-xQ5_Ue12PlAs
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDA4MSBTYWx0ZWRfX/gRlidtJsxZS
 W7Jrxq2xXga+G9GlzPIPyBrkeXW9DrsJqyBWXKJnufgNgWF13n5aLzKQDcsWW9i1wL6zwYQHkfO
 e8DYapJAkkYXmlNNgHNmM35NjAvcESU=
X-Authority-Analysis: v=2.4 cv=Av/eGu9P c=1 sm=1 tr=0 ts=6a882cb2 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=K3LgHJ_EJoQmVUSs8ncA:9 a=CjuIK1q_8ugA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: UJ7yKjD5ljbHqiR-ocE-xQ5_Ue12PlAs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_03,2026-08-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210081

On Mon, Jun 29, 2026 at 01:08:08PM +0200, Konrad Dybcio wrote:
> On 6/22/26 9:34 AM, Abhinaba Rakshit wrote:
> > On Thu, Jun 18, 2026 at 03:01:54PM +0200, Konrad Dybcio wrote:
> >> On 6/8/26 11:47 PM, Abhinaba Rakshit wrote:
> >>> Register optional operation-points-v2 table for ICE device
> >>> during device probe. Attach the OPP-table with only the ICE
> >>> core clock. Since, dtbinding is on a transition phase to include
> >>> iface clock and clock-names, attaching the opp-table to core clock
> >>> remains optional such that it does not cause probe failures.
> >>>
> >>> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> >>> core clock based on the target frequency provided and if a valid
> >>> OPP-table is registered. Use round_ceil passed to decide on the
> >>> rounding of the clock freq against OPP-table. Clock scaling is
> >>> disabled when a valid OPP-table is not registered.
> >>>
> >>> This ensures when an ICE-device specific OPP table is available,
> >>> use the PM OPP framework to manage frequency scaling and maintain
> >>> proper power-domain constraints.
> >>>
> >>> Also, ensure to drop the votes in suspend to prevent power/thermal
> >>> retention. Subsequently restore the frequency in resume from
> >>> core_clk_freq which stores the last ICE core clock operating frequency.
> >>>
> >>> Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> >>> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> >>> ---
> >>
> >> [...]
> >>
> >>> @@ -335,6 +342,11 @@ int qcom_ice_suspend(struct qcom_ice *ice)
> >>>  {
> >>>  	clk_disable_unprepare(ice->iface_clk);
> >>>  	clk_disable_unprepare(ice->core_clk);
> >>> +
> >>> +	/* Drop the clock votes while suspend */
> >>> +	if (ice->has_opp)
> >>> +		dev_pm_opp_set_rate(ice->dev, 0);
> >>
> >> The PM core will quiesce the vote as the device suspends, this is
> >> unnecessary. Similarly, the rate restore logic will become unnecessary.
> >> Especially since dev_pm_opp_set_rate(0) does not actually do any rate
> >> setting.
> > 
> > This section was earlier discussed in the patchset v4:
> > https://lore.kernel.org/all/7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com/
> > The intention here was to drop the RPMh votes once the device goes to suspend same
> > as the storage drivers such as mmc drivers does:
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/mmc/host/sdhci-msm.c#n2946
> > This was done to leave the hanging votes *on* for unused clocks.
> > 
> > However, I get your point, due to mean to say that once device goes to suspend
> > and GDSC power-domain will be turned OFF, it will automatically quiesce the
> > performance votes?
> 
> When the device's runtime state goes to 'suspended', all votes are
> dropped (which then propagates up the power domain tree, effectively
> lowering the vote which passes through the GDSC to the parent CX domain)
> 
> i.e. "yes"
> 

Ack, will drop this in next patchseries.

Abhinaba Rakshit
