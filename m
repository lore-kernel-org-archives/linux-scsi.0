Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617281804E
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 03:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719458491; cv=fail; b=LLTfKEim2PLiDeSW2WY/as1HsjQaZX3MTGiBeB136wTfeD+NrzPoGnF+ZX2AjGdH9tPR8JdC+cRNgju9z/XuvNDbOOucQLy/tzw8brZ/NqR0ywatKfJU4UkSv6feVqRqLjsa04FWDWEXKVc7bzKLETFPbJ1vTBulzok4gfyMeaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719458491; c=relaxed/simple;
	bh=MsgxyCVVbpp41/RLFSyaFezPpt2n48qhsirqZNpM3iA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=nSzGUEZbRM9CZC2x+PgALd5QyzAUDaPZWgGbzt02F+6tAh0CnpL0dCNfo2VohJg4Qg0A9yPTmUtGm+esi1HxUXii63Qyx0OMK2N/dl9liPf+8y5DCzP1RtHsUDJcff4EC8TqwwR6tRCeJQs69NZrpYq560noIANRtfw7CEdKFts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H+KBKme/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uu9KZHk8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H+KBKme/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uu9KZHk8"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QLMtUo011191;
	Thu, 27 Jun 2024 03:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=CbLC2xkyf5VI6k
	2/kAOgweX1rmIsVb/bn+mjOhQ9SUI=; b=H+KBKme/tLpg8vmjL+WLfOmBGl3gHs
	yTp9stzGV3uZUCnGl2fXwR8tl0auij/3737F5U7O2yUbX0f5pNX30PnOrZfl9sXc
	l0LN3+DMEFUUCaS0SyKU8TjJAVMOqa4jM7bCg8EHQm7EKogLcOEJesUJrNl1GtQv
	GVtCjhwsJhu14+Pkcv5q+gtp8B1ubnQ25NeDOqJj/NooHpm+r4pTyAvTf1qp0sI7
	kMs7CEBNXj5FbtEOfQBQ68NtsxPAYSXJKSxXivlsFCu5B5pyLgThfmjZ1q1sQhne
	QxPrG4i/Ym48ZbwH8q4A9eJIQOQ7rSK50XeEkd+UyTbISgSY+8CkX+Ww==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywq5t4x2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:21:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45R1Ub3e023594;
	Thu, 27 Jun 2024 03:21:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2gbd0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:21:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zxr/FaqwWwRScjg4BrnLM7K9BYIUeSzE140aB+ru777D3QMNhcNqPqzjD9EGKziM6OcjgivpZR68Mm7Qh8lJSBh1KxBOIwsP2nKwd7UC63Cq0TTmKOK/zyDHNmX+KEispWEkZjquDrQW8kDaUxe1BZKH/N69P1Nkk/wG7OqRzop+b1/0kOF6gf9u1Z2LVI+yo9jGGtG3gkdrI3Sp91BXp+kFT+REyUidND5JqkuRMd7Lfp/Iu7WuxgvOmMZcQKJErsLFddkA4K+9Y6LuYd4OdDL2UeklVQNl3ZYJHL+u7NG74ar+t4EmjUzDg0ge3HBbKmSh3Dreiny7CecC5loadA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CbLC2xkyf5VI6k2/kAOgweX1rmIsVb/bn+mjOhQ9SUI=;
 b=WwW1H3DMA0pkGsrpIx8Ga/ddEv9AKCzunCcUCxxSlEf9/NHGOrkCdbYkIuem5qgtNN1OH+ovuSMg552hevv7sApsmB7DWEwC6RQZkcxTemwg1/hQR0cEw8bHB7QWnPDH2pMeO7jOsY70lqJmAPAciySawPZwC2u9DLCyr5xrPJ5Qf788b7sMJedwKub8t51IhqJJt8yK6N5wWeTj3u/X1p1YB7iJn8layxSU3YP9XFgctWzWtZ+CKjUnGLM0zRjRWprCGgE8ftLwbIdWm+WGYj1vC1IHWH/WRIiUgUKFEpGFescaH3n5PRf0prRZ8rDH8t2c5CFID2dKqUlwQeVX6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbLC2xkyf5VI6k2/kAOgweX1rmIsVb/bn+mjOhQ9SUI=;
 b=uu9KZHk84Af8M54SnVMYa9jh54JCSHrFXro8nmdEp3wd3UsI0pGHeM38suvCcJH007pxQ3/7WAlPMIB/nBkUpulIGnLzkjVd5F2FNJeuX92daf4ORCNvYxgsPj13SbgFfY8np9Ov1chKBCh/YpCPNdjlnvY4ueEiFGuvp+I27TI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7617.namprd10.prod.outlook.com (2603:10b6:a03:545::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33; Thu, 27 Jun
 2024 03:21:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 03:21:20 +0000
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J .
 Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Panther Lake
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240618073158.38504-1-adrian.hunter@intel.com> (Adrian Hunter's
	message of "Tue, 18 Jun 2024 10:31:58 +0300")
Organization: Oracle Corporation
Message-ID: <yq1sewzf4uu.fsf@ca-mkp.ca.oracle.com>
References: <20240618073158.38504-1-adrian.hunter@intel.com>
Date: Wed, 26 Jun 2024 23:21:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0176.namprd05.prod.outlook.com
 (2603:10b6:a03:339::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: a40fbd5a-c8f6-47af-d839-08dc965836e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?B/JZH6W0NVDjOSffXH1umLRnJyeozZmmK2aHJN43hBAgzTqUuRjD2OEOFKDC?=
 =?us-ascii?Q?jAIqpxbTJAwjyEdr6Eb9AOFdXY1jzd4bECUsI1sqJbrCd389HjhtGgUtKFNm?=
 =?us-ascii?Q?KILfnv6+artZTLivxjvPiG9SerxTkWZZh0CL2NFjj96LZgvVyP3vqodHJvvI?=
 =?us-ascii?Q?k30a7EjmrpLRXOJJCFVeZlLnwFX3nUojLogCYruYwOm7u1pnBdVcg+01oVbD?=
 =?us-ascii?Q?7+64oGNKRz9rdHx7MGbjOs3U4zTPdHz5XhNjB5taPeBW7ZfCuRhXXI6GEfqY?=
 =?us-ascii?Q?dUikZb3/WKbnDptDaGORuBuBqg2JJBUut2knrIAaoMmaYmk0/xoGr3VlVCtX?=
 =?us-ascii?Q?UAt+Cf43R0VeygdCQCZ5lTnR21e+WhCU4s4S8O2Z4LN1o04uffL/Q4yAdm1L?=
 =?us-ascii?Q?5FG5HccHlgtlGeqvTXQX6awvNCIk0J830/dwLKoGtgW0gAT9XzH16t4EYLYU?=
 =?us-ascii?Q?8CeIOSjQ8E0aqwlLfa8d0ZTaK6n+KXWkoxqFql0xiGsA0oV+zpGNLGoWCFbT?=
 =?us-ascii?Q?l0h4UeqZhoC72vg155KgARk01YkbvasMb2oK81CBqFIkfFlTbokn+9hduNbF?=
 =?us-ascii?Q?eaJlObHrMnoPz8Ir13dZloekO5zGpgjPlopwgqJKbvx3Y4ifjOCjYkdjGqsR?=
 =?us-ascii?Q?o1El25qO0ihUMp+ziD4tONu/kUkxIyzmqmefWUbGlSaklyFEJo5HTFMCD3R1?=
 =?us-ascii?Q?CsjokeP8ZGHoBuBqDmOSL3hk1qZxrrTYvZN1yOqlPP7kA4QiNDjUPSceVL6W?=
 =?us-ascii?Q?Pov6yhcDJZhktThbyAbH8BZmfMt2xJKKikrPgTja1xDXyeFCVYFUlp3mtikh?=
 =?us-ascii?Q?4euKZ9WHqMx4y88m0awoF15qOzVELQvrx5RHFU50yZD3nZjHeU1ZbbRSoGaW?=
 =?us-ascii?Q?hho3sWE8NM5UwT/xuk7eYHK5B/yJtGa4cnHRhCfAuhjcQkzEqsvjcJw2/fdY?=
 =?us-ascii?Q?b96CdsrPWawXDtMqN75Bbn9p1PNGn7FbY49s7oxii/mTbCZ4FmTmXaiBWV9R?=
 =?us-ascii?Q?mLclVWrhTetFa0UrFQh5VR1T04Pg5rc/+bE/rbI7D8Lzvoh7Cm7qD17Dsnkw?=
 =?us-ascii?Q?W7dsPAWbANXUft8jYuv1RMsKHbQAXe7e/krHS0WNStWZbEyoJa5IVukZnJwM?=
 =?us-ascii?Q?kv5O8evaLJoSrQOfZ6X3IpBClHEfgx+snpabGORR1i7OOYN1eDBuxeSMQyaQ?=
 =?us-ascii?Q?w/aL4q0H91+MUHdgs4IwvFNCghwzkhmdWMhFA0G9f+2XOJdKrayjm1C6mjjb?=
 =?us-ascii?Q?0hOTMzgTxM5WbCDJKWm7aol2Wurl+ge4zcPgGY0akKrM8HJaLBGIOPjo3+Wd?=
 =?us-ascii?Q?8ArMVq3EGWJA0NUdOnMOpDZdchKJgB9JKjuiRaWHbyxGrg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?kDMIJh7FS6eLLsSB0o65kEWjYYi/dObEBK56FVb/wPQGQfsAto2bCW/31t0b?=
 =?us-ascii?Q?uc8NsLz8XuB+nbMW4JTjwgfk9rPFJ++g6nErg6FdQdHJa2DHw8oWcugS/hC+?=
 =?us-ascii?Q?Kp1vnwwaYsqIMQ9YEBkzhiREtE/uF3cao9QmyQQZmRMo79qQCdjQlRIUa2dT?=
 =?us-ascii?Q?bJoV932JyIeJiwSLSWgaeOQKr5s9vm+NiKuESfqtF4/qWOmlxkQV3Q34vCgQ?=
 =?us-ascii?Q?5vlbQxltgfvDbGKhh1bdXAle4JLS7n05Y4j6PTNHlTE6xUrdovJ7MI2IJGLi?=
 =?us-ascii?Q?ZCakvs7zRKFGwy0IInWqj16ows6ON8KDrgccF9dWc7LRQetn+8hsfzewihzs?=
 =?us-ascii?Q?yFNgAEwzRZejgyrtHH7ii3u3g4iIXZjaMJDpYDHuGP6TUpgGpwoYuXh2W2JG?=
 =?us-ascii?Q?VZTdVMShL/OZDJqH3csX5xvhO2EpjZOmEbbtJbwlM/UNigrkpjuGy7oh3+NU?=
 =?us-ascii?Q?9hK8e/hiD+SOx5YDiVpi12FMbsiahGZFHt953ZFOq1GaApFJKP2+QDOU1fJs?=
 =?us-ascii?Q?sGI3RUAgOWCZO8XGEto5pfM9GvDEr4gihy1DYKw4CT2BwFREyL4elmuGgwzV?=
 =?us-ascii?Q?RXs7gQhMpYXaTpJS//qQx7iWXWpV0CXwMnYxBHf1wFDUr1z2TW57dYmH2E1W?=
 =?us-ascii?Q?XYAq5wCNKTsQtZN54akRrS1McbNM/Xez0E/w6zD8EKiMH76/YfTu8eRfPeWe?=
 =?us-ascii?Q?X+GJ1mKbT18IjjsrRu03pEehErmL/Z3r/QcVIhRgPW+GohANBxq+yQcRfjpi?=
 =?us-ascii?Q?ujr4IEuI/ES7b1UwWR68coXy551LAcil2azZdev+Had31QLyU7cGfQIAbMxL?=
 =?us-ascii?Q?NuhKGFVLftLLspthTvWqR+HPSUo+tDAyRAk8VOeU2XClhZbcPYDok9SjHuji?=
 =?us-ascii?Q?QCGulakgqSBrgI+5V1E2zEIeVsdaOtukLrjJb+gjzLFN497+3L4HUswixfK3?=
 =?us-ascii?Q?TIyqKaOTGasq5HQWV14RBfkSkCuioaDXZhhY15IyLuFvSclWEAs5glYjffJs?=
 =?us-ascii?Q?f0OTT8Tjw8ANT+X2wBLIXhXB6X+ZacGGDNxl2ewhSVqF8DZyDg84LV0mzUqJ?=
 =?us-ascii?Q?Gy+Fc71dZAiJtWZlqNRPfEEig5ou2pFqXCiwLzseTaW+fW4Wms8rsgxm8jki?=
 =?us-ascii?Q?swGXHOiq7BXL88TEgvCOkG0SNANik5hZus2D15ItcHC0EmNsWRVUJb0r1RTk?=
 =?us-ascii?Q?TGpX36d/cWCsRYidqVx0bkTuGdBbsT+/HmNWl+wI19Ll8fO164u8WLWCxBXx?=
 =?us-ascii?Q?ZrC3v7pb+NaB+i8P3pombSshAMg21e0QZSxqXckHGWEQ09OPbfasWR8ALTu+?=
 =?us-ascii?Q?UvBjG2EA3/J/GIG97FvtDwKGy+jWmIGHiRLA90WaaPJnRqWf+LUJA1Mi+1+k?=
 =?us-ascii?Q?HUTLUkFoUfLw6KmEPmS1/iJQE0O9p8faPndhr6tLTkTNkpG0QI8Cn3z+kKlK?=
 =?us-ascii?Q?Pb1cmNaW9/uxD6stjjY+7qqRfMEFZX17rFx3vKMrrzcaSaYYGFEqC+v/onSY?=
 =?us-ascii?Q?J7puwCuIXpcyGNg1IgLrhHke28Ekx4MODQ7yWSmhxcaGWj5mgtuazuD5QSY7?=
 =?us-ascii?Q?WvV0am8o5A/c5RqyFCXNhsEVVtzTx0ZDxXGvnJbS05wRdUannj6iYxYZboH/?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RbRyR1FhxtPG+qWD635qr8sONhet+z98FVvp8mBMdKbPuad2qPKl/OW3PLrE2m2WiWN/ZQsrq9V9158DHxJ+HYYIydxscZrxqK7NZnnVYQ0u9nWH2Hn1LOWT9IT13ugd6vcwK9x7FCi/F6IfRTmg/LmmVK3nvBdZweKsoZZTO1dyHfmGe+TYaxglOWfPOtGQaBzaebx4S4xx+2u7y1cNST/odNlK9DpC/zcvh7Hi/BD1EhEQygWzjEcdfkGY9LwYXX8nEZiQfp0+lwbyg+dduMQIAtrSK4Fsg+JVqlbg+oIg/olY/sEAs/beGfQMJsAzZNAdIMhUiUEmo5Da5VkRkxP2XEewmLwXHJErrVKXs3cDtzHlo6GtWDtBXbj3fsaFdAIEbaNlGBf05mvzuOpm4vpgMoUNjM1B6h9fJ/pE664nAXwBn0ixbqq/ByCxQA13m1Ng9BD4ZB/WfgA1yCFnjFPzGzqH/Ys/BuI7F+eFnRzuMTeyK5gueE9ToSGedgSO/zm3XqGjwU1knT2MtG0oC1bMI1V/Fj5MbcZVPArOmmj0SlkWiDHj1Av/KVAmjO5EqifSnHeVKoBvFTDHeiC9FzBVPBvyxt4BFEWar/VjBoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a40fbd5a-c8f6-47af-d839-08dc965836e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 03:21:20.3474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmPPToLieEhL++3v8kzdVTPEQM7DhyugJYmYZUcJ5lMEEOof81/TS7PS8N5EsR33tUhwiqhU5FNXavAWPzNHNGW3PFV5gRhpXgCGDP74VZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7617
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_17,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=808
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406270023
X-Proofpoint-GUID: WSGqEoLgflzMnnxU0LVoSPsq46StPo0p
X-Proofpoint-ORIG-GUID: WSGqEoLgflzMnnxU0LVoSPsq46StPo0p


Adrian,

> Add PCI ID to support Intel Panther Lake, same as MTL.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
