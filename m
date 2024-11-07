Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649E6219CB1
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 21:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013320; cv=fail; b=O92DPBiNhu1OIMAQNPaxLe8VN8NgB1e6G68xTIcMZ/ITY95gZ3/z0bKiTslHNNfsj+WO9ZQ4SDNjkNyd/9Er47Lc4HkiXNEZMR9JKLwmBIMCzQjyNkktwcoj12cYjoC/2D7pPcrmUrX5L74WrRhpPQf59y1jtOcwN3iIdboOx74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013320; c=relaxed/simple;
	bh=pb6L6ooY9mHROOX1NM4256i+tTVWA9xyvFGG3/QY09s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=c6lURmz9jWjyWXI/T4U/mKU1M2MsR5meW+kTdQ6bYg+gI+W5f6I9Ob23imtbKFfqEU8pZ64I9HwRATANd+CTrOFyEX1dxTAY6OPaYA09svtCucALcVQnOOSdqJU+VRn6ku7NdUDZ7giAjMEmy5ukTnjnU2xPirXdeqOjRwFnYW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ghNaukqO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=opuNGTrU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ghNaukqO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="opuNGTrU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7KfeFF015577;
	Thu, 7 Nov 2024 21:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=bhnpz1vpKWheN6MuTp
	iF5xXRVnINstf7BU5gXs/lRQ0=; b=ghNaukqOajhHKexvHZ//AUEZGeR7hRewj3
	FPIzSbOxC49YD5U8deuDu7pnCB0FV50Jt4V1Ox/8XlOe2oCQJQse8tSX1INX/FkU
	IPI2FJVP67Ectal3yt9698jbVEP4BbqBHsmpjdJFa2PL80zTg+Lg6Dk+p0Ez7c5n
	SUbd4kkubwqEBPwA+SkWAOksQd/Oi1/iqaAfqL4lDeelvGwM0cgiN10PtXp3VzP/
	mSnmQ5Mxy8b/qVdxKr4YSyV6gEdB80xrm2d/6eEx0AaRsIe3gxNivuSrR5RhVTIg
	XLOY3Oxpl+ooHuFhGhwjVIwJEo9R+CwQZng9kmTpm8turgjUEyiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nagcbk88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 21:01:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7JSJto039067;
	Thu, 7 Nov 2024 21:01:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2047.outbound.protection.outlook.com [104.47.70.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahgxbbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 21:01:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yabb5K8mLszEcdSwEovdxhLstaPzIE9rL7SBZGQErKhVTeh7P9IJR2vyuwXj/zI5d1y/1nhFrUaEchksGMr5ABtAcTPjMVqvaMyih8FmFnRnBAn+r0y2qy3gHbGhG6Yysve8TrXgSIPBeGAwXWswMs34KaDHKPItZTa68Cua7j+J0kw55Af1oBwn/RVS1t0SeHJ4wNdtmWTzV1KeYilIV49mhQlKXOJEOGNRks5p/gwsdN8w1c9Crun58USc3ZszuW5BbARt5C8ByWHROHnbF7X3/5iVbZTfzE+zfcz9gL1TEo2rq779Gf9fh7A6okG6v62muacbfI0qeyzt0oxcoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhnpz1vpKWheN6MuTpiF5xXRVnINstf7BU5gXs/lRQ0=;
 b=pumzeGEx2ILvjqFaPu6WDofzpcS/3aD01dQjMoDovN8MlusvTJ/LIuzMlED0L/buwg788N+JwUVpWLhEvrcNCFqiBQTxvFP734Rae4mWUDZpq+8XCIYWMaQ5Mm3rz4RE0M7bQE+ERKTDs8+Bp6dCi2xzi+q9YLmIDMsJGxZMphV1umA4ZkhMqfJbjEbbWynkZzCOO/2tzHSXs1JYps9svfp2enRT/Od6WcJQf/+G1idlTNeuJvXimW9CxlDQP5CbXB3cLvGcn3xP6vtEgweQjW9ESCfvPHPdzLiLh+Ff5C+vjMKEeM1MaeOjHLOXBkcXxjzsvru9hY+K37x07tQk5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhnpz1vpKWheN6MuTpiF5xXRVnINstf7BU5gXs/lRQ0=;
 b=opuNGTrU2CNtcD5WbRAnuu4aQyCRm2pRqCvsAe6HdL1IpydDpkjmIofwjGJvuB3SREuK+Hil0xOdfbtxs8K/KUYv81A7/cOB+xcZEUIQRWIv0/x0nmcoNdR4ZvABYl5JWKSyNi4mvm+dZlPoAujb+S/wG+yn+FwkjZxcKdD7iS0=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by BY5PR10MB4210.namprd10.prod.outlook.com (2603:10b6:a03:201::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 21:01:51 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 21:01:51 +0000
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: Johannes Thumshirn <jth@kernel.org>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        WenRuo Qu
 <wqu@suse.com>, Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: use kvzalloc to allocate report zones buffer
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cfea0fb9-b361-4732-849f-baae9edeb920@wdc.com> (Johannes
	Thumshirn's message of "Thu, 7 Nov 2024 08:46:00 +0000")
Organization: Oracle Corporation
Message-ID: <yq1ldxuydlv.fsf@ca-mkp.ca.oracle.com>
References: <20241030110253.11718-1-jth@kernel.org>
	<cfea0fb9-b361-4732-849f-baae9edeb920@wdc.com>
Date: Thu, 07 Nov 2024 16:01:49 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0142.namprd04.prod.outlook.com
 (2603:10b6:408:ed::27) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|BY5PR10MB4210:EE_
X-MS-Office365-Filtering-Correlation-Id: ca01f9dd-2bae-40c1-7af0-08dcff6f66d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LJ+dx9kzVo++Bbuj5yNpi1DdJw2b23seIRVToJCAfurQFUs63fh3m1KRthaB?=
 =?us-ascii?Q?aCXTFPYgu1CFoNOWPk9LdLwvzOQ65UbmuJMyP8YebmM9vARWJAWHB+fbtq4D?=
 =?us-ascii?Q?e9+LLop7eW5r56QhXvtQOgq+JOdII86yr3n9n0P+Hu5M4Bm8HAUw1ipHN3An?=
 =?us-ascii?Q?UXj7xy9oybzCuUn0mih7W3iFNsNeQ/4z5YOjo2IZU8EiG5OUIwD22VcQyQqH?=
 =?us-ascii?Q?l6/Tr/kerRwyo4yhTcXWS6FhX50xkSMi5o56ZY6neiTRXyXicW8c2M3B3UrK?=
 =?us-ascii?Q?h6bHQnKGbu6mHmMspfyqRqVPQ92LI8Nlpu1Nk+yyRRf4Znwkg3pa96702res?=
 =?us-ascii?Q?WgOuP5Bu0rb3cy3TSxu18cSM0sOtJ8ftuMCFDDcV+6jzM+aXQBdmMOFuDqJt?=
 =?us-ascii?Q?vxG+E4D4Gsx/yJPtWV555lBe4CsEODgNoMLL/+uROtINqTsZ8BODjUs724KE?=
 =?us-ascii?Q?F8CclHNpUenpcVphHMrzVAAKojBwq0HIzDzUYqd9hP1OBYkV2EUu0lUqh+Fi?=
 =?us-ascii?Q?ztZVQsd6ogZIlS/yO1X2l/EgNJvZHI0mLfB4sz098ta405klAAoz0YsHlP+R?=
 =?us-ascii?Q?6+nA3cT9HI6Pj4LTkneBJ9mV7fRG5Mm/hgtfKmhEQpkiLhfEKVQv+UCXzo2g?=
 =?us-ascii?Q?8SRjBFBHROTBUWUocxkECqJyUkhKLsI0sb1spJnKOlgHb8XSsJP3d7LRLzf7?=
 =?us-ascii?Q?qITOOkSx7vahe9/x2V6LfD7jgwNCk2OXYgQ20tHOWYyzMaYWIckKJ7Qhmpv0?=
 =?us-ascii?Q?RK6zNl8L2cVww7eKzDrDMLJ/A6h3hkjmaxxeWJSNzk0FQJV/85M6nAwX0oMQ?=
 =?us-ascii?Q?1QsAOlTa4aLlWjx64cnl0yMX+kmluIRsrQ89XcZu/DdVX/MCK5tkbJUVLoMP?=
 =?us-ascii?Q?Lhw4wA5U3YER+Cs81rV2hwUxycTqEuwGjimyDAfkqPZ7E6J/lK0nOhISUtje?=
 =?us-ascii?Q?8pHcO6e9dzKqnGhU2EyQXeCIZ02Tu8qTS4K0sITQkeMRnsSORme0LJoY+tdv?=
 =?us-ascii?Q?n8oySQJi+JVjWjgXWOcyruo5S9eUcRt+HNZPv9ExLtdaqcbwYKJKWIO8c8kg?=
 =?us-ascii?Q?JhgqGPbvsJsh7Jl65S7g0aDMbaex4OstXROkQh9jfXfZ+OhdZQY7VOm5Jaqb?=
 =?us-ascii?Q?9Oa2L30yrcpcIFzneI/1HC+n5BRdpvaJwTryWOC40jppb8GWXUuOOX27L973?=
 =?us-ascii?Q?rAEQK3kKGr23xC1OEtHEA2J2xCAllGOruvGg4HVow2DugKtrPRfRBiehEGjY?=
 =?us-ascii?Q?uMBy22TC3AD57v3Q3XbxWN5zWdGBfXm7CELKvC8KoXrLsCxo9vgNz3FeCxNV?=
 =?us-ascii?Q?kXP4PFgZzNMmr2mTPxx5PD0m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/C0SCHjWjD/WyVtWVMkABjmUivcDqXhmxiXGqPDuMjbyunRdqGx9lWXhyabn?=
 =?us-ascii?Q?VkUkT3vdR6nJcqq0f+ACiIWL0k2DW+tSfNKKLb5l2o4JkjKhX5QgQQBWMDAK?=
 =?us-ascii?Q?sOgYx8RuNkxN2p/l1lPeQof1fG00QHeawwqRb9RndBYXWRIeHYfvbXLCfAYX?=
 =?us-ascii?Q?7HGoszFrW7Lo58gKzzT9mJTt/yGb7d+VZoh9rlIlmHJuGH8SKyJGhSUlw595?=
 =?us-ascii?Q?91vrjcXHUqf96uOaZGl9jd1oD/tpX0PKGcreAr4cUMtnY/wFu2B69FNOm0sL?=
 =?us-ascii?Q?Dtta4aNZogejik/jNDEfvcR6EfFTkbGNQVnnVizJK6iU9WY41q1GgiFAplku?=
 =?us-ascii?Q?BNwKJXZEBvFvFGLK6YDP11FpYGv1gHbqArjOl6AAkIAp5QRXiL8vVdqx8go8?=
 =?us-ascii?Q?GJDQYD0Pr03ds/nxythaPqHzlPnReAKy8v0BzhxIhbAYujTSjhKjgi94zUrv?=
 =?us-ascii?Q?cvvJKKSbuccjWfV1Qdb4zFrQHp/GAncvas/JCMbGBs/T1MAaT07ek3vpWw3y?=
 =?us-ascii?Q?WUbJAtcMNBunmvzYVFzXo5O8mzAVnvjaLoZoIkkeSfyCnz9WtcjMShrlaJmg?=
 =?us-ascii?Q?jDhk513JIv5iviMNOky9qL3f6rRJPq3V5gU1ck1l9VLN7f/Vvq5GK64qgnIo?=
 =?us-ascii?Q?Iax+ciTc/NPChv9i8Dtk3RVV18qIaDjocfPUnIXFuXfdZ9BVC38oklIYbdHG?=
 =?us-ascii?Q?WBPfHTl+atZMclkP6UzOJjqV0E0E/NA7YTDN3G+oNeVmfzpRc3SOjArdb0Z4?=
 =?us-ascii?Q?2tmJl7V+/lxTbUdvdFBH9D6sf5OzfHMxUmEo2x5E7KAr+s3iv9zlheDWEBu5?=
 =?us-ascii?Q?m41CuY1Q/32wypMgBJOt9FtQVG4OnKLx18IQjosm+ZVS5Zzwl4lMIWMe3HQC?=
 =?us-ascii?Q?hibvVgUsfHuDHNFkvGqFPJ5lUIFrZ+RwCEDfujHiYpRySXtFWK9d3FjqteE8?=
 =?us-ascii?Q?kKvLFhKLIUGaFQiSPdO3GRW2zP3bCsWQ6aEqfQJkpKDajdGZH7/MLCNqOXbZ?=
 =?us-ascii?Q?ksUHTjJUgf6Qyn9uc60sEdaE3kJLmjfoysGiORyfgtP6rR9shr8V4WFx1ek5?=
 =?us-ascii?Q?XF7bkCBp9Rhbi2HXiKpiVr9tLlU6mqbfS3jUj+wmBUI2whTChYLgJvg6qQbl?=
 =?us-ascii?Q?ggcvxo9WW2E0MOww9Oz4uu122sI5LEaaht5BIrICFf2En9WgCmALhprZTK2V?=
 =?us-ascii?Q?fo/bvGdlR8mFmr45KsrYmZj5G66OdoxyoGs0bQQ+wqBLnIe3WSj/4JOsxSYS?=
 =?us-ascii?Q?sNy/+a7N4ulqHdWusxsJsKigY5sRElgy5Rix0rU/f0uGpTGZbHrZT5qpqX+Z?=
 =?us-ascii?Q?d8r5jnK8vNzNOdw6Il30wgxgcpbSUo7lF+oLgMUq7yXcu1niWMJQdeaX8uOz?=
 =?us-ascii?Q?iHDYw2XKoQdzWJshUJtrn5RkjSQ6qIz4YrlNxRUDVF4RwhnM7v9phGv5dDBD?=
 =?us-ascii?Q?DHUbq2vT5+nCoYCdwgZUR4FN64mLLvx2ly+A3A/tYtb4RAXHPU1TQEmEDe98?=
 =?us-ascii?Q?AWS90plVFHzAXdCqd5lALuD1G3wByFv6v/IO12dhwcnP1+Kp2E065W01YjkT?=
 =?us-ascii?Q?FZ4UGBqGf0oV8eCy/T7MlVo1xLDj999IF7O7tXd0D6cESBPvHjuKzWY8IdmP?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mEXuafnRQAXs3MUQp6ARQaZDNDkqpoWuQype+jUWifqGOtm9IiFJa5DUvSaBvA3PmgnvQ5V9mEsr+LFTORPHVkdZAYKudy6SwgK9y8Rdyc/bbitgnugM/0Gzc9MpxZBV6Bs3hI/XVOL6rjErJXTIGOnHDq1JoYbXH9PVBPtAUn6MeqHqmSOWq8Tgfb2DFSz5nMRo5Wh4TA0bAViUfph1y8JcqoEz1gHTj+CqYhcXiLkVCDtNe8Qqyq8GSUux8yKJE/qSwaK4uY9FDRMBBd7BYwY7GF3Mzx0CitCg0iPdBD32pJ32cm2XCXl4xlM+08k42SK7t9VCNsbELqkEK2Sd+UaOM5hvJ2mWqESguBijGHZrbi3vbrj1FEQ+23HYybcRPulZVXJJyGurEHrSaDR/Wm51RFTIZfjKLO7RPSZck/mdmIQqLXhu6qTBAbbE2zSFZo0qn9NQsJyW0PgeZ+ewf+yUDxiQu0jx9vEyFi/0hL+6w2nBE5IeB/i1mC9cF7pRqQSr3wTdOGi+02+t/QqHhJ4/nmkWNMYbqz90CnZUnenvY8rW9tBInPhSkzvEERYYLPbNQH76EVbWmgVNksoOw01PpGY5m20LRdmAaPr7ezA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca01f9dd-2bae-40c1-7af0-08dcff6f66d1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 21:01:51.2109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8zJnkxEReDUS4BVPKu+DJIHuSiI5Cqt9yJQRkrhjSwhFphEN5Sql28fr1ycQFzoLVrYMBntJUfw03NtAewLOzmk73z9clE5wZW0oL0ZXIcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4210
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_10,2024-11-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=497 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411070164
X-Proofpoint-ORIG-GUID: n_jJqAKLNQXNdJp1EdYjNoQ_VbPBLn6l
X-Proofpoint-GUID: n_jJqAKLNQXNdJp1EdYjNoQ_VbPBLn6l


Hi Johannes!

> ping?

It's already in scsi-fixes:

  https://git.kernel.org/mkp/scsi/c/7ce3e6107103

I don't see a corresponding merge notification mail in lore but the
patch is marked Accepted in patchwork. b4 gets confused sometimes...

-- 
Martin K. Petersen	Oracle Linux Engineering
