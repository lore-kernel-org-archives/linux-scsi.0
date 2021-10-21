Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847B8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B73E60FED
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhJUDQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:16:28 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6820 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhJUDQZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:16:25 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L24llH008005;
        Thu, 21 Oct 2021 03:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ft78qF5CoH8gXD8JI1WDRoM7mItz+zzYKZWiG8YfHO8=;
 b=XCpjcnx1ZbkBEf0qIuaJQsGPAePP2HDei1d4X9T6/wFRrSoC9QIkNHfJs3uLj+MAvEhU
 nnMB73cNfZcHd4Cq7mrxpfTYmp9AOTNEmDber+JbnzAzjDwGKYJhhTsU6E9XHv2vIAp5
 fXckNK4mvx0Nro1XI2on8gEAnAeQGijMaIXc/urRuHI2plk/Om46KVMzJHBEY+4kDGtx
 +tRzjCURIMKUUCgGt4ArkzKBWmBQZnrtZNcHDAVErQuWDb5D009AE/7hmCkJhPMvWQF/
 fWQN+2a4frkjCN0cvn5aU2foP9G0fVke9cl5xDv3T07O0xPoOq3VtHtrBooMl5DG4XFj LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqp2jf57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:14:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L2pDgI060516;
        Thu, 21 Oct 2021 03:14:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3bqpj8263w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:14:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQeo8ppmuidNbGYLd9ch68MKzPORPjTfsCYrEDzlISsYdQjhQS8oQjBYlexQohirDzh2SK8Z6go4zwtHKcVmbbQ093gXavBr6pcWUdVZaT9R5iNQyHngL/Dd9OXw+sScOi758LhWpjzmdIfGxpGUKpha2w0piItvrY3dv5JxALba6J79jgegLuyKG00CRa2efrsIGykCm7WGvkteIcioRDqkv+4HbDWG4rAbDhbFaNKIbI5vCpUm8AvqzqPTrhXrjnWie4fEQq7N40F/94i5shjTS8JpGf+0s8jWzkTT+hI7ExHyjEGZMUedv0H7//2KQPmzyGPpabepvj6aILib7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ft78qF5CoH8gXD8JI1WDRoM7mItz+zzYKZWiG8YfHO8=;
 b=X4AMIFxV22uLQd5J7JwuU7tPm3rXefrbeDCgDP6aReEft1REAMfDys6X7oXVMDB2cKpIHZV3+PHfqyW4vPDCvDWG64NB4FhxayhQXNE924PMaNg3O414JV8C+CpLMLLsk1WiKOeh2L72d7BdaoTJA1usm7KSYfjaxzRLKcM7UCDUzyqr2g/4S09hdsiNV9MGDTZ5/orn0VDKJjOrIZQeO/NfkLahfOWfkJLYfW+gjRTaC0WWLqby5YejW5K58tgzOSi8wFM0Mhm46n8+uRaHgXsRKb8mW1wVcla7fq6NAyqrVD/Sv035f4A8wv7liZx+pksCStF3xBN2l6EgAOqHbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ft78qF5CoH8gXD8JI1WDRoM7mItz+zzYKZWiG8YfHO8=;
 b=wmKbSmFRniA1QoLQZOd8WZ3L0fH7YIwuHPLfHzQMFuCjE1wT1eVwzRCsxIJGrPVrx///qPz3AC2xj6Cm5lwGdy4Nrh+0uZcEWq6uxrhgIXxdKYkgwWjVVvxAIFJwPKWaLwEf7NnGMirCTno0hsZsXuSHZaJyhT3Ew9sHqJTnqfs=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5532.namprd10.prod.outlook.com (2603:10b6:510:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 03:14:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 03:14:02 +0000
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, draviv@codeaurora.org,
        sthumma@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm: fix memory leak due to probe
 defer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v91r6pei.fsf@ca-mkp.ca.oracle.com>
References: <20210914092214.6468-1-srinivas.kandagatla@linaro.org>
        <48895dce-8c26-0763-419d-9b53d7f7281b@linaro.org>
Date:   Wed, 20 Oct 2021 23:14:00 -0400
In-Reply-To: <48895dce-8c26-0763-419d-9b53d7f7281b@linaro.org> (Srinivas
        Kandagatla's message of "Wed, 20 Oct 2021 16:47:47 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0031.namprd11.prod.outlook.com
 (2603:10b6:806:d0::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by SA0PR11CA0031.namprd11.prod.outlook.com (2603:10b6:806:d0::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 03:14:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1aed7ddc-7b80-4818-1109-08d99440d53e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5532:
X-Microsoft-Antispam-PRVS: <PH0PR10MB55323147271D2247948D7A908EBF9@PH0PR10MB5532.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TDqPVxk0ySa7uDypZmGjdf2bESivyEXkPG3Sr40ZAIeGAGzoNxYaYDfTBl8Hnbxj5uIzYPj5xcZRkVQ9jl/CahVD5JJTnUv4sKXAXfoIJm33naY3TcohvDu3RSJMBeji+gPQ7ws4V4hXr5qM2vjk3lvIrBq8fnQos21OHdLSJQRTcbvhQGqoi9MJhZmCuRvbH3efHjQE04pbeXdcJTwP5T6h8njXhgFZEQ6JlXPXFxxR8H7GmOr4/qUKooZdAW9aDnT3dU/fSKN0qI9fmUtYAaSx3dyLlQBhKCRqG2kCDiCG9YeiixHkpa/08SGkyfr+ytC9iDqAlx1Ancefi74IrE8e7i7DdOww/CTQhxNhxE89vqSe2J9aFMCvgR9JyZxfEqOARDYAHiiwDmA9SAGvNYxwT1VWpfJ13ZwkyUrlxYgYnZydhLrVUCRhM7JWJfeZNddBfX0CxHGdoT1cUVkV1tgIWwg3HKHSGwUQ+pacV9mL+rynpyB/UTwi2km8oeaD3lsuakn5IpXaPPZLtCKHD9aRpn26K23NHwKqlXPmKk9HObJcWOpm+b9jjPv9r0h3kbJ7b3JLsohbRG+ebxtJLzMyVuFC09n2kZ/jEBNTRi3WuOz+UYVEMzrbJbBu1CFk+qOKEj1FM+mWQqJ/z1OkbHiPDYx8S3NV9EZC3ZMO7lt3QEBbfsScsFnQzn/DiPoo8a0dt4j6JkjwhsPLnY2iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(36916002)(6916009)(52116002)(66556008)(4326008)(7696005)(8936002)(66946007)(86362001)(316002)(66476007)(38100700002)(38350700002)(186003)(55016002)(2906002)(8676002)(4744005)(5660300002)(26005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mo4au8mEwoZJjkNbi4t6XogA76l2bUARlTDE00ejpQnVsZoMhbcWuTT+4zKp?=
 =?us-ascii?Q?en+ISHkG5pavYWplFUkrREit7L2r8mHOC0qW3QEH6V/jV4hsUFjka3KAXkRE?=
 =?us-ascii?Q?Saug6lIvYuMfZXbV7Ri4YyRyT1yyqehmdjf4PTBmEbM2zr5bQedUV84lzbaU?=
 =?us-ascii?Q?1Dk8AIFpQEKLSn9SjV8A7z8hCV6emlnI8FCQ/LtuVtsvtKZE3PYWATMMKfxF?=
 =?us-ascii?Q?p/FpzjtePM/f4eFCDBUyX2raxbpfD1MQAL9ACwRIjVFTNMO8qgbeKxbyd+jH?=
 =?us-ascii?Q?4sFLvJvcS4FJ+M2OJs54BRPKEETZwRhrY2wWsanPphYTOzjXIq698cE9XnTt?=
 =?us-ascii?Q?Na7gaJlbchsmskYuHPwd+0jBk6Wi57ddbMDihnaWuaQRK7jQfyI3YOarSgNm?=
 =?us-ascii?Q?ebfK640m587uqTZWKIT8XpyfAcr+d2rYQj4PyP4b0Eig0MQc2Vp4SiDhJJki?=
 =?us-ascii?Q?gMrv2U+shT3UpgdyE7Vt+uASUhF5XhY28NFMrPwZX3HWobEqV8UU9X/bNmtX?=
 =?us-ascii?Q?BDZ9oJIk317vNeWmUUlAaZqU6q8/d6b7ucfXgam2pdjdZoWeCs6hsjDCKcrC?=
 =?us-ascii?Q?MI7pGb9VEC6PKIvkdqiNMCNROyhh3qVxgDq78AsLv3NTto9t4zo3odwrFXtU?=
 =?us-ascii?Q?HSsVvwBPAdvzaHsYnwr47xdSXF5NeCzRhQSKQT0mg+ex2mac5h4CNOnh3OLM?=
 =?us-ascii?Q?QWzTIDfQgB2CX/kPa+w+9eqx2w1Fc08Q9SmTNMnDh1D0peiC2bQ7jSJFs1R+?=
 =?us-ascii?Q?8MIKrRor8ni1cSylm2h6VC5LvFc6wka62n9b5xPyHfmC8pO/ziFsMZkr7ei/?=
 =?us-ascii?Q?NldNm1t7vUQX5TKoA0x6idm+t/JQfVeZdpRYH02bRK2EK/ig4q7sxf0cZZgV?=
 =?us-ascii?Q?aJdsAxIrxAl/KFdSUEMmYPQlm8BX43QxhhDVfoLFpiiLviTx1e4hQXVIu37t?=
 =?us-ascii?Q?N0y8h8yxcVZeepEAosur4n+zLx90qRmuWPHZo7lco+BjMtoA/G7SGHac5qmS?=
 =?us-ascii?Q?sHbMNw8oUOzn1H+ie4/iYyDvqb/bTF7SBqq/nWhGlK6lzJ0oro8EVHuy/Tje?=
 =?us-ascii?Q?U/UsVbZHvDbddSBw2uJ5q+cY81sbtxIhv63r8FLH/YMgpL5zuMQE8LwmU6aj?=
 =?us-ascii?Q?1vF3hMbuUd76e+QXXRWDa1XTTyzhEEvCu9l4t7/0pgQLjihjDBlOv9IEiKxL?=
 =?us-ascii?Q?t0mzducGZ5UKW7BZ6ubZphQN8LbGo6imBY/4mIjaicHVqu7VIhNLbf09L2g8?=
 =?us-ascii?Q?/HvpO3e2fYClQjrndbo8g+WqlkBRFhbRPYGSImOZUahc2rB1W/B8T1bO6hGK?=
 =?us-ascii?Q?glS8+5z0Rx0/mEwe0IjV03Xyls7WeUm90/qWVVaM7YLTdaP8muXDBbEAisRP?=
 =?us-ascii?Q?8udohWMepkz2muSJUuWd22l4kw4226nteeRCAHkYg65G1QQfdpZpWCMGTZnk?=
 =?us-ascii?Q?htUDHZA/2zGVmzwyoJyYnSEktI5CscXp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aed7ddc-7b80-4818-1109-08d99440d53e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 03:14:02.7362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: martin.petersen@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5532
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=926 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210011
X-Proofpoint-ORIG-GUID: THQ3tpdv425b15JqXOhKWXmDlsH9Ox29
X-Proofpoint-GUID: THQ3tpdv425b15JqXOhKWXmDlsH9Ox29
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Srinivas,

>> UFS drivers that probe defer will endup leaking memory allocated for
>> clk and regulator names via kstrdup because the structure that is
>> holding this memory is allocated via devm_* variants which will be
>> freed during probe defer but the names are never freed.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
