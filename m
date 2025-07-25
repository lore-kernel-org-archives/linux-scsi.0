Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8864243ABC
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 01:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753405679; cv=fail; b=DIEssOJPqAtsOoTFdDQlA5srFeDiGKmfl/PnI569H8mmaBhIJH/LQOVrQq72UsjI38Vtxzg+qxz3RKzGNfwFuYa6Y+5cHVTyXK+pmnCdhdZ7qLDgbFz7WaoM+dN0g2e5l5f4GFsxVdAebakOEo+mvqkn6I7vdLkf67Jp3ljv8Lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753405679; c=relaxed/simple;
	bh=K0Rz+NUp7w12a8upgmGlVuD7mzOX/RFOUGwNV8nmd4w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QjpdPUFOq1muE44me6QWSJC4CdK6v7IfekOreZ04xKx/nECTJixvhUaOfcDfqXAiUjxnM2PxNrHLBMWgQmI0Lw5yOXBmRkOnLp54rP/K5tk1E+jAqAjqdEPdqZSnW/Mmq2agkzigCVKEAJ8bfLNNaAFkKJigc+rQBdH+g7jOhVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pR0tjZ4X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0LZ/CK2E; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pR0tjZ4X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0LZ/CK2E"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLk3QZ011892;
	Fri, 25 Jul 2025 01:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eoED7T5v0F8PoJAWNQ
	krLQLKIRMczTVrHW/EI8kE3gg=; b=pR0tjZ4X8JTwpne5stsYCs0GzV884zJIAD
	TnUnPZtfY1FOTzD/CRX85oduNKespqD20BILd+ZoDyO6X4GdDp86D0nNFwiAPeGq
	diUh4qOfGdnhXIRJG+8lQdWDvWSjU02ePlq5CDqwVrh0E8F82cmIocrZ9wFsWdeR
	fMswKFuQy/wouS76L9RwJMLbQdCY/ENPkOaNxSlXPJT0gpI09vqWy5gjNj137NSy
	cdK0FUW/0KbYD5mCPEEjftvJvX+6JpVSRlpbrz07k/siNv82oYwwvM9TwXGfZseI
	2SQ41Y/GAzbOSbvtDPMaEpC6EhXy0P8pkiZbyTePJXehClmYdWiw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k85tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:07:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OMmnpU014625;
	Fri, 25 Jul 2025 01:07:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tju99w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:07:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKrA0khOOZkljToagObwY47Qx9bxESFjfoIpEBpllRxKRiWA5tasYiueaPG2E097zhUeT8u1BqFF1tET5XI1MpljlCc6unsH9pInLXBnZIuUt1XlRJIehcm8qOG5bCpNmmdxIkRaYevp4dgZ/+arMqIt5EqX7ihcrKllpyIAHA3STYpIqE2ctn0v5VtikQwSDMl6DAkpOsoTzrycPU1NIiCKr3OEAEdnBCJHWqBN2Il1uItZIpsY4Eek8txTwx1XCjo+p70xsyFt73xoXGwZj7Pj8DHtl6y3/TlifIUBCfdetZMEoTZUe/bntUyLFGN/+aRw0BED9Ble9L0wTC1JDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoED7T5v0F8PoJAWNQkrLQLKIRMczTVrHW/EI8kE3gg=;
 b=NfZWMAmU9VB1CHYUYHukreZmCtBfgHdefMWfKyk+1QzxaRK5wGu5vp6qb/87aK8FG4lhhhrbIaJDXrRjIFmxkZTdQ4Tgl4rbskscKIclKHqI+L9ZTVXJ16+aW3H21OmLA7uQLJULhyHdBzmivDd6d6ie0p8SxV/ZWUrCM2In/WJByl7d/lU6NLnZQ2Tr/RGu88b2aIhP933g6to13PEQiIXorr8v3z7Vv8bVKUz3lfyIUs+hlOnmBhe3SqXeMsjVDmUubXOSgMPLrK8iaDvZcgbfJwNQfg7+2GOB+gI7C+RVRElrGz7J4LsOEtUp8No+IjwD/SJZt1pu4xDIXE5lWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoED7T5v0F8PoJAWNQkrLQLKIRMczTVrHW/EI8kE3gg=;
 b=0LZ/CK2EpVkzKCZpiyvkaiAziB0bvpuwPE0pZAECfMDx2qeU5S2TGeEqMtZWULVdQD9nMki+rrxVm+9Y6y5Rgdi0RqPKzcr68b+0tfY3c0Wx7bZSlycqaI5NnMsdCDCoWtMaEoywS0zA3Z5XSaFr3BWzDBcgm43cMhoV31bl6co=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF9FE99AC64.namprd10.prod.outlook.com (2603:10b6:f:fc00::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 01:07:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 01:07:48 +0000
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix a fw_event memory leak
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250723153018.50518-1-thenzl@redhat.com> (Tomas Henzl's message
	of "Wed, 23 Jul 2025 17:30:18 +0200")
Organization: Oracle Corporation
Message-ID: <yq1a54tt6w5.fsf@ca-mkp.ca.oracle.com>
References: <20250723153018.50518-1-thenzl@redhat.com>
Date: Thu, 24 Jul 2025 21:07:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH2PEPF00003858.namprd17.prod.outlook.com
 (2603:10b6:518:1::7a) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF9FE99AC64:EE_
X-MS-Office365-Filtering-Correlation-Id: f122230b-d42b-48d8-0b20-08ddcb17abcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SbIwidzX15RX+HJ+E4lnW+YtIjIIHuLiRQ2NwlEJ6TGCU0N5Eglxg2wlNVKF?=
 =?us-ascii?Q?Msezn6i29sbfkQ9gKuU802AFTTceR8joV8fA24du9vBST4MtkIT5vGZ84cSV?=
 =?us-ascii?Q?A6rNU9p6eVGEzVVTUEIiTouqcn3IlKqoNWY3XrZld26RgYVtfnUNaCdbPnle?=
 =?us-ascii?Q?u2JqE8MpgIBRXWs2LoV70KMWoncoYKdkGuVC9ItrTFNWWyi/a55QboQFfHpx?=
 =?us-ascii?Q?z/9c3pprgIMpsJ4eo2d8wriRkz/8b1gd//ANja1qCxJICq+v8V/ikJPc/Pm7?=
 =?us-ascii?Q?R2kJxJD27ajfG2bZ1fulrLin3AHv5DbjE1dYgAacUB9gidnqwb/xGcsV7Xuv?=
 =?us-ascii?Q?cbLzuRX9YQnqDavYlIFAfV1aJJluHBPBhDUZ/ElIGEtL3/YIwlnInhevJ6pv?=
 =?us-ascii?Q?DR8ySRKezIcNKQN07heQbzWBYE/YtQ66zrqnoTRZ6zmHXqclxtAJ0qxRy3En?=
 =?us-ascii?Q?wSyngSN5bjAD3Hxt9qL61AO0ZZxDroLDvZE1fWcZu7SFMyIAPlgEi2Jwbw56?=
 =?us-ascii?Q?R1rPBuKpBfpsUbx/FekeM5LC+zPl1isZFrEeH1/gZg7WXv0Pav5m8+fge0J5?=
 =?us-ascii?Q?NMPDsVH6Uziia4yXTSD3A+2t/FF1FhXqbfwr0ak3peUeNSvXHwO6gDau1j0Z?=
 =?us-ascii?Q?0eaP54nCg2Zzori3lT8sSICgLDn1tbSPGms91e/eLN9zJGz7iVjzCdpsqwhA?=
 =?us-ascii?Q?h5NgbEDUrYXjJKWFpQ1afftsRw/W8BAf/UiF/0lFMY0ta3emG8iU39HaxP9R?=
 =?us-ascii?Q?MremX2v4FqyGEw++AfOtbO4UB5seO0hO4l4bhHWKBaF6urRybUNImEVf1Nax?=
 =?us-ascii?Q?5KPkWYUWZvf/ZOEsiXKHsj2pbcqETNuD8PBPtlTlaC8PH2CsJCO+boHj/cx+?=
 =?us-ascii?Q?FI77OcAKP6Ohjkm8A0mzE3gwou6xlq101+yyP9hvhN7MsyJVOZB8SbU+AoZ8?=
 =?us-ascii?Q?p43n9fpw/VtjKBt0GZzaaRr0G2wZUtmzD7n53c010YHc9gPKoOPN/8YjEbzx?=
 =?us-ascii?Q?dDaRrC30qEVSZ/5fUHRsKqyya4kdBw1wjDlmL0Kjl3XpXh83rKopsFyDahwc?=
 =?us-ascii?Q?XrwC2vRjBcp4RlBIAmZCSdYPfDJB5xIMVTTLJ9/QV8E9gue3ZMVSVHyO7Yhe?=
 =?us-ascii?Q?Fxsf4qY9mvu16Cvl9xvCyLYQN/Xp+zsK88AYiL5IpF7MRN5x1WNSGPuZ0NVk?=
 =?us-ascii?Q?MWPAs1LMEFv4/tAHLWCpgKpRUbcIHx+r18jtwev9yWf/RNkze+3DnL1fbNC1?=
 =?us-ascii?Q?+Pp1UduagXjhW7xDF3x3MmkLk735X5gS9MX9tB0LkSYwaGkWADSGqSYjzheI?=
 =?us-ascii?Q?TaoQDaKG1Y9pkEyyrz1qxD28kwjNdHWyUccyXpz9AyhIpurSlxENPEjm1E1S?=
 =?us-ascii?Q?YjuE10j8PQNAOH/oCU8XWdPGeiPvTiXXozAbGGnWJvHji7jwPSSQoD0nAcx8?=
 =?us-ascii?Q?cGEe54UnAaQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TwmgoPwijv9pDxKdDliS0V+tHOz2XK289ckZd+PCtsnQzJUVKbqmc8gamc6H?=
 =?us-ascii?Q?bqPGxHjIWj3DyN2O3PmAe3DZ21VTdr6WaA13UHE2d+VPz5wbcqSpZvmYoh2s?=
 =?us-ascii?Q?IacOP8bAQrCfwqv8UvF3O0+X+aeGn7YIUgQE9b4987Ge+xyvElrb3nN9TxPp?=
 =?us-ascii?Q?iWmxpg24xIYsPr1f2L1/mppNdSk4+QqIrQfSV9y8zN+4thmZHa9i6DsCjg72?=
 =?us-ascii?Q?PVY7CV4LoK6Er9ixKCoV63Sv2ioj0flL5hS+TQbvlhLef8tO6EujIh2G3vra?=
 =?us-ascii?Q?PWg+hGsNq3eLkTBhWGvT0X9jMEuQtlQxeBxvxqUbagZBW4ApJ/7AFgUyovzb?=
 =?us-ascii?Q?R1go3Us4V5tJcO9GTBwtboi/AUYWmraf9ZzTeQeTbH3olQSq3Us5kKog0EUz?=
 =?us-ascii?Q?J/6WBUmAGIs8LZC43Myh93+omAoRiilYcr5tYW1A9bsl83XnjHzLsJxu+NDl?=
 =?us-ascii?Q?GsMZN2OmUDsVQd71q12V6qEti337IFW2zp+e1PpsBgvMQsZUBd4YWgLbrAP/?=
 =?us-ascii?Q?V1gg+NUVBB1iwwo9/RHgTQSTf9viK4SYk5cBatMMkTBDmDPRKw1DlPkFV2jI?=
 =?us-ascii?Q?2+rSRfgEusxlPEm66xdA8VhcfKw7KuzjT5zrfSfn5H+x5j2p5rvSjffCi6fk?=
 =?us-ascii?Q?FSAvXre1bLJSLhxi2qDUEP2+qfffX8Zp5HP82h5JLx/6I+nS3SLS/PahOUZ8?=
 =?us-ascii?Q?H078pv3RiQRM/zbAK90tspypsRMg4A/CPRYroXW8CVE3ozzFtHft4rTa3eYL?=
 =?us-ascii?Q?l1WcQRY3JQWZFHJR6uDszmGhUt7s5ZfqwPwkF17lNAnST7PUOymG8KD6ov6M?=
 =?us-ascii?Q?snYdVvqDBPonoq0EfHciZMobjmiyZ129jIOgol5sVtX/iAwXhHv+ojHYtlpe?=
 =?us-ascii?Q?FRlo309yo1T9zewpDZNa7sO59gJ3/Jf2wFrDPZtym5Lgl8fBb+QveJXWNvrv?=
 =?us-ascii?Q?aMRnfaGQNuK8tK3Gc7lyUO6Y2OErsvKH+l6EdhLWbMCODOuqvITfxnc9sjyB?=
 =?us-ascii?Q?H6YmxstRaayNQeRdTPu3aLY5/r6VZO7XrGWI7J2mIeRugH1EMkXqGFMM5UjE?=
 =?us-ascii?Q?kDpaq8sKTe14sq8E5k/F52v8bLFYwdnkloj+vEPd/CjXuNBPUWYMR09UK7My?=
 =?us-ascii?Q?f6gOge/dcVF0q+gZSRntmeIV+l6qeWUazW7HX3jvNTF9ofmEBC8/BmP/PaZ1?=
 =?us-ascii?Q?ZZg8CemJXv0JJwmcDl9fssSvLJ02cTIsIlgizIK90y/mCdch3L/zCJLfJ3t2?=
 =?us-ascii?Q?03juZWQCzMfCr3qWLO2Mw480hObyfSQMdDpE/fOno5bCofuqYp1osoCkeJqI?=
 =?us-ascii?Q?drcnsjpLnWCIzfPlef3K3Wi6sIDlcNnRCcPZsGUNRd5XqHrRKtz4FcF2JSDS?=
 =?us-ascii?Q?JCzujW/ACj+XHbxmvo0SChIXkb8kBHsTUDM90VsB6kennsZ7Khw+lk8mKLV5?=
 =?us-ascii?Q?8+S4jcX8RcPq3NkeYfw/TPkE9RncsuZFGKD96CioTFKsj7Po+QINt2WAjNYF?=
 =?us-ascii?Q?UNTk5DClhrJcIZq69JxuA1Q5zdsE6HzdzOnJNmDBtwt4/faqB+Rklhg3Gmh/?=
 =?us-ascii?Q?1j2iVLXjeCluZgkCG3nA+nS7TkPOTQ3oZwH8urPN2bwpE0yVZRqfdbZjyfTz?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SNal86azxqUhJhuBS+0ruoZGFEttVvyYYsYwaCxzCYKqjJXVPdK1V2wIWuCTlhEaONFHLTR92YndUs2lsW+yua2v8Csy2VtQSfalmlMF4ScESBM0g6Lc8XulRFipIc+O0XzRB+c5cgV62yD7Zprd2g/lm9pL+kD4TVRAuYaG9tladESEnTCuTg750RF15IERf6P3ZCY9POC3GEbjqxP/EhRwytmWE/6D6xQmJPEsT7/MNBp0ENQCZD34VoyuV7huRGURMvGT/qMotMqjN1xUgvfqKQ2uE1oombYO46yt69WYi/pJF6IhumbG6sey7k7AW+wMS8dTolXqDdtIXE8vSylNqUA356HC+iTl61PsGK4WfTF78CEGklrz4Sw7ajRh65Y7JGppa6GOAR7fP8AZRueaXpowWTZOr1nVbgOzoCRST2Sjipl77YsJyotY+878sFTdmskC5kBATN7PosmB76Oj30cv9Qbx/4NBRdx9cFxlZV/Fp9Hogop3ql9evvU7HPkZeHWNmplARTG3Ye1CSfJKHdhledfT/1De8xxDUcSxN29xrbVH7aHN30l+U+EuTYODq+X5GayHVCY9SyscinmXJnkuToSPW2qpqp5J4V0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f122230b-d42b-48d8-0b20-08ddcb17abcd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:07:48.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UyqlYMNOngDBgf/mp0gW2iPxRvXvqGY+YgClD6bVUtRp4RiAacDedgj/jgtCG3FGPeTfgj+iWrWvyx4y1Bg67cxwv7a8ylCWcUY39uFiLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF9FE99AC64
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=957 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250006
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAwNyBTYWx0ZWRfX+uh/3aLQlvCm
 MJqAe1z6UQvN2reCmCDpZmNYEV5lWuDgvN+WrZHc3kaQd8NwVzvMmzYRwvkfzPksNhjjCgnTHP/
 1HxO51iWdzYFEHMSORRlaAvsZ2ty8jTz8W9FY6vHAexH4W0+kpcg2hwqSX9yqkopKjFA2w5iHhZ
 y3JO2doAfEZmCHDxQsLiLYb3nyZq69/b1+yvEGgDZqdB63fWbt4PbFAURjBond87pNNvWt62SPg
 DXtlsr7Bg2vkqNPG7rAGdQJCQZ0Xv/G3dPNhgT/Kg+YpxIU0qOCpffdEBkOxwYCUzb1iOaYPv5p
 t+24PJJFr179WQ18H/CgbpkOiAysIB4lje0b7HI/Q3VvCCwgDJ+eyoyVWwr9vnbn+Rg5hLtV5dd
 noXOJRVrBcYlORxeQNZhrf/sf/K+pcGf03fwOeNnAyMzoLjnc3Vg58ipJbNY4qWA+ClDuzeT
X-Proofpoint-ORIG-GUID: 8-nho6SE-INje8JWadL0xyg04yxNwSky
X-Proofpoint-GUID: 8-nho6SE-INje8JWadL0xyg04yxNwSky
X-Authority-Analysis: v=2.4 cv=JIQ7s9Kb c=1 sm=1 tr=0 ts=6882d8e7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:12061


Tomas,

> In _mpt3sas_fw_work the fw_event reference is removed, it should be
> also freed in all cases.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
