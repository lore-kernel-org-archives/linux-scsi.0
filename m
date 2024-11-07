Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1E938382;
	Thu,  7 Nov 2024 02:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730945254; cv=fail; b=NRi2Cf6TOTGxPg5ucUpS3ygT4fMuiQ/7ZgP31gZSIY57W+Zm1suNpqohClxLvhJVeUo5Mu2YqqWRYDAPg2yP633KAKe2mxPPS1glbu+5QfpNI1Ye4xod2Es557/9Qh1uI3V6cTuuGlkEkoWk03Q/1gE5+SdQ7meLTHuwfH3FAeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730945254; c=relaxed/simple;
	bh=2B4jXmSKSuko9tR8PfPuqeewdF8DBbczvtRg0nbK7dQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u7bakrOB/aR/qnA9P+q3a3ANoUfreHoABu7isrCIEDLABxnflEfG9Nt95v5LNfF0WyVUyR281/T1YbrzGHXOKGm5IxQRa7kT3ssTqS9ryHJGtuzrPBjNeQt/y29iGSofoPe5fn9TzdehcBKvhD+N65zAs8HJzRDRTdwB2Ei+vX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TRRehrkq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JSV9NjKk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TRRehrkq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JSV9NjKk"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71h7re032578;
	Thu, 7 Nov 2024 02:07:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=MCN+P1wMnTSx4vor1b
	le0s1ng9d3zopzHeXyOKcfM94=; b=TRRehrkqfS7swU87JrCjC0edGz2F06qUjI
	BLvM4VIT/s6I3uFm74IhnZkPBMFcepJ5ly0NXpCV6AZCJzeoCnL6yIX1DtgzUHbl
	YNg7Ys2rrYs0cxKa5DZs6ns19JdFO+0v59v4Zi4pEgQYjWZhGXHNj8dhwL77u350
	3BWBGDfdn75I7Y8g2JpT6Dw5HbF/h5lKxsOWXEv9AmBR+ccb1CZKfsIh+o7ZT7UL
	NQqY6bpbk/d48RsYa6/TYKzSAxM8A6CxxF6qUfWZO9P6ifE2GVFUjUWfdjOX5ZyF
	sdqR92jSUiwLEvt1njXjXEewB6TndP7IYs1g14L1/2U+ITOX6m2g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42qh03cjct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 02:07:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A70dSAN009871;
	Thu, 7 Nov 2024 02:07:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahfpp3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 02:07:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VrBWiKM2kE/mCejrMCYG7hnCyR5rj4L+OfRjzxooRVstHmOlG7UVXYz+NUI1F8WtbjJ9PsmGyLWVFPjaOLl28MaXerev8e1uUAYhxj0GHdHOFPFN/8wPOdvVDbVssyhbTN6yea3w3dEVTynSqhLLlOrWZzxol1xq1jTrxkvsvBbki6DCV+tGsmWhRZ++Xk7tg9h2/v0XhW8IOg1hYK0ZtEjeoOv3HYLjZv4bdkgwLEp6bLh61cQp3ir4lxPudM3ACmCpt0qXlJUoaLqitfP4ZCx+KkYti+v5I7oJIx0eiEU78eOIZ8GJjrljuJs+woSxUME5BakPvqLHu05kpbqD3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCN+P1wMnTSx4vor1ble0s1ng9d3zopzHeXyOKcfM94=;
 b=QCQAfzgguRbM2ziHRV4IgvSCU4d3PYUdrq5gyLDRVgmdQKLhuWcyUdl3vyFmrDj3SBTxf040l6AsfHd2MlSw7rGfAGMXrfsS7vYZFzOJOWqkqsMXs2EpylKmHKFUyv1jmDijk9+/b+82B0V13uqU/EJuMZGpHlmDH9tMbm8fZ5E3FtqUt9IfzNEixpRikXONCvxr665T/XhritMeU3/hLqx5tWUdIhGz1yCccPolImOT9V7E4g4X162avyjVtjbtSqDxDWDE9qHQoHQ9HvqhVMZiDH3nBZ68LZGJU0xyDvEbqKo2PTBhIRrTBp/j5kTa3E1fN44tQdCX0rG8kB3sXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCN+P1wMnTSx4vor1ble0s1ng9d3zopzHeXyOKcfM94=;
 b=JSV9NjKkGJS+QKkSfomcZ9iv2ZGhIeRzdSlZLdEKdrDEa+uXuNjJ4mU7rKCrB/ZkKlsEbrC5s5dXgCXxw6bkhEeFgGizk572NPJBaf+aP1v8j2bepn+bGGnE+aBL0hTMNpwrxH8glTBV7zd5kblPjPuEtkkhu1h6m9ihyV5Rvzs=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by PH7PR10MB7696.namprd10.prod.outlook.com (2603:10b6:510:2e5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Thu, 7 Nov
 2024 02:07:17 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 02:07:17 +0000
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz
 <schmitzmic@gmail.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Sam Creasey <sammy@sammy.net>,
        Uwe
 =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] scsi: sun3: Mark driver struct with __refdata to
 prevent section mismatch
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
	(Geert Uytterhoeven's message of "Tue, 5 Nov 2024 19:36:31 +0100")
Organization: Oracle Corporation
Message-ID: <yq1a5eb23w4.fsf@ca-mkp.ca.oracle.com>
References: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
Date: Wed, 06 Nov 2024 21:07:14 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0231.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::26) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|PH7PR10MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: f08300a1-dbe3-47e1-5764-08dcfed0e783
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dWRQ/ifEj+A2dioeKT/p/n/LcF2QPy0HXgORwyzJ0TL/TvaIudASEtP5okeD?=
 =?us-ascii?Q?giR4pgxpRkst2W66gAmFHtaABKIoz+vKV39mlUsWDUAEYHkqv2vyeDNobPC1?=
 =?us-ascii?Q?gSTSU1On5U4yM3Y7WCNtJrEzGsnRq+uhRYtuLRtEDHHzUuP3F3+WNioVQlID?=
 =?us-ascii?Q?/kwB7ejKllh8tUVzrquuNqnGphsysiOxByAZQWhd5+qlRcr0xgLeqVXh5aIc?=
 =?us-ascii?Q?l4vC98h6w27W3oeCreTzNprEiHMKu0iagocHgkI+mDPwCaLVaL4MAalsyb0D?=
 =?us-ascii?Q?1+wwYC0lt94gLzFPxCXdwH7fYMwo9bSwb0ymtHcLFWLeBHiR4CFz9JzgzzRB?=
 =?us-ascii?Q?ufje2r82VboPpwtHI9z21UWj7K/r6vBGu4Gc5thPK5y+8sHNQHzmhhEDcXNU?=
 =?us-ascii?Q?fl1sndSiSNTFftoq7SIqEf2LPiWsenB5hZ0fXO9j/RUR1sxHEwMwXrUzdSMk?=
 =?us-ascii?Q?PJgzRyAcIEErmyOF8XMr0nf4nG7AEWDuz1Zyjt+h14Tbe30GNhySgdM3Oyum?=
 =?us-ascii?Q?zGKz8AYt3aEcYeq8bM6DpIMOUhmz0miU7SSxNIfbB2pZZcUqq8wLnYfowgJt?=
 =?us-ascii?Q?QgBKF1YqOrpI6sdZRF+sn3+SYLo9mD9WDFwvb4oVYbkdDH4a+AP/2yK2BVNO?=
 =?us-ascii?Q?jvNq0p+CwX0ruIYyN5iFdNcYg+uOuHQ6olUh9zhGzeRfsdG/DFEhFI4+LBi2?=
 =?us-ascii?Q?hZH9t+XaVbgBUflPOgw8POeSVXaUP/GC14qg8xyb8J1hEozMcRAyR4LzhCwq?=
 =?us-ascii?Q?f6FRnn4nc3X/ePAGjRKL0ijls00SZO5PEKYNawW1lXMokwWWKVZTF9qW+9hq?=
 =?us-ascii?Q?t1w3FTWzS8jzG0oAB0bbhAC4R4L1s7zzpHW/25Ft8Sm9y+pfW9eU8Xgrv8J7?=
 =?us-ascii?Q?nMrFaFX7157sd0jeotYOhvUuD9Qo8Y0/POecGmMqizlAaxRFG/kRTYIUcDRo?=
 =?us-ascii?Q?Ov4ZYQIn/Dl2Bbglnnpqoycg0JYfIB8qsUCV05+eDnaaVGeeVEzZq89T+HR4?=
 =?us-ascii?Q?y0W9GB7zfEMtbwEnGjkO8JgHxmPlKBbrkPnDG/Is0cSpsKLMMD9Uas1EgIK/?=
 =?us-ascii?Q?nD7VqNKhiGre1lvwGGmucBCHZfjYeMnl51oyXHpjvQQ+TY3w5MR3laa6bxu0?=
 =?us-ascii?Q?9G+EJRqAh7iYu3hBxLktfNdw9XLq6uXuxwazHliPeIrsOy0ZOYIM9YTeQSrU?=
 =?us-ascii?Q?I5Qnpehzn+wsK2i/UdV/d6EW6eEj2+OwacpGB10lWM5b05coQny1d5P1LN0W?=
 =?us-ascii?Q?SJQ60Zeirdo2T5SKtv+B/3tnGiMTi5uLDFJO7jLlLW6kUPACiuGEjUhgRFYM?=
 =?us-ascii?Q?5bQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GiNAqBMTAiY99g42K+qsnXy7GtaCzXHmYMaOPLJnHmg3fDw8h2nAotjL380w?=
 =?us-ascii?Q?fLRIpiJP9+xImOJMZmgYjIuFNCHtGMwtXsx91EHqMNvMly/BqMcGlEIet5uo?=
 =?us-ascii?Q?IQpUo8JY/cj7fjyW92gwvRlkOIsl9Aq3rwR9Oa4oVO4OhU30M4cOP6ipoWXG?=
 =?us-ascii?Q?NROVhm2JGftkiWEl+Dy/JWnhPkxvZB2eCqAyNIT1Fs5aw3mICExsGHU9nhPh?=
 =?us-ascii?Q?kCpRKW4I0hhqwf5Cbdl0zDuotfxRhbRcUjET81+ghP8qqRd9lOiLiV+tYA9D?=
 =?us-ascii?Q?Xt1Qmi9AkNW2I6iLIkQz9G8WFV+d4eoU+Hfl8jhC4HEGyWU3pLlqPn23z7db?=
 =?us-ascii?Q?g78lfHIDTxZ3BMe+cEXSPMCfxmw5gbKMF9CrbExE9JyS/apWmuRJrzOiq+Bd?=
 =?us-ascii?Q?SpCbBalhamxU232rVWZWQttrExBKRdLaCnG0xwCucKCkNW40N7xZPKWMnslx?=
 =?us-ascii?Q?AwkNpiSrpKr4hXGVudIQFTFCApXWC2K1H+RJu4nu0GyPP5GDREgzzkGwd8XY?=
 =?us-ascii?Q?zb+XemItLDi4SoXexySQbqMr9yuEnaUhF+E+CNdgjCCE19CcwU9RwOh3DuDS?=
 =?us-ascii?Q?sk6ztnhlzMQ4RZgZ+9oq1ODUBewndOIZh6Z4QHCrH8hDAQnaCcPmDpBFXu5i?=
 =?us-ascii?Q?Zp4v7ONdZYGFjXtP5WrNCQpeMJ9VBdxq5DROwJXW9tgdrivebu2u7uQ1mP26?=
 =?us-ascii?Q?4MCioyFnNJUN+zJUm8snuQf1amW9EyKMbC+5gdbGHv3mHE4/Q/laCS0NbS5J?=
 =?us-ascii?Q?CHlUJcK558dmlwYBjE2ENKNCigjNHgK3UahEjOIB3CfBOyoc5RIlbN7AlKMl?=
 =?us-ascii?Q?ueTm1QgtfKLLI3z1voex+LSCmuWxGOCevVU4cGk4pLwfc2cuYvQhmLqYz8Xy?=
 =?us-ascii?Q?J3aRyw/cTEYcbLgje1If3FO55IJaWeboik72QyD5RJIw3jWsatN2b4BwBMIz?=
 =?us-ascii?Q?UsbBFZIUGHneXOLHlxZarJwILjTX6CtbZsOVmfQmLY+qI/+XP0wARzA5vLvN?=
 =?us-ascii?Q?nEqJEeolxp4ZEa5hECDe3W8enEvSO8ZgMrbSUgmYjQo9U2CD/E44KlStnXum?=
 =?us-ascii?Q?gotxHdEIu1b6FbqxRuqdoPrVTGmgTbIOfSFPXuZZ1CPoWtKK/OiP/UE1X8eF?=
 =?us-ascii?Q?KHEAlXbMaiP3KY9fJDk3JvsqjlR4/uFFiQrc+nQ/urL7Q3go06zk/YZSdeiZ?=
 =?us-ascii?Q?xDvsq4sH9msdsbjrvLXo/zuN7K0W2c/szWEhJr/gtERZCWrJVXKUf8oYh8ZZ?=
 =?us-ascii?Q?s2VGQ0wHm+RICmgTRpqUUyV502iViQUGkvHfXYyBoZFJJYnjiP9iZji8wsbe?=
 =?us-ascii?Q?SE5UkBx6HoUzRPAuztMws3FkAMQJRHBsyxTEGV1Tvq+Zv0ySEx7DlyNnRPyb?=
 =?us-ascii?Q?jvPuVtEKT+Vsx59PcI2Jqfp9BxmyClLMY54GAoeh14UlB1KvS7tXvJxkG3hw?=
 =?us-ascii?Q?4sZULd7qeLMQfGZISuP5wDr77wMTWqCJXdrwzJF8HbOGC4ywp3UHZ85LmRjr?=
 =?us-ascii?Q?WUDu5nPAFqqvA+PBsaGCQV8jJkBAa6edr9L+XtDqboR+tOevqiG7UjsIZXUY?=
 =?us-ascii?Q?DbFsG3wT7j0Pz/3/1bx9I+DN40VlUtMce/Y01pL4r8+frh82Nrqvs1ch05Zk?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N1lgxA2C1DU2ABcfHvvXjbZZ3g1xVNJ26amW3IQ7IoM+wo0WZxhOACSmWLuAlD59huYidb+M6UUVtVji5xiRrmI9X3TtNZun5S66khK7mzaDMo5NOEUuqh6PDyypNjWHl46ZTi96plcBC4ly1/03Yrrd11BZAyBHED+H0E61FPCVbripI7eGRLHW2hWN3lrGGHerVwtYvRT197Ifh01dWOsOYDUr/4nGqfvi1dPjbKKUVsAKSPfy5VjC8cekmpEEyAhGg5l03KmDTbjyTN30qg9rgyKHncW78UY3Xi3yBWxS5Danvz8x6A10MvNBwc127JaDIfcDWhfL+/kW+fNQI86JlfJsXkM5KTadDcB4TZzAgGzo84m22FcvYIjVlVMqIzcpxaY/7ii8iozHar8azqKpcvPRnNDWghrzkEHeeRmVhyYw5Qr/0PtW8b1mxH4K/x9cgNawLuLByDGpVHySCHLEj5ICvDxfG1VUwp9B2stlQLCoTESlhAnTPLs6nhBfkNaicwW0gGcH9XzXcoPMEPZnLrxvPV9SA7cDtlSKlpsbfmZ2F98Dr7KB3m4W6EzX5V/sNqYyB47XhhovGgP6UBVvksFEim22p4vSMJGGrMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f08300a1-dbe3-47e1-5764-08dcfed0e783
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 02:07:17.1581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYfLp5IyK6Bgv8RzK0a9zcbyBfF9IRal3slPFqJLiaq61+YO7ulplqrMo/ZIiunJKxaIsgJ7k1LxXA8Dx1ONOVfSCYFxrDjgBJ0PaDBlC0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-06_20,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=664 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411070014
X-Proofpoint-GUID: FZLAN9mYIX_lZL-RHkg0Ztjj2kL3IWBh
X-Proofpoint-ORIG-GUID: FZLAN9mYIX_lZL-RHkg0Ztjj2kL3IWBh


Geert,

> As described in the added code comment, a reference to .exit.text is ok
> for drivers registered via module_platform_driver_probe().  Make this
> explicit to prevent the following section mismatch warnings

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
