Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6561FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiEQWZO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiEQWZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1F152B2F
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:07 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKQrO2023081;
        Tue, 17 May 2022 22:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iBH7ZMb4i8Ewugl0DvVdhVMvaiN8vM+9EiRVCqRLlxU=;
 b=FnDwY2ljStEQ8azltNVY0BgAYHF/0/86+WHmyCh6zk75V/ha9AReWIyUQXx6rqc4rr9H
 AibpRsq/DeKt712eKF53rO/C1lrOuwvP2F9mdxuf1Mog3BVhoABq3sTbz0vvke9BcpB3
 E/fkovko0gk1U848VSLUKkluzMgpCkiGOi8lFnIn5QeOImViKfM7ksg5oZlwzw5Hp9Rs
 TCNy5Q7yiONq3+6jJLBjuFAChMPxkZE8JOWjBUZs91jJRklH+4serOU4Mryem52XKVeG
 6nTgw0VxEQfX2a9A4eDeigQMl+0/ttP79JuLICFtqKLtbrUMdImVpWOmk/ot32iEk23g ag== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7ncw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLgi0031743;
        Tue, 17 May 2022 22:25:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cppmnb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:24:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REwNfXKQHOeNdgn8ha+SNymUYPz+LEkxXg7LYUxNZjWnbEh6FXK2wdVR4J80or5PMw+F+YbG+6AF/LiVlr+6lxR0SopTxSGmZyvasGi78ol18Q/kmzIHODisXzP39ztOlyx+f68eJv3D6MUpV4+lx/4Rw+poeZQTu1vTxtgtoQJ6oQnKll7KkASe0/act2BzC01pSOzECUJOVqZfqIeem5XLbt5n6sar+jLtqSYBW5fozcJX6lcb+YGp3j47s38ROShSE8cZHI9HlAPXS8LpQmvVz/iRQc/8woj8moQBF+Z9n3NIjYJtp18YS9fhWmvZib+tK0Il7dTdrnJOSMGPtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBH7ZMb4i8Ewugl0DvVdhVMvaiN8vM+9EiRVCqRLlxU=;
 b=oUs7xQYJOrDnDbF9U/ITu+hoj8YPm3lI1t/KhqIoIS7iw//mxnTXvF/ZvElVZFycMVjIcvgWZrvgXWP140DxaWKuOK4PLizDnync17f5fJojrSLsxijw6u/WFyFt1I3mdU0Ah3c8Tj/2VLkRmUI9r3tzAHhCoz2w1vfBQYQcGZDMuMBcqmANURuuSk5dIC1X1CwPr7iBwNX1rx1PYQ7UeNmF3TAtSqCVx7jJDT9mKTS9i+We9KmWE0XmxAHvEpXKx4VFcZwYlrefmkiziQ0MAm72C3nvXpzqIJCOv0zEG77/XdqwnbuUxHIwvUw5LKZrkNZkWApU7xzHTv3TRAKTlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBH7ZMb4i8Ewugl0DvVdhVMvaiN8vM+9EiRVCqRLlxU=;
 b=b5LJhMQ0t6Pyzhp/MvtBmlXfOftvrrmBQWjKAMa9lnRoUfo6hkaNY+bx4qBgIRc992P+qlYqfElk4Zjoo0kyAtePL94r/+2YrkyGIIbxpAVNvdIwi/oHlNK62xK8M5tuvdoowp6ZVvZTSTmMQL/m/UyheMYbXp189lmx1MxNl4M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:24:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:24:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/13] scsi: qedi: Use QEDI_MODE_NORMAL for error handling
Date:   Tue, 17 May 2022 17:24:38 -0500
Message-Id: <20220517222448.25612-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 149a6315-2d20-441a-c622-08da385412bd
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB551798F633D48B66489F7C7AF1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WlrBTbhCmj/Ul979peoqQru86fLqiipyJZHEyPNECirU5FVcAn/Ew/3vzODZ5N9Bkv8QxOnatgfbjOhkf3LejG3ZUi+8IYI3dX7OMLBet12kolrO2JZ6Cz1Rc2QMDx1zgjjHz0MFqVFSqrRCKaCaj+TawS6Mwoyevf9fWRmum0ffr1bPQ/S2RuMNH7v0j2u8WIaGFOD5LlTqNeJPs7GEo/fwU3+LcUEpV9e5JVe86S4Cb7LQd12NmC+yx7vb8MBqaysSMjBKmFBdNg9T7K+NrqvonDhDl4mC6ZBN2CLwgahbuxLUEoT/rIXgs0oSnqmMsZUl31HIW6TOX+T5XD2h07DnW/KIah+fxZmeXQE4OWgtzHBl18i/aVM0N3iPDUCAWBZGiSZHexWHpceCm0V9jiCnsurozHybB6wXW086H2l/OLWqEQNPuNGF6FerK0xfbTf4nSs5XyusCKV51DyNPByQcVE+zG68VO8OeL3xAyzkjlqjA9PU/cS6jFgJ7FwIbsP4+4LbswgWW/O8A4IJVfNYSuaxSKzdC5ArnxzwZUCUIKcXZlbHaY/vuHB3FF8ngn6Mn8NG1fR2PFrjCvJpYPfsspbmS6WZMuoWD3M6rJu1rEn9881AQB4Rpr5kVWF/NSLcMPa0YXXEM7ARTjAPoJb59EdHFdry1QMhlWkCWMvsudKxWSfZ93LYcr95+eRWGDSU/dV4DZIHX3gMRXZOYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(4744005)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HIgD2y/nvXV4CQjJaSIephR+iIHqtX/k66B55x7st950eGz7rJ0z2ec328+0?=
 =?us-ascii?Q?d/ytWPWjlAVBDhqruREFXAGDQNOPEpo9EGmLadjglcE3232AHek2xZw8BjPq?=
 =?us-ascii?Q?B/oXzITg47D33zOpc82ocnP1rBBnOafInb278iihgcVZ6mzJ2d77S4CSdiCj?=
 =?us-ascii?Q?4LU4Uky4FjkH95A6ZHu0TodD/vIlX9kC3bsV/IDQAD1SfW55rjCCkg/sd+il?=
 =?us-ascii?Q?Rr+5nL9aa6L+OGBKxjj5xv9vIumIGrdRQasgq6EO2gZWdBxm//4IpwiNKa+U?=
 =?us-ascii?Q?Q7yP/JjWdRXiN+gftxZU7mirNbxZYF13Z5mCJYnso2M2g90nhpjKJL9+q6Fk?=
 =?us-ascii?Q?FY39zgXjwPOLwBlzIyZ6E9OTrKesK53CmGfPvcvpMOJSLosaui3ctzcLVBMF?=
 =?us-ascii?Q?0wkD5L0oF3DP12ckIfempa1cFGQlP2AiKk2vlh4Pd+Z83GxXnFZeI5nfhigj?=
 =?us-ascii?Q?5aw/KP+kXZgAV8RoEEh6Pf2Fjvn1zmV9Vda6nq4czl0hGg0GDNUys5PKJ0JY?=
 =?us-ascii?Q?3uTAJIU+tp8JK1PfC0vAjnmxyrlHS7YGI4T3KamhJRB+sgRiYLXpEMk4BYZS?=
 =?us-ascii?Q?J6jdCDFTjbklDfRO7NF6sBE6bq1RQSrjHKpBBsMjy3D4dYSWOd5Uk9zWuz+c?=
 =?us-ascii?Q?lmT09UdlpLs/z/fM2W7sB3KxubxcP/gzDY8CIrNVrJkUj1yF8OLqRQ6WTF5F?=
 =?us-ascii?Q?peeKoXbrnQerTCkrgABQod0wCgwzV6BRxCVryddBek1i2hZQ+kM1hpNtOb6M?=
 =?us-ascii?Q?27au536tuPPw24zKGJPN3A4NUAaJ0lwPcDLgZCqCVN1/h4uxyERtr9yWOhQB?=
 =?us-ascii?Q?FVH1PwsWQsb/2QPhf4XbtZIdTDNMi5TDOate8WN9cK2eaYzkw2azCUvp1SS8?=
 =?us-ascii?Q?bkW6Tl6oyhlrz6oOwwgMrvvwnBw1KOTP8kS3lOXuvIPiMIM6PQ+ALhpR+k+N?=
 =?us-ascii?Q?8hMWnJKsY16FgNiIOPVf2mywKLnbM6L/E5Vbe4oW5i+al0BE72uet/ve92q5?=
 =?us-ascii?Q?x6ivVnVyu5GLpM4Y7Ev8dNhW7y4PJSAH7bi3rn10uMS7DLLtwKoUVPG/jYDe?=
 =?us-ascii?Q?WgxF6arlEevg3P0v25Rt11ZwIbx3ueUcSTeQR2TZzTMKou730HFEU7G3+6em?=
 =?us-ascii?Q?5x7wsUbynoGahUuwvzfZSVmi1Xf+oxuxJq6vqAMByT30rdy1qUEP449Eb894?=
 =?us-ascii?Q?/mL56klnVDNXj2zx08vJSxWrGU0SYpvuqtRlJG2qcbzmG/bTWLmo8FWIMS4p?=
 =?us-ascii?Q?Y0UpiSf+SnigPQXOXxag6nbCRQqOEfFpPHOE2N1xrQtOg2sHAJ1Lu8s/Q86n?=
 =?us-ascii?Q?N+ymybTQtY9sM9oCPfzMObq4xDaQLDvgbiaaVgXRjd87JuL0nClSaOtS6glA?=
 =?us-ascii?Q?wCGbLR1KBC75m+pMvdUSoBZpMvIrHk+0tLlI0Aog2G5+VvO0pufhTIisbCUS?=
 =?us-ascii?Q?e64ciNfN79X7zKvD1eUJtE0/7sro1hYpA7pJnpA88zUbH4FytF5z6tw4sVSP?=
 =?us-ascii?Q?nHChx4MwPhYzxhLsB2GDMwlt+6xtqYyflwyom6RY/AIiga/MKuWHs4Xnb+vr?=
 =?us-ascii?Q?m2MF0h3DURIMR+cAMDv7hk6QwqKrDEZ5igPXMFQtV0sg5Au9lLW1xcpkd0xT?=
 =?us-ascii?Q?5Tl4VCPlacA0WPI8VV7z1N0sdW/4IlFDj0Sf4ryeUiqa7cTb7g8Fxv/KYaqY?=
 =?us-ascii?Q?yL33mP4vSxGnZUXjaKByBM3SOGNcN/aCgkT59LymRbjt9pSZGrWGy2vcyZn4?=
 =?us-ascii?Q?mcPxWeOAXcrInfALC0XfAHMNSVx3H8k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 149a6315-2d20-441a-c622-08da385412bd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:57.0431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayxzrifsWSeie7zH+IazqNvh/Vi8XfgUjllZRGI/dXUI81o7fw0tLAJBNEh3KcQ+fCTlWOCpqNAvaTDp4kkzztM3McWawU/dUt4R1+E3rvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-GUID: GZ0EFYTmMNTJeLNcLHa_-3B_Yz9fsHP_
X-Proofpoint-ORIG-GUID: GZ0EFYTmMNTJeLNcLHa_-3B_Yz9fsHP_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When handling errors that lead to host removal use QEDI_MODE_NORMAL. There
is currently no difference in behavior between NORMAL and SHUTDOWN, but in
the next patch we will want to know when we are called from the pci_driver
shutdown callout vs remove/err_handler so we know when userspace is up.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 83ffba7f51da..deebe62e2b41 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2491,7 +2491,7 @@ static void qedi_board_disable_work(struct work_struct *work)
 	if (test_and_set_bit(QEDI_IN_SHUTDOWN, &qedi->flags))
 		return;
 
-	__qedi_remove(qedi->pdev, QEDI_MODE_SHUTDOWN);
+	__qedi_remove(qedi->pdev, QEDI_MODE_NORMAL);
 }
 
 static void qedi_shutdown(struct pci_dev *pdev)
-- 
2.25.1

