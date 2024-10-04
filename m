Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE2433DF
	for <linux-scsi@vger.kernel.org>; Fri,  4 Oct 2024 01:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728006406; cv=fail; b=rySUAeILxpyipiyIwLYfgpIY7/GpZ+gkvKCM/G/FiJSioEF11NZB29ewC8ikdMEF1gbsRiSKuRRef4w4TFjo7KpRZQ6G98HUYSXcjM6qFw1WHNxrr39SrH0Lg9VRqdqTUe5V8U6qEQsJyk3POIOakfT6uIacbSvjHI+N2TZAKOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728006406; c=relaxed/simple;
	bh=XR1udykNWUzCpZG++pH4MFGTclEZ560o8H16eyWXqIU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NOaMWFrJBZ/aIC4qrwxLrRl6iNVP7209k6wUERt7V68SViJKY1d+4rLAjEoofqgn91G5mXDgDR+6b6DAYPun8QP0DbM/l+N5rIAOmmKzGV3GtSZK0GVVudUmBYzAJGzO+9ipjHrZJnu7M1gVQd3JHO0t3/KoLFDzj93X9iDhoEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eyWMTkE9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YSiAebln; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eyWMTkE9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YSiAebln"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940tv7q021986;
	Fri, 4 Oct 2024 01:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=b1VlZ9Ok1CJt3P
	W8jI0yKavmjLa53cCVbUXo7XjX0u0=; b=eyWMTkE9sh7AtZqcNToFXneoIfmFsf
	yAenDNV1ZMLGsB/+GN1XsAZDEZQNmuuprQvmKAkEdP7DHI4ud4MzJ4nMD2aF6J/h
	m7VeButX/+F0aKNpNY/mnylQ15UrzsdqHudhKdSnv5Mx//PVlp02uAqRgpwyKF5M
	loi7rukr0Vz190AJExJDOfmRMILNAvqYloAoTQoFHGbtKFiXAtxiUxfcwqMfqBS1
	Y7kf4/KJWcTp6/T6TCdCq/0FFulj/ovBPO/R2r5nOv+Z0cdim3q4L82Y0RNZAT/t
	qVO0/d8ZFaDXKN/4qGXd4U7vCJ+qot1AA/f1YmSJ5GXIuiyIXZhm/T2w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42204b0p2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:46:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49405vXd038441;
	Fri, 4 Oct 2024 01:46:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422054nwjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:46:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QGtimAPR/dkcMKpemvLIGuPsLqvz9jiuqxwSyws7vv3WmbIEbgJfj7ntskl3KaC8BRZ8ryZ2rFP422WqJH09dcxU+tyJ68Q/1U7FQBVYhX8t2k9/06UAPu47Hw4uBlwqjyzTKxsg2cYyHJ5aQFKzsch0/oUKk5OuxN6B01MvItd61QwRQg0pZuZPYPBbPsdWWL5QD9X/sSZENuQku5AF0Reg/4eGgK4QUD7K1v1srlf3RB23INdX5vcR3tt9T/SuUQhUOtCKWJMrP1BkVM7fbCGrmD2SlszGrA/XATtu94u1ZDjWbp0HnzfCf5BGjYe6uwuhZiGOBJkQIjC0zALgdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1VlZ9Ok1CJt3PW8jI0yKavmjLa53cCVbUXo7XjX0u0=;
 b=qVZTY6u/vtdExp3AWl/qQ21LvxwKUHCZ01uN3PnbOa2aXt+4r08SVhHAho3DhiPaM9Kf/IMpLxPMkyFlh+ERmMQ+lqzCxTwmoBqgQagYaMq/rbcFlw1vHl6ssgxCOVTACeEgq+nrHUCmihTWost7HgjZkC+WMTgNlOdh2M9ciRYiPTKMGDl9yw/pWuEfhKzmTfxxKsI7EdOcyO8WHi1rIXahEwNgzNqlhISWdtmjblaZ2IgmSp/J0n0P1EXGpG5UDkDKYZDXjbiI+ojD0bfFvkRqThihqiLgeS+6QUazhyMfq3TdZXL7I6cZ6zwxlmmXBoE2XJBYoJcp+DX7g1zHsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1VlZ9Ok1CJt3PW8jI0yKavmjLa53cCVbUXo7XjX0u0=;
 b=YSiAeblnyej6XNq+FLJc/J/Q7Wixd32e74C7tY9SIU+oE1KY61IrqDw6j+UK6auh5PaK1X4+yeCDrCRR0CtK9VyKIw0DQ3IgKPUC4ct9kGsdQ6RAvKQ/dFPO6Z9Lvn1qbu1W2hvIiE+HX5PU+2ouuP4GjntCL4HAsbsK8YmBCJY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4505.namprd10.prod.outlook.com (2603:10b6:806:112::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.18; Fri, 4 Oct
 2024 01:46:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.017; Fri, 4 Oct 2024
 01:46:34 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash
 <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: mptfusion: Remove #ifndef __GENKSYMS__ / #endif
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240930201347.1837690-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 30 Sep 2024 13:13:47 -0700")
Organization: Oracle Corporation
Message-ID: <yq1jzeo3aj4.fsf@ca-mkp.ca.oracle.com>
References: <20240930201347.1837690-1-bvanassche@acm.org>
Date: Thu, 03 Oct 2024 21:46:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4505:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f72b6c8-129a-42c0-9bec-08dce4166079
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z8VyMAwwQqGKdNfsWUAV5uQf+R0pJrk3980VAVrMGI5ybV2STvz9BbccaC1n?=
 =?us-ascii?Q?DotwExvESf3EsN7mGe8AJJM3xnNXDcA7MvdJMwL0qny0HycTNR2eAenD2gFN?=
 =?us-ascii?Q?3ysgYinAwCw+RuecwKNUZ6LlKm2sbvcVOsNDmXzJbKPqHYsjh3KT1P2+8zuA?=
 =?us-ascii?Q?f1fERRVDAFDjLwOPbCtakd+jhA6Z56SFCMiSYVDVtBONHnORG7YZ28EwKwhN?=
 =?us-ascii?Q?N2zZjeVOXSHVJ2Vb1DRxIUIk20xqy01YDAmBbIaIHBMRP6wKywMKKQHR6CNc?=
 =?us-ascii?Q?Xhx+d1hWqTw2FDkgZYISRYysS4ZliXJItXK6xOH3Vkt4/BJI9XZbPTNTUXIt?=
 =?us-ascii?Q?U/fLzVSCi4W7ICjn162TR6CckLKAkNl2PncCZx5bZCPT7zWcNYz9J4kiiXRG?=
 =?us-ascii?Q?GdhZkX/XhruEK8NigXjk4HdBr0rtZJfs6qlFk2KGW77wYP72rjz2lLW9JogH?=
 =?us-ascii?Q?2kz2V4Mzvh4Dz7r+8efXYXmUC/3xsfs2wS5oKKzVmVLpELWKD9HVHLbmCNLR?=
 =?us-ascii?Q?pgtdEKp2rv2mt8Sra6V4TShlNcnXI+Ye1YuxjNs2f9Ep7cViON7A+BRMeELP?=
 =?us-ascii?Q?vymchBzmrst8DLAONY5XHtq5SP7M20lAs24pE+xKWBu5IE40AikZM+yAw1iG?=
 =?us-ascii?Q?FNtD5VYsPkfMKLNsZESmpesSbcdWlKKBy/C89adZpOH3CtgXgRRFzQwt41Xv?=
 =?us-ascii?Q?H2Un2r5Z7gyeSFOFJjvo7BcdoppG8JwuhcJRsyFKU3Vy2hHbPeLrfwL0tsG1?=
 =?us-ascii?Q?LfoP/+jhX2K+gIKdFIaqC2EoHOSNZ4ysEAYWk+9/Opny8wHo4Z1rbBbrfsJj?=
 =?us-ascii?Q?IXknQzkhZ/QMfvzJMgVkcUCUSUo5cdSIjrwmArCYDUqcEtGQcuH3IzGNl/K+?=
 =?us-ascii?Q?ps6Oqqjj6WIB1sk/t9HGxRIA9UfJuQ9d7KdQkLr+92D5MTy/Fn2nuJQRyET6?=
 =?us-ascii?Q?uBZinoyNS+/6ywpOdYD0/inyeVNGE4t8Bo8EgKaCYm2X70LAKksjW0aaUs6G?=
 =?us-ascii?Q?Lr6jrZlzIHjvjGI8EwrMCkIOVQzmNT2vDFcx3OFdGH+LlSh454fJXQhPosCR?=
 =?us-ascii?Q?t4/UJSoYvGQxsd7SoTeHHjF4MBsY2Uo/PffBdYJ1ew+eFhZUPnqMdZJMX5dC?=
 =?us-ascii?Q?79Y4xJGZlyLU8SOLdblIKix5rEsCfujZ0n+HY9r+KyxTyw9Z0RaVs+0YF2CS?=
 =?us-ascii?Q?xAYFqn/YWsY8rlAi7pxowh+4a8FAJEvd2txjUV2lA4cRK2LpdUw+CQ7i/e9R?=
 =?us-ascii?Q?M5Faim8aMnulJykMU9GTKBpY0TxgzWVNQa45ECyYCg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ahutPC9crgQxs/nUp6dRuGymvhJcWrKb7rmbbJpDeiothulQQ9JdVYTn2PK+?=
 =?us-ascii?Q?3pIm5arKLlOOFIO6m885C4H3mYOkVzuads7ZO8okQYlD2cjltWBhGa3RQUoJ?=
 =?us-ascii?Q?iUkVzoFeU2P99FvuYWww2QKmL181RBWUC6WcjdHHCjPCQcXFWXiTX8LRNZRE?=
 =?us-ascii?Q?Wk2fCPj2JF4hg419tXehqnBEEW5PUKGwiZeNsshTZpK4jNa/MUBUwLwmenli?=
 =?us-ascii?Q?uNrRjNzZwQkFD1MvgUGMS+6XsuDYEP0Tc+rz3wLNQa+cGPeCPRQ/Xfh82wWk?=
 =?us-ascii?Q?ha98DZf4Ht8QD5c+ym1j0DzWiLiPwFviSYOTCyflJkCJfZ8rj5pbY+Exc1Xs?=
 =?us-ascii?Q?1qHrvxQAd7J2KJ1rDnBYzEn3JV0dDbCbK1m8NdX2kwMIZlCaDUuBkn2PNdGe?=
 =?us-ascii?Q?BKeUiZI45LTjHrDj6Sh5+OmHZdwquaoUwEs/JY7g7cfpbsjIL51IiVIq5SeS?=
 =?us-ascii?Q?n9p2+b+6FxqTTTuESuwLCtFgNVXw4CLyk+jaFfK5bV2/r1aUgcfaUUiKS0X2?=
 =?us-ascii?Q?7ddD1as5Ub95ak+VJ6pqywbffJ6vXYgwDaE9xUs40yN3qk76giATPSd1jMmO?=
 =?us-ascii?Q?P++qNKdTRvmGyn/kEA7zPHFaZk9TrnDfphq0W4QatL2u6k2jjNF09w99TpAh?=
 =?us-ascii?Q?XdHPhAmoeOX6/32vSW6A9QP3HQp3iVGE2a24M6DIuvKklndxCZ6v1ncW2CPr?=
 =?us-ascii?Q?s/AUrgs5XD5Xp7ZeW2wIXjaz9f5Ez6FuG+Yd6AuOzxbEefT0aOU1jNQF5tmE?=
 =?us-ascii?Q?skVfv+jJIT+KTIZJAzVXAtUfakZj2ZyvpNuAq2zwkrLw25PMzHvw9DAy+9Q+?=
 =?us-ascii?Q?g9F2l78kqb2oU/K2oBoTXg+79EjhL+xMb5IO4appMKp096uqI1CTIAj8f1ae?=
 =?us-ascii?Q?y0hMbY4bIFl9wPA0hiOzLlfsBlehdSi4SLuAHQhyHIwgWCz3JPuKqUQNXNo9?=
 =?us-ascii?Q?cwXhqfESqXVFRHzn6nxrzAz/WuBhoIuot667M+NGgvpLmP0M63qghyjAyr4y?=
 =?us-ascii?Q?hoJtZTlQH7nmg+f3hcrKbSqoovx3SJ2m4Xax7FYdru86ohIhINq1TE49r6Ab?=
 =?us-ascii?Q?OM64BWiwq7bH6UHSpAazrq7uvxLMcee/Ig9lX5e4yzJmmvNjRwEjW1ule6ZR?=
 =?us-ascii?Q?rnDVnankVoLxXzP9SF+DDtg495h243Z6tPV3lHcMVxkq61uLY3DNzujHY8FS?=
 =?us-ascii?Q?/dqoqeeHYntS3YeAdg+g/BIlKnIG2VR/KKMtKXuAZ7TKRhJf9n3SRXcLac17?=
 =?us-ascii?Q?JSL7+sRL117r93Z+qs6xsVmmDnS6GloplWTNS8T/jWcvgKk/26QH7plddEK1?=
 =?us-ascii?Q?rER58TwxEK4evMmAOmLu9EdDj6SUMTMoWEDdkBZO/hyGq1Pii/x/p0LJ97Go?=
 =?us-ascii?Q?94A2p2Sv2QE5oiD2cns2LrI40gNKAiZqCzYIhEBhN2+jzp69/D7eQJHXmsKZ?=
 =?us-ascii?Q?uAFoLKUHkRh0ltq067b13wK0u/3BJl3zkd8vsiISt5uMkRm8pB0iGg3wfPKF?=
 =?us-ascii?Q?wWnnFNVuGVo3xnu7iQDAICCN7GaSbt8wTq9xT5AGW53lHjQ1dDgn3W62IKaX?=
 =?us-ascii?Q?f9ITR8101gbGXWY75mi6o75ihjg/G5Z8aRtCQUbpjxO+VS/BZjCUr4JZz0ih?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cNl2fzFH68UbM/oLPSmg7l7L2dTgbc+/Fg8EosE3YYKLqgL/4jnJ5Yh7MZiZ0M+h8gNGqFsTlIiu6PdU5lcn7h1QRrN+HYNYT701ck8Dxc8h0HmSm2edm6piUhRf1n/lqGNKK0Ly2t/hQHKo4J6CyIyXC9Hvy6+DiOZlSY+4nC9ZCyEyaXGewban0lCzgL5QZdJlsMypus8+dzciTvHXHtcURBd5EBtOqkx5xyjyZUZql8Ajn+Wuv2oUXPt8zPMiHfQXOsIQUUOaUl07THPEotVI5wf5PFPc8lYrmvJ+CoA7WOK6Wi6Ub1CMNJGxMIudahUbeXUYBSK2oB1Ms/dU3aqhtgp3/XQFWEMeJNvVo8h/APAJYw5M++4VZAAx+a3eouE8n6Hpl8MqvA1QdlimC+BCqQvm8+y7re4zVAMy6LSV/uKrjdsyWCvJIkBnHS2819iLwnjnxmfPaeP+nbfsiWo0tppD8jj1KQ7QxTB8ShUKhHNCgLebG2nZT5eY+N2k11vgGxuUQLsplF0Mtnah3ofIKQQfCIpUGwVFexhVciUVpjMvLdCXWs8AXCGnUfMLWWG1ysT2exlCvqVtWdYLFuaLnu4wir9HiYw8CdjqREs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f72b6c8-129a-42c0-9bec-08dce4166079
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2024 01:46:33.9666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDtIQnJNxlT3bWwJuzOri8yB7PNTcrM7OLsyfYbv7wNlkFhN5fNfQf7HUd/DxnuwI4tBi5fQbJ4LJ6PoFQkFQPuuuISfSvaKD6Dk9jF3x8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4505
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=703 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040010
X-Proofpoint-ORIG-GUID: 0nKyDTUY2SYyBulGovJkWuZhnZvguP1x
X-Proofpoint-GUID: 0nKyDTUY2SYyBulGovJkWuZhnZvguP1x


Bart,

> Except for preventing build errors, there shouldn't be any conditionals in
> kernel drivers on __GENKSYMS__. Hence remove an #ifndef __GENKSYMS__ / #endif
> pair from the MPT Fusion driver.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
