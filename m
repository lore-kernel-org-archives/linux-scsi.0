Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25DA185E
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 01:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714008644; cv=fail; b=uVSc2co4mMQ7hkxVVtQM0VTeI+TOl7TIBNM8SWnQegtjrVebNsBWvWO//JomjfSwy6K6RzxAQDu4qEgxGr+KJ78FOl6bvXMgenDHOjHdvtPrYVRjot/Sa6i5rE9e9boyBM4h0mvE5Jt9A/b30wTPrnTuPJ2+CBOuFKF5BdRoXxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714008644; c=relaxed/simple;
	bh=0/Km2EqiQPyMtjcvzEH6lFiqT6LeVlgShiIth+9d4d4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KcsGlRaeGFXq6IdYHnP12PkdwUhTE5usqwbSrGuCAiyZ7drefYLUR3tvdPoU6NCrEfykqDbU2S08FA3Vfi94k2wraVtni4+eHQlFMMsZPYxjIYRd5X+kSmKAW3dihlRguuFv+BphqVhWXcC32pbyblBTCrTuP/I+x7QzGcLk86A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IrLrBDuP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nPZeh4ci; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IrLrBDuP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nPZeh4ci"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0l4Yj002686;
	Thu, 25 Apr 2024 01:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=U/Uu32uttpwUxJZ9XJUSP5Pzh5OH6A2iCz5RBap9Y80=;
 b=IrLrBDuPISPHYUbyW/nCTuzXpM3xFcdw3npqnKh/sNm320pkFG+Uss+FKxfmQ1KBcq90
 PpXa6OVRC1JeQxyYnsSpUk3TmGKceVIgJhylLebTfrU7rL7jKJODl+cTqyqVYgiLybLM
 OoYIchngEPnaBOyfKZQMIr2xOgGkLp1WomBW3NYQ4nG7Q9F5MbdMGcn14g505mDnZ2a7
 61Ug3SIgRr6l87+EsirdXyHuy3HoyqrWkp12HHV4+z3o0BH5W0hsUuAjecPONng0Hu4e
 6+CA8biC8IjujJ9gQ0Yra/Feo4HSrhyza4P7l/QCa8wvOcjUD9gzwjPUyjLJPdJsarxm og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm5kbt28w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:30:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43P03Cmp019824;
	Thu, 25 Apr 2024 01:30:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xpbf5nbff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:30:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rj5a6hQud2KdvJGfgOkJDVb/svXayr3Qxq40HsJD5V9nSZUZOo1+CfidPDTNBxDijoYUk7SXHzNZPxCHxTOJrIXp3kGUHNXF2p6vEoiR8j9BCIC9erGwyvZgCi8CHgdbwO9QOxJCgd91biUTjvunr3qpZexaWFIrHNhxpT9Hju7BeiBtHIjflPkvhjxjC/yR+Pbgf5ERrATxOtAAFB+v6S64lR1Ir1S54ZEHS6+Kj7esSWp2r7TPgWFd/eKW37tnyf+ZOlcMiqjdOe3J4kr/W3Volcwdx7bQWKKzMpx7VETYSKJPKyLua9ZGYpOT/1389wmHPPwh4R7HjRlP0cQ4mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/Uu32uttpwUxJZ9XJUSP5Pzh5OH6A2iCz5RBap9Y80=;
 b=JnUk/X5dWCfty+WpVnQqTnlXgolfo+PcqbToUkfIG6UiSu2WgxhkvltUIewrMV7HyVHiLUIqEMX1qOb7c94bS+QZkmLF7PIHnfFlOAjC3Pss/T/EZGHBCQozJYPabnOPNek0rTAiHC0XefpYF9LYCl0q2c4TkR2K0Kj5vBPs6Bby6+Fnh/zlQNmDVXf8MP4WkMWHSPVrEJ8lede6Vk7yYwxuZOc/yI/ERYkrMNCkldoJM2KaVXUI4icRB2mtwQ1YHFSGn2Tf576bXI2VmLS4721ngpGZ1JTLDarN/+E7iirJK+xxzXFq9j+lItYNRSxOfWjINv7/5OBnr8zeANvgxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/Uu32uttpwUxJZ9XJUSP5Pzh5OH6A2iCz5RBap9Y80=;
 b=nPZeh4ciBUKRix3NSm24ANSLOzZ0mFaqGGVoRAoM4UXl99nK2eTUFmm1PA+3RTmX3113R8AjMoNFDoF/tVUeXt3gkkFyVzVNwAALS5xc/8YLpoVgiUFswMq1bfXlB9Snu8F4Pn5DWhquZTOKUBmdFaOSOxG8RqIDFR1oZKwXZtc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB6584.namprd10.prod.outlook.com (2603:10b6:303:226::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 01:30:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7472.045; Thu, 25 Apr 2024
 01:30:26 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: ufs: scsi_bsg_ufs.h: fix all kernel-doc warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240424055316.1384-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Tue, 23 Apr 2024 22:53:16 -0700")
Organization: Oracle Corporation
Message-ID: <yq1plue6xg5.fsf@ca-mkp.ca.oracle.com>
References: <20240424055316.1384-1-rdunlap@infradead.org>
Date: Wed, 24 Apr 2024 21:30:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0116.namprd07.prod.outlook.com
 (2603:10b6:510:4::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 4836f308-994a-45aa-0323-08dc64c7490c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?jhPqlJ8mGRAjG3DxfAihQ5xiLwdKXfpdUm8N4sv8LbzHt2gkXiYUuU8sY1mD?=
 =?us-ascii?Q?xh2M536WYzf1IcBTBQ3Q0rYHxzYcOeFxHw0JUlvWIyfCdypZq7JmLr3tNbnG?=
 =?us-ascii?Q?XNSef/iKPne/BkwgVpMmwOf2KL04KlyU43+DnWgMIa/TtkWRhhFXkeir5x2s?=
 =?us-ascii?Q?MJoXVj7U4eqDf0yT3/a+kN8+bqvhaafY7Rk7eTaSsAxsYFlLG+ArDAfbEqfa?=
 =?us-ascii?Q?nNSGQhKQ35wJZGCChB3dKaGXTYOFWTTmS/u+uUmb1Wy4mmefOojfZjN0skso?=
 =?us-ascii?Q?eH5T0mDLfndMGCNnilIYF2JGbypcwSS/fp2KikbwZv1gqkCvQxmxnrAQUCoe?=
 =?us-ascii?Q?h3spBsC9awzn7tBreRb7sGWXEDQ4VvGYkGQEG9pqkBLh+tv27Pfz/CItopQq?=
 =?us-ascii?Q?vXxnxkZe9kV/XSb0mbdOx7FUCdBqVloDfT1GQZyhYDKYkiH213R14uTEKbdM?=
 =?us-ascii?Q?nwudKVCtmhkz5LLDWGv+pFTZU8d3B3Si6u43Mh2wdLGqmdwzEzELujx3DlvY?=
 =?us-ascii?Q?RjbsB0zg4b4YqI6vXMO+Wmb8jFEKi7sZo0mGXWemea/oEC36TmwIQfP2UdU8?=
 =?us-ascii?Q?YyapRJbOjTv16suZlgjB22lxyTjEMolGSONN59Npn3Ey3MPMHXFodmbT7ld7?=
 =?us-ascii?Q?M7DqBr2jxDq+0gqh7ahjxWt6SFYhh/aCqIUUxYSENFg35+rXrOULBoSuCFi7?=
 =?us-ascii?Q?ICS4nUVfXAJC4VUQa8tUNTvjjBemNtyxUKd8g2Z5rn8xyvNkQm6jHmDiveQv?=
 =?us-ascii?Q?M5ICIgyfm716WjKvk0aCesz+T4kZFZO11zWrw5b4x6XR19wauP1HH3ZGtJzj?=
 =?us-ascii?Q?7E+8ntVA5x4HaECLsIQLlP5AqJMPzfrX/jPh7qu0pfhaP8ZyhdYp5OzHEQ57?=
 =?us-ascii?Q?ZIpHoo6x9HcWM/014scJemjkK0mzXU9U+LcH99NuWH1tV4pxtB5pakUxRrEP?=
 =?us-ascii?Q?QJSgGUF9hVBM4Hp58QApgkYHisD8ckD/6rRkEY89uisCPzEmsqoTymot8w0K?=
 =?us-ascii?Q?+UMPQd1SFXWlWzWGAcD9fpN5/SuNcqpjxDVnLO+mZKrw8+z5ba6rMvVLAqG4?=
 =?us-ascii?Q?UD6I3aUuLtN8iGWe0cevwgrBt615QHIA8ZZ/ia39bO9yJUFbJTYT2BMmdaYf?=
 =?us-ascii?Q?X42Hgmfa7iBiYFNtQhY+kg/mqwrMq/hc8iocjepPa0jw+ibHUS62amJQ4qTt?=
 =?us-ascii?Q?6ihnK+5iSy++hc33orH1gvd3He0LShdufL4U9A+ko8WzX2oCsCcqXnYitdF0?=
 =?us-ascii?Q?GZmkNDAQRIb2intcVbZKIYiba6WwTXerndFH9RT5xg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?16HTk7C04Li1AMpfikj3n3i9GMhQSBeU/G08ys8Fe2S3ygbTMQB4N4t1Tj6Y?=
 =?us-ascii?Q?PhZvDdsvlfnCgpS52RCj2MD7rQSTiV4WnORIrB8VyrJ4GVCU3SVsq6zIL5fl?=
 =?us-ascii?Q?yazLJFJEZICljnCEDEXMcrlwGeZO+Xxh6+9YSQ03bPagfJPW+XxWfJNrVXNp?=
 =?us-ascii?Q?2fSPbAc2DAi74RpCf16FEJlMynLc8JjGMfL1tKwiifKiH/I5SmWry1B5mklT?=
 =?us-ascii?Q?V4/Acs9fBXl7fhGnr6A59/m+hCR+reMjXBrPoeD8xsmQZc9wqmqhw2Dh0Bre?=
 =?us-ascii?Q?kF4j5l7Vn10r4sLNKsMMmNGjPYWnnRWVphH1m90XFG5OOBpwaE24o5g1O69S?=
 =?us-ascii?Q?gQ2W7U0kTkl62XlELjbAdAicHM0emZkUDtgTffdoKo+2glG/pG20qmHhRT3m?=
 =?us-ascii?Q?xIz6sEKAuo6/ZyCpVX28XTugeZlC3u2ajuMWik8oaQEbQywaa05L6Eo4B1E4?=
 =?us-ascii?Q?zUiKY37x6cAGcuzAAWU5bgQizeoxutCOwQWPQTQ/KI/JhM15zPLl1NBpfvby?=
 =?us-ascii?Q?GZAkW3VBDDQzbLyADFuL/VQussKaf8cyEc+icX1qqWG0fY1dP+xJ0lGyaNpz?=
 =?us-ascii?Q?TYBzHSsDjBZsJyx4f2ssF6ek9Wkbl8SEl8Qeqpfp5G7eIZdf3UALSbAXU+f9?=
 =?us-ascii?Q?qQLDjjNzA/q4sghbRn1EwIOAggv+kqMFuBGvCrcYqN5ArGdPnkEtcsfRDrWT?=
 =?us-ascii?Q?UID8u2Bs6TWE0cjSF23J3VzLRBbdHocFp93utLJEpwyTGkQMy443vqGLoq64?=
 =?us-ascii?Q?vNNKYNCyYELO5x4o9UToBt5umPLbs80YTxvgTzgk9nPpev3/r4wMFq4aw/LS?=
 =?us-ascii?Q?7kh01ZMCyxMayHAFu+Uyyp9vpszXgVxskbdx+FxyMnD3ySv0elM6M80h6diw?=
 =?us-ascii?Q?lc/3BYUU+f+9W0TRZkl0e2sHmN1fvqTg5dPWNpeGJxc0VedeofUswZtTt+Sx?=
 =?us-ascii?Q?3M0G6qBqrzi9o+4A+njBFcnyiMdRuTFZlcw9OVeVsJw/IZ58KXRM+gyQt/wr?=
 =?us-ascii?Q?pHVGmcjQbx5ytRKUtVYHIHV4vuboI+vGyAbHbCxBEFDFo+6f7HGvK/ZqtyLI?=
 =?us-ascii?Q?5VDtHQJ4GJ7v7FILGp6aRje0gZ2eG7+HH0zrQFk4Vtnph0h41p5/Jxww3v1V?=
 =?us-ascii?Q?GeuV6TGNq56W2zfzhaWYkhGpkjI3NAxotSsFZcmzBamXktg2WouzgQu+riNL?=
 =?us-ascii?Q?uzWaxm0fNDT1tGjLfPoXb6VVDV5CQCAVQ7U+yA45xgoDd3ZQnyjkb6Yg1FCO?=
 =?us-ascii?Q?8NaqLdl/l5cd2Z3noAdUd4lajKzdaWDAd7HySfK5QHe3rHARrcONjx/urkDE?=
 =?us-ascii?Q?2aaWX8JS+aIu824vO6iaP0N1Rgxl3zCkYivIA8AK3pgLp9ra4WI31TTo7lPv?=
 =?us-ascii?Q?pj0hzBqYtpcxkViDnHtXihA2Mw6IqzYj+Zpt/gxJ+SV36G81coSWCUSUa1fr?=
 =?us-ascii?Q?oUq7pk6KYHzkzWsn5HmZQUq/LY+6RCI7EYPEd0ZHrHHCIIYzi4QUDC/s9D/w?=
 =?us-ascii?Q?2ruJOCj1agDSpzfworH4u3yXyqzeO+cvjQNm9tjdeXW+TZREHO4qRI05etJo?=
 =?us-ascii?Q?rKtbT6g51J5/JAw26n8cXIczh5HD9FSXMNqaWhz3vXokBh8Zn9ERw5rLS3Ah?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6qcFirfLjqWVRRGPSohsyBJ5M4ojQa9DZkDHJWxRU9ScxFSIJSZQ/7i1JF9r9rNKjp2+u9McK9y2BQEbDaP2Nao2Evf+YvD7yASdY5SRDkC8PKABp5bCq1nY4XOZkEY45yGqafmCUss4jvksOFTJaypP6yBpF8NQqKT6XX7DG/oqrGCZb9DDZcrT5m9OAunnedVWwwpU9Ym2/C8gzK3zg6/QgQqu/ehCS2z//GPVj/RPqdfNLyGHFTVQiIUSPM/drZ6Pbyu1t5wSXdgfUaPe1viQk7WHQVaqtwzGWmPkclXc6iEPjbbSGS632ybXiWOE/Ew+2J2pxrIwK7pcRw5AA8ad6uu09DBqpD6YrxEB29mDMqpGP7YJ2I7PVjHKe62j9Ns3ZicCXQ1xucTJq0dC56eE4/lOG0U3PAX3MmXYN0fLJw0/YlzhMvfGmic/mGNXYpgaICUo/CBQLS+Rp+zHZ6sy3CyKwcC65KsCH4bqL5ubTudvuZIrOGm+dJ+M5FHIKnlEegUjisHkcLN2uR12C3onKa5tSu7W02pdW0xclZj5bCk4g2C+881vZF72KLeKRDc47jXCUWTRTEWtPE9g3QfTkQn0Bfbp00uC4o7VkcY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4836f308-994a-45aa-0323-08dc64c7490c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 01:30:26.8064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZ97CUVBIVi8bMNApyi5eeYAyA6bhepJqk3sApzjxYKBO6lx2dXitgSdeiGgdleec6JyGmyOlr9MB35rGFIZtr3OmxkF6SLGRPfSViq20Dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6584
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_21,2024-04-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=942
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404250009
X-Proofpoint-GUID: vM6GyWovHsr2a9Ix9y1vej11F2xOriXJ
X-Proofpoint-ORIG-GUID: vM6GyWovHsr2a9Ix9y1vej11F2xOriXJ


Randy,

> In struct utp_upiu_query_v4_0, add description for @osf3 and mark
> the @reserved field as private so that no description is needed for it.
>
> In struct utp_upiu_cmd, use the correct struct member name to
> eliminate a kernel-doc warning.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
