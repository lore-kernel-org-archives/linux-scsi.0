Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4044B149C41
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 02:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752028158; cv=fail; b=r3sFv9AI9VhNdyPeY+e8lxy43G8+5nMG6dgaMqXM8kY3TLfQIuWDYGe3H/anXZVZnSG6Qalr+VklPg4z8UDO3d5TI9Avo3ZUM3lskoi/eblwbip6wX+4kQXiMO4c5f81seVI2Q3iJmYY5GUfr86NOdcJ7+J58S3vjO7gVO8Shjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752028158; c=relaxed/simple;
	bh=9sZ0ED6jdqWsICfnhQnHykLxtCL362ms/q1YNKDJQXk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HJpnacdLIAnSIoHowddGipZmbyxDiYMks1bYBgiyRU96D6oOBHMY82Kw6cD1lujIAdkNPohsapLNwJwHbFrXP0/Mc9tBVXxsYbnl9D2SHxvh0u1Eq8K4tGMs7D3lODXEpO6E12NwflS7uGoRJcJAD0+6gqOHADb7eUQBof7jrSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sfMzJXfw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rGaKpnXn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sfMzJXfw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rGaKpnXn"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5691b3i3009758;
	Wed, 9 Jul 2025 02:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AaRmb50NbX8PyC/7sY
	Rgj93G8/HfhVtU6Bm/1+tmzWY=; b=sfMzJXfwFWAUOwXg5nmN/+TjswDvJkyaFh
	FxAgwMPQjUIkQJAycrb5huUCwG1i7m2wfOezLdle5uRAr6/ctWj6ip6dSv5DcEh+
	3s/KWJHRAi5393/lugvrcIcwIzh70djOakBbQ/sO6aTMPFVtcegJ3KX4zCHFrUNE
	aBAxG8eVvgmO3X29IZbp6bqohM3DWY/mZ1p4t9iUn6QoC1q6lqV3jbU0TfXQ6Tne
	YtaQiT1jOuurl0jtM51o+epsrRk+AsYNNYYBXuS4jwXaHTTKH0ZGRo70feGJ8dwV
	OPo1L/fXGUz4PrJoPZPXqhFBsbc8rjWwr7ek/qf2gVq8WvcrRb1A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sewn81e5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 02:29:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 569217J2013552;
	Wed, 9 Jul 2025 02:12:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb4e4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 02:12:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s7XFHQqdRQllbhy224xWPpKuBr1cl5/TNKffOzzwMBOoEK1l8kP5sJI2GCO4gqqhhk9kxlbNmhRtQOrZSplIxUssy/bi3LufNnQ/rr4/DYSYjV0ZH7FhRT0T/Ryf7nPMSanYi2mbgwBsfWzBccQx/Gv5BYQLqQtEFGz33Rue53WuvV3OdLnEjYpRlFUDL+59msw/5/eDoqaes6JyyrknuWNHGNCVRBtfJEiEuWPOzD8qYPyVOuNR03UpkC/ihciaNZWyI4JPzKEODjiBbIenl5lwx6vkyYKaEKrsj0uw9b7kNRdiqEMw+UW1MQ3lhVaSMjWQEggc/VvRFfmb/Y5OGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AaRmb50NbX8PyC/7sYRgj93G8/HfhVtU6Bm/1+tmzWY=;
 b=T0DdhvdRklJdKZElvgZFr415qUNWPrtwh+e+KXT3qz/+UIzIC2QEAnNKko/abMTOfnDPItCWEWFGJICVtlPLzQZJ2FDMJpjLSUnZcavptpBjTvHAFg+acrcGGLJhgwUlJwOQf6zEhyIMtUDTGsLTILjx+tbg976i/Co7Jn4Ws26ETlie+/t40OQv44+noPKJCkudeZMm2zy/S4EPft1rhvNHrnl2odsuNRb0mr0V9paKtKQm07NR1lGQfl+REkNfB6oMnN76TvciYfV1PB3J8xpc0MKqUDylUYycKpSEJDtfIu7ABDxTww5OIOO0QqTGWC+oOe1f1EASHjvbgdugwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaRmb50NbX8PyC/7sYRgj93G8/HfhVtU6Bm/1+tmzWY=;
 b=rGaKpnXnLYjQ757WdUH+qyJulxy0Ir32krM6t5nHrXks2t5UHok660xYFJxkCdDchcbgnEefErKFXML2ylhnu9LnkaL9mKbgPsBFcEgG2OgFvQ4u5EeCpDRJcKBjqQvrgxMtSKt24oEwNPtBGMXT5krHNWVAcaJz2fD9T514HGs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7977.namprd10.prod.outlook.com (2603:10b6:8:1a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 02:12:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 02:12:37 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        John Garry
 <john.g.garry@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] scsi: core: Use scsi_cmd_priv() instead of
 open-coding it
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250624210541.512910-4-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 24 Jun 2025 14:05:40 -0700")
Organization: Oracle Corporation
Message-ID: <yq1h5zmcdtf.fsf@ca-mkp.ca.oracle.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
	<20250624210541.512910-4-bvanassche@acm.org>
Date: Tue, 08 Jul 2025 22:12:34 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 1875b873-8ae4-48f3-b4d5-08ddbe8e12f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jDE9iRZJqkkFfLwRwoU9l6A2Q2s3eVOuXM9DCljSWg2Pw0xWGqZv96MiEKoM?=
 =?us-ascii?Q?9ny7LgzYIvKV4ZOBsru8Lpem0dDHfGGs9K7joAcVLEhvl5WAZ3YpmxzUTY6v?=
 =?us-ascii?Q?62ph2KGTpk/S4jgR17EI6/sdI+YpO8MfXoBP6cJovX7f0uts2TUV2lEC6U7T?=
 =?us-ascii?Q?OBORwZMYFLLLEYvADUu+vZBbHrvKyfz48DLpqxnwM9O42ghuWRzJwZ8Z+Tiw?=
 =?us-ascii?Q?955eEj1s2tTJEGBddVVEL5xtc/bLjH6FV/xg1NGcM4lbCKP5tYi1KLx7DKF1?=
 =?us-ascii?Q?Hb4j3IF6Ds0IBbgbR1URIASEHalAJ0EHtWzeJ2EC+Li0g8Z7SEmZODvy/ruq?=
 =?us-ascii?Q?+AsARMhWUtgV+Xu0eiYbg5BlSCG+XUhBdr1nRj1YNIK0CWf1oU49Fr9OVDET?=
 =?us-ascii?Q?xKChc1CBTeAGhqXkgdz18HNvoYF29TMM6JVNzT/LkGxpuP2RnXptv781LMof?=
 =?us-ascii?Q?9mHeiIdSyxXs5FUa3RwBcNnLB1Ia83i7qfaYbURuAnDSTfyzQkH3nhoaVbLq?=
 =?us-ascii?Q?GLTmcwIfWg2CfNCdyb3wwz9KdSSfsyIgGplp9RPwbjN9AUFdfnyHqa39AU8C?=
 =?us-ascii?Q?BgrxIhmbBNj3rnJx8/IbcImDnP4zDesJqClNLiI9aOnAcAIeC0GYahOCdDGc?=
 =?us-ascii?Q?sniYwTQnV+qhXoX/dYJZlVxtXuDv4Sfj6W7KGhik3itlxEvlc9HZUaGpuZ+a?=
 =?us-ascii?Q?pqgTQAbmMbzFMzwskWV74tC0zqwz9zJxwC0xKBaabMu113iPeZwTtmdw5tH7?=
 =?us-ascii?Q?u7aV4XRV7YK17u2kiEh+Pkwath0HSqn6ZGbl7FAxrqqVeaJCIEQeRDXo/Jtc?=
 =?us-ascii?Q?eEsu+824HrWoYMKJXuknnjV6Mwdmwn+ncgHNudZt+rp52Kr42AWPO+6sueLe?=
 =?us-ascii?Q?hTBFzpiqvtxMIYB3ohca+tVp4NYAPTApG4swlDX/jODEX/lE04MuyFDfiSMx?=
 =?us-ascii?Q?h5S2sk0Fb6jT03zPMXcQ658nd+IiTf0Wc4OQwv9wUc7JrEm3oEV1Xv6PG8SU?=
 =?us-ascii?Q?q8yYxq3FXj/IMRkLNQOjvu950Hhh7tPNgKPbRORpinn/HJOmNXuQbcd/Ptem?=
 =?us-ascii?Q?RLsRha+opspeoOYq/gLA7Agznyp8kU4sPzqpik1+6kbgsKjPQP+FwYmcLWZb?=
 =?us-ascii?Q?kwS29ykctI+KMDBYwtsVLNneiD/f0u377mSTwPhM0Ny617YsWE0skl2Y2g/V?=
 =?us-ascii?Q?aH15DMbiieNR+ri55WOb9GsF6zTEWvEZLBbE0451jQo1kXDjSGQSBsdypJYQ?=
 =?us-ascii?Q?nPaHSo0WqFzkZOfQoR/NHEEKxt/nselAnQxdf0QUOE2AFZBEbtAsENV1SIh/?=
 =?us-ascii?Q?CTZwLa+MdmCKHKlMdzzh0IT3uuko+D2qJxLfDUbjaG4J23EeDSsUN5cSiXIp?=
 =?us-ascii?Q?dWtfsfAjLtoOeJF7RbtGw4XSmh/7st1OLq1bhNFHSMMsYHjefFQywFYB5m09?=
 =?us-ascii?Q?5hqH3bnugXU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DW9BL7ZcxeBnfzR2YKdnSmTpyeGOWIyU1Jy4MWk5DNweTjYfRpPV+1mGvCSs?=
 =?us-ascii?Q?Bf+BthhSfvqsumToeF0KGBx9qtU+cyoRggN3ZrVyv/AH94oz+8dtPgBPYpGu?=
 =?us-ascii?Q?/9ec0Fp/aSQYnVw/kK5i63v4GLXausoebCL7htreQ+yxZ1FC+rXYhfhen1Ge?=
 =?us-ascii?Q?UkjTvBgXOB7v2dbnsMsiozugCGNc9kVE6gK7AapOkZlUYQllB5mtqgZv06pA?=
 =?us-ascii?Q?HjkuUrNDQTVUocH5Q+QmKUPfJcIj5Bo+rQQGWIlXwSvDBwUyT1DyGN+KkMk4?=
 =?us-ascii?Q?Wk6QKqJMxyXp8c1oLkkMfrEyDDnBpYXprtWthODmsxucI0KGs8SOYU/pErCN?=
 =?us-ascii?Q?2JJWdLwFIf+XAgb2DlvV+K97i8Xnw84qIP0oLXXLW7e/hjGMR+Fwc/YV2Enr?=
 =?us-ascii?Q?1q6hNNqmrKcJ2SjiLAupGTF/KzRPLOG2YLbGlllFTRwtBMl/lZe3WhUaSuFQ?=
 =?us-ascii?Q?O7m6yw8xPfbTtFUKPCwgqEEmLnvBjIjZAgWCejFqRvmh8MZM5qti2IK+09Vk?=
 =?us-ascii?Q?1yXOsMcucErW1OK0MjYmbSa6+Yt2qhitnLpkmdcRZDT1apMZ2hNVCY7TRk0W?=
 =?us-ascii?Q?SUJlyCD2J5SOYOzTkcatqWAYcvd+c7/Eh7+2lwpZRBSorE0MrsdTxG4YaroW?=
 =?us-ascii?Q?JS594TbqqMr93Fb1l9PatmHUyXdDjgrp7AQtmoOvL4C1g6EGLqzYvlcbJCv9?=
 =?us-ascii?Q?mGzKqVOS4j5Y4U/V3SfT3jK2K3yn1wIJx07V9MN7gua+BprJ3o+iz45fvX3l?=
 =?us-ascii?Q?yGntGspJR2sL7eCjXuXqbkdgCkuTlHzxmiS/MuumugNsVikyVAA/dEc+jXQ6?=
 =?us-ascii?Q?OocGhaDYJPGfVyMVQXZ3PIgQTYl56i+siwE/tFWp2eGuXWzsSZUCKxxC0iiS?=
 =?us-ascii?Q?Zi++5GQVJlcY0nw76kSEbbkg6RCh476Ia2wUXBlEGLDHdn3YGtzrASEXpwrQ?=
 =?us-ascii?Q?OmVDb9B5uP1m3khWJk25uQd/cOURq+a2UMwFc1NoqoOpxoqT5IdgKPNRmoz/?=
 =?us-ascii?Q?+mw1QApsWFkyXMUerdM12totqQt+fxee0IB73Dnl19fJ1oj8Wr2wKQgNe+CI?=
 =?us-ascii?Q?HQPEgSlItAHtaHqyyZB3+zeRO2jxk8HLz8Pk5PH36ciHWt1VeBjMysPN9FOz?=
 =?us-ascii?Q?okDY46kGtZ/WhAQ/np80Jsj4ah5jbOBjjPpD8HtfsYZRpFfGTojxMZieITJW?=
 =?us-ascii?Q?GvsMs9s2UIA9cwyYJAVJYEqV5wLor9lRD7Ko5dle2v6Zwehbcs5wCYvojrDk?=
 =?us-ascii?Q?FX5h+PFySFO2f6G+Qnw7bGA8Ml68fG3eTG9t+/f69p44iWH1fyPakjHkROLz?=
 =?us-ascii?Q?tCY48Ew3KAXJ3vtKGFuBvNNuF0j/MzzW21Ic0OawZPELSOjb+y7p87wKtKeH?=
 =?us-ascii?Q?L3SmLN0W/BYbEMDc5DynaXsikL8Rj6d7fz/+hFend+ruWBxrbk8xDJn9JZgI?=
 =?us-ascii?Q?oOwA7oI8xueqHinnfin4AHNMz3RQsqlwCg5oHcDTa/wWYjaw1W+3krZ/OWy9?=
 =?us-ascii?Q?5+guj4T6BZ3bOqIJaMD3fpmYruwv9m4LljJ6AxlPBErgRKSCDkkg+NJ+TYNV?=
 =?us-ascii?Q?clwZMGd0hQCpSze2PRPRpzKPeILowNZhgGjB7GjMMvRniiU4ebCtNqHtYIoS?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kplgI2pYfofXeEYMNXfcEzLmRggXuTTzIXyMF2wNduJ2zZagv6o6P/AkJgali5ui8+EpOa/boJcqA1IVQ9fAJmF7iEZJOhDs3wxUQrKj2DfEPAPik3q963LZmg6gik3B4Md1gOxmkBK8kUUxbdmI3dBlFwv+kMlZ4f56q82oAT9TS5hxqvFmYylujGmPeOKsk5BOdFpsDRTIRZqtMRwy3SZWh/QcxERTHtsp5RkyZszNQreWLVcLrDFNqqB9ohhJCWGTrWR/GqrzTaJN+asGnzm0frl2/x8fBLD/RloL2ieE5aOZD5Xby88Gxqam+gbvpN/EYD3Yz2Bg9yiSP3ajrjXvFggeyLTQFoVtlt5T1cFoeA7k93Vcf08t68WHIy/ZPHLyZDn0SxMhDYMZPodsXTdtxkmeog2ssQjjKgg7g7jekksYp3jsLWQJR2iQcohxpwpKBh7sVD5gQAjoe5Ur4Ypn66z1ErPc1P8O5gt3hCBdyZiPr4MorLIYsgWWsi2RZTk/UzDtfNFDk2D6I9QDgIkGpEPq1/HPWdn2g26W4SqysDmff89xhgOU6LsPoiCGXLcRznw+DP80dKGMjXzM4yxH1+M4aePSQe9b3Dg3Hqg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1875b873-8ae4-48f3-b4d5-08ddbe8e12f4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 02:12:37.0266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5iQzDx89iwjDaJBAjbuqozUEiK+USnrGvxPO8OGK9rNlLYNNuawYBR05lM5msiXjqOGYWO6Wd07qnPGeZnqcx2tcdQca66T50+i830m9BAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_01,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=931 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090018
X-Authority-Analysis: v=2.4 cv=F6hXdrhN c=1 sm=1 tr=0 ts=686dd3f5 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:13565
X-Proofpoint-ORIG-GUID: UpcNrrrqpP67BeCFiix7KR27xXOILYvx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDAyMSBTYWx0ZWRfXyW1/VlJDCe0m z/K3n/nQnFAfen1H0Sfdz5KUwBJ/FSxQcGccf1veAN9ywrbz2cC2Pg9+6DabK0xMZj2IpfC70MU OZ0LhuV6HmzWQgrOpRq4IhdS5kukWbM8BDwKf4T18RhSTcna1ZANV4rxDcqEle2pB30xYAPBZKl
 hh5fMZ28zuVSgqZyOrflCb6oDhqub3q470w9GDn2TCLunGs30wxAL8psPYhIZjtVdQfRWh9lzOD bmWduNORS8CoPEt8W6CuegLYJ2ItNaV6By2JMCE5T48nJQ9DUxHQ9mjIRVCxUk40Ii4AI4GM5vq wGXz5sTiunYKDRAOI+kmAzKxfhdmgVv+adNghIqh+LSsWl8TpFlv+5ys1/tIozPk0WgYBFK2E/o
 WCJxK2dnGun3Rt2e9ICjrY5Q9QCQbWsDtsrOcz0LJZqcEcVJtCdu2TjFsOf2Lx5V6JCaiYzB
X-Proofpoint-GUID: UpcNrrrqpP67BeCFiix7KR27xXOILYvx


Bart,

> Improve code readability without modifying the behavior of the code.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
