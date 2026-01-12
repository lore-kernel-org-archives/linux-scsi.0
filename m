Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859DA302767
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 03:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768187350; cv=fail; b=FAPPvJnK80pPX6LxZyRWcVS7/cbiZ3b04s2D1YsTit9HOlnjpLs3mbcOeszIS5QQLB1zoFEq9X7w69I9rg4O2j848W22xXgZjK1Nxp9y2qmQNBV1xSKw5P59wq/sHX0tLHG37z1sLPResgg7ffilH4b59LUQqjSFLGJ2gkh2Mo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768187350; c=relaxed/simple;
	bh=HI6CZTXryfDor/LsaqSTaSrS2pqdDtarr91yH1jciDI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LG8FuEc8FHm2ZdDazXeawfMPvn8I+FTCKc1jgYMsV7A8dC9n7YT3du3Pe1A/YLhGHRblaXE2M3KD97FX+VeP8hz+d8b7t8EaVoIGEzn2no/1dkjS1MsJleTb4k1g756Vyoo4n0lI5Hkfaptx7HUSP1KtlSLX4QXryuR9UGrsHGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D1BtaEoo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BHUO7TzW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D1BtaEoo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BHUO7TzW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C0l9Rl228767;
	Mon, 12 Jan 2026 03:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=paGF9QVdv8oNFGw15e
	UzY2tDbrXDVmaTwrdLWllPXaQ=; b=D1BtaEooBeK9zUBSX2KTGe+DvCyvV94275
	SMqPr1w2lgDnABevg1VIWzPd4R7i8YiiRPBLUoSNa+4MwRoS/Nx2RtcMb1Tq6T5I
	kWTnf6a+NBHfepOWNvAuHp1Qa/zfpZ183RhnJqMKYrgRIuZAUgsq/33LPkIz7Aqz
	G4LjFMly5c3WaoNoeqMpqjePijgiS02z8nI5Lx01+kII0gQ0UGPYn+b68vzXmn6M
	CbIHa2PtK/E+7tTofCLThbFZOnDXkpaoLgOJC0HYjB3XMmcjKK8qDwTj+sNdFIHM
	SelzFCj4jejGBw6hHuM74FqRAljhwMZiN7zvGAFdNfd7TIJxd/3w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb110b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:09:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60BNIs7T035258;
	Mon, 12 Jan 2026 03:09:03 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013070.outbound.protection.outlook.com [40.93.201.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd76wn90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:09:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=STbHECShGGU8FX11HSeF6QW1Y5dxKiDrAAazjwgQRES/MJfYMC4i/1nHxOxlEj6Zrgfg+iqrMrbXG8r6YWjhfRcgBClnMjRoeFf6sETBx9737M9QwJuWWTr5nrnHoLtdLAaPuAykIlUUVcu/8X9XtGssd5sVH3mEDrqIINE/L2w7c3usli01UaIqrX2ZJGyoFBnVxMgTYbuPGVe1hZjuhc8GFiR3QZBMvQD+DdRSjedUWOYEQ/Gb9XIjrNKnAkP23UTcLp7n5ZEDQZar1Fq/hKXTQf/VgLCzc1Z2Uwft4tT6O1Y7soLhRZimm7nqcBUeZpH8zKcMIHN5kccrR4tXBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paGF9QVdv8oNFGw15eUzY2tDbrXDVmaTwrdLWllPXaQ=;
 b=Sc21q7J6fqWn/2Jgtz4cbjBxp+eouwP3GZaTNEbv2WSt/d+OmpWei/+B5kdRQDCcbNGTr1DlZK/k76H0Uvkvj/Cih/KKYO7rDEVLVUIpfd32ZlypjaRBMbyKt7SpCLYjmqIxYaXFLVBfr8yRIRGzUNdOrQR5xoxUDuRxlUt/kBKMylB8RzB/VLdzI3aEfUlArNAC2sdWPA7Sgmvrvk2EbKHWpec8I3yvArtCJFkxrBC1rHT8LPBDBQU4aSliqdvsm76aiERk7R1gR9LOWjJ8eA2L1KzbAEN/VuTb6t37YmJgC+a2gwRrBvoSCJpk5lGcgV/1Iro290FYFuB8n9cBWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paGF9QVdv8oNFGw15eUzY2tDbrXDVmaTwrdLWllPXaQ=;
 b=BHUO7TzWvRJA3gut89fe2SZabFMh8vVyQ4HCS7oAAAKKx+9wwjfPueHI2o4aeHLw55T0OY+cXx17jJWMN/h3JO4y6OyXkFgDVYYLGdFajKOTbCXiqhOavPpz3hTTTR505Qor0cf+gnIxmhMqG7k1C+A8fehcyPLs6pyx0pfWDEw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7502.namprd10.prod.outlook.com (2603:10b6:610:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 03:09:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 03:09:00 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/2] Call scsi_host_busy() after the SCSI host has
 been added
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260109205104.496478-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 9 Jan 2026 12:51:00 -0800")
Organization: Oracle Corporation
Message-ID: <yq1h5sr4jeo.fsf@ca-mkp.ca.oracle.com>
References: <20260109205104.496478-1-bvanassche@acm.org>
Date: Sun, 11 Jan 2026 22:08:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0084.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: 164405e7-97f7-4366-85b2-08de5187ee9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W+XBbNYqrtfZbUU8XYROVXyyEz/SdWGlD0NL9G17Qm8eUmhgsmYqV261EcCg?=
 =?us-ascii?Q?vohlcs7108eRhVYoDGTpN24kl3pg3v+1EeWk+/Ru4rgOzy7ORSXvTea0R8jT?=
 =?us-ascii?Q?1vANO2Zql9p3rfH9oPfiaMKWnKtT1G3dpf/nZOaM6WwGH0/kstejfBBfGoRD?=
 =?us-ascii?Q?AxTzobkjDXmALnU+Xt6hd9oREubEr1XURQKTZLDYRDyNfjIQEaL0lewpuvfR?=
 =?us-ascii?Q?+bRQDYclayfgFH+cvW4N5JRfAen9YRkp5VV6j/Wc3Xebr6RDcXPtPcQnFkPv?=
 =?us-ascii?Q?I8IhGJbyE/FC78TQFkLY5YAOU7bwtkMXYtM5bgNqCZFftaonTHCdZBEGJiNH?=
 =?us-ascii?Q?c4vhckRA2BK/+D3BdKwoAf2gV81xu6uL93yl/VeHw0ETgDL+l6tS4l+bMkXC?=
 =?us-ascii?Q?dr2lw/LswHZjktlfMjW+1OELzPkqDuy5+3bwo2eusth7Cna9WkxtMjanbAp9?=
 =?us-ascii?Q?xfOhvID9l3rbk+FgQBnCcQLnJHEs0IDOAv66Czhsz/HMi9QKNvwcCxk0g5VT?=
 =?us-ascii?Q?85SnHsFEoj6x82G+7zBzbKF5qTXVrizAL6MOr9qBusqe8Z/3oK6nNq1yQOxJ?=
 =?us-ascii?Q?X9HZyatB9qS2BHoftaUcy822Eu6upy/WQ5OeFizb9u9PRHcqq/d9kePbwvgE?=
 =?us-ascii?Q?3d+zP2a+wufkcfTj6VJKuI1/8Av5C+JgNObZsYv+Nv9W9hbfnS3Kbjdm/khN?=
 =?us-ascii?Q?FUO/oXihs0f3F2WpRhZmDRgFMomx7kasjGbXw44lUePZ7sEj2RLYTnsPSiBQ?=
 =?us-ascii?Q?l7CHx1llfQYX5KplAcYc6jaJiocoDssS5/bqak7akN1Fjv326TfcajWQ83WY?=
 =?us-ascii?Q?3ctJ5sxPMiQALfHtga472eBz1Ozk6pAOQOWMrS/78DMr/7QcY0Jo779wrJ1P?=
 =?us-ascii?Q?0RDy2qvN8aixaIlh113dbocBIzyFjAckVD/v9R9tgpWb8qpzu5pgTadFnSXN?=
 =?us-ascii?Q?PdaUIZx/JM5S/Xx9UIIJXCtXcw7WsUAN7hgesUWw7bBnQ5NEPZw3dU0g+qlP?=
 =?us-ascii?Q?2RAxBZqdrS0lpjjNwCTpND7ZeGGdlvw/7TJKTU5ciUaRoYVU8XD6BpMCzqcA?=
 =?us-ascii?Q?Xabw84Ihr4Fmj5gibqhZ30BIbor6OwM5jqgATxpvgKcy70KNiPn/iX7vgbck?=
 =?us-ascii?Q?pqquD3r4wrl2EAnQUqJ8Yf/CfpWKcCUzZN03L54AYz6qrQZzO1dHee+QL0Ka?=
 =?us-ascii?Q?IZ5Oi6ZuEF4Pn2dJJPb1x4q6VL7dcpbFoOuqmbuzas2xO8T/EkB5lXimPcv4?=
 =?us-ascii?Q?TFtoPcONDbYqgF5WAGea+YJGBpLt8bcbSokNehACY8A7XTPcqXNejlzImWFP?=
 =?us-ascii?Q?2TXRBVlMIpt5nnU+DeBf03aW2V5eQ4LfT4lACukc3qB6uUHQurrG4o1UhI5s?=
 =?us-ascii?Q?Dzg1KLxrLeD7eKAy4jdqb9Ar6L/InFjk50zYsLxJfbauwfUbjvb0TYpvHFML?=
 =?us-ascii?Q?8IQ0L6E4mgfn2s0N6LTTEyiHu5a+XMgz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HjE9Q7Mru9s5sxoTynUe7olqUne0snpSnot1cNK+HsMMlse0ivMb6CtWYF3+?=
 =?us-ascii?Q?FMJUu/Tj1u0RkWsUeXEhtKsg38C+HjLAPphJEovDdSEZBoi9mejNXuj+TTdb?=
 =?us-ascii?Q?0ZSWXoSBQM5bOLLzO/k84OAKUEQy8BhZsFGgtySMgSjjARfUTLUdLT8rylAu?=
 =?us-ascii?Q?WggdLlMOuX3OHjR1eQEvFWqyHTxeeCOA5gZr9lqVBkjhi0HMJ7sHSjtZMKS7?=
 =?us-ascii?Q?Z7dkv+4VmUmzC9+ZAbAWBvawTO3MLS5qGHD2dDr/LM5evRZgap84rNybRsap?=
 =?us-ascii?Q?ykleokN22GoSktzkc5kYd48eLf+5okv19cusydnAz1lQx9FOORI8OF8vqped?=
 =?us-ascii?Q?TXEDQf/o9KQ17DulB4qkFN2ZKxFu26Tfmst/dfOq3lGW/czen+02F0GS8TNF?=
 =?us-ascii?Q?lAOytAvVO8ZSTp07cswjhh6yzrVZK1MEW9oFOhJyfQ6NsoOitsbUXOni0kwu?=
 =?us-ascii?Q?CnylL0YZlYbB/fT+XhjIjFnQSIwOqTSk29SlJ8Ye2FVn51V9tWjcuFXVVn3l?=
 =?us-ascii?Q?G1AgP3xHltagUzk7m+TAQigjPIRg2qZh2OUQJNVamE2hnpppWY78njF28cK8?=
 =?us-ascii?Q?jRjYXMS6CYiMw6FkFEnkTvQcNBi1jYI5unfhfLvB3Fztw7pcXhzXWbDHFan4?=
 =?us-ascii?Q?EYYVheaVoVATcoaFxP+R7BHLzP7MlptWQ/xaCBCjK9K0lAzLBIUfADPxv9ss?=
 =?us-ascii?Q?9u1WOsGJVCZ5LBitmzC/cFZGiLXh8cyuojLh++f8PXUn2QQlPZcO3CAyaA8f?=
 =?us-ascii?Q?B/S6muBJOJGMy/HuAQHe4my7a8vzIpQRFPCvrsK/7x13fxQyHm+VKmVXrVxQ?=
 =?us-ascii?Q?Cd5aH+QOmmJExVz51qC6ze/IHmxuzysNTFZyDE7lDVmtXsSjg4KUgk8CUNAy?=
 =?us-ascii?Q?Xi48E4rvh3ibqjGFTJSiGzbW4YtvYQznuQZ6uFhjrHSfQT9fKFk8wKUX1qvj?=
 =?us-ascii?Q?LmFE3stOtRjWn7Uk8Q/yDecH7cf+69s0/e6Ze6+jENjkOXfLW5xuv/p8nt64?=
 =?us-ascii?Q?PGLWOAUkr5ksRWK7tI8qp38vENDYGNxJvuSX6tguuThDz3+XlQiy9pKJySe5?=
 =?us-ascii?Q?4LDveLCebxFqWONW/KEP6m5Gt6gX8oWgMNnMUMfqQYRw2Ulq2O98VMRIenuY?=
 =?us-ascii?Q?zg4qTeLpkYI5famVrQjCk7wOJsSFoPL8DJ0auOEJaeFw+VusfYZRR9Kxd5Sw?=
 =?us-ascii?Q?fp1mD8WXhR5FmHAPzHhGuTeucmX+4YwV9GnMBTSc3YzeBXF2Ipg1UnPLG2cv?=
 =?us-ascii?Q?v3pSNa+rMocHQyzTTPVicgDYdoDeEuEgurZNW7it9ZTp4Iks0XqyceUhKwGW?=
 =?us-ascii?Q?Fy2jr+CJMnu7Me9d+Ws1maukyHrdAxLXceVDiCcoiaY/4mHkLOQUVjNo65TY?=
 =?us-ascii?Q?8u45A+VFrsne4RAHsa4fxFKKRn+dA5kSwJLbYz4Q2I1uA97Oje0c0BbTx+fL?=
 =?us-ascii?Q?AftUI2CmUeE0xTEwLbsufW9eprLxEQEY98nlfwcs35KVFgvhvUQh18nsq039?=
 =?us-ascii?Q?cfgR8pbNf3wRrNBEXIFKNS5WRndJldNt4EFqnCIC0TsrR2q8Kb+IX4d5PkN0?=
 =?us-ascii?Q?aWK9YkL6Knkj6OJor4fhdmBAUMgMHanYFi9Pr6NUmcNbpPlUrYhx6O+c9FGM?=
 =?us-ascii?Q?aC4nmcC/vUgfmVXewHuRiXWQ4u3C7lwAcsb/m3ztataocNbqv9RwkonFK30W?=
 =?us-ascii?Q?Ysl48e1NiNjpJxQgNP8dHzPUkPJaLN61kV6hgXfY9UCAgagXXlcdI0TfexoL?=
 =?us-ascii?Q?DuixuYcW8NrGSMBrjIO2K5TvarXlDRk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vY1rSnezwNYjuchB1WMzJ/xPzUUQpK2b9OBFjy1E1yTvyEmwpwJEG6ylktD3f4YonhUQqQ1iPZpJvReh5xmp9QUcjqc6Zitgr5z7ujhaZxTPUs3VF5668l+C1XzxlVAB4zGSN8eSOitvgdOcLGEH8oHZuiI0CH3IiC3kqDuDcqX3JStZJ2xEg5iTXLAdRf+jt4d6bMhbtHT6qwGAvrN+ygDupYdIZcEPIE50bwOMeHof24vitRtjQpJQbkzoZXW3+khJkvv/xIIyeRT3fNSkvm17j8zihvnvUTwf34v3jdv58ZJGtIdspGPI9cF+GmIPmD1s89byTmPzTpFZKwwJzhodzzIuBO3kYgyXVSBA4fZKfxvzPcH+41fQYdV2kzuZynYb3Mc/zwCmmcYQMrGmi0ZHEd2RjWr+2BSEV+44d2yTsE5DNCRF5ADzKq5idc5d/KVx/nJ51QnvG5ucXZ3CQ4BRUsVDHLQY5cLSWrmywilnHv6xgLrZ8R0461LB3XZIgrYeWZ6YczDQyYy3b9ZTQrljIUYRq9xdsLqnp2rBpTAR9r4PXzyxC4OWvIr87U+2U8T1Xoj5AZnnY6hFGBMiESBFdqRXRioaEjiCzGttvCc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164405e7-97f7-4366-85b2-08de5187ee9b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 03:08:59.9780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecZwqtZlN8M7WFEvvI68MTH1xt9Yub4HS6A/Cp1/TRqs1akPoGr4W8ifLXjHX1KvOdZQcF0iVPZpVyaZ03EZRAbBHa8R0NNO5KVzuwa2OqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7502
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120024
X-Proofpoint-GUID: RmcMWRj3GYpuFOeaMjI42USO1enNX-vD
X-Proofpoint-ORIG-GUID: RmcMWRj3GYpuFOeaMjI42USO1enNX-vD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNCBTYWx0ZWRfX4jd6z0joklIt
 ZwU1gEY5bB9H+IpPivQnOczx7QnVvBrzRbL0kHVQ4WIPY378D5oBdY4bHBLDq2T5SCqixNZCv1C
 YIEOeI1CixYqhcU7WNSLU39h77bHE6vR5/ZXoCvsE0jVWrUqdv0Drj/cqU4WHWtbceDjb4BGAae
 NuzOOduyq6zJfDVTpj1nFul+XZBnhOkhvYBx/ScU5nClP8TDVpAWVb3hKP1tBb38FgtOONvI66O
 q4q08DIzHUg+oG29SkQSAlJVgI/PqLD34xdaegR3+3bxA3rdemxV+cvW0Net6y4eSgX27jBMIBX
 QHDf35iOJgRnFvw/cDIlknpROHFTWQyifyeuKZvoPfBrY4JVhunX1Pyk8sKCWZh0S09ryxkkLZa
 nargHqHevWu6ti0f/aK/H7usT97q3FUFk6Hf1C+/DuxUVTsiBR8uHDLmltWuovAxidRxXJSEFcK
 CTlyrgPUWxVetdYcxhw==
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=696465d0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9


Bart,

> The UFS driver is the only SCSI driver I know of that may call
> scsi_host_busy() before the SCSI host has been added. This patch
> series modifies the UFS driver such that scsi_host_busy() is only
> called after the SCSI host has been added. Additionally, commit
> a0b7780602b1 ("scsi: core: Fix a regression triggered by
> scsi_host_busy()") is reverted because all scsi_host_busy() calls now
> happen after the corresponding SCSI host has been added.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
