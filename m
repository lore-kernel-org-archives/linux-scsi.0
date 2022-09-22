Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CF4C6FA86
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIVKHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiIVKHZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BA2D574A
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:24 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA53k6023893;
        Thu, 22 Sep 2022 10:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lEyr6Pk3lD2YGZCvKFxTAo4u4/fo1g3E9hhktAl94wg=;
 b=T0krdEdHhtgL60EgwAOVgA0IY4wNrb3HM+FU5xZw5CxwwQ5pK1TabcJ6vQ8OULbXRPfA
 Jvef/7eGnFE78XlPbaivsdYA3ibQ9zOPnbojSxoqaPdBYtWIDEZj9cVgJaWut4shATXY
 YqZoa0ohj/3453MH7y/UeDR0YcDxOQR89glr3Ze+4Ea8e+QLAL5DnP5m2ElQCat+B0ba
 qaLQbQ6Y6TZuiRH8oJer86DfpAIztGT9nVlJq1xd12H7EvM15MjJ7krRcIsnc4OygGJE
 m20DX2bWrU/gggx7Mi8h4Bv7Tlo+MU8kp6l5+M8lSe2pGwMlv0/rd137j1P8V1YAA1/N Iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0mn7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8lWXu033855;
        Thu, 22 Sep 2022 10:07:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39nedpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfzQuDERQ6/FFG7lNSnDLylRL0c6T8bhaDyKAvDNbEo+az51Q2F2wS3ZmMy+Et2vbEtMzz/tP7z7ku5z85K6ZeCELHwTiH/tqkgnFskw+aWUqwBwBpA9WDEf2dlUeiUDitSkMMxXyyrY9SblyHGbGzwwdostRBMuxE28lKn/8vSiBkQbDGuqHP/eRGHwCHq/7WHytZ88pKqQ84dgKKurYMa+727r6lUTZjp7wtEkod7ghbHLHi2Wxq5C2Ejr7KvXX+I7oH1JR2GXFYVZSW4c+l/EVHtYLZqsDOl/aVBPAmFN7rc9WMxYwgYkKRRKSEMloil6Vw4wnaoLXCmOfB4Wdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lEyr6Pk3lD2YGZCvKFxTAo4u4/fo1g3E9hhktAl94wg=;
 b=ACyCBgSa9aKUrzotYy9Pseivo5jHoSKH5MuaZr34XsNYIKmx7oDaW0iADYtS6+6hFi1b7sf5uJICt5yJlH/q7jHymm0njxlHFZNyTFO0aD/bHIslC/cZwjd3gcsimoo217Dh0zrhTeJaevWV3EQaMPweV9L+A4foMfh5S+3lVI3w12dFyDu9ovjCzBh7ApTTT+VXjh5IIZNF/iVC+C8jxBi1kThzXVdhofQAfS8mAr6BB/xQCxXUbasb/nPg21dUCWk6LJ4V4Nm4+F4AKoYKGB4riEGxsEwLJwG046tkk/AS+wn/aixXvFQJD90vpAQGjUSePF3k8Nj4B5RTfACfEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEyr6Pk3lD2YGZCvKFxTAo4u4/fo1g3E9hhktAl94wg=;
 b=taXhjklkjbvyFXKS1fkB23/MVUyhYNtrR+mnXn3t4HbnUpafOSNbWikmoCcAl6X886OBABbDqLFQBKdj1+eFSzDWctkF+hABKqgM3BiHIQdJKXU0zVdrT1coAveuckIMQ5M8/Lx4oJtJ4zUkRd7jp9FCmBm5QlY9PjckcEDbjvw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4317.namprd10.prod.outlook.com (2603:10b6:208:199::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 10:07:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 02/22] scsi: Allow passthrough to override what errors to retry
Date:   Thu, 22 Sep 2022 05:06:44 -0500
Message-Id: <20220922100704.753666-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0054.namprd07.prod.outlook.com
 (2603:10b6:610:5b::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4317:EE_
X-MS-Office365-Filtering-Correlation-Id: f75b0d55-55db-4816-b861-08da9c8236e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HU26BlDJLe+bWOIYK2z1RpOn9LLhJ2pQ4ZegXtdHtVlT2Zz+aznvnr8Qsp82CU/ihB+EcSxM8JQzhHT9amWcZK3JQCmrDXy2AYxAyVrQyQqlu0zL5FyxyZVhB45kU3T/nAC8bzE8DJtTCVWSo6uEYsB3si2j+sUzGW/04F9PtAWSiKqBxnC0MVW2kt2eh8M8nt5jdFnB4uVvDb8W47rdolOX7atlf8UIJBNkMtntM29AznGhrwAaZhVFw7aPRZEQobl+svxTSoEn0oDHpjlsm1uiYkJ6TPhg/qchV7g3Oo29LGsxykpB6GRV9cAIwWk+cwTh5nN1R4C5NgPfNRh8HrG4vN3wP1I6NcNTAGlpx1v7faCxSHMYYdwBiezpZteffY0Qo53LrnDHxMZjJxhIK41qc28I2rljoGY9tptFeooTd6vVfUc3HeuNai3kcTzA/IdsNgoYAxjp7QGCbhIx80hV9rSNNICCi2sYFaQ9GxObdgSCIaB+HzZXx/ftEELDujG2TNjbvGEeEbEqr+XKRpbOHGYsJm7kHASy5HZE9h/Di33FLQnIHr0EZzBe5MRuzFj6Iz/XfbcD5m0Wcq+WpZuICs5j3/Uwkj2RyQVvYPUc5Ys5WvqdKNYzjPX1eAZomkM2n1B9SWi3lTp+871pxK6eKLqKQwQw7VIfFtdBNx8AyW0c5dmLXdJ3+Lzmsi3BU6ANpvvLRLAE3gxmEOkHXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199015)(2906002)(86362001)(38100700002)(8676002)(6506007)(6666004)(107886003)(26005)(6512007)(4326008)(316002)(2616005)(6486002)(478600001)(41300700001)(8936002)(5660300002)(66476007)(186003)(1076003)(66556008)(83380400001)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Un3tqrHpiF3KPbTungoN2lYtelEwXD83VPhTOoz2EyzOAmwgf2Ga6plSaGK+?=
 =?us-ascii?Q?+9ML974aFahWYSWKlZYQDFqA1C2tQVqT3gxJSKE2drpmaRztO/3d8fuDVySS?=
 =?us-ascii?Q?HQL9ZSjoTf6rkywpnhb5JQZuL1lG6EK5m6DdOPvAavORP1t0U4+my8RXVH59?=
 =?us-ascii?Q?TIGyGL8ol4OaZtZG2wBWC+6V7uZH1A66HSUO1j/Mahg/gB+JMw263OZVrlAS?=
 =?us-ascii?Q?gLODKb3F2UzpJ9RCos8f+sFr9kj0RBMl+kXCXvi/j2puUYtkxKSAIfwQmX6D?=
 =?us-ascii?Q?uWS/X25tOXwxIfLuqlhJ61Z56WQQlJZ39y4fFFrFj3sN4aTPQajZb/NgtRs+?=
 =?us-ascii?Q?0oZlG86FX1G071fX8CFL/L2lrj2JuVYpf/KHRmcWQxqBOBjGi5fxXeasJuXJ?=
 =?us-ascii?Q?dUC6KlIXNZNe77IAqZwvHfQFBw1XEwF4/8AAvE2QNZMQcMfBqB6HGn+lg0bm?=
 =?us-ascii?Q?TT4dzfOKIyswnzmNXdFNPC/1QgTnv6yu6Kc1/JSgwo19WGjYgVzyVeQU1EKo?=
 =?us-ascii?Q?AoXyGiXSgZUeDd7tcLS3JcPxbxShTo+WQotfBlRTfH+h4ThyrNDNSTokfPAH?=
 =?us-ascii?Q?ClOOsTqdyZjUVTMDhEkkX74jyLQFPkvngIoihFFGhYiA8VjphMvmWNu7zyGs?=
 =?us-ascii?Q?x2tSMnAv5kYcFfP+utmLYrrchawN3NK9BRqfyOu3Eu2beFdQYmPcPuCjtnW5?=
 =?us-ascii?Q?PUiCoLt0CDPstTIdHg/R/YYNp+nggKb/Uz8T6EcpRg29WoW7y9k/C6ESn3dH?=
 =?us-ascii?Q?tz77Wo5Omh58W4qu4WKD4tbjNWQMAIU1Yipf6ltMj90c3k3E93ujpNQ4OB8H?=
 =?us-ascii?Q?zBSUWYaR7Htl+UI4fad3IiTjjt/EoxOeMpdN6smDhLoJgFuQreV6O9Qydkj9?=
 =?us-ascii?Q?SvafAQRWidEnAS8KWMEzSqOzeursA1so8asNfr96Ylz71zNu1n73uuom5J5p?=
 =?us-ascii?Q?XfsiGvasFZrj3ZqQpqfgABQvQw54Pvd+SfNikCDGNgXINwWEwC6upCi9OHDQ?=
 =?us-ascii?Q?e6keqry6SkH+h+jR4/vw+ZDmxolFqMenSnVzzMIm93NCbgEwbgx4/k4sJ7/S?=
 =?us-ascii?Q?yqwQExLoR3URSyZyiIaMXmLat0BHwDJFs1IbS8v+mckYH5hL4zwxW0iFF9P7?=
 =?us-ascii?Q?yjV/LsouC16MaTGeumfwVRuX2uVJmi6m937z+GJwmQDnv2/27QInt0Tmk0Ft?=
 =?us-ascii?Q?wXuzKBJXOix4teNXCW73eNT69zAyPtgUDOyE6Gt6QVEyu07ew3Cy4beFeDsb?=
 =?us-ascii?Q?C3nklSWpiHiTCdDM9KlQUyr0kA0rcQtwxvHTPehAuRAODhI3r9AhLbiezsyO?=
 =?us-ascii?Q?lMfzyk/9cxngqJjhPFXAg6+xxmF7AVAEW6t5ww+EvbWkdA8atj96fay6/AWW?=
 =?us-ascii?Q?ksdF6zSamV+nsAccEWIU/odqVTgJZWqtp+16NZN7zRqJof1+Nr1adD3woTNs?=
 =?us-ascii?Q?eQ5XRf7l56FBs1QOreQMOmVQRJjaRIsPZAvon1TkBf6VDXv9XamY8CjivJA/?=
 =?us-ascii?Q?vJ6PDb0ne6vgGPg8UtZ9ok5UVFzkJQH2MAwKyJhSRybbS1+StbOoLtUFU5/I?=
 =?us-ascii?Q?ttcZyM81qOsr9zfJmyixn/H8KJJAO+4mVcmr7gDmh0j/eztT757qWX+etRoY?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75b0d55-55db-4816-b861-08da9c8236e1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:10.8196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8UeZGH+udmFjXpZ1if9mc58rWLOFMPMbnWSMK/+woa9Kq9U0J9dUi/hX9cR6zT18fTi8pWClQfgZKmOrzqVMAhYi64irvXdJ2KaIGhcSMkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-GUID: Z1nUewF-YSQ-1ouCtp4pF24X06XHlN_z
X-Proofpoint-ORIG-GUID: Z1nUewF-YSQ-1ouCtp4pF24X06XHlN_z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds the core code to allow users to specify what errors they want
scsi-ml to retry. We can then convert users to drop their sense parsing
and retry handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 63 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  | 24 ++++++++++++++-
 3 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5fed56b6b7c5..059c5f40d236 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1830,6 +1830,63 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	int i = 0;
+
+	if (!scmd->failures)
+		return SCSI_RETURN_NOT_HANDLED;
+
+	while ((failure = &scmd->failures[i++])) {
+		if (!failure->result)
+			break;
+
+		if (host_byte(scmd->result) & host_byte(failure->result)) {
+			goto maybe_retry;
+		} else if (get_status_byte(scmd) &
+			   __get_status_byte(failure->result)) {
+
+			if (failure->result == SCMD_FAILURE_ANY)
+				goto maybe_retry;
+
+			if (get_status_byte(scmd) != SAM_STAT_CHECK_CONDITION)
+				goto maybe_retry;
+
+			ret = scsi_prep_sense(scmd, &sshdr);
+			if (ret == NEEDS_RETRY)
+				goto maybe_retry;
+			else if (ret != SUCCESS)
+				return ret;
+
+			if (failure->sense != sshdr.sense_key)
+				continue;
+
+			if (failure->asc == SCMD_FAILURE_ASC_ANY)
+				goto maybe_retry;
+
+			if (failure->asc != sshdr.asc)
+				continue;
+
+			if (failure->ascq == SCMD_FAILURE_ASCQ_ANY)
+				goto maybe_retry;
+
+			if (failure->ascq != sshdr.ascq)
+				continue;
+		}
+	}
+
+	return SCSI_RETURN_NOT_HANDLED;
+
+maybe_retry:
+	if (++failure->retries <= failure->allowed)
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
@@ -1858,6 +1915,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
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
index 497efc0da259..56aefe38d69b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1608,6 +1608,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	/* Usually overridden by the ULP */
 	cmd->allowed = 0;
+	cmd->failures = NULL;
 	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bac55decf900..ee3986401f52 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -65,6 +65,21 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_NONE	0
+#define SCMD_FAILURE_ANY	0xffffffff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+
+struct scsi_failure {
+	u8 sense;
+	u8 asc;
+	u8 ascq;
+	int result;
+
+	s8 allowed;
+	u8 retries;
+};
+
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
@@ -85,6 +100,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -330,9 +347,14 @@ static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
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

