Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED0F12E1D1
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721695808; cv=fail; b=qAZ6HTvEq4sk5JajNSEt3JlUM8S0t44r61dcFFGf3LxYAeQ7Axmf1Df3hNgDrLAjDmlcCr4JV4onrJsf2knL3sCL/ycZIKzQqaNd27AqLF1B7J0sBcuWCUZc5V2Nds2XinGkA5aI3fiFebf355HbY/lm0UkkJ/OZUi+ktzeBT/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721695808; c=relaxed/simple;
	bh=907WyWrrYMnZWe79oQ7ZRPrr/adcC+BqZhDcdgtujTg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sMus9p15Op8tn2akZewxibl9B8AeXZRvNhAkZDavn8SJoagUqxYpne0XD6t0fmVFAezdOhYyLuDLP8nGvcnnq4AdaEMcqFv37vj3tKqyD/1fARJYSk83JwQffmN7adXPZQ6xZerl6xxDlJLD+Z8VcGyTzsFXJp908V9t0/v2D98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NtMQ/ZZy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m5fSU2GJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NtMQ/ZZy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m5fSU2GJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKth8P018552;
	Tue, 23 Jul 2024 00:49:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=lHagXhNim4Te0o
	zYmzfxIvcUW1c0JTj26k8V0eS0IpA=; b=NtMQ/ZZyWq6+3FdDCz81ZcYqGA619D
	cVBvqc6orcy6mFBiZblcFM79oU24/akGa3NMY08b24DXfzwN0fIPq2OqDeAOkYLA
	oCrPRXHpJd7fZIy2te1nybN03CnkbrAr6wB5kKXiRXAjjS/RBl9kXtWlaWBJ5CW9
	R/BmEwYFRhiswAGKJ4OfO+woG8WcSx4xoEAKlNC0DR3Yno2RMYz1gZvhKFIROyBP
	1ut+J3wVYOPanFkZTn7bW+SKcIlKN+z2g18pjDjog2z/p2QSa3Bodbc4PRMO537+
	wKa39I0sJR7KYaLXUT8hwgSQ14JLo/BDUL91CWQi+LjiHvyIyNiehV6A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hg10v592-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:49:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46MMQXRQ018568;
	Tue, 23 Jul 2024 00:49:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h27xy129-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Racv6oQ2Ju1gFpCrW0k4Hp24J0p3MlJr0UqI2mBeYrkKpQV+Rm4gmxcE5nUZLY5VEB9Ix6URXtrvwuPz0rFB8kmcmM6s+r0yGMFanPKIH3j9PYY8xBv8A8CCyqG2DmXDLJ9aAI4DT3638sag+iBkvSreLLwB61VyuIe5rDmZQS/mi9Tcmsmd9wcrm92aKQSEJQlyoDHuJDQ3X1UAwm8nHwpIPn4dd87o1PgnpH1WADAcWob4WbqRiRppS8eN2DlHafWU/lw3vx54ofUA+fInZ9JSgqo1oibDapOOb2E/gmriAEQazkG89vFZdF1WYFGEve3CRBfDuR7dX9+wF+OXww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHagXhNim4Te0ozYmzfxIvcUW1c0JTj26k8V0eS0IpA=;
 b=XhY6r2PDZ5h6mxEhv5CqzEPSqDWSzeSqTsfCm291U7Jau9/Ia8Qp0wymFtusxcgstv017F2ZtjuXX+1a9oXfF8AHbYLkk+QFCMjYFNomfyY3EoN+DEjKXLZ2KGGnUDgtfVt03XxuVv3N6I8uG3lzH9yRnVpza5nH5JxLnBvfk7/zkwY3Ra7tOMQLOpNdIer7JeZ1Avfw11COOXisxi8QwdrIBIsgidv/SbQ9sZDsX4tMKZWRKrNexWuHbCvaC1X1hYkG9xC5eDjItaAh92ij1jNnyPzy98lCSXotH/7jt+FV89dUJfjJnMOLRaNNXG4l4zyNG0RFRY53mWHI0Abl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHagXhNim4Te0ozYmzfxIvcUW1c0JTj26k8V0eS0IpA=;
 b=m5fSU2GJph+lArAOMWTIXzB+CjpCJVZasqr+uGACYn19xSHzdFQIaUncJTFLzdPxgYC7QcYcoytKxMgxRT2lHN3qNiE2hGMd7arom1KM3Tt7+SKNDM/nFuAsrFRxxtnfZ4+WhVMnNauVcVBAbqmcgPLCWqNCOLteexlofYUAQP4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB8128.namprd10.prod.outlook.com (2603:10b6:8:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.32; Tue, 23 Jul
 2024 00:49:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 00:49:44 +0000
To: Yohan Joung <jyh429@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, Yohan Joung <yohan.joung@sk.com>,
        Damien Le
 Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v1] scsi: Check the SPC version in sd_read_cpr
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240720150039.843-1-yohan.joung@sk.com> (Yohan Joung's message
	of "Sun, 21 Jul 2024 00:00:39 +0900")
Organization: Oracle Corporation
Message-ID: <yq1v80xc57l.fsf@ca-mkp.ca.oracle.com>
References: <20240720150039.843-1-yohan.joung@sk.com>
Date: Mon, 22 Jul 2024 20:49:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0221.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: b2e6d859-5917-43f1-c8c1-08dcaab157da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mocpDMG1lhNHzop/IfA0eTiSrkNOFTuYBknqvMb8p9j/yHiRJUr5hWRSlA8u?=
 =?us-ascii?Q?mUu/KLnY5IPCP78vTS62PIzHYh/lc7As6tHXM6bG970Kbhghazbm/ivr9DtA?=
 =?us-ascii?Q?ITXLVDGCPIUlkPvaLsm+zfX9OUOTy7isH1+Cb6VRuFTG2KGZz5GS69AGcvOp?=
 =?us-ascii?Q?tvCdOVgJXOHK/HvpRq0oETEgSjRqVe2PHnzw5TqSfJbJL++ldvbiFrshLmOE?=
 =?us-ascii?Q?LY7Iv3dKIvXoDKcOxHVQ3G7/cSFvR1555rkyS1Y/1N7t+ghK3gVH2cajmqYM?=
 =?us-ascii?Q?rS9V8ZAYYzT77nGTDt8o/uOvsCvkagX5j2dlGol/z3Cp9ZhHesvWFB+rGOvb?=
 =?us-ascii?Q?eyDDr5zD2Dh2ztVzM2J9WUIhhDYGWVIYPmDFcZKuHYA7ATBmcjSTtc6JK02x?=
 =?us-ascii?Q?rIVDEft6CDcrBRzw7D/D4obkvITe20t+cIV2LGAOHoganQ2lgCSqiWRrD9qK?=
 =?us-ascii?Q?ZY/tAX3jokHqCToNGfjUdPom0i2s7NnJy/jqF1DkRh/bbmUVTOvXdeSnpBor?=
 =?us-ascii?Q?duPTDgo+ofOzYr0sp4MNL88/sFc3fddsvegy/d2pE/rui/hO/u9tGvuSgbvn?=
 =?us-ascii?Q?NTM/yt3UCQTOMlBR97k9fXH9z4XwBpDD9vzwtaOu64q8/c2K58FER1720oCF?=
 =?us-ascii?Q?MiQyEfG6x74YPur6IvfFTLJx+yvT2QMzKGcVOw1U5t3HZQbWFPLNR8kNkcY7?=
 =?us-ascii?Q?fB7AyhdNujv3MpNMZu673SKmwDopJoyA9yvau49ucpHjS0naSrUOHd0fivjA?=
 =?us-ascii?Q?p8yuGMIm30ivkue583/S9noRoMXXt4I465MtVueVJD9gicyXYa/z3/zmRrK2?=
 =?us-ascii?Q?FIErjCytWDi87Q/HCLdodrwqRAStc+i4R81qYrnHXlTWZwl+LrI6Cg6neEG3?=
 =?us-ascii?Q?DrlTmFaJ+Xd4JF4qPBOneLmgbFAv+ctm59LvQg8R8QRfwRh9Udih2wXGbSs4?=
 =?us-ascii?Q?lWEeV10+ve70MbVjj456O6r/27Aa8/3w66Zg8rnL5QreRPlV1rzJPppKtLsP?=
 =?us-ascii?Q?TRb1/ssxwYPJAGKdSPegO6YObbqRgGCW20Q8gXf45pW76XO2oKUXEnpsHO0q?=
 =?us-ascii?Q?TPuP1fi3T7QpCKuEg1dT8A9tcevybOhqktBeaaVKg8zsHnhTaywns87i1zcb?=
 =?us-ascii?Q?OVnY2qEzqeHbvOcLgT8x4yIDwdhKJ/tviAb+sb9TBAxr89Z6uxs1dyJn7s45?=
 =?us-ascii?Q?cgZJsWyAMn8t2yEB8HNt5bJwzSv7ifPu/IbTdODrtqoSFQ6wtmDFyejN4Hn1?=
 =?us-ascii?Q?B6OKmG6WTPoQ1chW6Vt0g90f1NTKPVph8gljw+pPOvPdH04c5kXVKxGMHSXd?=
 =?us-ascii?Q?TZ2tXstLSh49RLHa3/d2WU2VtPH6YPhuC8j51fyTb+My3A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N2NtX0JCUEu6YHtm/Q6obswumxjVcOZL508fzz/Vs43jQ/7qzQoU0MJkNWiq?=
 =?us-ascii?Q?iRZqF6+km3O5UorhdLjeE3t0oG27Kos3CVSifw0hnLUrJ8Xxx3syN6PLbUgK?=
 =?us-ascii?Q?KBoeJVSf1SYSH7ow1VKPVB9DhynlgWZhvkg8QAbhUcTTEYRe4OlfhDMsv0+m?=
 =?us-ascii?Q?zHQMt2PrrKITTghcwDg/ptYiiKxs/HY2OdXUYAIQZcF5LMf5NxxUMuqvbyuc?=
 =?us-ascii?Q?FxqwSnUs2TIA0OkilOMMnG2xvMwt/3SpYl2mNQf8txVaNlmhPrlcyzfEY8Qe?=
 =?us-ascii?Q?SzzwXZZr4UUWZG8oJcEhnsI/VC1a5ouO9APpofPIQnSiL5Oxhw7eUaL7ggsR?=
 =?us-ascii?Q?RFKkPzSub8/IyznsB/Rtz/i2yBL1MoGr8+MVsEBrmxNn/D7QKC+47Xi9FzfU?=
 =?us-ascii?Q?1XJS2bY5SfOjV+jVKdBti41K81TaonAclCZdIYEOsoFUt6CRhHjDBf1TC32X?=
 =?us-ascii?Q?ackIuGAZp8tmGuzFRglr7kqRDH4O3L5q1ZBGIJUb5E32g2rbekHjCGVUbrHR?=
 =?us-ascii?Q?FKbU92okqvvX+KKqJn2HPX2KKMi4anWLTVZg2q55g7e2t8L5aBuNhlUXPgzA?=
 =?us-ascii?Q?f4WdxUNIJLL235I1Jzf7BfRe0c2wbfdgY9Dcs7awZkV3+ri7R0QVRaWWkzQS?=
 =?us-ascii?Q?47SX9rJibwYjFP8jWT5acttf+idwQYlc2DEx+jJhXnGWbfvEFkmVriKtakGh?=
 =?us-ascii?Q?/pTuYop/TZpdd8d3HKCzniEp/i85j6n1zp4HPzHcUkiUjiYZ8VoDaEy1Ff5T?=
 =?us-ascii?Q?bK8whUUxR2j5z/bgTRTUbA6Iidc0JOoI7Xk9qdUHRC+nXEZ8Q0ociazNuX7J?=
 =?us-ascii?Q?2jjDldnZwo6v8l7WQ4E4cFWZyGZnPhdF9JGn6izEAFGgOZ0lS4tdDxe4zjBu?=
 =?us-ascii?Q?aNBlnrj/qEgfa1MyT3AiiKqKRlsQG4JtHSITikiNZSZ743KWXgUzoTNb/WzV?=
 =?us-ascii?Q?MhTd3gMI8WBBidRZbrr1LD0A+D99K/BiPX1YTSiS3tfobU45p/y1WyQ1f+Ce?=
 =?us-ascii?Q?VVLep0/b4VJbo2DJNFy0tswOtjp/wlyWLi0N96QEaeGmjbcHxv0PcY8dDX4J?=
 =?us-ascii?Q?/oAbopEa4c/Tz/qRp9QrVA1nw3cr5DDtGdZUgCFvM38NkIzFJMqa2sE6ru4y?=
 =?us-ascii?Q?3eDsNIzZDtWHsGJXvFU8Dwx6ZWikyebhg8Cgio101YrjHADgSZxQnxxwXdzA?=
 =?us-ascii?Q?0JRcfCGdjxNYNXR/hcgtvmTU3OBakYZDGEEcKp/chuj+WMYDd1GdFWaoEJLR?=
 =?us-ascii?Q?Tf15fRqwy0rmoKhOlpdUozFet1xVbmy3+ERbppu7pVw9G+e4+BmMeVsh02Gu?=
 =?us-ascii?Q?EknRsupcJDzmhLA/Xcs2pgKfdB9z9dDg3fFtPwYf81+wx3PD7dayyrGSMmY3?=
 =?us-ascii?Q?1JELr+xQkplIEOTNG2tVlINN4AS6sUkcjjIs7O3sThGfP65SsTF3VM7RfzDI?=
 =?us-ascii?Q?T5W1160k1l/nIvQLuXXxxAq/VoKSDWGngadtql4jMHhKO99ZC0cjQfO2QbcO?=
 =?us-ascii?Q?frqpWogIMJ87cMarZRfWhdHfdj1fcdQSNG/X7QbzXI15J0JYr0cpYd4VI5hC?=
 =?us-ascii?Q?iDJ4EqGetVkOusBbVi9oPakQ7CBTcLTTorsCaLjFyWoVg2QjYZZWiL/YhrFG?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PqMahSOiXj/dMSI0mRmsQuDQOax2yQnRcbzEiT20+GAr778q+LzjJTK066LpLzJn1Jk8RrQ6QBCKdF9FFTVx2Bea5X/DE8T12RrnZEnM/yT+wTrtRld/kSixa7m+VJMAiUQC/1yvClRafSOcid0qPbx2vif+Jk7hKiUHHJX/iP7637VGQmvnqIu5t6WqOxUEd0abkl2Q6UsjelZcrZHgoJHaYCDxVV4iDFTVNsKimPwPiATnP9RkKB5HV459R4/7qyWmMZexeNJVWrj6NbLhTaj6taFLsrbUNoFkEjavPEAbKe1k10crOSfR5nhnyV9pmrHleDaMki3pNudAC5JbjNDJuZimD4HDQeQ4KjI5UEvn7Cu7hPXUZUeh9L9Wbop8I8oY93TM7hNi/b4mdcSK/JPatQVv1YWwdnFKZhgwnVJ4lZQmU+ZNOU5vMSd6MZvKhEt/BMIAAiLmyPKT9qTJ9DtrGWLpAaM52DWTa+8EWdIMwnkm9O1flHYxcK08WtgcoSEViPShk5XAbwTgkJDvZ1vVBDc//K47On27lFy6Z9Z6AfMa395H+FHdXsq9zaV3By+OcSyQ5D4ixT6lt8RIJNy1Oq7Ex1rqPKQ3JCAD13s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e6d859-5917-43f1-c8c1-08dcaab157da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 00:49:44.0527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Alvs0X4D7W0Qq73DN5+qxrm4T5IRPnZ5pOvhNGL26E0bsqFAqu3WYGqosCUvISjfLAXuURaNEVSt538Kri8ISp/pZI/D2oUL0gWdBOK8Yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_18,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407230004
X-Proofpoint-ORIG-GUID: EGUfu6mF0Ai22W0J7UO5XYRW9eQErJrS
X-Proofpoint-GUID: EGUfu6mF0Ai22W0J7UO5XYRW9eQErJrS


Yohan,

> Add SPC version verification to avoid unnecessary inquiry command

Are you experiencing an actual error condition as a result of this
INQUIRY operation?

Devices often adopt new protocol features prior to the spec being
finalized. Therefore we generally use INQUIRY to discover capabilities
rather than relying on the reported spec compliance.

> +	/* Support for CPR was defined in SPC-5. */
> +	if (sdev->scsi_level < SCSI_SPC_5)
> +		return;
> +

I'm OK with the change but I'll defer to Damien as to whether this is an
acceptable heuristic.

-- 
Martin K. Petersen	Oracle Linux Engineering
