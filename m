Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F6BDDDF
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2024 02:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554196; cv=fail; b=XosuKxUoq7zysd7M/hkhHl/1x0PuGQnKKUhEdcW853ehoqM0WxhglmR4aPPhdljWZO5Jx2x4Ra8P2ulRwkWfLmMcfZVgKgsUcRwpLdF8vNz/O/9HZar5vJCosWDfR47jKRCCfI3ZLLbRAIv74mFOOBNYeawfTGyYltByxKXwDVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554196; c=relaxed/simple;
	bh=qwYH1C48jGJa+eX2LyvKesLr1ajcA1YicltufgNpp/E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eHHsngKsAkBj2wq18ayP7t8Uq33Dab0bZDfbRhc0HWCmHQV+Rs88ET5iP3pIiVSRlc+xnqGUilcm5PkBDcHbiKkTg0HQYsBGX9G1UGLeFUdejY/juc+2w9M8CriMur9Ytjlajmo6gwuXEDcH8BrKYYNZpE82XP1H3MVtUzpOlsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GIy0iDTc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bYa6gS52; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GIy0iDTc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bYa6gS52"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551DkgQ028397;
	Wed, 5 Jun 2024 02:23:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : content-type :
 date : from : in-reply-to : message-id : mime-version : references :
 subject : to; s=corp-2023-11-20;
 bh=qwYH1C48jGJa+eX2LyvKesLr1ajcA1YicltufgNpp/E=;
 b=GIy0iDTcy6BkU6zc1LgCIhqWl4Vbfg6jxI6pFq8pMFn1fCWGKD10dVkO1Yu8YDJCihzK
 31S3SOm+UZuGaPdOXf/EVEB+kgyppabCS18PnIrrXL0S3Y8WPn90blH2JkFxVG7PMt/I
 h5e5kgT0QNRy/3SX1cJAKDvunqu4+PhTxrXs0QSz+UFeRIrOJvIk+Yim6IgiCEIrCcwF
 VNhl+KnaIrZ2m6zn88EFf3aJFs78IgHF28WcSuqj6uHvelI4jTPxpOiw4PFaBCVxgwRn
 oMQ6T2REKosZzh/VxG205CrdFTgthTOSdS8DRIH1N+rrMlGFTZYfnSSmWaFMDKcXozCC KQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbusr5uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:23:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 454NqQ9i015562;
	Wed, 5 Jun 2024 02:23:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrjd4510-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:23:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwFmyq2wDLiIoBhsOxDQRJcKjDmimdmUq+nEjSG1BUlZUg1T4k2B85svHI1LGvHcOL1fbQj7+gOpHbSobiwV5AiL3gJuNy66fXe6BnPjHFu/cOJDdwK6KSOb8SaFXWzUk4gtWKhq0c2pT/8cQRLzmaT3bSYq5xauEmCNOfYCV++XnJkr288KQ5rgH42x+c/oFMsEm9mmoFQjnNNrwwN29JMA0DWwljKHJhjUpaBxQftaJkOCHfutaOHlJ1CUkv7wj1lLnmhb8x4LMwYZRek+HP3wbYKKaytd2vF8BK2W8K8Gr38Six0SlBRFl+Mv6XG70q8zfSkinbqWE3wm7AkW6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwYH1C48jGJa+eX2LyvKesLr1ajcA1YicltufgNpp/E=;
 b=B/yEe+JvWFMQT+2TOgPP87t6lkScjOAEkLF72Dsst7uAEQw0LL3lBhssNOsIoJNWxW7GyAnsDGnY54W3ZpUNjy9J88UkJBdDqfIceLb0PWRXNgBWlei3sOMk9nrfhCHuco6+Nvz7Aeh025HYFrD/IcO5m8zM6I6ml+jVo/AUPXuHSmGm4NGrQ1J0DEs0sdlfir/cB6eXBAZ9QCR/VSQpw4pns5aJcbuvOQnaNpr8a3kGH/LACB8+iKrjcMJ/zUmOropNoWbQ/d1wHRNsa9zxczWl5s/sFDw6GXpMBJc5OAAcsfBy4rJvvIqPZHlFO1ouhpauJiz+Wb3LmU3w4bKeGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwYH1C48jGJa+eX2LyvKesLr1ajcA1YicltufgNpp/E=;
 b=bYa6gS524Amr4eSe50g4OOTcoVy2UpAPqvMl+rDBqQ43d7NiTmK9jdrdmgkIaKHhgJ1x8nXcCX/gW9r+qqGFRxsKrRMLAsY+cqMfH/tadWtldbOUaW3gahFsjpzmcw6orYFIC9wuOwz4xAifr/dHOrxL3LtUpCUI2PaEwvfyP1o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6106.namprd10.prod.outlook.com (2603:10b6:510:1fa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30; Wed, 5 Jun
 2024 02:23:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 02:23:07 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] Declare local functions static
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240603172311.1587589-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 3 Jun 2024 10:23:07 -0700")
Organization: Oracle Corporation
Message-ID: <yq17cf49lhn.fsf@ca-mkp.ca.oracle.com>
References: <20240603172311.1587589-1-bvanassche@acm.org>
Date: Tue, 04 Jun 2024 22:23:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0023.namprd17.prod.outlook.com
 (2603:10b6:208:15e::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: d7dbda6b-f640-4102-847b-08dc85066fd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?2eBFi0hmDsTBEvkY2kUOoXLlx4sJv/f3hZHERP77CyVtDQAEVmKRf96gL3y/?=
 =?us-ascii?Q?8vNPXltsiXyI6b1wmvTUwVxbWVUI5v62ebGshFLjFvFKcFBvXvHZSu8F5Eqi?=
 =?us-ascii?Q?o5Q0jvCR9ns7/OnkwuKn7poqZNnFRuo0V0eoDafmXJJDZUQmGjexxPzufgoj?=
 =?us-ascii?Q?cbH69JLaPVMOYNBtn9Ek/TDdr/X+3Ho76s8ljG4Ch3U4hgjnaCnYvhaAoidG?=
 =?us-ascii?Q?mnUz50BSlcqGs/DlnynWNexDynXctSLIGHY2jpDDKIlN5WtIdtzL0Up6C68l?=
 =?us-ascii?Q?VnlkAXehaIOmhloxERLw/eUOiVRk6XpSLyGdsxHi4aBeFLhZbWk8K2iDwe3I?=
 =?us-ascii?Q?t5vjXCTgnPQYcqEq7Adu6OuasTIy/HQi8VFRuYNwk66xZBYC3pkNyKrzF4kQ?=
 =?us-ascii?Q?t3ag2fQNE6vmzFANq8TRUuvKNvswbUw5AqiousadvBJmyiA/7AJdH8RnMMov?=
 =?us-ascii?Q?I9Sl3jpMeFuWR0BezmxpJiCIXa2O/IdhV9b87o08m5PUXmXTEJhdW6n6Uapv?=
 =?us-ascii?Q?UwhKpQYw4U0SvkkexT+kZNMgkOggc8LxQ4CS+1CtSO5qCRcYv487qj0Mmybo?=
 =?us-ascii?Q?tBQWxpMXl1I6lkfUac5qBJU1srAYBeX5jz2l0IqVD54YAVqujfd+2DIbpJZo?=
 =?us-ascii?Q?QNUJPWQZYHLeET9LS3h3zPgp7qJCgPGJpoSUEGzczpgN86ov5P6Wj91tY632?=
 =?us-ascii?Q?+V6dq/FC4iT3XJFZNSxtwgtzX4s4yq6mHhrtdcZUJxlCfoOM+wHX1zt5Xo2z?=
 =?us-ascii?Q?e8AuGaFh8SuL6DFBQ2lfTSxJR0zXEnVAkd/CUZYjH4dmKJhXkoTo4jNZTlzv?=
 =?us-ascii?Q?3ciW+w2M5ma9ysl/Fx2Ur3taB9gR6XwF4HnwsYNudvtYKa1jhRCt9eysAlsZ?=
 =?us-ascii?Q?l4N9GwamXPEbdNB2hBJwkJoxIkzhBRxHCSTJOBhHFGwPlN6wYLv/MGmbMSW0?=
 =?us-ascii?Q?AlUY96fMtci5+GocZLdTjRKsGxvrWgBtqlwJyG+bXb3iCnPW+rncLJYmwA7Z?=
 =?us-ascii?Q?VjJbb9HUswtzYa7X2HfBx/uPOFDxU+Wv+DOIuEPm0q7y01s1EU86jWxAO5HX?=
 =?us-ascii?Q?F+CbPtllvuUXLHe4Qq8F41o4ngiaA3eIyEuSOHHRAuOL5MOkylIsMs8IkfPL?=
 =?us-ascii?Q?fdsPOS7vmqd8tYXC5KTWssZfIUuU5DRKTttCu8AHh34Bug71Ht5YJ913MRwV?=
 =?us-ascii?Q?TziPtFIK0BpnLZfwOUrPzMWDdpxUhOXZGkia5SGuVgq+pLTMfpEtpfjK1Vun?=
 =?us-ascii?Q?J4HBgt5qczTfGoOyhGA/sYt9RHQ+hMwIKBrPwKzA5w=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cu42czIOhLtSpNLI+3um2a8o1BZ00oTFaOOHw95Zb5PUp4yXfJOk8p3/tohY?=
 =?us-ascii?Q?zvzLrUsOCCHdKaeJ1CG3goZfQI6tUTXFVS0vYMJ5VBojKWjyemZf1qMmYNx+?=
 =?us-ascii?Q?ymQ7Itsi5NR+5nNIIcdjTaiDyT79ciNS43tmTNsGm+h7KhCsWvzMYDvc1GfH?=
 =?us-ascii?Q?I/byM4vV0ag3XCTQ+xU6yyWXK4P+9k+69B0PMBWvEag9+RY3nvMXE+POQAJE?=
 =?us-ascii?Q?qonE9Ln6YhRugbbb9Ww7iylova1tTvMTNsjN2Yo7WeEmzXgvPVFzmRUoETsm?=
 =?us-ascii?Q?vtgtYbIF3dC02LNDkyr0nVXpSAgm5j40QQN5PixtYYs99Gn8JDhvXT6xDs7f?=
 =?us-ascii?Q?AnMEcROH3hzXWh1IuRlTBAFpzztemmo4dMd0xhpPZDh9/PgoiYN4+KyXxtyg?=
 =?us-ascii?Q?rl/YVO4uQkFB1oY569IA0ZGtbx64Oa5DBNK+q2G3kC/f3TbCWeToFlAG9Z9i?=
 =?us-ascii?Q?t4i1vDPovcrWJgk1/tMsUtuWfxCHajz0iga1t7CidGta7OFJgtaYlWBrW3FQ?=
 =?us-ascii?Q?av7YSmctt6fvpDiVGD6zmUr1ev0Cf8o64utqIcUbdx5Bdnf7EoYbEabsHLM0?=
 =?us-ascii?Q?/RUnG68bxgzO0EsExEUnVxuW8O8KqzYisgUmRp8JF3l+dZig6+S1P4ivrp5y?=
 =?us-ascii?Q?0QihbcgCdMgA188t3eaJcTUWT3PBIHKUrKlcz4EdUcL8pzXEzT0NfUAacSMA?=
 =?us-ascii?Q?D7ByIBGijBZu3BIr7fWBbJ9czRyMRHIC5DH6xGl906bkqiW2oQAG7c9LsJqo?=
 =?us-ascii?Q?4ne9Urg/xnHFIaj5/8x1FSPE7CLAUk0qgXZK+lR1zfXD3D0NPKSQxWvRzO2u?=
 =?us-ascii?Q?Y3B5QF+rrVd9Ub+FVv1I8ArTJS1znLBSS/G2PwhoYETyLPkhZXxI9a1OL5t8?=
 =?us-ascii?Q?4pp5gx8XcOMwswUawk1JX+F+SMc2Ic1EqZzeIjmXg26bYEFg1v9+3WCCPg3m?=
 =?us-ascii?Q?xZPu0Vd2H8A5aKJ2+yWChwudpxqOo+arflw8RJokh5PSqlGqhQunAYrp6ZF7?=
 =?us-ascii?Q?o1sD0Ibi84/uv9PIO+28WMX+xGemRFvImtaKMLFxE2hlfePf2PRRupQ4Z+8Z?=
 =?us-ascii?Q?poL67eKwAn7+iKTVAqD4N3ZQW9mSOi6f1Mxua0OoNi4VTC5yWCCejO6njcGk?=
 =?us-ascii?Q?ZFcfSW3Qp9Yrn1KeskzPOeaNBhFVKbTYNy5BRcRQh/2ed53mNrTqnFsePFXE?=
 =?us-ascii?Q?Ych5IZgDs98N9BY18x0oY+m0SgrzTQ0DBxYbO5TobiTZO37KFwcOPB2Ck9hc?=
 =?us-ascii?Q?Nv2+lX1j0dfyVogOLmGpLbhrX+/p+VUs+bwyj9QYsPWiN6dZPBwXO8P33cFz?=
 =?us-ascii?Q?O5W6OdoJv9lrMzUUDeu/sFfZs3xeWKdIaM6c/3Gje0E6NOHWoXeGpfkG7VMS?=
 =?us-ascii?Q?1gPep+GRzuiy0XRMORGaCLwunF6cGOor6Y/Nk595EbTC2m0FNs/QTpMZlINX?=
 =?us-ascii?Q?JWKmvc11UOR9K0s3YgttaaM8F+estHZ6LDIRGpYq7Gh5YtOFoPZshDSmeyh8?=
 =?us-ascii?Q?DbpalugAjo3voRpsqi4O/TnIlRL4Rs8SX6U0I0Y/KNx48w6zCGO1CsKxO4iC?=
 =?us-ascii?Q?BFgnF5hLDraDVUS0kXajBhh1Z2wwTnwispMHQklEI5oGNRmd/gWHgY265mzB?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	2hHT/YFyrROrb/qIzISfeUNApIL83idtq3FHhXQ69EMm8rvpivEKhM4tz7Vo0zf0EyusR6i6OF6z96aATaCxV3HNUS3CC14e32X9RqOruWyQBsQWINofpQArtBt6TQQyjEjlUf41+ayXjyuVE/450qHBwZ4iDvSduxLsKUNMx6MxblqPJVvaPkXkxzpOMkxVDp57x+mq/P5p+7AHRMG1J0Q1v+ZK3ys/HnO18zPDvLaLxpXZo+K+9ZzVypaOmo3HuOuWeMvQMEjHs/OL6QYmUNfOKo1uGCsYmvOVVqPfKONYLuIJH4koQ3f1o25GDn1iqXVBu7brsoCHSwa+8c2lLC7yd4MBN5wMdPVEhnpktgtkf62WjQpO2UhbxOqU7ejLqr2DcEIJ5rswNdOSQyRjO4yJ1kIwbF0zOB0vz0nJ0jrO0ZIywQFo8IgLmYbcV5JEeT1ZLwiszpJIJHvsBezT7GS5zsVNH0QqcEhYPScuvBPpsgkEvy6DafJ/ZUK8LUS1Vyx5QW6JzXQoo+4bVVIdWykCtJK0Rp+7rLTh3Fb7Zbs0+HoCQ7yhJ3yBZmeqdyJeDESKcNQ9xB3U6moz/2iZTmUdxUzqv6A8r+N9syxJea0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7dbda6b-f640-4102-847b-08dc85066fd3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 02:23:07.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22eMq1dMm/ic2xnusp324dNOgwUzpVptaQrOpQtHEF8dlWIW5NFRmPJFHm3v8jcOFakQ8G81GLTIOXb7XubRyhpvJo8X6d82wNXBpXuKgXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=536 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050017
X-Proofpoint-ORIG-GUID: iNIT-jowGvT9xpxbasqg0FEmrIToOwb4
X-Proofpoint-GUID: iNIT-jowGvT9xpxbasqg0FEmrIToOwb4


Bart,

> There are several 32-bit ARM SCSI drivers that trigger compiler
> warnings about missing function declarations. This patch series fixes
> these compiler warnings by declaring local functions static. Please
> consider this patch series for the next merge window.

Applied to 6.11/scsi-staging, thanks!

Martin
