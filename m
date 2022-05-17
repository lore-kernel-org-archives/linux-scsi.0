Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DF8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiEQWZQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiEQWZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4AE52E48
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKQrO3023081;
        Tue, 17 May 2022 22:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=BgYo8VqgtVB0QasWFDQDAx8kHRuND+jDkIf1iK3LMXM=;
 b=a3lMG2V/WCOun55mHhMOaR0UJnIfnJIBC9TLIzATwKJVQpjrGiDWYDinSrmzFafrgXpN
 YZrQMi1QtWUuLeghMhuKKAH2jKeDw4IaIm8nYe2w9Szu+D5hYxP0fQcf0Nus28j1/sDo
 5OvpUj11n6RWqoy93Ju9jADdDtZwWs5FsHlnGZFBVVNUDsHGBj3fOyPmgYR1NpJX/Sdb
 gESCw+SlSuk6nl0SLPVyvUIGMDXSyHthqgw4u0WII5puqzj4mXhH40PRlovTHfv9H+en
 jOnNi+cppC1Qga1LbwQwz9ybm3g+e5pn6zAhTX/UGtVxC8owuOtBFXnqVQ5J1rida7JV ZQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7ncx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLgi1031743;
        Tue, 17 May 2022 22:25:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cppmnb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfDnOowlptfN2FCOTtcVR2tnpw0Pb6pCa3LRBmGZTtq+9u69Hl5sPH93U1aMVVFk9qg7xaWp0EjdZWwlhuHktZcB7gzogIvK0Re4APD3T95G6DM9cu1G+0Tm8RQPZl3lKiR9wOmg1PttYnr+CYm/VqFm+jSRLDYKjZN3AlEkaFR8MsNu33Kli5fapN5irkGsO1dJ7RObmiFntyL/+oDk1Rr8RkSabi5KZTIhQi5wYFH4h3tHOynnWJus9MtG9aFj1MMxkrprCGJxAXznhHyZnBKTPJD+OEUWqUBE7NKyeke9QciX9Z7DjQUGJbR/56gp8r2lpzhYcGbn1q1h07v5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgYo8VqgtVB0QasWFDQDAx8kHRuND+jDkIf1iK3LMXM=;
 b=D8rViJa/UlvP2F39OXz1RHlvpswAFpm/3zuK7mGwqYsUO5dw5HFUOuJo6oQVyQe5QJVBtKelRl21W2dIJfS0Axo0W+6XR9xv6Lj0gjAcK/WcnW67WzARvFU59afbiVqeEt3/x8F0+d7AXpn/HK3sgzC5ZqXouBGnhxqeQng4kWIkrKOaS9iZFRJIFU9QjbpsdXqU13vJPCauTLYnjQA50vw2Tx5ineGtAks1jM+V9FJP8BcSgQuZbKjUvRjVdQ/wvbCHyqqt6uVr91MaGqJswrCT51OdF7IGsxCkC+t78x6kXcayD00XjpIm9GMs1ksuKvJ7hdUQpjFkNiBMRKQS6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgYo8VqgtVB0QasWFDQDAx8kHRuND+jDkIf1iK3LMXM=;
 b=E8P4aC9KPRDDrsZCKK9V2+OzM9euzbqosOZAUkhxhAuQOKNdo3rQtUNAplDDiec6UboksgHHiwN/TnCRnHFNEUpjN0C1yHodPiTdQRShAFAjO9thym0k3tV3I2g3JMcpDkcmkYDuuD8vHNltwEPZ4PnMkP6E250yqFCPnjaCLbk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:24:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:24:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/13] scsi: iscsi: Fix session removal on shutdown
Date:   Tue, 17 May 2022 17:24:39 -0500
Message-Id: <20220517222448.25612-5-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: a837e70e-9d8f-413b-869a-08da38541300
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5517637294939BA77FAE7199F1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +v8jBkNzcObNr7CWejJwki8VcLdtA1fN+1x2avrUso/GLCrv/cDp7p+EwxBdhPclZB8/VUS2pOPCQguXZMZk+UQuJDSlJ4tdhW7hXMmmoabjqjSJuGTGeKafhzSCiUVsl/cQMw6CeGqWecjvCvPjFajQuDkf2uxW2pbwL5eJ7ZX5k+RigZ9+XD6he47QZDLOH65WzDa2gSc8TjKJWtV2Oe88x268p7tizYaYHcs0nF8tAqq4f8/sbbLJOlM20MaftFz5AFo+gvInPvbhmj9dSi4bt/MoAU7uuCeuMLq+7fo1BhEHB9ZMo7AnRTkTVTS84hGNzSiHZsrUI17ByHopMXzkI75buwsv4z+izS2FMrFECaedTIInnPyUHAjlH8nXIGVz7QFS7l9NogMAXQc/Gl1jgh/Aq+N/PONllxrb14Etp7Zi0WdYwZ6RYNf+y1O+BWFHSIFnf7I3yBYif1CkXfFaOTqzEDuYhRIF5kNANZ2SszXD79MWiZ8dWBpncHdPW3UHge51Ypdi+AXcYFHETrvsjiK8LKZ2iWBW/GWpQsAJza0qWb08MiWj/2V6QY/DU5sa9EziNCw2iLvCxCJvbF3j5t1kWyZb+k18Gd49Fjwy4LBg0sAWqbKKFBDhndtWFfBYdsl2+ZnKK1ofFL/1HeG1IkNDa2qriHnpFopnMJCEXW89dn4sBiI4S84hwaxAlOuUFV7e7lLiBUL3NsZBIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIXdvpYfaQsSfgi1tCPIqv0gfnavC9x7nJu97uuXMxvAVVdEaJbnDr06EHT6?=
 =?us-ascii?Q?IwZRUphMrNv6/5cEL2h8iZacpLrJLLyMLWubE6GtVbbb72WZ09qHZixwc7Ye?=
 =?us-ascii?Q?rbuPvHIMLFArfEo0L5FkPhfRyVsl2xjPOPQFAfpJO6sJYFQa2apREOH3qfKw?=
 =?us-ascii?Q?FS+7PFbPQy3n+EiknjzUdd2iq4TwPbja4nD6+I+OAKrHivjjmM1ABqIv3PUp?=
 =?us-ascii?Q?BTgULTEEkONcrTTAcli4gqDQpTNoTNIvE1Mu4FWWSuCI8KId79F1yrJ7Z5wC?=
 =?us-ascii?Q?XA/NGeJhqNDnybsk5LLQzQHZWXioI307MX95TffNfuuuPR27FzWQ7L92JZgm?=
 =?us-ascii?Q?4DNoS1Kmi7VKThxch+WrlhTt7XJKRrYl3gixL3zHcrcbFW5dsHDhOCMahUmL?=
 =?us-ascii?Q?bqAJj4WjB2ffSOitOkX5OVuldnFAn9Hy/ombCqlkaMReTw9Wwc1W+Eck+b9m?=
 =?us-ascii?Q?82GxpNLVczcVTJc7A3ZRnpj14hzNgMZr+LEvMWPzhy9F9dzgwxEs3dlXDcg4?=
 =?us-ascii?Q?PY9ATE8xnR4O9Z5+JIf0T3LtCtzMNohnjSFX22GDFwg1kV0x97Xln0SMjmyS?=
 =?us-ascii?Q?nuyW3Vctn99zTwPP3o27ESEm9iAQbbjahH8I0xZF+4DDTCQ2dFIq1k1XfATN?=
 =?us-ascii?Q?WnFQECzjpxlk56O+o8iPJuMq8ZUEarq4RyPdh1VVsJgh+NgNN2U6Q8kGX+LQ?=
 =?us-ascii?Q?u8vmVWm5o+AfGQ6tzOEuPSUmynA2mPdkJSuz/C68lNjUpxfqGttwF/HMQysJ?=
 =?us-ascii?Q?iTyV35nIbdrYg0u1b71zMcLfwTWqajPbmPqJ5/SU+I+m5mQ7wET6r2zEAac2?=
 =?us-ascii?Q?kQDYPF5UGI71Ph2Hh5GSVXo2rvqYFDR5pPcb/GGGxP2/pQBH0JxL75WLbF5m?=
 =?us-ascii?Q?kJ4b0OQpUhrPvcq6p4b06t5pfRuTc4wU3YL1kmD6MOpfsA8C5j54FO1sSYPl?=
 =?us-ascii?Q?z6Pl8xdQPnH8r/fKsIJIgKXiJyJ+7SnzydKVeh4+x1wJ8J3tTO8Sc2bN96Gn?=
 =?us-ascii?Q?bEKaU1r8sui4DS1F9t2RaYejnuiQjzv7V+6I31POpSkBCuyF7x2SPQVurjtk?=
 =?us-ascii?Q?yz/TrOfJL1ULy/+R1AKQDB1hFxb5ayw3uhzj3ZNaTyRN4IfQJe7pGSPS+ioQ?=
 =?us-ascii?Q?nPxTA8tnlwAg5wkmZJIdVOf5hl1SaI18Eb2nHCH8QrT+d2BP9yyWXMZqTJaj?=
 =?us-ascii?Q?AZVI4wc3U7Ky9VN7SEYHZcM8JdmY/RXC8y9xi8h9IcJOel596dQX+oG+HCID?=
 =?us-ascii?Q?dpvViMBbZqlDQfG7jSeSsOJEM++ySiapmCqrFpt+BQKKnJVkyc67LUm7NEyr?=
 =?us-ascii?Q?4VgdVG7QyDz9JVwCvu7+Lv/eVm3862kEqotBQNa5laV3q9VSHfBYNiJjay8n?=
 =?us-ascii?Q?9FckPg1W05QtOeLazlpWa+x7uXdCGFqy+QWFa2Jf68wK5rM/cVBQtfKwRdaN?=
 =?us-ascii?Q?fgueWfDXQM6gCJPHZ3QhXo7nIKWuChzxBMvQ++a/MOwT7AieTRz5KNB1dkzb?=
 =?us-ascii?Q?Z96MbosXc/fswnL+n0y5SZUvxT58e/BXQqbJzWoFNeUpshx+yB+ZTj/h+57r?=
 =?us-ascii?Q?aWrI06RAXd4Az6aI5TTgQw/MXI0+Son/dZw8xu+i13kXOIsFDnz8aEnoAtDV?=
 =?us-ascii?Q?HW6xPkMD0Z42ddnQmbQhYxJGeQ++yqr8J1zU25IOEku8yL6aqaa9Jm66eGk0?=
 =?us-ascii?Q?izi6LDwAXgmw03OehXRJ12bQepuEywiKh/tbpVInb3ihJunDWpKc1EFWtoyW?=
 =?us-ascii?Q?HcHs46zLg4JysmH71mEAIRNPqqPjMhw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a837e70e-9d8f-413b-869a-08da38541300
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:57.4806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5UrhnCr/LT1n/5LoMnpY6whHLiGa8oLbZsRoShih8Mv1C16qtCm2Vz4IGo/EI7vPZJIN0G2kpbcnvODSnZO4B351lqv6yA9DSJ2T5zAoDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-GUID: i6TPe29KrDZ2axZv0QxJpeDGOsL9L_AQ
X-Proofpoint-ORIG-GUID: i6TPe29KrDZ2axZv0QxJpeDGOsL9L_AQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the system is shutting down iscsid is not running, so we will not get
a response to the ISCSI_ERR_INVALID_HOST error event. The system shutdown
will then hang waiting on userspace to remove the session. This has
libiscsi force the destruction of the session from the kernel when
iscsi_host_remove is called from a driver's shutdown callout.

This fixes a regression added in qedi boot with patch:

Commit: d1f2ce77638d ("scsi: qedi: Fix host removal with running
sessions")

where in that patch I had qedi use the common session removal function
that waits on userspace instead of rolling it's own kernel based removal.

Fixes: d1f2ce77638d ("scsi: qedi: Fix host removal with running sessions")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 4 ++--
 drivers/scsi/be2iscsi/be_main.c          | 2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
 drivers/scsi/iscsi_tcp.c                 | 4 ++--
 drivers/scsi/libiscsi.c                  | 9 +++++++--
 drivers/scsi/qedi/qedi_main.c            | 9 ++++++---
 include/scsi/libiscsi.h                  | 2 +-
 8 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f8d0bab4424c..e36036b8f386 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -568,7 +568,7 @@ static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
 	iscsi_session_teardown(cls_session);
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	iscsi_host_free(shost);
 }
 
@@ -685,7 +685,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	return cls_session;
 
 remove_host:
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 free_host:
 	iscsi_host_free(shost);
 	return NULL;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3bb0adefbe06..02026476c39c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5745,7 +5745,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	cancel_work_sync(&phba->sess_work);
 
 	beiscsi_iface_destroy_default(phba);
-	iscsi_host_remove(phba->shost);
+	iscsi_host_remove(phba->shost, false);
 	beiscsi_disable_port(phba, 1);
 
 	/* after cancelling boot_work */
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 15fbd09baa94..a3c800e04a2e 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -909,7 +909,7 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 {
 	struct Scsi_Host *shost = hba->shost;
 
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
 	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 4365d52c6430..32abdf0fa9aa 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -328,7 +328,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 		chba = cdev->hbas[i];
 		if (chba) {
 			cdev->hbas[i] = NULL;
-			iscsi_host_remove(chba->shost);
+			iscsi_host_remove(chba->shost, false);
 			pci_dev_put(cdev->pdev);
 			iscsi_host_free(chba->shost);
 		}
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9fee70d6434a..52c6f70d60ec 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -898,7 +898,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 remove_session:
 	iscsi_session_teardown(cls_session);
 remove_host:
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 free_host:
 	iscsi_host_free(shost);
 	return NULL;
@@ -915,7 +915,7 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	iscsi_host_free(shost);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 797abf4f5399..3ddb701cd29c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2828,11 +2828,12 @@ static void iscsi_notify_host_removed(struct iscsi_cls_session *cls_session)
 /**
  * iscsi_host_remove - remove host and sessions
  * @shost: scsi host
+ * @is_shutdown: true if called from a driver shutdown callout
  *
  * If there are any sessions left, this will initiate the removal and wait
  * for the completion.
  */
-void iscsi_host_remove(struct Scsi_Host *shost)
+void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
 	unsigned long flags;
@@ -2841,7 +2842,11 @@ void iscsi_host_remove(struct Scsi_Host *shost)
 	ihost->state = ISCSI_HOST_REMOVED;
 	spin_unlock_irqrestore(&ihost->lock, flags);
 
-	iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
+	if (!is_shutdown)
+		iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
+	else
+		iscsi_host_for_each_session(shost, iscsi_force_destroy_session);
+
 	wait_event_interruptible(ihost->session_removal_wq,
 				 ihost->num_sessions == 0);
 	if (signal_pending(current))
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index deebe62e2b41..cecfb2cb4c7b 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2414,9 +2414,12 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	int rval;
 	u16 retry = 10;
 
-	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
-		iscsi_host_remove(qedi->shost);
+	if (mode == QEDI_MODE_NORMAL)
+		iscsi_host_remove(qedi->shost, false);
+	else if (mode == QEDI_MODE_SHUTDOWN)
+		iscsi_host_remove(qedi->shost, true);
 
+	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
 		if (qedi->tmf_thread) {
 			destroy_workqueue(qedi->tmf_thread);
 			qedi->tmf_thread = NULL;
@@ -2791,7 +2794,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 #ifdef CONFIG_DEBUG_FS
 	qedi_dbg_host_exit(&qedi->dbg_ctx);
 #endif
-	iscsi_host_remove(qedi->shost);
+	iscsi_host_remove(qedi->shost, false);
 stop_iscsi_func:
 	qedi_ops->stop(qedi->cdev);
 stop_slowpath:
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d0a24779c52d..471422641ab3 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -411,7 +411,7 @@ extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
 extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 					  int dd_data_size,
 					  bool xmit_can_sleep);
-extern void iscsi_host_remove(struct Scsi_Host *shost);
+extern void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown);
 extern void iscsi_host_free(struct Scsi_Host *shost);
 extern int iscsi_target_alloc(struct scsi_target *starget);
 extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
-- 
2.25.1

