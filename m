Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEF76214D;
	Wed, 15 May 2024 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715782014; cv=fail; b=BSH8gX1v2P65nhnj5ylVqcR+62VxOBrEYqEXX9aLjaLdZPDQuS5LOciUtSIaSQ7AHpEF9itvIINoZh1OuARIIqgoOvlTvc1MvqeLEgv/CB2c6VVofISxIGRbuTCer5bYZ1HDj40h+ARSHFlsi6LnAGyf38tiSp1bo6lAlBS0dd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715782014; c=relaxed/simple;
	bh=PZNtxUr/4x7B62JUI+YRkb79aDl6i3vfE91lhs7j6Ho=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gu0BNYVOlZ5jQ1+H1RlXXPF1ENvIRJZgxE3Gwq/XFgxb7eckv5/O71z4sTttSkHKL5m2GB2HuQh8rC0sGf6D/rVtX6DNrLbXcGWse5dePMO6XaDxasWDCUcV1PuYKhGZhyi3gGeP7L08T1EdscQx8ikMPmsM59PcEFF/KWvdenU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CkJAN1FO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kvGgnMsd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CkJAN1FO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kvGgnMsd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44F7nGfg024793;
	Wed, 15 May 2024 14:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=frCDFj+dVSJx35i03xCn9BE3zsX+vCwcsPehsLVkH4E=;
 b=CkJAN1FODeUa+qV4+R6entDUQfkLmpW47lsY4wC3dADl4uCTrFwniIgRTO56HriZNvEs
 0vtLLeIJ/WG2lmpevYVgL8S2BbhoJg37FAKpFYSrWAtONu0WKQiAZcmp8NkSWPsxDJt4
 fh8L9kETxRDdE7dgvFgM61nrX9ggppB8o6KlxKm+HFQLucJ+FIV1OfzQyigQpwLnY2HN
 oMDJdDruGxYQAWAerpJ0oEuQtSz9wTNWU+w4thEYR5OQ8IPAb9jcwg2qRiItaDGqiCuK
 Xs6JvCZ7RDM5X67zouAhnWeghgnoxtsj0kt68HO0PU5uDGjSizflPoT5pw9DvnineCmV kQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3srru8y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 14:06:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44FDvSo5005786;
	Wed, 15 May 2024 14:06:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y48tqpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 14:06:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikwrFatom/05rty8lrdgTsDbwmWyRAuZck7F+EYLinYcZn6FBGJdYPMsDm58zuBKIQHAQVL6OUMdlZxfp+KDBqPvWLwx1dQZB2fYEdEs8WwkabFmrGLWAyEDeP7Ixn0zsxAouecRUvkacrOI0o1KwqQPMc3U2+OSZ7byffjvMCWf+Bpgd2hlDGvlwkvxTQpEFq2c5EqmXH4lApGt58CxFeZxIExcW8CVVlhGspaEo6n842vdj6YzaNoS2eisb/UMi9p/hcMjigQISF01S6P85KzByKo2EXCtkd3ecIXS58tHcMWSkRGqd2gswCGhcQaNeBZ6FVRU6iTLK/e2XDD3PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frCDFj+dVSJx35i03xCn9BE3zsX+vCwcsPehsLVkH4E=;
 b=K/oI247IE+/bCnQweCO3wifK9O8nRrdoDWpC6Wj5gTIY6BC2dbgGOkOkGcURHh3uWT4ewtbT0Rca2VZeS442OYD5XixtJ+6+wNidnFXxp7AtPimCj/c8yerXUpN5NrNXNejZZE+Y0tMbjBfzK6vSQFpGzAZwq7E1H9hG5royjFwhUaLjeL0ZBvqkwdF2dd6tYMB22SORJMVHpg41WmfHAkPEIJ7hsKtenI+yFvmgd8jLHDia1kHyryrbkP8os68K6TFPXw/oPTfuXtmJu9D1OXF1P5w5/AwQmBo40nsGGzmsXYa8FHfBO59EayLGvqhoUdegDYvVq0HO9vnTjl6ksw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frCDFj+dVSJx35i03xCn9BE3zsX+vCwcsPehsLVkH4E=;
 b=kvGgnMsdJ9dOZRlA9YQhq475KJPwcpnObEe48VtIt48D56TwoxMzUeHidTBI5sSB4unmJcZ9GoAo3i1VsC1rzArRiMes7VxcrXeSRlH4+NbUwoGjOo1m37GfgoM5yFCQD0fU8aKKb4ozrSq1d0QvzguR1i2VJc9i3c1acIpK+Hc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5019.namprd10.prod.outlook.com (2603:10b6:610:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 14:06:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7587.026; Wed, 15 May 2024
 14:06:31 +0000
To: Justin Stitt <justinstitt@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor
 <nathan@kernel.org>,
        Bill Wendling <morbo@google.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: sr: fix unintentional arithmetic wraparound
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240508-b4-b4-sio-sr_select_speed-v2-1-00b68f724290@google.com>
	(Justin Stitt's message of "Wed, 08 May 2024 17:22:51 +0000")
Organization: Oracle Corporation
Message-ID: <yq1msorrx04.fsf@ca-mkp.ca.oracle.com>
References: <20240508-b4-b4-sio-sr_select_speed-v2-1-00b68f724290@google.com>
Date: Wed, 15 May 2024 10:06:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:a03:255::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5019:EE_
X-MS-Office365-Filtering-Correlation-Id: 4abb97b8-6de1-4c80-d988-08dc74e838dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?wvu9phjL6pNnd0FaAnFlCw+WfZ4ig7FyFJa0yxowbAs17XEbKJtGt0QYrwqm?=
 =?us-ascii?Q?urdGI9bMp3o2yQeW3pSgwLHbm9DHyQXdf99WgDmENC5zKtHMorqVJNUE59D1?=
 =?us-ascii?Q?suKqDkf2VhjaXqY1oD278CLlAaSASXrEC37jerppB/2YRLUreLj+r3d3OMza?=
 =?us-ascii?Q?GBCQXXHfxVv164uOH5iDcmTzIoe8NKvgJKaLJIFSjeMdM20u0ELNmRxwyCRM?=
 =?us-ascii?Q?KDbqaBZKHEAQnP98r0lzeNpyC0HoXVeOn4YNiPbQHOyn3uRyjdGomMouf+0H?=
 =?us-ascii?Q?TZo2fbQIc1vPmH2IkTchDmq1ERfHK/MuawCV5/AHdlJbnbPlXqwIV6xGkX9H?=
 =?us-ascii?Q?tPgJn5LujAaVuLBkyKUsuiSXj+oFwRD8hVAu7D7qUO4KobeCoT9yhUj6x1O7?=
 =?us-ascii?Q?I140vB0dpx55kodIJJHlbPsa8EaxrlwlKuBzTe9U5VLu8aXghcPvOHqFI3kg?=
 =?us-ascii?Q?miasqaKPxaFG5Xehs80KU2L5PGVJhjKzZfmUlNLHfoutOkHU6bmxoBRCHnwE?=
 =?us-ascii?Q?zhCCHrsmaP74AcnA6UrPL/jA+4+wb10urN7JY0Xrg72OwtgEdtystvD84f34?=
 =?us-ascii?Q?Yv+J+OEteJWvbfzjxSxY4Z1bG8MIBt3vhr1ER/crWyXOmygMlEW+cPopujJf?=
 =?us-ascii?Q?86pWgiy/rS1U3l7vk1cuNU3M1VHEddAUz2JI193n5fyoRcftjMhjHXrAMssh?=
 =?us-ascii?Q?JHGwR60THJeYEW/6uyM4Rc3WsKEZZJW0uflxnYZVyeJnOycy2Hw2IySRnG4l?=
 =?us-ascii?Q?Pk1FAkiHzwYbsobqw0cMCEuRxupyaIOn7S4wQY7qWp2Mp1Lj2rPjtD4cHrGa?=
 =?us-ascii?Q?szn6Zx/F15VenuvoThl7BVXV2owd+QZ+iuycdrQGbaxZJXlxhNQhwi9sJgGj?=
 =?us-ascii?Q?QNtxb9Perzer4w0/Lc/3lsc2/Uo3Q6+w+NqHQgZHHV6ANL/PRSpfCaM4/DKd?=
 =?us-ascii?Q?tzuzRZmKbOFmepB25vinQBORcoMepg3O1HQSuiSM/62UTbCBm+Q4zlsN4tEK?=
 =?us-ascii?Q?t9vBfRII7HYfEKiCqRsvkgq+r+Q5ERJFsy6vqrN8WJM0d+ZXmlVv0g9xAxat?=
 =?us-ascii?Q?oy4XjEhK6g5XnYGaddOzzkw3YTHo0dn8HGcCTi47ytGlmO3MV7+Xud0r68lY?=
 =?us-ascii?Q?6B22KyziQmo6C0SRYpW3Dhza1qrA83aRgOarxMHp1RQ2CWQxfwVsVVYjD8OA?=
 =?us-ascii?Q?RAo321RUNcNlciRkbOgB869mybuegPZ2Hc4I01+sotCt2gMcVR6tByoCAS4d?=
 =?us-ascii?Q?dw1diFv7i2ZlGwtshcTauOOBJsRhS3HC2GH1KUJdOQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FAxOtfzZJdResfEB++24d1hIg8HA7Sd4Wn/ghumuigsqHJb12CVIsg93UGOI?=
 =?us-ascii?Q?MA9bxS0Q9PuTSy35mmXleadupdCTl/WRzf4Rn11I0OjFUjjTis+A5Cz6K1PR?=
 =?us-ascii?Q?5kx7aTtUIz4E2Xt9Nk4KI2xXRzrINbZfd+lkk3JPIJg4+S19uHeIDeg1s3N+?=
 =?us-ascii?Q?3auBCzvFeoeGrMVk+HFK8i6VKDII/DIEQB2nzlx86Tj4rFMEoagaDf0rnRaE?=
 =?us-ascii?Q?8Z2eF/V8CFmYPfVjudiai7szS1n+E2Y8TORKNe5XYPzPbuV3qccS2FaIgJ5X?=
 =?us-ascii?Q?4mnjj+Be30GvA6NXflfvG0IMO1mczPJpZFDDKq9capON/fcJhoxzPA1afeTR?=
 =?us-ascii?Q?PVf5USXFtC5/hZXMidSPa2qLG02RstbtjmJRVEshnabdX2iGulX4Z6gNQWjw?=
 =?us-ascii?Q?YtiiIxU/asGKDo93g3kHy9dJTP6cVw1n0p+fHP+JqMeBDTHV5XMtMPYhIgU4?=
 =?us-ascii?Q?sGgblXqogCVMo8Hm2YPccYQ6NG09tdbLuKwxrkUM6jMGENLqvJZtAjeamQq6?=
 =?us-ascii?Q?vqpcaNjHyI3TQyb3XUz7aL8+jk0WY1RWoHg0UzIcx8Tkz0iDVPpkbW9i04Z4?=
 =?us-ascii?Q?SvV4zzuTX/m9xFHAANnGmonP16l1Tb+mxw9Ho4KLbn+nzSiiJjEznyxpIQAW?=
 =?us-ascii?Q?krNFAVHYCDkrwwA8yZ6iILzufSLFJV4Dbk5jrfwUrQodTpIapzU//XFikCL4?=
 =?us-ascii?Q?j7cqMy2+EBJrawLjEFgXPn/P0ooYqwXfv4OZCP+FwIb6F3M45u9EVnMv5AUG?=
 =?us-ascii?Q?zTX7H9f9P5pJYX2sutUwAZWN7DMr3v6kYDBGRJJKoxEFnxGTGZ5CMIGj8ex8?=
 =?us-ascii?Q?rVf364o8jFliyLuqMw7OM/dxsATRcAYzBFZbdOZlntSidQX0/WZ7t0cPu+Ge?=
 =?us-ascii?Q?BdHXDq6yM4kRda1sb2xTJGh44f3gEaGQ9Td3m3EQ0kNIQoWjr6CkJyZMEDK3?=
 =?us-ascii?Q?EzVi2Me6Mjy/EEJREmxgudHl9Kh1PdCp+wgf/2xNueGcGFvtR4/NCsbyaK9H?=
 =?us-ascii?Q?LhYLsJpxfWsntIffPW4REhPC7Zix3PuIvLIL2/Wz9qOye0AzrPsRTWHfdR80?=
 =?us-ascii?Q?Qkx7Ovhh1mf6v1xZuC/WaFe/QyqxXR4O/Z72yxVOky5zNVCDyrjXH5/0PSdI?=
 =?us-ascii?Q?pJ1wTk4mzvS7TXGUXpN/IqkGbUIxKSOmmt7bib5PSZgF4XgSNX1T0YDJxEik?=
 =?us-ascii?Q?xkHvZM1ks84AWSura4ILRa4xmCpshRgN8kDg5X8X5Oafz6vsvXlrCBFGdQnC?=
 =?us-ascii?Q?7ew3X82LcGmcyM4k5iPJl2GG1AyhLCLiEH5SO8GOLL5RU50CJ1KFB2T9L7Y+?=
 =?us-ascii?Q?8UXW9JdLvYcmoCmijRrNTjAM6IA2MGc6inw27FwEwbCc67oVgtwwrMRyt5yP?=
 =?us-ascii?Q?FWOIGpINlyYkcQv2oSjzi9MWVs2V7/eFZwUhs/PSTJixQQV8LXCIRFoHcbqe?=
 =?us-ascii?Q?l3/VITlKwOvaoWV/TDMeLbRoh6AFw/Hb4JB27uTXUCNM7Yrtx3c6k3rNVPuw?=
 =?us-ascii?Q?+F8njq2bW2qlAwahkpS++W9MRzCLJ+CTr/rU6FIe3IlH5hieSL2BTJrPM12Q?=
 =?us-ascii?Q?Chkp4P7dSgJZBXO4gi21JiQd4KmaPyMjbzW8983MHVbxiEU31IBjq5bzILQ7?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Cn1IupjT+l20PQ9WqjoVX3Pj622aQ+J9v3MevO66wpBTnqpMQSrh2SBm6/+Aam2MNaqyvgIirrOMBHWV546oSRTLboGFHQGO9T8szuar7o8fC1DgaU+FKtnJiIS/l2HOvbCUUnjeTI80tqMEgt9H2e4z8Fup3XEZQW0g2dRCUqQiFQX7CMeX1VqKNDg/y3p1Mbp2ccUfU63wxjXJxHk/eqhzxK499xZkKNASjTppRpTpwmrDANnI/TVCnUwg21TbWk+QPECKSqBRCgmy+NPBEaZqKgE7VE0s1edmdIltNcKSvZuaDCLxxchWnnhy9NY6bHiz6y+Mp22y054crN9nV2Po5ybHQS8MnZBQdiqL5Ev32pOmvg30bHKEgHJQKTss2QU5/DVeRa9XSDJXlNIRtsqXp5BMPwYqESaup+AalGbVd059p457ZjpF+KgCNZG+cixk+Fr0UXuzoA/pJZZtFysb/DH2Z5UjJu3hFa3Hu9V6Mfvpngh3YD9Krwy6TQq3F2YmFPLIMTn/TIf1lW+3FNoui+g3zmIqW6oyUBbEummrkcD1VNoOJaaYfdpXVNnq8K3LXwurueEHaa8+DqLdKSCO/W2j2/9wrrE///wIpPY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abb97b8-6de1-4c80-d988-08dc74e838dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 14:06:31.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17rzR7mQSZb5L7y0giFcUEcXwyzEgmVd5+HYWWD48mdAPrn2zNgzc4RBJiqZKnmYrpQvz0Mpb++dNk/bJgen5NfIppYMeJ7BT9VOMG7S7IY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=983 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405150098
X-Proofpoint-ORIG-GUID: 6UCEP_NqqNP1vTu6ziN8Vv1r0R3PJFuE
X-Proofpoint-GUID: 6UCEP_NqqNP1vTu6ziN8Vv1r0R3PJFuE


Justin,

> Running syzkaller with the newly reintroduced signed integer overflow
> sanitizer produces this report:
>
> [   65.194362] ------------[ cut here ]------------
> [   65.197752] UBSAN: signed-integer-overflow in ../drivers/scsi/sr_ioctl.c:436:9
> [   65.203607] -2147483648 * 177 cannot be represented in type 'int'
> [   65.207911] CPU: 2 PID: 10416 Comm: syz-executor.1 Not tainted 6.8.0-rc2-00035-gb3ef86b5a957 #1
> [   65.213585] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   65.219923] Call Trace:
> [   65.221556]  <TASK>
> [   65.223029]  dump_stack_lvl+0x93/0xd0
> [   65.225573]  handle_overflow+0x171/0x1b0
> [   65.228219]  sr_select_speed+0xeb/0xf0
> [   65.230786]  ? __pm_runtime_resume+0xe6/0x130
> [   65.233606]  sr_block_ioctl+0x15d/0x1d0
> ...
>

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
