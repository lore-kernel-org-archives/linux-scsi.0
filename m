Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0622E31326F
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 02:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785292453; cv=fail; b=WDJYx1ci3pa4Qwy4vMI5eg91mwKch3AwTMqSgViBQUTq1mKxnEeojulqbjnv0554VjY2tFDpL4PFTu5UET+RfXAtGt5inTa3S46CF1bnBgAkBTDcd+bE1SnVKwGv++2EKLaRnOxVTq1yOsVmAf9gjO/1vAbopQuilkSkYEuQ1iY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785292453; c=relaxed/simple;
	bh=8uDP2OpjRzGTEtVatwx8f6PZsXZHaDwebhsAKCw7KtU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=H68/kECKEu2AEL1NGHmv1+ggF3O3C6Sk14FBuI25AG4N6w7vpLG6bTUpszyuwL+eVtgUDEPPONXDTfWH+zBCEAMRy3T9pAJd+w2Dr8XJ/J0R3sS8RM++sYwGtaGqrHGSw4Ip+sjbtX/n3O/tqgRluwPOdyMDIy8rNOa/a3fWyrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jjYSGYGB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bIc+4fj0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jjYSGYGB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bIc+4fj0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItoCT2091521;
	Wed, 29 Jul 2026 02:34:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=G0NaN7W8ER6Yy7QNQe
	cv1hS5AgaTjKEUHoaOK0gPuhI=; b=jjYSGYGBEC7u6Nb3L5PI2o7CRlcKd8RTRa
	/6T5WZ2J2P7Fpi1+6KgJa3IkQ6MCkLGWwA3hQFx+jnaKB7RO6wl5YEEznYo/3fWP
	K8oGTl8fsL3kdOeVI+s5UxqthSW4b4msaQyyq6QQ/xTi5xVtTDJm/aXCDIDNhIc2
	FONW0aUgBoaYY6zSpbiHdsQ1us//OuT1Ii1mvGVWALsBqezFHlB4IBrZ3eRGxBWJ
	1Z7l14bz6BJKfWSldi3rIclONedXeOxhCdKH+fXOoc7SKZPn0vTdBKwb7tX+9u1R
	Pi8/7H6aIXps59MsKTOx0HG/x3hbH1jXtwhnMEP0RLu/nEZCt4dw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyyd7f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:34:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2UXfQ040922;
	Wed, 29 Jul 2026 02:34:05 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013033.outbound.protection.outlook.com [40.93.196.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6qd8ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 02:34:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mADjrAWdPJVYvbveGkwH+GOV3jQCX1IilIHTUdiEaP+QUL6i2vdAXWBUxoYGXNWxRi6WivOnbqp3+0By79l2j6SFqYyU2JtImzHpDt4EWff5a5STqACLe0SNZTPK/RNjvUTNPOmGbOiuEoRAbaummZ6a8ybTXBmzX4C/DbVjsGBBOnaTi2/scNv35zMurm+Qc0Xq1qdfrMPCFK5RqkBRZQ8EG5OWAffwHOde8Ph4NJBr9fYnQL/6AO00Z8vAeNgRK3HJxOvjfpRsBf36zP78qkDnVazYTKyIsREH2llWqNMdyjI/lHt9o96f1BB8zFVZi3M8FAntqztRZO+AFYFTYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0NaN7W8ER6Yy7QNQecv1hS5AgaTjKEUHoaOK0gPuhI=;
 b=RLpVT4p3Tstnw2Pm5L6Ja5IPzx6d+1vmFgCX1I0iAlSwl3KUaPiNxr1OtFK7q+OyZYoFhtG+YXvWKGNvwXmlDuZXEEQuFn8jLHFZLyT5Hl8E8vA96e19jdSEADQyra+2mEbpTBU1TXln9jVXage9Lyf4BvzGVjBTwCnSb5F6cXUxIn+jUD+P2Osirsg8TXVXhj6PW0NrY50JpfC1d2pZd3hXyiHfAeu6d4bgqKfXtjrmvmFjwvDRJHxkv2X1HKcLU8U5jJq9jku53wlmTiqhafPX1dh9PWP+G/wwTXUKIRXBghD4ie1AGgs4oDlKPwhwEvMR9Wrqw7/b1ITr7jbN6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0NaN7W8ER6Yy7QNQecv1hS5AgaTjKEUHoaOK0gPuhI=;
 b=bIc+4fj0UnQsE6gZajA+gwL8BQR6YV0fPSBPdVOomwBhhXHLfHd5oqJdy9dMeyIdHTh7VBtNp5UU05SZF4Q/T2KDsV3ay5rdy83IgT1iBNGO+z2a/LXp7u8NZLETOLgYdB/T/P4G8VrCI7SqqUXhwZEjmavRvmf227R//23YBO8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6218.namprd10.prod.outlook.com (2603:10b6:208:3a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 02:33:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 02:33:59 +0000
To: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] MAINTAINERS: Orphan the SCSI tape driver
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260724055923.4793-1-Kai.Makisara@kolumbus.fi> ("Kai
	=?utf-8?Q?M=C3=A4kisara=22's?= message of "Fri, 24 Jul 2026 08:59:23
 +0300")
Message-ID: <yq18q6uwmp4.fsf@ca-mkp.ca.oracle.com>
References: <20260724055923.4793-1-Kai.Makisara@kolumbus.fi>
Date: Tue, 28 Jul 2026 22:33:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0098.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: be144805-f422-47e2-75ea-08deed19d86d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Hj+pEJv5gD0n1gtSV7lbRUsD41lQjP9K8hD1knS1kKDpUnbU4AAQzLU6nLPXgXkCfpDqly2GC1dMrG7By3zblollbW5g6Mpiig7vRNv0uBwbbv1lkJWuzs7obFjM/nuwz70kRgCTETBn7A8t/denlST0+1iMNHoLjBNRGGvz/JD3nO56CZG8eEnA8CRfIrdSc+7iJxFuBO57jsL7YPQgt89k8K+h7e08pysTHr8fX7PxWM5JhsgcyW6cBkzQhUwYUTtmhda+kSyeuYVYNiLqETz3PnGYzrp4GVS9B8YKfPg81leCizcSdRHnYMxmuBYQ79cCswkvuorBKHQY3VFSDayBD2FGtwDMmIJkn9L27eszXmO98NPj/rlI2JXhgcmPTQOzPJ0jFVycLgt5DMsholhx23mveMeFn3M/dCwzhXO2lPvnwcNe+tVbcUni+g0TYyVKFulju3PUvZXaOH7EEoldoeG12KzpCMLvp+jyKfs8H3fpoqQDSjrboLRS3gduzcCebjN/llH6533HQOoYWv0UBXPUkkmz0nycpOouGX08fUxO0I33keUnJXxPC9+0aEYj2gYIaMBP84prW3FwJ4W/bWswRNEHbfRkDcJwHOT6vSDKqKlGJPnpieTiHLqhUXCkdrFW69L5ofeA8vREV0kw6RDtYkEjid1coNRFEx4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZO9i30iEVFrwg4UZTsgEAayu+vsWYLDoNhu8GdETpFnX8aUkZ+ue4HJngY8/?=
 =?us-ascii?Q?ukYjA3+EHeGGiUXdus5NlxwDmgtNAibtCZpgkhdAEHad3UP94o/rSM/KWduv?=
 =?us-ascii?Q?U8hOg2N2KlmBuhcSkkCdtFwC+LXiWBbypt5Q7aHVSLTxxbr8Jiu3pe5WO2zz?=
 =?us-ascii?Q?wFQYm1xp1eIV3KKGnbAktu6p94lxmzwr7pcL/YD7Bn62jNQebteTS1LITb9P?=
 =?us-ascii?Q?MSBfivT4exoq3oc+R2JRivOF7B+VgPeMU+F1ozKfTxvjTTI4QRGjC5FLUH2w?=
 =?us-ascii?Q?tkdHgs89uOEx+C6Ns1RbwXXAdLosHu4GgODur+6sr6Jsv6/NN9dwCYiSlk2i?=
 =?us-ascii?Q?CkResgjU8RdDEEiBKflyyq5pg36uYMnCeo0Xo8rruDiNxJO/z03QDmnl8t2Z?=
 =?us-ascii?Q?TYDUCocetel35weLaSXF/VJi2HcJTRIQGhqagrISMtdW7S/wq9ly7V6inghT?=
 =?us-ascii?Q?dWl+1QQ0YS9WcCBRBrMbPPOQ8C2YsINK9JCvyPUTPX8lH8bPgqjmMgq/tUC+?=
 =?us-ascii?Q?NbcMXLd8ae5S/zu2C0bCD+hbweGRNLAgb5P0V+/SeX9zt0APsHtLJu1v/yNq?=
 =?us-ascii?Q?P466qFLvLqwoqG/MP6nJeIVduHeJ6hHOfMKV6UMLrP8p3KmBFM6G9arauYiP?=
 =?us-ascii?Q?BnrWPUy84ADqcQodfhj/VFI+tABv93OeCm/rUZt4ad7Z3bPmsyQgMiApp5p+?=
 =?us-ascii?Q?4hCrpHVbdO0MgGmvRjqP8AjIK1GjRL+uCmZhoPhcaaFWt5RQKHZXnpen12A+?=
 =?us-ascii?Q?fVaCiIe5f8pivhgJ8GYMcxRtiyvLUSTm3I1POgDd9Htguzf6D94alSG3L/aY?=
 =?us-ascii?Q?4Vquw8Pga6RVfW7x6Luf39yDPMN4irqbVueP2OKPR2cfRRjrNZ16fxzofHaW?=
 =?us-ascii?Q?XmEg62gNmGsnefVSwWa44rl+phBjzHY5skhVs6uVfkmg6YqELVml573+JA1T?=
 =?us-ascii?Q?VNihZha7m6dGibC7Hy6iC5CmQBTL51vFOLhVmshN86sTOEQ5EUA/p2RyvEvR?=
 =?us-ascii?Q?dPZgLVKWNP+9qRqhltSj7CDVr8+xqLarGnidb1K2BnNmi85OJmlz0P0ko8BZ?=
 =?us-ascii?Q?I907+cvhV4allmyCb87ZqhuO1PomiRK2qdkwjt8YJQ6RSs2moDGxTj0dmLaS?=
 =?us-ascii?Q?oXuaC7a9WmzhHo8mFe7jCKImCJ9LE/EfB37l7Ask7TzNE8pD3CWlTOViApfw?=
 =?us-ascii?Q?/p8f0+0g/gbejZJ6AI2TQ6t5hFTZLv0dG9DKYp9qCprXRkuTrs+Ztu/Sr671?=
 =?us-ascii?Q?oEv3PMtpY65QAxD5OsJRrfj2vlwapJNuwZ2fPjE/TApO2KNFaV/9cIIpqvZp?=
 =?us-ascii?Q?UaUFUHevqdgxxPFSfo0YHk74Evp1Oj5a63XY4sS48LzsX8s79DP7Mm4aU1Hl?=
 =?us-ascii?Q?K+ei3gMLli77+iv/UdK7CFKlR7+axRxJ1iNJULsDfdwAIOOe/jnfcPyDKbFS?=
 =?us-ascii?Q?mb3C6RQHXRr8r04rSrBfqe5eRYe5fzNk9SW1hk2MVM/VAS77z8Ps4zH/tPND?=
 =?us-ascii?Q?8Mc4u2/jANeZoaQc0tYyahlIEaEX4QmDeX9UPrPt3Vq3mCKP7ZYcXolxDk02?=
 =?us-ascii?Q?nXnHUuXuj1G99Mszfm6dEjYU0br4XpikkRvPhWXqFCZqSzN6imTAqWhSrEB8?=
 =?us-ascii?Q?Kc+2DE/isc6UA7xSfold5PClVLWVKUrADar3H4lboaPvzWId3mpsi7Rd2H4Q?=
 =?us-ascii?Q?MMWyHxLZi5N/WlOYZeHAVwDrNg6PZU3K7uExoGHKTBPzb0/gwTXFOX8CUlS+?=
 =?us-ascii?Q?Wok4FV+GpdUaKVTZREvBcJVyx7MQN3U=3D?=
X-Exchange-RoutingPolicyChecked:
	ZNbbnbC40yVz884XkRbO/xxSYYn4Xc1k1VmN27UKg+MZya48UhS6gHwojX9CngZsZ6rtu1mS/YtLYrKPbPqK45zAaGJWJ6tb81TClImN5yp5nc2mZjOtKe0+F2Jq/58hSnVRL65sKu2opcYpecJgP3rVGsKydpdRaONpMgUvPrU1TWrEyzkIX0LXvw8j2DcfJADxL2GmWsD+Zz5Ne/POAprLh2pEjdp5RmLDkqKsMtrVjcQ157JmPXUaY4wVaB3tU2mrvf/mEzJuRFU7Y6x4Q35Rvf5Ya/V38WjHkkVs53Qi91A91Qh+btLm2/tumtoAlo2MeIL+CI6GDvxwQNjYyA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qqEb23bQwiBTEAUS6sdI79Rtl7qCo65kZHH+PJkwlCQhCKEpU+5L1sJKPInUy+n7YuGhQzTcmiM/g40u9TFPnX3cs+ucVov4cUia6dyxdgzTs6padIeVRuEgNbpE3nk23JaVkkHf3KreaVNPv6MojQ400F9l4qZVNHwkPEWClyWwmyqx8XX3EAYxz+WQTbD3/J65UUKJS7/303Q0wjtzX1OnKw1wKpX3e7lO9RynKNT+UTYSyrFH8fx3wgw/iCjcuoYOb0owDqz55/BqsIqV2/Gr26bJSjd1AHwsWkXskwh6a4vm0WBmaHD+6Hl01ECYEeLwtebJnEFJ3xq8iWS1uLn3sfAqs3oeRzFKc3pyFfUf3cdN9Zs/scRBSgVidVKesL8vLgPYsmRIqOde2k1XoPrJCFceQsNdnnBacysISYXnMuEQhnCRPygqihLU1vmb4E8N5DZxPI+2bWRSzHOhIduus8NtveY8t//5ut12OH/2f0xm/B8K+UmZfLnMVvKoBWvdQKcRJwnb8vYn0IO09a4V3VVsynHmToOxpqyVnapOW9plG161dQ5Bz3x2tBKmf1Y/CmJ5FIu8vrE0nhrlyLV4yXkD6WQ3Jhzs77YS7mc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be144805-f422-47e2-75ea-08deed19d86d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 02:33:59.5308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +k857nuB8DmMaNVhHE71Udn/o/DPg52i2OO6D/zPAcyia9sdP3x5u0qkQtWYJQSZXM6KgaRt4pds0HtUrR/NORD9oLVDpjiFm9o3w58izcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=699 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290018
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxOCBTYWx0ZWRfX/+74mOVu7iuO
 w5DoEGI30Uyb2y6YsNoINWswlIBxroD/ChYk/HYW4YsRcYHJ7HIeoxx9fyiouO3iyExhImHb48P
 U+pmmc9uPNK8Q7bNPFfE2blrzdMr+nFCWYg2CS6dK48nOoFp14Re
X-Proofpoint-GUID: 3VH2JKZ6KtOdtW-ik5kH8ILrkkfPEY-j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxOCBTYWx0ZWRfXxy6iH9IlnqMP
 4+RAMzsADE35p3bXU1ceiV3z/oYaYIEYMTWXGeUD1WJDjqU3IvY0w1PwtuD6Rpa8xawKaxJEnC6
 9titfle7byYUWscjwZHP4Fld7mIlS8hrWbuYV2ot+w0yS0yEgshCiNhznjvMXFm5y1R8gvrt0qe
 bSMw/aNqzLJ6VQ3iW9n4a4Id3YjCu7A92U+le+CvDQrIrG+KZ7Ociw2D5Bb7h0puvZ4roLJgwkX
 d3liT8B+oxgtI7GnmX/6/pz2n28vYNOVGFrDl1e/eodm1Kzsn958Y30X/IJYXQU0hZuxhcdt5Cg
 Sa0GA1vd0I47NwQy+nvIQLajwk7vMhnyLaIkfgSD8/cu66jimSJoFm3cDBRuGLZ7IPb88zftVsa
 LPbiOE4uL3zI7QKIvMHiFLSM8eaatvXqk/qkipAPJbOTjjiNScGMw/TazlfqojH0DT8bj9LDHhu
 U5lO+O2APqX6eji5hKTbJj+Jdktqfy29IGrYComk=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a69669e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=SZ28HBOvf325YpvGjvsA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-ORIG-GUID: 3VH2JKZ6KtOdtW-ik5kH8ILrkkfPEY-j


Kai,

> Time to retire from the role of maintainer.

Sad to see you go! Thanks for all your contributions!

-- 
Martin K. Petersen
