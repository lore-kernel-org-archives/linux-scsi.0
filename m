Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6D48CFC
	for <linux-scsi@vger.kernel.org>; Sat,  8 Nov 2025 17:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762622536; cv=fail; b=fSTi9ese847Yw0trueIIYttqQYYq/GryQZKjA33m+jIQ5VA9jnW2D52pYQjX4Gst3nME67nPVeI59ZURd5N9LzjfzqCsPFSiDMqV8Y+SM7fVGkCXCkWxzHpAgrO2e1pRjsaIK6EdTKQcj06E7T/74Z12zj5Drs60SUOFKQzI4tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762622536; c=relaxed/simple;
	bh=vdeIez0lPd+XI33kl95VHvYjjOdhFh18ikH1P9Rb0jM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=anMps2Bhh1SgtvLQAo6mTzeUxFvtxW6dWAax1JOuL9hXedWT2csJ2jECFArwfPX3cUnbvBb44RN23DWTSTH82/Po3YTW9FdbQjtjCY4NibOmPxO2UZIaAWMNZxDTd0DQFG1lIH542e6VIMGnYbMPSAf0qTl5d0FD3QIPSKtHa+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y4+uco1K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P1Fn0FvS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y4+uco1K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P1Fn0FvS"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GjT5K017275;
	Sat, 8 Nov 2025 17:22:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Hy+ReGx+1le6nZ8zid
	MycQOR+bvtUnpeOiy4pGZx2Mk=; b=Y4+uco1KB49qHgUBY3CH8fw3+BC8I61e3Z
	K/mIXhszQJH70asaCvXe2YnF67BO0cEbOqLrao9vSeRRggwD7D9pt3LS8RsA4KU2
	WdFWsHpAJ/J2k8bnoVVy7NktdHo2NBKekjGTdUOYpZ69ZcaMF0oflwG77IY24sft
	+XKCdZkFkZ61hFBSESlaew8C5gZE80GeWXNDvLvoUGk96KSAv/z/uZ5yPyPMDhMD
	8aJ24kTz16Hw7XbTntNbaYRa9PGC6wSWz8T7l3D8VsAXMUf+PasZZDaorZi8ATNs
	QfZK4zM0nYq8s/xNRYuuXdB3BYJLsOZl+Eb87EudejW6Gj6q2lTw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa8se023c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:22:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8Ge45P010006;
	Sat, 8 Nov 2025 17:22:07 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vagetw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:22:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GRtQQR5MwiGuiwTYeTpYNkAcJ7ola4Nq/Cns8AGq1hir3PW2EDprTh2vjG0ZfCwbtpW+An/PO1dK14mM1R6q4nvI5g7T8Ald94URC6pdInYEQoD5nwOCnAp38tiphcWEfEBfbuQgYAec7RhqAl84dRzuyerfAQ11qV3R1iZjpHZplpbpgaUPnPJFJVyl9XZb2wV8wMtIwBZEkbGLi3IaCIAZEnqMhZl5wwaxWTdXiFPubGdhM80Rk+rzm07gVHyAFFEDVYk0slqTZVwOcoRYVhw3+57zQG9clF8sfRfazy4xFYuwL0HRKRtsp2uSm8rjlH75qjwNHLkSn34zSSoJOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hy+ReGx+1le6nZ8zidMycQOR+bvtUnpeOiy4pGZx2Mk=;
 b=DuTAMB0E8yOq2MCHfBawyc739fJe3H0Y0ilh9reQRkw+Gogjq4XRF1EQwwk9YZUVK1BlWz3khtAQnGOuedv0V8V2XtgdLWZrHWrJJ0oqTIWY0Ok1QwdPEbgTXuGsgzDWrA9izJ32Abv/CBmxfoVNcigqw+1X3JN4mvGWRWm6riIWnOhZunoR7l0ITKrNtk0MWPKdfsdysDUxFSuh0S2gqzhlTh/+6hrocvexNYXPobPOSWacj6qwhvXwIGknp3oTdZ/KH1+LuIzDUD4WAb9z6O2e+zVb5/Z/eH1rY/6d4ZNMrZwAEgXynO20WBquvQVQoC9iz9m4ptJM9xsbEYgCLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hy+ReGx+1le6nZ8zidMycQOR+bvtUnpeOiy4pGZx2Mk=;
 b=P1Fn0FvSQBee0UpdEUb9kDLW4YRnlsMe71CfTjxyu17PI57RcAsfVMsVCHs//Liu83KFNpIN7Ebg2aYScg//X+B6f0OxGjVcIxvO2u8kl/s7ItC7UejZyErZchVzYUpFbgnVwcbFLZMBRc90tfaz1X4QjqvyUOCe0SEhSCYf8IU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6126.namprd10.prod.outlook.com (2603:10b6:8:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.15; Sat, 8 Nov
 2025 17:22:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:22:03 +0000
To: David Jeffery <djeffery@redhat.com>
Cc: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 1/2] st: separate st-unique ioctl handling from scsi
 common ioctl  handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251104154709.6436-1-djeffery@redhat.com> (David Jeffery's
	message of "Tue, 4 Nov 2025 10:46:22 -0500")
Organization: Oracle Corporation
Message-ID: <yq1bjlcjv80.fsf@ca-mkp.ca.oracle.com>
References: <20251104154709.6436-1-djeffery@redhat.com>
Date: Sat, 08 Nov 2025 12:22:00 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0024.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::37) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: c820fa38-dcdf-465c-8066-08de1eeb5565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vEyLFrwIqj8wxxTqDWtCDtpdsBVdD4mdHzp4K2P8kMIPCKbagw37MmiLS2wb?=
 =?us-ascii?Q?i4noAHvo/NbuJDYoI7pw5WWFOFOHj0Tgi8QOCubhdLvoOM1V0rAlEDL0WH4i?=
 =?us-ascii?Q?fEN57hqi/sSX4NTN/8Xq/pVdk2NZ+0FTflRSgeZwtB6rLQmKtQFlwLvnKVP+?=
 =?us-ascii?Q?QzxYcuzddHScn0ChaoSi9c6TIj2Dk2tpx6yQuOXJTrQIrSk+A9qSkotvy3Is?=
 =?us-ascii?Q?gup6emrHHpR/3e0b9HXgsMMtUy0SFmTnV1mRvDUiCz2SU1yKIyNPsV7tYTzQ?=
 =?us-ascii?Q?J0/440g09j0WYDKOuRIC6B2HQiLE4YCjEKA46LYsa71zpJZGBs4sz0ksxgPN?=
 =?us-ascii?Q?w0ylI8CSviFpbwzytru/rp/uoOkRa7IUxok/d9kxFStwDcgXCL5VJD78Smgb?=
 =?us-ascii?Q?knr7oPvMbClTLN2mJykozHCfPK+dOR7ZOABEnubabmd4BElLUHCQo+Bpt5++?=
 =?us-ascii?Q?gbA9Dm/Jmp+YL7MX8XGK15D9m3qGwqCncPhL6nGebcRXe597uZnm/+ROmcIK?=
 =?us-ascii?Q?lCF4z3KZhXZx7z4msl4HOqpbF+4mzLQxt606DBRf9/ew5EfK5aRpjVI7T0Nw?=
 =?us-ascii?Q?CWLR0zyCnjvx8SHk7Nugs8oKeX5lkpHe8NFr6H3XqAIpVWdXG1BT8wOQIs0n?=
 =?us-ascii?Q?dNqeiw8p5iKOFhpGmtSOkrhhdS9jG9aArri3xFLmS+KFURaJROXPOstMgqny?=
 =?us-ascii?Q?M0HRwh9kz9TQHhfyWz1qqt19kQDmps1JvgKg6PbPdnVB37AkjF86tfh0X6NU?=
 =?us-ascii?Q?UVJP//xt+FqLfy4UdreAnRYh1BDrWWP75xv4RKWedSPYzxSym5djJYNLqtDH?=
 =?us-ascii?Q?ABn8CqAreYmYlW8uXqzZACilyvAPeJ4Ekq1sdKOIXV5zCeu2L7WPOE7d653M?=
 =?us-ascii?Q?emRaX5sFoPJZzt8evqaL0kBQjfYcelndcE4QhXOpR7k1+Ncqtt0FvmVypNIx?=
 =?us-ascii?Q?4VzkkRXE5IUIyzPPjAg615KvgaKlnJJQbntLxsfkZgYcbiWB/6YlZ9cAEIt3?=
 =?us-ascii?Q?J8I/682OkMpdjHj0InWiqdxnIBumK+MCivNl/lOOLO7GCGUHWweA8eL4iC2q?=
 =?us-ascii?Q?Yg/uJv/YkiYXYx4GaeUq6g0WwXaHYtMZ+whKf6BWlEPdQuDlo1FnkP+uMWRb?=
 =?us-ascii?Q?1+ZhFNAQD8JUE+MV46sDFoIU/+C3RoxgIj+CFy3uLQJVRYmBk6/OOWD8fRZ9?=
 =?us-ascii?Q?K0bnlWRlJM+/89Wc9IBktGXgk0LJFNYikQH/YLufMEDAk8j2RyVvugn/eqj+?=
 =?us-ascii?Q?vu72UrdGkXPGSXimWJq/TyJ5O1VTdqOrva+EAskg7wUW5O10i7KiJv1BDVA0?=
 =?us-ascii?Q?XIourOluWBRf3rbhCVdATNx1WOb8oxJnii2f0xDJtKRBTzjo/zV7aWwe0n2m?=
 =?us-ascii?Q?42cv/siTF0h+8pplkjruFGmEWC5xnvAWTyLizw1eb0+PKvaarwLNEvfFgrPd?=
 =?us-ascii?Q?9ZLE9P2AymeMUv/iQLEN+BLsXZwSe2AA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hzdq/uX+62VIaSTa6YWLhtOjja7gfS7m4nAS46ii2s+Zpca3r5QRRzc7WamE?=
 =?us-ascii?Q?7NQAZhUabuKadLk9NjFJXIdi1LyEYyK771qqihtz0N5Nxdqgl0SEhhZJBOHd?=
 =?us-ascii?Q?010+xj1IAyarNPdpv259Fmaa31crUsHQ9YVRiFPSxKUiADIj5O2DHnuj1hC0?=
 =?us-ascii?Q?VctLOTUtmaS0xLMJOfZnhIecvtXylg4iYFF29js9LzFbaFzsp3FsRG/nZLeR?=
 =?us-ascii?Q?zFXOg5thzi6lSGvGYEmlpXkBCCyHYDFKJTd5rf/UWZ0DzUhnQzeFrYXYK7T6?=
 =?us-ascii?Q?gXEwiDeMt4C0Flite+EvQ8tnGYDdcsj6LE8mn9ZFIXiCyIlzXkRQ/zGuWXx1?=
 =?us-ascii?Q?aRWFMxwhec4aZJH6Iht3qiKQG/bSUuW8z6h0KXOwmuYb6DgpCOv9RQkumCWF?=
 =?us-ascii?Q?l2SHJRv2ziNf1sLEGk1cGRNrrKYM7X0WbI/zUDGKkpFBuAi2MUKUYI2grzl1?=
 =?us-ascii?Q?K42XqjX3AlVsM8Jizsmc69gmbWmuVJjdSkuYzqp8YxD8XsgbT77i5AMFa8AM?=
 =?us-ascii?Q?Gha2hdavGBBIExBDh9h1ZghYb4Mt1lucysVohMfYp/pN/hYCmG/N0nGcfTCd?=
 =?us-ascii?Q?+OtHXAtSOVT9vsync0tdZE9WFQzJQVxn4n/nUuVFswDFm6RBYMcaQbJWDPbF?=
 =?us-ascii?Q?5btNUtbEmh2YzfUOCqosYnIvO/GwPdXgKsMgRRDC38t/3y0u6RB7LAInDa2j?=
 =?us-ascii?Q?iVyhGGQWFah5y42OfZwHpq021Mc1HnUgdU7FIx1jotpTcdVgOKLxpbqcq3Yq?=
 =?us-ascii?Q?e3UXxO+sE/aA61QTkYmeI1neTQ9qSnCHS3ivPxHwKvdXS5u4frDexIy7zEa+?=
 =?us-ascii?Q?5xjgdBv4+55SjTruXnOxfuTf+HzgwkxzpGW6Q7iOzYaqU7dGy7Gx56y5fGnX?=
 =?us-ascii?Q?kUUwu8ri9Djc1+LRSqS3vHRoGusBNJDM+3XaDtuGwx1Qe1jjm7njn7eCphCG?=
 =?us-ascii?Q?gZF3+iwdls3E01x8SmDBsCMBTLeayOMQiiZ02MIxv7gSufm7NForEgthHW9y?=
 =?us-ascii?Q?z0Fd5cEclrO0JvdKy6oz5RJ/oxpl1CnPN2wICDstLhNFvqgbZw8UYa5dLj+t?=
 =?us-ascii?Q?UZt1c85V29oJyUntMzOOsWMaTgbLbpafavTAItNrg3Zy9/rTfThAk27WCO1T?=
 =?us-ascii?Q?dIopPleGUHF1oPOy/gnMwfg5f7s6kd+4lHAGyk7WQ20TMHY4t9zfc4mCoFMV?=
 =?us-ascii?Q?A4y+lsyBZCd+ChJcOuMAD6Rw3wQrG8VT9bF4s2+NYmooX1D0Xn5s3ndepglP?=
 =?us-ascii?Q?YxLkxsLox+t2IaxZiOnZQ9iud8zwtFyGEeH1kYBmL416ZFboP0oD6qC0Tk/f?=
 =?us-ascii?Q?c7c+/NDSdArmHgEEO4yqxwecPjemICvXWKKeZnKPWJkQmAAr0geP5seETq0H?=
 =?us-ascii?Q?9d8r1KKAFJ0lCwmLwX29fValrxvTfUPZMdGvxECahgsYqE/Ro8i0ziYWzjgo?=
 =?us-ascii?Q?oi0s3pWImKYyE7fG7QlcqhegxpKm8ldV9avnrEeE0dvESmNfRiOdQHYKxZ8K?=
 =?us-ascii?Q?5MAmNE/qJSGjD7tJ+RTyf7v6AI+fPbQhxEXF+6H7BH5adHqISESN2qhcdedX?=
 =?us-ascii?Q?lN5bqaYJ1woo0gRirJQtILua6AsVR/RgFl9U0qJoa787qKr3AoD/vbNZcrdy?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8qlMEIsdAoX6VGhEFeQalNCwEEWtNr6JdpBHCFYXQqoCJ0McoyoQCYw86nv0zsTelBHmoZoRZiGP5XNGsxD/Qe6GNLikkul+Twbc5YJZaPKfdLQn7/YM6DfJupIjj0J7OemQ+SK3Re8dsBXH3dmmyZXkvfKTnzFSDzPTjaahjzbU0dw5xWCdyyUutln8p8PV91GEe659kFN5k0qFzthtrUssszN+zaK/haQqzGRGeVzbg99EEBghF8eS7t7JTa0c4rWTxx2TH+N8NZ8Gj2uuSdt1rGVMFiSVg4d++HAEJ1UkLfAjuySyR6ZbL5W2f1KKtCXQf6G+8dew6LAzTywz09kzkIhaTLIDdzXS7joVKkBTsJNpV/QD//1dBnsal3wjtOJ1HuZfhXqw+OhGj96Nx9xC/MZ53dGFuoQuynLhhfDz9wtKtPB5xqYeLH1Vn5SgbS5gy6sxfR1jM4I42WLPv8vDXmXzhJOEUPGBk+uSvSGw2SiYGFC89t9f5N5fYb+IZd9yemSQmtNiOJ/brLqZVTrH9nlKNcMbmu/WWHl8gCszn8RgkrsAsIkJIQw2fvGgSlNs6FIuUrhJSJJHC+8JFASicNLsaw3Ggho1E+3HABE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c820fa38-dcdf-465c-8066-08de1eeb5565
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:22:03.3243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIvxHpZ15TQPa8ybtDmz1IJ9d/wOed7A5QuEw0xDlSKn4uYpvf7mKKQAgLbEXvnR/3cU1c4q/coxcvLN165csVCVSezhKe0mCzbC3FCa7S4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=752 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080140
X-Proofpoint-GUID: ikvtYdAzYjhBfqgCBTHnhIhHjgvzCD-N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEyNiBTYWx0ZWRfX3lG5j5mUd2nF
 NG/KyFTI5vx3/tPIVLQTk5TuTLVyjNcnMZ6jrrG0jpPe8+DdChy325HgYOKFqzGgg0TjLZr+9CB
 2LtqB+h78l6LgneNgbrarzgi7X3aTLhLjx3Mz9kBBbOVA35nrZUvQxEfiDiea9VyRjyTBqnjqLm
 SiFGEwfRJT7wUi/uhii/2wjIqBn7eQmu1RA6AiO9ASuNnZK+MGpOYr+uylFJ+iLTOSGkCHn+gx3
 hcbJeSmA2yFLpiV5xy74H5PmmZv8HKGw1jtfcvdfY2UOyzcTMt2a1WCOeK7nm/tDNSMcVW7Udom
 1wiJEsDMSI2CsIY0Su2jI2KiPcSH5pSnpvn+SaqDySHtx4dYgSsMY+lz+XvX+yjszjGh2nPkNOX
 7ZMAFX2Y5iZiJvl0k85hG1FsAgbtDIm+YJKZFa1+klNsiu3usnI=
X-Authority-Analysis: v=2.4 cv=XuL3+FF9 c=1 sm=1 tr=0 ts=690f7c3f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:12097
X-Proofpoint-ORIG-GUID: ikvtYdAzYjhBfqgCBTHnhIhHjgvzCD-N


David,

> The st ioctl function currently interleaves code for handling various st
> specific ioctls with parts of code needed for handling ioctls common to
> all scsi devices. Separate out st's code for the common ioctls into a more
> manageable, separate function.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
