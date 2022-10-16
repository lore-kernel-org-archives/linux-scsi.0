Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D0AC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJPUHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJPUHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:07:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A97F32AA7
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:07:18 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJluNm004999;
        Sun, 16 Oct 2022 20:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5qGq1GjkGe6KPqYs8n0AlyWjCvPVGaFvDm7qWcYrW/4=;
 b=1Uhvj8rQMs8pDT32ERQNAsXPEYVrsSTe7MwGrDKLFBn+pHkOK37LEVF54Ek7h7nc1oZQ
 TtqJ99XGygrK3dbyTC6A1RcV+n/dcLOt59oVhmcqHaKZ9l8giXrqiQcstPgLMwP3NGwd
 YbtzDOvpOv7dIjXTOwiy7nyZLV11hutkkDH6wLbLB3wAuyDTNrHHz/sEI31m9v0Ztsck
 EXfWP1hUyURJWULpuBhLm3RGWKrfTJ661ZunF/RbzaNr7fvqztZOTH2t8fakgmqnYBXA
 deo2ZB3E5ZOKFrmZG5VruBzpqd9T+R0vuB/DT4Cj08VmJoSCZHSDzAVj/6vmErLXb/K9 SQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7fb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:07:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCBW7H029464;
        Sun, 16 Oct 2022 20:00:14 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr84jbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ji8uMJpw1axilRB9lHdYYDHQ7TBzaObbWJoPp3AlZG5lpbkcWt84yfPGNGzjrJ4L+o3ZgJVirVnepPveSbwvMTIuF9vb2T7IEsQuzFGaoontz7MfBwv84QLYZ4R3uWsLS08TGEEqMR6kTcbbp15d5iGjCWqGnY8EsdKKnFkzwHZ7ZfKnVxl+xw6dPGToTIHlTdfS2uNEiEt75OGjIu9RiITwAAtI9MGOPRmJ5pOY8xSLWpYStfUG4YwesrCKh0GSV5nA3EluJswuQBsYHPIm37XtlIFAvNW0dibyEG17waFHy7psq8NXBFB3FLkRpsZgJBV1h0TrIilUQpA4+8aG0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qGq1GjkGe6KPqYs8n0AlyWjCvPVGaFvDm7qWcYrW/4=;
 b=k9IO789LCoaaHgI1oZ2WHGOCEB/XFbjAC5fR3iLqzFSlLP2MZdPz/Gi1WHwMwmc5DD/GtoyrE7AItMW/CgR9XSH/uV+8MKM+8zZKp8StEIBQN500RfKpHn6qeV4pnzz7Q0pmkHF4RLeOJ5H1HxM1/5fiz7fyrrrV/A/MQGRZUtGLqTGO2YtorrkID8pctEoQOVzQ/RHgy8IsCkHpqpygwoBbELb+kvie7yfcTv2C78wqEvODDvEP8hr8VrZmJq1YoMPsgfeoRhPBqe4JcdzDzByVm3BxYu0Bet9lTO0DfOkFTtPobXYM+JsaOcEHrnm5URsGSkWBMYZAmbize3CqLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qGq1GjkGe6KPqYs8n0AlyWjCvPVGaFvDm7qWcYrW/4=;
 b=Whl+sP6OfiiiQZILFr+cWmLw96mygbuLFuJhNmL38HDER5ABHgJermDue6tUVcgovQj5O6seWTv7LTnXpnwg9N397Zfkn/rBSenpW8MS4sgliFwc7oZcFcYumdvSxgiav3HGj05G+BW/1n8yQyJnCYA+nVfOTf+I3ent/Io4uro=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 15/36] scsi: virtio_scsi: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:25 -0500
Message-Id: <20221016195946.7613-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:610:50::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f6303c9-224e-4110-dc66-08daafb10979
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3u7uxR3gK6AecAnML4bA7rwtWufC7zrqbmgZwf+LAsv0MYpFsUB+UoH4WAed354uo4AGL1KU3UdXMZAua0+v/XFj7GeXNkqlirk24UL7mfzJQH+GWjqEMYhXVlvUKB4p8l/Y4E1NiJrRx5KLyS5sGG4u3bK1BAhy8CbECwfrO/hmtNDy9TKGJ8oPfN/GrcnKZSlIKSCWAmLO3FeD9YhkJn32nU+3+wD+Ey/4McxsBTZTt4L9M+xF7e/xlaCi/Nc1P8yhEqTWDh+795hXkDfk8YmMqILO+FQNhAPH4NyK87vgfukpXuVbn6zmC3EBnYhNzEMppIDIG78C97PnkkkjscxeWscyJgiOI3HFV561bySq4yhcCnUtRg6g/po25f0ZNpRg9tn4VZ/p50bnF3z3RGBoHhuIT57TuV0JxGgbjjUbQKdksdrKTXabBjv5GDIl7zjU1qZfdpcqYpkFAzUZYekyPOnqcNd6DsNfpL8jpHXqyMtmR1609U+q+H0lP7OuudwNISg08lzigODe341fQxx6n3MFoyJmSIp+S0V8FhklQlX5cJY45JjDgFQegiGgNbmaKX/wZ+dNFmgbnCC9iQ+mYmwPqh9KdpqydoazcOvUxi//LaBJNHs4g6IvSlNJTAzq618gwrJeGM8kNbFZcq883IjeaBJrUsnP9Tr8RpJIlo8ERqeL151jGVbifjwb7RN7lRRqJb2oVAUXK9XOYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nAZrOBJO5kwi2HJdfprpuqv4iVpfnvJKH//WxsQTObCA19yWT/zJ+Fo1yjmi?=
 =?us-ascii?Q?6vmR+AUM06Em4yDz0fI4b1zdzC3xA/3Ty3jjsWBZRfJHVDrc1Kyzy/XS9Exn?=
 =?us-ascii?Q?YFwbXV7yGpT4fNzJcrnj1By3Oe+GEJlGoBQ4z+KALgVxVjezI7zVBWb98cfm?=
 =?us-ascii?Q?Gm0B4uDq5FSHG4Tj9dt6fCXyqoqK08WApIwZHyaHAXU6hvH+YQqPbA4EK50v?=
 =?us-ascii?Q?7r8R1pF2umy2hduvy3nlzXn1ozVZzFobI137bgTS9K4S60zjynMp707ktKSM?=
 =?us-ascii?Q?4cG81uzs4+930yR1+Iqgx5IxCBf4ixflteeCskI8QUs9j/NJ66fQPfCEVn2J?=
 =?us-ascii?Q?8G2VSApYCvplLOiR6teAdPbRfTMIQYKyUfmaPH+nsccjdgyCNI588WqzFcKO?=
 =?us-ascii?Q?2Ji672pF2CnlfKhNLB8UhewKC2My7EXjewoQoiP+wYz8lepPDX8wg6PxK36N?=
 =?us-ascii?Q?X9Dv2tFuMbUoHo+z5PjtAWj7UtkNFyNEKLgotrM6pl5j3QF2jIhO946Dbpx9?=
 =?us-ascii?Q?BdXcQIbcSt8yICkirtzYD4vXrVYN91vynRk7l08vTYG9/GDcvciAKBAlsDmn?=
 =?us-ascii?Q?T/w46GqA0zSHIMr6oVvKn6jTAXbRDMqETQOUjbueQpidckRrLs5gCuw+tohJ?=
 =?us-ascii?Q?uRIbgyDUZClibcwgIKSh5Ze55/hfGJ6dNKMdCQTg/BdQyneIojGVjNTQb2AD?=
 =?us-ascii?Q?tbMPxxYl2Z9VglJw6QRZxDE8POcEwM95cgIhcu/PhOwhMmSS8sc+F+RMAKIf?=
 =?us-ascii?Q?egu/7zJtnFfsHAI5pZM5p413ppAss+8Rgmj6EuSsaCMUinWKptQKkMhv7p1z?=
 =?us-ascii?Q?U1gcHrDRm4ch753jr7T/ORm0SZXbMeG+DZSFWqRA8vjjl73/7/F+NaFEBDTb?=
 =?us-ascii?Q?yNJQOI+LbKO9W1JIkj1YMH9rzdYd9lXP5Am8vaQPefGae4bPz1z+wunNGzbD?=
 =?us-ascii?Q?HIwurKiuaARBaKs/q5Ed5AOwlhXznJttNJjBlHGGJlmWOKsKuyKCqmEgOqLj?=
 =?us-ascii?Q?SPPIrlGVB8WVFytuJNZ4njELc53s391KcInAbPrLWGAwFL7j1LZfwBf39KJc?=
 =?us-ascii?Q?IHG8mWZVhubIhDBwtzxo693OvuONnG2dBI2V8pl76YSbJodP7FiCcI/fnyQ8?=
 =?us-ascii?Q?jqm0VFupZ59qQqPdSCmOp+TrvzYRVBEvmrDQktjRZridwdiDvi8zNmpFP4di?=
 =?us-ascii?Q?+gx6wnn3fqLrCNquUpXzjWlVAtWwATrXudwFX74+rgsQ16QTBos89WhxgsHQ?=
 =?us-ascii?Q?GUiIFLcooUoZ6g/fkeJQsz+QijpFOarK9wE6cgXaX6eGCnQbojNYqpyHS+tp?=
 =?us-ascii?Q?8x/ORcFap6BUmvjHn7fWEudl6miivt3C9dXNubMc4cbDjO2kKNPzZMWoPEFe?=
 =?us-ascii?Q?9TUOcnhGnbP59VwmT04Qlfd9ox+lgSbe1+J+otkk+yW+7wB/Z+XPP2R+Oja6?=
 =?us-ascii?Q?X1pG5FUMRvpios2UJjEFgIupem0btPvVaVRKQ6jXoW5OHXB0GtckNYJNQDQJ?=
 =?us-ascii?Q?FQVNHev1LBZHwIAWDpc5qhutF6ONzljrtyaEoYfZ+qxBB/5rtBioRZJNjhx/?=
 =?us-ascii?Q?o6kmz4Akpap2ukCKaoPhC1tA2xpXxlyZiF6m2nBuDcj3sHNDE+5euZ+KhXK3?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6303c9-224e-4110-dc66-08daafb10979
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:13.0493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EV+4Epgx6XXw9zuXHLY7q0Pi+Oa2gebpwyYdeOpaFsQNHPXe7th2t5jEpNaitZBmMQSF2751JpVoSh0FDNt2vPlOt3oLua9vxsyJ1QDyDX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: H_DUIvUrf5VhyoIvc90dFcGx9_KtxyV2
X-Proofpoint-GUID: H_DUIvUrf5VhyoIvc90dFcGx9_KtxyV2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 2a79ab16134b..9dbec7188995 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,9 +347,14 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = inquiry_len,
+						.timeout = SD_TIMEOUT,
+						.retries = SD_MAX_RETRIES }));
 
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
-- 
2.25.1

