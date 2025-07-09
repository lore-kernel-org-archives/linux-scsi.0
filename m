Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F38182
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 02:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752026640; cv=fail; b=T9ChsKaCbo1temhlz7zoCsIz/7sX4Yq9qIPNBcuj0F1FNYZMyp0HhCdLfBNsTX5LNdRSTjoPpqJKQ09FEQgmoTo40HnKl9Z13ojB+rWAh5oNyUApO9wI7KVBPMl4lkP4+rw9DQA8SryLYMa0aCr+E8txAHAgohLqaxwV7JToHoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752026640; c=relaxed/simple;
	bh=Ls7oT5NHNHIwtVwDCC5AlLdzsNjhNWg/WxSqgRgi2V0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=psa2lkIR3ir5tRb4Tr6j+IBL2xVrA4Xgk/HgQb/QukggXgxk3PaahtqNUih63BmZw7zRECPENJcu34SepGPAEHJv539sawKx9J+Vb0lVclEW1ZPMeA+gs0D+kMEQrqXZ80d9MNv9Sb302gmGx8Ue672RPtHR6pG+eu6pPHTMOwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jJ+8x13K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o0eiwibP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJ+8x13K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o0eiwibP"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5691Z6Mo011252;
	Wed, 9 Jul 2025 02:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j5io5Spu6lL5gA7Wox
	9P5w69fjdBm1+8RLEJokfPs3c=; b=jJ+8x13Kue42Hqp5Bd9XfzTozruKSc0T2Y
	CM1/N78kq9mDzLxEoMvTkiLIwKY58iDrgxFU3OKT3Y2LPeagWb6YIcZU8/o4tkt5
	kYEy5E+H+c+cvffQjBdCOawN71mm08Fz2DZe0oAAVKFtOWcFpyGiOjGoTMiNqV3J
	lqGaexDb7munFPclJpMvUllikVNutASUfyyLy76/Aozt+RKE5yWogzkjK7xSLrqt
	dAZ1geHKl0kDzBV1Hre6z6u4Nlvw4fLB2wvxVLDybnsYAlsQIXYKj5k42f4e9KYd
	z7n0cknBUbzZPPZolpLBbisExM3sCoZh086pf4Udp5/9aP/6erRA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47scqp84w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 02:03:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 568MpXEf026703;
	Wed, 9 Jul 2025 02:03:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgabnmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 02:03:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IgaWvow3kthWu9YXfh18tvK1monv2wXyx8yAiqae5aLjpDHNbengqBAUVYOvTXtWlJUKiYTIovwiHJQ8jsUW1LsVCfFsjtO6179YbNooTMy5vVONpRjQXBi1dD4A3DE+X94QDHi7oQ3ShMKrhkTaOexc+eFEjfryJYulaE9/DdJDU/JbpihmGB5k7olQV0ciHUN9kkOWcYiJ1Uq3/p0gRpX6u+Z6O62Klo8hBV79s4nYDOxb8IniXxZ127edL3bY5q5+6z8C/ixFZgX3t+xKOaIfDT5UG6HCak0pN1DBpu4HtiFtBCFXw8bKj+KSrmXQrFHY25yO1Csz/YFKV0ctBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5io5Spu6lL5gA7Wox9P5w69fjdBm1+8RLEJokfPs3c=;
 b=nWbsrfkF8dm4MlBJ2feHgL+tkt80giccSoNVqcdeRfWrkYNYNJrhcc+ocXGDtdFDqgzyLkofTS926Jzk49BhB4LfNttCigr9jjjIVprgu73B4mJj+djhP+S3rl/OduyjNDie45tpzPuMJjCfORcxlWqaky3RmKr3UxRKLzBAmeZrMG9j8NueF41QvUIeZ0CvTpe+WgITgNq9+SBTtJpDxUtxA3HXgYr20zrhrtnl8+JaEzEWxRD7utAmhSUlpcvOo5Nwb2pxEv2yy0Hg0FleGXaJixZHeC6l6oyiAs5RDWgoo+/QKbCcHNqaHwmWQM8NCueFCCDe3uq69E9wzX4JqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5io5Spu6lL5gA7Wox9P5w69fjdBm1+8RLEJokfPs3c=;
 b=o0eiwibPVdh8kcG/ql+Z8LQEKlRW85vozQi9Fe/mV3BKf0RJ7koHJTedwgexgGpL5ZAvSTKgjS/1xUt3vPx1E06xpg0XOv3JV0qjGhdN9o7xi2gh5h6Fx6TQ+9wJlUGCj7DBlc04Y3FMkpkBY0oajwz10G/jO/o0sIY5jQxF+1w=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB7310.namprd10.prod.outlook.com (2603:10b6:208:3ff::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 02:03:47 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 02:03:47 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1] scsi: Fix sas_user_scan() to handle wildcard and
 multi-channel  scans
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250624061649.17990-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Tue, 24 Jun 2025 11:46:49 +0530")
Organization: Oracle Corporation
Message-ID: <yq1y0syceen.fsf@ca-mkp.ca.oracle.com>
References: <20250624061649.17990-1-ranjan.kumar@broadcom.com>
Date: Tue, 08 Jul 2025 22:03:44 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0210.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB7310:EE_
X-MS-Office365-Filtering-Correlation-Id: a895c480-3a79-46ad-1ed7-08ddbe8cd707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qy27OpgJPxdruTNLwhHb3Mhsmwa2+oMx81mBps74nQyNwNNdD73XkVJqfAqN?=
 =?us-ascii?Q?kFOADPA9/+/wa16B6uZgnAtZSF3JS2aoEqY+FcL57vMIFzsYDdAZ3ZCEiWRL?=
 =?us-ascii?Q?4UavuRkVyoNpCu5qO9zHeE+9H4sG2mR+L+f7XvmQXQoQMoahYgUI/FPTGHWF?=
 =?us-ascii?Q?KpwwpyibByl/nbg6oqr2kgOLhQ52KBIj6jzPL27R0rwBc+qnLpH+GtApszSj?=
 =?us-ascii?Q?gUGp8D50e4lE5wkzhfHNpYWUGpz2RS6c3ALtwuJJmb839zeNrzVbtEtWRVLO?=
 =?us-ascii?Q?L8JEqSuA7kqTZjnyP17mK/VEh1j4HO98npLNx4obCZnMoBw7fLN+uj15ekv1?=
 =?us-ascii?Q?mCqZGnZ3+nIJ/4oOAJJBkrhGVIDCbcS0A5BQk6MiWN+JmFP7Xc1x7HBRd4g+?=
 =?us-ascii?Q?jjwQbIKcyh/Z7ftgrJKBBoPljzpDlCyRG/ipCw5Hl3YdHYQQIeGEqke3OpDM?=
 =?us-ascii?Q?zR5J1yRmWdGah+LpoRsyGJHVqpTy17oG+FV9ElcSwBiXRJuNtfxzmBpYaspu?=
 =?us-ascii?Q?WmMl64z+BJcxyoLIlEmmeQqrXNkXQoNlSun9069IzvQw7ZDC9b8C4Qf+8Qhc?=
 =?us-ascii?Q?5w0IWYob8zbNqrEnBP1Te9g2k18HMUWbNZmTG9K6q036Nd+aRFmfQ/iPdlaq?=
 =?us-ascii?Q?i01N6wNxAuA/reDJeXBA9wQ2FqYroVoNMZbLFR3Zv4PDDav7M9lh0zgOr+j/?=
 =?us-ascii?Q?jYIWnewNcki8aJ2WrrfOlUfQX4vUtYBR4Jx0hkTm30I9uVyFlbUKWmzzu8E+?=
 =?us-ascii?Q?STN3s/kE5YTHn004gt45Mzec8YfzZtoKVSmmreuePFsGvmH9LqpA/XfFYrce?=
 =?us-ascii?Q?VQXw7V+3VptmOfjBQvGym7/H1UoX10vlffwBJ0DsAr4CyKbOyeGmFoQeeiz5?=
 =?us-ascii?Q?twzwylTXuppqKrIDPkRLSeBtQuXqrMuIicblai/heEcDzUF9AF09LJONjQRF?=
 =?us-ascii?Q?/brujrUS7+DjpvMqlm6RHDQQ3FCGym8TWKFYU0eF2CsW39adAChLy+CeSeW5?=
 =?us-ascii?Q?8egGpaP7wVPL0C+7MEMkTFTLqmQj/dPXMJRKnRwjT70PDuXHYcegV0rV1KL0?=
 =?us-ascii?Q?yKvjeIxRAahn8GEF2iF1q2vAr8n5vXDcekbWpq4SGIPFMsAWbZg6A1k+05A6?=
 =?us-ascii?Q?ABGMxAtGANtaas/NJ1ca+2u3ApQyZi6OXZUZ/gaa13GPBm0uWwEWKCTa0B9u?=
 =?us-ascii?Q?qtgNY5pneEw28Rv9kqDqw0fM+bylvTSVfXFa4LSaesBnk5wlOHsi+3tmUMOF?=
 =?us-ascii?Q?NSbPzuZeIw0m0LI2vtE59WzePj06DmwF6/yLSrY7Mu+oZ1RBdn+87F/2sIyv?=
 =?us-ascii?Q?y0YM+DbT96eQ2jO4XqeLFZxM2gJFzxoZY45EXtQstnk358gsdiHoPsAg4yKP?=
 =?us-ascii?Q?7sriV64oZzhgKL5zwjvw0umf+m8LI1+CYobQbNY/1S2r/tB+X7bayIfFZwTx?=
 =?us-ascii?Q?qkQapfk7hqw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LbkQxk9K3ScRoaic3MocBxLj2BLz+94bzaT6vOJJg9yxyU9YPgpRMUYzg7Zg?=
 =?us-ascii?Q?nnXf5WAC1yb73HYeUCzC8JDqY0lsukGKQSrfixnf+51hw003oMtKDpmjbqJ+?=
 =?us-ascii?Q?X0HViGUSrfGz7FdTYtIExSgQvRqsX7ZqASNb3iqhUW/K9WZGJ6aIFJPVMg4o?=
 =?us-ascii?Q?RQFg4jIWy//zlc4ntMHoX1U/U9lLQ0ovqCh9+1uNNb0kr4I1qvYCcurwsdsk?=
 =?us-ascii?Q?81MLVTMe3JT8Ar+YxSPq1rtJ4svSILH5vWTSDLN+/G0yCrrJGV4P91cDrUO0?=
 =?us-ascii?Q?V17/PITGog7dmUNDSadSn6MTWnQbwoxglsycqES3ZxysBlVW3YGPJNvimPJ1?=
 =?us-ascii?Q?AjV5831IjXnW1VfIYuz4tWYGwYhXYfBGY5dPuoKWaq4BcmUhObxcXAO6yT9t?=
 =?us-ascii?Q?+xsPxxDvbUGB/qzC5KKY454gDPUG5wLkyj2VBcPRMdqkQZ1QnW38b8WsMN80?=
 =?us-ascii?Q?0che0PsGnsxJvDBXJ9cuW5unGka6rwkhGRnNiCYyYWCNqCmmFsfBZCznVpBY?=
 =?us-ascii?Q?MIVRabNwfAjx8h1Vg+83Mj+hfpQACD9tWMRZhh7EaUEn6yCi/Gj6Zvs3YHNC?=
 =?us-ascii?Q?aG1wIfyS1VM56C3Vt1nLvpR1UgD1TsWKMGW59hKZgWB8f/jRH+BR/dHGa4yx?=
 =?us-ascii?Q?anioO71/ILuKNEAcrnkd1OAj07Upvw8Cu/nv7Ti+5nJQ63SxbJy0L/wsrDCR?=
 =?us-ascii?Q?AJPKgTKv39dgOWM0H4i/G+Su5U2NNSj+NOUd9ql+NdwxXjuCNFoR8xi+Y6CJ?=
 =?us-ascii?Q?0zYyuAU62KjTdssheh8E0xtyRDVrv29AllLhBkMeIve5GwErS9k+BVPeF0Eb?=
 =?us-ascii?Q?OkgkNSt6uQeMBxVKUjBu/CBeC3wWcCKEHIRqyHVRmzG7i12Dw6uN613fz4+5?=
 =?us-ascii?Q?em/b4vRpnbY5aY4Aezpwkr9PQpz/sAOEeSwxW8YBnsrj0MTEwAbz0KRfErtZ?=
 =?us-ascii?Q?Yn40O6PD9CnOq0Yi94Qn3J20mgUSHQTmtNwDoSpCidvyHM1H1XZO1/c/fdZK?=
 =?us-ascii?Q?tgojV4N46URboAC1/WbRl9FLa5wifi8aNZmwqyGu8ePYlLVV35qtqfeoJI+h?=
 =?us-ascii?Q?2WLyqlHFvCPDBoYS9h6H4Jkx9YGt5wGLIZRqmkU4e4sht5ujga/NLTuzEWa6?=
 =?us-ascii?Q?aqawXmXdh7FGMDHLdIHHGwOF4GqsnJ+JSOt4w7bnBEJhRtiBZzbvvxLoH4dE?=
 =?us-ascii?Q?JMROwYygYLx7RG/bGU6DAan2keoS7hxvsLJjxcC+WfuJ6KwdXgaygOlZLRkZ?=
 =?us-ascii?Q?WcQhNJ7mToJlUKCSrJfYkcGVe5lIzDkUXq6BLoYWXZ37NW63Ukvz5Vl3uSTO?=
 =?us-ascii?Q?3F9sVtfyas1jaXkdJM/szMt9pF2MEHgcypPF7FLXSHl7CnbT2dmO1s5osZag?=
 =?us-ascii?Q?9BZJmcGd24sMt8+k8PhfjkDRt3EhA9/+8uQ8GcMwfQVKuLYb844qrNWJBQrB?=
 =?us-ascii?Q?AIVBKeGgJa7G6wjNl1obNS0zE8HClej2XxRlg52bS4qCbny4afwq+yIrDpDd?=
 =?us-ascii?Q?gAqUa/0UdfDs3NSYjHeXHTOOkyFD7317NqONaik+WO7BAIkLbTDP70PY0TKo?=
 =?us-ascii?Q?aAsS8oqezcOFE7aFoCn0GvvAayy1L4vQN8pv8qspX6exXTkwRJas7NSGjB2Z?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xESwC1MB8MFXUbWRpnEo6GXIsLsqCLJvpaH+3YbMwO1Qk+S1OspQKZP1MaRJ+3KfLgY4RNq5rhwHUkNVYS/ILkptz1Lj9lEDPQqH56Pp9YyXNirgAYPLnMZVr54wqBoBFnshJ7QN8Zr37ggr1x8b9xb05jv6ypPKMWVsJtpTiHjA2Se4uu7oM4nQu383pMohH7btZ4J41t0/0BL5xZbWQ0l3CjURGhbWhR1PwOi54fiRi3qyYB4PP3cnd46xYVsENPdKzDcoK/7m6hM+EJbAVsMrawehnv9ixyUOix+951zz0U4GtbCg4wbTWI+0kqg3abhksYErkMMj46tf4Z90IDrrGEPmoV1sZdFDs/MXry0ZmuMwgRdM4F408vR1VrbR5XYJMze09wMut8QJ1bS4rWmyCsRaovhMpAg/pX+OX5TDzvViKItLObceXXiPWCDzwcE90nWOZNuHbI5l7+SQQZMV9fM0rTE1bjXwBlcaDype8dixV+KcDNrGMqFlh5A02YWEggiY8zP8jO4QQLlzxW1uNIugQkaoZrLhHshLNxzTVlhJAirciqom1iArLF7+05zKni3t1/K0c1t97y1oYBTRkrELAPFObpeVdCorD2A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a895c480-3a79-46ad-1ed7-08ddbe8cd707
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 02:03:47.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3oZCOKyyiP0P+qhjn6dUa8DXMT6oshtFMbBZFLwZi07C3ucDKYzqZAE6FUl8rtE6RP46vK7id6p9EzUcRLQG4VM+gV3DjXrHyTEeXWRKfJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7310
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_01,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090017
X-Authority-Analysis: v=2.4 cv=PJMP+eqC c=1 sm=1 tr=0 ts=686dce06 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=xJe5Pi2zxZvlx8RjNCAA:9 cc=ntf awl=host:12057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDAxNyBTYWx0ZWRfX7u97tHVZQ/PZ OUO1tF44Fd2Lk36itZroAFZvFZsJZ6Ynr/74Yjjs7JevFU1CN8c5Weq9U377VnfTVRC1F9DgB5Z Y/gpv/3vbHajBUSyD2rMFyyitf4CaxT5T0mI5aiLCzeitZA1BddjEMH+W5r7WYUH5ns9+rOqCQO
 RNCoDknqTom2cYRLqvBk98HuNBturqhFsSjUF6Qk0ryk8yuMsUlbRG4g2ckAabmd68GgaGL+6e4 A0aJ5IYjknRo83U4CZw3xueNY3BCkx/pKyHy1VCAfcV23sTGA1ZzrE97RdH2ViR+gA90FY58KHN uYEJgA5cY04D0NWTlFeVdDlJuljWyXvS5Dt4nyBI2OJQMnqDweQXceyWUp6udZUpPpB94ilm9nt
 N44HhWFfDjPXmLGTmaPZ3FeAMjM+1M3+K/kmKCpywchC6TGXgNEYNE9Ly+BNZbIJJ1ODc1Sm
X-Proofpoint-GUID: sAOWMgVQdLgehHZbmQIAfconC7tz_4zw
X-Proofpoint-ORIG-GUID: sAOWMgVQdLgehHZbmQIAfconC7tz_4zw


Hi Ranjan!

> user_scan() invoke updated sas_user_scan() for channel 0, and if
> successful,iteratively scan remaining channels (1 to
> shost->max_channel) via scsi_scan_host_selected().

Two questions:

1. Channels? In 2025?

2. Why special-case channel 0?

-- 
Martin K. Petersen
