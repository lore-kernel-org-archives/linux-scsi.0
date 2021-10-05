Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6FDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE8C61507
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhJEEfP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:35:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65064 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhJEEfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:35:14 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19531d1b019258;
        Tue, 5 Oct 2021 04:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cJzL70nu9oKedtWCqmXRWyNg/rFRDpQt9/+/rTYx6kA=;
 b=Su+gPlKNMQ4PoqEoA9e63eV5fTNph7wYvOk5wxaDDmhVeGoxA+hqkFP3w8wWk/LqSXrE
 DFd6R96vbitfJ8nVnOW4sBtgRbxEqugXxhc9NN8IG+n7v61e/DC91U+vISZzaid4Tgjd
 uEtqn+VquI5CR18lzga1vNo91e3KCfpptqemvIRCKInZoeEaS8Q/CXa1APYoEXVFV5to
 zCrOcxPNMX7+fcEbueOHD9SNPauu77Jdm8u9TV3t0emCkqJYARfBDEmOtAEK5DePFspA
 gYSiTKqbliDW61moBCNK5hG0BacmKytKSYZ1gkzsAW/wN/pX5Z0Glx/YHLZCXD9HANsu wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3p5cwvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UdVM029861;
        Tue, 5 Oct 2021 04:33:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3020.oracle.com with ESMTP id 3bf16se2c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlfCNEX0rcfjH1fs4snTgsNf2T3pJJ6RND8uYjJZqYPv//wj/zNqZJF148U3d9/+hFvG12gKWReeckQRlwyFPDLNSWpHKrd73Fd6gwoypec44ihKEKK8jSxhQu5OghGkG50x/67XrwMVonwwLZGpfdCJpQbL3sgc472P4G78qYWxpamcarqTpIqiKXDffwwLbD4/bQIlO7vWuf4s6eStYPuIVyhKWxiRkM2KPM762u/QTysK387XAvEGcMefGxRx9kbVLg95thgJ6scD0eOdyR9lMnQwPKz9bssVmNIwHwrm3+6F9xHEjGR7xlG853NtQWw1ou9f8CAe0TnFs0mAoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJzL70nu9oKedtWCqmXRWyNg/rFRDpQt9/+/rTYx6kA=;
 b=jEwCmp+Cu++s8CHL8i9nxoY/0kzt0mUcgZHWF3/MvzLCupTzf0YQkeUh4lPI+xG7Lcfl5d1e0TekcqE5viyWryU56lwUuygW/xRJbEz0dIiOuyE0UWKfFk6x5iRe1omf4bFWDW39RsloOYefuAMUibCqfkdQekK7tlHK4vL2suQE4mL6iOYDU+ELJB8RRzxTSaYnjkIUVzKX04qyNci5ostvdNn4sS+7vApzmuhvkulyrFhOWwvi7wrZv4DA9DBlOmxhgbN0kLQRCxZtapztMD6fgoIJQnYWuICtZ/KSLcxmLieGObrFqnsnjy/K0uocNfRZDX8XFtMDOpIm1ACI1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJzL70nu9oKedtWCqmXRWyNg/rFRDpQt9/+/rTYx6kA=;
 b=bYNj1e6mMhljTHhy8yF4KwMO0LOtpCYMKFyyleEZXCPpctNoH/WVEt0kFh65oKbTaHu/NQOW91pC3OC7FfYPklvOpn4mHrp2NEU+PTM2vUbj7wO6ipBBie5hi0p/xUJ2t971hkcxcwZ81MGEk1Ag5iZ3kM6BHBGk9nASx5HeZR4=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR1001MB2320.namprd10.prod.outlook.com (2603:10b6:301:2e::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 04:33:14 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:33:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        linux-scsi@vger.kernel.org, cleech@redhat.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: iscsi: Fix iscsi_task use after free
Date:   Tue,  5 Oct 2021 00:33:03 -0400
Message-Id: <163340836501.12017.10039537382537270541.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211004210608.9962-1-michael.christie@oracle.com>
References: <20211004210608.9962-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0096.namprd05.prod.outlook.com
 (2603:10b6:803:22::34) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0096.namprd05.prod.outlook.com (2603:10b6:803:22::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Tue, 5 Oct 2021 04:33:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a7c0154-b3a5-4c5f-3362-08d987b93eb4
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2320B58C67B5B82D350319DE8EAF9@MWHPR1001MB2320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jK2y35nIS9FETadqwPwNEoOp7NOkDZXM7ZPHbuELcYwaXIE9dOlzgHM0akuwjvknWyckKwMM0kW+LdsQ2KLjTNrsLa0r5krE9RbvH3FJH16tayijzQrwoaUmsML1og3P3E32Hor+Qna3tLrycmmGy8woGncnp5nNVzO5Tweq4C8RKMfrk3jC1g9wfUvoYtxUYWSxmi8SdMkXan415X2foDR4LKZ3gWRzlfF1o0lAqr7ZyWXpaPlrMvoh6LiAPX2ssIh/0gkvL8zp9qd4Qs49laJBWLnjWOl/tzOE1WRqglMlTDbibPX+rbw+SIXpjPXYa2i5VZvsO+lZpEZV/F6PRf+2MurrsEh10bWEQLY0zEwC4FcEZ2CUBxEfUcf4/FnISEg8WeXpbWnM34bonJiJeP62sMcJ/rOp1b2DplgwtIn78Q4YKmudaJvnjE95H257712phzGt3WqIOqF7nZPcI7J2nz7LY4w8mnHhL/hrDt7lC17bAS+FIgn62CLUETWy8Epa8Tb7qRW3AtyaB4rmAxn6I7pKHu77KwPYS7QfVYeoV9QrspwZQefA2QcPq0L70CRG/c/v7/78XED2uRwXm9b3AJqScLqoi4SSyDs4SO9RpDcY2uzPMEpbfJ1vduH4gFZKEzTIolYD2GjmOAq8+Z+j7H1iqKOkDg1Do2CkTzJ3KvT2Z3lZ99Ofof5RYDSK5TK2uQcZB0TKonsjHoUssTH+mTsvh3eFdcOsA4oo3eeETI9S8z+OCSrmULjncBKy2L4yeZ6FZlhy0qgCgk5lsvXO2JpN0Bl6GVfQv8NudjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(956004)(966005)(2616005)(83380400001)(2906002)(4744005)(6666004)(5660300002)(107886003)(38350700002)(8936002)(38100700002)(7696005)(36756003)(66476007)(52116002)(508600001)(66946007)(186003)(103116003)(4326008)(86362001)(6486002)(316002)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zi9FSkJtZkVBT0ZzczAvUjdreHV1V0lrVWlScEY3amZtbTh0T0FrclJucmJB?=
 =?utf-8?B?ZEc1T0ltbUtua3JTcUsxbVZmTUJUWStTUDlZZFRWa2tRT0VPWDBIQjYvaEcz?=
 =?utf-8?B?ME5vSE5mU1VGT1haZW1qZjBMYmNxT2hybGdwQm1ldjQyd2Zvcjdtc0krT2hH?=
 =?utf-8?B?TFhLMUF5VGRyZ25BRi9iUERTYWNrWUZxWWVTZFpVeVpib29YMS9hdGJQVFRS?=
 =?utf-8?B?SUx3ZEx6M1hISFMvekdoUlBWcjhnY05FT29nUU9NQThHVk9PUHVydUY3VStW?=
 =?utf-8?B?dzRuaW9CdVNQbVVyRnZmTnZLRFlUaktmY3hXQ3VDMk8zZWlqNUgvaDl1N2ZQ?=
 =?utf-8?B?aEt5MlBqeHpFMXEyRm9QdGQwQ2dEQU5iNUFCcXlTeUxnSzNlSkxLN0dacFNF?=
 =?utf-8?B?YkdHS0RDUVhhVjFpMVN6UlBEQ3Q3dHRuK0RrRkkxcHhpUmxCZGNkM21RUzhX?=
 =?utf-8?B?N2VPY3ZJTkU4Zjl2Um44c2RkbDV1cHlWUGxzSEo4MmJ3cEozdjR2MlpidDZP?=
 =?utf-8?B?OVpmR3VIMlFKQlZPaW11OEttQ1dKVVBXNXRMT0ovd0oxMGFNeTBJTkhrREVu?=
 =?utf-8?B?ZnBpNWlDd1JkeGNLM2d0bGxpQVNtMjNKUEMvcEJ4WGZRL2xXTzUybVRPWmZQ?=
 =?utf-8?B?MmVabXVBSUF5cm4ybEd0eG14N1hPZjRxQWVFbUppQ3V5V2Q2ay9zRUdSME43?=
 =?utf-8?B?Q0lrYWM1TXVqVHBLREdrSFZGVmFHeDNuZ2twWFpubTgyQWxPWS9GUEJTR29Y?=
 =?utf-8?B?UGhlczV1ZThkM3A0Q2VTcXRRLzVVdXZzcVZJK0lvNVZYMUdxSUVBbm0vMGh3?=
 =?utf-8?B?dThFdVlHMTlLMnZTTUJnRXpJY0dTdzI2WWZ1UVB2blQvWlBKb3FxYTlwVExi?=
 =?utf-8?B?UGlmVjVJdktFZlRXaWdZeUJKRDlJSUx6TGl1MzFyUzFKOENuZDRJUFlJNVpT?=
 =?utf-8?B?Q20yMmRZOWtBekdrMjVUbWk3K1R5eExBM3FNSjlWSHpxeWpad2ZzMUV5UUFY?=
 =?utf-8?B?aHF3R3grOGI1Q2Z2NFFkckpwV2tmMlNwaXh3dVBxUHJmbHJzQmVnbC9TTEQ2?=
 =?utf-8?B?MGIyaTZzbmRSeGJBL08zbWRWMUhYbUYxZE1oSmpRK3Zoa2FCUFE3eDNRdkJT?=
 =?utf-8?B?bGF0OEpIUTFhaElScW1jcno4bWZmWVdLZ1RUUTNkYXF3azI0LzNmU2VHeDBh?=
 =?utf-8?B?SjBPcTBhaWtDM0VHb1M1eTlNOFlQSlJzUndteFJqMy9iVzdra0gvcWVScUt0?=
 =?utf-8?B?R2hHeE5Ebk1HUkc3dmRtUFJyaGwzS2NuWWYyRGdDNHcxbWxHc0pxVVV1OVZs?=
 =?utf-8?B?OVV5QlNhOXFjTmJDYnNqcnNjWHNKTDY0VFBMWWV6TlhmYVpTTEthVjF2d0tw?=
 =?utf-8?B?aEowcVFmaXloNUJ6cmcvVHFjUnY5YW9TMVFUNm1WQ3FDNlZrQWFlNFpHVlM1?=
 =?utf-8?B?Mmp6TGdqeU5TZnlDZTZFb0Y4SjBETnhNTGNpNGg1VURIVU91dXZPT3pDVEZF?=
 =?utf-8?B?amVXd0hVMzdrenJEV2NJZENsejc3eFpYN2pBTVJNckxuRndFbjJsMjFuMGpj?=
 =?utf-8?B?TGVwTnNxYkdHc3RmM2tBWGJFQjM0VzB4WU03OXZWcTJZd1ZVbzgzaTZwelZs?=
 =?utf-8?B?NVBuVDdoVEZyTktCWTZYdHdzRWcvTVdvMVhGZmZJaVhDOXRnYTBoaEZXc2JU?=
 =?utf-8?B?VEgzSzRJV2ozSWM1c1dYUVU0OTVjL2Qvdmh1Q3hCMStGVzBHMGVBMUFQKzhD?=
 =?utf-8?Q?DGPDgkf/v3C0M3KZJruNYlJXr6HQaQ0aEQxa+bT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7c0154-b3a5-4c5f-3362-08d987b93eb4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:33:14.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoebYiULS8BxrU8+WoTHZ1V4MZ9i0xuo5bS0Snvu1ag5Yg4aXQoBXBi2iEly+qJTVuyoC/rfkHTNLOhLAlmpewcpTmlk3+gkk0c0tmELra0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2320
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=516 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050025
X-Proofpoint-ORIG-GUID: uf205G-cq1Tz0oARnJBUoqLiD-jbulNO
X-Proofpoint-GUID: uf205G-cq1Tz0oARnJBUoqLiD-jbulNO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 4 Oct 2021 16:06:08 -0500, Mike Christie wrote:

> The patch:
> 
> d39df158518c ("scsi: iscsi: Have abort handler get ref to conn")
> 
> added iscsi_get_conn/iscsi_put_conn calls during abort handling but then
> also changed the handling of the case where we detect an already completed
> task where we now end up doing a goto to the common put/cleanup code. This
> results in a iscsi_task use after free, because the common cleanup code
> will do a put on the iscsi_task.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: iscsi: Fix iscsi_task use after free
      https://git.kernel.org/mkp/scsi/c/258aad75c621

-- 
Martin K. Petersen	Oracle Linux Engineering
