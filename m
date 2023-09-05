Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE08CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242388AbjIEXVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242001AbjIEXVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:21:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E1EE8
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:21:21 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385NKkgt029633;
        Tue, 5 Sep 2023 23:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=I/csYn6D4FRCNBnPQU2CZhFm2OeS/wCs30Ju53Be9VE=;
 b=JNxDF5n/2Olqn10mnCCqZrRiAdlZO0KBZzFMPPrpQyK/SopicFXhI7IiQIul1fgQ2hSS
 h/WxnleIIIS0hs0Xedhs+WFQYNdI9bubZ88wMFuhggMOpFht3xvyyUSkTJii0vy034gZ
 jEmcEBpGjOuWUkmATcprfDJjqyoY37CEbfcCHwBLaKRlqlNIij+G6E7YAoey+uHL9FKR
 /qHbOrlzDXvHJOIrWtcJmRH3bfhQpLvMJjkeqmdW+IBk3cLdfmhS8ZnCcYOa055zQs4Q
 OvUgZf6Fa6ttDCmCQO3p5op29HJQfT/DV/em3aoE7slub55QBam9LIAnNSlUh2IhXCZJ 0A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdwu800q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:21:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M2ToY037100;
        Tue, 5 Sep 2023 23:15:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbpc5m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwG0aW0oRZCtPqvEsb21vq2ng2UMoIjYix83TxLNv5huFHJVX9QHDFAU+x1ZTd9O2fGztjkEmPomZxMEzrvMeOBHkrLzxQSaSggN78a99c0oBw9PWaDArmuZZ1q9O4X9PHfhohmMpkipUKlTe/5/DBOYrt1G2zv3my6voEO6gxmICMZ8BkyrZbUP6rLiYF8aTiCV4GINlaP0rOjLoVOoEqOAbUh6lTY5vKe5wqSn1xJAkW/6x3QIqVKeAlimKy8HwzBnlevF8qP0SyHf1pH6M6Zbk8UGPcOXE/ER0TMh4tyY+MCChRFy3Ndvl0NT4Lt3uf6FKrT2R5kWKI9yN/ojXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/csYn6D4FRCNBnPQU2CZhFm2OeS/wCs30Ju53Be9VE=;
 b=eOMZBtEarVkw3HIAMqSey2hD/UGy16wP00SqtmdDNiKpJXvf/sfbX57BUh3MXfoXINz46hAsPEIeQ5iLylprx4GTt0xfECSBpiWJ0+3zGVaDmL3fgNDVR2oeO/rixgfaw/wfOvchKwPR2EKlz0XoYtbp4IEuLWyY4a0P7tRcbo4W6Qo/anYByDP/tjHa8cMjInnjTc83fYmB4PIdV+YuW9SCUtiRNdaG6O1JS0kXFELtwN2oVpVaFoJgiS8CHqhxMM68rNqifsfITv0WO10joVY/7X21G02iZjzxzLHItECnbZqI6B3jv1pGUjvM9WT4F1dL2TcCCY8Pudnb6+fRTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/csYn6D4FRCNBnPQU2CZhFm2OeS/wCs30Ju53Be9VE=;
 b=RfpVASF7nHvEwt3a9EZ4ruAQBrBO+ZOdH0uxgxvn7wsBzyPphC1BFYdVNIbx8Xsbs/yMKAbeEeMI3yYV1xredcfuK78iES7kC29RdvfpzAb9+EmwfldL2hVC4RUsBxTdJukmzCQo3W/TwTcncLodqmAl5Uy+ZL44VC2N8Ec/plQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Tue, 5 Sep
 2023 23:15:52 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:15:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 02/34] scsi: Allow passthrough to override what errors to retry
Date:   Tue,  5 Sep 2023 18:15:15 -0500
Message-Id: <20230905231547.83945-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:5:134::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b84c9ce-9cb6-47f0-e7bd-08dbae660c99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFuTSXA2vvRkGf+eB8OgbLdTx6FBSQ9ljag2rye7pPbXnCh8FM4kzPcm6AMwndUXY5HhGZ7geJ6onxI3O8HPlwRkpVMlqVmqUzbG0noEQKiRkesaan9vF4WgN/7yDJJUxvuPdmwewPzebS+D5z5MvCOR4Z6ovZBEAHohFrhnCHghkz/gX/JaN4nr8ymbL24ga9dLsgxkbl6Uj3KPd7b9+pD2VEua/pFH5UIcG/zQJxCfvm7OGFtsGad9HJj5bc5q+S2X6JoMx8tjOudpU2k8B00OMm30o1kHaLp2jow8Kcizf2yHqWWxG9HKuf6ir5XNFk2zfbsXL09Jv1ETtisAXiWdbT76htCOzelXCS5EkO1V5Ad+wwVs9hGP3y5dw+EwiDcSyXUTn2iQ3c5D1TkakXJ9EcSyTe4PKCysYIBLgyTKXFBnidlOHwWMMQyxf2b1XmGyRNQXZp9l5rKZoq3eNpqAgfNpKjBrrsTY4+ROEQAD/XPwwyQMY45w6tFCWqhTW2DKeRL1Ec72EhgeNamD7G2UWxqCsZk22YwRG+ttk3iSL0f8qzxKmdnphbJhYfA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199024)(186009)(1800799009)(41300700001)(36756003)(8936002)(8676002)(4326008)(86362001)(38100700002)(66556008)(66946007)(66476007)(316002)(5660300002)(478600001)(2906002)(6666004)(6512007)(6506007)(6486002)(1076003)(2616005)(107886003)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIfpUkbdSFurLL0W73wuCeRwjubeJrhR5BHIYH88YeHOlJcB5FAalug49BG+?=
 =?us-ascii?Q?nGMvlsoWy59bOFE7L++57aagFvuIkcQ/yfxPl1rHXBBsbndEte2RBgr7JEIu?=
 =?us-ascii?Q?zf3xaBLZc2Yb2rc5+pfCTN7PBWou8S4bwZm/od+QkUFqbzF2NfHJK2f88Eto?=
 =?us-ascii?Q?HD+bmy2H42LeMKq11D5vHVqi97YwW6Mw0SOEyGhWNugiQaLktIKXZOtfOM6O?=
 =?us-ascii?Q?p96H/WulTaZ6jGFCjp4NmIU5iDM3wWC6Bhk4k97uJtFyHdGtEWAuvQNi87Kl?=
 =?us-ascii?Q?UhIK6pNWwohQOEUTWyqLFMhwLYJm0E7udJFPM1Dk7M2+hbijcROBBjdyivOo?=
 =?us-ascii?Q?wHnymL4/eGNUKR3Iw62HiPnBFCoLd7cKoWnA8mGyS4eDQtpTCgNzaCw8WvKA?=
 =?us-ascii?Q?Uh1VqRA7r7GBxcH/SytCoTRzPb9DEZlccAX9sjbpeTrpQy9CHd4RiKG3lSr5?=
 =?us-ascii?Q?/1SDJWKMXB6Zl3cmyTiS1dHBKGSFGY2FEFaPmWNZvQCBy97+v9Tts/oJUCO4?=
 =?us-ascii?Q?9YVJMQnX4BCCRkYuS37ZQ2gcDM7bEjNxWUXV4QLO5jVkjZQ6RdtIT46nwKh9?=
 =?us-ascii?Q?CA7WDm5Hguii07MBvc2T1Aj38aObmZiSY1NP4WnpOaojf3V6ekLxpwK6UmDj?=
 =?us-ascii?Q?V4Hrm32J56O2+kT42f/EWYw7fadA8V0u0lt44UFNBcKGhBJNMR1eUEKsPw6Z?=
 =?us-ascii?Q?H8mytGaumw9jaj0au+V8EQg6bm44Z/QHhv8dcPsQb4V44IR0PWYzu7Y7tPLX?=
 =?us-ascii?Q?xET7Hy1SxVZnvTUxQE5ZqcP/xbYRU5CCG4pHHQFOq280uKDr1rtTb0DW264/?=
 =?us-ascii?Q?5X3wQeUERXd4/XiAJFbSwPAvrWzQOLvZ/DDNXDlV05Q22rFm6p2K8gMUcrpY?=
 =?us-ascii?Q?iAACtvXxev7YCIqFw82g3EhDWGvrtlcuA5U3dDJa5rme0wjFtm2+y3Uw4zdC?=
 =?us-ascii?Q?RX+7bejEDfm1BYAUCLF2hvelqmQGhsW3fAUECIjMQ+8eHEwd4//HuqRlZIuY?=
 =?us-ascii?Q?0x7G8mkSQfK9xYG6RX9rwpk6cdeYyjb4n0Yt/fSyesctIqty4AM3Nc0HkYhX?=
 =?us-ascii?Q?OnAu3QWfC9i3yXZSXqtRmP7TLyssx2AQck3rySskGxLQLdnBcYEJnaODfeUS?=
 =?us-ascii?Q?toUzSZNZf/qLCx+PDcRBVr7iV+tbxcgYL8DLua8zV2IQc/XSojzZpCGn9Rdu?=
 =?us-ascii?Q?OsIJwQOmI6WIwEoOMUoycU1v6mqmq2x8gfyVDk999fnNQi2HEP/ic21YjAoB?=
 =?us-ascii?Q?0uJnAFplhjpaTEeKxlOXUZky10Sl5qGJWR078JiGTpoXuy9WrY+vbiLrWE4H?=
 =?us-ascii?Q?n2kl6ISu7YY48gam7pchON7KkCPwxgXd4tATBBx/qzWCYiVpBeliLRTZph0a?=
 =?us-ascii?Q?eZtq7MM7bTApIue7//6XDCvalPs7t6ZZUv0NhFF5tYtL04/+1VwMCIffScCm?=
 =?us-ascii?Q?pWn1ZqQex091ofiFbL4yMheQscAJg5+hFeqsaCs7budh8TBACtUh7kkXp0M0?=
 =?us-ascii?Q?QBJdqAE2HYlyBuM8+qNh464+fpLiEYOnpBMPnSeVHQYaFVDEqqbodiq5uJKi?=
 =?us-ascii?Q?H/CXmygLmBkjbkxRsHUgjxd2VWVY+V4z8LF5NzJNgYZDWtSK57uhGiJ/rGVX?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bOJWz79pCsqkSNFdUW5jAy21EUU7wslGWkjupFzysQ+Ix0QgSHxIUiYMTDCtH3ssZYrXneUn3AP+f2BJHbfdFWqUhDKeKCdTBoRirjPsLaEWXPdfNBVSImK4BRg9w8FYrkQv+hNzNSu9gYy5PcH224pKILcCjpl1DGpD1ARVVl3+KwYLGU37H7AxfwC65OjVL8VHl9J/Iii//stcvHwSQOSYzaZSTi2iGRJ9v4HFIyD7/r1O6jiK7HeIavM4Tm+rsUYIzQmHaTeb+e10gyjaIffeUf4qmYkcmBDt421YfHLPwulemUMkCqSH5h2DjNjlZzSBzpBUeAMGB4tyAk+BfFig5LI2S61bVrPTdE+aq3plR+Rq2OpD4/MXj3o6bqj95lFexBfg+PQtoEqDgL1uBGJPInVlWAPb/alvhnzJZSC/mfzDw26KvMaG1nXvc+55NOY1Uzh6UH+dadEJN7J8vNpOXHReGLUb/XWfYI0oeIZnD4/3JvAjs1nXGZGpqpfVsQCGuljdrI5UUIkkw93J3EnQPs/Vs9pUdpil85pjJuxrFclHm2EVOdleokio3YBV/GqZr1dgaZP2vID7HbxOkH7yURhyt7BJlgTNXfVJa+2DMcbRdY2B8QyAtUhpBDHyrTqeEqHPDC6plfzirzLX49pfJenfyjx5tkYJstxtkPnGc8dGglDIQvWWt/vWjbgtWzWEIqtpnKflim2Hv0JyA14fc2PWEvd0tUMROYUX5yN7wFBZvofXpV4ojOI9AvETuDufJ34COys9bl8RiiAhRAHvDgIz5OUh2hOqu9tDirRqRRY6aMw//ZtfTfMRnCOajf3A9bTJiEn0PBgmktQW0ICR+qPu1ggrqcDEd9Tq/Kp4oZzlknK0Stqg9jPcY8hl
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b84c9ce-9cb6-47f0-e7bd-08dbae660c99
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:15:52.5698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bsaZaZotsDwRbLk+3ZX1o8pTxJqm27rbeuejijAhZNi62kHCp65s9lUeyUxLJwikhbSpRUu6gcSYXXMhyQyal6lvWtB4rMUJOhNwOH+35M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-ORIG-GUID: woBeyQWOjYO7erw163UB8rUOX5GXc1ut
X-Proofpoint-GUID: woBeyQWOjYO7erw163UB8rUOX5GXc1ut
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_error.c | 80 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   | 10 +++++
 include/scsi/scsi_cmnd.h  | 35 +++++++++++++++++
 3 files changed, 125 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7c3eccbdd39f..d2fb28212880 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1872,6 +1872,80 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ *
+ * Return value:
+ *	SCSI_RETURN_NOT_HANDLED - if the caller should examine the command
+ *	status because the passthrough user wanted the default error processing.
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
+	if (!scmd->failures)
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
+		status = status_byte(scmd->result);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != status_byte(failure->result))
+			continue;
+
+		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
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
@@ -1900,6 +1974,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	}
 
+	if (scmd->result && blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
+		rtn = scsi_check_passthrough(scmd);
+		if (rtn != SCSI_RETURN_NOT_HANDLED)
+			return rtn;
+	}
+
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ca5eb058d5c7..7c3e18663c64 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -184,6 +184,15 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+void scsi_reset_failures(struct scsi_failure *failures)
+{
+	struct scsi_failure *failure;
+
+	for (failure = failures; failure->result; failure++)
+		failure->retries = 0;
+}
+EXPORT_SYMBOL_GPL(scsi_reset_failures);
+
 /**
  * scsi_execute_cmd - insert request and wait for the result
  * @sdev:	scsi_device
@@ -1129,6 +1138,7 @@ static void scsi_initialize_rq(struct request *rq)
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
+	cmd->failures = NULL;
 }
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 526def14e7fb..0dc937511f2b 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -71,6 +71,38 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+/*
+ * scsi_execute_cmd users can set scsi_failure.result to have
+ * scsi_check_passthrough fail/retry a command. scsi_failure.result can be a
+ * specific host byte or message code, or SCMD_FAILURE_RESULT_ANY can be used
+ * to match any host or message code.
+ */
+#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
+/*
+ * Set scsi_failure.result to SCMD_FAILURE_STAT_ANY to fail/retry any failure
+ * scsi_status_is_good returns false for.
+ */
+#define SCMD_FAILURE_STAT_ANY	0xff
+/*
+ * The following can be set to the scsi_failure sense, asc and ascq fields to
+ * match on any sense, ASC, or ASCQ value.
+ */
+#define SCMD_FAILURE_SENSE_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+/* Always retry a matching failure. */
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
@@ -91,6 +123,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -394,5 +428,6 @@ extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags);
+void scsi_reset_failures(struct scsi_failure *failures);
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.34.1

