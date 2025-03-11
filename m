Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0176D1DF26B
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 02:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741659915; cv=fail; b=Bl4Mjjy/DJK+OiJ+5nJ8QVfiYxvcNNTwo+rgdKwr8HKFQGaEdexktU9rhvIwNaelJe2d8o+pLGiBHzcTn+liH/FoqqvYVqpZPjRcNNKnRYseelD2bWbCyZxSV55e9nZADW7fYX+xcH7R8rajKXJx1JhDM6+Z12KI4a5e8p9hMc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741659915; c=relaxed/simple;
	bh=CAideHTMSppcee50kuH0QTfWUMfruaUB7mUA0AieQac=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TUiGRAkTUOHjfHNBJdjA0iFOjbv/66+yDlF+fPu+geypDoMBJMorJJg+AEGhkcwHAJDGW9TPiT1Paw1hXxXNM6l+wxloYKXQOqYeYnRAIUcLXAe9J5YO1nQ1DkC/Yc0JW2niTfk3Vt7ZvadxyZGKynwTev8kmfrHAgzc3OeqwOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R9rFU0rr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UsOqHgT4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R9rFU0rr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UsOqHgT4"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52B1gKZo006664;
	Tue, 11 Mar 2025 02:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qozbRUHuVottW7mx/H
	gZVmgKfx2eMAabN6N1g0J1ZWU=; b=R9rFU0rr1zvNCV3+C5sTffizgeyNY5ozT+
	CTMuZQMDnFJ8HKLWh9IkzEPLD+dhxrv2fGSpdDZPZnze5+ELs6/X0Fmj9XFfGSZl
	ad8rHjibytv5pXXn2Egsp83MPC3twdA54g9ZeXyRWMvobVXyLxpOacpKxuU5Lu6M
	Umpy4odH/Jm8tDt3MCmq6mwAUfUHazfSiS58XQc2j2SqtXYvOtXP+ObY1i+v3vun
	jfmwnk7WOl0v2ph8ytTbsWXOTZ7dJnrHkLqpc1Yg/FAu/JkwGl+dAj33Jb96+fA5
	HqEtmcchbvwkwFipEMmZ4z1Aky0J3SvEDJ+S5evle4H+lV4Vc5Yw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458dxckxn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 02:25:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52ANQ6Vi028894;
	Tue, 11 Mar 2025 02:25:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458cb8dk2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 02:25:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJJ2K3A1EakLhwR6lSH0mS4G0hlY71BEYMVdJHzVp9WJu08L3A3sNo5j6FedBL8MkFLoEGCDatIJCmVYJvy0FH2tWkDYhEg315HtoeguIN8TX42021mSyVAn4PCRp+0LXj+AZGjNVZ9/SMH/8jOy9o08WDVNIAMEjm0vZ4GQ/kOVBZnyCCMEZiuKkOBtcm7GDMizTR8404M9m1wA9JTRY1LswX1GzhhNCfUmMSWPpcPdiyvuPxWLX3uPHXcp67QqqqsceJ37587g9+YxSUFLw4w6jfeEZ5MPo/f9W3yKMKJy74E9aJluJXmnwc0Jrs1f92pQYeZGPF4dYe04pRZXRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qozbRUHuVottW7mx/HgZVmgKfx2eMAabN6N1g0J1ZWU=;
 b=Ey2r6NqFtGHz855RsppAYAuYN2EeJM9H/k2ZhBzIeYp/P5FSvvo8AL9+I56iXGpeuJJJ4lO4bulZ0h/wxY7DgOMI+xb1essPkv32zSaJh0zmqjeFtAlja1EbEjhJOnbER3WngLirxk/of2y4+ue1BI8lrovHpgqWuMD0/kCelHxh0gY8ItW8sD2B3zDQGE3REoaK/L9/wJM8kwPPHs8YYrm5mziTSiz/bNrXw+93O7pwRtXG06La8uOMpmT5+S4gB+hHflRpvgXuZFk7X5yTO0Ag9G6OgF/gKBM7xhzKGpUwHs6/tBf1UQuP/bkNcKk7LlQRHO3HkP5DuS1Ijhp2yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qozbRUHuVottW7mx/HgZVmgKfx2eMAabN6N1g0J1ZWU=;
 b=UsOqHgT4S1kSRXTbu/cJC6s/TwDJ3I1wDQLeB/RVxHBYUgaXfwG34A9XBxb4ceB/u8aYY7r6iRUJbMQdgQrDgd62qjhur8n4qpkF8yb6QKfHBHhgFYSzC1Az6KeFlTMRkanOfF/Mtaf+RvxqeRliG+8JMfraBsauE5K2hC9CVxs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB7380.namprd10.prod.outlook.com (2603:10b6:930:97::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 02:24:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 02:24:55 +0000
To: Samy Lahfa <samy+kernel@lahfa.xyz>
Cc: vt@altlinux.org, chandrakanth.patil@broadcom.com,
        kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: megaraid_sas: multiple FALLOC_FL_ZERO_RANGE causes timeouts and
 resets on MegaRAID 9560-8i 4GB since 5.19
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250309135728.3140904-1-samy+kernel@lahfa.xyz> (Samy Lahfa's
	message of "Sun, 9 Mar 2025 14:55:31 +0100")
Organization: Oracle Corporation
Message-ID: <yq134fkpapb.fsf@ca-mkp.ca.oracle.com>
References: <20240216100844.aabjlexbwq6ggzs2@altlinux.org>
	<20250309135728.3140904-1-samy+kernel@lahfa.xyz>
Date: Mon, 10 Mar 2025 22:24:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0196.namprd13.prod.outlook.com
 (2603:10b6:208:2be::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB7380:EE_
X-MS-Office365-Filtering-Correlation-Id: c464de43-2c54-41dc-00f4-08dd6043e943
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MqschZms2pmI4Ufmj15xOtqCVBGz4nuqBYNV0RfJM25/+HvTJ89UR23WEwCc?=
 =?us-ascii?Q?LS/ATy9AHEQCVUDTPVt8mxD+PukIz95Wf6AZtvsDXtSZanOT5foy3UXwuoAA?=
 =?us-ascii?Q?99EG/9LGgVTs+Pd5VtzA0iIFNPPBpPcR6lQ/jQ2us789bz4fs5VyR3Zvac3J?=
 =?us-ascii?Q?sllWicGiRwvckO7GH2DNNgPYZ8afn2BcLyUAl7gZD4wft3KOq7lNoHjedxJ2?=
 =?us-ascii?Q?m/QM3wuxsDzCz/rs3i6RbzSdTAlkF9x5eZGEDhQl704908dmDI3uYbnof580?=
 =?us-ascii?Q?YIpn3QQD3UweKQVFSz2RP22hmPB6dgwI9AtpmPV/AVbQP12TUQU7ZpVwz3QH?=
 =?us-ascii?Q?+c8qLOp5JX4n5+7TCjG8GodCNZZq+M1TTVZOOWykabmkO15a1pI+YsToAPjA?=
 =?us-ascii?Q?LbkYBg4FMXs0yfBXBoWkQcOeOZj9VXRd9bHPlF0/SzAJ8xmJFHO+PSMTroIV?=
 =?us-ascii?Q?uoDaJs7bvUcu1VPoG5hTs8nNcSECFWjfSoleIxHEB2UfHjZLwOqwqghVKtwl?=
 =?us-ascii?Q?9/6IBwQn84PRWZK7MDIpzTrKoaKY2NSyVZUo8eg85sVK8D7Fm60zLwdD3DA9?=
 =?us-ascii?Q?FNOWZgxGGY2dmT4ll6tbW7iB+3pTiGZI+XoVn4BXV0tB9A/xMnOlnz5zUCGI?=
 =?us-ascii?Q?ZLzXYrHIvfetL6VLAJcV9xc/jAK3vB8dtdpMnEL1w6gbavUpQCfq2RLtRT2W?=
 =?us-ascii?Q?qXKzmCPj7RQUsvCzeLPWySCMV1Wv5Lcjmu79nb2sZU0dCSIqSGbn02BhQU7m?=
 =?us-ascii?Q?4fUQlj4AFCPtNxZIrlKXGoUrxJNdJ0ymkKHmy8ikomaHMJaiMNac79AiErIb?=
 =?us-ascii?Q?QbA9EXWJrjqJNQxGsIRPpEmoQj0RUaHoG9/9BAOd/qZCiESngY3SsSHYBReV?=
 =?us-ascii?Q?WSNg/tAZK4x3HP7Bn2vBFPlp7Hy1MkLjx6HLbPqDFQ9wNNPXwHsFY4q2lTHA?=
 =?us-ascii?Q?5DtnKN0Ogwx6I+/LdrLknCalXiNNlBox6q+xP1H5neaxR6IRwoN25BkiEcyR?=
 =?us-ascii?Q?5YYQPsyw3G+UVgS7dVx/zy49k4Dag6fT7xFujZNWdbBm6PjH7naI2G3G6kOy?=
 =?us-ascii?Q?APbrl/1/VxuIuumhxn/s0Mz6hdu4aP7r9kHFYVhxNCl0dypnQJ74o0APIshZ?=
 =?us-ascii?Q?M1g8oPD7Tz4mDClTYhwNDVY10f5yrDtOvm6NRjUM2lV2SlHwwNdpQTnbIX1Q?=
 =?us-ascii?Q?pGq150za4kACEDKlnLUZ0BqgAXNxkfjJAsbobzC4KBOfpFkUfkaGnX0yJzFy?=
 =?us-ascii?Q?xLIMsD99ajlZyVuynmjhllgHvlAwOsbLrsHf4+CgfLzAKnz9UwQOY/9OyGhf?=
 =?us-ascii?Q?WUk7vl/uBIAGRYjZT+g2prOxD9GDwyp8IMtJywM0hWvwrXMa2jmISfDSKBjg?=
 =?us-ascii?Q?t2K7KcefBgZt/eTgH0wZ7zzKH/I6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S3n8Tu+onu27Uv+qAu0P2Mg93TYOGME+lTHHYKmY2BEFNB4ZfQvmklB7UEW/?=
 =?us-ascii?Q?p4k1c6HmCMe13FJ/V75QGf3VVt04J1pV3sw/2uZaVnNccQp0kUg3DeYc2d+k?=
 =?us-ascii?Q?/5lLBC2RNaOsH18AddNtCYG308rLwk7zOO6oWtYS5pPkxmiB4Ii0P/VD/01n?=
 =?us-ascii?Q?kPrRqgaoegwii5BtR84O4F3wZa9AlhtnQVOQ2JbtaKImCu6KEh8FaR6D1wZ3?=
 =?us-ascii?Q?sw6hsIKI1IW6sRj8hkXwIlVKps3D9yzexeRA+nagR2X2EIyefRpqiCvQ0HXE?=
 =?us-ascii?Q?7M7RT8J1CAjgAFXDdZdXa2l3EHSqG04VhGDd/Rk3675Bcm0f8ENpRW6oIKAQ?=
 =?us-ascii?Q?eCX8ExXuNomKz5DHzOh7QWVIEWhlsunZ3ALVVDWjBr0dAInU6jUAqNN5z1yC?=
 =?us-ascii?Q?1uC1iOvjXPUEZBBwS3fxJS0Ufds05D4pdG+OClidRVGneGX+svxxnmZc/prt?=
 =?us-ascii?Q?ciZZ1nGDKvY1DomOjZbNqcKqnCBI2zwu/Z2e8DwD8uvtMMu03bWR7I9O0SYd?=
 =?us-ascii?Q?10TZ6vc3Jd5wjXI+8x7RVEP3SswBEpBIu060uZDVj0O9szJnPRWf2eclBerJ?=
 =?us-ascii?Q?kdRmfTUS/dAVh9COtfMLGZyFsDMUQhvvjcAhBgBydvn8TAtRk8Pq/yTOH/nt?=
 =?us-ascii?Q?ZHbyiFvMwsTVP/lrjPIS3WKL8GxY+MQlehzBemHucELMRtS7GR+80JNjvhqb?=
 =?us-ascii?Q?u7rIDhdAU/PTh1nLii1ZMiRyggH44htH+wJZp5cTpwmC2sU9xgFWF7QJTBKE?=
 =?us-ascii?Q?dH6/xIMEkpNuwQzLGnkjebx9mf9pCMdY1KDl3+gLJD2e40r0WOSzvRGKdp4H?=
 =?us-ascii?Q?oIjCaEXRTMDDJ+GuZelTpQrxBfhfv5cv0aBjdupl7/OOcrkDy7WYf4tX55bI?=
 =?us-ascii?Q?lZY+ccfd1pGM3M2oJM9Hf/oNJCnGZvazBtmJwWkcDLDwDDXMf8IXVzVHlVrf?=
 =?us-ascii?Q?o2jaRVL6Qg6jrHJb4QoV2K91oSYA9+7HtKD4615x4cRMX9727IjvjZdae6hC?=
 =?us-ascii?Q?RaM1EZqy5zQAwY0sMPkPkYdjxTqqL4MYd/IV6jPBCyqfc4V4RRC1OLF5Of/A?=
 =?us-ascii?Q?xjzagS6cqPNg3QsWmtDriFu1o1oibdLXdn9luJ+Sh8B0Boj8rshAOHM1EQyR?=
 =?us-ascii?Q?v/GpxawwoMtaUbvw5Z0RmOwutaNPBYIecPzSZimGBhWk899Q+9XSJ5PVloQO?=
 =?us-ascii?Q?2QYSCi5i1lJoBMTaurEiMj9EpsaU8u6XNpvldvFcvCtCjDlDBpxDhu8WTRUR?=
 =?us-ascii?Q?wKgADryezgNucI2V/rZV9T0BaoSs2NfjxllvD5ttVQdpraYS3tiFCLMopeyq?=
 =?us-ascii?Q?mFq0K1zYYKXJPrErfRYdvL67KgRj2r+6bGiEV95z9T+6EGBIXJligUQPIKbs?=
 =?us-ascii?Q?xvWEFyz0SXd84AL92luMqSPiVlw60EaLuZDTjGVZsDs9gFhZkXlKMMsGiLis?=
 =?us-ascii?Q?8RTcCTaYC6uKuy+QdMpS6WH7bziMUnhgNEzU76gjbAOmfRdY/Kkuuyy4kpkl?=
 =?us-ascii?Q?0/QAXg19kNJHOE92on8OW0u08crxWbO62hOuk1tsvQqRM9GOp1zUkq8qxYj6?=
 =?us-ascii?Q?GyWUyIk70BMj/lHr5YLR5aLttpPe+dTpymBpPgSdxJiXPvw0rSrv16p30l2R?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	33jKY+8SHorRlQKEdf0T03W6sTCXy6UBeP2o3OKh+nSgzsysxn7Js4q6fvx4j+Rzo1r3LADDPXgxxnjXzOxQLWLcUEKkgFfljyIC2zBZ5gsSgCMWy4/nsfXrWOfn8Jn09gEXmHvbSFCnp10slnREKFzpD7VUofJ3peTYpChKqQfaTl0E7RhWJLWunyhymyfqvY89FYk0+FdK60t/RSrnmsFsoz0xfyQCNy6X/MYPLl+bNN/T3/tG/EESh18Cyztz3F5wlP30UcKlOSy0owUW2F5nwc06BuxZsNkQQV99ITlLLUX9zPzyzoZPLKe7VaJlqZb5Aqw8ryVQwEqrps2u2XvgntsAKkQG6jPFr1WVcp9kn5V34EcH3dsHvU5wp02kRsM2BS9UfuLO2KwQcnarmoflEKJshYswRfUlX08jtXQO/Uo4HSwozqCly7jN1BvDv6ghvUoUQfjfTzwogk4ZVKb1luzI4zTZciKitisFXw63FsgcVUM5bnOefasihh08Dp/iTy9R7AEnaXx77gkRrTqwwi7fwz1oJYnPN4GNWI1GWD0ZlpmEta3vzhcEUsO6W/7th/szthWgiVAsHLxPJ2pUwaLiyiaFNFMxVepiqx4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c464de43-2c54-41dc-00f4-08dd6043e943
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 02:24:55.0592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBzXPWTINcn7Z2f3n5IHqmV2opqiKm37X4paAiGb8xCPIo37RGqj8jJYricSzPfRc/t/UgGj1spg1IJIhbaOEEGucwIUFfLYa4bopYxZE7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7380
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110015
X-Proofpoint-ORIG-GUID: OM4wATDpDp8IKHIKQuAaWr5kZBWa2hxw
X-Proofpoint-GUID: OM4wATDpDp8IKHIKQuAaWr5kZBWa2hxw


Samy,

> I have just ran into this issue, controller resets and timeouts
> (running mkfs.ext4 or mkfs.xfs to reproduce) and bisected it to the
> same commit :

Can you try the patch below?

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 88acefbf9aea..8ced3f1fd427 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2106,6 +2106,9 @@ static int megasas_device_configure(struct scsi_device *sdev,
 	/* This sdev property may change post OCR */
 	megasas_set_dynamic_target_properties(sdev, lim, is_target_prop);
 
+	if (!MEGASAS_IS_LOGICAL(sdev))
+		sdev->no_vpd_size = 1;
+
 	mutex_unlock(&instance->reset_mutex);
 
 	return 0;
@@ -3665,8 +3668,10 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 
 		case MFI_STAT_SCSI_IO_FAILED:
 		case MFI_STAT_LD_INIT_IN_PROGRESS:
-			cmd->scmd->result =
-			    (DID_ERROR << 16) | hdr->scsi_status;
+			if (hdr->scsi_status == 0xf0)
+				cmd->scmd->result = (DID_ERROR << 16) | SAM_STAT_CHECK_CONDITION;
+			else
+				cmd->scmd->result = (DID_ERROR << 16) | hdr->scsi_status;
 			break;
 
 		case MFI_STAT_SCSI_DONE_WITH_ERROR:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6c1fb8149553..7d28b5b23751 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2043,7 +2043,10 @@ map_cmd_status(struct fusion_context *fusion,
 
 	case MFI_STAT_SCSI_IO_FAILED:
 	case MFI_STAT_LD_INIT_IN_PROGRESS:
-		scmd->result = (DID_ERROR << 16) | ext_status;
+		if (ext_status == 0xf0)
+			scmd->result = (DID_ERROR << 16) | SAM_STAT_CHECK_CONDITION;
+		else
+			scmd->result = (DID_ERROR << 16) | ext_status;
 		break;
 
 	case MFI_STAT_SCSI_DONE_WITH_ERROR:
