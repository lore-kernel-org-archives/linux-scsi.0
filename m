Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AD2C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A802464EF6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhCDERM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 23:17:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbhCDEQm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 23:16:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12440vxi050252;
        Thu, 4 Mar 2021 04:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2hD/+EUFteD6yc5FJ+6KcbxWMu2IsspIFGvWOZp3Tz0=;
 b=TzRJ59spurhwliWOaYir+/LxpWKZEuqbboInNCSkWVkQEOrqRvl2/eSKFADQ+NDEdKJW
 ZX5AGGcJhXtWk57vogrflVOkE3usC8wiHypTkB099W0gWKpE0xM/p7QEPjW1FU0mO3XU
 bMzx4Xx4df/oXEzWVCCuW60mQ6YdQGKJfFIm+9Fxz6JGp5bpMcIOtQ4mpGNVdMoGdeHn
 sard6x5eoKBJMQR8iZiysiUKyuyniStKYv/m1D+QkbcdEe3AYg+LAdszyZnGuUunxFVx
 R1aOFwU2KUmskExa5t5truoRbbNJDPL21F/ThK309dRvlpb0CcFH3Pn3I9W+9CpQEjSW QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3726v7b7p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:15:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243t5p7084028;
        Thu, 4 Mar 2021 04:15:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 3700024m5t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:15:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOrP1bFpZCghkSjZ63ZgFCY+Ht7T3yegPOucIg1ysvJ9JNfDFn0z422Nus956HH2/114v2UmVD12lewwrtnjw2/xehkAsJ8iRLaGcZ5Nx+Xk4LwOI5hhvPXhUod32rE7G0eLYzSJEgB9z5bvuY4EZR/lAr84t20/QF7ESgJl5JL6hGmKIP5OfcuIOIzAoviY0R3ISRm7b/SK/lsJLWHXxLPSUuUPXrZXS4+c+LvwyaVvkDvk6LSudDVEqJGiZeyDq2PAFMOC+8xV+/eT6VsFWeIKSCHxIeEiSNGNwZaULZ9rnTibpuCJCrjxvKcQAyAOKlRknth68UtgQ9tvgGul2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hD/+EUFteD6yc5FJ+6KcbxWMu2IsspIFGvWOZp3Tz0=;
 b=ItnCt0WCmSSYigoXnKCoPMyDdNOLIwyWwCPTLV9J5/8YB+ku6A0O7urm7X/6Ev+IcSdK9Rsbn7Ngdl2YfTUWujIMMP1flasY0zCR/2i7/q/9WyCL6xauaSh9pdCqqCKJvatfEPMAKR3mbbgdMhUt7CPuFZwCatJoMguMUF4JDEENtnYq69P1VVUvRvwhb5QTlV/5qA4WH/6xpsiWp2r0GG4zXm9C9B4NDAfieJwZrIwJ+CaHZB1uCd1wxvsjOesy728ShaNE/tKEYuTolQisXQazPNuZpRLYMmKknZri6Eopb76RcIeBhOudBwAWtvWGmtrkolX2Taq62+1v5AOATw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hD/+EUFteD6yc5FJ+6KcbxWMu2IsspIFGvWOZp3Tz0=;
 b=iVRMoAHDQULXEzyJ/dl7ozZe2TFPPbpojbEguMET240bnSwjZpFAmCa+GC3/LYCdEZ74AIZAzV471U2+Qt7ZAKXXidFBoFPW6KI6MoY2aTdP621LPF9fHdUwwsYvMsZ3qnO2dkT8sJmZnB4AnDkqt4n7cVbCBaGZCHeergBzVb8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 4 Mar
 2021 04:15:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 04:15:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, loberman@redhat.com, hch@lst.de,
        Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, bostroesser@gmail.com,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 01/25] target: move t_task_cdb initialization
Date:   Wed,  3 Mar 2021 23:15:44 -0500
Message-Id: <161482822407.30323.7273252063928870022.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210227170006.5077-2-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com> <20210227170006.5077-2-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: BYAPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by BYAPR03CA0011.namprd03.prod.outlook.com (2603:10b6:a02:a8::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 04:15:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 252011d8-27b8-46ba-2ca7-08d8dec4327f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4552485042A6D37737988CE48E979@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DrG5sSVjUSyRGb+XlY55aT+cjhhkamisvR3saR/979+cz78wCyYWXrumyGhgYzO5aCDPVWhiTIzx/mykoZmIQqEQcJJl8NQvszQH5Rp2Rlemp31BO8fSk6PfBmsD291evH7D3FcFC/N1Xcahn0PW1EqgFzlT3+0+7YkHT3yZKRcyCnLGTqJtDAoADDeJtL2VbEtXXNWgo0tPLdg2Fw90EK/ev/N0qT0oUPf8slqKTVUm8Scr7twY77cVd2UWdgqYkHWkpKiJXt8qo5RESXGsxSfOqbsnAmNpzJ+wvVV4oHo1azCPlP1oviverkO/hLZvl5RSSqR7Xe9H5rFhWIgCgyIXaXqWNb6hmdy3dAG0m8nqMYyXSy2bSiMkYXJ9FidzxaiZniBCfRoeYncVaPwA2R0TOnqr/UMffxVLmucGu5D8/1mAcNg9OzF5z7lW8ZVIjyxJQsacOQMw1J0COOS1T7tkJLK/XJkyGYCOlR/dTRN112EwxLjF1MoKvoY7ijqz2xhMUqgkPwqHClZbVXig4o8BydzDijtOUJ2YwsL4O1GlkTY3K9uooCxHu4vm7LJlIqIk2RgAYnDD04DL1NitXfjrqNNsbnYjPaRmycm+jR0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(26005)(66946007)(6666004)(16526019)(316002)(6486002)(66476007)(478600001)(966005)(7696005)(66556008)(86362001)(2906002)(83380400001)(186003)(103116003)(956004)(2616005)(36756003)(8936002)(4326008)(54906003)(8676002)(107886003)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UGI5VGN3b0hVck1XRzNIaHRKYWdVUHZ4aVE5SHMvVzJCL0tLNkREK1JxL2Rn?=
 =?utf-8?B?WTl5OUJWVGFlU0NtdTBtQXFaTldiYnExVmlkQy9HYzQ0VEF2WnU4ejRMemV1?=
 =?utf-8?B?TzB1TXZlNjZVME5tQmo2T29zNnpHTDVDZGpkckp3MkNhU0xqUHhrYVR4RVpz?=
 =?utf-8?B?bXU2QTRrMDJtZUIyQ3lUaEhqdzZ2d0R4NkRFdTVuYkJoaXpJZ045VjNCb2JW?=
 =?utf-8?B?WHRna2hiQU53cmZtNGZaSkNwRTg2Y0dQSVRKclBTNk1UcWRIeGdPcGFHRUtv?=
 =?utf-8?B?d3FZM0NXTWN5Q09HS3REYjRUSnBacTM5bmdJaEdzZkhMRDI5eHVtNWEzR0M4?=
 =?utf-8?B?TTJkTjNuNm1oNW03Wkw3NHRLRzF6YUpQRW15a0hMVXZYaUFnejBEOTlHWjB1?=
 =?utf-8?B?TDhuOHFPVkswQXd6UWxuVnJZVmt2OE5MNUpWbVRQQkY4cFNIMjFWVnd0R1ZU?=
 =?utf-8?B?L2V6ckZobmJqY1c2SW52RUFxZHFPeGsrNzRlU2tVZ3MxekErMlhyWEFrTG41?=
 =?utf-8?B?WERLbWNFUnIyclErWXlBZzFhMmZqQ3ViaEV3RE5PMHVPaTJQOE12clBtUGx5?=
 =?utf-8?B?azRhS29XRzZock9UL3ljY3gzbkMrVENxWlA5eUMwWHlxODMrOTlRY1ErT2JO?=
 =?utf-8?B?REgwcG16RWh4QlNuM3h6eUxyL0c3UGxPSHFTOG1JMGc2R0JITnFIK3ZLRDFX?=
 =?utf-8?B?Y3g0SnBFWitNRzJRNDMwUG11Y0cyZUhFM1Q4Z3RTVEw0b3JGQlY2Ym1qMHgz?=
 =?utf-8?B?eGVMVm05S0tZMFlOMEFiN082dkdtTVJteTNoYzNOclFoU2JWNnhQbHRlQ2k0?=
 =?utf-8?B?MWtQbll4ZGNsSWhVaUhkY3ZzT2k5K2RheHFlUEpnVlpyOXQrVDdNL254M0g2?=
 =?utf-8?B?MUtGQllFRFZIb0FrTVk1OXRlZXFvQndNN3BrUGFsaWtYRFZFL09MTWg0N1p2?=
 =?utf-8?B?blc3Tmh2QzVSbFhPdDBmb3RvNXZ4cVBlbVJmMWNsQS92aFlOaXA3TlhwNmVM?=
 =?utf-8?B?VHZYVGlkQjVTOUx3YTZIem90a0xyYis3aXBRQWhqa0ZxUUxsVFZuZkJtVjRB?=
 =?utf-8?B?eTRPQkwwUEpOYWpMU2RHT3pKYUlnWlV2KzI1YUJsclBtWTQzRDZLZWpEb2FR?=
 =?utf-8?B?alpWaDMrSEtWWHVBMmFVb21GakZ1SWlHNklFMW5ibGpTdTNCbmlNeFFMajVT?=
 =?utf-8?B?OUFrVlRScVNqRnJJeUlueVQrS2hGc1VuMURxYnIzOGJZYnA0VzB5NDgyOXN0?=
 =?utf-8?B?ZmNBVHB6ZlQvemRUZml3SlkyTm94bGk1WUtLRWJBeENhamdzS2xsYzhubjc5?=
 =?utf-8?B?WlZYUG9BV3RMRkxHbTNJUVgzOWRYbnFiNWVMeGExbDFJMkNoOW5sd2V1cTFB?=
 =?utf-8?B?NGhFSXlieWpEd0UvaS9YVy9WNjRrLzJTMEQrS3BUZ0lSRm5pVTNWSjRzSXJ3?=
 =?utf-8?B?SFZxVGE4bkg1UEhUUFVJZ3FGNVR6a050Y3J4RHQyajlEUWY2S3IwZWcreUV0?=
 =?utf-8?B?S0tQQktNUXRBSGFPaWQwTTRqZVE3ZWVRWW9pbjdMUm1tRkRpTTAwZkpzdUlM?=
 =?utf-8?B?bU5IbjFPck1yVkM1M1hIVUY5T2pTWndtdTJYWllDQ0RlNmordzJPZk4xWnBP?=
 =?utf-8?B?dWE3bEpxVnRjbi93c2hzVXU5ekxSM0tYamRzQTJ0cEZZNkc0bS9SL3ZES1hY?=
 =?utf-8?B?Z3E1Y3NhN1ZtRFZNekxmZjNnY0JCR3k0S3ZOWXJGeGxVVTJYN05vSWw0Rmt3?=
 =?utf-8?Q?sI2xckWNfjWTWsz3//NTYC0qMVqHeRWIk9w8F4f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252011d8-27b8-46ba-2ca7-08d8dec4327f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 04:15:51.6868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bunn1F6KkJoz8WaesRG0uSPkQx+/g+DorBQlTnhg+6jKyzVbZZ6SDwFAAO8uyIf6ikvTb72GALXwxyutVo7XHZ2Sr2DVVkNTabB8ivQImk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 27 Feb 2021 10:59:42 -0600, Mike Christie wrote:

> The next patch splits target_submit_cmd_map_sgls so the initialization
> and submission part can be called at different times. If the init part
> fails we can reference the t_task_cdb early in some of the logging
> and tracing code. This moves it to transport_init_se_cmd so we don't
> hit NULL pointer crashes.

Applied to 5.13/scsi-queue, thanks!

[01/25] target: move t_task_cdb initialization
        https://git.kernel.org/mkp/scsi/c/eccc70ccfb15
[02/25] target: drop kref_get_unless_zero in target_get_sess_cmd
        https://git.kernel.org/mkp/scsi/c/14e025be793e
[03/25] target: rename transport_init_se_cmd
        https://git.kernel.org/mkp/scsi/c/ed58729a69f4
[04/25] target: break up target_submit_cmd_map_sgls
        https://git.kernel.org/mkp/scsi/c/4a3f993e79db
[05/25] srpt: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/834e8c13acc9
[06/25] ibmvscsi_tgt: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/3b168220e479
[07/25] qla2xxx: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/9e54e530349a
[08/25] tcm_loop: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/5f3e979db0ef
[09/25] sbp_target: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/207c30be067c
[10/25] usb gadget: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/1edc02440bde
[11/25] vhost-scsi: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/e4edee8ac14a
[12/25] xen-scsiback: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/4d1d39e3a2e7
[13/25] tcm_fc: Convert to new submission API
        https://git.kernel.org/mkp/scsi/c/bde30acd9bd6
[14/25] target: remove target_submit_cmd_map_sgls
        https://git.kernel.org/mkp/scsi/c/4d3a1c529373
[15/25] target: add gfp_t arg to target_cmd_init_cdb
        https://git.kernel.org/mkp/scsi/c/22be5fc090a1
[16/25] target: add workqueue based cmd submission
        https://git.kernel.org/mkp/scsi/c/1a8ce8031c2c
[17/25] vhost scsi: use lio wq cmd submission helper
        https://git.kernel.org/mkp/scsi/c/f4e69b337bd5
[18/25] tcm loop: use blk cmd allocator for se_cmds
        https://git.kernel.org/mkp/scsi/c/93239a54b60d
[19/25] tcm loop: use lio wq cmd submission helper
        https://git.kernel.org/mkp/scsi/c/3f335d8914bb
[20/25] target: cleanup cmd flag bits
        https://git.kernel.org/mkp/scsi/c/74493992906f
[21/25] target: fix backend plugging
        https://git.kernel.org/mkp/scsi/c/1518827a9c95
[22/25] target iblock: add backend plug/unplug callouts
        https://git.kernel.org/mkp/scsi/c/18a45511925b
[23/25] target_core_user: add backend plug/unplug callouts
        https://git.kernel.org/mkp/scsi/c/dfe49a322758
[24/25] target: flush submission work during TMR processing
        https://git.kernel.org/mkp/scsi/c/b0ab4acf2df8
[25/25] target: make completion affinity configurable
        https://git.kernel.org/mkp/scsi/c/100d21c4ff29

-- 
Martin K. Petersen	Oracle Linux Engineering
