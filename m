Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861519ABD8
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 04:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768623474; cv=fail; b=snNN8G7ufir8ISl8a1WUM4oQlsMOGYtU0IMuOrF58yoyy2OHGAwaS89SXepMqIE2cV9WBtH4zRdyfREwUQ/nAcm81pEtXl+v1JvTESxEoL2ai2X5vw7AJUcuFy7P4qHnnFZ+7OyB0ghp5Id19lj/W99jWqPrs+6l3M2EyunmRn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768623474; c=relaxed/simple;
	bh=U6A5uvVm7ui4RaeoBEVJQsMdJLrULoyDDHMvTIJ/Naw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=B2Ydw6ghNYzFtoQrxEW66uCKVfPIDwThwtNPF64HnE+19EEMFK826cFrf86iKU+LeSxe3MsrcR4NI85YyRp+ff+FsneMlhJUUyU8zPIjRItimcLxQoo1oYkzrhkFGv+N8DI1CH5qD5YvVNaDolxdUzEBzvk1BoBI+BgaCjePBjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NMu9Hprt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MKzxNInP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NMu9Hprt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MKzxNInP"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H3NxVe1035757;
	Sat, 17 Jan 2026 04:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZgCfY+xuRLGSFBdzTl
	ZuQtRu+N5SMx4MtcRTOSEnMP4=; b=NMu9Hprt/ZxY8sdYzmQ2mmgUoxLjJJ3qqB
	EObUKY+Q6bD3UOt2qlLkKE7R63pq8k5RiHJOhQ0WcUKXoICMj8WJM1c4QsSBUC+A
	FrXUt24KDiqXDgrga7+PG7hqMhQc/CDoUvK4v3nTd/fxR1Zfwrgc/L8UKgUVVBm2
	jiRKx2UR27gZaoRJ02Zul5I0KvOMfmI3UOgmA62c8aoxBsX2yGnQV4Hu2Jyl28jd
	t2JoqPXATA9YqzMoIfDQ77genDywSMD9qNaCjA0krrFLPbK/GeRLbSonFQOtnurx
	FUs4mpBbY3/UmVTk2bMDe6m4AMzg3C511txR4/ghJRY0mDqhhTog==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa0137-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:17:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1YB2a022610;
	Sat, 17 Jan 2026 04:17:47 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0va3a01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:17:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPYj5/oSvBBRrTwvWkPCazsvq7zwo+0xSXK3LOLLHo0GDmFz6u0mna72b8hkdGFihGrzy16yifTebxUADubuA1YJU+TKjCQnTQtuC4H0pBOJiHIRJRPrQLeHTGz9mzDvARGEQHwV1xj3lWNt58xuSNfXn0L2qwB4oxDH2I2c6NY2D/2uaGAPIMS69JON78CSQLOqfBklXTQi+3zaAzpiaBjtiWHXRDVE+0tG0WD/VCyXFZMfAyRhCyr4m8ZSLo9Q1KT4673AOghI0AwsCpgFtkM3K31yEVnIJgy9+aj+0Nd+yZx6YxEnFT4bHBWLUlZiNdqDb6sd8odZb25wLvXeKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgCfY+xuRLGSFBdzTlZuQtRu+N5SMx4MtcRTOSEnMP4=;
 b=WtzJgxhmEHbaxAsCh12ukdcxMybHkzyAgec4vHgh3MovdEBG7GEPGuqurFiCfXWhH9YQBTnJT6W0+XBK7ZQZTOtfamvXGw8uW/3XklcOpy7Pl7NXidK1If0Cho1E/Ng+24R6aT3VKxXdvk9755JXaeQszide/b4zgeOLbfbJ08dejb0kxJrVqho+5nlaf31j3yfRjcH9pRiAr2WiufzldGI1Y+482+73PqLOcUD6sUgWUCVioY3PKbQKMwhySXFKdRD6v/u3+Rhr1KD7zPIHLg8hlVZTqV2iLDVvzFPM0acrwCBNkMQrg687yxu+IJBezKQbJNWrYy8WS2ikYq0M0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgCfY+xuRLGSFBdzTlZuQtRu+N5SMx4MtcRTOSEnMP4=;
 b=MKzxNInPaCV/kc5hlAQpBdUU9bmQyIDOz7VfJ3RU1YOKohwCrKGaeVk0BgvYEsJ1+21Ul5POsUAxB6LaFjeWD/A30g7sTHbGUm6yX5/2kwwjUh0oLD21g3a/Ram/tqTK3/aYZRdewDM/uMai3HBe4ZYI1TtBg5drR240UlfvLXQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPFE2CFC098F.namprd10.prod.outlook.com (2603:10b6:f:fc00::d52) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Sat, 17 Jan
 2026 04:17:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9520.006; Sat, 17 Jan 2026
 04:17:45 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 0/5] Clean up the SCSI disk driver source code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260114175054.4118163-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 14 Jan 2026 09:50:48 -0800")
Organization: Oracle Corporation
Message-ID: <yq1jyxgj2jm.fsf@ca-mkp.ca.oracle.com>
References: <20260114175054.4118163-1-bvanassche@acm.org>
Date: Fri, 16 Jan 2026 23:17:42 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0134.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPFE2CFC098F:EE_
X-MS-Office365-Filtering-Correlation-Id: c63da47c-1048-4f9a-2085-08de557f5d51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wHkEC8LCwCYfXR28JKQPiFs2m0oPYrWuKXO1IIc/TGBTdXnH3Qsbro0kJTmT?=
 =?us-ascii?Q?ZdMJAU5lLgrPWrox+qVw72DNE5bxY6wqEDmosXwa+fFbiz/w7NsJsvjS3a5w?=
 =?us-ascii?Q?UguH4AzmwMQbed/cyatQ/fMNW1qH/v5BcD9Zn67qa8kLbtKDmNS4AmdMYd74?=
 =?us-ascii?Q?vTGHqJpELFDCTX4iBLnd9Zpn0kLFU7OgYOmgvDi3YNvC/L1bc2iHMeodXivu?=
 =?us-ascii?Q?KHdF+Z72C6clVgfrFxPCXEbFqrU/BHfgOVro2oAhATPT2wuyBwBKdLHgchSU?=
 =?us-ascii?Q?XN4MBkhxRjkoqf0R3BA0Bo2boocvhVjXw3B2aC5mZRV1mVijnWLWj6tm+nXz?=
 =?us-ascii?Q?4wwFENdDCNfgoinYjhyYPvEkOgqMwnOP22ZjO7fx7lIvnwGHaSS4i3jMJgJr?=
 =?us-ascii?Q?Cnka8mjN5pOnSTRNNJZdJigDv25ycUoA+qXH7VsgnKe5SBV9pimU/Ozvg/d1?=
 =?us-ascii?Q?NCLI47lFBcZVcYKBJn4RjAzBqb+hZtfdImnOScH+/nWl2amJ5534L/mFFqe+?=
 =?us-ascii?Q?xWkEsIhjQPmQKRyNV4virQueKd7mzJA5gGXT1ls673VXggJARpLlUOqO8ZJc?=
 =?us-ascii?Q?/VwaN24bBtGbu0pyLZQpj+is2SvSfyhLOUTbu2MhFjSKJEmK0/SSx70gVb+/?=
 =?us-ascii?Q?OPefh+Ni0GSb1soNdI/X+JSJZDDaOEgr44hqX2HnJozpaK2DQol1QgHnYfgG?=
 =?us-ascii?Q?lsQ3dpj+DA09G0yUl2l42S178Zl7LVDv8RSG9WlOzubYBi6Ww2Zby9KywqOj?=
 =?us-ascii?Q?FX3gkO2o7mMyuTHCwcy34jIi2GnXk5VFk8EVqNr8eFmEtzTyIGYNmYzLlflz?=
 =?us-ascii?Q?5sjskjFXKTkp6ZpgsCv2YO6eYILz4OCPAptMwWWILkAAU1Wa0rtdsqc5JoWA?=
 =?us-ascii?Q?lGyTOH4YUdv8qZO8P3dgkd79SgLJIjkndkg2ouYGios+JkyzO3P2Mt6ALeGy?=
 =?us-ascii?Q?wtnWIk3vYSU/oAkaDbhB1kfljbbApv+bEEskCRinfFDlyvipRq+Q4zsFG5Ow?=
 =?us-ascii?Q?PWnXaLEF4dQeD9t2qDMwUHCDFMtRdtUjB9Dc8aUwsbcCjIQzy03uOEDoowOQ?=
 =?us-ascii?Q?SS+3V4spuv+dq/Ogva/7Wx9steUPhZ20zO9RucsgW5C50Uml10MAtz5QWu8F?=
 =?us-ascii?Q?lYGlzYtl15C9xBpzkjTWbybvkq1iwQawtz3G24X5zpDy581sFcIHLtiF67x2?=
 =?us-ascii?Q?SQGEc074FVDeA34sJ2SUBzNqfGmqOHmQK7PdvtOLQLCW2oj9jf+q6vP1B2BL?=
 =?us-ascii?Q?ebBYYHl9AGBaNPZkp70atNvdzWyqNTJqWatuTtE+ESmpqRxGmF7prSpmSgQl?=
 =?us-ascii?Q?yynQzBOdC5FRgqP1v9rTQk6slagrtcS4zPnSqSH9l61tSpWr8Ex4yTBL00ST?=
 =?us-ascii?Q?3Jr5FX2POhleGZSFLWyy7sICBD/8w4jyNMWOp0UOMALDlkCHtuZAP2wXLRpE?=
 =?us-ascii?Q?W/Apcd0d4IanP+noHP6Eq3nkvSk7yQZLue/jyhVxfFxqSFF3SAGyHEjfuY9r?=
 =?us-ascii?Q?Dqgrdtq20R0seQjSsWkVfT5AU2ltEpuWKgl6gCyGcvPtg2X2rSxLnzY7rf1W?=
 =?us-ascii?Q?liP1iOFj21qv92ZsG10=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IA+7W32xf9Gk0k3/yRf1m295K8OAe3ZzO3p/5KtLF2l3Uz59LUU3e9il7y6d?=
 =?us-ascii?Q?IgAwAADRK37b5XJiRIuVuBnGYYnTuS3PEKZcgTdO3t2oiZ+QXnEhLvzSa8AG?=
 =?us-ascii?Q?B7MqpvAY45Lp70wYlOog9qfr+UV/5wR3RqKmkOP+aEIjNl1B3/QmLrmpTOje?=
 =?us-ascii?Q?9d/Oe/mw77txB6cg6j71QYaY9CooDP8P0Fa3aVEPOxuMEPoQ2OTOfS7BQLos?=
 =?us-ascii?Q?8TVG49tpcyf4rH6vIcaHewiKx/5sNHc5bgX2Z/z1r/ZgBUrG2PraDx1VWKWP?=
 =?us-ascii?Q?H3mcXQy8lVJtDGi5H2xUCq/QvY6zG7FvqdaOyedXpCRj5X/rpbWdNGz/0d8V?=
 =?us-ascii?Q?PYGi0L2BgTp/2c/1Q8ZCV4Whxwsm9ahPJZLQZf3cs5UejDZTk77YmZEEKbN+?=
 =?us-ascii?Q?kHGcIaXD1uzSjV/JEx38PyjGOVjbHLSJ385L5aUKaC9ImoP4kC1XxNP7Csna?=
 =?us-ascii?Q?WOKWgkZxpekQqwOLIfE/znHwqTQ4M6uL3u82C4IZz3lo+eCFiU72X96VQpiV?=
 =?us-ascii?Q?Qy4WT+MUTO/Idqx9trNcOEOoaTLpU+mMV866q6yTx5U11vQ7JL9dcNfrnFSn?=
 =?us-ascii?Q?C7xzRz2mk4MeF3Pd1FhGn25o1K+9dTm4C48snUG7GcIy0Czbre3l9pHqrafr?=
 =?us-ascii?Q?r3NzA0ofelBKm1VGt5rTceD1xIjhofSq9KtzTJUQve9h6HIc+NddpNM5FjUL?=
 =?us-ascii?Q?8onzOGzgpdI0T15m6D6Hvl2DzTulSnXI07oQjkoWL0z//UacAzKrHlrDHTg0?=
 =?us-ascii?Q?ovFsyZwAAXZaDtqYWdBY+GK3gyhjUwpn4ObXgMBHf8bZdi9UqT0Gs+LW97YI?=
 =?us-ascii?Q?EfSxrWGJQfzCROrW/dX8UXHw1B9/cEs2o064bnT66JRQ09r27LNp+LwxR35o?=
 =?us-ascii?Q?AromZ4g7v3xMERMPpUT+l0NiXTFSAON4Mx+JzHOcm3VOb6WQ4ZEIk+Fjb4az?=
 =?us-ascii?Q?JogcyjD3vMBpg4PQ/jmDh1ocubmYTOko4TBGdWvJSGphvkkP+Kc/6AjelEh+?=
 =?us-ascii?Q?K2SbvgCQKdQfOn+Y9yUOeUkmu0qAkv1Ka1mAJwiwqtkc6iEBih5/lsF8tTTK?=
 =?us-ascii?Q?uK2KaoDeAPKaKNjLgyzURrbTPbUiMiqyoncLafMg32KDntCyNfaqz5opcOi7?=
 =?us-ascii?Q?7Afa3sgg5CXKOT/7VyQRNUi0D9HCEKLb97EfiT9VmcXh90IKYp7j55mfk/WB?=
 =?us-ascii?Q?OTjDcXG4H+gWIAkynegGG8pFix5lUnRGe4fQIjgxjwI9zTY1MOeI95EkyPU/?=
 =?us-ascii?Q?lJ7LkFM3L+ngsu3cozuvl/tj+6QVuWUk0gtFyed/kPJS95zJohkEDaRPA0sq?=
 =?us-ascii?Q?kioRkAT6apScvBx4zThnle9/50z7Ysd3MQ1ix3zsH1MMk6r67nA/58lAb+fQ?=
 =?us-ascii?Q?WWZsfsMPmDGaY/tY9WDRJdw4/xoI/K9eIzOkSJxAkq8P82kU01qL+5duJL68?=
 =?us-ascii?Q?YaetM5N9kCDoLkaVxTKLK+Cbe6KmsKeFM8Wxh0RJGCEUqHqOwSa00pB44YV7?=
 =?us-ascii?Q?OV6a7RS7PIy6+b4NPGyA7mL3H0aHc5iqyVVwNbeoEu87g3Bo5+PCqI3Je7mK?=
 =?us-ascii?Q?B4B5GBC+6HhUd7sFDTORObdVkzjJQnWlX246hNVAFdlvdn4t2IWzl2gIpOi2?=
 =?us-ascii?Q?NLEe2lVKBLoXc+H10jwnLBzU1vf4qXEvwc985tuFFejtJFmArSHPACOdb17e?=
 =?us-ascii?Q?B2Nhp43QJspnQb0/nH3SjAyNXbmtPObNXDXvEYK5u9C7xQeeJDJIRMb44yq3?=
 =?us-ascii?Q?de+y8+LogBhWX6mlPyPrhgF6obViJiQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4VW3mD9/MejGfeLsO3d4v3rsSmWsnnQoSJtlNZjiH4WqlJu08w+TIzI2YhB5re9Vi56q2BvRxuqi8ItnKjKPR9qk3Q/aKqVruPoN8xBDbfGHscDH9b2ucW6AssiFUzCeZvabdoatcItSCN8yMIKZy+HRjk6CKabiDqUFku+ymleMB22c+KjkBwNn2ZQkjOMwklh2bOrKy1aipjJXiP3kO+tGKSZ+OQwTkuvUPY3NTtsxBmSrJq4wA2GB5eMvG1Ciynh9w/CEVGCSFwlWKGncNOKq2J+C7vyMZVWnIO46lEpoBhjYHPpwHLimG9bVYDajGswAaUbtw0qiNMonVZkZfGG8gSlsGnhzw7cvilXO8LQK2O6QCmHl2N9sLt5lDaISPl+9CcWBjSNHhSJcH/bfWEyGWPtH2RFzMY8CNVV0dFDsaO7N8UCuQS1EL7KinriDOKedA8vhQ16z/J5z+f/QOXochnO/elHczE45325kqV1fUjf6GgV/Hs3yqckUK/ygJbHYt1KSmH0B8021opj2KFt0jeWX+B7N4vJ83oIzh9eDszcDfyQeGOiLnyTUveucjF5fOCvqDU8sGnygyrSHt4XmMwrBc8s2kIs/YO/1en4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c63da47c-1048-4f9a-2085-08de557f5d51
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2026 04:17:44.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErbpntVvRD2hqApSqGbbgATIkge/KqL8ta87w0oPQ8wK0EwpQt9Wi1dRbWGThz96UzW+H61IOOEbKl4WjcT+T1DJHrqyi5sv6FjUpPrx9HU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFE2CFC098F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_09,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=545 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzMiBTYWx0ZWRfX5eTfiKcZZveN
 id336rb+KzwIZ2oWohBegZXMr8KDpvAI+OM8/YBbJHu5tz9oVGNJdBGLxb7QSz3N8k5McBfUUIV
 y4C+XNVRYWzGMzdQs37z6zVzfsElbrWwrOlMD0e91Ij08/Kqy1xyMXZdd/DFnGk7zY3FkxmOUgA
 2hPyHFGI9+ntSBIKMQVGyCEBs8BjVyJST+l/u4eIrS/+IsLpjQgofcN5iGev3fHKminsU8Rr3mY
 R5mwVp4LEpITIl+y5elSpbX96/uNfJ3PGwC/YYeADSJfqTmvSzufqXh3Xa5KQa6jnqWlL3XEJR+
 jCPFF3vj8amm6ciUCKToBQG4HHkdMr0nuWsDpFnrXeHZ1hjLwcNiHbTMmDkk3UY/ZbvDy/ENfIL
 MLJ1UN+T8BmAW9B4XQnJSbxJaJjpGK/6T76S+lXz8C9OL9PX0msSsJzgKfFfgeZJpD4lfuwuoV7
 tLMp9b6r9CMV1gPagvVZSiJ2bbDWbUYFlqumLwHU=
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696b0d6c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9 cc=ntf
 awl=host:12109
X-Proofpoint-ORIG-GUID: C58D_Z6JmYuVuQxSzwcKq-QZMGwse20r
X-Proofpoint-GUID: C58D_Z6JmYuVuQxSzwcKq-QZMGwse20r


Bart,

> This patch series removes multiple forward declarations from the SCSI
> disk (sd) driver and also makes error messages easier to find with
> grep. Please consider this patch series for the next merge window.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
