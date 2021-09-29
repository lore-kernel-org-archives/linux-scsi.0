Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A2BC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9DE613DB
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244025AbhI2EVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:21:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20344 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243950AbhI2EVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:21:15 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2ECse013609;
        Wed, 29 Sep 2021 04:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oRoU+wcF8GpLM+kpFfxbRkmXLpWbDzYRHzzpdZKFgwQ=;
 b=A4lpJxRxRRO1Gr6JifTM9nvCUi1paIA6GNHsaKZFADVXMCXkwJjR/il+cRv8aRErtqnc
 ZjN6TFhd0a7X09NVXAtps2NQMqhTMuIq4OCzpfo5piLwHGmlNThQOkAD7EonUf1vqiyS
 M+MhMuJpYPOyg4aURZRx3+uErsoovZHTqHRJmU4KHu2Ryh9esqc86Q9hyrfWuJxVIIfC
 cvJIPLjW1j+hqvfGhFmOWaffosTW6S2cFk0J8FqMtENl+dj9hZlgQC95tvy4z/dmeXZ8
 FEB/iCMmilXFsE8f7mvcbJ9p9Qi5YX4Tva/YmKP5oA/9hRtL7bXqr08oMRkHagVen6AX QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6crd3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4BdCo132115;
        Wed, 29 Sep 2021 04:19:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3020.oracle.com with ESMTP id 3bceu4usv7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ql1WinEJtkaZXVLUGBkMobzZmIhnfeAcIv3qMXzira6+brc2D+tUsZsIJKmjm0PsQ+nGy1pgC6V0oT3/t7BVNy/uML0PTC0H/IwQlTPopBrwyzCcijtc/Dnp9yHPSa6eTnWQvuLnH5RtDxUlduFqFFQc4YOwKptShKV3WsPdgO+4ckA8KxzVysMetv25JhwSn1TW1QmF853XeYh+G8FRUuW/2VIh8ODOrFvQ07sg3tRQdcYmYiBqmVqQCvstXou4j6Kbd7vaOuf/hWGneT8fmiJASLI8kGmUW3HIFjNFm+fpFFovieT/3Fjy3ToKItympA4dl+4LctwgG5yJzaWajw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oRoU+wcF8GpLM+kpFfxbRkmXLpWbDzYRHzzpdZKFgwQ=;
 b=fgh2bfsPZSFp8r+EMgUt8K0R3loOm7Q6tSKDN2W1mZqZAuIDs5k+7ugGnSaJGuFVMcGGCCv62zSfas+n15e5ik6gesjJXIBA3vrvrS3QXnvRvD1ZY0jx2YTG6UtgCkG8P1mDt8EjrWPAShF27Ua3c6Hz3oVLs60l9ASpbxI2dop8G3ua5A++IOHfeOA+NWqEBEACxzkAa+iQPQwwCQx0MJLpmWNGXu5BmDM1OJFGcaDpDgglkEq6lj5VrQlMBydcl3kk9Y0x4kFkfwr0InxXn1SsdX9r5v770MmHN4l8s2WZ0SVmRKpv5EiA2Il8IJB/7dLQPP/IOKFEm19H8fI/qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRoU+wcF8GpLM+kpFfxbRkmXLpWbDzYRHzzpdZKFgwQ=;
 b=ec0U/NeBPhL6/39MZLGZsi39L1GZsZET7/AmbnYMtCgqOOqaVsKtdPOy99gRf+RZmly3THLt2xbxMPlW+v9NLkxzHd8XL7kcgxxXnW84zOEZ/tIA3rwBJ6ryWskOstVaU67l4A6iZrmTd4MDsP75LQXm/D4gWJqOfbaelf5UbeQ=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:19:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:19:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        emilne@redhat.com
Subject: Re: [PATCH] qla2xxx: Fix excessive messages during device logout
Date:   Wed, 29 Sep 2021 00:19:20 -0400
Message-Id: <163288913991.10199.8072985358438207313.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210925035154.29815-1-njavali@marvell.com>
References: <20210925035154.29815-1-njavali@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Wed, 29 Sep 2021 04:19:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67d08303-037c-46a3-8a63-08d983005556
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB455129658741D4401914C12D8EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3mCxZceBGLFjQ/y2Sm7di9Cq1FHJc3rWMlBaIEXxpEb6HJkENdUrFRlSXRXs+2JMbIlBl2B0cFcsx3Y+fokd0vwjzO+LfPQ8ILnC214EUGuxIgX1trv6ml4NIUmYiTg0TzmoQo+ggO6SE65sCLE7j8BSBqIT/TNLRkl+jtGt2qJXQzLIiQARnbQFiuC/+A3z6PLKk7t/vvNATZetLyVgTvokUjSbY4mGHRpeVSnumvf0bxeBE2OO6rhx8fcKpPSgglzWlxPK6uryhIZheqXB7I51k80hGe2PMhzt4t9vJRuQvTIPzUbIEKG+0vPJucSaUzzeeBewbNGmZz4hUDro2/D1ZL4S682jOFoThf3Zl0VOCKJD3fbzq4wZJPSGLBz91Yndf/rIBNAd1qGzbcAJUOiboaArDqvyNga2vrxQqFHwLht8m6kTnQrNMt2P1rvqEU4g05KJIoPtdsAn6zz9IkQfnddSbKAiDPXmUqJgq9wx6oy6FCUX49OTpdhI5mQanBhI6VIh5Qd3jyPKT+CO0tHNP6xHYxcIS09o2cVB5kQ6N2lQfV+04C2wuQvFqOUqIAE/0qIvLSTi6+Cez2o93we03i1IIaW5lqNbc7YG9Gh0bICNaSJKkYheb/36KkEIr1IQKUU3WZCSeRGrRLBxCPQSgvA08ZjtWCTwcW+5JZCEoNtvY6DV6a2FaV79IqhDuFulUPw/aVPTpbhX0/uwwaxFpX2lhkuBoDegyA4h0nz5/UE12VYw/5Tt591dZBeNRTqdNdmWJNoEpJnXX1FVLvN8MlUrk5eNdx/eheXUGA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(6916009)(2906002)(26005)(508600001)(66556008)(66476007)(83380400001)(15650500001)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1d4S051K243RXNqT2huL29lMEpPSWlqb2tFWXgzb0Fod1dod0U4a2VuUk1G?=
 =?utf-8?B?QUpwM1UyRVc2N0ZHamdLOTNiZmRTS1JSdUo3MXdJclpkTE9sSysxK1YxV2E3?=
 =?utf-8?B?RlFSY0kvMzhOaG16ZGIrY0VpaVFaYTFTVkNKN09YVkRpY3VtV3h4MXVEZ2N0?=
 =?utf-8?B?QU9zVEhtbUw0YzQycTNmbndNSFdiTFFVR3dHZkZoMkRuRlZZRjVWVUROZG1t?=
 =?utf-8?B?R0owU1JCb04zUUhOQ2hwY29kb04xMkVFWTdDMWxqZTZJajNJTkFHc01LSEt4?=
 =?utf-8?B?M0R6TkhyTWxFbHE4aUU3L0YyWlNYWXlxSHRxNldIbTdoNHFOdTlUZjQ4NlFI?=
 =?utf-8?B?SXUxQjVvdyt3YnZ4ZFlVcXlJd2M3SUZSdGkxL2oxdmR3QURta05NTmhGQUhw?=
 =?utf-8?B?Wk0vSThMc1V3UkxxTGRybERQSFh0N0FhSWh5SmFJTzVNVDZtVW00dmUvdVZG?=
 =?utf-8?B?dmNpcW92dG10VXE5eXFTbEVwWVppaHlFNU1QMTc1UHRoSnFidW1jUmlaelJv?=
 =?utf-8?B?UWpVbkx0Zk9QVXJPOGFZQ2oxQTQ0ZitKTmFPSHNmSFAzOE5Ea2YrUHZEQTRz?=
 =?utf-8?B?VmJlS240U3JkQWI2ZXZpQ2g4UWZpb1Vja0FVMGZQd2VqVm1scUlnODd3dkR5?=
 =?utf-8?B?RHFaYlFtaXc2c3pqeXF4N0R1alZxYWRqZks3QklpeWY0YUlJNWl0SVNEWTFu?=
 =?utf-8?B?aEFMMlFmZVE3ZktlazZuUGY3OVRSM0dEZnFaR3N1dlNYTVNOdk56OXlDVWli?=
 =?utf-8?B?MHJuS1ViY1ByTi9DdGlkbzl3Q0xSeVZvNFNCZDF0YlRUR3d1ell6OXU2WUJO?=
 =?utf-8?B?Z3NCNzlEa2h4cUVjUXlnbG9OSkZTdW5UQXF1eTNSSEtzL3lUU1YyQnBsQUNR?=
 =?utf-8?B?dUVGWXJNbzF6ejQ2YWF5WmZ0bmVuZXQ2ZEV1czdvODh0OURNbHQvRVpjV2Iw?=
 =?utf-8?B?TEUyTnpKcE9aNzZvdVhNUW94alQ5NWpvWGNWeThLZEJwRzNkcXcycEVUZzhH?=
 =?utf-8?B?c25JVG4weUFId1QwRlpCWklsblV1QjZ6MEoxUXFyTjVtNXUvb0lDa1VhYWRO?=
 =?utf-8?B?enhCcm9TYnpQdU9VcVhadWYwbjB4RHJzK0gyZkgwMUpZUUYzaUdyTC9GV281?=
 =?utf-8?B?U2h1b1FERlYzeS91aGVZMWlCZCtjeURuQnUyMlhDOXhHRDA1M0hqL0tKd0hG?=
 =?utf-8?B?Lzk2cGdNRzNPSk12cUNNOHp1eWVsb2VVbytBbHBPZ0JxN2orcEliNjlyVTVu?=
 =?utf-8?B?Z2NzUExLMHp6ZFFnSnk1UXhmL3gyanlpREY2aVROL2NsNk0wSDFORDZnaTQ5?=
 =?utf-8?B?VmVENTgxMXdybVYvODZxRnMxTkdqcGpJQmtpYXo3eThVNjZuTnNMdjBCcFN3?=
 =?utf-8?B?MWdpT0FXRGwyNzFtV09WTVkwQjcweVloUU5pSFREUjRKYkNxZnZpWTBrWFpn?=
 =?utf-8?B?NmNYSzYrUUxoMEJhdTJ5Nms3clBYMnZ1a2l2dTdzUGJXc0lGcVpQRDB4UFlz?=
 =?utf-8?B?MnI0eng2WVdLOGY1Uit6VmZJeU4ybFdzOEFDQU5SUTI2NnpmbU9sdEtPbW5J?=
 =?utf-8?B?VVIrZitYeEgwU2tsVWZKb1Qvc0VxTUJzaVNzQ3BhTGJPSlE3b3V4aFE4N205?=
 =?utf-8?B?U1VoL2tJdkRzaDJ5eWI0dFR6UWJvbFVDek9kQkl4UFFDclVtQXJiL3hCVTdI?=
 =?utf-8?B?T21LWG5nMzJUUjhSK3B4NFJWa0JQNnYwL2RFc3FGSmdpT0xlcFlBbC90azhm?=
 =?utf-8?Q?MDxpJNeZQbWAwcmJEZBmEA2Q/lP/SOz8wGAyGot?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d08303-037c-46a3-8a63-08d983005556
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:19:30.6431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIbGcBg4Qm71+IadsfjPCL2j2nDxpEvkmw2uWwHM2E/09l8+/VsvnVaKvZFimjjzgP0oIP5avMjS1Qcb1wW1gWHr1BroC6VMXDk+2vc9/tY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=853
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290025
X-Proofpoint-GUID: 7ZcdJmo7kOr1m0OA6JHZZGq1YakpPJbY
X-Proofpoint-ORIG-GUID: 7ZcdJmo7kOr1m0OA6JHZZGq1YakpPJbY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Sep 2021 20:51:54 -0700, Nilesh Javali wrote:

> From: Arun Easi <aeasi@marvell.com>
> 
> Disable default logging of some IO path messages which can be
> turned back on by setting ql2xextended_error_logging.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] qla2xxx: Fix excessive messages during device logout
      https://git.kernel.org/mkp/scsi/c/8e2d81c6b5be

-- 
Martin K. Petersen	Oracle Linux Engineering
