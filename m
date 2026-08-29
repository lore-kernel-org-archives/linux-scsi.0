Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F255B342539
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2026 18:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788027145; cv=fail; b=Gtdlx8EU1xi+0SrIovRWxndbDckluWBTK1bAuoiyfNTyHAeqIDfiVi4HNYdyWj4Ff9/Pl4GhLlViyQIcYp9mgQhZW//US/cDZHAoZLRXAzSF7Sfa9GE7H+ZXV4gJRl5m+i2yW8ta0oQNIoinnT/CUrQ3UlTDrgezVkaQ2hwAan8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788027145; c=relaxed/simple;
	bh=SgODM1GLSbZ+eyCbjGcNpYIpSB617vfPDlJJHv80wkQ=;
	h=To:Subject:From:Message-ID:Date:Content-Type:MIME-Version; b=CECoVQA2zE3HE7FNmdIY39TuTZvYuoJtoPrF8v19fYuzuNq3VB83+fev8AIBCeaoBSeK7DPg5CHL2zcGxBBuLhyvY+kT9fsJ0mfzafZhz2KDCS3g4swog7FOpHPMo8JLI9UW6HN3YYH8CGWbB2mXFIbIMrBYg55w/MHaERrVnkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qHOC2ycI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Pdej0OFJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qHOC2ycI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Pdej0OFJ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TGFSlL1766461;
	Sat, 29 Aug 2026 18:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:message-id:mime-version:subject:to; s=
	corp-2025-04-25; bh=+6FHJR8Av1wojPXsARyxSlPSaXaJ37FzpbygpxPgEiQ=; b=
	qHOC2ycI1XkJgHsjICtkIgScl6T+i3CIip6vWBi6l4zM08FJF1BcfLvQOnYvQTfH
	soXkIPqt4E4i8VG5RRrvWDGtiSwBs4tfmr64Nu3jsviv6rYK8dKej43+K9dcPBXh
	EFD0OBJPrbtXRPjJP8O1T9wFvlAgdEYvcYxdGQsjzGz+1c7tcr8C0QlDhT9nbXZ9
	qPHUgPXZ8e7xpLgDlQMbBc78o/lxKMeeFhsZvZUyMGhW71esDr0QEvws50jrTuMN
	cDmib2dduAVXwqakZ8wgtl5W/wfrVF9SIt7CipF4AR5PhTbTNEf8M4iO75K52Wev
	UaWB6joO/khXxzraEE6rzQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbarh2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 18:12:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TIA7FD035898;
	Sat, 29 Aug 2026 18:12:18 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013000.outbound.protection.outlook.com [40.93.201.0])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvbdyk8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 18:12:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvptgR6I+S18R88XmKOPjbYhhJL8T3JokQyZvx4257jA2DMnsVa9eU3jumjyeYnOLxqHZLx33ftLJe7S1Hk/QZZpjo7GknVqjveidat2UNBwSash1H6dVeUQMnat6GEWIpmrHUJask15uU0hSuXxC96pmenb+ZZl21sNTBgUGg/QlFbCR6vb46GpQfpXkreLPQxVWfWOH9gP37ZH/ycLJC2VHQBUXtdQdswYowAfqnSIkDbQ5qSeTO6onbcIk07laj9e7tMncZs49n+cSwgvLgs5Enb1vTL+A+AtKFaEQ7QLqjbJRKXczq3smyPLWxsx6g3q9DyU0H/23yEFGYU8bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6FHJR8Av1wojPXsARyxSlPSaXaJ37FzpbygpxPgEiQ=;
 b=VjJ1QCAl2/+jRpavmtrB/d1ylb2NtGI+K4k6OWCvuSmdGM7Q47HPcaCSZwKoi4Sekiuvmvz+5awKvCHtYK6/U1cXxTVOqoPm2vQz4fVKZARmfe1UKIlUb9GPexFziulIZYWcNXOwB5u/5JHfES5okoBoRhQFAolic42v2nfBq7gbA2uQ2x2BcayzJbnEz7wRmpDnJF7KA/7B9FLNij0XQ/SetGGDcSIvtpIdKPlSHHPNNU4oRdB7wTTZ3cXC7z6T57uc4B2iH9LaaFSs0jeelAzj9WP+LI+22K5qhExYXUjDn3nu+QfFgrjtUs3IaD8LAxlzY9abZApByKB4/Xrffw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6FHJR8Av1wojPXsARyxSlPSaXaJ37FzpbygpxPgEiQ=;
 b=Pdej0OFJeotQZBCazgNGvuD+aFpJoo2l23dzsdyow5CO9R1xwIDSwxKJXbBuRasihPcVBUCFrZcR1pTWvmwEEZ8L09pBXtm9rjNBpkbSmiGUoI11mzD6jyOWLo10pV3C00Uilf9NpQHWmk4KD5Zyn0qZa2d8JUDR+ILHnvpCuac=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PR10MB7910.namprd10.prod.outlook.com (2603:10b6:0:b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.9; Sat, 29 Aug 2026 18:12:09 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%3]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 18:12:09 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        linux-scsi
 <linux-scsi@vger.kernel.org>
Subject: SCSI updates for the 7.3 merge window
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Message-ID: <yq1cxv0iyv1.fsf@ca-mkp.ca.oracle.com>
Date: Sat, 29 Aug 2026 14:12:06 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0233.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PR10MB7910:EE_
X-MS-Office365-Filtering-Correlation-Id: 74df1c06-820b-47c7-fb59-08df05f90a35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|56012099006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+mklRRi2NBUlE19HVXy3RFvpto4oq4y3unE8bZbj5a81yklB1XSiyIgF1LU4b5L88OyC3XeJI57CEdXcGsuvNlLYkRLfeVjcDfOjlWEsKgf6Py3KANVY+UcwZtcoT88xwXjmt75OHndumW8gPRSyX/9KuMy2laevBWWG0L/E8YUlewqSJLCysylB/TIC5SacWWK4ujvXABiGVbIDID9F4rAIMv7XqOsOdX0aB/DOsDNutCVF9MQJ2hA7a+N10x0NkQI2veD9ABB/H7ghpm16aKq8DOYOwWEGZIR6/syp4oNyYeAUw7Qc1kEWioQXGSE6wHdYVbnneT/tsjyfPLSyEUfz5ZX0+TduFgQUgJugWLJhxsHrndMm7Vur+/RYdRjfHcfQ3EEXpsw7oN2Sm8lGQGMhGm1qX7vMw4oYS6cKqmfe0QmnOBsx1hJOISRrIK4rILCmtsaZUaoiIbnGq4cMvdwCB/uzzGm/TRNs69l7IRxoCTSs6UhpqXUuYn3Oz4+laLAfnPbshMxlGP3J8W6AL2nG1Z2YNkFYpFeuy7IHARVLv9QlOQnL9XQnCp/GMk0NTgl8lNuDgK+76dNoiz3Wp0OsMNCnDAO1fW524z6BhxyES9mXhYzLBTOsoP3UlyAHmjzpcI9w1XQBGdWXdavPRdoy9xvyOygiFIPLLFUnY3g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(56012099006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WxltYUNmecFsMA3pJfSZ9F+7QXPwcbCpS/yTjSN5UDTMqrqAzW96kIzcEn/u?=
 =?us-ascii?Q?le4GEMk/jH5Ox+fjz1GqzS0tCfHz7te+fTTTtwkTgD2FI8lrYCI9FZf7Lree?=
 =?us-ascii?Q?zDrsVBdzz37TgI2o6hojHcJugBzREBUXZgyZNPj2Ob3QoQGZUD0lVBV7sMHs?=
 =?us-ascii?Q?qkDcnoxQybMiQ7Qtt4C/m5dESHXdqnv0h3fEjMdoDqTkx6e3Z8TIqqC3+GOt?=
 =?us-ascii?Q?pPQv2LrO7mKpUXVvdorvttI8i61Cs7LJMnH8MmFMjhTsKqZfmxg5YPBYP4e8?=
 =?us-ascii?Q?9CMmw+wKqNMl0GPCr1QHVwviG/e98qpVl+Qdtzs7AiO1m1gIe6JCSXWr2f7e?=
 =?us-ascii?Q?TiUN40l9R3w79O/1EyIakrgctq4eJI0WN8Ft/gfDMxWuzwd6T7kJgBNSUXZG?=
 =?us-ascii?Q?3D87j+SGtQsvYVNQUF4qPVjGAs9t+5BsHgbeT8bcI0XvzBIB+eYAaUiMmI8P?=
 =?us-ascii?Q?fkgPN9tDZV48Oo8D5xDEg+cY9Ga8NkYn3yh1miuauXOBhq4GFRemeT2dNH11?=
 =?us-ascii?Q?G/aeNLtk+Mfy1xiLm6en0hZJVC9ZtLosYkTzoFENFbYgbG6G5NU2nP8jErVg?=
 =?us-ascii?Q?KOZRlEHB1vZtOSnvhxZ4S3yvhWG+UAPZqPropDqDsyQDguY6zPB9PllgqxnB?=
 =?us-ascii?Q?x2Rfuan3HsV8pEIMlejgri3w575LzWyIcmMFnKujbySc3f8lM5FRUinIjveJ?=
 =?us-ascii?Q?fQDnBTf8rEQ+aGDjzpTaRWEVGq+uqIjp3HFYhQt99eHBXeSwqov+yRgNsemb?=
 =?us-ascii?Q?eyZrcsjXTY1hpkAMyPV1q8fnHrAHgU7PNc3xS0TfKXmbftyS63vbWEPlI/BO?=
 =?us-ascii?Q?PwpmdAYBigYmBTSVCTIQH0YGwphMoRg3a6xihopZhkVIisvX0u4b5aBvuid7?=
 =?us-ascii?Q?+H0IDhSiSOb2JTPQO3obAzHXC9H4tDw7WMc+3cVKl5TC+fjWAEyCJAzZSMIG?=
 =?us-ascii?Q?L/Qm1Z/tbWMzQpn0ZqRFdEiqHZcucizI3HCiAGWUOY6UNKCoBwESQcFUKnPA?=
 =?us-ascii?Q?tyUnTGIP5uul5ciRWJeN1fwfVtJx4jmtKccjYin4Cfe5TBvNhTIoPny72Vtu?=
 =?us-ascii?Q?wdsRnRU0UHGfhIgnj96wjj3SIjp/Al1DfJJzo04MtHGk0biOBBlrx32Biie/?=
 =?us-ascii?Q?qIftWevuK63YPhylE31VKBKgJ17ERItzwqMKzmlpr3Oc1GFJL9Ww930i6E/i?=
 =?us-ascii?Q?kBsafuDVlAVKndcNkDR40KRshDBseIBtkpkkHPeyYlHty+6ngX/rV05zgdo2?=
 =?us-ascii?Q?QL1+xXiO268t5jepLZuTuNaywloPGXbHvxKZMoCGISPNlLreLun50NV5rMtx?=
 =?us-ascii?Q?PnzdJeTaiFjkmOpTAPnW4P6DWw8JbvIt3pJ9rOjls82kYvCzS1XMrjBXTqU9?=
 =?us-ascii?Q?Yefvs9dBEjFf0QBpY8NGPybdSiGtb1VaaAUc4GPLDMskKCXNzAbjgyG9jsIq?=
 =?us-ascii?Q?untw93+kNaGRnXjmA7HvZm3zN7CUE6lT2/C3cD39ZyyHH61M8D1s6YnKo2zA?=
 =?us-ascii?Q?OtlqqSorvH5OOslpLtpdSWVVJXHGLYT7TzPLwPd++pa+Mpk4+kAOrype5Rwm?=
 =?us-ascii?Q?o2ZhAX8At2EjTzZHtumlREBBkgxBhI7uKk4nRl5bngO8VoHR2qiLty6epZxg?=
 =?us-ascii?Q?3oB0m+E6Zg3ClGrzTningBQI1H/EFucHoHazDlNVetQJfbW/5BDWoC6faJdA?=
 =?us-ascii?Q?pQl8p43drawgAQcCAVG1WeZy7mW+DkDg7K4wiupnZLZG6RfXiliX1/3t0tz+?=
 =?us-ascii?Q?iOSRW5GliAxPjKSPO7x8dMw4BN08HQY=3D?=
X-Exchange-RoutingPolicyChecked:
	QfQLtyPblz5Y8V/+Ney6XqB5xzWYZdZkaadswJOlU1fbscuY03l5lOQsOPDObfGb4IG7+zMinGL8bTXMLHBYnGHFLMrueUnslQ2GFvI9WulPTu2S4E0J1/p7skpE0Ll/LEtKHzzXQyp9peCkIFFiZFxJItLP270+XB0dJ8bMwYiAQobscr4coE3ronGZUmZ5gsHkv6UjFnK38OxedjnnLdmR2NsJlzlIhL3VEoi6Ac51VssnX8ZtwYQ3GMXotxZbBPDxMUMUauXbujio4duh0ebrY4tBQrjsZwhkZP1QuCrlkvApeW0+bpeCStjSMy0G498aX4q6bly7j5Oo/8RQAQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	16Z8NnKJ3MZv8Jvzsr5EA7xI+LUqYhNrcVMxkCUP77/1LIFDYPZ4PARmceI9S+KUo3OEcjc6xMQ/BJwkCilZrXtg2yas1TFcJPEbfXKogdSvt2wCAzc1HzN40cZ6rO4QyzGc9DOOQlQcQS9an2CteNiKwD0Hc5t72QLjOsiBX/VxKnkZI2e6RD5yn263HamKnUefpLPN1eOW5pmk3Ln+RwjJ4zoX5fjVZCkLu2Tm8QaOrrHFPgn6Mh6BVshbRseKf6nsZLtDTsOQvZsrOyeBoCnFuccPeAMFhkyySTjcx+g8FwcgaZI7D4ST9MYjwgHDTLCaoI9w/S/EwLOb42BA8vmVrcm7xJT5RULMDR76LmD4ca/lCUR2ZvaLX1h39K5zHgHy1l+ZtNub091u/opKK0Oxkq6iB+RrYfLK+rgEdyFhAISbBwP11tGPQJUyrVfjkC2AoCNvwfzHUjrroIL6LQbfmnnYkZaijYf6iZPMKXF7WI/Et47+QqngCMTGpVvSUhvfnMQqat+DBlQ8xftAjDoe/zB+x4zRtba2h9H7cW1wW91Ev5K9z02H8nljW2ZHgtOcFGHioDA3Oj1NPgM4eSZc1hPJ99UK8g+KTzh/xfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74df1c06-820b-47c7-fb59-08df05f90a35
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 18:12:08.8166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BTIFURnIIr/8EYNaKSWE14Zp9wS+hT44eU74NyRp8Yra3tY98kLqA8c9phBGRV5Ui7mdWgcoOB0EQ3vyEmTW4XMarkvix1Cy+bQJ/nbuPwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7910
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_05,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290157
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE1NyBTYWx0ZWRfX7e5w2qxL7qYh
 nGceInX7/Z9piehx5+NUCglDrvUSQ1DnlZ6KOC0T1TmwVHNW17acs6A818RlODuPbP35AFfSipm
 fy7hAVRAtT90fWt6hnuW1idhf+7ByCu3U5ZemscJayOLr39MxWqu
X-Proofpoint-ORIG-GUID: gjLYgKaE2l-DBl-WWbNgku7VgCODJSju
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE1NyBTYWx0ZWRfX8dBPM2FHVI1c
 o5O7nxZoa42ijqk+tsowo31qruuawsJXfymnxsRaZEEeKDXsHbHFbAYqU7FMX9LNxik/0sQ9P+y
 NE0Ar91wvixdE7cKwqjYkeol70QJYKP9Odgf6ua9JrAtDEDIg1IIu11qIEEspQJ9WbivGpXY7Bw
 QGMbfLL67RaAU588YoAOrkVzrrsvvnkNXXH7JDlOZKZ9eojCEW3dDZW1WxEhQ7zpfBXCSXep+SE
 pd7PhgHgVX+GGuiNpHtVjTcuZgEe+dq0GVETuzqhddEVsyUwYFClgxQxpLOtT//8l6EhKp9p1Z8
 ivvIQtQ9oVSuhs9pcS4L2z/8+AfMUAPUxNIIT7oXLkYCa+lozShlTF/mkhkJW4iwsWtbkbTAYck
 RqQ9oa7PySXkJ2isYFsbe0s53xgi2DwYUgYc2m2nYjIwSKAE+c5YWEec6fB7GPWHxOdlQgsb89r
 8jYbHEaGYSe/gnxLpjg==
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a932103 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=7ryCAhIx8TlXwMqjY34A:9
X-Proofpoint-GUID: gjLYgKaE2l-DBl-WWbNgku7VgCODJSju


Hi Linus!

James is traveling and has been unable to prepare a pull request.
These are the remaining SCSI changes for the 7.3 merge window.

Please pull, thanks!

Martin

----------------------------------------------------------------

The following changes since commit 376a3960e5efe85ff765abfb5b5b7e4655ad6aed:

  scsi: fnic: Fix built-in NVMe/FC build (2026-08-10 21:24:01 -0400

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/ tags/for-linus

for you to fetch changes up to 12e67eb89eb2b9516685c744d3f7de0a2d1bd701:

  scsi: snic: Fix SCSI host leak on workqueue allocation failure (2026-08-23 22:34:58 -0400)

----------------------------------------------------------------

Remaining updates for the 7.3 merge window. The only core change is
enabling context analysis for the SCSI layer and UFS. The remaining
changes are either bug fixes or hardening.

----------------------------------------------------------------
Bart Van Assche (7):
      scsi: ufs: core: Set task state before io_schedule_timeout()
      scsi: ufs: core: Enable context analysis
      scsi: core: Pass the SCSI host pointer directly to scanning functions
      scsi: core: Add lock context annotations
      scsi: core: Protect host state changes with the host lock
      scsi: core: Enable context analysis
      scsi: core: Enable context analysis for hosts.o

Chandrakanth Patil (1):
      scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers

Chen Changcheng (1):
      scsi: snic: Fix SCSI host leak on workqueue allocation failure

Dan Carpenter (3):
      scsi: qla2xxx: Fix an error code in qla_get_tmf()
      scsi: qla2xxx: Fix an loop timeout test
      scsi: lpfc: Remove unnnecessary NULL check

Dongdong Hao (1):
      scsi: leapraid: Standardize NCQ priority sysfs attributes

Finn Thain (1):
      scsi: MAINTAINERS: Leave the cumana_1 and oak drivers to the RISCPC maintainers

Ian Bridges (5):
      scsi: lpfc: Replace strlcat() with seq_buf in lpfc_info()
      scsi: lpfc: Replace strlcat() with scnprintf() in lpfc_vport_symbolic_node_name()
      scsi: lpfc: Replace strlcat() with seq_buf in lpfc_rx_monitor_report()
      scsi: lpfc: Replace strlcat() with seq_buf in the debugfs dump helpers
      scsi: lpfc: Replace strlcat() with sysfs_emit_at() in the sysfs show functions

Linmao Li (2):
      scsi: leapraid: Balance host references for firmware log VMAs
      scsi: leapraid: Serialize firmware log mmap with teardown

Martin K. Petersen (Oracle) (4):
      Merge patch series "libsas: rediscover improvements for linkrate/sas_addr"
      Merge patch series "Enable context analysis in the SCSI core and UFS driver"
      Merge patch series "scsi: lpfc: Remove all strlcat() uses"
      scsi: MAINTAINERS: Update my email address

Nathan Chancellor (2):
      scsi: qla2xxx: Fix size_t format specifier in qla29xx_process_rd_image()
      scsi: ibmvfc: Fix use of uninitialized rport in ibmvfc_do_work()

Xingui Yang (2):
      scsi: libsas: Add sas_ex_phy_to_dev() helper
      scsi: libsas: Add linkrate and sas_addr change detection in rediscover

 .mailmap                                  |   3 +
 Documentation/scsi/leapraid.rst           |  14 +-
 MAINTAINERS                               |   6 +-
 drivers/scsi/Makefile                     |  23 ++
 drivers/scsi/device_handler/Makefile      |   3 +
 drivers/scsi/hosts.c                      |  19 +-
 drivers/scsi/ibmvscsi/ibmvfc-core.c       |   2 +-
 drivers/scsi/leapraid/leapraid_app.c      |  14 +-
 drivers/scsi/leapraid/leapraid_func.c     |   2 +-
 drivers/scsi/leapraid/leapraid_func.h     |   4 +-
 drivers/scsi/leapraid/leapraid_os.c       |  89 +++--
 drivers/scsi/libsas/sas_expander.c        |  96 +++++-
 drivers/scsi/libsas/sas_internal.h        |   1 +
 drivers/scsi/lpfc/lpfc_attr.c             | 555 +++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_bsg.c              |   6 +-
 drivers/scsi/lpfc/lpfc_ct.c               |  29 +-
 drivers/scsi/lpfc/lpfc_debugfs.c          | 202 +++++------
 drivers/scsi/lpfc/lpfc_scsi.c             |  49 +--
 drivers/scsi/lpfc/lpfc_scsi.h             |   3 -
 drivers/scsi/lpfc/lpfc_sli.c              |  43 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c       |   2 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |   2 +-
 drivers/scsi/qla2xxx/qla_init.c           |   4 +-
 drivers/scsi/qla2xxx/qla_nx2.c            |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c             |   6 +-
 drivers/scsi/scsi_lib.c                   |   3 +-
 drivers/scsi/scsi_scan.c                  |  52 +--
 drivers/scsi/scsi_sysfs.c                 |   7 +-
 drivers/scsi/snic/snic_main.c             |   1 +
 drivers/ufs/core/Makefile                 |   2 +
 drivers/ufs/core/ufs-debugfs.c            |   8 +-
 drivers/ufs/core/ufshcd.c                 |  15 +
 drivers/ufs/host/Makefile                 |   2 +
 include/scsi/scsi_host.h                  |  24 +-
 36 files changed, 654 insertions(+), 643 deletions(-)
