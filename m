Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9070C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8E161167
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhJ1Ddg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 23:33:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16944 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhJ1Ddd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 23:33:33 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19S1A9fB021028;
        Thu, 28 Oct 2021 03:31:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=g0/qzPx4TEVKE7UOCsy4O7nXO79IJvmPnFa+hom7kKU=;
 b=WxmGM5j9ADkpqirHWySvk/iXsqgNzXCIXXJuM45xdy+lJFbO3wPmYUq2otSuFt/XcX3v
 Y9gx3YOjXJcWFWoA1skZGgqzZZaUehsc3sr1GOLWvxF7RBmGF1VPh0GamV/qm82UDYpE
 1lFwWaO/yzBGZyUGYbQPcrpUVIuRzT0UwhUy+M2J0GxP3vWwzBoari3zhLg+uFAFKeL9
 TOE9FEumH5ntuwlc2fG78I9uBM4H+CsqS04KVTvCJWztJoqfLNrCvJvwCWDPkZwpX3oz
 yk0c6XiFSNI4bPhNSqV61qiuzd8hTl8Shfk3tgXQBbPyQtPmt6q1NPivXMREeTj8EsGC NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byhy9g944-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:31:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19S3FaDB149038;
        Thu, 28 Oct 2021 03:31:05 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3020.oracle.com with ESMTP id 3bx4gdp73n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:31:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu8miAzmes3yQR0Bs2WuH7TNyO0Td3vsNOpcLb2zeCH4WLloBNSqRSMCGHbicZ05wqIQoTQlokRMgWN8v3HErh200HRQv0DW0ktozGIPQ+vwBMX4QLX93u7PeLM1PBUClQi/JajGjXfwcNbHl7QQE6QSB74/PbVFi5hNyKfZJVurN947ecclWAXbXxzQ5QYTC4ERCAmSQT6S0XThw6T+OY6QjDomg9i9lowAnnmFu1dD1MVVS1pdjJKhA3IjfB9OOnAzxzQ3bJaLcUumyvXBnWerVgp8rTOgbFWFRLsv4AFy6Z+YKnAK4cMFd0boaWcTNGvemsExSR4zpO+fL7XvHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0/qzPx4TEVKE7UOCsy4O7nXO79IJvmPnFa+hom7kKU=;
 b=X0OfLQFXGqks3wWlaUDWZrkhdwBW1aURHRALhjJS0PNpU80UMHl+mJIA4nZXmltnVs632m7RWwkSTzl07BBoL2eGr/OCjxfBTf2sIzCSyPIOowy+3Hv4+2CIuPVapZHqzFoW1GePwTQVeQR820uGsJpqhBD7r5N4/8KifbD6ag8G1fsZIzOw95dUwPip//Xj+3vkFRjm8vcaOQc45HrMP2BYwwo+fmsO0pCb4YU2OHBm9AmcbvwdblhzWjQ05XZ470RssM/7mOleYpFBQ+9Uxlsbw9kddfFX6wwysTHVoebEhDbrotud6UonAS4M/r+jSlD1hUuohKPnpSsdYbG1Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0/qzPx4TEVKE7UOCsy4O7nXO79IJvmPnFa+hom7kKU=;
 b=zhmDl0KOZ124JGFaGNMrc20TwCLqZxETVZUCeJPD8V2O0bh+wq9TAqgxD8GUQOi1VibaWm/byQHdaDKiQROMR2PwpcGr/p0qUQVCxak4Rn1Rde2PfJsSOv2hCgjLGlkuAFJTrqBHNgls82Gd7APdj8cJ38ZBgV+zePKfoCXbrRE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5467.namprd10.prod.outlook.com (2603:10b6:510:d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 03:31:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 03:31:03 +0000
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: core: simplify control flow in
 scmd_eh_abort_handler
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtmtygg2.fsf@ca-mkp.ca.oracle.com>
References: <20211025143952.17128-1-emilne@redhat.com>
        <20211025143952.17128-3-emilne@redhat.com>
Date:   Wed, 27 Oct 2021 23:31:01 -0400
In-Reply-To: <20211025143952.17128-3-emilne@redhat.com> (Ewan D. Milne's
        message of "Mon, 25 Oct 2021 10:39:52 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0022.namprd06.prod.outlook.com
 (2603:10b6:803:2f::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by SN4PR0601CA0022.namprd06.prod.outlook.com (2603:10b6:803:2f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 03:31:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b5c98b4-ff70-409d-460a-08d999c35ea2
X-MS-TrafficTypeDiagnostic: PH0PR10MB5467:
X-Microsoft-Antispam-PRVS: <PH0PR10MB546740F2023CA4129E7DBEA68E869@PH0PR10MB5467.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zusfO3dO1pS60nSzfnd74Xd+ifAH+GxGxSixq0u3vc+JS0JygeYS2GYqTB3HtmmgiIxnDyq33pyjxvAH9YIvl/CAPZ1pvDnFkbwtfuCGx7F+SChHph3CiiGOwwzkpdnos7JOff8v6YSyuZ+jcF6WK9tgqSF9gRH7ZXQcMnLKSmDosfBm13rNaAVgrWhFM/mCWGkgdfSgoeR0hlRMNiqHyQVun/jm9iZros3NqWJQyj54W/yIxJj6Op2iuLvj/wQzhH434fgU4MWqS8Dv5VUtiLHKzxiX+QQSP4SekGdMudkyrqhLTwy2OlITuDcuzUB7q/qtSyjTYAwUvOZOCWrrX03P/CzfjtLOoD6SW3GqeCBm86XKZz4g7OdGDUziiRApLZRJfIj1ttSNxjiMDmf1B0VBGHk4DMsnCFF3HYIj7dPEz/qZJOFNVivkEYOZMAS5vGEHhxmETTQiebmRg+0vHjWCH4nYcV7CcdhJgftelnjEvc3WFLQMvcenBAKnZ9TVFkboK0YcalUkYtr6iu0F6PFjkBVXlN+I0ehBc39gWvKKYTzXWIS4sflbcIhjs/Wk9BNAl4o+HERBGCxTMv1bQ8byN9jZEkh6QIVtKIl9QtfEbXvOzcNcEadhEHZ3bvZ6B1Fxo0OfLjMpOzfsMPqS3qWTFG+Mpjy770Y8cycFhAHT70Ztb1oLWehGYAHKwMNCQ8y3UzbmA2uzX6RaMjknow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(8936002)(66476007)(2906002)(508600001)(316002)(186003)(956004)(66946007)(4326008)(66556008)(38100700002)(38350700002)(86362001)(26005)(36916002)(558084003)(5660300002)(52116002)(8676002)(7696005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N30g9Km3RMvWMF0tt+T0JrbaD8r2/gW6VhTNUODBZk6/kffYDl5G5g1j8PbV?=
 =?us-ascii?Q?MPviFC8j6lGp/QiiMytqrFomU5DymyoFQChzyDuJgRVRmwEWyLDW19B3uSxU?=
 =?us-ascii?Q?DpjFCflcTH00GbA/oaBOe1WDCjI56wDXRlbQQDw89yvfg6x/J5kBygnpjePh?=
 =?us-ascii?Q?zr+c7J5SVXPVZbMFTWnD/fu8T9PVHfb7/Lfyc52wQWoBXf+QEQg2y9zJ+B7i?=
 =?us-ascii?Q?Kav87VfqG30XsmNBlbG/h+pLdTWeW+CsHuojY4Ym4KzqR/HDfZK/Vhl68txG?=
 =?us-ascii?Q?l87zJuYBlOJe7eXQpjs8ZVLt7s6LWPkN5PajgVzzFdBMzO3XZIYuDV9+cbp/?=
 =?us-ascii?Q?R+MAkF0Fa9KK2P+xRH8LB/N5DgUoVPHDbPVaydglqSv9csozS7XusCO67q6w?=
 =?us-ascii?Q?NhS7TWR8CQVrTRJFUu4aPun8DzhvTcDfUH3ummiCGzRtUjtiSxD0ObYwbc46?=
 =?us-ascii?Q?2tM7mVHpeldivYCgM5PYcIfZ8tlECYFyYVsChTaB9t/cuZwEwTA/0bgh0VGF?=
 =?us-ascii?Q?/le+fKuKOPXvCr62t1BvhvvVpDMR6GaCXYOfANnl2Q2V+zizaP2B3nx6PW+n?=
 =?us-ascii?Q?inyUzIkhP2eDwx5KNC6iQ9gENQHHlefbxavS/H2krQH+sVlt9hk4/FhBNl4u?=
 =?us-ascii?Q?du6edTCC1mNCFy6KOoPmvWEnu0Ro7M45nv3cfwKPIQoGu9CTrQGalTXjKG5G?=
 =?us-ascii?Q?G5QnV4ojJ2TPwHyArD2PDz5O6cNBDS5rP2RBntSjhgKKoiVt8zpLl+ZplGTa?=
 =?us-ascii?Q?XQhUrOKg6tlyw2yx5BgAhoksUN2MR6SJUG42StGB65AXMSIfwAh/AFjcsWXI?=
 =?us-ascii?Q?zju++kk1s+yfziQ6VOiHI2y2ZDJpj9M/IFOrKXfnOUGRBj8NHXDLMZ8CLAfu?=
 =?us-ascii?Q?RAzGDF2F5N24s7YIy1Tgd5twSEDlbRHPdCyuHYCIPIsM5aQIZHQASmKDQMeA?=
 =?us-ascii?Q?YzPCsDA6YP5vP1a+nyQ9ohHtA8eNyc1Fl5EX+puq3WwhQw6MVRW+bDFzYGi7?=
 =?us-ascii?Q?CswB9xmOj1Ohv0o6mdwO27oOgdNSX15KR2EF+IANKsX5TTf5qU6p0j0eWAMg?=
 =?us-ascii?Q?kB9SLOnpKkFLRCIyQQvCTHbLXo9Fx9U/Al8J9poWzKIv9ibfAcUL+Im2n243?=
 =?us-ascii?Q?UYouU7rS4FxtJwgRw0WdHwR9ed0mr9pNIRoBdlDuZgx4GRsFkHYKNudMwAcL?=
 =?us-ascii?Q?IFKWQ1kabliKHnVyv1U3qSXnIg3JK608OMeH9QVbdfdv6KR4/TdylDeZEKPl?=
 =?us-ascii?Q?kX4R+rQhUb5VlwXgkPcqHEv9yNPFTPhbjfYxgxAvWVu9QrNf5kNzPVhdYCUY?=
 =?us-ascii?Q?qWHphVoaQw4N7s2feXCchtv+tUgrpqKxhDq1akxtrBmOsJsxZphhNwe57n6M?=
 =?us-ascii?Q?5AkYj/w8FJYtPir2Wqbw8z8T/kPGDyS4rE5qIu2jYsxDsUEczq/SGJbyb3z8?=
 =?us-ascii?Q?110sRQk4EL3eqiRTprsE9LCfTxhacpEJAD7Q8dLMsY+jyMhQbJ+B8se7u+/U?=
 =?us-ascii?Q?yrehdN9RjNzmLP00eDoYchOqwINEN5HhEcZOmpnnyQLMH3j/rQcK4aEnW9CE?=
 =?us-ascii?Q?EioOe2V+kwnP57+RvhNT+Db/GtvuOxSKf9fHMWxw0qP77FlU3SGGgiLxWmQg?=
 =?us-ascii?Q?awvaJLGnnaCWBqil7dMM5MuVCs18IMzM9Knb8emakwrmtmPMLgC33soa41S3?=
 =?us-ascii?Q?a8HFcQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5c98b4-ff70-409d-460a-08d999c35ea2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 03:31:03.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrUMPuCyShmpT9LDLqSMnovuNNyDtk9STqwAG0/tynb6BYiDqvZZDS24ANpAcbfbv7SklHrTXODIFMYAd2iUlgS8G1zj1O6PlykA3J4x/VM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5467
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280014
X-Proofpoint-ORIG-GUID: Bpf04mQm3CFR0dxTW0Eprxl5BKBtIGEF
X-Proofpoint-GUID: Bpf04mQm3CFR0dxTW0Eprxl5BKBtIGEF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ewan,

> Simplify the nested conditionals in the function by using
> a label for the error path, and remove duplicate code.

Oh, I see you shuffled things for the follow-on patch. That's
better. I'd still like the stable fix to be smaller, though.

-- 
Martin K. Petersen	Oracle Linux Engineering
