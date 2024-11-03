Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7527AD21;
	Sun,  3 Nov 2024 00:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730593109; cv=fail; b=aQhjCGG4Yg2Q9ArNOf1tzYs8ILgU+aMSZPCeqtwcZItjIytBM9wZJtCSHwuS82x0lLec4a6wwQn5oFoSU6PqkZ6JQi42MnFWQ+eeAkNTm/JFKYH78GjgcqTnlSKfZ2xkaCeUe/MNx27/Sf1dIn/YNk+qM9gm4vAs2vcLwyuZgBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730593109; c=relaxed/simple;
	bh=SNcOnLMcnEXeMov+2uHxOoHsBgAnmKBMPWdLOMmQdvc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eUOwWMCRCYPh2DD8G9owXzucjZB9rGa2vAuoidFTU7K9ienu0YiOJeyLeYiRbL1M2h1Ai+6dzUfEzpxePcFqQhS9MH6tOCjRz2tfao1JXLf7lxD1v6xQAGn78PCQ6GBf9mieJRrkZflAODYhsfHdzTjXRlLD84UHS4ptHyJRtHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O95BhEPl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wFXEtl2M; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O95BhEPl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wFXEtl2M"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2NxlwG015094;
	Sun, 3 Nov 2024 00:18:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=uRb3MgqkqK324G7dx1
	0hJ1quJXEl8t2ikb+Kk0wd+5Q=; b=O95BhEPlDugNgqc3+sK8am9mUAOge+cF9b
	bt6Wu8kqXycRB6ngpxHIjk1pXceJfeF1cm7J/WWvWnPIyvjfuQMbR/z9L4mNL69P
	moG5ucAqDPQABZ+6pivYEgMi/26qS3gDgZt7zXyVu5gtF+kjKyfua8pP+AaWO5/z
	6h66qq/NTZUYXPEQh8nptdIRSxihNK8UDLhNc16vzSizZfpydxv+ftbRSyT/6Uck
	uEcQfgtndMxDSaULX3R2P+PzuDMMdtIeSvbJRyVIhOlHgsV+6b/SMIbku2yxoWcy
	Np7pjWFmggu7RHd8BS2H8mMWvc4e4QpHHbOquR08qdBLtsGPE44g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42ncmt0n69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:18:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2IGASZ009100;
	Sun, 3 Nov 2024 00:18:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahashss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:18:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bccPZw0ijG3b0BRxFnkuz3MrOdn4IQClgayChCW2vo2Ykl2bEKYDApeplnrG0YiWhXH5CLAoCxFpwh814FnY06skoZQT0WIGoaWZn1vLiqf8viumkqWEggFhvF0WSavYBI0U0YY2au/JFoY4azhNX/Iq/co2mTMuna3OJePJ2YhvWbWFN5WH4wNii9Nfo3KAKRFMNkZFjYcTsKJm+n2yX0YYYuGlFgOSm26Kuj8ZAfylj0eySMlx6f/mcoFx5+Z3XEad8k95ZMAzLXdeHj4hGi3htKORBvf9/0oid0aG9IpTMK749p8aIlX5nIiFLcvd/AAzfzrAci7jfEfyZFxpjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRb3MgqkqK324G7dx10hJ1quJXEl8t2ikb+Kk0wd+5Q=;
 b=QnyEKJSX3wRpGfDDUW7IRQvEAGeMFJvTEKr5Bf6pGPkhK+f1Yb4Uj2c5WcNEU8G4bIFw59nbz9WPBwl7RisLV7Xao5PwcdJjYShPHsnehoaBrjFKL7hRZhkvwIBAi2H31lTJ5+WoGVbqTLX32DkJoSE2uGWZyVQ0EDYj8fv2Gra85tiuVgaanOi+8pC4b8sWvAZ02FnUwboIqedvUBZ44sy4/NfgTO9UF/h61fii4co55EDN0tzpyXAQ1ImuLF/JbUrAcogtsz0QBjtf68ATyLDNx76e3nTkSFEbf54aKlERwILi2FUeFvQaC2MlS5+Q+zOVPfWDxaf9V77866g5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRb3MgqkqK324G7dx10hJ1quJXEl8t2ikb+Kk0wd+5Q=;
 b=wFXEtl2MSONvAlwce8BvJZZoDVZpb8B2qgsemv3CKod3ml/ptiXuPcR0TVuL3XYh3IARsyJ4csKrCG87klowoeoVFyiuANJXIZI+2+fwmovFjDeQYUgjk9l2k0CUJsqdDUU5ciQzClxBVo/LqvGt9XMfgYbuSJdzj6d6V2gLm3o=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SJ0PR10MB4797.namprd10.prod.outlook.com (2603:10b6:a03:2d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Sun, 3 Nov
 2024 00:18:19 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 00:18:12 +0000
To: TJ Adams <tadamsjr@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm8001: Initialize devices in pm8001_alloc_dev()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241021201828.1378858-1-tadamsjr@google.com> (TJ Adams's
	message of "Mon, 21 Oct 2024 13:18:28 -0700")
Organization: Oracle Corporation
Message-ID: <yq1v7x5891p.fsf@ca-mkp.ca.oracle.com>
References: <20241021201828.1378858-1-tadamsjr@google.com>
Date: Sat, 02 Nov 2024 20:18:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::31) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SJ0PR10MB4797:EE_
X-MS-Office365-Filtering-Correlation-Id: c9038145-021e-4495-1edc-08dcfb9d0109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+szhuryRoIEp9D3axnft6IP9IukS2aXvXtekp6PEX/UcLB09Vtfp0XJEnyu5?=
 =?us-ascii?Q?3apmkYICvAr+NXUkQptkZPhldoJ7YIwffgMQnPGVHXdp+tLexzozcy0W8f5i?=
 =?us-ascii?Q?qruu177830SGJHWRi+wgkzaoozgVOa9JT0d85FlkdLEjbpB2wWazJW+pnAdz?=
 =?us-ascii?Q?yYvXTgfSJF1Ppj4y5wpNuNuas+E/P62XPV+Z1u5RDwoZxpUeeNWpZisDcZb3?=
 =?us-ascii?Q?OITvwBYtR+U2FnhsnZnNl/QQe6XRCXVv0PSFyyLjnZvF5heRNbb1FfF/Ce3a?=
 =?us-ascii?Q?81kTORs92Shb3UKHLAX+OvkBr3JrrxDvOxwPmPEOARi39CLA8MiGp8KXVmjA?=
 =?us-ascii?Q?IQBJrMs2fgH5rj2GKeVquzXEXlUdgzCfdRIdmKZpbQ7dLJP8QiHk2N2DnEdv?=
 =?us-ascii?Q?44+kMe4kYBJL14J2/pzg0+N36QSTix2LI76HqkbO21jGVJ7YdrNAysWdZ8Rz?=
 =?us-ascii?Q?1O6cKBPe5F592xGW2GxwbERIHCkHL6MoXSyxgV8+ZrFoO/A4QfVtxFZDQh+k?=
 =?us-ascii?Q?NThx/g0X1k4S8ghA61xTwsgR3hNlFbro3arGA3uKeJf5S0ALPodu8kfLPMKC?=
 =?us-ascii?Q?iyJ1mU2cJIaXMZzNCwKTcd2msbRHuJzwWA1Rc3zepVHbjM+SSejAKuerQWdl?=
 =?us-ascii?Q?pgEYgW1Y+lHBysUtMK89U8bYe6pwUf7DAQK7YTk6CoiFCn+iNx7ls+W9mO81?=
 =?us-ascii?Q?sTNhrsn89q7+E29VQXWP0jI+sPU5xeoq9y1B5w+MyFBvXu354+TYdKVydnpu?=
 =?us-ascii?Q?EPECiY+visPkMF/JFZJKKviCwRnk7SrnR8pEwXOda8AMcAYYisnOqBJ2jaKw?=
 =?us-ascii?Q?q1rgUmcoqViNgfyQp2Eg0PNa8/dqnxEZJFByG/zAjenp4yi46/v4xn03zHXy?=
 =?us-ascii?Q?m52RkuauQPsfYsxydZ5pqf9oiCwvjyXFcQ2cedBs50NuSnTxQHcKE34ppiGI?=
 =?us-ascii?Q?N8aExUmRVnkITIggToG7Fn2oI8Fg7e/KyNRPoJYpaAw61+MB0WdwOlqI5oZI?=
 =?us-ascii?Q?OGAZJS3bxnmKXDrKaZQ++AwriC4szDsatMKES+eOUk/DmKtihqJ9vbCojMHw?=
 =?us-ascii?Q?CZfCJHuHH8MXTmBXgB4beElpfEMXuwx47bhUTfH5fha6nn7K+KVPPOtDbhyg?=
 =?us-ascii?Q?2JwLDAc4nYVOxxJg8qji0DQfWAbZj5PITpBFK88A0oGI+08lyTUn1nwpwv0k?=
 =?us-ascii?Q?NddtGJJWQGodfdfI0QgTtt+GULgROBl68AHSSbvZQXWN4j2XADn48ogYHEIF?=
 =?us-ascii?Q?EkWM9STXiK2wAluW2pFlZY1Q2S1cx8a/z36NMhgnOHzcYJzmwzNNKu2Vb8r8?=
 =?us-ascii?Q?eUHUxqIM0WeQMeLiGAhV2psi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/Jb1WRQ4V448LljELQYWXK9PFTR67uAHQ3bB8J7LMUXdwnW4k8P1UFftqthe?=
 =?us-ascii?Q?ORkXipfen/mKLYOMLDYPz7pPkoqlfntMFC+4eKr0MH5GWNWx4K15l6rgzHxB?=
 =?us-ascii?Q?erCdtvNIeHd55UZypbCFYs14i5d/7E2VSqxB1KlN6+JhPwzN86wFSSdDd6tG?=
 =?us-ascii?Q?trOGx8PaUE4UVEHb+2KD0NZ/WNjUoXTw+371iRpOC4t6GoERGujmv4mnQ4CP?=
 =?us-ascii?Q?76RNurEVjPg9Z86aPzNbnAO73XfiX0W4vFUHQbgPylsoonnBPZm0nkJFtWum?=
 =?us-ascii?Q?wMo565gpw3utGxwEL4QnoigBITx8rKSBvGJP7c2GxlqgTNzull4DOTnqHc8z?=
 =?us-ascii?Q?ClrhM5sxoLjxGSTLSFGxsNHLLpQzki9IflEIPmYgGZq183412mF5aZcU126s?=
 =?us-ascii?Q?UP/vCxNeH9YFZkcvriHFKhG63wkZ98kkviwtVKRDYNcW8BTsQVf4x3DA+xaq?=
 =?us-ascii?Q?ySIXkXbifB38XHPiWSO8pc/bcxVZ3b/pxWb2YUV/z7LUFGdIT2X3pcnjWtp5?=
 =?us-ascii?Q?ofSIbMwLUNtcTnLAzyS6n0t0vtjzUaEHwhn718gllOjquL1hz/RL4r5F8s/V?=
 =?us-ascii?Q?qGOwKfBXQBsr4r8CUrfjyKQEe//xKkM/w/XR2qMKAqNMzqVDMa+jwaQEH7gP?=
 =?us-ascii?Q?dw1KEqGEVQJ3TrFFmSXM7H4Y4dt0KUJnbeIdJc+XD054KE7VDkQtaqH5u4Ai?=
 =?us-ascii?Q?JQOnJghjrz5oOdobR44VtnzJuTQPlbPQoiJor5zn3att2edo+05q+TUs5s2y?=
 =?us-ascii?Q?7FYLQ4phpNqjUqArFnhH8CcuEIjyzAKgFYUr2cS+2IRGzP+ZKzxRwkJrJirT?=
 =?us-ascii?Q?x3kL7UHtqWlpa+ssWzV8R5sIAoGXj4HfL7U7FKpdZNYzICW+vrBR1s6i8/9z?=
 =?us-ascii?Q?2d2iiKVtH7tEYIyes7qoZkX6/MbwfhJYHKvHuWu5wEqvqPOkAA+lyKc+51nT?=
 =?us-ascii?Q?Ut/uK2vnjyiE3x+1beWWCCKNVeKWn/u2QNIuhTxCyWweSYJxpvL298CIrOgk?=
 =?us-ascii?Q?P128nUDerl17s7OPmfXevuxARkF1yoHdGOL+OlpotmTmYuHSqpwSg8mvqyHZ?=
 =?us-ascii?Q?kx0R3rXG2JhI+KjfVKGvhGRkbl5hmm8+Qq12b1cvD/sSvPuYcTz8kI5PE4WW?=
 =?us-ascii?Q?1XmZxJ3yyxMRgXlnFLVEYBp/+RPOKnVnU8SqEZeav+nYXquWGJvMpk1k6zAi?=
 =?us-ascii?Q?a5QWDTEShTiDUUUrty6QcbT1Vdev2rGcoT7DnRe0f1bZorUmyuIBXnTjewlv?=
 =?us-ascii?Q?LtvF7O77zqwjrHUZ0hcwc+YDHRze4HL/Zop7iOIW3/Gw951wDeUn4UbcTXk8?=
 =?us-ascii?Q?4w5VBsdZIY6QZjbW2c0l5URfrF5ahkZtU/KCXyO1w/JHRzY3Cx/q+k1Pt4Wo?=
 =?us-ascii?Q?iE7z7RzGUisNglCkSvbMq23Oxgr9SzBHskpGtQbFVFSmC7z/06OOikaFKa3u?=
 =?us-ascii?Q?pKWyM00UqvSMSRHSWJIrsW+WBPx9ysfCaSslRXRJECW1zJUNEASvdJUkSuaa?=
 =?us-ascii?Q?zxBf0Q8ya5kwosbbSinq5BQtOgaLso6q+ILXo1SW2uO4hnLVyy/VapCz1FYD?=
 =?us-ascii?Q?lXyGVQa1tYxqteOE6/7vxLykx7IHs2mAKDCRkMTBmhY9mCQ12dm3q5c4edie?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KyNOXGRFsBRSzWrkVPwYsQjL88heNsNsqizMU0urw+XM9ySvfG8RDMgYZSTq3R68bcWhRxdYDBPelVbNiXFtaPxbcGwM/hzJthzpxf2+IZfg7AlrnG1UEX2lOtTqCoeKCdWhKd9SjE7yqb99rB6kO43+qCFKOnTv75P09KFuQFoBW83tqK1oOl+PQ7rxOt2ixEsBJFQB8eDc2uHqvpXMqkcSXV7TQpfCrl/d+Pnz2e3ySF1+kjaya7VtKeoq+iUS31I/yNNEe/gyyvGHypt65C9+D3CE7bdm1pD3FzyUWJop94MX0vJStKgQixM583KjyOnPS+UWJYN3Qhn9kE21B3+VeSThgvE6Tl9OAH3rDZM+4eXWGgyvST5UvYWt9MBaLmta6Ipi/u0ZYp45TKiuyJ7erX3mJfDNZEkrt8GPRbG3gzgCUHmWJbPxw5kotb79fETKFSugvKm+6BOREr+vXph4b2xckrbfhuc6o10gHVZGa8a6t7bQ1wi6+Wqv6YRf5uMaoRIvmItpzQ95JVry8nfkRTeAZUjXUwKKCaawZSkMHNdh1OztHbgZqT1F9BuubOxbQH3TNIA0rt54SeQR508mtmbGNa/sEp8I0hryZvc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9038145-021e-4495-1edc-08dcfb9d0109
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 00:18:12.7304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35ywX+TuRG6rVHDXdlrRjIBdPd82tEVYqwyv/tq0r1r0S7sHWoIdVjAzIWRrXU5VTvg7aDOcqrSi3TUC2UxvDMzS3X3UNf9yvdeRGWH5uMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_22,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=868 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411030000
X-Proofpoint-GUID: mus7PanPo2aOVGTZC1RbPrasoJQyDgq6
X-Proofpoint-ORIG-GUID: mus7PanPo2aOVGTZC1RbPrasoJQyDgq6


TJ,

> Devices can be allocated and freed at runtime. For example during a
> soft reset all devices are freed and reallocated upon discovery.
>
> Currently driver fully initializes devices once in pm8001_alloc().
> This commit allows initialization steps to happen during runtime,
> avoiding any leftover states from the device being freed.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
