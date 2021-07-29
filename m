Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8CEC4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC7660F01
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhG2Dij (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:38:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47892 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233601AbhG2Dih (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:38:37 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3a8UR029107;
        Thu, 29 Jul 2021 03:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Nik2gDqmtff+Y/6K7iyH37b/i5MApWrvGUIvlYdbbpo=;
 b=Jtd2vvI8rMD2IRlh3dhGpW9Eu+bt4QQMq5be0WnzILXcoUaZkENv2xqeUVgE/bNR0gqq
 OG5yFJlkV3+JUR2hiuLbrwZF+Kz9NM03hXtfeG0pw0QfYr9tJ8IJDFNF5KPUz15WeJpI
 RFsPNxTzOpZwlh1mujGnxH5eBOrhEbyYd43NVZh/RWK6wo8qHGIV3K9OR8TyraQTjogK
 wlzG2W2ltbE/AhCJvQ7w29xxtZaorjb6eLIvgvF/RMH9JU38KqX0iZMtT5Uagyc+lLWl
 0nS0Dhib3KEq9JvwSC40D6ArS0dqw1Q/cLScOs2Z0VY/F6J3i1HrTww+gfz8jOwHssJL Iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Nik2gDqmtff+Y/6K7iyH37b/i5MApWrvGUIvlYdbbpo=;
 b=g6u3oHoJc/pf4s6AJtswBRU9HE6wBu3ojC14EUhagi8Rc4I32LPSKFtDrRjKKGuJNPHg
 nt2RPnUBLJ3VZKAOTExuUfxspmxaucSQ/O9B/xGroSixr1BcNHBnpbjk2qxp2iIlme9m
 nn/2FLgbJpFjxYZN46JERnFngtZSqqIOTeZzZC0GqzW8lVP0n49jsIzO/IRWdjNqDQMQ
 +AZk1ecgKDKw3nRqQZpx1wZAD9xn+TkEwsLUyARruq6mX1f6zpGVSIfR6Onicu1ghinN
 vPnwnsv99reaX2vDtHkMeSlysBucWYfR2WLh3T72Z0dn7wf0ZnHSDQMKH0gINNSWcAIL Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3jpd043v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3Tnob041079;
        Thu, 29 Jul 2021 03:38:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3030.oracle.com with ESMTP id 3a234dpeeq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAdspYGJyHGd0YrzHeaZYDje+XlV2MgX0FDWu6IAgsw7y31D9HzKqHYkj4GSkJq5kzFvK2jRS+V4+gmwLHTAOu+BkoBWB7FZzuLUs/JL8BRUHPFIIt65LjAAG2+2WT3OByjU944DjRR7LIvFd/Mhe4FY+cqCl2mhSI/U8iwugexDmwX4plnx+h/p8E2T8cPG5kKIC69DSa3MTwRoPLsNwB5dz4GJZbNeCM2O1q7VEdhdA88GLRbcmBUXsOYvL8Yvi7XlftQH/+t+823utXjuOCTTY1sN+PHOgQ0o6Z+wSSVTsDdPYyHT1ebx2N4FYmiDaBEClh+ZQQ//Ltk0Wa7gQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nik2gDqmtff+Y/6K7iyH37b/i5MApWrvGUIvlYdbbpo=;
 b=oYJcN1xzXh6QFQPZNEv8Tgw2+tlYheYRBdPQuvNl7eKKBK5ks7QwPgqiALc8SQnx/FrclXb/ab5FS0GTR/lLfaBoNTi1ZKc4QnQxYn5884Jw66Og/OJHsetZshW3LT30JzmnNrIF+7MobgoO2e1wCAxCw111gqlyATDiIoAO7mwwVBKegLbMr3UFdiYjXVvzFDpZpm8PCWnJ5paVGQgoPRozQLDDA4n+W+Or1piDQdBMDF0zkI0MI+ewFcrA1xldwTDpRsJdGqgZMMOZW16qldsQk98uF/vfQVqpA1gKHhQKNCrmtB9GnR7GbGbVu4qZbjq0pDuRDdb7BI4dKIdtHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nik2gDqmtff+Y/6K7iyH37b/i5MApWrvGUIvlYdbbpo=;
 b=YudsJhKgYiyyi4CfxxJvYooJCGFs/vdDP/qHvLQ4bx+Lzuha3pHXT0W/RbDrUxWFnvXCkPXsj0rn0CEWOFEv5q1aSZa3z2QRXNU3+7SLgla2/NCoNjj6tJCV51BJ3iWDkN+zyui2Vcu53bIQjA82ZI0E2Ze+6OISwTo20wXD84o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:38:30 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:38:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Colin King <colin.king@canonical.com>,
        Varun Prakash <varun@chelsio.com>,
        target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: target: remove redundant assignment to variable ret
Date:   Wed, 28 Jul 2021 23:38:21 -0400
Message-Id: <162752985699.3150.15301668641855029976.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721101519.42299-1-colin.king@canonical.com>
References: <20210721101519.42299-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:a03:332::12) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0067.namprd05.prod.outlook.com (2603:10b6:a03:332::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.11 via Frontend Transport; Thu, 29 Jul 2021 03:38:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d303b73-d979-4201-e1cc-08d95242557c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB154934FDEA821142F092EA4A8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiswqon9C9Thwo/suMvqv8xWXoGTPWVXNKGi9I/28dbH95aSQylGBZpOew3JjUFm+nI3G9Edif2BqlZBR5NzbRhd82bQJgjE/cK7VSE5ZVZIHuhp7Sp01bHqfYYIH7NhF/7vp+Dap1hggCyVzqjAHGOsdDPHYKUCusPd49+WHw6ZP7+pgfhs56GpVL/5pYqWKLFFy2JIG6rNnb9ZEA9tSGKHF2mJ+Ae4z0eHxiA+JkQb6gs+lyd+hoBu0/IhgYLIDAhTTmtlIZcgyKRyAtTjoqP6muso/2+KoMdhOfBbLojMlXloBHsRR5MWkt5cOvEcu5uDATHLis2Beo4Vq2SasoLx5aQFQCCAruRedkGYO+vPBgRqsft+DurRvn/OdzJRVn2DY03dfnIY7uEqNhYIpULt7JrHeEuVhxwpaA4jsJAvD/dzuWwa031GHVp9n//SNuCKroes6oLKu23OksY4EMlXCKEf2h8cOp1Ixuql1539li7/nzy1LieeNpofWQ+Dns17WLzSCjaNUzK0RsMSCAhtPOGIFOZUIORWeaQgA93+gyLmQwM+s9jyQrBeB2zdpQFb+hTrUIHOvgDWt9C2FyfJt5X0HSlT+FDrAHiAaM77or8d/kstKbVnmJe7j4daHcwThBjs3xkHJDJqOUXHnSYY4kLiPRKVS613ZQiU44wmXIxVypOyiMHgT53sLRYjC2gqiuHtzTw9lha/hvQyRy94wU15uJtN4vsQyI6U61t3/sZz0avFKYYQfAlS+2HRlW0qQfzK/GjQDPYMRubWQaejvHX3BlrJCwEhX/onXMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(2616005)(956004)(6636002)(86362001)(8936002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWd4MThWaVhOL1FQYk1SVHJ1d3FJUlBrYkEzZWtwTUlibitxenZRYWV4bnpv?=
 =?utf-8?B?ZncyTWVnQ21SQjRlbXVFVWZDaDJjMmkvTnQ1MVVMQVgyeW5ZSlZGOUh4Vlow?=
 =?utf-8?B?WUFIM1ZKUVdlcS9pOENVS2EwSlFxV3gzdk10U1lUMjdQV1o4SFR3UkFDQ1p5?=
 =?utf-8?B?UjBhL25QVHJJTXhqQTlSVlYxUndBc1B0d0tGVUIweWJlRkhUbjhpd2dvckdM?=
 =?utf-8?B?eGNuaUV1U29XQm1FVGlBOW1WZFpjYWhtZWxoaVBwOVB1UDhTdTcwajRpc0JR?=
 =?utf-8?B?Q0xLa1MyMk8zeVJueDlFbTFNLzhCVU55Ulg2TEpCbE85cEIwM1hRSno0bU5o?=
 =?utf-8?B?c0MzSDZiNXpPTUNoai9uRUxPQ1pNeVdBL2haUmRydE1DWXY0TDJBUnNCQWtQ?=
 =?utf-8?B?SGNiTkltWmlvcnkybFN1c1pwbXNEU1hadEY1N0k1SVd1V1VQTFhaVDlyZEl2?=
 =?utf-8?B?MmM0eFVDZ0l5a29SZUlxSkhEOTJPTjFwcXd1bExJVkd2Zlhrd0lmaDIwa1JJ?=
 =?utf-8?B?RW02ZmhsZkNuZzNJZ29CY2gwQU9zS0ZoNGdNYVpYOU1qRExBdTdyWS9QRDBT?=
 =?utf-8?B?UmdJNVF4blZ5bi9GVFA2Mk5xaGt1bmFqSngzd1Y2TWx1QWRvdWxVeXVrRWt5?=
 =?utf-8?B?YWFtS01EN1N6Z25GZm1QTktZZGlrZ1UvZ1BlaC80VjNjckNLL3F1SWtXMmVm?=
 =?utf-8?B?ZTNQeDNObTE2QUdtZTBRSE5KZFBQQ01iZnREVnV4ZEpKcDYrMjI5RGU0RitD?=
 =?utf-8?B?TGFNYUhFRnVXcVVDc1hUQzBGV3BiYzJqY2d4aE03bjF0Mlg0RWxoc3QwcDgz?=
 =?utf-8?B?RXVobHc4bzYyazhmUFoxN2tDeDE4QzZXUlcxY1dQZ0lpSmJoWUxnNVNtQnFY?=
 =?utf-8?B?REg0YmNyc2xLcEREU0V3UjYyeVNhSGVpKy90MlZEYU5GRkhrU2RmSzlOcEYr?=
 =?utf-8?B?T3BocTNaTTZnTmtMZUY0KzJvN29EUlY2Tk84S25jYmJiR2RXMTc3N0dHdVg2?=
 =?utf-8?B?ZkRMcnQ3OVZSeVZwc2k4VmQxUGpyWlVOeDRkOTdUWnA5b0VnY1ptL013d0xB?=
 =?utf-8?B?dXFsMXh4ZzV2WDlpTUd5bHBmOEI0UVVXa0ppbmRncDlBek0yS2t2Z0p4VUhI?=
 =?utf-8?B?QjBJblYrTkJacm9pQlBtQXlHSlJWQTB1Yjl0RXFGT3FySUl4aCt4NUNWQzRN?=
 =?utf-8?B?STNrd292T2JYN0tCR0lBMmhEUllaQngzOTlRNTBFcTVKUWk0U3ZZcWFOb0pC?=
 =?utf-8?B?Njk2Tjdkbjdmbkl4VGZEQmNuWE5XZFlqbWtsSDZxcVpDR2liY2J5VERHZmpB?=
 =?utf-8?B?Z3RQdHJ5V0VJd1dwVDdXZXk4cXd1RWZ4elk2bkNDWUhOYU1BcWx2QkpJUUxk?=
 =?utf-8?B?VTl6WEUxaHlTNGJuZGp3RERVZnpEbDFET2xnYlBvM2htYWx5NjF1dUhEelpV?=
 =?utf-8?B?Wk5UN2dlN0pqcytCVmJHRDJXWjRlQThSbzFieHZ0STlwMCs1UFc3elVmQU1w?=
 =?utf-8?B?YjFQSHRVV0orSlhmU0czVGZnQURKMnRqY0FxTUJ4eXMyM0NGZ2psNmYwZDll?=
 =?utf-8?B?VlhmZEtQdlhUL2JRT1RKcFlmdFh1aGNEY2pEVzg0Zkp5SWg5OXVMTWZwemth?=
 =?utf-8?B?MG5pMjVoU2xyYVU0c0dwcWt2N0FGRkdSWU90UXAva3FhNFdXMStFbExvK05n?=
 =?utf-8?B?TXE1bkVnRFhiRU8zaHVsOS9nNFlFdkZ1NzhKb2p5b0VYZEFnTXAxdFpmd0d3?=
 =?utf-8?Q?eq7sLEStp+K19wYDpAO2GgWfOILy8C79zRoB1jg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d303b73-d979-4201-e1cc-08d95242557c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:38:30.8089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NU/9wKT6tsNwfLBBS+9/wEZp9y9MEjsfG2KnRDn7S1+k6rqUMeJ+JWtQ75xpQxSyb32V1+mpM/o8Wp0zHCYsG/zX9hk8OEDBajxSMtmoIBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-ORIG-GUID: L1Bj6k__12pjkMk8y127HNWctuussmQo
X-Proofpoint-GUID: L1Bj6k__12pjkMk8y127HNWctuussmQo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Jul 2021 11:15:19 +0100, Colin King wrote:

> The variable ret is being initialized with a value that is never
> read, the assignment is redundant and can be removed.

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: target: remove redundant assignment to variable ret
      https://git.kernel.org/mkp/scsi/c/8f13142ac2eb

-- 
Martin K. Petersen	Oracle Linux Engineering
