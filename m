Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2746B23185E;
	Sat, 29 Nov 2025 21:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764452698; cv=fail; b=oFYg/E/sKI9dDetZmmvAbDcFSGFKju3p+uIgvCM4nI8d6CXE8FNwiTnKI+8kTpYbCZrbg6BA/HxjC3hp2wenWa1rfaoWq+9scDbSlrOvn9tWlxcVvtrVaX8uJSd2BapVsNigIUqbmU9XcvUmibqkk9Ge7pUomgxYI49I7GSdDB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764452698; c=relaxed/simple;
	bh=j3MEmT/YEBN1x+gCdaq7rcj0O+yEIerFSoO1jejidwM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZcTJfpaNFcqeFtJ9l2oc5WmS0PzkHi+AQqPQUS/cHqL9fCZJ0aBT14zmX3DXytEP/OIBBu/Gb7kTo8rh0YBsSWFjsD+nwogtBvEg+dyMcfgFnVrdjKC1seKhOa5Ku3VsueTmxa1B2pAUL/Mn7tg0/vRglcxyUmi3qggNdx5JGbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P38sJZLd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l50LcMS7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P38sJZLd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l50LcMS7"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATKvoHJ2341561;
	Sat, 29 Nov 2025 21:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+4YTijE+nYzl7zaUHQ
	smLuiOl6knE9piJVubQb1znwU=; b=P38sJZLdE79oxO5sFN3S3OLoY0UbueRoCR
	qQPC3/qfhgke42WJsUdfa3NWV0Kdjf5am3r8Hknn2sUW9V/AGzsKzkG4knbU9ZHu
	rQJ6DW1nhy/YmWGNJsHsLI748KzkU6YwP1M4nXNHemai+lP9I4vZKYxqS0errZBJ
	CQ6NxfQ0MLbkM51+qhwyhIhXmNl4TYWUum1eJmwCuPbkrGIbnrPNf/VkY1TfOnUC
	ijQ+oWG1kg2CHEjDSVslPar1hSXS0C17anemWakQm9GMO7FuSdyBSCWM90Q++1mW
	snM70UXW1PGhaRchjEelGbIP3lUKbZpMS4dsDmhUTm8y/3dZbmgA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqscr8jqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 21:44:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATK8s7D032605;
	Sat, 29 Nov 2025 21:44:21 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq96g7du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 21:44:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tBNWfakJFCbPhlqOwqdvoz8U6shpywH8UzjZFW+923vYEqkMC9y5vbW572js5MN8jgEWA3RKYTa0bjsniL7x4mD71Aq1djY+dK0g8uBhylg2u2Ro6Tzjtlt4e1uzTIPtrX2kU8RhHDC049cxLSzi58vk6JyRxMGEGKm5XJfXudvZZmMuTXillxPj1wlWmlQPqA72b26XBN4ymOlAkWMK8atpSmVIQpX73VutpNYoFizypJcOuFNHuWDnbwq8pM9nuPBmnrXeeaN8gScFven1+hHXDWwt0YjAFilrWq+mhC2YDzyHcVx1Ll/LoAVB92C4yjChoKUWBHnHBCNMwPLvAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4YTijE+nYzl7zaUHQsmLuiOl6knE9piJVubQb1znwU=;
 b=iJuWoTWroQUrElepm5e9RGnJc70lbMljaoHIQhCqzdl40EULq+EOylNd4aPt1md9Lw3H/AA0T94s449bejwlL5aDWOKtfGxSpP8qonKNLKpnqCTDdc5MecbJcFk3iesXq+C8zXw35FCtCuCKetM8KRQhNAWtcpWevgKyOBY6Ixe1hkdzXLDy/3BA8G2u88zHEpbfFr4kTsOg1zg2eEbuVqhGWFfOPZtUXifSlIqyPHXfHCbkuR3ly/K5Jint93GOZrySR+xOh9J4efOwwRWAqemx8bEV0yYJizUe5V5a1PIGws+uLJ4b6ZCy5l7GWALodIRlpwe1xPRwsPUlC2VIfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4YTijE+nYzl7zaUHQsmLuiOl6knE9piJVubQb1znwU=;
 b=l50LcMS72fU5oPReFHoWdCzhSBDsj1iIT/USlMa4zLB76YhLVvec9r1uWxh4cry3R8cYHuvF1rbON6lcvDa5verR44GFQmVhYGmfy2WKdxDgqvZ+AXN9Nz50ZsBMA/SB+saRwLSvAXGsAPyDOyyZMf3Z9icJNdPch2l8LceOtXo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6288.namprd10.prod.outlook.com (2603:10b6:806:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Sat, 29 Nov
 2025 21:44:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 21:44:18 +0000
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Christie
 <michael.christie@oracle.com>,
        linux-nvme@lists.infradead.org, Jens
 Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org, Sagi Grimberg
 <sagi@grimberg.me>
Subject: Re: [PATCH v2 0/4] block: add IOC_PR_READ_KEYS and
 IOC_PR_READ_RESERVATION ioctls
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251127155424.617569-1-stefanha@redhat.com> (Stefan Hajnoczi's
	message of "Thu, 27 Nov 2025 10:54:20 -0500")
Organization: Oracle Corporation
Message-ID: <yq1y0nowm3o.fsf@ca-mkp.ca.oracle.com>
References: <20251127155424.617569-1-stefanha@redhat.com>
Date: Sat, 29 Nov 2025 16:44:16 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0107.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6288:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c22a30-2638-4a81-4db1-08de2f9072bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fAt5ArdJkAnHzOx8QjWEldB9JbopCBvS7H69rrVdMTWwNYGKWIqw871ehEUH?=
 =?us-ascii?Q?SC6RyeEMEoi3z8pDjQLkbBg7Ss5DH/0vvgEjMjyqUpn39raJ+GSUciJ+OVJk?=
 =?us-ascii?Q?qXkraFhfZij49pxb6epJxkCaxfhfwjfdiAri/2S9POC/ejQopuY8R7sWr0oy?=
 =?us-ascii?Q?WnQa5nCFk9Lk7XysjZwBRGSXV8nP7+hgcnpFfvthIjBtHElFQfY7/4mX+i5H?=
 =?us-ascii?Q?9jjsJFKuGwwX3fHodVJNlc45Po1c0N4U8sN/wOQajSvjHUm3mJh4etfPVJwd?=
 =?us-ascii?Q?B4fzoyXE/0RxV2Z2DNM16go1A4G4LInPOWrURkYHQmhvjVq+i4QpRJozDb4z?=
 =?us-ascii?Q?tTRrIMfLqreFBVbBeLBgXv05uEUjE/nmzoDsURpNlmx8+B0r6FSzBo3yrYmT?=
 =?us-ascii?Q?e+7bLDIMWO21cz8k8w4yWgv1QTXbbVyTjy64HnvkX4Zk3QQ6c103QL6IX3h0?=
 =?us-ascii?Q?b3ikLa+52Syfbxtp9hl4ME+jo5/jNgD2Mx6MFRRW7sXww7Un8VAWVtRqbIeb?=
 =?us-ascii?Q?y6KcvaCg/i3ZH+vKQSEXg1ft9PwcG6sNDQ1bWepKWc0X2sN5EN2fMX/FUMXB?=
 =?us-ascii?Q?SkpGg/BiDDY2OGDX+TvTuCZf1NFLYtD8pw/p+V8/eku2ho2JY3oU6E/agGQG?=
 =?us-ascii?Q?U8XbEUE4aSA/la1T2L1F+JOZfiZCG/TdLBsYIUbFbV0GL/uLKp/Gv4iehWP0?=
 =?us-ascii?Q?bv3ENV4fLUgmat5dSQoc0BPe2Bn2mK93xAaNNOjfVQJPQaiMMzuyzJEzKk0a?=
 =?us-ascii?Q?uMYNwiXrNH1997zgGVHg8eKYkIMpNjGaWcntzYtqOfbWjanPyGq9FcGwvQV6?=
 =?us-ascii?Q?ZcbJ6G+Jpv1SVLxNugC4St6LW/1uv5QAe+3KPkPfnYLx4k5deGfPE+crDOiy?=
 =?us-ascii?Q?nWJAmj22YdLzZmLE/1wQihGtvI6tEJxnweVlDT4buTpQQmu9AxiPS9zkSdLi?=
 =?us-ascii?Q?UIOR2s9Kpay/avIUhlujQk+FQa/hunVs3bCad5KlY6a1ykJN+RPnGx1iblVn?=
 =?us-ascii?Q?3/xg3LgY1F6l98FYkB+0tc7zYEBFtUPy3RgXcsYiPDOUvFMvOPHLmF3EUdJb?=
 =?us-ascii?Q?+2PUrEwBt1rdfimYtO4ZO9Xq4+gdZV6JA6vq+0xDoYYLHrCgRj8darPMxZl9?=
 =?us-ascii?Q?ufpaQt5ZLs3UX6AQ/xjkbJe3WrlpVT7Fs7lWDtHzU2eBCEv2v9VhLzLDey5W?=
 =?us-ascii?Q?VO7B+lMwablTijwazlJgqoOiI9vp0GS7TQ+SGSB3VO0TOOgIm2orxVxNDy2l?=
 =?us-ascii?Q?8Ro2Gl8t3HmSwTmLEPfYeq6+6tIgbe+vrwbmUTgzV+G8Sew4p/25maTiuR2x?=
 =?us-ascii?Q?jhg4TSJ/TX4EFvAHwi+zpjoLtgiHJksQ6QAv+cR2Fq+WReZSawfyq033uAJj?=
 =?us-ascii?Q?fnCDvy1UqkAp8Y9TPV602IniPb1xDe0xmb++px1cecXCRH/5Yx4RDk0VbgSi?=
 =?us-ascii?Q?YYW+cwNdDnuLA3GBgPh9dx8QaRjjk2UN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hfB8o9iCTxuRQTOeMRXua3InJIqBQiG1OjL7kh62/moZnkQgvcnsaBpMOP+M?=
 =?us-ascii?Q?aaNCW477TjxriOuAhHP/kLH+nKfEvZvGJfC4bP2ogb/43rjPq0VvQIhov4kz?=
 =?us-ascii?Q?9/WmYQ5GYtSG+KgAYzwrB7AuaHuSN/Gl3pUkQSbl8RiOSx1lPx8QrHcLTl6Q?=
 =?us-ascii?Q?EU2v/PG666Yk+2ySP8puQbblXUIpzXkhprOHGSMj9FecKyILqKT7f9Y6VrsE?=
 =?us-ascii?Q?fS2ogjPc0GJ21R6iPnd5sJMx7OE7NqOSzKs4vN9L1mSrqv0tdzIQHg+Dav6E?=
 =?us-ascii?Q?/cIa9BqmJekt12MB4gihMVoZ7DHxEM8Z0e+oZVoRkYTSrJwq/AtV0mTPhiN1?=
 =?us-ascii?Q?2F7k4HredtM49ec+Y473rIL7CTka6i3E21CMmP+KpspD5WfuSR5MC2eLhGGA?=
 =?us-ascii?Q?HOUeiUy48QaWdAztsEax3z6PExAOOiBeCP+uuEpiw7mSi9sPpvJ0EUv0mXc8?=
 =?us-ascii?Q?W5IpJMPH806mIcG/a92o2aGDeJzUUEDHZ3Jmpj8UrsrE8hP+PQMJ1za4X+Jx?=
 =?us-ascii?Q?hIiyY84VZsQhgW2KvFScYS/31YJk8g4kScAAcuyxJp5pKObqPbjSiYFxcxvQ?=
 =?us-ascii?Q?kQUF38NLpj8FTxAPUtmP65OX3cNFwIhYLgeSSUabxzcFOF1b/MjxYMToGMgM?=
 =?us-ascii?Q?ncewcrUxjJY/jzDdM4SakC7biRI6rS1nrFJWf40RwmVpGdT/U6YKMVMvj0Iv?=
 =?us-ascii?Q?VsS+YevYV8uuGFpp5abl4GtHqDWk+6IZgZXzCvp2GUhFll/go3nkhc4wz9Aq?=
 =?us-ascii?Q?F6cZnSNQl2xvaxaFXT6fVk+ZsWDwSs/8NfWdP7eCroGx1Tf1tvzt5Wo7UCEr?=
 =?us-ascii?Q?dAvIO2LDI+ZqaOIx3PN4F9Z/+2ShHuAeeTT/pWwiuxfDlWC86NDtkIVHW1sL?=
 =?us-ascii?Q?mpzLZpSNTZJNbQD3E/kqrGuIo2U0Wr8rp26X+trmPdzjGCgMSO1oZhVfQymq?=
 =?us-ascii?Q?QanH1t/8sZS8dKEHBodvkLtMWRSrx3n/H3nU2T0EnqriG7O2oZqpXqntPAFW?=
 =?us-ascii?Q?n4mirgryNcidHgkS4UCjDqHz/ddOJB3zPmEPDF8ZrCFZqFPZ0h+RRhC9HOAI?=
 =?us-ascii?Q?hq0Ke22z+tcEcHWQfiPYMjxXpEomiPI/nma3b27t7/lHvAxlxVHc3pxGkZgu?=
 =?us-ascii?Q?ujamzNTg3ZEDFQZStjRlK8KDGNaY9+ibJ7tSJ+r3WsHng3VCtEIDbdUjerO6?=
 =?us-ascii?Q?ws77/f8i3tn7idhP8BhzQEj2CHVOfWYlc/sk4cxEc9w2Y3tE2kxZ5fsT7/zd?=
 =?us-ascii?Q?6n1w2QTPEQ/cWtZmlbzP63TiXvWJBd4T1h4YY4f2fH1sgoJtn3QNxW9/3w3l?=
 =?us-ascii?Q?/QaDQMkbWTsQGa+H6OUPW+vw7XN3j7uIgHZ3U7c6ztkmXPWb9GAoJrv5Y4Pb?=
 =?us-ascii?Q?9+6KyUjeYj+gXSgMgBhyepdHiNuoOFTwswWaQGPR/n9KR4fPwEomabJwMosr?=
 =?us-ascii?Q?cN57frVOMnWBW3GIThX6zIkH+pA91lEcyQKE2YrdIqg14HCoU0KHM0u55tBR?=
 =?us-ascii?Q?dGEuQzRPbxo/5/3LHdEZApS401qaim121h2/0212WzMTx9fSOj4UqOsExOsk?=
 =?us-ascii?Q?jrD6p0Pbz3rsU7Q0LrGiXw0mSrRQxuAdwny27sGGsGFEE4KKQkqNhHqYpkK0?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kNlg5rgsEVNbl1RWuHOZU8d0CCCB1UxwjxcbVeFx80tpEkRuc8WbiGxkEvnS4RDoA0BJvCqIZRTqKAKXd7QLaETQzoOgTH9xbBbg4XfmDPG4cZa/Jo/b/fcQgRbJz546Fwg1WqeGgEr6haBRL6uqJ4gcjORnYjBG/H5sDPrCg+qgBsaeYFGgePyoIIB5tYCbOKvNsk9egawANZiEVloukLUrgNKV3WZviy8iprkdM2Hk6OCTByALDGeDVYdDbeaQJb7BgdITCL4ZNTd4W51eFkwNrHOhTedQqiXlrtOYtas6GgUXqlW2x1pkUSvpjVPc/RHqFgj2EZ8h4Y5AFmUT6YyqmT0nxcqRNjyXqoOf7j8OuPYfa1764iPUzrHlQZytLEPSOFUg6sNtOTnNdKsFjhLcQXgcSd0qOMCI2DUB1nJ6XhVRw4Rvj4OWUz8gGLfiB5mVufQMBuMNJCpyFXwKHvek1rYGR89f1t6Z5Jf9OsnOOvX0kWU23AB1RNpvgXZYqVGwhC6z4mD+gzinBoIco3NUuo7iNpKIn35dNy6qrRCHEsBAh8xhyw2MiAMGf+M8XVhDbqRuBup1PBxEJrJDnlI/4UgrFqD05mt5yebaNC0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c22a30-2638-4a81-4db1-08de2f9072bd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 21:44:18.1497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEq+3PkVRbPWEZxbJJq3tZuARJJocoOv0+31cIITFchsL1BJaUrOMn4wzsrBXha372FERmxv5bYIoyW3LYV3uYy/esXQPFwt/Nb+T8RP0rw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6288
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE3OSBTYWx0ZWRfX6ut5wm1JrH1J
 RQANrrghXpPSOPWRzkaGQZwnWojOXdek4KtWJM0GgGA0ghInab2ZAhvBXxw0ZNUwTHXiqwj7X14
 e99IuCB4YxQygf1RMx/S5rcWHkRyCxJs/pYAGp2SBIAvKZHYQCTZ0IYN6cVNn/OA9vswdy9WWLO
 Kw13lrvqxQCdNdya7EGNxtngfy+J9C/0V4k4ADoZ/Zyb6KsxTMea/EmSg6p4z3fMHKG27vfU9fD
 Rdwa0av2ss5Lm91Rf8NZwKs915ZVzu0UYC8J83ryf9m3l71dE51AAFTjkdrrdiueOlMElMRaIeO
 +pJ02E8TQ7jZBwMm6e0aQTSzGTZzcT7yvU+n+IspeDdUFuNbYh5XJrUoFFCeAsNemhDlF7DSP11
 hU6PeJhXRS+0mfqcdn5mUiVNHwPX5Q==
X-Authority-Analysis: v=2.4 cv=S7LUAYsP c=1 sm=1 tr=0 ts=692b6935 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=kOD5xOVBVMNgHCKJDjsA:9
X-Proofpoint-GUID: unfi7cbzw4SFjrNJ5yv02-Juy9T_2lSc
X-Proofpoint-ORIG-GUID: unfi7cbzw4SFjrNJ5yv02-Juy9T_2lSc


Stefan,

> This series exposes struct pr_ops pr_read_keys() and
> pr_read_reservations() to userspace as ioctls, making it possible to
> list registered reservation keys and report the current reservation on
> a block device.

Looks OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
