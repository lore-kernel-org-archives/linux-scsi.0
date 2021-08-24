Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BF7C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83CDB610A3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhHXEEd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 00:04:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27532 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231693AbhHXEEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 00:04:12 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xAtu012513;
        Tue, 24 Aug 2021 04:03:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MnweBIAhzQMmvF6IodtQEHJo4LTWS5XMa+IXwZexHAM=;
 b=A0NvHhK9bb9tlFg8ID9CUNaEghWEem9cgzzMnLSzAfLnQAI20/68D12qEdxR5X8zI/3S
 rQLEeHYIVJ+0j1iWqtiW8bzYqA9wUfH1+2K4yqFjJyqcKUj8lCe5nOJw/iimlBDS/eIY
 Tim+dmE0Hg5U8wP4AG6+3oy+gQINNMUcNGP1MksIsabbkpfr6E70w4T5JOGEJ7tec/I5
 7dK8BsTfluY2uZ3rB6SnagdPEpRWqff+QESkOzlUJ8UTVNvo/qGLgHTUGg5CaqCxiulR
 EmkQE3R8qV6UuGyeTqRma0wDFfroNZ38GJMRITqYqC4pkwnWyFMkKVKoaurmxyk7y1fH Lg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MnweBIAhzQMmvF6IodtQEHJo4LTWS5XMa+IXwZexHAM=;
 b=zCtJn/fpRrGsv11W6s8Qs2PZ1WNcufxVoqoJQDRKS529VJ1elDVYEv7fRm1hhC6ZR520
 LJ/cDAJPUhvBJGUmgXnINKdbjmiPFVYiPEakZ1bWHeFYnwIa6USKGltn04TsRDiKk6HP
 9fZ2Vsj0jclOZhCoxUBPvvbBURKYbbgORBJVtm6ncoDCncp0Am+be7YkcwnGQ2kqhMNq
 EU31EJzh8Et9wPGbHTRabcGe4z/XXd7Hg187YWcvo2QgL94aIO+NUfTF/cnq1zY4IVQk
 TKF+fgVfUK+lmGNi4fIErJKQFNw+95Dhd9XJFlmJ2ZB9Vn7H+1UULKlDQNhDdKhvYEpU Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwcfb5sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O41Jok153706;
        Tue, 24 Aug 2021 04:03:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3030.oracle.com with ESMTP id 3ajqhdun4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFYEuMIYboycAn4yYK73pG7Hm6XQw6SCYhLhr71PWD2/09N2Q63GXkuF8EOelsW7kG/0rbaDWonZUGN2mQC2jwQIBf1hYHIDwR2agFSQ6d2Hl0LzOHPuNF1rPFm11psv9XpQcG7KbtUCjgr5I22kxRgrhXBtD3rO7Ye49cKZVx6ouS1g7vOI0QoKRJrQTE2bCt0g6+JoInbbYQ8VbOSTrNPtPo3gL/cPmrton8Kz+Nvj5HaKNtUu/DiazYLIJP0Jkh6Jey5qYULjoAAntgctpuBPisPXbOyBm+kbSuW/JqN8r8FedwRFR8fT16aanffBOf2uW/S7ZGNMqKhwHnXGig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnweBIAhzQMmvF6IodtQEHJo4LTWS5XMa+IXwZexHAM=;
 b=g22UCjy+OmiiioJPwdpcbkiVO9KBEbThxrxzMq17L6eFmtyR76HgATbTT7RVoaaxHw/UD++Vb6HxOxOfnNr428F8NWsrAo7K0nlh3XYW5HSph6at9qdjv6yF2u6uf5AtZWmL0OQU71yPOUptwQNv6+dqRkDTYrf4Sgke0B6LfV0d0YjsgmrC1oTpAQkhWPUppOccSTY8iof89mSxDyMvvouX03zgGRCptzFJ512acpNeYB3WJnwfQUuw74MZojkWtLSRuTt627tr+BJ23huunm/HBwcSBMh8yDgklZ+mx0J8olqlxngYGxo3WvqqA5/j1Ryxm1qxJ4Lz62QzK3x3gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnweBIAhzQMmvF6IodtQEHJo4LTWS5XMa+IXwZexHAM=;
 b=CJ014jvCFU81ec7A843N0Ei6CAX4U+xtT9TzLxdxFsmELbg1VqIyfeEDzcc061N0D6WSs26WAEbVucXw7WR3tueBTqnFHwuxs/+CpSYoBgFQ7hiaEW9jpCW++5qspGD7HeEPOPEqcRMrCM6mGQ9V+Gb5xaqgocn4+iWdeqAjV8o=
Authentication-Results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 04:03:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 04:03:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     satishkh@cisco.com, sebaddel@cisco.com, jejb@linux.ibm.com,
        kartilak@cisco.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.de
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
Date:   Tue, 24 Aug 2021 00:03:00 -0400
Message-Id: <162977310549.31461.5518262804247567380.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:a03:39e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 04:03:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fcc1d40-4af0-4b82-cf17-08d966b41701
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5529B19B10AD76E2BB6765678EC59@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UkFVxFs09o22gmMV2DMU8mOxQLmT2kyfHXAQ+2FpW0xf0uaOfFvFlx9Fe363ND/BE5tXAEVoLorZto9wIFBX3Whl3yYtaZ9WU2tAv5WRdokdzdYrBFjInHvYvzyD6SVMRHQyraFuIoezO41Lor+M3JJ/SN0BDeUbHiq+j3G94JMQkUgUd5BlC5ekdFgPz1go/gck3i5mjY8ZXbt/bBYVpIw3pA/50LZtMLjs4pD89suQmX4xFP09dg+7M7kl3iDpQNej8au+hx2XypdyEzdCBStznghvlIOPQkTBP2lWSyv7LAmjyS0+xcjOixZmn21GhHz9YZmn5bWpAbx8Zv6TYObPFe/E0GO85NVAfBHUUL1z0AfaAHNGTyEfXPRlyOMkbP3UhGtc8zxHGf9H8V491OUyFgk2gD6QqwLhU9nsdIZiX0A9Ow3e2KOQe6REKZqIHE7+AgdXm9H+FYhCskVGOBJxI/tKv2+CE/++Fzxu2OGfcYQwZSfECXuAPOWL8Xo26IQAmJ4lpgcMntkaIDJND9wygcKfQy85y+KP8NCLOzZ1esShPaShcZ3FgIpNIhI/k4W8z4FkvXnEKofjQakoJylCHXeuFigeTKkQAdJx8F9iWU29WyyN/mdhonzWjDJJRBqUf9A0VEjDHwVcFtOewZFpxgtFXZ0WCmgOGupXiC8gQOsSklQtym3ugWXwDgepSn87KP2V9BcqOHFWq7j/MYGm6nc7Ey9t+lTl8KFcb3xxEs6q5TGauFsaPaNQfd+fFTf7fz522oUCwtTcd4uVRj/rvJat+lnd06w2fmuc15k96IcTWu09xlyY6p2+dpuK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(26005)(5660300002)(4744005)(186003)(8936002)(966005)(38100700002)(6666004)(6486002)(7696005)(478600001)(4326008)(2616005)(956004)(66476007)(66946007)(52116002)(2906002)(66556008)(38350700002)(7416002)(36756003)(86362001)(8676002)(6916009)(316002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHlZaDA3K3ZlV3pmVTd2SWswYmJmKzdRQk5ER1FWc1FMb1RzbHhVYzVkbTl6?=
 =?utf-8?B?YXFPZkczWUtlZFdvSEVxbUFPYjRZUXY3K0lHYnlGMVhya2hrOFpBWnp3S0lN?=
 =?utf-8?B?SGdpT3dTRmdtUkxxVmhBYzZjZmVDTFJINTFsS0VBM3NCc09vR2JXQlc2aGhY?=
 =?utf-8?B?THNtVkhnQjU0UnByZ3BDOXhIWGcyQXZicEhvcVpFTEVhKzkvMmFWdnhUSVpY?=
 =?utf-8?B?SS9rYXdUQmNUeTB2ekViVHhiZFJtVG9EdlRuNTRycnpKQ0hnY291R24wenNF?=
 =?utf-8?B?Q2F1Qm11RTZhZU9la1BiU0R5MFNJa0Jock1KVFI3MDVZb1lyZ3FCSlA3a09H?=
 =?utf-8?B?ZkNuZTVZS3hCeDFmMFU5UWE0YjZVNTRzOXJyQUxKZTl3SEExcE5SMU9QZjU1?=
 =?utf-8?B?a3ZwZmlIUCtoVGZVY0hMMFMrREdvdXJ2UkZZaWxwdk9SalpUMnVvTnUwcURp?=
 =?utf-8?B?SVFXZVdzSy95OFBBL3hSQU9LaGIzVGhqaWxyaTdYMG8xRTg5amtLcWk2ME85?=
 =?utf-8?B?RjJXZ1BudzJEc3pxVDdZTFI1Mmt4N1FvWWZvMCtWL0FSZGt2THB2NXhnblB3?=
 =?utf-8?B?SXc0M0xVaENQWkwxQmllWTdKZzlpcFoyQkZIRGtabkNMRWhjWHZPTjFtc1RR?=
 =?utf-8?B?UXJJR0tmaU1zMm9TQ1UrK2IxTUVUb2ZZSFFXWlRkMlQxNkJrZ2xVb2l5aDds?=
 =?utf-8?B?RmhPRHo1MSt2dzgwM25vZW1ZVllCTnprV2lnRmQ1VEhZbll5ZmZqWmlXY0hr?=
 =?utf-8?B?dDBFMFNwUzBlQTV3MXpqU2VjZDBMTmtpTWZQUk9rZzVlK3R2cWh6VzVYdnl6?=
 =?utf-8?B?d1NqanJ5UzYwSVZyS0FSMjRjd1gzYlVidFB0MVZRbE1XKzJUak5RaFdyRVhO?=
 =?utf-8?B?VHRuMy9qUk1kbnFCVFJ3S2piSlZhNS9hY2JNU0pTZFF3c1dCZS9DcHpCeDFa?=
 =?utf-8?B?MTFrZVVGQzRpK3BCclhaa0pRWXVpajFYTWZWd0lOZEIzYjI3Wkl3cDVEMVRR?=
 =?utf-8?B?MnlaRGM4TkloRGhoRmVkbEtHWkNEZkpOSVBYWTNQcVJCd050QURQR0NyYzJG?=
 =?utf-8?B?anlUS2liWTk1Y2t4NFgrSWJWQjlHYUo3c0kzVm9pc3FpUkRpWnVjTHpNWlJn?=
 =?utf-8?B?SUV4S3ovVXdRdUhIazdSZWFXZTA0NjNpL21QYVZSTExTeExWc29oa3h5MmRv?=
 =?utf-8?B?K2VING8xZWJSVXh6d2FsNWowTC9mUVBJZGNTUVNpZnZZTlN5TGVjKzFjYXgx?=
 =?utf-8?B?NjBHRTU0SW5Sbi9WZUhMdzBwUkZMcHNZdzBuZW50cEs4TitLdUEwS0p4WnBj?=
 =?utf-8?B?OG9Tc2tZNjZKQmNPSkxvajlTNW1PNU9tZ3Z6VGduOHJDVnhlMHhZbUVEa3pq?=
 =?utf-8?B?OU9YbzVVTVBwZVJqam5jaUtMdTRhT2Vhb1hqSVR1Y1k0cEZOYnEyazF4TnRj?=
 =?utf-8?B?citQa3U2cEFNY1BmZlh2bkRFU0VpcExjemVZRXZvUFRnK25oM3NuNGNzUm93?=
 =?utf-8?B?bXZTT3RwRy9udWY1ZVpXRFkyZ1c4MzUwbDVIY2VXRHdoQzNVb2pPR3VFTkFk?=
 =?utf-8?B?Y1NqaDljakRrU0dmcmt5TVBQbnlyb3puMzN4YTVxYnhoSHpSejZSTklGaFRQ?=
 =?utf-8?B?YWIyUml4TkcwOVlad2phZXZxK1ZrZG5GQ0lCQlRybGdiL3pqRmdaT0xXV3lK?=
 =?utf-8?B?Ri80UzBua0dxYkx4ZUVsSDVnc0RNQmh4Lzk4RUtnTXM5b0pHUytqUWVFTWFx?=
 =?utf-8?Q?i3ETIzWVA+Cu4+O44nVykcCcls5qnPmtED8az4w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fcc1d40-4af0-4b82-cf17-08d966b41701
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 04:03:11.8325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95DSYpRCc6U8NWU9HDwMqP8HvE4cwooIJ7FL13vcJpAZ243yC0KQLe7BtoRgfGjT9xHfvWnDeGRgNSa6R22mlJFMnw5rkRAtDEKvffkkIc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240024
X-Proofpoint-GUID: 6JHgSkDkQEOQL7OFrjJZxfRJFzPMCZat
X-Proofpoint-ORIG-GUID: 6JHgSkDkQEOQL7OFrjJZxfRJFzPMCZat
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 13 Aug 2021 21:49:10 +0800, John Garry wrote:

> There is no need for scsi_cmnd.tag, so remove it.
> 
> Based on next-20210811
> 
> John Garry (3):
>   scsi: wd719: Stop using scsi_cmnd.tag
>   scsi: fnic: Stop setting scsi_cmnd.tag
>   scsi: Remove scsi_cmnd.tag
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/3] scsi: wd719: Stop using scsi_cmnd.tag
      https://git.kernel.org/mkp/scsi/c/e2a1dc571e19
[2/3] scsi: fnic: Stop setting scsi_cmnd.tag
      https://git.kernel.org/mkp/scsi/c/e0aebd25fdd9
[3/3] scsi: Remove scsi_cmnd.tag
      https://git.kernel.org/mkp/scsi/c/4c7b6ea336c1

-- 
Martin K. Petersen	Oracle Linux Engineering
