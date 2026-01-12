Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7571C18DB37
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 04:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768190795; cv=fail; b=GD44OVN8qYWLdM2hRmhmAlV6meUFc2bkZFZB4SHBuuelSGxs9Nad9q4VIeAjQsrXfXr2LeFAPdJh5hdKtM/9lHRSCtlmiZ1gsx2CgpluygpvRdXOwqke4AHuUqPvZNFTqiKLizBKJ+a9RfmF11Z9+cs+yB3EqdIF5mXAs3wa2As=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768190795; c=relaxed/simple;
	bh=LZbt5F3X7/JKs+xTai6Dg9IyNjN8StmOsEKLF0ACPg8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rw/KcXdTHnGeHyBNczf3QzTIZowDq38a2Do7nyPoHQOx71qbQKonan6zyakjVSGVvwtmiE3zVDkkwkRxexCYydtMWYPUzFXAEtJmU48rdYLuaEman9/BXmXbzkgg/0gBi6q2jEhyW2WJuOIjDHPtO02ZBTWjl9IGK/FZUdOL0pI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dc7QWS8K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lOpOT/4K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dc7QWS8K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lOpOT/4K"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C0qI4H297293;
	Mon, 12 Jan 2026 02:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=76JPtMvDrmSmIObRwq
	m/ydLfCtn2+alNfivkvYC/Y+A=; b=Dc7QWS8KAD2kVouqotnVIrEmSaEbnWgQef
	n5ahwsWnfR1CNquEx1EVSSrpJq+9GLBhDrs1qHmIg+mWwK9FriAyyy3hTHcMLklb
	bZEtRQebuAtO9BaAkxuJFuUTKhrFGODOaHujS7OwmcpJM4xOx236GZoXer4ujqTd
	kVpwrpz5N2qYZe9EjNzrHNDt9VXp49iKOfnvBwxF/Q2gybVxsS5wYEDg8OyKhDQR
	yi9MTix0bqgK4G6DeZ4kEpZHrVpaSVMwktJvvrAjcehv0v1PPHYiIkwvyRVKdwTb
	qy9B/8Su8xTcfkW7nzj9FsmuETrSOQhJVAzYk4PtT83aEtEtzzpw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwggyg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 02:34:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60BMvglT032753;
	Mon, 12 Jan 2026 02:34:21 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010006.outbound.protection.outlook.com [52.101.201.6])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd76w4ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 02:34:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wy3PBnADqqU0eNuO3p7LrWv2n6HeJaIr7+xq4H5c9rF3/oggkUu4w6vtx1sXIPB4WxBD8DE/uQsYVOuMIFFHlGVm4gXkp3yeQonohFR1pwL51Pho6WUeWj/poN2SwCfhNgn1OPk1TYja4M4O5GxEGGlH/MrSxva+qJDLtBG25xxkwSHAxwuY8VRPrFYrTcOT+TeEjvtuMX2NQ/fly6n5k3hR+yNN952o9itPkgVL6qlif4wkiuguufhcuuPU+6vA7udUxD6GjuQ8Rp27Z0YPLyLKW0zrH7sfjMBPsqZl7itK7eAhlxNQxkPKqz+rtflnB1xbQzD4pDIWrINPX/BiLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76JPtMvDrmSmIObRwqm/ydLfCtn2+alNfivkvYC/Y+A=;
 b=fwQ6IYv4zOnZ4HNtwpwyLOCsQn9ibuZTO2rvODwmjyx86JmRDGI24BLJuMGtoNjCwuSosUlkR46jmQmv5161jUGip3JnE9bqgaWbVGWb5zBHUxWGRAZP+8e5kTYRskDvSwCqIumxYWtx7Kqf/9khspuokZnVpfvO2aTJ4qJcPVKJ8dCmSFAF05zv41zQc8CEt4R22F7SvU49G4rO5Sx4JWmgSi0dRfDRvy+u5eiYyTXwqdWx3KmYof+FweyV9GIbF/2K/H4Ouul5nl7N++j9xh2MCa55ceohj7cwZ6dRz/Y0hSoDR9flewyLbTELk0BZQKqfF2uDUmXBMfLrxGXfeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76JPtMvDrmSmIObRwqm/ydLfCtn2+alNfivkvYC/Y+A=;
 b=lOpOT/4KRKOVDNFCE1w+1CKwnTvOeil9EW7TzUQetrysGvKGXX4ODY38c3k2/QWlUyZtZRwhMnzNP9CpMljs+n+gN4A7kne02/83r7zcvQ0A1fvae7rHcFghAD1tpjyEWoWeI6f1Dc0dyNdX0lzs1thS/RzT75ZAcuBOZTpcYTg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPF1EC0B6C27.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::793) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 02:34:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 02:34:17 +0000
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?=
 <Kai.Makisara@kolumbus.fi>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri
 Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Peter Wang
 <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Bao
 D. Nguyen" <quic_nguyenb@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 0/8] scsi: Make use of bus callbacks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cover.1766133330.git.u.kleine-koenig@baylibre.com> ("Uwe
	=?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Fri, 19 Dec 2025 10:25:29
 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldi35zl5.fsf@ca-mkp.ca.oracle.com>
References: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
Date: Sun, 11 Jan 2026 21:34:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0304.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPF1EC0B6C27:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fc36139-d1ad-4967-b9ae-08de51831561
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qLRLFd+ho4/rEy1g/N71LzuElUvR73uYwamfQePq7tJZaXjDOwJhozrOWaWO?=
 =?us-ascii?Q?PW0XfrTQyz2CUTA7mK10EBlMTuOuSui0ANwNE2S6h7m6fFQXpbDA8KlaMtlL?=
 =?us-ascii?Q?CV4pAWsQfG+oee+8ihWrIL2gb5c7t6+P4Bxnt7nDFOO/LZOaCw+jX3tv4dFF?=
 =?us-ascii?Q?TB9GIloV0yg7TZK6OvixCbeAVH32e3dO1nvFMifayA7FZeuyKnoI8CieNxH6?=
 =?us-ascii?Q?a8j19pelUk0K/Fuk9Y1b9bTjwhANEze/ayGYczSZDrfE/smB6uy6Xuud389l?=
 =?us-ascii?Q?0mlfdzAACX4k2Em8QwP8wGJd0GUfUuXwFN6RgrKZi+4db5FsSCcLfqDnD7AV?=
 =?us-ascii?Q?1AEHLqmDGaDH9MjeJBg4fqXhS2E2q36UEEbmeNQuFHtWfwePJie0XgnQUQFl?=
 =?us-ascii?Q?5mG0D0FMEgVsFHasThqR4HxQdciGj32IJbDcR6m45jVGu+EfW0Sa+gN3pwO5?=
 =?us-ascii?Q?7KsdBkxGXvdw1/zyp3IioxjvlKEF3CsJupOK4BDU9/p5UodndeaeulUglVz+?=
 =?us-ascii?Q?eDKLYmvmOzSGD+kA+Gj17qh4Bs/Y8qyh9HPdNggRTYdrcWwY4JyGkAQKZYIC?=
 =?us-ascii?Q?YHFJXsX0W22MgI/wUIeXhir1NtVLiV7mZ4C8juRwKoKu9rV00LmS/dFDlQSV?=
 =?us-ascii?Q?Fgxahu+dzDyI+krAkrSLLhkIcxWD+uDEmC4haw2QA6D5EugZT1fBcuiiyFo9?=
 =?us-ascii?Q?SwaYY5vQToxqOmM5pOCccpG+a2yDo0VIZYrPFBGPTPApf71wFAJAMhzU5c1X?=
 =?us-ascii?Q?Y6OStLMMNrmBnB3+B1m8i+OO8PM1NrBkTZ4Af3NxcTtKaUT7midvXpPHmKs5?=
 =?us-ascii?Q?n1Sk3k8GbMT4N7N6my+7/s4LKuKlkS5sp3YGoUUTZPJnVaeVpdcAn/nd0jI6?=
 =?us-ascii?Q?ufioCkhSKN6Xo+O+QxKMlXpDrgXIz9ef19sPa64nO7QfyDTTIyCd425PE1lF?=
 =?us-ascii?Q?CBTqetR6D2OMHirPEzdh+rNkGnM86V+TyNoJl11lE0EgWC+9P0kUxKm2qYwG?=
 =?us-ascii?Q?c8NY8bDmtvb2pS9NkgdhE5aNWO1zUNfzeVeK2p8xbiUtsNZ5rvmBSJAnzyc8?=
 =?us-ascii?Q?ATCZ+XPBQxhrvhoHNTm4+GqwzLHRcg6V6RNwquIQ9fkUKB6WVSgpJEWqH6dp?=
 =?us-ascii?Q?wRqld2vOE0fkbTMiYt+Fat72gnhce9z6QpeV9wyTL+4s1Jsj+kgjfG5gNC7W?=
 =?us-ascii?Q?dvdlvKPC80FZbXkf0ViXLGjHamfq727ToqaL9NM9saf/302IJxXhNKR+dwyw?=
 =?us-ascii?Q?rP0jMwQkceQjGrCln13ILaEkMz1glsEdBnQigUTIPioWANXf3tAVGDrjZagU?=
 =?us-ascii?Q?5bt+WuHHQBxAQKg1Ojq59ra9QTzQmUbU1uPCtJcSPyNckeHTw9bqu1UgKpbC?=
 =?us-ascii?Q?izF/cQMME8Uwj8kC4HXpGV0lSqUotip5z0z4cetofR6D3uaKSQAWSiuzxQex?=
 =?us-ascii?Q?JqH2UiXlIaokWfsG6o205eBpUCF+YgSt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K0Z4oVeo/TiCibdp+RtuD7jE9Ubggw0/1F2GjwMi//jl37VjmyKt0E8Pp0j2?=
 =?us-ascii?Q?8qJp1bs3osWoJusQ9Ed2bFyt2G7IKyH3/utvFaeMJHjCJffnJr4zQqbNW0Lq?=
 =?us-ascii?Q?HbshzyIt+/6GEx5ywai9wTywX7rsdXtNVRpejVgsRzGRcB16Nu78kTgoMBVu?=
 =?us-ascii?Q?bGtd+kJ5jLeETTd0btqtkmqcnXyj9LvA2ztP92lQUTiyGxrI4eLF9/J7Lj2J?=
 =?us-ascii?Q?sHiEbeaHavVISvHvu3ltRW+jf3JBHN1tuImIAET3TJSSwS+qTSrOIpdxQEOR?=
 =?us-ascii?Q?cd1m3YO8ddpVjVf42+cqhlBwgaAv4TO3cZ9uChKMnRIneCXwNVC1QDIoAXUE?=
 =?us-ascii?Q?0w2SqdGVU+wyARhj36kgbUY5chFSOEKYYf2KoNRaWfuRbC7Ko0vy14A957YE?=
 =?us-ascii?Q?/Wij4AMPIQa3oEFjxtUGUfVcHrjtNY4i1qrGtOJZmb6sAKfMBIC7TAUJBrIi?=
 =?us-ascii?Q?cpM0uwjbDSPlAvhxx73pFM2B1yf9wTY9O6ERW1qaDVLnxb8sixLKI1KGJSM9?=
 =?us-ascii?Q?JCdyjgCQP/7gU5XBaEc8NXcPl8FDahiFB6n7DhgIgTm5FuL0IcqQWOJQ9Yg4?=
 =?us-ascii?Q?HXUUGbMcee+0jBXVA5BVN5lNVjDekZmNus0LXCHAh6ZI7rHq9UB0DDIFE4+J?=
 =?us-ascii?Q?ZNjVD8xWP7VI+5RXLuyBm8bkoQISChHBYO43oFOmBdjCXKSZtv4WKVwQ6vbs?=
 =?us-ascii?Q?SaZzsUgdTh0PoCIRZLQHNXkfG436N4WR5+eP8TSRq98C+dHWuPSRQKUwIs+E?=
 =?us-ascii?Q?CZpODOkIJGslvWWcdwYUPbwhuKSW/LPWvQI7SujMbYp6Q2FhIo5D0qu/WBmU?=
 =?us-ascii?Q?IxgCaWBrpo/zuyHHavtr1vV5qx4p4ioCRYNdPyz5wnGLgSyZQJ9aWdInSueO?=
 =?us-ascii?Q?OzJVMjEeE8SbjxM2NB5x2g6sVY+yOep2dRXf/f8v0465pJaETQBw84j/+skX?=
 =?us-ascii?Q?axuM3VzuDrFGTFNyjJMYYL4iUsPx33aL0y0nCJJRefsbB05KTXs1aSEJFOyJ?=
 =?us-ascii?Q?Sx6gjrfWeKnLaDAnaBrXC1ZToYXnJd0dMpAxnn1lXvtNlZKmHe/J1QqgsE8p?=
 =?us-ascii?Q?OySayUiHstQvwaQV1aNu9j0ICRk58iGmFs9Gud8Fe1qyy4B7XJHT8W805sgA?=
 =?us-ascii?Q?WSXDqvxzsl+wEcMP0chwImgKDexKBPLncAygSAwQckno/bqNO3/DPyZoPUhB?=
 =?us-ascii?Q?ussugLn/jzzbDohW0UQKcQJXGIpLV+n2eZ3uUjdpfA8l6WXJCKIXyE9UCxmx?=
 =?us-ascii?Q?vWiKJOmvPcWCWn63AcVaqorBOx0X5cC8R0cOGk8IvSMNaOx7QG/1duxP4Kh8?=
 =?us-ascii?Q?xMUinEx5H+SRtlFup0tdpOmEU1RiSfRrhRiZoQdIJqIxJneUIMeEzuWIDSzk?=
 =?us-ascii?Q?CpRyuQBOmmD3ZgW1foQhdsDNsRLuqhkXYfblBy6TgWMrSxpPtF8n2e4viSqU?=
 =?us-ascii?Q?9Ud9FHQTK+s0RSaj/I5Si7MRYHsj7ACiTEnlIQjofy3mfgCFyC1H3ofzJbnA?=
 =?us-ascii?Q?sByhzBRganBcJ9Fcoh/7DmRdoJJytJ3Da6YEs6oYkseSlsyv2uqSsOfI0S0c?=
 =?us-ascii?Q?H3TX9NRrpe+Kp5Qdm3W8ttsqxVyLMoWlF53P9+FlDegpX59FIiZh5b8SPPl1?=
 =?us-ascii?Q?ZkSSw25Zz7ofaYA6GlWfryCQ0WGIhpDQFZToPrDIVMv+JVhlMs7NW/YI400x?=
 =?us-ascii?Q?HSakvX0pfALPqX/7F4BPV0xL105yJGmBgBroX3INGRXTpG2i0/VBIiy36ln8?=
 =?us-ascii?Q?77lPNa3+tlLJB54dF+UchT1Es8dmcns=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WP7D7IHTpasXlw3x875/b32g7wX0Gx30A/wVFxcbJwrhK9l/Tev6rRjdI0LxdFxJhIpOvVIFDXUVGKLElbVofmvAmILO6QslAGroTurm7Qy7oa2SLWrA07QrA8KIDedInKY1TcVSZgWf2dDh1I1IyIb800M0eXcmWHhkcxxqyI0yyIVFyb9OUVb1wo8U213W8meVfwKJi09mffXJQTWVM9t6NLF3jfcR4WLAa0CG1vCFZEfEN79KS8JM5l+2dhFB0CyxralfdoYX7wS89Zqqg4dvdHSByLYK0oujpBrWZww8QGfNMh1fuJmNC4UNxJHhF2CHvNXPwwpVyNpK0AV9YdnqCTgeZv4pIO3qrSPTmNl9IirroMAcr7SPD2ZMZqyuiO3IWBT9EEegBQnx5xEdTCWUWclBIhOKPd3KNqAuktpkA1AOyJVm0xTC6U76mHwO9Q9KlAYcQMtkdKD8NYTMkHyXsQbwG2B4MK0ABKNqF6t4mYc2ubabbJk9I+rEllFEFD1ASvfamWOGGB8fBDeBN/HI3LGT7i0NUwBHunCqzmjwQOu4stXSQt30SnNSDpiIqd7v13gfb1LaXbfsHaQnReq/uybHHLXH1E8KztHy+Fw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc36139-d1ad-4967-b9ae-08de51831561
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 02:34:17.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGK2Xo07kp7H2HXhMAlSrdiHUUU4aH0/Tzo3Xb5PQWZ0yMSyIBPWkuQAwb3vbbNIGvFZm0DHu8qIARX1mG11kSioWDkf4FEL55ROg6/c4wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1EC0B6C27
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120020
X-Proofpoint-GUID: UVcTZ7_t-tRBywfMC39S-s1FAc1rWQvC
X-Proofpoint-ORIG-GUID: UVcTZ7_t-tRBywfMC39S-s1FAc1rWQvC
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69645dae b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=-WnfM455DvF67c03Q0wA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyMCBTYWx0ZWRfX8Egmu9HNcBi8
 vS/uJTXvBRkSas0JCUkwnFka77ZrGRqdEk+J0I4bcf3sjBJPgWf8TNMNFUsj75TQfPlOI2bi7qW
 qXs0MayeBxPQ4c+fFkqejpRvpr1nq7uPDFp1AUywTtonQtUuYUkkXR1HX/OjnicXPtgTVuDxmOY
 haSht7m/AHkjUYpx7TBAs5j3wVMUT2QQ6FCSlZLwkc9FcGSFxVjeVxYM4M0+9a2fvYn4i7Rg7I0
 4TCgboDSos5nz13fOrlC5Y5lV2M0q/QkqEe24D8JKBhvYtCFx9OFCXndMCzJUgYSXh71qyx9xGb
 baJnODDmHNW5SfKPf1WC+HeROZHz+c2cBx/UeIml3jhSQ9+9ryWboOFu2wiCkaSn/6zw3N+SMvm
 BM/B/A0YWTTDJJsRA4ci/QEzdWuA7mOMDkIu1RtKKbafnZtVsSmdQNXm7xPMqQ6Itv/7DkJ6ba0
 dZoxpcBpys5ePQ5Gz9A==


Uwe,

> this is v2 of the series to make the scsi subsystem stop using the
> callbacks .probe(), .remove() and .shutdown() of struct device_driver.
> Instead use their designated alternatives in struct bus_type.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
