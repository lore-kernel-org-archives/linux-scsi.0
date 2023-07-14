Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75839C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjGNVeh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjGNVef (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:34:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04A73585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:34:34 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4ciu015000;
        Fri, 14 Jul 2023 21:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=+Xk6AFBtZb4v86xDSnKHhUr3SXxNU59+woQv9SSypJ0=;
 b=PUm+JrjvhMb+HMil3KQ1lrrJd5cO93iZatK6GLhrzTVwCiDwBzaWZZmKiOB3/MQH3I/U
 96NGe6DvwFC+S7os+jiPfKhdrCrb9vXqgBt+P7NRA6S0YRlUK/ADGCp5DORoZ06vJau1
 3DyD9OUi5DrUaJuP3MEvgWPAnERjwM6O25fO5eNJRBc+z822hHpWRIVn0amMnDkQXtaP
 7PLu3bduQQQb1gFuDbRNkZCzhgOtOFiRGfV5jk+pVG5k8XzjApB0a7+e02mSVQGL8Rci
 fx3Bo/qyS8JWg/UsxGOYfQITtAgOmDxR5KMsHxwQG84nhrjRo0bVwV2HovHO5Xz5RuL1 Lg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptx2f5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJoXZP027397;
        Fri, 14 Jul 2023 21:34:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvyh6fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bk37bM7RZAyaoK83igksU1H8J3oVGGwu1k+2ZzIT+cqkWK8dD46YdOIwozSnGLd9cpaZGePXpiXKmNa4ruCu2Yyz0aCj4KYzTpnll3kYArShP5Km4B0kkizLjdkUpP5dNeOqoD8Anwtj54QM+4DqVOuTDExW1ZncoBVfGO9o4gbvYmnu805+QhgNE0GhYK6rLmQnJIn6PMYhxtc8NXQoAFIpNpjxq+9abMpPpsvDgpfomrF4AuxHAHWuO8MICo2IoZCoPJ+I/aRZ35LTP65n927XpMiDpChFKGig7YbSfjC8735cRQlGlW/ECsFdd8XdA6nc62ivjNWWxpzfmjC2Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Xk6AFBtZb4v86xDSnKHhUr3SXxNU59+woQv9SSypJ0=;
 b=ealqDNkBPrX1Wfdyi06O51zelezO0ZuxdY1MRfL9J9vycM9MgyCM249hsxOOgwDuLYr+hHCbSKYCk6QrujqWBhF+OBh+vMrp8VkTGmvITAMopS1+4k2XFbaULjF51FxkoIz3j/sqCOdFROlRf3aazNRjrMQMKfk0wsPnA8bmjwKHnjlj1Wn8uz7VL7ii3tnntzwLaydR+iXv90+H8TAXAPakrCUK5jEd8L+QmAuB/YWxnh/FZhVLK5X/Jsk2jQcFzH0Ad3ToE55VJEiUD9vgUxa8prmLSleGScXk+FPtPMflD/sODqf2oxr8KJvcZVHC0gz+SBvS7g4Xm2liWhSrNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Xk6AFBtZb4v86xDSnKHhUr3SXxNU59+woQv9SSypJ0=;
 b=IUCgZjsdMGysc8r7Fwf0jUyP/Cl1mFiDe7Vkj6ObXKweBJg2+a36bIuHtYwiziwAsiAYupkLXwCqOV9SfjlkQgirrsDblPIyqO+OU4rcSwAmKdPSHDIsDhTmqdQsQOBdxW9897feH1U7mG3C2dtjz7vWBVjvySdHZf4R84X4i/A=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:24 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 01/33] scsi: Add helper to prep sense during error handling
Date:   Fri, 14 Jul 2023 16:33:47 -0500
Message-Id: <20230714213419.95492-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0119.namprd07.prod.outlook.com
 (2603:10b6:4:ae::48) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fccba15-f470-4530-160b-08db84b217ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JFZoWwDAtOQhwA3zeoDyOZFklRl/CCrBg3twRNBCQNwtyjeVYncw0EtorAEjqWfbgkbYTXc2J0DscCwO/i6MZlyTwthOoxy9Bz7AAn9hKZAeyaEssECXetXGKj52+ocsc4nzqn0NEbHOeKYuYpocWr/ATMoU8vf6CFaHFO5FEAT1dbhJ9zmxg5pED4oi79MZWNv9j5eTx9xz4+oFJ3cdkKzQTPDXf5QsfsSM0GwYwRdSZ6emoNOzi+xsZJzd6se2rxHF0NDCdyZ2NVBeuzqlaL7uI94W7gm8B4y0kTCuCrSNkHm9zugf94RobkN1iyqR3pxjXHkEKNw9YPIAyFQpz8J1s74KqbojNxgd11c5LBmk04j4K36JGbyjEHl06YBZv7G57EL8kc/WoB56BxR87wKUfFhqVsQnNpZ8xzj+XenSmDzl8brkM2yh96Id5Ot5bmNl3YRkWwxSOs04gWS/KAxBOTjcy4xc1uIn03IYnnsEMDiWSgd1cxtJUxNYjhJ+QpqhRZuDmJo1C6Z/QRPTWTVFsKehRD+IuVuzxRWLTVNs8Q+0z26qDdz8NiwLC0r9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0DS4RIk1IKaWSuYo7gn67le4uub0RsoYiwNADnjVx89THSQuNwmsFicKar83?=
 =?us-ascii?Q?EIAEIJJCg94+mMM5mzxF8TfZ2aRnw2KekmhRwPAOGSDsfH2cCjaAuEBoVgTq?=
 =?us-ascii?Q?INj/VMWopK7dKnpHj/7W0qN2mvXsynF4tXb6PAU1QmpXHk+Oa9sAC5q/Uldz?=
 =?us-ascii?Q?ZrWRgqgcLzGR1R1IFlyuFwSF/6eR89xZe3ofT2OO1i+04v13EAeljfhJfuW3?=
 =?us-ascii?Q?ACYGkFAwb8/in75fJpsmeFLHQH5X4IMvBYLRy2lI1Jo+mP860C/yEj/Q4sPh?=
 =?us-ascii?Q?1FwdzjWlPR7lIE1aF/BNRwhy2OXT8rYTjx1y05MObwU2o/Bzl8bVb7I2zKQO?=
 =?us-ascii?Q?vMPMZmqc8WhNgiQFM85PMNZGrmHmLxEYRkrc6mK2VSybQorkF4ldfvMieCoD?=
 =?us-ascii?Q?/y5H1SS1V0UOmJQf+ZE/HiG0Iz39lEC4BxO+rRsSaKwEYE2sD88sIfNeO4sS?=
 =?us-ascii?Q?ptV3G7bUlzpp49J2Ya/o0GqtXA6nYeYLLOXI1fXe9kweYcB7vEHYuTj8Xaja?=
 =?us-ascii?Q?WRtMKDjTJqhXmJS2qV6FODyfRVa3bJYc6DHwo0DHDjX7zQ8bha1UaoEXu7hI?=
 =?us-ascii?Q?psSJXtWOM7IU6gD0lTcWXLrW/1CbxcFzcrxFyiF+ULdVRxYSBOSCaBy7Jd8i?=
 =?us-ascii?Q?NH/XGidsiNu0pARTmAuEd3Sb7dbAWhFLs8u7XILc8OCbsGgVUFD3Gx34HLHi?=
 =?us-ascii?Q?tvEfL0oBYHytoBfFhvHEWtj6d8WLeGx+YJOgqwR90iOZDDW31er86uvHuUij?=
 =?us-ascii?Q?AidLiNXmgoFj6Ca3hnUVVHQSuz+XFuu7lVS9bdkIfKUx+p1ebi8O0sF/JFpa?=
 =?us-ascii?Q?LYlR4yRJ3mft/f55A+qHQOQUnDSjjWVuOZ6P9fRx4q8kuHs8qtHBeoWpSs/E?=
 =?us-ascii?Q?cBJTnzZeyr1+bIyfIwtMFywEIPXUywt8v38tbwlu27G11//4YXvfLWQFhL68?=
 =?us-ascii?Q?miOVWXekOw6K60cql6uHpd1ghesmLW7/krZdF8ZGpJgI9lWDQluM8Ndc9Dqp?=
 =?us-ascii?Q?A0w+SgJ3Wm5U9CItjLwXntiufieCKB+iofZeu1scgyHCP62igxV6RfmNi2k6?=
 =?us-ascii?Q?pDSSDM3Vz54sPozB0rk5vYaiCXtEPiWJvvqAGDbMAiJHd/an4lz80kthqPEi?=
 =?us-ascii?Q?mnWcEoWC+FlnFUlr5XPCqVvXX+asVyzeqFjRPMlEvV8VnxifoW2p/eQEtGqV?=
 =?us-ascii?Q?IRktL4hNjQodEbljfrZnSnKVmv5V7fHxlX2AN6ihnKBx1eYqrdUS6O3dfl81?=
 =?us-ascii?Q?/tlKeUQIBM3j/sRVQJzp1XTu8aW/8PYecxQULRzmieqqJbQ0QDcD9dL3Oxzb?=
 =?us-ascii?Q?KKw4dMlxKV1lLDox4GuGLRj1XHPDaASeWa8wbv8nimYi3ePS3FwEN4B+Mcp9?=
 =?us-ascii?Q?zuIEkeoUln3uqdAJBz91fMJ2QimXXrrlhFuKG6PmWyIgGvJszQP1MR1vvXsO?=
 =?us-ascii?Q?SUcm1BmGVYycUeplM6YkEDp7rj0RDmuqhCmj+dqGxHy8YOYSB1QaTBPEdf11?=
 =?us-ascii?Q?bVv2MBAmquEdybS1aWSjS6VD9XlOI6x5Nsv9n4tKGNxz6e59m1NNFUBxZIiQ?=
 =?us-ascii?Q?4gJZ32Uy1nELLDI9MzuA9B90ontUHXC6/a2udViXxbo7U0qDYjwJ/xbQKvaB?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EWp8ZPtgnXAkJEq5a1ezqaMwguq7VBCet00v17+iy1hsqESl+TZYlJXjy3XRTEuNrgteaGHBksc1A6Hd4ilVpBGhuKTgjItVs4l14MkZk8qUd8rhGKfFNOhdoBmpNNSLxeNbkAlpiA1zansc2o1iqHxbxI/H2F3iXX6DgpKkjfwYoqjyy19d/VIpE+zqgXkC6nQHhJMbk2I+eASFdUtebuyumFlicjzgz1BQ7ftSF+pgCVBaxDJ9GQ2QLogt5VhvfIrA8rvuz8Mf1yLNZMbdwGzZvtoknl62RRF5vPAPWgRGh8u1IeFHMF7AJ2b9IJ4wlGLK2GeWHkZ22KfBERxTjhS8u7nyAoYb2yk1lN2ptBJ75CnbBYMAWehzBaVES6eXBuUwI2jhP8whC6ySs/BFqLbG9CFqPCu29HHjcxLt8h0G3OUZQ8AxjNtzTR+SC2SeZUDsTSX2JN1vPv9gXnIfxKYdmFn5AEoFFBiUWy5h5SiEAGXesNx/szIj4O0eOl6fgRuwCpNFFS5+v1UiLMESrKKWcvR1rV2aG7azgFbPy4r8b9IoOpn3B90K5NiPZBcpzGjRc4Pzn3X8gj/ZQYkS3pq9amAKzio3n5zNPfMeD5Jo2I6ar+Ka25V33PzSGR+Yx6Nts7Y1wV5Q7bta1Hbw/L0bqCjppqgYklw0m20Oe5kYf26zbvOqYpew0L28Ujbh5M/DtcYMetjqSHx5qFUNOLJCvv4WK1fvLE0AQ8Omgz7NYAmQ3UqUrfFZJLnOBmkpnc/HkyBtHsF8Vtal/IsnfQtMeFvdruGIJzgk30RV3NCMkQSM0STLAJSvoJzZEqX1Gtuqrue1v9GtS3nVxFm6DHIfro4qP4IyJ0q8+laU1hgc9hh76SNIzFU3t89CtBtB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fccba15-f470-4530-160b-08db84b217ed
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:24.4643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8pEzwpVaV8t5eqD0T8K3VzhUsHyi+XIBF7XZ57d9REZpXKlwKfi6D4/Y+zBy8Ivac7lMhvWXMUbr6DL2bx5ds+lnM3yQw5Cd+35IPDEp2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: oO6QRcFmDZNM47QC1xPcnnSYWE2ChH8s
X-Proofpoint-GUID: oO6QRcFmDZNM47QC1xPcnnSYWE2ChH8s
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks out the sense prep so it can be used in helper that will be
added in this patchset for passthrough commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_error.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..7c3eccbdd39f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -523,6 +523,23 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
+static enum scsi_disposition
+scsi_start_sense_processing(struct scsi_cmnd *scmd,
+			    struct scsi_sense_hdr *sshdr)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	if (!scsi_command_normalize_sense(scmd, sshdr))
+		return FAILED;  /* no valid sense data */
+
+	scsi_report_sense(sdev, sshdr);
+
+	if (scsi_sense_is_deferred(sshdr))
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -539,14 +556,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 	struct request *req = scsi_cmd_to_rq(scmd);
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
 
-	if (! scsi_command_normalize_sense(scmd, &sshdr))
-		return FAILED;	/* no valid sense data */
-
-	scsi_report_sense(sdev, &sshdr);
-
-	if (scsi_sense_is_deferred(&sshdr))
-		return NEEDS_RETRY;
+	ret = scsi_start_sense_processing(scmd, &sshdr);
+	if (ret != SUCCESS)
+		return ret;
 
 	if (sdev->handler && sdev->handler->check_sense) {
 		enum scsi_disposition rc;
-- 
2.34.1

