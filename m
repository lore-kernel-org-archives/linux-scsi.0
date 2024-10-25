Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658B4524F
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 20:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729886456; cv=fail; b=lh0AtzZeu2uiQu4p3j4kbSxE8y+VSXm68G57hUjLzUEJk9Igp8ZWXBYX4GTFTDym+ZBL0ge0+2BwfYogNOCBcbPefYP0bVJHqeZVa92lq4K0p7BsCxXvkgMbWwTjLbajVbLxC6Dm8FdyyV7YCyxt08QtvPbitQ/peztPLeqOhco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729886456; c=relaxed/simple;
	bh=JaPbQGZe51PtzT2ONiZ+LDdS4fecLWrYT6BqoBEI/tE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Jf3azdShwADkfzVqYSusJBQlvM1IrqNZnIsBIM1wjpThzdrXM+7rvYoOin2svkI4QFdlqCzuLn9X0MlGq0HdJZNvulensf6fR3HT3Ap6HPAR56tLYJQbOCmBj13cZiVBJ3IeotDZivMEqBCpnanm62T5LOGa5fDhpFiiMGCgiM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z3VsXpoR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JFJ2dHGc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z3VsXpoR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JFJ2dHGc"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PJdUHS007220;
	Fri, 25 Oct 2024 20:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=k0xUlobcxwHzVjGKM4
	Yiv54GcvMuq6DxUKN6SmqyGgs=; b=Z3VsXpoRO9Ql6rc0ttFwZ1gymkHz8PpCIJ
	5tzAWwc4x/FUNV8ZxhajqHy9ZQX4rJ/asNbUos2nVDQCJBjyhtXnEOXJ8/6rC4RX
	H5b/dajdmiWRROJIvbMwgusNCyThlXjLmu9y7uZAI2nApHqiTRhQY9EqfQe8AvIq
	cL0W9GSIXpFF1+wSoPZq/HdF0lVSMW4wvvszZORnviVP8F2YE+n0wuHAcx+bdSmi
	TDzCE9KQzfn8WpaQvyMhK1CRdernh4XS7TYCXc5O/0+r2lH6fFhfZz3vGsS/IYiE
	2ouRnVSq1ULp1tvtRWXkwrOSPQRwV45Hogb9Senf3w5RoY0aA+1Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c53uwt19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 20:00:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PJaYu4039277;
	Fri, 25 Oct 2024 20:00:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42emh66cye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 20:00:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ukj9h3F0lwylikmu77sleI28cN0T9Zmxjp62Htcdgq4p6hBMa4lIsJpJzGcsB864pKin8hlckNVvkPAUPDOS54KQyoRqbQj5epDZXPa2G13Ii95PDS6EMkpD320YwYB08oxVXX9knXrhuVFzD6SeLcABn4VOS4O/pcWrkWKIThbWDsVjg1IBOKV1ciLa4tv5WclgjFHyxV+9K+8HpceTsiNDc/+7QHpCLLrbGwNss1OLiB1RrGDs/I7ZOueqlpGtkYdOJYDPRuaeKnIuggLPXWRfgquYUTcV4GbTGrE5h3U57J8pGGb2wGJ+P14O80v0WY4hbCrC+5T/Tj9wdcUYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0xUlobcxwHzVjGKM4Yiv54GcvMuq6DxUKN6SmqyGgs=;
 b=BHf8It9OML2MlWtIfsveu5wnCW38bV6LcOTOq2D9f14rx4d5HSlU277w9h337PaAMAyMVxQfluqjDeg+14in0mdO74yoS56/L4RyYRQSQ0Hdc/ZfrsmkE+Z6+RrRQ0VeasOyP/shHbgv78o0hLP6EjCOguD8BrlGyd2DsQqVySIp1RNn4KyuB/a9hFWmPAWKM1ONhRUqj01215RtukPBa+A/HdCXdJjSST/M1K+waeteypHkUKBVSN9xvqcUAfvCKz89DMIEDwFFIHSmJMv83X4+MpXGNIGXtRKRnFjqbMQHwg+9nt5s3NUjzyKsxKJi/mTqMi5ggHZzmfWC2uOugg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0xUlobcxwHzVjGKM4Yiv54GcvMuq6DxUKN6SmqyGgs=;
 b=JFJ2dHGctJviRNHHicKCsyn00IuDnmmxpnuG9SdP57ExREYbpD/++J5m/panAnmXZCF/849Bxof5ictGduD3FFyKg2H4M6orwb/Ivpme+f1jtBJebvjzNyQGpv6nFewUJCxxG7oFsnxkyn0WQVo1CkbF2iYLnHUKSbr054rrrCw=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by LV3PR10MB7964.namprd10.prod.outlook.com (2603:10b6:408:215::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Fri, 25 Oct
 2024 20:00:47 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8069.018; Fri, 25 Oct 2024
 20:00:47 +0000
To: Magnus Lindholm <linmag7@gmail.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
	(Magnus Lindholm's message of "Sat, 19 Oct 2024 19:37:08 +0200")
Organization: Oracle Corporation
Message-ID: <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com>
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
Date: Fri, 25 Oct 2024 16:00:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:408:ec::21) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|LV3PR10MB7964:EE_
X-MS-Office365-Filtering-Correlation-Id: 34ee229e-1166-4f6e-26d0-08dcf52fb76a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PWNNSj49JC0RPH3iyPuPrY1JVcRiemwF8qI5CDum/MKTF+SgCKV+ib6CJGMl?=
 =?us-ascii?Q?DEtS0K/IsYLMHWOE9U5yan1/9wsgXkHwuOkTdqfYWqBb4L7N8unIlduE9WTx?=
 =?us-ascii?Q?LSyjntqyuEthVMg6R8W4vgpu2AUMIPC6VkJi89ugRbEh1Fb7SP8fo2wRtKt/?=
 =?us-ascii?Q?hxc48fWDaP83jmIXfbf7nLVPF8pD4Om90DL/09sfa+efisav/LTebUDGOCiX?=
 =?us-ascii?Q?i6XLbytMZOVxUDuavUOMWB6zC42IDDHRz92I+Ayf+LZQFApotohCd321Odds?=
 =?us-ascii?Q?JdKfpRDLkR3NUsva6jTqQMdt9hznrmNd3i2x89ntvJpuEbKQAgyur+beYMP1?=
 =?us-ascii?Q?7Y4TpAw3YD1cKNm1knfmF59uq2jJeJ5FSysCFPlqw/HLGzaJJHH25WbKCTVB?=
 =?us-ascii?Q?VefCqP/OUajDTrabRhgyppIGGjwk36KVadjRZcRGMmyTlt3flAWigyQEj0vf?=
 =?us-ascii?Q?AisgJbROjFq5Dezf8TSx9uNrRIZassblwjgw7zKLFF24I5rm0TAXP/pQqkaR?=
 =?us-ascii?Q?M0NkKAkH+aeAgtftwnk7iTcL/m0HSXMqO8ApQR3G5HH+FHGxWQI58gD8nCpD?=
 =?us-ascii?Q?bsWXJx8D4JL4y5FFGJzM6X2N+xbeSol5FWHSBZkZBhpPWq4eKpqSG/jDiNTj?=
 =?us-ascii?Q?6o78d3ifIUcItj8MnqMM32KMv8JLswbzvONfakjnDXH9K1i4tp/8comAUtO0?=
 =?us-ascii?Q?nSsb7ytDYt+tPd+sWaFo4BoE+i9jtVPZ4/lHD5vHYdfYbygcLL48nAJ2FhNX?=
 =?us-ascii?Q?RbDFS+OWaBpscsrYUj3ITXQSmK0ffG3M9VHKdXbUy6wWiPt2PIyaIm+Tu7A+?=
 =?us-ascii?Q?IJJFqFAjKpXcW/1PVfH2ttQEu4bnwBI6+7Q2w+D3kJittGpfqeag/01e3FUJ?=
 =?us-ascii?Q?ImIOMcN0exI58Y10fFCa6/tbizGrKjYiYmfEgn1ZMZ9Nmwk4fox4KRRQF35Y?=
 =?us-ascii?Q?ihExcMGz1WudbcTGx3vIjTrb6T09MrYUMy+HEOHfZbmT2f0TDQkiitvj/K6o?=
 =?us-ascii?Q?Fs6SkCa1hKkOjvTNcuC6uf5nbx1N7mqh5ZQVrvmqCRkhPbXlbz8iqtBbN1j7?=
 =?us-ascii?Q?JZ//WcoOmVClW8/vKC/++MqF7aUcvMMyU9+jTrFZ2U6Im/ne7SxwZ5c/gU9E?=
 =?us-ascii?Q?qsKSedvPutVYoNN1KAuODLvCWHtpp5yy3WsMRBvqLbjciOatJVOGuWC4VJWk?=
 =?us-ascii?Q?+oXERAvOjbQ0jvY3p9zifFDXXWsp2R7aIdm5t08ogm894iONdtYlaqoTHlTX?=
 =?us-ascii?Q?X0gimEynKT3wO9lQX2hD1uBdaL3Gb8tksA3FRhg4X57m7LVHWc0YH5vPx8XM?=
 =?us-ascii?Q?bKXurj3LxrL9clf2YCHRGQSq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z7FjCNdpK9tXP9GChDxCFprLreJ4ZM2GY7PeCnlLt3dxFdg9gYu+5QmKvA8o?=
 =?us-ascii?Q?4OL5kr44VSV/SssjPZmx8EAaKBOmkjmC1KMKlfxaN3D9sTwKMGfCel3h9W/p?=
 =?us-ascii?Q?dqJMaCZsjC/8fscR0ANJioA8XfRLDMV4xnzmslS5HbQmAQ6eoFU37IBtEFJS?=
 =?us-ascii?Q?yLJnGGgYKqdqGzari7CVtobn3NtrnQwx88dvm1mruTlXHtYIcXZaknywtl/i?=
 =?us-ascii?Q?2v6znB/3cIrMiHK/gd+CWAHyN3OwOg720sYw/8DziqeQyz/FPsnzjikOLBDn?=
 =?us-ascii?Q?d9jsrNt4nrUUFlXaf48OXTcC+qqPitM8q/7cL9FsilKpF2rP8iDRU0S0xDU7?=
 =?us-ascii?Q?kcLCnfJgBhjjBSqBuLgwfXe0Yey/GINDyQigRTZ2W2rbD5jVSZqVZvChIA42?=
 =?us-ascii?Q?8LyFXrQy40dmfLaqRMvv1Lj5EfzxHBpeooaXwBMMkj93QO+HBc7Jj17bjQ+N?=
 =?us-ascii?Q?kkTS5YeTPas3muoVyXHysmczAi3KwsVjMEMNblri9c5iATIDFTSEYYw7Oo3y?=
 =?us-ascii?Q?zxhvqMm0SGQj8T/cfOFYkPeqvhS5J8kNFLe9uJgRY8NSsD9Qw5QwANV97m/l?=
 =?us-ascii?Q?01YThXLsV9jKTEMKZk/cbB/L+/bayBczZW3dKS4faLnP2D8un/Y6zQfmKHLi?=
 =?us-ascii?Q?+BctoRqiGlwgVEsVLbGASrsqhCdxXhA1GmsbRN5N4g/8KIvFiIfRv6c/ThdW?=
 =?us-ascii?Q?OzJAlavvV9flsx99wt+QcZ8a9/8arLpAaNy2yrbUxbh6uqVoFwtJjPkbphad?=
 =?us-ascii?Q?DHlfpicCfWSeIZA9DplH3js9m9/KPRNsDmGiZll/k0jURNjm7q8lrqze17i8?=
 =?us-ascii?Q?BBBQ2r8wJMpJs7uOdXgvXOmL4W/rUdMSem+hejEJMX1LP1Rexee94p9Xesut?=
 =?us-ascii?Q?Vqmj0bV3qEHDTLdWanOzGb4QznNnPBw1RZ4L1/XhnGZefYVcgCfQbHZFjDVE?=
 =?us-ascii?Q?49F6VMIh9UumVwDLvsuA1rwgcfW92QHNWrA3mP1ATI2NaonyoEKOxkyBNcJG?=
 =?us-ascii?Q?JklcgXVj0MQYuTe0ZXY3sMDQVR8QJwNpeIPxePbcGIx8FXXCxw6ikI9S/mUc?=
 =?us-ascii?Q?0KGzTKLNtWclO8ufa+oJ/GMZfhp1DmqFVNASym9hPAkeshNempK5wmh7HnRP?=
 =?us-ascii?Q?Dv50xo8wdfq1z4OV/+WQ67NrfjVoymjeHr1Trlp5P3zNjIjDI37DGx7ssSxH?=
 =?us-ascii?Q?LAjBJye3ED0yYApWck9v4AYEKRAc/oUM1SOihBN18rWbJtROMRa6EkOrHkHF?=
 =?us-ascii?Q?OvIDX2r+uvWe/CpZ0L6fefm7ECYvRibbTvOI1OCjQICkzn4nWEzW6rpIBXUy?=
 =?us-ascii?Q?sHMLFgjAgp5xekK/p7ECR243aEaGpkkuHWFxCaxre1VE4EKtDsqWdq4tmwHM?=
 =?us-ascii?Q?qRej7b7j4gXmhJ6KTtfHkieRaH6J7d8kbOx8VS0I0qNwzHdorAPOAh5IAOzD?=
 =?us-ascii?Q?QUo+eK5tEWZNvPH47lJuh2gb1gMuEGEJR54q/pdBQ3NAFZm7n3qV+qtkwHnq?=
 =?us-ascii?Q?JwfIYZv7ktGaweMpRZ1d797c69bBC2MzXIaeTAn/Ju/Ix65uDoNvLHOvJbvz?=
 =?us-ascii?Q?vbCKr+selKYEsP2yARYPMgaUqa0A7ZbtnVtZDQ+VYCGVsIvwzXp4Gg/Ys41P?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uJ0mJ3SSUt6d1X2dtmFBPA5ztknuXId0f3y6YPzjIEwGmS/lT7sS5MlX1yzx8v03TuoGmoNB1wbqXBUrMFaL1CuhDbQPd9cWbPEz9Jbie4arqe2Bqun4VWogTINvHZ/A4hPZXbC2sZ+Ahve0ofNBRBt+rQ1lL/cxk2sLc571WneQrdV2X6httlkXxurMJNWxqk9JK7XHl9AC1cgpglsfaRF28+XN5thFDhr903nNiEeOiA3G3NmXMgHU8N8pIXVOd2qYRTa3yPePfEdSIrsNKzVNcZ46noHZs9uOy0r89xDeKAM62I/ZrpMYF7RsCUmLcQOUil/SmXWOh+40u3FFmq5Kvbxo5dQ6aEWP1WKctXPOwIgXCnrY7tOJinw2MIbTvN3cnd2M6jQ69qxZ1xYRPaFItWfrZZRKnbVCL8oNPZZQ62Q7UwX7T3DBCIWEAVNdZ47eLGNXSDnkcJ/4sQmQvCu1ZXxT+xLGnGzbvNbk0JYMdPr41NkvuLuWXwPjH2Zw84wvTR0OweqXXWi4afSQjLAzuyc4mrbg57s+EGZYQUFUJcRjQSGWyMLqifMw9qdlGlostk1wGZTaMU//ia67J0VvKUU7D7xX3TDTkL922HQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34ee229e-1166-4f6e-26d0-08dcf52fb76a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 20:00:47.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +a3Ykq8kv+a+igOYOGc81IMNUs1/qgNZx0yUx6jyaXZRxvARzO4Ft3AhpG7579sDmp89Bc9M2tt+2QZGSSoza8qw8wfF8Zbv/Fl63N5GOR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7964
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410250153
X-Proofpoint-GUID: zr5rnl1HBphgO9sBWTqpvhthdWi5zbZD
X-Proofpoint-ORIG-GUID: zr5rnl1HBphgO9sBWTqpvhthdWi5zbZD


Hi Magnus!

> I've been running linux on alpha (alphaserver es40) for a while, using
> a qlogic-1040 scsi controller. A few weeks ago I added more RAM to the
> es40, but as soon as I got above 2GB RAM I started seeing file system
> corruptions on the drive attached to the qlogic controller.

The qla1280 driver has been used extensively on 64-bit platforms.

Is your isp1040 original to the ES40? My Alphas used 53c8xx series
controllers if I remember correctly. And with the ES40 being fairly
recent (21264), I would have thought it would have used a slightly more
modern controller than a 1040.

> The nvram flag "enable_64bit_addressing" on the qlogic board is not
> checked nor set by the driver.

That would be a good place to start. Maybe if you could dump the NVRAM
contents and validate if that is set by the 1040 firmware? I'm afraid I
don't have a databook. But the 1040 was current right around the time
the industry transitioned from 32 to 64-bit so it could very well be
broken.

If you can establish whether that flag is unset on your controller,
we could use that as a heuristic for configuring DMA.

-- 
Martin K. Petersen	Oracle Linux Engineering
