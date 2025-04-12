Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1606C2367D9
	for <linux-scsi@vger.kernel.org>; Sat, 12 Apr 2025 01:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744421945; cv=fail; b=OQLONMC9IRvK30gj6j29xmET+z33+5emy1b7pvOu1iJxb4b2OAYn+1VDo+5GWGHlW9r8Dbv+YXA1p6jMBV8DK3ZeZYdcihbijiU9XMTeu0hEmUrVw1YKaB78Z2bsoQXg+kjU8Pn8fCfRO6X4UInHE1qvaSIWTBKZZc7J+xUP/Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744421945; c=relaxed/simple;
	bh=DKj44PeDWCXrmjnBSEtOldzsq48LK15zu88+QFZUz2c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=IKqrIKVXaKLYV2aOh8+6Kc6tOeOyLYleSYk3/rmSnBrNF4vH99JLcUypRk3G6oTSIF96yzfhbsjA03j9zPFerWOL8HiJvewdaPyrYnP73gIagEBswx6Y2bmRqWkG9VOy33PfOcOSbFit4H1crWXE5Md+OALVnKfbq3VzvsCJdPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FCpwDDjl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bOqrdI/j; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FCpwDDjl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bOqrdI/j"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53C16xTF026579;
	Sat, 12 Apr 2025 01:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=hjCIQWaq6K2+TxO9UO
	L3G+svRdGPWpDYURD0gV8kclU=; b=FCpwDDjl1HNFRgG0hBo/Wp8H6uyVBQBDJ0
	0HGaCtCk9z+wEEXMoT43cSLinghffyUFveu0I/9AdHiu3h5UFBFYLeovNwTgFeQ6
	it1Tpn66qcFEYYUdJvVXUidPWkVJmqSz74Yv0+8KkuM0T1uXh2WCZa9KYuVxO55D
	CWey0Ii+49OXCXjaoJVrfgdoxZm7N0PTqa04vwevvrgBeKAtNGmKuwElMxJcXbGU
	Xqu7isZCAHqkslhg0tdn/G12jkXfHW0ZKCRKx33aEKKCEnYGhO2CyyGw3H9k5rne
	XV63m49GQ97DXa4oNhK0NnK7r7MlaOhkReygmFjXIrfbK43YtVNA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45ye7p80c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:38:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53C1YHVx010675;
	Sat, 12 Apr 2025 01:38:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45yem5r24v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:38:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ev8xmYuq2kMaDehpqD8vcVYC4Xn52q2GEJK5FazsoX7FcZr67tsq78q9WjkkJ9csHAecGrLkDQsSjDuw7+OMfKfd9BrONQxIG3hZk3so8+zZ6YKvWYsh9ZpjFrAxb+RoobE1AsnxKrKx1TMLUWNU0yirfvNLif5tMUcGnHYcYwEp2HFL+QYQT8T9c7BzPsI0Xm5dg8+RIWSgbdlN9wRqKl5yuHPqM6KwQ996JLjILsVuQM6c9hjF5nbb+T23UDePGY3+L6p+rnPzjlDDX6Au6bhtPboxcLBHCr1evGGPTJoQRFbiGV6Gv2tRxuKhRo+vVguiTg1xvL8ADf8g0yjC1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjCIQWaq6K2+TxO9UOL3G+svRdGPWpDYURD0gV8kclU=;
 b=usB0cw6LumoELQNfICWTYRe7MFsmMnxS73T2JqkM+EryVi4bKCYQG/v3/ZjqzJ0JIpdPUT3d3WuDkpvLxLxo+LLpENyycXf6QVVczYLFELDW11h1aNnR5G8bLV2h8qsjGX66DP11zUETZ1oYUdOiU6NKljFXOmE3+6CH3Vckgn10g/gcDenemtrj5wZq5fadQmqsYgCjtkeiBruGVHgdRScunRVKUu7/MVTmv+YnocEMDv3C3Mz6qu8vpnH+WqVpQnd6iEE69Qtc+1XF0uABLwty3Yuv9nFVbUch8xGKRkcxjEHBDbyFixncKWrmwijbFE6Ol8vRLW/bk+sHc+Hsfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjCIQWaq6K2+TxO9UOL3G+svRdGPWpDYURD0gV8kclU=;
 b=bOqrdI/jG/9MzkHUWjUSamB/3+a0vYV9O+GTcnVsnytuduVmIGsg+KWRawj9FTh6rcSDGXcSbt8Xk7fee8hA/19AdNHxDhx5vqYeWhpqwxGQpsjLCgqsUPDvzKudgRejt8cY3UCvGbMwA7TecQRcOZimmi/ZKBmSCUPN63BtjxQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB4992.namprd10.prod.outlook.com (2603:10b6:5:3a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.31; Sat, 12 Apr
 2025 01:38:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8632.025; Sat, 12 Apr 2025
 01:38:44 +0000
To: Huan Tang <tanghuan@vivo.com>
Cc: bvanassche@acm.org, huobean@gmail.com, cang@qti.qualcomm.com,
        linux-scsi@vger.kernel.org, opensource.kernel@vivo.com,
        richardp@quicinc.com, luhongfei@vivo.com
Subject: Re: [PATCH v11] ufs: core: Add WB buffer resize support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250411092924.1116-1-tanghuan@vivo.com> (Huan Tang's message of
	"Fri, 11 Apr 2025 17:29:24 +0800")
Organization: Oracle Corporation
Message-ID: <yq1r01yi2g7.fsf@ca-mkp.ca.oracle.com>
References: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
	<20250411092924.1116-1-tanghuan@vivo.com>
Date: Fri, 11 Apr 2025 21:38:42 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0677.namprd03.prod.outlook.com
 (2603:10b6:408:10e::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB4992:EE_
X-MS-Office365-Filtering-Correlation-Id: 0629af12-dee2-4263-b9d1-08dd7962c2c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PYhOFfvyTuyI3yC0HpmjXjuqEvAdOMM+pOoTr86uL4kysjJ/AqYFmXQjMKhc?=
 =?us-ascii?Q?/Z3hSKVq5YHLpNS/mVghSLJwz+9TXeyQB1O0crQCtM/XE5YSmS92vTvpy0VA?=
 =?us-ascii?Q?qyjSCAly1zIWhOQ8Kd9QefsMT0Nv/YEXdDURuYFu5hX/vAdCPs0SAru1gXrl?=
 =?us-ascii?Q?HTae8q2PvSsdQzCXrKjHyfuhkoU1jIdbB+nMq5OjZAhS0WtN3oukqd+tRoah?=
 =?us-ascii?Q?xQNihbkMwCNaI/ti2hrU5fFi0hH27OqgzV60Slo6xZ0QeGX1d3N/0RbpxCCP?=
 =?us-ascii?Q?ZnxtqPCtgAvpjBTiWLyUpZIl9P6x4llImQ42BM3wrXQDkcgEfF7JsX7lgcj8?=
 =?us-ascii?Q?g5lrDWlvJYX84R4xNRUQH5up0YiIELus7xGJGyh+q4RS1/IObrSdswiLRDfy?=
 =?us-ascii?Q?qRk0bS1jr1tdO+fyZUHOLFMaOeg5azSMLvjp1iftoyRKp4zM89PNB1u9k7Qx?=
 =?us-ascii?Q?n457A3c8Q7fmLl48zK05y0bn24h2FoU3Zn/j2D6x+LU9AsXQiO/UVVE2dX1R?=
 =?us-ascii?Q?VaCj4d5zTWUeUIo7nzGt75H9MK25o4ceAyXrGqAKtlWWHQxcxjJv+Eou1AYi?=
 =?us-ascii?Q?ca544hqTxJtmAUgW8wIU0f4zlbbbakgza7B6ePRKeedvrAnDFxxkai9J79d5?=
 =?us-ascii?Q?zQy31KeYq7vZ069AJlJAXTekuiXq3fecvjZrBOsObjsnREyIo45iYm63c+l/?=
 =?us-ascii?Q?GcWSb/7NZYdp3EhptcwS3Col/acUVpkBbDAoZHMTxzB4SKtJOn968yVBgUUV?=
 =?us-ascii?Q?VMxDhiR9TY2wRTIevzALbZleNBnKvBbalXU0bayrlccHa4yU/qf+nspDPA6U?=
 =?us-ascii?Q?O5UOV0FBpxz78KmCfi9QEMP/I+dS1WTb/KlNxmEnR2P2qxDUY9BFl4kY/mFT?=
 =?us-ascii?Q?D8F1J2N000j2r/NtCCDPLTmmUmD9CNZuIAYowb+M9POeGsr4KaV6PfcAsiaI?=
 =?us-ascii?Q?xDgfPNO7hDNjwri560aj/CKQ7FTkfvDQBL1azqBf8+VXTILFkdsZOe22eFsw?=
 =?us-ascii?Q?Rtbz4SnM2/jRGYQDDS52NgVh8fINlLACaP4vhzqAjBlIlpxAxbEePk1FxUSo?=
 =?us-ascii?Q?QUmtf4rgkd33fS04E4pFAYNuUW1E37XFIIUFb2/Ff70jdGVYjmAXGDnxgHxJ?=
 =?us-ascii?Q?tL9OEmio/JY+3LSPPfuqwFBi5JtVVloCOUkoC8lC7mGx8PniO4m6BhQzP5ED?=
 =?us-ascii?Q?MDyS7rJ2dQeiDlGER8V15sBvKP1rLpJ+nepBloS8XKyzH6/qNDPVDEAzJOCo?=
 =?us-ascii?Q?jgwswidbc1l3uVZhZuBsxKvR0imYZei9H6Ojmi3gwqWX7hAx3GQQUZgVPrnZ?=
 =?us-ascii?Q?8NOd1Xqz8RrfFAEdE70UNogKP1yOSqnvLv9vqxXWp5KcYidcXNSs1HmVjGD7?=
 =?us-ascii?Q?JANdIwEsjEWYtzO9gNCdSN/qQrwF07dlxt520wnv3rPPzmnkgRvNea79L/88?=
 =?us-ascii?Q?q11aSBrA5S0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?slAXNWlL25Q1li8KknP/pgvuK27aKN8/ssM6MSGpKpjaBOttH4tS+czhiHg3?=
 =?us-ascii?Q?hk+no3uSnan8obNu7TtHzkx8g4FrPiOnIe77Ab1um/5dy7hY5O2dT2dYmcXH?=
 =?us-ascii?Q?ZR32x8PFo+R2sbYNDXvivTe6nGwesJDAe8poyBM6NAgGXltAX1k8fV4Z3eNv?=
 =?us-ascii?Q?P/2QBbY+9VVdkaoBz2Av3rjmjY3m38SOYRFnN63FKfiLGAz1QzX+Spl+Nf3o?=
 =?us-ascii?Q?zKgx3xQnjMOQKLnS0ilpSjIPuK87W7uq6+Jk8gLquWGc3Rh4d4Y8ww2x/M+h?=
 =?us-ascii?Q?vHZ2fW7sG9yb/8XmDHdVrM0A/saqg1RxqyWMftUlfxaWNEQI6YYvOb6PFy0e?=
 =?us-ascii?Q?IvgdP2uuOwgm1SHMh9nnVILkD++g+N/eM9wPsoLZRd3hPb0TIebPutVwHdXN?=
 =?us-ascii?Q?ceGdqsuj/BnRawBPe/FTMnHSEtD+OjCg4dxRXjnfY/plUgIfnmd5yETcq478?=
 =?us-ascii?Q?GZTc7g1UeEf10iAf+HcSWUH0LzhV/QD9pQYFcg0XpMam9zWQIAXvul5/LGj1?=
 =?us-ascii?Q?I4GuoY1ggKvuJNpGhU97/+hxgzIz+7Cde4JeWjmTe0wCBJDocQr6MpGlFQx9?=
 =?us-ascii?Q?UaGKY3eKMEpnjOgVzqqQnjmYcAZtJ6Dag8HyTO6JEZcXT94qL23RKeyZjFyR?=
 =?us-ascii?Q?Wur0ZA4MU+1LNu5/RjOUvjJOwdWL5jzxo51yFEsb4psxynXi1a0PkkW4M227?=
 =?us-ascii?Q?x5GbKi3sRdZZmsKUiFI15LlwEerGamueuw13qWkNUYIamfGsLIFT9bcrBDrU?=
 =?us-ascii?Q?VCAmDrQ2jtU0UAwoovdCe/1VMOvvl6qJfMKRloOPn4IiAcyZ3+VCBB4rQfKe?=
 =?us-ascii?Q?k4nPeWYKF6+eQiR1ehaHA9cPAfzGk3fPT85MY5T7wWH3i0LXGiqgsE26b4LQ?=
 =?us-ascii?Q?oUqgddKytTZpCGl6m3awQ5WWdCigmdQ5FZr9hSJeoete3Q2Zb2hnSv1uQHeJ?=
 =?us-ascii?Q?ui7p5Dm5xoDR5oFV9ohyLJlu9O5w8pIfCU2kgJBNU+3r8rNpXvCqs1AOFZGs?=
 =?us-ascii?Q?puWyOtMENJBLnYe0BQUUeoikFD4JTLrms1tI2AQdpOUeSrtvyevWKML2DHXe?=
 =?us-ascii?Q?CcZ/Tnq8sQK9O6II/UV4p82jKuIdCzWGnm1Vwo8qmIzh9bscNi0IW5Jsnp5w?=
 =?us-ascii?Q?MRhsDDU/tr/TmUUx0bF5W9XewhE/p+8a7qQEAAyTO4jKlbhZ0HUKWEAcMs6j?=
 =?us-ascii?Q?LVZaSsf5Pz6AnGy43iR5unm5Y4/cO+iGNrQ5KpLqvyR/kpu4sD0WIoG96XDN?=
 =?us-ascii?Q?BD10ut23Jt18JBZPI2uLZNi/F7OrXpGvOD/mOFJA+MdBwHbtqGdb8QAXxRzW?=
 =?us-ascii?Q?1y8TtZUGKCn9jP26gZ8lpGaaeuo5stqORfLKf5WkIY/x5qg2NETy0VE8EGRT?=
 =?us-ascii?Q?YhWOUo/M7nbalX3Rn6+eaJrTquJMv1mimq1PIaIOPFXCsZL+01B7J4gX0xvJ?=
 =?us-ascii?Q?vxdvwz6mNOhRu2dgQJwdXg9zbVqO43L2KdyYCUhhI5gPN2aVnFCf1sSLXmL6?=
 =?us-ascii?Q?trZu2qRLyu8rigAM7XHXNCHoAwDhmjywlzB8sLs32KGJ8Z7z7/o6ZDvb4ZCi?=
 =?us-ascii?Q?lkCo8NH/EdPBSkeoQSfdDSnzkTQpmLjekAuTck1K29wORmQuwH1MecQM+0NF?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UBSE26EH9QprgDgsl0S49UVbiGoNZOTuXxop/BHtBFXj5iqWBPhBbpOPAMx4hXnxkBCEnWD7Y80ru0Sh4tjfO/yFnmzrSzjVRPu0FIE0A2i8LyJ0cGhJ/jn/E9bGGCR2sGKSS6+jQz5B0DWBWa53iBSkxzs/YaT3YB3Ubt5Ux3l/17OoA9kdOKYChwcsqCZcZOWf7TlWXH/D7fEmXRIv6SXbLYWgFp6OrTzGEm9AFWdEtrihJ/+xO1r9P7om6bSkvXPtAjrhbLMXxUhroYh8cx3bmMpqKCmhyBreTeTt2+sH+fk+7r5jTEYtJsGRLn+ThFgvEkE8BvpKcn1OUGMwu9Y5ah/HXWbJT0a9oPbyIvmOd5SKtIqjLt7DroP0CEjSF89myRGw33ZOzJ6/DgXZF17/HXCkhDQDlbFf3UyMXcYgxGLVlbTQ3jTiwZzhiO5lkcGPhK43WCgO5TfAmt14U+7xJAoo1yywUiBWNVJiJ0BBiPPHeTfQCKef5h8Y8Bdo34lBOrWAgYNuykn1jOzFnOxvjoP99rGif0m1Fj37Gfb6RSWYxXWzAMCsQUFusNBqONHAkYpw3VP/qTKrkRsAuZou8miaS/jtHv/jIe2fuyM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0629af12-dee2-4263-b9d1-08dd7962c2c5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2025 01:38:43.9869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0IZ01i6MuHldmAFIOCsVQuQPxco197kSxmPZCWRXhic6N06u4RrqMl2XdPP2eP4n08Q4phYK6ld2d8RC71DwrHXJD8ROZr3eSLSUkOu6Pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-12_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=798 phishscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504120010
X-Proofpoint-GUID: bIpwMmhOGPzu9Z69xl3MVj701LBvQeLd
X-Proofpoint-ORIG-GUID: bIpwMmhOGPzu9Z69xl3MVj701LBvQeLd


Huan,

> Follow JESD220G, Support WB buffer resize function through sysfs, the
> host can obtain resize hint and resize status, and enable the resize
> operation. To achieve this goals, three sysfs nodes have been added:

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
