Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A05334545
	for <linux-scsi@vger.kernel.org>; Mon,  4 Aug 2025 04:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754280694; cv=fail; b=CYs/EX3CQimt7ebBPT2FND3uh2ruLBvbYiUZ+sYm0nCia4dufGRyBLIFUAS0zdJR3hC8AgMozMg61kfJ5/YGPu1mkU6RyCN8sxN/MeYn6PFnOXlGPWD5kkkf98f3JjMP2qJS1SsDVXb8LW8XIHYc0c/kullweQhvBxZHYRpqUk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754280694; c=relaxed/simple;
	bh=E5OjwQFob2K4ruy9fjYf0J/efzdMk+YpXAG6Be1xMSI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=VeMuWt+bA5p84jqGHZawSKHEcEUU/zxJu/xd6w3/McsCYa2ydGSTKt40KRYNTYnRRa++HK8at60GKgSFZTGwnd+Pmhn+lEBOhbl66wVeUwKbjloje7QAl7+BnPPvfM8d/oAAbCKXTFu9D105NF5ef1yVUo2jDHneaQlGs4R33bU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=JXtn1R2e; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="JXtn1R2e"
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 573NTghG024327;
	Mon, 4 Aug 2025 00:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	smtpout1; bh=v3SQcOF5izKkSzg3VK4G6o5+ed+7l3O78Ur5WK9OuEU=; b=JXt
	n1R2e++8JfDdeyMfSh3P3Au8/oOoYdGxZLGouIY+PcyHJrc4X4sI6DONLNURlUFs
	rRyPuDd/H/CLMEWUW9HQY1uaTvlV7pVFvdBEglM2F3jwUH4aAlTZa0RTYiVWnTqO
	oiVPa9vadiA4F/qcg8i5gNhr0H2axCANRj9JbaQc+i7V3uFvRbCxydIp78ZN4pV2
	i7F1e1VitttoU8F8Ju57DlHT4y3RI81yIOXHmzTz1H8xnQ5OYnuC6zXLkLiY2ejD
	4xBIcxsvD2zxq1Vh5n4F4QIXGxlPY1FCDtJySr7OXXsR4Sb13/6QlbQx2cR1DcPb
	YhJsslaTPjPBZkVm1iQ==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 489du1n372-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 00:11:25 -0400 (EDT)
Received: from pps.filterd (m0090351.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5743TfEJ018377;
	Mon, 4 Aug 2025 00:11:24 -0400
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 48a4sqpnxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 00:11:24 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fXfMhOTmci78OwqwDIjQB4hvK1eB5aYv9BGA9LCgOJJKNCAnOQ8iRbTz3iwmwrOOnxQ6qhr//vnpnIkbVXc19foLZWndlpfa9SuAOzz8SK7XEHxWmE0UmuB/zKkU75xBKCbHBm/tTbbFJ8hMtaRVbdQ8Kb0Juwi9ck7d79edFenhPVa3G8+zwwt/WOAxUgcwjHEsqtCCylmu1u2db3cr3M4v7aJJbkSizXu/PEKpZo6Qet2kppWZCaAl7eu09Glz49/us05ranRwaC/z1UIaKjTyjOaFhk1VnELffdum+099LxUwVOpMqSpJHXnjWl7JIotm7SokCJhEwnJjk+z/mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3SQcOF5izKkSzg3VK4G6o5+ed+7l3O78Ur5WK9OuEU=;
 b=r/vqynh1SC6nhGSuNZVtuS9FPm5B0TW/A9CjLqZMsAbz4eYquCE6gTY4UPjleT9nMqxx/KPaQQiLExucFry+HnL56DBhIMsubsRUzJ6x/NZ8IlbpFm9ox+jGwQHEwUC+FbtMZns1ChGakzZ2ucG/4tb4IybhBQ32Cut80OzBkydNI2vO89uySzgmrAgVpMXhhs1F65CX1Yb6E3/OL/57ieQNT/zo15e8k55vQ9YDRvJ5+CIazxE7B9XRKMVyi2Z3MXgpfQ/F/KnoIJIXOT4kdDhC0WNf7V5FGBfyTjgd0X/2TXJbp3+MDIhNf8WVX/yR6IuF/UE6quh4LwIFTN5RkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SJ0PR19MB4590.namprd19.prod.outlook.com (2603:10b6:a03:285::21)
 by DS4PR19MB9052.namprd19.prod.outlook.com (2603:10b6:8:2aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.12; Mon, 4 Aug
 2025 04:11:21 +0000
Received: from SJ0PR19MB4590.namprd19.prod.outlook.com
 ([fe80::1776:78b1:62a7:6d42]) by SJ0PR19MB4590.namprd19.prod.outlook.com
 ([fe80::1776:78b1:62a7:6d42%2]) with mapi id 15.20.9009.003; Mon, 4 Aug 2025
 04:11:21 +0000
From: "Lee, John" <John.Lee4@dell.com>
To: "justin.tee@broadcom.com" <justin.tee@broadcom.com>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: lpfc: Fix eq count mask error
Thread-Topic: [PATCH] scsi: lpfc: Fix eq count mask error
Thread-Index: AdwE9dOmfiWKzy4ZRwW2UDXtuA2XQQ==
Date: Mon, 4 Aug 2025 04:11:21 +0000
Message-ID:
 <SJ0PR19MB459028F515C43C5B91E662B4B223A@SJ0PR19MB4590.namprd19.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=True;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2025-08-04T03:55:26.0000000Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=3;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR19MB4590:EE_|DS4PR19MB9052:EE_
x-ms-office365-filtering-correlation-id: 91d45bc4-7780-4614-b881-08ddd30cf839
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|4053099003|38070700018|8096899003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?M+39aX6yrieY9qQlioap1x9Jy5rA/QeMwZBmJIaBmW69/37KRE0gjDviYnvx?=
 =?us-ascii?Q?OHOqz5alOr8H9sygbsyonqrtVuJheb7x8ifmPhuPm2bpPpQFPm2+xB69UGDA?=
 =?us-ascii?Q?Pab97pPvyLmx0cQAcJbbnGGLN6WycbhWgHnwbuGn0MsbTgOXB8CHHCKj5cQH?=
 =?us-ascii?Q?oJnRy1IpOffGUjPtHAqohOBJRXTh4mMmCr5Dzgr71DY2GQsYI38fIjnrzHmi?=
 =?us-ascii?Q?4K7Z5LKPw59wSlFxNYHaN+h0jNo7yvou2V7a+1jpc5IPTHfdfptKbhF4iIPf?=
 =?us-ascii?Q?xBU5JRfX20gzVJI3zt6MN+fJK19MPt7YHAaD8yJ6c2bwAqilETzxYk+5aYGT?=
 =?us-ascii?Q?yAoXdAsBKdpJDyyhRBiZA/4Nk+jUF2DSFXmC8NW+5H+vbE4Rx71yCle7r9V9?=
 =?us-ascii?Q?ozTIe4mtyZZjXnjj203Dy6gDyB7gk95drJ84n5xA40s+Crln9f6Ksf2Uu3p3?=
 =?us-ascii?Q?cGPh3mZO2jXIUhvXbxICKWJzg2GmO171E5mYLBEoec9JBszxJAnFRblDbVq+?=
 =?us-ascii?Q?ZlF+g78xK1l/xuVenSqINmbvQ5HMvy4577n+Aw4+FdIbIon2F284qlmjD61h?=
 =?us-ascii?Q?8gVvXbGplfD7C27qVSGTUdTcfzd4pCzmIYDWJlDP5Lf9lEJp3b8YicT4Y40B?=
 =?us-ascii?Q?QnpoeYs1iXTPGTgaU6EDlNr+WH/tVrDYnef8NPVdYwb5CCfHS/dOhck5QQ7r?=
 =?us-ascii?Q?ZEjoQPoK4tuyMVPOM+9WG+aKTg1TYPT1dmQ5mbi6yZNbuEjmUayj8MYop3//?=
 =?us-ascii?Q?5faOk02igsoEBDoqbsAOnl5juZ2QVl6GjLgjTZALcOELEoL1kxQG+P6RMnhY?=
 =?us-ascii?Q?OuCid9LxC6bea0ytXTXHjXb78jcNgvy954G4tz4ucbzGksBiQcjrn2TL8B5Q?=
 =?us-ascii?Q?Jq2gE8H5Wimd4M6PibKAQE4DYnBbLfBpbZ5ccoKmGC/FZkfkzXAJ4HbEdyns?=
 =?us-ascii?Q?+47HQkRUxXVhFRdAerQiPP9kBAHpk/Ax9NJDjo10fM2iA7ztEJqSxAw8hOra?=
 =?us-ascii?Q?WEcCkTgQmg8dOJXz72LjopDmIVMnlZNWslo/3f0C4CPMfsMMgKwfpIo2ZkRh?=
 =?us-ascii?Q?JUKoZTqVYcqMow0oIfGs4zwn98MBkCl9aJrh9frJgvXt1KBWh08XfLvwaHhb?=
 =?us-ascii?Q?+D2XSa40pqEuLwXNAYgmCyuD+tIy5G0AAOdgYcXGLRPObl1RPRhmiL8eLbNs?=
 =?us-ascii?Q?tPuSlU2M5C/+5trglzLLFnFadQg5tFjvEgAQXefy7wYD+eqDiiRtxfNkDEue?=
 =?us-ascii?Q?IaYOm1ilvX8btY5YUQGJOSRdlXcbSEaRuPeQoDlBa4nLRkjJuxiJPonG1t/W?=
 =?us-ascii?Q?X/UqSvhAAUyMEI3trl3/PscnPnmBsIbvjOklV86FB9jEq+eGCqcX3IKX5Kp8?=
 =?us-ascii?Q?Q1DYgMvrpq6bVpj205L/8VmbXNOncYPSJx1hzY1du4AKZzorpiqN3ipVCHr9?=
 =?us-ascii?Q?Ob8T6BoqxHbjxDsWJD58C9klsO0azbfuxWLy3gTSldVjIDgsnfW5zWQoJyhG?=
 =?us-ascii?Q?fH3fXYJ7ehfnPY0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB4590.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(4053099003)(38070700018)(8096899003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qFTKq2wwBIMcpPDwwn/zzLySI2PCZRpX10ki5129+lfJcP/cFVrg0SkFxzOW?=
 =?us-ascii?Q?MdbR95fnGrYqJxPeBJdQpnyHbNlb5+AarMFrZTHDWGukjpjng1+D47twfTsi?=
 =?us-ascii?Q?RqxBCZrDXJaX8RRnFfSdNzlEvY/kGE0PVgHNiKcXH+UsLIEdfbao4tfFfNo+?=
 =?us-ascii?Q?Z4fr11SLWUhjqFXHCX4OLf1OZDVx57n0fuNwBRS08xIbdAxte5s2CbbkZhV8?=
 =?us-ascii?Q?VLZqMircbOmVvaWJssyBETeMcGAB36s+wrIncacBu6OzHNc91qHRwL9B66P0?=
 =?us-ascii?Q?h0yeqp1d5tD9g67TkUoBa3KttCXGO2ona9QkqgXIukNb8YxuJBJg25tNCykH?=
 =?us-ascii?Q?kemQqG0/kVPUM+odEeXMV1xQW3H3GupJ+kLvgFBMKY3dZtjP9LI9Z8DkdkdE?=
 =?us-ascii?Q?oDAK1uIQnUThaJUnFiMumZJkbSwdyIBeTFo13k/VBuBG8g8k9vRFfzfV+zPq?=
 =?us-ascii?Q?yOqg2zvBtoyewdyJzo1J8pbLpyfcKkpVRa4flV5IGa59pMtyvAA4cq5aE3mW?=
 =?us-ascii?Q?GoT0TGydkXcpaw7gYE65woRRzfbs+NQJs4R8sm7fuFzX0z7wPFw34r56Lzge?=
 =?us-ascii?Q?unXJs8wTO2cWdUXq3vwvd78Qq9/V9XaxcWQlHEvtA7c/cXvf3tVl+Dzs1Ek8?=
 =?us-ascii?Q?pE8ILJDV2EBpRDa4JbbioD6YwkdW0+uEaMrkqBveagIuPTunXzoUry7/i1rd?=
 =?us-ascii?Q?AaxrLK4o4omP6j9uwS9UDSeFToIu8YtWUkOtXcJLWuJAB0v1zxk6WhXnkchL?=
 =?us-ascii?Q?TQNFcms2EltJpN7tB29Faq5BArUttULfLi/0jot+87Snpu91vZ4ASTvmJjni?=
 =?us-ascii?Q?M0iMJJvM4ve54f2UhimG6jr9LhiQ00s4K/KwNFuuAKMp5/qK9GcBNcW9C7Ut?=
 =?us-ascii?Q?SjpJcgrbrNu+St1EJKLcAdRDNyqXJBpJz+9rqmlTrbKdLFlssRFj2KPWIDO3?=
 =?us-ascii?Q?84pziPT8je16vj2+9YgVzLoO4BzWr7ezG63QpgJ6mLShEYytfeMFYDgqqMoQ?=
 =?us-ascii?Q?VqsLRe57vXMoc0mJd0uED/rYfnjhWq6tjiGKP4t2ZjTZE1mFXWBAazelingt?=
 =?us-ascii?Q?7d/di4W0a9z9PF7d3enQivmpMDxTfzDtHyQdCb/rgbv/iGEIWpT2dBAk5c00?=
 =?us-ascii?Q?LvPHR524rbbCau3pJFUHnOtvO3SJT4MePw0xI7/79XhYl7zGK3gtTGts8qS5?=
 =?us-ascii?Q?c2RHStjfvDWV+dELx3RNtiMOjHcSYOPWDYIr10HlCvj5FONMeUr6uRFAXjTB?=
 =?us-ascii?Q?rBwof4kw2/68RLBg6JCYGF8HxNW6q6hN1afcaiWnkJwzvwbNcUN/mvH2ftek?=
 =?us-ascii?Q?RiW0Z2zPP9B84VZISYpFTY29dJwC5JMQ3xOfTjf8PeGM4cojIDbZXT6VVqDw?=
 =?us-ascii?Q?20Fr6TimzoTWD2xpEn9xOFddWkmDhNC5Cl3RD9rr6TeejllBfJjuUNRQRkCh?=
 =?us-ascii?Q?pwcaQDJjl/RCdB2sRI7y8snkPqK7H6lbgvGb0HoDiFUMOEUNYSAHd8NNSKhU?=
 =?us-ascii?Q?NQ7teoIMOc7BIIk2UcBi24kyL5R7rIRAsrtoZCKr7T0mcgoEgg8onNZ+f8ZB?=
 =?us-ascii?Q?1JUke9uz3Go4r90QygU=3D?=
Content-Type: multipart/mixed;
	boundary="_004_SJ0PR19MB459028F515C43C5B91E662B4B223ASJ0PR19MB4590namp_"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB4590.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d45bc4-7780-4614-b881-08ddd30cf839
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 04:11:21.3705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nhq26aGO4RVz+rjXRP0oSTEyAhAdXcocLCxNYMTWwFmm0FJ8Uhn8ahA2IyqlGA0LWArOteeKzGl6+tGeAosGGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR19MB9052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_02,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 mlxlogscore=659 spamscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2508040019
X-Proofpoint-ORIG-GUID: Efl8REQijOUO2O_fmQwDGXCRFdNZAjR_
X-Authority-Analysis: v=2.4 cv=GttC+l1C c=1 sm=1 tr=0 ts=689032ed cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=u1E0KylwFCn0ecOcEOEA:9 a=CjuIK1q_8ugA:10 a=yMhMjlubAAAA:8 a=SSmOFEACAAAA:8
 a=3r7ihuFr8rY1otJf:21 a=gKO2Hq4RSVkA:10 a=UiCQ7L4-1S4A:10 a=hTZeC7Yk6K0A:10
 a=frz4AuCg-hUA:10 a=wj4KQc8qsOsxTWURJSQA:9 a=B2y7HmGcmWMA:10
 a=gbU3OgOOxF9bX48Letew:22
X-Proofpoint-GUID: Efl8REQijOUO2O_fmQwDGXCRFdNZAjR_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDAxOSBTYWx0ZWRfX5YOB2yrBKma+
 C9m2XH8vJEU6a6G0Up6opfTDkcQsacKM932JXhjLNR1zKOg5ALiuVLsTVoJHAuJH88X6vHNQKIr
 78ECzFITrOTK4c06PeiXbFbjNPGMxRYTvtAIG9DPHJaGZ0NMRDrNhBi9Ve2gd2rpsMrzNhxYgi0
 bYVNxnRwFTO4utmpSlXsGEZRoWaphtqxzZqmresVUtuB/MYb5Zt276FZ/8xc9rD+XfecfNlPIDC
 t3Aetc86aRbMIl5q5ut+WiDwaPBOpkjEa2Mz4WkG41eESjsjDYmjTlTi5G5ktYVJxRhnoRsiTN1
 MUfr+GabnFRx0xtFd73X31HFXSmHZTNtTPXUs/CprOOTTXuQlW2l1MMUXTbiDzgVyQsiwEzUq7h
 TlIMBnUzsJIrrK0qpgxR56GPiCeN7qP5wI75G3wNrv2X+9Molyq7/EYReFAYoE6674hwgbcJ
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011
 phishscore=0 impostorscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=591
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508040019

--_004_SJ0PR19MB459028F515C43C5B91E662B4B223ASJ0PR19MB4590namp_
Content-Type: multipart/alternative;
	boundary="_000_SJ0PR19MB459028F515C43C5B91E662B4B223ASJ0PR19MB4590namp_"

--_000_SJ0PR19MB459028F515C43C5B91E662B4B223ASJ0PR19MB4590namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Justin,

Could you help review the attached patch?
It fixes the count mask error in EQ create command. We need 3 bits in the m=
ask to create an EQ with 4096 entries.
Thank you!

Regards,
John Lee



Internal Use - Confidential

--_000_SJ0PR19MB459028F515C43C5B91E662B4B223ASJ0PR19MB4590namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:DengXian;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Aptos;}
@font-face
	{font-family:"\@DengXian";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	font-size:12.0pt;
	font-family:"Aptos",sans-serif;
	mso-ligatures:standardcontextual;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Aptos",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#467886" vlink=3D"#96607D" style=3D"word-wrap:=
break-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi Justin,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Could you help review the attached patch?<o:p></o:p>=
</p>
<p class=3D"MsoNormal">It fixes the count mask error in EQ create command. =
We need 3 bits in the mask to create an EQ with 4096 entries.<o:p></o:p></p=
>
<p class=3D"MsoNormal">Thank you!<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><i><span style=3D"font-size:11.0pt;font-family:&quot=
;Calibri&quot;,sans-serif;color:black;mso-ligatures:none">Regards,<o:p></o:=
p></span></i></p>
<p class=3D"MsoNormal"><i><span style=3D"font-size:11.0pt;font-family:&quot=
;Calibri&quot;,sans-serif;color:black;mso-ligatures:none">John Lee<o:p></o:=
p></span></i></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
<br>
<p style=3D"font-family:Calibri;font-size:7pt;color:#737373;margin:5pt;font=
-style:normal;font-weight:normal;text-decoration:none;" align=3D"Left">
Internal Use - Confidential<br>
</p>
</body>
</html>

--_000_SJ0PR19MB459028F515C43C5B91E662B4B223ASJ0PR19MB4590namp_--

--_004_SJ0PR19MB459028F515C43C5B91E662B4B223ASJ0PR19MB4590namp_
Content-Type: application/octet-stream;
	name="0001-scsi-lpfc-Fix-eq-count-mask-error.patch"
Content-Description: 0001-scsi-lpfc-Fix-eq-count-mask-error.patch
Content-Disposition: attachment;
	filename="0001-scsi-lpfc-Fix-eq-count-mask-error.patch"; size=825;
	creation-date="Mon, 04 Aug 2025 03:56:31 GMT";
	modification-date="Mon, 04 Aug 2025 04:11:20 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhYjlmMTkzNWM5YzVlMmZkOWY3NDZjMTU5ODAyYTMyYjYxNzJlN2YyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb2huIExlZSA8Sm9obl9MZWU2QERlbGwuY29tPgpEYXRlOiBT
dW4sIDMgQXVnIDIwMjUgMjM6NTA6MDQgLTA0MDAKU3ViamVjdDogW1BBVENIXSBzY3NpOiBscGZj
OiBGaXggZXEgY291bnQgbWFzayBlcnJvcgoKLS0tCiBkcml2ZXJzL3Njc2kvbHBmYy9scGZjX2h3
NC5oIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2xwZmMvbHBmY19odzQuaCBiL2RyaXZlcnMvc2Nz
aS9scGZjL2xwZmNfaHc0LmgKaW5kZXggYmM3MDk3ODZlNmFmLi4wZTcwNzg3MzBmMjIgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc2NzaS9scGZjL2xwZmNfaHc0LmgKKysrIGIvZHJpdmVycy9zY3NpL2xw
ZmMvbHBmY19odzQuaApAQCAtMTEyNyw3ICsxMTI3LDcgQEAgc3RydWN0IGVxX2NvbnRleHQgewog
I2RlZmluZSBscGZjX2VxX2NvbnRleHRfYXV0b3ZhbGlkX1dPUkQgIHdvcmQwCiAJdWludDMyX3Qg
d29yZDE7CiAjZGVmaW5lIGxwZmNfZXFfY29udGV4dF9jb3VudF9TSElGVAkyNgotI2RlZmluZSBs
cGZjX2VxX2NvbnRleHRfY291bnRfTUFTSwkweDAwMDAwMDAzCisjZGVmaW5lIGxwZmNfZXFfY29u
dGV4dF9jb3VudF9NQVNLCTB4MDAwMDAwMDcKICNkZWZpbmUgbHBmY19lcV9jb250ZXh0X2NvdW50
X1dPUkQJd29yZDEKICNkZWZpbmUgTFBGQ19FUV9DTlRfMjU2CQkweDAKICNkZWZpbmUgTFBGQ19F
UV9DTlRfNTEyCQkweDEKLS0gCjIuMTcuMQoK

--_004_SJ0PR19MB459028F515C43C5B91E662B4B223ASJ0PR19MB4590namp_--
