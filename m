Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269A7C5479D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbjALDJJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbjALDI5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4294883B;
        Wed, 11 Jan 2023 19:08:57 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C33V8s006199;
        Thu, 12 Jan 2023 03:08:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ayYhov2S2FhgBf6h2aTAseRP/uqX8wu3P57Ct2s1z0s=;
 b=Ucqm1T6kLZkVJLAvXzXbtIYUC0gaJYnbf82k1IWPQJvg7z7G3X2IIs8MbRbktytRV3/w
 HyOrHp7tPWfAJcaJekiiRoicJwNEGSF0EHiIeCekLee+dJ6zeRXeo1BRiLJgpfJUDoWj
 lU59yxF85rN09WY388N1orQqywkvs9jepIt55T7f2P20DdzErXdItrsm37E+FdRYAX1j
 6Lugs6cg/GdBoCuDxkwFzJTzADgxf0PkSaIUo7ToubRTggZPjwbkKwW89u4yP0J7hP3n
 /YxRhPcM8xKED96XYNt0LAgTaaoViiB7wLy6Kk3xmpJXpW4Birc+6KlPLPgSR7qtQSdI ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n25k7gah4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0f0YA034176;
        Thu, 12 Jan 2023 03:08:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxp5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiMt1nSzUxMHghb6ePSFr8WIDgu0pAtft+yODRP+c8mUqUNll93pc0vtGyRf1Rx3rnDylnws4b2TVYcTP3+wiFdiheur1qKuqbmL7+PEytpyWEBIODzVruAauKyIeKr8g4HS2iri5RIZXJsDkOgf7sEr1zPF/WbqxNuT37PjiA86QyP3jx+Jrd4YQyoqrQru+ZY0dxHjkze+KZ/dfNiwKaOHNtMKl3ZQJifznneXVxCb8YVG800Nm5MH/d2z+RCMHShlQTK2oN0awdp/TIge9Cy6Ln/Cq3KmybIbbjikzxrkgcOkZmxqpyuolM7iadPkravoRvx1pWXlpxvHKwn+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayYhov2S2FhgBf6h2aTAseRP/uqX8wu3P57Ct2s1z0s=;
 b=PrpPKaHz5y0i2S3gLZLggPWVvundXmZoR1CenadC+RHx2E/S83KWXEEYbIH9CU9hqz6j4dyHYXSY//Zbs8s63YomVGUWW8FmaioYZcHQDsluzhH/tqbV8ptMGWCBQgpS1UMGOgv6PwS2tvBzTCy3wnKE52+jc9GdWPmShxZMM3lKN6/Xy5deoDiGbeZwjyT/x7D0YiPqABRo0NKxxSUJlb9+fvC31s8F2OEI08cgpV4Et7cG7OceGIT/u5wqaiFIDKlgv9LR1zqyeMBr1May0VhvuD/wN9s2eI+5e6TaTJfYLDfYMAtp0ZIo+SL4VOopJK5hlLYm9hP2aURPhcsChA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayYhov2S2FhgBf6h2aTAseRP/uqX8wu3P57Ct2s1z0s=;
 b=WuEZ77pccC6DgIbWP/toapT9Ak7+AJEG4HIDMP8btGgtC5o9DMSP+rK5STzofxEFnolUj3pAr+FUvjv/pF5dhYDRVeVGugJB49y0Sh2BBv1AqgjSFmQNCVkZscK4/vJ45vUqtM1L43eMkM9lahnb5XAAzXZNtfoxk7lSdpn7xnQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 04/13] scsi: target: iscsit/isert: Alloc per conn cmd counter
Date:   Wed, 11 Jan 2023 21:08:23 -0600
Message-Id: <20230112030832.110143-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:610:59::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c833af1-0280-4ee7-59f7-08daf44a4f12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29Vd4DoXgTmj39k4PYhXobA6mdpg993mqIoD65/jk5HbExvfOT/Q6O6RFE0mqa3UiwFWDu3x4wMuqhVhMQ1yK09gvere6jG81JRmfALGmOw01BjSCWFoOPuG6Lj/Z9BjuQRMd5bwsSlAtzAShha025+5MSLuhTQeqojMWwFb2xazQwPGhslQ38ni2ikxu3ZdA4bMqBr0NOV3YXyDDIJ9ORWGgBmysnWn9XlXeXdZvXygu8Sc6V/L83YWTx1bDfIYoY/C0gucD7lvF7YGUkQUX2cBfY5QiprUdetlCYOGvq0rBm8BTYghKUt2LYm9Hu+JPwFJ9bnnAZKjH9RybDRne3gbZ6k2xzWoOWo9Ho9i5RCZmxKqAK7VO/HJw514sG9Z7XwRMlANwEEIFBpXJqq7v/7tGSVIPQPEgL07COmeOXRtvh6JyZRPoDN1b/lh/v/I4/HKFRpwuyiv0uzwboPD0yiZ+D01Ki1UrT4wtGKWUQfD3cQh5vCpFrJkbYxHW10XFuVTEEQjeQfx3fL0FRixleXPc9WKaQPFaPKI8RtEAhEpd9wbjZVuTFzbgQhyCU5GvXE3WshF19OJyK+z6uQD/sm616ryJa0Uxu8DmUhFKvsTfRhE3Sies+WJGGInJ8aYAu9TMygV11P9+gYaReuRkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N3EzBiUSO8IRmM7MeK2kHMCQ/17Xn6JZGbCJgZW/c0jAs7tFBQ8moDTH4/yZ?=
 =?us-ascii?Q?KCWY10GIta2Ytzk8ed7Z1WvLDpFWw+18U1Pv2jyqJ7ZtGCcqkVAJPihuFghB?=
 =?us-ascii?Q?0n+2mElDn8YNM1ok9m5S0hc8SrEeqQJCGgql29TYOzlkO/OkFmehjg2buevh?=
 =?us-ascii?Q?oi9NQr7eXGtobBtDGDwWUEKkQVPIBkdvqU89GNw+uXkHO1nXcFLNVDXcs8sK?=
 =?us-ascii?Q?upoSULdr7TrbZL9Txw8A5ATam1UJ4aa9/WKQxUs5HN5nfsvp5URHRKBLvlM0?=
 =?us-ascii?Q?7LbxjxyOguE4Mm41LZw15/I1LBulbNT1LHu+XovrWXUTK5fVkMbR8wSyw8JG?=
 =?us-ascii?Q?anaCiBiN96RVm0YmlQGBBjHzYsRJjPRY9Yquyb3uLgd0ChJ/LcwmFtDgyik8?=
 =?us-ascii?Q?IxBiJGpOGFUaAJZfgC9jlMWIaNehRKD3Ev84P9M5vExa25wQ2RZ2RennaRWl?=
 =?us-ascii?Q?IpeRx/2ranTGuCRcjtKSGBTEuSuOnG3vetHbZd3dmh9zQJF3dA+LwDWOkpZu?=
 =?us-ascii?Q?msbescvajAvum+uwr+lRqc2HeMvhm+F3f4SIWTL9KkomgdnPQ+f2KGO+/mr4?=
 =?us-ascii?Q?CLDaBB7hLg5IgOB4kZQiZhDRmaOVHXZIt6oNYGAtFbu5b7n88Ubk37DuY9c/?=
 =?us-ascii?Q?m3y5HYgsNDGZqlU+K+uhf3dxXT6MYSUUjGrxeDxhttAgfKDh1hi0JwWbEo1R?=
 =?us-ascii?Q?ptlU76OU45VmpMrzmRRgt0w7f2FGX00j0qjWBc0HvA/2d2oNqnSU8u4/mxRA?=
 =?us-ascii?Q?XsPBP1yxSqLIo5JM4S0t29hICzIOb08MnI/xkGNm9d0DvHKovwyMnqoZowC0?=
 =?us-ascii?Q?O7Mm6nZ6VYLPJo4lYMpeatwo4jCJrZLa+nCpijVnpodnZ3ZuyHoCrQHbXx8c?=
 =?us-ascii?Q?kIKJoodxsLXkyvkF1kziQk7gio7Gb+h9DO90B6Bs3944rUBVQb0z15ECwgCT?=
 =?us-ascii?Q?tk77ia6IKYLpT7wi1lSroyxq3aF97SneTjSwFx6xS3j2HlGJfNxMrEgzO2KL?=
 =?us-ascii?Q?FdVd7iGvXnpykf3uPEgEcr6X2NlGOsVAFFTx/F2HKAOAnmTCN4EpkBEXTN8G?=
 =?us-ascii?Q?mGDaoLttm+8daSnhvJn0e+4HUjFdyHD16Ruce5PbFxJTJXpvcqNV5rFMnr7m?=
 =?us-ascii?Q?NCTYyKNNyBHPRUys+/Bmv85dq0xSu0AEFj8ni/50v3Uc7clk8rPX6iWB+x+K?=
 =?us-ascii?Q?XpSa0cjlBnTtQeOGqiAtJ+XtOkV2IXpvMcopLZqpvTi2FGwS6fv9F/qvknN1?=
 =?us-ascii?Q?X/GCcYmCWGpz4QHlXT10SI8AEGcGUi+OpwiWd9J/ow17zC9hZNNrxnDBBhCf?=
 =?us-ascii?Q?Wd1zWYunP6Ps/91eJZmjhBdjt9pO9WIeLcyyHT3o7y0nQFUi3z5+V4YhEt/f?=
 =?us-ascii?Q?3qYN6R3HF4moWfTwhDli8MiPbRhI3dy5dbylyZNGgLJaASUOOV2ni07ZENZb?=
 =?us-ascii?Q?Df4eoxkLNj+RuAHrFMp++Dek8Ju2FNOXL2uQmNWjKfzNlidYUAfdRTxUao1w?=
 =?us-ascii?Q?yRpIp4IqPS9ei7P4pYMCEmzM8nVgrXxrP2Z4hH6D8Ni+/11VbvyakIeQjFC1?=
 =?us-ascii?Q?PM8Ewym50RNgwnR7XFxKmpEEP8x2EEVNepb3ZarTLRkiqS5jhbrbyGFCLL4y?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zN6dhtVQ6ma0aDQJemIldsw53N070GmtY7F31+vbE65w3m9n7sntKjAJC15u7V6iE0lwq/3Dv9d2XkeVBVpqtIBFrm0bMTuvKMFu1EzXOqBoLBNjtyMiATMw+yh6+G4PyCJcWEutgQDFaaPTdefBMD/CkNuv8pf87UApnIhLrXN1ayBBqxDHSTNj5x0yzZ0l/MHm00MCCvdfnvpxq1SG31eo5yUqJ2qxKNDpJ9VywRhdx5aNHwJ7jrC7r0ZEuwGcBysUWK7Hd/FxOwVdtBIAYA7tG766qNqX88KxoqjFWyX+BmeEOnfEqA0z58vp5CbP77Ml0C7gtcAYIXjbO3v12cY9ba4srTWXFeHdSjZ4xQ2Ne9DrceCA6ii6KAdATvErwOH0Qw109+ERjjmYcrQy+elPDn1hs9eFH+QPNDbpiWkx1slrWHSRVoKO3iLrnNaxc4+vasCwn4ZXD9Sjbs1dcXTpmqCY8lhX3yMDFKYaL0IsEODnAJeZP7LDZX7eONDaKSEqwRn3Q8j9h7IjYBEBe+NgWluttCdF2Lg/v63yp8K2dQL95mCo07Vq6MeGWvACFofd3VwDl0kDscNQyj8ddZdWUnqolqBTlVNsuuf5vNy8K7kBElXm05I/OnCcCPnNU9XkwsrkX+yRDK34LJFClL1TOi1rII253qcHyxLVsvvuh2FFOSwE5rpW+pP8BM4xAaoKk1O0pAQi4gmkPgCVisakPeq3gBhQdY2iU/kIfkU4ltYvsrHu6ppEUMUGyvbbXf6RMof/8CuxSuwsUm91AQXIldKEknfW3piitXG4IDrYhXjUShBFtVl5NpL9Fuvw/bxl3e/cX6jDib6fZCjPG+5PzmP1y1qmFlWKG6f5Cu8OSxw+yuQrRCpCE04pIf+f
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c833af1-0280-4ee7-59f7-08daf44a4f12
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:41.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xDsAurUxU0jn7fw/RtwcwgddnWfpCM8UY/nXiUpZ/0RETVhfwuODbDOc/sEyzwrBXdbEuSNuF9fvLekSGylazkJx+5nF4bLztmZahSCRCEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-GUID: gH8SwHJi-1WhH4Bwh8Fmt0uCxMIxdDQl
X-Proofpoint-ORIG-GUID: gH8SwHJi-1WhH4Bwh8Fmt0uCxMIxdDQl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has iscsit allocate a per conn cmd counter and converts iscsit/isert
to use it instead of the per session one.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c   |  4 ++--
 drivers/target/iscsi/iscsi_target.c       |  4 ++--
 drivers/target/iscsi/iscsi_target_login.c | 17 +++++++----------
 drivers/target/target_core_transport.c    |  9 ++++++---
 include/target/target_core_fabric.h       |  3 +++
 5 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 75404885cf98..f290cd49698e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2506,8 +2506,8 @@ isert_wait4cmds(struct iscsit_conn *conn)
 	isert_info("iscsit_conn %p\n", conn);
 
 	if (conn->sess) {
-		target_stop_session(conn->sess->se_sess);
-		target_wait_for_sess_cmds(conn->sess->se_sess);
+		target_stop_cmd_counter(conn->cmd_cnt);
+		target_wait_for_cmds(conn->cmd_cnt);
 	}
 }
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 87927a36f90d..11115c207844 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1193,7 +1193,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  conn->sess->se_sess, be32_to_cpu(hdr->data_length),
 			  cmd->data_direction, sam_task_attr,
 			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
-			  conn->sess->se_sess->cmd_cnt);
+			  conn->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2057,7 +2057,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
 			  scsilun_to_int(&hdr->lun),
-			  conn->sess->se_sess->cmd_cnt);
+			  conn->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 8ab6c0107d89..274bdd7845ca 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -324,18 +324,8 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_ops;
 	}
 
-	/*
-	 * This is temp for iser. It will be moved to per conn in later
-	 * patches for iscsi.
-	 */
-	sess->se_sess->cmd_cnt = target_alloc_cmd_counter();
-	if (!sess->se_sess->cmd_cnt)
-		goto free_se_sess;
-
 	return 0;
 
-free_se_sess:
-	transport_free_session(sess->se_sess);
 free_ops:
 	kfree(sess->sess_ops);
 free_id:
@@ -1157,8 +1147,14 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 		goto free_conn_cpumask;
 	}
 
+	conn->cmd_cnt = target_alloc_cmd_counter();
+	if (!conn->cmd_cnt)
+		goto free_conn_allowed_cpumask;
+
 	return conn;
 
+free_conn_allowed_cpumask:
+	free_cpumask_var(conn->allowed_cpumask);
 free_conn_cpumask:
 	free_cpumask_var(conn->conn_cpumask);
 free_conn_ops:
@@ -1172,6 +1168,7 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 
 void iscsit_free_conn(struct iscsit_conn *conn)
 {
+	target_free_cmd_counter(conn->cmd_cnt);
 	free_cpumask_var(conn->allowed_cpumask);
 	free_cpumask_var(conn->conn_cpumask);
 	kfree(conn->conn_ops);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c395606ab1a9..86adff2a86ed 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -254,7 +254,7 @@ struct target_cmd_counter *target_alloc_cmd_counter(void)
 }
 EXPORT_SYMBOL_GPL(target_alloc_cmd_counter);
 
-static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
 	/*
 	 * Drivers like loop do not call target_stop_session during session
@@ -265,6 +265,7 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 
 	percpu_ref_exit(&cmd_cnt->refcnt);
 }
+EXPORT_SYMBOL_GPL(target_free_cmd_counter);
 
 /**
  * transport_init_session - initialize a session object
@@ -3170,13 +3171,14 @@ static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
  * target_stop_cmd_counter - Stop new IO from being added to the counter.
  * @cmd_cnt: counter to stop
  */
-static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
+void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
 	pr_debug("Stopping command counter.\n");
 	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
 		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
 					    target_stop_cmd_counter_confirm);
 }
+EXPORT_SYMBOL_GPL(target_stop_cmd_counter);
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
@@ -3192,7 +3194,7 @@ EXPORT_SYMBOL(target_stop_session);
  * target_wait_for_cmds - Wait for outstanding cmds.
  * @cmd_cnt: counter to wait for active I/O for.
  */
-static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
+void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
@@ -3208,6 +3210,7 @@ static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+EXPORT_SYMBOL_GPL(target_wait_for_cmds);
 
 /**
  * target_wait_for_sess_cmds - Wait for outstanding commands
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d507e7885f17..b188b1e90e1e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,7 +133,10 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
+void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt);
+void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt);
 struct target_cmd_counter *target_alloc_cmd_counter(void);
+void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt);
 
 void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
-- 
2.31.1

