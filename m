Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6910C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJCRzs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiJCRy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC0A3FA0C
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GODGW015434;
        Mon, 3 Oct 2022 17:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=yvmRGgmZ6AJW6SrBp/xYx73Zw+rkwBR1aTRdjZOXHhE=;
 b=yS4jtdb16vYSfG4yTgjoBX6HM7C2UUr6ALWYMwIUil8lZyolpxpAkzrxcQ1xUIOY++qW
 3Nosj9CqVEOxQ1034d+DFhZqglPCLV5h2vhqQFrxSzUs9P1xbDlH2RdHRcVqopdFO9x8
 meoaU6KM1gymCtRcpNOPXtfiYBP6N/p6GwSVkfuONQWqQ2i0rBQeF6RMn35ZPpZ6Gjb5
 1+vGzjbua4M/HOeoTf/penjll1tJksovSM/RsIE+iu60R4jcIIt6svhj4/5HXTY6JnFo
 vgCC6/dCy8E2rIfjMAXr6GP7vwBa1wC9Eyv4Z2ChEm2AT+wuRJrEqEuQBQso/bGNBYza vw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2mbmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FU5Qu028008;
        Mon, 3 Oct 2022 17:54:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gda0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4G6bNA5kbgao3RnFD4b6kFR7pfFprxSQnh6A4R8SsU57RCdvgIb4d03MeLHIbH7pFVrCUE3rEFCHacph/pduvxqqJ80mqxUuRVq9ibRXbLuJSXwyoj8beZZY9q7oq6OncVTSfoO6ffGlm00YdVi1HPBGP79N00bd8h1YDrP5r0GpxwwZ0flYw/pZU3KPQh1KdnI7u86C1/Mpg8eNQhSdukKWbzRVWoB4744/CDRZZOeJPlMYApvvPeTsjybRelkTG0xD9Sn5G498RBC1Qe+PcGJTFA0I5UbnHuWwztROOj4EtkvUB/LJtYj7ZqQ81Vnr7y69Yv36WxXW7M1SR8fmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvmRGgmZ6AJW6SrBp/xYx73Zw+rkwBR1aTRdjZOXHhE=;
 b=EvF8I36VcuI9pvljRjGCQeRiIFxxvshaiJmTDv2JMfxnGyGG7Cn81KkCkEnQmgyXjzAwbspO8GWWq7/SrKp6vmHGoFqK8zTD1QMWXeY5tbR9WTrG8txjel0M8EM3S2RdglzJLrhTpP6p8MMWXIw393tRRPEj3yM5L6HkwYIq7ASVf+jY9J71FndZD5gdfkkvPbTjz27SAsGpSY4WlzqQ88cExg7wmmpe1KN7usRfwE6iYbcC5EmS4ZivHjVE1sapQ7dDWAdg7fUdUZ3WIfK+gNWy66waQllYjltgl8ZVKh7IN2lIoGBJuloiWqEycgzp2NxDbvGhGx60K7iM7Dugpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvmRGgmZ6AJW6SrBp/xYx73Zw+rkwBR1aTRdjZOXHhE=;
 b=ipKt4pF8L+U0ZPyP7XlEqxM1paNLOCSYkliYpSCjuIiWGpIsDhCwJfrHlS8MnsiXctBW2xYAtT2uIn7h0z2EBOHaCdVIzwbeIXQDhnW/beAOE/kDvKc9bkNVflcQKCWv9Zk1MPNdCsaALYHlwxG+RTTG19eiSveN58rfmwZ/SeQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 02/35] scsi: Allow passthrough to override what errors to retry
Date:   Mon,  3 Oct 2022 12:52:48 -0500
Message-Id: <20221003175321.8040-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0055.namprd18.prod.outlook.com
 (2603:10b6:610:55::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: be918548-c53c-4dbc-1a01-08daa5682c77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dfUsolmv2eVp4RVxzwq4MD9qTMqKWZ+dOrYP8sYgLhQSBReYT5jfiWe4Ln2+nyJocE52y8/7ct8smiTnwDn+z6fSTZ6TOcdZnd15OTSJksIQqjxNe/gATrqgn7M5keiplVGweDOl7M+1ghZIoKdQ4T04WlA8TzB1cWGj2cguwaaaQn9Jvg6km6Abd9AnV3tDfqNafDTApRz+D0rGhlWGIbzHYg3G4lWt5iHlrN0gtrAFfWOUjJrZ09wXZS8ppoNGf8Kf1YPO69QSBJJe2oTr6KXgR5mJ2Fn+OW8sDPS/B4UEBQlYE7icNWrdJeka8q+53z1E2Z+FcLZI2xZRPQZsCN9Wq4G3m63kpGAt8tbplXWKPtjZNOAhZ7xZg37Aqkuxq+7ezg8l71NTuK8aJqucQfBwJcxSy/WUCx2H8KxL/Jpx8IxnXw8L8YlxGJHR04jwwGw/rZqea6c0YJvo4hO991ppB1AlA+O4HHxyZBLVaEIl2Dni8fNNMKSfoZOt8MJ7GhLyoqkx4oKv+2CZ+UrJlR3HgSNCkMQm2zz8aefMEC21W6EcA6MjHOK1Ghd93HzOTsZp3J6pR3bHU2mAlIrsx5ko/moiQYmHcyAeRzM8X5cyox8UkaOETqZCeaQDJQID5o0X5WyD878NwS5Qv1Dfu4RxHLlwoYzs34p95I0hboLEwSRBtwblO7GF9UBo17J2DPh4pTcV2bHvfO0pUvGIxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0gDgSsHbOEhfqAbH3t2HTXj/A+r1HJxAej5DV1w/slih1Vf1/PSVIDnU5dqc?=
 =?us-ascii?Q?Y1USjt5Ls00miMbjB9H6E5FYfTNAJY8Ci5LcfRK0nEhwb5HU0Hvh/K/K3UeU?=
 =?us-ascii?Q?Zn0Oc3IzwA8IZJLAXrNfdsvZHFW9qvKy6o2jpKHNTDyXG7Uax6eUtHrj6VXB?=
 =?us-ascii?Q?mOGkQvVTlsmzv7/OpUJicDWSf/yCXJUe2vdwkAu57L4JzzbRHVJBO4z3NlJ+?=
 =?us-ascii?Q?iq0/tYcD/nF4/Z5UnRZVwjUo+fUdlu8ALxIpXWrWe2ExpsWWUkZL7Yw9vxD+?=
 =?us-ascii?Q?mKFbNS2lBDHeh4MlO9Bdq/EuQgxeVlyVDX6jxPjcSlUXpFPddUsHzbqaQKKr?=
 =?us-ascii?Q?pdrIeegD3ZB5BYbHvTJJ6mdEOaA1Mzmq/qCay/Nualtl4omN2rAQ4cgrrJfg?=
 =?us-ascii?Q?QsjWS7W/Ov6URCC0+eu+KjqrtZFuHWzFyDwsOb04Tyvv4weUeqD00Cdn5YoN?=
 =?us-ascii?Q?VQZ6FSNF6afAV2VCWIBX42iK8RgJoSZPjGhZS6EAsIV24m+OIPGnWZ0SzF3n?=
 =?us-ascii?Q?IDwupruTbFvAD8C3ZvmTHeJomXkafRAL1jrLgbYBQFcFOMr0kv0cG/6+Mr8B?=
 =?us-ascii?Q?go7Ny56zr0IoI9wIqVhp+Hw7XhrmY9ZD5BqG1g7pTZzxTWul1Flehg15Rpkc?=
 =?us-ascii?Q?ywWsbXJSSbaPuMK6/YDSNWK45iF6t6LPC4UcBb9CRjZKFxDxa6N+3YZNrTnG?=
 =?us-ascii?Q?ft91pQtcffWiiEd++JHJWpjAtZMsAaomwRb0cxeH/4DU+EDeoI9PFehAlD/j?=
 =?us-ascii?Q?iDPr91qGtMYUKC1lmY/tubD9CwyhLBPToNBHJMlAqzwQiVd5Hx4iBDs9/rNJ?=
 =?us-ascii?Q?sxXB06W/pCKheY8TuhtskA1afzj3wFNKzCIJ13SJqEeuG5OPFn24b7ySvLsC?=
 =?us-ascii?Q?LT1kBVWrDfAThvkE36mTUZZ4khHuvcq3gLLzyQAGKN8qF9oZ3yW08nBHgMRk?=
 =?us-ascii?Q?oM0a50LmPM9//+1t8aerEJqGqZWeWFN+B3BSLM7h+zBybkYYOlrZ4PAkEu3a?=
 =?us-ascii?Q?D/GHuxHyl5VSuwkQdAkB9W20pQCkUs4uwO3/VuaYu0shmE+hQb6HA4s0UHOz?=
 =?us-ascii?Q?Fyg977qTgITNNsIyZpVF/9uDj5im091oMe/OOOaTnbG5uq0lIwJsY+3ejILH?=
 =?us-ascii?Q?XTxMGkK8G0I/VTB3tvkg4ONTmhQc1meQYecrnlBQzRZ+tLajXEWAspDoLTGx?=
 =?us-ascii?Q?nzztktS3EXOPqtstLwUOvZkOmX59QUyMuJ0N1krrcok8i7JrhlnmAeEoriwl?=
 =?us-ascii?Q?jo3wuaeVRZv5hMyKoFspu+fK1cuF//arXX3E4rR3JRq1YZ3YvyWx8yu4zbM4?=
 =?us-ascii?Q?XlM2uLvIZij/EJumIjcMsDWm4Qiro6SGjiQtafr3AXyUbu+9fDmSZ0cCj4gp?=
 =?us-ascii?Q?/oMuVuiozzLCu67VC8A/C35jDNH4RgPm1NJe0M9ZN6AHq29UVANEU6G466BI?=
 =?us-ascii?Q?B5pnY2+1f5SoQUi02SedhYgneH5JMdLKxNqjx7i8gKK8I5xvO/Dpzyoe8pkA?=
 =?us-ascii?Q?DnZjah9EDZ6G72ZTIIGOvXL5q3xF615t+Fahzy/0IFLTMcNJczgdhKSOldJA?=
 =?us-ascii?Q?yPcEMCITPKCgveKUrQLrUO/aMpnobcxPxRnTuydBJNR8q8xodtP+JRkwIOkG?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be918548-c53c-4dbc-1a01-08daa5682c77
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:26.8468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cK9vuNuCk8iMKBLn/DavfXMaKpGfqSNA+l6iBouASlYuxJQwB68iFyvjeUNjSktkDbZJX+xH4L2hEDB+ZPwydIr8Ydxgb0GDD/n33yltz0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: LjStGyx8L8KcJSRq8VJ27Z4DQ5sVAeE2
X-Proofpoint-ORIG-GUID: LjStGyx8L8KcJSRq8VJ27Z4DQ5sVAeE2
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
 drivers/scsi/scsi_error.c | 73 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  | 27 ++++++++++++++-
 3 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3f630798d1eb..55765efa9067 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1831,6 +1831,73 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	u8 status;
+	int i;
+
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
+		if (((__get_status_byte(failure->result)) !=
+		    SAM_STAT_CHECK_CONDITION) ||
+		    (failure->sense == SCMD_FAILURE_SENSE_ANY))
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
@@ -1859,6 +1926,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
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
index bac55decf900..9ab97e48c5c2 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -65,6 +65,24 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_NONE	0
+#define SCMD_FAILURE_ANY	-1
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

