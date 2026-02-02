Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BA726A1A7
	for <linux-scsi@vger.kernel.org>; Mon,  2 Feb 2026 09:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770024827; cv=none; b=UI+HkJliNTjxVMOetK6niyGblF7z/K6vCcRWkah/TgdamxR4gIjzvQwN12G8z18HTBZcoH6UCqUDOpKxlogIq8STXdnNEMqYH3f7mIb9ElmqEJII8gc4DWxFBX7rwZzTvfss96vVBvXU8NBa7mZ/lQgQ8wY8tRrr7fn+bpAcKvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770024827; c=relaxed/simple;
	bh=unPEm+1NIuStqMpaoStpa+gtyzS7uVlA6g5lUzFR8+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2XuCsjmgUlRKR8DT1dNu41XHTdh9BLbc9biAlRraqX1eZgx3lNgckgxanQUXH28TNsySNn59juSquz5vnhuL2FaV5sWNtA4mP+fmlTVdz2qnw2oINlU3Ps1VqLYx6SArFcLjB6xcituG7+WLksXuLRwDlemYMQ0enVxa9+1Dpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Hl3Huccn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GGtvUyzY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Hl3Huccn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GGtvUyzY"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61284kK11473776
	for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2026 09:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=gJHUyMi6ir8MaZUDuIcqes/3
	jjyrEWI6G8BBp7lKnpE=; b=Hl3HuccnZ9mJUs/r4VlQZnnsosIAWNfR2vQHiS+/
	8n/D/M2wTxSe4A9Og319ZFJrlavT3UzMSVA9T4KgIhbepGaOTDYYNo4bHHm/HoHA
	YefCr6YKsDGtjRSjEcieIzCRAZvS9F7xi4I+8KhCqRqLKNmnWubEKBTEdCm0fe1f
	OL8Z3D33FxT/TQyWXLgSWMnX7zUoPvnnUjBX0S/YZbZ/r6YIYP2Ar7F6zNAIf0QX
	khNC+mpvtkNHs5PdqNa6mQGtBFRds2W/4u+E/yzRO1OK3QEnB0oMN5/BCknFLCns
	hbdEA8QSY4TxRMT8nPsdokwRZ2b5xYqy7LdUDBqSMAwuVA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c1au2mure-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2026 09:33:45 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29f29ae883bso31005705ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2026 01:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770024824; x=1770629624; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gJHUyMi6ir8MaZUDuIcqes/3jjyrEWI6G8BBp7lKnpE=;
        b=GGtvUyzYI7Vd+rMT360OrD+AnnJl3Caywsio+S267wzXKcnqjEPY+r0oczONwRqZ7V
         nTSdhbfzLZDwl9w5I94x1b2q5ToLABxVmhPGggbgYoE6J4A7I9Enmie9Gt/p9U0FqEpX
         iuPMD2FHRPmoovL+SqIpk8jOGhasf3lI1zobUId1RQ++OQrYf9ulYO3Wsp//+y3uHXll
         JfqcazVgNzoSpTBDDb5DsfTZS7WobqtL3lu6cA9fFnsLUrM+1wA3GeB1yzShclW7x5N1
         IqHGSOrqSqbSCyOOr/s7P05gdsX+76pevJFjM6LbRkhz/8MmmrAuQA3iGtsEVVpdadUt
         cymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770024824; x=1770629624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJHUyMi6ir8MaZUDuIcqes/3jjyrEWI6G8BBp7lKnpE=;
        b=VPDGl0fWdU7s2fEcfg9L9ao401+pW2x44PEQQ6vD9YfJ88VzNgytCcv69hg5K5dIYq
         fgyahLkRV2uALkPMsjZzX2zZI1CYSvlkK0WmWrLB8ul0ki0XkyaWgT0OelZZdDubSZp7
         iaN0KQqr+qXunPOheUoz3qG3MeChv/pOW/qo3bYRpP8Goi20sauIovRDy8rI9DNjZiy+
         7a2nKiSE26OR0uV7GzsdAzLOTKnCQLxy+WvWP461Xm8384+1rWLnu6QtVR9NaySC8fJp
         G7ZwzGu7EjM+0PSaGAfe5kd+IBCruYDuNKN05qE05s8V6H5Zv34tLZyWhpujlkU73617
         VGAA==
X-Forwarded-Encrypted: i=1; AJvYcCVfzLB69uDC2dN763ymg11pM8mtAk11l2gnaBLIA3xMbjWn0wn9X7bQ/5LF26V8IP9YXT/A9NO7fZ1/@vger.kernel.org
X-Gm-Message-State: AOJu0YyibanUILSaLZg+wxq/uqasUQ2UatrfKlhx06DQk4/jnJDoxToX
	cGCJgO0NDagOemSSp7HJBTX8EK3Zc7uI08jYwfXUwO+8PrC3wF4U0L7elfmNFQnBx9rP6swc7QY
	OupQ5F02GV0BlXmz5X5B0NWyyjsOf/rjvs2YF+RPJbiLOCO8LwLyaF+vhgP0CAH/z
X-Gm-Gg: AZuq6aIij4uzF+hYPttkx4n0PbvRCme69t6WH9MkNXdoOMitINf4F8hXPzpRrTxHOg/
	jLJCb3Uke50EA5AsOydGid7yNZLGX9xMEvRGyYMUltGZPZEYjca7fXyUNpK2rJFU8TcJHLh8w/5
	hBLZKwgjXXtovM14fiNeQJAxrc914NpbLTxwSink84F9Jbpp7oWMb8YUxnYrSM6KjR4QlDH7qGl
	bUfTTkz4DEj7hiJqvKpDB7POIMUkwQ1rjkr/aypQcRxqYR8HgISkkw6hr5i9Lcb47Re8Cyxj6nD
	Nxilbf+bSt+obI6+7Ioaj0R6jXpmPUXROW0Wxm2r9hozcXbEpcB0XHX0wPW7F73NyOnFbRLtM3R
	7F3F0w0C5dNE7lAYUZt7oj3yTh/iPqaLE0OeIUXC5fdklaK4=
X-Received: by 2002:a17:903:1a83:b0:2a7:87c0:2357 with SMTP id d9443c01a7336-2a8d96b18f9mr124758705ad.20.1770024824522;
        Mon, 02 Feb 2026 01:33:44 -0800 (PST)
X-Received: by 2002:a17:903:1a83:b0:2a7:87c0:2357 with SMTP id d9443c01a7336-2a8d96b18f9mr124758425ad.20.1770024824050;
        Mon, 02 Feb 2026 01:33:44 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b414f1esm139990075ad.24.2026.02.02.01.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 01:33:43 -0800 (PST)
Date: Mon, 2 Feb 2026 15:03:36 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aYBvcBFVhwbV4UEH@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-2-260141e8fce6@oss.qualcomm.com>
 <20260128-daft-seriema-of-promotion-c50eb5@quoll>
 <aYBE/VljJTUNx3LK@hu-arakshit-hyd.qualcomm.com>
 <13e311fb-1298-422c-8859-1b08201743ab@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13e311fb-1298-422c-8859-1b08201743ab@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: mNEdW_P3RLnqMjwByZL41lB18v4kKefw
X-Authority-Analysis: v=2.4 cv=TtfrRTXh c=1 sm=1 tr=0 ts=69806f79 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=L9uGvZmjxWfCn8EH7uIA:9 a=CjuIK1q_8ugA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: mNEdW_P3RLnqMjwByZL41lB18v4kKefw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA4MiBTYWx0ZWRfX8Vb63+jOtsks
 /sFBLDTNCNrFVp2ipIz4+xCsmfx0j8HIMMfCRAcpGp1/f6Nj7CW5cjkAzDAHjFumit6ivif/2xC
 lVQLAwiG/pYIgAWmybDkLhuN7COWwFMwcFolW+FO3J29GuGnJ5nz+JB8g1CBlBNfXWfsfi8+sfU
 CNFmcjqS79W9y5yy5DEQt9WKd/Br3mL2WhlQaYvb6Q7FdeMN1GPE2V7ENHSCJC0Dqf1/IxiIP/3
 58huhhz89u+1qzEyEHZ3UjXBzMKqhOVVnVwi91sFFrm16gMGh3jCxV/v2mEu+qKkAExTip2XEOR
 A7ot6fxg0hQEC7MtjrnJ137SE3VOBHS4oYC6uAeIkghDufipsTGjacqChD5AfoooYQzwcPyp+Hu
 aMCQPto3ro3zoObqeI8gywj6ZIuC5T1c4vkLHf24ikaW+9yvOnruFKvT20l6g1Dm7KQHXOGt5eY
 a8x+ik9970LZI8wV4SQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602020082

On Mon, Feb 02, 2026 at 10:23:43AM +0100, Konrad Dybcio wrote:
> On 2/2/26 7:32 AM, Abhinaba Rakshit wrote:
> > On Wed, Jan 28, 2026 at 12:04:26PM +0100, Krzysztof Kozlowski wrote:
> >> On Wed, Jan 28, 2026 at 02:16:41PM +0530, Abhinaba Rakshit wrote:
> >>>  	struct qcom_ice *engine;
> >>> +	struct dev_pm_opp *opp;
> >>> +	int err;
> >>> +	unsigned long rate;
> >>>  
> >>>  	if (!qcom_scm_is_available())
> >>>  		return ERR_PTR(-EPROBE_DEFER);
> >>> @@ -584,6 +651,46 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >>>  	if (IS_ERR(engine->core_clk))
> >>>  		return ERR_CAST(engine->core_clk);
> >>>  
> >>> +	/* Register the OPP table only when ICE is described as a standalone
> >>
> >> This is not netdev...
> > 
> > Okay, if I understand it correct, its not conventional to use of_device_is_compatible
> > outside netdev subsystem. Will update as mentioned below.
> 
> In Linux
> 
> /*
>  * This style of comments is generally preferred
> 
> unless
> 
> /* You're contributing to netdev for weird legacy reasons
>  * that nobody seems to understand

I see. Thanks for correcting me.
Will keep this in mind while submitting subsequent patches. 
