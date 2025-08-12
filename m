Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFD42EBDD5
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 10:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754996122; cv=none; b=mF6f2LJUBKJHR2zELnRrPw7Hnm31QDTy2TXAhJofrlYpVNqqq64UnAjtBOZmQSqKaz1SwimpnVNHj4GlU9PXknaLrf5dArhkyuyH36Ee7az16RTCQpwb5UO1CrwUguqi6JVE5lwZ2kWMj2cj65WxOHPDermB2v55+0ch9XuiZ3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754996122; c=relaxed/simple;
	bh=Pj8Bgqn/mXPWbTZeeeQ/TfBZEKt2UzEfDdrBFxMjh2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QP4CtT1C2K1pGdtg2utVYgVoLEh4kOsxjIz6qH+nT3Yz+7yCs79Xnsn/8lk7FNM4/54+ApOnXHzt7Bwfpr+U0gaaajwxIK/t2efSVXvUrGeaxbehIwYbS9MpcruFllO76qcpC2vKtA1CJMgCyHT6Yo23Up2hQbAytYl6xlFghEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FQxRcwv/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FQxRcwv/"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57C6s0LM005506
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 10:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=0t0Mj4fJK1eduZrrGo955CBD
	djHdqYbc7uk+hDghtMI=; b=FQxRcwv/Jtq65zYoMJp1XXGg99XP5yZw44pjw5X4
	okbeZ3Wr3iwqmISso1e0lE0U6fkUucuxT4PQWUqchm2aZKu1BHsMppmg5ePGZJ/e
	3T/Xa+FSocO/y+idJUIKmHzkouxHiDEBL7H7s69grwHW9Sqj6kGd13A6E7jTXxms
	c9fXUr5iunJ+wgxQnfvmwtppHSMEvKfnV/lm9OLguD1foB6cEgJVZ2SJeOCJ5BFA
	5lwmW9IVkZoHEFHY9liXSqJONTJdZWGV0bCHfQCk1mIhUYkMtUS4JZjGwF6I5NVB
	fabFvDexyPnW1ZAJcqWplY2agMO31rmyvRTM7opr+gUdTA==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48ffq6kp9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 10:55:20 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-7073cc86450so92830046d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 03:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754996119; x=1755600919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0t0Mj4fJK1eduZrrGo955CBDdjHdqYbc7uk+hDghtMI=;
        b=EJqYVjnw7qUBKpk7zNbhXOCRw3MYWDR3lB43c1fN3TN4n2cL9ftUWMOvP4iex8oEoI
         ZCwULfEp7a6KGTvVijBSN+jrKsFDIlNT475wDp7RZ9b6D5ewe1DVU8mKAFNedB9wNDpy
         bfFK2Bjec3/bDQd90A0fMOxCI8vBs76a8GHpM6x8geBrelqWHh/VtCXFIlyIr/0JPsG/
         Eiu1TO4ng8tlNO5JrZ2jVC7QwtnuCXky12bjCRfxQnfT+t9O0ZFKnpT59roZ0WgIC0LJ
         X5RcV7xY7bOUKUhGAbH6psG8+RkDz+r2PPZpdZKwAA2KETp0PeT0FqERB6mnSVBXlX5i
         m7Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUvEk0eGPPWlC0fK8MraOQ8lYFqzYOZVC5lmVS7Foh5wfjVRMcJNv+GkoHRIbuO6eEhgGqUZQ4qJArl@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5Rg7ymjEGDhvRB7zgT2h7V5Id0eTkpoYcsy4qKqxOotWOMFHE
	Sj+ajbQlaQgXSqKBTepzIVcGhmrrsxje6bR06mnjxn9nfJWJmh38X7klIyluk7O9VVci9PePS01
	UouGadBRcSUbkNfW6hrndarKF5Ms4nf9aKDCspGKVL9KWN3KGCZfg1SDcke90A6/3
X-Gm-Gg: ASbGncv+LYN1uD301qLk0pcTQ/2mrypNBFVN3dGrDEvxFPTfNVI5y0xdJFGVT0b5Wbs
	wFowjAtx1piJMmWiyCUk0wbhMvoE0LS4zPy+Eyk/G3SidJipi5UAUQbpcgxBot1okHl7s6jhieN
	pG7x5+ynHbqmqdEWqrZ4TxI5zwXOYDWH/F7DXeoWqyd+eiHKHYH+NzeFefIVCJd8upGr67+ftWo
	Fb8nBW8JQbhCNKmaaukt14sYhzA/VXueMWukLN18nkKau1ZkYKVVjtdjQPocAAZ89pTepu98mJs
	uzVGK2wRfGsxUOB4RspBZFWCtN5tYn7s7WAbPRh0maABQh/+8b34ewEE6QJGvbGU3+3Ew39S5Zw
	Ydy2qZpn9Ghtct/cY0QMQAVyNt0qcTIzS/bSrDt+eGrval5JIVM4g
X-Received: by 2002:a05:6214:2aaf:b0:707:49ae:cd47 with SMTP id 6a1803df08f44-7099a332e69mr182468496d6.30.1754996118896;
        Tue, 12 Aug 2025 03:55:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdkhFnmwSU74jKtHq9bp9+uokwPAB0k/r84R0m1BGkqTHSLqHpUTQQ7XgYD2WVUetchlW7gw==
X-Received: by 2002:a05:6214:2aaf:b0:707:49ae:cd47 with SMTP id 6a1803df08f44-7099a332e69mr182468246d6.30.1754996118482;
        Tue, 12 Aug 2025 03:55:18 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cce15c5casm1342803e87.112.2025.08.12.03.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 03:55:16 -0700 (PDT)
Date: Tue, 12 Aug 2025 13:55:14 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, mani@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        andersson@kernel.org, konradybcio@kernel.org, agross@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/4] arm64: dts: qcom: sm8650: Enable MCQ support for
 UFS controller
Message-ID: <27qmlr3lie54lyigl5v434yzvbes5twy6zgtkqb52ycfh23vsp@zdg57ifh7kog>
References: <20250811143139.16422-1-quic_rdwivedi@quicinc.com>
 <20250811143139.16422-3-quic_rdwivedi@quicinc.com>
 <67aedb2a-3ccc-4440-b2ff-b3dbedf5e25c@kernel.org>
 <9ff100b4-a3a5-4364-8172-1ccb5566e50c@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ff100b4-a3a5-4364-8172-1ccb5566e50c@quicinc.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA3NSBTYWx0ZWRfX7Wb3eNtZUHwg
 z4Rj2hqnF2TJt7HLGDvREOk0bnSiK5FLt8p1HVwY0ytJLGiIaIZAxRGlSkaOol8Tas03xAZuquh
 V/pIIQ+ib0gzV2jDeuN6pNmc2e4YLmzjfjEgiktHR4MXWNX2XLejakA0270DBKjf1hGHD8fCMNf
 mCE+swkQhPSF9725XVpSMNsOAbkaVRlu5rtHi74S6bG6PlxbXSCJWflshvOMV+6adDUKMlfBlYE
 gQGLr5NL/gTw4y58YHR9IP6PRRY/qE3kSinoIPYKmpGi4AyNcKGITh3qruh01/MQDswJI/2FzGi
 A/9f24/XJFZP0grZ3ybFHagixJbooPo8BWAi6FL0Z5Q9TKdlQbSeEGEpMmLZHJcbMbbr8z6YBSC
 TFshbVWF
X-Authority-Analysis: v=2.4 cv=TLZFS0la c=1 sm=1 tr=0 ts=689b1d98 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=COk6AnOGAAAA:8 a=VZigEyOcwVUUxk4fBhcA:9 a=CjuIK1q_8ugA:10
 a=OIgjcC2v60KrkQgK7BGD:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: PURCQ-zvTQJxgVg6yp-CGrNyYzuom1cG
X-Proofpoint-ORIG-GUID: PURCQ-zvTQJxgVg6yp-CGrNyYzuom1cG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_06,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508110075

On Mon, Aug 11, 2025 at 10:24:29PM +0530, Ram Kumar Dwivedi wrote:
> 
> 
> On 11-Aug-25 8:13 PM, Krzysztof Kozlowski wrote:
> > On 11/08/2025 16:31, Ram Kumar Dwivedi wrote:
> >> Enable Multi-Circular Queue (MCQ) support for the UFS host controller
> >> on the Qualcomm SM8650 platform by updating the device tree node. This
> >> includes adding new register region for MCQ and specifying the MSI parent
> >> required for MCQ operation.
> >>
> >> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> >> ---
> >>  arch/arm64/boot/dts/qcom/sm8650.dtsi | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > Way you organize your patchset is confusing. Why DTS is in the middle?
> > It suggests dependency and this would be strong objection from me.
> 
> Hi Krzysztof,
> 
> My current patch submission order is as follows:
> 
> 1.DT binding
> 2.Device tree
> 3.Driver changes
> 
> Please let me know if you'd prefer to rearrange the order and place the driver patch in the middle.

THe recommended way is opposite:

- DT bindings
- Driver changes
- DT changes

This lets maintainers to pick up their parts with less troubles.

> 
> 
> Regards,
> Ram
> > 
> > Please read carefully writing bindings, submitting patches in DT and SoC
> > maintainer profile.
> > 
> > Best regards,
> > Krzysztof
> 

-- 
With best wishes
Dmitry
