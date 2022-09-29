Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233CEC04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbiI2Cy2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiI2Cy1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:54:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03F2118B00
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:25 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TMZZ004231;
        Thu, 29 Sep 2022 02:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CltwJnPUzUDVdxNlag5iFXTalA1YB4pG0jhnlmEoa5A=;
 b=SPq/T3sHl7XGTIDIXf7jTkTSxq0GGyVKGv2rSMtSnACAhiqol4QgT8XstruehwlMScFA
 06gw3nCebvImdDnBuesaaI2newRPUSjXac5/bzrHadzxTelSUfqZxqqviIVMM2yUOr9L
 gG1050liHlGDtpwfyBO9vTLHxsj7kLAx9HUrwU0B78tGhMZtHPgOK1CcDt5vWtepRXF+
 fIfnOMyecc9rH1vqaxDRkKlsHCXQUmsCBlcZJOhhuK/R0F20BBeANwLkkqXpgBUMnimW
 MdfzYToeo2D0X646b7nVbTGa48fl5Lq4jnYI8YqnU8zHrtjuWOE0afS6PCCSIpzrggZH yA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubkhhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1Ylex039394;
        Thu, 29 Sep 2022 02:54:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpq9jc24-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NssHfuLk3H7xFKIpgC3OseKdzkNgefmw+JLYZzIAbxlgnOPjpN6xSeCg2G7z9b0/xSGAuSVDpExo6SUhi9HMXMtLAfYMnz18IYybh3MXiTRwBOk4O3FsYyvGAFp1v1cBRS0DxMApY5i4M2lDhF/ZfiXgH5tjaXCy+EVUMpwSL0LcK19RbhDE/BKbZj4Cn3AvB1RuLq5CLZMQLyUb5/jb/T8UuHClHQwW7gMn80Y08HEfelpNfjrEwFiXZs3//CSmLynAaCztavLT6msXW+KHfdcfdOHEpZ3USdKow9K79dPICPT9vDE55oUyl+ipUyFLQ2JKP8TMcXcA8CoxZ8sK6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CltwJnPUzUDVdxNlag5iFXTalA1YB4pG0jhnlmEoa5A=;
 b=kjiZBa4B8LplLavofql79D2hTJ+MPxVmSPUYgaGQXB0Ih7pesDDFkL3VEzz53hDIdce+4MKZWY0IFQIgOrIvgB82KsIGIEAG4jRFQZAhWDPmFv6j4X8AGk6DRy/wecXEJCG47pHsmHg9XYNNr+uEtC1XAOR00R/ErLWnl2G+oppW621OD/BD6XezxegHJo1YFGc+bA1SUgrtKaGkjywpzf5dpdv3VkcPRIz11YGl+WHaUI3BTQl9Sz4BpynW5GwtbwsWo0oVJhHmOFpZ1HgBhHVnxzvV/C2ZnVXAMQH5CXBJ+d6y6EGLE2dLWUV7OTZGfRV/Q7hoHLBumBA2BY1mNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CltwJnPUzUDVdxNlag5iFXTalA1YB4pG0jhnlmEoa5A=;
 b=NHAXj+SMxqGVq/pgt1lkOcFmgocPXzqZ0ExZ5TvcGB8W0iD7m5yYcGp0M/SDC9N12Kd8h8tTUJlWrbe9IRAvnRJeFx8fTm75zDZxNwocllmXFJUKC2HuE2l+r+yAlTvJrDRSsZystNBcsvCDaBVwbCAgrs/oEpP2TSKwHyXq/d4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 02/35] scsi: Allow passthrough to override what errors to retry
Date:   Wed, 28 Sep 2022 21:53:34 -0500
Message-Id: <20220929025407.119804-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0027.namprd20.prod.outlook.com
 (2603:10b6:610:58::37) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ab4e562-c39a-4c7f-85a1-08daa1c5e539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UmCGHCLqL/Y18w3x0HSwpvcv3e0NOIJk8mi1XmsaTYfb80f/FDp8RvV9rDpLzZPg5FAezpthUaqmaFm+AqByvpOMXdWGRm8rRL3bl2GtHib6IBAWPsERHHhDdoBCf/64aOFWo0Ip8dJMKYpTDgS7eMJbav9ZEgROnWLtAVqsAz7ycqzI0ueMfoiNV00wRScE/O4yR+mXeCQ3TGl/1MvaSc2OulVm1ZgXg9kj+WR5aFENPQVHW137yrkjsBOnx1hEfRoB41CBPZHBgOU/EItR3+TFMt92Ul+1FjRwrWfxV4VTwc+L9xFhi8+VP6WWx8wdkz3RIRRu0GpTJcIQIhUlqSXGHsU7WRpBnxNeZCwvhJCs2oIBwvbOtM4wmTfrMsC/Se4QakgZ5Xak8qUfHCA7qsSsN75A5HmWD1m7je5aBJ+uerGTUqPFkDGTUJFalJfy9bFuId2tHNXtB3Cm8F2xs421TfguNNlfhnaYxGdr4hlVPCxc7OqyqtaCsNVj2s6NYUCYZ++cWOHKIMnvNKqNCybjMVtCtSEg8fPu6sQlogvFK4RADLZ7aUtCMkrqcul/rhygKdLhX8mx+T0v2da41lmGsdT0YDrGT1AiqRUlYpHaaOEARNaaks7YjImZ14Fj51FfupcHHUR8XuQlP7Fja4Crrrm42wIuzVfTES4yZZYUv39S6uk6EVmfkUBPq39Qf7+G2EUCKdxY45NPH390fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m2PlRYLC5HJuIgSQii3uW/p+KCvAglSPvU/gbhob7C5IwLk4wOALt0LFc+x1?=
 =?us-ascii?Q?20gVWdmrHWwpjBCxyxVLiOpYFBcb4P3A0T4J49vFQ4baehIJ4gyaXPyAaLBi?=
 =?us-ascii?Q?tMWzd9HCeAf/xwAvV5pDD41AgT7lDuvZr28pfuwkeuYqWg0Zs9TuyR9kgCys?=
 =?us-ascii?Q?bKpWP9CUjA2phIxiMMTKWuywSDhrj4P3/gqs2y1rx4Cpxg0BmvFcxigTiQNM?=
 =?us-ascii?Q?WuWzu0j0PUOOx9CF9N7WF6BNOavjNFQwtXkem2VHCOw3u1EzgUVPq5zKAVSY?=
 =?us-ascii?Q?CIvCEwGwodTxwYFMG45zRpdaEziJJXaJtQX+TOc8Cyu3SgQVKTy8tnjkDtjq?=
 =?us-ascii?Q?S289vBCkfEpwxJXIHVliacPLXXnalEa3vF0hMkpaM3DLHZFOebBf0vvKbpW/?=
 =?us-ascii?Q?Xm7sQIDJmXgFT/cyQH5iKMwiXucOw7pL3b0xbKeIfXOFTt3KZPJ9KmPgpx7P?=
 =?us-ascii?Q?c7OhKM16C7v2ErYaQiLQXpJ0x2bxee2rnpXGsDTM7cWBFagawyCH0h4bBrY9?=
 =?us-ascii?Q?u0OqTApnsF0eTQq0MzKbxmIWsSR7MfmVkJI5/207KZssl3sGm262uhBMn3Y+?=
 =?us-ascii?Q?mTLi6neLnVCbgor5mg/+iYEzvyMzUBQNjFTGHjoZUlZl+RH6tEm4sawazP8Y?=
 =?us-ascii?Q?jqy53kbgTdSwq5OoJYIJBkacS9NkC/EFB15hVKh+IcuplKrHl+mj6PLAF6Jz?=
 =?us-ascii?Q?zZdM/HEIoFAcXv/2rcLMvNQANZwdI1de1fmbSLTX4696+mxYLgcj4pZ+ssfP?=
 =?us-ascii?Q?q4OjzZtZN73Bc6Se64LGKs5FtNQQrt37PXIVpXpUfLOLWmP4ZvI2CJDMSWyX?=
 =?us-ascii?Q?7J16L6YG4aiMmph/MjS0Ish2E7IAMNiE0egnESVoJRfYiwOgx1+zrk2Sl7B4?=
 =?us-ascii?Q?PCFsgEWv5OCEdVNXwGpNrunGpHOobeFc6a7USlG+p3L0YVLkjoNPySpivBw1?=
 =?us-ascii?Q?lmz70XO2Uf2U+r7uQnsIxEvcHme6Qu+mzwPbRYhYp3ArLPvLN6sgielTpTjw?=
 =?us-ascii?Q?rNKw2p1LVvVag+iHbi3Vl9tJblS63y0mTTxFjriQQLa3z49LQ+o2VSgkjuMS?=
 =?us-ascii?Q?BpCwbOlvTvsrRhKXvyTQ9hcxyul/0r3e9vcoxkbDnn1wkBY8Wg9OKGMkQcaO?=
 =?us-ascii?Q?pYJJBq6IuoCAqb0MEtwn6GiXHHx+5Y4YxcIVBGlusM1cXCICm7FCpCA2QBVY?=
 =?us-ascii?Q?N9phhQKFZl0ur9QdUYD+u6W8yhxFtttNYJDTS3RWoRL9t9BOP0Ja71R5hjFP?=
 =?us-ascii?Q?mJrUeoU84+HAFuLDuzjDk8NRzsfLxd/adzeQo3WH+ytulD7rD/Led6ppFpcU?=
 =?us-ascii?Q?WKsOHS7bC9Bbw0St35oy34idrRsRwSnby+TrLln9PIrYqqNMCnqzDR/Fyisv?=
 =?us-ascii?Q?s55QGOFkJmqc0zt2wG3hTddMVghpD+lRSE90HLB5MCektt0a4Qp4llh5fOK4?=
 =?us-ascii?Q?qvlOLrEX0133WTiP0ST0buvR1WDd17nS8nv0bDMYn6PKPQ1tgZUuC6x30T9h?=
 =?us-ascii?Q?Qr/1/SqwRzB0hVG1jDv8fEnQijoFkJxvxlqEOd7g6FEgImF0jIpiUINcDiCL?=
 =?us-ascii?Q?rPHJ1oBJEO54Bt3uEgFA7xOs0nkiGI/emUxv7ad1ugNu0D8/LgYmY+n2yAMX?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab4e562-c39a-4c7f-85a1-08daa1c5e539
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:15.3821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YqGIa5elZ2aQELfKCXJBgRRlbqfRDF0s/2QFqHNmS0JpcTqbk1HDyxD/OaRbAehbwYQSChyUP7LXfVJkVCxS6Df0ZV12fjL2bWEOA9+CLnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: NVgbRLeBEWPC0vieixIiSKZ0qv26xf3I
X-Proofpoint-ORIG-GUID: NVgbRLeBEWPC0vieixIiSKZ0qv26xf3I
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
 drivers/scsi/scsi_error.c | 63 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  | 26 +++++++++++++++-
 3 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3f630798d1eb..4bf7b65bc63d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1831,6 +1831,63 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	int i = 0;
+
+	if (!scmd->result || !scmd->failures)
+		return SCSI_RETURN_NOT_HANDLED;
+
+	while (1) {
+		failure = &scmd->failures[i++];
+		if (!failure->result)
+			break;
+
+		if (failure->result == SCMD_FAILURE_ANY)
+			goto maybe_retry;
+
+		if (host_byte(scmd->result) & host_byte(failure->result)) {
+			goto maybe_retry;
+		} else if (get_status_byte(scmd) &
+			   __get_status_byte(failure->result)) {
+			if (get_status_byte(scmd) != SAM_STAT_CHECK_CONDITION ||
+			    failure->sense == SCMD_FAILURE_SENSE_ANY)
+				goto maybe_retry;
+
+			ret = scsi_start_sense_processing(scmd, &sshdr);
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
+			if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
+			    failure->ascq == sshdr.ascq)
+				goto maybe_retry;
+		}
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
@@ -1859,6 +1916,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
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
index bac55decf900..9fb85932d5b9 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -65,6 +65,23 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_NONE	0
+#define SCMD_FAILURE_ANY	-1
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
@@ -85,6 +102,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -330,9 +349,14 @@ static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
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

