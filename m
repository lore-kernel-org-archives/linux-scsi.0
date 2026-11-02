Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605395;
	b=ew4byJe1gJOJdYPUCuWrU/pTDCM5oYtKk6q0s/U2b2jw3EaRc8v3RtT44Cwbnwlw6RUa
	 xwFm/kMhcnuzyQQ4IN79FIVti83WTvn+TfWmKuyqS/QCBjBUlysy01RPL+eY5JH55ibaD
	 VjUkUjcweZZm5/kHuiaoleiVaxYVVqQOZzhoftMs1L1eHG5ZPK2OvDZAO5iU2c0Y8loBm
	 OuVGwmxblFEhqy2OFd89vH/LTbwXnDFQKx5AuH945wZuWyzW3dWUzOEptrTXiGPUP98+Q
	 sLUM3xliqenvte2Xu1zQUCH1g9lAVI7trIxwYuO3eb6tdaTDq7ha9qhe2U9Nl4BKFCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605395;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=klOv1N84yVFiX5VyeIBQfSwBuik5rDbfaMDuPGgQBP8=;
	b=FoRtdHhjcbV2dgsw7TaXwdUy4ac7TOOs0FwMiffGFolywn+2PEaeyiMXEiaAjsH6zSLU
	 kJwmS7EQTR9QMGLWUMXF9AmsTX65OtLqjQZbbnkNI/h7/h9UtJMoA7DcE00+AeWJHJCrY
	 0Lua9audTUELDlT3eI0J2EELQtYByv/BrTJ6Zahq1POceV3xtD4kYPkVVLU1L57q8GSA0
	 sT7/KbIbYyUC8M4IeWHO6OzobHy2UXCinRfNHtzaJlUAe62vIRcGh/F6k4E9GRSazUoWO
	 YTGzYidFQSuPniq86xL1ijJv6lMapmIg/B1rOSHdVqRcFc0xO2KsarKUsxJNtW0Lu8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Otw4bcgG;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RYap2Or3;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EBD606A329
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 07:43:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4EBD606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Otw4bcgG;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RYap2Or3
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A24DKsu2433769
	for <linux-scsi@vger.kernel.org>; Mon, 2 Nov 2026 07:43:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	klOv1N84yVFiX5VyeIBQfSwBuik5rDbfaMDuPGgQBP8=; b=Otw4bcgGn2SZvAAU
	SHiX5S9Rrnm3QRUvZgrsRrqaD1dQiFSlL6Md4O+n4J4OGWK5rdgqDryMx/ELO3o9
	XR2WZjLrBBBBT+XfyZi2JUlFaOkcZFTcMnIirfWcxJ1gx1u7d1dEJCtVS4f2vl0q
	V4JDx9bri+DEGBQ25AaMFinqdsyFdOtaaABhZ56xYF5mpOgBkJM9Z2CgbBpcEBsX
	Oe5llLh5WSVoaj/VW1LSKDHpP/+Q8VOLXwrDkVpMXR8btuMadadyEdw/PwnqDFeQ
	n8KbV2HD7uzE5n6SLGqsl/i50c4wroRDDp3Vgls+M+01/nSjtv46kjeJyHRGqUV5
	mvmKFw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hpka60nhd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 07:43:13 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91cc59c44f1so8595076d6.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Nov 2026 23:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793605393; x=1794210193; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=klOv1N84yVFiX5VyeIBQfSwBuik5rDbfaMDuPGgQBP8=;
        b=RYap2Or3Tukg37XesOeKdFJSljYjcNZwZb37F8HMEYHwXH1f0DsIqPC3M7FqOa6AC5
         IArWCNtX5iqn79suJRj2fA+OENH7A/pcMU8S7W0jqbj//UEmRzvl9klABB0Am4ShHUVn
         kEKVEZuocpcjWAMc9d6I7EXWeRsI6ORw8pcICyc9MobjYSjMa6/OhcMqQnd7SmCGcV7O
         VjVHZrtiuD8M+T9EX7faVKHP/hFASvTHaTv4Txwp/rxZPrQHgR+w7zs2WanZkx5bGdXa
         07x5bOXw9amWZN5Dez8WccKXY8267+8rwyqGN1H0JvnwGVGspyuwXIR7yWB8Jxu3s5LI
         G0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605393; x=1794210193;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=klOv1N84yVFiX5VyeIBQfSwBuik5rDbfaMDuPGgQBP8=;
        b=JOe2cvndxboMPqCn10o1tJqcN9qvR3FTMjvV38M36wAnJFISqYQye+LUJ2SS/haiDP
         khncNHqrGowgRaMhCojRkKov6uZGpNUxCLMFfx1DCetBD1Wf/k8fTqtEHIqf4P4jd+Ed
         DdUIjqLy7310sgnmzi5704/mwkYAMV/5NOqPB78eFK3a8eDeUljocvCtR1PmkUTMWmGR
         LY0eLcwvZDA/JRb2Dk4K33d3SHcUB25N9B4iXSxJmQ8tQqB+ntpfmVSNsnEmKrEU3ci8
         iZ8qIgH1GND1etCYOX0ysYiRBKG0AIQM1Tx0IJ37DCqK1NdgPF1arGLZwNV+ok9jDa2o
         2PsA==
X-Forwarded-Encrypted: i=1; AKwUvByy8Bqn1Ju89jMd2umQG7IL8V3QrcN/u2T+RVuYuVD/Sp+9bSIMHZBYmQiyLfp4gwUEjawkOMApwzeR@vger.kernel.org
X-Gm-Message-State: AFq9FYKdv5+dJml43pBCNUs83ch0QDoJkGS3JtzpbTRbMt21hPJtehie
	cHQU1JiSoYLsef0nXS0SshES6VNBNgIktvaDqFvJCqS6D+GPHPNrN6bBUcs18r/kL4m7dmkNssx
	lDwkPnThaV6Vzxlc9T4K0ycSbAN8+r3rE4w/qixps8RjG1x+/K00p1OKsZf/7CwkN
X-Gm-Gg: AYBFou0o9E4AsrPzA530JoIMLN7lyL0OFmYmPBKG0BqMzGDKuGny3xFLQuwkYDffFkh
	CV0pd338xo4i5fhUhw/CgNcanobdzki7Dqoqo0J48vUErne79PHSMuiy06KQn9CWxQ2dBLOmwkW
	dZjKFvcMvRXNf84CiWue/MN6PbGhPy8ZYBR1ohvMrze908Jw1tV24edwpdS01T0vYK2mX63u0HM
	R4mEuwHP7fyOoeKcD1mjNGPE/qHv+aR0HHlO2iDFUOrwTfSH4ZoQ83ApNiqgerFAk6KpmlBgtkT
	e+84Zq7W5ER+Fgc6yeRglT1I0Jk9RX7Qrm3+yfjooQv1CSTXzKxHEpinGCuVGdNBW9SSTYHfcmK
	9Hc+YQGWL9k2wTUq1JAcWEBPx55OlsA9P00b7kzYeSMb+A2fq+agXeeU2GUWaWE+IcXruxfGmvg
	==
X-Received: by 2002:a05:620a:29d4:b0:93f:3cb0:464b with SMTP id af79cd13be357-944216f1ff6mr1455248985a.49.1793605392619;
        Sun, 01 Nov 2026 23:43:12 -0800 (PST)
X-Received: by 2002:a05:620a:29d4:b0:93f:3cb0:464b with SMTP id af79cd13be357-944216f1ff6mr1455245285a.49.1793605392157;
        Sun, 01 Nov 2026 23:43:12 -0800 (PST)
Received: from [192.168.1.110] ([178.197.218.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b723cdsm18976337f8f.12.2026.11.01.23.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 23:43:11 -0800 (PST)
Message-ID: <151dfde0-4057-4ace-88f3-3939612e4dde@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 08:43:08 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/2] Add UFS Host driver support for SpacemiT K3 SoC
To: Trevor Gamblin <tgamblin@baylibre.com>, Yixun Lan <dlan@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman
 <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>, "Martin K. Petersen" <mkp@kernel.org>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jennifer Berringer <jberring@redhat.com>, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-riscv@lists.infradead.org,
        spacemit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-riscv <linux-riscv-bounces@lists.infradead.org>
References: <20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org>
 <DMICF1DA617T.1TZ7DMV5WG818@baylibre.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <DMICF1DA617T.1TZ7DMV5WG818@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: J-8daOi6rqfsPPrM5T1NOrLQYxkD725l
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAzMCBTYWx0ZWRfXytLn1vWGv2BP
 RGUpGbdKlJRxxTL+K3f3ouLVAb3u4U6OXoHH4tFsVMR32I+94EPpUz7lXcapph7EpxiUrBUw/lX
 GyBvsye7xJL6FojU1SMvmZXZaDBY65E=
X-Authority-Analysis: v=2.4 cv=ZbyIpcVA c=1 sm=1 tr=0 ts=6ae83f11 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=uyPgTw0bjBTS2cVxpiNm5w==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=IpJZQVW2AAAA:8 a=T2WrtOQxrTuvjP7BPBsA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=IawgGOuG5U0WyFbmm1f5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAzMCBTYWx0ZWRfX4fi30wfV9j9X
 ohlqrB2PV0YWYyNMK4ibqKjtzvIcLItUS/mxPEJxVGfNDE+XMEE0GZgJEfpohGRTeR8U8oNZ7pH
 6Gvo8dbWVkCVuQqSnwKvDJza65Gu6xPD7sMLYq8UHNFEMUnqLdO7XgtvDbqeo78S9ykcej8ec2y
 3Xp3kRpPWob/kWFpbbvQO9W5ox2YAgT9xorz/kAOKays+mXmy5TvVTnAbPHoPZnlu/VizwAqsrH
 bYOuMUsG6C7udNA5CPJf4fbM73bXOelVG4t0wVQ+U2jYKwL1AHJkJq59MlDiZCIJFIHy2prqV19
 d9wIkqhEfuGxKbHLwXy2zeqtqLUA50389KkK/u/3du/z9XbrHh5uYl2XnxXaCbsRqxgof3XM1zJ
 9FYIDshSqUzIRb+O0g7icQeoOrZwrhPBb1hftksVGzfBPZ8Hvw7wln1Ias7WGnKsEkzzGkQno4+
 Fl/IlS0hciBL3usP48Q==
X-Proofpoint-GUID: J-8daOi6rqfsPPrM5T1NOrLQYxkD725l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020030

On 30/10/2026 18:19, Trevor Gamblin wrote:
> On Thu Oct 1, 2026 at 11:10 PM EDT, Yixun Lan wrote:
>> This series try to add UFS support for SpacemiT K3 SoC, the controller
>> components consists of System Bus Interface Unit, UFS Host Controller
>> Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
>> Management Entity (DME), Transport Layer, Network Layer, Data Link
>> Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
>> block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
>>
>> The DTS patch has been dropped in this series [2], and will send
>> in separate series once this patch accepted. For people who want to
>> test UFS driver, please grab the DT patch from version v5 [3].
> 
> Hi,
> 
> I've been testing this series (and the DT patch from v5) successfully using a
> v7.3 kernel in Yocto's meta-riscv layer. It's been working well with fastboot
> flash in our nightly CI. An example:
> 
> https://forgejo.baylibre.com/tgamblin/boardgarden/actions/runs/827/jobs/9/attempt/1
> 
> For both patches:
> 
> Tested-by: Trevor Gamblin <tgamblin@baylibre.com>

No, you cannot test a binding. Otherwise explain me how did you execute
it on the device?

So if tag does not apply to 50% of patches here, why you can't just add
it to the ONE single patch where it applies?

Best regards,
Krzysztof
