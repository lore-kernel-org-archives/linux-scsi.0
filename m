Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BCB372AA0
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 04:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763611469; cv=fail; b=unJPgqjEmJsXEr2AYGPZQvcjkzlZEr9/imHeicT5Kt/W+Dj/hr83QYTGAkecZDfW3qN/CPmMTtPveA2FrweFPXTE4rUe/B2ZJnrHPmSldqiu+Qf3PGaZzDVgfo0wgKiao96obtiPzdbTbb09FxZn4Z9gFSYmBUCEXiEhBX8+HnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763611469; c=relaxed/simple;
	bh=U0FtOywkpsxMbHHcUh6aR/D80OmQWaQJ6fM8AWQ4lM0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FRGYICjteTL1voCTVsisrJJBLbsmtrikDKayqVc402xK4NZG1agZAZceFCU1RMJuo+y5bbgOk5YPWgUoHf7Qc/Bh+Ze+JTVzR7WzecshS/Mg1dvC6AdHb9gGCf7qwQdq3yl+4PtGg501r21WuP/VB/wcl/ux5VeZKOrjWyHsG48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VfxRpCjx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vbR2wCNv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VfxRpCjx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vbR2wCNv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NXDg017018;
	Thu, 20 Nov 2025 04:04:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mDjqnjbv46lMelFsyR
	Qh7rorVDla0w9LHwuPzOnmfNo=; b=VfxRpCjx4pWXWRXiiwjwz5dkjPszYQsBR5
	pbB8KmJfSQ9iA890COKFMN01+3drqh3W+cKWaauHeAFn7jvuGz8s4nNbvfalA5i3
	KZlhoJdURPPCqjaNv6PJsW2363JX58BlAD+K1/zgpr8rFcaJDyrBSno+vUJjC//r
	c+cj4DMLgk2nApGNi6ZUPkDY7iYuFT+/eHIdCMLNl1LnuGGy2WCd4CaR2jYyfUpa
	bYhDEH9ZWSE/4wYR04RX3uwY85p97fYNQ8unGxq+AUgiWv3Q5vwwtcYjlBRp7+rU
	/rvDU7ts/slaCkKrBtT05Jo8nXdJ9BsE3SsGZbKZOPNHg3949lKQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbc0887-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:04:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2nxBp003879;
	Thu, 20 Nov 2025 04:04:21 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012063.outbound.protection.outlook.com [40.93.195.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybgm6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:04:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xaQSgV6pjEuLU8BPK8E7rA1uc5rRBgxHy5xTbltYBS6+sQ9q8uRnh50hzJZ8ZXOnWCdNpneT7Endg+oCbsHY/L8J0vd0zpl/pOr0GQk1VwHm+l+l7LM/ghXEXZEXUd5NC858vf241LL9OZcX9OkmxibgkhB2TPOjfYzuOh/tpqizF0DFEFlTd2J667pNZc951d1BWfjsI8qMCF3811wOpGOiEqb65ohTE6gjQIQ5hUwQu9wCiGRf7X70N241ro0B3CLbNe2/UGWPca32HKD7AJqQkKfygndAEywkHKQq1z0yc1mPAcIk29WpiY5zzwDaUpRag4GsDrWTrxZW1y6nvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mDjqnjbv46lMelFsyRQh7rorVDla0w9LHwuPzOnmfNo=;
 b=Hju8VGypi3txUWV0q9O26wLicaSbIX0FH5hf+4PFKIKDbksPJor5GcgY6TNUmD8KBS4H/DcAG/U3QC2/K2IO6dZuFW5hj4rdfHGbvhcD/Ag8p0el/ylPTivaPwWF+y8r+RKWCG83eKEb+pn9T/Yv6FfOPfa2IG8t/Yv5hX1XW34ava9tbV6ANmCUa0vb0oIAN1tOQkl3i0HncIxcIaeDRYJpin5szOv8e547fWj9S69LyF6XW5E6cxH2l3d2Obo9bcsyPoBCwAzW8Bke3AtJaQ8NPmi7SP6f1V6638x5KrSvMZ/q4qWaPMox5NGNOkWiI29FFdqX4CJ775sfLk94mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDjqnjbv46lMelFsyRQh7rorVDla0w9LHwuPzOnmfNo=;
 b=vbR2wCNvN4yRQHAvps63NDuyrfJPBP1m64ZYTrpAO1ZrDq6Sng9Vw7oH/ohbQUvK7ps1ZCwNWQ4W8FcgUp87kpXEJcfk+ho4+0feIX6rTF5/9ko22aEmuRtQ4lo8B1mZ4XLsJXqxcolPHf//+MOhzuH9bA1IGMa1d1ojyPfnxbk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB6430.namprd10.prod.outlook.com (2603:10b6:a03:486::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 04:04:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 04:04:17 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add the UFS include directory
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251119165742.536170-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 19 Nov 2025 08:57:32 -0800")
Organization: Oracle Corporation
Message-ID: <yq18qg18i4p.fsf@ca-mkp.ca.oracle.com>
References: <20251119165742.536170-1-bvanassche@acm.org>
Date: Wed, 19 Nov 2025 23:04:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0014.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::22)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: 33fdaf7c-cf69-4466-2471-08de27e9dfe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4SpcRNIA8mlZH1fqkq3IaZWXufH41uP1h78xIDGr7+nqiJeDGJ0gyxS0EDvZ?=
 =?us-ascii?Q?fsFGz+i1Y4k/cWkniEjG6xeQfz0Yhd8vGxvEf/SxJW1DGud34NdjVE3duZ84?=
 =?us-ascii?Q?TIZCJDBbPy2MOzjVEpWqRW/g4iD2BnpxOa86lDIjiVUGrtLtaLdp1aFBy4Pt?=
 =?us-ascii?Q?7liU00KttaHrTjaoUN+a5EgUnOTFlatYrOO0vsugQIKEJ8XKd9qaGTPVHdxs?=
 =?us-ascii?Q?pIgFCGmSWN5Xicj04XmBZTlC+jME0WN5gsKRWfXkwFj0hu7hYB58jRpI3QE1?=
 =?us-ascii?Q?548ypPPpX9TVGBYeRxkym0P/SbG32CmUeNWkDcwQyfqx6Nfhj/gO5sHpVkJ5?=
 =?us-ascii?Q?mK25X5Un49oNGrilK0IN3ggS0kK7dhkmv7vhBRz3P4T2vMh9gYhwn9/KVJWx?=
 =?us-ascii?Q?+LyVeJxwpge49gN85UA1M01ZpYwthKzAIydDxkrMW/a7fKNT7W+MoNoufYoi?=
 =?us-ascii?Q?1xd31VoN48Iv12AudzjYr1CPrevpP85ZmdaCI0cqb2kUQbk+3mQCO+/Avjch?=
 =?us-ascii?Q?AsNeEvbbnDxNsF2PdFEFuiXwOdEUQU7dV4ikFbnRZEBbPyZ2DHYi9igSlwGj?=
 =?us-ascii?Q?V3OI8qe/SWcofjYSRDE9nQxMv/XjCRCSupkDC9m4OEgQqNU6Fg1m3ukVxM8S?=
 =?us-ascii?Q?X9CWBctFQpfzL666DHe84DyEcO9y9d1YMhv2K75TTB77dsTW2TAN4jAYRdf3?=
 =?us-ascii?Q?KLysdboOZk95YzpycaFDQpMACTqAURLgI51C4Z3yv6sQvnfT0GHJ6x1v4UI2?=
 =?us-ascii?Q?DGzoR5AI7z1TRZixvtus8qjZ5qKdRbL6AJ9spvXd38Z9Pa52NXH3ozsXkP1x?=
 =?us-ascii?Q?WnKr84w/0avdNjjVHXgKdfAxwrHbVWogBsZkyxlUHrnnvY4dwoCk3tZBA4ml?=
 =?us-ascii?Q?Ds2cmHfOjqNEVbZp4YA1dtJeIS3qlOLEH/PbRUQ6KvlWnNYUKsFhCLgR49qO?=
 =?us-ascii?Q?1QZWjMLYK02TdrQwug1uIOWZWEsJA9NxwStsnNx88ZsjuRtm8xoYkdJSTHVs?=
 =?us-ascii?Q?Xa2APlWacXVOIMcPeDA5jlVuLpg9sIswz5JT01yn93nq3f9EKAxf1DIv3yQ1?=
 =?us-ascii?Q?VykK1Fwzwg1Asi2o1bzmYc3EpnCpD7p/I5WCX2MJ4yWhaxpZIOGZwb2UPoA0?=
 =?us-ascii?Q?hCf2E1XegWKthEUjXNoF2gIlCZp+mBiE0O4XOGYDqsSY4NZXZdShtw4oU9G0?=
 =?us-ascii?Q?8wdTfmtwjqASn1clBdFM1xwp/0CoFC87XaaxYRyTaAIkln7jemD+4908DF8M?=
 =?us-ascii?Q?BcK8JUFBpH+cHBpcd8O3TmMfyVbrxZcsqOXSvb8quMFWrYLbR3nhWRqgXdRz?=
 =?us-ascii?Q?KRKsQP0PW8vyTP9mfZU2a3/Vp72izSbAaesDTX5Mk8KkuRThzKyG+uJRHZyM?=
 =?us-ascii?Q?uiZ0yvOWe/Oi0Jzy6SFqi3kSO5/L6+Y7/RzhRV+XDSwqMizcbRC06FdZzh8Y?=
 =?us-ascii?Q?tsptux/LL8g9ovpMad3nejE097p493DW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9GSJdCzEnxh4BiLyiFVWXBwqJkDpIkBmwYwt4LT8tSl+5/9JuyL4dXuFrRtr?=
 =?us-ascii?Q?anwlcmXy9noJxmKjnY9ql4VStVHwYKPc8heqgs3Y65sKJl+jGZopc/H3xiKH?=
 =?us-ascii?Q?c0p+yWdIl78hkdOE3dl7KD6Ckl9cjPruvxMjY9YH8bLQwCE6xk7TChAbWpKv?=
 =?us-ascii?Q?vvUvyfCUtR8nIO/sFtMFX7fv6bji1o1zTVwOShvWIT6DBUK1zzDdvEBkYI6B?=
 =?us-ascii?Q?gzdjY6uUddUXIhleWue+CTNw2UoFPIo7E3kj/KJ6q/Fia7mLUr0Twpas1Q8h?=
 =?us-ascii?Q?WtSs8yCNz1RZb75H8ysK19oWz/FCRLFAKxpOyME7nR0lqBqZ9JwN+/1HysFY?=
 =?us-ascii?Q?RWBRPdCiWTfuNxobY/2bP8rKF5vlAncSsDEKh0cmGs3D6kOuDIQr5bXRcjF6?=
 =?us-ascii?Q?zDD/2moN/NmA9igFHHVU7U93U2fAvNfDoY7QQKiew7zzh+W7IyAOg/9GK+qQ?=
 =?us-ascii?Q?S14WlL8kvXYiuLiR1Hqtlnw9qOxm74prGH2MPuTWh46a6Hl6HNKefkxRAEc2?=
 =?us-ascii?Q?lkE6HNAbAqP8x2u1Aw7qHUIYMpc4O1ardNTiK9b5QFQ2/zAYhUZZT+xC2/qq?=
 =?us-ascii?Q?1Xgh5tpMatqo+E+bYhWN6dOK1KRzElP9oIHT12CzzYyl/Y8RZO2HF8rv347r?=
 =?us-ascii?Q?UxJ21o88vJbxbPRtjUFg4EsxMeuSlpIOAXOETZxAhx0YAJyjcxaR6L/xANC/?=
 =?us-ascii?Q?3TcMQtPkNVk3TYPi4pMwc+dCo4DW3n/IR9wtVy4ilW3XyGZ17Bb2IVDW7SnX?=
 =?us-ascii?Q?kHB4dNz+hg6bZpmtcN7l3YmMaqOQdf9DnL2oA9FRvqHn8ck8xSRj7ZeU0Sio?=
 =?us-ascii?Q?BA5mB/+DR+b6DZUaZ7WUVahsGwFvAkAEivRPKO41PsPaM5X7zSn8VId5Ygm2?=
 =?us-ascii?Q?qwrkTLEj8YCHASG0iJfm7yF4g9DZhgxDQ9wVUw/S7ttOOBTCzGnWNGFcYYwN?=
 =?us-ascii?Q?7m8tOL4nyXSFGZEL00EhgymQfAA2Wki2HZ3bvMX+makqaDGoBwx2xLs653EH?=
 =?us-ascii?Q?a5f+e+0A9hCr2rf/OeTZV3IJEEUVv/Tui+vZe4U6vb0vk+tZYKFX1mIzgzpg?=
 =?us-ascii?Q?4y/q2dKm5OoeAgrWhud+kWOfemODD4I4esiBL3vaktSSKX/NOMdW8VMPTebW?=
 =?us-ascii?Q?6xjBAinlvwvhA/GKmvEW+alLvLHOQmDZou4bG6JTDPIWYkYWizCo645e8tGq?=
 =?us-ascii?Q?bA5fGFKTdkrcbfIDFca6mQS3Yrjx5QduJ8lvV9kBzZEiEXYujjJybUDdDEv0?=
 =?us-ascii?Q?Dsx7Y0N46gmHe8yQaEXRolQFLQXPElmFiru4t06Gx1BcoC9LvJJL2S/62TgI?=
 =?us-ascii?Q?W5ZQOWIHcwSF0M3zdaz7xjPUpBdvjv6xPzYTfxDvEL16tLCPF2T7huoQjisg?=
 =?us-ascii?Q?ZPJXaxX6gOYG4xMTQ1DoAyXiIjACV33ikojHNqH9ydLFjvrYwU4Q1dUmUrMH?=
 =?us-ascii?Q?9A3mmwZb3lXmTKJrS8Xl2xq2PGl8WzeWdSkavSCiUmnw+o3x35K9It16OjeT?=
 =?us-ascii?Q?KSSIE98WkVQm9l32/0nRNbqVU5M/F0MTAly+F6mkoSMRxZZGgDyzjpSgrCd9?=
 =?us-ascii?Q?ILOp3TTduzheHpJN1MMqzXKO0YfB75XQ/eFdF5tMDohskqcow/sg0F6YJR1p?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T3OlRCO2Wuwdfk+1YvKsKIwU4RHkRSV/Fw324VnEXHBrbLPFgd3b+LSMcsY1VeJUAMTr6PvOZ1yjA/wJWFB+L6KqpI89RT+EJzhceCCWaslhv3XzBlMPbbL77JaTvmajm2WOqU3zksgAcoRBxHDZfYWc55m6eCVrxWoKLiubxmcOvq1dES+nbTsY0pEjXwyy7FC2aBN+j/+TJEfnqNbrjA5Z1E2DSTnOUJ7zh595QSWT/3Y4eznu0zZutJiK9xmCjrrbPZ/THh8JVDUEolHXxmORi81V8TLWJasPJp4MJ7uEFqmAB54x0vLg5qy+WEIbTX3Dl9dMbYUnnkgEHzCvul7nVcJWHGhLUq3UMlGJ9REltSMBR9yDy+14d4W1YUwOSpPvAsUDIziuMZIUqIvpGL7RnThnRaKFVUOsjTcjitHjU/8xfQPZV7YDsTFKkc0kZrDBh1OVm7+W8zYZXs+h5A96ehj1F3gvwpnZcqrXiAiY03BgZRCbAMEiADp2C+G/Bu6YeTkIYWll303PwQMK2/Pqr2p/jGQl5oRbjFZLyhneqZapFvKk0FoL4s8zwR63kG64j1QrO9IUoO0HfmM5fjxUY+DJ/Etc9mbQ+OHteCA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fdaf7c-cf69-4466-2471-08de27e9dfe9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 04:04:17.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDfSbWnnl11BfF7ZmKRtcNEKz69/twmMtz7CDZjcWmGARQuMPlx3Vpzx+HDuOXCAHdgASD8kEVYWP/6MqCDOhX9lrzW5vhIgdiaONTjvmPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6430
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=878
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511200019
X-Proofpoint-GUID: _VH6QxeKfsJkrOugrbWkmVu0acuXMbSL
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=691e9346 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
X-Proofpoint-ORIG-GUID: _VH6QxeKfsJkrOugrbWkmVu0acuXMbSL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX5NgWzSPQnwKJ
 1JL4FOm1T52uy7fbmYbjpd9tjtN98PXfEr62X3pFJQnb4+nlOyFHUTWdeyEPEDadVN6T12gs65H
 lRMKlqJccFQusX0DB+eReQ2VB5Pkpk22qrccA5yNUTA6BFSoqXX/pxR/Rtaccg21tdu+nQeu7Iz
 1jGyX5MtDGIw4RpUVEfjcnu7TEoMmXGNKQrSSGxTRB6IBxpPABSVF4zvfmu+Wn8eqauYtYML88c
 PR3NFE44v+O3dLAv0yvVOYyF6aiIhuml+POXZhtzbFkZP0Rc7cKwuEXi+a98akkUElEIQgYi3E5
 nPAcDzs4zsrk7vo7aWmunUmsVLSYQeo1ilEfaAyd+YU9MJ+luOJS1mdkzjiLSEo+lyO7Pt6Ykwm
 HBeNyqUEYVRTfeyGefksFDFT8Z9f/A==


Bart,

> Make sure that the linux-scsi mailing list is Cc-ed for changes to UFS
> include headers.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
