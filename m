Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC6A7E111;
	Tue, 10 Dec 2024 02:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798815; cv=fail; b=d8MNDzXDwVlowBhG6rirRlf2RW5hdMDvcAa7/xEdxFb24+mdA1NlUrcKm+zCgksvztDRhyL2stB8lqB2nfvIsGRenx1E8lSgqj+L6qEUsp1m4AF6N2YJRtVDU4zMch7sd/PmBdDVdexjx8w6Rh4ZLEsDUodVoVpRJrj5KHAKUqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798815; c=relaxed/simple;
	bh=84NoeCFVUxJ1b5oScwXaJ5b+2XKpSBSvFfPwuJ3Fnms=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fjVbFptkbQyi+nhOKgePR/D3weF9C0L2Mbr7K88z+AWOYw/T6Zz/yvSMVdinF0Ku6kqgb6ZJkMx1PTY0c2kk/kwNA0ro2GZNi627zLRHxsaLfGEUseiElRJGXpOVzvZZVsvq1y3/VxsXH0JsKs2e9Uj0AEYfEHSZyZSVRzn00js=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JCpFoN/Y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EslrFnUd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JCpFoN/Y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EslrFnUd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1BtjY028548;
	Tue, 10 Dec 2024 02:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=fL4e/lYkfbG+WK1bt1
	AHr3gdSKJ6zYzV/4ksCN7OdG4=; b=JCpFoN/YMlO/rL3x2qXhUWocAfKMQnnkMZ
	gbR3e2HndbOQO/iut0gJjLbqRp3w5Xbw/+buSee9v+a7FGPhuJHDjCpGbIAdiMdA
	UN/X+z2JoH2hOj4KJvmop4nSky8OrpN9t2W7OIQ8bJ5Du1lshSx15a2KxCz+/yTJ
	dCgyx6XT9plWd1j9axQuq91UF5eVx/yj6c8RhKFj68FH3frE9rJyJpR14WH8TlSP
	Dlu8qliFPYzL0IDaDKBWd14ULVvbGdhgRDGr6rhaCe8fu3mjylkkfCitZQLqH+e7
	qh1iIurdgrNyPH7gOAmkX34H38jZexhkeda5Z1z42Bcr3MeSqkZA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43ccy04t42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:46:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1EuHC036391;
	Tue, 10 Dec 2024 02:46:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cct83h55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:46:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ehQ+QGodhf6pE1zV6deyRd4akOxqCzAdU0QVCW2yvHm7/74HYE4tpqd06OtkAwpTVjMZRP3tS52CGzqm3gBA+/r/W5Yma/3a1WgkzoiyTtCVnTrthtj+iEGKtTnZ5HDLkVCMRGmFjMdqFGR2DyM2miojt+yoVS5N79Kuk+bJkQp6St5i4xf0uet0OywpAp+fQYz+EuLGHzqoKgCLRBORhAWfinFisvnIMFJRe2ewQnIq9PasXDw1XVW4Vs+1vFF+SxlxSY3I03z+eytJJ7hQ4IRySSd1YX5R/54G+1u3QHFhYKT4OvTGJYElURxG5bTL0+wJ7az4gi3huIKOI/gbXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fL4e/lYkfbG+WK1bt1AHr3gdSKJ6zYzV/4ksCN7OdG4=;
 b=XxeruirgdaFgsaaBlgPwmB21vZVQ3WsMt6tFHVFmfZBVLCydvg1fM4kDOpKgBvMFeXLExfK2Ov4XUPg75M7VQhT09Oms8SXDrmX4/UAgmPBU9TJK/Qxt+VhpTdi08EVHtsl4V+lSCxgxlHwmW5rK8L6RaSeu07SUpAmRCq4stVrgfiTxS/XMc/dGWzYH9Ab7oJxw7Xdhl/AC/ZfSlx5GyekWR9oXDyDosVpEDQ6hzFi/QYoqKozzgnSUJVO/I+ZaaKkQJAR6BTDAtq7iCCVnhkWepYsyBlSbSE+lIzO8077XMqC1+LyV3xn3zjQ/7/wSNInx4IBrRXQ2RMMR2VntAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fL4e/lYkfbG+WK1bt1AHr3gdSKJ6zYzV/4ksCN7OdG4=;
 b=EslrFnUdREs9mJbyKfCNrFKgfwHb9IuQW7DQg/xBIeUEJgw7/wLNza5paPnt5K9nxB38tfqY0L5qEh6PDK4xnKGK5OqE1fxyv2naIw2xBK5obEvIJlE9iI3QaBomzPJbRFqwqStEX8nSMYoM2IMrgTy3Tm6KXG6w+a4itgTRuyI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 02:46:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 02:46:36 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: ufs: core: Do not hold any lock in
 ufshcd_hba_stop
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241128072542.219170-1-avri.altman@wdc.com> (Avri Altman's
	message of "Thu, 28 Nov 2024 09:25:42 +0200")
Organization: Oracle Corporation
Message-ID: <yq1seqwjlvs.fsf@ca-mkp.ca.oracle.com>
References: <20241128072542.219170-1-avri.altman@wdc.com>
Date: Mon, 09 Dec 2024 21:46:33 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0241.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: 147648d2-3fec-427b-96c7-08dd18c4dd57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P7etz94pa/PiGzEjCtyNroPCAd7UQ/yzIHeSEg6lL/VXDYdwtfrlse3GXjcj?=
 =?us-ascii?Q?YmVBdEc2k5+6OUV3ExQbVj1WdsjZgP3wYklz7DlQczTkj10NEewxt9CuP2DP?=
 =?us-ascii?Q?lwjk0pGPyQsvnFXpjntMI/ntSfrIENi3CQt8t4oUZ2zpDwHIa07YzgmYoBQB?=
 =?us-ascii?Q?7X4lrZqjQh9p9ioHyiFUvpjk+LZe76KFFZXz6B2zpzH4YrC3HCzuEO0O9/sJ?=
 =?us-ascii?Q?SAt8cgMvds/9FBUx4uSITn8pwvtoYf66Slpaa2IJRhtYxASR31jEwM5rRKWd?=
 =?us-ascii?Q?n/EE7Lcxs8sW7i7Kt3VmMWQKS8y9o5E7o4OPY6J4joQcZk89hUsNCRBZuHB+?=
 =?us-ascii?Q?uMdQkrqU5kpCNffPcgKel08jfCTuAs37NowCUW8J/cJRd2kZe3WWnTdZ9LJu?=
 =?us-ascii?Q?Ffk/bT3KnAwOo2eql0RMSOVrZCpA70da3mjQCvpYFRKV0Ms2RVsht9FT+pdJ?=
 =?us-ascii?Q?AQHP3Pfggdz1rzg1oCqwmA+bYFCYw3BdQEZKuAEnq2Dfvf3wu2FkxZqlpwyj?=
 =?us-ascii?Q?htpzV8+Iqe3ly1HlQ3rqA/LdR/5PcH9u1uP3vTx7tF8oN82xWPNdFgPAkbBJ?=
 =?us-ascii?Q?OvIeTRfh0reFE2680IOr9JZvYBzITSSWQ+AFAgcFgjdcxoKvpw+PhHAMKfMY?=
 =?us-ascii?Q?h9/DfIZ97cKhGPhyi5Ms3EjH7NL2WE46CY90Ar2YWI1El1gZ69bWIpZCPNdM?=
 =?us-ascii?Q?rX69ZEwt46dHx6sCTHqyFTgPaBSURUHDhS59b0X+HcmvLG6/ADuKJlR6wPgU?=
 =?us-ascii?Q?wWtaT/QADnvx3lFbT8+SQPnnLGR8iQBOlp3wBq1IiUVVHO9UgYWOgFLq5L+S?=
 =?us-ascii?Q?85r3Hm3dfoU8Hzh/UOKYYIyK2WbupgBn3kbNFPtsVX2x3oLc5eWEk3eVuTRZ?=
 =?us-ascii?Q?0h/8pCFIglSb1sIaj8kx9iE4duDTXwmJvmh49w1vUQItz/4pz1pafb+nPtAo?=
 =?us-ascii?Q?CnKyzKGsk7GaeoZzsaA4ckHor3MBhOFmDq6WiDVhYTlCTtgfi1TKHAfm33b0?=
 =?us-ascii?Q?njTPGn1Qy/owNpsvM+FhL3jJ/66PR/XDqp/E/7FiSvH0ACUPYr9Lz4TviQnU?=
 =?us-ascii?Q?6eRJKIrrA7O/vn8nNKNbeqeOMUBCHDn8nDwUwmTsd4QFgFgXg0QozixwowkX?=
 =?us-ascii?Q?CvCDkPUNLkSkMknp1MffFGVCzzVO6pk5dUsGR3MrNPJyJXrPbeybNTAR3/pK?=
 =?us-ascii?Q?uvOPz11h9SCkW/sBJcBL+5cta+76z1jQc/40oUVA/LPtlU/2vx8hcC0Kzv6N?=
 =?us-ascii?Q?rp4sZxA5aBPu646N0CHZBWA2+p5v0chZyZmD6LiLsjfvhSq2j7uIIc6JsHFr?=
 =?us-ascii?Q?tOXjTiRSY2LT+HuDNOEQ1YDDjUPh5lPSCA9vAaoAzsFo5A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?etxbtZ2PIh6iyMzWsSr61GaPbgSN0pgbNkQSWfy8Zw6w0suMh566mDlOABE6?=
 =?us-ascii?Q?ip3TSg1rUswyA1VSfNWRFvcNOyjOpG7FEA4PPnrsEnABB/ZgME6qRcWTHey5?=
 =?us-ascii?Q?pppItO79i4B3R3dmSELaeO9AXm+RXrkDYEzbM58cc/PR5EbSU1I1UsLh0JYh?=
 =?us-ascii?Q?FDjINGzviAWn2UBBr64VBEj6vVw+c1tdiGptJMzjaG4l9neDYXeWLsD9K4cq?=
 =?us-ascii?Q?6OCj2HclMeKGmIGIGSdOKZoXBWSATIjSFsyToGK4Yg9l2YoBQXzEkfgR2Sa0?=
 =?us-ascii?Q?GhRv0f1cSfsZHmXsuu/BY/U2QqCbr/ZNyrOSyeM2svPAkM2MBRB/DvKoN6Pd?=
 =?us-ascii?Q?OLlWsXqRrmoFxiVezf8f/yTxA6XdCkLUCPTVQJQR3VZiPqCeYalkKWzdFu3K?=
 =?us-ascii?Q?8WiksN1AnaWXOiSZvo938OCeZBZeluEFvk6+rXcC518g58BimOCLr/KBkUPT?=
 =?us-ascii?Q?DJW6m3YoywaETXCCEFgU7+4JAlbvEwUN0V8ldN4F4zk3KebJvwFJpoKvaAZH?=
 =?us-ascii?Q?1K8L+q+haO7Zcb7qc7fJyWOgeIUkYjh3J78DXPEM6EPWw7+NfWrMEv9i8OXy?=
 =?us-ascii?Q?EHikd8LUCZPw7UxG9fdui/8EWJKCsRq+Nkx6AfwWcpn2g0TLQb54Zd7RjU1n?=
 =?us-ascii?Q?6yeohLwo/VFx7P5wH+sROBGgB9JOuP5KYUg7yRWvCHZQmPWOdtlSjugl64YQ?=
 =?us-ascii?Q?wEd9U6MDjynAcmLtC+Df/vgz0xbGqEYK0Z5jQjGiuJ0wiF3j/DFgVldEz71n?=
 =?us-ascii?Q?hhkorNnB4NBA3nt6M5UhGCCUAxm20ZgTNTdkLFrZkDc6I0VtQWCh06t1fxjF?=
 =?us-ascii?Q?bsqotOIHK4NIAVSi1fcUJbwtsmk4q9W3A9HXU7Mn/UIm57E1U/gTsiyrr98d?=
 =?us-ascii?Q?3TbgIwxkpDzO2l0GFY5eUuvZKRr2BhNQ056HuqzILbjivptrvTGjPUHO8x0B?=
 =?us-ascii?Q?iyASxud+uaMbm5ZQSDc8nIArsWN8hJYH5DC7W8abLJkrQMKjhrYBdcjjX8nf?=
 =?us-ascii?Q?YPhuUnqIjGI7Cg58cCwHKintGnLw196YdbMKAT67vA9MKYXwvCpqhXpCpY+x?=
 =?us-ascii?Q?tm74P2FP9kuvKg0nJZJzdPJlrNK61rAQlP/WTQyUDM1lhUz3ClPA7tYYipb2?=
 =?us-ascii?Q?9X+zJbS4DsgCDGZ3nJxoPMZCt617v54wCIJF2mImSp4+sUHETRFyk2rO01+D?=
 =?us-ascii?Q?OOqK8O8uA2JMKUO8FMtMe4sX76UqMVEEoamFrLMIbG9yjBlNn+xFkI9n4ypi?=
 =?us-ascii?Q?eCpWOYBXUOVfVJT/25vRJy41MPDN29jVnNcRvBqN/HpcJAH6A5p6AyjFHG5H?=
 =?us-ascii?Q?1sVy9lrrMgQRkFN8QRn8cQ0tpnTsj2FQX0pSv1tINLKjpmpQftMNe2aTwhCg?=
 =?us-ascii?Q?T7wKUyDmE0eRxKcqFrM06aSNEfBE9l/6l8K3YpoidkvmHyCnd6ACXrXdBMu5?=
 =?us-ascii?Q?6CrMlA6zY+CmsouRBCCLVFADExAtQa1knrUfC9WhSUJk8e5KXeAZyysNAGPf?=
 =?us-ascii?Q?9bBt+OJRbyUHnrar6wBv6pTbsJ3Ry3ZFLW+vqA9IIrsDbMHlIJNwJTammHLD?=
 =?us-ascii?Q?vboishpYIanxSRGtk6yJoPJgK4kN9TU6onSffiplT3MoM5UzV1YD7Rnjedus?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rp5r+6mx9sPlqoaFJPY2WYSbfrvQeT4+0fcX74hXntAMev+wx/YX1optJaHCrlFK9sNw76Gy7eUDXWtCDs/8Nm2vbXDm4Mt8zJGi1burRMoOJyHz+tNG4/cZ5dxn6Lz49eNdKkenJtsLKWq5wuokQ/abdow7/KOMtkrHyH30Euk01lT68EJUzdMGKqhT7ZScK2A4witHIcvP0dc3oZyxCLivW6O9KTfD62bciWsfexN7FpnvyRoWoGqXA/dR+vgvUbpAJ7nZfE1/n3OtIZPwYJcVWuD+OBo0x9j/3oeqe8NZ78HmkMjNvkEuuE7ZyMUJLGeim9BiRngLKUZFEhPqYr5FOAzCk38GtPVA3hPkRt52gg3n0rX+WJHmvUzJ+JeFLMY/C6uhxWppaZcRF6QFckdWeL28nvMCEq5E9J99I9GZ+ucfNuQiUMtnke+bAqtkYqrw03oo8vn97AqQX/RZ3YW4yPw18z1jUHF4gDcaDljM58/kqx6kGE/ZIvjvKMgoLvI9rMUXWrMufAIID3aAmc4ZnRS74U72MJQK1F5XQBuephKpLU7Fl0x2NEijj7BauQahv4HwtS0eu8fHDblvByVGv9PDFaPOfKB2afQaTOE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147648d2-3fec-427b-96c7-08dd18c4dd57
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 02:46:36.3603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVYTMZCsK3CXqt1VRXQra9aO+aREQ0cH3dRrY2oNX0QFTS3UDrZC4/xOcVyL6GiVlIcpCBs/QFLYc40TuBad7efnOLhjDBLCOkrBkfj6Ux8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=795 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412100018
X-Proofpoint-GUID: CIoSxqMAGuqEH2Vxzhomg-JVt4xS1BHV
X-Proofpoint-ORIG-GUID: CIoSxqMAGuqEH2Vxzhomg-JVt4xS1BHV


Avri,

> This change is motivated by Bart's suggestion in [1], which enables to
> further reduce the scsi host lock usage in the ufs driver. The reason
> why it make sense, because although the legacy interrupt is disabled
> by some but not all ufshcd_hba_stop() callers, it is safe to nest
> disable_irq() calls as it checks the irq depth.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
