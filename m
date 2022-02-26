Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6C8C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 23:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiBZXFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Feb 2022 18:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiBZXFh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2022 18:05:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7800F15F0A1
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 15:05:00 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21QHrURx021519;
        Sat, 26 Feb 2022 23:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6DJdEhmGgVWMFbvFw6y6fIGFzS1UCjX6gqTb0diTeVE=;
 b=Q0wdoXE2KzTSFCKIBx0n5U4Gw5eNYy6Vr+GGbSbwGQbSFWFwr6TVmUI5hEw83TSBKgqh
 Q3fEzJP57rn8GlYF89FtS6c4szgJw61d0pckWRLmom7L/WgkH+uszVdYxqsCognIy7D6
 ZC+mC64hKLzrqPXcCdjh++qE/LyWyQlwhTmbBd3T2YVaP+RiFyLvJgZ6j4REMSfRd9KY
 Fh1gWKVMCqPN/5654TybTc5Ab/oFWzM0wZO22AMndKXOfMOd0mge+U9Krzx52Nk6+Ue+
 V8HfyszgmM835gnAJAwIL4Cykdprg8S7PRV1r+bH5TmhiThICnS1uUoNgm4haksKPyOZ pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efat1scnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21QMtm5N027402;
        Sat, 26 Feb 2022 23:04:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 3ef9at5krx-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuY28xhMTSOK0c3n8f0QfuEvUh+X5Xtcn36OVPwhbUmCPlrDnHOhqxzGqJRKjGqPsDts5plLzhl7MYzh5Nf59P63lrChhirtP4WF/GUtOJruPLRPSbPDjyoyaSo6jNbURX7L+F53zuAkinRC1YGqO57CQWCkpTuMfxdzn21tyMbSvxQ7BL0/oRyRUYOr4Cuky8Qn//sxOXJBOoYB3RxW8tOPomjqnFOP2sn5qseHKcsDYe4lvmeVyKtbwfk1U9QLeqpb+9acfaRd77QhqkHg41KhjcNwAgt8W/lCh3fJT0WVELqlukHP3rchcxlDNNKJGFKtCqT6ROi109UGZbFaYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DJdEhmGgVWMFbvFw6y6fIGFzS1UCjX6gqTb0diTeVE=;
 b=P1gu7EhmTCoAHxpeYic9fW00nyC0zWqXRqs8MKEgHIs4l3gk6e7hd5mqgorlT1acm0cq1/aNn2JOuH1DcecbCXARev7WBSHEqHl4EUiSgHSkQIOKVLfh68p8n/7ST7L1dWWy4gtBEbVaQsahTGqqgJhAFTGFk3EnGFjKDbw/If+yn67rZDcH58GJQFgCwkpJ500W+yFay/QDiitCVJzHjuCajZty/k3sxPNB3wwwAzvYQB86lhHeCntWTdXaaISx8gzil9TldOfeKmutzWnkVJjj7OTCGAokaZosW1VmAvVEdi2dzDDBOdTwxjaI1NT41tTn/Q9FrZx4ICdHSwdayQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DJdEhmGgVWMFbvFw6y6fIGFzS1UCjX6gqTb0diTeVE=;
 b=ihBr2BdD/17g5ugNibQAaU9v4cj8Vpb9tAFi1YN4JYPW7qHA74ES2kQn1r4ikPQABEjmOhdtqKL59bQDo/pxJnD1HRyB4Bum0zlqYZFTqtDIq3aaUlmQzo0rMtwirIT79Baas1NoG/pOGoynmjHzheikMDgsWwlkg+MI9ay4nts=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB5750.namprd10.prod.outlook.com (2603:10b6:303:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Sat, 26 Feb
 2022 23:04:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 23:04:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 6/6] scsi: iscsi: Drop temp workq_name.
Date:   Sat, 26 Feb 2022 17:04:35 -0600
Message-Id: <20220226230435.38733-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220226230435.38733-1-michael.christie@oracle.com>
References: <20220226230435.38733-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9129a874-5dc6-447d-8718-08d9f97c61ea
X-MS-TrafficTypeDiagnostic: MW4PR10MB5750:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5750675C7A3F0E1D294F26A7F13F9@MW4PR10MB5750.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FITltsYC1npAHWFsuAVLEZb6GazBmEkqKoFSCcj72A9LClcupE2ju6nylray/usxdvalgMZLGz4kO1It2j2EYrXE15hKarmFyb7Ujo2VaV7I7X0c8sa7LewWkteYZAN5nVgHYK4ZXlBcoeSYtzN33W/mFjIB/tGuIO8/EOUsUanGrQgs2dox4+kJq3m2TfeXmfNTrB+4pY3aRmbhgm5pNnLNuIUt/xYAfDvxgFNVL5DqiKlEuRUpL32ObqCDN4xLUAUItKtWagxYrnQGu6245Vn8OjQrRKdvIF75ykNv1cwVlKJlXoI0XlLx4ygwxXBb3OgfGHHNs8TSYD6l/hNTcssS4BZ0F9cPGE/t0NqfuA31HUNeOSQWQcvwPJ74lIiF92Lx48U/kkRiJjbcT3RAv3gUeqYhyIrZaGCKlFoKoBvIkp6fFOjrDE5g51nD58ene7HwMKZcO8VCrvrHzzCKZwsBltragR+i6FslcsPI7oNkU8ZaOxJMfrtxs8IcSZ6n9I8L7Hft3QJwHHHop6a0WTn08ehHOyIAtsq1sQkkhxEBKWnKRBadN5sC38AtRFaoVtZER3l4jcn6Pz4lXaruwuLlLtOjQuyy7Qf5UpBabsMdReMUZRL1KRNxqeg7awGVJGJ9jNEnL4w7W+xri9H0BRwJi7ADTc+x+MwrAJDcic/rtBiwWs3eRy6w1yi22240qGOtMrE/ckQGV7B8pMiolg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(1076003)(107886003)(2906002)(5660300002)(66946007)(4326008)(8676002)(36756003)(186003)(26005)(38350700002)(38100700002)(2616005)(66556008)(66476007)(6666004)(8936002)(6512007)(6486002)(52116002)(6506007)(83380400001)(86362001)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QwTiUheFTWJiDG2YJvHCKcvCK6CwFE10DXiNFouAuJ8B/MAKzk1/HXKU+mzz?=
 =?us-ascii?Q?9F4U8EPKBMe+nTs7j5vIq/wZgRCAW06JCJd7WzVOyagRFiUPm2CTUFPfN8At?=
 =?us-ascii?Q?0L9uv/epvSSY+cFqiEqw6UAQ6t53dgfYFjxWGNDRVDN6tbxp5cQGc/O3bK6A?=
 =?us-ascii?Q?kwrkyZjfNXJ+OYlXodYWfzCgViw3GGP4lnOWlOPStITTuQh9UxZBIDHha2Kr?=
 =?us-ascii?Q?8B5Ccu+vedHEKQmBiQpDP3q5q0+NK6b/1dppA7sUJ6evC8U+fPUIx/OTazsi?=
 =?us-ascii?Q?GTboGlujtF91z2wMFN/cw5oCE00Z+ggBwjLrs0pflfLyY51NtztgfVGc8Gb/?=
 =?us-ascii?Q?6FaiJrLjAxWzrjQ8tRCqBD1DwuvJkseD8adlithj8qjqIJ0RP89sYzxqGuav?=
 =?us-ascii?Q?udeR5T5QoiyCX54ZX99I/L+gjfUAPVKnNvhNSSKQdR2GOqxPlygd+nOl5Zh4?=
 =?us-ascii?Q?VzmIzzc2wqQ80thTTt3RjYbQQaFA69OyiUy7bVGVzPrL5FrlW7Pv7WTKTwK/?=
 =?us-ascii?Q?ZUxOCfjOl89txyeEhIwqYyIUolzJWz2gJ4o5ocio7DZxaxYFRHLD0dn2HwI9?=
 =?us-ascii?Q?Sbu3LpltqRbTqg5R49qZQZfxHIrb8x+cv3KPPpTG/U370nL/dYCIlDez9Z3r?=
 =?us-ascii?Q?YZ6D4/RklOeXMco54XiWZ1tzLLgGe1McTXQb1b3TgxyyPnUOYjDR+b9+bHak?=
 =?us-ascii?Q?f13Msj3HPzymhOG0DKt9aqr8UxQ8vOC4DvRouz3Vy8+OubZgDayWtn1PuZAs?=
 =?us-ascii?Q?LgVJWs7zBKYaU+Cw9TBG+pKyZju9WeKtaX7wuJ64K8CDHBNc3hdJrs7IXbMh?=
 =?us-ascii?Q?uCmiR0+xD1l6KU+ckWFZBitcW/0CbiZ4msqOa527S9IMX08lZOU734AJrZ1H?=
 =?us-ascii?Q?cQE9tkzrrUGsgHSzbsbnIR+Z60wSTM9Jo+gFrG0WKUGgoriDUSf6xBRhUl8b?=
 =?us-ascii?Q?TYfIRKHx+bMjmqI8wszWHMTvVltyMBh86kEibK3MWVcb7Uvx1aYuOhU3tns6?=
 =?us-ascii?Q?LfgtpLimNBrCWHMlnGGfy55zICEG03CbieOpdsjdjRyJd/wSLXv2G1pxMmSZ?=
 =?us-ascii?Q?4uj6Pq2fGGWk4n6/AUFWS/4tadaK07ItG7S8q7uCLQe7QUl5sUXQFWArTgcZ?=
 =?us-ascii?Q?v1nClSTTb+PWEqDlY2CWmIUZMdBf9xlVV5VqMwr0LqxMKhqR1NMSlsijZQbi?=
 =?us-ascii?Q?qqlnrtpBWEV99MWauo58E/6jqxTgFSFC6yUdsW9prkPStS4h7J/q/L0XC3u+?=
 =?us-ascii?Q?t2lDnK2PweKbt22dSXYDZjwvaTeLtwN4KJs1kM5EZjWO+QzmqSoBIohq+9Ox?=
 =?us-ascii?Q?Nn95qwcjoGUz5NhQ/pkOgxKFkjlpT9LgC1hiVRg9aKNaIZsCUFpPhSLLonio?=
 =?us-ascii?Q?gGxmridujhIx/keeYfuGPASAtyzu1u5njvBY3R6D6CRTURZB28HTH7HrHc3V?=
 =?us-ascii?Q?+Pg3dZakXRapR3gFc7vyqFQgp5V1eMXfuiJ3NFXytIluodT+zUHiQOArv1W6?=
 =?us-ascii?Q?Xd14t7SrtYjMRtg874YmrYNNu3sdPOMCZRg6KQvClGJdZ6gbCceagVXJNTqR?=
 =?us-ascii?Q?m6vvfFL7SDDrYNMjExd0S6KU/UHdv7tqF8QBkY7tDJnAmxmsn7nhjSxx51U7?=
 =?us-ascii?Q?rc2nI40cVU51cE/Rt3zGhFHF757Jdn7ZKeqmpefzWU3+XJvDkklrB1MF3lg8?=
 =?us-ascii?Q?R9dLdQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9129a874-5dc6-447d-8718-08d9f97c61ea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 23:04:46.5062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRoKdVK2j3OqnD+dC0ndFQdILcZbqzPpkT/GJb5e5DzSPjkyQoxK15QTLSrBvL5YPJ5i5XDjOOgxIcCtAe+Ujz8nfOCCML/Puv+ZVjV1hGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10270 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260163
X-Proofpoint-GUID: SijuU-eY7rTVe-WieGm_jEmWuVDNCWac
X-Proofpoint-ORIG-GUID: SijuU-eY7rTVe-WieGm_jEmWuVDNCWac
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the workqueue code was created it didn't allow variable args so we
have been using a temp buffer. Drop that.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 6 ++----
 include/scsi/libiscsi.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 059dae8909ee..a75b85f0a189 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2798,11 +2798,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	ihost = shost_priv(shost);
 
 	if (xmit_can_sleep) {
-		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
-			"iscsi_q_%d", shost->host_no);
-		ihost->workq = alloc_workqueue("%s",
+		ihost->workq = alloc_workqueue("iscsi_q_%d",
 			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, ihost->workq_name);
+			1, shost->host_no);
 		if (!ihost->workq)
 			goto free_host;
 	}
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4ee233e5a6ff..2d85810d1929 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -371,7 +371,6 @@ struct iscsi_host {
 	int			state;
 
 	struct workqueue_struct	*workq;
-	char			workq_name[20];
 };
 
 /*
-- 
2.25.1

