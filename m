Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F027EACE
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 03:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740367189; cv=fail; b=S5v9rufTehzPoizv3FM5dTXOgoQzzZ2ZpUvpWOyqwhLlOlDyADCx5DYEHkdDQ1RmXbirxnUXeA8AXoYjQVlVjILiywfCB7u8MNwnpUPdF1WqOrtvVTe77xPQAD0CNWGST6JxHbN2sh9uJzyxalShtJIOsWiBYlDaksr3sTqExSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740367189; c=relaxed/simple;
	bh=lagIIfyzQ4xjVeDJeHqs/70WCjYKi+9zrW97TsYC5pg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ObXrnM3wB0GRp62oMhwTYbTdXpWvFS+bApjS5vr6jgM2Wxu9Jhl+35lj0fcawU0M5KUmGTHpOhWhaY0J/rkhPOl60y9CVWFQE7iEYWcxKTpUz7ncvYLGTLilmKAbmIf6CHzLGTidQfH8fazwx4N2fOSpKw8cvNQ2aoZzn3h6VK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fztONsSl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vSLgQ1jf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fztONsSl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vSLgQ1jf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51O1BbGa001719;
	Mon, 24 Feb 2025 03:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=y8rL/dN18B6/U93cOl
	AnZx6QfGidiWpaXpsPW4XpEU8=; b=fztONsSlOPW6Plg1vi6bLEQEGbkBN6r6tn
	PDfxeUcbIU0CrLNLbWXY7uwJvaYLb/UVv9ozQ2bZ2lRTPSUk9h+Xtp+V7U0rE6I1
	DNZqXV+OPJVFNVRpyD+uehqcNu2uB/g+GqCoPpPMv5KjYj0jBU8Em2aMng2En1OL
	YxsMWPgEbBJppeBOINuNtyqSeHQ6kbeqZaVb/GxWSy3mafUO8z2aPccjqOE0R6AQ
	lJykpcqm2UKvACSq9lkyO7zOD64tSWiG7av1/KCM/kum6MvHljOum1Pz3O6CCv/a
	VIsC5U0H3yXeFzJVYXdVuaxxCRZ+/pLJEYg9hTbMact69pFafMsw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y66s9pg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 03:19:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51NMt2SG024310;
	Mon, 24 Feb 2025 03:19:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y517479n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 03:19:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dGrq2cjfijV1nfhfsKV62Whs0zvSLWjCY2s7dk1Ayo0TJMavz/2S/AWV+0Ep//qm8MhJ/788yZ4ktFBvFrNSpDt05FysyQy4Z8orgAbIctT6riqi032Q9yQzmWrfUQB0iOBqqAxHXra34LE+nxF+jk+L7MVvjJesxFMUqn0S+Wlwn6Le/3RNmyHl+yIozTsww9heRHGKPmUAVQ7LitEWsY6APVRHIPEoJjoKgGgWRyvO8eF1dZDcZuKYiqmwAsSuRVGT4QM7qQ5i4YEYC81cG+gMj9Od57mZJ1bnrohM3nSv0em/SeZ6bhcDKQkWH0eAyV6frUT23rltgbNdW7UKaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8rL/dN18B6/U93cOlAnZx6QfGidiWpaXpsPW4XpEU8=;
 b=GK5HTkFy/4DGpG2+pdDcIAzizb2A6ISEimg/d4BsV9Ank6YjW+gU6T99Y4UdR8pc4sZWi+oo51lJklGqeUNjqHjy5IZw+a+EWgNUduItmKnsHjSAwnNODUJ5OOxK6j+Da0RFS44WULJERiVd9FPy3qAlGBxpy78l0qEBQ5RovNLZ5jxFuq4H+WjeVPnKxjeFcEWEm9n7W72talL4JYDmCgdR26Op8+nXqIy6NzkXHdJHXrb6H7Qs6qiVhUrY4dMyToKviiddCjZ2AXTlYt1S+PX1SOEVa7jhTk4IWkoku3CjMcInO7c39f+BJC3Y0N2ssB2H7BzWSAEaZ7RbafxTMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8rL/dN18B6/U93cOlAnZx6QfGidiWpaXpsPW4XpEU8=;
 b=vSLgQ1jfrj1zaaDzlOGyyJ/jBXDevnRMFyg4gsT0FJAkoUBxLj3t+pMxIFLL8LyxHXlOOEzMleAauQJVT8OE9bt99rRanQEmFjYIBllUTGofEKPmB4I+ZSYZh5piDsmi02aOfj/P6CRGv/4il52EU0e1H3T2M3VlgxRuHqrb1yA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB4866.namprd10.prod.outlook.com (2603:10b6:208:325::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 03:19:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8466.016; Mon, 24 Feb 2025
 03:19:31 +0000
To: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        jmeneghi@redhat.com
Subject: Re: [PATCH v2 0/7] scsi: scsi_debug: Add more tape support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi> ("Kai
	=?utf-8?Q?M=C3=A4kisara=22's?= message of "Thu, 13 Feb 2025 11:26:29
 +0200")
Organization: Oracle Corporation
Message-ID: <yq134g4f2xp.fsf@ca-mkp.ca.oracle.com>
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
Date: Sun, 23 Feb 2025 22:19:28 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB4866:EE_
X-MS-Office365-Filtering-Correlation-Id: 680ba6c4-e4cc-4986-6932-08dd54820db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GUnIzYmfcaI5glMvZird7RL5l4LX+fMyhI/Gqg4Xm3960pBVrHzbJbLRCSTL?=
 =?us-ascii?Q?39VGqYjnIj5I/li3ljm9pxOXtYswCJNLa37PA1ecSGC/JO/Dr3T5MQO/mF2G?=
 =?us-ascii?Q?MjHapbhATX4ks8ezZyBURmxlWohIcYYeSGjm5SZXy0e9mAfSZECzudzO4lMP?=
 =?us-ascii?Q?st+TqBmFRb0yZW1+9XFVx2oLuNdAn1WFii2LKc5xxife4eXJwE/RV5+5PspB?=
 =?us-ascii?Q?cFthq50BzfzTIfhR/itRxIaxa2iori9ufdNuMrkhjF2Frm2UXgra4uumCDzt?=
 =?us-ascii?Q?+L/LdalU9ZyZRM4hghLlvIv4KyllotqshghV4Y53g+NVdQLBqLEJ/kesYgzK?=
 =?us-ascii?Q?q4b4C20ZYaL6ySM0XsdmVGCpqD6/6g53h9xWrCFgKgag2BinoF0WwBx3l983?=
 =?us-ascii?Q?z/920TN7vbZnAvAcDwAFRTQIhRGkdM1RVGo4XbKsI4Zl8imX3N5BCrBy6HX3?=
 =?us-ascii?Q?uDqdivRZDTtZGZir2pr6WUSvF215hT8H8IN3l/B6F6ssMPDNfQP2JLl2kNAW?=
 =?us-ascii?Q?Hy0Ub05YuN1TzLlL/dD09z4sinEykjSp9Tgb2bgTfW1rjwUHpAdgtMoe9KKE?=
 =?us-ascii?Q?wdgMnYQ650FPXy0vAgbYgoin4WBuBQALqn2V0q3+oMh1p7TRQYw5aVxS/b1L?=
 =?us-ascii?Q?uKWLqG5HCaANDyqHDBtdE29Eq1EWP2INBRsTFWRgPbma8Kv1X8wBChPFOOHm?=
 =?us-ascii?Q?inr8dM3hhNZIm5ApeVSyg1aSxuUz87vzWlLZprUmD7waDEecTxwF84PScVyt?=
 =?us-ascii?Q?VtY6VRUGtI+OZiBu7ExipDcM1uBnp33GCg+A7q2ix3pTaOdSN9xyniu0G+Or?=
 =?us-ascii?Q?Tpa8vVWOQ9zKly3eOATOmRLhGfdR2vu/BbL6Bfv6m0uGfgJs0HwjsuvBOJJk?=
 =?us-ascii?Q?ks0wzmirXBGkHt3CijvVM4xllLVYH/lqbA/kU3jF8LXh54v86oC4eTHoYCtn?=
 =?us-ascii?Q?4FbvQoE0jgHURUTCk06/QV21HFhyEQYuvXizTk4iskuEjN2KcBAmw95jrZcA?=
 =?us-ascii?Q?2e2sXV4nXAP29xX8hnyfQBwkvjacPuAD8KXixenjQ0NnP1xSbUArOxw3o2fu?=
 =?us-ascii?Q?G0oi5kqKHw+ng7otZZDvxcIim8GlfMFwk/QZIIqk2HF1THHf/Ko51yXgIjn2?=
 =?us-ascii?Q?Wvv/gVKA+/u/3BE4L8Qd3MbuxTXZ+ECtMQKjukEk1diD2GX4pZNURtuujf8l?=
 =?us-ascii?Q?lFnzLpKRvLdrbBLuTefQtrD/x1iFcDCvYaVRGyAM4bMjU+JMRsqB7DcfnhdE?=
 =?us-ascii?Q?JUwOl/LQC696QW+sGw5BcO9/dC/hOYY0TyupwJIX9PgWHYQYeGlN+0ulmpOi?=
 =?us-ascii?Q?+/7EJO4Z2GqlH86UJj8LOleRKVvSNRTdjndL2oBtaJLChiX6IbLnzf74fgJ4?=
 =?us-ascii?Q?CAbKP37Swtik5w41vc9QDtVgnOs8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8mynDFlsy26ZkiG0EVoGFMqEm6e6CTvWrcaUEtnRlcfRb3QtH0DkMl19z1j6?=
 =?us-ascii?Q?0blFnvaEHxPqJT3iMiB4KF2V5Wp+HBCjM7gsXraFKQJr1WPef0W++EeDgR1/?=
 =?us-ascii?Q?PzmoEDiABGYQtPkA+cl8TOhnsroev9AqKF4rjmw6HzmHoC7IYHktveeHyd9v?=
 =?us-ascii?Q?WtnYws2s/5MBvStIpjL4N+TqC8bDlnwgHrMCxW7b42g+12ubSQMdt9KMIy5Z?=
 =?us-ascii?Q?qUB+oKI3VnGykdArg5fgFqFacfwTu8bErAMckCE9PRVQML6qsQaq4267tFzk?=
 =?us-ascii?Q?GoQV8K3jt9nVDN0Glf3GrPSF1oayLT8QeeS1zi0f1otRdEasbpwL7RQnLLia?=
 =?us-ascii?Q?PyNZETrjMIoflSiIjuhX+UwQ9ms7sARYrZ2Z16An0b3QFy82YimueJyOIaIs?=
 =?us-ascii?Q?ibxESMCnbuOYRv5tfx+HxT0M1KEVQfCvgo7bhbbNrqFQK68WObkia/w+V5Hb?=
 =?us-ascii?Q?sZfX985mbIorsDhmt/+KpYSVzLEQglPffbQsljaAONDK2QY6WReZDLUqEEGf?=
 =?us-ascii?Q?/Bf9oDNYjeXsQufgc0pkrdjC7iPmP2K6SHlu3eG7PLaLZ8Orre+atV8hIYmu?=
 =?us-ascii?Q?Bq7w1LuaV6NvmPwDPbsnT/UbY4o/4z5NLJ3jVTqecgey6MOz/PaSqyp00Ri8?=
 =?us-ascii?Q?xYxQFZD4iXT4sAjlD4QtZyLNuvj0fWRHr2fyS4ZD7JzV74ARu8vG3ebeBR5R?=
 =?us-ascii?Q?MkFJnqjmM+fRlyDoedAuDGvEyaGag7K77aSAEUap12wUza8bEmTtyHNVc1T5?=
 =?us-ascii?Q?gweb7HWWqhqzBLU97yBFHQkxdS/hakCejgDCxaV1RzNH84mjtG2yFBIUgh7v?=
 =?us-ascii?Q?cxzjXD3hVrcMpz5lfrEMMJbRsCmgPe7sl1pedvZx7Lh235lYtWbaZhWtqfb4?=
 =?us-ascii?Q?Rcq0+rwM2ioX/B6Wad2s6yj2QMUKyaw5ugAPTAb+dphWGVLB+7MJdzk0Dz2s?=
 =?us-ascii?Q?ghzMAHj7OoD3kIlfIoXM6o5Qy0hwZCaYNjPnvOjeaoI5tocZ7UpfCNPhO65q?=
 =?us-ascii?Q?BtZGVMjQErA/2THi5T3LlC92WBYwupm74fTX6C+yfSMGnMXsOnqLlufprf6G?=
 =?us-ascii?Q?SyvlcAas1wBsDkucyvol+YqUfzb/OfzHd9VHk95Yl+vC6h5iGbjmD1Cp4Pki?=
 =?us-ascii?Q?zoLwX7UEHLZDDntkd5isNvN2c6rEQL6tXyt6CBedKshP+cUrDWjAPtzAvNWl?=
 =?us-ascii?Q?w9Zf7DmMepHtgVxNQLXQO33wzA5aKktndZSiIY5Wm8c2FH5oXzGIQHqCvP/x?=
 =?us-ascii?Q?4RliNP9A6P/jms4VaX99fja7HtI8xjReiZW76EfYdLvey/BuhLUl13lSNtXM?=
 =?us-ascii?Q?G7Fwj1nQiDY0LcTnhIGRVqonTLx01th71Z2GrBsDReYOTyFjqjzLZ/bbNfzA?=
 =?us-ascii?Q?0w/QP8Nde5fZ5qccjHcGmepmqZ0qRVvUrwos6fp4T/nVM1ZARxdlz5QmkKB2?=
 =?us-ascii?Q?4GE8AL0PmttbJWwz4ft8ENoDCdOkw/6dl8xOsSWau9tLH6baNYqdEFhndInz?=
 =?us-ascii?Q?roSyxsvJ41+7L7QNbSq61SoQXJ4f5oT0/GOVJV4yXrQ1/KuJV7xyv8cY4Y+u?=
 =?us-ascii?Q?hfef6D4k4BKNoklw9p3lRBG43Et0zURjKIn2d6b10d9KfuQ/Uor+rsIcQu5v?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9ao+MAgXMiHKqPp3BOO/QAxgUoPAmEX8v8/r94X601bLGAWftmCIBiEt3iWq63Ta3AwbhEzoImY9M8wU9ImM2pi3NVHnpjcKAs2bgE+OWjdeCKjJa2l9ASpXsfi4VwTQj/m4TB0CUh2fmNYiREanN2YGb6j4mIEdXGM1Nx6McE8m0wtv88ZvkK3RP3V4RgN5bbBOlxI79k2fGWOGQQNEL13oqo/KxHTvyVGzyPWEc7nFabCN8kGADeTMHl/2OLYr7DwHc0hPfZHNpLSAaDQN2SXVUlyMtt4+V44BkL3xBIg6iabBMtPASVxqn3iYVRHymh6WQ0nz/od/LsD2wiT6XrxiFKoWWmiHuXdguYKkxm+AHskelyGhxzkw33ETMeobnUkztOUsXxGeFYZ02tjpy78nYqveRhJx2zCJSvd60HnlPL4+LP1K/C2XiuKHQV+AU8CRaIO7SfvY8x//7La6E4Ddz9sQ1TMY4UcFlMPBW1C73oqaQkcAIdf4MR1RUGDxu0w7QGafcrbV8Z7y8buW6kIV1luvCg3qgUb8HO91X2Mw9Pc+n5DEY5KKh2F5yjK1p9Mu2pCeCVrlyxiR8dKftxiXTCNTpes1LDKIypou9KQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 680ba6c4-e4cc-4986-6932-08dd54820db1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 03:19:31.0792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1aEDI7wH88H0qDw1iolxhcVK44OGcsbJtTx1wISzkAqCGzPrG+VqQQJVkq18F2GJ/6iUxwem/usovB8PY/G1jIIGuI94deyzYNOvMVKnrd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4866
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_01,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502240022
X-Proofpoint-GUID: bRtPXHWDBn4x0LNctDjzzw0zID0KD8BN
X-Proofpoint-ORIG-GUID: bRtPXHWDBn4x0LNctDjzzw0zID0KD8BN


Kai,

> Currently, the scsi_debug driver can create tape devices and the st
> driver attaches to those. Nothing much can be done with the tape
> devices because scsi_debug does not have support for the tape-specific
> commands and features. These patches add some more tape support to the
> scsi_debug driver. The end result is simulated drives with a tape
> having one or two partitions (one partition is created initially).

Applied to 6.15/scsi-staging, thanks!

Unless I'm missing something, you'll need to update the report supported
operation codes bitmasks for the commands that are defined in both SBC
and SSC (READ(6), WRITE(6), ...).

-- 
Martin K. Petersen	Oracle Linux Engineering
