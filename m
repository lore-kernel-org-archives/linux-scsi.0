Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0389FC00528
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjHHCYo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjHHCYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:24:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5C61736;
        Mon,  7 Aug 2023 19:24:39 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781iTO3029912;
        Tue, 8 Aug 2023 02:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=twd2uaSHadD8CfHnW9wFKkgNAVhf4lEDK5xX0XzaVz0=;
 b=Wt5cyP6en7j50HX6Ca1j7exaLQCERnbzoJT9ufhYEvz9Rz7Dh3zdsBfh/x1ZLT5pL2nS
 +yjtDZ9M0terwjGxV4eS1TX24efXk1VvIyQkjkc8WeAXGkxEdVU8dOQnOLgL2RBkfw5O
 V9rYX/SmF7MOQw7GCsFfX4E/aiyj01Li/AMHKL6hQ3mse8rgmosBq2+KSdwOhKWPLCpu
 FdSVdggH8N2VLL0TNh/88nl8CKD3NQqHBTz6WnlMFWM02xd4inByTil1ttoC4UI2O3py
 GRWURM1b1htNroQy5T+GfWvJqFo0756rQjvkR04TlCHfkDvpdoDqCQAoTUvykNb66Xj7 Ag== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9cuem3yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:24:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377NBfHR021400;
        Tue, 8 Aug 2023 02:24:23 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvbwcue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:24:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+fhY4+J4VzhMPfE78NCIJ5U6QGoJNStaEjwRPqhByXwlghvt823L5ZBsJjRR+y/ozbrB7LTuAhnmIvFOpLU61JOn+bWnzYaKGd6ej3kxAhEQLuKHzgI2pIM5pX0sZt1KDCvWqWAsaGl6Pavxgf3d/0pjY/eLmk1yS27IjCyYXSgpr8NGNOsscr76fft99CQlGfShVr93oF8J90e6DVqajdaNLT8lH3JOosNi8Zd1aWXHBoG40LInAw8i7Wi9Iu1Te4rDnjAzoVOLSlDDiDY1c/bnXXvdgNSx2HC/6FMb3/SBomUScGnWWKtFSy7IP5tRM0amdKYdqgCvRPbO7rycA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twd2uaSHadD8CfHnW9wFKkgNAVhf4lEDK5xX0XzaVz0=;
 b=ZXcX968YUr9q/eb6R6I/NDiagd4X8BTMPSMzmubadmYJUuTNXOeXt/NpvMbCAXNmL2LJQF/f7icm+Y7NJ/oVd/ViCB4d6z4eogsSUtNGD22LR1P7qzdXIoleCQS9xE9tvSOlVcHFcJwzcrNhHcKu1NHsZNLP5FnpsZ/mTIYdqIGXGFG0xuH/Dzu8yfILQW52FjUCl2gV5SjsIhOPvyJUele80HyimeMhaSIVHnA/U/ZFenjCmFvI0USdGKybKzmzeNRKORf1f5Cn1tx0SSH60LOMDAnwyS0v4bJCLnw5zfPYfhBLdpBSgCr7z3tH8tau2RgmMZdsyLTTymVSUV1pVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twd2uaSHadD8CfHnW9wFKkgNAVhf4lEDK5xX0XzaVz0=;
 b=ZCm4uKQ8CLa5fGeP0Xmn7Y8QZ54CSCKCJ7C/sDqIKHHPtncafcp9SZOZuJjb9HxAvxJhmE+rnD3w+0JOCTeawS/U/AEFgOUS3HvoR97ga1Cw2rvJtCD62FsY4AV05q/waQN1rr+ehswCCKfb7TJ7+G9FzgjFfUgRGCMPYuo4avg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4336.namprd10.prod.outlook.com (2603:10b6:208:15f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Tue, 8 Aug
 2023 02:24:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 02:24:21 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v6 3/7] scsi: core: Retry unaligned zoned writes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1imjod1.fsf@ca-mkp.ca.oracle.com>
References: <20230804154821.3232094-1-bvanassche@acm.org>
        <20230804154821.3232094-4-bvanassche@acm.org>
Date:   Mon, 07 Aug 2023 22:24:19 -0400
In-Reply-To: <20230804154821.3232094-4-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 4 Aug 2023 08:48:01 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:a03:333::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4336:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a97d02-9190-4442-7680-08db97b69340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y7OcDt48SysUqJSSYAfN5MZ5J75tJcc5/1XTJ7JKsmkjsgWpLCorJMyXkBi3BbHAOYNzabbbNba28bwsD7IKyj5Tzok+cRG4447KpzCJ30ciU6JT9G5r4b+gD2HbyaTM1PC8KmGqeozGdGcbiUbqvUZWcsoWZLuI8awBWqStuVyIKPz591Wom+76pZwwG7zgkFBs2tyv2V+OBwWBGAkOM9iWQP6lhHctT7TG3IaQDSuSZ/q087jkJA+H6lgyLmE9fSBZZ3lGMqr4rbI2eRA3aDJEvWNpulMwgBr1RFcw352CW6tg1PpezZMxnEU+7JnzBE855EMsA71fLY5tocTrsQrAgODhg8TOUfN1iniNaNERiaFpjB2BJGiivqyX4CePeguMpTADZeTcPh7cNlWfqA5mWVB1tPTDte0TcDh8rwGUiEk6XdFj99fJ47U9egcQJvk7MLXRnslPxPQC6U8IkiTtCt5AN1Mli7IeeKr+EwEnyT19cwKUmFMlOcNnZDEc6HUwTrfG7pXs7hUsPce6OvRC3HHBGtVqj4lrzi0WHbZ57v36nrxg06Bu5KFE1yAjBAeJCeii7q16oKQoUydfZIoHno7maZF4d/Z6J6LOm92zGROM8iDevOuF5Rt8DHEM8jrAY9r92bnlNWMe/aqqaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(186006)(90011799007)(1800799003)(90021799007)(478600001)(6486002)(36916002)(6512007)(6916009)(66556008)(66476007)(66946007)(26005)(316002)(4326008)(54906003)(83380400001)(2906002)(5660300002)(86362001)(38100700002)(6506007)(41300700001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GGT04S1RuTXW9RQmlT82UehS4VhX2nKfQYee2EYRMJ21rJ0fdYI/GusOTSFC?=
 =?us-ascii?Q?aC2Nxp0ZxtZV7EvNVrUNH4xGGCDDiFNWftr8q3C9B6nJY2tcVbJnia2fZqfV?=
 =?us-ascii?Q?wJSmcoXy+tOop69+gSzN808au/ccYhyBqwy7xD571u+VQxCy+UpqUMxr2EPs?=
 =?us-ascii?Q?Pc5nU87fc6yCOQBHCfyQTFv9gkivao3hf6qh5kbECTjwlm/eIp3K1ybdjjGp?=
 =?us-ascii?Q?3GFoZkVRsTlrfzDfbQBWUCT9JxlnmiMSLXVwU/rMowZBRMNuCIxm4YTdy0mE?=
 =?us-ascii?Q?Eh14X5PAJOsHQHqlJEfiCcVp/B1vnkSOcEd3Lryu7bb/elm34pYutJf1ZDZI?=
 =?us-ascii?Q?iYX9Jv0jPRW8tKvaIpmw8dhgyZVUiLckJjF4s9bV3yTuCzk63xZhokXIcpmh?=
 =?us-ascii?Q?+xL8tA68EQ7iRDw5awuKas7nJRTAVPZI16F7FLOdbz5JheZ2V3JPI9kqUxml?=
 =?us-ascii?Q?bw4GI9jgJlt74sBU8CxmWGtp+95MZMpldZd488F/L3yQ6nnNc+/1LL7NrPlk?=
 =?us-ascii?Q?3unkw2uc2syRa54vyavE4JCP71qcejh86s2ajer3JSZqUNJyyc9L6i0qRJ4v?=
 =?us-ascii?Q?K5V9ztX/O2HvYNxjkQxZoFrSL/ZaV7WJPzqF33fYiEZU1e1W6bZELebX0bH8?=
 =?us-ascii?Q?/6mm34dRkROChkcc0MDoMuFFcqPqIkWUpSeMPFijq8vhSf5cxmcej/yf8TjJ?=
 =?us-ascii?Q?X0FF32ZGbMmvxXx4IrplUMjEzzBFCnhZeya4PgMLpHhp5PDU8Q+q2RWbgnk5?=
 =?us-ascii?Q?OKmQtzhpbo1nBF7dIKhvu8NLGfQPZXr45WPZkxOe8GUZUvVn+AH9xwEq7Toh?=
 =?us-ascii?Q?qyl61D1r6A/By4XNMUwfmj3oCdSB0HE11F0DWKf+rtXNDRCjCIegT26Wferk?=
 =?us-ascii?Q?MqQ0w7sqTzM9KnRsHyW0IqbyleCTutxQ4NgmoZLHKdJx6KuTIjmoQv3kTMu1?=
 =?us-ascii?Q?IoZgKrpxa8gI3mFp4B6PsaZvZX6M1m9bKJEelmDEp+sMvSXzwlUWWXfIo/5L?=
 =?us-ascii?Q?iDTgbP5fiGjWtlK1YYCJt3sR2l4ttdeyS6Srr+nA2CDMxtEYzEuA6eCuJ8Qu?=
 =?us-ascii?Q?fTIUyA9143Zz3O8377DI3Tyd1LCFqcbtbYvjQCC04HeDch86USjsnTD+vk8y?=
 =?us-ascii?Q?j/mxs8SeZpSYs12iSHHJGvVdisO31Wnr2lgasmqtYM3Wi/70rKOA22JY+ycw?=
 =?us-ascii?Q?QafmUlIon/OmiA4gk4c4fKhaDZ4s01steH+75eqdI2pY/zLgcvVFBHwrR5o7?=
 =?us-ascii?Q?DKn+IbEjcOCYUX/bziI7aVXs4RChazlQ3Ws+sXA9xAy2Pd0eMQM3UwlYIqDN?=
 =?us-ascii?Q?mCqwTl7RjifR0apo/FoCIBDkytmIfoNXYWjVCvWtQ9YJX/CdD4/V8S9hMSp9?=
 =?us-ascii?Q?u8YwlLJG1byo7Yo+MP42y3KRtR5nf/5m1DWErgwBigfo0rBzjndgQEpFbTbV?=
 =?us-ascii?Q?Oqyhllwq168nWfMRWAjqu3pKHb5AIl8TQVWOWxBuIddG1hH6o/q78g8wGLlc?=
 =?us-ascii?Q?5G7hqcSAFqKi9m2w7kJULVM7exQBhVaI4NIE+qpM2FcGTGA8PBdi654GDEIC?=
 =?us-ascii?Q?/EiVP4/a/MMR6Esh/oFGujiBNB5eP+gVBXE73vXmsLoXnK96FwP512Br8d0Q?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aE0+TToKuCXCG7RuNCdiHvpjxtfRmA+Cenc/bitZq5AZwyDLE6ImhfDV5jczgJ5fSXBQ+ew3OgnllHQ0bttzXYKSFn43foj3eiiYGov12qj25gq6pxxUQ9sYU4oQA0mGlidegwLlNQsuth/0GQaJqm5V6w61uCgMsqVZ2+o9dxcupPR2eGMB8sEY9Qtwv/rdEpLxA/mFMEHRVDWtMwvLSr/FXM8xOpU32XdMo44CpXN0IaYkVHqv3I24efmTolgXQ1l1fb3Mmph2pmTQF4gIGdEh/N/hYsDgTbFIV+fQVYnX8OVPyJZQreyfE4AEp4JTmWaPrNSu5tFlJRn1Rjo5J6hN1fg96u7VFIcHBtGS8JsjWgpODZ6vvpjy/VpzhGvVm9qT/3v/KLl2J8vATFPt96iJQbDWu1SydYS4nAgMlP08E4GtO4koT63Bxk9Mf5jwJehCD5ucxlcjzfKZYUlUdKeeEJV0ZbHYaw9n1vvZfg3OGsH/CsfmnN4DvsZjlN0lu0MXtKJNuY2kYI9EFUAxnYDb+nsaTpRN+qtvJ7hv9tVzW9YaGEOfqM7RFXb7qy96yf17ZbmUr9xb0LiB1RYYGGxB3GYvHhrjTQlzZFIQjFlCPDFfxRM/A0RkcPZ64wv7nDSOGyoOsCcx1xLsenb6PC2xn0okNtlHBKZWynzzPfh4K8F+M7MLF2tDJ/k7G2D4xz2foU0ggXKWan/49whm/8A3CGmD7K5T2FqGFkT8gNOaE0hJcy4+Q4YPtfkaMMLjQKwXiwH7Q5s+xoonyiOPk+wmyiV1k444kKOvXfIdCfRkydv76DrpptqMnlMBvobjpwvaHpT80r0gx9kZKVYLbNCpVgTp6kBCQgh4sEmPcjs33aNOP3INqj7QGYc03TRTiQFqBCvWUi+RQaCwQVGjLf1BZA0Wv9pAsYoYakZ4kxI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a97d02-9190-4442-7680-08db97b69340
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 02:24:21.4619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbSMOJc4LM23danFj8vLQWc/3lH1BSEiOMKLi25WNTGKBZ7q9odk96eN4M7Gm5GKUKlGuNqtHHp4vVUkgL+ckH7s2UCC2axDU3AJmZ5aBB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4336
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=618 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308080020
X-Proofpoint-ORIG-GUID: q3iodwBqy8CWMspy29eZEmXJEha9iarN
X-Proofpoint-GUID: q3iodwBqy8CWMspy29eZEmXJEha9iarN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Bart!

> If zoned writes (REQ_OP_WRITE) for a sequential write required zone
> have a starting LBA that differs from the write pointer, e.g. because
> zoned writes have been reordered, then the storage device will respond
> with an UNALIGNED WRITE COMMAND error. Send commands that failed with
> an unaligned write error to the SCSI error handler if zone write
> locking is disabled. Let the SCSI error handler sort SCSI commands per
> LBA before resubmitting these.
>
> If zone write locking is disabled, increase the number of retries for
> write commands sent to a sequential zone to the maximum number of
> outstanding commands because in the worst case the number of times
> reordered zoned writes have to be retried is (number of outstanding
> writes per sequential zone) - 1.

I am afraid that I find falling back to rely on the error handler pretty
kludgy. It seems like there would be a more straightforward way ensure
that request ordering is preserved for devices that are known not to
reorder internally.

I probably missed the finer details of what was discussed while I was
away. But why can't we address the specific corner cases that cause the
unexpected reordering at the block layer? Sorting requests in the SCSI
error handler after a reported failure just seems like papering over the
fact that there's a problem elsewhere.

-- 
Martin K. Petersen	Oracle Linux Engineering
