Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26BB32AADE
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771586147; cv=none; b=cB3qexKC9uHH/lZCi8zIP1IbmUSGrYJ7UJRUBZhNPXb2TcyLXVAx7icEeM7gT8SNCrmuTwkrh+OHbt+n6yOdFIASlGEjuUfVa+slJTbvHGBQ4BvoRxbAkNB+2P4Erdx3k6icsFSKRMtvpaQgpglh5TvEJQwwK5FQukLq775sUeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771586147; c=relaxed/simple;
	bh=U7jG7pwKgorBrNi2MpLPry9SRJx9mEM+lupPKzoDmS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6PrDK2cqjPJ02PWf8RlUHKoBO/gm5hCS57bNaaunKfOoMIG2KWf3ilo7A4X16ard7SI5wJDyDBFf/A13YpvjizsXkDDwDw/zCVGZi7ne1wCcTOSmwSvzz6u32sRQX9PzHAl6D2PUS27wciZwFYLhDPPgmYZ06eo2oKxkeni04g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=en7PT6MU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PnoRQiUI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="en7PT6MU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PnoRQiUI"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61K5RpD52552662
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 11:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=b2GYOalqmiTplVooSJ9TenZd
	k0ZNjxw6paig2ezJLo0=; b=en7PT6MUG8JNUziVY5gM0Vb1J4sLtuA31epz4g5I
	OUQpyNiD8xiBkQrTN/sXtsUdS0TZni9+LkBJ7fTPXViXAHjaVAwEg+E8XL90xSgv
	CH2nkuypCPw2KkjfM692JIwr3o1Bjh3Bgmxv/jUxXP1vVrM9to0P2UlSF1aIrmXT
	6i654tEJqgbwNt3XhzjWMmh7zbQgOiP4yv/x5HgAv+rz/o8Ka52e+SGXOLfNIraA
	YOfcvQoU0o3/QqdCEeEj4INqZ/itjHkAKy/kFG9j3iIdWS+JBcu8DYnOBIlfT4IZ
	XLXhnFphCEezuE/3kcjPqXsn4uN7kGWYuWn6JYAF/dzSNQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ceh7t0u5v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 11:15:45 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-824bf5fe8cbso1017703b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 03:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771586144; x=1772190944; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b2GYOalqmiTplVooSJ9TenZdk0ZNjxw6paig2ezJLo0=;
        b=PnoRQiUIO6/IDRniTrItmIuzMsLTbfQWWuLcC3YrKHWchRttvSpvyHaISIg7Knhu80
         lduSz1vyj5naSdzKovdzi1aml5tpRlwESDih2pzA2QcXtkwiHjvvshbCb0+PYjAV+ctP
         SlhDJLlqayYfXnnFXoI5SzcCNjtXV79R4i5rKn0jJo1462MG6TCHrWSgD+aPzVcajP5L
         LPg7Ve5wwljreef7GpAuzYjkPg41ix7d7HhNada9IhaZ3E5hi0H35YbOXzgMmcsldrX4
         rnDz8WOvQSk/kGdQw3bZrwPcfZTynPJTzxGAzpTBt84YUXRvW0yKsbOaDhOg5HwDq+2T
         WwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771586144; x=1772190944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b2GYOalqmiTplVooSJ9TenZdk0ZNjxw6paig2ezJLo0=;
        b=I7lWcTkfsJxo2RcGN/CLhV2cY2uwGrhmuWgbKSpfzK7iJnnNunjL3PHC6U8YqV5QLS
         hMj4e3XSp/LdHZlcjnyj4dyLD6TsNtXtQA6yfn+Vs9ZKQUEpZNDjLvlfKxzbqliVkFkk
         geY9WN3zQzAUIl+9ML6GlvogQPwdj/puKVmmDOuyQRebs/J8gkUapD3sMq+0X47XZrBF
         2UEdvnrCCY5AurbvG3GXsr2eyUCCN0ALASm4xCn+wejllF2C7hgjaHEUFBpsz/cBioxg
         jwLekJqb0Raa9H23YadgLU8ffuYNgCMZ86CYj33o8prJJCMLfmtE1/cHj/G39M99Ak6w
         +x8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5zcvqYPYjvqdASTBeq+c/aO/8Mvb3/QuFNyYzZw2sN1bCrT3JWuaGukiRyQnfsd57kt3Vheky4hiE@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/3Mwmq+t/QKfG+IpeoPdxODKZRczwLednIkGH4pNFh6w+bI9H
	R+Fzs1B7vkQFup/LTuoU6jwLVuR492juoAlM3a/FnQ4r7I/eW7QC5edrjG5ZOsgOd+dOK2oLMlg
	Ekq+guteShCvDe23Yo/Bo2353lseCjIV/yU8rpelq92c3QVKjzsUCfY8wwn2ITWNaOCskhhWh
X-Gm-Gg: AZuq6aKg+8QQ+ktPPNzzl6ggl3sSQtwiQVXLg0G44MU3aZ1njbHo0SiGSzeDauuD35T
	589JEenP01F9HBmxUR0LQ3hrCznuEdbsfu1tLn/I+jrSAbQblLVNa3+RmqvGJfbtmav1QVdbLmj
	kJ3RCaSh6nEg8WMS6156w/1FEywqkPXrOUQJRlT11PobGiuGTTjDL8XpS9IZVbC98dZ9IpuN9Eq
	ulCG3/iCpUJ6wldknDH8NeS99EV6hQQnN/C1JClf5W99OnxYq5MdYtmZrQmFdk9Sfu52ZqnU+Xp
	9KQgXnyf9mvH8BJNrRxq63j4f/QXk+Bj7vtUy+18KKuMFVQk6J6SRvAD7lDD2wft7lhGkpkHq6Q
	JsDmB1yZYkYPBCxpxIAYwc1snkdMYpW4+f2eR5PMVbf5ZDXpgn1Mh8mfTeys=
X-Received: by 2002:a05:6a00:439b:b0:824:16ae:9ec4 with SMTP id d2e1a72fcca58-8252771735cmr7655817b3a.63.1771586144203;
        Fri, 20 Feb 2026 03:15:44 -0800 (PST)
X-Received: by 2002:a05:6a00:439b:b0:824:16ae:9ec4 with SMTP id d2e1a72fcca58-8252771735cmr7655793b3a.63.1771586143732;
        Fri, 20 Feb 2026 03:15:43 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6bb5acesm26585871b3a.63.2026.02.20.03.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 03:15:43 -0800 (PST)
Date: Fri, 20 Feb 2026 16:45:36 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
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
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aZhCWMTi3seAbXo5@hu-arakshit-hyd.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
 <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
 <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
 <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
 <6d2c99c4-3fe0-4e79-94e8-98b752158bd6@oss.qualcomm.com>
 <aZgOUv+QweA7vE1W@hu-arakshit-hyd.qualcomm.com>
 <5bf31bf9-835b-4b87-a4d0-8452d516f13c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bf31bf9-835b-4b87-a4d0-8452d516f13c@oss.qualcomm.com>
X-Proofpoint-GUID: -ruahHGWOKY0mSqXQVGHFGkk-CWU8z7F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA5NyBTYWx0ZWRfX628PnIUPOIh3
 HCmAzhdq/mDxtjy/bGm/53JabjEHlMR/RUl6mFNcu58GUu/Wsb27kDcOCUSfoFUHAhGl/1jkXj5
 BqSYVOo42ZjKN51jh+6e3Df0+kOC6jXiQcS5e4trB0uA/KZOxbjbxap0CmZ6L6NvGadnttY00/M
 Ok8iFw/Vjb6F001fae10Net0pUPoSXuVHgNHt7/O8ar6BYNxxEO10mtdYFtENqiUS5OWxS1M5KW
 6bOFPisf3kWfmzHNm2YWLuLwg0MAlqxFeOtlkstDQb0o7sgKWXnSJGJRp69386g1LffL9PNvSLq
 bgHIbNSmtIQ7Tk6OSrnp689Jl3wHK+483/F/Vc2RVkH8WQufqOjJJTSYA0xki2QDTGNbsg+HzO0
 ULvg0HX9tjEdmmU+QXoZD1aUPk9bEMI02HH+wVLxYbLKkSLwUaBqaTFkseJ2h6V89K6n84E57ur
 jD7Oo46rAcD48M/bxZw==
X-Authority-Analysis: v=2.4 cv=PcTyRyhd c=1 sm=1 tr=0 ts=69984261 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=-r4YXHmrKH74x9D_t9cA:9 a=CjuIK1q_8ugA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: -ruahHGWOKY0mSqXQVGHFGkk-CWU8z7F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_01,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602200097

On Fri, Feb 20, 2026 at 10:42:58AM +0100, Konrad Dybcio wrote:
> On 2/20/26 8:33 AM, Abhinaba Rakshit wrote:
> > On Thu, Feb 19, 2026 at 03:20:31PM +0100, Konrad Dybcio wrote:
> >> On 2/18/26 8:02 PM, Abhinaba Rakshit wrote:
> >>> On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
> >>>> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
> >>>>> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
> >>>>>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
> >>>>>>> Register optional operation-points-v2 table for ICE device
> >>>>>>> and aquire its minimum and maximum frequency during ICE
> >>>>>>> device probe.
> >>
> >> [...]
> >>
> >>>>> However, my main concern was for the corner cases, where:
> >>>>> (target_freq > max && ROUND_CEIL)
> >>>>> and
> >>>>> (target_freq < min && ROUND_FLOOR)
> >>>>> In both the cases, the OPP APIs will fail and the clock remains unchanged.
> >>>>
> >>>> I would argue that's expected behavior, if the requested rate can not
> >>>> be achieved, the "set_rate"-like function should fail
> >>>>
> >>>>> Hence, I added the checks to make the API as generic/robust as possible.
> >>>>
> >>>> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
> >>>> play, but the latter never goes above the FMAX of the former
> >>>>
> >>>> For the second case, I'm not sure it's valid. For "find lowest rate" I would
> >>>> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
> >>>> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
> >>>> so I'm not sure _floor() is useful
> >>>
> >>> Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
> >>> and ice-clk >= storage-clk in case of scale_down.
> >>
> >> I don't quite understand the first case (ice <= storage for scale_up), could you
> >> please elaborate?
> > 
> > Here I basically mean to say is that, as you mentioned "we generally set
> > storage_ctrl_rate == ice_clk_rate, but latter never goes above the FMAX of the former".
> > I guess, the ideal way to handle this is to ensure using _floor when we want to scale_up.
> > This ensures the ice_clk does not vote for more that what storage_ctrl is running on.
> 
> Right, but what I was asking specifically is why we don't want that to happen

I would argue saying that, having ice_clk higher than storage_ctrl_clk does
not makes sense, as it will not improve the throughput since the controller
clock rate will still be a bottle-neck and it will surely drain more power.
 
> > Also, this avoids the corner case, where target_freq provided is higher that the supporter
> > rates (descriped in ICE OPP-table) for ICE, using _ceil makes no sense.
> 
> This is potentially a valid concern, do we have cases of storage_clk > ice_clk?

As of now, on the UFS storages (targets KLMT) I dont see the
storage_clk (FMAX) > ice_clk (FMAX). They are mostly equal.
However, I am not sure, about all the other targets and cannot
call the same will persist on the upcommings as well.

Abhinaba Rakshit
