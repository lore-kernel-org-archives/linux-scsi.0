Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012B0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 01:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiEQBks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 21:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiEQBkq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 21:40:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917042621
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 18:40:44 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKrCRm027282;
        Tue, 17 May 2022 01:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=emBOr7EQgp5Gw6cRZWaEin9/WyUxKbM6WIj0jUrAxfw=;
 b=Wa4ZdFhzGy/R3brUyQDuTvoxEWP0MrFOM7+k+bfoRSAsP+rQ8ClE5UU9uEzMc3kBMtnf
 i3ijVFo4Rq7eKFaD3B6TEX9LII50CSOHSSoLKqKARY4ljSmpY3I2fAG7PorBFC9qOfWs
 wJq+pLzZr0sOzK5qzcQZ8MIKZjvpPt2MKrEneijj/lvNshNYZbTggIwb/0olDDSA7IHV
 +MZwZcw52vpLg1oO4C31ctsnImkmT2BeRQyUj9jVHEJNn2rbjMBd7iRSJaTKF5mItcKf
 umUP1qx6TI40USOpBVgLs6yGG9nGu8/xLbjfvDqdbpSqB08pZuo25Fri7sj52EVK4s++ RQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371vwpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:40:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H1ZUfM019224;
        Tue, 17 May 2022 01:40:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v2a2am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:40:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHQtIqZH3QlZatPAPtOBy1I+Fgvuno5AVDeskRRMUadzJCaUH1OEhWoji+cMiT8MEJY+eEdxcqO+k7zdWOTnnh0RAGqvLhMAm8wL4o1s9PBJz0QU0SZFSQrtSW5RfEPwebGiCieigEy8dTzw2V/p8yjgsufXy6fSh10eBU+QZW76d2kr6rOGCBo1caEgtEu8shlJqiX1NDLAMkleMiylFXnruJkj1WNF3SfSORvh03zGT4Chs6hNy7RPhebReC72YyFnxQl0Sm2wp1K1wtcuoAZ0w5VCbn+MSXY1Hm2lCHyQDpcfDB4Sb+5rZGMEn+1kGLJ7vx8zTL3Ao79aA954hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emBOr7EQgp5Gw6cRZWaEin9/WyUxKbM6WIj0jUrAxfw=;
 b=hHjAkNDjtqbLORtIjcX9qe1w/yY/twM9emjXIKgf9DtEXwwvjNtGzXlf2lGZUT/EfsOlXQF8qj+6SIL5lk9j1EP0SZIXgkW2dZzU/w7AjfJ2/i4HyEchTXfpQIYjD5HvTQ1Y0YGo7zNa7VOm1NFg8FssyaGqVG5jXBLUzTEPpQ/P1jFAl5MuvlfblLL5J0Bq9ENTUF8TOheSX9XkvLBdooWlIGCtRWAlIc+bCUu1uqHuPV7QV8AMD1tXI00JBbc3EQgD0NmstVlwAffNJdX0YynN3hAg3uAtSxt7WPXCCCVAgdZxkQV3L8e06rodkgx5Kq7yHu+yeW1sle+UBWagwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emBOr7EQgp5Gw6cRZWaEin9/WyUxKbM6WIj0jUrAxfw=;
 b=Zr6/chwyg8ztIGm51gmquNBhbDZrNfJxSYoDKWOB7UxPDFYV3S8cVDJZT0C+IEpl4H8KoIuqt59joJpyB15RyMTjFocapwqbKjRRs1m1xsPg/WUDbg9Qs8WHC5Fego0eyaiNEmyiA7X5oV9aAb+Uw1IjI37Q6ksk+pyNn6h7hkE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR10MB1700.namprd10.prod.outlook.com (2603:10b6:405:8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 01:40:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:40:32 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 0/4] Add VMID support to nvme-fc transport and lpfc driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ym5rl7b.fsf@ca-mkp.ca.oracle.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
Date:   Mon, 16 May 2022 21:40:29 -0400
In-Reply-To: <20220510200028.37399-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 10 May 2022 13:00:24 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR21CA0023.namprd21.prod.outlook.com
 (2603:10b6:3:ac::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e614334-523c-433d-abfd-08da37a63af4
X-MS-TrafficTypeDiagnostic: BN6PR10MB1700:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB17008F45E9B929658C1D2C928ECE9@BN6PR10MB1700.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g8s+4h+vRJWoPZtnO6zxhYYyAZJJ0uriw0SFmGszwS5M0PAifsXlNcRqtTPPLDzXPF6nvHUuScMNRp4yuOvmHhv7KRq/uNvoM6ZlorB2jGPec45v6Vf2rpwnwY+D5/2Il/kVK5ppee2Hi0g1h2UTAmDIqe5GhT+CAlRQXCspolk8OBzPuTPJ9awhfTslmr8lBlm9bXANSyPfDjRQ8UdT+ADxm2bZbdMxbpDnMDQ4NBTMfmIknmMYETdayP6N/1IQf7rWsbLvDA8ez0WwiLOR7qI8b0Cg5vlOafhVJZpFC1UphdcH5E66wAIdIBIrWeU9JP9k/2e1FmPzXav6kthRtP32x1UQ022cCnJmRo77L4ZlH8em0VP8fCkPwxtC3kKHuL8V6rpeloIo7DUpGMM58ilGlU3fonuPLV+FYr/Gkexqjs0h00fBVk1UH59Z4ul5z476yAKTiL7FxqHceqpj0JIO5ACa+QdSU0MVzvNlox2s33x1mFgj+qwylCRbKmCx/YJ52KVdAd0QIxv/fD1hld6tsvkTbCgJiG7eZ9rRbeU3dI+BtpoCsoLYU+qXGHP4KfAtiyOHyipJLJiBfQdo9yyFotDUVDpFIOjHM/HLsADMNrS1ZnRvARvxnLHeUmlmymDdMG1YXdDOHBqMfoDhwWgadYCeW52TLMZmcvG+i4WiFQWW+X2+lgZeIWD+TZoDhuOhJXz0kq2zRwgn5wDCsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(52116002)(36916002)(6666004)(2906002)(558084003)(26005)(6512007)(66476007)(8676002)(6486002)(508600001)(8936002)(316002)(6916009)(4326008)(86362001)(66556008)(66946007)(5660300002)(38350700002)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7+Rukuum5MbIf2JD0a+4O5/wYAArq7Blx78Yp/kbl8tnFhAcChJooXpDVHO7?=
 =?us-ascii?Q?L0idxbGcSo3vHpobo8J9hmMarQmL5KoYIQjkmuJ7yEwM6IxPR4MO3+Ard4xy?=
 =?us-ascii?Q?tfXOjeX7jqu6aOaNjxMFMk0TWXNankxSZ0W3+XEe+HrfpHa8zzNtgGGoS3fq?=
 =?us-ascii?Q?Ly+T6fZem/aS8FHenU4xiAluY7RD/BYQmFewXRgIpu5xTFr+14ZgMCKz2ode?=
 =?us-ascii?Q?sBot/WYJyBR+35f7P4CKlxu7usEI7O/OunnU4i7QoemY578bncsMKO01o1jG?=
 =?us-ascii?Q?mp1QhWy7GeaczK8zA94/hPwuaxkf/1xpo3ObEYbRc6+JWzC1AjsL9tA09L8G?=
 =?us-ascii?Q?0BS0jCnQMlKk98NT8EXmRmgjlDTfT+XiOhKXJcA7/1zun5N+N5EHGazMtP8E?=
 =?us-ascii?Q?chsoA4yY26Xi26KJBF5rrS0lYLgNn4I7mCUmXcEAoxZDMOHpsCdPL0bBPFyj?=
 =?us-ascii?Q?utHvJPO35ZM8t3RSzNX7XO6/1jYO44Vhq1zrb6DQCMt3UqT3hI/OdOiqz2y7?=
 =?us-ascii?Q?HZ1lZkqvL9LcaxgO5s1FQouyBpFwwW/sSmWU7lwrApUmNxKSLZIebA2rAcNv?=
 =?us-ascii?Q?eVMo6upHhFtySMYaghbkpZw6v/GASdgk9HNoKebKYHmLmZ+/JisFY5H7bx6w?=
 =?us-ascii?Q?qsm1bIgSaxsILTdZq1t62UCM0FekOx5ytszbyfpk+2Z63qCOtfjeag1nJf8A?=
 =?us-ascii?Q?ntG1wJBagcSN6E+uwB21mjtHbHyGEkWkONppJpPtUqXy1kXNsSQWnAHz8SnG?=
 =?us-ascii?Q?rW1ENYUt1Z+k215OPPfDMMnVQUs/yc/VA9DQi6zK0ION6QJVKZqI7J6bWjA9?=
 =?us-ascii?Q?OeRSR8fzSpcpw9iDcdJ06S1/TR4cuoR7+PXOGG0mIDkewii+7zsOCd27XOAA?=
 =?us-ascii?Q?bWyN0AHAX/ag6/JjqKPli9vkc0d3fgO/Lw/ac8UiPR7ucOkJI9XaONYf7CAy?=
 =?us-ascii?Q?+2ZZ7vGkp1he5Uls/9crdEUoIwsc4SKtCJp5ENt6GEMo2ctHyjHLuB6+bj+V?=
 =?us-ascii?Q?Ouky+kgg9C6BTjpYRX//AIQUVuhAMAlXU1SekOtg6yS+JqLhSdHhkgUSK4J5?=
 =?us-ascii?Q?JTsGvlVysoXaunSBlEXzFiTUyFDIjulg6XdKPuXOaqh9Wt6jEoJ0Xz7KrsgP?=
 =?us-ascii?Q?wxHREkRaYUZgDTQeeMS4PucfFAYPEQjGtxb4vUy86F/Vx7mVIKLy/z2e4i5U?=
 =?us-ascii?Q?VXUbNaJcLm+9bNZ/rX35Es0aozmtZi8hBWWl1uhlAuNeWkAPGrgTLRByiiqV?=
 =?us-ascii?Q?lPQbBrQ7yCk04PcYhWj+vXEtcDunQGo4SHkiAVvBsUKSq7XiV9EYxaTQVV1D?=
 =?us-ascii?Q?egGMoGQC0s5QTOLiUvir1LYKJ+D3HGa1d82g2Q1XhwXZLo0EiH1TY0Uw7kXk?=
 =?us-ascii?Q?C7kujZaVZP4LCgnoMu2dUCihwnaCjDy3y0MiEw/BRQQh612j+6529cwUT113?=
 =?us-ascii?Q?xOUyoEfvYdt35eHTMFnhYauldZIQE3Dguj577MK5XaxtTkula0rg+1yjmlDD?=
 =?us-ascii?Q?LLtnW42KXLj1WKzid3V7SU383G9dbN99rWXqzMrNsBIQSeJxgpGSY/WSX6ss?=
 =?us-ascii?Q?wKBg2SJilMisWgsRe+8AK5Bll9bbFsbD/cixQ1T9QmT+B8qKNcxy5fsMOYcW?=
 =?us-ascii?Q?CKVeElEui89ac+tR8Ao2UiSpU3Ppx+U1O3LNwzm7LtRGSAaDIS0YTOVdSijO?=
 =?us-ascii?Q?9hDo3JBOVLQ5lgDnUdcbqooj2/JXNbORoe6YcBSKaUeIDtL/i9JGUwzs3xGL?=
 =?us-ascii?Q?V76g1mUSqqVLJXgqwxdcMQkKgEBIIj4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e614334-523c-433d-abfd-08da37a63af4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:40:32.1120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zl9hy73her8BHtXbx20ilkY2kLoPHA8a1fbmXVCPJQjQTGkt/mJwSQyYxZgDE93Asx9ZsiTI10BOIftt1X0BzCgTNjBupc7gDegzdo7HJO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1700
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=587 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170006
X-Proofpoint-GUID: 6ws9KpYDb8nQBvFiuIYOmEyR4150jPhq
X-Proofpoint-ORIG-GUID: 6ws9KpYDb8nQBvFiuIYOmEyR4150jPhq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> This patch adds vmid support to the nvme-fc transport.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
