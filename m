Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7532B381A3
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2025 02:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740105529; cv=fail; b=n6LdRa1s56vVKuf9ARRh30uQovmuG+n6hEvAEiHDnNf46prexHGZA1WCYiFRtnjX7MJJzp30wQIWIJl+gBojvd37E19lxATRyO348NrkNocY/6cvL96CbN9RkjbCzB2uATIeKJjLS7N9a89i8n0sTQS8Wk11UvV6RZSZWxgpSIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740105529; c=relaxed/simple;
	bh=48HNhtv7Y5RQLr4jXTZAHiSZeTTXQoSl7SupfS91xuo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=s6c13CSXiq4z8kz1yeBmklhTUR8hpPYCFqJlMdplu8fpPK4cPVoy4XPq9IDbc+GlDoxkRSik7OBfRuxcUxMCZcR+LWqWMa+zTk/Ip7MvV3RQ4wA+GebD4lcXAhK6aHB5DSFipiYgqAfAEVtifPp1BpDNsZbT4d5jsGTVEorNMY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oYGsFwEu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dLlWSPOQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oYGsFwEu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dLlWSPOQ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51KLrYcp014130;
	Fri, 21 Feb 2025 02:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=6g7R5dh0zNOOJUke4h
	oMhhqciyfAKSSUbgyMnmwaAz8=; b=oYGsFwEujBhoa03fi62Zf9egI5bWl6rWjW
	VcRU7aFhNVOy8M7Hq3qkopywke1WMTZd/EN5JsAdNJLVnjE4AXYa3Dkdq351FKXo
	GTZjI9qNWwQKd/nExlQVSpvQ0PRAs+Mm0WNxTT9rqeYpQYi6AosC+4rl+pAPs1AN
	6ce2hXyVDcJE6Ifhem+xyc0jGoTSGKb+RpbBHM93Z7wPcTjMztLFbl3GrfR3kL2M
	2hBmZnPKGy71CzkTYdjokFP99abAeR8o+Sqndm6BpHvwo4Apoh5i3vglvF1oHmRG
	pQyGn2xUxuaGhAHHdzfaEhf4pZ4UrLSZEe4+QPK2vWYgVuanoIng==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00n5dyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 02:38:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51L0wUZC026262;
	Fri, 21 Feb 2025 02:38:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0sran77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 02:38:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmIz/z/5BzRW17XueTbMnOv6fbgtWi1Bgf5NqgfV3rRBAotjrbP0fk4VvWM3Volde86d1ijM8USG+DMYC99CwCL3TWnav6rI77jfuhgsyqf1O4/gdY83WQcfuryX/IHxe4g1dZxiAG9EBx4a06M22Rq/4YzT7ghbmdfcrslR6aX3a4LaKuDmQcCr79DsKhGIF9jVi0y7XqdB20J3452A0TzkGkzxssCeHrQgbJvBbXjd7vxbm3J8KUKYjUqU6WWjyL+qDRxg5gZHuYcY9VPGnUQyNpSACS33xR+l5yGdgayhSXTmIo2Iu/ZLRVqxy8VR7Y/6q41u+aWjvJk5NHt67g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6g7R5dh0zNOOJUke4hoMhhqciyfAKSSUbgyMnmwaAz8=;
 b=LnLx0wp5YT7I7tr4onn8+nI7ChhzXytCV7lp5HY4ewhHdwBgTGnARQR55skoTcKQhKJe8kxCAvnzaBo1r2NItg4grqXWqNLSv1xAumzVFyMSjgj0+UStkrfvx92QIBJjKBOQBUw/xSKn9VWU2Vc0193NqBH+jBcaUowCqFqGooV4F653yigvEfukefQZ7URAYSmtqfmzU0hdPb9U3sOJoS3jkK0IPLRCXrnJlBjLU8ZM/1CMnGAHycgQKTHKWD3ZwcAADHtaUnq/uWwWDaFRqUpzgBN/8mA6QOtxDTSou27jd7xbPw9YnaBKb2bCVtyRKFQ3OxpTg5z7mKLplFiMrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6g7R5dh0zNOOJUke4hoMhhqciyfAKSSUbgyMnmwaAz8=;
 b=dLlWSPOQCISf/jIXS2kAsvoZud8UvK4hwViWGVO2kJ5XpaN+UuVmwMiJoD1zD3QHAT2hSMgncAm0UF/5z0ZPSMnra79bNUGysZDcPE3yC9Zf6AJKzlXTWGrnWR8UICGmxQFYx9UClbxiCV/FPApVPimBPP3DHSQfIa/iQEbWAZg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB6192.namprd10.prod.outlook.com (2603:10b6:930:30::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Fri, 21 Feb
 2025 02:38:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 02:38:39 +0000
To: John Meneghini <jmeneghi@redhat.com>
Cc: Sagar.Biradar@microchip.com,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, thenzl@redhat.com, mpatalan@redhat.com,
        Scott.Benesh@microchip.com, Don.Brace@microchip.com,
        Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com> (John
	Meneghini's message of "Thu, 13 Feb 2025 17:03:50 -0500")
Organization: Oracle Corporation
Message-ID: <yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
	<yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
	<PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
	<8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
Date: Thu, 20 Feb 2025 21:38:37 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN7PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:408:20::36) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB6192:EE_
X-MS-Office365-Filtering-Correlation-Id: b60c9b2d-3231-43f1-9535-08dd5220d910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SZodDrTDUHRYJd7wEYHQN2jsNtRuMSJkPeeRWE46wEgSFcWi0k4xhlf6PBR+?=
 =?us-ascii?Q?5PyFJYHex8V6VkNepVksf8QsVmtn6IIMBBHQzsYseuyfoyD+RQvpl1gV74RT?=
 =?us-ascii?Q?5GQ28JNxd0O7DI2bJ3zSeQ3SGEx0SmbhgK7RTpCEzQ1nxJQu9inbKdMJu3xw?=
 =?us-ascii?Q?c7S1VMd7GJDdNl7s3hcM/xQgF02t0DrtN0VWhgI3WWL13uqujC7C8LZUR+NH?=
 =?us-ascii?Q?WWTOSRTueDX+Ts3mMWOLNG9vDNWeaDIg4MD3mH3AUO6k2kBkQfusAiEPS7ll?=
 =?us-ascii?Q?JOlFxB+JjKD2lTYDieY4F53LfIHc7zte4pNX1rXRq4dT8WJkKLqTHMTBAQO6?=
 =?us-ascii?Q?ExG3qk50NMA061ejR+IsoqcefVHV/SdetZNKU/9yPevp9fMIwg4wUI6asL1S?=
 =?us-ascii?Q?/5Xg5M9OKdnhiTZHdyHz+NmXNYWKLZ5fUHDuh8SQl7zfLszNffYyNL5Y34IY?=
 =?us-ascii?Q?ub3ubxGIY9XHz+YMGRUCEi4IDmOZpx45esOS4mPKSvjU83t34VW7cL8enUSV?=
 =?us-ascii?Q?1f7jiB9geiclLIhnIIV7HnIO40BZ05NBSWW9eR5xtDr+/v2k4eH2/sPLnGXK?=
 =?us-ascii?Q?W+C6yB5UPwzMh3odywXsKwTozX35YN5xnrc9HO9Ao/VR7I+uD8VdMT36NpG5?=
 =?us-ascii?Q?UwD/Vs1xJAZgPm0tIGKtcg7hwo0+r+bcuvkwdGeJAI0Osp9Y6q+77l2DJ5e/?=
 =?us-ascii?Q?OfLpt4bm8LZghMJwuqO5gp+grO+Z0YWdhSH96EkGIFl/RXpK5vb6zAVqShAJ?=
 =?us-ascii?Q?K6XrF15so/OIHsWTr8z1IJTz9SwmVASXwctUhYl3/a//FgMwhiEcyge0iFAj?=
 =?us-ascii?Q?U/1zmsiFKj0QKzPHDp3pxfDvi7qZI9dKpmYD7+fqAwnHxyJ/G0mDZuDE7y2e?=
 =?us-ascii?Q?G2pfJ1McpJSNfu+Mr86Ao1zwdzQX/S2TJOU1VAdrp7Tow4xXYVjtfAK3C50I?=
 =?us-ascii?Q?ku4WaM14AuQ/l1KFW67u+CFnMU6wt+oiZrCR3QE2JIDkRK2/0krQi63m/ff7?=
 =?us-ascii?Q?QKI7GZHm9BRkzBeD1TuaOvRZxUjSD1ghQQnVizGPdkJcmcMYb134U9dl9zUO?=
 =?us-ascii?Q?XioS/j8zhCMw1u2YWnf/sbckFd4n9mnGqvM9HWkWa56J57TsE2SBglyEAaQc?=
 =?us-ascii?Q?ALELXqt8tnMQi2eUhvHrf+s/c++o8tDdodWFl+01WMpkKKAlzry7FJYLVO5J?=
 =?us-ascii?Q?Sh9azOoPwL+ZTmGZu3wTifCYsXIrutMXsUI0xH9y/c78iDswJWOZN/Roqich?=
 =?us-ascii?Q?v/jx++d+bmmRq1XBbvf1PX12omKAp1XxGGctlN1u7Kxx1mXLEKD+tmfUFVW3?=
 =?us-ascii?Q?MBeOKDM1I4IWYMN9JBcyQCEXKZ0cR0+V7ZfzqxmzPnNnk9DP7BnbLs2adPfv?=
 =?us-ascii?Q?Cm0DDWG2hffdhQbAskzATYQ/HuWz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jIEPHgYzWJOulVgF3AHueFVin8p1hh203rvGBS58drmUgbIAsWYCm9UB3vR7?=
 =?us-ascii?Q?9pV5Q7wF8DNkQv1r1IbDIxqnqf7RowMLid5RTYJW3/Rz5fdMyN5NxHdadBJI?=
 =?us-ascii?Q?Ak23oK1iRVTmfdJWUfUIcNRMqroQ+1Ybokvbug4kbxiGUUIyXMG4jvQ5VU/f?=
 =?us-ascii?Q?ERzvJoUGmqGWsn60g4U9TqcaKEWzsT0Qf9h1c7Y9xOFmVQdu9LTACScVCe6h?=
 =?us-ascii?Q?rhmpKtAiEFApCQNKdrqqfTjG5f291S8h5cka278CMSjlbn4S4P1glXqJMRou?=
 =?us-ascii?Q?cHEhBYBcUKU8LHyt+S41jy1AUzNJcqfv2o+YN78c7D5sq4UJAqeZlObYZ4Ug?=
 =?us-ascii?Q?LfwPZlb9Qw/0/bY06FUAL01FDyhg/F/bXrGC8t3yGmsu1qTiyFIOfASLcZZJ?=
 =?us-ascii?Q?yXQmfdKO5FKn/U9Tss7Xhjk3QRzOs4t2GZ+K1tajkOeMabI4v58E0cp+KN6V?=
 =?us-ascii?Q?RRp4iz3VIsTgucVY8xRxL5ehv0OmLfVA47ZS1lVcMQzcermcSXPDHQ1Pts1h?=
 =?us-ascii?Q?iZofR2LC0ylJcZlvhGZrYiprr2PpBbtTvkw5pgvBB3syInXBN9xddjJU3/OJ?=
 =?us-ascii?Q?xQbiC/AUmgc8hXZHho6JxGh7hGF2kkQuHBtot3pcv2MPiCi5soUXfih4pFa8?=
 =?us-ascii?Q?0DhCYfo/JixIDuAK++5ISWQ5/QB+w9eZk6cC09Do+GE0Z+Gc4nUW/coj2L9T?=
 =?us-ascii?Q?TP+VyNUmXoRD9ISvI8CZ6uC3Tr/y0VCwbyD5MPRxeOitTqlJ7yd7u4vQ3RKf?=
 =?us-ascii?Q?PWha/oPDWEpdV76fVpScQRI4iaxk7dx5W0tya3GYtpCgOHKVEwS4WLn/DtYN?=
 =?us-ascii?Q?xZMyZfN7M2L6Q0k6H82gxWZ4lvOzavj1/HBZ/URiPFtTw96V0oBM6/zbRBHr?=
 =?us-ascii?Q?6jlxsY8gh4cRtOKPxvlZBUvFi8NxunWEpxg2zMndicFV8r3fS4HOgJs8VyA7?=
 =?us-ascii?Q?QI2LVFU6p6sbyi596HomVqyrUC8jkBI/cxy9AsH6w08SzFOkfv4Gwach9Rmb?=
 =?us-ascii?Q?JO2tkysvmRzg3BDoRzzrem9+u9UxNOmkVB5eHuf0CCOetzpetUSqLSD/xp2+?=
 =?us-ascii?Q?6lr9UV+h4T1RKhQu/wdtLYZarXiAMdltq02Evfj3p2bNwBnFxhaShkwEENkf?=
 =?us-ascii?Q?ggGVplutl9Y/Br4NfB6M/FZ2Y7rinAb7hBKHG3VtZwrp5PMvlEHkWNCQCMEM?=
 =?us-ascii?Q?gWa6dIVrUZIRNzQbBr3oS/e6CYQkImZ2V4eBEDLGuYUj2o7mAwaemF+2BoOy?=
 =?us-ascii?Q?GNYNcsSiQkJX3iMK1UwvZznyBNWioQYxJOU9UInPc/kR+TwecCwLsRioyedE?=
 =?us-ascii?Q?nYMSXcWT5gkjlhB08C45wHQul0DP+tw1KLGLRgElmlywgCEtLw8+3UbdyyXa?=
 =?us-ascii?Q?c4s3GR8E1SMERy0qLX9oZyTaKgSEke8MJ7J+zl+xWQMFMEUmXYEd2t1kMaUu?=
 =?us-ascii?Q?524XxOV0vxX4tUXppkhq9OSpYDoAfVPSlTNLuiy08ZFTLx/8SM/0BnhtFU9Z?=
 =?us-ascii?Q?0Ij29bcS6864tIa1smwA2iHEQJYPYG17iOUnmLwwNZbVRQsXcRHqORC9UDTq?=
 =?us-ascii?Q?o7favfl0eTFy3+jXjw5WADSR6YQ85ZoE7nhrfhk1zm2KEeh+psAf3x+z5bkQ?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PIn5Fna4xZ5jhtKlpxmHHb1SHcKdj6Fy0W0WUTferqojUVrTkvGRdf6WEnZd1uLJo1MSOFezWxmuhmC0j3SZMWA826tVSRh8ykIg7VZI6DWPzlAdsiz342ORfeylybdn11gN+YtyVsr/eIJ5FCp5rnZIpuB68J6QFaz7m3U6dD+cGdQQpSyaFCg0vKp9Gpze7Ps7KsCYto7st7LTshfyqUGydgG/EFAKfXF6ItTX7Tp8Ov8LazqGFn0i2U3Mx/JPySFeeZpcViTHkXN0haEfmM50ng/h8LujcnRRISDMN6x/ONxp3wn/c3XcRoyrli4aIq5tlktp5S0lyqAsuHBp9XDNuZL49aUiAqjnPcqdB7heRPVAfMMC3WXWQoLhufGbWHwb+EoTIpUoQpo1b9anjcw/DipqaoaZqZMqzSy3+ToTcVnuLAp+7wyTZ/XyBFmhyKq1p/ZCTqAFWbx4E2Nk2WUMvzjsRn2hNY8IOpL1np+TDITFq5W/fsW9suOtMxhhabCni24JApD4rqho3uVCoqifj+pfKTjulmnMgWWsG/TdS4QOG48Li/ZlL3HtCLdeCL7iCiLEn0J20vCs7T1EZjEyyNrD7jD/h1Pro/8L5jI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b60c9b2d-3231-43f1-9535-08dd5220d910
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 02:38:39.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ku003hlt5BwdFr215jKrbS6HbhlTSZjxg/mqQLZ/EFsXXFnGY0pAX4IpTGB2n83bSUsPwviVCVlsMOwnhc++AYwS4KCAmDBf73VLthlx8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6192
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-20_09,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=645 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502210017
X-Proofpoint-ORIG-GUID: w7zRvzdZWM75bUDEYYTOPmJ19pCMwqzp
X-Proofpoint-GUID: w7zRvzdZWM75bUDEYYTOPmJ19pCMwqzp


John,

> However, I agree it would be better to just fix the driver,
> performance impact notwithstanding, and ship it. For my part I'd
> rather have a correctly functioning driver, that's slower, but doesn't
> panic.

I prefer to have a driver that doesn't panic when the user performs a
reasonably normal administrative action.

If go-faster stripes are desired in specific configurations, then make
the performance mode an opt-in. Based on your benchmarks, however, I'm
not entirely convinced it's worth it...

-- 
Martin K. Petersen	Oracle Linux Engineering
