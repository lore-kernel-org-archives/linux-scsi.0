Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB41C2FDC4D
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765447628; cv=fail; b=IpyX5r5W/42iLYfaQfgzV9GN/LxwNGZAVrsxmP2A9+vtq1kM+e6J0mQ+iQXVjKhD1vIKSlv6BP1OxI8/4d+1dQsUnT1lhkGA9omULMcxQfvLxS4fzCNrfWneNBwxQ5E/zFfI7WR447gX44Fby3OGO8kkIchOgDfSLWX3biVXYgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765447628; c=relaxed/simple;
	bh=rSo3pezor0d6Ir6XpeTiNMd6DDNom2zO1jXa3A08uHY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jQ5HKIcuGw7Si1PxnPWTuxGYIqcvL3hCI6n0hakhMcsv+gCjy7ybA/8OSnImw6im5a0S/sbnjMazkK/8CMNy2qQzCNhsd2632NPMmuXL0rkQ713GholVdiuXgZaZy3E99Hc1/ImtNSofADd98l+NiQwWmHEOy88RoF7Y4SreUSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J+Jecq8z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ex3aR4zJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J+Jecq8z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ex3aR4zJ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BB1gI4J153843;
	Thu, 11 Dec 2025 10:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=BQvGeJ5RetJP2BsU
	73gbPyoo3Rw7ynXSd4M7HQ3wNqk=; b=J+Jecq8ztWn9WmLNarVC8Imlm7S3LiRu
	NvJgLwMGMlgLy0GN1HpI0KdYiN4cwzatAcdyEbMVjS/t41mkdxqeQpWRDtN+tjSb
	O5vKarUtQpzOUx+OWU7PehmWCPfmmJ6O4c4tQESsRkfkdbhHaREZtcP1I9C9hIKi
	90ToTrNDkb7ssS5EkNO9wCZXwcJnTz7w54FOthyglmVk3OywWUTfsnAg4Pn9dC58
	0nwzDn1ft/CX2AC1/IvfnX/4vmE2L/hVd11bm2D8XZjPATRgzr+/feBtg1rjE5Sy
	n0bqpzYmIqYy+Gyn8fwFpVGjp77bIFUn6wNntYkcR9OP/P2gznTRMw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ayb2s1ew1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Dec 2025 10:07:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BB8T1sS017531;
	Thu, 11 Dec 2025 10:07:04 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxbdwpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Dec 2025 10:07:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQPv20eBivtzJ4Ao9e8x8tERSqM5+z740gWvObzyCBYuTDxcAMt21cdb+/ZoU475MaV+RyMUnYkI9lJOWZu476Bck3yf8b7eEaFDJLwU/4ypeAFllJNQMYX5fF7FdAD6tjjsLfkJp34NePOVWMC0Tu1dBv0uOw1KKcf/Iw/sNpv5wIIbLSWUshkNTqfg+cJhU0Ww4xIrJls45j9oh2KCWW5ANzW1qSqXX0+taUsVHBsi6iRDCJEuXFl0L4SYIkoVYE/KIAlzVdqnA1reBnxr8p19R/nY0AwwMWXJi124IVcApROkD886giR6yvW5j1YfagJONYpvFFGBRuLiqGCu+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQvGeJ5RetJP2BsU73gbPyoo3Rw7ynXSd4M7HQ3wNqk=;
 b=QptgzOXrlV43wJ9Gt6R+Ncc58TX3wqHlRUVpVAUoO8qZEsXvJP3ilu3uI6fzMuD5yrsCYsgr9W2kMgVdUA6QzE3VEGv0NZdZoO3TeJY/1QH1jPBBJJp/QMS0x8/ipkNxRV6affr02m/jpRs3WI5HyVFgtEDbedTxSUv6txwadtsnMBicy1ECU5v0oLD7me8WwYu18Xp1ykkHfiEhW80ogkRfaLYR4nzlDG46ofxUHoyh4DshNYsnPvojXgFu4G8JTyOr9DZ39+d/ahJqiuiKb3eenY1ljf0o3FSZb0dmFLn/pXABfXqSDFQP2DWnmOtaI1Uo6bU0LkaLk0c6PlaPKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQvGeJ5RetJP2BsU73gbPyoo3Rw7ynXSd4M7HQ3wNqk=;
 b=Ex3aR4zJTn0hJd2m/UayuAX1hSjjqG/Wg4ZcKhiumIQWvB6kf5GrGcYD/prayCtDiY05lFkoPGlRRbvYB6JPZ5OkSaeD8OzcWUOPITYPtmivwrI0/RD9aN0pNB/E+vMUxa00D7zZx36beVEb1nzGZI9i+GgaZ7o/7xDWrqtifvw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BLAPR10MB4833.namprd10.prod.outlook.com
 (2603:10b6:208:333::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 10:07:01 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%7]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 10:07:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: scsi_debug: Fix atomic write enable module param description
Date: Thu, 11 Dec 2025 10:06:51 +0000
Message-ID: <20251211100651.9056-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0085.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32c::26) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BLAPR10MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ddc210d-08b5-4fd6-52d4-08de389d06cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eHvS30f3ltiUoezZIejK9tFN76rhd2p8Sso5KyfBaH4giTg0pYMGlFIFLps9?=
 =?us-ascii?Q?qnRnj0fQ6wNZQMDpvPlkpMcgsvp1H6u4eTgDrYPMWfHLUrEIvPiFW3xgrb1G?=
 =?us-ascii?Q?93SYEszk0QZF62YYBy+BLksPp00eTxtD2emfCanNyAH0p4lsmI7GtC+roMm9?=
 =?us-ascii?Q?JgSMAwdWhne6r4fFjylmoknRZBBxTvdOf1ac1BmJJNGR9MT+AQgvqaRITVLa?=
 =?us-ascii?Q?3/1Fm7H3Zvul4Pyb6hshdi1T9OMi0CPQitS42ay2hYB02rFN0trQ4uOeg9EE?=
 =?us-ascii?Q?u7R4gV6EMJ/IxGZaHyY76AbY+GZ40OVB5v72fv43h1kMLHtYE1Xl+moosmWn?=
 =?us-ascii?Q?JpcuxHaq4i0jFmwpamrMoM9kEJk2JZSY7zZi1JZ+VMmU8v5UAX575Kh3OD72?=
 =?us-ascii?Q?94XibvjmPb8IVSlEX4xN8sLKY0kyfK/7p5fTeW602PXX6we6pNOrxfoujag7?=
 =?us-ascii?Q?dgJWHBSl5e0mJpHSokOb+eAz310KyzbONPTnu9mh2gt6hKwdfgZERTWSFQA3?=
 =?us-ascii?Q?2xHMbDJQTZNPMQDqRCB3Ec2NoQNgy73P0Hp9nVD9uFRq17rPKwfLXjJw5qGW?=
 =?us-ascii?Q?okgFBapd/nSZWStx6u/KvHTrbZEOV3j88gacHEwME5NZEp/KDfv6FT/zMuAG?=
 =?us-ascii?Q?rt2cx27MgajO3l0vbs2OvXO/xkPEB7XkJe9nihfWrBRYGcMZLQxmfmkIDQZ1?=
 =?us-ascii?Q?6LhIcmYuksL1xt5fepBtbxY5cUmYEoavXKMuvss6MsyCurAYRiwW3bKvyPOY?=
 =?us-ascii?Q?SZ3/ViXQRH8TeRPwURQJJNE6Bov9ult/TTafbxOqFitrG1bnmL41Wg1F3sPi?=
 =?us-ascii?Q?Dk+biZXSZ1NcwKQH+j7Cg+fu+FYecHoiN1cG0oSbmkYAo372JbsGmUlm5Sm4?=
 =?us-ascii?Q?fMjChgnTyVqskTErz/sMXEQxOPzwTULcUOfzvS6dT2SEBcFJX67MrqS7Vycp?=
 =?us-ascii?Q?p+7BO9/Mz7J8RoX4zzXL0UM3IAtKUSzUhazmkDhbgBT7PcuDmfigRta+w/Od?=
 =?us-ascii?Q?dctlNuTGpRypC2aG71M3qi5+GHPhGkcfbZc+tJU5Jz/a8S2VZGBzRBxzH8oq?=
 =?us-ascii?Q?BGP+0BfpnzGyW7r5Nl5n00h6thZVQbqc9YriiGh1fAgxHibjH/bdOlca3BVl?=
 =?us-ascii?Q?p1WsC8yiLYwyYyc64A13WBtVJDMOba88g9aUh9MDiHW57cphiP9ApSXqvNpB?=
 =?us-ascii?Q?7sG5tuw25cyYmSrJasK67k/Te85g3jCG3E3J6wjTRfPhYRrqf5kj+puGbPKn?=
 =?us-ascii?Q?EzlSsMseTLZdcf8qRpVhR7Bc1bmAmlnCh8B70YkCvVSNS8IFC2e2AOxebp5x?=
 =?us-ascii?Q?dzK9CNJiu7IQdNjl6gdMSygQ6kibcnFTm2KgpvhjMcunwgStJpE1bFysER4P?=
 =?us-ascii?Q?hAujWVaRLLpDVygcMGzE17y86t/QPMVhy2womyO9sSDsXq15zhKUM6fTA1GY?=
 =?us-ascii?Q?ncX0kbD+uCAPTuIGchfeAP+cMnN6kXga?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?htT2lnZhmPR4nEsueeRcvdFIT/VffYRRwkkF9Oy5pPxO35hRok3AgbIqcuTH?=
 =?us-ascii?Q?1eyOi8tUXhNOtczhEi4t0NDnbipX++41J22kEtn7KV5zpySc8gagF6sXKHZG?=
 =?us-ascii?Q?kJJfEqhmO1X0i5i38Zk1f3N6c7v4DwunC67+4WOXchjNSHF9I5rmbGOz1Eof?=
 =?us-ascii?Q?hvtB01sg81JZrTuSOiTld68Ga/6D5r+iPqiHbSxWN0dqm3HP0yU3ab88TNcj?=
 =?us-ascii?Q?9+pKYBdSGdTEUxzRXVoe5Oo/Xpk1ux6rPyT8i6qKigRomsYxnI88/IoDtkwo?=
 =?us-ascii?Q?ufvzBELQbAPCEt8kCYBHRzWMlOD8EF8l4vx6pJgxayGs/F/yWtlhwV7sxUWW?=
 =?us-ascii?Q?hYkyj7DEJ/GRW5tPntQ1E+7efDAYNz1oInaHTKE+NckAUII66tLYcWv/eY6/?=
 =?us-ascii?Q?ZVOJtEiDvTQljdjTKwx7fuU4xSiNMXA5jk+E37ArkdqDBgIiIEm6xljaGDfk?=
 =?us-ascii?Q?CvX0KbvQIyPs83DBIEgsgO5a2Tki+OZ15qtQna0cWZ1esBKQ4iqc8gtZrb8f?=
 =?us-ascii?Q?0mZUqz6l9XVi7VMY1RL+rfKpUEM5AFerQQMek1vYiKueJGWXppcLMpgZaFur?=
 =?us-ascii?Q?FBc515ZllH+L4XDwCO558eb1iX5ttP7uL6QE8HPI89H65yPKuBMNTmWpdGG6?=
 =?us-ascii?Q?R+BKLRafOKQA4Me7CtWfN91a428ezFIdYUqyQuzWDwP1hCbB9G1Yi6+QkCMz?=
 =?us-ascii?Q?qYVoJtIXWkj0TpauBcfqgLPpBGA798Ere1dFPWV9LU0znfTkOubtmIkC/HOd?=
 =?us-ascii?Q?JKbXhHehJLyBlBjXqqGJQiLeH5f2EQ7IfPoyP7w+2X/ybTtLHbj4ZFGZEckX?=
 =?us-ascii?Q?lFgjgGKyz6ZlcwtDyFDbrdJQHPL5LmBzphveA8oNF/nP6A/IhAoW6I2vrxZM?=
 =?us-ascii?Q?zCb1gUy6OsCvMQ3HQ2Vw6BtwMhUocXuDDUZKzpWxD/MpyreoUbu0g+H3/WQO?=
 =?us-ascii?Q?kWw/IwJhNVLhoA0Ym4f9BrZy71W0FmsFfuIQkg7MGJA4cNOUyBpu3YOrmPcF?=
 =?us-ascii?Q?4Iwwec8I4X8XMFkv9+yRlp/qFAXcupPbBCB/BvHeWApyvwY8ZCRbX0Qs1Amf?=
 =?us-ascii?Q?EmxMNxT9jluuO0CjN+X00cHT8fXAQOem5PujLLAMdawSdYX6r2U5giJ5A7E0?=
 =?us-ascii?Q?Wj5tyyABEGaLgoMFymCC9T07ciN42hxKR4rACLb2wesrQPe4UtkDbOHsRR6W?=
 =?us-ascii?Q?03EKD2iqTjUlN5MPIN9fNQZ5YfDUrbYf5T4GLBc/Qd+fcJCkdijUv64eTfxV?=
 =?us-ascii?Q?uxrypac0L7ZOx6aJNjqHutoKexoUaKXVMqG+p9NfiQPiGpvWEP9bDu16Khkw?=
 =?us-ascii?Q?mpekz3NfC7R3KRoYc1hhFzqsLAENd5xLAwUrvxkVI09XZXKIMcC7E2dFYbn8?=
 =?us-ascii?Q?miDlI/9gQeyj0hTScXTkGU6Bzq9pySikYKn/5N+rBgS6TNu6cJUcLOvZAjA3?=
 =?us-ascii?Q?59k/Keln1H3R5VWgmIkTqQGy6RpCYdwsirTELfVJJo2undkNvrXNyOWxZ29P?=
 =?us-ascii?Q?EYm/xzXCkbuImpgJ2niMVBqPcUu41OHKUF+Be8+ofS22gHPW+XHCuSjdrJfO?=
 =?us-ascii?Q?Wx/PuN4SKHeXG9KF0jJg4/WYvrwOUyPktEAOueBpjqkjX55ttzV8EvbY+tqw?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/uGQt33v71EJzE2YWgwINRymm3lXPYauehAz/DJ3Cx+4yUalIXO9+QVIrGGKARi2gJ9XjAkWhU5CuD8K0NNyqnx4TvcyB7sS2AgDmbl+95Ue4K+RJ1qMpZT5HW1u61Yj82HxsjDqtUr1SGxrbsfch3ssC1WGLbFIMUaMPNXeWw1SSeSfQJvX66PzQEBtufgYB2cURuiwcFMnllcXYOCdtctw59xu+sbjqvxMavk1iua+YZ6BNAfGOuSRRgtMdAwPjVWNWNAEJeL/sPv+b1tPWdful7PXOxgn5i+8YD7AzABnM6u1U0mFOuxomehV8r8XV1el4T6pIygtvHY0CJ6Pn6ZuMi5mMH411MGq7Anq8dQSQoEkFQPKcxLP0KEBbxeymq3fqn4RyN77S49xl6D0Si9kCH/Htd7ELcbdsLANh85glqCF3CMDh1ctKnpmMCR0ZVOj70hEsAeh7SY2c6in+yr4ycsXc9qq4htfF/cukmV9wz11LLPd5I2/dySxCoTqhdoV2/91Dleh4dZzqJVT8hgi3/hHqWXGZLE+7OB/55X5fUz4uMXpk0lfrS9KNzxVoTK9khQlfacjTd4FFBLP+D0sQLuLWuDpvDSmfsklhVU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddc210d-08b5-4fd6-52d4-08de389d06cd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 10:07:00.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L53jPDojqbnmItShagxLnX8XdihRURBfTRZ/EqDctcjU3Cc3wPlrVGu3Bg1tmY3ZmQZk+tCiZIM4bwvwxRChPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_03,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512110076
X-Authority-Analysis: v=2.4 cv=Raudyltv c=1 sm=1 tr=0 ts=693a97c9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=P29RMoVk4Xi31U_lJMAA:9
X-Proofpoint-GUID: UHv6xtQuPdHgfMvT_cmLzHqd1aMJ0G-J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjExMDA3NyBTYWx0ZWRfX78WQD7jFlwfe
 hMccr3QWyKIj7vuD8VgU0fop/Cpx8n6fRseD2E4jfJVRDC5QG6rszNOytbgCVZLk4PQa34Qj3rF
 L7IaHZx17dCb1qzQon+oHk2MzhozodDWB0B/mhrWtfFfDG5uPA/reDOptBl0d6SLY9kc2HHdrDG
 WfW+w9ulBBfQoH4N9aostsfZOjdPSn+oYEOLC0RJnk6vUitIQ996wN3Kz1E+fTkayzCe3kirREk
 1XUQg2bOPZVMsumsb9BRxLuXYSUCFs5K670qht4nIfyY4v1qesf1S52Dj3LmnTJR2HbI9bbS62N
 5CJTfMveWN1+NXKkxpqyLYA1meqWvCnyi6UHDcIQDLpl159M+g3R5Ib5z4uHfM30rOrfazTaXDm
 vYrrcOSfMMQJ0NK6s+yLJX5Z3XK9kA==
X-Proofpoint-ORIG-GUID: UHv6xtQuPdHgfMvT_cmLzHqd1aMJ0G-J

The atomic write enable module param is "atomic_wr", and not
"atomic_write", so fix the module param description.

Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b2ab97be5db3d..047d56d23beab 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7410,7 +7410,7 @@ MODULE_PARM_DESC(lbprz,
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
-MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
+MODULE_PARM_DESC(atomic_wr, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
-- 
2.43.5

