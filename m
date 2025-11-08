Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4329D4A33
	for <linux-scsi@vger.kernel.org>; Sat,  8 Nov 2025 18:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625991; cv=fail; b=FovrU2y5UzCGhlmbjUaSoyNg6yCmAUbnFdJVMT8lwGXKo/iKLcFmB/yS3zsBZmH76yP9NIy3weUF8tfW6iHkJlsPOHlIfbX4dU0tfpIucab2ts2mWM/gFjkLSKGvUGXVJ/LgQm2e3UschjB+l4z3teQHHsT87YJv/yHotpp+RvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625991; c=relaxed/simple;
	bh=RInbWhnqqEuuNafTyswWKekG/oD9MZMBPTdQXy9APwY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=F2sM4EFK7R8cV7LYbiRX7hbOM0Y6R1dqsTdvYqtM1s5nRhhCxrnE9lue/RQOe0MpqHjtEBVoIOSjEbG6goXp9ckjcT1JJhl+uPpbdcJerOBa7d19curcdcFsXkA4QZfGebludbQmr9Ab1et/4QSg43dGBcC6oTeSZvpziKsGhUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=APGmPw6j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ISvIdrgU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="APGmPw6j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ISvIdrgU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8IGGAf001168;
	Sat, 8 Nov 2025 18:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=P7bLn77kIhOdJiVjVF
	laC4EpvD/5Y5B5l5/e0+ZrqOo=; b=APGmPw6j5vkxxfQomLROyWpnanNKSvTxXB
	55PUI5hf+NsA1PUY7MTZFV971hdMI8fRCRKoettAQ0CjTccCV7XWguAGL81NKkEp
	mlA3IfYwG+DMiYcyBfPHGDoNvWCBINsoFA605VD9Ddv8MFnqBiDHo4b4LpNoceBh
	ZvaPgQ8QlLder5PTmiaz8E5no+FaVdc1+4VceWux9mcjUM23DYsJrPOzUJm2eZiv
	DRK7nhS/WtZTbwszAw/weSyaqlCk1bVQfnbvE0b3nWUPwTN8BTQCU62tvGu8gg+m
	sUyFegYV75OeUeeMB19OkOGWkeB7rwtjDSwMYldTLWQsoAWrubeQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aaa19r1gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:19:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8H0lD7010012;
	Sat, 8 Nov 2025 18:19:47 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010067.outbound.protection.outlook.com [52.101.56.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vagfk51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UIMVA7bmsOHbOfrxNq5C/wwc7q/zirBMPXp8xMyE8PwiIJs1v4013Tsio2RS7gniCgSOJ4muU8hq0MXaVUtfqIe8KnLWupVpwIddyQRd+Lpvj4hp0LnYBbA39EF5Jv7oEC2IhRGbE9f9NYR2t8Mk2vxled4r8KhtsFppP213TI/HVMDXB5RNIsr/xf5gjvTLpXUWOucMX396p4+vZoxmcLh5xKaAklcrqVTf2Yp4x84ssdS7CQUs3I1f8nuV1Q/5inhJeVpF3f0gGi926R/xg+oSlFw20CSPrHX1Gtw1qhJE1hJJjLyevA6CpSFo957ojZlI1gT/B/CvMXFWor/Dfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7bLn77kIhOdJiVjVFlaC4EpvD/5Y5B5l5/e0+ZrqOo=;
 b=MITqxQscnhPAZmx94vozC5h6JzW2qcn11+lMAmrmkkRctfByn+B52x3OKZsMhXRn9y/zv8vyWFuhDCGuLnm0CHTKAVbPMswKvsDE0vRFE9fkuA7xPqjaCTA3ZB/CkXXBjfP31K4eV0eoUmpWbC1sj59U6jaa6L+ymLr1ZQejDOcF0ihdEQhy9BwdlbKiVLyTBTz9AUp7yYbsRmytVg2nNrYmfx+lzIOUrYtRVjrJ1pn9EQPB89WgRBu5MffwYJDFYO1bv1FSEb0+nHEtpUZQ3H4S+yadNxVybtb7fX3K903O4wc8MXkitiK3F1CnUqoTYEjzatjn50BREkj8NNnqcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7bLn77kIhOdJiVjVFlaC4EpvD/5Y5B5l5/e0+ZrqOo=;
 b=ISvIdrgUD+jEUD6W5c2JyJt6qqok656rztDKS7nF5B4AS+KwYQC6gHyTjjF0nic2L9qDo6ydZojtHtmUZxf9i4zadapl8fp1zKKbOUK90Wvpdphe+HoqKdW2++9WrCdT/r2WMVuDE7+UqDbqY0w/FrEL0xjzuY7n8imBV92r+fE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CYYPR10MB7568.namprd10.prod.outlook.com (2603:10b6:930:cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 18:19:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 18:19:44 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH v2 00/10] Update lpfc to revision 14.4.0.12
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com> (Justin Tee's
	message of "Thu, 6 Nov 2025 14:46:29 -0800")
Organization: Oracle Corporation
Message-ID: <yq1qzu8gzgt.fsf@ca-mkp.ca.oracle.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Date: Sat, 08 Nov 2025 13:19:42 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0079.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CYYPR10MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd7d1b2-3383-4f5c-0f93-08de1ef3647a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VZdmhmE0+hWeiq6aV6Kg94ZUAc7VMCiQTOwrYRMImBJJyb1CEDVn9le/I5Aj?=
 =?us-ascii?Q?Na8vuW/2hhPrS3gYwxxvaf06EnXb56PdcNeFW3KimKqYbEZTIsJFYbUDLajQ?=
 =?us-ascii?Q?mAPdKHbHqP6VI2Ym+phH7s2/0PsCX5pGvN8+TkNLyShgrYX4KaM//v0Cr0pq?=
 =?us-ascii?Q?e5CVzTkPpmD/YkELYFVLsC567wD3714cV74+TUc42BUdY0f0pV/M7n14+7y8?=
 =?us-ascii?Q?lqv6O64wQB+3f8YdRAc4FrFAXcBPHIPAxG+GbTn+aw6rZUZReboZbULVGE4q?=
 =?us-ascii?Q?aGCdjW1nX2sLKKxQcD9uvAUidJg6/GsF0LwngwCBDXfNcTm40XLbqsu35PMh?=
 =?us-ascii?Q?BgNFiPapc11cXkEtDPNWGAfdbKB6ALzDulgI05cgJ82T7NqJShN8HeRLYgLP?=
 =?us-ascii?Q?Sdlg6urk7nB68Fo92lbsErcwfjGP6oy08zk4B4InEkj6eeDMGf5Qm6hE0Wth?=
 =?us-ascii?Q?eTORZ1ewx7rc/iPvvqGi/fvQKsNGy3Z7gtKIPg4TIMZcTqvsCfQjf08MjEG6?=
 =?us-ascii?Q?uYnWEtwofSFZqZkzGXHfV5VkxWakleKktLOPNN5XVw+ADR7tLzDiB1PmtWp7?=
 =?us-ascii?Q?6HTCiVK49R2scxYpY68OosKOmw9lDl+ycL9Lk/O6ubwHpCe7a8e03qYfWLg8?=
 =?us-ascii?Q?4faK4pBC+xGjCTJFsWPvRw5mew9tfQo3amJpjWedfGL13SpEvED/PPRx/HzZ?=
 =?us-ascii?Q?/XqW2ZghBl8jJ7bjiSEUoEBhnpw5uqEojCpb09aNjJcwZ3shppWuoq605t3W?=
 =?us-ascii?Q?RIyerl7VESOYOga18ATDIXheHDXBnQbUmXXUTzuP7VjTGvV9b4rsVGpB+Dod?=
 =?us-ascii?Q?1LYROwC7fHe/BXLb0sEcPyqmTBEbNBNhhjnaFib+Zd75J1/9zRAPiGhmADXQ?=
 =?us-ascii?Q?g3ASa97YdlIEJ42ot8SadzoPTiKBV+w3NasTz5ADmGzB++Ia+k1BQwz+0Aiz?=
 =?us-ascii?Q?5MPbfgD++g+kksOR3qq2hQztDmbLwgukWECFu7j5QeHd5gjI3Qr65XMpwZQB?=
 =?us-ascii?Q?t1Jq7OAwCxo20cYi4vAoEfO+gisnNvS6+bsW3JcSQ7rFZMJsx/hPt9GdM0v8?=
 =?us-ascii?Q?mqkxZXwuVbFgNHLzMa1HPSbPwtZppQsWGY9/Ig59qDmQiKmfFzUGJcOc8w5i?=
 =?us-ascii?Q?bY37ejXXDuuS5s3gf4CCObYt6A95XT4pcKTgiuboR54LFly+va/Ztqqe7xJA?=
 =?us-ascii?Q?wtO6o7gm3dkJCfHMgZFcfH1ThPvm9BT/dDPSA6lyMs7z5lYsU4AYcGPjVlbA?=
 =?us-ascii?Q?9nMgWHDCG+TIl7AO7hSb8d+v0zMDsegeoObYFOVoBqj3BuHjbm9dUeTnZDfw?=
 =?us-ascii?Q?3MSfvD6fG1/hs45OPdC+caADEy/Ryqy6k5aw5BdN+Kk8CnOPetX2oey33gsQ?=
 =?us-ascii?Q?6SCRp5jVByQJNAHDnHnwTQa+wEXpXUVEgvyd6ilszoWqlK1uVF9bXD5DAvPJ?=
 =?us-ascii?Q?zc/oPmf10+ltrzxo1yJg2VsKvoqRVfY7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZjwP9+bSoKWIxdOnX+Cj1QnL5xiggSQrp0OgRCbMQFrYOmtA6/J4pGxYy6fF?=
 =?us-ascii?Q?A8A1cQkqrixxQ0h8Zw1b2YS86D/UBT8vxt5jOO6VciTX73JlSSizuVJZ363J?=
 =?us-ascii?Q?DSWj9c7OwsgmiuLhFk2LZbFt7d1+YQFMKFU6U2xIGrckhS034ffXDycENqzQ?=
 =?us-ascii?Q?45bRPchURk7qwNDeaBRitiwmgRVuvUZF4xTlja+W5utuM1+PDSXJX2GVQxa6?=
 =?us-ascii?Q?0oy0XV5qTXQ+Yy/9PG1/o/AWmUgUsYj7e+1jtkLNX9r2j2yAR1/sL0UZHWFd?=
 =?us-ascii?Q?1WvuF+nBkO5xxhonrtQe8prkZf9xDf+VIb0LQ3PV9U2U/E6EKZ0cnR+iIlWR?=
 =?us-ascii?Q?TW/Km1SCsqlHq96+xPVqmxSWOYuAPEQZvKvGDE6ffVHG4F3yNamfZu8xHOzh?=
 =?us-ascii?Q?mnOy4V3Ngd+r/m2nrMTScBHEsTgXhDV36qV94/2hgSAKG652KT0XISQFrRpi?=
 =?us-ascii?Q?H5lIIEERlAP7oy4m9rWsOVpCO4JcE/w/OeftEVR9rXfzs6oxHcUu2RLS4xhZ?=
 =?us-ascii?Q?hFPL+wP9tEIlCyaJ9MEuNAtQolKXjNhoQjr1/oefOhm9R1CzklH+2kl6OZpB?=
 =?us-ascii?Q?S3yEXr4qhiJ8Rl7qG+tAd/4letTkAVS5WkiIatjPcE8wyll+6ALJwtkFU4eA?=
 =?us-ascii?Q?O0YRydEI2E5CclMvBfDBZXqpsfpDOyTlfYfIO+Ex65sdxl69Vw39pZw/Wqfz?=
 =?us-ascii?Q?hFCfdXcqCiMzlPzr++Flb1zbDP2H45AfLWuLmdHQgQKscZ/RebtLxjp+HyST?=
 =?us-ascii?Q?pGOZpb7eoqbJrCX35Y2odVXb2xIA/GqtPxVhQe/ZJXORpmkmB8WROonQK8/R?=
 =?us-ascii?Q?o8VDuZDns2YRysjyELT27T2j+0wcAM4m8i6b2ub/hwIedQMSVYTC1uO7c/m/?=
 =?us-ascii?Q?38qrVSW/y1BI/AbJen4Ra2yXaZAhg/4+WB162pdkhNRe0sPQut0v15dD4Du8?=
 =?us-ascii?Q?LheG4D7mgv676Iq8gnUmlRrDSGg3AHkTLeuE2VDFwS+MkYsqdLZ3T5DLvtbB?=
 =?us-ascii?Q?wmgJ3SD1yWHBRHF/Cyg9KQO5Fd2vHESC5CPvluDdVOiwQ7UgOoxARgAWGK+u?=
 =?us-ascii?Q?tyFlZUAA//UnuPwbYAAzZAFCoT3kjd9pBMSUVVVqcbaz60n3FdeYuqHImvd2?=
 =?us-ascii?Q?1rB+NUh51CyZQca5zfoYYDDe2WSFYOqg3nJK1xSIZ5jZrxy0z9UFSZWomfGz?=
 =?us-ascii?Q?S8Lis6HnuH7c2M7kcMSjreNpVECWqHGMzQDwxgbX42K99O5lj8ScdyBs2ua3?=
 =?us-ascii?Q?ewA/6UOPgAv2p4D2OQ/rBbEz5QMOOffGc8/42nks0TN0aezmV31Ar5OkLE/P?=
 =?us-ascii?Q?pumIZdCX0YxDbfrRyLmlyvLHmqH/AYi0TzfSKtT1/z+JvUQUrySFEDYbqkU4?=
 =?us-ascii?Q?AsvkrlBlqMJPQrp7RMfT4EoLW3KiVhQrp0yNPOVAET+b16IQ/8fErC6dW1Vf?=
 =?us-ascii?Q?yqUiygH1f1w+yms7AVYh0wYqJb4C5h/216MYgf9+wu4lwjho6MNJONn5ufkm?=
 =?us-ascii?Q?nVH/Vs6fu+xEyJntIJaQZbdI2QYPBr6DDYOCKZMoDtO2SKTpq8MxFRvSOGFe?=
 =?us-ascii?Q?zdmQ1v3mIqvrnVKTquscxqeOFexn7JXF82HdbyVMvwCqtXWBRT863WAyzLPZ?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T9rD044bIULqQoIDezs0zrvPsG+ABbT5c3lvpXMi/81WfzorOrNH/3IXOHz52iil7322cr38YukQ03tKtZeLNyj5TGPg9K8MFPxT7sKhve7xvlrM7hSA6UNRNDgEum6rAzsAT01X5KxW2nq+XvtWxqf4JLbtF44y9wu/Ft1C/fjmABqx8Wm/L11KRknAnJy7EBs8p8uMp8m7cZ9iC40moHbltRrCiw7jK2zij2wEkJI6TRzVDNAh3n24zjGvUIXLZ9OANfWFNUQTJTcfzQCo5aD4S27u/kPexAYEqmwKh30KO2bCS07qA+f3bXaufrjpCLnV78hhWJunzwwd4n2aF+E7pPCxwtU6SoMHknVdnW69sU102G2Lth26WyDWI93tgsNj4WiuhvUf6HdKwe0d/ptJ1gEm2aMR8DIgGeajcypbE35jRCcWI56R+n/sxPo6k3pU0Zm0RR2b1QifRVcyK5c4ukB7md1yBiBg/UKDCx+rMN7DtK/kIdhXon7qst3Uyp+gOqaEWUv1cMsWT6It3pRmAKfObRy4PJ6ZMq2t8VFHgCvwpRkQwoZVMZuSobBYvim92mv1R/rIY0f7kdEDfmdzJmEedHF85nfykTeuwiM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd7d1b2-3383-4f5c-0f93-08de1ef3647a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 18:19:44.5892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +K2dPw4tqUNzgQOwA6/kHe3WrZzyVdGQjgTviOrBqJZIv4hRyCbCONabadaqdsG8sgXDeNqqspWMfkq2V01HTRKlhLqkNJqfQv2Lys4kgcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7568
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=703 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080148
X-Authority-Analysis: v=2.4 cv=NrrcssdJ c=1 sm=1 tr=0 ts=690f89c3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
 a=zgiPjhLxNE0A:10 cc=ntf awl=host:12097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEzOCBTYWx0ZWRfX/awsyRDESv+d
 JwFPsuRchGcunSo/JaT0qORoRTc/2TtkAvL4E9cJhpzoN1rw0J+uytUU9clePHZGmp+LhTtO7KM
 8W+AVGmkzWNgQw8S2q2cpcjohQG0KJk6khYwG0tgGGPb5/+8pz3pzdL1wOEaLOsr/89t1og3ZZA
 A2rzgqPN9/qbE3oitjCwrrqTRAXz+mi/B5lcG+mXvS/MoJNTvroUgK9wQoJpg59ikFYFOoHbGaC
 EIyCEzOLWwEBgVfue6dLObUdAKxchGItiZ49bKInGer2viA5LWgGOavx442lnBP6KJsQuM30YgK
 o3aRz+NAj9WHWeMNOh1EyLAMKQNb4BhblUbZz4RfwqYSHl4hqiIHYxd4xYKIlWsCtFclBcVCOi1
 wHXmPiCWsrVHVTuuGiihwgCj3V+bnzonpyIEWDgv3aBzIPE1p5I=
X-Proofpoint-GUID: mRioCuYqHZTVMXFmjtY_YimY2uDOW43i
X-Proofpoint-ORIG-GUID: mRioCuYqHZTVMXFmjtY_YimY2uDOW43i


Justin,

> Update lpfc to revision 14.4.0.12
>
> This patch set contains updates to log messaging, revision of outdated
> comment descriptions, fixes to kref accounting, support for BB credit
> recovery in point-to-point mode, and introduction of registering unique
> platform name identifiers with fabrics.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
