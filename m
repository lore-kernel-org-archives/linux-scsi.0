Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800ED4CA29F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811815; cv=none; b=jxhC7A3b8PUeD4R5x6R+yWZOA5rgysV4Z3gX8S58iH3APiA+VwTs944lKQjbuwnMxaBUMBoDbznd3QkIbcl4TqX43Eoe2gPWCJdrshfBFvlLwzk8ZAi2CfNZ3opc9UV80Y+Apq+07dQgzmpYfeJGOWzr7zuXEX9pMfkwwopgHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811815; c=relaxed/simple;
	bh=o4I21Izv9BhqeNzRRuSgO3vorZoOkvzJ/7C19kIPh/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tvyqimotf6EvC9PTjAPcRkA9z1eELZy8n3wgoT4nqdw+hK+0jD5HkBifMwIO3EP+vQjCq4/HtNyYNxzXEegVX6il0F7/H5CCF/ZC7zUSKLuUYrwAR5YKNzNtmswDfkI06WIjKgEJrdDfmnyFHDk0M1taU6Y0GAYo/Zcd7Us6orY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pX9MhGfn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aW8yvnf3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pX9MhGfn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aW8yvnf3"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NCvXRE3954477
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 13:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uNSSLfxtoiUMkYrN0H0VYtMiS9IIkqhLoMRgaUQ/d9k=; b=pX9MhGfnt1WQ8PVN
	JO+Zt0Mc/BbxqCMj8s8WwkqpJANa8ojXWaV+oMjOst4HkNViKzrtqkFXtANm4D/t
	3wuXoScRh67SQ4GoMJciNrzMY3I7rRJ65cxjmF9498scJbeeoW9+fIvgVCeuOUGr
	fzWyZVOsvngWKHOzjr4DqxcFd03SO4EPKPxkS6fibwGSWWs8XqnHdR7CVD5T2M8w
	OXQfxdLIDwMR8qnDhsWjKLvOa1FDd8aePtEHMLyF55YZueDeeCh8++NMKd3zziKG
	YIOcjw/MMhkzWAvJNREXAgQEfdR/gUFbD83Wv87CROEgfxLBuJCA0SyIurxM7HCx
	Qr1h2w==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fke0ksf4j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 13:03:23 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c069f73e4so1960951cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 06:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811799; x=1785416599; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uNSSLfxtoiUMkYrN0H0VYtMiS9IIkqhLoMRgaUQ/d9k=;
        b=aW8yvnf3bR2CK+Cl+zKi+yaLSCFW9H585HG+kPH1KjwbCL7LxGsK9CwYCsBZkAdH33
         pe17urlP5WGwfXWkXwsmpvT35DlGRk47pQllWzLbx1riE7tT1DDVtv/rqO0QGT1x2vfb
         gOj8FL2yzDWYyH6LQQdJYPR0gByLpeN5319ACosej2RDqgi3M55Ej8DZ7jLFoh5VocEf
         WZlVrWCW33CmVFBsYLKpkrCsEr85MZjATvvcWoCS/zxqxqV90JiOMX+CxMW6hDJYlq1k
         vvqN6x2iSd/RpDQPoXPKaMDCTTYaUOnwGCLwkFsrXWNgK15MiEng1e8jMTW9EekgZIJY
         6VaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811799; x=1785416599;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uNSSLfxtoiUMkYrN0H0VYtMiS9IIkqhLoMRgaUQ/d9k=;
        b=naG4CFVKu+LAvxCylKirC8IN0gzSQWgGLsjfAayVfSLS38TJ7ohWT/Ma9IKP0+BA84
         CWITJOWvfPeuHdYacXm7y0YBfZgAtClQLsc1I+ar5SEkb59gZOi4yeXAvHrVBCSdiiSR
         LPCHzJyBM52O6lmhvPsdsQnysgrUkfLJRRkgKy1u7xkZiX6Z8QLwitJV2ZO1FIel8GbH
         h4DnWNq58a+eoja/MXjyQ3tse2aB9374IqF2oxtHLMa9RhO8Enk0WDeWqFshv1RDR7Kx
         qzuysJTZc8AuaFW2C7uaLyPcD7tqN8uJMicpnxR5HIu1eUUaC/gZVz3Spg4x0Dh2aTEZ
         i8pQ==
X-Forwarded-Encrypted: i=1; AHgh+RqYu6utk8VBpJByqlgpLjqLPhD1YBZKvnyXG7fqapvkPyLrV8FreNZV1/y4Mi+xGvFqmMC9SDwuoNMP@vger.kernel.org
X-Gm-Message-State: AOJu0YwKf2QUmcj6mPNAsebXNGG3faJvua0zq+f3+eyeTOxmvHj+Q62n
	0JCmKWn5rIiOOswoesvlNN+5gVGaq3MA8oSW6VPmgh8DW0boagwVZKZ+8HvLMN+9QWmB/+jOhHG
	bLZDG/qM6jzUAZAvQIhg1wHIv8p9ezVYr92ODTcQTgjeJqZgvXjQ3oBc3Bf1Ce6rJ
X-Gm-Gg: AR+sD12VVmO0epY0/tskkdy1BdtlfW5tn9kMumU2WONsUMsEW8VbyDkZbJtJrd3F8s6
	hKJCYCx3n5XTqPh00JYrxUZ6T7uiIMG2Cg+XH62ymwscUKVt/L72mh3oD7pvsoIS0N1xo9ZkLsC
	6rnAednPuGp2fqi+zaDSsRTwRTIHCh+gb9/4EaL2kuRTGyj6YOS6DdSmH6oWxjfR0azSx07s5f/
	Xs1mvvHg6GU/2q6fhII7pmP2/WeFS5zAIG+8sAVAxQGMd/O//Ui13YcaA0hgqxb7FEHAbFB4c3S
	pV1IB8ufxnfyFLlzrEDZrJOziM8WUXQVFFkWZBbyzBZLiGCOjNFyveTmdUwh8FLdYLHq9d2yTNF
	BQ1KzA++8BdVPBTqytlu7hwMz
X-Received: by 2002:a05:622a:64f:b0:51c:83f1:bcd4 with SMTP id d75a77b69052e-5283db3bd2fmr22151561cf.0.1784811799012;
        Thu, 23 Jul 2026 06:03:19 -0700 (PDT)
X-Received: by 2002:a05:622a:64f:b0:51c:83f1:bcd4 with SMTP id d75a77b69052e-5283db3bd2fmr22150981cf.0.1784811798317;
        Thu, 23 Jul 2026 06:03:18 -0700 (PDT)
Received: from [192.168.120.193] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2a9f48edcsm991679e87.73.2026.07.23.06.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 06:03:16 -0700 (PDT)
Message-ID: <b23c6186-bc24-4312-b5eb-3a6c5f459b55@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 15:03:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        alim.akhtar@samsung.com, avri.altman@sandisk.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
References: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: e_PybvpcaypYUH0IuGlR9lf8l0d9X2YM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyOSBTYWx0ZWRfX+KuLKzUqGZPs
 XT/dum4qg96wVkgXMdQ+txdpyzenlOuHuITw3+AWLUisVbWZQmJghnVIcBljwHVoLjg/UeXcKrE
 eEoWsqiZKlznryaXDIGfKbI4np0uiTI=
X-Authority-Analysis: v=2.4 cv=S7DpBosP c=1 sm=1 tr=0 ts=6a62111b cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=vq3bXs1Fwz2bHWXBoJUA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: e_PybvpcaypYUH0IuGlR9lf8l0d9X2YM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyOSBTYWx0ZWRfX0pIsgMlwdn7G
 uXpdnK57UryfDsrVFrwRdZn1raen1XQAb228V1kqYCL5XgA+fogkJ+H5hmpwR1546BQDZ2mlOE2
 ARMccldCJJ2uJYpEcUlA1MtEfXgVkpP4un3PKPL+pvf0WiEqJ5iwu4qUPkZcqfNYRI+umh7lOvd
 Q8hQCWFAn/7zplYH9dXzO8jEfpa5Ew2L1pU9VkxVd+sNxLliX3pKUCfLLqtNc7QTMUuNzYqfiD2
 xUWJeyG9reaBZANs10BBj7vxPvz3shjaqnsH3bUsmCWphxoaSxYqs+bwnCQolzmbC6moQDW9tzb
 /oUPFXBdCTId4aJ5ZiAqlBtzLZBtfewGnWloMCux1P3vPPbQsAb4oL/aXVZzk2eMKgRviWz7b24
 hvIajyidYgNwfOl4tTT8ltLUn7FBeta6TywCdg3THICHauvrX8IXLmk1k/0QdKeGgOjAPOEp62j
 5nQ3e7yg69RU2SPeNIQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230129

On 7/23/26 2:47 PM, Manivannan Sadhasivam wrote:
> This reverts commit 85b2b966285498e1b551ac85f02c79cd06c0cff0.
> 
> Qcom UFS Host Controllers do not support scaling clocks when the traffic is
> ongoing. But the offending commit removed the block I/O quiesce in the
> clock scaling path, which causes below UFS failures during clock scaling:
> 
> ufshcd-qcom 1d84000.ufshc: ufshcd_check_errors: saved_err 0x80 saved_uic_err 0x0
> ufshcd-qcom 1d84000.ufshc: ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0; saved_err = 0x80; saved_uic_err = 0x0; force_reset = 0
> ufshcd-qcom 1d84000.ufshc: pwr ctrl cmd 0x2 with (MIBattribute 0x1571, mode 0x11) completion timeout
> ufshcd-qcom 1d84000.ufshc: UFS Host state=3
> ufshcd-qcom 1d84000.ufshc: 7 outstanding reqs, tasks=0x0
> ufshcd-qcom 1d84000.ufshc: saved_err=0x80, saved_uic_err=0x0
> ufshcd-qcom 1d84000.ufshc: Device power mode=1, UIC link state=1
> ufshcd-qcom 1d84000.ufshc: PM in progress=0, sys. suspended=0
> ufshcd-qcom 1d84000.ufshc: Auto BKOPS=0, Host self-block=0
> ufshcd-qcom 1d84000.ufshc: Clk gate=1
> ufshcd-qcom 1d84000.ufshc: last_hibern8_exit_tstamp at 196451913 us, hibern8_exit_cnt=20
> ufshcd-qcom 1d84000.ufshc: error handling flags=0x0, req. abort count=0
> ufshcd-qcom 1d84000.ufshc: hba->ufs_version=0x300, Host capabilities=0x1587031f, caps=0x124f
> ufshcd-qcom 1d84000.ufshc: quirks=0x0, dev. quirks=0x310c4
> ufshcd-qcom 1d84000.ufshc: UFS dev info: SAMSUNG  KLUDG4UHDB-B2D1  rev 0400
> ufshcd-qcom 1d84000.ufshc: clk: core_clk, rate: 300000000
> ufshcd-qcom 1d84000.ufshc: clk: core_clk_unipro, rate: 300000000
> 
> Hence, revert the commit to bring back UFS on all Qcom platforms.
> 
> Reported-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> Closes: https://lore.kernel.org/linux-scsi/al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---

Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # SC8280XP CRD

Konrad
