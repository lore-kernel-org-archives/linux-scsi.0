Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21321204696
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 03:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739416965; cv=fail; b=h0/6Kb7FAop0ru16P4M8HPunSSL7eTyrVo2wt/34u2q8Dw/K4sZ3UFhHU+l3GMmmEW5Vbbn4F9g/aAZIyefgUZsxV7b4tso5Q2XkXl+gHkFoBSAisDSXxxWKS5TyD2dqBkVAjq7PI/54Bz4YhzQSkhnflAVoFRAu0Au1kbeesnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739416965; c=relaxed/simple;
	bh=A+vYCmJsjsUQxekAp0LeWLyGxTYY/waHl1AKd4MxD00=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=q7w1V0mNirwavXlCK1GiNp+ZEIWxpzhRLXC016dNyLFeofMZqPULmuqPRv8HAxYCL/+kb4P5TlRX8awA901LijOQ06EaajCUKDAHlYj9wS0zq55EHAtjLpYJArknajJQWn/kN58Yg9zDHjr3NTwNrE/uQwIySOL9iAl7pzAO5B4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PoXmP8XI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hf+ZViGA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PoXmP8XI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hf+ZViGA"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1pc5H012371;
	Thu, 13 Feb 2025 03:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=hkKSvg30GiYulnlYti
	nUHKAy9lbdQX9rmIL3JjsaPGA=; b=PoXmP8XIppjSvO/+G9hBGC2p9IW3hmASfN
	1NDYgHnLT2Awf4sTjHaaSIVcnez9ZtHpLR57ZRteNjnmWFGO78ncyC57SFa1u2OV
	KhAd312QjwCmO8SANqoHNf6BLiiRcdvEs3IvWaMhX1h42a4ql4MBJkmdBP6iUjiS
	f7a/vUOYreWtOE2zqbvFir4Iz/bw7dsQt7/7Znn2YCfUjpxmtRnbh25xh3CME5mV
	Q/vJM86C6Vu0Gxz1tYXr39i89k80IkpXzVfqL2kozJDnN7gd4ZTwDK6EMT+G5tkl
	uS1XpmNnR0VVnFXLf4w4EuThE17NVNi0tC4YmpIIC0W3t48Dl99g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qagqem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:22:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D11KiS002289;
	Thu, 13 Feb 2025 03:22:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqhpcuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:22:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2mrnMDlNPJ5+FlK+SAKoGBoQG/NhLOF4got+mg/d3YNCN2UTi6MxM5xWCbxCCKT6bGwsfSSdlLXA07DD68FN9Z83WyQTRFWbtjPavfCJ/1JoeFcn1KiNenPEREAQmr11IZU/q6UUQPgiJuvQdc+n0q8byZ+z/QeVehL8uFyXHpslAAAKDpywcEj4khQtlZIzBay6GA0AwzdDZOj4lzgt/SwjqQezDDUYBMDnpM/XzWdvzD47sRlnacYKBUSLeonZgZH2/36oRCIC2Bo1pvIGS+D0EYQ16LNX52+WDN9AspYSsBzLZk6lfwnG1HFzInaHUQThT0lXydAZOS96UxvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkKSvg30GiYulnlYtinUHKAy9lbdQX9rmIL3JjsaPGA=;
 b=yUvV590L8UqIyx7LA3to7bp3NGjjVjiECZB+TGmtV0TVAjcWFQkeSBLVa2M6caO05bwr/tgxRlz0qUTYTwgDWigueDD6jm8fOExBycAbkdbpTx1xUPtkVl/tHLgyxfiaghXtBS9qFNbGqD0Vjr81tMS1YM0+C6OCBpxnzYXFfa6eZYr8OHeLG1aknT3qqH+ELtI3tKM++CBr+N7WncGYB8Fzg3DXeKnKFmrk5smTwhpYTl9NoNJEqOSgXwQ68MfggGkCJnQU8pLHEDlaSYnp2JdO/Lz8S74w01+q20zyXcF9MRjSJ2s2Cz55jmppDwigK1gu7LrApswnRZKS5NK4ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkKSvg30GiYulnlYtinUHKAy9lbdQX9rmIL3JjsaPGA=;
 b=hf+ZViGA1qKbDn7NchQFpEgt8CfUysu+iempyUyOHRqsuoIOrS3loVupNhaVWpaswbYtVY1QMs7pL0sEIiSwn+09o08eAFfHznymrzP0617r1paZsSntZMEVKDi/GLqM6eLPtAC9SNW72+xnuAYZE0yrT/exbnm8+s4/zsBUyeA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6366.namprd10.prod.outlook.com (2603:10b6:806:256::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Thu, 13 Feb
 2025 03:22:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:22:01 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sathya Prakash
 <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        Adaptec OEM Raid Solutions
 <aacraid@microsemi.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Russell King
 <linux@armlinux.org.uk>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        Alan Stern
 <stern@rowland.harvard.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sabyrzhan Tasbolatov
 <snovitoll@gmail.com>,
        Hongbo Li <lihongbo22@huawei.com>,
        Jeff Johnson
 <quic_jjohnson@quicinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Darrick
 J. Wong" <djwong@kernel.org>,
        John Garry <john.g.garry@oracle.com>, Jens
 Axboe <axboe@kernel.dk>,
        Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>,
        Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Jani Nikula
 <jani.nikula@intel.com>, Takashi Iwai <tiwai@suse.de>,
        "Rafael J.
 Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] scsi, usb: Rename the RESERVE and RELEASE constants
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250210205031.2970833-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 10 Feb 2025 12:50:09 -0800")
Organization: Oracle Corporation
Message-ID: <yq18qqav8aa.fsf@ca-mkp.ca.oracle.com>
References: <20250210205031.2970833-1-bvanassche@acm.org>
Date: Wed, 12 Feb 2025 22:21:59 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: c6b9ae6f-03d6-4897-edc4-08dd4bdd94fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0YuJVuA4+G8YR8FrPvhEPsP3iEFYmgTahpcEI5zuLvNaHPdUzuNTg6UcTdlW?=
 =?us-ascii?Q?dbjbNo5/eyg7MmKsxN+H0blyEIz7vi9TzLwvxfPGV2cTSJu9vd2nSa/EtZYl?=
 =?us-ascii?Q?ikiveaif6XpTmuH5vuw7LwIKOtAeSy0QZrUwEwR9khRWsRWfyiMlXfZbr7UP?=
 =?us-ascii?Q?dWA4ghEJnIp3FD/uGQaYi9nAzI4G55Qz1pzuhb9/hkmgy74fF/9kVmFRnoMv?=
 =?us-ascii?Q?xHm4/4sZoJZz3Rcd9zxKYycTAMKoqUGApozMU50vG4j68kA57jgCtjECYvh2?=
 =?us-ascii?Q?d3dPp95P9cwLhOxzOENc2gdh84A/fX3SAznEioWrUKCzAMfglRqMmMV6q/l0?=
 =?us-ascii?Q?xW1DShM03BRFf04upRuPq7KNYzhQP3INps5j1V38UbfxsklGhQYmgRbFofEu?=
 =?us-ascii?Q?SLostG/237t3T1tSQYZLR3ivO99zliXXh2qhjldeKmrZT4A9bUygL5xLCm3f?=
 =?us-ascii?Q?Rmo3E/0Wl6AfrXM/BN1oPFyLvJE6appIT0sFdWV8YETZxbnTm0mS5WxKoutk?=
 =?us-ascii?Q?d8nDcqFiV+uK2+D4RWWXrtBTgx6A4WqDvSAgXAZAFMTlkj9C5wITc4m+Ofec?=
 =?us-ascii?Q?sb8Z1aR2SoKse8z4C4EPSaH4dt1UxBgVymqs98gcbaAVJ+NlpzCKITE5V+t1?=
 =?us-ascii?Q?Glte027Z27gfMAfOaprRCuOAbCvlq0kkf8WDxcDcov7wlJK9y/ECcpyfEtM0?=
 =?us-ascii?Q?Z8KvV+bskUX9RRCMcD7sf56kp1AMqsdF/bVxKew+4bF7mYhgC2q5IlHdMBOm?=
 =?us-ascii?Q?kMoSARbdet6zFjcUXxQRsatJ0gldgzoOfa9AAl7POouaG+YwU5iDcke6p96z?=
 =?us-ascii?Q?rPeO9dXp9bBMvkzpcGqc7muVG57Eo0lREw8G8xiZEd2PUIK+zZI/iqdIf2QS?=
 =?us-ascii?Q?MGIvZFJwf6IFUUQeQBPOZ/bmzmNacT12HzDnlxasieHxfV/UuazutnrxE6af?=
 =?us-ascii?Q?TaAWgAwkwc9IOza7sspOsqWpKezznZAPBCsAoox54HD9EaNYG2DulCfZ1QEl?=
 =?us-ascii?Q?T8rzBmkj5DqsGQ3+TxPumkhLybhCKtv6/u5ImtuFoWyPW/EIM5gGCxFrvypu?=
 =?us-ascii?Q?YF8tCfdx70Hu5p/58Xw+c0RhtQCzWY/LfI114rS/a6cPF8SiGhS41BoESC2z?=
 =?us-ascii?Q?Dzsrg8NncYQn4GgcIt368DrpgtkdeUJp+dPsEEI7ESNRHGxCdGxoD9Vy9cyi?=
 =?us-ascii?Q?2l9F4ZJy4gOFP+EztpMNI19akL6LkiiPv5WZBFK8ASkK/JeOc0p2TLtW20tL?=
 =?us-ascii?Q?Vq1qkKl8m1QF1CuBwguu3MwjjxSnFTze8xdrcMs8oiFjkuSQB8jA0+sdMrzE?=
 =?us-ascii?Q?Pvg2HQVV4mn4/PL1U4F5ocoa+h4Z76Jx+i00byElyjxzQTIuvmblfqyYz/7Q?=
 =?us-ascii?Q?J13YLJWv2lI48tNzqcaPOn6uH80q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fZJhQhklSKBFHvJyVmPh+AjHI2lPS9dX07Nu9tWU7LNkpJqCyJbLqsCvh25y?=
 =?us-ascii?Q?hP4mW1C/oMkOBieXmLQeoMZkGJmWNp6ISGoirWwbzv/vgvwfHWoVdzoNX95O?=
 =?us-ascii?Q?Kt2Dqbfl7UdtCklWs9MTiGYofOKx1f3qJVtu7z7vSr3406nh4yZQEpXxy9q8?=
 =?us-ascii?Q?C3AZp8Qr/U/Eit7eBInyjSfGKzroZj3uQctEQcXoxj1dBRSk1j5Z+GIwIVXW?=
 =?us-ascii?Q?rYTTaSLYNNnH617An48gav6y+ezYePnKqSSGAu8Gj3x7EQXXu9ncQ2nhKRQR?=
 =?us-ascii?Q?i9ZxsI/lVmk82BlSzKCo/FBU4ZYu7OVDux4ZuzQv4DsKalEyAtD4C5teNzYF?=
 =?us-ascii?Q?4E/TxlDTvgumAf/7KF/MRhPw5gxZqmGEWR5Oy/D2hmv37XIhhUD5EpTnjY9i?=
 =?us-ascii?Q?MJ95Xpf8hwBuxC4mYNdGQ++N0sBsXAatFg0dqJ3IMPqgal/0u/9JHOQSsdf6?=
 =?us-ascii?Q?rlfckiReO8Gwl8zYMomiwQGFc5ijdRgDVVLsn/2XVqEZYctuRC2tF/jn2yA4?=
 =?us-ascii?Q?hz0reUv45Bs2ITAN4MwtM7+mjDu2QXUj1l89kGJW7EKvUgHweBWTmtDpuW4R?=
 =?us-ascii?Q?Tf3I8oWs+7GwDW/YdMtVzig2L908tD3XDFE0VNZ8vs0KpEyLHkEb6oD6kn90?=
 =?us-ascii?Q?LeTBGjaXOe+RUEiGlA10PbPkdENvZw7LXJQ4v+HGj1sH1d7iCx2qNx94nzZi?=
 =?us-ascii?Q?HlABsl+puk4R9MxKoIQ2gpE/oeXFVl5Wjp6osVqH3ZcWSqvMLNuhFEsdV1tp?=
 =?us-ascii?Q?fjiooUJlY1CHqOW2J1XMsqiBPVUhGo0wHfxWeV0eDjs8HLzse+6QsMwOVMi6?=
 =?us-ascii?Q?Nad6vuTMBBY1ajmElESyHWuxbqF4zVKLe9HwSE5pOpf+N7GQ7mKljb4ci2Dq?=
 =?us-ascii?Q?XpGJl0XCaCuwGlK423dsfHDiMKysAu1aOYlZx1Iew8NQR2i7ZVHNmaFg/EZX?=
 =?us-ascii?Q?uWA50dZSDqD9JrSoBktUrKWLHySD++q5PT1oU2Jg2NjqzJVpnHoKQ6y5hd1M?=
 =?us-ascii?Q?TlrQptAqPoSiJsBT4BfM/MJ8LC1MFZpiWXF8CEycULOzyzOYOweMgu/33xzf?=
 =?us-ascii?Q?dnBVZsfHHK5+PHF+/IfWs8M3dq954Vx9ACOoesPByG2T3QG+rbz57+V5Zuwu?=
 =?us-ascii?Q?L9crhXfhy9s9rT50Lwu3mL5WxUqJEuoxScPbP1bCPNSO9YorIX5J4Qoel5OX?=
 =?us-ascii?Q?uF00IBqbVQJRlhbu6vEcOYLGEqfj8Y1Rb4E9B12Mpr/umZ0H1w+G+c6DVqLy?=
 =?us-ascii?Q?I5d95tTYZRW6G4EUjrfZg5Q97DF+rVTJAfsiOQALW+Dgr2qw6ExF8u/nXadI?=
 =?us-ascii?Q?owY24jli/WaHeA6n9/SgAQaFa0gT0+yZr3wMCNm5+u6QLFUc87BNiuM8FvW6?=
 =?us-ascii?Q?VnKVYSHgng0+Ipgc9eY/9cwLPkOmffP4ByDtTWnc3jKwQW7Mnfp2cmPfhuDr?=
 =?us-ascii?Q?Rzi/eAtmzkaGQudfs9EBzoA18Jri2MFuQguwwaqteSIyrlpci/SglAytOW2A?=
 =?us-ascii?Q?aqt6ryz63VWSy3kA61ioWGpf1d8LtgHGLZPdNyjJvZL4UaGwKXW4XC29/kPM?=
 =?us-ascii?Q?gpncNMpqyC4Mb+zIMl9BxN+g0nWAFS+llRm9EFZljftW/mHgrcZ4X/xdZQCW?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gE1phqGOu61Q3VOzhOm+RTRPU0LlRZKdx3AkWyK5kLLxeMox6NIc+4RkfITjR6lriWLKnFqiUACGVOe/6LjPaG0a9tF7tPom5FgaUNNoRhQx1u8h5kTkEfryDlokSvxGDdl0eWuNSaKi5sFeuAWogNmnpO6vu04XBtI6t90JNbi4IOTT5EPTwkJQ4ISO/wgoZocyG+htPPZpVMZ6zcvfTXySV5kbA/s/AjBjLfNtM4bQcs87EQvrhkGVWUtXQGfGRL5agEXmMtYZinMgPKB5YXq02Wcg34qhnuamUA3cSfVIFD9KlnhYOrzGok3MIa62cQ1RkSI0SmrAaPcS0ijEhGe2c1Xnt75gDw4oSL74VuQ6IjJyQIERYlpcWcxjwLnf6n1e0uwYRSX5nA7iVveLh6r20x4WQxkHqoK7E3+BzqXSXnEp3UTgJLva1OCx8utU4540G/Db7VUdSYOin631oXFkZqnRIjv6tUvQ8TA/XtVqgPNjfbdkO9GViYT6uj03P/GeAMpVOtlsneYX4ezbYS3rkN68/Y/YuMrm+1hWdkK5m1v4xhvwVHdPFESRbtDas/wpYoj0OesujaU5tdGJNLSyA0Muf7jX1x4t+ndOQxk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b9ae6f-03d6-4897-edc4-08dd4bdd94fc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:22:01.7190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VgDGPVOlYTcrsgT1n8I2ghIhOO1aVIAfdVbrWAPA7vWnpzPYl3khsD8cJlwubY2s/iDthm8KH/0iK4/DtTvG1JvFUoItxTwxhHP95nSUZLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_01,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=738
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130025
X-Proofpoint-GUID: HrF54VQJFs1mbfIOoRfhpoQm6yBIReuu
X-Proofpoint-ORIG-GUID: HrF54VQJFs1mbfIOoRfhpoQm6yBIReuu


Bart,

> The names RESERVE and RELEASE are not only used in <scsi/scsi_proto.h>
> but also elsewhere in the kernel:

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
