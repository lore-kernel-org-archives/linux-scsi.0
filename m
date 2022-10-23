Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AC4C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJWDEh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJWDEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:04:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258DC26CE
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:04:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2sqqI006776;
        Sun, 23 Oct 2022 03:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=xggUMucoeCGKmNgdDNHPRXQiBcswsnK5bhke0LkCycY=;
 b=aOhAF/aXTTGfSsznxSOMf7WdFOu0KRuK2uS8S7AHmHkdDtcy+D/E3mx7+jYNvu46t8W7
 34ix/+VojtUSxmvUx8FPWenC5zwl2Ju5knkPRoSdOR1zGvYRmhGEv3nX+Tqw5yEtXbxY
 OPKH3HXjFmOQ3U9faXO78iPxcB5mIrM2+/jbyLB3xEq0Gbmzz33FpKr96iOhHw0o3NqK
 juto5FBZSvGTBfsnga08hhF+NyLy7DQUQppufCy5fXCVXZ0J925TklqaBfPcjZRvQZac
 1tM0Vu64H3j4xPJ9noDNFtO7ZgmoHQaDUK9sONfXJPhP5g3Le6FSbmh/NaF7AmRV6flQ uA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xds4v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKI5b9040561;
        Sun, 23 Oct 2022 03:04:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8grxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pl9fqplf3+JBWWTtD+Ls7DOuuEfjcthFJ6E4yuGhdlxMo3E+DbV6WJhHTzs7M482tOPD686fxwDH1cG1sb8/qflBgGzUMXuoZ14U5utn345lgIKSBGdE+eNEP2XN42ATE8zoUGWwPyDnmLFhEIMVlLMg9mFRfpHOIc9FvQlhcxqrlSln6T3F4F3WGktgAOj65OWD2U5wA3DBf8SXP+K6qJeEM27gojcoLTGnqhAnqkd7iFSys9oAMzueheUuLloSwiSGVFFJ5+hLAF3EZKGIpEuS2nhaC3AHECHFM1TXZYlY9KmWU6YK+N3xCOkPRZhUvmfvj/Z/5HpyRdhXRHo9Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xggUMucoeCGKmNgdDNHPRXQiBcswsnK5bhke0LkCycY=;
 b=Z03+Lrr54NHhcZJ7JI39HiP1pKwl2qqXnLVH9KUUjIXVOuuQaC/+Jmpv+Npa4jgesLUM52ULDh1vi6LfRe6oBY9gtcYAJpxc9MOnS8aXbItbmDyjZLNnRne7I+PuVA1qgVeyux5JfAUlAY5xIKAbst2ySvoKxcqiyp91PLHvURI0eJ4fssYMPR3vv2gfP0BYoBBIMpNDF/BfW/z05+mMvGkVwG7ttOcgon5UEZ7wZN9F0IW7oT7de4LrMcPIUxUX/PTGy3hW1kpkwYqUlhkSN7XmVo6pRZUZcfcFsqp9O/pnmUtKiHpxOGqbVgTcRKglQDBJxt44vlH1Mtg/sFcn1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xggUMucoeCGKmNgdDNHPRXQiBcswsnK5bhke0LkCycY=;
 b=pxIKMYNDxZpzjCb+pxAW5RlKl5dNxvacj/IaKw07SxvCDwYIXB4kcom/GTI0k7tiDitTlfHOGyeJJ16RXI2cWQ9nJFdNSSB8LVVKmkcfGsi7G6YioxKzMWyYmuBiiqiqlUjcOd3/inYxHpjZZ+oWMSWmVdp7al6eeGhW/x2+hcU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 02/35] scsi: Allow passthrough to override what errors to retry
Date:   Sat, 22 Oct 2022 22:03:30 -0500
Message-Id: <20221023030403.33845-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:610:cc::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 8205449f-72df-4d95-9705-08dab4a34179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vvaswptCMTaBmd0/FKuRX7y01XWypADNKxaMLo8qygMJDhlge9ASHfl2EwHndW1WYWQFgDsJ7Cl+rY69OM10F4z2YwF5O2Y0QaBgoS7Otic1zFfNV0wmqZWo3VDjKdsay5eVTLO7afMHhGDUUsD1dIrjZ6KVXcdwj0HQk42nZTTeCcG1F1/6glA4KdXOeYHArpzc63WSuudbw/o/+Jaz9+zKqlSAvWS57yx4/rB2JXx2aSNT3W62se5n8OLwn0M/VU74K1KVzKw3aCVP182sKF3dAwxOM6YFnBHR7AhpfyjEZ5DkRO6j9GIihfHF/i1IM+c7gLbzHbLfvrkGqHai5DI53DA7Ta7Afn6lCeLgU9Qgs+6fkntqhrPs/wc0+zPUNEXq0rHVN9cja6Mg3idLwGo3lIiqCgmuWI6Uj7z0h/phrvETmn6XbncgojeddLK9LsHN8f4+WfwNapejxAKn1O2HdXIprTWAa6QH07HxX6taqrh1Hr/4wrcUUhmZaeVgQkoevkTPxRtXi92PVID3ccL9oCOn5N1He3tGbLtr0pHBtfTHenlipAIuZgYNl7R8cMLj8xKiSZk9PVRBjc5XF1Qdecrg51Z7NZRPuiYh0xP35rxbY/Da0lOJcQt4prdy53AKpm1RAW7HlemcvM+bNeYAvmhKX2uyQuWWCVE7lqHh4+1ckqp1Nktm3NQDiB1d7tzqlIYnf/hUQbfSVNDYeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fSXPBb2wJZQG/vtpOftfROQ9FM9GwpRiid4XDDSGmsYbraoctfHQVpfBlsLY?=
 =?us-ascii?Q?/QXlULL93dA61i+fzCn84c7tb6wddnL853/cv8pD6lj4+YqvFnQVtRxms4S5?=
 =?us-ascii?Q?DS8R1bYZaEWzvLvEc64TuMA8tI0odCu5f+D0bwkWHVKJywsiFTg8xxId9UCb?=
 =?us-ascii?Q?aXgA/q2PJ6BnBLNNjTZqQQwY7wGrYmRq+GoA6/YjanVdeLBzxmJVMI6DsIcI?=
 =?us-ascii?Q?p7A9L/mQjWGLDUP0XSjpldOWM2ZVt7ROTPdggYNT1Cb0AUpyYYz/wNjkaM1N?=
 =?us-ascii?Q?tAKqS44WRCma/CvqtXD4bbR55CqiZXHcqwzpM2b9a4r6Tfs+A/cb9lT8zq39?=
 =?us-ascii?Q?q/rIGQv8rtROKzczjlaWu548tSeQ43es2XYT6he3rL4C63ApufsW1+wTTPhV?=
 =?us-ascii?Q?BAFT0q8GqqiJrG3fx4Maaz827jaA/QKGypuhY4Q64CIy6LQzWEsllGIbMHp3?=
 =?us-ascii?Q?W9M79eINcYP7IXtciGNdLlS5zZwDxCOOyTeBaRTyGkDYBx2CLxDjj/OsfSln?=
 =?us-ascii?Q?v/jY7uTLQwxBMBBg12N7ifKtvcTV2ns2Ng2JISKKexU2r1N0s442ZoHYZG9w?=
 =?us-ascii?Q?8QN8Va90xeYanQfYuxN7y8iHdSgvmYINc+7T+XY31W2sP8+vtLuIu36EHZN+?=
 =?us-ascii?Q?3eeYRMlQngoQQhZKKy5BIdgIujxoK6EoHvwRux8NzxwKhQQLTTV5OvTC2HNQ?=
 =?us-ascii?Q?v66tZh6G+uqXAamGNPNsj3vgGx5TzGRdnWWgUvBad9AyVYnvRDiB2ad4Cjub?=
 =?us-ascii?Q?/nJC+D7F29TehPrHXRYjnXBqULr9Hk0DDWrOGoJpyIKPkD1FlT4/GrQpAWzK?=
 =?us-ascii?Q?yZIPEEKby9L6NP9Ex9bgILcLTAS+DJ8uVEqWen7nGLN5tbs+NdywwN7pIOPA?=
 =?us-ascii?Q?Ag6Hgui/FTX2GpsGA0x8csJx8hPW0B/jdbjm6gWb0KliEXpJ/AJ5lp79QZSe?=
 =?us-ascii?Q?xnSese7Zq8CYI8laoqGNa+A2iJbRphcTlVIfU7HUDC6WbmMwHifHRCIOT5PJ?=
 =?us-ascii?Q?GBJGN7TAFMIUx2q7o3jlhXZtizR10cK2rLeyQLEg+SDWVupLjtCwLqfHT7vY?=
 =?us-ascii?Q?/433RZtsgwi2uG2zUuikD7NWF5mWPjZSodFM6Dtgcq3tm3pi4JIPkICzeHhD?=
 =?us-ascii?Q?rVlMd+U1iC7jtRZFzkAHuAAG1CBl0mLEaKhrbIcHqgOXbXJaQ5vGwiltGbZ1?=
 =?us-ascii?Q?h8eiIslplQSiuxpdLeCi1fFknE24FImhRHFxtu33t5vFJ7QVZpJMM2OMnVqK?=
 =?us-ascii?Q?F4N4LWs2e/ZZyJzoTvW97XjxqTjaCIciTOia5WTjmjoVW33Fxo9q4aj24d1E?=
 =?us-ascii?Q?N4JOV3Ueh3WCVmjo1GQKCtqtA98LiFX4EUSoo05kAJx3pHZKF2HTtsCrpZr0?=
 =?us-ascii?Q?evQWLlvsPR6b3WoirHs2lHn1KOUbUFBdsoPpWcfUa7edoxmuxOWDakk34pd4?=
 =?us-ascii?Q?XNDQvQFFg+deP7bldga5i99Es0ScrX9gxLQeivXfkgXmGB0hkcHOeE3/PyRC?=
 =?us-ascii?Q?6ZrQcrvFvuFelcyw17LZJXIqKr73mMLkLIRHaJIE8rSf+nfJ1EaTHmR+KbNm?=
 =?us-ascii?Q?7GV7+2Qvq6NguAXDoB94z9G8pj6807tubA2vnFyLKzPn1IgdU2H3YCCkFebL?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8205449f-72df-4d95-9705-08dab4a34179
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:09.8440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcR9gYT/mxrySgXheF55cftWujvgyrZ1fMpNxF1rhQevqxInGnIP79/e8fLHO9JNN+nj5LNldLeReLyEGAvZB5ji02HPs6EyyooF+7W7m8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: xirIhmiFr0JrKQTnclHtD3Jh8nAZuQ5m
X-Proofpoint-ORIG-GUID: xirIhmiFr0JrKQTnclHtD3Jh8nAZuQ5m
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
 drivers/scsi/scsi_error.c | 82 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi_cmnd.h  | 26 ++++++++++++-
 3 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 36ae7cc5e7d9..19548a1d69c0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1832,6 +1832,82 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
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
+ *	command should be completed, go through the error handler due to
+ *	missing sense or should be retried.
+ */
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	enum sam_status status;
+
+	if (!scmd->result || !scmd->failures)
+		return SCSI_RETURN_NOT_HANDLED;
+
+	for (failure = scmd->failures; failure->result; failure++) {
+		if (failure->result == SCMD_FAILURE_RESULT_ANY)
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
@@ -1860,6 +1936,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
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
index 7d3622db38ed..ba629ac4525f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -65,6 +65,23 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
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

