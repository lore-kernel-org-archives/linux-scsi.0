Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB99C43217
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJPUAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiJPUAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E191EEEE
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJ28Bv011941;
        Sun, 16 Oct 2022 19:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0Ej4Te9PQtTHBmrVwOvaQHo5tIR/TIb/Xlr5oL8pEME=;
 b=pTsMbJ7V7UUfL80VsMvTeykFcJtVODE0suX41yvC/U5KcTyX2ZLKSSZTyjvFmsuw0195
 wvDk38zTfKZdWl88CoZ96GUJZpoC5nXchxy+PiWvJ8e9dCqNO9u1jGABJARMwrSXPDVn
 u7p/dUmOn3SByrtihWzAWbc9i6JvSVaYs0xDK1oqWoFoRN50XzPor/huCqCgg6tRseVI
 3e6wl6OI+2v00LSIW17y2dXlLEa0GzvpjjFsEMr2dmna1wgixduGfzA+1l7hM/F46HBY
 ZmG/H19AxlTRxONBIirxMgTDbGF1IhDnsUxltTpHErfqFRsHdD2p5wMs3GKEvjmcx/YZ sA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw39yd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAa7j001092;
        Sun, 16 Oct 2022 19:59:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmgfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m25G0T8rk/fxFBFk+bEYVZNPkF64Wv4IPyswOsyWH5miwDuElY5LaebFVixUXe3xvT4V+EtQiGq8HDcuWR2guNAGRaG5qb1RR+DoT/4p8rkG3vEJd2EcL3YsSaaIv3Jfg12qKAWmsEkoxEDf23fVIqToqCP7Cgq+HwTVFsLBJBo8oEfRGICWIlifLa0GZ99++QugkD0nH+n4mmRS/OeivmPKE5wIzUvGVp3PoGWOVwXALAvR6zKTxZ+iAMuiqcmYj8PrJF2Nz1PzR5RqxXsPb4XdjBkfxSsxgXEC3tdEczN5hkzg+tuO8g5f7v2/clC6Bh0ozFW3zWZ946QUqQ4B3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Ej4Te9PQtTHBmrVwOvaQHo5tIR/TIb/Xlr5oL8pEME=;
 b=Z/EX2k33DiN9eoeojKoQImQLTLJQhxOjya3Ig0m+SEHHHd4IIPxbOIpSVfEXVSRWMkFCaSI+EIdj+73OlDgqGCsws2v86GLwKdu7ykkNzIVj/+s/LR9oIFCXEMhExyCodmvQBMr6Gz8gLzl1DJ2oekMsO9oBCjQngmeXcNdXPTYr6BzXvaj+PO7he7U2EMqxkEIPRAsVvWnezcfQXACQnLAvQTLxYDaPLOgiIiW8uV6prvxemvBGXlYuzYyBwSd9gTWOYTMslcR/tVfgOncYDJUSUP3Ixs+ZaHqFEM582SK6TlsXV1/cSOUqHOM6gqP0gFMpzwMI0cENXPodr6P9sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Ej4Te9PQtTHBmrVwOvaQHo5tIR/TIb/Xlr5oL8pEME=;
 b=o2VKd+tT3EmhS7WbL/WNTL3ElWBjpqJieEJJxsuwdLFopufwwxOWGPacxO33Cz7t+hnDH+EFa0RWuZ6tBjJlPnwtJsZCi7oJSRNNJevuFW/rxMHj7/mfbgQwFifkHr6F7B7O92mj4zd8grWg6BfNz533nOXq7z8jCLjan0FMXxw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN0PR10MB5909.namprd10.prod.outlook.com (2603:10b6:208:3cf::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.32; Sun, 16 Oct 2022 19:59:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 19:59:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 02/36] scsi: Allow passthrough to override what errors to retry
Date:   Sun, 16 Oct 2022 14:59:12 -0500
Message-Id: <20221016195946.7613-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:610:33::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN0PR10MB5909:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a204f7-7b96-4b7e-9872-08daafb0fd6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /SKGpAbofWwCHlZu+OE1mq4Z3iX2DmGQtn2a/FbhNLqYjv4J99p8RDgGLtr7F2SIdY9iRf8oqvSunKbaIYXyhe1V1HXw8iRAOAra/vWOnG/CTAPBTUMAL9yJDYZKqEMW6O9TzLleoJWaAQ7udPCx5R5p2AhIgq6/dc+18RunnwhZfpGA37qAJ6VT0HTqHMWMrtYyHjhmG6ALJw97cxc3aktT5OwmF74sjA+4cwtxtpKbPBICiMjxhAvRfuZJXMVQqdPmBbfRbAMJhdATIaOhigTslKHo+XEUuz70zgoj83Uyx7c3eLSUc/bBA/JeI506vamK4YEh1m9wVUsC1Xya4l0lMRU3isuzRlpkIzhIyo2qy/Q69Rf11Dk7CrenM0u82oeHRD+AxLDsJllWNo5zlNlET8TycEUoY+D1FcPNpi4pAO7y9imTWtOIgmQVUv19252vVACa7SmGk6bRIEHrmyzQnvmiZzXpYAX/jklybLecJfQE9df4jsk4lZ0EC6WjgOM1KnEUo0/L5jF7o8z6i+TTy8CAaimAHC4wdSUaF9JkBpOjc0S49bTp2I7Pvvx7xmjsQwMBbns6U8TzkXXIRCg/XcZmeiBbT4Qyonx72NlLKMl4GQJ7GyujnLeKiI95vkZIzhmL9pCtxe/s0/VdkhNqgoEpVHof9dq+HfXpkJh1PMX7W00TkkPbLsSDWh46lMpz2UVEvG79xYUId7OttQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(6486002)(316002)(6666004)(478600001)(107886003)(66556008)(66476007)(6512007)(5660300002)(1076003)(186003)(2906002)(8676002)(66946007)(4326008)(6506007)(2616005)(8936002)(41300700001)(26005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Djfl5CiiR8uIK3dazsimeGCewq5bajuK+N9A3KAD+51fsEhvjp3x5TZUXDAO?=
 =?us-ascii?Q?z21Qhfipk+0jT691g5K8TDPjcJ4vaK6hyRZLelp/74nEht/vFCV9FoGc6jXY?=
 =?us-ascii?Q?T9oV2fzdZGTPz9P3b4eEIa93KYZT2olJ7KzB0WdehCfckEu7NLn+Su+RSclw?=
 =?us-ascii?Q?3ndnTuSUXm5HzxjHqdAxo88Py2S05ZtItG/DQ4amaHzwBJwE2nQ4qJyy/GgA?=
 =?us-ascii?Q?Toa5xVhKXKmU6i2czM4W9XRhk77Tprk5bKv7xrS9cprSWaIHwv+s9+5booLV?=
 =?us-ascii?Q?ujfhuC0IhMMHh0JsvA+GmzTpz9eIhRhAZ+1pYR53y3UFVVoAvXY+unip3NoJ?=
 =?us-ascii?Q?S8Cbq3W5YUHBRT9cBic5WysnksSuu1z40AhdV+1SZavbuVpP9jIU3W953VSD?=
 =?us-ascii?Q?vUvRP1QYWcD7vOck5zZiT73dA+R5D6GVAW9DBCNIRdoGnb6JGoFY3yJPq6EX?=
 =?us-ascii?Q?3Uo/8v7a3DsfAJ2oA4YnjbFN7GqWCc7T+k+rujEspCqDtzGLgFVrfMPgpmg/?=
 =?us-ascii?Q?mmsQ88rl9DeWSOj+YbijXx9KT9tFJzZ9khU97n/t1Xg3nHR7cf0kA+e5vdHr?=
 =?us-ascii?Q?3HeF3CMCzJjWKuLmSEFu2sP7Vt4aWdT46QLTM0aZfQCASpa6+y/xoXLPhTmq?=
 =?us-ascii?Q?HRGuGXih5Em8QINdmCHYGPJb43hGXxvkenncomHYmtY9RvwUli+S8M1Yf3ji?=
 =?us-ascii?Q?YvKRp0IxTo1938MbTMz6HyqWlj5OHwx/n9hpKJ7XDdMj/CyZVE8pT25dR/4/?=
 =?us-ascii?Q?lxYcK/CbmTQeAvEwuLVRGBDHN6nY8FINCuhXoeYeAWzVZ1srvJyJQ9YsUSHx?=
 =?us-ascii?Q?WixEnVjnsyl8GBR0FrLoBVwuFCjrUMO/NAbMplClEd7N/Ua9VyO/Pfa6iG9Y?=
 =?us-ascii?Q?xgtY+4p7TtjS9Kw8EOKWUZeEu+q5o83TUCtu+/mbHWNN8dalNK4pz8aNK0F5?=
 =?us-ascii?Q?VfQS6IbEeT1MQmGaC+yYGEe8CuGZfzn6MxFqpb6X4XqDE+ncn21GgGZdCO2e?=
 =?us-ascii?Q?wEwRqnBW9wueJy9gKjk3GVkzicllnGbGYa8nnjc09M5z2ghGRJT9gZc5OaPF?=
 =?us-ascii?Q?teBiNDuHQhZNryzEP/TsM0p15xp2vxgTyy5HnNPnaVFQijr0oT/6MPzH1IwE?=
 =?us-ascii?Q?LCpRMHlTg7MFjWlDYTlfvjrHfxBaDBzysBt/xTX+Ai2QfZou6XY/sZhvio36?=
 =?us-ascii?Q?X9qpoCbS00AQaPY7GFCH9A5kJgPXueVG5xNEE/DevWrkweb7dqLbcGL9IB0/?=
 =?us-ascii?Q?/Eo4kIbYnvzSYmAZWDsHfLBn2cBo7drOvZWsacY5pANIvR9/mgVNm6EfrYUM?=
 =?us-ascii?Q?RUeUe4L8kkg+G/ur5FTXReAAuBc3v7Szk5wRPvkdY1GrFy8R25dH6lBircHJ?=
 =?us-ascii?Q?5E22etiBVVVwNkAoXcA6rd7uYAWWeOMJn7aDrvzRgHdUhC1s9QbiBzhe+TlJ?=
 =?us-ascii?Q?csK4fo8Z2fKoKyuc5F2hdYnBtn76vP6A7ZIEzDvcnPMXrStV3BuuEAXBPeHP?=
 =?us-ascii?Q?Bl6y1CKORc46l7gzl/vKZb3gPso9C8V+Kij/b/Lrab73VVgUK/ISnTMDfNXo?=
 =?us-ascii?Q?z7ermSZzkATh/wkTdaV44QVwyuINbfQgAXrRihu+qUa4b2NmTqGmdl0V4Dxe?=
 =?us-ascii?Q?oA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a204f7-7b96-4b7e-9872-08daafb0fd6a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 19:59:52.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fcb9lSVim161ZF0lgdxrPKBMfGYaKbvI2B1iuNMsVIGHoZeeFJYHPS6Dx97l71DIWZz3WPZ6V5Ogp8DFAWrKay6Khrp0jSVcPqf7tmWgq7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5909
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: ropGJ-Gn0xaZx4lkcxCbqMDJnr0SbwDM
X-Proofpoint-GUID: ropGJ-Gn0xaZx4lkcxCbqMDJnr0SbwDM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For passthrough, we don't retry any error we get a check condition for.
This results in a lot of callers driving their own retries for those types
of errors and retrying all errors, and there has been a request to retry
specific host byte errors.

This adds the core code to allow passthrough users to specify what errors
they want scsi-ml to retry for them. We can then convert users to drop
their sense parsing and retry handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 84 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  | 27 ++++++++++++-
 3 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 36ae7cc5e7d9..2aa162406107 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1832,6 +1832,84 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ *
+ * Return value:
+ *	SCSI_RETURN_NOT_HANDLED - if the caller should process the command
+ *	because there is no error or the passthrough user wanted the default
+ *	error processing.
+ *	SUCCESS, FAILED or NEEDS_RETRY - if this function has determined the
+ *	command should be completed, go through the erorr handler due to
+ *	missing sense or should be retried.
+ */
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	enum sam_status status;
+	int i;
+
+	if (!scmd->result || !scmd->failures)
+		return SCSI_RETURN_NOT_HANDLED;
+
+	for (i = 0, failure = &scmd->failures[i]; failure->result;
+	     failure = &scmd->failures[++i]) {
+		if (failure->result == SCMD_FAILURE_ANY)
+			goto maybe_retry;
+
+		if (host_byte(scmd->result) &&
+		    host_byte(scmd->result) == host_byte(failure->result))
+			goto maybe_retry;
+
+		status = get_status_byte(scmd);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != __get_status_byte(failure->result))
+			continue;
+
+		if (__get_status_byte(failure->result) !=
+		    SAM_STAT_CHECK_CONDITION ||
+		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+			goto maybe_retry;
+
+		ret = scsi_start_sense_processing(scmd, &sshdr);
+		if (ret == NEEDS_RETRY)
+			goto maybe_retry;
+		else if (ret != SUCCESS)
+			return ret;
+
+		if (failure->sense != sshdr.sense_key)
+			continue;
+
+		if (failure->asc == SCMD_FAILURE_ASC_ANY)
+			goto maybe_retry;
+
+		if (failure->asc != sshdr.asc)
+			continue;
+
+		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
+		    failure->ascq == sshdr.ascq)
+			goto maybe_retry;
+	}
+
+	return SCSI_RETURN_NOT_HANDLED;
+
+maybe_retry:
+	if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
+	    ++failure->retries <= failure->allowed)
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
@@ -1860,6 +1938,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	}
 
+	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
+		rtn = scsi_check_passthrough(scmd);
+		if (rtn != SCSI_RETURN_NOT_HANDLED)
+			return rtn;
+	}
+
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8b89fab7c420..eae438d53ac5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1130,6 +1130,7 @@ static void scsi_initialize_rq(struct request *rq)
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
+	cmd->failures = NULL;
 }
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7d3622db38ed..c08e083ddab0 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -65,6 +65,24 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_NONE	0
+#define SCMD_FAILURE_ANY	0x7fffffff
+#define SCMD_FAILURE_STAT_ANY	0xff
+#define SCMD_FAILURE_SENSE_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+#define SCMD_FAILURE_NO_LIMIT	-1
+
+struct scsi_failure {
+	int result;
+	u8 sense;
+	u8 asc;
+	u8 ascq;
+
+	s8 allowed;
+	s8 retries;
+};
+
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
@@ -85,6 +103,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -330,9 +350,14 @@ static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result = (cmd->result & 0xffffff00) | status;
 }
 
+static inline u8 __get_status_byte(int result)
+{
+	return result & 0xff;
+}
+
 static inline u8 get_status_byte(struct scsi_cmnd *cmd)
 {
-	return cmd->result & 0xff;
+	return __get_status_byte(cmd->result);
 }
 
 static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
-- 
2.25.1

