Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117811FF5F9;
	Sat,  8 Nov 2025 17:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762624760; cv=fail; b=I5OdIlYW6yI7oHhfNQ22GPUhMmBe0e44zM+xxO2uOhC7OFkkeS8TIYdSwDruJnntUfoDNORHjSsv4xM2Oj9jsU9pHsrwtTLJqUhAwaoH9GmeRjvH0ZVUgxtYeSK8mQEhvPxlMWTdI/aUGFhl0coaOVW0fEoJ2QL4+P6zEmnnhiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762624760; c=relaxed/simple;
	bh=jk0+WCghbxu9wiUpX0YdIZ2SLxo4IkuG1LaSeR+dboU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ade42MyUHljeFKlwGxw0dF99evH+WDNWx73+AQbL+5EE7N1S98vqIOUeYl9+fbvnpfF2Oj03mDUh9iEg9agaHB6bYGQNrbqZc+Ri/LTkrHismufhBWydatUZcQeHc5PwtRco0ijbDDt/XJDWm4MgW+OxOReE8Zfh0Y73m68n3pQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nd7Ah5SW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gJQWR7Eb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nd7Ah5SW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gJQWR7Eb"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8H0CXk005860;
	Sat, 8 Nov 2025 17:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+6taQmbX44HYnRuXOC
	PuA2jyDx+lzFDQ6Dzcc6zgGLo=; b=Nd7Ah5SWCmwapnbjsRDBg5LWrDoQbShacB
	o+lW0w01IP6GmUPpOzEZDL0vxUTYWtHLxIggjOydVdBYtLAfH8v3b62IIpoxkapc
	kjW1pSotUrrAmq4E0ZipVYrTpor8ap6Gt7d+59hXl2RwYa0YXI6cFn3FI6IkKxbj
	l/kjDjVTP6bB0x7hKGaEdcH/h8pQGFEUSiE1Tyj0M+G8hdSYQcfeFRD8Ewh01qiN
	dSGVCBPVW/ndPb+Yopfd4nJm4am6p6DHimG4YyE7HBKxKeZgJuBIeiNWtxEzYUHX
	0AHDoUTgUAQ8p4hZ/re7T3jiYjMomoPZyOoyRFR6786gzsHZZK1A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9vs8gq69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:59:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HB4Nc000864;
	Sat, 8 Nov 2025 17:59:05 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010047.outbound.protection.outlook.com [40.93.198.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaaqbsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:59:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WcUThXY+gItNE2GcrCbGBkKffv2eZdlAH+nBi9oH9Q9Qh6pzM2MoZJD1oC9UimlP9qGmoH+4VJKDbsLlxYClk37op0JEbKz/OK2WTrnP/1MJ51MlgEtaN9wMoWafkUgJjpdi3qBznZBseZH5hpweXnt+gk309aEDIWbBpXwK85x4+p74myx9bOe6nvfF8+596klbl81cavBtKyIEDXqPC7d5Hk33IZppPKxKbQb5+gXYmgqwIRw6xgMIoJdTcD8lrhk75QxluWf3rFgHJbUT1mYsU36djDErQcXZXygZnRDHasP5yEI/3XwhXTjGbDfM5tMixUkybOIM44yH1M2sig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6taQmbX44HYnRuXOCPuA2jyDx+lzFDQ6Dzcc6zgGLo=;
 b=RnAmwi2xf0a19/ZfMcAMBWB495KAgm5V1H1dc3pm5o62aXVVKm71fPBWG1EwiZylBBhbX7VSiW75mxvDA0OG1t2pFlXaxm01iL+A3YUepDsfspO5NuegbJI9Ow++tsj805+oyDdGRrANKre0Y2EUY68DdCNNYCpYFz+E4kzS1FygNItX2wmjDdHB4cVnN8DAyhtTxe+4ng+gWPyq9nn74HLq1jQiMH+S4xpA5mQVWLACB9ycsQoZEPxlfzkF0xnfv4xqOaYTrHo/SwCA5pSgZ5EUE/x34hjwrVodE4+dKhtt+JDXIb1eVtV+TroIkM+J9tb4TKT6huA/UrQX81QBnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6taQmbX44HYnRuXOCPuA2jyDx+lzFDQ6Dzcc6zgGLo=;
 b=gJQWR7EbDS+/ztSqg8FtvICKGRkMpubgBBewwL5BbdPIeVg3N+8cfwiS/MPq/BSmgIWnPVW9OjkjUygjV8dUozsSsWeEnVEsDvzuysi6HHaFwp8u/Y+e0d5cLULEnvYxsqky4XBirBvj6Ch17M5sISKC+R+MDDkHOAdF2N9xJM8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7374.namprd10.prod.outlook.com (2603:10b6:8:eb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 17:59:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:59:02 +0000
To: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Thomas Petazzoni
 <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT
 <gregory.clement@bootlin.com>,
        Udit Kumar <u-kumar1@ti.com>, Prasanth
 Mantena <p-mantena@ti.com>,
        Abhash Kumar <a-kumar2@ti.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ti-j721e: Add suspend-resume support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251106-scsi-ufs-ti-j721e-suspend-resume-support-v1-1-6f395f51219e@bootlin.com>
	(Thomas Richard's message of "Thu, 06 Nov 2025 15:21:54 +0100")
Organization: Oracle Corporation
Message-ID: <yq1346oiexv.fsf@ca-mkp.ca.oracle.com>
References: <20251106-scsi-ufs-ti-j721e-suspend-resume-support-v1-1-6f395f51219e@bootlin.com>
Date: Sat, 08 Nov 2025 12:58:59 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7374:EE_
X-MS-Office365-Filtering-Correlation-Id: 885a243d-f50f-4217-c1fe-08de1ef07fc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?le9YIAktH86q8IBBxJ4QH54aRbRcjeVDNWkpUGXTKnXHbEjAIMQDlETbcibD?=
 =?us-ascii?Q?ADf08tyoKyLdYfVAk93xMt7nTBafyDPoHak2LqUgXzTi52EFeWVuvCnPWNcf?=
 =?us-ascii?Q?dt6Qvl6S+w3t0eRh4i6luhTvUudykTH3mGJxm02P7xvzCxE5qeoClYEgtkjH?=
 =?us-ascii?Q?LVoKL9ZZqX2nq0N7noF41z7wV2rKjjMHitpI/Y1zEf8zDryz6rXae/TY8yG0?=
 =?us-ascii?Q?n3J2Cr0ryoBgq/bsvOaJDjIUE+dbQEPC1GYPKMUWsRxXOGXDDafr+BWSGLlH?=
 =?us-ascii?Q?nDR0yWHvO8KRuHtZFdLH3HT4PwIm49muL5PvXv5r+DohPtXoCgsoFp0Yq0nI?=
 =?us-ascii?Q?v2Jh6byTtdSCDXcXJJyxGuHylvzNkDFRnQdXMk0zHOiHyHyVbaaNuGsFXbWU?=
 =?us-ascii?Q?Zy0esQ/L+iBD0n0ngWdzMpt5Yn+rtqqbPzUV5rhIB+Rlwi1T/gRY6HkOb5RW?=
 =?us-ascii?Q?gNbXrNQi/5XVi6WPgrNmJE23brZrrzXsf+bfGYi3Wsv17IELdsOLyafMJ3c2?=
 =?us-ascii?Q?d9LSEFDa12YBgvlIaNvy6fi7ybn1Z3XBSlUtlWBrgiKXWKY3koBtBSFqtsWF?=
 =?us-ascii?Q?zD/086fFFpl2qYgeZpAamqTNzZ8k/PBpdxb2WHf+FGXouTw185FlhywVDpt/?=
 =?us-ascii?Q?vdHbyqeyDW5XjJZyxlXkeQI2RixNnV2QQ3ZUWJyGPVDLNMFW2MqW6EMLVzjU?=
 =?us-ascii?Q?hNA/WtFr6PbXkyxdeQJgWG/ghZk/WTmRiHsIcW/w2zgvXa+fGUVnJY9Evxbf?=
 =?us-ascii?Q?EsvynOGq5ghKZnsC/6j2qt00hBS124ClD13fhHAnsyIpLAgIMPE1GUCC4dz0?=
 =?us-ascii?Q?pcJDR46RZnwhnfYEBjqu65k+0N/qybs/Z55ztpxBRVuqOFUxnpt7szK49YFt?=
 =?us-ascii?Q?kOoVD7ExnO78pK4z4wyYhrkD1AoxvCpc+KjeBBTFC+pfOI/nzqLP/GjRqri0?=
 =?us-ascii?Q?s3SRPh8/+lDvTlyRk5Noz3piVnzC60rSgTQCzbhrZstjk/1J2oYi3HmxX7r9?=
 =?us-ascii?Q?3MLSKfFA+trRQHKkFAB9SOpGYdpJnyT+zY3pKLdbhz/cJHKbSndMleQbc7J6?=
 =?us-ascii?Q?vdjw3iLxJUwdulilHbPwwxZTCGW5zEkCUUNoa45a2DoZfzFvc5iwZDBMaeDS?=
 =?us-ascii?Q?+kpxBzTOIEV7oiN2R6vYF0fLBxM4SNJT6yw0xQYw2Yhl/EDZ3j6TMEsr5tLK?=
 =?us-ascii?Q?LQ7XW3FLDAdKX18NwAXQphE8RXzC78JXXDhvrHT2VoYlZttPQQDkoVowT3bG?=
 =?us-ascii?Q?yQcIkEHETXjAjOfvupu9cnHLeewX7xo013SsvDt+q1CpdaXCLLPWp1BYELtY?=
 =?us-ascii?Q?sn+hKyQwCdmEhdqsDTZ+J/vz2H1e2qYrkuwIlf8zsLD2qVm5pruvL5JXPKJl?=
 =?us-ascii?Q?hQb2BgDiv7cl0s0kEfVAHcKEz6PwGEICSSWwf1PNUJYyPEJP3tUW09OWbhzZ?=
 =?us-ascii?Q?hl2EAb105rAYOb0Z4IWGJz9WswV5OkE9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NBmyaxlYjqP2K9Hrv5yMUYyjKrh8Sg5yVXDXzMESYwZGbWKGwVr8sREoZrl2?=
 =?us-ascii?Q?HTL2rftNE4ahKxeFe2eHfXm0R0ZQpf4qrKcIOtIBTnZU8QOdSreFkpLdhY4x?=
 =?us-ascii?Q?sxmgXD6VFtxjSoPnB+qoEx6WDhmybcvqD+QQjpEjVjT+G9NGT5+dQ69W/D9n?=
 =?us-ascii?Q?x/Mq/0cxlvNedRwMAoXsC0isMDAQWhv8NRqlnO8Zphb8HYRVkvLNKlVrBv0h?=
 =?us-ascii?Q?nsJ1LG6XDi4xJnAyXmI3E8CdCeOxZUlbyciaRxF1nxXTrXoTN5fVLx1YxuuW?=
 =?us-ascii?Q?XyLUuB+1/IoMZ29lx7aYsffPMhe5qu42jbWVbkhnEbQmx8B0gXNGvProw3kZ?=
 =?us-ascii?Q?H8bpW5LEp7GjGnDae7MQW3ZXyh8ToTJpVi63Co3ovcwyEUWsnSu9aOfXNs7K?=
 =?us-ascii?Q?IjnOUrz5fQnQHJdGuISx/8Zo1aFvAWOio4L5j9zNBNdAbWnbbmMlEwDGCAsG?=
 =?us-ascii?Q?BsPV1YMAzzJi7yHD/tkGq6FfAu4WMBN4oKeHC3Ox32HcGDALr8zX/Un6nsvM?=
 =?us-ascii?Q?Kblg4lS3dhnXsoFDsEc7EzCbG2SVt+YX/NgXSwcHee6qdpPTY3wz37cdG5Jl?=
 =?us-ascii?Q?QFjvzU8TU4oxx0tEsK5623ubWv5km91CQmH754juoEmk3KS3vxBWT7ins+aT?=
 =?us-ascii?Q?mTlL4qQf/N47RH6lfARYHN9jQF/Ljwb0Wa/4AWXRW48/2aaCiVWDpTUdlx3M?=
 =?us-ascii?Q?lNKhyBhOlLdi0dmW7ChIEBviT5ZSjTpO8YaFc5t42CYum96ehr1aJXkcHw0V?=
 =?us-ascii?Q?go2lRec63LfMrcCzlmHKeD7k8LJoP7U7feTjLXW+AB/cYqq2u5B9jXScFOrk?=
 =?us-ascii?Q?aUDVPBBupb0gPaGzzRvl975br1d8YounefS9lhW1gCyN05eJKMHDkhWJwrj9?=
 =?us-ascii?Q?SrLXFnAIE7wnY/FEhk6eGPUnMfOJP23IKeugcbQbY7SH0IDtXZ3aMSTLXY3z?=
 =?us-ascii?Q?mDewcGwDktLgvmNRITH6zRgcrTSAZM0zEjUoy7vKMq5wGaArleFYBVLxoNmf?=
 =?us-ascii?Q?z+/kxd423/WCixZSq41NJMFl9YGc2TxyHcTaBeYMxUcdyZexh0z3F4G/V5jg?=
 =?us-ascii?Q?5VYgc8ks88A60e92OBzqzaHTqkqLqsc1ri4LLty9HdaWEaAf0Ddhv7b2qCQh?=
 =?us-ascii?Q?K0wOmOvvm0PB8TT24EePLUcxxaGeRr79QyJf+VaJvXuF00zm97Uqx/GJH4KL?=
 =?us-ascii?Q?9ae4/B/50XZJLOjtvmzZE8KWgAEPJlk/pJrelz9V7voBAC1uyH83hyItrKSn?=
 =?us-ascii?Q?mdi2iTprXOGp+/aap5OIH6M5GmaFmiulAfTMfgXhqvqxFToLgUQH3aNH/XEX?=
 =?us-ascii?Q?NRMCt4adMO/QEdIxbVvQxthWI76jCGswAEC/JJusiYriVDvpPY4S3Rcue69e?=
 =?us-ascii?Q?zWppZfd3+dEsf/S7eRPNWlCLFJ3uoz1pIZ8HPe2rXgNhHoiR2v8y1rU9L+pO?=
 =?us-ascii?Q?fMIKiUAeB+ADHSA8BP5VwyG3FxU2yti2uF4yVxZzXAIg/z46E2S1ER2o8Vcv?=
 =?us-ascii?Q?HEdXFcVmhp9/xcqtkGBhLqaebY8KSH4uydB2nx8e2JOsZUD1ZqvOJzeSHXJi?=
 =?us-ascii?Q?dOVUZtuo4E6h/1X8Wkx707QUwMys8mTJMzgU7cA63j2xdxSi3T5Vgb6xSfS0?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eBMl9zqdExrzUqJCpSuSpOPSPFsV5/DbixVhLkxqUCo6MP+xP/7Fc4AwPsBFkomKiyl2KGmMC4JUrVzhZ/cHdl9wg2iIJb40/PmbVn0YBJKeyDar+FeGTvM+ntgwCEkB1UTKf8ua8FXscrevIedu6MLgOuHZR4IPkX9paRjSTaKN6QLhVOqlotoDVkc7eHf3A8VFQeSS7hTbZdmwPHaMZHP14XVKPYHIU/zeSCDVXOLVjvRhzkxiSb4RQIGwJpPUHiQWt3Giqwbi7RUnEN3r2K+EQWhjKVezam3lpNRIwkxQSh8gBcsyhArwi71q/ek6vSiWbQXGGqWWhZU2ULXuswKqCYnTbHxWFr9ASl31xlivWgkZX0fniOrKVLTLpIW75miCJIVj+9+jVUSNp5+s3r9FDi5qAV7dDnXmdUB2t79R0xjtpW0pzSMj88ZCIqZFQKLSXeuKwj4oPFDNAAwqJ2moGHITJQ5TakYSncK0GDIDbeF0qrJQOXYsXIKqFOkiMtt2SBwC5JdNEFgRELv24U0Qf/8L7IgZzZV3iKe4+T2AhU74RBzQPvzY58ji/mVUOwl71qS21kyK05fytaqxNGpeV1qdZhjEfz9NkzvTO+k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 885a243d-f50f-4217-c1fe-08de1ef07fc6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:59:01.9562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JP1F3542YrMLjK9ItNev9CXAemmlSspUgnjyzK9PAJQTMWd5aIPkHBFhZBYzvOZxwHjf817tsaP5pv83fp6GBucAtMyfdOOrkj+a8amoyr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=746 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511080145
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxNiBTYWx0ZWRfX1buBalgJP3ME
 Lkv4M8W8ojUdo1X95JgK8lhrqGdhnJedTbWD+cVg85ZX42UK3nlOjMuLt8XZEyrBfV8IO700ZLy
 UrXbpeGHt2c6Bsgeihq6qzRLqwY1vExC18GmfjNf2SxM7DY+og+jMnoFHJLnY+YdAeYKr4aUB/N
 L8mwUkbRRLi2DljwPsrDbXqMvtZZBZdI1feHZMBfYe3G07VLo2uGam2N9dMsRf8VRrvkwDOJJ4R
 eXUBk/m0XRFUTpoF7evR/8d11OH+FULVdEfZmkhhe3F3CS4hkBe67of6G7zf60EWyLYMAtJaJsn
 YDkFedfravMVPgnXXOaiZ9nJSxjJjZwNZZiO7qhLaWO+LqHc4a9fGwEVCFnsgbDyfBDU+2y/7O0
 145+M1dQZYcLrBNi85+vWYZ6QiIkoRlr+ZW1KR838SjBqeAcdkQ=
X-Proofpoint-ORIG-GUID: dkGPDiQGD2XnE7I9gry9egAFa1U8FrF_
X-Proofpoint-GUID: dkGPDiQGD2XnE7I9gry9egAFa1U8FrF_
X-Authority-Analysis: v=2.4 cv=eYgwvrEH c=1 sm=1 tr=0 ts=690f84eb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:13629


Thomas,

> Restore the ctrl register to resume the TI UFS wrapper.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
