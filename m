Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27092C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiJWDFE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJWDEq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:04:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EABD5C
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:04:43 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MEQLhS018071;
        Sun, 23 Oct 2022 03:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=1/5xQTZJBckRlqB5Afb6kr7W9US6r8HCBlKfiphwFr4InrWY2k+zb1Wh9ZZa4XWdvQDY
 wnLgzq9ASKDopgyhX6mKO2M7Nu1ANYd+F6RTL0hQig4lrie5PL4i4d5dcJOBtQgq8Kp2
 IxN3vg03/3w26rSV6pJLympumletEWilhlgPb4tl6WzU+IA5lKexlUfpVdlJ/3fh4MpV
 WrmJhONv0JpmqbSBC4c1Msjqz7nRtln1IgtoJz10CBQKjIF8enNVFY0EG5gGiILgfuFY
 4IeELlW9WORSnbSt3O6Kz4ByBLeAi1vPbJCsFpGMls9aGEpH0kIoGAsWN1spUX02wXVt bQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741h86d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29N30Vmt032218;
        Sun, 23 Oct 2022 03:04:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30ajx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa+vaPM/yP+pGCxCG3buLjtlLUUl8MwQRIno/imqr2UoyIaHr/BKXjfBkbwe7Kd5wCI0pcPgYsFnKrWLkni8f5oBQ/fpbRhURbtvsK81AFv4CVI9SIhjOKmiYHKiQ65THY1LT89Ll3B0STgyta3Id4AJ2dh5hxM9DYnqCpCwjHyYFC2VNoeIHS29MMU/P/+A8/XyBUG2JstBTcTUcI4TvHGHpq8OJN0rJ7zTrhTDNc8FxU/kqb+2ypfgGIdgW/2Paxx+WrMBoBW/K8SbsXPULCMr04GazkMAfySldPf50rYHcl5nPOzdqQ5OkKTpynQWSOKqbgN7UGi27WQx661rMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=JVosb5dMHkZXYxSi7p5QEcJFvkv2z1iQQCqiTi4A6l70dRz8eDnTrNReDCs6k+B56bIz9IB7ez03tQMgVbDhoN7S6kvPuwh4IMLwnvqOa8kgUhVWIs1w0UhdCQvRTj+a5Ox7f3ILrlqzaFpw3v04IA2CkHccIQVqqdBjMhplNzH/EeGGEZnlxGYezDkppWJpTUe8RUA4tVaGVKXxyyKnd4BfbIZXa+c/ppsI/uQxQDR4DBMkpwtR9XJlkidzwFQqqqOv/Ym6aBf1iOPNbL9Z065Qfl3oDk0typlXHUV+IIv5G3I60SYw6z6pWvi5e5LYn8S6SucNg/7nXK+agKIG+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=XfFoXp4lV7EkMpGFU6eWdAadxc6jfyMqhzqY2S8e1BjndYsFAZHn9e6f/ZmNRqAWn4VXCg2g3/R5kaYJhqGI06ml+d8yIMRmsBn4NqoxG4LM9IxF9ebq/nNnvtn4U2WrAwTySlkdLobWdYluR1DoThlepiZVgLIjY+5LrYfFmwI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 14/35] scsi: sr: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:42 -0500
Message-Id: <20221023030403.33845-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0029.namprd16.prod.outlook.com
 (2603:10b6:610:50::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a7df6f5-bfdd-4475-77d4-08dab4a34c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DuM1XLY4/UYoxV0MviuOPw7D2w/6mWvHrI0I5vMKaIB/M0tNy2Xf1EQ/gdgkjZUQiV+fh2xcQNG/25sIbIz6lx+NbguUwdsWk2VB99ConMX4j6nrJ/PYQcL+j9As+eoFx8F8+L/YtPET9ePBM1DxrmeAKWIIRHFGcIH1v7h/TQwoiD02npToQwbbO+lE7QIim8JLrzC0DIHNkmXZoJ6ZiYvd6OLC+Yj9BSjiiEWWyD51RCLE9HVJc59MphjRHbjRaG7RFAuGwKWciFt1eP7czzuf6A5fATNzBnK7pwkVORQ6u2x8r0MlKI1OHJbBA+YNjsQPZfSuqaq6dbJwsIvNPs0B/dBHRZFRWIn7FePUbyUjdWEsI2pXv1GkqaQm7es7DeSCgRhrwclByAVb7ZtyoBGGil3MUMi9hN9HXL2808Wz1uwNModTsbnFlfhQgjhEebd8bUgFuS7c8crDTyYRuz/MQgSVBw98JJZux3SnWTnS3IPdLHSp1LOJp1GdD9VanmBS3KBg0M3KENa8n06+fJfCjq56AjrF4MFrgZQItpzTpGwkWiuBHeD4KAM6W4uHo4yEglcAQavkqEMHzvB/ZzLVYuCV5bjOUfzgtQcdErYdDfDbCpit4R/gaLfP2HrGxoQQuZTZoTOs73QTzQwhuGb7Nhmg99yUm5KGp91PJ8bEq+rqHQLZyB2+4M3sCFh4lfxZpOZq9us/QYDIYywscg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4FXS8BL7FMXpJ+K/XS4BkOl/dwaJKTzhWO+DZxvxLugf3T0/LJEhUNUKIdI7?=
 =?us-ascii?Q?7+VAGzQ6aOqFNiJIbLbx0ckAClTQJUMSzYkVsNDBN3i2YyPUiO/b0hSq0xWh?=
 =?us-ascii?Q?O/HZtAw6knhFto/uai4+C3wwaxa8lFFzLry/czxuhsqBKvdiH9eAotdEI969?=
 =?us-ascii?Q?DwLEfEpAjof/FeJDScjii1uEcOEFpbGqsY9qP1NBorz99JCA13owN/AeYOMz?=
 =?us-ascii?Q?u6U/f1xCvuK6RMoo53N2kJKRrKlWqqPFlnFI25g4odAitZg9e46xefBJ46bq?=
 =?us-ascii?Q?FQ7YFCo9/WzIe2eBJk/99YWP2otO7MbTU8zgae73MugqODD75Tdpxd3JEX8e?=
 =?us-ascii?Q?/aQevzwTIU1f6ugWQWkinD3ak6s625g+/xuqnSoxQZPkB3Ht70m3OmumNL/O?=
 =?us-ascii?Q?vI4EfE9RkeMNF6acD6qS2P6QAS1bVLrIp8Jrkr603ewsI965B/ZoTFY+j6eH?=
 =?us-ascii?Q?47BUm3kSGwHp0XdLHjIvL0IbfUgBrag3BR4AIUE+ktQ8Wn/wBT13EhEJiFIy?=
 =?us-ascii?Q?Zy9sxbITxizol6TNJrwWOrrKmoaJRFcQOZhslWkh6LyzimoXmHASn3w9fxyv?=
 =?us-ascii?Q?mbPx9M4EpiVWzy84zY6708lip68JeDCpxP0qjxRrpC4H70LdApEdktFolI86?=
 =?us-ascii?Q?xbbjeoB2sUMlAWQqA0xiqhnxuoO3WewBgrqtZBUNS0p4nYcq7rIf9LTh6h0s?=
 =?us-ascii?Q?uTrarRJG0dHiK+Kjq/7sB1eTDscVUnNEMCLnjJQFAnfImXfM8+NfNVH7T1QR?=
 =?us-ascii?Q?9/WXRbAdi7v+LCCEliQsyjxFRBGWPWsr74zuVz/MI7XD3LBYXaTACb4ldqbI?=
 =?us-ascii?Q?cdIWeoBgg+GqdzjSy1835oDETJI4UNeWhW39F5J/O+f/yPbDRj2Smtt3Za/h?=
 =?us-ascii?Q?EJSelsWGCw2rPCc3ff13xE0SbQ/hMTCWh7Rd3Emh3Zw1MX2lNOajf5qcOFjR?=
 =?us-ascii?Q?CEy3YtFCLtMutggmjLUUYbMpmw6ilTAZk67apJDbSjZ+4ymxm96F8gpSDH7Z?=
 =?us-ascii?Q?0sGoE15IRS5jz5t7YwffnDI3wlVgrRHHL57FZhYcuLDFTMcFDfxK2oVvIc83?=
 =?us-ascii?Q?+yQqq46L09kye6U5mx2Cgi121xzsWYFA962bSgU+vhvYxsIXMIAzPTCZsJbG?=
 =?us-ascii?Q?t9b1/9O//VYO/13M627GMLOUsDq8rM1H1XUZR2S7YyzQ3mBpRl30PKI07FQg?=
 =?us-ascii?Q?YerZLHdfqMaop+N5fYDW0/VNgDyvYnUq39FUelNZFjeMT+PFhZdBb3Dg4+UH?=
 =?us-ascii?Q?3dAP/TzrUQhIq7pdMIuicDmZevOR7xTvlsWUlXQY7DkvpjzDiNdhWwm7F4/U?=
 =?us-ascii?Q?L2L6QBH3MLVG3T04Om3ZwJsB6PlofhBE5uxF4sa/B+GZ53jPbEfhUqwDsAx8?=
 =?us-ascii?Q?QzIMDds2Mw4VCD6Jr80cyn6GumA1SW8pDIUgMQ+Mun9Lg1jtFZWyrtyAVwb+?=
 =?us-ascii?Q?fZ9zM54fpEpnaBSFi3StH92PIh3NMFK4LUJ1ERnnK5JQ0o+8d6u7ptiDLQDD?=
 =?us-ascii?Q?sakeZHzWIqAhJaFj6ON/MWmeO7oCUI8DleR6FoKBL19uIcPznYxLdf367px4?=
 =?us-ascii?Q?25ai+1aLOpUJlcGuvUyU1XcgM9dJ6MwtnE/DNVXTTJFVhagIWbiJHf2ppJPJ?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a7df6f5-bfdd-4475-77d4-08dab4a34c7b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:28.3112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PkSyBXhJX3mTCslYDZOD73DMPtCVR4tP0aZDU0gAxI9ayO5HAv2ruy1n5MkTHZyBI4qxnkCMOD4P6kYByhOdmgu5xrqBtjIPvl7fUW6LYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: 6KnDQvMDllFa2Z8XORcrmLO-U8vkuySh
X-Proofpoint-ORIG-GUID: 6KnDQvMDllFa2Z8XORcrmLO-U8vkuySh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c       | 22 +++++++++++++++++-----
 drivers/scsi/sr_ioctl.c | 13 +++++++++----
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..e3171f040fe1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -172,8 +172,15 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	struct scsi_sense_hdr sshdr;
 	int result;
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = sizeof(buf),
+					.sshdr = &sshdr,
+					.timeout = SR_TIMEOUT,
+					.retries = MAX_RETRIES }));
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -730,9 +737,14 @@ static void get_sectorsize(struct scsi_cd *cd)
 		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = cd->device,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = sizeof(buffer),
+						.timeout = SR_TIMEOUT,
+						.retries = MAX_RETRIES }));
 
 		retries--;
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..3d852117d16b 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -202,10 +202,15 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
-
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = SDev,
+					.cmd = cgc->cmd,
+					.data_dir = cgc->data_direction,
+					.buf = cgc->buffer,
+					.buf_len = cgc->buflen,
+					.sshdr = sshdr,
+					.timeout = cgc->timeout,
+					.retries = IOCTL_RETRIES }));
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
 		err = result;
-- 
2.25.1

