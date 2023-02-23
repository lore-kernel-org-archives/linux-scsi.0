Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569A7C678D5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 00:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjBWAUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 19:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbjBWAUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 19:20:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12F62313C;
        Wed, 22 Feb 2023 16:20:06 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MNp8q9007624;
        Thu, 23 Feb 2023 00:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=2mClXI10T8EIPeLA+eZAmowoCQbblUSf3AtG69qFTQ0=;
 b=dwGmn8g73uo/fRTXd/c3zcjvp0YTQWrSnvw0FUBfdbhYhEeDBq+ZAEzZ857Yt3L+3h9E
 d7ByHXtJfeUPFbq7Oa7Tok6R5DHN1NMPkIsZpXukK0U8VAE8siz6QqyAIvxQind8XfN9
 pkMZYxSMJa3JZtMpY5IaE5mKJIqGnnQTHV1LrO0q1TOzK9T9+i3BVnJMntW5z2/ghUMF
 L3OiassUKZ5yW+4avxo67Q9Vf8GCgKML6mZfCLotJgZGY8KJ5Hbmz+uVEB6zsQFPRE1j
 46SURJ6Tgd+BtTRdaqzXZ5WFHFRxE8Q+Mnwj+83le4of/kCld/nG4HqaaAzFhvAnP1xz 7Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9tsdqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31MMqpsV023257;
        Thu, 23 Feb 2023 00:20:02 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn47cj97-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOBgLZ+Q5iHZ7OMcCdm6wdJ42rQV12aKP96wEEo7Rrn/BxI97tF7BMsfm0vf/D2jTpRxCBIAKwL67Z1CDzKVwoN78tyn+MJMhjgyCbuvzDVm9aSDOGixozUS7559NlmW7CVXpdmWZdfkvYhmfdg1lI30cPLlFflKn3mN/5lgRzOyVNRvSbyUiYPBI9rCE8B/ecGIv0iuRDuI1mZ5GcKwiSjFJlZHrjfR+5XS8KWGXwNe9u7Rc2Jx25P9jSgQW87MNIsZh1VpoOnKjKau6LTA3zxCCBLeGyUmANxWq2ujF7dXbKcH50Zf9M1gptK4X5afqe3mhpSIp5EP1tDsaDSZWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mClXI10T8EIPeLA+eZAmowoCQbblUSf3AtG69qFTQ0=;
 b=RFrl3CxYIpGqa/ss5D0LfAnrLTmI89cKDNdgJSOPl+Pk5lkn0k6bRP8L6OMWGjTkajMtqLEq+LKnxdK0F6AjXIJvwjWyZnkdBYWtxNI1uqm6ZzlIKrXd/g66qQtbrfpnESRSzAjfiTdVGfYLQKeso/QQUb6HN7N/QKac/7F36bV9iG64tPzJQ8IbC4GdT/lUV+tZOmjzz++bQrkResr5ntKau65U1tJB4SV21DPIGvyNSIS/CPNGDAdcKu2g8Zy1/jvoZ7ViuEzgjAUeII9SvHBJNIcL8FNsII5FJVIuI1VP9RwEADs4hWS93UIHEtpvSTdOba8CJLJu9MKKE/Pxjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mClXI10T8EIPeLA+eZAmowoCQbblUSf3AtG69qFTQ0=;
 b=MYKZaO1A8exPS2tDvMq4k3gJdSNONMUmao9rIjc7wcmY0ZOfr1oZNHAdAAeBRjkV7kuOwmAIFnvQ7Q7YZGsmBJB3nBkVEjsw06xHhLfGaMOg4XjKDVjACkpDNkBGBUOcNP7WLoiMQJIX9MmeC5v1Uz52zt/eqlXz0Xpb3Lw1omU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5286.namprd10.prod.outlook.com (2603:10b6:408:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.6; Thu, 23 Feb
 2023 00:20:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 00:20:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/5] vhost-scsi: Hold tv_tpg_mutex when decrementing tv_tpg_vhost_count
Date:   Wed, 22 Feb 2023 18:19:45 -0600
Message-Id: <20230223001949.2884-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230223001949.2884-1-michael.christie@oracle.com>
References: <20230223001949.2884-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c5ab632-1a4e-479f-a78d-08db1533b39b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OvIiNLMdDcJ1VkiMsL0XEgOFuHab4o3l6HtbE5u9UBlR9LSEM2t1+ghrVpyqoKEq9u05gTRKdqTVem49I2gCZl3PSBAwdIDDzT1jO8myFOKIv1CVA4+cepRZYCUJITa2Gx5lE+QXqDlB3laDKnHVIK/6/zbe/1x6MfG2S85zod+rQj7S2saNpxkMyPa9KorxRc4pehv8pRCXln5we7YLk/jmhHgONlzmiuPv4sNDZaq1G6FRw+Dox24qpLfZ1Sbm4vv0iBNZ0zoFXXLvZ7Fpgb0HeVEekPhLTce+wtajV9CDKamgzNSifgDJDZU2PMt2/Tge9bh5uBtRqigmpqxc5D8eROAx5DOMvQjhoYmZEJw7oo9oQ4tEz0q1N14l4rLbIv6YcKPXFTomaMkKVpRd4MtXHpDY7qTXZrI6uQroAw7G+xplrR6bOFoB7xwPherOg+RUxMYVFFLlrpCxHZmcg7pqUV5FgM5usrsontwlf8ylKorR73WuUJQYMzJPLBhtW5nw3aI1Wb0RIJWEy25+OFKEEzHuCkV+qEWWUiODGbOfR2zr5cK4kxNqLKx3iTn1sfI4lCkbOxmGhysP5bBHK+Jda7Zu/FBfNI1DKhgFHal5NPG17E+Caf11VTGA+quDM0UTIzBsFlpB2UfCoECE6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199018)(5660300002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(8936002)(2616005)(26005)(186003)(1076003)(6506007)(6666004)(6512007)(2906002)(83380400001)(478600001)(36756003)(6486002)(107886003)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x6b+ZYYbcjb53PcSkrvaGrHPSQqH+A96w96zXU7Czcr3b72vcqNdOhssREr8?=
 =?us-ascii?Q?YrCDcqzcwDfy4hc3z7o/liXFRSjtTMQ5NUIEyFgYOOScS/czjTgfxnRbX20s?=
 =?us-ascii?Q?Snxn9M6IM7AElLtk5qzV2n5bbN95BhRqyR2rZcFoQdlzxFCB4lfB9nIcrxZh?=
 =?us-ascii?Q?7qhxHTMyvrdFLOz8iU3thpbBAcznzAg5jnZnGR5Wg68+sLduv7GV/8f87ZmG?=
 =?us-ascii?Q?1PSEJ6fLh4zxEcRXluaA1KSoRSPfBhw9klyTZHTIfFlApWivZTIhtjyGA2Sv?=
 =?us-ascii?Q?SQ4aiZld6WpWKM2MMkkK2AhCmGrCdS/bD5LEd+iyUP5Psdx0mQ5NQIkRXDgx?=
 =?us-ascii?Q?bNIyL13PIRL6gKuqo0+s+uI+r6EZcuPaip3ZPvbmXk6vK14qwgwVJeWvwVK7?=
 =?us-ascii?Q?FLJ6WBYD0MPFqQU+tRUbzQvOqmhcJGDeJhmImoEat5gcLVSHoAker+/+Go34?=
 =?us-ascii?Q?DSLMv5eSlUQaRbFRYPn8/gNJD5r5Ht78sevQTYXa7FkY/G71RabHz3t/LPXV?=
 =?us-ascii?Q?58wBHX5M7JnJq4dxWtbkrsvT5SBGFkowGMZBr9naI2V0c5VkXokNvwxC3McQ?=
 =?us-ascii?Q?fXT2yPUUGH4thVfJKpvdgL63LBIh48dYjlsas7c4I3+IcoptVe3k8WUZ6Ybt?=
 =?us-ascii?Q?91W3mZHAf1smUyfujY8ubv+qcIqXK4Zj5nsMv5kT1tAtD9/aEBuOKKPQ1sfU?=
 =?us-ascii?Q?1lb5usq90pnEWx4mA4BagvvaFuVDapfXCYgjLt2ucX56dYfz9VFZ7WWgdXnI?=
 =?us-ascii?Q?C4+PeACT2kwsvj0q8GSmFDqbub2jvrFUyv2GT3aJKKOCPUQaXce7UT/ETLei?=
 =?us-ascii?Q?QTMbHyprt4xPTAWjsxOuCW7N5iLLGNgT26kuvjehNuof+tKRsyD9rVyO2aOa?=
 =?us-ascii?Q?EDq3z3zTLhZYWUy8u8Aa5iAf3Ik8rnu3Ghp3rEbAcl0oHcMXt+TTAMN4r/uH?=
 =?us-ascii?Q?CiK5tjk4C3fJ8V1eVs1Qc3mcfiZ6cdWIw1N2hkCnZPCp5ATdkI71kElsmE0c?=
 =?us-ascii?Q?6H0vLECmyJ/Cl5ZHkRZssKoe7COxsmtGRSekxYt5f7Nr+3fnmKYD8rpZ/UQ0?=
 =?us-ascii?Q?+2I5zK/ZCAjpC6xTDmmH9JfxNpp8n3ytip30FCzXVgsYalg7aQFhX9TluLkZ?=
 =?us-ascii?Q?b3xKx6g9cwNEKnFbVFaKOQIQnB1q6TUGFV2OYOdu+4M3aIcbMh+xEZmKUPPG?=
 =?us-ascii?Q?8OMyPUOfCLtKtVsuzRJTaX7Fp7OpYWZmd7zacbQp/beObT4tA1AgBOQy9Xb+?=
 =?us-ascii?Q?YjjJXXO/uqDKzc++GKo4hFbOrvIlxtxbdxYDJDeNIWPI6sq/9Yp0vtCxHSik?=
 =?us-ascii?Q?U6IDEmCIQfyRLFPJ6SrZFOi1sEue9dnW9ytYJ3ZajMZsX9p05PJAx0qxzn8g?=
 =?us-ascii?Q?/qDBjxLr4izTKiXecdwfH/aRI+nd0acKtzBqVYT/igKSbHGnZ8uypAjMlWGo?=
 =?us-ascii?Q?8nh0jQLGrbRGAbBjMlodluH5S1dddmeBXLtWSRLfjOlLJ4VK8vexqcUVXgDv?=
 =?us-ascii?Q?3vidwEmncTX5r5TTJ2pgjq6MwRl6YPow4Gy/uJ/f/qDyUtna0v/Qxg4nlSSi?=
 =?us-ascii?Q?KHDSo4x2EaE5pJlTKq8CLCn8tPhWa57cXgKSrCYeb1Tzfa6cb1fS+KBrY8bP?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Sw2p1VtMEFmBVGwnk4SzT7K5Iqby7IBMkQHePqtYF3raTOtd0zUoQtVqJjJ1JVXXbjBQLwplA3F41rxCQNubH6ghIj7Ep6JR+hNKE9uDc3dLkMHloz4vBayi2W3TsZUd5dkw+1bqbvZl8lnSvGqUzqPqIdtkpzVww4xv3j0vmk8Mn0geJO6iX+s6bdYFdiFEPs332Khbs92QX24dmBFvnDO7do/uikoSceSsRgos9tbipYZJGBT58hCozWrHmIA/ddaRmDx9ug4Uw/qDTlQuxuYztXYrHZqKOKAHiNHw+GIrKIe2qUUDEnctdVMjtrCoxjh17aKvX3pATL58VSqYPOL6M4VTHyCCIbBeJcPpObipBga/BFcCC/axKF/Jw6QvY/0uPL3az59Tq6nNTwRU2Y6IgmBqeAtk2l85Lf/+jXqegDaC+wG8EbLMYUOvT6C1r1hM0IDCdwoc0MnFlK8p2lTmnfXeBhKpny2Rq54othIhu2KMA/lh/RCLv5MBae4kTz4CLRdUYwGv0osERHFL5Qwc9B8SP87jCwOa90JB2UGG1IafMZdmcK+EDW68znVYH0qWZ0/d/bGVvwabp9leGabelIDiPjk80hmclWiPFEAEyTc9vHh5SIyV9KJXM5h/Fqx3augg90jLzfgGbj3q9JYj5Noqnu/HeM5HsLQXLMddcHA2fq2BH7qieQAu2CW19/fzcQ42l5phJA4i6lXQnBZ/ATBjRtyku+VfTd/7sJdfyffQphsppGnQle+mdeFZVtwgVvA0tgpGew8PkOSCj3TnptdQO1wj7yPPUD9qBlfAyVBcWvpth3kC62tWEHZrozLn1Ux2G3gA6cmRT9BytV4EXiOjyh97gwCY5UUT4IU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c5ab632-1a4e-479f-a78d-08db1533b39b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 00:20:00.5457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qWRCbVdE6/T71Q71mL5cNt4/1sm169G2Dt03Han9iCWiiLYTkA35pY5G6lP/evnoFoVC/u7r6cjquYvEU8GpuWv0auyUy7yA3utsMUyMBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_11,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230001
X-Proofpoint-GUID: UOUf1BxVu9PYWdso4R-lqOdEvzy8MhHV
X-Proofpoint-ORIG-GUID: UOUf1BxVu9PYWdso4R-lqOdEvzy8MhHV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has us hold the tv_tpg_mutex when decrementing the
tv_tpg_vhost_count in vhost_scsi_set_endpoint's failure path. We
currently don't need to because we are holding the vhost_scsi_mutex and
the dev.mutex when incrementing/decrementing in the normal paths, and we
can't hit the tv_tpg_port_count check in vhost_scsi_drop_nexus during
this time because there is a nexus and we have a refcount to the tpg.

In the next patch we will change when we hold the vhost_scsi_mutex, so it's
not always held in set/clear endpoint and in the future we might change
the dev.mutex use, so this future proofs us.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d5ecb8876fc9..c31659aa5466 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1658,7 +1658,9 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
 		tpg = vs_tpg[i];
 		if (tpg) {
+			mutex_lock(&tpg->tv_tpg_mutex);
 			tpg->tv_tpg_vhost_count--;
+			mutex_unlock(&tpg->tv_tpg_mutex);
 			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
 		}
 	}
-- 
2.25.1

