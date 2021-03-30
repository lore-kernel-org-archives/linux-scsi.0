Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6B4C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3E861584
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhC3DDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:03:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33616 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhC3DDI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:03:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U2vPVF173433;
        Tue, 30 Mar 2021 03:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8hOjwOG+IH4pPXBcJerIFg0GE0dg6jrTk196KJqOqHU=;
 b=QDJrdonVLaszHqRkQUb3jH7hbde9jVaH5Z68tTlZnPa591LwugXpDH7YU7d4/11hpLsz
 vweG6BRnGOgy74d1ZQ8rg3M70DvSb7s1pWZoKev2FWPgb1BUvYVB9SF9+n+kkAF6SoHF
 WhbyfbWR3fL/imfccF8i8ciJYEygfzNcKGoQPwgoViC9jpMSd6nitHM/SEGrFtRqeJ+G
 9O0AKPfKee7yra8vUU3yq5X1uLDCmw+kNg/0398R2KxEaJaAsUZZ/Qcjr6XaALILwKRd
 WIAhluyiytdrO51g7nqiPP40BtsX1opLsYjkVlL0Qo0nXe+Lg2y/MwbWgqktemIG1Q/O ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37hwbndfpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:02:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U31R6c073413;
        Tue, 30 Mar 2021 03:02:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3030.oracle.com with ESMTP id 37jemwh330-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:02:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NywYSmwwkxsR0lKCwAVf2HKwNxdomMMimbcwuzGaiy7+ht9JAOoHN7QB1Qosmf0S1AEwRfRuyB/2AwrzoQd36RvFOW6SJlQ27aDzmAGNZnvz5JM/BRNf49kPw87rYxnjQMcYZEv2Wysc+cXxz1buGcoE2CJpADEUJBVnwrZGOpasa2/5dC41+ivuN2/IiD6AdBP2OpV75Tx5YCEOMtIqHVEK2g2Ojqcppy9IYc0pYIe/8UmnlM6RWnvu4bf4OW5RwA6bJccsvqWfW3VEwAFSRP98/0jhTQ5UpGzxgjx9Bv6t5phUJQG4O8uU+ApYWjBSm+OlAXBdEETxNQP/9Ab6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hOjwOG+IH4pPXBcJerIFg0GE0dg6jrTk196KJqOqHU=;
 b=LuHQvqdVPm9jE8GIDmIJdU8l/LjQLmAbRWnlyg7E1Tzn5oNuld5Oosa8+MziIfK+W+D9vSuy5XYvb5U3U+GYyMX0h5nzDuMrkuPGYzyKL2hrnACkjb8/f6Wk9psCm4vagZ0ouaR24jE0dYQ+74GVimPWZOFnrqrtAkOR6YEsku6uiEGr2wOHR+67yHjfGxSZPTdujmuRnTzGLk0M7AP9aJty3npX6JHkByWQUBLL1mZ821fe1njAIaOYUF20GoZbkEuEm4SLyyiHhUQAzsZdfTTAXWPOYTnsfz6EphwO0atFuJPARNyjPJj1AaChd00i6dhk9wAi10EX/a08Er0R5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hOjwOG+IH4pPXBcJerIFg0GE0dg6jrTk196KJqOqHU=;
 b=cP/t9SPg07jQG18m9827M0KafO5ZlIL+IOrxj5B7uqj/nU23yep/iabB2RCn5yN1XH/psruXa/F+aXG1hj9GyBkAuClylYuyn2hZQdlFAhPpXB8QMoP/qQJH7V8RnCNM0ReA2xrcJr938OCerW6DGMYOuQaQq0bWe/+5/sk6xo0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4534.namprd10.prod.outlook.com (2603:10b6:510:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 03:02:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:02:29 +0000
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Don.Brace@microchip.com, Sergei Trofimovich <slyfox@gentoo.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi <linux-scsi@vger.kernel.org>, jszczype@redhat.com,
        Scott.Benesh@microchip.com, Scott.Teel@microchip.com,
        thenzl@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
        <20210312222718.4117508-1-slyfox@gentoo.org>
        <SN6PR11MB2848C136F6CB4EA66D42FFAEE1639@SN6PR11MB2848.namprd11.prod.outlook.com>
        <ea49071d-d1e1-97b7-6468-501be0b9b195@physik.fu-berlin.de>
        <CAK8P3a15jo_qup0W4itY2Fkm=SZ-NuQjmUTpDBPigSCvrF_+Yg@mail.gmail.com>
Date:   Mon, 29 Mar 2021 23:02:26 -0400
In-Reply-To: <CAK8P3a15jo_qup0W4itY2Fkm=SZ-NuQjmUTpDBPigSCvrF_+Yg@mail.gmail.com>
        (Arnd Bergmann's message of "Mon, 29 Mar 2021 16:22:35 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0601CA0003.namprd06.prod.outlook.com
 (2603:10b6:803:2f::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0601CA0003.namprd06.prod.outlook.com (2603:10b6:803:2f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Tue, 30 Mar 2021 03:02:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5590177-9ed8-4845-08a6-08d8f3284155
X-MS-TrafficTypeDiagnostic: PH0PR10MB4534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4534317E34F91FFACECA5BD18E7D9@PH0PR10MB4534.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6XTsB9k0mG3FtCLuhEL5EUql92K8MlkeMBMoioHajGcgEdKCDg/q7xSdxJEDysSGBGtVshW2dXLFOejOA9UcbDyFbkK4I80g78/eyZSZNwueOVOIqSkdxK0WtLAoe/ozlyQC2iOx4XTMK/EAgbWpM+OC3+NWsH+iNQJgSe5URKzbca1fS/U1BacuuVD9pDvxFeAvlyrRb5KXYUAyE1ODfkJ5I55lSK7lrqo1e46lKLKgaQq3Z6U+f1hZHJEinnhmdHZYNUpHGkaruCfPGOiA8/bLf/I4+shUXlmt/pnPtGftVU/ed/lJr0Cpi9pHMZyjDJzylb+/uBNYOVpa+c+R7emW/TRTWF1Jp2W7ZeZ+PVYtjAz9IGp62OUnbTPrAm31yyTQOZtBhTkTz6Vlfed1YXx/WfrMvudNCTrWaf9lM4VhwoMmNYoi3HaELPauYgeCYy2exQB8OK7PQ2Ebkc9TPfqo3tI4uMUlG1/ifXv+L8D66PrOuSwM9usTD0IZbQim2e5xRqyrswUE6sQCd9YoA4hD9i1IpkY5ob6xpnVkYKI5cCsh30+D6dgmTf0OuL0M6QFZvMuhnTfe++60EqiK55d3zxgYUFCPyFtVXSyJqGLINGQd52lp5cKdYwMYHkgDuyKEi9O2yoNQ3JNe9BA9+FdrPT6+zievCwPB30LhSME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(4326008)(107886003)(186003)(16526019)(26005)(478600001)(52116002)(956004)(55016002)(5660300002)(2906002)(86362001)(6916009)(36916002)(66476007)(66556008)(4744005)(7696005)(316002)(54906003)(8936002)(7416002)(38100700001)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lG+PAwrCyxeBTbOBoTtjCAXPDxodC2bi/DhSaj3umTOIdtldpSw98buTnQUC?=
 =?us-ascii?Q?5lj8+v2Hvrk2OtEmzPbxnB0YbVMkiwKk8ob1I/9SeOBuyqnTM1TvU3XXTjrn?=
 =?us-ascii?Q?/WdVsiPDLD3MyzNNDTHvYQw1xCxLEGvZ2dKaAPbBtauj4cfwAdePJocrbQTY?=
 =?us-ascii?Q?vVZz7rAI6y0vBnwoPuES2yIQ6oRFp4mnXoENdOmiaIBSyXgxeFZd4KC9ONWv?=
 =?us-ascii?Q?RfbrV9gY07f58A6GGz4g6HsADbJE/JSUHPwTHV3waX1lMWnFbY5Q9kE+dA1M?=
 =?us-ascii?Q?mwUqUPKFttOJ1jkOahZUdzddObyQspTTR3wXvF6EoJrmudrYGpsJFC1KQ/X4?=
 =?us-ascii?Q?EI4UqDHAcL4JOBfwZvUu4oRmO3R32ssVIJVjGTr6NZlpn30y+VDMTepn+9HR?=
 =?us-ascii?Q?laf/vfnn02aXo75i2Tng4D2Z2UU1JJJvnokqSdkWrA2WdHdMk4vvbmt4xER/?=
 =?us-ascii?Q?LBJd57TMgzkPNiK2g4+d9J17GvHSPC9BHAybfxht6ZWvR2gHhlQIe+bj3zo6?=
 =?us-ascii?Q?CRlmhar+T6ytFZuAfT/4tBXgsf9Bf/fbGXgodp5aonI9PEvxw1p3EUu9XbZT?=
 =?us-ascii?Q?wmOSgH3dqUxqzmLokz66QC/ct/1e1Co1CD6d5UwasRwZ60st/34m2MHvtfdO?=
 =?us-ascii?Q?97LtfL4df1SpOSCJTuK8MUL1kMn9SGxvGjgdxKt/3oojzyxaNxP+oH0pN3Nr?=
 =?us-ascii?Q?S7+p8rwJITWX3kL4GqEMZUiTqjoOk/y8Pm7VI179VDb+M53Dpxi3dBDsFWyg?=
 =?us-ascii?Q?etnHBTcrLuyF1QBeLRk6NNy98d0Jj4BHXhzi2xBXEEH1Iy7KXw4TkRzaWaUl?=
 =?us-ascii?Q?WgFGtF8kLcrTqDAESd4ev65X5sC68Y7dFblJLlYe70vTGw56UNzSZtgeu9EY?=
 =?us-ascii?Q?iMoy+UtWZH0rL/kKXKEYS3TrsUoOa4yr0x5pgXFan4TqSO8s7vjShRZT8dA/?=
 =?us-ascii?Q?rwTJALHSE/ahQZi+EK6k9Up0q58vTtahuVw7qtS71vTn1DCAhNoenQeQyXHl?=
 =?us-ascii?Q?eN1TtqLqGRC10zB5EP2OBpkowzYjYjtPFvmLdCxyfsPBc/7387H1nfGfT0vs?=
 =?us-ascii?Q?oHqiotG0jCwonbw5URJjMWSTNxsMvRPvRhGizjZzewlRmvYtm0ZdTBEKlBsg?=
 =?us-ascii?Q?4AVAjEnVd7mQQ0XSG4gNf11FqhqDtG0L3i5vN9/FeEzMML5N/apwe+oYy+pw?=
 =?us-ascii?Q?ycLf6BPKJIJd4/ygeomPcVEVtco6O0ZObMWRfglzPu3g8YzzR0Ir/0YWyknW?=
 =?us-ascii?Q?hPgeEn1pTNNAwSNLf0UowRiVDx75wXT0gPkO4rW9pC5SYotPhG1IqlkU4ys+?=
 =?us-ascii?Q?PEPeaqrElDJbA1WYYbNIp5ic?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5590177-9ed8-4845-08a6-08d8f3284155
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:02:29.5259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCHjQZQwZfZX+UFNfONmGvZ2etRwFce4kMg2cw5Q7uwb8zlU2CGoIZ1+LJPcvFEj8QaZR02mafPGGjDPuzYLH7twx1+YBRs/TEqlrIk+jCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4534
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300020
X-Proofpoint-GUID: N_MYfWTueKLaCv9A3Dc1yfgrDyCNquLK
X-Proofpoint-ORIG-GUID: N_MYfWTueKLaCv9A3Dc1yfgrDyCNquLK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arnd,

> I think Martin is still waiting for a fixed version of the patch, as
> the proposed patch from March 12 only solves the immediate symptom,
> but not the underlying problem of the CommandList structure being
> marked as unaligned. If it gets fixed, the new version should work on
> all architectures.

Yep.

I unfortunately don't have any hpsa adapters to test with. Was hoping
somebody with hardware would attempt to fix up the struct properly.

Given -rc5 we're running out of time so for 5.12 it's probably best if
we queue up the workaround. I would prefer an amalgamation of Don's and
Sergei's patches, though. I do like the assert so we can catch problems
early.

But really, somebody should fix this. While hpsa may be out of
commercial support, Linux will support the driver it until there are no
more users. And the current structure packing is just wrong.

-- 
Martin K. Petersen	Oracle Linux Engineering
