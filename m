Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722A320F067;
	Sat, 29 Nov 2025 20:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764446976; cv=fail; b=DLxgPZzN7FRJso6ptkt69G2L+U0fxHDCxCwQ7Ghu6GhHQTelq/3T99ZNUbUCm7r/FhxVf4Z4ZZssqJ25FizjWwmxpjiGIApuUTYcvurOiOnPPgdGpwWc84ipLqDfBmnR0VfbddKSaiNLRhTwDGB96QK31H6GJjuEKyFzIjsjMag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764446976; c=relaxed/simple;
	bh=ebP8mqTbnU4n/mCWGy3rK8QpyXt2ho0L0T/qi8401ow=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HaVHR8fn/+gj5xv85wPxO0ZArR1VxihsW6ch4nvr+s9e2bTL2kSdi4WMm6M5ASTGY5NZh1d0zXaqRFxDSLHfLk/93/8vvfMxaN/p8mRq0oN6FIABoIKUSHopnj45GrroJRebV/q15AiM58cdyfRr2Xc+vlk0k1RqeVvUXBawEwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IpoIOxS7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SfLeES6N; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IpoIOxS7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SfLeES6N"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATHp44N2001765;
	Sat, 29 Nov 2025 20:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=abP4pOazu2nmBW9hGV
	1gbEyonYrXi3rVfKHyROxN6X4=; b=IpoIOxS7M4pZAo7H2Ds3XFW1ViAkhdrfz5
	ZFhgjSX4FBRH3FnM82q5G+ilaWdDxJH9OZOUUcNNyR6foh48bttZVH3obOwZbsbv
	k4R5QrcgQUCN6l2W4K+sA6V2sUg8X+7zZQxAhCL3l409bOLodyh0ycF6sDrXRK/n
	LuxPTGyCGZrWMaSzBEbtWcpVxLsdtH7V3d7fNLwWhzM7Wx7Bg2zQBVhAD0q4NvQL
	0Oh+4Zr4Igk2j4SUPhEG71IjROUNGEyb3iSevuLPlDLDwqLhvC6PT9KTCjdRoX5V
	5IiXRxU8bWzoK+M5uVQgiQK8Ci1xM7dja6brHkQ6YYFdlyTrh6BQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqqdxgke8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:09:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATDaGST023603;
	Sat, 29 Nov 2025 20:09:31 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011022.outbound.protection.outlook.com [40.93.194.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9a7e31-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:09:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFHpYHNg/W91rqExT55CIAe1idfAp0KpmKFURzHzQbL3Axfm8Mdw1G3wPSs+LQ3SsK0nK6RV0IMdsvxxDjNSz2RViEGsYPicJtP9ACl5yWuZBXU5+XPkFhTdZYNfUY1PBRanRNqvMyOw2bkWirU/eBkuQUdYxLB4bdu4dPdkr0cN4Yp/oaIhNtkGrEuIhobq2UfYitCYJJtgkIFqJcOYSIAJluh54oxNNbNL7PJG0Hixhef2GgvnU+Z9Nhea+NTOT3K+8MwG+n4AaQfm95vhrzYY3g3AzG7Oi8nQHE04Jq2QDdG8trYuwwzwx83EVrnfV1NQ/7fYtOGxgp/6+2WLkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abP4pOazu2nmBW9hGV1gbEyonYrXi3rVfKHyROxN6X4=;
 b=swuXh8+rrZ8nODgXjPVDZDc31fPOyib9p13/CFFsqHBXiVmiin9zBVyUO5du7YoJOv4bBC4XaNn5ixFG1GZy1BP8SwRmRjhbCFL2gQFakO1/0ER2w989tKmmfFgwgofIBajlfejUFerqdmQzgH8do5FO+JUkkvPbzspBHaJUPwY07TUGsU3KdaPQ9lPhz83q8L4mpAOMSs73oW9OjAAyJrz3/Q7+s920cMJCfgjpaEn3EsX5sjC5/89YPEkwDvwlhVep5M9zQ5+/9hdFVdWnNZ6t35atwhMSlVhQFMpi6pjAZvPZyiCJlJi7SRvDKaOnRl1PVWKIQc21TnvRaYWCiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abP4pOazu2nmBW9hGV1gbEyonYrXi3rVfKHyROxN6X4=;
 b=SfLeES6Nzzoj518nABXUQO+fXGHyusmpj55NfOAyeGWZVuIUl3cTS3Qp29jUhs8uGOFixLPbCdsM8E5vGUn089ZLFKVennSnK9Bj5zgEZvGc1p2xivluxp3tqHYQHY2LnwIf3CCYxeup6eBTs1T2TgCBG2dy+RRTok3wCSNc1Yc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN2PR10MB4336.namprd10.prod.outlook.com (2603:10b6:208:15f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Sat, 29 Nov
 2025 20:09:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 20:09:28 +0000
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        stable@vger.kernel.org, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH]  mpi3mr: Prevent duplicate SAS/SATA device entries in
 channel 1
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251120071955.463475-1-suganath-prabu.subramani@broadcom.com>
	(Suganath Prabu S.'s message of "Thu, 20 Nov 2025 12:49:55 +0530")
Organization: Oracle Corporation
Message-ID: <yq17bv8zjmf.fsf@ca-mkp.ca.oracle.com>
References: <20251120071955.463475-1-suganath-prabu.subramani@broadcom.com>
Date: Sat, 29 Nov 2025 15:09:26 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0021.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN2PR10MB4336:EE_
X-MS-Office365-Filtering-Correlation-Id: e2437ddb-5b52-4a22-a26f-08de2f833322
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?DJRDsXng8sBjUYiacxEFnm2avs3pT2qf0m7jRWdtdjc7LyLG3BFSMQi3hqF9?=
 =?us-ascii?Q?BxAYCIcGAoZSybfIkq43wpsK7rpsuy6DcUinWsTYFdcEUHCEcpxHyYK0qYdx?=
 =?us-ascii?Q?oJDKpvwyBl113Dr2uD3kkVmoCbWUa3EzmlGVa60NHlgT25gMGZRoPbsVcCZr?=
 =?us-ascii?Q?VQIhReVoRaChOjistBLRtnLl0QlYUwsh2umwSLboIdGxTBcQzy/7b9ivKI4i?=
 =?us-ascii?Q?qdyjWlCRVE90Exhfep0RsYG6Wl59hEr5/eD0QuaKG0rFsYqpuMwzTvswNenx?=
 =?us-ascii?Q?ZwZ/ctlVhtO/it12IZT2YArqWBHmK9ou7WVOUkUiNKeFN+xZJNql2UvGl8lu?=
 =?us-ascii?Q?dxUd2J7sdjzo/SfhlvL2OHKOuij41ByYgOXoXRsaYFqTe7iOzT9XOWel4091?=
 =?us-ascii?Q?5V/mI3/3nxvRrea5sasATf6LHWDMf7jSZgC9hJVLlqx0VBTK5re2IC9wmMuV?=
 =?us-ascii?Q?NjaGMYyGgRKrf0Sw+4fLm3w8XwTijAfXfQWxQcE41vZ0iX/AhdwjC3bCl1+K?=
 =?us-ascii?Q?1p1kDku8ZrL700khhAqwB2G7UM3n8ukgedcIfGsjEWGjNk3ac14i1h63rohg?=
 =?us-ascii?Q?pfaNhGFAlDezbf8b1xOOh2CzNXmm/HzmVinXEiAgB7bENdSWv4hY/Zv17qCb?=
 =?us-ascii?Q?WEQ7C43WXgPHXdAfjJAeeibdQXe5M1e+1I9scpTgyOPHW793d23IcqSa/law?=
 =?us-ascii?Q?3OnIHd2hGREp2+0w2sBcGUrdN8Pnfc3hnWLgipcuym4G90/CPmk0Ds6kYKr+?=
 =?us-ascii?Q?yGmhay1VFavZwmHy5szQ9w92hulC57lHlWfwYed4zMEDbtpiL0HRBKuCnccN?=
 =?us-ascii?Q?5iG6GeQoX/B/fy50KBiHe82jRlEgHQG7ENifmzpqQ13yv7OoGGDlam401KOM?=
 =?us-ascii?Q?Twec0FueUttmgbtjKPBPC8nLtza3xH4DRfJg2784lcbtOwxQP8xVlIpKESkD?=
 =?us-ascii?Q?ubCIZ8qNuH09jtP4uATUM9ff64YV6A7hFw/hmMURvH75DVYrF66yBPLPAth4?=
 =?us-ascii?Q?Pbu4bIEksvKFwygt2vvSSghb00gYyKoG0Mnac9THTpgRe0m+Z0av1OnYjM0P?=
 =?us-ascii?Q?6RD5IW/WkiSRFtugQxnMV5DcgtD9x0BqVSvLg6TrRQI8Ej/4y2hEb0H9JKfZ?=
 =?us-ascii?Q?Okf4oRgG7qFTBzeXxi31rUSWG0ZT3F4PP0LkDTmaGZI+sQr75AwDqf6BRITI?=
 =?us-ascii?Q?ou4ORsz+RHUS23V4kEUqHTw9B0AJnSGNn3W/KE1viVlUKHWII2ZPOqvp6IIQ?=
 =?us-ascii?Q?jb64HK4Ci6/7uBzRMHPAUry5TGfd/RkMCtbZvDep8XFc7/ZEgPyI243UnmAU?=
 =?us-ascii?Q?rFCktvJ/QVxqvvlECKajrAcIfR5v0c+sbijEYWv9luTd3t4KQJmwQnIR4sbY?=
 =?us-ascii?Q?sMQ1OCuIR0sg+dhTURKLdxpVC+ar1AWgLyMk1Kjfwel3maMjj5pNRIOJSNYi?=
 =?us-ascii?Q?5l9a+PiQL2cJLnDzzFcX5CzEt4QJo1B3?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?wTnDOI4AyobobgqSUNu44YGdFuqMWSzZEAGSfo6H/Th7Xgl4Dy7KHzfet2+V?=
 =?us-ascii?Q?3AfWw5eRBHIceuPUqijOWo7zlZtUR0bmZJjJ6EvkugKH5e3MlYPUbW3jxPB5?=
 =?us-ascii?Q?knIK9I0xmkChQKPqhF2HN0nMcIkap/grS5J+A3zLlIfFc++RQprbMRq7vSef?=
 =?us-ascii?Q?wedegRyrtvCyZ87VPWqdnU7yUWvTTCBOmHHKOPeb26TEBEC8XJqa6snjF2x/?=
 =?us-ascii?Q?txgSI974ojbgb6Vm1HV2Hz/hBJ3D4Mi+GUXfUUpu0TZw34UZ9Oay5/+VI+sq?=
 =?us-ascii?Q?EOB2Pmtnn1RgRny8bZBk2gChNp6K+v4DSoz55if2BIputbrs79of/NS80Oja?=
 =?us-ascii?Q?s6IyzZ0ehX8sbuCgTI6cpC06SZYHJ7OV0GtOiw+VSPLLMoJqHuECVWytHvr3?=
 =?us-ascii?Q?95iCZQhDBgkdeOC4R5fuAuYxu8uhKaY/S0rjKb6iD94eSvDePzEutQ73Myj7?=
 =?us-ascii?Q?Dp6e1e4QSvu1qsATIThiRMJO5t+mROofhIg4qzPMWCGu57sJJQW0F96vtm/k?=
 =?us-ascii?Q?PIHEUZ9BSYFbt7z6as3HUCHVcDWwdJWm6gO2b9e+WZw/ZrV7D9m51Z2YSzTM?=
 =?us-ascii?Q?iTVFJe/t2Dscwz6GhuGAmyGG6qI5oeQjGpp1WFgbXzEZI+FOXrTY7zdVE48E?=
 =?us-ascii?Q?aA+Eay/7K4vZPqY0gm+zEvqdTXJM3h2KouHHc2v7Bj8vuMK58LMuWyBSZmDA?=
 =?us-ascii?Q?xuFtWhwftvCkCmdXM00xmnjMQ4/Rkb2WpAc93GnUH0gJHIxLEcN0vrq2wKdI?=
 =?us-ascii?Q?JA31kdzWFZS5yqzIGZpQTNdGm1SSVVCJhKkpF2MZ9fNA5rYiC4b38aLQuKn6?=
 =?us-ascii?Q?zip/sWzODME/DC73kFU2ZNT4zIQ3VLTrm+UfW/To0dcU6G/5pv2qJXarvZdh?=
 =?us-ascii?Q?rbX+zJ2+f+Ne8+qnEQg0BOpLeXpY+Tee1AjJ/WDRyby1O2ts7o9LdPebo+8Y?=
 =?us-ascii?Q?Tw6roqx2BLetBauJmGtx8EA5ARlKeFEDnl7lNJccZUlzy5PLFyxchdGdT/IW?=
 =?us-ascii?Q?zBfv7zPA3dxvOEVyYcl5iYeyVh7ZL35zo/xC4L/Jre8RHworClZrdY/ySDPf?=
 =?us-ascii?Q?3DSpGp+C3omJLXwg+8LmtU8Ut/g3LzTixcdTSqhZQe3BtBYRzLYR/Uq5q1jG?=
 =?us-ascii?Q?7pzkrCSlq3f9qRNW/RweuTGl5mkYgQ5xFJ0VB7ZwUtoeSA74hYn1l0O+M4hY?=
 =?us-ascii?Q?cIjHEpvMs1HZ4HrHrIEzta+G7CZjppWAVxI7eRp4Uqu8I5dT+lumJdVuPtFQ?=
 =?us-ascii?Q?KZihl4Q8n7sx1IxUst/+qpk5wT06CilLjyP6bSzqtfEgNvrD8ohV0TPlDqkc?=
 =?us-ascii?Q?7Ift/S61cySbSrOTG2F+N3wXKHCwyxWzI+4+nujiyZr9na02og0vUWColNSh?=
 =?us-ascii?Q?B9I70YHF2kzLPs+IrBDyh2LZlxf2D/S95LJ1d+xJDC7JeOg1UiegD7UMbsO5?=
 =?us-ascii?Q?7HP023udkpx+OeOBL++7j91Rcdw2x3Ux8ORDCf/14lNZoh1teeHoXuNTs6J5?=
 =?us-ascii?Q?w3mrm1KWmtka0Srnt/7WKAA9CMFyNg0LOqLURfT7Y+RjtpOY3Tu1kjkvBc13?=
 =?us-ascii?Q?N01WKorg1AHhqeie8zLdTWpnQPb6tGYBM74M0048qzgSVS1c4Qr06jNdUE0U?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J20fQ9xqmvcleuqhBIff9JzWPL54Mb7vaviefFa+9u7NE7wv08t5vLxX/IA6hEBmTO4vV7oNdGhXH5ACXywB2V5GNKSAjqzCGLUyPFuoIi+SBLerXOClMLBq4vSk7dQY0XfPi5QLIzEb3aztBk1yFnWHhysAdosQHNF7reVwOikEYsmJPbVSqBYUK6NrYyaiUgryeSPpH+aKarPHn/PTuUzphAUKgRycSgHa0YRD24wRPtGuX/kT7NjGFPAdt+H9mUf49f7FuhfnPzHa603YOWwjv+pHdmzpRW62U2sCoKvRaStiqs3MA3GaQs6Q3/XRVwdNhSPaHt41YoygxfCIYFj5VdsXIQjITHS7Df8xKKLs3qjphjxdwja0+ZafkRwv+ZUNyIUeHLGDdO/AIvmfXmIR4G9pbDb2YKy83ODuqdxWiBlRovfSwhDCMK/CpAtpFeD47nFq3u/8J1DnX36oLcyl46MrW+EuJm0hr2hBnyeMhuMFGMZf4sxq61YdFrXHxmJgoSDzxSwGVkdj9mxh5qWkfEMjtcel+D1XgZ1Wark+uu8aMfTAfkdUC0KdMlmtcBTxiMWZ3r3t/Y59fyd4nuJHJoAaVVmFOJGXwcCd7ww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2437ddb-5b52-4a22-a26f-08de2f833322
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 20:09:27.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5ikD8mJ+PSZ/CTSLekHJJUHKK+2VqE5+2kVnFBQ7Id7A3/3OsYS4qLNm/4FH+2XoSuV2iyn62Ojc3+js1eiQ603CqrYZI453SSaKCF3fos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4336
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=876 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290166
X-Proofpoint-ORIG-GUID: ojgsfViX1DlP1xK7tlO9eh2s67gz_R7B
X-Authority-Analysis: v=2.4 cv=H8HWAuYi c=1 sm=1 tr=0 ts=692b52fc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:12098
X-Proofpoint-GUID: ojgsfViX1DlP1xK7tlO9eh2s67gz_R7B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE2NiBTYWx0ZWRfX+PtGpfItOfj+
 9ueFwkUT2qj187odlEfT0CWDexfEO/Ch5p//TyRvMGLvNMP5NueXKXJoJSfhGNpFDfrYSg0MRRx
 uGqCqkZUcd0bjdC0UJM85Wg56p2NU0mZjrmoCh+laEHDziVKfV1NT68xHhHxXKTqthWV+7UiT0s
 cruruRHisAyrwRqqr5V8r/finPqB5QnJQGkL1oHTHezjoNYhMq9Bnd4eBddIwxc037AMic0xymI
 jx2VPWvRkoldTlc8PlrYtiQpPffjtMpmpgaJ0Octia3BuGOhxv3xUx/Ayo3jRbzBLdUn56BSjQi
 aYeMdVewfliporQrv25QT2bhaP4Or8pHOTP4wSIgJsYS61l0MYdzED6xK1+EWsJvyZyj40BOO0A
 ZNW3WBMD5Ry7nDgi9aMLH/ZdFA2cJJJKokBdeNHHXHbQqVkb6pc=


Suganath,

> This fix avoids scanning of SAS/SATA devices in channel 1 when SAS
> transport is enabled as the SAS/SATA devices are exposed through
> channel 0 when SAS transport is enabled.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
