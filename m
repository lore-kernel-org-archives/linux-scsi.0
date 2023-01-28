Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918F3C61DA7
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Jan 2023 20:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbjA1UZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Jan 2023 15:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjA1UZm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jan 2023 15:25:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7938911674;
        Sat, 28 Jan 2023 12:25:40 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30S5IGbG024000;
        Sat, 28 Jan 2023 20:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=BVv37RfEWC036PPO4PQBFFJOIl+A75HvFx4L6pRknvU=;
 b=KmmSkC3LqHMNl6Zxq9HGlhoc0B77g49BFoHJMj26vwHGrakEazj4Y2qdZ+d7mVcqOEto
 dsUW/BHGGIJzMV5pez/JO2EfY8ua2wfcJn3YvwRpHRGQxVEwSS4rIhJsZqf6SERXWG5X
 Pq6gf/aTUU8dBX+h1va0DWRYGmNQAJkDJ02Xv+i7d9zY6P0cowVMh1kg2YCv7hF7JGoe
 JX8fcqAeflPG+SeBznKw+qVcsgZqyL2/SbBlcZ3pWeLS5F9dyY4WhU7RJna30cF+8+uh
 cNYcaZSjlTXWpPwGV+9zBql/L5/5wGLJfyIJrpckryVMPJQzvN80FSBub3smoF9ign8o Cw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvrjrqb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 20:25:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30SFOu0A037436;
        Sat, 28 Jan 2023 20:25:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct59c661-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 20:25:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8o71s5TrCZdb+nuLhd4zowmDGDJe8+igiGUz91CpAe2AJF8UsrNrAuWmWNQYgCiNtRmvWex3Fqh4GeGEVCnM1XT6zbJM7ReVYj+LE96RJEXb8tFM4u+et/3y32twaSedU8IsG4ncxV6jG/vEkRmXJ6hLhNN6F4MguMHI6qYOTrzJJt83/DnK8R57AQn1/sD23EKMEJ4Ujv9Kdq3zfJVyb+qI2BN40h+VTwtQU14K3tB4iDpgOXyz+ZIREQ7iMFodG8FAkcojkooWKd3OQZOm4GVDH40zkcMCZ+dZuvVdtlZfoPxW0ZukNBDZIeuoAXgRNBxUPnUBmIRsPzo3IeIUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVv37RfEWC036PPO4PQBFFJOIl+A75HvFx4L6pRknvU=;
 b=lQeEytO9PFv8BVqp+/MImrUI1yno69c7/dSSeSYyxfyj/X4HB/WtRPCuMj6L1Y2M80/6EYtbBE+UDHn5v4JKw3yqeEqZOq+qfeLOtc4HXZBknl08ebtc3n/7NdBughsDyi9a8DjLlYQKjKCEVl+LkbAO95aJiK5reGPdDNWWAeSUW0EHAkY23KCQOZhzLxqSRu31TElobdmQQ8JQyNt02WCGjQAbNnmbNYVOwI4kc9/1kUXV9pmbxz/RWft49YnN5T2D/wsthtTuzNtUTdEMKK6Bglgr9BPvWrjIi/7ix6LbnK4xYZKc6MUHUHhWWUw4jgliqWVlbIRLxbtAabnzxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVv37RfEWC036PPO4PQBFFJOIl+A75HvFx4L6pRknvU=;
 b=K2Zs9aKFTaV2KE9MMKZWkKyGSFQ3ndZwI/4YH1LoCLp/Z22rUmtxnwIhZGKK4P0M40kS0jUJShJOHIyFQl2sS4gYiFyjfm85CwvkyX/9Gb5iaOnGPd3+gHN65YnmhMpWMLInZKY6qmlDjXbCLvJjyyZnq3DvWjcezUlBNhLaEeo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7184.namprd10.prod.outlook.com (2603:10b6:208:409::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sat, 28 Jan
 2023 20:25:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6064.017; Sat, 28 Jan 2023
 20:25:25 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0veh2fa.fsf@ca-mkp.ca.oracle.com>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
        <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
        <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
        <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
        <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
        <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
        <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
        <e8324901-7c18-153f-b47f-112a394832bd@acm.org>
        <Y9Gd0eI1t8V61yzO@x1-carbon>
        <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
        <Y9KF5z/v0Qp5E4sI@x1-carbon>
        <7f0a2464-673a-f64a-4ebb-e599c3123a24@acm.org>
        <29b50dbd-76e9-cdce-4227-a22223850c9a@opensource.wdc.com>
        <c8ef76be-c285-c797-5bdb-3a960821048b@opensource.wdc.com>
        <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
        <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
        <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
        <4e803108-9526-6a75-f209-789a06ef52f9@opensource.wdc.com>
Date:   Sat, 28 Jan 2023 15:25:23 -0500
In-Reply-To: <4e803108-9526-6a75-f209-789a06ef52f9@opensource.wdc.com> (Damien
        Le Moal's message of "Sat, 28 Jan 2023 09:59:16 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0030.namprd05.prod.outlook.com
 (2603:10b6:803:40::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7184:EE_
X-MS-Office365-Filtering-Correlation-Id: 02fcfdd3-d882-4cc8-70a7-08db016dca02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SpMh0pRwwxlmd4Z26NQDk1yEMj5YM1G/UV19fx2EMLQ+uyPknac/+27Ge7NGA+nY6mbtPFiSIp/d5BnY7qwFHIJqe4Cjlr8jLycZBHj24X2waeke77/1SKImPgTuEm1Jg+whZRAyZ45Qwjc840KUowWxXfgbN1+HGSH5sPfl2k5USW5U4+B1l4FS6KO9vbTlfTBhvdd6XPeaAhSKvhFAjDyglNot523ZK0twVJcqicnuJ4IBuBDpmkB5p/oy1vWY4BKJ647+aFRdXyAneQ9n26HKafp8t57qVMm3lg4PWZ72nA+6kfHfqRopNfsDMI0kUIh3cdJDinqpnIVAr5KHdaioa5gRE3Iq0z+vULXLOPD4ObTMIqTTg7qaLFACboNXeuALtiaNvgb02iJhXePmJTG8gPhpra3HpsQdU0twj+cUn04ScIzo5oucdF2mAY6ZxVdx9+QXBQ3G3Hd99YXmkWy8mrluVAd5kzXPaB1mXtC+1JWGjaouTc+FHMLvDH9thwyVOE2oVzkMViQqKNsWF4SL303g7sKUw6/GzSQGPfH9ZyLtK06BwAT6JdQwNMOBFxB3qWrpHpUeR3bEdQhZWdAejxleQHItUWFsUv92bOvatF9eXtmw+GNh3yjGJW4KI0hxarT7A37EbvV/ICT3Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199018)(7416002)(5660300002)(2906002)(38100700002)(36916002)(6486002)(6512007)(478600001)(186003)(26005)(6506007)(86362001)(83380400001)(54906003)(316002)(8676002)(66476007)(66556008)(66946007)(6916009)(4326008)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5V7AbyvpO0Kiq6/TLwZ0ojOmySUdqO3RDXRaaiIRmh131ANAHpUc1p6QBxCw?=
 =?us-ascii?Q?NjaYzKKXm85HINF0GXyOJzEFp0Kb9pd9Aeilan4QxkyxAKOW9fqNqSI7z1nc?=
 =?us-ascii?Q?+Ol9mSzNIe9Jg9WQ8K+jeUxXIypOuN569pAUhxM3K7v+OKNvP13+OPEQpPAp?=
 =?us-ascii?Q?oOHaJDdkosJ5zZEtixWZuzKMK/GLZytVHX+TbcZfOnfqEiVLcQzaJRdXYUh0?=
 =?us-ascii?Q?9KO35nCc0OUcAnWkQnChfZS8MZFMNVAAIxOBoHWPOxMvvJ+Q8Ytn+gnuxnFe?=
 =?us-ascii?Q?xE+pjx46ycN8Gn8KfyT1jJ3T7QktKnIA+ir9om3TL3CJhrrvt3QRGdNcE3QQ?=
 =?us-ascii?Q?smaLNZMUg4AZWsPFYtWYCAkg9InF4sUXeO0LT7i9YLa4iycNj2FYxCbcusdD?=
 =?us-ascii?Q?ExTh4CiXBa2wou7ZDrtltuNYjtzTL5vTG6RvJFkhb4cgtNLU2/eDtNQKDGG0?=
 =?us-ascii?Q?9Wr7HjSnITY2AKQiFNuR1Q/c8iKRRJmToFCaGrEy2XiUiK/tAmj5L2wqHi7E?=
 =?us-ascii?Q?BfA7fjbCGa50OAfnNV4RNTH5JAcv/YxUBbkeFFXRLVssVXrxknaKahmJQSAu?=
 =?us-ascii?Q?PidSRs32zy1swbCVHLfWieTlzDIqhDxNFLo54OkVLnZ61NcAuSoxeRJV+45C?=
 =?us-ascii?Q?3uvyX+7K0aDvkPGSgZNIda87Gi4fpOZkSp+4XA5sIY6eend07O0/gc/FFKwl?=
 =?us-ascii?Q?c+C1B4PR7oE89KeEs7x9oMm/3qXmCJSheo1ygiOzHMibKmuUfnWHSpMG59kN?=
 =?us-ascii?Q?l/OdqMtt0LF1IyzSzpvN9/2sJGlixJMlHUIiU0xc4d0B/45iNHgUY4yYyeCj?=
 =?us-ascii?Q?1KFm5Zpoa3wLX+10LsJ7oaEcLLDzE4jGvEevV3wRXPvx3JBPyuhj0kIJhy5c?=
 =?us-ascii?Q?gtUZVtSJxXWSWFI9QYgPmb1k7fGbm3cm2OscMcECQmVnXROMGGrLqbxofmDL?=
 =?us-ascii?Q?YfKsjR1bIc6JJavKHGBarZz51CWJsUribn4b3GunLOlXQwwF3xH9c8qC1lBq?=
 =?us-ascii?Q?w3HwjADpJg6me1KqmapgumELFQE6i7GM/D2y6s8Z5wSMJVxpymjQ9WlWtLza?=
 =?us-ascii?Q?N7qM8u/kgTJzBaBWw11TgyUnGbAXwF73u/pXl448Kp2i8LAS1x1GUP8K4F/e?=
 =?us-ascii?Q?xRMtFJLW6mvg5FLy/WLAOTIEdPupluTeQJDdp3yuBkIa3gNjTT8Xyn4otpCs?=
 =?us-ascii?Q?UDWzL0jw9l2zOsRek9szfXoeanTbUgKwdF8/U/Ve9fEhb3IVq9l+P9olnnob?=
 =?us-ascii?Q?ufjhn+LsSg66lBMEZ9b31oii5PDobsUXSybIqE9ihrCuWUD7cIEy82grVt5M?=
 =?us-ascii?Q?xyVqXu3FICtiMG48tIdj5AqXpELRp3rPIV2pIBIigqS+RyZJ5vgr/p5a2aaK?=
 =?us-ascii?Q?y9MfPVH+6IXQax162MybLd5HETXYC9J3eVL5p8J/Dntj5UZ8cFAc5uNnmUcB?=
 =?us-ascii?Q?BD+mpFKCvSUOnCgFsrgtiznAKoKjEIsZnCEl8LTkrDIG0ogSAsEAnDbXLTQD?=
 =?us-ascii?Q?2K8UDe4Q6aBcgBVZv18Msp5LSCmD5RjYYxtvNqd73dW4wbhvnvZJvkOqoVqq?=
 =?us-ascii?Q?RVyaJQFlTQyXvsj2CTu0uH1ZGrs+4PuBRN6/VqGzO5L3rlU93VT/vN/8i9yg?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?xC8j5MK1ZxK9XVa98m3n7MxtG7QKdRz3oeG6gvSBee6pC44JcJHm9d6CQ9Lu?=
 =?us-ascii?Q?Eo6Nm63JpBRIbwkHk3CeaKKkqooCdYU2xd0wmvNlHUuT1zoBcMTYZs2l7EKE?=
 =?us-ascii?Q?ObwytvygRDT/Ywo7RueFtrRe46rZWQQfWkBTrs2+f4Cu8td6yRuGLARqYpQy?=
 =?us-ascii?Q?22rf/kUrKWID/mMFmZl+Eb/11i6kwJiRvhiydIXuX07zJL2u40FkipxhM9tY?=
 =?us-ascii?Q?YMJU4PkNRfVbBvQmqSVYvy66ESDV4JmWpshe5ciCQMtLDlPlhaoCAQXS6NzL?=
 =?us-ascii?Q?1mBvfmnKpPfyP53ER4pIENaHnnKfQx7zuwpXweIwnnk/a3aHSdcbMaO8k6ZQ?=
 =?us-ascii?Q?wQHwGJxFumrVJFm8UlTcgkexcNKvhauAV7dWAZRZ7GBg916taP45UX7BGR4y?=
 =?us-ascii?Q?csuFWFz5U34J5ZxfFbyhlJgu9xWXajikBDBPtke7HBEfndBJBMLDikn1jY1K?=
 =?us-ascii?Q?nnwWLmi6UszxEoODPsVaN8uvRGS9zROumy2ZzhdMBi0tNUZmM8+qrun+7aRH?=
 =?us-ascii?Q?9rupBRRXVbgaCgg3CREpy9inoLHrJpW9fEJQk+fubM6XVagjhrUpQVoTF/9R?=
 =?us-ascii?Q?Edm1jo5/bK03qIx+OcbBheH1vW5xIoTfzZsm2CTGY5iq8ei7PHzt0MC8ik2E?=
 =?us-ascii?Q?/xKTkgxE2/7zAjzZXlVHTCTYG43LU6YHIcLVrK8wVzGUQN4vkEgPcX9AGhfd?=
 =?us-ascii?Q?vS41GyKVal9WHHvzvvHp9DdHMCX/Nv3gA1q4aaCRJ5N/OUnPXkKxVnudujE3?=
 =?us-ascii?Q?UxnaiYjhr3PysxS5vmVk1toiQnBTAjEbJjazXoFUXLwWSbA/mRsQgfO9UTWt?=
 =?us-ascii?Q?h8/m93hsf4hMtVmgEa9WUqYfDoRSZC96OzaSDJhqSFQXa+5P+QCu5seS2Rki?=
 =?us-ascii?Q?LzHwMmHtFhMKeIN9WvxQ91tODKpyqyfzeWXpEAG+GpJUoREvOC9iYR90VvtT?=
 =?us-ascii?Q?a9YM20JBzxeh1KWRlx12Qg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02fcfdd3-d882-4cc8-70a7-08db016dca02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 20:25:25.8727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRzv9CN8Ocp0FbbARoKLlw58OF2qAPvFLr4FTzrgiTbD60Gnj9Pze5F4UM/sxG1GEn/bSrF8nk1OpoaGs9JhfycOWYncT8eQgqNE6Kc/uPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_12,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=924
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301280200
X-Proofpoint-GUID: S1f7dQcFk2nANDa737l0QchaikViGaBB
X-Proofpoint-ORIG-GUID: S1f7dQcFk2nANDa737l0QchaikViGaBB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

Finally had a window where I could sit down a read this extremely long
thread.

> I am not denying anything. I simply keep telling you that CDL is not a
> generic feature for random applications to use, including those that
> already use RT/BE/IDLE. It is for applications that know and expect
> it, and so have a setup suited for CDL use down to the drive CDL
> descriptors. That includes DM setups.
>
> Thinking about CDL in a generic setup for any random application to
> use is nonsense. And even if that happens and a user not knowing about
> it still tries it, than as mentioned, nothing bad will happen. Using
> CDL in a setup that does not support it is a NOP. That would be the
> same as not using it.

My observations:

 - Wrt. ioprio as conduit, I personally really dislike the idea of
   conflating priority (relative performance wrt. other I/O) with CDL
   (which is a QoS concept). I would really prefer those things to be
   separate. However, I do think that the ioprio *interface* is a good
   fit. A tool like ionice seems like a reasonable approach to letting
   generic applications set their CDL.

   If bio space wasn't a premium, I'd say just keep things separate.
   But given the inherent incompatibility between kernel I/O scheduling
   and CDL, it's probably not worth the hassle to separate them. As much
   as it pains me to mix two concepts which should be completely
   orthogonal.

   I wish we could let applications specify both a priority and a CDL at
   the same time, though. Even if the kernel plumbing in the short term
   ends up using bi_ioprio as conduit. It's much harder to make changes
   in the application interface at a later date.

 - Wrt. "CDL is not a generic feature", I think you are underestimating
   how many applications actually want something like this. We have
   many.

   I don't think we should design for "special interest only, needs
   custom device tweaking to be usable". We have been down that path
   before (streams, etc.). And with poor results.

   I/O hints also tanked but at least we tried to pre-define performance
   classes that made sense in an abstract fashion. And programmed the
   mode page on discovered devices so that the classes were identical
   across all disks, regardless of whether they were SSDs or million
   dollar arrays. This allowed filesystems to communicate "this is
   metadata" regardless of the device the I/O was going to. Instead of
   "index 5 on this device" but "index 42 on the mirror".

   As such, I don't like the "just customize your settings with
   cdltools" approach. I'd much rather see us try to define a few QoS
   classes that make sense that would apply to every app and use those
   to define the application interface. And then have the kernel program
   those CDL classes into SCSI/ATA devices by default.

   Having the kernel provide an abstract interface for bio QoS and
   configuring a new disk with a sane handful of classes does not
   prevent $CLOUD_VENDOR from overriding what Linux configured. But at
   least we'd have a generic approach to block QoS in Linux. Similar to
   the existing I/O priority infrastructure which is also not tied to
   any particular hardware feature.

   A generic implementation also allows us to do fancy things in the
   hypervisor where we would like to be able to do QoS across multiple
   devices as well. Without having ATA or SCSI with CDL involved. Or
   whatever things might look like in NVMe.

-- 
Martin K. Petersen	Oracle Linux Engineering
