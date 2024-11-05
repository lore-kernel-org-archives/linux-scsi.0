Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38C93C30
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 01:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730771561; cv=fail; b=bko/2/Ws+5d1phVX8MQUW+7ROdl9pWAHeZrlKV3nNR5F7Aj4PFECafa6mUE57tppDoukE5CdBdS8LqitVxSm5rhLNGNDwWXOsf4TI3cY9pG4Sax8EUKmCN2ajD3lpG3GioYWy09+K/V626jcJp+jZt5Plpg4UL5iellz85YtwT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730771561; c=relaxed/simple;
	bh=EWGLPTSytzWPiHpyCcXc/tm6dTZC+qX/cy0PGMt2cBU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=W8vaCueNYfVTCo7HXdrMlQdXgHtNFQlgtBGtEjtpoTp3YG839l6YT01jRRPhf2IRneOlzwuQuzXE+pmRQV2e2vHnmt/1yorvunFNXa8ps20sJe96FfFqKQX4UC0xA/OZQZWY1uYTSaYbonKq6sxPD2krLhJKPY9Nn6v3ton1rm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iKR4wSTP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ASaOIqQR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iKR4wSTP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ASaOIqQR"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A50faOp011554;
	Tue, 5 Nov 2024 01:52:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=UzT480CRkt4aQ0JvAK
	U524DVVNWn4XeA+xPHDEACFdw=; b=iKR4wSTPArrhPJXHyttuW0zGzI+BaAvZDH
	i+o82/QFXptcrSO0v1DbUazKB7eq7DMbsrzUqO0g792uRxdcQ3hXl2WNj/A9Z7Dz
	HT5ztlkm8jC1N0a45KoF5smzw4RqtXteQ3vtOgQy+WwZRXy9BMky87GSpkipCVnm
	Wjp0ZBXit48tmB13BG40tfB25OzvARXzlOrzmpKCOFohGhaHgqZ285XWxC6Z1tlj
	JRV0v4XUNjZZG68BzITABq+FDHPQCRKX53dS3ltT1Fmv7oWhWheHJjjTvkkuzhee
	vBSv+a2n9q6yQz0Ny/PyWGDqDJgod2iUizd/cU6Kvm083oDn/Zjw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nbpsm7fg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 01:52:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A4NtmV1035238;
	Tue, 5 Nov 2024 01:40:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahctaep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 01:40:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W7h0cwokYhTmlcC51f37tArvBgcO5Pm7arm1C1nQO5pqhimCig9b8O2e8tNKB2CuMje5i6klV0V+Ftgt0odbW2GE167uqJlRUnjp7j+5kcJjD4NuhgQxfkCTL7tzkQJh/KQsTpptwm6KmpiX6vq8XSZmR4TNLavXz5VQr+KGUHsXIZE5qMkZfJxHiCcXq2BPG7BkJvhvPJ3l51awp54WdcnwpMSZbwiJr0b6YIOFUrwu1HMxJComUPrWjrNCbG3aE9qG618tl1VWCLYtcT7mvIxB6POCSsSIBAnsMLCC4PS96FSoUbYCcx5Jj2P0t5hroSNJTreGiE8gUwmJObXXww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzT480CRkt4aQ0JvAKU524DVVNWn4XeA+xPHDEACFdw=;
 b=b6Xon8xCG4V4CI18BD9V7qt4esrBve8EnvA3S7P3Jhn4szSe87wYjvIa87d5R8JTijAhJdkSM8Wa622n/iBYK5s8LOCiqCvbVmHrSnRl10iwQWTfzcrlVKaaqUg+6/jpLdvWUcS+/EzMNNR3X2tP/QKv/zNXxth54DqYBS8aOufy/29HA8ZRc26ZNR9z/HkAtVV9FaYCPoDTKpxSN/lsBalrP0vnBDRTVlKQBg5qaL+w+IaIZ+aogavKg30Hv1giNZAflfWMEREO8w7eZD+wicDxoqKQFLuNQNzqkpyi4WK4C+/bCnBqWyytEHhX8Tjjc+chAkuPVTjU1n8HH4Q/lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzT480CRkt4aQ0JvAKU524DVVNWn4XeA+xPHDEACFdw=;
 b=ASaOIqQRZLIfeHUdVQ0zMqBXX3snwif+PGNLA8BVqKeajRyKM+FhB7D6BpSmQqIwBemU4l6vMe9ijGiF+hEKNF4qFqA/OCrmJg/Q8on+t7M2wYL0h+ZvkS8vOMEyGBHfhJg6V4jSF2XyBF9o3PCsyivuhKz++63tNgykzKUsLeY=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SN7PR10MB6476.namprd10.prod.outlook.com (2603:10b6:806:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Tue, 5 Nov
 2024 01:40:41 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Tue, 5 Nov 2024
 01:40:41 +0000
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Magnus Lindholm <linmag7@gmail.com>, linux-scsi@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk> (Maciej W.
	Rozycki's message of "Mon, 4 Nov 2024 21:52:01 +0000 (GMT)")
Organization: Oracle Corporation
Message-ID: <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
	<CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
	<yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
	<alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
	<CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
	<20241030102549.572751ec@samweis>
	<CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
	<alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
	<CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
	<alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
	<Zyh6tP-eWlABiBG7@infradead.org>
	<CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
	<alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk>
Date: Mon, 04 Nov 2024 20:40:40 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::7) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SN7PR10MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: 703605ff-2dd3-46e6-1423-08dcfd3adbb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w7shg+FjQNTN/EUZNIheIrJ8Vo+rZyDnw/jl746jwzLV/rhaULGMzerJXUIP?=
 =?us-ascii?Q?XbMYEBVwqhKeh93sland+cO73NrGJJNGLtkfV9F0ZQV7SCMGybPq9jCG3tqD?=
 =?us-ascii?Q?wUfEQq3SBW+Gq5g2B/ITfG3F1d+ZdxaxkVIrpfvhLk5f0AdPGjX3ZVCje57a?=
 =?us-ascii?Q?HN8NyhOrBHN5Jw/pEgUSZkTxGzOmaIDIcF79xUnb+BCfWqsq0g19ky94TWKg?=
 =?us-ascii?Q?O6tHPRK2ilujZnCKzoHpNQ8WGsuB6Loav18dtiuj811xgPm5P97HOffZHzrH?=
 =?us-ascii?Q?Rcs+acNUsukEirr4zIZAcX1KAo35Fks+X+rN2To4TVR/ZJkyeYvJby54FFm+?=
 =?us-ascii?Q?VM6++8TjSPjzCqGOAZufqdPvQ+qE4IKMFhJqi+XL7135v+ZPzV9UDYm4+kCj?=
 =?us-ascii?Q?sBBiDgoKY/iNei/94Gfp3tSajexDNf67T/YznUh+l75D1rWyUEy7sDyCgh6x?=
 =?us-ascii?Q?/9K712z0PMhunl8US7IM4aD+ifH9cifg6UE83HndjuMMuAwYGo0OXEVKHjhb?=
 =?us-ascii?Q?ofeO+R28ZGh227aYcpzrcb3WoeElcUwM93rq4Xpfbi3Q+pqHhJf/B3Z+t56m?=
 =?us-ascii?Q?fiWQjXqaWyIGMvmFAmBlXFMTHfAP0NA4jpXshdVeed5IMdAH2MTN3181KrEY?=
 =?us-ascii?Q?tFBGzeKEzaKEQBp69z6FtlxdP9vx5M+S0B7ZrP3KHj09bFUa+V9itcjSZFYN?=
 =?us-ascii?Q?mKcOB5GziEYnThYWj2rSojl6wMzdSRq4yBuFR10fPK826vX0gthtWej/K8q+?=
 =?us-ascii?Q?PHSW/T/kIt1psK+fNNeyy8KyAVKomW01AQECzOATBO4e8+2hHDX6oISZQby9?=
 =?us-ascii?Q?1pauQm07p6LRdi/LE/uX+nv7lTjBuulgJHyP9QQbum22p2J1poJ6Ze5QZB1O?=
 =?us-ascii?Q?pZL6s2svN2hyhL7kSzS64rZLn4jCmPRSOq3V3EJGPnCrSDKytk/3dne12moz?=
 =?us-ascii?Q?t1Kp0pzm7pPd//nADlQmYiG+boH8Qo+2T1BoxDBCQNWW+MVF/H47yGFBfMPC?=
 =?us-ascii?Q?RyjjjWHUYl/o8h30xXr2ZJdARQwTm6ingwKNQgMeCCV4D6vvNufCwk7eWtYe?=
 =?us-ascii?Q?Tx5TUAtN48X1gEiE0eSJc4FB/R7O+MX6XxrzHJ9le3QLBvyeQSFeOMQU9maO?=
 =?us-ascii?Q?vJgJCEcWAxbHLSbEvPWuZxhyQSobq8QGWCK9pkjwfLQcKornvcSYI5Z8mpIa?=
 =?us-ascii?Q?ELk1w4oushgbh9uCI2JQPzW63FBKeeoOH+KDuFz75Qs9c/hy31Gt++E4Gbzo?=
 =?us-ascii?Q?aWFenbMRX+S29LTseZHZGizrxYZQUizw+999CSNnnaqLawYvXjoVxNHtZkQZ?=
 =?us-ascii?Q?IS/5/tSg6qvBFsf5HCLEURzV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SHsqEhQprG2TGXAD69sLrcx0Xiw/GVcNcMdkchh41KljLwzJYPnJa0YSEmIX?=
 =?us-ascii?Q?RtyPz51CrWdCooNhZxIon66Rlp1JwfO97VTx+rqMuM0w0uzXV7LO+ykrKTUF?=
 =?us-ascii?Q?87ZFo0iSVMdf5XgnMnk9cO3gdLjJby3WNdwoyLFA1KNOa5sWSLHuAgUJ4BY7?=
 =?us-ascii?Q?8HWEyVeHSA8U0RPJtk1ZAPRdQ2h/6rsiAU+n/D2H1x+YEiXMrrAsZf+mDG0U?=
 =?us-ascii?Q?pluzXGHsJS34cng4meNYPjJ+buAJzuzTrEVbe5qp+FGstOEUSUPOpFbmCblE?=
 =?us-ascii?Q?fCMZKy8InOHl0HUYnFa4rfLEI2wIQbVlk83P5XbK9DEJamJm7z2N2s2sDjmc?=
 =?us-ascii?Q?JRFKM8iHFiJpM7kwgQv6EebRoQ0GCFFBQZiwkRvoWfI7nzwqoDSS5hN1S4Ye?=
 =?us-ascii?Q?FeGMtP2KQrXoXWm701RHR4WJnJ9ZsDheg8TN0D1dOpOJeZ1iiFLJspxA5nT/?=
 =?us-ascii?Q?jEdjKBUV2tbucw7BLPIHLqu7cR8WqeYvjVnRxeQC0kPMNDgdhW3wuIGJVPU3?=
 =?us-ascii?Q?UV4ZTiocTNvHNIMOBQz4vcVTisCOSZehwziVIGS/fhG0T0oYjXysPGh5iLPJ?=
 =?us-ascii?Q?H5kIFQPfex977RwJoz2Eryp1DoQdgKiJXK5t0Am9VlG3570m8zBIuET2rVX5?=
 =?us-ascii?Q?n0U9sB2nbCwSxsh9rR8rwism6oA2Km8K/UoQQTzwyyj37ZZK0NGJGYP8XNZh?=
 =?us-ascii?Q?Ssad0QsUUItX2+xym7ccW/M4Va9xIuSUBjLw7Ua2ieoP9DA/e3C6qjeNZDa0?=
 =?us-ascii?Q?dP+SPDNAl8/VYc82cN86nsvTFTeJOpWMNtFhKgrXmDKF2nceR2sb/kcIP4Mk?=
 =?us-ascii?Q?trmI3lnszH/rYhf186/8QGXI8gppJhMKT4C07rIZ3zZrJT19WDMjzubMVx7r?=
 =?us-ascii?Q?OHdZbdwWTzO/WKdEOlqT7oioOOFd/zlZUjgTv6QbGHwKgZ/dCzugbRckS6p7?=
 =?us-ascii?Q?KYVCpUanPTdF8omT1PoxlUgA8TTB7Uzd4WZxVEiOZy++pPl5z7tRdI3Tl/Lw?=
 =?us-ascii?Q?IU4hVg2P1xMJwfsQvVMjQ7h0Kzy/gNOPXAEuHM8EmulxtqHt7bwyC9/gkrP+?=
 =?us-ascii?Q?xCsOxTxN4MYMJCrfuC5nGKRtq/3jAECWrkcgh0w0MKkJF8VWHRDdVnYKI8CQ?=
 =?us-ascii?Q?3rEDDKx3wM+vvmBLAgHSkolvczDLWnKwLS+h7C0Cobm1fC3ABf1S7NkmxiUx?=
 =?us-ascii?Q?gDogwrYr5Wu2nRvWq4GiKz51Fd5zfr3GvXEvm2pIgZdC5P7esr3u6DmO+BZ9?=
 =?us-ascii?Q?XDm65MY3puhfc14PJdj5jXN/gVu8r34+nzZxdkw8/l3016zIthhzMPSsdqjp?=
 =?us-ascii?Q?7ezC3nMImnyJZXv7ktm/6voe/tmE7ttwUYxBpAe2uK8aJgrlo2emGNb/tGcj?=
 =?us-ascii?Q?+4kzo93/QhRhd+KpoPbukilEP7k8LPPX8r/gbCIjEDhsSlymgMc8f4V8fv0r?=
 =?us-ascii?Q?gX9Gyg35x2mow20yl+wAnldry12RcV4LKQPLnsdqEZNcSe2iTH+zDQ5r640E?=
 =?us-ascii?Q?c1HrtBdA9Hy1ommXEDOakBZNs1Xvxmsf0mUoKl7XObx1TILn3Wsj6p5VFO2F?=
 =?us-ascii?Q?8mj9OjYhybt3pXwzE+7tov7OPKvaBSUzXxib/egxLLMJyAkJjyxsyx6h8121?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xytJ76ncj8NuuEQSeqFmHKrW65J1olEVQzmaNVqdHN8nRjZgseLKYEAMwSbRw2ndAikd/akRVDJMXqpn1uAtM7GkIuV2gyJil1/15+eGh8wDP5zJ5KSnGnNxa3BBnmdlAOynLhhcYqnfjzvNcL4iS7mx/zWXmypMqsYCsokH0JwOmIg6rI3K7+jKordLZRhg6D36kkNFOxyVYm76D6yAyQOx9r4OVouVnUceza96m56q+ryHTRr/CnC6CHw+HTNzQdus3PMuL0gHxasS/RPM3hkiuFkR2Ed/Mkn+QGyx6F8PZame9qddF7woN20rY6vXeEoJc3anxwBsVlYkvMKDLd3ipzC+VUIiAJ1kE5LNEdxY49CVtWy41sQYUSwTRhJMJKFDlNRZGAcwPgqn1WZubejsPPHVWR9KaJiSVy/gJNiZk24/Oe63LE0Sfx0KExeepW/FrW+AyQZWss+Gh2qsZO3Mf/Vm88GAn2KgSp9fylQhWFqjTa100xGKZZrkC24wcb8Ahf3n+MZnsbDVq4ywKWkM2s8ERR1tfFYqqvkEg3uzBOxqvm1e8UFk5ECSScmKnY8hpgaAs+2o86Bp6lGdeiQqC5n36oMOoK4doRzacWE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 703605ff-2dd3-46e6-1423-08dcfd3adbb3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 01:40:41.7036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85RK/qnBPdtZr9lxH16wia/Ftc002vNJRUnL15F9NoYNdi1zGsRGrSo8mZzOiXlpgcf/JMQJEh8olPrPD6+7gwZPu5Wcj90wvAK+8oBtfIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=616 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411050011
X-Proofpoint-ORIG-GUID: XxdM8UFe4VARC0eqnFb7Ofutnh9u3UNO
X-Proofpoint-GUID: XxdM8UFe4VARC0eqnFb7Ofutnh9u3UNO


Maciej,

> force 32-bit DMA addressing for pre-ISP1040C hardware and let the
> system determine whether 64-bit DMA addressing is available for
> ISP1040C and later devices?

Yep, that is the correct approach.

Thomas: Can you confirm that your SGI hardware has a C rev 1040 ISP?

-- 
Martin K. Petersen	Oracle Linux Engineering
