Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7E8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 02:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbiBWCvI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 21:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbiBWCvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 21:51:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA374D609;
        Tue, 22 Feb 2022 18:50:41 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MMsst1006162;
        Wed, 23 Feb 2022 02:50:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=urs8HjKf2jKtBVH0ph3dFaKcYkoe09g6H4ha7N7bT38=;
 b=onSz9qNPjpuJDrbAsZsHijZGYqTtvbBFb5zAjibQlL7X9NCosBZ8g3q/4pq1AZinao6q
 v6W8OjAsivUmVz6/dM/EztsxCHJ0cfbKpoa75aEnjPZlU6N82LrkrPkXUy+8PcmI9uV/
 aN8jlntMOjvl86FnWXRY3+mLckkKUmNRoWl/s//HqywhsiNVmRg44XGtF0CXOUdcI79l
 WTejeYHI+vLZqO/VGeB3EkaJpclS7AOiPu9r4EPR6eyG905/V6sWwguyHeLawnN5r+G9
 PMsiZX1/spf+S8WECBYmOzjR8ZLfQyvQOQsZTbh6Z02TF9imFpFW65tzRTQgDBcaAsom 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7ajxqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 02:50:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21N2ai5w061345;
        Wed, 23 Feb 2022 02:50:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3020.oracle.com with ESMTP id 3eat0nu7hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 02:50:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kx2y9+/PZ4SLB8tzC6Tj1Gh/w/A2Ib7RjIc2LhJtIYEIVtDLqEqmjnOansd+lggJfMfvnIKQMu8fgD8arIpP1Rf+Y830D3yKvMLhpbLnk+YWoJ/IlfJlrPj1uqn4Gr16cvvEU3zREmfqSWEfrq6BFhahaQTAYgSOIJy1qkpwawq52g1HIpna33+9FFot40O9yzPBJTHR5ebuvpJOTZicEIYK+h3S7OfsTugkNvh5VV6+Gpmbp1FNrX0xENZDQ9XbblZSd0IiJKiCDjBMGq/owg8+gjOgPfw0BHV6ynkSuvIqW2Ukad+mb5tTXByx6uKfJzkiZzzINJ8WbefjclFmsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urs8HjKf2jKtBVH0ph3dFaKcYkoe09g6H4ha7N7bT38=;
 b=OfhHNLIOm/qXbffEhb0eTpLk7UGRUpe/z4UsnvKP+u7aK8NLyR2O6yMy0mGH9MuddAkOY6zDus90A+EOLw+8xd2COS237oiz+hPNAs2M0MhdW+Hft4fgWHQDDk8AQ/BznhaYuqxJKplA/GYZIYwbNviVYFADyNoJ9AQ3ohoteoNsWymc0KpVInfKiYaWY4+wi+JwFu/EkpK3p5/vXUiuAbN+BBSRrFUCY4pQs/nyLo8/Hn3alN8dYLslarZ51eTimfhl3LL43ufy3zyx8v7c60dp00jtgpuQl/ty10p/8iyawwrj+uRG+rz8GbuqzkGGHvf0e6Jp3IvAay98TZVVrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urs8HjKf2jKtBVH0ph3dFaKcYkoe09g6H4ha7N7bT38=;
 b=hP9IL83GcUlVp0AtMLQfdQOikU4pmf86tuNuFbG5fqVvUnZHKazYniKHCfsJ8M2b5EPEmCWC/5ruMQGr7KyZyHafjozu8NOWp8xp8O5lGbkDQjA0ObzoFwRwLnXTYpI9/jRIkDvAvTTKcTDxQLf+SnvjABfMFTMnFKF6mCCBUuc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB5836.namprd10.prod.outlook.com (2603:10b6:a03:3ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26; Wed, 23 Feb
 2022 02:50:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 02:50:31 +0000
To:     Olaf Fraczyk <olaf.fraczyk@gmail.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Karel Zak <kzak@redhat.com>, linux-block@vger.kernel.org
Subject: Re: blkdiscard BLKDISCARD ioctl failed: Remote I/O error
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnhmb8ug.fsf@ca-mkp.ca.oracle.com>
References: <CAJWTG89dq0-HDb=hSJMdT5WyArH3dy+SKZNXDEr9WOWsaUsMEg@mail.gmail.com>
        <20220221090558.yvkgw2lujwjodhfi@ws.net.home>
        <CAJWTG8-yrpLevVALX9ONnQGEgFcytYuhSk4ge_-qyi0tQS0keg@mail.gmail.com>
        <20220221130912.kboxxd2dga7edjkf@work> <YhOlbX0+0SxYl3Dq@T590>
        <CAJWTG8_2bgioHW87VntCvhCOA8_B8GMsuk+82o7uuHPx=9yt1w@mail.gmail.com>
Date:   Tue, 22 Feb 2022 21:50:29 -0500
In-Reply-To: <CAJWTG8_2bgioHW87VntCvhCOA8_B8GMsuk+82o7uuHPx=9yt1w@mail.gmail.com>
        (Olaf Fraczyk's message of "Mon, 21 Feb 2022 16:33:52 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0142.namprd11.prod.outlook.com
 (2603:10b6:806:131::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 154dd0f1-595b-49ff-9943-08d9f67741a9
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5836:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB58363CA305994000EFF1CFCF8E3C9@SJ0PR10MB5836.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RNVuBFh5jSdngGoi5Aag9SCxvaqzSbqATJnBLHNoFAUgivJPd0Z/ykMU8irTAIRZ29A/8R7G4XfUotB6MmdUDKtLCpvfHiyUgP820UfbgTaJdTuRIudqSpClA2X2GVGJy+QIy6ohvA8GHSrXJQctqCL9cQwvAS3V8rvtJB8tO2sQR1hgD21FsqBpAWjmWeUNhtbA+x0ktQY8Qm/OSWiJdD7CahvZG2JsVY4ZpJLjXTlMeLVv88MaH475ZG8oEd1sCtvhi3rBeEMsdMasjD10th9xKKfDlwnMQgWJb0xxHOKgD3co6WrtmBMnX/Wsby4YcNG9HqmosyiKHe5QI13k6eVOsXEHh5RJgfT26+zU81cL5bd+uIkzMXd3PEFWcExv9oSoKsxkWRDVBkwJRwdfxGwc1EnBg1uOw8S4cq/kKpJxYF4c1MghDuc9EPmZObxyXJFJSVoxTBg22vp07ekfHSE5Hh2XaVP3Z81HvoxBNwHrkqnlbQzyNfGfdkqHouF+PGZxeHwDjVNuSWJ+0Le2vHyd/pbOKuA7eHj7gLFf/8GHThAVzew8vqdVxRg9TOD1d/UMLh/xGjJ2hxacGXS3EEmrq/PsiHUhFHM0SA9tsqHb5hQj+l5he6IE8Kvb6ONwcGPt4rzjI5SF8j3vd3QGA5XNLr7tGrRegpF18KMWgTfcXRhSeIf7jQ0QB0WiY1hYclDF8WAzs3JaNiHS0G0Fpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(6512007)(26005)(6506007)(186003)(52116002)(38350700002)(38100700002)(86362001)(66556008)(66476007)(508600001)(4326008)(2906002)(4744005)(8676002)(8936002)(6916009)(316002)(5660300002)(6486002)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h81ShJnb18jzXemSipBVNeq8XGZgXr6A0CDLU/Su4HSRZkG2aru3fok4PCZA?=
 =?us-ascii?Q?3cs7zB2a3MPZbpbGLABswspOuGH13DTATFOmOEqzM75vxf9xaTjKA3djy3bD?=
 =?us-ascii?Q?KVy7dlPBLQ8ezDVdjh/4ISTUzdvlVZ2S+M1F1UMKhqmLrYxCvZMwUy1Prbd1?=
 =?us-ascii?Q?lpoqo+QtsrzwWxYs3mAhg7qQRFqYfu2HzfX6iaP+w9aPpnsfJAHWJIp5MoMl?=
 =?us-ascii?Q?6C7mxNyJclzFGoHywAxxcuVkJc3yic7zNib9mnPAebW+QfFJnH7iiW5ieubO?=
 =?us-ascii?Q?jE0pHp5tCYxYr3lIRvq/hg5nMgUB8p9cfeA4zRsd7ecUHYRCKCf8XrYoOF8P?=
 =?us-ascii?Q?UF01v8QhZupUZ1MxHigf3onIU/c/ogSAwKDWK3cHa/8ZqU/xojfwB1Ck/XF9?=
 =?us-ascii?Q?Vr0GX0WsQNtDiAYjdrgjm/KjICrY0jbTLKv2+ohTI5zMU83XCU/uoIcBaOVB?=
 =?us-ascii?Q?d7qLin0oBAlYrq3d1YSbSc+CK5md4wJSrlSVwcynwT4S/KdflxOaAhVny9af?=
 =?us-ascii?Q?U7UO0d627l57Yp9R8wyK4BiobMKL8t1YeMVFFmxCJPJKXTJd7WVWaUC0usUD?=
 =?us-ascii?Q?TMf7t7OuiYBXED+H2BiP+MFLgOw/zRdhO8Bdae8pwoyL3j43BBcU0h8mY/ND?=
 =?us-ascii?Q?+luPOVlbqPgtjBF1vDe8305OsGjB0tO+KjCxz0DXTEb4oTy+a0YZNA5A+5qp?=
 =?us-ascii?Q?sE4IzyAeXe9SUb7zpGyuLhXH1EGpXV8bcT4KOvVqYUYpR+mhsCA+y0xRNApp?=
 =?us-ascii?Q?8G2+nHixPc6AeGz8bymTssUcsmXRMLxv/6pK2YSXxcZUOOBlZCKQgnoBeMg8?=
 =?us-ascii?Q?IEzYx4E/KMD7ej9lqRU3Ljx3nuxSd7B5ZBU1ngf43uSuGeJg+IFKN+F90TLe?=
 =?us-ascii?Q?dOhImXVPsPpFdDW18cHvzJEW4+scSlnmpMj+C07lueofzbUlSkF+Wm+UJk6o?=
 =?us-ascii?Q?Snl7I99Fp03v9rYyDt2Wmh6N7hWm/6iAn9TjTnCzW5it361ykD0I4lIAaeU4?=
 =?us-ascii?Q?TNKc5UgZl02uO8LkR+a+M95/qqocDn8aO3db8FSZhzMEcfFeF2QupjjMcE3w?=
 =?us-ascii?Q?LKXp5ANR3ddIvY5wDqDDURci+bj+xHR8QSnobOsBNOqr0OLuDZFGCTe+AtIK?=
 =?us-ascii?Q?jUYmznwOl0kikO3bYy8APzreHOoBVB8M+O/gz5GRZgvSqUuOnt3aANaacGtD?=
 =?us-ascii?Q?GhTcRI3G0XJ7iPsgC86fkwhUmuo3FrRE17ZB8XfzseDxnr+1jXXU5GKNBpKo?=
 =?us-ascii?Q?LZe17SeEBqhTm0qxwBWxqZaGGf3VYDY/WEjezjholXfUbA8WahMWriG8Vm2h?=
 =?us-ascii?Q?oCOGHXGT+OqyEXmB5aqTo9zecUi5pRn+CVki1S1ojiUbOlCuFk+W+C/ZgnMX?=
 =?us-ascii?Q?EW9/0918fbyZhYiJw+AYj9Af+vMo2dXdDk+T6U1KJSNETVAX4O0Z/5+c5sJf?=
 =?us-ascii?Q?3sGn+jWneMjHOffSGLl+223iRN0QbOYxJP6APIwN/1eSKREHzK+bWsmAEDw2?=
 =?us-ascii?Q?xQbc3ZUPEGg2Gy6tMlW5ICoCaQvQagSqm4earmOz8kesNfPpITWRtvI3eih+?=
 =?us-ascii?Q?dsgcD3NgHjoZx3wOXV+OjIgTBestXwiPRJ+t9osPNluwEG4Wu61TvU1j3FN5?=
 =?us-ascii?Q?9GAgVZl1r+glonfz3zFWnA5lC3HGjL2jW+vo2aYrg2M1rlQfoxPd1bHBBuV5?=
 =?us-ascii?Q?L4cr0r5T5qJIff9hURXUPq58GJk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154dd0f1-595b-49ff-9943-08d9f67741a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:50:31.4529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nv0qaXpxlshplyrCgL6O83BeK1/aBifEaW3ZYKC4RCI72UzesdOpEVitbyTgzvWNn0SGF7oswGlbDImpCmSNB7hGdtiS1Mfte1VCqWed818=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5836
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=742 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230011
X-Proofpoint-GUID: sB7xTs-LlrN05Jq2toueJaunvTyQAjDe
X-Proofpoint-ORIG-GUID: sB7xTs-LlrN05Jq2toueJaunvTyQAjDe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Olaf,

> You are right.  I moved the drive to onboard SATA controller and the
> problem disappeared.

Since the SCSI-ATA translation is done entirely inside the HBA I would
suggest looking into updating the controller firmware. The mpt3sas
driver doesn't really have anything to do with the discard handling in
this configuration.

-- 
Martin K. Petersen	Oracle Linux Engineering
