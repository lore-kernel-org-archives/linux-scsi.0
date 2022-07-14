Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870B5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 03:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiGNDTK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 23:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiGNDTF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 23:19:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE9F14D0D;
        Wed, 13 Jul 2022 20:19:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DNfwOm023362;
        Thu, 14 Jul 2022 03:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UyobRH5chVOdAAVPcX3uGQpvFhK7j7ErrHxHP15J1Cg=;
 b=VJYsAvu7Lev9yNVTLWT2C9cm/5HBqaXPHYrhNQg3Gh6B/Mgpc8lT/2YyM0Co/wjC863u
 gShSJScxBufu3izgtwBgp55VhsqSThnHk7Q+qDSMyaA1KHNX31jVYDVt2uZO3XsiZEYU
 nihrFYuZMlCszSS1ScOmiulZuPfcnvEtwanxbEH3L9NX2vhKrFO4I8wKalBKO1znR45m
 E7fpVZG/paL7LtW/a4njXbEr1x5xm7Ce7cwhZ8fLYdEeBx94ZDW0nzjX0ag6yJqeaxkC
 jmWmHFBh9fCKZA+RXzNUU1eqJ9uYxgKqSmuMWqxkT70QIvnqhwVlflfVTgXhlYfKqISO 8Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71scc000-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 03:18:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E3AFYF040905;
        Thu, 14 Jul 2022 03:18:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7045qy0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 03:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fA3pwYGoD7nPCuW3Dm0Ol/XtMNuhgNBxoANpfCGJcnxa5rnaT/nGjV48Xh0GmeNRCwYWvzupP+eM/O50SoCijagXGawpx1R1cgFxxzPki2BFfePMf32FXpJC6gMfayC/K0pYdWI33TzDc0tqyjbU9BoisiWLLXKW2aoIuKv8ze4UtYG/FiUbDZPCzQgF4BS+Fp2kmdiznPlHyFP3ptgO6X+06hCeKeijlhzmmD0I/4LSE9RJgTeDNRxjS3kv6s20tQb1p4XnvNujktxFyLRAxk7/IN3FBkq5DIij/8LNT+tdaMPonlLNAMmFdiDpJkNIBYCywKO5hHUEgN6R32rmwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyobRH5chVOdAAVPcX3uGQpvFhK7j7ErrHxHP15J1Cg=;
 b=nsqdyuCNAayLmu/9uGgBOcGzphDTODbd+9wP/W31Z7dCQ/yXz0Iv96EAYGMCTf2qwrrT37SRbuHiPPSUcbeP+70j4cUsYoIMsuaOZLeucSj+8SLQidwA8NBGtk6df6KuafbhWBuXkzL18foSL01YmdlAQD3N/Lp3d5RzGvyK0oFowEbFvKWebpAP9NKrxHeCNiBZJhhJybnRWZhkEy9mI34SEjAm+je4b95CpFovyasVZh0ZMNQILUg0/46RkG8flGLRSygODBhH5qKjyNUZMaxnbRjhHGlR2OngX0b5y75BSAoqG1I/HvztOHjW82o+jcKoLYnqtoa2U6uYvtRWNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyobRH5chVOdAAVPcX3uGQpvFhK7j7ErrHxHP15J1Cg=;
 b=TSgcTFQhQfLYThLWzwj51x5bZ9BJHGqzlIkzwrJ8GR7wbrW3a1O18/azTkZDvmk1HHIsEh9GIIVOJZiaxh+KvJRQ8pF0nLt3ZbiMfIseVlifUgxQGUjEwiqx0Jcfgsrxv18Tv6tUYp4ohRFYSj2ahOAZqrSwRd2yEK7x0TwzSSk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 14 Jul
 2022 03:18:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 03:18:55 +0000
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     linux-m68k@vger.kernel.org, arnd@kernel.org,
        linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [PATCH] scsi - gvp11.c: fix DMA mask calculation error
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wncgwfe3.fsf@ca-mkp.ca.oracle.com>
References: <20220713074913.7873-1-schmitzmic@gmail.com>
Date:   Wed, 13 Jul 2022 23:18:51 -0400
In-Reply-To: <20220713074913.7873-1-schmitzmic@gmail.com> (Michael Schmitz's
        message of "Wed, 13 Jul 2022 19:49:13 +1200")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52269142-9b9a-4b1d-a6fe-08da65479549
X-MS-TrafficTypeDiagnostic: CO1PR10MB4756:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EjZ8Ok2OHyAUtz/fm2k2shaNh4NKYH9Tm/rgt/Wzq8RyrKoO2DMcwu70oXJGcDYHK5wB9V50vhBP9hyNbNZB5BrleAIhziqpFRVTUmY2jTrg1z3eN2JHvBEsKl0Lj62zksFj8xA6gQaeR1/gVmauqnaJb2K6zJC2HKY4aZI7bIlyPCmeDegtxAP8g/2MgYCju92r77ol3UzIZGm1d9JsodJnlgFk5aYlFeaQ/m9Qk8XhonrIF+BwvrxjP01jmzKuQQjHnuv/zq9+cU//gQg6Zkq+eP3E6PTy+K4g+Pmsmk9RjfCOWwHpU0A+PSuidbzQU4l98WA0AHDJsahwz12nRMRlTaOY+0vNBHygZxoORN4h64DjFEAtf+SFbivC9S+0e/j5yyyqDuJrRd0URDqO4mOR9bfZvO8ojYD2tfGnJ/6bgH5gQvUIOgauRsb4nIOQYDb7Xvg4v9/5y2+01ZspcJnrZVKH9OxuurWSq6dKZtSwOONdWHwv1U3bI0J8gq+pSKsd3F1pQxOqraeuh2X//9V2JnY6kYMPrNdV3MzFs8/BfQkbPEpA2hPiS5vS5TYtGBNDG0YAWzVSbaJ+h4AFoWMuIxWbocKgNj/JhsuHflb0mZZmhh4z8T/3pLMLyuhf2fp8rqHM60MdfoZlGsjD0E6O6WEnDWqBgxajdxC2lVQjOaSZDy0Ntw1p+YtOr42uUN02oSCnGB0+qM6TKreuSQroKrYt4gdQVIa8fo5R4lXIf1TtpCcwzFH8/zfJ1M0r1fPtvpiATz99Umb1D9oWVJcLLRo0xClZ2PcMX0FQnNj5oOyhpvpZIyQ0Hj0iXlbj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(396003)(346002)(366004)(376002)(8676002)(6666004)(186003)(66946007)(4744005)(8936002)(4326008)(66556008)(5660300002)(66476007)(2906002)(83380400001)(26005)(478600001)(6512007)(316002)(52116002)(6506007)(38100700002)(6916009)(38350700002)(41300700001)(36916002)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6rdWQKeAVdK2n1j9a8jWBeOZGWLGrCvMjBonBSgkodfK4P4B6ljU5Kl3PzQ6?=
 =?us-ascii?Q?vmRr3jHIE83vwGy7WL0R3M89w/MOHRFKQVvf8SDBbOSO4/OpD4cLZfnGhKFP?=
 =?us-ascii?Q?qu/iaXoV9Sj5dIfCtln5InM7CEFFUUIxaOzLTxGzmSotE4lydHcb2rWoyEyx?=
 =?us-ascii?Q?yrInQhkwG6HmPKOXZRfctKyUhMMhI76qZGKL1n1HsegUKIW6g2zVnc5sasyF?=
 =?us-ascii?Q?ofxAEcrfesQyjYMT5TEfwJ1/4WPj+LakIr9SogcuInlJgduxrCH2qOBtoUKX?=
 =?us-ascii?Q?ALSLg6hlCCjrEYr5tChd7OzJE4Z+4iYP5BjWnZGb6fvaRn/Ox8bx4AkxeyDa?=
 =?us-ascii?Q?Iop4eUMDcJe1xsEli7coaWlEsuuDbslEc9HEK51RcRBLlkKURFneZMoxtIa6?=
 =?us-ascii?Q?RRaaeU/cMqZMMMonxQ6L+EifAoSGfNBzLA5wfO8h3QV2res9+JXh3kLiCdS8?=
 =?us-ascii?Q?SqQsHRxTDMJc0y92KEPv0FaYupNTr7DO/epFjBcG2rknXIT0kcwvRT3tC2R8?=
 =?us-ascii?Q?XfWqfxwgXJMVVBauXKmdSjmMVX2S/w40n4QAB5zkMnEfsGtse9yGr4oWbYn1?=
 =?us-ascii?Q?y76ER6zyS3viHeEt9ONM77ycHxGXG8LdJjfrJtkNyq0lpwVxAHFXxX3XTwuL?=
 =?us-ascii?Q?1tcz4tEavUurL/ugPPwSsQ8sFhwDeK43jaBq5Ji35GmGIDtbhNUZMMjwQ6dy?=
 =?us-ascii?Q?NTj56CMYU/4ZzVnuOsWmiYIBzj4f7ZlX9Ym0mUKdVwwnsmMHbb6r2z72NrqA?=
 =?us-ascii?Q?+zOTcgARVFotjFPVhNMc1/esAAWvNlzjXD7aOsmxEoIQWN4KuiWr0Ri0o431?=
 =?us-ascii?Q?QpQaTVhx+5NFTEaspdFojmh81ABUsPRT55Rg0wqmBs7utwonvP2qmWANRePv?=
 =?us-ascii?Q?8LP2CIRxCgpqH9LWvhTt2MKgQkxtz7mH3vySYp0duRnb1GKDHB2K4KuLz0Tb?=
 =?us-ascii?Q?NLfgmNF4STeKbh3WYtLWj75FW8uBFNTX8neysEXKsnSAXMTIvctqlqaWtweU?=
 =?us-ascii?Q?V3GVOJIFh5KtEpHJmrpatOEE3L+DMRjkPF1hy83eAdt+vedSLn63eHj8xg8n?=
 =?us-ascii?Q?S6+yRHioDeN0JeoZ+qg9EyQGuTM5rrGKTQuFjunx6mWGY7Xk+RSvSSwKjwo/?=
 =?us-ascii?Q?SCtqMNpyaOBj9LIrCj8aXwhZ3iTNKtiKSvqtXg6i4CJSJ2oYRnvBoW79OqIM?=
 =?us-ascii?Q?Jbagr28ULpmOIs9NTpUGvifbDOv2fJ09/Afd/nuQ5J1Yv9YjpAAErLgfhErN?=
 =?us-ascii?Q?U8tw7HZF3n5eVl7j5CvvNnWnyiRobWxEQtguy+TUIIXQydnFz/drgNgyVve1?=
 =?us-ascii?Q?ffFVGVjyCIsDiLjkzd0biZBaOfPD4zSF2kGWSZIX3w9tnnPEdG47sHxrckQY?=
 =?us-ascii?Q?CqvwqQBgcuoLpXCvV7lmnPz4HrZMFzCHOFmHTbA8FFJQF/vAs4MNaiZgc5sG?=
 =?us-ascii?Q?9+VmM+mpgrE+T5Tkd/xl+Axwj31UIYkTq+ZQO2yBgl8FpNPp2bg6YyLZkI+g?=
 =?us-ascii?Q?bz8+sFn4N+xOtKeZ4W3Gq4jn8jVPKTLT/7Nt4v3J0T3Dz6l3aURZIsTXEAao?=
 =?us-ascii?Q?8tQpRv0gCG2HYL8uM4anajLV4YBMWUgiScjgkfijw4elRACQFZKIY8OhQkPA?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52269142-9b9a-4b1d-a6fe-08da65479549
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 03:18:54.9624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mTdR3/Y4rOQ/MkzdJ26H9s3JNdmlUz4wDfamrwtghAAeHTTMZR4COnOWFHGz546VJ8oYcYUi2tX3lHkP+ds++XtrVZc+M54KjfPXBEXdjG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_02:2022-07-13,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140013
X-Proofpoint-GUID: 9k5F-7LrVlredUMe2uv4rYbpUOBR5PLh
X-Proofpoint-ORIG-GUID: 9k5F-7LrVlredUMe2uv4rYbpUOBR5PLh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Michael,

> DMA masks given in the Zorro ID table don't contain the 2 byte
> alignment quirk seen in the GVP11_XFER_MASK macro from gvp11.h
> so no need to account for that.
>
> DMA masks passed to dma_set_mask_and_coherent() must be 64 bit,
> add the missing cast in the TO_DMA_MASK macro used to convert
> driver DMA masks to DMA API masks.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
