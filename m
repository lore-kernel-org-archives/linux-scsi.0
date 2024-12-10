Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB0D8F6D;
	Tue, 10 Dec 2024 03:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733799703; cv=fail; b=bSRQtB/F+SC1zJMyoKEF9/oFJNJNj1YDhio+8rGEaBH5K97R/GZyZke2GTkYPPnXYyKIVYbUu9l+H6dsdvJnHuCTSxJGnTeWObEpfNtokwBXNVI24fHTmWdDQvdXMPENtm39qK6zG2ufluYb6p8iQusLfI6QDRA0qSEGB/F6q7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733799703; c=relaxed/simple;
	bh=NmngPX7ySfORIkUgMDjlMpp9MBPfqcDFw/HN+tLlYm0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BEFf0hMWyxx1HpQVazCNhBAtU9ALu4KtY/WU4Z4BrOXaJ5i8hTEO4CfoBCgHT3Bey5RzgDJRJgLp8NHRPeEoXjnVLQ5pAdm5aXm7sgtuwNWkd6/X9K2Q++28nrbPwk07s+kq0RlQSFXkNTA8pJQWO2T1Z2dywZ7HOvb6/ZSeaPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TXHZmwBD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Mm6b50kb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TXHZmwBD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Mm6b50kb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1BvQh005043;
	Tue, 10 Dec 2024 03:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=DFnN3//pDIcFv5T5F+
	qit1z5bgh5rVnTug0rGbIoDLw=; b=TXHZmwBDSvqst0flfZmDqnSCqJi2pdJSDd
	CobGWdD6Ere0tmH1EZJ+F7TSsjj+FgT0CgHo6K/Y0sEFFsoZRB90zJfk0ERwd/y5
	3tVh2II/9ulhqHzgzqegOBm4CSKpSb6cxrtdZD+ivMqWVYEaIvnmtfIIO+9bCsWq
	RsYgMyCrwNZjDuq2PWNTq+uYvznYXTGw0iRUAkdzpqMZI+6zlYhO5G4PnNLzeBNM
	yX9IwRAoriT9qIZ9URSN/jClZljz0+hSNbk0+HVDBT+xrm4/QOYeVNgrAhBd9Sgu
	50QcvYWysO4jKq9/OODrRa5yvD2ObNs3eWFXON1aE2WCqC/MZXzg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cdysvpm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 03:00:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1NWxK019340;
	Tue, 10 Dec 2024 03:00:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cct82scf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 03:00:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Krs5SXKhwo/qLqyHd9SOchYjCRAt52z62PdgiMYvE6x1UGmcUf4yFO53VhmQDH2eJq5Dgb4y2SVIN1GIJXG1yoeET9iNtKei421yGzq4JZvku6DbHfYnEYq+2qbPZJe8NOr53mniQ0H4BUxaKfcadT+KPviRWKaG6WkdVSNbMJ+CseX1bB4fB4RbtXqYAiOlnT/H/8ui+j4eob2+075wIyDtKrIgAwFBv1Y9WoE/YhZd9tIZZyz1/tsxMqeBLhyCmxShrV8xzPDwgTOW4NQ8HOPSiMJg2WyziJuYsMKTuH4Wfo4pHTMGJwWlNr6dmQy06HY2C9gsoLGF+R8y4hWTIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFnN3//pDIcFv5T5F+qit1z5bgh5rVnTug0rGbIoDLw=;
 b=fRj6DtxXbIxxoUachmfM8t2daJaxFuA7W4j7QEbVmz9IS6TvoK/y2zrSELg0+00dFuyexwPtCdz+RDYbwyqs1TszBTWo1EkAUHbo9ro+EnZsITuN0Si50xljNEaa/7cCkpJNfbgHF5KM+59cMB/UujW0SF93Tvih21DnSEjhMYFMynScjlJ6ZPYy0CNoDgjZy9hsXQN4j9qb9rTXxeulg6+ccsl7yUBB/Cy8exjeX+T411kN6AooGL1DzL3w3FZ/ubahrW5tkihPOEPbwejPd+vARF2beFOiRuZ3mpF+ot/JoQGcF9sKnXpNXiFYaNwRGY4tBd4nNbAzOQ6IerOj4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFnN3//pDIcFv5T5F+qit1z5bgh5rVnTug0rGbIoDLw=;
 b=Mm6b50kbXDABpBaCXWfof6nt8DEhdgq/Nu/WavfB98/vHps+0kfSCcy3X65ZuwXJEQ9YQAW4Wg5g10I0VcL7t6nY36vrojLSC+KWi5pTvyqfrYaDLBuAk1NWTtORPzylab45Gp5dxIBDQnr6lr++SzNOCegf3hTrYdtT1FHxGoY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB5566.namprd10.prod.outlook.com (2603:10b6:a03:3d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 03:00:50 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 03:00:50 +0000
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        Uma Krishnan
 <ukrishn@linux.ibm.com>,
        Oliver Neukum <oliver@neukum.org>, Ali Akcaagac
 <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        Finn Thain
 <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        James
 Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela
 <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        HighPoint
 Linux Team <linux@highpoint-tech.com>,
        Brian King <brking@us.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, Michael Reed <mdr@sgi.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: Constify struct pci_device_id
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <fc61b1946488c1ea8f7a17a06cf40fbd05dcc6de.1733590049.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Sat, 7 Dec 2024 17:48:28 +0100")
Organization: Oracle Corporation
Message-ID: <yq1zfl4i6nk.fsf@ca-mkp.ca.oracle.com>
References: <fc61b1946488c1ea8f7a17a06cf40fbd05dcc6de.1733590049.git.christophe.jaillet@wanadoo.fr>
Date: Mon, 09 Dec 2024 22:00:48 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:408:f7::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB5566:EE_
X-MS-Office365-Filtering-Correlation-Id: 062956b0-9734-4d08-0efa-08dd18c6da5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Z5dfz9F6rCG8UZ2di6AhhTiY8ku1iIvuWFY8f00BAyzA8Ofpnj50ntu+rjw?=
 =?us-ascii?Q?Aka2abx1eeTgfghtJ3pAdD3zZcXWsJd29FQ3nn40qGdZU/SL22xuv904Ssex?=
 =?us-ascii?Q?JqOCtyJk+kisi3XGxt6fpM/O5b1fz4ifY6gk6DGOUmOFU0HaA2zSXLrFqOOL?=
 =?us-ascii?Q?GSrv6I4WjLJGKGk1BrGybMocyLwvkS00xYHEwVE6IX+VgGnxPwPTa0K9tTfJ?=
 =?us-ascii?Q?bSJ6rYTOWiRRLg0ZdwoDIx5TCVlFczABqWl74YSc4B4AJ17QJ6z6tTpqSQT6?=
 =?us-ascii?Q?vwGyiqFLEzhlAySjr23oonNb7wpu64pf6eOAIhv5d1XIG7v4Dhc/bedAmwIU?=
 =?us-ascii?Q?X1S/V1Y2VIWbf+snJ0oHkaPks55IjbX47wW0dtUZQgBinXBB8goZIZ6lE1RY?=
 =?us-ascii?Q?2J0AyP+pM0kokmamwbKz2uX2vgMG73DeEqybCzVyQJEKQH9fW68KDIhfePUk?=
 =?us-ascii?Q?rdX/Q244qtF+wdjzsuODoaf/Qgj5QCTWiffbplbaNUtR1n31i3ljE8XH3EzZ?=
 =?us-ascii?Q?O8ZlisBo+r9JCvQanfWjrr/EfGjoRmfGrINWG9XVlNiTVynt1/RD+sSh3Nyi?=
 =?us-ascii?Q?uHP6lmXIqm85EMLwLJ0QTVkI4y9osVyeA2CS0rkhZz6dkX44vD0wQjvFwdQe?=
 =?us-ascii?Q?SP8c7ZmXHlzwDvZFMTXm9JJ7+F7la/T7TD99fH3MiPWNh/2qkrn05ctvjE3X?=
 =?us-ascii?Q?toj6Saf0Wb0xSdV8SZjboKhbFmJiyyw4k8VUsdDwjo1rzQaBTMUWZGjISLHD?=
 =?us-ascii?Q?Jvj5MMjUZF2i8PUoTNOGnAgR8QZglHJ7GkU7gzaf1EO7StrfRmwYeCVFvUar?=
 =?us-ascii?Q?el903uXnNvY53CAveeq42E+LecCDFFhoWYkHOhwGjwafv/dTAY/ctY9P4Y+p?=
 =?us-ascii?Q?SYiJkAwh9lGhmLo8V+jM8qzkjvx3xVbFtcrjorHHJW6+8ibyrlnsR7/BhMW3?=
 =?us-ascii?Q?9AQIg/HZ5T2E2wdoZ4zFcCZRpBIt6xFCvxfamV6yistn4As2bLQXf/SKJi2/?=
 =?us-ascii?Q?c4uDjvHbJ9bkTyjVO9Tsf23Wq7nUV9S1tqmPGPKlEpjPxFjAPCpL4zSDcck8?=
 =?us-ascii?Q?qvFFhhEtXxOf3w4XfITHoLfoe2wYWy7pVja0/oRzojk/C+Zk3/Qosf1fX/B7?=
 =?us-ascii?Q?xRbomrDPsfb71CvrwqMRgvyg/6z2hgTYYYLO8dimY/sCtvrXExkwE1kpZbT4?=
 =?us-ascii?Q?pMGNPQsRheQ3PQOTWXKobYWnLV2MCFRfq4K0ggtl4rEd17Anm+V3khUGy5Rt?=
 =?us-ascii?Q?mO3lBZ/TVtRGPMfImo15/zn/Nc4kMX+EwCYBmjcuGVz54RCyYu379c8XuV1V?=
 =?us-ascii?Q?89hWnbA+m1CO63udpGbFjuLLyqOmN6cvOulvsY81MKSBsg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NAxMaE3wFOAeMbGFK65k68ktsoP2GGCbdW5h990niGZhI8TL4ZDcwkOOW4ZQ?=
 =?us-ascii?Q?o87DwYOJ7RBAYTl5ICuMnLhvQUhxgz9ZgYx+n4dNXBSfIP/gc2EnNHpDDH0F?=
 =?us-ascii?Q?OIYWTCEmT12VONTdsxQ67qAGQU+vg33xsHVBty1UpysUA7Y66lAm5jMkfHvl?=
 =?us-ascii?Q?cPcF1/MOsuddyrdWBYfd0nqojQjTUXQbhfI+YASKXyfn6Vs2CT6VN0jOHZAK?=
 =?us-ascii?Q?QrMB3PS/fF1ygQYV5brzNK/ieVz9CAl3uIMCB2aq4JnVufA9XhIUNFrbhxfL?=
 =?us-ascii?Q?z7dF0XfwUDnMwdw0XRznj/J53WgjLzkns6RRaMMXQAnmW/GjRo2f7xZH7gkV?=
 =?us-ascii?Q?0LWRkshLx7x93oH046UQSyHuo1DLNkeyCLsED1bK/YyUcoM70/vUSHdqv4Pr?=
 =?us-ascii?Q?mj/x6uKea3Ygzq5QYHzpPFjoGPRE1gLQ5V3JSOXAkWcSNEoDY7ad/RKFwppJ?=
 =?us-ascii?Q?ZMct9aYpUhKES8Zmev06QbEw3Ul3zk5Z+4/zr/wm7OW/rDbXQUcofdhcrzMs?=
 =?us-ascii?Q?gLWiyP/ih19PHX3y0HfYIjKuRkaseDF++AtvRiZLt2qvZH4jGe3b99bLrQNT?=
 =?us-ascii?Q?Im19DdPFpMrmtB7giM/tgUfSv5gM0RutYR44eB4hFV06uS7ccDlrWrhA4caY?=
 =?us-ascii?Q?C/m2m+P9yG43GSp9TcBGUK3+EqfJmy0z3kKsz8pDRRsfbkjbu6xA01XrzqjZ?=
 =?us-ascii?Q?KaACVGhF4kxK4H+PphSaNN5fesgo0f6At9lPdy5nWVY2dg24m/RrmgUJg8N0?=
 =?us-ascii?Q?O2Y4zVdgXxt8/qxGTFOYT3JxSTzE71Q8M7pFXfe35uQ4mkpZdrA2SvyE91tR?=
 =?us-ascii?Q?oicagPh6O9gLqfvqwJF9giyPl+8MeNHUmgWgaykoLrk+ewEanrxByzV8vqfM?=
 =?us-ascii?Q?HBkpbky4Bof6cmYhbaHgDp9HvYhNRc60qg6OqRkq7Yl30R1JOKYAqeH2MTiq?=
 =?us-ascii?Q?7bCGOZ+KWEdIv0JUWUW41WmU5QwkJq+9FPF3/MiltBoE0STWV2Fm1MVg4LkK?=
 =?us-ascii?Q?AiGjSCJtLzPaw7kPWCUbklFlkg2rELx5TvjfMEr5wWABEpSFUTeiQ+8brFGw?=
 =?us-ascii?Q?OBk2soBPBT8PEjZ58lQH9jl44z1b7t4mk905dcggyJSDUqYnk/Lln6jwk+KI?=
 =?us-ascii?Q?u2Dh6utqo6bZKgORqXy9hnEpHJmNSeSb5QDbFB0qZbyr5XPsBG4h2cjKASsx?=
 =?us-ascii?Q?8GiTdmmAVomlal5Ba/ovvRJklKQMckGOPQcGIzqWuEYFXFjKyoJZsNoPsb23?=
 =?us-ascii?Q?4rzuAJ9bGEfaoBcz3gF7NHQvpfLPykDiOrtPCXpXAO5o1zPKQCqm1CnU8GL1?=
 =?us-ascii?Q?KEc9kq7eSbl8sCY7/cjRCVpFeJoj5M5CHA5gYiOu/O6GXO2ziV1U1EZtkGci?=
 =?us-ascii?Q?A0Z03o/t3zRPAdF9I4e6SNDdVNW/agDi6wzOACJMxTJIe7LN+RYU9zpf3GvZ?=
 =?us-ascii?Q?YoHxnuqU2SW6228an84ZNGkdiGJN1q/n8np8XaGP1IBsV6uD67ZLJa66VZmk?=
 =?us-ascii?Q?T5zl/5ORO0fOv0PdKJfGkxjzHz6o50CY3em27MDCYxc/w/VGNlaxFofRD4xW?=
 =?us-ascii?Q?/Q01NlrrAH2ucxSEguk7RVcERmDsJH7KJrlBCH7zOjNx0jMqGUlfbW13+mBE?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3SfVJw93FnzxIDNZT2GhdhBnQkLGpIVNk/RxbJyz2Mu+07o7JirbeKXJkYV5UGB9bxJDnuSJodnyDG47L+1syMNdOKHaV4Wioa+lZ/PwY2sDiToGldPreXxbOPJVBEOlMsa1eYhsuybJmghjtCaJnq0V6VVFd7J688ALzHC+AzE+4r1vsX1Po966nTyS9ThQK5Noc0BTZBO0kqs+5ptlm7GGpIcJma7zoq8zYRM27oNRHfyyfRMb2xfkn032BH+O6mlWizQi1DjBmACr8+AFJV7GDRkPAuLbCbrh4f6onhZHz5YSun4quO0KgAwjMssi8PkDMjBoG8gQbUVRvw41S5Xw8k1BNeGB7KGYUrN0LtxFJSPSKnlWy2c7ysrTqPB0v3DNNPSHGsv7+drwD3f16xTYNlP1V/BGiy6V0963+VUrXATN8JpNSpU+zmDjBGzMcyJxvE8LUUIItwppx//wcLmLJsl5rxV4Yi7vLiMWy9z5qTU4ETHLG5BBsg0PXllX2QryRvFMGxYa4UrIpxZcunsij+Fs3IyYdbJMDGmdndrI6pWXZxYDXw8aBXYq0JeX7cPYc2WZqPynXV2rwIhPHZYAZIdk3fKiqx9+xHmRsME=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 062956b0-9734-4d08-0efa-08dd18c6da5e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 03:00:50.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ka7sLvseODG3NCD7K1t6rnmWze1BvHwjCFH2PaAsP3AzXOqH1vAQgKNZa+/YoB2BgsMCFzUH3I+8N78ZgsR6UHsC+KFx3QXY7p2XFhDCfq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5566
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100020
X-Proofpoint-ORIG-GUID: ggBOL2UYQ8sjlB7sVNiILFMtjb-FVPbj
X-Proofpoint-GUID: ggBOL2UYQ8sjlB7sVNiILFMtjb-FVPbj


Christophe,

> 'struct pci_device_id' is not modified in these drivers.
>
> Constifying this structure moves some data to a read-only section, so
> increase overall security.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
