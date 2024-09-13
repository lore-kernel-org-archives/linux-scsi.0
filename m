Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2594A06
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 00:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726189006; cv=fail; b=WS3wqlDKXShmtqq1yaIl9c10yo77fZ5wcJv71gifDuHrS6MmtsI8b3UI4VVOjPz4rGphdZZatOfyTmkx9YyT+GVUxpJ8/RLd/ORWBi99Vg9OpkWy1RVdKY96tRZxEekxYApQTRBey1EW8mf5Pbn4hVvwTwBgUBEu9fBfZqv6IOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726189006; c=relaxed/simple;
	bh=Qz8Zd7OpbdmpJAc06DOE1GMnR70ZD8GEWsfH59erIg8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OfimnkV7QbgFfp4y28hCiQlVR1OSOKxiskn2SUQpY6NSG4aorNBHhf8bseGqmWNueE+8Z4sy8umdG2xnpnYjHeIqX0nVPBUVIlaMy4GqX0k4BJ8GhXYZckXL2p2eEXdehrguLqHaw00HFYmZX6rfAt9A3Q8F4qcNRoIScCFvyyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UOZbtj87; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rty+bMD2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UOZbtj87";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rty+bMD2"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBW0p027783;
	Fri, 13 Sep 2024 00:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=c1S7I+KZGn9meQ
	VLWBUHA5gysyGL3kWEQoCLyGkf4Sk=; b=UOZbtj87bixg3UrZt3PS8vLSwy88bA
	CIxq8ib0OxqH96rXClUpRdGnxpvuXRQydmZweHXaws9BM7tDMqn74WHA9gs+coBT
	n+wQYgw25Cu3L6mB7MODkvv7Ew74nvDQyCNS1AfjKTOc7kpkkRTWJifPTyccZBiI
	Sb20hTFkJR+5oSRDTpkfj8Jpsc6Eca7btKOiBOlCCUg8KRgEkJJaP324Z/Xt9Zu/
	AXMTJv7UQ+Uvt9NxPYt65OfJIoDGTaJG9W4yo9WwKqfRGzz5a841v2aeqsaROGki
	P/KLIGmzjBFNySZJ9hvENJyeAfoXi6Y9rvorJpUIAlczR2uAvNqg+y3A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2v9we-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:56:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMEjfi019927;
	Fri, 13 Sep 2024 00:56:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9jj4cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:56:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CgOBqDiLvimQGsDbTYhVRaD8tOmj977W1xZCwgFkz2jpAvxMjxX1+V3PbTngDMCD4EXU3D5qutKWfoluZpZ2gonIl4Uu3XDovb5FqMotMI+tvjdzndrz9MqJZCpTFV2E1jui4w8th6+I/RLC7+2OhBiLnR1yX5tteISnD63glQvUWZEJpaFcFuVy529b0J+nCqwkyR6q5jL8/nAemAygiE9cpQCDmtR/7ypLu5udZ8hU+HY6OpnWaWx2+hf9PFpjykOmK3q0CuM1l4dMahqeEmnjFyH9VNu65dIKv1AjSxJm0Z43L91mpUE1BDlySYpGe89YexlGemVQc5QT5Z0Bog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1S7I+KZGn9meQVLWBUHA5gysyGL3kWEQoCLyGkf4Sk=;
 b=C2L4cIATOleSU2XH2IlHr7U7Sr0TVOTZYwFj9DKnDGRiEwkguD11eCTJFgOR1Eh2SJQ4x78b0TNTrXRDxTOaBXO6NEn+9muSyMTFgLKebDO77mCe0DUPf/l8QT0xQer8SLiWeBgPvbrKSaLk5S86Al//X+jc3+KR54Zy8d+X4s/fn8WYIgL9E60cIrdIiZWRbcrMq4tdVSOTh2tejn8w6PcyN3WWA2E7eMwAUFYbhFC/B40g3l1E5oQTQj7Kk54hu6Ga94ESqwWf893uDlzGLYzyvEbjLcHCacgSuSz+gvlgUjkGOyMNxAkCdIYkwO2FJ8uDBXSGXTdsoQ3wAya2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1S7I+KZGn9meQVLWBUHA5gysyGL3kWEQoCLyGkf4Sk=;
 b=rty+bMD2KM8WlEf/zHNqQG6X8ylem5l3YXo2PvLcrfppaEYgk18qFRjxabx8+vJ0WM9vqOmOLNClTl8xX7Z5kAcUT1QcNS78C1evnb4nMUkSKx4W0NYvtgTE0K53cF6czJhhwaZP6RuuPC1NomDg/quF7pxbWq/aKol4BG8MK0o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6287.namprd10.prod.outlook.com (2603:10b6:806:26d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.7; Fri, 13 Sep
 2024 00:56:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:56:27 +0000
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke
 <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        James Bottomley
 <jejb@linux.vnet.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Bart Van
 Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fix off-by-one error in
 sd_read_block_characteristics()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240912134308.282824-1-mwilck@suse.com> (Martin Wilck's message
	of "Thu, 12 Sep 2024 15:43:08 +0200")
Organization: Oracle Corporation
Message-ID: <yq17cbgwevk.fsf@ca-mkp.ca.oracle.com>
References: <20240912134308.282824-1-mwilck@suse.com>
Date: Thu, 12 Sep 2024 20:56:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:a03:255::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d962394-f219-4b25-f2f2-08dcd38ee5ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x5y2cXTcM/8SA+y+ImYMxXtK7q2de0zYBSe75DtnuD9SJIHRGGgI15rCgaE2?=
 =?us-ascii?Q?IXUx+H9pubS3+4eJo+VVwlNwARyh4qW+cN1LLInwmBEtOcf8Pu3FC0tj7YX9?=
 =?us-ascii?Q?98g8VoRaAWZXHgYWN7G8xY9KZOgqMETf5brOs2ZD0Rcftdz89p5rIChxPde/?=
 =?us-ascii?Q?VuAW3iSBIfSpoLbkpVH8b0L+CKbLyZXPY6+0FE0H3QP19wGPUZHfHRjPtVTV?=
 =?us-ascii?Q?gVJD7x/tzwcwYssGbPTfcvihxmwSW4WwiMOqNuq3Ri08xapoSmV79jt5Ssu3?=
 =?us-ascii?Q?z4xKJ08YLbacF8agwk6xH+aCVfdCDs8FWL98sgKqAX7orSYMfpS24Zi2TyPD?=
 =?us-ascii?Q?dfZrvckrqVWn1Ke/SQZjqmGMwMzIoAz9+84DacNmnMBqu5IJQWH3YO1LDkGc?=
 =?us-ascii?Q?fAmboJeAKaY5qz+Do42/Nj73N5FOm+bNT14VEoyxbkuDTeI1kYQ6Rlod0pRT?=
 =?us-ascii?Q?8m0Ivp+hC5vzc/qNIcvL64vlvGlY3SChY8B46q6JtHt02a6Lz0JwjJLHiPQf?=
 =?us-ascii?Q?SB7wB3BDcKWWFZHlZhPSGswySRvNQjq4MH8dP6whxnNP7YmjRMdQd7ga6WZS?=
 =?us-ascii?Q?wQIOwQzLjIyY+LKPgoBA/5cdQ0CypFa0MU1A3mO9p6mKScbL9MNPmuavR252?=
 =?us-ascii?Q?XQaXcRptMI0pmHqvUtTXz2vK8JjAxa9CSy0bYzXN/ziDH7KLL8QWU1wznaJn?=
 =?us-ascii?Q?zhbksD2z0dBkCfw7xvkAQ3XkGLlxUpeOXc4TCx3jPG+EgVQD2pt3Lr2uL6Jv?=
 =?us-ascii?Q?LyN1g1VS4jnfFFt0/H3zxMQA3kqF2g08sSRzRrC2BLgPJnFyxjeScn+7lDr6?=
 =?us-ascii?Q?sOfoSW246AqJPUGBPjDAJQHEyO3QHqOg/WOsI5UCT0mlDn2ZRTckjizZBDr1?=
 =?us-ascii?Q?cDkCsIMLnGHLOD/Rg9fcsrtaDb6IWs3uZtv67SmFKb06ilPKQdnE1lcnA4Yh?=
 =?us-ascii?Q?OeHcFdSZjEj/+7wKHBx7pxRjW6ZNts0dr/S5GUX/jDJcpfYvaMJz8ED6aEAj?=
 =?us-ascii?Q?2/DMyRBTMYw0FWC1CJ5kaeQxMjftWOffN98HPNKeJ9nkgH/Lr/vqXERdJ+0Z?=
 =?us-ascii?Q?gUwj5yeRONICM8eGH5ggc1s/bpwA2qMwkWzsp0iyzc2i2v9DPFYBlFSOFX0S?=
 =?us-ascii?Q?yI913SIfCR0iwUpWQ+LadC9hatLqlHfkkoSi6oX4oymeexBbrtlYR5P/C70X?=
 =?us-ascii?Q?E3yInA8WlkpYSvMUquo0wiKCBa697/2iJM6F0U9e8p+h0Nhr4MjI/7SmhEgu?=
 =?us-ascii?Q?Du+JEZ/O9W5CnkOzOOvCeewfMy6xhHzv8Y8ed9nEhlDHeGrieE7s7vMAAkn+?=
 =?us-ascii?Q?U3Hex59hWkiEZS+KfmrtTtUyYusaEMOQJOO/64l2Rsscxw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3vOelpnh4M4tR1nrWV0Pwm1u0yWm0a9czDsT0LEE1J1W+ZtkLFutg/DQVzPp?=
 =?us-ascii?Q?RfjNNiQQWiJufUaA3Mzgohbl6osD8L2P7DEaHf+Hl2QNZj9vnDT0awzyP/Y0?=
 =?us-ascii?Q?BBtSpPwksXOqjV09puZs6xYC0ykvNCi/lrpcHmQgLfn0S9cqoazN1G1ymklw?=
 =?us-ascii?Q?pv7sEkx6EaKv5R9BVT3/fhaObNZa4wKt63D9wREzrbKluqtNgF4gOYEvZOZ/?=
 =?us-ascii?Q?yHg1xOMBDbjb1AvXd6Zw5qbu3Kto6FPPVmP5tsHEBQjf8B6U/3quwSUVuxUT?=
 =?us-ascii?Q?yttOYMPaSVq/H1450Inntu4S+fYE2HfgPrSxD2EMQILSY22c7E+LBpMnutuN?=
 =?us-ascii?Q?7UIU6HvX45X4hBMSNBNrm476HCGCZ8rfhHG4BxHsiRjHrCz/XZZbKMVe/o3v?=
 =?us-ascii?Q?JSo0u1cY/8ykLhlO3OdAKi/7QmN+TXekgUBPWZo9qRKCbIg90zIq+fTNYXyS?=
 =?us-ascii?Q?fFrgWEdUI6gFPe5nauc9rcrwSVm5Uulm5zn6yQnTRVE1Z/xCPJiGlF0Ai8Lt?=
 =?us-ascii?Q?CLb/2rSAidbuJWNfy93Xmu35QXJKZQrN+/0dQK2PpSTIlTx5AkahDSsn8ACD?=
 =?us-ascii?Q?zDMZwkrJ44xWPofmL0mE+Dcx62mFdzt2nVqxZkSLcdw+Cc7yLznFUOOt5ish?=
 =?us-ascii?Q?KdBgPoryh65VPZXO/A6d/aV6S/zgNMiM7c1JgnwexHLEw0N5mfl/NWMPNkbO?=
 =?us-ascii?Q?fp2nXQzbcNPUITFE4GOnsOSz4P1Q3JL+n+WZtv/zY3sbF+GdkJbum7MKLLnP?=
 =?us-ascii?Q?Q7sE0iQ33QOPmeugsmKd1SSvtZkPjwBMi/5EkY4cN9PTuZnVLaGTdtNBkVvn?=
 =?us-ascii?Q?KU3LczojLgGpwIN7f/aF2Y4gYdDtknqMGrXbqPeIQ4fQNoPxtzyKg74+SVnh?=
 =?us-ascii?Q?FXr/6bau1r6t0BUXwxNMiniAuhGJ8N3h/oCgCZ1q0bcth62knw8GA3Nk+6HW?=
 =?us-ascii?Q?BdHTy9ajOTon8OyjnxQ7bRTglFW+Z4Uk4Y59V9pVVGfWqJ0Efi80SR/NAprv?=
 =?us-ascii?Q?4GuNFvmaw3QOlAtiazAkAxB3ltnO7rpti2tx26uHjsCMS3DoUdDTwr+Payv+?=
 =?us-ascii?Q?LtUKOy3ZlvvxM9zt1/8ulL2B1LdLCjrwWtSOkmDvZUTt+gDCei3wxIObFFrb?=
 =?us-ascii?Q?tvodj4N1snuTQZzwdocctJFJqL8ompFEAu3fe1PDpPz0cpNaDjW4oJWD5npn?=
 =?us-ascii?Q?8p7B3Axw7sipf4TOPjT4MO1cAlAEOfbeeipV4YNp1SqHF5jNGb5zwa1LEAHR?=
 =?us-ascii?Q?mZBT3+k8LNjh7MF6Irhb7byi1p11tWJWkTptGKUQc+HEP6yWQJN+mE6fMQkY?=
 =?us-ascii?Q?8rQUvhcHhQauf8p82rPpG5BKYPwJvUpX6XxV2yTAZCbE+zdvNcCLR70SPOv8?=
 =?us-ascii?Q?mNZ047PkcCMPZo/9qJ8SvgE+5DJTfHS9dOK1WEggQ1nFDRI1+HvlzyJN9e+E?=
 =?us-ascii?Q?MLgacKv+Gj9/uOGBJt2hA9mC0KoDUD5vXV3yl5NmHrqPZzyz1si3KP7CbltW?=
 =?us-ascii?Q?lfW24lHhDmsPoLodeR4LB8l9Z+TQulM0VQtfSAMSnx4ne/fiadB4cKBt9LBH?=
 =?us-ascii?Q?J/9A396JDNTOtMaMbEEzn8SzOtXH/xA/3/AoeYYfzleIAt98O+FshniV+RAu?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n7ODWquEixvxcepx5NJ6249J52RVg23tC7U3n22VyQmH/33H4gLatOn8YRyRy0CMwFx7wnmaSGdfSGewYBzqI5RfAb0/UlBcFopG5U2c5xiHrXdSYoiv2hfj6kSJK1IXJiUitcn+teCeeCCuMvHVIhk1OO5aODhejaupvnOdok1QPyU+31eEA1bRUHJkQChGqvUppp7jSv4ebDeO2U9Rcn8En+RaZ7Xhp9Yw7kqXpp4nisAnas26LZkHG+8auWArK3GTj45CdKON+aESYZ0tlL42Yqh5UAQX07dhf50pkZpOVkkMpx8zin7To9QFZxjNUrBOlf7XVrkIKj3QNP/TCsj/UTQXfs6z33Zma0oKroZk7aVjn5tgUb/AZspemOzMQeH2okxKPNhpkWZORkJp/mz+3qtEWo1OWRMuzJ8Dsx4LPT7vrANfoN4RW9VrYP8PGk+8H6ewt0FMeSmlEYX4MiNgrG0OMKwW+BL8StGGQBeV5sG3cn6xqkVB1paKq8Mn3fHF4Sqg1Xp0QVq9RWk1ZYMD4QbszTc6tzL3R+95lFQMnKC50d4bLM73QeL6fn2+p8HUzxYjtRSe90L9/eIKHfBieY/op36Xxv9OZKIUPPI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d962394-f219-4b25-f2f2-08dcd38ee5ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:56:27.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHl7LkewskwUyfVzfnOCx/rjQBU+IfLXhpswg09WxCmDL9T0aLHkZQpMKtXqElM6RlKCJmzS6AcIbfZxqOh69/4OZV1i9BJwYyIya3+huIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130005
X-Proofpoint-GUID: fX3_RPg-2kYcNkBp-IxYk5MOlxuzDwMp
X-Proofpoint-ORIG-GUID: fX3_RPg-2kYcNkBp-IxYk5MOlxuzDwMp


Martin,

> if the device returns page 0xb1 with length 8 (happens with qemu v2.x,
> for example), sd_read_block_characteristics() may attempt an
> out-of-bounds memory access when accessing the zoned field at offset
> 8.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
