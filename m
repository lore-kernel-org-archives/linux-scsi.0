Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AFC26AE5
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 02:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776739677; cv=fail; b=YXJXQnrD4YsNIHmmr4oHYtdgMfbmLwgcNgds24DtMdUlIbEvEoItp1ABejkEedsV6L9iLYR99GbxxP+bdwCtn552JplGPLEVsp9lbTbmaBQmMqDsg6Y+OcaMuHp/SCG8QxquNUPd2eMO8h3rtFqfdcCXZX00muqgjTJI/Ebq1zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776739677; c=relaxed/simple;
	bh=4rDfwQWDn9OXOcjaVniQiYbE+xlMz1xMsCni6zHonm4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bsoJMsMd2f2UGs/P3RiCfhk+GAr9n8Wby3HiKKm54fsxA71PE4LvuoJMz99t64qQpsSGNQbm46jUBNbAq+iaM8kUztcc6V4RI5C45KvfryiX3MW/yU1KkUV73PKrgzY8YpXez4JvRkTxevm7rmXjzFsqZA+Hk1ObrCgDnG5RNdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CqDNK/ns; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EbAxOVRX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CqDNK/ns";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EbAxOVRX"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLvBAa211935;
	Tue, 21 Apr 2026 02:47:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vZObCQsxE9TEaVsH6G
	mFH683NEXmgWn2DRhpmLffB2A=; b=CqDNK/nsumnvnDufclHApttvId1GjQ/caT
	jMx/wTYcn/HRgYqDQnv+cOKHMgzQv8zJDbjAzx6FiO4SQSF3YhBsk3/7nFOn54fL
	80OGW8DDghTF6T5K1b+s6DM3SOO7kATBlgk0NFwQoWrGpTVw+zf9Y5SglCy7NsTS
	YDlZaPxYYUL35b9VanuXM0iXptENceH3keBeX9ngrNtRYHOip0I0QrY0mkqYqIxA
	UF2Y5L29GIG/DJTk2dxwBA2Ndnxj0gMzyG3nwr1vR/ad7Sf/QPVO6tA7DFrNKXU9
	zfH0SqcylWhQGrsZxyLoqL81eGQ6b1Jr5ivmQpNeDa5nHgx8RZVQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2grchpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:47:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L2aKJd016033;
	Tue, 21 Apr 2026 02:47:43 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dn1cn7emw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:47:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V8LpDt9mhIkKOH/hgp1KyPIV404ippb3AXuOS035n6yL4KYc86m4gXAIXcGnjDsH8m5+XN471H7KHidCbOwbLipusgY6evhi+zud+JgwVQSvJ5yA6KbvWc5pMO14HRg1Mj3/GjUxZV92spJOdttcv7hO2+kOXAK2Z9q/W37taScbKtcBngofhoQzSJdx6nbdO1YLon3JO/9SwEXpQalUAMRoSjM2Iq28CCXGBXci6ZRitOgpUXnGWiR+o5UheTaB4zGKLcKIR66MnZRrbZw9O18d2Z5nJP4FnH4IpLovy6MLdMj5WUWP4gZpIifodDIOg/+AIWyCdeiCO6JWxf5zhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZObCQsxE9TEaVsH6GmFH683NEXmgWn2DRhpmLffB2A=;
 b=esr52Mqk8+F/Lq9uhtSqoKQgeHcvFRG9Ost8Wf5jjOrxoLA0XPoVj6GFKt39bwFsgjmxAJDnLVzzuQeSt8e+Dh7sUV5EOHv86+TYlaoMsTSN1NjQY32llT9cngl8t+TdsN/TtiY2pryMbe8rPB4Hg/S2o+N6DvXJIYKOpo+eNA4bkRp/pB3OSk+tVmTrPfTEfNyrWQPAkP1S5zDimbnDnX8lR9gNKzzGewvPqx4yliftcYr9OUj++oGK22R5NQQ4vd+CRDv5JcnwUblTHoyQEsNCPjMb/+Agmc+qWAx3YVerpkwncBzMp99lL2CAyuf3NQm5rv+hoGFDyQk/Z57hCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZObCQsxE9TEaVsH6GmFH683NEXmgWn2DRhpmLffB2A=;
 b=EbAxOVRXYxW9mr7D2HQI8A61UKrwZvNTi3t/ph+djK/Y+QFbIxuf660uuNEMzP2diwoCpRo3KyEW3S0OMf5szL7MCd7Zlk+rky02i9UxBaeo+28LWreYC6QtKQU2R89UQgc5+jCqfW+Gl5hpn/cckAYgo2QXL/6Bg6uOYy7gPFY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Tue, 21 Apr
 2026 02:47:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 02:47:38 +0000
To: me@magik.net
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Kashyap
 Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        "megaraidlinux.pdl@broadcom.com"
 <megaraidlinux.pdl@broadcom.com>,
        "regressions@lists.linux.dev"
 <regressions@lists.linux.dev>
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
	(me@magik.net's message of "Fri, 27 Mar 2026 03:20:36 +0000")
Organization: Oracle Corporation
Message-ID: <yq15x5lowt9.fsf@ca-mkp.ca.oracle.com>
References: <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
Date: Mon, 20 Apr 2026 22:47:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0146.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: dcf2d3b9-fde0-4801-b648-08de9f5059b2
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 xM5QhQMU5uIAIgewznmi23qpmXEMl8OiTRriXEmgqxwj33snBgp4Ef4zyCU/cIL5BEizzuDxRZ7DZ5OSluiYBK/z1W94bWX25bo6Zcz/++KBahcVs3n8K47GJhpv1LinwMdCTLnfLaDBeV5byFRLDVd5/coA6JwVvzrlQQ9FhP8zT5vVMD9z9PQ8rVctRsusILvYvXLvWrH/QGdnbGxiGoSUqJlCJLBWa527uZYZSAYBNMCQrBgqWwe9TzfwGoOkKUkNmMHNqQGVkR9aygzEK2z5MwPMJ2Rcdo9EOCU517pIdaijUnnfDTvVn3UCxZDIebvPRbXdFz4Oo885J1QMaPld6xsmm1eOq5M8AImbrWZq6v/+pOhzAUviR4ehRTJAjh5m2F8Y5Pgo0JtzI296G3HF4aFXkvlbKWawsm2BrsjlQ2v2L465eCm7f6AHYAS+Ql+rl3MHUtGiMh7J9iKcbkRjat1cwxGZ6dLiK55ly4VDcNxgtOVncWNa9Tvh1GVSXIXD2KVY9ljgxvzs/SVmyz5V06y8+XH9m/fn8/1ZVBWHv2lDZApz78T055S5v+PM9f2GabLSKoEy9mjQR98x1RerGO6dXL/fmD3En0grVsATRD1kxmOg+mK3NLwyreBGuxPo9/3KKq9fotE0LjOFgAM+KzvNgvpj2dX5HAf1pGUXt71JRvagNYMhsOn/EhHKWYNNeneWVJ4GeaVM6kJp0iU1n/LNM2+b9I14CbHnPFs=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?uTgDHtjkoK86njQEIfv/EtlRCpuMMrFFW2/RRPUxlNoy9AtIf0hShDKSahos?=
 =?us-ascii?Q?eRuqN0v/2sEktwN1xq5akhyGUpK8hiRZ5j7q/TWFprQRlxmsq6GnFj52ZvWQ?=
 =?us-ascii?Q?WfTdnauNiBJ68s1lbqBGN7F/Ojn0WvJJL2wye6WeCwF5Zr3VSHqwoYlwIbe3?=
 =?us-ascii?Q?Nx3sAJY1d+zc7TFEM2F7o03+fFGMlhdUvFIteco4zllXowpPnBSNswa9ZlUy?=
 =?us-ascii?Q?wxLU+WyK9mdl8bdWucaUgMXxWI3ujFjYwRm0Lj+FwrIxwMhJ0p3OytiNLp93?=
 =?us-ascii?Q?dPb3Z2ze8jmxyeTFTg3ENFYKM6tO90rqTgZKhzXSZG+wFtbTQs37n06IyoJa?=
 =?us-ascii?Q?J2RJ10EjzaRg+eG2GTjHLNfpxekmf4x/2TfRgzS8NCJatlrbsnbqZPChUKac?=
 =?us-ascii?Q?t+xe/uLfj/dBz5MtYOSzj48hcZFXuR1eBXjGoqgy+cYggWm4gK8KUFW6dMx0?=
 =?us-ascii?Q?UeDQaL3wzXKDAfrd6U9xSMjqj3yWKsZzppqbDsZAMOckEADvnj2Z8T6wy7gI?=
 =?us-ascii?Q?h/tQVpWjJdSbiB6wSDjovQ9RPXgM8PF3We7NiifCNBoCOw2+KqJs4pCNJKKn?=
 =?us-ascii?Q?seRQAMNOhQHJWe8kdMXKP3qUqtOELXUBHJwFwDFErvtj9RI7p7Xm/IwX1EaF?=
 =?us-ascii?Q?qKq+3zaQUzsEWxwvZkCM9gcFaHPNKBbDSABWocT8NHKxapksXBZbWxLVa4YN?=
 =?us-ascii?Q?NFnwPJfm8cvKL2T6lWKLKNTaWj9hwWM7xYPRCLa0PG+3YOQ6KGEWniJA9itA?=
 =?us-ascii?Q?DchF1cnrW3LyzuDPMxbxpGG6l28lKoCOFZVeVEQIhXaO1b+3RZ7b8+NvYb6J?=
 =?us-ascii?Q?bgEQSQhrYEOtSAaGZLrew/Fg81A9jHhI6dUquXwPqGe7iVj5uJkytzdG/C/N?=
 =?us-ascii?Q?7hjow2VZtc7sZklYQHwGyPgls8l7qUbgAwV6MAXT5HTFs2bRNgJHS5rt3fGc?=
 =?us-ascii?Q?wjfbFBRzPheoeK7a7JRjdJApZnosXm2HGLm12Fv50rZR7i4htNpDUMLAZ/ao?=
 =?us-ascii?Q?vYEcee5tSiajSxMv2L8+lPq800IEf8so4qrGTAbK2equapXiSCFfohHIzv0R?=
 =?us-ascii?Q?7hpGHqd+VTVudKNZ5GOpHR84rkXZ/HZBa3AhyS38fZEERgGRDG5a+/shb+a3?=
 =?us-ascii?Q?uUUWd3ZXdnuWAF3JFxjCvfBGjYEUP/6VqNto9gM5fd29k54gzs32PMcMw0Ln?=
 =?us-ascii?Q?74oKF05ziCkEG3k/6yy21xbLnSOCjLKRWIuFROtuJ3Vpa/Tvx3F+WlmV4Q/C?=
 =?us-ascii?Q?7uhWacENrcnA9tleBvmfGgL4p/pCb48d5sAPpOAYfy3EMh/OpR0cgDglePO2?=
 =?us-ascii?Q?RNQFhZdmLfOvX4gd+rcDRJFTeEsjjnesCZXzpjn+q4baHyeiVWKzFs6x5CEo?=
 =?us-ascii?Q?1IUeILPsHOGRzZaZ20emzirbF+Vt0noQrJFsxj4BfAr+NKrEECVzlKQcD2hd?=
 =?us-ascii?Q?D6EjqsVNJ0qIMkIFCWRY/wMdP2X/8RbyBVn9x0gI5CNmec7+golaf/We3I4d?=
 =?us-ascii?Q?tIyt2ldMcqJHE2SxxpnOeYby6er+GT291HEPMN8GGkdPQbbUo8ox6bUPI4Ih?=
 =?us-ascii?Q?/4oyF4wR5/vzKMQC3E28BFFgAW/MELMNi2kOExlhrkJe57xTni6F5iFjeOYN?=
 =?us-ascii?Q?hwHp+oW7iX+2u3NoVHE1+fWvgwIMCr3oeD6OCjUp40n/kRh9gRhL5jeDHUmj?=
 =?us-ascii?Q?aZWmNRU8iVXlttaf8v8TRmgKksCplHWgwTGfHpmth2juz0/AzhEGaei9fuud?=
 =?us-ascii?Q?nFuQ7A9aI8lsU2uzE8JeLZgNAew1Kes=3D?=
X-Exchange-RoutingPolicyChecked:
	KnhswAKRuTOLFJp4n11BrXObu9S1pFRw3LP89QJwWf5wJnAZfuFCpwU6WZ1f3xWDZv1sHyHImZqd2IpZtpmb8Ruuf9FpHAKfJ1m4qOYQW0RCKFiQtNf+wwgmTTtkSkXNx3lpv6GXIhuIjyry3fFuSuPYfjnDgzt/KE5nBdz0CAX/2Oci8SA0a3beovvRWBv4qi+p0myoyUF+63ufCcVrJXCL3UmQGRwZroc1BKIsrz89jhoF8rxG0TIH9KKcxAieRVhNR3ulsffQpOVL1dJI/ytszArr0IicuF6SLGz0M8EDYlMT/qNpPRfmc9+6MS0+3dQR6mI9d4fj6sd8be9Lxw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gS57VbI7mH5gUTzhNMdyBK7FhyA8hi988HgTDWTPEoFBAtIBTTp0Lrjkf+Ntd2QDc8HztwjET2wFg2Idf9I8ZAWkuHnm1NJKdLZ55bwxVVFp7qbrZhsAit4b2m7kgj+VDLJTQ2rQpqyDqJKiKD8DtaHso26efE47LEghi+e2KSO1VBboJ46EdCGLbW+DhG5ZzL7VIxGiwFJa0E5I5STrjt+6bvx+BDBNXft2v3nHGUgxxSTdxQg6NK/wZeQGb7BjyE1FHhlX6MGrLlR9CFZ31LSRFKtCcjqcLysa5EKbsUcp1O3dqBBnJI8OGrHs1nIAk9ezFLvNLvhvSkxPG7Z/lZDrIE0PfckGCIF7WUgUAHh7L/0XEP92uy5oTuq6N4MttEowN23F8RYrEhoHElt7SAOAcjIgvGJpvhP/Fjj07/XxhkQS6yNRtOjA6i+/J82xGydn0YonF80XHVfrgULmCONCgMsNKZrEZ48tDqaONhNKxYEujKl964fiFw30m7UgKc2aCePeElm/bf0xbuTKZBWrj9797A5jk9waBczBe4dEF5xqDe/42OlwOtNPKgEe3TeTT5iCGY+uMagT4lgSSATFcfKKvlQlsKmBZoR/wUw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf2d3b9-fde0-4801-b648-08de9f5059b2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 02:47:38.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWzZa+3LKpD3B6u3NKxn3MduGx2ReYjXsCPoLD5sMXhspA3fSLmRbt1q95icf43Te/t0wP5Im96UDtN/VIDfusxwZLTThjQDQDBnV4dVWhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_05,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=783
 malwarescore=0 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604210024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDAyNSBTYWx0ZWRfX/oBPJFqFlxdv
 af9sYWLmDFzHeeAz+am1u/zCQlUlsIe7Svob+DZzX6fTI0FHKrbhN8aB12pwNXBt552hWKTRXGj
 3OhfDdJW0ZCnGxIPaip3YsBHH4VqYzqtzBWAIGD643crTSKgzBdoMyRJxSkfuzcvhpYH9f03J6J
 /NAsz9Zpg4SelorvaBEH88/a+gpOpKEd+6ejqiJTaEJfm2Dx5GH9eDf8KyVC/bcL0qkbXmUTqjT
 76vxm5BqLHhgQ01n91qok5heu9OrRTW3C1iyGBzsSjgzVnPW7cIRogV46xNINFKk58SDyMcdy/Q
 HAf3Ne8PLHRzAsFtfIXz6U49RDoHj6QgxK6f9WAe7NOlVoQc150kcX4rLxa3uWxGld+pqZovo/X
 UpYTQB96PiaG8kKsem9o07R1Edcky15mTizF/qu8faArDiI1/YWWQt3llKHkRUWkkelrw4vzYzO
 bAW6tqhjOzSU10/vq5iNtfFfldFGaJH4HFs02qM8=
X-Authority-Analysis: v=2.4 cv=TN51jVla c=1 sm=1 tr=0 ts=69e6e550 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=eRKuCU3VBvCXl2hJBwkA:9 cc=ntf awl=host:13825
X-Proofpoint-ORIG-GUID: uPnwF7f3GWnkIhaZcFhy3moRqhOk583V
X-Proofpoint-GUID: uPnwF7f3GWnkIhaZcFhy3moRqhOk583V


> megasas_make_prp_nvme() builds NVMe PRP lists in cmd->sg_frame,
> which is a DMA-pool allocation sized by instance->max_chain_frame_sz.

Broadcom: Please comment and review!

-- 
Martin K. Petersen
