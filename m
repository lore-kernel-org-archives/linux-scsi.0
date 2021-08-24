Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840E6C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BFED6121E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbhHXDbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:31:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27194 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234368AbhHXDbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:31:41 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xA2J012035;
        Tue, 24 Aug 2021 03:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wYKNfD/qoCX53rP6++ebXXxls79zbhQlYHwHwN1JYo4=;
 b=CNdCl7FG4jx1UbsLdRU5aro4q8ILePVsfer+Ih+2G/5mqX1fRhpTMAsVyJuUfrUjLjvV
 xOw9YVGMjDuRGLrcOniDWttpeCgK+DS3ksAEQ/pJ9PgbMhqPSVJCoXoaQ+nzpDlKrRuX
 lmoTqG7u/O7rRQ1sHtLfRfHJsTzt4/5MBQvgMlxZeH7YIpA17humyYIY+hSzIK6pgrSn
 1BglpnG2HdnCafZdXG5R6lX7fddnNgzdQtqf1tIF+qkWX3wGYJF4SuncGUabuyGNLyr2
 /dUORZdLXd9UMBFoJUP4Au6S/xHOJqy6JbLzna3xp1o50kuQBHfoCdQqbaYLr9tGfJyi cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=wYKNfD/qoCX53rP6++ebXXxls79zbhQlYHwHwN1JYo4=;
 b=GHr8XtE7CX115sI9t/oIG7Ro/mdN5/g5IE0DygqYONAs29h+P1DZtzo1r7P0Cqp1x2QE
 x5Q+09bA3x5eth0hpQD0SVXai5U0B7Q8BA8As0LldyA9uxtmg4QQWl4Nb/zcGSrAZgHq
 5gCkNimlhqEqWjxojlHv/XLBeibPzP6+soygFXejARhcemXKgv4Id4E2V2xK6hpxK8Iv
 PLYKcs9OFvtJul9IhRMf9NEGy0Ldm06+IPt2Vcd+l7PGfm5lRNIw51zaP4w7ToXtLFjV
 Nt2KZRoyVhkbnIGE4mxDWHb+fFcev24FEJ9X1XEt3DFhtOAC07hZRVp6eVLp/8pFigAL Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akw7nb6wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:30:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3BMB1148374;
        Tue, 24 Aug 2021 03:30:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 3akb8tx38f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:30:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyqMa7+Q9zp05sVXxV5k/bUBAPAlDrxcqmjIQEHvCaBqwQFVcew0SfuhL3gBjk9Vnff9JFJMYCgl0omlpAN7wLjoONa/at1+OUD09E8XcXayx8KT5Wc/i+9TtrlG7Bk7chJJ2VDSg3vhqkTlGyOD1GhJbi5LC3vawqIzrW4x2x9FmW6mRD4Nj/mHS6wrycaMV0cTvYZrMTTHCRJeC0KUZfCKw0mpdwCGmgNwSifXSyveEG+TdD74b3EmyyvHq7dB88XubNugRXT/3fyXjRdF6nX1+5bVSz4101zPl7AK6xXTP6/upRFaKZl7IserEnXQA69GFpQIUgvkJDpE5oIklQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYKNfD/qoCX53rP6++ebXXxls79zbhQlYHwHwN1JYo4=;
 b=ctF85LCOsR02oFZcaJI9hDrJul4mcah6kNQYFB18PcVBCGUfNMR5jRn9JvSW6wKtF7b4CbiE+sC6Azt9anMpv0Km7yb6jmXjYuVxeFPfzStTPykMxVRi2ZOmseJmZPVJtai2bROk26cW/Drurhnzp4mEo4NktwTH6ZEHNklDDN1KtR3JSpuuq4sYCoEY2EFvplXHnWXmkd1YpAq4SkOG9bzVIHakm03cozOhb4bKQdgi9tdmDpYWPkwXyjBHLLeX3r0iGVQrdvK+rXlWhyUfX4v85H9i1drH9Iuckm3FvrXjywDFnJOFf3ka9hpIJeWCi0MMWCRxI1xEEuiQrhY4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYKNfD/qoCX53rP6++ebXXxls79zbhQlYHwHwN1JYo4=;
 b=oL58ZNVXz2tv0JAepxk9MptDD8QcPkeh2HJqh3LgU48pW4dcFeaAqGaoW+ObB+WkyB6m1EY+WZydRMTndTcxBd2XHNIAZNf+Uh1/gmij29ZvqwyezbC49SjNnibVVF/b+vTkqys+urZJ2oiiiVbQiA3WMmXSFY0zuzx9hAxQ99M=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5436.namprd10.prod.outlook.com (2603:10b6:510:e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 03:30:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:30:50 +0000
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        sathya.prakash@broadcom.com, thenzl@redhat.com
Subject: Re: [PATCH RESEND] mpi3mr: setup irqs in resume path
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7ffecz8.fsf@ca-mkp.ca.oracle.com>
References: <20210818081755.1274470-1-kashyap.desai@broadcom.com>
Date:   Mon, 23 Aug 2021 23:30:47 -0400
In-Reply-To: <20210818081755.1274470-1-kashyap.desai@broadcom.com> (Kashyap
        Desai's message of "Wed, 18 Aug 2021 13:47:55 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0216.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0216.namprd13.prod.outlook.com (2603:10b6:a03:2c1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 03:30:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3ec848f-9305-4557-a4a4-08d966af9210
X-MS-TrafficTypeDiagnostic: PH0PR10MB5436:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5436C85E1E0B566AC95412D68EC59@PH0PR10MB5436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WyqBKnuCkJFua7/ctNWBPm1Fi6zz6Wdh9jTzUC/WhSEsR3OQeuBlb0HN4peakb66t9sNM6YxVdI7e7wjy99+B2mk8sCKGN5f8MMfMBYfEK7OU+mN8OS5D56VBrNauy9LnHi9YAIsrlKeg5s2RRymm6NytlFs+su7WdZuRDKtHtQjyM8ya1N62V82k2N5cQvVlb+0Tab3mF6l/TLTTbRiVQydqz4Ja7wkqm6KvVniTxkkkCRD8d822ag871mf/MafP40DbMJf3yzQhYSBtXlf28fUtC49Wtl0hsr2FrEp+/N70opWitHQqc+rfcFEWicsB89FVxLqnYHTGyV0+12UNw6gLwZOOSWa/L6gUXortWGyyIWJ6BIy7kYUm43SzwiRjcbQ5ivbCC/SqZLtCAbbirjcj9J/dCxmaeoyMDaxZc7NZXnRlRfpf/gjvWyDm8oFJKj/FLHvatqcJPvViX1koGjodFTLnDyEc9ivf7H8+Hc0JzpBSeBya/rqB/vmUxSAccQIKn6Dntib+5yvEd/sDMUuFBVvlhBmKKfvRbSR7J/9S8iq/ZZirtG3ShaUjqHvYGJDCvEAvznZFB+B3iCI3PCreGhvK+puoBcbQlZZ59XWKLto/JbLjTuOo8jBkK9ITBjSUQS6+bnEPx0vMY0pnt4QJrRrwymRDs7+NcUCk6KkAAMoT5hYROgrxAWYywt/6pt7NLzfaSwAIBIbqqxLOeaheNgRPQJZNlhjqKXHNy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(346002)(39860400002)(186003)(36916002)(4326008)(66476007)(66556008)(6666004)(66946007)(558084003)(6916009)(8676002)(26005)(7696005)(956004)(478600001)(52116002)(8936002)(38350700002)(38100700002)(86362001)(55016002)(316002)(5660300002)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vIOL37rvUgLi7mYYtNaavyScqjBmoYaSlwE+cTf24KS5MJOZZ8JhILmw8bhz?=
 =?us-ascii?Q?fIQTCHREuv+uP+VG8ZtAkKFnDOV9VoDdvtwwCDpRNPPUzUpqKD1gjcHCXt6E?=
 =?us-ascii?Q?lqn3oXMEclQ/b4eg255k6GDdlgAkiK0FHG2Coskzx6sdNGsp4ra8BkwJrom5?=
 =?us-ascii?Q?4unahEXxYNXfurbMS4AzFuMTj/hooc5SArY9wrNVAYf4UctgiHD0LRWYZI84?=
 =?us-ascii?Q?lgoMhz0yEkW4Fa/LjUvCFI57masGnvKcG0y6SFNVDNceAREwA016g9z7KfF3?=
 =?us-ascii?Q?dXNeysjiWSKX9avCA8qyPBVA+ItO+suP06kdjRY+cRt03Vi3JAcy52G4dtww?=
 =?us-ascii?Q?71dm1DK0jK0dO8t2JsIevcz83xs5ekXV1DIIP223FLISg1wBfR0vwKik7BMX?=
 =?us-ascii?Q?KqPwUeUc9qFkTZp8a2CmqxieaoTMyOX2/2I1iBTxSTBeNzDfBxmw+zilX2tS?=
 =?us-ascii?Q?uIC4lixifKoUupTVRMpWn1r3n+3K5kmTBV71a8TzILdnFHZB6Wm2ZtLAo4kK?=
 =?us-ascii?Q?CZCe4JjgNhnDaIHINmBZPyDmd1uPqq6z7JYSQkAqeDEI0iZKTjbipUdOYQnb?=
 =?us-ascii?Q?OBhuDhoFAdVrFMV2vJbf4KgOVHCBCwLD6axgg+KnY6QqvW6CKNm9XtO6Tqs5?=
 =?us-ascii?Q?qzqF/IeFGX741ksnIMbl7BdYVYz8n7EPxEIFX7964U7tLInyl8FWlbQeY7Xt?=
 =?us-ascii?Q?ePXbbBbtXMMcOyGjjXIsm91LnoSEerkJWCBd5vWJw57oVmdHLZMBG4onxJLO?=
 =?us-ascii?Q?018tqJJ4gxlNFCgnLC1xIlZrRYRRh2VluKB3GxUWzTp4sY9x/sGZ25JmPHJO?=
 =?us-ascii?Q?8qkLk7j7EmSDtptZ+E5/SbyuPyxmlco3nWdji0o2Mii1pVsXHljMe7PXLHk9?=
 =?us-ascii?Q?eqb98f0AN7mnBvjeKra15g4ZBwJ4+qSW3oRsPTZemTSnpsBAjmbZT738gMmX?=
 =?us-ascii?Q?RPTAmkL4C/JotrAV+TJKt39VUkBpzMjaL86iIy5wt8gk7AzSlrF6NJ7298iP?=
 =?us-ascii?Q?Q9fzDcn3ww/LdWNGYZlLMx3eQtoZUEfgLiFRpXAM+H2QzC1WdF1BJpTBkV9s?=
 =?us-ascii?Q?+Bxk1tw9bTeOlGVW3fMtgsv5bx6FNCHavzu+hQIJwLiU7GrqbQIySduvoeVM?=
 =?us-ascii?Q?S+n+C1OyA3rEDJR5AVkhYVYX/px3UGgS3RGB4tBYgwsFQp7FMZL6umQyOJ9E?=
 =?us-ascii?Q?Bt7tg0fRxY4QBv7IL/tlNVag4DF2QBVOHFSc7kfFnUL7HcvE+DqTLivmubd5?=
 =?us-ascii?Q?ZeaDpntkVSgaj+90Gi/gjTcHiH+/01akyMPq99ttwLVzfyHnESt06XDeHkwT?=
 =?us-ascii?Q?udB6d/QoiR1S2+hB8CYKU4uW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ec848f-9305-4557-a4a4-08d966af9210
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:30:50.6416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZ7AtEM/PG6HENUNLjpgUzN7eOanMw3z10CKMrWfnV8IluEaSdS4bPXov1Zo1eisDWnubQquw/Ifs/A1RWififbLXmVL/DRnpD+AWytHgMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5436
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=813 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240019
X-Proofpoint-GUID: X8Cd3RAgijv4cvLOPw1O-UhT25l_Bb9e
X-Proofpoint-ORIG-GUID: X8Cd3RAgijv4cvLOPw1O-UhT25l_Bb9e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kashyap,

> Issue description - Driver is not setting up irqs in resume path.
> Eventually, hibernation path is broken and controller will not be
> operational after system is resumed from hibernation.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
