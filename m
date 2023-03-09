Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DABEC6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjCIWeG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjCIWdr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F69AE190D;
        Thu,  9 Mar 2023 14:33:45 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lxdax014203;
        Thu, 9 Mar 2023 22:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=T0ZFWsIIIYlq1z3p2EKUZTbxUrsbjFhpoba9Q3GZwgw=;
 b=I0GuwcjcnkvpqifwJZA0ZLd6SplvKHpVsUtaitTneMIvpwjrDOGENpJjET3QH+WM7vls
 Xgx2K+Cf60eda+KWLzIDnpnbUGaWcZhSJe5C4XgTj3LCnE7vDU2HYoTf7LZC9qYLqha7
 tQn7tqZr2PPwZNfywQMAxP+u+PgbC+zQHZKggV9TSC9VlAcxl254tAt4In8lOdcUAKyL
 APLEI62l4IRWHQcSV2+NesDAMMVXP6UJuy4f8EIZgtF0YnV5aFciNXOnvkkf1rVWg/sA
 fw54ipRDl2U+OkcI0cSJGVRM39zs76gMqz73kcS/djpPAkLsi1vyKrL0j6e/b1M4mIBX fg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418y436m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329M78Pd020848;
        Thu, 9 Mar 2023 22:33:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fua4rge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftioIQMI+WR/E1Nq7NiytqQSHpq5iOzK1P7xsKCowwjTnEolw/soFXKhQTBn7IeWCw/3AApWyCAUdtD1Hg1murAof7E5nA+o5Clqgfg+w9T06VwhUKeoVV+0kYjk3k3EdaUviURrtH6I0vpnv42Pb45Gz4LrDBrNpiQExEFPNCVHFUJxmOTAFEbNMWXypMjubCJI8R4mGg2UYsMZID06BwpH41oZdnx5INVW3R2nqgnnR83A8i3MKuPlzhl62Df0pVrN2CA35JPoQLjzZCaRU1mE9AqWSo0f4H3jwK8CflgC96T7eXkPue+2RYI98ca/Fi6r5MB6JDp/eqPClj/Inw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0ZFWsIIIYlq1z3p2EKUZTbxUrsbjFhpoba9Q3GZwgw=;
 b=ZZsUuE5A3Cid4wpy+UfMxKAEhCkO9qgfCtpXfe4b7LwgWn703rUP4xjAyFc5OIpiMbGpIAkE4ksMQglf9DJTr/xMHzgVhDxq9Q2se7yShVpy9d8WW3pVjAdRw1XHt7NT6cjyqPbbXMOcgMi/JNKZ6OiO/YxasiFbSo7gq7F32Tr09w6HUlvOqDLuoOMbfC5W83/PPpn9SxvSpcVRwuUSoFytTxu8XDcWI15UUU0WfrvtZqz/2p2gtbO7rL9EbNKLTxah70PbyZgUw7RxW0x33Nx7wMfzJvCghS44qGC5pRTRo0W7AKdk39KkP4YhieZBsOV9feO+wC729UqRlwAjqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0ZFWsIIIYlq1z3p2EKUZTbxUrsbjFhpoba9Q3GZwgw=;
 b=gF2ZpHEE2SfnXV3/64S4lFpnhZkQ67AOMIUgZjU/zcgpnG96iY/VAcr7g395de4cEfY+UpwhoLazOpt0jdhc2OZdxRkUZyo1Dxb1TeuTJ/fI5G7s6yOorFoG+1SHfuqpGMP1ovaUW6fukevtCsdpTdCpYzFNsUpwhebNY62iC7A=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Forza <forza@tnonline.net>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/18] scsi: target: iscsit: free cmds before session free
Date:   Thu,  9 Mar 2023 16:33:06 -0600
Message-Id: <20230309223312.94595-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:5:100::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: c0001b87-9347-405e-ae5c-08db20ee4fea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mu1I19GBNFplHhdVFRqazlMXerI+bReIafMU9kEwPEks97E5zqc7urKCX41afY/LVKNO3C4ZKFidX1+nZhLoq5R1cLzmdNy5KBhRQEVB+5Ccg27uwLYfo+c9lnOQvFVkPWFWleaG4eLcY9CdNetzxZ/Z3cFPbOBNHzvIRnxQZ3ifcdoyBLY9Bq1XAjbtgGiuhPDygotaY3z4hjbQpxK30S8fsJwXN3ufmYMOXjhkBMdVVLFyDmP0TACLWI0bXY4HUu6sygI0+3canIB4oNW0drK9Um7S79PcRHgxPvXrej3jH7oChmgoisXJQUvb4XKbHIDNY9tlPFYYI9Zm+3Q/mI4N9CAIi9/EqPCVxZ38pFNwaAWiAsW1x5O+NIqJG4JsEf1p+4OmNHWPbXFjfWSdmDwwNXUyg5Cypqzp3e8ljrVk5NwF08wT7O/PxqXzfFNvCjPz/nDcNZcTD7XrNrePvcIKhRUSV9jFf7YlWgzL9joLU8wjiGzvYcpWiNiQY0kZS6JPNw2X39mNwjTSP6mQA2Q74fUjeYr/f6uHo3zrwCCPQrPwrYMnc2ld/00YDN2wqO82ymaZAN2XHFIqCIGgoxoEKPJI2dY/qIvZpLyHutVKOYCPQ78ZG4Hz9E9wpqGpayjP9KUAUg8+VQbqgAHT3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(54906003)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FwQ1ToksX9XnqG9KWe4boW1gZE30mVu3Yf4nenMzG9W4c5W4I00dNsmateER?=
 =?us-ascii?Q?KBr4yRjinBEygazM5lIv3TTDOuI1YCpwG+3OKJ9lpQSIieE5/ulP9ZR9LUXB?=
 =?us-ascii?Q?YMmdGaT5ao9fX4xVuCaZe0bqTLY2OtvHhgTB0DTOvIcL+CqsJv0aIw0My8Zz?=
 =?us-ascii?Q?/YmJs9THBkcJvZoKhWFOfbTJxBZMGS0GGyR9vgYr0xoJSbFzxnqD9p5Amqyc?=
 =?us-ascii?Q?yCudi10U5Oa3tHW1+1a32/nwbHmoNkQ5OhZh0lPmUD7dqZFahcmTNvLN3vB3?=
 =?us-ascii?Q?7Xze5wMvM3vlm2+4mg72gBVM/FncOJIQX805UHRJSsxdOlKPfqxApPFol4ct?=
 =?us-ascii?Q?wBluXsrh0l9G4sST/TNLGHg/8rhQ6RkoIfagun0R/WJp8LViumLrcvgJXwbS?=
 =?us-ascii?Q?vi3SbinfZ8N8ZQ+7shGReOav5C+uRy69jizXOV1sFzKu97MfutpuPYfCAkvu?=
 =?us-ascii?Q?m8J/PEEYRio6KgpWS2cvfrHSYhX2gPqI8Z+dBetyClW/S56+6AU4lLS7XgL3?=
 =?us-ascii?Q?EDQX6UMjQyAkf5c/oUgX4dIad6VMqUQgYIwq7s86AS19R034DGS05EMLiXDR?=
 =?us-ascii?Q?Ml65zWcQHE5ktkD9D7/fwefEtRA8arKOhJsrhawzQ324/rdNH2Kx3uRkNY8l?=
 =?us-ascii?Q?dIsBYQnxUNjQwj4DPLKedApum8WVSNRknxrlMA75NSa/gj9Hvf2q17JKqZM0?=
 =?us-ascii?Q?SspEMfp8KOV00Bui6ix7czP5kt0z977w2j2yqihTJlqFjT07GogQ6SUsIXrp?=
 =?us-ascii?Q?kGiaNCt+eXuOUexX0FzNk3z0BoiHUTrf86CgIfl+yEsZlKz8CMjAJOxWTJL4?=
 =?us-ascii?Q?JqIwfvuf2HK97IOhrS8cHiuJiDfwmCmX41ziLPIDMtVme3A+047PcbXaq3JY?=
 =?us-ascii?Q?ms28GXvTp21UqAjunYzTU6Tz7hpOrJ+XglCmDnPyZLWKnqcDOyupJqvLVuNi?=
 =?us-ascii?Q?jKYq1wOUdJZ8O0U9xP/NQJVxIoOgifOOcmbHZxdzFDaSX/01zFGxUxsUK3zt?=
 =?us-ascii?Q?ajzcmX6+Pr9Lui+Mry5oXfvtG5tPCouoRrzJUYBQzCTSLWleELbxhCCR8tU7?=
 =?us-ascii?Q?A4tEVnn2df37iX0sPtxWZduzvRhP0Jo3n79iRzHGB6Qif0kNBwdWU3OGvEcI?=
 =?us-ascii?Q?TuNBfc1hYtQ0Apb86eAmNLIx5ghEDNV+JvFIiLBVqR86X68SuRWyo86dVkqK?=
 =?us-ascii?Q?Mj1rVE8ZSbjH9Crelg+VI2jTSN02G80PHW4zc2KjM63uBhgUBSG9H6vpTIYl?=
 =?us-ascii?Q?j07yieom8/KGzFcOi2BFmBJai1ZI/OySy4HvWJxv4Ss44T8KWHmIeUL3vyl2?=
 =?us-ascii?Q?pVWVC489wMii+iwK+dTTkqVaaroKnyUjENBF5Z6y3fhCkCHiofFTv4wpydqK?=
 =?us-ascii?Q?BrKAY5JWV9dDiADSJQQhMqTZSs2zl+BBWGl9qos1izoM/0LBC9erM1hWiGSL?=
 =?us-ascii?Q?SAOgMfKbNZIoX1M3YmHjUcYR6VIBy98czEHY8nCBf8E+APIZiq6f+YRadyeQ?=
 =?us-ascii?Q?kvMEbT2KO3onhxZHE7O/DRKN/WY1uA7FOWPb0dCLmTPemPMARYdmvOtJA9HH?=
 =?us-ascii?Q?Or9ZghjBOugMiVQ+6/nE4+IkZr890NHNkfyCmnr6wYZ7w4C+mdIG1l55HMUh?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5izjX17QxmJn8NEyx//sPNSyLpXa/HZQvmdjXVLaGrgP6FTNa38epM4fIEyze8bFjkutgHXtkij2x+5OE8GssYTLS7ZSBZMcKftYpSl0yqsUzD+kwTlEE0B/ztu6YWEGob8qqQqOb1QGOXQsBHzqFjkeKDtxZ/gNA1OrenKvN2K0szsG+bBa2rfV3+/KzpKhLzT2dpVZ5YvyBXBbyVJ0hKBCcmaXCKwE5dbceweaZ2buaJcjxkvtJLmb7tJ36lBJr92bJIT9A5nz/6R4Mi+3ZPo4l038vJDF9K4hpZVBgbk60IRj4pnWn0R34floxRK11lebzc4y5FdBH9J/SExWU0ng1WbJ+B2Zu5BRXx71ZuwvwOroEAXf+gknni33xnVgah7N1JR7QWjjkri+r5PUxVJeLvy5R9HCdHOrPaxQG0pH5q9SYbjJxynmW3G452oPlr4r1znggHFxqSVhklWovnIY/EXX+oSaa28SkldUg0bl+ioYozfr9cUzZiTMXvtrh71avE1RkGzsBtSdbY5LzRw0Uj2P4p1P5qYS3ohx5lYVby7Iy5IEHsKuqR6wmmVevoCFNIXghIEi9rOr+PWxDGGmVed/dT7QmzrGD8YLjCJJbmc9bv9/q78ATq2mWxYYMVxOYHgqoQRw2fSiojhe+L4hbRNZqoQtIWzeK+L7HpDjNKxWUB/Nx16MDAdBe5kviwSPKx5ULW14vVaOtW3NuPoUXigOPlUMBtM3FaLkuZdmgxJREoYuhVDhtgGMl75OM6722EF5N2g9+wHQ+MBVbETBg4X/IDkY2+h8WBkI5gXecgoa9c6LN81IaWKbh7ZykXQAKU+Yi6AdVv6lqDCSZj9Dcem5iBYJYsaivcFUuU31Sb6IA/n+RjFzZpTt53TkVtLWGN/C7DVpmdywO5NyAPClueFE6p+dbJ1jOmAMwts=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0001b87-9347-405e-ae5c-08db20ee4fea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:31.9548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQKGTVmhIojy+ABN7ERof/1gnVsP+dQwM6nJylpJv8KgnwC7I8UJAbWDc2P28sx4b5ZNHCxMqKo77/LbFEY1VwCqwlcBW8v+hRGss3Ds9+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090180
X-Proofpoint-GUID: QCzXNn0VEMhzi-da-aAXCemrG17SGaeS
X-Proofpoint-ORIG-GUID: QCzXNn0VEMhzi-da-aAXCemrG17SGaeS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

Commands from recovery entries are freed after its session has been
closed. That leads to use-after-free at command free or NPE with such
call trace:

Time2Retain timer expired for SID: 1, cleaning up iSCSI session.
BUG: kernel NULL pointer dereference, address: 0000000000000140
RIP: 0010:sbitmap_queue_clear+0x3a/0xa0
Call Trace:
 target_release_cmd_kref+0xd1/0x1f0 [target_core_mod]
 transport_generic_free_cmd+0xd1/0x180 [target_core_mod]
 iscsit_free_cmd+0x53/0xd0 [iscsi_target_mod]
 iscsit_free_connection_recovery_entries+0x29d/0x320 [iscsi_target_mod]
 iscsit_close_session+0x13a/0x140 [iscsi_target_mod]
 iscsit_check_post_dataout+0x440/0x440 [iscsi_target_mod]
 call_timer_fn+0x24/0x140

Move cleanup of recovery enrties to before session freeing.

Reported-by: Forza <forza@tnonline.net>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2e9c0d7b36a9..cd9ef668a054 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4546,6 +4546,9 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	if (sess->sess_ops->ErrorRecoveryLevel == 2)
+		iscsit_free_connection_recovery_entries(sess);
+
 	/*
 	 * transport_deregister_session_configfs() will clear the
 	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
@@ -4569,9 +4572,6 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 
 	transport_deregister_session(sess->se_sess);
 
-	if (sess->sess_ops->ErrorRecoveryLevel == 2)
-		iscsit_free_connection_recovery_entries(sess);
-
 	iscsit_free_all_ooo_cmdsns(sess);
 
 	spin_lock_bh(&se_tpg->session_lock);
-- 
2.31.1

