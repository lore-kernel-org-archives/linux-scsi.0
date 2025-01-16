Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80020154BE5;
	Thu, 16 Jan 2025 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047175; cv=fail; b=DVQPqfuW8y4fu9+CcVdfICK2C0vB9QiWdFZIz8phi2/oRnShXKaMy3+xkWNc7MId7vxMEzOrPreIo2tVTPaNpHXZNWCF5rCW/KGCUosloQ6Joj2I6Zf7lLN2C3lX7rfAWRlrJI8wqDUF7yLXo0CgSs4rAfxvgnSUFc1mXlogd1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047175; c=relaxed/simple;
	bh=6Z3AxKRbAfACFFh2rOxyTgKgRtH8a4uMMYeVpLWit28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oBdOF3pp25FGl/19EKOsIwIhJzHs/HTlq/kZuwhYOSmoqofQ7y8anx24Ht17XNG2oIHIpZSPY+AFHJCkVQQjShu2QzaNGUGCyr5gCQN03Iz0SH3v8KZkt8jCh3Hex7+GDbBLn6vZWgTpZVPBPmNLU+wJa+4EWW747UUtT+DZufY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Whe1NlCP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KCnu4VsI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Whe1NlCP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KCnu4VsI"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0mpU020191;
	Thu, 16 Jan 2025 17:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=/234QoQX+0h8OacLimOhvyViffW99Y5FKI8yj0DyY/s=; b=
	Whe1NlCP8Z6ZU/KMEmT+iZzpN3bXLnxHaphL12XXrqeVhFFKvADjSVIMk9uqmdk/
	+sG2eFN3JTqX905DVGxlOT83ZClfkJ9GpylAzMIyd7oU8JQqGMePYuvaGwHsi2h/
	TQ3IpBfq1m72DCI+kJYC+r72LFxu51obQNBlqWphNJyMExOdG+BNb872CKPhnfKf
	wAsyURjp/Wf3nJxfxefg5KwkJmQ3VlreECU0zqqeYCijrVKUgy9+IDVHHMobRisM
	5lrc4Q+9SGZSBfsm2/YIIB3ocoa7rZ5EG/FS/EzgxKbEVhohIi04hOrIRUAGIHBA
	IfONxzV2QlxT0gem6DBY9w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 446wtp919x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GFVoM7020422;
	Thu, 16 Jan 2025 17:03:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f3hdeux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhN6/v+lcqb4GLVejA+WMHQgWsRKauYTlw+GSqnsgVyS5/jEtusMf6lQza9kxVlPQlKn6Hc65oYFqRtZoY2JmXEon7XD597LdUaTTq5xd1ageWk2r8PdtjCCr8SzCpaSaQIKpInARdvu030s4NXLFFgqoWHALb9f8qs0MFGQfWb8LXXcPQjdlWLTT8Ujv07pLE3C5PA4kStN7RFVaWnGMAnYCYSdaNgr3vVewix93z5ZvvNiU1VDDEoLp7F6tCCAF44QtMCwcQXaz4l9rPHOyEy/xxxkE6G8EXnklbl0eK1sQ1TWvWUcMIUVBG9rA9+60XDUz3gffIfTWcT1wpo3sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/234QoQX+0h8OacLimOhvyViffW99Y5FKI8yj0DyY/s=;
 b=lVYRS1nW5AmLsvyMTI95Su+ScZhMDP2ts/wW6AKBHV4q1Be8wJcV5diSa8617M0LIWWR3M5F7EIGSZphHqNCXJFkj6E7w/InTHt9GZmUzSXH+rZydm+tGQHG77tO24qacQcIToB1JqoCiA/X9/UOyLkaqd5uDG3dPWHqa053hjYltBlCCuNOR2RfZaGwzxtoKlfHTlOdV5PosbQttxeQm5QVP9gkS36w8Oe0nLX15awTqCCc/Uqbrnl+D/seI5PG/mfMlTJQAp9t7DKIlC/T2e2pEfZ4JBcrPern7H4ZjlloR1iqgVcPdpIE1TtpJtw8XA5AtJqAc6aZOXnmvA1+Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/234QoQX+0h8OacLimOhvyViffW99Y5FKI8yj0DyY/s=;
 b=KCnu4VsIYLlpg5a/tYlO5o/0keD7tJD/UVFQ7DJ/rtHRuF427JEkYVZgn81jLHRRhZRw9S9BdnWlBtL641kB1y/EX1OaZxrJj+4u8iHdrXsxqwzTF7TiRO7CEU03ceMoLW753a9OdkeSNjjQAuQ4uM/DyeR72mq1Haz5S8xznuY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6235.namprd10.prod.outlook.com (2603:10b6:208:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 2/8] block: Don't trim an atomic write
Date: Thu, 16 Jan 2025 17:02:55 +0000
Message-Id: <20250116170301.474130-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 3055ccd5-0061-4d67-d8ca-08dd364fb4fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MkL57MpQxDHt2lgycTBr5bYZgeokMmpsZIJKvrNjXLhpnUr4LVD4+vhf5gLs?=
 =?us-ascii?Q?g7eYdkSFTBqCEPWDiuYjm+WyViGA/PmNJq3FvK0T4i6CKoXz4IDba6gnonNa?=
 =?us-ascii?Q?iZr4Z+r9hBZ50XNo9ocA2jtGCLzkNmrddy6IcaYj0S3+LgPOnAGznBIs90au?=
 =?us-ascii?Q?POZ0LXt3RujQH9cvByHJIoP3R/uHZlByMpsMIylOLwikgRcwIiQd0yucmSCe?=
 =?us-ascii?Q?QYsd0uZ6arNETpJFDG7wdYseOBoVbaC9PN+KOQetNnt7s7QE+Sxt/YJAy4Wa?=
 =?us-ascii?Q?kygU4vhBSxC1nc1p9i+cueNIsqIe/CJaEfrAFQLBwQQujsM1lnWcWTviPIlu?=
 =?us-ascii?Q?AcDTGEu9xC8tGUTPf1RH+FRxeudWYRv5mE90ml1QcDMir5OAAek5nujq7Wet?=
 =?us-ascii?Q?GFrwdxo/XWTSY6EzF1skN8hxP7+IYfbkTKfWSnd1GS4A2OLs2F9oXsJQTnep?=
 =?us-ascii?Q?bt1+3AbPHYgV3lbV922eUylBKdvtgA8bK+erGnTdHeu1mBF50FCXU+923rn3?=
 =?us-ascii?Q?ZDJ3N1CCMFUWotk8FFH7OWZ8d7BCn2arNlv0d4TNGitsRHlcywiJHp/MdV8N?=
 =?us-ascii?Q?Kq/p3gK7qCOAhm7fbto3mWKoxw8mNniyS/+yRj3ygRnlbUHs1S8RMpSCeF7K?=
 =?us-ascii?Q?kM3Y/T0Kwylbu+nrhScBm5Y5SLOzkGtSIqYZw1UmhJwhzQ6vLeJIVoPg+MfG?=
 =?us-ascii?Q?LfjV5SaRNLjjeW/FYEHKp5h8gL4QvfWVBmf9fsrYGH+zSzQO3tkJRJXV26NR?=
 =?us-ascii?Q?P33PMEsxq8PpZJKj0K0XEDr4CQo+PtB94Apy7nmKJ+S0Ukog7mG/pEe07ow7?=
 =?us-ascii?Q?9aAozndUJ8kH7VaAmSGS25nCDrKCUGgm3UgrbUKEHSRFvvHHntGEDaqMvzSg?=
 =?us-ascii?Q?Ry7fKTF0PNIW5TexmjCl6PxeroOVSu7Uj09RIESATgDNZ2rJTZ0yU29s0OZw?=
 =?us-ascii?Q?VlBqj5G3OVKp7UoB94KdWQ5JfFslHPxaMw+xmjHcI+x5J6Y+uWoeGuop5k7C?=
 =?us-ascii?Q?26Gsygbyat+3RIOX4lyWTLLzmCaoxwJjeR7D81UGqhBkmmsumYXwMRO0beiG?=
 =?us-ascii?Q?jI6XB2GoKjJcIxgISuTUC5iYlBE2/uG+r/h2w+weEAhVC4UesslAYwqOaJ5C?=
 =?us-ascii?Q?NWn6IYqKTPF9/D63KVgc1vR8FFmdzkUzB4BFOOhdTI/KdxixVVTuWQi/ETnS?=
 =?us-ascii?Q?oQSd5Gh4JUVoGuJVIr7/zz1+I5ICku81pgDKQAvwZBmttjI6dM26NqwSUVqj?=
 =?us-ascii?Q?C62afiANzPVwDZtYc01UVZTj+mFK5Sai7OiV2dbVcpPOZg2bcEVATGiWLv4p?=
 =?us-ascii?Q?FjvrQUyZG9ZiV0VkSsGIEWH69/1epk72VLwGXOAdTxEY1EpJJeK2VwOv/npW?=
 =?us-ascii?Q?lSnkK5Q0GTWnqGqqCWmWmQlloe5N?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mlRhrhWcwbD7FIIoey/9G0uHeJ7h8CzpccsHrNY/JjVGxr8SNQ4kT0DeWgsq?=
 =?us-ascii?Q?QPm+PqJZ6HEqyU7vE8sCMfIYP3nGDj6V2SY2n6HWYqufaBE75tyWqR7waZlJ?=
 =?us-ascii?Q?5w3rO9lbp2d7UBx5GFyNG+XMQM6UMaf27O0PLyfFkyiaYGZTKG1pCAMbQ1Kg?=
 =?us-ascii?Q?pMXfaMIWxeshaB2Fr58GzCWPgx6suig0jI21r3SkbBGsqOjHII10+15XsBE6?=
 =?us-ascii?Q?nHPTBBcwgxvJcp3HwjeolDWy2ObOsdR7FdEsJqajY+CDU5QVVGNEJxN5dWYu?=
 =?us-ascii?Q?uUE8nCchXELcEKgvBpdkRt3zDERVNjkgJkw+stMyRE61P0BUeuok1sTsU+PK?=
 =?us-ascii?Q?FUp1V340hVk1aOt8guKg9205+gwS2NsWRYpjY3FdCWYjNqnNWaQU1CGVUlg6?=
 =?us-ascii?Q?Rwsyy5hCSyfj2VOsntBsDmsocUloW9/6n3Og6pM1CrfthOJlW/QNBYM7MUxD?=
 =?us-ascii?Q?xs/hytdlHiZLUG2neJZchCvf4lz0AOpT4xqx4ne2LSIvqQ5jTn26pEWMmz/U?=
 =?us-ascii?Q?Z2MwniPEYYyPCLyoFqzaSKpYWeEH7ZchUNxNfGVwiDDU2pxhm5l05pPRckZa?=
 =?us-ascii?Q?MbAYTjpDxTtdQX0GjF6HOHUZzLey5lC9nMJv8ZOCZfYlZKpxYwuLkudX4PIj?=
 =?us-ascii?Q?dRY+gYMEZB+BckM4i8DzoqWR4H7hf56sKF4R060so9fSw8cy+OioFsVoPCqN?=
 =?us-ascii?Q?mFuVkRUTOLL5yTzU3HN/59hYEwaEprHa+EYBlOKqgdWuyvqgiuo+xjBE3Axa?=
 =?us-ascii?Q?EiX826JqxcGOI4tXFa0gHpV6o/5SCwky/KXrtdgyDTqmsw91yfAEiWvgj7fz?=
 =?us-ascii?Q?lIZcht4YOGUPAfebtmhTbHCSiPkWLnuZzyc44H+Su8vwT1ErjWJN1R4lSpJL?=
 =?us-ascii?Q?QFURs9Pai8HOLNvhU9qjRlpJ/z6YNhXaOKEVvyts3r/qnTiYdcUG8EMl8pUt?=
 =?us-ascii?Q?xTiYKUoTVPtrh1tRn/UvLIrhwPEwgEe07BDPfFZkPTRJWElED+dMCSFFNUW4?=
 =?us-ascii?Q?vDMtHKyEAKHV9NIN3YRt0LA/Ry88/0SV8JWxSHIIVBywU+mhbUcEo0oazRll?=
 =?us-ascii?Q?QdWymcDYPOPfIzvRT7dgOuaam7sT0U1oJPGY/X6YIR99Uau/S4kmXI6CcPiW?=
 =?us-ascii?Q?YxRgzIlYXKB1d//kTpDaYGMfxeocAlNpJiKAoOgdLKhddo+EwQutZwFJ+Spd?=
 =?us-ascii?Q?85ViV67PrI4HSKuqwmxkMCwYtKHY06R0Z9N45rQj6GdZjBzr7o+zTLwd830c?=
 =?us-ascii?Q?B/EQxnlkmgRRcyWPsZeP+dATu6sLP9YH+IYjw0nhSnG7h+tO5tIQicSfHfQH?=
 =?us-ascii?Q?WEyo2j4kkcV112H9pxK+uTSl1Czxkx+fw5VOWlbB2UV15Zj+s7oOorQDSaIw?=
 =?us-ascii?Q?IMBGrYggdKWhrXBxkLFYbJbrngCHcwNFslSaMbT7Tzg5E8D3uVUYpiIz3ehR?=
 =?us-ascii?Q?L94T7OeDw7RafQxckirEv20BQNRk3DStTeTvFRHPQsCSR6WYA/11wr6hDpoo?=
 =?us-ascii?Q?uoA4tHMNtUBxcFGujK+m+7eluCi/56GOZEYJ83/8kxWvt2b7RxcJiNgx4uL0?=
 =?us-ascii?Q?O1vjEcGufIHCz3JExPRB21N2LoO7hE6Pweqnee+XpBwZPqk1EGbXRXOXpaR9?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ttFMeJNVOrqgraqfWLWsPBAEMDuOddGVLNVPoQeEGE0O49HEgCJ2ehQwKKKO4hs3ZNEqSnMoebbNu/1ZHSW5bd6PNTYlY/HUbduZwzOoGrkMfnUYYEOZXEgjOZ0vP1APEx1DxqBCr+cZH3YbGZ4hQ2XXTWYIo4LrilaX9Uk9L3cArV9PFOvaWlVkc7pTSRoCB9FTtpg/ooWfylYTqFhpePsAT9mIxqrBNdvgpw7RyarcTitPAM0vFZTne+//Ay5MfwibSKsMOD5FL4sTQQSISw/Vbpv9ThwEzp5dA9KoDLy74hoyAlLR8cmRvbw8BytKsrMN5vGsVhSVgkjoKh8FREKSLMJ1+w/+uiYQH/RcNCOUVb1Pb7V8ykMK05GIVHAOuiAfXAbaJ3XyBzb1t0y38IsxRr4cIno6XYIf6eJD31/3v8wULodhZGyzE6cFRBWAGg4VsRSeMLJklC+ZZyUK4Pia4VqIi3FtOUF4wPZhKvXfnvF0jCj7baNDBpHKaD+7di1o9yaGW2YG4OEXkxr67nnaNK4JMhcXfxWNgvJMjwkTGYcqIZMGM8qTsjsL53IruqTMbgow2g3rQeAWdBfkSdCjT978ylVQ8UMAGLkgzEU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3055ccd5-0061-4d67-d8ca-08dd364fb4fe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:32.5033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xng2tnPhQ/Mps4K0/9vRAgovjejDhArsxwcCeam0jo5qTc3Ehxdn/iZytcFJTD8Dvg9pmBPRpATioz8hDRjEow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-ORIG-GUID: gxOHmD8XYKtsIGloMyPj7tyfvK4N2vx3
X-Proofpoint-GUID: gxOHmD8XYKtsIGloMyPj7tyfvK4N2vx3

This is disallowed.

This check will now be relevant since the device mapper personalities
will start to support atomic writes, and they use this function.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 4e1a27d312c9..f0c416e5931d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1610,6 +1610,10 @@ EXPORT_SYMBOL(bio_split);
  */
 void bio_trim(struct bio *bio, sector_t offset, sector_t size)
 {
+	/* We should never trim an atomic write */
+	if (WARN_ON_ONCE(bio->bi_opf & REQ_ATOMIC && size))
+		return;
+
 	if (WARN_ON_ONCE(offset > BIO_MAX_SECTORS || size > BIO_MAX_SECTORS ||
 			 offset + size > bio_sectors(bio)))
 		return;
-- 
2.31.1

