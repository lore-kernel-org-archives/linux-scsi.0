Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A36633B6EA
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 10:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781520160; cv=none; b=gvYZnuLpcPyoJdCPZY0B2RUUxZLK597/OfL7G2YRiawUiNJF/Z0GxiC9lDDWvfZGbGgME/CQGK9bBwOQ2Hn0n0vygE0hPwcTmt1OSM1sz1PC+y6uYD25PqyeIx3iqKgDEYTnWihuxQ1Nb79y7RK6G+wBpQPpvuH0cDWJJSld6Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781520160; c=relaxed/simple;
	bh=PFv8Bc1QwX3m0kl0RA/mhRJh7I4ymyWI54an8mkYJ5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozu/t6vLMaQk/WMEKc3N9YMCxDIeiUiVxhfE9OnZyvSnNNV0zdeQAlVSd01TLcNUR+dKVW21TKYn38+rtgReTJ02Du/Py1IoUUHgUlVUJodQRQSg7imXlgEa0jdfhXqQUJ+UI2tG2dTq5Z3uyV3+aoNw00+MwfnKkuaAJ3t/GH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FE0O22jw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ijfl9d3E; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FE0O22jw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ijfl9d3E"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FALKIR084762
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 10:42:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MoDrHo0nAAL3euwZduxOxWenFYYl8H0QyMF+HqYIOj4=; b=FE0O22jwl1QN8hIZ
	DmjPlCC3hQkvfTaA2H6gCjt+UATlBBsb3pfMkg2pQMM997S6JuGnbRikkHgVxIDa
	hwsMIRLi/gES5do6pDcVbjDW4S/1mKbEoN28be/dUT5uh3IQzYx6hl5TIKNm02fR
	Zc1dng4tQa7KCDZgxXiBSPvWviLFEmn/Wx/PUORtEkJkrN4o3MXVFGv8tjCpdBDY
	nG6LcHOrXe5V0W8R7/T48Y3WjNVA7r5BmLign8SaMDNiAogbDOPEdGtj4mKR4hGJ
	R/yWXfAVbtM4RC3T416GDY6x34c8DdfUp7SWbqDkelr4J5Am5WIZyTc4HIhhUmSo
	wuOgQw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4etetf0939-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 10:42:38 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2c2b64850easo15104845ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 03:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781520157; x=1782124957; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MoDrHo0nAAL3euwZduxOxWenFYYl8H0QyMF+HqYIOj4=;
        b=ijfl9d3E+ISbC3tNnJmFbvsh6oaz6Vw9BqBqTlrXPGI0b2lTHGsAQJXcSzEEaNb1OT
         +PApx5lk4skIAVPqBSo9cUpD8FsIx8cULV6kiJcPZvvkp+6lAHYv/AMVOqT4DSDWRKfY
         QIFagz8RigiaeruQJCKA8usKhBPtSCM+xlsKGUzT6eLLusS6G7lmyQRMiHPMymebR5Vb
         p2r3teXMSTwOzrvK7M0lv5/AV2SBHfg1v6tG8/hegZ6VGjZNkZUcKlvjyV1faqbc4d/Z
         4YsdGUIZvIsYiXU8xIgP3ec1raQoDiGQSEhAh9o9y+g0MDfOImBGnKTVYEjQKhEkPVAm
         B7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781520157; x=1782124957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MoDrHo0nAAL3euwZduxOxWenFYYl8H0QyMF+HqYIOj4=;
        b=dGihmaec4HsozNT5/swJezDRWpI9UO8jRDWzhApqZ+e4zl8FpJcI/x6qAjQQyeLdd/
         iVPqBKkGZcsO7y1571+TQW2ZrXhbovR+ZHXJGDHeI0vyhoBAeghp1nwhMWOm0YBTHnvb
         87WfXkZa6nDST+G5AQKhbyy7XthEuc26Hr7g9pb0LWWLf9Co/lDhOPOgKiLFcLnVrSDC
         Lx202wImfMogC+d3A0AnEGcVxUgGmgqlDeEsNUIk2d/gBkatwvc26Mvo6MEsEmIFcKPp
         wOJnhVyIDOXMGchdHyOjruJSEKjNMWTZ1UJCX2GGQslT9QXk1JDK8RsZReP9G6r1SAmo
         P2NA==
X-Forwarded-Encrypted: i=1; AFNElJ8RTBEJXstZjkDkXUtYN1aKcYK7CicsxCzricoO2PzwLYEk/sizOedUoG2bnJ9MkMvobbI7/9MCJIYI@vger.kernel.org
X-Gm-Message-State: AOJu0YywLw0C4WEsV0EYdj3q3gqvdZffihgAXCVkiknyz21WNgkb1OpR
	Zz494Dgdoj7BGqJ5oey53UxDXsNu9MvanmAU0X/Z1YXVtRcKqPvEJuPEvmCP1iOJs0ULejpXTV9
	csScOIS+vMpB1aPHChzmRwaOmdOY8vG7b95AEO5Wd4+7kbGVfusXyFnfaOb8JmRF8
X-Gm-Gg: Acq92OFAf2ibId2ifjfHVCm6Thn8ZPbcEhNCocScvTzc/gGn5EMm/kwkAxo6buQPPv7
	g22zqHO69bDZzp7aH+HN7y9c9YKtjZodGtGMnUscg+my7qClshPj3ufSIgKoasqh8HNtVPcHyRH
	3wYT1av9cmckDoE7eyVNcZo7SigynVKx6B0S+AtU6alCfBwKFxXjku22nkd0QDR5VR98lBk7oUu
	R9dPb8pE6CxMKdoPLEOFW0qpmdYLnecFkVfd3jzWatfuhuCUx2nlYVsdIrSEHR3VsjP/7/kXASH
	w2qY2P3bbf2DIOJej5to1y/Lqg2ozCXHe1J12hbpHLipZWMvddjA55UHO+tKSb70UBTegs/ux76
	al5f7T8/C/pUtDEIjaoTfe8pYyWhpKgEtDHe9UQjcdbRY3Hf0r2QJgg==
X-Received: by 2002:a17:903:2acc:b0:2c0:ab92:584c with SMTP id d9443c01a7336-2c66426264bmr116470955ad.25.1781520157221;
        Mon, 15 Jun 2026 03:42:37 -0700 (PDT)
X-Received: by 2002:a17:903:2acc:b0:2c0:ab92:584c with SMTP id d9443c01a7336-2c66426264bmr116470495ad.25.1781520156732;
        Mon, 15 Jun 2026 03:42:36 -0700 (PDT)
Received: from [10.217.223.142] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f1f0f19sm95512865ad.10.2026.06.15.03.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 03:42:36 -0700 (PDT)
Message-ID: <16746ff8-4b33-458d-9c41-3f43bdaca4e6@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 16:12:29 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE eMMC nodes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
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
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-4-1cebc8b3275b@oss.qualcomm.com>
 <184dfbd2-4781-4dc2-9165-66b3617bde0e@oss.qualcomm.com>
 <ai+x7Ovc9/pPTu9f@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <ai+x7Ovc9/pPTu9f@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=adxRWxot c=1 sm=1 tr=0 ts=6a2fd71e cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=ENEOTGz1k9nZZJ794AwA:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: 9yM2v4xjRPTdb2m92zDPnYJ3tfdC8Twt
X-Proofpoint-ORIG-GUID: 9yM2v4xjRPTdb2m92zDPnYJ3tfdC8Twt
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDExMiBTYWx0ZWRfX97PbJE9Fi8Fw
 9MU1NccLhDa4v15upz2OeK/ABkzIWJTDBgHXHq4en8IziMkjpWrJZuZPrU8BC6UVBZUaYCa6MMY
 tz82M0viMWR0b3uAkWlvidSYBKKPDFk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDExMiBTYWx0ZWRfXxnWY7L42HpPO
 qskElAo4tCpezPsF+ZXBxnZLQob5z9SvDETCxx5MAZoFWpUzWWs+DlOqOPW+ikkaHsWW0PYzlDe
 IZT1Taa7PvRfXKXJCC/Vmtt5j+3l3ySE7Kj1KREWjfkHG4e4sHJLfMZq53nUIJScVCSUf6jSS8y
 gz94gibTpEhNsp+cuenYHVOogCUClGXnzt4ECLfQJcrBvQoH0sNkhTLnfXmTKtHtK7qdGkLAcvN
 aT43AdU5C44+/Lx/SKdnLhSgw5mU2KOj8yQm0vEB+DvhexfnAxqI8FkCIMaLUrjlFcyx21VCijO
 umyL3sMx1sjbCg9gjNRS2ag9a5lk2ZO1FZzWov1XCAS3aWIsA044EnBNjnFokIBo7tGJCoLbZum
 3yS90rHlYr9djmcdIrYcdLlOsQKakBznv9mjQo3YHQDQIQ8ZhIVBLyZNU06iO3+ryvdTQT1n1Ns
 fZMOtn9ljL3FrvPoZ5g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_02,2026-06-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150112

>> To align with sdhc_ice(as label name), can we rename to ice_sdhc_opp_table?
> 
> Do you mean sdhc_ice_opp_table?
Yes.

-- 
Regards
Kuldeep

