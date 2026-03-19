Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65767285CB9
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773899394; cv=none; b=HNDUuyPYmahnxBu/Z4PJrmqYvRa7f7y/G83lpBHm1LEYTqqEJq5hqiB1+xPl9tp/Jqw3bM1wQRd18OnbVTu5toevXxgwS8ngR76zF7KnLlUsTI9M2meHc1tEP6BypJY461Uv+jLyWJ55LxaHJwc9f0NQyPCFc7vso+x2fTQoRdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773899394; c=relaxed/simple;
	bh=IPNmg/QAX7oGxoUC4oxWan2FFCT85H4qf7WyrH8Pgnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sBEb4MvP35DpZyY0kdtcmWAi7ZWXz5+kmThq+81Y4wu+zLw8ivSDhJRszR72v9P5USXTw2UuCO0vmzC4OyPZGbBcUdRTgBYjW4gujoXK941qPkqti2HTMffr+YuhmarSBHKMy762haHeYlyUpIri1W/5Y8Sq1s784PO0WruzL3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RhHKaTJ4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Svu5oW39; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RhHKaTJ4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Svu5oW39"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62J5XeaU2348039
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pnlY8HB3yDdOi+HU00GrZcKC7F6O3XJWo7Y53P6upBA=; b=RhHKaTJ4QUXHgzIZ
	FRSSpEqYtBx140tZHNarzUC2dd8jzP8pCn9frm9c1BoHT8g6mfqsZ82Anejuwlpp
	MWb0hCHL1TyAFrA1fypAhM1YtcEtC1zBaB8VhnnjOraftvTq1u0C8QX2EY4Aa4ks
	2hHsA/jg0Phzs89utm4ONnJE7g5kVK30qG4KgNcm7r2WLguAgQQryH6CtVZztCNC
	7VsFsxVAMNNmOqnoHTSXtJTk29ywPVUpJB07J9JICpYYuloorCgsXyCzGArr5/5Q
	S+q7YvlDbzrDA1puMxyKoxBwD3FWa87kmxBEuK0v+5m5k714Mpl4WxXephxveaXA
	+LeBXA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d0957rb1f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:49:52 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b06395b7a7so7943745ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 22:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773899392; x=1774504192; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pnlY8HB3yDdOi+HU00GrZcKC7F6O3XJWo7Y53P6upBA=;
        b=Svu5oW39F//jO9oD6M6LMxbP1c4qEnNiXd7kD6izz60dzXNZZT8vl48/cLbOGLlgSt
         GeJCG0MOae81Hts0tm4tMXSESzBZ78MsiFBj1dew2ahpEOtU0X7GezFX/eokMzgSSFZT
         5WbCOGX+iy3K9wXLgG0hPgS1NjxeYWTGi2/MFFSK7uI8w81mrqOKdHHAw+RAfhnrlQpk
         F6vVb1bUmhmRvAnegtexWU9XekT6d48kNilXUhDiL3tpFvRVMRgsFTt4TnbdoDvYSOnj
         jyF3hnTX2lBg1xQYnWjfjqZ/J5Lp0aqxGcEN2fST/Dq2evOFOI5UdTa58sF5KIFiJIzH
         zKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773899392; x=1774504192;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pnlY8HB3yDdOi+HU00GrZcKC7F6O3XJWo7Y53P6upBA=;
        b=R5YYpkoaqOTDq2syG0zlJhGJobaKo0+MmFa1Nx/cSeH5VmtWfk1VJXEbRTIOCJRxXB
         LI/cPaykyzw8zGO2CSCwtt0TOSM5j+hHggeyPaGgGI7JCjeYCuCbOO0L/nOePOPffPtd
         rqkcWswO42QTLHyqbaTpIhMPgJ0YhVN/COCe2uAztUqQsiwjq5vXmFg5Eqpgm/bgCa2f
         wdQPJ0KqMeaosLNZVWrz6MkftSXPTnny7SqEPh0uit6rijNdePXsP3wFhFWecNJry/i6
         ML0FYseenzm+RXCXjDS0jOWs8O3boQ5tbQtJoMvC+gbYOLHpwAOGI+WHi/Gza/HwbM7I
         a16Q==
X-Gm-Message-State: AOJu0YwLWohgZnLo1qvXz5IHplSlL8ORAlCyVQSLy6eIpe/v/b7DWeyk
	VUa3qlsm6wn5RX1i3YORTpGQjIyUJLTFEtAL+G0YxfrdnzNov9dVLrSZoWPGpibFZUNl9m21SKT
	03fAkFAdCw3KqonfzI50V6Z6qv0U2/+suu9NVgGI7htruvOJRfG9ZICW2fvBMjXXY
X-Gm-Gg: ATEYQzyn2Cdj931KQ55ZSovQEvuBaSGjgPn1YG/i7HnBZn9Xd/by500Sf+Z2ZDmsQ3u
	EgucuI4CrYPIqnJxpvHCpaSqxPvnNovYZUISH4fM77WC4KzAmvnzAil6BOevcRrtyllf1q4S/PM
	IH/Bp58a+FWgorUxssfbt4ywrOoXy/QoeLYpX3DBuwCRH+kUBwlkz4FP6xIRDTJRqvOImddDIXX
	i8AUyOuRmuXE9tdmJ49pwUnZBkOXxc5jBqXGlBHwOryakoHCtz8cWlAB/LvIxW/4XXKW22V/YfM
	estzYSgptaBRgjNNc9TWwZ3XvvcNYSfgiLnQ6gLrmJniR1dFXL5msgrQdiPRuJkYw9yeKPHeuQP
	bj+QLB+u0IZi9qDIfQ2HHPFL6H2DUmcl+wbucw4udw4+OIJo83dopwitnUuSAw+P9VziSIm1WCZ
	mgXoPwKzlwpQ==
X-Received: by 2002:a17:902:ef08:b0:2b0:6621:cedd with SMTP id d9443c01a7336-2b06e4319d3mr68941195ad.49.1773899391975;
        Wed, 18 Mar 2026 22:49:51 -0700 (PDT)
X-Received: by 2002:a17:902:ef08:b0:2b0:6621:cedd with SMTP id d9443c01a7336-2b06e4319d3mr68940915ad.49.1773899391519;
        Wed, 18 Mar 2026 22:49:51 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e44a42esm46352395ad.33.2026.03.18.22.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 22:49:51 -0700 (PDT)
Message-ID: <6e2f03ee-6cde-48ea-9f43-6b911117fe4b@oss.qualcomm.com>
Date: Thu, 19 Mar 2026 13:49:45 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
 <42587e16218f1c51dbcbe6bb1639a843e10bcd80.camel@mediatek.com>
 <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
 <fb56d5f1-2b53-4627-ab7a-03db13cd76fd@oss.qualcomm.com>
 <ead714be9dbe88ac66b3ce586498f7ffd734e328.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <ead714be9dbe88ac66b3ce586498f7ffd734e328.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: RQmUWr2l6zfv3ntQkw1v6hplYGw395cG
X-Proofpoint-GUID: RQmUWr2l6zfv3ntQkw1v6hplYGw395cG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE5MDA0MiBTYWx0ZWRfX02N9bzZQ/IKb
 VsVqPyzM+4MDei4hdj3BEJa5wTeGVjcSmzC6UCuJuHpthgWv5P5D4pmJ+JtPYCIv686tDHm53x/
 exmmo3qkRpRJWTYQ4rVUro6bvqFGMuJRCza57mSyhSboZgmN8qP5Mm10abtluhGRdCgp92JEhGb
 p96ieP8w8NtL4JPma+ewsemxxvHxazh4ZdPRUz9h2cN35043y6RobuIcgkRxO70gioiN9kfbEBq
 drix1jsI8IQD2S2C1DWEIy2eXOMmvmj8LeLdcSNzi9W2LJpISKOdvJa6B5nlzEqlfj4cfiOIjkc
 3f7D8Jibu5j/akT6qriHZzUIHp0oAgHjdnNrHRDUxiggu9Sc/pSMUvR4TvmjFSGH8LI4xDtWElY
 y73lmL0LP2cvp6WFnTLpgQfF/J3tg6YdUGwvtBKf7fl0Fjc+hniaY+mkSP4V4+KvxgygB8nByvl
 xUlrqZ3Al2lrB8Y6drQ==
X-Authority-Analysis: v=2.4 cv=RZedyltv c=1 sm=1 tr=0 ts=69bb8e80 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=lZOxv685zBznO1DyOMIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603190042



On 3/17/2026 9:10 PM, Peter Wang (王信友) wrote:
>
> On Tue, 2026-03-17 at 15:35 +0800, Can Guo wrote:
> > The main data struct which is costing memory is the TX EQTR record
> > arrays, I can optimize
> > in next very by dynamically allocating memory ONLY for the Gears
> > which
> > actually
> > need TX EQTR.
> > 
> > Thanks,
> > Can Guo.
> > > 
>
> Hi Can,
>
> It's not just Gear that needs to be considered, lane count does
> as well. Only allocate the Gear and lane numbers that actually
> require EQTR. Also, please optimize the structure, for variables
> that only need UINT8, don't use UINT32, since memory usage is four
> times greater.
Sure, for the lanes too. But I will still keep FOM records as u16, 
because we
need to initialize it to a default value other than 0x0 to 0xFF such that we
can differentiate a real FOM value (unit 8, read from RX_FOM) from the
default one.

Thanks,
Can Guo.
>
> Thanks
> Peter
>
> ************* MEDIATEK Confidentiality Notice ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!

