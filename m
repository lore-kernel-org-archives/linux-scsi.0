Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA1018DB01
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 03:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763609225; cv=fail; b=N/vCmb2cBA880eKgovVgYTSdwlqY62tye22oc5RW27C9sX5mZ8kZ0WdL+AZDcOJKU3CQZJ+NPWZ9Vpgl0CfmUus4v7wg/at3wxF9YtimwWTs06F6bW2gJCq513q4NiqM6a6iZSEwrtGtESLiTb+6jrOnhMbgZGdDfrVDqwxXu7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763609225; c=relaxed/simple;
	bh=NC2nSvL2kD8DIuD25BP777dvkh3VvR0g149iiuBm730=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JzYfdwQs05QFruf8FrGjumNM2e0hBadtYUhGxsQKeuJikPBwgc1wgi+QIoo3ykRs/dbOff3St7du8FdzWXTI5F7s2hSGt2DcA68WLVxPmY0lRZdemBAqnfyXxpSOev3CXuWgKWiXiBHoCGLNHW6a3kMOIIGhwm+sqydOOnnz3Ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MIvqRwXp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BQyw0+Cf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MIvqRwXp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BQyw0+Cf"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NTf2029867;
	Thu, 20 Nov 2025 03:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rgSG3CO5g6BOmMLe/2
	+knxSvolmHrKU18CrmRRBsuC4=; b=MIvqRwXpchGro7Xvo6g7fvGLweAsPnNIMf
	r0x7CXmUzO7pQmq4gTiNni5k1Aukvq+ohC82TgXRtu1Od9t0TqJKi69P8i4n/xs4
	SPvNNGS0h3uMRZdEFOaMbRXhVh/kG5QVT2uh6VSFy595W5BDv65gbJTDIx1klFdX
	AUDxlti9uGJZ/zAlQpneDasf4AVooz05XlXWFBWGYw57/O2A4m7gvuJfpbhrkVui
	PoWPJp6lt0inAAJIYGrT426x3D4/xKWblgyx/5pwSZmz4krEldkYPmCRppVcMHUg
	xGbIX7RufoYaNGm/KUac14WbzxnAay88NGBH2dq42ymAqR/17rsg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968afp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:26:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK12AVF036111;
	Thu, 20 Nov 2025 03:26:55 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011039.outbound.protection.outlook.com [40.93.194.39])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefynrpj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Thf4Lhl7ACm7N9UAfrsfxUBoODNhu1/0lkbsQEcztXA+sFkyhc+GDygHeRB94V97piCRYuHNVk1ZCipxSlx4L0U8Lu0/3ldx85GXUIJA7bmHXLVxa6YJKguwcfcHnRuUPbEGT/KjAePIBqJjXvIwR4Sw5vzKYnbqhBl08ZMernoZeugJgaSOpWs2eVPZjcOzMwEgvYznTe0fHR9stQ0O0WrRvgogE7cAggZ9XGB31cLM6F2Xfq612dS0HHlwx8YGpLDrQH7UuqW0l1sW9ompQHwXs+MQyLkdy4XfptNLQ3of7h1FUn69k64VOZ0ezqkLvk0QLafpcbbyNd0zpcS8lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgSG3CO5g6BOmMLe/2+knxSvolmHrKU18CrmRRBsuC4=;
 b=JbC+QspSpetM5G+tvFi8yfjaoLgW6Mw5fRV/qZlzddJzYiCja8MBWtO5sXcJz3Yz0WSZg3HEj83cqZp5Fm94R5XNemRlskviZnxhDVwn4IDctw8AZkHjoNJ1sLFsTP+1FOWWIAgXtQofeh7wZSO4yk9meFzr20GeCni8HEraV9m0wkjC2CmIsZXTKoKx0Zsi2jRmm1cpYcfEjCucllQ/otTrvFZlHgOSdlQ36AnV8OHk4DclUbmI6NoNUAegG3+MY8CRXQJLNCB7BU6qFiq/zqC5yiSsohAcRkefy2U69/NdIN9KZQtlPsbd9LcEcdQZmcbVLvxAhrzuvnzBcTB10g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgSG3CO5g6BOmMLe/2+knxSvolmHrKU18CrmRRBsuC4=;
 b=BQyw0+CfH4ePpdY3i73NW3e8jkNDd4D0qKMQBLZmhZ0zcpwRYqpCFA6yXR2NpopqxyzCvr5CUqkC9CYD2fyj/EwLPwcReqa4tW8f5j49U7Qsk/p9fFkrBQyd0dXOZk8wcqMEcMFPUXaS1O6BrXS+Xmi7To0W4ko+44UagTLW62A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB8132.namprd10.prod.outlook.com (2603:10b6:408:291::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Thu, 20 Nov
 2025 03:26:52 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 03:26:52 +0000
To: Lukas Herbolt <lukas@herbolt.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: sd: Rounddown host->opt_sectors to logical
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251114102853.1476938-4-lukas@herbolt.com> (Lukas Herbolt's
	message of "Fri, 14 Nov 2025 11:28:55 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ecpt9yqb.fsf@ca-mkp.ca.oracle.com>
References: <20251114102853.1476938-2-lukas@herbolt.com>
	<20251114102853.1476938-4-lukas@herbolt.com>
Date: Wed, 19 Nov 2025 22:26:50 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0131.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB8132:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ec65848-1ec1-4568-d43e-08de27e4a5c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PA6St5eu6kMfGZq0yoapnmoIX28X4jC5axK0XKmEh35kaYXrpWB3UviYYY/Q?=
 =?us-ascii?Q?wM+rwYoCnQOXr2VxU9FxOP90jbo3X0LH8Z6944WMMBuAvwc8DntW1EG2jg5T?=
 =?us-ascii?Q?JnaAVFTXgMJQjH9gylTLcgrRRvaLLL9M/yG21/WGsU765a0dHv/YUb/NJkDL?=
 =?us-ascii?Q?fyzK+biCp83ejIOLcG0VZDCJx1ONuKbHaJYKmIn/gLl/vW21ZLEqlLm6IZS3?=
 =?us-ascii?Q?atGJIkpIytN+txNTf33Ssk8TEHr5NqJyQ2x3++TBY19+e89BUpM6w5V8ybau?=
 =?us-ascii?Q?QxYLDr4X95FApDgbdrLC3AVWoyMlPud36gfzf3oJ7mYqYiOSzb6k//QQsNAj?=
 =?us-ascii?Q?P/n83eB7zHycAj1JgI6LUEwc+Ime06RKyFkd0jIy+suXk76Nl7aJyiGk0aqW?=
 =?us-ascii?Q?zLuI1hoLkGsU/3uP78XbTpeQHDwWmAKQB7pT05LlMGTF0VLK35dYHs4jPpSB?=
 =?us-ascii?Q?sAInNa66yMzzxJrE6K++RrJlMB4+thCHN1YjVEoBfWruD6jQLeLVuKQ0OrFW?=
 =?us-ascii?Q?iTwA0/AtL5zOGa6wXrr6+IqE9FYMzYvchdUPEQeqoiSBR0gmnn1FhP5omUYK?=
 =?us-ascii?Q?5bP7UpIQQbyBNVSrIuPPY7mM5diiTPLhPbNMzuA1EPqzVKIQFEfKxg/cSAN/?=
 =?us-ascii?Q?Of7HsyoRUVbewgzUJEicS0IwQ35rquW8OOzhjY7aElyU/9MWddWb/9I4m9Ux?=
 =?us-ascii?Q?wSSn4vFBI6qCy2bUWgT1tj8Q/fyulW1XPoC7Pa6KbJlyKjji30E1MeiO9Mwh?=
 =?us-ascii?Q?Z0Ncha5pJ/OQnbmtHctZvS1TfioeSDo2GklCWbEtT3y47UXFSTekJ8IJekCI?=
 =?us-ascii?Q?lUpT0nnpTFOwo/xNtKdwPGwW+zJ0Ws8HZ8Kmqz0KxAGL4WEXOd0/6HReRA/f?=
 =?us-ascii?Q?f75G5Bu3+BK+9IQImqkFrlhl1XPUiZf7QT+GEZX0MUu/QqAk645z3RDOeJp4?=
 =?us-ascii?Q?gRuS9hpb32dzhocO2t6J5T/V5WD9TSasSyJ7JU5WD2X7JSuvFKGKrDf3U6TH?=
 =?us-ascii?Q?Gv8B3PG20jbihROnaUTciKWAGdGi/x95/ApQwG22IZhGRRcvMNwlkulsWI+w?=
 =?us-ascii?Q?U+h8cOFBa45GBEoa30w+bsz2VxrIOjDF2hRLIcQ25rd5426UdFXXjTGll42s?=
 =?us-ascii?Q?C12gvYYK8wgf1QWgaPJd/r9haQLfs8jikL9m/1VApSR/keMrBIxbSMNNnVai?=
 =?us-ascii?Q?HM9S6hGbv7uQUy8ociOxB73zOo81QgwmINzdmUH25gYPH6BbSUjF2WLC9uYN?=
 =?us-ascii?Q?PCI2lzF8c2xeIzEEKXA1RqIdPnhjcKyvmXssPAT80ykslMzoZS0xdNuIHJjC?=
 =?us-ascii?Q?tgp28VCDTA+KNbfCbn/nTR5rhPtaXx2RnZNa+SJQZqld4YIV+LNspcTjHxdo?=
 =?us-ascii?Q?pdzXN0Eokcx1QRspLnxC++r4Bk2H5m8ljxXctGrQPRP/S+7oMo1Jrmb7JCDL?=
 =?us-ascii?Q?mxuetoTELRiXK/PveQzYM0QNOj86JrR4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qeTkfZv7qtMk0OT5SZ7St7sTXfipMmE87IhnlnWhm9hEZkRGf1dAXMwqTLDF?=
 =?us-ascii?Q?ID77OebX2pC61mGoOoRvnfvKavcfQyTqIgah7dAgJqBO7IfafXr5ZrSPwMGX?=
 =?us-ascii?Q?f0JB5A9brs2zIIq7Ufx585y1AYeDPc+yK7F6aTB7orXg7olW+xxOqvgc8lhL?=
 =?us-ascii?Q?R8/0bxs+YpehliN+2LXMKmrtXbeaKguCea9qFRIXjMSDkpufNgJiSjZMV2Wd?=
 =?us-ascii?Q?ad+b1XSV68s4eWFcOLp2SMOgbyQE+zGPTd6eRobgGB39RbmMlM9EYD/irga0?=
 =?us-ascii?Q?7jC+mz558RRVX47ohxU+r318xPRyu7dpz0jKRHOnF6Vn1wdjwHlpw509xp32?=
 =?us-ascii?Q?Hkn7GYa4r0ftG/g4xYWOIClulEDsb3pOe6wTKokeehgzQkHd7Mq6d4okCuxj?=
 =?us-ascii?Q?/TYzxCuEwDlbJ2dKsxFSzmOx2Z4LfAk4IUuJSR1+//v2j/MdGsmyEU1ipRee?=
 =?us-ascii?Q?uXv3pP16AN8pakDjyl/hOo5oGXqszGAYM2ptaG/rQ4Ks+6WDN9ESduvqRNMo?=
 =?us-ascii?Q?u72JFoZh+pHZwA6dqOeO0PyrVHg42Ym1YdjhQI6F5iDtNdkC2z9Y+aSr61DT?=
 =?us-ascii?Q?abEBhlrnitFqPZjukdKyJRSnvn9eHXxfFvxhvKu3eMDZ/IQQHakWIu78zlyn?=
 =?us-ascii?Q?rA3u91+rVDSO5Fjyq6tDs0K0M692N5jbOjDiHYHlnlmOEa6QXe6u9mAFD+di?=
 =?us-ascii?Q?JWU3i02GubKPW71APxepE4wRRqcl/+teT8jt/RDO9xONGuj9SfocNOZcv9FJ?=
 =?us-ascii?Q?ouual+P3RWPytxtRHU8oSX4gJmEgNsyinDfLFzck2D7xlYShTRadnjW+4luX?=
 =?us-ascii?Q?SWZhJ13ihYsJVqCUzgR9nljTaLEtL9kNy4NMbZ9jAAbDy/JJGeUXzzx3bUBy?=
 =?us-ascii?Q?kluNCqROVdJ00rTUG7UBADWKbtf0ls2U3kvwEm6j06BsKbJy+3z9KIPkqNmp?=
 =?us-ascii?Q?3wl/U2O2ivIUtMS1LfulafmmK/B8+p0leobDUHcwV8XEOvZ2mMxsUYy+xvkJ?=
 =?us-ascii?Q?esqaT5zbKh3y2xju7k405C9YTybUyFWIP/tSSe2cfxdORqVnzaZvwC1Sv2AR?=
 =?us-ascii?Q?cPBoQOB7/CyAK8LszGVusMD2ZNTv2eu/yKtX5oxml6sDRM184Kdhv/BR//Ey?=
 =?us-ascii?Q?fDA4IDRFW+fCzM9Qq/l2dQ6iYNVWVMceJwvQroy9xXHH2JwhjBvsKBkARgef?=
 =?us-ascii?Q?qss+PuauwEesgPd17wsEitJ6xAtUUZQYH/yoRA9tY0Sch50L1TWQK4kFBCrb?=
 =?us-ascii?Q?igjcO65ZCpkJkH1GNtTt+e7GylTdPS2xelh5KkVvzp04LNj6A52LbfTK9HUc?=
 =?us-ascii?Q?/XL9tdweXWKnhfpeB7d/2XYThUBrsRXLkx5fEg5rChq9CMnhdBFvxcZ8nUoU?=
 =?us-ascii?Q?EZ2M3w1fxQj/wU4Fyi9TMAyjwTgMLGJvbTUbSruY+kXu9r/29mQ0sQcr2Tub?=
 =?us-ascii?Q?xQGYjNGounQaCRhZhNqzXvSWWRqTDLB/s5dLuvhBflC1yKS5acLf9vhTbLft?=
 =?us-ascii?Q?PDRTjpHhfYjYU2tb4oQ2W/GRVB8043ayX3sXzM6Ye6BU7kVNhfyuOXkk/U5u?=
 =?us-ascii?Q?yhyyaN5kTc3+K7atTsBco+t37+QjJcFMD1H0M6DT1AUXO/hVoW+RYtRnKm29?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cp2a1b86nYvc2jqkJDkbLdoYN7YVPk1jRKg5OdAQE8Kabq7IID1LT+IMygOob6oOZUVMSiQ8hgnj4WT4vtKa0pH4qsrMJE74G+/bBy9J3CWPmWVbrxXsSEaeIwrLdBY4mzqEQ+kmOlAU9MGE/2Xu+ZG3hDyB45tjnhaimODfbGK8WPO4GF6gdInJTbpWSgaqgkh3m+4F3E/6OQhKgDU/qTW5QnnLzwsLtpMCsc50n7GM7aPShLzup0ow/PHvAKtmJBGuGE+3lQ/up2BbLwZZa14aw4YhJJFyMaJoTxj9vgzlEJ1teenMfyhOQu7JxNTUEVXxV7SUx69fUM8oA3+FuDTTQz2pGKojR9Wmdhe5SkuSfa2GlpEXorA9oEGaigSJ4I8zMxBnUA5AZgpxJcbHuZS5lPPU4h6eRj/mOkXto8ANmokTEXt8/iXkWJPv9Ol1HQuW5Nk4EF6qGos16KaiBYmMKlpeRirIMF2p/gS9IryutGVQq0YwqADJiaXzLeeZIvanGiWYaWq//l67pa2OQsB84PJmdDXGo3wKnkRDoYStd6+1ol1EuUp6WFRJigKecqVC6MUpdUrhKNVlMxnInrN8PAurAfoGCt9R9lP24NE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec65848-1ec1-4568-d43e-08de27e4a5c7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 03:26:52.1628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6giXjXiX/o3BKCtqFf7PtihDs2g3Mmg7uBwnIkdjvF+G35F+G3CfP7bl+tVzF5PAEDwCGuv0E48KPe6kn20VvtSjpipJriw+PdCUVfF9cXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200016
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e8a80 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l-R4seiF2JktxmGwTHgA:9 cc=ntf
 awl=host:12098
X-Proofpoint-GUID: zr9TE1em_reeEq2GgA-BRVc5Zx0os8zO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXwGScektMK3NT
 TWoVcE6q8vOW4lxEiybyFKFLRYDVvAbqsS3YvXEssFH8KYhXhTTOhrpfH4Wg/sqMLSdpdHoQGr2
 HQL2uQgpZ5Kfg8l6UAGZx4mJNCaDfNDe1iBnHuZ8DTM7ffKSz5Gm3a78QDJTYvjmawyDNj4/40u
 9N0zGuHhGxCcbygY772Zhbxx1OCh8XNpj7BNf2oIkcaa7pHndA/5LvDDiNpGV8TYfWaAWAuYWJ4
 kekIwNDDfmWwsQ7+HbH/I+LxcS/ZSO3w4UEVdSItccaBcgzOzfLfbSuVMdM5S+Ym9GWP74fMSpa
 hJ+cnuz1GJQ5lYHFG6H8l6tW61Fg3prpxkrqIFoHmnFgdiUSqdOwDLEstDMhrzC8ULtqFALOdo/
 pEvnNYqswSHkZ6D4j7aenS/9+uiux+NFvtc096ly1U1CWZqXHdM=
X-Proofpoint-ORIG-GUID: zr9TE1em_reeEq2GgA-BRVc5Zx0os8zO


Lukas,

> The host->opt_sectors are by default 512 bytes aligned if we have 4KN
> SAS disk reporting zero or smaller opt_xfer_block than the
> host->opt_sectors we will end up with unaligned queue_limit->io_opt.

I am intrigued wrt. which controller returns a host->opt_sectors that
would trigger this misalignment. What is the actual value reported?

> +	lim.io_opt = rounddown(lim.logical_block_size,
> +			sdp->host->opt_sectors << SECTOR_SHIFT);

Those parameters would need to be reversed, I think. You want to round
down opt_sectors and not the logical_block_size.

-- 
Martin K. Petersen
