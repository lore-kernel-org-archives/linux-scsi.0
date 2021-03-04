Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F47DC4332D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03ADA64EF9
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhCDERN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 23:17:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbhCDEQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 23:16:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243x8id062507;
        Thu, 4 Mar 2021 04:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gmU/0S+qg9/xNhdDqx+lCZEcdviEUHSPG5S0cCU0w5o=;
 b=vxalU9dQk2u03aoM9XUC3JJaLF2jxIo2DO6LqS9fzb5f8zrNAVnH0HqgWVys0XWDp+Yy
 AqIU3SgU6ozmG6WuYcjnorvvQlx2V9rRYW4RvR1/tcF/S6ZSQYUzpi7u0+Tbn1KOEKXe
 93Na91zvEzmLBUrmhZqEvBZ9eYmrLDcysKDlHTvwQ8FlZj6/mtid/WoVlpNUmrdT5aqd
 iWvzMoz0ZHx73QgrBd2ILOf8QklBpm1rhGdczhumxXFoGYTVnGCR98Vj8M7vpDL1fvb9
 e338gErKNwXtjPTdAd8U7PLS9QLBQ5ZBdAhs2C8lOa152ZaQ8uiAzawXjJ6j4E2POsvw OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36yeqn5nbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:15:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243t5p6084028;
        Thu, 4 Mar 2021 04:15:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 3700024m5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:15:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7a7s/m2M2iA6pZljCSlsh9flc+n4kTlU6ccA0BTYslr5OlYJd5J49U4PRk98pVHM/Yc5poRgPcFwrhn7AAAu9cIoGR1J8S1TaOm00TB26k1iv5cEkNdCnOQyxYeS9QohUe7n00KMcdUxcWGUCXoA7YVNMeaZ19/PDOJekCzAcg3ecplV+qdrxheuUIr0neYdtCv8Lfj1DL72N2nEMiv/couYH0qJhmvjKQK01Ndy11Q2LeoBBle1cbY3QouV7+UAb+wUwmoXfzQh+u6aY7Nf/5JZLoSqSx1JaYrO3mw6+gODc3ub/4iVa84Cur937uBeac65o4y9xMsjvEbDAaYqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmU/0S+qg9/xNhdDqx+lCZEcdviEUHSPG5S0cCU0w5o=;
 b=Xs+g0afHDIwJ068IN47A7Pk8j1EXst4CkWGs7uEqKKhkC4S7WRAm0vfvCDTBFO0HgJHsKgloL5UtZH0h/Y6mihocNKqb6/u8v+AxRx4Q1n4bqb47SmPBLp17tLxp8IWHndARDMbjSnP/erlZluBazwhMEX39ZniPvutY1i2zWXEAnEsKADiDNd8hLO4Ll9AFHkN2sCL88vzkqnRX3icZx2mWxxobdqBu5ihSwDqp+vU4UwGsTKZEjNBdj7jcwEK80fQJwf14ivjGcmV0LRp64Yitw5Xdon3lh0XnevFJREA0Dt33uSk/gtFKdozZ+BWb22mvOGqC0PQnJvIMPwGqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmU/0S+qg9/xNhdDqx+lCZEcdviEUHSPG5S0cCU0w5o=;
 b=JadH/aYDUev9HBYFeJRJhHpqKNlQ/ed7Rz1TYvV/U9nP1QzPh2kyuTKehfdyBRJ4IeTxUAr1B6DZoaMZtB6ABKI35Hl9VZY/ALNb/AW+rP7ZxIPTH7VFOEGGouTPeb/sYOngkuON6nqAqlLuMIMhyS3516FajVa04K7Nv201Pko=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 4 Mar
 2021 04:15:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 04:15:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-kernel@vger.kernel.org, Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH V2 0/4] scsi: ufs-debugfs: Add UFS Exception Event reporting
Date:   Wed,  3 Mar 2021 23:15:43 -0500
Message-Id: <161482822406.30323.684163343681623393.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209062437.6954-1-adrian.hunter@intel.com>
References: <20210209062437.6954-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: BYAPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by BYAPR03CA0011.namprd03.prod.outlook.com (2603:10b6:a02:a8::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 04:15:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f266e068-67e2-489e-64f4-08d8dec43187
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4552ECB7401FDAFF568F335A8E979@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SwkMF4flE7XapXQhGNagIHFoBSTjFmSZm/iCZsYKjv5lIjN5iMDYuIq+XSdi9Trn7tDceufgXlgYVHF2WPixvwSYGWNA1a2qIDBXSPwUP9J0m14ItIOFoYIM+Xb5Wib5qBbEvG6THyiyLIp5Td3Osl4vP34Dgl1Yo9Kxvlv20jkTuMll3/PsDnreUzWJOKw0TEp+IdWgWDByPGJfMU5ENb/xSgXO70TLMQIXT9tm8URnrpREgBCWlr7VQz/tAKXfszOU0q2TC20VgkSg7g4MPl88Z14e1HODHBcIGBwuayfU4Cw6okdyXCpgjuLNp/Q/y+BEALEz8l6WpfWFMqiB4h8RIZqDMqmw347x8KGRff29uuG+MKlh9Bs+1v8YOA1aW9znYWXBe4wCbITb0AVVHkiF7iAfWck74514aSTlnZYcoEj9eU8Ij2wAdPGbyZm1Q+0yNdW75Q4wpxUv2NuHqMdk4/6Kp1dDlPIGq1HweKXAK5pKN07j8G0Snmyza+mIeoGCSSe+DFPp8v8m3kxfmM2zPjgQVENCWcHparWOT5wxD9o3hgnTniVqMp+unfTHFWwZi0wy2/R2VszqIhuApTt/aScPyyyHSeI4znJDAHI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(26005)(66946007)(6666004)(16526019)(316002)(6486002)(66476007)(478600001)(966005)(7696005)(66556008)(86362001)(4744005)(2906002)(83380400001)(186003)(103116003)(956004)(2616005)(36756003)(8936002)(4326008)(54906003)(110136005)(8676002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TVRJbWhwWVZXcXQyMkdaNXJFKzE0TDc0Rm9xMkRaQWtSVkNRdjZydVIvQ01Y?=
 =?utf-8?B?ckNNTVNiTWRRaDQ1MXo2d2dRcU9xYVZkR3pCZjlxQkEwbjE3d29zKzBMczJM?=
 =?utf-8?B?cFphOGxjUWdCWkZJVjNTL3RxZEFQZEg0UWdIRXEweExGWU5NMDRLblR1U3Qw?=
 =?utf-8?B?NkN5RUtDSTBzK3RDNVdtbFhMbk91SGRMcUdVeGZydndVa2VUVlltM3JCZGQx?=
 =?utf-8?B?NCt1NGxKM3FmUURqSUxUVmR4TWhoOTd1Nk5TbTlOMGUxZHhrcjJYeWh6ekNl?=
 =?utf-8?B?eWRTcityeE42SlJ0WnkyNzZqTHNReFJ5V2NUZHhpVVpoZUFHUmdvLzhqSGxt?=
 =?utf-8?B?djNSY2UrQ1FkeTV1QzNFMlFFVENncU00OGxJK1ZRZmlXUncrUXNlcksvdU43?=
 =?utf-8?B?WStuS2F5UEh6U2FVOHl5N0ExcXhJUnc4NlQvVXE1RENJMDFaRUg0WWdvU0Jj?=
 =?utf-8?B?RHpGOVdrUkZxQU5XMUtZSVZDZVNVRmdsTzJOa2pLLzg2ZkFTWkFGSThRemta?=
 =?utf-8?B?RGE3WmFLaEpQZ3BlZ0dCWCtWRXVYUit6ZlJGMmRITFNvRXdMT0J4b2JmTFdx?=
 =?utf-8?B?UXh0d2lyZURONjBFdU5GWkp2UkkvZXQzMDhDUWVSRnIyZVVXTmZ4NlpiRCsr?=
 =?utf-8?B?NCs4TS9RSCtGcXF2UmNhakMwYStoL0lZNDZNUDVDWWNLd0oyVklZUlk3YXVV?=
 =?utf-8?B?WjZvKzFlZU4xaG9xWmVlckFlQWF1SXl0d2VuUkxSc0JvV1I0OWFIa01XNXpR?=
 =?utf-8?B?dTZFUnNpQXFyTkpyZ053MDRONmNxUmZrNjViZHViNVdBYmJ1QmhXQS9Ja0dR?=
 =?utf-8?B?dGFGdEpzTzVIbGpPUWdqeXJpSC9mUXRaSFQ2ajZ3YzhNTlRSanh6THZnZm8v?=
 =?utf-8?B?eGorYlVuUnFPNzFJQXd0NVZja09PZFRwTkl6MG4vT2FGaG1BclB1elJTb3lW?=
 =?utf-8?B?YlpOMC96NkVWQjUvRHBhemVkamsyQzFaUE1IM2ljb0RwZXVJS1RFQVBQbmFN?=
 =?utf-8?B?MlZRU1dmc0w4Z0FIdGthaEN4TjYwYWdTNlR4eTczc3RLSEdRdjVmaUh4RGpQ?=
 =?utf-8?B?bHpIbC9WdGFFR3NKWkNYaytSWmRpOHlaUExhdzdmTnBNbXc3QnVDRmJXamNh?=
 =?utf-8?B?dkRVa2hzMktOell0MmlYWWdUZ2xJNXhsVERjSW5DaWFuWWpDYmV1MzFvV0Y5?=
 =?utf-8?B?V2NwTmlONWo2d2xtSFJ0OHk1eWJmMG5WMVBUSHlFVmZDUko3cEFNR1pHRzN2?=
 =?utf-8?B?aytGK3lmV1lmYjN0ZjFwZmF4bXpYeUVJV0RUdVZlTFpmbEM1eTdUVUxjSUpS?=
 =?utf-8?B?VzlYQ3NMQlhBS1Z4dm03NzRmbEhhQkFtZlBZU044UU90U3NJa3I4Z2dlaTc2?=
 =?utf-8?B?QnluY2V0QWk5dFJORkx5L3QvdW5HMmNEbnV1dCt2a0RkMnBWQkR3YTBJV0RT?=
 =?utf-8?B?L01CTkhJSzIyc3IveUErWG5VWUV0N1kwNk1aQ0ZwNWdnTlRqQzk1Q25VMmF5?=
 =?utf-8?B?bWk0UThVb1k5R0JhSFU0SjdmdXoyNnhHbGtqWnc5ZlFVU3RQRGxkL3FoR2F2?=
 =?utf-8?B?NTFwR2JpcE9SUkFsVFhaMVZuT25kbTl3L3NxQjAzNTc0dEVxd2dwU25YeGFB?=
 =?utf-8?B?bDBySEZscWlPV1k1VE4yRDF0S2FtRm5VTFBiR0FrTSt4WTBGZ0FkclVrYTZv?=
 =?utf-8?B?N29lNk1iMEJPeG5MUVdvQUNZTXdaejhaZjdRNTVFTHgwMTlmWHVGUlkrL0pO?=
 =?utf-8?Q?/x3H/4KARSlJ4Cs7kSfKdan7YoOPKimOn+I3vq8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f266e068-67e2-489e-64f4-08d8dec43187
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 04:15:50.0401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8C4HOzPt+Txoo7lm71TgX2w9g4mnTv1bEcuod3SfJamvAcNebkYXwhzYAWWx3COrE6w5ialRnBlmSesLNj5Q4nf4DdGZ/dYRVoTskCZX2aY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Feb 2021 08:24:33 +0200, Adrian Hunter wrote:

> Here are V2 patches to add a tracepoint for UFS Exception Events and to
> allow users to enable specific exception events without affecting the
> driver's use of exception events.
> 
> 
> Changes in V2:
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/4] scsi: ufs: Add exception event tracepoint
      https://git.kernel.org/mkp/scsi/c/26b01633fac8
[2/4] scsi: ufs: Add exception event definitions
      https://git.kernel.org/mkp/scsi/c/8fd31fc2b84f
[3/4] scsi: ufs-debugfs: Add user-defined exception_event_mask
      https://git.kernel.org/mkp/scsi/c/e1c8b528dd23
[4/4] scsi: ufs-debugfs: Add user-defined exception event rate limiting
      https://git.kernel.org/mkp/scsi/c/c3f04083d653

-- 
Martin K. Petersen	Oracle Linux Engineering
