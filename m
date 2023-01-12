Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264E2C67871
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbjALDIy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjALDIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160AF49146;
        Wed, 11 Jan 2023 19:08:49 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BNkJn3022348;
        Thu, 12 Jan 2023 03:08:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5ROmkP5rIIFt2Ere0yJ8TU8DhMzXjjhEh97DDZlwkWE=;
 b=nMKGmTHwsr0XiILU5A+CzIKb9Gof6YeEPsGnV78wBN23xXmFPqqORYjxNcKRCUgDmtNM
 6qQrPo4SPLwTRaVXGPfIWig18ugGN4aQNWoo4HEJx2WA76oQaj81F+/HJJ4+Z39XMisZ
 RoTZx9OpteYFlyPrbyNkZAr6VAkhi/yjLWxJJ+6se0inXDXjT7JCKC3TrfRV0fK6tHZl
 Ip6aOnRZt3f9U9MQBcyOOGnp+ZTldPern9J1dOPQ1IP0s3j+OsADpoovCfakID2fMrHY
 SLT+2dHBX1qDSHPPziGAs6Z3AJianLI0aWv9zyJzKi2Q2LyJm28S7XIjyVKnhF0ajgXB mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n1y1nhhpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C26qDH007539;
        Thu, 12 Jan 2023 03:08:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4bkwc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaweiITDq+UrMKN3/IJ0u2AFO6MXar6TOfd+j27bb0saGIKDS9bXZyoVQZj0kmSLiD6Knj7yfiZJEqFqtFAdwDKrm0U8vlPSirVsBmTP7vOhNh6FrxPt4bOKhewh7EMFU8vv+pZ3tuIbY+hZcAtS374ttNsvXcnsNh/gX0LXnzbc0JAxXA1hQqUE9Hk5rGGhQiNhkdDBoTvQ1EveNSurAh5bauDpPeAewF26FWCjqcX0HS9ovLtOyc8ONm7UYfOzY3y2GF7un6evgeR6AKUIe+Ifu7NPnmLzdV+PvNLM1fwy5NsLTr9djP94f9b7fTutVdvwffayp/AMxoqhRWhdWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ROmkP5rIIFt2Ere0yJ8TU8DhMzXjjhEh97DDZlwkWE=;
 b=nzVTtXS0rbvCWYCzqw+ukui6GxaeAYZoOP198uOp3bMill54na1mMGawm4zHLE+Vq/0C6jpwWTGjwIOES0p6fChLcrGYQKes1TfIsrx5QOfTvGEbxVTuNZhJehATWvSNi4nh6IY2lXrYcqpJJ4W8elNO+FGsONoh9nQl4J0TZKHZgher63JSKqQv4QN5sIwalbyPkLkG8QRk2D6CzH0PqjjJm4C3HnuIpdTZVYiLIeP6glY5CQoMu0gJ5lbN45wUJh4Qwz3TOqIr+fSxL/2yCSVfRTUeoVtSiWh5VKoDn3GFPBwVmOFAJQDCm+/vHTRBkJc+NfO86hpxmUjTmMZwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ROmkP5rIIFt2Ere0yJ8TU8DhMzXjjhEh97DDZlwkWE=;
 b=MweQvHEOEyufxoBcSEBe2Ie97vBP7F7y20akHmVVu+OcnbvYJJww+0Nzr9Pd31GSSzdah6LaJKD1MsPQG5IctXKQ03vV/n5+0M6Cq0jwnwCixCQOM9xPhUJeC5kgOuNYp3nJDsbZMnPKh4hXOwngceF7PfiQzE8nNgcKmcJCTGA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 01/13] scsi: target: Move sess cmd counter to new struct
Date:   Wed, 11 Jan 2023 21:08:20 -0600
Message-Id: <20230112030832.110143-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:610:119::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 852fd21d-75d4-4fe7-4e7a-08daf44a4c4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+fd3Mtw5tqD58z7jfgEis7M0wfCtIsvU3IyXpzfAFYrAbuF+VbzFWwSEOL+Cx4RfPNXzqYwec/1mDwZSvvJQlTO0f175CyKJOc88UspO13RZgsx1Tdc7boc1HBOPwUTTRSFs7gIuE2SrBO6fe7qEz4ZXNu2v0Q9JIW7sJG4Km4/KQKWWOGQxM6qnLF3yFdG6CsQPOU+mFufBWtIuQJzXYS+Dj2cNi8Q40OvlHhVxyjAkNbryRIXgiCh79o5a84GN84EGuhlpDiiqNpaDq3boiZOK23dbuEz0L1AOvu1FCt5celyMN4d5lwpbNZWRLR6TESmCxQAahUL9wrEptiO763knLVsHljhHDhGIu6qmB+D54dOUq4mtEs9HpKzk6l1FyvHzwdzOUo9KnV5WJdKRF8//UgqBvwf/EzHNBbVT9NOk/pbT+fjC7psaIox6t8IPVafEtkIIST8PXMOPmR+ukcswsGrxM/0MnTOmukMgJWr12/6hzXgkmhhgIHXClao1FRFZnedBLC82mtLo+8uQYrBlfe5FxdSl2FK2Ktm+fEIhBcPyhONuf4nbH0ME26FFoBvVr581Q7MLtAb+58SwFC0crG4sgLSi2psBYU+FYTQHhOzVeCulaNeNvuyjP9shRGjz+2Z9WF2IkhWHqeqWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nUrDZ/L9edr+lYbl2R0bqxjia9zs1Wzd3V64onMKm9QA1WOH64G5Ut4ijGy6?=
 =?us-ascii?Q?JVFuQbYEakBvs9OAXpSfFOmee4a9GPNJmSgMMCLOKAsT7lw3d2xnbBrJmU1J?=
 =?us-ascii?Q?1ug3QV1xbg+LQU2TncJ/otVHAw0KaoWiLo5Oda4jljk1nl4IHhPwVZBr6FVQ?=
 =?us-ascii?Q?2PD4NxHZORcQr6f9JPkEOl8GOsz3pEITsHEi+Jf2LCzG5FVUOrjnrAFCa7BI?=
 =?us-ascii?Q?7E86Uik/rHxW3NJWCTT1TA7CY6kBc3zxzc8EBMaKla6UhncCjjwLiRO4wcQE?=
 =?us-ascii?Q?3Or/bvy4ECawBATioPIRjyyvuc553hyeDozw1uGSoubgmBW9Rv2OxRJohoxH?=
 =?us-ascii?Q?yP+ivg6GARFcVkvYt4eN8r4Tak/Kr4ETc5iY0qY6exWU58wK+lFN0m/IPpc6?=
 =?us-ascii?Q?N2BS5zgqbwjNgGqL7y1k3+6FdBkBVovVEYn0VUB5zy+AzzlpgTo2M5dqV/j6?=
 =?us-ascii?Q?MGtytSmHrX+BGoEfZzK8/Ai6nLypklUDOrVn9G//ncyTFgQ/St9iIfKPcy4+?=
 =?us-ascii?Q?YJwbCgtRt2WKGepbeTWUrV33n61nx6jchyx97688oviakigVhz022r9I5+/i?=
 =?us-ascii?Q?Ly9C5YUkXynyh6POtTbs7jCNcnX8kpegMokvNyVjs77aTwlhq3pho9tR7avx?=
 =?us-ascii?Q?hUF++Yn8agLQccLX4UU8tkECfFqdq1Ac8EM8cRdSgRQLjIiOJ4EIbGwvL2ot?=
 =?us-ascii?Q?YD5W+BIi5K1Gp1YicILRF5nJ90G1Jfav6YPqEYuWdpalfzyAOBdoLnKWYJ0T?=
 =?us-ascii?Q?6XtEGE08cWTvwnqK3LIsE9d3ihmNLrXAyJtwlHi9fqrJQlnqotNGppvdHbj1?=
 =?us-ascii?Q?Cnv2JpIsEIS9gE+UoResSr+/BJnG/hFahNQA2HZ3/QEchVB4lovbZpaV0Z2R?=
 =?us-ascii?Q?fjj5WW3G1kCBpvII/dslk6sadWNt87poWkqR2P29ncErZMugguCsZtmjbdy4?=
 =?us-ascii?Q?xFqKASZ0Mt/KuV1xkwRGKuNOpJBQQhEdxRXJO4r0pu1EzM2Sv4VIcbILeTOi?=
 =?us-ascii?Q?QHRkrAUjMF/38+OMEOKV0oM2jgYdShd5iA6n34OTleP7zeLJavSNoMXla9Fw?=
 =?us-ascii?Q?OGBZQ/SD5sNTG8EnFStfcPoxD2iTxe36V9C68A5g0hBrOhNGlMszWSrHmBWA?=
 =?us-ascii?Q?YWjhW0otGa1RBmB+9L5eBGyH7jtGu4PRMietbBOcL5uNJNYs74buCpfUHxps?=
 =?us-ascii?Q?NMPFklEgP5J9pf61DedpGmI1ctbainnA3Saw8E6uDn0WGMF9piQTxLK/KGUj?=
 =?us-ascii?Q?vSC54OqJm2RG67dC8dPePdH5lxIZQ2g8oFLrSn7B7grpfjVxIKKlPv2QJJg+?=
 =?us-ascii?Q?EXiIAVA3Sde5PF8LPnJINRKyi4IVCZ0IImhBIuq/LwCkHFnEPzPH/RUXo0qd?=
 =?us-ascii?Q?nvvJcryqQHOaE8az/DY4Qjz10cRjpcLwkyKis1Uizj+QyiHScB8wcGv/kUSa?=
 =?us-ascii?Q?ExH0WeBRlzTWlTJWANhnRm4eA0LV9gocIoMW3YCcsAGPXysyaPg+D18WH57k?=
 =?us-ascii?Q?LY2i80O1JUpv/XUGcCJKytmvqyIKASnqx2GTfWgmY44RihmCg3crawRqAOgl?=
 =?us-ascii?Q?/0woALU1sjqG3u7UnnMe/GhtO00lwEfZuPqvNeY5MSwcWlV9sam1/QVnCGnM?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xEyacuDQdRmAQXL9taSWvBA+OfzGVy0HKrBwnPDZzuFxqlew+GSidD1oN+I9R56glANJm8zdhdM8fX9ncd7YtHdAJwS5U13PpfaJ2ObifHp9tsR1E4ObQ+58i/6eEhQzuDYMuO68L9XAJ0U62+PZqZc9cAQzz9JGM3f5TVVFYXnSjhcxvh+CWfbqgG0+40BxJ/psO/FWmVWBYi6dpa5bMee140RHaidCjzgDCBrWVaDcG6lcpbdC0j/NRmTG5VhqtBftz/sKNLie8hsEA03Ad++FcBC5KnEdpDve+z6Lf45FyVFamugzhdJ2jh/htQ1rUtYMldBfiSQNqQ39R3G+ypwl2JzRxBBlHHNmi+zmp7iUb+4d7Bzt3/WqTGDdgMHRVieelJVShVBLNdIfr0upTPBz7NGvon+IjRSn43eLgz5VmIHvpW4/hsXyqu3rZGH/L1c2Mk3fhu4hv2ztN92VnG5/SVWvTzQKJcHlPpeaQIy9wuf4pWA4HDnllXkKWYB8qJi6WbubQV0OlAgBExt8TYcoFd9DiM0vghS5FpnlNzT8ytIlo84q/xEhgBax7a25GSOkKMuByKZ4qSLRtkvBQEiInKjm3tUPSD7Ks7uBlslgoVDxKeKB5mfzDhCI1PCOLnaod+2LRTdAvBBzTTQ0QJjoRExxTt8OkHotURuAdmvy+2XRKpimtSn6UlFUsg/If+vCSWrso1c+A/VLtL7HpxCU6C1uoXDLjhfICNkABxzomS+rh5Y7BePOb6FyEtH8BiQwjMPn2qx7EfQgdF2Pt3vdAQGgC5erLzwm1jnEkvNblfVSrsQl+SmJSCn84k5d9ZthJMela7U9iZNAPjLO747sLBii2iDwI2PiVEJzBX5o3GApzENvmf1ZSGYv7RV+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852fd21d-75d4-4fe7-4e7a-08daf44a4c4e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:37.3491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIEzOAaSVFQ5y/QFZBozeNcL6oJFEZmCfy5mfCcmcwRDJaAqssUfiRAD+wdwzVQbH6tzxe3qxap3l6zqpQ7RrkMmsQzXvZGFfWnkPhMKSkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120019
X-Proofpoint-GUID: 7s13glwkV4Op3RLSbIn3oBCVk1MhmHf2
X-Proofpoint-ORIG-GUID: 7s13glwkV4Op3RLSbIn3oBCVk1MhmHf2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to wait on outstanding commands like how srp and the FC/fcoe
drivers do. It can't use target_stop_session because for MCS support we
can't stop the entire session during recovery because if other connections
are ok then we want to be able to continue to execute IO on them.

This patch moves the per session cmd counters to a new struct, so iSCSI
can allocate it per connection. The xcopy code can also just not allocate
it in the future since it doesn't need to track commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_tpg.c         |   2 +-
 drivers/target/target_core_transport.c   | 135 ++++++++++++++++-------
 include/target/iscsi/iscsi_target_core.h |   1 +
 include/target/target_core_base.h        |  13 ++-
 4 files changed, 107 insertions(+), 44 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..8ebccdbd94f0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -328,7 +328,7 @@ static void target_shutdown_sessions(struct se_node_acl *acl)
 restart:
 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
 	list_for_each_entry(sess, &acl->acl_sess_list, sess_acl_list) {
-		if (atomic_read(&sess->stopped))
+		if (sess->cmd_cnt && atomic_read(&sess->cmd_cnt->stopped))
 			continue;
 
 		list_del_init(&sess->sess_acl_list);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5926316252eb..3d6034f00dcd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -220,11 +220,49 @@ void transport_subsystem_check_init(void)
 	sub_api_initialized = 1;
 }
 
-static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
+static void target_release_cmd_refcnt(struct percpu_ref *ref)
 {
-	struct se_session *sess = container_of(ref, typeof(*sess), cmd_count);
+	struct target_cmd_counter *cmd_cnt  = container_of(ref,
+							   typeof(*cmd_cnt),
+							   refcnt);
+	wake_up(&cmd_cnt->refcnt_wq);
+}
+
+static struct target_cmd_counter *target_alloc_cmd_counter(void)
+{
+	struct target_cmd_counter *cmd_cnt;
+	int rc;
+
+	cmd_cnt = kzalloc(sizeof(*cmd_cnt), GFP_KERNEL);
+	if (!cmd_cnt)
+		return NULL;
 
-	wake_up(&sess->cmd_count_wq);
+	init_completion(&cmd_cnt->stop_done);
+	init_waitqueue_head(&cmd_cnt->refcnt_wq);
+	atomic_set(&cmd_cnt->stopped, 0);
+
+	rc = percpu_ref_init(&cmd_cnt->refcnt, target_release_cmd_refcnt, 0,
+			     GFP_KERNEL);
+	if (rc)
+		goto free_cmd_cnt;
+
+	return cmd_cnt;
+
+free_cmd_cnt:
+	kfree(cmd_cnt);
+	return NULL;
+}
+
+static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+{
+	/*
+	 * Drivers like loop do not call target_stop_session during session
+	 * shutdown so we have to drop the ref taken at init time here.
+	 */
+	if (!atomic_read(&cmd_cnt->stopped))
+		percpu_ref_put(&cmd_cnt->refcnt);
+
+	percpu_ref_exit(&cmd_cnt->refcnt);
 }
 
 /**
@@ -238,25 +276,17 @@ int transport_init_session(struct se_session *se_sess)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	init_waitqueue_head(&se_sess->cmd_count_wq);
-	init_completion(&se_sess->stop_done);
-	atomic_set(&se_sess->stopped, 0);
-	return percpu_ref_init(&se_sess->cmd_count,
-			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
+	se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!se_sess->cmd_cnt)
+		return -ENOMEM;
+
+	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
-	/*
-	 * Drivers like iscsi and loop do not call target_stop_session
-	 * during session shutdown so we have to drop the ref taken at init
-	 * time here.
-	 */
-	if (!atomic_read(&se_sess->stopped))
-		percpu_ref_put(&se_sess->cmd_count);
-
-	percpu_ref_exit(&se_sess->cmd_count);
+	target_free_cmd_counter(se_sess->cmd_cnt);
 }
 
 /**
@@ -2970,9 +3000,16 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
 	}
 
-	if (!percpu_ref_tryget_live(&se_sess->cmd_count))
-		ret = -ESHUTDOWN;
-
+	/*
+	 * Users like xcopy do not use counters since they never do a stop
+	 * and wait.
+	 */
+	if (se_sess->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+			ret = -ESHUTDOWN;
+		else
+			se_cmd->cmd_cnt = se_sess->cmd_cnt;
+	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
 
@@ -2993,7 +3030,7 @@ static void target_free_cmd_mem(struct se_cmd *cmd)
 static void target_release_cmd_kref(struct kref *kref)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
-	struct se_session *se_sess = se_cmd->se_sess;
+	struct target_cmd_counter *cmd_cnt = se_cmd->cmd_cnt;
 	struct completion *free_compl = se_cmd->free_compl;
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 
@@ -3004,7 +3041,8 @@ static void target_release_cmd_kref(struct kref *kref)
 	if (abrt_compl)
 		complete(abrt_compl);
 
-	percpu_ref_put(&se_sess->cmd_count);
+	if (cmd_cnt)
+		percpu_ref_put(&cmd_cnt->refcnt);
 }
 
 /**
@@ -3123,46 +3161,65 @@ void target_show_cmd(const char *pfx, struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(target_show_cmd);
 
-static void target_stop_session_confirm(struct percpu_ref *ref)
+static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
+{
+	struct target_cmd_counter *cmd_cnt = container_of(ref,
+						struct target_cmd_counter,
+						refcnt);
+	complete_all(&cmd_cnt->stop_done);
+}
+
+/**
+ * target_stop_cmd_counter - Stop new IO from being added to the counter.
+ * @cmd_cnt: counter to stop
+ */
+static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
-	struct se_session *se_sess = container_of(ref, struct se_session,
-						  cmd_count);
-	complete_all(&se_sess->stop_done);
+	pr_debug("Stopping command counter.\n");
+	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
+		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
+					    target_stop_cmd_counter_confirm);
 }
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
- * @se_sess:    session to stop
+ * @se_sess: session to stop
  */
 void target_stop_session(struct se_session *se_sess)
 {
-	pr_debug("Stopping session queue.\n");
-	if (atomic_cmpxchg(&se_sess->stopped, 0, 1) == 0)
-		percpu_ref_kill_and_confirm(&se_sess->cmd_count,
-					    target_stop_session_confirm);
+	target_stop_cmd_counter(se_sess->cmd_cnt);
 }
 EXPORT_SYMBOL(target_stop_session);
 
 /**
- * target_wait_for_sess_cmds - Wait for outstanding commands
- * @se_sess:    session to wait for active I/O
+ * target_wait_for_cmds - Wait for outstanding cmds.
+ * @cmd_cnt: counter to wait for active I/O for.
  */
-void target_wait_for_sess_cmds(struct se_session *se_sess)
+static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
-	WARN_ON_ONCE(!atomic_read(&se_sess->stopped));
+	WARN_ON_ONCE(!atomic_read(&cmd_cnt->stopped));
 
 	do {
 		pr_debug("Waiting for running cmds to complete.\n");
-		ret = wait_event_timeout(se_sess->cmd_count_wq,
-				percpu_ref_is_zero(&se_sess->cmd_count),
-				180 * HZ);
+		ret = wait_event_timeout(cmd_cnt->refcnt_wq,
+					 percpu_ref_is_zero(&cmd_cnt->refcnt),
+					 180 * HZ);
 	} while (ret <= 0);
 
-	wait_for_completion(&se_sess->stop_done);
+	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+
+/**
+ * target_wait_for_sess_cmds - Wait for outstanding commands
+ * @se_sess: session to wait for active I/O
+ */
+void target_wait_for_sess_cmds(struct se_session *se_sess)
+{
+	target_wait_for_cmds(se_sess->cmd_cnt);
+}
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
 /*
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 94d06ddfd80a..229118156a1f 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -600,6 +600,7 @@ struct iscsit_conn {
 	struct iscsi_tpg_np	*tpg_np;
 	/* Pointer to parent session */
 	struct iscsit_session	*sess;
+	struct target_cmd_counter *cmd_cnt;
 	int			bitmap_id;
 	int			rx_thread_active;
 	struct task_struct	*rx_thread;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..bd299790e99c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -494,6 +494,7 @@ struct se_cmd {
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
+	struct target_cmd_counter *cmd_cnt;
 	struct se_tmr_req	*se_tmr_req;
 	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
@@ -619,22 +620,26 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 			acl_fabric_stat_group);
 }
 
-struct se_session {
+struct target_cmd_counter {
+	struct percpu_ref	refcnt;
+	wait_queue_head_t	refcnt_wq;
+	struct completion	stop_done;
 	atomic_t		stopped;
+};
+
+struct se_session {
 	u64			sess_bin_isid;
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
-	struct percpu_ref	cmd_count;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	spinlock_t		sess_cmd_lock;
-	wait_queue_head_t	cmd_count_wq;
-	struct completion	stop_done;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	struct target_cmd_counter *cmd_cnt;
 };
 
 struct se_device;
-- 
2.31.1

