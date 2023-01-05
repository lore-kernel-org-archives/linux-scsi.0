Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F1CC46467
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 02:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjAECDm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Jan 2023 21:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjAECDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2023 21:03:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB461EAF4
        for <linux-scsi@vger.kernel.org>; Wed,  4 Jan 2023 18:03:39 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304MEOW1028248;
        Thu, 5 Jan 2023 02:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=8OoyimPkzjP9T1xe2TJ26lJv8W+hG6bLtC5EY+1a2oU=;
 b=WnBqup6NmPfGJ4yee7U+hB3LvGjwefW6l4oDWo9w8qIO4IEs2wsQKxboX3rbFwHbXuLj
 ZyEolrep2+KQm8prEfk29/VzRDKpVcYvnbwZSMHLVxie0JIJxRMZPF0EKkXEawMkcWcJ
 O8V08DCHN4Gsc2VFzp0KZx1EgbbinXyWFbzEFrANHtQRvGprUFE9p5FrnGVgbra/R2Ej
 Qm20yar+rGACdYLR7mutt+CBEmauhfOzvDdDpz4IjkY2Plfcy9hSF/91EgoVkP5YbGQk
 SPvfziT1V37A1euBAUsgnt8SQ3pYi1ETX2q+p+vfHxwaCm7ExNDIo1mUvyb8dD0L81Qz sQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtdmtque9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 02:03:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 304Ng06G031335;
        Thu, 5 Jan 2023 02:03:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mwdtrg0qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 02:03:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoVdbi6cx//tJmO/Nx7yh7KLNak0nYb26hVvFo8SOlq5Opsz9TAiQZvSnnuDw5Q+84gvV/KGj1UzA7PFx9HSDUBT0RfPKHNGVXPvjewrqUyVFP5T3k4EdLkwk2F28+5l3eF/eWAtqX2QlzvJj3dyZ4I3L57887IN9nSu49JbpPRz4Y4y/Dzn1MZTCEog4+DPCgcIwqXJYfkhNU9NluCbBPGpa1xfuO2EQXQRwoOFZRQ3dm4Y408w+tVA/ub6jVnZAzac+dgODUNCZdLQOYLZkDxVj/R5yQ2urtQt6wrRwosK/6cfwQeFVUeTXuU0WLi9Kmr5oII81REMc1JLOLeZRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OoyimPkzjP9T1xe2TJ26lJv8W+hG6bLtC5EY+1a2oU=;
 b=NORWLfwvEZuLluqKUzj8Vci0/sl8bYMAv9QpnX8ArgP5V/8nIM8X/0VZLvHe3TBjcl6iahRaV6c49ufrz+2kPjo5zISYaklDPbxHd2fa+4LGcYgs4cJO+spzXpO7Zhz2i0EY4rQyhsIY1nEZ3bJV6ZKnf3B12jnEmXmtE/OmivhcidiIcx8ZYxCffr56U58mCMssd8ri/wR8tIzMydYrXh9+vJnl3R7qv1XaoJByz4recnZArtx3Xp3PtTMH5cFJEmzlbstlSEyhTEHdeLF3O88ev1aMYVT74EQp5tKwXYXAOF6QEuMsfNtn6sAynkVg8wHWEEVCEvwcaTDkMQqg7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OoyimPkzjP9T1xe2TJ26lJv8W+hG6bLtC5EY+1a2oU=;
 b=m8pms3NAaicFsrBlUNELxKUmAEjgQZ2uRUwvlFuwUBoyoMlXnjYFa361avO2BC3uujZGnFBfChWKFSJxfLyQKi714HCcXFCuccB72VGDpCelr3HueANrxAhF1HhqGRsL8fmpIMYU/WDk7Mwh74NDHKWZjKVUwuvpuxEmos08JH0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4546.namprd10.prod.outlook.com (2603:10b6:303:6e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 02:03:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 02:03:09 +0000
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc:     <martin.petersen@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <jinpu.wang@cloud.ionos.com>, <damien.lemoal@opensource.wdc.com>,
        <john.g.garry@oracle.com>
Subject: Re: [PATCH v2] scsi: hisi_sas: fix tags freeing for the reserverd tags
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1358p3flx.fsf@ca-mkp.ca.oracle.com>
References: <20221215040925.147615-1-yanaijie@huawei.com>
        <6637df86-9302-56c6-b760-3f1b46970f15@hisilicon.com>
Date:   Wed, 04 Jan 2023 21:03:06 -0500
In-Reply-To: <6637df86-9302-56c6-b760-3f1b46970f15@hisilicon.com> (chenxiang's
        message of "Tue, 3 Jan 2023 09:24:53 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:806:f2::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4546:EE_
X-MS-Office365-Filtering-Correlation-Id: 62973931-d0ae-4f9d-2012-08daeec0fe3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhW+YPx2aDHgMx67+uTNAzZAXBLD0QBRd4fatuvPGefd3p3xF440hu+tHbJ/H7GwZLzVGEN9u25V7w/aX9T9qHUjXn/b3gEuJ9R5WkJeuuvncV5QNLt8tod8Vlpz2bAOFx/TrX+fRosL/9qbLxIf+DgHY0rN/Yzuv5K57RnnXCIsAre9OZzk5KGStrr5x4jBl4d/mZrpK9Lw7GePFrOsJaUXsOQz5wvSB9XT+F+iytlqp0B+C9uW9SWH3IG/3WA7N9XrbTCs0uihNMJznbiGk82Hh3V7Aw0LF3cFG9hr2k6GX2TOUnj32I7cA6lWDM9dA26SsK69h7KjTRCDsjUcVaVq123IKD8WOvZVL4nYBzd7+CxJ48QhZVu1VUKXeEQAI/n75eFmbJ8iLXGvaqyO03lG3CJLNUqaN8OkFZzlyTJBKC6HxopquD2fNj7G4g5RZ4i8rZHZ7rU46VH69rhBd30Cp+j4F/ON9Pmf0CPkE3YbVADuFtJ4/u6F2qjaLSlwY24pD4K1/YfWFotPxUW1nLSYyn1HChj9AYmQLOgcxi9tRawN3np7fiID/v3noL6FAwjN2tErCOrMWuadP1mfIktSpNK2Tw3eIHETHMeXyPTg/FO6Y+v8Qup3aKHUmRkL3uHVfEY7fD4ZvHDt4RI/Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(83380400001)(86362001)(558084003)(5660300002)(4326008)(66556008)(2906002)(66946007)(8676002)(66476007)(41300700001)(186003)(6666004)(107886003)(26005)(6512007)(6506007)(478600001)(54906003)(6916009)(8936002)(36916002)(316002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1jLfVlf0KMYYXgLDBpTToXGn3pc2MzNCU1mc0rbx2T5xvPOx1DmkeUaWkOPf?=
 =?us-ascii?Q?3EAkAyLaAoTaxDpaDO9NWB/5If6bMKlYxryM0CLKhOEVzDILiVogLBj/6uej?=
 =?us-ascii?Q?QxijXpHJhAhdzAUrUijG8UB/cBL+IT3eltj//4kbraI1hzdT2hvXsO50NYaa?=
 =?us-ascii?Q?LIKG+bGCOj7sYabibbTIUIYEtCwvqqTWV60nPcHwEd8Nt9UAC0F/Uwo/0Ca6?=
 =?us-ascii?Q?BG7oeX4doPKx9sN/RGrur5K26YZxmPP3GdZc/nAshuOaf43T9ocWMplA9JbE?=
 =?us-ascii?Q?ls3SfYdDazKkHiVJSgnqMAfFa87qABZBBYfS8i2N0gfQ2g45NkbSRLGHUKI+?=
 =?us-ascii?Q?Yxk9UB83CTr+xVrf1eklTCswEXEpljT+2+Mik48lqhGJkeTpbec7IQihK7P7?=
 =?us-ascii?Q?FXcITXKZpM/8lS18poocuKJF2dLBwOPT5Vvt+bPNco6POm2yb50/ueaxKcNS?=
 =?us-ascii?Q?ZEGMSZRGAPmbzlJPVvS2tFFCI8ni8V1NLHmr00HOiXOoGualwCp4JV8UGJDP?=
 =?us-ascii?Q?14M6iGPW4EH5Nh6Z/jVPaBMvJ6ViGtiI1P4Is3shw6lRmk+f8C0RjG/+2VIk?=
 =?us-ascii?Q?9Mq/i9tSJfoUzjhn7D7KgZs1XIKfqQcY0wLIhBsWpZOSx41ZRzKDCbtiX0RD?=
 =?us-ascii?Q?gfwSslhQhj7Njzuxg6hnL6Ho9C4w2oZMT0w2eTLSHeE6f4YgqF9yHNmq5DLi?=
 =?us-ascii?Q?qNIPMxt9N+J3j4JdH3L4vyr44EA/8Wadpkmk0n0myDXJN3ttS+RfKf9z2o8Q?=
 =?us-ascii?Q?Lzdh7bU3SgYmPtIQuBKoyDuhwUIGPCTvS0Z4BltJJKEUFScEmMHi43IFMpez?=
 =?us-ascii?Q?JA3BO5tvClSvQzPkQ8KjTIS7RDzk2yN4XdGGX6jdfXTNlRDJP8mSJ2SC2SDH?=
 =?us-ascii?Q?ZwVeNJ7iyCS7N5PnKEEsOpnDLRDc2llibglhSwumz/LdO5r/TzuEElKk4HqN?=
 =?us-ascii?Q?35hWgwFWFIILER8JHPv3Sp7xceOLTLyibPDplfw/ulu0Xqkn28fqhhpZFJb6?=
 =?us-ascii?Q?ArIdEXeQTEEPR65sluVKMrboaVf3p3VJh4u9k08ptrCofZgy5PHrDA73M8TH?=
 =?us-ascii?Q?G4/d47nZBvucOlz+YvMceexHxrkFoNY0yg1WF163eRnHuOOD2QRB5CoFDxLS?=
 =?us-ascii?Q?YsTeqvLlopWG4rdeo7o7Sh8u1yv5SQuKS5SY6aK0/9z1mguZqb9zBYZarUmx?=
 =?us-ascii?Q?DeEsoT91LxBlfAwgI0jWxhqcQO1IbRwO7STnYr6NT5LgTBmbuTk3P3SSs9jP?=
 =?us-ascii?Q?i8mIfJAxzDXW6WJS0sRd6Mxj8jmzmOn5ss//widVB+n0RTwcNSHrUQN3QJUu?=
 =?us-ascii?Q?Cg4r0hhpfJqXIYWs8bphFaijrzBPfkiXzqmN4DHc3q4y2kQre734CS/JSn7v?=
 =?us-ascii?Q?sfRLWpV9iqbMEclMzXh7HH7StO+IyWwOygUmFuktY88pBorNT8SXnY828iXF?=
 =?us-ascii?Q?w2tdR/dnjU2ditISKlEutp0a0FL4op34GndTjuakmqRjw42J6X1cZqJf0wNH?=
 =?us-ascii?Q?wENtvXKe5hgac9U5ukdSavCUrYDJ7UG48aJD67NP0WUO9oLYmKnPCxE0Fw0a?=
 =?us-ascii?Q?1D+YkVMWyExipm8tY33mz6ZaWU4Mntm1LtHFonh+jVtSnR3ClwmxOoyj8bc/?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?kd+ah+S9O554Gvfse2mK5NL3aGuMh5/aMKiO/D7KQ/WLLswv99pj4WOOyG4Z?=
 =?us-ascii?Q?17LDiCgZ+YzOTL4DYW6OH/pmmlp1vY2j38U6qBFX+Hjn3FrQCqS7ylOc8qaZ?=
 =?us-ascii?Q?quzIltlS66hO6gjnPr4N8JPhsn6O/xyGl8hnt/+aaqzFfA+u+e46/Ql3PtGw?=
 =?us-ascii?Q?biTFr7TeTSL+ZgWDAwWXtd/paDJ7PUSTH/M3vsG5Uo//G4M45GmG7J9o/sJc?=
 =?us-ascii?Q?Oep8rzrkFRWI+ZAllaWNtuhqQKhm13wHux24AK6f9TYgIW6Fi/1OKsL3wZXj?=
 =?us-ascii?Q?FlRje2xUqZRMiidK25xw3YeWNonYrcRQKgYHbTvMzQGQMPrK+7P2aWm/2Zxr?=
 =?us-ascii?Q?bMs45bXWfg/a/TAHsUdeLz4rrEAlomwUephbTJeKB1K7BxklO+NmP92LUHC1?=
 =?us-ascii?Q?24PREUmFO4YAfPaCN4hfmb1YSUJJwxsdj/ZIVgEUjZEHErf1RYfGEVmQJjzw?=
 =?us-ascii?Q?qsxVIv/z3MJiBHqjEKJEwEYTvLj6XM4yrf72F4neeAfc0LlNoSuRGIBp0g5X?=
 =?us-ascii?Q?SpEM84V2Y7/825x+TZb4umIw+ChS6JEeJQZWbnqn8HfyMCXqLcIFfHDHdK3m?=
 =?us-ascii?Q?T385z8U3bADtoEj/Fo9pSXaR7G/I8f27YXbT2BOjPfHOeDhpWdezxMzZ5u+f?=
 =?us-ascii?Q?wzE2KcvfjTd9EnPYxCdryaDLKLUH4PznrOmFnHc7gntuTnAkSaaZgO3gxmGa?=
 =?us-ascii?Q?VqL1PxT2XTJ7S4B3LSl1LpQaiA2f1z+uu5OWEnQAtprAcM7zqyne5ZMy1Tz0?=
 =?us-ascii?Q?47Xh16drihFKJ5vNnNPO+VuiKmDDGBOv+7+6TAgCNkd02t6UwJo4bLLjkeS4?=
 =?us-ascii?Q?pmeq9SLJu/6h0qDSTYrNzxb822k0F/NdXChxdHmuYxx1M5K/6zxNDnlrYONi?=
 =?us-ascii?Q?vRkNGA0p6+Ggy/N2ELpk59tyC6lVjF3HpjRIu+89fmK7tfwsyIvQ1D2Y1QHs?=
 =?us-ascii?Q?5sGD9ogm0a2xvor74gsJZv263SeKEZIKrYW+Eks56Yw3COCTUuM51TO4b+9I?=
 =?us-ascii?Q?GUJ/ZTxXCFOgnqz3qpWlWQEd9A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62973931-d0ae-4f9d-2012-08daeec0fe3b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:03:09.4796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cuz7/RPg2WaEBHNAa7eR0Y3cubM/7n8nRZCG0BTxL4GoQuKYZ52vD1s9uQ97m7VWBhGhXvqkBPLAIVnHjgPLGRLZpjDLAZR32W/LMgJEG98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=626 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050015
X-Proofpoint-GUID: WX7aEjI1rGaYUJXMZRPxx3nySwt5uANA
X-Proofpoint-ORIG-GUID: WX7aEjI1rGaYUJXMZRPxx3nySwt5uANA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> I notice that this patch is not merged till now, which affect the boot
> of this driver.  Could you consider to merge it as soon as possible?

It's already in 6.2/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
