Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2050097C
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 02:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768185947; cv=fail; b=ZURzSdTv/PFzWA57GsokW88jlIQyKhB4zxwdH0lrrBuxb7r9BpbCtj5wWF8pzWheEAXKRqVkAOMtfTZ97QFFItOh1n6pxovddxK/7wDNiUmoFNEoxZRX8eS3DVly4c9xsacZHssP3tka6oKuGrax8iaz2DrMh9eS5yp9Rv1Kxf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768185947; c=relaxed/simple;
	bh=HMBM2dSAh1MY+r4i37mWqNOO3W5Sb9awGxwFU9O7tXQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eV3H5Z4XvnhFI9WnN4V/70GFO3XNumUZ9/TExcRP8aOTNjxhpLkXh6hxx0VJANKmufrRhnV/Igs7B/00eYxJB970GUD6lgQc5Z73GUF3Ds8YxMlUM0IbfW4MtaMLiSyRdV7x2rd8ALmJPLo2f4aHmXcUgik45nYQE3PObX3PEPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZDXtsJr4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RcWjdmwm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZDXtsJr4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RcWjdmwm"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C0nXjF4138132;
	Mon, 12 Jan 2026 02:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2nkHCa0mtRz295W+OD
	bdBKf0sEgxq4a9DgA4NcNuKJ8=; b=ZDXtsJr4/mlan1Hd8LOeWu5jbF9gj2By8X
	6MB3tWzGUYJIGhIPbfWGNQDONCMgwuibr6Fndh/1pGkyv8ciJS+PO7gkOOwPPIaW
	vwXkDcLMdYyq1dv2WJ5mKE16efRkj9dcdTJv9iSoLaI180reCCyFMjMmy9ZsZl5Q
	BTcasowjW25hojFgABjo7elrVGOY6K0azx9rbyPD3EKhu0q2vtVgVDLjtpowbL3U
	kmaT6vz2WnmPTLPIkLLdHZN/A1WZiIzM6Xte2sUmQASGhnE524KbX1F0GbUnfEnD
	tZ0ubIbVyLddaA+/sjrLG0sviYRS+HmOMDZoTK5oJ7C7k3/+VPCw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq50y3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 02:45:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60BN0WaI000493;
	Mon, 12 Jan 2026 02:45:39 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010068.outbound.protection.outlook.com [52.101.193.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7and79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 02:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ixhfODhH6v2+gDxkMqv0DRL0WgHqmSHcZwRXSJN+pCVZEzdfx2wfJijofUfQ6gjTFUhwb8cqultCB5sy6cKJg22adCtGQGmsZJquCba3Zpn1GixF4yXKSuT9Y8nT7PSLwnhip1NszKatrywi8SUhmtm65mrxKDpwIDKPhpsTqDM58D6TXD7yaDGo/ONfO8kRRKVqxzB7/vNYPxGuREGQym9RKnaQBJsFrh+HwlfPtt4o09O1/6yZg0d1N5s8uzHlJloxnZv6uRWK4UcMwz/27MtAgTZi9nSS+I8LgGlNTKlUyOBMA8eNR0TnDkxgN0intSOv0THHQWCqdjVTQq+17g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2nkHCa0mtRz295W+ODbdBKf0sEgxq4a9DgA4NcNuKJ8=;
 b=u44iFZrS1jc2WWHmTiha+1xxJ9CmzfcoSgPFM4Oqfhd10nayUrM6bCCVjf+iIRz5y0DlVjJTOa2vgtcMOrbI0VA4UgsP1757G7GwrYOcnp1ID+AIxFCP3RoJe9CSZ+NL7/C5MMu8D/beJENlEWCwiYTPOW8WaFK7rVXslAxQoI0UmUTpqmenR3W4ppfPr5/u0cFLM36SLAsgGcYKvh4ZdX4a71alpks7pVYXcYzBBQWs3b41iAY/L4zdeuiahQqizT6C0sF7XhtihIeiKmNeMqxb9GHczaTySLVxyuJHUJsazMWzCc2EydlNRnYbHyicpLlZJAs1fapnML16bwxbfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nkHCa0mtRz295W+ODbdBKf0sEgxq4a9DgA4NcNuKJ8=;
 b=RcWjdmwmtCIDNRmfkCwBtOc8shhdVi/pIQdHp9lp+u4OfS8R8esP8BG7B5jlNg0Ms/0CoXCsTFTN8UWuTT/UMKspRZ3IQXdFbxAd6m/1uYCusnaEe0gPefHt5vZlzpj9grV+U2h5mcMjjSfv/7cWpuMvsw6xXtMdpLiYqGnLt1o=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB6841.namprd10.prod.outlook.com (2603:10b6:208:437::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 02:45:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 02:45:36 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Clean up the SCSI disk driver source code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260106190749.2549070-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 6 Jan 2026 12:07:43 -0700")
Organization: Oracle Corporation
Message-ID: <yq1fr8b5z2r.fsf@ca-mkp.ca.oracle.com>
References: <20260106190749.2549070-1-bvanassche@acm.org>
Date: Sun, 11 Jan 2026 21:45:34 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB6841:EE_
X-MS-Office365-Filtering-Correlation-Id: ae83a026-3e8c-4b24-6a19-08de5184a9e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UXP+U7gsm3/gJSnqHGOPyLjlyw98OEYzKUgWa7NBH0mJ31O6JuJIO3E7E/oY?=
 =?us-ascii?Q?VF17kNBZZkucCKfrkCBlf9dAWaJ/sy8FzGTCe3FjOqYXlJB+SHq6b9eoKCTA?=
 =?us-ascii?Q?6w/NFEtyShoH3qKxiUkTJpMrH819I6jwj14XuknU+uS/CXBj3fDyh0sUckc4?=
 =?us-ascii?Q?mBJlWcTBx3sW2GaCrCCQZo8dyCh4YYKjDbSKfsvXN0TpC6bD053C8sO19Gte?=
 =?us-ascii?Q?+i5UQXhyWJnGBfWnRq1WzloYnhJTrUvEAvT789hdjMIXMcspA8dfOIbZA0Tc?=
 =?us-ascii?Q?EqAOdNZV4jCaTJSeKwos9uDsf+u9Xk07NtOY3HYwmM5ygOnEMcs6MN+3EQn+?=
 =?us-ascii?Q?5ttoYmTUJGP/kwGf9TBV6Fm6M2uQJUgPVZIjZlt9PpiFxgxhHFU7OBD6YE4D?=
 =?us-ascii?Q?1xt58EpL6/3TCKIfbH6Qt5olH+uixJm90OHmsrOYgevyvzCk2BlxPjoXf99a?=
 =?us-ascii?Q?GUYeHa4s0H7TgH+arcNBUAVPWPrV1gr0XwnhXK2yfuLe7+LEjgwmKrMEImqC?=
 =?us-ascii?Q?oP4A67GNM7C5PLGu+VSuXc2RFayiXghJm1RElDc0pH/oCvzcIzKyQUkh7ZcR?=
 =?us-ascii?Q?00CkDy7Fuaf22+NB9BE7MOyVjyIHslmUmt5IEPAa9QGv/8F7nppzvJFwqL28?=
 =?us-ascii?Q?8o/gGrLBE2kROopWEZ3Yt1u3GGVdgsgMEYMB5uqQhtWeLDZDq2AjTHKvueF6?=
 =?us-ascii?Q?SdKfTDVpIoGpcyEBDsczAjj0xx5InNtM6VgACU20y+jf2PnSb5uBLbszbJEE?=
 =?us-ascii?Q?JUGo8k/qUU9s/g+eEn0xj4vF1tPHfge4mKuHeGVwHNXYTLbtc2Gtq3dlwazY?=
 =?us-ascii?Q?PXKdIn0uROieB8KGhY4nx8oKtFua/6PRTgurqX1F5yhf73Y7Mq/YMIcSvkb4?=
 =?us-ascii?Q?CdW5teKkSL8d2fQwL9IpWsTFHAeJaoBQqTNWpxq8LW5B+wWEV+AiQK155mtB?=
 =?us-ascii?Q?Khs4kSHNIwOixAykbcSq/mhzClWkzJ+R4SrDTHSkZaOuHqE70lLUxOdCZm1R?=
 =?us-ascii?Q?qdTRr0E+qThPYTYmhBKwbJfaCBcQlgMbyfhXeswrKxo+oLPK5hMEV9jv8hv6?=
 =?us-ascii?Q?7z8836QXe758Hm6yJVFFHMT/Bd1XtJ9lktw620ZowPexZxxkvrP8Bgs6X3k/?=
 =?us-ascii?Q?h+KlMyFvVhsf5dF3++hn2XAQmiGmPM8dZytnqLkOVmZwHRYygaKCV0pW7pJn?=
 =?us-ascii?Q?2BJjiKee41m+4Xt4YXaTrZz3nyjL/lvCgJS74t/9nGfViNYD4AdhtyVXFmMI?=
 =?us-ascii?Q?HW0b3zl+URJUhJXExN9znvhBfL8ejUJzeG5Rf79esTZeyDuC86ibfuQkMJNd?=
 =?us-ascii?Q?xFB40W8+B33+KEUGbnWYBhnl03o66GdeWR6hLM0PnAFmecJxWYVSCqQOh4Vy?=
 =?us-ascii?Q?wUV86dnnuNx4HNwPnAI/NV5THEF2zDhFY+DMw7CpteTBrZmONfFOk3N+tw0Q?=
 =?us-ascii?Q?MVDQereR4ECsch1EcyDWRP0wXROjrlsx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GfQqTA+iZTdrIeLyGsE6gk8oyiZ4v1+B+UtEBuf20nW6ItUhmtW/AEmLE4Pj?=
 =?us-ascii?Q?SMGRqYdi/aMENjlvaNwePH1wi3EJoBKoIW+OrdxImHODagB5uZyX8CY/BIVY?=
 =?us-ascii?Q?m6kSZMj7ZjBtdun0ZHAnSAq8VZJaNw/Tsp/iTuY+ouZrTv/nlCLp0pIBbQ7J?=
 =?us-ascii?Q?wFA0lOZGNfszvJPr7NuSdHKxjw8yCp207BDSVSELRYzPQyyDvfBazh6EFlUP?=
 =?us-ascii?Q?DsF2+LatO969aH443KIpnSRgW29kQtqbWJJwUrBI204pcTMgLNyYmpEqRNRj?=
 =?us-ascii?Q?Pa9xoklbJgn3ylrFivHMux27eON+DTKeHaepP3VaNQ6s6lL2cB+fGWDC3w44?=
 =?us-ascii?Q?4X5DsnBHjPIPMZe7DoKqWpEgfbYOHK3M6wZkMr2crWCB+X62Now7bNRdjhrz?=
 =?us-ascii?Q?4HgcqTOOOROeKJs+0BPEfW1thW/unVK1W0wnX3eTHleoCFo6oyjaKToXPT8l?=
 =?us-ascii?Q?cXHsdJqPmmNSJQEaVax8XO+WJR+oGhtHg4v2ZEqCY1mwAG3d77baE4vkFjuZ?=
 =?us-ascii?Q?c6wIGoQZaFdG2FqbSUz2KHv3TTiIE2253ww4je4Xa5z5CUMavaUt1cmWkR5w?=
 =?us-ascii?Q?nNYDEMAvVXtfwNELCt9BdWK/4n8UcQ2LeSAL1/xmS+cg4e/MGlOzxqSSwpft?=
 =?us-ascii?Q?yOjooUPVsebk6d2I6Olf5tGiLOnlr8cxTJi9UDmyj3WgsZyEL7EeZgjRsBod?=
 =?us-ascii?Q?VHvscLqYo1uofsw4uhG2xXSXb6WE7Pm2m1alQ58yO+9bYOC4BUjcy1NFAVhk?=
 =?us-ascii?Q?GhnbYmg0FjuVHXmpuSCYYercbS/vcbNScs+h7gdw2P7OBnzFLBN86Sri5wW9?=
 =?us-ascii?Q?e70R4E+M9jvlhL+Fv359ht9n3vBtwNRXlyA4nCSyuhgL4Mox7Ingf1f/xqKf?=
 =?us-ascii?Q?Vk7nzTJ2j3SizOOb01dLoyD60afd4IlozjakIj2eT1iARke0dS6f3vt6NZXi?=
 =?us-ascii?Q?/FkLHOB7aDHYe/2E30TvbINIVYFQPEJRXwX885W2OyFPZSNg0T3m4fy0L3An?=
 =?us-ascii?Q?bAmIXYbgU6SS3PNfvfbZGWtyZ16zA124Fn687nKLtj6Tty1+iQHN1fgpLAUR?=
 =?us-ascii?Q?c0QPAgLnClc8i7njFGH4RoKRlUsBhwntMPNQfOA0mbSyEOWAJ9cq4gHZ5S8O?=
 =?us-ascii?Q?LfgWMBM1G56GdOLfDjGiiPg4d9KJTa3eGS8e6eu5qZOfF9ZuRzvKt7E0XETV?=
 =?us-ascii?Q?qbQIhxzwvWLufkCp3DtT4oR5LbaYt9IkCG4YS47YsO7ZveVffSWRpQTZlxcF?=
 =?us-ascii?Q?xJgfS9nq+7NEKmEBhX8/2a8pE4nHeJjppjIY2+rlK/eflYzFBti0M3VDW5Uj?=
 =?us-ascii?Q?EgfHhFjaDEIS0Sc3GIw+3KVGL043orS+kwoOb8VJ3VwivSL2D1OsxY7v1AIv?=
 =?us-ascii?Q?N+Vb3M4LfNPHlNTNsKXWn6dlFrGS+t1OmKmjvKb92NXX0pLUTYRYQg9QdtxI?=
 =?us-ascii?Q?mhhTG2A+iliBGGBGR2ujkQm8vdwBwa3fhk3/elLbmV9qxc7hukR1Lc+KdYFm?=
 =?us-ascii?Q?RR2HbF8s4PyTyrxOuOqCRz/KwgoL7dDHDOlJR0RnTjNxzkA4jCqb6yiBv6MY?=
 =?us-ascii?Q?Gu7m3SSxLsHRpkN33zXfUeqShzGKn7iT9bs6nSgtNMEBe4ikAtOIZ9fZfyvt?=
 =?us-ascii?Q?2wdaGiy57D1MtVOx6J6rAghbF+s5gTksFdOthS6IJ4iedSMXmapfCs0eyQAu?=
 =?us-ascii?Q?gLPlWQ+h57DeBrFA4SICXvEOmxeog7c6wAV6/a/8Rh1lF74riQ4cZzV3FEB0?=
 =?us-ascii?Q?S7mKBgwt2p1J8CRgCivJXikL0ADb3rQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lxQAjZyUCq8SybZ6dS3XZM4sEg5upZdN0UVRwNCsv8gsfCLv1/NZGzhVJIKHM8ilmYgJ4DoRowrV3OYwwWsQyet2eeGcefrK4N7qFm7pcy2wHBOLy04hH1jU8L5/PLiPGOZzuU3x7rmd5aKBrl4QUa7WZkncvH42IUpiZvP9VVhRDIipPO/5gogHW5NTlbPCgtFLSBbb48ueFyib0iBqdwqSA3T+LdZwHKRP0GIAz81oiIzVjfAq1nPrZlcIihlEEiwtNpH82lHbn/+n5aYLyjgOceYnzid0L9w1dsSplk8gXxN3kbeQCx+kSzIS7DqxlfoZT/xMDrULsmtE323n9qOVAXSATNUTNhRcHuNZ3V8Fs+UuuGfAJPjiM+aSGgT384SFA2klnx9310fIVJ9/RlGeGPP1NJj8LqQOHKyYuqOmodSVn9Sih8AwXwzbPACB3AlgbIw1Pea81f2Ecl+Vwz0GlDDAcXX9ajOFO6T2fuGAJhCb1wJeUynbYNgPJCdyuXn9BhUb26gkMWJwnsSCZWTSLinJEnkiVnoU1gjSuqSR2236nSFO4bzCHium++rmmY9bq8Hbtmym5kJFo1JM6FyCDdzDMKsSGmZXPeI/j6c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae83a026-3e8c-4b24-6a19-08de5184a9e7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 02:45:36.3241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0RvB2DGfZQvopS+Y4xuGN3KbiXMXEuICWMvVIPB0yJMTOLVGJclNx70sB8FPsGSWYP9rPG9nUIPyRZRpL96SzVNG4lshp0X0fYHmK/iHFgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6841
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=569 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120022
X-Proofpoint-ORIG-GUID: PRYYhm3J-dltJPFPtjrqyTYRWEiNL4nd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyMiBTYWx0ZWRfXzyy3Wvdyj/Tp
 FxY6dUUCpaapL1mjVHs9zXiz/8cOxqMJRmDGWJbEgo7rvWSmPZK72KlraR424ylJ4/tpFCHVcx1
 RBPuzVIrhFQkq4YLmeFfEcgKvCoeRlCCj/K1G5cRnz5KZZQkA4YSIQpb0TkbHvKRP9RpaQRNZVn
 Uqzbl4TWWj9aDScMHEPYBg+S0puiV5jn7dxKXld3py6c/+hu89AtZaxqK3Ul3+0KqWHtvMv11a1
 BKx0FSTSHOE+ULHvRzTsPH2072SFTRyxUKnEwZ6Ret452F/ONMps7VIYUQYYfI2WQVfD9TE8Nsk
 lBuHc8iQaKB3k5xjGwc2RIJ9JytrLFa3ej52/Qq9XIr29h8Y5TgD0FcLwcL7MIwgwSE6MafbIsh
 nSOZCYYMLZIZy7cxuMI527n8pCV7SwPR8lhcTrgLfoV+AJAfIlKecQV8iDkIL2Be9mgmsRbZF4E
 kkcqSL1dvB4m0YkzW35o2uUmJwZY7lw0hyeZEoa0=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=69646054 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=aCF1RjM6wFvPaKqP47MA:9 cc=ntf
 awl=host:13654
X-Proofpoint-GUID: PRYYhm3J-dltJPFPtjrqyTYRWEiNL4nd


Hi Bart!

> This patch series removes multiple forward declarations from the SCSI
> disk (sd) driver and also makes error messages easier to find with
> grep. Please consider this patch series for the next merge window.

This conflicts with the bus series. Please rebase, thanks!

-- 
Martin K. Petersen
