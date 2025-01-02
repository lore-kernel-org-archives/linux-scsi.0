Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F8E26AC3;
	Thu,  2 Jan 2025 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735841620; cv=fail; b=kLmE5Lgn3y0LBptanSFLy75K8RKkvSVJuz2u+i8iHOA1iQxgUWn+xxJiMRzsnnNvsqHgGCacEcVjB5grmraAlCg2we06a6Ncp6lj8WZkZxhO8kAQVFLn1sW/umYIYBCnbO8K//UOqsjZa75jwZitnua2ogVh/OlzJO2UyjXC+G4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735841620; c=relaxed/simple;
	bh=Y7hbc/TZtrHGJewN6iIgCmWLDfGTM0wh6sRvEBkz7uk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sVJtkCE0fuZcSD19KjEW9JATLvmqsSNTs8x5J/DLuHUwZETBXSpArsm8A9qn72xlZyq/kYkrXL2OpMdFaL4Bf7jp6FfeguEN87v4yV4jBN9tNm/PwPW5OwBIPH5NDgxUF2mrbzLBrATXH/bOOReJC77xgRla7FZ+7T1AxbBhsFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eM8fjtT5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PLgVj0lm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eM8fjtT5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PLgVj0lm"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXo5t023845;
	Thu, 2 Jan 2025 18:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=czSn5mwEevcCY1wpPq
	A5WAINjNI6jNlI8QvoMJSsL74=; b=eM8fjtT5vr8oiAsim1KBiM98lnxNAncuM2
	ZHHr5U7utXAIVpEk7T/kJ3OyDf1o+Il59PJFDCdr/Z+fFXNFIQv+TnhOozHOYSWg
	/yGnp9m7rQdQeAfi7AI7StesPvgnE0qzQvKQhVvm5l30Mi6VIrfu/F0WFhFmHaDg
	3Js8Xi7eJrzXc+TzkDLZVu/HAnvt7kgdegbjV7YIG7uzji8SRb18R+RghaxhRs+o
	40LsqTVHNLqDC/dpWA5iUCpE0PG0U03jZuWXbjBJF6P2yPeYBLNbpoaBXJWfNNUE
	ur1qihorlHUAbKr6YNl4fbGgllVKQfaN9gsKV0Mg3lif/jbtF1AA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9cheat1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:13:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502ICD8m009521;
	Thu, 2 Jan 2025 18:13:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8ug4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:13:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UX6Vhfc4BqCAHS5omtupE+rNRHKJqqFA4FNou0R14BMI7k9fqUV/wxSUn3juwrW0j3nTF89C9g4wC19U3bT17zPTZ2AfJx8V9Xeg1DaAh0X0m4kVVSD3Fai6rzxqBdJI/i5GywU1Wdsnt2K1cZ7eD8qTCwXbuLzJrOa3C0xxTKspvXwwnUH2HqXOLwd2x5xrSAmzQHBXkc1vhyvLBrbmtbLEoOWw173ev/9EB56v/ORg36zsmdlg4h0BdGsIMFju9Mx4f4PsghKaP2U0NRA8KpDdS8ER2pWnGUgEMTbMGeoHy7YRpTPHgwaKHBCFiRPp7L74nEljHUsXrFNC10pQUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czSn5mwEevcCY1wpPqA5WAINjNI6jNlI8QvoMJSsL74=;
 b=xsKUoxnr23vWlwJ1ikUSjEo3XkLKZCSfGO7NFcdoPQbD/e0eX4BTNjcYxn6uwGZOEAYQvMVSMrni6LAzlE+rvQMxzFhmdllMvTGFjLwM+pf+DbyRMMw3BJajSP3SDiqD3up45C84MZubLyMTccYTKNuXLTug+SR2Dj9iiEsIpqk3l+PVQPTjPmjgZEd9Q+q75aFfXy9T14k6j38bKnw4q3weUyH0hTNdVNlFw6DZKD6O7Jm8PZcvHHOKSIMDdDAlm0rQXTIbEqgzJf/NSq8ooZi1w4Nz4x9zUWlNJe18mlUo9dxnw/aTdeMVo7gp8opicLPYWiTetJo74u5lM8c3oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czSn5mwEevcCY1wpPqA5WAINjNI6jNlI8QvoMJSsL74=;
 b=PLgVj0lm5DegJgYy0z7hw0oEnd4qE/v64gcRegH81HssTDYb+7MPxTBX8K5V6cOXsE/PcqxNF6NhEMlOlIM1CcE37Ns6aXJmIbGAGuiiXMv9CddfDoG3aHYBVs2l+ivW2CAW1tUyFp5PQVsbzgAjUHBBCnxCnI2AfUXNwwpUp+I=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4464.namprd10.prod.outlook.com (2603:10b6:a03:2d0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Thu, 2 Jan
 2025 18:12:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 18:12:54 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: documentation: scsi_eh: updates for EH changes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241219214928.1170302-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Thu, 19 Dec 2024 13:49:28 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ikqxgk7g.fsf@ca-mkp.ca.oracle.com>
References: <20241219214928.1170302-1-rdunlap@infradead.org>
Date: Thu, 02 Jan 2025 13:12:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0020.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4464:EE_
X-MS-Office365-Filtering-Correlation-Id: 1024aa2a-96e8-4ddc-456d-08dd2b591409
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o7Ycw3Lta5p/n8NnPMNeXjetNNopxak95BS+ZpxHmepi/58hafkDawrk5NDo?=
 =?us-ascii?Q?yyK+7gCOAWNxUeCrFJl8hJ9F+XPiiShEYMAyDetN7JPgT31E7BDWdJkwV0TS?=
 =?us-ascii?Q?m/Fm5h3PLddPJb+vhOurJE1XKXaThf27u6hBSF6g/w3cwMrZ1p8Q0vYgHVl7?=
 =?us-ascii?Q?ljbM0KINNJvEFpWuG0WUPEYD4toGqLQ14P94ruj8Up/9t0Ix6UKWup6BKV4w?=
 =?us-ascii?Q?FwWV3De83AU0qmIlTFhAH1xcD08Lo6DDrSFh2JwsRFmAjqDoOWa8cghOejtF?=
 =?us-ascii?Q?aUQQbF8W1qHconIOo6HsJlRrslHQwGeJRnPblBmsfN4kgunPOtbeCIukKK4w?=
 =?us-ascii?Q?tUotDiWFnqqG0+q52K2rA81pp7rlrV5waErevvRiwr3k7XsJb2mdsPHtWSYY?=
 =?us-ascii?Q?0F++gCnpKBSKSDFYgqZ1PMerQnYxgmJbGi5BHB4P0aVdjswIG8ibXw6zTaf/?=
 =?us-ascii?Q?X2VV6TdubvNOWtLZ2shZtrCvlj3/VrrVagztJsa1Z+XMheUxn7elZSCSUWnS?=
 =?us-ascii?Q?a4YmB0z1QuGmblJkJTCJ+Jmit/NoE2YotED7oha1z40KdslVbCZ/1cRXtjO+?=
 =?us-ascii?Q?fME/Su66/A/Zpnn6VPLHflafWyG1ZElqW+bm9Mqb1e9S9nYBd7r9iaI5I2Zw?=
 =?us-ascii?Q?kY1TWCEBiZODWORhoZBG8Hy5xDQpTDz8xV8Vx8m08X7pyQiBnmFnjxi6H7PF?=
 =?us-ascii?Q?Fmwf0LXT5QRUTGy6UXlOtASOF7kArTddu7VkZAAalIO6yW531rY6T1oqqHhU?=
 =?us-ascii?Q?TZNedKmPsi+Pkb/bd6XrKMi/N+P1RXURdFwmc+STXNvJ9YHXqf96WLhs7TVb?=
 =?us-ascii?Q?2DVHl/Te8126hCW0rhQJ+Xwg3Mx6Na8itoWDSy7VYEO5HtsvAMp3Ui6xYHI+?=
 =?us-ascii?Q?JYEd8xuXD3GN8OJMCbxIYSqGVb0xHJcscxzfWRahfc7wLv6QE4r2y8z6XeD9?=
 =?us-ascii?Q?OpTBBQR79i7cu//r4nxf5DY8XJHV+45rsBG1XDBiN1aJUaillGENY0G0/GBN?=
 =?us-ascii?Q?J1mHSpsyQnEwF2EM7ON4/uHq5iopzIYwCly8KH8/2p80/s1ohdI86aT/FzF7?=
 =?us-ascii?Q?NX8lGsqb6cyLc7KJsgd1Z17werVBjdBS+miLjObF9BWLjHVjn2pZiPhc4kzs?=
 =?us-ascii?Q?sUqnky1xZREw1zcNx2dtFvszTrFb63GGm7sdtddkyqPpAUECKCUp41t8Aqsv?=
 =?us-ascii?Q?kV4R9kPZI/koG4CiDC8qnRkYQYLH2uVV0MCx3pFqoygy9uKvcQxPfKqHjI6k?=
 =?us-ascii?Q?JNaNIagDwSnLvk7Zp8lEqTxxZYcm7J1KoUBg41CSPbxYZHiVivNa8FEI9iZ9?=
 =?us-ascii?Q?VUNT8AX1BgRU3gcVkF0g4OShGVpKihHTJrdAe16iEY6BjF2AkTCBtipznH+y?=
 =?us-ascii?Q?xcDo04DFa/d6ZoJprts1jhZiStCt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N3bgTopd1LuRtflf7cCrX8o9R/oZxI59idgR/gnZI5UubyfhY0BmLEfsFTay?=
 =?us-ascii?Q?dY+vxLGOF5eHFo7pOv4BpuegfTFyxqjo+QL5ALmpABP+2tlY8SqrEplTuzdV?=
 =?us-ascii?Q?n02w1UvrYLTMAzaHCzpHxVb66k+C1Lf2b1uCKmxv8uiTZdFETMB19gVQkB4S?=
 =?us-ascii?Q?04hHYUj5D1RXtOyhgYZCfZk+JFvl7uzQNsPEnlQ04/gIOkTJ/6+SpQbWdELE?=
 =?us-ascii?Q?jO6S1RTfc0+Krsm6toovYXH1GL7KPg7LRvJBG9ZnktyAmCqnvE8qDBbLLGnr?=
 =?us-ascii?Q?shgEHufZWgwshL+6G+ijDg2bEoPRZDr2qesekHABDN0zv7WgPgd+yWwkCLgE?=
 =?us-ascii?Q?jHIejmr1MhSZqgDILEUvDmHY/jC3ovLo25sDRqDAzm7cW02LinQtlbF6ueiE?=
 =?us-ascii?Q?LHPbMrpHjMlfUoeFRA7DzcM78vpg3B4cW6ley92rbaj1CBNgGshWE8TLV886?=
 =?us-ascii?Q?+XhmmuBEiYM0qJQvhUwiQ7F8HSVM8Z9TDkO/Cs968ZWwVsi5bTrebM6mQqwq?=
 =?us-ascii?Q?JWGKmcxAHS7PHKdTf8J96f+SfiQETsXFsLEnFMyixFL4iVb7+jY+qkpSgnqi?=
 =?us-ascii?Q?9mjgqcR2PusbuRCMrdLEHtG5YdOb3NDnfYFPjol0PoxZ+rCDrUtHvrru6RUV?=
 =?us-ascii?Q?jEXq6HFtokhpFsctyEoJa57pwhFjaRm3k8MAoUVGgqFaJH/CJ3iNNuAZ5pjk?=
 =?us-ascii?Q?1wxatRSZikmtLUM5WQdQ9EdDFaDZnVnHouH+2IzZVbgaYUf33Z6/J6DCcXGt?=
 =?us-ascii?Q?DDUBsryPYC71aAvcfZAkKyyZf2uUTQl+Ll2W35YPIIhHL9EWqIxPv6hwUE8x?=
 =?us-ascii?Q?Z8ftndv4kA0hcboLlLSkqerSnFGvS/UYzxYnm8k3A3STI3avfZtHnchK/39A?=
 =?us-ascii?Q?G0mxtvhQjiGlmKGN+rY4FoNNDsNEJBgtkhIJmZ4rnS7cXle2SY0YRodm5+C/?=
 =?us-ascii?Q?P4qzezfrBtTSf06ofeFBFVGVE96S2tKKfEXXN4IA1IFTGPm9qY8ys4xme6IP?=
 =?us-ascii?Q?OclR9NcWV0pxTzOFDGKjuOi678YgBfaBYJhi6ScDeIYZAZfgyOtTvJXXC26Y?=
 =?us-ascii?Q?iXdmdmA6ifL6IoVnR9sEiXqRWWR76J+WwTkmDlKxeloR6a5yU5w+aZ05z1uv?=
 =?us-ascii?Q?VhlNtv5NnQs/8Wry6AQOv0bfzsoLrRLLYq4sFvBZ0UNmz1g9ZLRArcL2hug8?=
 =?us-ascii?Q?h8pIz7nUc7rBRfjBftUB3froK0FkjGGfoSJesdwn1c8/ORrq2yUTeKjcNQio?=
 =?us-ascii?Q?wMnspg0M7X6nUrKgI4qLvyK2eM6/HDTJ96S17KaIY+1QnvF4Xlh9u16qH0fE?=
 =?us-ascii?Q?bIZj2fFGBkrWe3XxK5AsNEuNRLhAuqMQ3kSToA1WsFA36OhC4FvSzBS3HNTw?=
 =?us-ascii?Q?QkUJ/NjJSCsnQhoyf5jSzy/KUprB9pdEAgyLP+/yj10eBTsivLwyi6G3ucqs?=
 =?us-ascii?Q?WuvgkJ8mveX+Ut3wh9t8oZJHa0FmiSRUySiMXc/dSJBPJjyOZaPbCdnE3VC5?=
 =?us-ascii?Q?VuEk1Cjku0KHaJ/Pn+Q4/tC9m9pKRNImcJXxI5e6BAJTcPDmIsydf3s+JPjx?=
 =?us-ascii?Q?9uZ9xQkojmAb0z4zDFbyh8+6gm1LbFr3mlkzMS2cSMbGk/mjmx0bNp4tN178?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6y7LiFoJzcesdmtKUy5fIfw29vVbYM2bkK3vsleb7vM/GGtPgMrzud7V4ijBD36ZwgM1tAR5h9F67J39Raaq6wTnm/TQZeKsUyGOE0b8cS1seLmBd2vwYS/AQcjA9sO1pZIi3ajEmyremrM8Pa4KjD/NB5SfIyoFtaLh67U9PU+aUZj6F6TbM8CaBkUT8aSjyCeI3POjtAhg8JkMAW3YHbvik0rBGFJRaiC7SvXWFAnNyNM9ZKNZ5ilY9PRbAl7WYQkFX7E7yfAatrzjW3WsowjGDBsu0YMeK0GA4XaC1xV2eu8DK347UZ5iy8+A1i7jleC27+ZCiFLgZHbW8ygOjUqJaeSVfbyprn5g1tOYW+bJWLSyfTH8WNBGiaUDLP14gF/1KAO/wrp5zEoVTKisst35e+fVGZ+ZhN7hdW76VCTvy50U0QBvNmQmW5a0E4K8z+pie3cVNyIM5uSp+wxS+8RLu7pPoCP2lZlcXLN+LRqCtagi30voBtII5r7Hhf2y1j7uG4D1ULjsS35lZdKwupv8g/yk0+aCPgDbmjrIxw5ATol31NQ8fSYyLGwnh2jB4eyaHQAV1PqMIE4YIpxc/RyofVzXBHHJ/L8zjY73OT0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1024aa2a-96e8-4ddc-456d-08dd2b591409
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:12:54.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FBYXLQAQRyOFpeckCpAZh5XcqjRgjr+SDNZ7zKYMFHdmojYmik12R0eaA2qIkpFB/C6ktC60wGjyIv/x4JeK8eOG1gR/Vrj+HloYJ1XFat4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=740 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020160
X-Proofpoint-GUID: _coagsRVcBrjdBeqYR9JxT8xuCl6kIzs
X-Proofpoint-ORIG-GUID: _coagsRVcBrjdBeqYR9JxT8xuCl6kIzs


Randy,

> START_STOP_UNIT command should be "START_STOP" instead.

Applied to 6.14/scsi-staging, thanks!

The SCSI command is actually called START STOP UNIT. I removed the
underscores instead of using the incorrectly named Linux define.

-- 
Martin K. Petersen	Oracle Linux Engineering
