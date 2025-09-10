Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491A0248F5C
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2025 02:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757472525; cv=fail; b=kiejbSNwDtuVP59r95QTuF3YB3YUGVW99lnP65snfk4zOEbmE8HwRzEcNlYZY792Npbnnz+DahrLVOEI5VBzheCPpDFY9ciTxgm7H+/LfJ5qSOjPCXp+jEdguAdjOCGGy/6g5O5UKorUqK6PPLYn/894Zh89HhwGGM+RldmkVFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757472525; c=relaxed/simple;
	bh=Jxa8umjipMcaC24S6oI8pwcbOhqvZXnMjOuhKongDH0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u5c8Yyz4tfAZtTlEu5/B2JmMIMRvsJ5DAhBWh/InEE09a564sf4EdROpJBVl0Hs7EgKhXSeir4prC6rIKQvQUWPUQC8NB1SRGUER2AlOsYT+2jwRFQ6stTaCX3Vxj+mJzY3CRaVsO1fsfXxKGowXGqTZujIUyThX/mGF6Gmg3lU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VsmADfBy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DsuD218L; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VsmADfBy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DsuD218L"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0W30032415;
	Wed, 10 Sep 2025 02:48:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NJqgREQz9uxdO7q1hK
	O6iN18vh0kl5fizTlgL+J1hao=; b=VsmADfByDXiKfTpXU58eQ9Kt6iFGjvcLhi
	mFrvjZupMxQ49PXtpNiQeLbhs4SHriOPmpNCkEALyS6WeI+OXECpCyYJTaYmr65w
	YIuQ3Qlntu7horsKZuoP/wSRfj+W8NpxwRBVrgdTtD80WTC+GUSl8wlJkg16McFP
	zE3xMy27qfLKtfEHEqWOuzBF7gljezCpxrG/NzaA4VVyr8zMfIBijaaEvJi0leTd
	ufHyuhH4CoLvERNe0v2usbjYEqbCtZEuHw98C9dLC9yR/SgVvtY0OaOj8UFEOJTn
	CsuZOF8zb3xoxEkmT4vjN5rNyrfgK6P0tWkVew/JGNE0+ZrasFhw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2u7qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:48:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A2lnK3032870;
	Wed, 10 Sep 2025 02:48:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbdm90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:48:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cgU3g3h45Vl7Z35MzL6aiulbuLAjujNI3qrAoaIK+j39CzNzAqmeiKnadUFzHR++FWoXDPM8xT8a4VQoPeCVk8kzwKYQo0TYa4C6rReYy1QwDdiR/grHSMGaFUnBN2TcFJo24RqgGrxgARflHghX3rxUUodxoRTqW6Y77pLAcL5ZhJRoRSAKUQpIsAr5zPy8H2DzoJIr6tt+NVRENoTdwFlsSF3cXN1PqVJLWETohHEtt/NLJTs1wJwhfq7W/BCQVCaJZGA+uzceA+KMdEltYiaBleteJ50WobJeq6DbD04MUdmieRxnjziFRiJrHH3A/uxk3FQnhQ9wGvE3B1xTHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJqgREQz9uxdO7q1hKO6iN18vh0kl5fizTlgL+J1hao=;
 b=QeY8ndf0T5U+vMCTvSHEXdXZNP/hDMI3x0E5+IuTBP8kNzAMsC1tRYx7v2d/RI8BsY0FW6krtkK4A0Ap43DcEwTduB86IFDqJBD5N/96qzA1WzCgFTpTsA/5Eqx8L3fgUcYOPxNgdysRbC7lDCM+Kup2PlrpGKq/wZdb61N5RaSUsRTQ2BT2a0/VZabqIrfwpjSP2srqbSviHzGwd+Ifldl/h4zkeGsJ6eR7txGwUIN4FTYQSB+hyOef7AMvAiFcH5WX88VAHpoZ6DXhyW4zxmIaNN3DvXGXvDK3MfUWRaUN7QjCGso2HMYvhl0Tiso4IksQfsT5L79sx3TqsHK7zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJqgREQz9uxdO7q1hKO6iN18vh0kl5fizTlgL+J1hao=;
 b=DsuD218LPpHeSFUP/RRcuoTZZMl05Y5iobPuuhMEZRffWIEf1LCz1l6zVl0ONJsldRE67AAnx4oX9fXaYQXyNlpnwc+exA9xOUoctBeOjTSdSNPKLn81aRZGCIsN8IMEfLwJyNOrlY7SeD6j/89O2KBnh3tMIsqMSSRhEFVhkZk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8275.namprd10.prod.outlook.com (2603:10b6:208:577::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 10 Sep
 2025 02:48:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 02:48:14 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
        <sanjeev.y@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v3 00/10] ufs: host: mediatek: Power Management and
 Stability Enhancements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250903024631.496693-1-peter.wang@mediatek.com> (peter wang's
	message of "Wed, 3 Sep 2025 10:44:36 +0800")
Organization: Oracle Corporation
Message-ID: <yq15xdr58gs.fsf@ca-mkp.ca.oracle.com>
References: <20250903024631.496693-1-peter.wang@mediatek.com>
Date: Tue, 09 Sep 2025 22:48:12 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0005.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8275:EE_
X-MS-Office365-Filtering-Correlation-Id: a4419867-b90b-438d-d299-08ddf0147cfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+ijnrpIFwSFMYuZ3ah19JvumWABG1S9A3MuPvKz/H4GUDQcpDkzb3EmsuJn0?=
 =?us-ascii?Q?st5WCN0x5yJlsYa6MRomMdZZCzb3/h9gcxq4gBhCTV7Xqoen6uicN0sbbmBC?=
 =?us-ascii?Q?uot5CEnQIc/EpSImd3TZQvTp/Ynsmg87505t1pHoqMrHxb70cxXw7rX4dfqR?=
 =?us-ascii?Q?c157o6HSr/aSzFHgvdZ/NXdQZH/+BZf0HcXCM8/YL+RIyiggYsuxIUSIr69H?=
 =?us-ascii?Q?AoPqQ+GCx0b40Q4bcsUGzrgBB3Ik6Lkg+l9VjHnymjZY/V0Euw+GZ/y7D6l6?=
 =?us-ascii?Q?b4x9FtK263PDbiCaoa2KDfzTS0WcQNKdGYXdSDCmBzx+28DPdZEhRBx4gcW3?=
 =?us-ascii?Q?PNfRPdh3dgEgDOyj1ETNKKL81nHTOyN3rueNC6zIN/e9GbrikG+MgtvIp0Gr?=
 =?us-ascii?Q?3BgBaIV/M7pf7DJsNOUBaL5tjLwV823CK3Nc/pbQZ0h4VmID9ndSGrYA1Z9f?=
 =?us-ascii?Q?6iVlF5s3UVsoZX2gssXWr53nlRK2t0+WkXRGTXG+wGw2twuiiIQk1wHlUz4L?=
 =?us-ascii?Q?q3hmRzjKjC+gbVO0PvPXFhzq++GqZlnx4IwMwFD6NeOZidMS/wrjuK/uxIs5?=
 =?us-ascii?Q?R5mxIKQbfQbeVxKaRh2Onwbebki83KmYs2hM/2mwGNg3SXjjKoDuscfL2Dtj?=
 =?us-ascii?Q?zCb/+xFAaekZhdhFGFsh43grbEh7B+n9xzTSjhhwiyc8E+AlV8gWl5MIR086?=
 =?us-ascii?Q?IeRRTCq5ffwIjuHbgaQddKnL08JALRwknq+RBtUfdlLTcXnseK3/zpdWc3xX?=
 =?us-ascii?Q?45OzAtkygNI/AXlS/sFHfnLLlB6BTaeKjwP0rpQRrwnoUOvMMVWMpJjFwFoY?=
 =?us-ascii?Q?a7ugil1H+6DBhnij5LUqEJzI2CcTNPgE+ehN5BQ97W1BIzD0wuGNjjL/diPp?=
 =?us-ascii?Q?F76UoIsqSgOaCF4Rc9hUgoBy0/Dl2ht1xYbeglrUhWGDEtRfjaWgrw4K6U3G?=
 =?us-ascii?Q?x+NheWZdjzVr1U5RVJaaSCH7F2tHMtk2HDHGJzTFB4DmIHyZklM2KCTG6kcj?=
 =?us-ascii?Q?ZV9DjW7dCPM7fuS9h3/+1n3FtP1kn5D9Ah02GSsxnWJn005aADXMrpvXRoIF?=
 =?us-ascii?Q?k5fxlAs3//IlQ7s7e8H8LRYPX2setiuXdc0bQxznh5HXVKXCVwJ4enr8rfbq?=
 =?us-ascii?Q?GsoZqTIg/hyKgkhyXkf64Tf8ki+Nliov3drgVt8vRzdctofk+59wUXNZk+Rq?=
 =?us-ascii?Q?7OvbIzxNBDaure8+QXqPGam2XppXNpIXLGeo3IqnQDp8hmWvnHU5J25lozwM?=
 =?us-ascii?Q?7ezkZ2YrYDO/5vRnVTfQY97Zsz0RX2/yJ/jmUaRJ6WUbHJZ++XSXV3Mxkniz?=
 =?us-ascii?Q?hPrDuYQe1hHugGWjqF0t+v1uhz8ZPo6o14yzovQ5xnJJwGR6hmWXp5AP39D2?=
 =?us-ascii?Q?nTb6HvR/XlOhC7eNSrZYY5A/Grgcb80y3ucOFASDxbrKIyoJfOTMp/O4LyiV?=
 =?us-ascii?Q?0SjB++us11A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q8qWXETB5AZ8XPRBTcv6XJMSiReEjRnucq6SLAw4kWwpuOCs3eE/zAzEY1z7?=
 =?us-ascii?Q?3Nh2jVnfkfCluwYdXNO9hBc19s7KmYqToMDvScKwvKBkyowWO0K678c4zj33?=
 =?us-ascii?Q?9pp87fZ5/A9Hwh6f6mvPOI/PGJiWOZPRUIpv7862dliO88eStgZPthlt3jJZ?=
 =?us-ascii?Q?gO96qej1uxDBsaqXd+Wa7YVw7Y8A9AFY8m41gJiId9PkN+05uioK+OWvFRwz?=
 =?us-ascii?Q?kJP3Bd2hY2IVOhWg1x5OxO3fZZtw2YXmvte7AtfFkubMThx6/dp8JsxGHl5U?=
 =?us-ascii?Q?3PMqtAonjWt8OyVUgs5l/RwtMAe5o4uHdyv6O4P5xcXLt5LLaM420MRDAR8Y?=
 =?us-ascii?Q?GFnXanjg6YmkkNRgU/pFC7K0jCaTLCGrO3I/o/jxMCHRycdgUK0jTLfmatQV?=
 =?us-ascii?Q?9XgIEgoU1cs3DCl7svvsmPscdDYF2ZvgbmCW6fgcEW4wW07X3qp2R8aooVKe?=
 =?us-ascii?Q?+40OABws7eWOKviI0Vmv30dvbUv097CTdgq7QwaqBk+DkyJ7iQ11w94ojjaM?=
 =?us-ascii?Q?FUcWTAZcCLVGa6783STQKzW8A2S//7F6atHKK0LkMB5NwypLA7+Pzya+/tY1?=
 =?us-ascii?Q?CGhCSVENlhE5m6koLbxo6iJs37kvz/fKhF+6l4pfHDPFXz/O14wenpIAaXqj?=
 =?us-ascii?Q?RyC1z2VBpx/9KCk413RKD9kdvNajMUsE7rFTBsBI42tkxefvTaWMN4IKyP41?=
 =?us-ascii?Q?QJrrx3mKAGNcLpyFBL06VSPBHSttKx3CNpw7RDulCrU2Pk+xZ6ORoCzc5EIm?=
 =?us-ascii?Q?94twlQNhA6IUmrwuuFIuIjmaogRs7dyirVMRApY9eRPBGbI6qBkKs5vNAERA?=
 =?us-ascii?Q?s9FEK78blCMKAVAQtJTW+oItoOi94Npudtmims6lZBXjVLBWNmkaTWYKhxW2?=
 =?us-ascii?Q?1SwawTIzAi9fqeBbkhZiaE6sOMtumBwUwbICVPnctn5sf22IoDIOcwjB3F6q?=
 =?us-ascii?Q?J3vq4pl0lrvODjmzoa7QMa76XRgeMegXKXdn+rhnCpZbA04lIaf9wRwjD9XX?=
 =?us-ascii?Q?sknccAe0WRntHozxafimrp/MV7OzhHf9r9Ddux21u4y79nAU9gkcxFG0dAjQ?=
 =?us-ascii?Q?OPtbqb/Rlw8rmPfnixm42TQgb47VXJBeRQ0Xlz24oIyPL3K8U9FMIEdUx294?=
 =?us-ascii?Q?akEYPAanhqzEXNDjcbSrv+h9iHh81VIDitaX6opsPMt1zf4YW7f9St2YykKu?=
 =?us-ascii?Q?UNrTxVYEy/2vjqqQtWrxHqwIL9/ba/9chk1bdUBvHT6dGvfTAy/t01+RfN+O?=
 =?us-ascii?Q?Qa4YJEFqIofMCxu1JCNk2tbVZOU+jknfrm6VUre8vEBhMStVXdhaqOpzQuOM?=
 =?us-ascii?Q?xQle1poONkYRGb7512qvT2jE3PRRHF9YNDVR6oSgoWPkl26V3INOAhJ2d9Un?=
 =?us-ascii?Q?iKL5mfAByfOX3tvy5doT69CElMVUOxhg/6LSLGLDtozHSXraA6VHekJ4j349?=
 =?us-ascii?Q?0XTLKbSVoEn0ASETRjhfjcTICvV1jP7klZey8RS2CNvLnpsBfNNS6Gqiv5Rl?=
 =?us-ascii?Q?ohX5eak0wNO/FHeVs7oRjWJdT6nXIhITO3DrW7Y2jrfokcPEw1QvUw41lHEZ?=
 =?us-ascii?Q?LDehus7Rtp/H+o9C7xWrpG3HpQhmkePF6X9RkEUpyLQgaA2mvOdCGWbp7Z5o?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W/JUITUkqf71ZdHsWIIjQrBmDnAaWJ7LKboXDANYiWm8jopFACijWNWykkkZtnL0Aw8JG+KcID9vr84MkD1nDG/ZvbrD1y0xFHQo88MAGL4xi4AZdjW1Rhn862rbk1ATrqZ/Q0ZNIaP+zUPLgwI7si2PQeNwby3PxqzhKEdkrQ11IkFhCvtZbHqCFKnpZ/uUzdXQC+y0TRNnTEX0GNrSAPb+w0XVUYqm6/xVHMh/a/I9w6Xi9BeYPAZX8tIzr2jIFwy6/K4fdgLg6w2ucu8LmCUM5QMBsAjkP9hCVvKs5B15YKtctuUACZiwAxY51HuWJt2ZQdI8sfwuIjD15Czb8mNTxswbfMdzgRexsZyh5k02XyOfZk2lxxa8Z90HO4dr6w7R1jTECKNtsQtB8nk9p7+2GbiJEPJimeDA+Ic740i67RCxihcHTk2D87r/q7XdXHF7V1DHXGPj873SDxNty0YcAYa8pE+wL8oj8VKMiobNYqulyZ+rZ18EOumTs5AZfqQyClpRGvrJntOPjGaBcGTEujGeeTvG6XazAjtFhxVvlPAQiagdlPH2mmCGdMhQZpnIH3RxsHJ/z/+8UiRp1EPs/1ekt2uyss7rYsEN1/U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4419867-b90b-438d-d299-08ddf0147cfe
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:48:14.5113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GlIX/xLMZQBbbBBQeit/N26C8NH5d6sVBZl3DKw2TCaiUfNRNSTFuLMM5P7wwBrxafrgJWQooJIBfp7SJV005ZswgS2dedx9FF1egf8XAvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=875 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100022
X-Proofpoint-GUID: fPeTsM8c2Zo3_hID-pztHiDYpI2lbJnW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfXwMF6w/cPJOzx
 PWyEsbaK3c0XvEQuw8V8FFyEUsSwEIv9UZA8e6m1c1XH/4mcnJxA2zJejXXZSX2kgxIqy6ggADo
 PEtQMXOwbfjeDigPdoIvW5lG722FaDv8rEYQ5iliXrGoVeBfw048nVanDewBTacxqhT9R4wlKp4
 O7//s8vUCP+8araIpYsxhrRVcumvBZwb22X9yI7hwf/dqcgqLXH0ElMOi+Yl9fKGZvA3Qz707+1
 u0Nqg8X0kAad9/+gl3G/qsSBLhiYiXmz6V01FRhKi9VtJCk+Ua66XGgQKFD8RGP1ijRZfJRJhsH
 oj5HiW9n+pyj/LY0iThZJDWJQqF2SRH1/1yGRy28sySGWACmpUFD2zO25ll01f6DGFTWgdv/2Ol
 07mdwByM
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c0e6fe cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-ORIG-GUID: fPeTsM8c2Zo3_hID-pztHiDYpI2lbJnW


> Enhance the UFS host driver's reliability, power management
> efficiency, and error recovery mechanisms on MediaTek platforms.
> Address critical issues and introduce optimizations to improve system
> stability and performance.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
