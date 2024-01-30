Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BDA364C6
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 02:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706581526; cv=fail; b=R5vzqkiCepEDOwEzVg9PzQwSCD0tQEQm9v2X0BHHDcAMwAnpak+krC2qXbY0jun6pzJhlxdsQLzp/eV+jw1x0GHjDeIt79KPXYQTzvlcGoBxx68Wm+YSgNu1taJLx56WAY4vN5khP+s7Qi3f2baHRChz2JL6tq3SDx04QVNsPBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706581526; c=relaxed/simple;
	bh=5uJ2r2aj51UHvSSTnIFtOo/1P+KcKF6JNxGsS3JagUc=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=YwmMXfTRs4Hq4V+WpDQmdpjDrxcgSQf6uL46zR+EOPw/mC0nwTNXXu1RxYB7668lBgtoXIp6Q7JRZwOqny/snLUMF2Rd4AGxci5hHUoDkyCgjMaNFroRCTmlBMWYuMzTC2a9/oKpq1s7Ji90nNdX7QwGd5/au6zLBNBI0adLMFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QUQ5U/FM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zyYr2Fmf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QUQ5U/FM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zyYr2Fmf"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TJiOKb022267;
	Tue, 30 Jan 2024 02:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=6u0LuWV/gnnu316c1tyTxh6nqzj2AntTV7GCabIAxP4=;
 b=QUQ5U/FMCMlUkoor63/ZnV2jH2H8/rZFfrlgtFv5APNmovNda2ngsdJqfESA/OAfTsBY
 o/KoVjGa5jtqoKfkMx54QZMIn8tEHHG2SaCn0ynXFau6Sqk/5LPrIkAuya6fKuwcUNgZ
 xjH4otsJHVH7e3v82Ss/u2po8v7palcJNZ5hAs0S5YU29fSqKb8jGXVgYR/jOLGVd8Vj
 HMZy2o5w8oY2n00h5KCRWbn9gd2BIIpIhuRVk6BQQEct7vPQa/0kTpbTrR+D6F9Ji0jX
 nzd1NMz/Qitbg5Li90IUZ2xq/QMieajHIgIsgRLtKgCeHzyMcYi1IvpFpvtda8avqVbv Tw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2dkc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:25:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40U14XM2035398;
	Tue, 30 Jan 2024 02:25:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9cgt3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:25:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYtap/lA/Rf+sa4JwVHPsq2I+Cg75aw2V222k0CZaZtrW+P3o0GGuLM8gPexRIWMrU7uZmisPL2w0QuZCf+4dIHDYlCBFKGhkFqQbmitNUUXCK5tCFt14plOCEXz0HTtFoa/tkeQk1ipw100vNyqOW8/f9Q+aiZLzt9JhImnK2GcPoW5dx45YHhY2z6hxHcI6lju4WOrcah4FZeB6Ky8qARpvK1UJsJ7UVjxyXrrmPHhIlSz+NYEhW5Q5ovjmBVbSYuK+ecGDOt581tVaqbGruBZNdvmcZj3VBA8+pMuHD1XavrBJj29OiYWeWKMcz60fcLmICdssYQyOZRwyoSB0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6u0LuWV/gnnu316c1tyTxh6nqzj2AntTV7GCabIAxP4=;
 b=I8X+fzuL9RXzH6/yCjiPowyQkmRkKF2RmRObASIvsn36ZthtbyvQuyQO1MRX2n4syQ/sVC+DrjHLqDeLY9FbJWVntexXv6xwvOe4/F2VpRQiigyIKi5p4Y/uoSuLZcylN45Tygc1gIa3r8MFPceckbYb8DgUj+uYo2bOWkz5wlbVXhB95MOvjhAmghQUnABOC5DT4BMUK4Z25gRiNjhKyF3EQN2WTo5v5pCksldRYK9VHhbSqyA2ZrbZWACvTewKRWdoWmw0+/1tjqrvUftUgrJ4aIBFQgaNtO67rH2LP+cJ/ciykqJ8rmyDhqpnPXL8tRgHiSBGzHPson3UxTP74Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6u0LuWV/gnnu316c1tyTxh6nqzj2AntTV7GCabIAxP4=;
 b=zyYr2FmfZRNUzYShK7aHBGQkhL0NM3c/VlNrLSRGK6TQGvZ5k3g6zXV0rPONc/Iw4IQ7RTup+u0kDoXo8w43eDVqowHLIO4eO7K/KZWmppFEZ9wKJFIc1OCYFEORmLXXbg1wM1iBGgnt5gPdfp7LDxE3iX1MQZcJbI9FM/MTpzg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5212.namprd10.prod.outlook.com (2603:10b6:610:c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 02:25:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 02:25:10 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v13 00/19] scsi: Allow scsi_execute users to request
 retries
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq134uftv61.fsf@ca-mkp.ca.oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Date: Mon, 29 Jan 2024 21:25:08 -0500
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com> (Mike
	Christie's message of "Mon, 22 Jan 2024 18:22:01 -0600")
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0039.namprd17.prod.outlook.com
 (2603:10b6:510:323::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5212:EE_
X-MS-Office365-Filtering-Correlation-Id: eb24ba32-7533-407b-7708-08dc213aaeaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GZepbfxi0jlMOwNg2Hd6EcNjxDOWZstG6P2MyL0uWYeLtH4oDF17F1SFRMbt4TBtAlSyPZlSsLr6HktpJQVrOO2XB3gap8hol3MgJk50XdcHApSsRDCf8aJrieZW/V44jdM8Pb/jOpfU2wULWHhsm6PzuERyqd2EA+MbZx38F2IXBv14/nZglAVqbRngrGwtBjqhDR+BaLk9sVGo3uE5Q9J8ql/miJfUhBraRgT4mA5BWVph4+ZLpWych8HNQNVuddczhFN7DWJNpDj+ZSa4Q/37Fso/26SbFdcSuoocHNnFOH4bJfTd3n3aAGqeb9cZJ2XXLbhnJ664eE9f8YljEnrmigd8T8uK8dYiumyYwEk6UbvE5vzIvQuX/3nEB036j/hZ0KvX249ECsL2BvAeQpvS7v9jC3JgiHADa00ve/GSyC5rQ6BgNj+ijePzKpJtC0pBjzBdwrMcKqWT7fF0k3NMD6Xx9O5yDfjYVjJGQt/eaXC3Ko+M2onCyiLa6diLOKrl9QEiFD5mx6gwlUknwhHHQUHypDGNpMaVmp62TCBmi7Qnhr5N8QVJPkdXosL6
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(376002)(39860400002)(136003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(41300700001)(2906002)(5660300002)(66556008)(86362001)(6636002)(66946007)(66476007)(316002)(36916002)(478600001)(6486002)(26005)(6862004)(6512007)(8936002)(8676002)(6506007)(4326008)(558084003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tqoMXtQqLzr57C/VzN7Bjio70XDmsQ7Pa83j7ozprTI5LBcI59i34mZ9CED0?=
 =?us-ascii?Q?L558bREjcqHuPQWkOMD7LYjgIjY7g/FjirONAXmaFT/4Dwf2Avv2EcoJKSMU?=
 =?us-ascii?Q?wLWtMlFuKPZ/NqJlZTbhjlDh3nG4gu5xIVCy2HU7ery9UetgVTzghE8U1Ynn?=
 =?us-ascii?Q?zUeRAXuzosuk2Z45CgWc4E4G1pckbGJsSSTkFgu0p0/GiPQZi+8RuYVKRdEW?=
 =?us-ascii?Q?/87oGxiyKgNLOugo5b02jMfekfZ/g3TaK9y5I+m4izHZM0SZV63/U3/zl+uj?=
 =?us-ascii?Q?cBu/7m2ddA4RHrrJTJI2XqAIiD/wKSQGbn0WBykogc0f31rGhq9qqVUevs01?=
 =?us-ascii?Q?nIh2IAzpeDyLOwk16lcETmo/3psKe40jy/RrAMYxRTqNyX6QK6fCTc9+9XH+?=
 =?us-ascii?Q?gp4OuthO2yh+5tjSUVb6UYD7sFj9kYeUqFWUs7c6izkLo8m/sQG1uhkBgzx7?=
 =?us-ascii?Q?muo0LVyuczWEZzlEffBKtJAx285G2Kz98zcQE+neEoLeuY43GA/zZdU6YUTo?=
 =?us-ascii?Q?bu8cXeVJ5NMO080N4tFdEzY1HdCCrgSOjQSDaDP3yNXn1lnupSEo92H1Mkxb?=
 =?us-ascii?Q?xsFyk3JZ5oV0IQmIEzK6PfR0nsOdmAMEQSKn4Nm5RHi5naGovFepQ2AuQNA9?=
 =?us-ascii?Q?TxrNr93nlQe8xqg5DfsDreWYs+LQ1d1AKhYthwro5VEWVzrS0c1dqeS0jWYm?=
 =?us-ascii?Q?V604FXiWIobcO2Ygz+gHQBTNsCg54X6saFW4lQ68heIh7NtrGvmokXkdm+5E?=
 =?us-ascii?Q?5nhCROP/kQIHmEquS1eYIW3DPw0mAImHPKKX6IgEnqj+3n594am8CfQbUgCZ?=
 =?us-ascii?Q?PGv4GNtksdUjrynn7p6m22W8qcycjJT1bqjxzNKo5MZYflseXKEMB9t0u/69?=
 =?us-ascii?Q?BYbugLbY+dgLo1Pp7Fv6+ehxENBq5fvF7IYUPoSocgfefMvJqR0paBIXQz+K?=
 =?us-ascii?Q?KNCeKBr1hNYtN4EKtZka1Duhvb8hXa9Ft/1XoCwWp7w/C+NPkhhfycMsM/Kx?=
 =?us-ascii?Q?20Ur+fxElYC4z0gsl4Mo/8jdHp5PIQuQfYMR7FUkJ78trsr/tIN2dM+pOQ9Y?=
 =?us-ascii?Q?peVzxUTMcZB3+WDV/SjASXjZcLzEsAQGovdQZo07OFEEFsm/HhKW5D8t+suM?=
 =?us-ascii?Q?015aovWFEUApHZIbMwo/45RVdIYOnUOJzO9dsRqk3sZ+wST91O90rpI6zWfn?=
 =?us-ascii?Q?kMynASne8nI0JkgnDZ9tSgf/iCPf9pnff9nV7UkbbMUa8eMookbkbI4LsRh3?=
 =?us-ascii?Q?q5FQe6ftwgEIa9F7cn08L2WnEcLw1inr4ZSTU7Mxn+SHurmLEZ4sLY/YQ9o8?=
 =?us-ascii?Q?BbpUIquTXYLPNLfPxSYPfq5oY1WbgnedSJH7n9QH1I5GYMlyD5LivjQLU4q9?=
 =?us-ascii?Q?hi3YARBHrYI1hVQVBYUS4HVC66I+vK3vDF32JSQ+Nx5gvaD0hfiJmbAQ2NEG?=
 =?us-ascii?Q?RvAhoE8xuSIrI1oKGozS+EmMmrqSjOO1Wc2pZOxMsXSuEYfsT7h7QpvzuFRv?=
 =?us-ascii?Q?+6wXsnlhgZiapTRvqFumDCZRUR6gkfFtVHXbS/XW1wiM7fBxkSbeV52WIuqS?=
 =?us-ascii?Q?kalpxilfDtIjic/I/Mu3VPtwbFad3mtN9WSgPWjS8h4Hi9wNew/8QAVcWldx?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	42Cdu/wxLv0zH7tPGQRPfL2+miYmmc5HIkZiu0XLI1do7DYML5zhGz6u7gPt2y1xsY5kV/ieZIsVEEPd3Dk+vcsCVTXozRjsCoYCwac2SbZKZhymaVoNhzugNezshsx0/Z7P2fC8eIo23SOhdMrgvU4Pj+KrxSvhUpnO5Gq9Dz+iJrjGscY75snvOqKcDuYjhs6WjqlokpNlaP8aUe0zrj8hCEPAjKGb81TPXK286VnQUkLkymFkoW7k+76opoJJBGczgV1GE37t94b0BfvE+eZuwsxqA8f0QxOuedtyyeFdWdujsQ3Kh5Xix/chkeJj9NqvALX8TX7r/CU4bFa8gP7DOspZfEp0O6WCYgRiaWi/J6JV19kcHtoETm2xFpewz23NbJFI+BtytPo1+gk0r9j3XO9iw44uAfoPCeTL7nEixKP90yzjpMnxYWrm3ZUjSTVI1wYkaMJzjIv6ArRwnEUtneKocdzKlLgbnbyF2f6crwN7g+OorJ4LwIljIhOfDJC7gLQ1Rqe/d1OrldqcWOGy5JS0snzen+udFYhYtiUBRw7mGiBYMrHLILK3TYOzC84Wr52ve/JPOC5jjcPoearMHNcccABfN+VKucyvcZ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb24ba32-7533-407b-7708-08dc213aaeaf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 02:25:10.4001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JlHBFKeTFi+tWRArdaoVX5tvIu5XnvSXSyE3a/JZbA6w2k1iEGGszG/Ff8zCPBbC2bjE9z3/ulCn9khK49ut3VhY55fBdpXqE3Y4rNGzAbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5212
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_15,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=918 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300015
X-Proofpoint-GUID: rveEE_fgl_t7DIjFvSJRf6k3mHCrTQ4p
X-Proofpoint-ORIG-GUID: rveEE_fgl_t7DIjFvSJRf6k3mHCrTQ4p


Mike,

> The patches allow scsi_execute_cmd users to have scsi-ml retry the
> cmd for it instead of the caller having to parse the error and loop
> itself.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
