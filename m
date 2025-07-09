Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF94F1EA91
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 01:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752025462; cv=fail; b=Zws6OsqHbygEO84HJR3oxEinXIcSTjGVH4DQuc3HNdgLtC4RzfcNqbPJCmjYS6IVPQ9XzPrtXztRcnUFEw4Loj+XaQCHypMFOxB/yRzqRTeTcB7ti+Wl7WJVG1kpGo0NljGxdWcO9+wcuCT1PazInIOgj5DbrLxcYoILAAUu3XQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752025462; c=relaxed/simple;
	bh=gw9mmdgZERbglVHFLcsRTM/6SNFtGcc877P0fwqk+JM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mdvviZ9HvIC49VAviwzDSRsu0NHBqd0O6rXszCihqQtd7/9KhBbo53rRXt1V9X9PIf429edFV6cRttlHA/BndP3amkyICeM+xpyVcXn08V8R3hmd5656RCGXyaPttuMpQxsFU4JZneIx+r8YXyGr8w9o/PVrSwS+IN3Nh8eDJ7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DU4Xp0JH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iq4ccuVg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DU4Xp0JH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iq4ccuVg"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5691ZHKu001393;
	Wed, 9 Jul 2025 01:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PvV7GeILw/vf8ut2/w
	wrGKvKlmmKUxaP/Fz8j86Bsf0=; b=DU4Xp0JHbdSHGMUPepEJFqIPBoWlDQ7pX1
	cTTHxzljYQmfuC9HZLIwEqdthEQ/hWP87WwaU6zFpka9pa/pGQJX7jxuHKWSZr2r
	7EqGEc+daDIibaOym54tcqMS2O2sRfDZFE4V/z1HK4zJ2Y+6fXHKpFBNSptmoKIP
	Vq/4x7WnZVppRupmXcmRE7Y4hG4ZaZobC0MTxhYs6QsPFsBglyFcV4LxgecjS5aj
	hC+s1e4stlsHNAjxZpzpnAYyZKf+mhExBFL74Oz5sAYkteQZ6ZceFkwaUfUHuR/W
	7d3P2aVnSXveGQFkP4rs+xNDLBYkGbhsQUHl9Ov7qpbPboucS4oQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sedc019s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 01:44:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5691URgI014068;
	Wed, 9 Jul 2025 01:44:09 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgabwjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 01:44:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wcoBPMQGyfFJZzVTT449sAT14PIzYxJ/I5d/5HrgDB2cAN4K5PmAuBzUoCIYe5hSY2aJroa5VU+vLB6wj3xBoMAA0l2j3tNsCbBPdeqgCWcWs6VB4CAW57a74suV9sT8Zesl1j9CqvpBgKVpImrdSucjE+4pJ2Ja2vkg8i02YITQmAKItF422SWeagwXpDlzUDu6+3mBYTUpWYKdjKzDwPmj4Sny8uhTXNKOtzVKFaQOLIuhnAX+wEG3e1B9CmRVCIcurjnAatKvrJgF38Qahz3s7KMiBQ1Ea6q0fBS9UVpTO49fKAsbs29WnuuJCannWqAjwPP6A6WXe3rxILB8mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvV7GeILw/vf8ut2/wwrGKvKlmmKUxaP/Fz8j86Bsf0=;
 b=jZpytquZZNG9Xv2eeCQ1Oc4Fjv5YnhdkSXNVRjyYK2uK5tKVfYICtBEfx2F+KyyU1hYkCreLZD1xg7JRO73Dh100PoiFb/vnw6PHFMe/a8sPLRQrkJaUMuETOzt+ES36Upmu+XQ2+iWBo+0MHLV7iBW3d8rxbR5e3Udp8JQ5Pb7gWUa8WZbQJMol3VZadzURsuZu1EEoOXabC5SWLTyG8Q6SIfe/9zsmMY4b2gojkWPmqT+tnoNuHAPdlvuRhzG1xQ+CNn+DHKMbdstyXZvS9gHUUClT0rQivuguuR0OuXbJ/o3PGgjtKla9C4aszSjyyS/baWxxVSL/jjbqb/ovTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvV7GeILw/vf8ut2/wwrGKvKlmmKUxaP/Fz8j86Bsf0=;
 b=iq4ccuVgNNjReGlMQX++Fo3lACtwfALRHxw4jo16zhGTGVAyDKOuQTlrlVo2RnRsD/rzrgv8hIS45u9Jyd8Nlm8UxixyIqR2efjzjtBKjjZ+PV+1LOE1CkC+nQ5LUU4wzSruzvyLdcYN/cJ8mSWiRAm3n6huGCAbmAJktVViAHU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7832.namprd10.prod.outlook.com (2603:10b6:806:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 01:44:07 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 01:44:06 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: Improve return value documentation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250623215909.4169007-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 23 Jun 2025 14:59:01 -0700")
Organization: Oracle Corporation
Message-ID: <yq14ivmdtpt.fsf@ca-mkp.ca.oracle.com>
References: <20250623215909.4169007-1-bvanassche@acm.org>
Date: Tue, 08 Jul 2025 21:44:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: cd18ab26-7200-447f-eee2-08ddbe8a1793
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k8d7lOZtB0r+77qJW1IkSZCmUe+Db14iKHIEdrNmIDrir1abz3qbcEASy6Bq?=
 =?us-ascii?Q?9q/D1L2O5ynnUBka9FgpZKHWbnEEh1y0HcM4IliTZe1c7kaWQ4cfgaTNmpbi?=
 =?us-ascii?Q?+XY+vMtmq89/VyfGCNTXnJbvHrt5fTGoGMHhgn2ilkC15lpsbLMozYgJCLvf?=
 =?us-ascii?Q?5zHRaMAjp3hhb/ei9FsglukhJP6Edk/+TsEtMa8ZQeFOsZRvcShKFRGU5e+f?=
 =?us-ascii?Q?i43cccLrPzMeJcZVzX8ghN40auFdi0ZdvJbFN5g7wMeKhXsUeYC0yTuwCira?=
 =?us-ascii?Q?Kp5IY1P4MovwTFe3NnSxZgWl/i57rj2qvihDKAg+XBkzLcSATdc6bLbahM1p?=
 =?us-ascii?Q?Tw7bV3mWfpHgUoyBKpktv4Jt2IQLhNYrBANLAXsTbzI8CbAakGh7VnEPJ8fz?=
 =?us-ascii?Q?JzCVtpsABZCjCXSErgXclvFjoEJlHJB7cjEuOkO76Z/0at9rP7bH5kqkcGgW?=
 =?us-ascii?Q?T3yYewUTft+ImYDBARVbBOrovmetk8LYgzBue7+shhd47WGJrSint/nB0EwN?=
 =?us-ascii?Q?Ga99mJ9F+sw1HfzFDDDYvgigKIp+NFXhJZA4vcx5T7yPNnERBQrSGjyIiagJ?=
 =?us-ascii?Q?Gs81Eum6HN/6c8B0VWsQnEA90rDI/bIrR6aSpH5078kATO0WEcRDYSEzcUVS?=
 =?us-ascii?Q?CgW6hfs2z/N5tykcLiaE7980BfqW/NF1RKPhYT9Y96iOyiptqDKlX213noa7?=
 =?us-ascii?Q?KeuErfnP/TBXv7A8V0DsRpG8SXz+yVkVkQ9or+vtkXjjMQeS/9k2/gP+ugd4?=
 =?us-ascii?Q?bzFd3krWFs+qpAeXyDrfzrHwGN56wk0KG+QNhMFPveVsrEsaHnGjKMXcALXT?=
 =?us-ascii?Q?Vey4VeaR/IiEjQvHzx+H+yoi606+pxAEeJri2kkNcGxn27tZPSkdKhzNWgOx?=
 =?us-ascii?Q?ZsdmMUxdsnQcR5qNFM3ywRRwoZhadv9o0q2lfkwdHH5jKye0KYYLZ8lGfG1R?=
 =?us-ascii?Q?6N0trVQD2N2n9L1FyV53QDaJERhlBHu1FGvpv6CqOlh91F/6b2M7fsXzekKD?=
 =?us-ascii?Q?TajA5l6jWqBUi21SKh0Op3RRzEgpr+6xgZiMLKP4sNfbdBw39AWTItvStYwb?=
 =?us-ascii?Q?m+KlJSA/ejXojt+YTsVpjeboNPb80WTYMthaZgPcjBQ699hdihBa8YyC8ikU?=
 =?us-ascii?Q?mlGaqCi1QAcAlI51g1eaikZihx4popEcqZ/6bCkoCCbey1XXUDiPI6bnGOuE?=
 =?us-ascii?Q?OwKXLKBW7Bnz6OLUKYhQLBeSvSHh98phLTd5RZipl5/x4fOxNzxkFiS1mmfP?=
 =?us-ascii?Q?W/BSpCGHHvEs2vktJK8XOy76He3YuV2+xKPjONHjzQHw6b0vxi3wpw3UB6Sz?=
 =?us-ascii?Q?NmrzowZBgluaO9ENTl6neGrO3uwxx8xY5CiWrW/K43+PNH+jI2xlUNjj81BQ?=
 =?us-ascii?Q?thI+kqrx5sgRWHYDcyuDUDdSXFBnnMlxios3zdZxkwV40WNnGRr0OQso+Pz5?=
 =?us-ascii?Q?FSQx7P0W+wM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RSZE0rQpIHEVvzeNmKQiCKkl8s0QWlMS89sLf0bYkZfJlFWBZ3igxp/6q4PQ?=
 =?us-ascii?Q?BvnmPSOfG6aQxH0jcegW0kJuP1LAD90MeTM3N3FLVwcb4meVk+isNiReKPOS?=
 =?us-ascii?Q?RckkKGwSuuZ2d5TnDq6oXqR5s0VTbk7JeLJUTROYXfFrnlqFiPyQSXg1UeAf?=
 =?us-ascii?Q?53LQ9OeAf45PwISmbIsko5AurJwPz0s++53sAk7NSsqL1q+E8d9lMivcFH+6?=
 =?us-ascii?Q?rxIB0A2BnPYFSQpJdCRJj6Pmw5NeYYr+yklB1YU1yuRYiPUvVDq5J+OOBf/R?=
 =?us-ascii?Q?2sgus2bQVIsrBjcgY/dBGNJwRtmI5yTW5iSh4xsS2CSXBzVzocHC1Rub3LnX?=
 =?us-ascii?Q?liJ3xy/f5ltop//hJCHNSIgbiQ4zMpRnbJmBEmod7aqWHk1GCm9IK71zdfv0?=
 =?us-ascii?Q?0OqpMOovrgh9oBOit8AKVRR4vl1zQFCQYC2ojLPknXgsauu9wBpEObj8RTL3?=
 =?us-ascii?Q?DjCuyhNsFFzt7hPSPnSVC6xFJnTI4uM0iQNrrfutkZfLEdEAAUaHIvowKs7W?=
 =?us-ascii?Q?M4w+GW6jeyHKwquDI2aU7gt0z232PZonMl6K4GbXdhXg/uC/qZh6ZE9Ndiqr?=
 =?us-ascii?Q?Xe5Dfp1dHef6ON8aKHuh1mjKQ3z/muJsMcM2E4/hWLPo94DINIPhP2mHwWSg?=
 =?us-ascii?Q?i5ps55OD0bZrxCTaaTXaCHD0zSPQ5zt/b/4b6KNYXrIQ3iWu0H/oQE9p0Dca?=
 =?us-ascii?Q?zskXGBnyZceFShgn78ssZp93brPRNyG92cXhv9wMCiz5fBR2HKJbEZoARUAK?=
 =?us-ascii?Q?5NJd6lx9C3GxCXdZ6+2V/mv6h+DAnoWGvvPKdq4cx1Oqe21w7KgCIDmESSTU?=
 =?us-ascii?Q?X5AkqAKM5LqU9URS/ukp+WyJZ7Ju3XykPLtcKgAgBN/gMfWtUyqOcNYs1fIQ?=
 =?us-ascii?Q?HxpjU5jSdO7dS8WZte2KFDRxgKgVB+O1lUTRwfNUZHSKAJau4wGKEePDXCl4?=
 =?us-ascii?Q?bKE7Gr6gkie9q3QF1dWZN03vaBWvUpdKVQY+kCIiCLIKo4L+1sOoMpTtWzGK?=
 =?us-ascii?Q?2j43GigdAszh8YgAVWZcuWHi71zyNhaoJrFDzp/wKNfmWupp1m3555PV84Cc?=
 =?us-ascii?Q?zZbnXP8ZCemZgh1FdWtOCt2w9gQSnyDlL+9NFZqBiAsUvjKh0wyzV8wXCvM0?=
 =?us-ascii?Q?ML+W2+AG0K2f3jKcJAhdwGRvMvOHTQSwuQQkGsuS2ViTMJVaevjSbZhD/izq?=
 =?us-ascii?Q?33XgZHzev681suzUU3pCDcufsBVYXIfTMzC6n/UciLx7ZzRY0no69DW/k/dB?=
 =?us-ascii?Q?rZ1I3FdqCoFxpJu6t4Z4fchUMo7HdRSzR5uo5XFjUlgs585RCAPVDqrSGzlq?=
 =?us-ascii?Q?xFwsxYYb24vRAk+t4n2QpfaqJf25fHC7YXTyS/9e2ZTPcjRSEaegTpNgFUQQ?=
 =?us-ascii?Q?T9sr0TShwEs4nit3sEZx1ZBSubW67/Dd2KhCYx8CjY84Vro2v7+m8U9Yj8Yx?=
 =?us-ascii?Q?A3ar+jLh0FZynxkEUcZFHwbeN6YcVuVl0IV9EaxEV2x+o36Ludrc9sfM+HYD?=
 =?us-ascii?Q?0+1gwtcqr8zPu2Kf1xklT9FF+Zi7C099XOoVAFTOA+G8O3kFnW+LsXBkibD3?=
 =?us-ascii?Q?CMPrwVePvwR1MD6/n9VW0HV1P6L96itbAX3S2qqE8ndN+z9uCMkisgIgfHg4?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R4ZCBjEuOzykFHJBnIoiZRBfxBw2KXfQE1dyoH1SUzqBW7kmb8A5qpGdNkdBJolFohBcbMTZtge64Fi7gcy/kqZLhRpvkmvX5Y9Ms7TytseyZTIhpMDi9drgfkQWTsKQlqYK4xT70pndbQn8SJwJ6AW0Fn64U78nXu8hl7XYCa+64W/Ca1kGYXHe6LaiBnKAdIFFV86McZGcTvWJtsP0MREh6KgmoMiflYbrtqA50R7czZq5hc9J5aDcDSIxfDht4ALkH+yFwGEjBMQ+Ahi4Kf2g69uEn10JmSB+0HxYqEk3TNrLtXRVnpCWX5mnTYLnd1Pl7MS2AwqSTjgtJExokGGzVxktlEhldpxKSjIuT9kWVpCx6jUnEH+CjZWjmoVWb43frlxLIOHl1YK0/uYydwNFoWZfK6ryuca6oZrJ4jY9lZMVEHVUPyCEavv88kTAQnG2I10uEGFOSL3WnxVL2SSoe8UZh6dnJu0rN8AJjLwgW3rjudtPIL24tCNyD/geKOZxD2tReos1vwECOQs16L1g8cpBwxbYePMrJ+8stmenmCvWkmPu6vHVwPX/QyAJ8thrynKwx+f1tWtFRz1W6ixqLPFMhzH12DPY2HMJtnw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd18ab26-7200-447f-eee2-08ddbe8a1793
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 01:44:06.8081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXxOu34WJBgcf4m+8k/GudErBNS+RFkyxKAWb19+BMrg9IFFA3aY6RtEaV+pmCjhboNDkcyHYtYzLGS82EfNe4dVfPFR96+zwtuWl6E8Qpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_01,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=701 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507090014
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDAxNCBTYWx0ZWRfX2sgE60gXojP6 3AG5IB5QRndOfDBOXe1mkWTgxJKlDGfhHqEwbSZyzmakScgUZhL0ngwLZXbDhKdyzkVR29i29kJ +himUF9U9AEnFFHjnh2WtdNKQLdG7NTtXdKvpiylOdMBjAuIY23Yjk7DD0tSjyl8GhM1KcOcCCv
 GAgnMn4rNvVcFoESM+nfuFOjSoSj8euiiarRZeHg/JsupazCSQvvaHJF+bCaEGCaSe23cst3gay w5DBOA1dWAi/H8w1E97j/voL9gqERHU+J74fxaBbvyIj8u3n8MO0Ytn7gTeTV/pp/dtBa/21Yqn UOJ05yXmlhKMAIwDbi+HQ3jdFuEngWSbemd/XJPShbMDw5j5kd1MGenluZCV+dbNZZjZZepcbB5
 k85LmDpvs+zd9E7U5mAGGgsaoldawHyM/CIMDpPiZ0UWxGVhmnX6ndsNf4XORP2qcRMaqOe0
X-Authority-Analysis: v=2.4 cv=NOnV+16g c=1 sm=1 tr=0 ts=686dc96a b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:12058
X-Proofpoint-ORIG-GUID: QghQ-akalOW85Zz4wMRj9yUm7kpwyYLU
X-Proofpoint-GUID: QghQ-akalOW85Zz4wMRj9yUm7kpwyYLU


Bart,

> Some functions return a negative value to indicate an error while
> other functions return a value != 0 to indicate an error. Document the
> return value behavior where this documentation is missing and fix the
> return value documentation where necessary. Add warnings to detect
> mismatches between documentation and implementation. This matters
> because several sysfs callback functions only work correctly if a
> negative value is returned upon error.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
