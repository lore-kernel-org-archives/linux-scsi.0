Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF65EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjGNVhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjGNVhj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DE83585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4DeV003063;
        Fri, 14 Jul 2023 21:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=xeO3OY03byPU6wlhOa070RJQA5Yv99PU5o3E4I7j5Lk=;
 b=s7tuJTgco4J0pv0grK/VxRwTfNWz/xhunmNDJbZH9BRJ+3ny/je8MjkJEDqhpF87/UfZ
 hCJqS+0Mf793aZleAYbxlPPh5T9VuvN4MsJ0EckduskqUjUohcPmbtv0dazS6lJNr4r1
 Hq/XiHdkOHIltoO+Z8+fyvRKJluXsJcgwgEHAUo7sUuFgXooANbsCIQW+Bg5tkyCg9d+
 /HpYUiEMqQSKyz+BaIjDEa9tNQ5Wt+uvP9qDsHQ8SIFsEjT0T7CmwWa14EsfgsP6NmXf
 K1Wnx2kInGiNPcecYXTRxOQpZs4feq/lDSAK+OUlq2yo24la8wJ72Q1L0DY+B/vS6b5v kQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqnct9u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJoV9A033015;
        Fri, 14 Jul 2023 21:34:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvrs496-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AS4xktQNyGtSIpo24O34BPAr7iika0Wr3Ebrvv9GREpdRSJyxRa2CmersJgPPcsuv07HV20pcXdFSquvUElGVagKoiQ9qCD5+KuN+fp8r1+9EVEt3wlMai7+b/N+ndsBf6K6Z4wV1RsNKjQNyzWPMNWgx6hlH/MDkbAGPlc9iRB7C4bdS+ZaM4p0QWBPhhD+MJxXXzwAKvVB1+pounx+CLyF1wpcof7AtxVHqe4IJXMBLfY8SKkSpNS1hXmFaCgMSJvFUCk4UwASVpCYlto0MQRyklzkFD6zf3B6UXIjo8dNC8nc5L+IxGgIs2mSM9eFFdwEj0OAq7DuXGbod2nBtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xeO3OY03byPU6wlhOa070RJQA5Yv99PU5o3E4I7j5Lk=;
 b=giyic2fGKhULbfT2y+PVl6aI0a4+7LqFQ5sBxUs0DcC/vS0uRN9/7pfeoHycEzTG6AEBq/rL8Dnfo8WulV4sRdTr6OB9v0fQLXPd1Lx9HrQXJ/xQMi4uBehXDM5fh13QW6quzTY7OIw0J3yTVFUesK8zRft70EjJVW88NKiX82X1/BMGUgMzZCAyDPoPKfUstC8UHw2vVd9YAC4SUyx2U/PKaVdykSHc/Z214nSJ8dTDDSkcxTwgfVsmcrj9sNIuEQB7IHwwaGVY7D7wDn6HUvQEoEWVFnI5I5VT8cJwQShnrcZf6xjSa0n8/qP+km2Yt68P0lI320oWOu4kyWWs4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeO3OY03byPU6wlhOa070RJQA5Yv99PU5o3E4I7j5Lk=;
 b=wMM5aHgTGkEFPFEP16WCHYSxTwSwUc3l8X1nYOtnTKb+yua/mxavY5T7CN423a8/QUMU8MrFkuiagmnwIY/DKBkXZCQwI4nqPdxpsLAJdu9DE8OpJfSGcHp95j+xuTN22I/7tPigT3+t+fDUCGSLX2ZqVEBZxVTfEVZgVy3wJN0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 03/33] scsi: Add scsi_failure field to scsi_exec_args
Date:   Fri, 14 Jul 2023 16:33:49 -0500
Message-Id: <20230714213419.95492-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:5:100::47) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d47a29d-d831-4ca9-7225-08db84b21982
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qi8FWmjs2BAkB2ptrH2rV/gXklief2DhWbeZTE3V2nLSqCg8MAVs+YPmzgQhmob2JM8FOlR+5svy/OivE48wbcteaEqn+pDzvodu/YLtMYMma7g13FykrlnAG5OCOMMS2hp50Yae5Ef4OXyHMcl7RYd9ahJKvc0GkEI4Fs+slC39bjRsaKwyNPz/mASQFIvzJFE7LAHrUATfuCFFBEK+V4EKdlcI52+r1yV3FetDVEm5iFRdgG7lRe3VibPZDIvoJknVe5iOTqc5fkibRLE2vEES/34TPwUkiXWEaoj43iCN/oGMKaMmia9GLDwDA2fdVaqwTVqK6eUaqGJ52L77s/gO08lYtKj5c5zA/LpbpzMH8V4x9hESPP/3QFeTYKSDoc8KBgnozxGgzQkV0DbatKRBG5Ex0upfqfKZOI+rID9HmpCwk7YLEuQQw1yJryit6x7OzmcrAKTysNg3YcJTsqsW6lgawzChbiZ3OyxxBFQXFMSupTzd4aZ0Bhu/bT3TDRXKhGO9H/jMkHTyRygwzkH2VmPNXlsS6hPtJqNOT/E9UsZjLL1MeZD+FCvyc0eC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqd5SV5llw0WTsZny8JRjSCcgGwJGd+/Cch0vE6mgBjTkyo/cyiPXceMca39?=
 =?us-ascii?Q?SnEeQSU4QKYPEvN2Mho9V5agF5tdx4CDJtLywDx46tiDosIOYqXM/JOCeLw1?=
 =?us-ascii?Q?/bGXrdgEKT/UK1BayF+7kPL6c7bPbl2oME7OToPszDW6Nety7OlzglVw/zcq?=
 =?us-ascii?Q?1L1YxlhPkLTxCqon2dY4NjyVbPkZHQSQf6jFmnz0O7A/+Y62AEiztht7admg?=
 =?us-ascii?Q?BkRDbhVqrs0bXcVXoEFhgB3lxP3Ri8/lAlJGrFB41C/mogxj9GrIf2yedjz1?=
 =?us-ascii?Q?TOCRTgu7GltJoLfPEiEOqE0gNh7qeGyWOqpnU0fEs0DXcRkPdx1IvetVYsjk?=
 =?us-ascii?Q?2CV8W4DT8K6GT60RJnZu5+KfrjSgmP5yEiRAYDwqOTPJ5XH6uIXLf/MeaSEd?=
 =?us-ascii?Q?5uGNPgV4wExVWsq/vgiyl6KyBz40eWpb7KMtC0VhIGqbsuCxkwCw0nUJQYSu?=
 =?us-ascii?Q?yIRdRWXij3XQyHwqidnIZBAm4ga9VdqlAq6D2wAjRXg8TkvpYhrr1obFyMTT?=
 =?us-ascii?Q?f4Wavf8wXsxOrSEkjQhZCrl6EjrOvNAQzuQ0rP+KLVu56TV1oomDkE7ZnGk6?=
 =?us-ascii?Q?pwoSI1OQPYetll/FylcPrvdZBXlTzGedpzWVvaaUIDTtO/3gms6gdPmIKSTy?=
 =?us-ascii?Q?2ua7eL7pM+JDUMwOhx0aRUuOGX3zkSl3dbjH+siSgyXgoqPTZOAE/28UKADE?=
 =?us-ascii?Q?LAz3LdlsG2tjwUqt3qkTTQqGnziSpw1sNJCDZV0lWDdFyr8VmSP48NqymK4I?=
 =?us-ascii?Q?0YQZYIVQzqwHC61Vt30m+h6J7G20gyLDnD2+LAS6Tk9TkkrSsu1q/wAqPs8W?=
 =?us-ascii?Q?11LDxkG9pIpKqwxp7FoO12B0qe96HltevEF4jLj2H5xldpguPekVCtxVZpau?=
 =?us-ascii?Q?BPYcl+uiUIrIDvvkBKaJOdYAaKScG9dhUp01drnSLxvWFDdwt+1D5bidiLsY?=
 =?us-ascii?Q?PeWqGAJ7uvmgc6hizF+Bf/CD+Ccf1JMNnie/8JDe1zU8ceETj79gTL9pphdP?=
 =?us-ascii?Q?73G/V/UaC2gLxix+l4/Laeo8cBsNhhYccYTCnxk344SpksUM4mbh4iVp3kGm?=
 =?us-ascii?Q?h55MPETYZGfx+bZjwA4/aRigQwm/KuvD9zo2GeCegwCNitH+cP8HB57lrxVT?=
 =?us-ascii?Q?GTTvZnVV9Ruzt9Qdp2O88t7kWZxWph0z2oZ/ylpD1KGc7gWzuEMw7mCM5n45?=
 =?us-ascii?Q?zZP33X+ofXPW06xC4DbDgLKM54ERsrrxQ6jfpDlxIUBbCTydtVOBmBt1jeH3?=
 =?us-ascii?Q?3a/eZvux6WSew562ockUWMABxjSbSXaXfwoVZwZS6374Brmuu5+oEKk252nG?=
 =?us-ascii?Q?ojoNFgqDpZb+SSg6sxJqc7r42BSBqqadFh8qV6NwY8uSZjb6G+xPK1n8iskl?=
 =?us-ascii?Q?xncSjnuHMRnBVMQ8W74UeDQpr8Wp7IwOHI2ma9E8gpGf6b5W8uPsnFc4MoGb?=
 =?us-ascii?Q?KzUGdzQJagPHFqmjb8ENUxye8o3EZyGWmon8OAXTSseE9D1x1yG1jCKpBs4X?=
 =?us-ascii?Q?AHL1Eonmr/j7ZjzOEsZEA9rlF8l4bbiyqdXR/u1ggo+raDdS/mlD8uz2xTzg?=
 =?us-ascii?Q?xe7/5WkLSpUM0CfBhT7Nri1U6+RPITjvTGzxWBL+91SFwutpiyxTETwxGIQF?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Lm7ZZnoPTLbDUIOsdJC42q3pcJWSlnI2mAeNVXLq6RNNPV8C8sPDoSKkabZGc+tMQECf9dumU2bwYWxmo54EvF8oivM0b5ZSrTGZKbEAp8vU9bm5kTsSut/5hA//wR4JYDOeYRJiEHEsWttPa31RCxUHqc5QGu8pWNvVMQ6F2CLx4/NzIJ402t4TO5K9Q3oL2XOS+XJNptm6S5Bic8zkwVp4UQYOgz67wiXvtcCoMfhuBCjlg7xp36t2W3RkRpzKdGB0HDz6E87PqMqWyyMGA9wh5ht7zGIK+d9ftCKORwpAU+UyKQnVw3aMuTU6qQskGbzD7LaCTfiAJ4ba1e3XqHj8/aFUq0/VarA0wlw+BktrZIGohX5JFM5SOolkOaJGZVrep6IeyR3iZuAOQVzaV23LWybCGdf5lq9Nso/YXaaVJym9vkUL9QIewQf5o/6ibQuIWL4c2ZR1IJpbdnjNAmXvdyOaVF49xq/eF8mw94EN4KcEcRE5i+lH55+DbOMBryArIoMCQ0aZdu/BndnfnEMyEarQZDbJJE6uUuZlRMuWT7LP9CbECqhy91i6Elt/Bap5We2zvS4bLNDrLCzNeUI/ezgv6PDMvxxezRmUkFPYiWvbOBkkhqNowXxquaoFLPMll9z+HOMM3cYteu62YSzXtMCKA6R4EG6DTP+qs2FeGFAm4G4JPdNWV9WctNd0gOe78qCoWt2fWSjNJUWz1gRO9sEbfPDjzsXDMLrwasxIeOs74HU4fkY5cEpO8fyUZnhE7bCuAfv8A1+F5VXw6f3NDiS8vOZsxCh08V8sIz6AJm+lYSshcaToVGFpznTa2YeiZoC0qNp3S5ADUByNFCN51bgS6tUpe/GLHhzHV1ONnSqL14lVr+aquFvcIREM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d47a29d-d831-4ca9-7225-08db84b21982
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:27.1585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkYKHMAekS6nFWlGxOh9Og7zfv++RhvqBGhu9M8NCO/Nq609PQHgAO3T8yQcOx6z4TA126HyLZFLw8pIB2UJ0ywPBaZcg0gD1wV74xfPwwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: ZyJb4ACZ_Y1CmO0hZP4CBsq8nYZe2Uhq
X-Proofpoint-ORIG-GUID: ZyJb4ACZ_Y1CmO0hZP4CBsq8nYZe2Uhq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 68f4bee73ff2..0097166814a0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -237,6 +237,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
+	scmd->failures = args->failures;
 	scmd->flags |= args->scmd_flags;
 	req->timeout = timeout;
 	req->rq_flags |= RQF_QUIET;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 75b2235b99e2..accf6c80591b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -14,6 +14,7 @@ struct bsg_device;
 struct device;
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_failure;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
@@ -472,6 +473,7 @@ struct scsi_exec_args {
 	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
 	int scmd_flags;			/* SCMD flags */
 	int *resid;			/* residual length */
+	struct scsi_failure *failures;	/* failures to retry */
 };
 
 int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
-- 
2.34.1

