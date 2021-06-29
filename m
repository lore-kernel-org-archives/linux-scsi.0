Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77D8C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B7D361CFC
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbhF2U5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:57:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25858 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235520AbhF2U47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 16:56:59 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TKbX0n023457;
        Tue, 29 Jun 2021 20:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IFFFIVtpi1FRE7bwVo6ZNXZOGGftKzGKcHqVEIb+Vtc=;
 b=my4z9wfrHUZGF9mmLESZ4CUfPY5IJrCmmhLX4JWJPTnoMmp8N18cK2cagrsNqOm/K7qL
 UP3m27Ao0+QBmoPGCquQOJpSXey2oOfz/Ir45DoMLjXXlXq5ZqCWHDzxIOOHDte2tGPf
 efaj8twF2XeA2MXOll/wjq7Nqd6HLH7MF/jVe/C7b4qxPcxvAdhKORKManaoH5P1RxHk
 oHleJRYmvKBj5TRKw0wsN6jjfqyy6iK7vJDjG3EHE116wwFRUO3hW9nAGLkXY/nDV7g7
 aUocvecQHAVS8KqpfH8n1YIp127yHVj+eHylfT29JkME7pKDUIaH3uD6IjG5k/mkXWvi 1A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f1hcmwwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 20:54:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TKZfIk094983;
        Tue, 29 Jun 2021 20:54:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 39dsbyrmth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 20:54:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dja6gtUxqHLCjWfcyYwF0ObxiBQqNbZXpLzmUyNqU/q5vneKF8bwlgPRlecM2Il1GRkHU6b0P+8k37BWBplKclKCGeKgxw0p5opgrvGWg0Ddv/wgrzbnUNLXOFuyVTBW80MzWyqQAjW3n1zWKE2zQGyAr1RE2U+JaRDS0ItYsezugymofexxO0dObWxHSo7oHnddawlZ5d8ZrUX2/D1YON3/8ahQk5q5Zf+mkER23VEtEaf72VNAO6kMcmIh0lmXDkqXx886/xTIcdV5sU5a/9ksLvl6zKLRLJWmT59MLsTrJkWiQ8XDI9ToBAIelCUcL2ibb7Tko/lir1C2vU3WSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFFFIVtpi1FRE7bwVo6ZNXZOGGftKzGKcHqVEIb+Vtc=;
 b=lgvC9S1lOgmA/EqyDDoquKjAP68GavMFSPT16V3UnHZBhfGuEyzswFVWUiq8xPDgO1PhIJNon0gtDIGh3aNSWDtwvpkyo0KD2k+Z7FRi4RqFAf2kUKGEj0TQwpVCjlSGb4JGWJo92qTGxLJ3I+S7IiXOLyNI/FLvzRAdPC+O46yCNRh5EDldOqBKEyswytpZbxPw+XmGq0ui2WtZRKOMMgkf+BIhkMHS/0nj9uliKZEz3r6wW0PDhonGbe5W5HuNg2TrHfUzr/730VBk2xMWABE5/GIbY3sL+Ubsn+2QlidEUF3DO0Qx7Sprs0qrNEQmd5gT1hRbnqtrlqo8ccyorA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFFFIVtpi1FRE7bwVo6ZNXZOGGftKzGKcHqVEIb+Vtc=;
 b=KrAy7ReIpKjFp7O1O687X5l6xXHTR+r+voJ3TkVu7TrLMmIYaI1TeEOyiG8OTMvZdRUMBN5uY5oLNIx79IVOWiXKkduEizS7Ho4XNxyGqF1jwGVf5yGASGAvzQWlIquyNtf7iWzbUTCmfJC2KnydOiBxmbjtsOtN0gNstR5pc4g=
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Tue, 29 Jun
 2021 20:54:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 20:54:22 +0000
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] virtio_scsi: Add validation for residual bytes from
 response
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmw4ie8a.fsf@ca-mkp.ca.oracle.com>
References: <20210615105218.214-1-xieyongji@bytedance.com>
Date:   Tue, 29 Jun 2021 16:54:19 -0400
In-Reply-To: <20210615105218.214-1-xieyongji@bytedance.com> (Xie Yongji's
        message of "Tue, 15 Jun 2021 18:52:18 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:806:a7::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0015.namprd10.prod.outlook.com (2603:10b6:806:a7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Tue, 29 Jun 2021 20:54:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 333b4ee8-8807-48bd-bb27-08d93b401282
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB552957302F5B54C5DFA14F3B8E029@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rb3JeUnxaDsXh2YcrcbLZOYCFsdURTa3lUprKpCFw4aMuZQpV939OewIYuGVohotSYw9p7GdWatQyzPy9+21uK1M5yzVN/DAuhvbWCMimwEMBK1WGny3Cymdy9RIvwxKD8ly4EgOWZCrzBLD3mLQ0SOxcKuteLQAF7gWFm2TEhOM7eQlK8J7IyMOOHVomebrtt8249LyV26PaXVpUOEkhnISGqa6arNO66ElT6wN9VzEw0k1hzN6z1fzFk5y/YnrEJHjQw2w1hTxvDMtRhe9Hm66usGc75hhbSnmu4B1D//8WsaqFT+Rt2g5I8YZhcRzhqaY42FPa/nZARUvlwoSSU9aifHlWlsO46CCWGWlRNV5dCnSL70XqJmaB1HtrTiPOnLyP/ynN1GvkfzNj/HGERcK0sbDztCeEixRiOfFj2FCZMtk0O9UM45+Kc+7hrgGWx4bjRb6FakAShh7u9e41HuU6UTm4PErjL3jXqPTFjp38CVFc1welG8TyWFeq7WHXrdvgsMsZHLsyGbbCM1pOqH9T4P2Y/+gxvoEwOfbCeRXPNqEYdpQzLZi3+TU4yAxqCqwuFjrZyiKeqOOemZidQlJbPVBZnU9awPzF9hswL1UtIiyxpP1Ve7n0iyP1mW7MfCJQ9zaSsHcK6XxBTr6bxIc+vuKhLru800v2S15O1N0NWzeFdE1ZWbHzP4BZWfKeTKp1FLB3Y+4AlabVCA4yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39860400002)(346002)(366004)(6916009)(186003)(38350700002)(38100700002)(16526019)(55016002)(86362001)(5660300002)(26005)(478600001)(956004)(8676002)(316002)(558084003)(2906002)(4326008)(36916002)(66946007)(52116002)(7696005)(83380400001)(8936002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J5IzFiQ4aCborymYsf44+C8qNmcI9Ra8vTeyyJPAdW6CbEZSqmhIEyBCSXQG?=
 =?us-ascii?Q?4/B8aITSFseoMubhxSrJAh8iCBADqGQEejsv7h3C71SYIMQCvFHi8zBpF2DH?=
 =?us-ascii?Q?FX2NSinTkOEBE4ysnntwvVwxL6yw+biTyPg8J7HyGHLzSEFvsWddzrh+L8uq?=
 =?us-ascii?Q?BvNtvnVBWpL72PZSiE0DC4kWy+8Yrz3cfiF1iw5Bbs/iBVgEjkXTG1awbQk5?=
 =?us-ascii?Q?01yqSdBszEPtZjQ5M4TNROPuQYm7igVGAzzxG4JKLKrtI8cL7BFA10yixhRm?=
 =?us-ascii?Q?ds9xf9vCkGLaVxS80Tt2O7okmHrYn4HdNcM0zt8zYlz2UL8whEsHbabjOPpR?=
 =?us-ascii?Q?EWzxcH3DAaQUAj1k2qPVJTcZsgAV4PV8OEHegQPg8Bq2XD57EdrEIYrku8y7?=
 =?us-ascii?Q?B+46UvSETMLFMfaGzZXzgORoi6taM1pFt7sixv1/eUHqgToB5px+ned1RbfW?=
 =?us-ascii?Q?1vfFRVFO2qsUuD5iDKEJG/pARPnMs7FW2/g0ZyQiP2uNiCqV5OhEjO9BNr2Q?=
 =?us-ascii?Q?hZnTVxNgamWnOJFRXHdDkQRsVFpXsncWUhQYQpNzIRgfWdT1qzn56737GJ3d?=
 =?us-ascii?Q?aUuT0G5RWEAUlxNktmRX8IOKwss2kVxOHGjpL+siOfsfbJ4LM9yGvlEg2c7y?=
 =?us-ascii?Q?oS43W3kdat87fZlwSk+2NzyWsdtd6b0jqfgWSANuQKcdxTl+cYu+v38H7UlE?=
 =?us-ascii?Q?wSlJ6wWhl2KrpzcqbPYCqQ+xFqYWSTTqZIode3/FnxAWj51+/ji9wh8yJ2fI?=
 =?us-ascii?Q?3jVYhGQdDUAq1a7YH9URG+hz1u+aBrmNSivBS2A/GL84du9qtHKHUzoD5vrn?=
 =?us-ascii?Q?f6mqiNs37dPcmSlqzBPTCUmxQcYh3bPacJWqS/TYOwoFNFNXtyb11381oTkd?=
 =?us-ascii?Q?bV/LCtBwL0jpjF2lnYhom3ybkFRSwZITvxMwvdoxEWsV7MJQHIqt2+f4KWr0?=
 =?us-ascii?Q?fc5HoQOmONFtn/ugB8d3mlnhfAVnnQgs1HpDK+0lhd1l9ZiIchFsfOHD/cT5?=
 =?us-ascii?Q?9831tPPrwvP2cN/9+cvs9RMj9yt2NzWTHMtpDtMp7R0pPbTnqp9+6DEQRF1+?=
 =?us-ascii?Q?V9G9COUhgkcF4ufIFRYWgI6wL3XAryDbzwTPDSkSxwzNXpZe6ODTi85DSux9?=
 =?us-ascii?Q?qj7qcj26Pl9F7D3qIJneOrnvagiUnUCn6m+ECt8/o/1rrtM17BB0MZwzpvdw?=
 =?us-ascii?Q?tUN0OsX9AnGRwvN2Zsljjj9kKNcKHNFq/5Iel9L93n7s34WzieiSYxiYE266?=
 =?us-ascii?Q?sS+miXQl4DOvkACYdQ6yw7Qzd6pqIR13qhnraZNemW7ziATg/F8s3iw+21t5?=
 =?us-ascii?Q?tVmQNgtK2L4QRlkCmgrsI7tN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 333b4ee8-8807-48bd-bb27-08d93b401282
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 20:54:22.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rIBkez8JEyIsAE0T6/zFzVlf087cL2v7zqptvucRDJglMiycdeRg7AC9zCSwHz0uk5JLH/ezBUY9O1V+i0KfnQSgPWo/nndJLOLZaTNmj1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10030 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290128
X-Proofpoint-ORIG-GUID: p497pSlq56-3NLj506XqiFruJNRDqWst
X-Proofpoint-GUID: p497pSlq56-3NLj506XqiFruJNRDqWst
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Xie,

> This ensures that the residual bytes in response (might come
> from an untrusted device) will not exceed the data buffer length.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
