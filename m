Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD18C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC4820709
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbhA0Fij (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43296 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238638AbhA0E4G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:56:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4saM2115775;
        Wed, 27 Jan 2021 04:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ntq13CrXLEQCaPgJHzr5nB7rBM8+xsdnTGA0QT1/VX0=;
 b=ywOTQ2YtK2T4YXUx7ciz1MOk9t3hwDTk3CbpvGOEqX+UWbNm5hPk7Zy6sNjeb/Hi/Wb8
 rZUcUVLZ0vZQTVIBfQXEacL+0ldk7b4AJq4id+wOvlCUHmD7ZY4wX7gDap2MtbUax2xM
 VgDWM918XJpPE8DMxz96SxKYQbSVztJ6dvnR9x3rZwk9nyn7u9x6qFuyE+0jMHh45IOX
 BFr1sxe9MySuJrNwfcrfqK5ty1tdx04MvavQ6k2ERBRolW6s+J+GMBYKFZQNjsJHaZnF
 BSMCqEHdprHPaZDDSxAFg/mpQ0EfZm5XlglEvEj9veqKzTyjwSzsPQmHs7BPXQH0geNJ sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7qw6jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4p6mD188943;
        Wed, 27 Jan 2021 04:54:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3030.oracle.com with ESMTP id 368wcnsk28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ni9L4LTVyakLe3fEvIgV5nnh7I2yajeKOMhjAMyizexARQsjJCJedHRlQDaJi783vPd9OgAq/N/X1w+BEFKL4PqUEdbL1obYqH4BheaiskCgQlBgzfmHcWdsb6tD5mjfJkwTFUwTlwaze8pAwTMKYQzjPctFCAGlo1x7yIydV3UezxrEpHOG7QpUi0GNIhF/F2Rcn8msbHsDQPDWk71lLFAA5HO6ExHy3k96Pzod+La1xrTmKwzZdQCK1RfOAmYnPBuo+jF1R3AMTLGP4pAF7HrgKedvZthdHCO+3+pUF2O9HV5VPVjPbZqon/5FV/ERhtp+D1u/kEn1ZOeoNZ4zmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntq13CrXLEQCaPgJHzr5nB7rBM8+xsdnTGA0QT1/VX0=;
 b=P6wZhYlyJIvkTbWh265LtQi93gVl7V9tq/yr8K2trrEKIKEr709AaFXfPnnkHijQWdGSx2wiYE2iIFuF3L0wczrlR7Ktne7p9NzsxHCrTf1Dle2X+fRGuBV6LwWn048k2TjpbuFaQfDP42s7Smfq16a7ViywY3WtayP5ZumfJ813ovE4/A0dFQA+NqcAtYQs7uvRrzmoHIPHH2zMi+zpMFgqPfKgzY3e7FZ3CIYFVfac291DSBCuofoy11T0TSNmCQCbrm0NXAeV2ItYmLpzPOPXEfd5zIhB2WphdQbDoR2ApxirFQApdfhicJkQGt63eCH/xELqGleOKxNSyUgSsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntq13CrXLEQCaPgJHzr5nB7rBM8+xsdnTGA0QT1/VX0=;
 b=rvBkix4Rzp9+s1PbE6us9ZkGjIgjfpE1/nQ2ZTjMj0P7rZDJB3+X8Y7OAAcHEb+jED6wrYui+TLPxvQhkwjq9dW1RVaNgSNr1V7/rQCCU8edOZDO8mCGx0rqwPf3YdzS73fJvGJVRarf+IiqYtduW6wfZKTfXuhvVxucai4Lkz0=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH v3 00/19] scsi: libsas: Remove in_interrupt() check
Date:   Tue, 26 Jan 2021 23:54:17 -0500
Message-Id: <161172309261.28139.8025416227993124300.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3440b2f-1395-47c5-4be6-08d8c27fa32b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584453891E96BE672B8CE458EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z8QrF02amVIwt+OUccQkalUOt6JLv3IMUY586q7ZHIMqZplgaGcXqlBTNai8CGafs0o8k4jabuabf1sX1zrBAgL+AOE2AYjr0G/ZlMdYuhiw9T0i/ZeAkGQn6yjiZDpfhsGtPGpmItwNQfcCCDS1boXurGHWc7fEK/2cofWT75RUwA1YTYMDs8ZTbpoLdzrD7HMnk5zl2vLs7M4FaiW24EHePcHvCSWqRP5rWfzBvOLTcyHDLGLVTMVANGhsD2PMsLzLIc8wjTCIyrHU9URMY6JKn847KwsfZPt80J4ooIvuGx24OeehgQwiC1d4CFwbbVYKsG7yICn/kbdoxswI/KBG/PcS32RIjNcVnX+XcfqlkBJ8hlVZaeMIQAgdYPQgOOJ3CkQ6eoLhbvqbVCl0NZbZQx+/Z7JNY3jtc8HIxVdCHThCjKB+x9G+cCNSKrxsez1Bb1pmy1wEWvLelAWgZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(7416002)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(110136005)(4326008)(66556008)(54906003)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZUgvSXg4RzY0VkhCVlptKy9nTGlFUDVXeEdzbUlPTVlVcDVjNWpPY1EzL3ZU?=
 =?utf-8?B?WXRFUU9wUEJjTmhrZ0RDWVZDTU1uL3lYT1NSQWtxd1NFSUNUSmdUKytQWjBU?=
 =?utf-8?B?R0k3ZUQ5Qy8wRzhZOUs5Nm8ySEZYSzJ3Z1hLYU1XaXdyWWgzajRUQ1hjbmJr?=
 =?utf-8?B?UUhLMjFiTk52TkMxZzUyVU1nVEhiVVJEQ1ZvL3dwOHRLTFl4VFM3bVhzMkVJ?=
 =?utf-8?B?ZmtWaUpQYVU2NGpJV0hsZStaNG5xYmlwc3ppTm8rb256VHptV0lsZ041bzNy?=
 =?utf-8?B?NTdkMyt5R2FVam9DTi92eVdSQWtoSXB2S1NLRGtyRCtqSCtTai9JWWkzZDRV?=
 =?utf-8?B?U1VCd0QzaENjNWFhVzBtZWtYYlRLNUszczZqVEhFSk1sbWN2Z2tSNmwxNWRS?=
 =?utf-8?B?aXRmOWVEMEhlSkNwTzVybTBOUEEvRkZOV1luZjhBZVpyejlraGwwTVQraEt3?=
 =?utf-8?B?YWUzRjB5WXhkSmhyeml3VXZFd3BCVlJqY3laakxpT1RIVVUwTVEvVjBTRmgz?=
 =?utf-8?B?VnRpNFhPS3pablBWb2JFL1g3NnR0aldsdFdXeldKaFViQTFMckFhRmFrSzk0?=
 =?utf-8?B?R3V1QWZtUVg1VFYyQXQ4SHhZNWFZcmZ4MkFndzUrNnhUYW1CcVo4ZDlycmZ3?=
 =?utf-8?B?cVMySzZpNEFVM1dYeUM5SUlSWkF0c3ptTTBsSjVwWFM2MllYd2ZjSHJBa2Rj?=
 =?utf-8?B?dWYxMWlKbmVJK0owL3Nkc0I3dGxhQnZOR1R5Y05lczJYME1GMFFsYUJTMGFj?=
 =?utf-8?B?YmEwR25ZTzRtci9rbUNGMzY4RkxxMHlmQ0NCSXEvL1pQNitWaG1yWVVYQ0Fy?=
 =?utf-8?B?ZDNnNmFCVW41VllOdXc4b1BTS3krYlVGZmhIbmhRR09FV1ZNcjNiNHNYR0Js?=
 =?utf-8?B?ZXlsQytwckJuZFpDZXp1RTZNMXBDU1orM3RCLzhOZ2crWUI4YzVoZUppN3di?=
 =?utf-8?B?bk9pTy9FMWVPeW1OdS92dDNBR3JnL2JDbDFNTUNTTHUrbVE3dUl5MEhUcWFJ?=
 =?utf-8?B?a0JRam8vSHMvTjk5NHQ1T2NNVjFDWGpmWWY1K1IvWlhJc0dhUDdUZklCODRv?=
 =?utf-8?B?WjQyYUcwTWtucEJVYjJBK3NXM3ErclZWMUE5bFBWTkZCL1E4Q3hwaVdib2dM?=
 =?utf-8?B?R29zTEFqMXA1STJaNmRtZFJCWnYxdURVbmZSbVVSSmRwbWszWDNxbEJaVjZv?=
 =?utf-8?B?SStiOGtyZUR3dW5YREg4U29pQTJKNXRMb2dwZHREMTR4ZExJaXRRcUUzNUhD?=
 =?utf-8?B?NlR6aUJYN29kMUZDb3E3WjBEeCtweXp3RGJkZ3QycHdPb0J4UGI0OTV0QWNU?=
 =?utf-8?B?ZUh1YVJTVkgybndxUWYrMXplTTJ6MjdQdmZPeW5ES0lZL014STJaWk1NTFdR?=
 =?utf-8?B?U1U3NnQ0RVlUN3RqMzIxc1gyQmJJZWlJRXFwSEVtNjVqQmZmaHhZalNrMDRQ?=
 =?utf-8?Q?UWlwNx8r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3440b2f-1395-47c5-4be6-08d8c27fa32b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:32.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +TDuaoC97oh7nb/5FC41SnLjm98Tmgbb1aIwNqWN4rZ4L8T76wuQPVR6DQdtbWPtaciRqePTBA+JPSbQSsHgGcV5KrNf3OL7EhVpvOYjsz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Jan 2021 11:09:36 +0100, Ahmed S. Darwish wrote:

> Changelog v3
> ------------
> 
> - Include latest version of John's patch. Collect r-b tags.
> 
> - Limit all code to 80 columns, even for intermediate patches.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[01/19] Documentation: scsi: libsas: Remove notify_ha_event()
        https://git.kernel.org/mkp/scsi/c/3f901c81dfad
[02/19] scsi: libsas and users: Remove notifier indirection
        https://git.kernel.org/mkp/scsi/c/121181f3f839
[03/19] scsi: libsas: Introduce a _gfp() variant of event notifiers
        https://git.kernel.org/mkp/scsi/c/c2d0f1a65ab9
[04/19] scsi: mvsas: Pass gfp_t flags to libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/feb18e900f00
[05/19] scsi: isci: port: link down: Pass gfp_t flags
        https://git.kernel.org/mkp/scsi/c/885ab3b8926f
[06/19] scsi: isci: port: link up: Pass gfp_t flags
        https://git.kernel.org/mkp/scsi/c/5ce7902902ad
[07/19] scsi: isci: port: broadcast change: Pass gfp_t flags
        https://git.kernel.org/mkp/scsi/c/71dca5539fcf
[08/19] scsi: libsas: Pass gfp_t flags to event notifiers
        https://git.kernel.org/mkp/scsi/c/19a39831ff99
[09/19] scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/cd4e8176989f
[10/19] scsi: aic94xx: Pass gfp_t flags to libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/111d06ab77c9
[11/19] scsi: hisi_sas: Pass gfp_t flags to libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/26c7efc3f952
[12/19] scsi: libsas: event notifiers API: Add gfp_t flags parameter
        https://git.kernel.org/mkp/scsi/c/5d6a75a1edf6
[13/19] scsi: hisi_sas: Switch back to original libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/872a90b5b466
[14/19] scsi: aic94xx: Switch back to original libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/093289e40b52
[15/19] scsi: pm80xx: Switch back to original libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/de6d7547ce1d
[16/19] scsi: libsas: Switch back to original event notifiers API
        https://git.kernel.org/mkp/scsi/c/f76d9f1a1511
[17/19] scsi: isci: Switch back to original libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/c12208668aef
[18/19] scsi: mvsas: Switch back to original libsas event notifiers
        https://git.kernel.org/mkp/scsi/c/36cdfd0f7a8c
[19/19] scsi: libsas: Remove temporarily-added _gfp() API variants
        https://git.kernel.org/mkp/scsi/c/65f7cfba6196

-- 
Martin K. Petersen	Oracle Linux Engineering
