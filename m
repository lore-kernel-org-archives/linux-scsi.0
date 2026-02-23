Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8B82F60CC
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863665; cv=none; b=W47Yf65gNRRW1nbKaavnbzoN7wBKnFzC2vVzML2QKZMAjy/nuwNGaj9SWVlMZWxNLNYe07iQl0EkF6xqeroNPwDgColONZqtAWkHbbLDcEE/A063sa2WeQs3e4uUf3WZvwfIPXTGE0mX7n97LyLl31l9dtE667tbWX1OvU8Erx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863665; c=relaxed/simple;
	bh=9XMww8y1cQhJYxDduGYdr8t8Ddjp20hYAB5EvGOs0Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQpwdZY71Kct5XS+2tsCyNG0oRL66YMsIAf9t7XSEZLzy+oHeBKRdgjk4SoBWtvrpdl8GqQ5LX3bbxqsoZQgyMtBqNjU217MQ3nVCm7BhyEdCjzjNaxt2OJvIy7Q+1fAq1TfSxBRXHB5YWpm4l2v4LJ6ppE9XPywNjEkFsmL5xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JAUmDwYl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A27PjmMV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JAUmDwYl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A27PjmMV"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61N9SIn61197849
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 16:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=xhVObjuoujdJeMjV3kqUuIrH
	fXuJ62UYDpmgw9/nppg=; b=JAUmDwYl3JuHlvGDb8ItAtK7tNmMBHv+HsgaOppy
	cWefqitW2Z0HJSJ97rTqyrQHlpNPRsISzIDfkoZR3Ck8MdWOKbJjt+wOfV9jKDfA
	DvJacs2bgcqyjBerf5ziTtWP7x93eMNnH6WirtKcB1+U8oocgatfSg6Hx1IFjclN
	reMSwjRRHB5GiazpcoJcfl/KcrOURAqXUVoIMW/rN+VoCCTqRKIoNb1QRApo9p34
	3VY6T3xjgnZ03z/l0COsYTxY9l0HuKj1KuY4V5ZPWEQU9T9Za8HdLsPVKb191nrj
	ypSRI4K3qqQx3PcLLX313nM0pjTRiJ1jVd/sCKHyOSRncg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cf603neyq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 16:21:02 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cb42f56c4aso4642255485a.3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 08:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771863661; x=1772468461; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xhVObjuoujdJeMjV3kqUuIrHfXuJ62UYDpmgw9/nppg=;
        b=A27PjmMVUg9J8cLHna42nQIR5etTnH1banCdb98mPVXGMMPeyo6lTgwS0GWkliicl6
         4TBQNtDYrA04Pg/5q/3FPnnTRQhApR7Zgoa3X6V66KB4zK3CQxDpz0ACp9HhpuwSiPWY
         1fMLjE78FsZUfOb1yC0TBYmnXibuzEBpqtko44vK+FS2b5yW+tU7hwVUk0uL2jq7jT8j
         7uMIQtH+N2hro0aHfon+qvJGu3saM1EZ8TSQtHENWYRGE7b203OoKbxFZRiPuT9FcjqZ
         SsaeTWCOoL6TTi2t/tRxyrPAUA1Ii5nlXrulTIbgOq39WDeJkHoFX0On8vUjB2/Nm4ua
         Qy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771863661; x=1772468461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xhVObjuoujdJeMjV3kqUuIrHfXuJ62UYDpmgw9/nppg=;
        b=ORVWpJeILAVwot4np3B7IdN+HrbI/YyyNTbtoeUGNDqjGw3gcHXYdVv8KGZ+U6LEkF
         vNk8vITUf9w20kmCcQO+zGwKAp403KFdhLier/ujNbSdkqYjHz8PtkqDyVM2oynDZgBT
         Jb9ChK6syFbW84C2nCmSa7TzF/HAz6QB81u7DZiypgLrYQWQendd0aN0KKgFp3XWQ05y
         0SmdVouT8SpBV33WANzfPnifFlx1oFnX9G7XYPrm2ltkWPsmsotxh+WDQhXsZb2SJs8E
         xdhnytpYASdzgmIP8FBQCTHBpq55pLELR96WLbyQT8593qeArNsVFsj22Rywkel9o4rX
         YVXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlbGYQfEamM9mMcVunP1mT+20sNdn3xiq/2gDe3yLU7XmAHw3aHCzCNeO9uB6ZO67dE6qGsEDtClrY@vger.kernel.org
X-Gm-Message-State: AOJu0YwjGWj5cE1vc/Ewus+6FtKzsAnchgtjza8qHHigzWSnMtAO5dO9
	tgkR5iFMBVQaqfn3SV/x/XQmWBu/TTiKJtW8xHqv8Fw2KT2pfKZE4dg3r3OSufBDTcvPBICHTkt
	+oGQv3naRgiCtKe3gDn2AjQx2rILTsTxQV99Omj0COZ+v6LGdJt6jE+I9mYnGQvBt
X-Gm-Gg: AZuq6aKt6Pz7zrYJk06kIZJupkSmmR7+DGghhhLTnlswasN4DhUYXob/FBYk58VRyVv
	BBY8mHGKqLVlgqDbBATY3+olEaP//zJAZI1e0iW9jvhMO6n+g7ssLJafX0dpXynRpp55DiHJeLv
	vPfM6WR3yBYCecGrtmCs7nwnuOEnP0Uo1hrqxv6xVwFnXgjrT0wV3DwnPe4WzOQcLZyUpvdWADu
	WfsVL+ovIiXoGB+F8HFrqe/FQMymTYpcxnBsNBSmBtxPqot0OxeS39KYtLlwW5JOzXWqLXD4uG0
	6zYlHiAd0GqSZMJ9Iff2BcElG3+ouj6tvyVUP5gdgjQgIwU79KTM1TYWJyKxV0Jr3Wn2FA05kD9
	DqpZA9xc3JfUGSnzo/GAmRzwUJnoB8lANQJZI
X-Received: by 2002:a05:620a:1a1d:b0:8b2:f29e:3af8 with SMTP id af79cd13be357-8cb8ca76ab3mr1029274285a.59.1771863661467;
        Mon, 23 Feb 2026 08:21:01 -0800 (PST)
X-Received: by 2002:a05:620a:1a1d:b0:8b2:f29e:3af8 with SMTP id af79cd13be357-8cb8ca76ab3mr1029268085a.59.1771863660741;
        Mon, 23 Feb 2026 08:21:00 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9b6698asm337771805e9.2.2026.02.23.08.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:21:00 -0800 (PST)
Date: Mon, 23 Feb 2026 18:20:58 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: dt-bindings: Document the Eliza UFS
 controller
Message-ID: <pszsqoifgo7oxmfhqrlukqo7ipnt37cqol4ecdjxswxpsaffqp@4qgiwwrmmi4j>
References: <20260223-eliza-bindings-ufs-v1-1-c4059596337f@oss.qualcomm.com>
 <qroy3qzudcgtme4xxo2dy63ay7ojd674ski3njwew5ky7rjw3m@iagzzywq3we2>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qroy3qzudcgtme4xxo2dy63ay7ojd674ski3njwew5ky7rjw3m@iagzzywq3we2>
X-Authority-Analysis: v=2.4 cv=XbWEDY55 c=1 sm=1 tr=0 ts=699c7e6e cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=J6WbokQiPFq9zDEevI0A:9 a=CjuIK1q_8ugA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDE0MCBTYWx0ZWRfX508g8y/sbGLS
 YMppMbXeZ8RyTVl/Vh7bFBJhLafny9phPcmDdMmL6Pax163ICtvSjnOwaQ66lvOnQHcMFYys+d+
 VzUg5YsPH8fUGq8WpZBi7zq8geXjfW/k7LIckYjbXrBxP3k36hSSWrTs3n748ab/Mor/5apwi4u
 i/cNJve6YPYbOUAiotTEenA4VdvC89pN7e2hNseCqW/2OxeT2sEmEX1Y9Y/bNIl+4zyIInnxfx3
 TFuP+vooz8fd9850/eQbqNrFUwtqVJeJn6WswEjwvCOUunm7eqeb274kxQkdSKg/YxtDS6+pp4v
 4RCElzwJ18G42Iane9RdomOlnO1l0idOrR7Xt2MMumGeiJNJVaL1VWJ4ASOoUPPna1K4ol2FaSh
 jsD4EAJ2KtJBhBw1EJA6VZ2vq9BcTqSlU64c/BbKi0/W8PA9shRXe60sk2xX7puSxAB1prziaoG
 xAPjJhv/62fJGvetsmQ==
X-Proofpoint-ORIG-GUID: vli1uPAHqXXlA3k_8yh9xs0G-QOEBBrZ
X-Proofpoint-GUID: vli1uPAHqXXlA3k_8yh9xs0G-QOEBBrZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602230140

On 26-02-23 20:17:09, Manivannan Sadhasivam wrote:
> On Mon, Feb 23, 2026 at 04:32:35PM +0200, Abel Vesa wrote:
> > Document the UFS Controller on the Eliza Platform.
> > 
> 
> Could you please include some info about the IP revision, compatibility etc...?

Sure. Will do in the next version.
