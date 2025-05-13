Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43AD19AD8C;
	Tue, 13 May 2025 02:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747103186; cv=fail; b=S/gqMVj9lyaz0b3G9OMtGAqOWGb/C4mBsIGiwazqsHEV+qm5YoFvDyG3+ndv7uIEiVw5j7/F8tEP13bmLViIObsx7loyCN9VkAlPLFVMLZCpEGwySh3MzWGtUOL1WboyVj6E/y3p3+B4MhMD4lrjPanUJNF0DBKXaOrZtEGofqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747103186; c=relaxed/simple;
	bh=G1Q5wxJHbUxsC8baQqkEMln+SlKlKWe3x9iWaan92cg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XKFcVG10nE1FhLchNCsRkQED6GMQfWnzBjpThLGHZEcXc9uxuJ0rEuj0Y2ztU+0CYVYPYc2b1ZxBfQh6HvJF8yqfgyL0FswdzxrY6QgKi/nysneEnXgBOAK21y5QUjj8iVxFgrBspw+n6IU8f1P13CAg3iOzlXimoauP4dmnnJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VxRnq9ZK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=avbR/Oag; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VxRnq9ZK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="avbR/Oag"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1BrTa000462;
	Tue, 13 May 2025 02:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FRO3IXnSh/C2WkEegQ
	3cdwqORnJSgJnDk4DUymrlQFc=; b=VxRnq9ZKIVtUTV8GHF2UNZQip1/a+KDnCp
	lHTFHHTBs6ZG0HveO6IqR28HEQCF1pbrXF2erWbj23kihyD+3I9IgjiovoAwXx1h
	DHe3UTOzisjF3QtFmD+nxTJ/O6HYjgAFUALMw4w/MAR3lvrck8UE4s/fIITL0MMu
	pHmAA54Bfj8CZu93BbE0Nq3w6bHnuWOIdBVs2JXHrHkXRwdH89t//coLSlZhhEs+
	izC/bcn/+Uv3FRlWaiXEK39tw/ftci6j3XMI4EcN4atnz3M8rG6vM+70tl4Qvlb2
	3nraQkxGmRmCAXRn6cf+y8fl9+mjh1KhEsWt1i+cGQwl+Dn1vWjw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j11c3q2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:26:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D0Nfge002472;
	Tue, 13 May 2025 02:26:20 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azlp17011030.outbound.protection.outlook.com [40.93.12.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46jwx3rpw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:26:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JODTIOnEXBjnt8FGaGLySpBR38GY5RbOhZetvqHyxNwDPWQeKkGLyVuVzFMc7wUhfQr22qkTL6jfctpw+8M40J7WCt31JY6vzfVOUyME5Hc6NF95SvtA6DVaEXx+JzcqggWkGGXZ8L/eaehR+/UZnLbvYwuOZwCLbjcnNqBbrN+be3CnbbLLzGZailX8OFE9gath6ZwyIediC8edRQxjFaGZWOmJXGc7rscQINOB1xBb3kUBCC2tj1qQRwCxiInF38qMhwk6ZMVbzUqAPlzkdb/hIAoaTm1MilYBJPw7uLivrx66fLnmRoKjh+f0+rlaxF2U9gP+kxEjYzVkvLB7gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRO3IXnSh/C2WkEegQ3cdwqORnJSgJnDk4DUymrlQFc=;
 b=IJhBSNqWW1KaYlVfMNcAhiq4dJ/m9F25CdUtSmSLFI13+CxPz43wk/MqIU+JXkk9UWYDNP8XxiQuXdy2rA2ilokORjuV1fCSbZuve3eaH4OA13/UYbkFqcicQuxoBKq+oa9wHQYBBttz5jIZzFHcKJrVXeRVNQjOalDq3gptQwF8LrMBZR+uZXe6J9dHD/DbxLzStW+oApZL2mpXpy1yqkfTof0D9wu6VGzWpDN5x3JI9Wd9it5qNdTgC0pW1bwI0COtYBKzo4Ztzpmg1vt+lC0jND2AuUS8YRveodxmO2Om/5tUf5zVzjNO65IWNLsWM4/XUBfw/GefcJzd3dChFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRO3IXnSh/C2WkEegQ3cdwqORnJSgJnDk4DUymrlQFc=;
 b=avbR/OagpMpXafRuQc4SBEFsgWq0JyOOWeIej0ISmp+4ULNprzpQcoyxWvkLLDYNtzYlP6V68sCQ8X5tTs9FGlk8IhwjvfN9MsTejgEaoSdzI/4dLbTItkz3iW4cRky9WACfpfppwgLhMcx0K3knkonEBssn4aMaAwfZQHomtbQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6099.namprd10.prod.outlook.com (2603:10b6:208:3ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.27; Tue, 13 May
 2025 02:26:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:26:17 +0000
To: Nihar Panda <niharp@linux.ibm.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@de.ibm.com>
Subject: Re: [PATCH] zfcp: simplify workqueue allocation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250507042854.3607038-3-niharp@linux.ibm.com> (Nihar Panda's
	message of "Wed, 7 May 2025 06:28:07 +0200")
Organization: Oracle Corporation
Message-ID: <yq1sel9qm9z.fsf@ca-mkp.ca.oracle.com>
References: <20250507042854.3607038-1-niharp@linux.ibm.com>
	<20250507042854.3607038-3-niharp@linux.ibm.com>
Date: Mon, 12 May 2025 22:26:16 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: f9b3708d-abfa-4e5a-25cc-08dd91c58a7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fSJaj9hmx15gXXUuXRqf+dMUh71ZdUWKUjEUBHT/TtxzqZ/XFQq8v+6ITxii?=
 =?us-ascii?Q?uQ1czBCgjRjZ8jxjTATZEZ88l3PDKUksacMzb0F4e1QUmTETkUaqDDEJTHML?=
 =?us-ascii?Q?h7Bz4wMy30fsylBDome2EPqUaNBTLxrV3fHL8zMM06C4du5sT08UKFyYPUne?=
 =?us-ascii?Q?WocwTF1A0q84/ItelQPsBqoVNwrfPR7bhdGoPck3Emcex40B7LYfecXXeMKx?=
 =?us-ascii?Q?YdJ7vBKF73lJQX+Kss9n0kRVz7E5sC461vbt9A7k1LSEJN6hJQTAiSSLXFao?=
 =?us-ascii?Q?2we4mhQYCuxBpmVa/TvHomfkhJarGhnr0HYSFeFW+gzPL/zl4p+5OgTB2SEk?=
 =?us-ascii?Q?2b0fC1Q34UnrzzJ7FnP5DANUGsDulyvGDkFQxDQ1JYk8IAaUaVPORRIf6mqQ?=
 =?us-ascii?Q?+9wYfGWcvD3lvGQkS2ehQekXteT0/QtRbW7zyB1TZpFen+y65eJ9rUEhi4lq?=
 =?us-ascii?Q?Pte+W+j3oPCbhLgB6PqXbqOYb57TFQiKHSIoGMJ4snAa02DK44biS9Vl3Hhz?=
 =?us-ascii?Q?z9o626PNzQf5fY25q3xVkgpOA4yBKpkBR1hKNmTUW24SUiStfSChH/CBSh+C?=
 =?us-ascii?Q?5JOYNKmAHyXWwMI5gkdwhtjI1pT5yl0Tkld27TjjYY7iVwIji3bVe8qEQeoj?=
 =?us-ascii?Q?8bThvoV8vzHMpeqRUVr2X659oWPC/fokrkHIoRYN9Inqqg5f10owEPAcD2mL?=
 =?us-ascii?Q?trmRoA6UpJmKhJwVjrZ5ZArcOfjvhkwE5hWtWzjv7aYBzdhkxuqKw/XY6lkU?=
 =?us-ascii?Q?9kzbWXuwSweo0wLz5EAC7kcCOGJPW/z+a3XIwGizoenuAgldUwKiT0tgl/NG?=
 =?us-ascii?Q?CiS7CuHxW6+nnl8BV0dd9JeX0oRri0Tuyj6mHxgoCC3tHqpq8dB1W/RH48AA?=
 =?us-ascii?Q?UqpBVA/l/PUh7ELr6HHsUYXJWY3KWhxlCR9IIz2elwOGfXftkiJtbuv+YIjT?=
 =?us-ascii?Q?/xDxmClebeR3Xf9gX6z4xLpU/LdN+oXCDEGxAz1RlrpsMJdSGHTkWFifmF3C?=
 =?us-ascii?Q?bnEeMShKwM6N5A2eArv7/80ar+airA9MLFFM6zvtqy0HkR3bnL7hrsIpo0iS?=
 =?us-ascii?Q?Rh5vK7X1XtFFBT77+cUtBT+ZcDSBgxC8hydFehgsCU0KmDsvfqvtxQY/GR9S?=
 =?us-ascii?Q?ymx5NR9vMEnuqLx4Z+JGBt9nrAY3CYlNg8/It30+sjyMmo5yTLYpf8TEnxzC?=
 =?us-ascii?Q?Yvfumwx1c9vZRaTpJs/tMvlxpXUg88wlrCl3BIwmPUJLNND/A4RFq0r8le9d?=
 =?us-ascii?Q?mPTM+Ug7hXAowHWAMJmBdtZ4Fm4S2QmcSR3aq/5LyDs8sUiBzN6FIRqBEIDR?=
 =?us-ascii?Q?5zg7W+V8G5UH87PA8xSE5knMjN8D8ltauMz/AEBVtYhsXdVnDqpDM8H+R+x8?=
 =?us-ascii?Q?p5wTv0iPxyolD690nJkdqGYLgNEFYl0suHzrJaSFXA3+vQH76oDklefmkDBM?=
 =?us-ascii?Q?qbHcoZFv5/c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zb8O+zxdOmXM7PdMbXHKchOL/IMBToHMrz9y9Yq4WqIV9prjzNXi7m4Dbdd3?=
 =?us-ascii?Q?j1zRqelndoj14cFplexcQarlNSBXihdfL4fQ2pc/JTDOYUkqJeiFl8W/LGt0?=
 =?us-ascii?Q?3v9eByqRQyyhTLw5sZmCa89d9QNbhZPt5zvPN5G9Kwz+Y5O+m1PoTNCGqX3D?=
 =?us-ascii?Q?NWVI6vT3j6lQBnI9NmcprMfGQXbfa849fN+hWmjZzPvUvqEoUMduAYlMZeEu?=
 =?us-ascii?Q?oWcdfOdrUympW9EY6yhpK8R4dGtaT63NTGnGNc8FO8C533pVP5nEVm+XXj+x?=
 =?us-ascii?Q?FnWMFxoq3LieldGQstuMzc7k93b4+M4xF1vn/5ubdCGhEVKEpFOUBKpbPqum?=
 =?us-ascii?Q?+DwVKH4vVfc7GgL2rK1dw9kDBdIgnaRbbZozq3jrvEWT6tQEVnBbGW3t9vCp?=
 =?us-ascii?Q?RYba1YxTAFUVH+xjwxDsOeVBCX+v2SvzuQtF9U1ef4j88Q2cfkS9E6FO9iXg?=
 =?us-ascii?Q?peWvCeoXd0Rf4OS9oFivYYo/80brEsSGVsjRJfl5PHKyKChekaVeTVuqx72J?=
 =?us-ascii?Q?LSn7LDTH1IgWZrIJRzH9mJNx1Yd/nntf5GdANqv2MrnyRvOoK7EEv5+0Rh5a?=
 =?us-ascii?Q?sqcrEePlndfxh+dF5OEqwZWm1tkwG3DmNVbVlVmJ4bVTOiVPgNHtD7xVapWB?=
 =?us-ascii?Q?pbHy/fWgNVQe6UsXNW61Shl2KXhOYGCjmdfY3vTGJ1wuaQDzBly/BGyoTxZP?=
 =?us-ascii?Q?pNrcaXPSOfcdopKNA8u4bCG1jwl/QsC+twY/Qu4lOlFh8UAAo9QWrhBau6zf?=
 =?us-ascii?Q?GwgrTa1r7VOy9co0rs7Jl0K97Y0wqbTHJBZU60DvphSJvla5/vsdJx2Q4fWa?=
 =?us-ascii?Q?vF5rSE7aZ97j35oY7+VWydpKsc8ii8N9HePF6vR5VnZ/wY6xae/MUDVHInyy?=
 =?us-ascii?Q?8PJ3dw78UOZ9BEryAMHmWPxInfN15Ecl4910Ru4dvyKeex/SGUDL8zQtLqHx?=
 =?us-ascii?Q?Gpgl6+YpGCsoqmHuXyKlflPd3ZNp2im0eail8SKZs7Hk3f08d/FWSssz7Ril?=
 =?us-ascii?Q?fj2ymR6cq7ZZyuPtW3QKgzFzwvZmIFntpJzmzid9xN2GnWQAASROzutuRSSa?=
 =?us-ascii?Q?/EckkwMCoC61Y7vPRMX1P6EyZsOEPLuzZ1YWDzSI+dtwA3QNV9iwO+PUISQU?=
 =?us-ascii?Q?ASD6AEl6KsVtvSmjtcmDQ+Sl+eF0Pfd7WUON90v7ZGENGGkdoyFAM0gKlh3O?=
 =?us-ascii?Q?LQoCdY8StMp5ynfe+lI/Lj4jlOFc++oozKsInxLM0zQSenEVwR7Cu5EOnw9B?=
 =?us-ascii?Q?TAbAmLB6Aze0QrIFMqg4Zw56BIbUGThp6oD3k3pg03LD1NgQjQLFHrP19EXS?=
 =?us-ascii?Q?WnKzH9D8CJaA//XQU41oxehQHw+m1xitdGgN0bUF3ncwQ9Miw4NhpSeUjB0K?=
 =?us-ascii?Q?QZHZBUvB/mH2fO+Zo/4/H/bMmW4hEyTEPIzNAFTtpah2onNF1kNi9yIMeP4p?=
 =?us-ascii?Q?4sOfCiVVG6jBS6FbiMGSprZxwwbOfz1Kzp60/iHialEWrNLdtO/VboBe1Iy8?=
 =?us-ascii?Q?akaneLo3blKBeKyip88gXzTUsMqNpipTs8GH5/vnlh7xvTvuLMiveN9q231A?=
 =?us-ascii?Q?Ytm2hRh7GCNiEyTSsfKWng5izUvgu4zwIR+OeNLquckb76069gISigem7D/9?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p3NgLcilEbGfvUZlrElFspxO6bLlIAgsiXrImN1k2wdsW6yQ7KETGXXylrWaok6NaKTamg1MOCeuaFNK8Gg88MMbPhbR0/X3Vdiv7sPRnxSgWAqROEz/bReDz1RA1fROl4omM7TBWqmTS/CZX4bEEbYfkDp1sw7Vbjwiwo5eKRliQPbkk2ustynxsOUxzsL1l8+SKYUlTMgpExRnjscXchho4HA7Xo87RvMa8mKVjLK2Pet2aSzATvc/ZqKEWlp1KyLBYUI1c7ZRbz2aeT51FqNI4sYaXWjULlv3ner4i4N3HrOw4zkdB0+uz9kjeEWA7maiqYczTnZXW5uJzXqVLQXv2wXY+lV0PhKfQBB2sWIuqY64m4TK+YstZX9qNcftHkygoZwMyAKjROVqwUtFE+yux+fA014ZOGahq0MnG9glxddCrdLLshMq84B4KJDmiN9KFj+6/KdJodN9vGN5cooYz1wrN82agUqBzaVsIjtqhBw7v3f0vqIexs/UoYvlNrOKyGQJTcbsHfD4zwZ/TH0ESzj4se3FVAw5lrBWVUazQ55Z347xeU39wVFqVo/M6FYNNGXNwRWB+jB4nd8BA/HJybBgKlNuqvkiuVZ/qUE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b3708d-abfa-4e5a-25cc-08dd91c58a7b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 02:26:17.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2qQlW9IdIQBLDsvKPk5Zy+Zav/iOq0uGaCnCzyAp/79jBQ//jGrcruRkhc9QnI9/o1yStfT2AQgSQQInLrIjS/f8/CmkzYvNjV2xJVYKog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6099
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=671 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505130020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyMCBTYWx0ZWRfXzooHKYPzA5Cj sR5t8kpUAI9ctboBaFMfIlJLFkedQbpNBD/eGGeTnkQkSFCcPrRReSlzC897bXs2OMPOzWONa3Y ssBeeR3/OgKbruYMScU6WMZ40jKhkuXtt0wswG4SCNTQBplzy6ump0q7Oyq/dFKvZC8n6kmAF9f
 K8mTC8lCC+N+biVe6/zKTNn9ZaCeGXzXM0ukgxV3SsWihe8hD9HqYfGij48LgJ8iIQpCEOJ4v7G FWRTXrEfOkHGKreY4+zDjta8xi0Pqi45hLT30eRZhEsfbO9OxhRTcXQNkhhNEh5necrwOnKJo8W uBXr1cTUDv5txO4Jqvo7xYtkt5atW8K2HNEg51ZE2wDP10lJEFb07pTslneK1gf1stXGN4KvrQ2
 Y8f1meLykkljcJ15d70cBNOvoJ0VDWflouydmMtPhq03gWCrCB7NfOBD1iQBRsOGwdll+Zog
X-Authority-Analysis: v=2.4 cv=YJ2fyQGx c=1 sm=1 tr=0 ts=6822adcd b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-GUID: RA7L9AGQ2DFt9ZB_1yjqJa4anucQodJ8
X-Proofpoint-ORIG-GUID: RA7L9AGQ2DFt9ZB_1yjqJa4anucQodJ8


Nihar,

> `alloc_ordered_workqueue()` accepts a format string and format
> arguments as part of the call, so there is no need for the indirection
> of first using `snprintf()` to print the name into an local array, and
> then passing that array to the allocation call.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
