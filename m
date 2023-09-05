Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64891CCF9E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbjIEXR3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjIEXR0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:17:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B45199
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:17:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MteJt029120;
        Tue, 5 Sep 2023 23:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=ZRrng6kE3x/+8bDvCiVbmSBAYbA8WdwHT2oUwWBHcuc=;
 b=sgvjdsz3XgrEbmsSc6RebFzBzqe5VQpRjunBhBXECFqIii+coeo/zI210U82BkQ5pxb4
 zdssR/eESPKt4rM6YFGor2zuAa3k4UqSckF93TdPNRHepnq2CrZuevK0Tl2IKHYtr4cv
 fVu6ts0y2MTbAq/edfmZImulkUqAhUoaaNah+edQJ5BLi+59womKPq891fGAjk9fBiN6
 IVemRIyy8RtwJDPr61BSB1qQuHI+CVL2tH0TtCfPuz/lAeahJC8X5bzWMiVbPmnMiyJA
 Xd9vGzMl6fPmwzY3zrDr7KuAPP00+oJD6P+USGF5xHCAlbzRphz3DyfjsAfJdsWOGeXJ lA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdj500vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LeulI006539;
        Tue, 5 Sep 2023 23:16:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5x05a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXoGH0JmLzxtTLYYbvcu/YC3g6aIrO9+Tov/wa/mAR3OFmN8P3p3YZbn6VOA8y/z4saIXQ61ke2aCPWj0u81iYJn3YU/RvTLfbI4KzgUSfwOQtNW0UlJFOnDsDdv0GVKZY8bLjV9RKT08/0CCjSaV6aTUxQ88gHf16Or+GU4MmppmJvdlDFiLzNupPyTawT4lHe2H9OXKv3t/zobvp4RmgVdcdcBm3syjtTOasFfrZuROIYkOP9QFu35/sehnjO1meRo/x3Xq0LUaR/IRMlF1xQYAaJas5/r7ciJqq03KhzCZyS2g3iNvYsl6Rvq9kaWAKhn4fXRUQJw2b77kYMHbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRrng6kE3x/+8bDvCiVbmSBAYbA8WdwHT2oUwWBHcuc=;
 b=F2hfGmno98Pq6L1kgOmM7azZgGjIebjV6Klx94w+qFrsqJomifQwlkDmF0dKQnDYvbs0xG594PSLehnzQzK5LS2tXzo4xF3/a+TOhHz/Gzt/XSNxoAzj4vrlW/cUjFSzkCvW1APLHHonXaO27DA1/e3d2MTlZ3s3i9g23EWIDs8OeXHfW5V0HnzOqfNmlHKIcuVz5ncCJXAzkvq5M+RtMVHHhvf6JFW7JQAeD8Vb0eaTgEHPWc97ElVhirSq1U6ETKKMuqE8btGs4i3y2Ib6Repqp1U/UjX4DoGM18NeOSx25+66Xpd3zTw2xDDfqPGCP2CD7s9eDEfzgNLVEJG7kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRrng6kE3x/+8bDvCiVbmSBAYbA8WdwHT2oUwWBHcuc=;
 b=pnO7XN/H2EtWyhuJ5ssLI4h/XDuAntfzqnWa3badbOQiHRj+sK9VgpBj7BIXlxIKQPMkoakhW4Xfg7bc7TJ2+HYvHNo+pmNIqBUoCbsXCb2xuT2pltRnEtUUJoq875VhvAafplMHm+znZJWqHl1nI3HAeS+ojBYDWJIy3PVw4sE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:11 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 14/34] scsi: rdac: Fix sshdr use
Date:   Tue,  5 Sep 2023 18:15:27 -0500
Message-Id: <20230905231547.83945-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0079.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::20) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: de550740-131b-4424-57b2-08dbae6617da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEZMFqxpWpUO+0jTKWdkGauXnvYaMHx05J+0LVPan6/PIgUx4iTi24pl2TpzwbScjeJcKoeFRVMuEu54WBseY7zwKmTSi5I6yn3nlRpmVkBZpskHdxwdYGZvJys/wzHkbO4KF8z1DvpTf+IKDCe50uj93MGVriL/Fn6CxyzYhV3246KVLoBGOEjIGcMvfV3lh4B7qsOj2BdmJQA4rk3x3T4VXMJjZXmHMJzL8Uw6tUnwEl5XLtdYDsZEb5L0cF8ZKFMZN7cXURdNY+ypZ9owjhunEmj51CKUBNqo0EwGl6G3PGYoO7QE/6sMVNmleBYyDaPmCXOvc70DpI4aQU/9nhwDFsMPtmPXzBlY0DjUWCY2zByaSLR8J+9Pble+9HeY+OXDjATLjKZK2+KxnbN3u8SpcJOijaYhWdsFHmZOnsK/Osy30lWjuHPUC1vUHddfxWq9TD5D9JLUeeRy6RVl8JFTFwgOl/XtAydZuYrvKYoOQruff5+vSqLARboZ7zadxFn82bxGx8+LQDTfuchfI/LrkUaAtBXszE8DZvza4rmKhcpJmIJFQhJGyDacEFp5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MoBm+UfsRBiKxtxfyf4/mN2i4xRF5kcH1hdO5w7CMEhSoPdGtPFiEVaHiazZ?=
 =?us-ascii?Q?95kq+F+vHwPYlDhvumfZBsjXRsJ/FZZcMgg08ma6ltmX7qDviEbXaE6k2Cpl?=
 =?us-ascii?Q?mMZY0GJ6N8w0YzSgMz6la5nsrJ41D2XoBH9BKs0QxLQdU/ZaLH5/mRTar7O/?=
 =?us-ascii?Q?q7BiDR0hvhwLF6CQ8BB9cH/BLtZiz9Myof4wVrPUWafOU762QZ6KBLViApMu?=
 =?us-ascii?Q?Ka6azIpjyGfAdUihw14TpZ6vjd/dNK6zuG7FveQVTNi4uzYF2O9S64OCBXgj?=
 =?us-ascii?Q?918y9MHxApKKafRTz5zDdT1ATt+18KFLyO2s351QQ7A9JIwoIvp4noGuGqqd?=
 =?us-ascii?Q?a2Ear1tEqcSJYmEAMP4ObXjcyFRIHyaeQsX9lH6lhigv+1HME2AV9kwdHiiw?=
 =?us-ascii?Q?4QEZGsAER/bbB+Zn7NSD1uq26pKODag3IP94K2QxxEOk9GCMijZOEiwgaJDv?=
 =?us-ascii?Q?TAEaEGQf5mpeBlG54q/PlcyNpUiiEwoegkaQkU3bgvgcnerhCe5EzUEL5bGQ?=
 =?us-ascii?Q?d7jO4/xuINygr5zQGnV0rIh10EtyS+vh2W9Zwd2/wIuNdwLuSPu1nLiFjosK?=
 =?us-ascii?Q?F+pVNZeqCKCiCMInnEm6QdVlgwwdGxvueFak66cphS41CHbeTVONAit8Xz42?=
 =?us-ascii?Q?7SD/BSul4xDUy+6EY43e89lU6jlk6sN5Xnu3sroJQL5Te2glgLlyiA8AcNRj?=
 =?us-ascii?Q?fmYSC4t1cS1SG5IgvB5UWfQbrJoWeW6GCZsG/ZO+UdYcTUf8Z4jOsscRF5KR?=
 =?us-ascii?Q?8ObITjTCaJ/a+CKja+gUUiXoqbHKsZ0FuiPK6gfiYm5CldyOd9P7zFDzUSu5?=
 =?us-ascii?Q?2IB/Sxsr73mwokwJKMdMg2GS+xPbyHYIik2svq0M5HWAOVRNyG4WmrhBtpNO?=
 =?us-ascii?Q?hScVvYNSLf1q77XcgDBUoHFFwa0ikWra9rE8+3UbKeplzE5BI30DXvy+i3LM?=
 =?us-ascii?Q?AAdDLvyaow5CBc80XlH+IiCLpl4XUd1QUPwaAx6FcL4lMhZXizH2uM+ampJI?=
 =?us-ascii?Q?dNc2xX8Wogoq69/y06RtAfufSHrdB4V97DaElzxNidyNORvTunNR4sVsZdd6?=
 =?us-ascii?Q?0qsz7AYy8aH5fVYWLzeq0wNicEqRSCyHXadEIoMQ5laHGTHdHd6byUyEkYR7?=
 =?us-ascii?Q?NI4cSoGH5LdL5V69KcYNIxSu/rIU468pwqvGpd2E/HYe1Xwe+jVJjqjOjPfe?=
 =?us-ascii?Q?L3dYT5lcKy/pcUTwta5cvPZMaYDD+kyWR75tuuN8oBQc/GcedHO1i/o4Hw2z?=
 =?us-ascii?Q?KP6j12AnFcssS7+tEQ5vG64yUfN8Q4A/5hH/wGdSK6JtS6FXIBTirwn8FGI/?=
 =?us-ascii?Q?4TQVrwjnIfcLQP0Zr2yYQv17PvfLDaTdAW9902u1QX/duCqa/LRl2evO8mmJ?=
 =?us-ascii?Q?SXvECXgO+3C3hW51LLuGGER45zR3o6pkY9ho+6UxesUvinCWe0FQaBgRu1sI?=
 =?us-ascii?Q?UqBx4aMfRGIcTAr8AD3VCI668r58j0C5EtTkukWxldbN6mol/70I/ocEe4Pv?=
 =?us-ascii?Q?+STMyEqsNmaKxbE/SkR+20wO5UG2huZ5UWvXGRIAAiLQ2Co8bIsG+UytdS73?=
 =?us-ascii?Q?sNJagZ9AvzayxhVCef8PP6dZ8rLCMdVarScn6QIVp2dB573UywPQuEKpjayL?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Y6DUT6h0oqxPRyRO06FTxtLdw40E8JWBzB9D3zi5DQ97onjUn7qj7hZVSaUSVi02Vo1oSbYJkWoHKQZJJKz3xHFeW6+et4rtf77Ay40jrhMX2fb2bUDZx0BMlL7wfQpLqTS6SL1nDguSBkiQnMUDXhW6gLVSCXHdbEWHOQ6a9uhTNm0Kb8Ei4XWi9yHS27SIfSK4W35++EZ1YGLAgaifVcOom+fpDdPz7yzzsV5jcgSq6/GWjZ5onADV/VcbxrDDygh+HyiwstalakNiCYnSTH0Xg8Zu57HSvnGnpj5/QgnmC1lwPQXzSFeB74gNgJstWwH+en3V5XIAlNffVuRSbz9QqHy4V3g+pu7nNP5iuczv6VBPYoRtF7FXGhJaTyIkcvhhmWCO0YMVld8TX5+x2r1GLwtpeLAvVai5TficzG4FtWN9Fq/0UTHmQFMmwT6pdrsuT7ruPKtSA2VExdm9m9BI/viVSNQmrO5sIVzNQLWVT8r+lnWDmdywmT+3du04Yzha2RXsK7i6gKy2J/1lTasBzBtBKFhk/a6xcDfzhesiPv3+dpvXVBnYhY8P141YrvTUKkKfd9t4RXdXz92A1QycnblRh0LVxe2q/hSV4AXOrB0VMb9/EW+EiHUlvW+u5hnLvSdKKU8ny++0dQh6N2YYhoI2oxrAW4/m+UIC80nkjypt0ft+jAFrWnA7QN2bavSSAG21jwKv9ulH99PWMuiGtHCjRvR+D7Bej60EJqdL1D+WyFbdQ958KDKuP+oXCdpKqmIWi5kqua6uaGOs0uZ1ERYLQW+f4ezhfArtVpjNjX8kt4/LmJBXoAF6rI/YzLRoyHrfowGZyoISK/xvHHgAtJT86S/sd4j9hzf08GEzv6caV6dfAfFIf0HIG/CF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de550740-131b-4424-57b2-08dbae6617da
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:11.4552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epxPhzeCf7Wy200mLI+wz2pY10+sp1FOzTh6ExU45WLwsXMyaPArtq8zCJhklfauVFGyiuuhkrBVQLH9A3dNV8loVg4cxTGsTvL+0OE9lUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: Nn17VwxV9ob-uN4Ir2VKMmLH0c13cmth
X-Proofpoint-ORIG-GUID: Nn17VwxV9ob-uN4Ir2VKMmLH0c13cmth
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b65586d6649c..1ac2ae17e8be 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -530,7 +530,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err, retry_cnt = RDAC_RETRY_COUNT;
+	int rc, err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -558,13 +558,16 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (!scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
+	if (!rc) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 				"MODE_SELECT completed",
 				(char *) h->ctlr->array_name, h->ctlr->index);
 		err = SCSI_DH_OK;
+	} else if (rc < 0) {
+		err = SCSI_DH_IO;
 	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
-- 
2.34.1

