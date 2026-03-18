Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4465D36493A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 06:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773816682; cv=none; b=idAJDjR/LtKR0RI/C6Gtj0XNKxFoqw/7cRmdd2cv412aDr0wt4vbIwgCzI4vQQEfXBsd+dpdg2cUq0IfrnKuNcg0YhIpAR95DS2z6he5V6jSn0aTgOCOmTGAJKPMR1pbCaNotHijWjv00pogI65YdMt1Onv0ZNxKlTMhgtHZQw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773816682; c=relaxed/simple;
	bh=uDtdBqMRVAugjMyqIMXog1TMy4/UYJcnwI7IpRnZ0RU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uNQGkb6/rFW+sGVLZze/TCm8+JeF9GcAkZ31FSXoZRn6QzKLgEWd5HnDg1cMZbG+m3habPTab0VPKzhI9VFZ1eJH5yKuPVIxSrQTZrqWPoMh/Nj+ht1+TFlxgNUWdqCefW+pVAbfc5re1IC9XK/SD0qDoyqwRLqnHKnT7yj7eco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kl17PUhZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CgiTQqug; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kl17PUhZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CgiTQqug"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I2hxl4932345
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 06:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dVw1W12K8D9H6jAvdaq/0zYSu/Z0gjDFdppar3Jnxls=; b=kl17PUhZxRh1ipMk
	QfKWvHUMbBvjkGTCMNRvLN4hojloY22pXsxAjetw8x6e2mwLwLFEi2xmMFk+15Ad
	qaM1pzD+SJPvz8VSfxZ/YQIGB2LaENg+rMRsCrJAwxdL3QDHYYe9GS7x8UmcTbwL
	RtFaxB+RHwwitvN5CtMNngGPf/yNsBX8eWTurUu4+tVYD6is4iJaDrN8F906NZ45
	wJHCINm1wSxoBXC9RQamycetwvV+EUsg9RT72pXU/NjOheBDWCiKVuQ1NJyd9ZOI
	owEduan2/PyBEEAELKJe8JDUlnrafg5/bC9cFknHOdJbjcSQnWX/sQTYZk50Fved
	WQdYmw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cy9jr36a9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 06:51:19 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5091ee9f1d8so46226501cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 23:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773816679; x=1774421479; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dVw1W12K8D9H6jAvdaq/0zYSu/Z0gjDFdppar3Jnxls=;
        b=CgiTQqug2fZRfecU2v9E6CaJMGZbdC0oGAZHLD3TbfOLtIAkwzExUHxE3PLgl6tqal
         Ocnpr2XFRszztrs2mcnw3aYooXVc00p+5dnopfK6mdQu7cxz/A6cwyaD29/jz+LS9zoL
         Y0ERRR8/Y3LxWfnC6zvItYMcJgGNZy+sJOYjd1GS9+R6ja/dSmEjWZ2Z5MEclelLn+zv
         h5yTMGpKL6P7mpm1j/UnKppWwAdo/+3wDg9AcB4EKNzqQQelNgkhQsbqJnZZkMd9voX8
         cHArmOOIRZF95AEkrzSWDCjEdbdp1GBWiHm/c8BZvfDMj3fYWJZ/Vj5IkYGD6y2Rjj1f
         ySoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773816679; x=1774421479;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVw1W12K8D9H6jAvdaq/0zYSu/Z0gjDFdppar3Jnxls=;
        b=PNNIDS5ZTCuWXgehxwXeYsiXLfLF4nQJH27gqD4J6/VxcEEyD/vbPL2sLm2u+FXXsF
         7tdQ8k7xBxBtRg4HDaMIDTZBHHPSMdnN7V/qPn6n+giZ3XN95zVNNSP2kAU7MR6Bx4Pf
         DsWxcC6MKXsqTwa519WZTzbHSRho2V382507/Sgwvxj7FdgaVJoF9FkByiIFo9VdeQav
         2519CXgk80K6li5OXye3kouXMFj1oTPW1qXEs7YYnaSfKXNbtiI50OID2MO9Mq64RFXq
         P7vy8TCo0e6IDv/MLt6owCOXZNd8vcIOgHBLv5NoO1okcOmo127Pj7aej083xrZqnaFE
         ckRg==
X-Forwarded-Encrypted: i=1; AJvYcCV8OH+o/n/KK/SwBGSgE+ADX2i3Lph7ujt1R6RwN4O0hLcggGOQHtc/yD3fN6qj88lAD8heojocbbjR@vger.kernel.org
X-Gm-Message-State: AOJu0YyhOggHPNBtWZC7tbeJWpB8sMrto6vjchhE4gNijPK8WeueoL2h
	sDxvNOLUkTr/fz0/HRng1GfH4QygT3m8qnW6DrihjA0Stz8pq1IL++jZAwjBzO9fuNa2Guq/RDV
	qPpmwEQCi2cJt2iPJ/hpfCtr6/vVJcYwZQlKUChyPmt+0uGRMEJZ0Fr8/JDpoC2yy
X-Gm-Gg: ATEYQzxmCa5xk0b3ArrVkiihKACpNHakTvDxIvPsuZBlgmuDQFq0vfe+rdyIXjtt2sJ
	U/Vkd8igzL29S+w/ef91VsNar+6mfENdUL2Ie+QBBM+AdpRgV+hzPk5JBlelmYQYN0kDU63q6N+
	MklCn6qspEqH5biYltepDRXqtc02fYbWj51xQNbbXDpKS+etUNmDvsdv8I3d6Ff3zBZXaIagO1N
	7CjYF1DbQf8V+TQo8yGDg4JcY4/tvM0vQhAdZd4zG5OP4SNpss2jsJXQDzkxWXcucaYcOQwpfYE
	7/OjidYravEXq7iQV2zYLMVyuDp4heexHVdUI/uVL0Zz2VmtfHc1PkQFjBD440GlXRQVeybgX75
	BexFEeWrtfDjoBlQuKGCXzwSIhDUzxRgLwn/KgnKpxuNugBIZ
X-Received: by 2002:a05:622a:18a2:b0:508:fe5a:a5bc with SMTP id d75a77b69052e-50997e5de45mr77980641cf.0.1773816678576;
        Tue, 17 Mar 2026 23:51:18 -0700 (PDT)
X-Received: by 2002:a05:622a:18a2:b0:508:fe5a:a5bc with SMTP id d75a77b69052e-50997e5de45mr77980081cf.0.1773816678050;
        Tue, 17 Mar 2026 23:51:18 -0700 (PDT)
Received: from [192.168.1.29] ([178.197.219.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b51852ab3sm5409518f8f.12.2026.03.17.23.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 23:51:17 -0700 (PDT)
Message-ID: <69dd007c-16d3-44c2-bc30-4e7f5a95addb@oss.qualcomm.com>
Date: Wed, 18 Mar 2026 07:51:12 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10 net-next v3] ipv6: convert CONFIG_IPV6 to built-in
 only and clean up Kconfigs
To: Fernando Fernandez Mancera <fmancera@suse.de>, netdev@vger.kernel.org
Cc: =?UTF-8?Q?Ricardo_B=2E_Marli=C3=A8re?= <rbm@suse.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Selvin Xavier
 <selvin.xavier@broadcom.com>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Simon Horman <horms@kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Varun Prakash
 <varun@chelsio.com>,
        Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Michal Simek <michal.simek@amd.com>,
        Luca Weiss <luca.weiss@fairphone.com>, Sven Peter <sven@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kuan-Wei Chiu <visitorckw@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ryota Sakamoto <sakamo.ryota@gmail.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, Kir Chou <note351@hotmail.com>,
        David Gow <david@davidgow.net>, Vikas Gupta <vikas.gupta@broadcom.com>,
        Bhargava Marreddy <bhargava.marreddy@broadcom.com>,
        Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>,
        =?UTF-8?Q?Markus_Bl=C3=B6chl?= <markus@blochl.de>,
        linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        linux-scsi@vger.kernel.org, gfs2@lists.linux.dev,
        bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-afs@lists.infradead.org,
        linux-sctp@vger.kernel.org, tipc-discussion@lists.sourceforge.net
References: <20260317140141.5723-1-fmancera@suse.de>
 <20260317140141.5723-2-fmancera@suse.de>
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@oss.qualcomm.com; keydata=
 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
 cwzYbmi/Et7T2+47PN9NZAOyb771QoVr8A==
In-Reply-To: <20260317140141.5723-2-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0mM-6kaaYKz4ZnE9hENPahVjKyPIksxq
X-Proofpoint-ORIG-GUID: 0mM-6kaaYKz4ZnE9hENPahVjKyPIksxq
X-Authority-Analysis: v=2.4 cv=NdjrFmD4 c=1 sm=1 tr=0 ts=69ba4b67 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=gOEeR9iKwsj33Yj5oN/cWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=tBb2bbeoAAAA:8 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=jkvUz-bvcPb0UOHwX5IA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
 a=Oj-tNtZlA1e06AYgeCfH:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA1NiBTYWx0ZWRfXx/eGgz+RA5wp
 kiUG64bnrvwq4A03cqCoqfo1UA0Aarh55MvvY0uNZKhIjPVNy/6J0U0lKsaVaFNVNjt2gR+2XRd
 ffzGkYLD8hWznMhhwjffzBoO26CfcyFugWetQ9UkAb4y0Rt2NxrxocWRh9wnVY+yUDNrPt2PRnP
 qJa9upH4+mKiymuQi5ljm7ORTo5mtKAk1cfyp4g6nnmn3qmGQQhsENN9N5FvGY9Yh8oCkBeJbGT
 bk1J7h1U7FOUeNCfWGnhlBmBsnXWQDXDX7wH0p9JGlegkVvVpGoMxOImEfKcPxpoZmH3f1bkVcY
 1m7Gp8K1rXEIsfQLap0TphYQSbTDkWe70V1hZYN0Gx+dZveO45Ty7y93OACD+LhcNzVV888Xtn0
 hzdiy6hFoUbHVU96rywsX7NrRDSR9PxqTLpmKS9sX2ootR6G/1eP0DnfDMOVB4aZ8Ahiqs7R/+1
 +J+ISPnS0Tar+638vnw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_05,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180056

On 17/03/2026 15:00, Fernando Fernandez Mancera wrote:
> Maintaining a modular IPv6 stack offers image size savings for specific
> setups, this benefit is outweighed by the architectural burden it
> imposes on the subsystems on implementation and maintenance. Therefore,
> drop it.
> 
> Change CONFIG_IPV6 from tristate to bool. Remove all Kconfig
> dependencies across the tree that explicitly checked for IPV6=m. In
> addition, remove MODULE_DESCRIPTION(), MODULE_ALIAS(), MODULE_AUTHOR()
> and MODULE_LICENSE().
> 
> This is also replacing module_init() by device_initcall(). It is not
> possible to use fs_initcall() as IPv4 does because that creates a race
> condition on IPv6 addrconf.
> 
> Finally, modify the default configs from CONFIG_IPV6=m to CONFIG_IPV6=y
> except for m68k as according to the bloat-o-meter the image is
> increasing by 330KB~ and that isn't acceptable. Instead, disable IPv6 on
> this architecture by default. This is aligned with m68k RAM requirements
> and recommendations [1].
> 
> [1] http://www.linux-m68k.org/faq/ram.html
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> Tested-by: Ricardo B. Marlière <rbm@suse.com>

That's a Kconfig/defconfig only patch, so build system. You cannot test
it in a meaning of testing code. Building code is not testing.

> Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

You removed important parts of Ack. It was not provided like that.

Best regards,
Krzysztof
