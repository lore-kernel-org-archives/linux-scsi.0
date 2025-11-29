Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D133A36D513
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 21:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764452030; cv=fail; b=rzkIijb4KFqaFSDE5mqfVVq+dnNtMQ4zvSeOSpk9QIj79o4IL6u7eNLGVtFzbZBljLs5JaJyTSQks8tOWIDcl1pX0BTyd5lNmLDlXy3V1CJwhSPhIYX2arhcJFbVlqflsCUepWNQ4Cn4yCm0/NLIln80bF6qOF6EvkVBktceLMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764452030; c=relaxed/simple;
	bh=vXujcHt56qKh1gnLmc9zAYafmnrkHFIEDpllTxLCvqE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bYnpNXBH4VK8tW9TCRMR9rq+QEvIf600KlqvJAxI3isURLIVHmS5exR921yrgE8aqqY+fuK5+JGkPBXmPEtCsN+TCg3va2o+iefRAzQbT9NmSqsTNvSDR3hh3buEjhsTHF8hh/5rM9XfUHd52SuDVt36n1hlAKnxQa3RlTWfMSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ihGIt5kf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PzyARVvX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ihGIt5kf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PzyARVvX"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATDMBHB1754819;
	Sat, 29 Nov 2025 21:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6p2VHAqkkWsr4nVAdw
	dxHckR9wUoEqZpHfA14WffSpg=; b=ihGIt5kfzha7Ma/KOhXvEFw5XK5L615zgE
	VIQgujqSVWpqb/myH3lRKMYs+LSfleFMhma6XxKeg6cwMA+aXnaqZfsVLnenEm0+
	AZctNGz9Q28AOMSjw6pQ0491IhkHOSMT791KTyHct6309L8ZHaTQtra480hyqIKX
	qhv5OrLgYebsJc/9vwkIN0KkR+xSd7FtdNLQQkTCwWkqlcSxkfPJ+2bKYxUrZzoo
	/f6j7H3ORcyl6dhzX1cnDM6UQ3udA7ejP/WzVjE8WgGPYoD1G5YA9lUL70+LEkll
	CoeKoz6WE+q18oh0dnfW59kPSMVi2woP22jKYz6ICZ39QrX7TDlg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqrvc0k4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 21:33:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATKd0aX004454;
	Sat, 29 Nov 2025 21:33:42 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012013.outbound.protection.outlook.com [40.93.195.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq96gch9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 21:33:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPIwCZ+MYJkm0lQXxiXikoGJqO3lyVVQQtCcoZ8x6PI3jMvU5/irO4oc+lUVhyhvsEUeFMkq1ERCf6IK5NlD6a3YyfnrS19TK753tCycLVau08iSluoXebXFF1qoIDZ94hwHpNAbZRskOcNqJrE5GdHqwQEQ01GWSsafypfVen7F9HWQC7VDEuSeHkDlqPN4xR5CHZIAHalTrBf6Wim9ekWomfm1uvh4zJzIds6IkVb5e+EufCBj/HF3hvuU7vukruQmOniOYAnhPbfo1HN253GPfwXlalW9DkMncnm6tu03TpctiU2eV19SfjypyGwa0peuwhoPUpCSBNtVPxvkew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6p2VHAqkkWsr4nVAdwdxHckR9wUoEqZpHfA14WffSpg=;
 b=PCbSy8jXdz5EUrEyt/2cfG7/lSF1WD0F48ShdGkt5j6KAch9XneE6sEKEeLnEU4GWZZcPq+sevw4yce/WeYkpwhCa6c4StrsQY8b+eSBWSAbmAowLpSD6u4p9qIqAH5nzAVcLcpZMo85UkykVx4TCo2x/ycAlthXBPwOSM21ValZKg2GOr9VsMKL7gEwTP9TFF3bhBSEJJJsixcvVG8GGrmLlE0hlrTdw4cEytfpmZIbdnM0UbYsnEf9ElnHd0FUydLL8+PslmevwBrmJCzV8VfMRDrXslJzTcD3LLRoodECJeQ+7g5JoBibWFFhZtkd+uI3dpuibZPOAFmrF6OHLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6p2VHAqkkWsr4nVAdwdxHckR9wUoEqZpHfA14WffSpg=;
 b=PzyARVvXetftYSV9Y8UR/WDkpZs3Tsq45k08iGOEjBJzzNUHVce3D6MMi4Ou+K8UqKOeUW6x+sf2XQtejw/P/klsOOU42B9+mC9UbGovHw9neNyEtEkspnw6SD80PEkdRPQIj8oC/SUBZCk1QSOuRgx3PMCNe+wCOgvxP68JUCE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7086.namprd10.prod.outlook.com (2603:10b6:510:269::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Sat, 29 Nov
 2025 21:33:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 21:33:25 +0000
To: wenxiong@linux.ibm.com
Cc: njavali@marvell.com, brking@linux.ibm.com, linux-scsi@vger.kernel.org,
        wenxiong@us.ibm.com
Subject: Re: [PATCH 0/2 V2] enable/disable IRQD_NO_BALANCING during reset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251028142427.3969819-1-wenxiong@linux.ibm.com>
	(wenxiong@linux.ibm.com's message of "Tue, 28 Oct 2025 09:24:25
	-0500")
Organization: Oracle Corporation
Message-ID: <yq1a504y167.fsf@ca-mkp.ca.oracle.com>
References: <20251028142427.3969819-1-wenxiong@linux.ibm.com>
Date: Sat, 29 Nov 2025 16:33:23 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0086.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: d3feec6a-6626-4570-72f0-08de2f8eedab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J2zGXmPkfXLq8We1HVMbwqiUPTtPIX7I+E3y1RhmfGiKVEguKyWyfHoEgmUH?=
 =?us-ascii?Q?OyfQK+oSdCn3ZBb6GNKC15a1Lc91qcf3SYlLJlL/QzPNDiMkOZJGG/ZO2sCj?=
 =?us-ascii?Q?Lgxq2Ncj9WcQt2Hc8whPia3pmkeM37Dmdf8M1rCTLBYEAt6H7twV5Wr8gOo5?=
 =?us-ascii?Q?X653xUfvEYNqqEs5DHdM5BjVGPd9O/XeEBFRn0FEI0/xd3kZfPISkJW1q6eY?=
 =?us-ascii?Q?p9ZTGsfYuMXdjimz4J5ZBPpu6NlEgRh9DD1qrBB4WAexw0/FnJSZU8flUaau?=
 =?us-ascii?Q?s+1ex41uaP1NDGfyoDy0D+2sKcBkYObXEeO1mi7DJ8LDygOod1d40F2rdcXd?=
 =?us-ascii?Q?FQ6Jg4wbfHNp/puRhAsLUW5fZBRUcLGxI7vbil3jny3gQ5WRjOPtXhBiMI6d?=
 =?us-ascii?Q?N9COwk8VAQ54grDEJJtleKzmrAfkhTu7mdxBronFqfjGZ/BGaw2ZqOKf1a1j?=
 =?us-ascii?Q?1PPY14mb088fU020OW65sDP1H0/8GYGUQPjjPij3ykBhf2g3hM9bS9LZ9kwp?=
 =?us-ascii?Q?0qykve6N4PnoprVT1DZ5Vxre0qxBIULgy/7WnqNhrk50KSV4VFATxenvgqAq?=
 =?us-ascii?Q?WyevrTXOg2fBSHQ6foWYzDzHo1zfUUU/XdYPY5D6PsZ/mCXcrmpMiBRS7uEi?=
 =?us-ascii?Q?SzuNfQCSE1cNJBn2wNNpEZ4at2Uy3ZIzav2MaW3+iGDqPPb8ZD1MnUirLbbe?=
 =?us-ascii?Q?zsIzPg0fPR8rYoKg+ymgJby2im6uzc02tdog+N09lRCBFAG9R1MOzkQYSHFE?=
 =?us-ascii?Q?pPciysSuwQHaUTTppPR5sOQN3MyiFfL1pMSIMjUQmPemkMvlmILyIO1//I62?=
 =?us-ascii?Q?Xpfx6GXdtPT14bdvaT4YDY64U3YWOe2TZCO8qGJ+n9Z2T+zaYjatcHJcIh4r?=
 =?us-ascii?Q?7q1xuAYzOo19EAcK38vMkMQoOs99YxwbTW4YTzfrN9s/1SPyAk4OF05oTynO?=
 =?us-ascii?Q?pKtuS6Nsmx7vtKg2qoIhavrhOqcpunTbwwy6tGZ77xpIZ3QUl533v3VXSTzL?=
 =?us-ascii?Q?dgYSEQ542xY4/bE4navKmUIrhmbu2H4+64kjv+EkvnDZtRrWPym5qqpVwooU?=
 =?us-ascii?Q?HmvI1F9IzfrFGi2SNllyiYjGDLg3FXDLgf8ZIcTkx1U/5CgdnXRtNGSMysMU?=
 =?us-ascii?Q?SFzVGRKdaFMa4e369gCPiwT7LXo4aUovS7VABjEmmdaX8/zKQZFcc1yt2Y0Y?=
 =?us-ascii?Q?bCovt0OoGjFUu4bgX0fxpZgpTD3cXRn3ZP++rPsiUpoXqUOukhS0mY9HkN/T?=
 =?us-ascii?Q?eNPcSTN3hIvmrkH8ottQm5VV+wLIvi2rfVBvI00ecogIZIQ6qu47OWiU6DRL?=
 =?us-ascii?Q?Cm3f/aGk1KJM2PCYyEqUOcPZC43PZ1I28cAnqpvr0r+EG0rXyWpfXybpo8RW?=
 =?us-ascii?Q?2wG3dtFkKw3E8Y5TUtw6TARpG75uOOZu7EUf96aDqrFfVl4bvz1fFU0QO8yp?=
 =?us-ascii?Q?XQzzTxP0FD2XPpgZPWHAbLa9CTUO1ox8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yuSGcnZgkyAGgFnmfP81RYwn8GUxGgoorjW24JVTINoACHB6dl+cJ+YJUuKM?=
 =?us-ascii?Q?LE7bRsjYIMvJGTBCVW4kuY39cc16z/Mw0ECrj80s7v56haD/KUGnBrnlCTwB?=
 =?us-ascii?Q?5LrBkTEOrnKB4QRzyES7+kv+Z5EurISt/tWsqbJJbxS6XL+7WUJ68VfqyVYl?=
 =?us-ascii?Q?CQ3zZvTdYAQP6ylvtNhNebjXFbPIVp17je70M2GxOoZE/BlX2b0XF9bSlbXo?=
 =?us-ascii?Q?JO4/1bTZoplzn1tRfcaM+khqcsfuZ12iY+wHNo3pj4ELI0ZfKOW4IGTi0tFc?=
 =?us-ascii?Q?8n6u2bhl3LeOhGBZQjLb3xdSvyQdJmY+DohMUkH0YDiFgR67YECOqGsXXyeA?=
 =?us-ascii?Q?LElA47XJDdKs0TaCARx73WQ1KpcDBEltO60/9fT9PDxEJwP8IKni5nh8qmsd?=
 =?us-ascii?Q?qS+5S9ha3g7q/CDY4Ob4UwWD8q8FYzG+YAboiXIVxdKrk3dTHIHiffB1vzAA?=
 =?us-ascii?Q?hONzxZlOV/VcoBcGE6VxYpEhw+e1yEHclg7cpfITm6lWq5K1GLOcuKyKFIeD?=
 =?us-ascii?Q?GPsjb143lYZsfMSW3ApE/CA+RlI23Bnb9VcE+3zg/hZqFDA1BNLigTs2vJvc?=
 =?us-ascii?Q?2hejDEQZVE/mKlTEqvN1EFX3LiMY+8txR9wPkG5t+C9t6XZhrCw1tLP3cn07?=
 =?us-ascii?Q?Zektu6PvdiODlYYNvQ6rCCl923Ry9hM7bXc9vrGd0YyN1pQixUSQtkvj2ETU?=
 =?us-ascii?Q?UcBV39Ya0VVBjWAm36ZreU2R76NOTHtixj4NxJCyaEpT3yLeqCMoo6R3Gy3/?=
 =?us-ascii?Q?XqYZ243tUgU2Jg3E6+woOZYSuxiGxrg50KQhgVDmj9hU3s60k1x9OIee1X/J?=
 =?us-ascii?Q?1M9m2vY2pXN1QnWSJny0Lz8QgEhIyCe/z408SrsWQ5eBUfnjtBNOEn8+xchb?=
 =?us-ascii?Q?6oK7cEvLbulZNRrCiuUSFi5lnarwWZqsIqZOCJ1s9vTBxj7Pty/WG95Pb7Dl?=
 =?us-ascii?Q?sikuJCpa5e/YSmZkfxCf2Qa4EDcP+Z002PgxWByM1veSTyU9OLHboa+KscvF?=
 =?us-ascii?Q?cBj/x/T9j0Qmz12LHd8LVJb6wJgsYkqwrCbXJJUgXHgc38Y5MGbye5h7c3g1?=
 =?us-ascii?Q?C/5w+DXbt2XHlw6jHpa3WsPXO7CBr/3eyBi88LIP0iZ1raFw0k/GzXz43ZXB?=
 =?us-ascii?Q?QUnN4bZ/jHusC+tDon9o9j1ilKQa1gxhZvZj2xEUjZUsLFAO2p0iSry46MOQ?=
 =?us-ascii?Q?LVVTM8dPO5mOhVxg7v0U5YlNZ41SoyzNAupYT/8e5gj/3mraSiWrV+vl1qg5?=
 =?us-ascii?Q?nVBdhWl268RJ7EimoxwphxdNQ70HEXad2GS8aSNnmy5wvlEo4dDvRLYG783W?=
 =?us-ascii?Q?RStWY/ABRi7fabvKLkmGuJGQK34Z0+jg14SF5omstiWGqISl99DzYS2PoGIv?=
 =?us-ascii?Q?/6IPBIxy+/PvONFt7lZlikjcWiByxSi0AKjllx641TmSzBxXmjLVLAQT+TII?=
 =?us-ascii?Q?TgbXDK6R2QsAr0XFKgQr8C0a2359QwhGAGJAFvQA4wFc6OATymt9PqZJZv0k?=
 =?us-ascii?Q?btH+crgrrs/ftveYlK/arY+hJ0Fv21NbB+AQo2Qo/KwXhB/rki1RDBRLxN8y?=
 =?us-ascii?Q?jZ0BXTSGwhb7pxhIj4aLasn6RZfKkcup1XtfNj/CTKpCxvHNmZRcgxU9kQCV?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	77S4YqmVDI6RWRcKZRFhiauDqdyzoUmaRSM8bDvx7ZieFHoBSp0MBVudAnSrcwLL+iMLXGhlMkEY47h4RCS64ESUNFROvDWxvWhxQ38h/TTfo2WBCPWYkMRasM8+U1nNcRUGE4Z4Cx8T8DJi/I1uuh/x1LUyquwk906nf+Wh+OZt6MXbDitIyeA9l1yKJ8g8s0XDNRV8BG9pet5gp0jUncbB1DZsbHB7GyXaybBlqXmI6K0pqurDwPA9Yn3RBcMjSU0sIi/SiDjX/GTni9D7bFW6y15SQ68i3lza3GWmUIAcIyNN68bhOL2PW5Pgz4Pj6q1+OicqGgiyNzQqvVgPa0QyLK8g9TbViq2WiPHH3IQKXGSGz2ZaOhKlMkLPHiZBqTLT1SxCe3VYPIIwpGwxf3n9xMpgdjkt79f+644cnlrrBfxQtSt69gxvs0zRi2BPR3GFvQj9ZV4vbGII4Zcta+6+zSEbrKtep0KksKmkxA/CsCiHNVzJjIyU+gqhwKICFl3GmWXwQApnsl7GpyfkxlcZaIbWIP5PFTd1JqnfDB2bJDhROWPfxLab74Z2gXZD45hSr6/6SYjiY/kAtAxvvWJk8idGyn7spNa+VUyh7cg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3feec6a-6626-4570-72f0-08de2f8eedab
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 21:33:25.4281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d18yIx/OGYu/q27JCGIxTMlta0Setm+ujvz3j9ennkqgUCN9vf0/Yt2tgFwW06mFjAGQMZlgz3OST9bxSXOxTlHX1umtKFwSeH1KWagCqa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=894
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290178
X-Authority-Analysis: v=2.4 cv=ZeYQ98VA c=1 sm=1 tr=0 ts=692b66b7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE3OCBTYWx0ZWRfX4rD822ZhjcDb
 54diLJ2P47bfJvudJN6X4BZKy0EMpprzPY/QPt+W0R2/pjxKS2/yjIp4n0f8eldivEyyaDCxM2/
 PSfsCu/erUtLZvkY/GVZHw5vki674spbFMxYxKYP7p+fu1nJ4hLRkl7/8VJDbIeRlKA2s1uj3CK
 Ho2T0547VZ/U0y7k6wKO9ibBxIeMpb2i07HZApIbGhzBi7CWMiFi8REOsG8mTbPpUWNRcuEHyZ4
 q2U8bxQM0mkmGuQgFOSHqzsAvq0CIa7uxck07y+AL8P6dhDU+PEmVZsPB6hIYQYswyKIX8+80Ii
 PwMf9NxL9opvOzAckQMJJTWXWeTDq3Toruj9aK6EM8txx6pY7zep6VsiPmGFZ367AGdR3XEFCOs
 cam73o9p4BSX65dEddvCaavKzpm2kg==
X-Proofpoint-ORIG-GUID: qKYECDMmOx0U5FZw6zpjbVqD-gQgNU78
X-Proofpoint-GUID: qKYECDMmOx0U5FZw6zpjbVqD-gQgNU78


Wen,

> Issue is: Dynamic remove/add storage adapter(SCSI IPR and FC Qlogic)
> test hits EEH on Powerpc.
>
> This patchset fixes the issue with enable/disable IRQD_NO_BALANCING
> during adapter reset in both of ipr and qla2xxx drivers.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
