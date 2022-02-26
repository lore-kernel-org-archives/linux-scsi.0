Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D393CC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 23:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiBZXFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Feb 2022 18:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiBZXFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2022 18:05:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6E615F095
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 15:04:58 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21QIHcjH008247;
        Sat, 26 Feb 2022 23:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=5F0qSuMBwmIbqhAryziuZ9Y+O/vouc9QyeVTtvk2zK0=;
 b=IZHJqMjNxm5HxenYLv56B5AmQqgEDEhorCJ6j17WY2xk6kuBsG3pcgO/Bi2VLZh02ipF
 dj/kI5jyVOrDOpQMKksNSb1x0kdIU5DXXYDOb7vdiqRjkY94aLtUSGCqiNrkty6zS9sU
 AA//liB+nZwztOmifystzpjI7QxSvv20vwxoorGPQxT6SZJoTB5mvZXDurtbn/cITpjl
 Gd5HtAQJ4xpQLDu5l4AMZlZ2Fn663ty/djaUZS9rG1JjTrzuWdD0HATSX4ve4tVsHbnD
 9nkd2KUv8vze1k7aHMgVpiVggomq+mHOBCFF9yTsojLyRNYEgRMuEMl+qjYBRzbcYoA6 dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02hbce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21QMtm5L027402;
        Sat, 26 Feb 2022 23:04:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 3ef9at5krx-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0vvt5AZVWLYxodchKah2uzvdFaJOJY63S6GvMZs5j2ftutE2B1LzxLyrYb7qnyb1rvPFCCy3Lfj/QkwOQSXMJ9u4K0iX/ap/IqVqxaMdJK2TXHt4Tyc37xbj1ddotxny0Tx0Z9bCOSS1bbfQz+dhNhOkMdzEnt2hafJv1+ATWQ+kN5Oim2MA0r70FcGCd9oKXYJzW1aZhaRsQmUcsxMeMVTmNJXkJz1Vhi+AowA9UBMr2cCY//RbpQMbPcc5ZtEi2T5PUnx4A9Si3Nyjghysy5Sorud9nynvruX6SnqpLeqkhqyb/N2afVocmDsMLvnQCovh/795dGs9ObcqXWWcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5F0qSuMBwmIbqhAryziuZ9Y+O/vouc9QyeVTtvk2zK0=;
 b=WCot17czoMYyjGNrXlWiQ/9t0EWh0Ek562NkQU980JntOL0gyo6FLn08J1TXlTzlr9XJD1sVIayXm5I/A58Zk5EkdzZHC4TGr8hGns2wXAMD72y+eTgo692F1hhlGMkKK+rmMq0Smlwr6Qg+XETLbAGBAueMqBqBjWsmec4blKQtP8on4N7/JvMPWSt4nrhzB2wGEgt6aYa0pBwKaKIeb28dnrndhDOFpGdi/DH1+mxK0mB384E2wO6ml7Nt+c8tX4of/P1UJ3BsvP+5aqPwUJlrrIu1+lCm13I4Zbnrb+eIVTDDh0J5zjYnIY5fJblKsaXsasErFb6mWZ6u1NhKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5F0qSuMBwmIbqhAryziuZ9Y+O/vouc9QyeVTtvk2zK0=;
 b=rs4octH0GI6YTZ9nXr6t+UTh3cEGzaL3kgc0k2WFgFVM+Bogjng9IUMUzvdctdUEMKN9ONliyQ37Id5kDWKLDgt8yEvoihX8JvAl9MhyV2dnr5Cexj77lKko1gUk5Dz5TKygQxYWsSQVkJ3pNl/q/QNTD+DC6oPCG6Fu+hC2br0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB5750.namprd10.prod.outlook.com (2603:10b6:303:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Sat, 26 Feb
 2022 23:04:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 23:04:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/6] scsi: iscsi: Speed up session unblocking and removal.
Date:   Sat, 26 Feb 2022 17:04:31 -0600
Message-Id: <20220226230435.38733-3-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8cb2080d-aa3a-401c-a9b3-08d9f97c60a8
X-MS-TrafficTypeDiagnostic: MW4PR10MB5750:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB575046DC0098FED6B8C9E21BF13F9@MW4PR10MB5750.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPvi3tEvGaXcY5qHZbz4Atm65XDEnJMTDi12KDwMWmVOeERgzSr1IoUHiYb0f4v0EZ97LYK8GlXPg5TEIIJtOU7CeI00aMYurhsYHHVj9lV1AjQZiwqrEjYmgFf6uqUB0WnsRk3szoU1lDMYn9kpAhOCv0sGkrpd8FEoOMQ6vyRpPqe/DF0qQsOWno74aFrPODBFf/uyO3bLCLNAzdAgDR+zBNxFL5LLNBokHcXnQsbrofAPPnG4R7P4qJJ6XL3uDnGnNkJioc4RlACXkBBcWAC0l2Za0qbhadJclf0FvLRoFRdCuAaBcdooTiVOaqY9fNWOycUHLi4k2Fu12nkISvELBO+B/20aPfYUy/c4QNKZN6xtJH/cMxhKuYrqS/dPzE2LWwt23pBxSfipROo2TeMJiDC+dTXGZhTYGU7sxZKgpfn1dzrBJbVwjMEAoxeXtVKh0ppF5L2xbcMiy5V2aNNlEMxRJFXtwKFpRgfwGh0y7XbmEW/9O4LHjS2ry5xeFR90/ezLbQkvfOpD/Iqf0Ot8B3Xchl0jq+tBxnD9GRuGUJ+jV2Aaksy+AywI6DVb7O4oYzt71Ctq1yd6uBjefnp1rqf4yo1LawoR32lnZVP4GGyBr1S+4afuD+F7BG+XqJgNkZbGGVzEuBYJ/kacUpY2LaZzgakmwBb86P5qGZhG2JafH3MYg6fRl9sf7Q9FFwbIskinOtme1wZh6pO99A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(1076003)(107886003)(2906002)(5660300002)(66946007)(4326008)(8676002)(36756003)(186003)(26005)(38350700002)(38100700002)(2616005)(66556008)(66476007)(6666004)(8936002)(6512007)(6486002)(52116002)(6506007)(83380400001)(86362001)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q3ftetsw9zXAIy1Ac8k0hCzjKUMyRrTBq1Oarizcl556p16MzV/ne1f7HtYL?=
 =?us-ascii?Q?1Q8PQRQx1jG9eQd9CfCYd4w2sBtPKHnoGN7sRDkO8xlTlInx1L3GLJ7wGmn5?=
 =?us-ascii?Q?ctbPPIJhdAdqQ589oNAI9KPfdByiMQ0kS8Vxob7/64s49+rrl53EH3tWEzqJ?=
 =?us-ascii?Q?c2s/wwUY5Bs2/CW7msVwFqOJ9GqBnryT+898A9sCWlSCOnCvtAnIJvME3iKx?=
 =?us-ascii?Q?uzJLdGRYvkYidyAqAGs91Nwd9/g/LmE5zeastfIwQ7wfcSDF+plYzChMCDu9?=
 =?us-ascii?Q?s325Ea2gfPU5MeJAyVfcPJISGENBG/hGXdIvaOEg3dX0V81BFnca49UgUwOn?=
 =?us-ascii?Q?0n1XYr9L+6Kt5SaYnmY6PajY7soX5Db9r3vzmY+rKdjsFJxyfspRoWUp5RAb?=
 =?us-ascii?Q?1PylIdDgO/MNhiI2jqzXDfi3xD6yWEQME7PKx56Y6m+o2YbKDy7rlD0ML6/i?=
 =?us-ascii?Q?uNOAeHZr/HYRCdQwDBPBreftl3N3CKpISCIUQGX1sF7/1/xSAb/Z2TL5lhul?=
 =?us-ascii?Q?GkNRAaztL8SDnEo5rbXiD5F98aJV/L9kVavAuYXB8v/k9IJedcj4M2zEyGZM?=
 =?us-ascii?Q?/eoJ122mR/MVVMIYr7DqCA/S+GGEWGr9TL8X48PsdJYgt3lhuJWkxMb/G9eK?=
 =?us-ascii?Q?bs0IFWdIpXA7JmdFGxpiEZJAZFIbzSBODpTh3xEzRODkq1orhLJwV04/lVu4?=
 =?us-ascii?Q?Qc62uhj9Vf0SnV3wsOOS1H/aG53G7Jv70Tv0bKltqEWxycjG3GmES4MQHX//?=
 =?us-ascii?Q?OTHpybMXgKTgzfdYN6KKEl9lcvgFjspXwnykvUWM55rw9vTkPDD1o4WUSCpw?=
 =?us-ascii?Q?R6nQ4R40SHohasE5Fv1Xlrihw+4xXceeYJ38YM9r1Z9fX6RPQ9TMIFdbrTUf?=
 =?us-ascii?Q?Cmp/mqUTfrzjoxwKUZGn5FGEctR5+ApZKIvsvnnG8lN3kQLc+apyCE/zG/p9?=
 =?us-ascii?Q?uB/EZjeab0RDbo8Js7bXzjIeljInHVv2mSpNAd8SFnA3bSpqt8t7e2YwUD5D?=
 =?us-ascii?Q?KveAPnGZehWBC7E6twwE77pqdChJBiKrTQ5J9aqagdzRVHON3K4fjpxZtYwe?=
 =?us-ascii?Q?rjHW6FRdIrG6pF6vMxduXoyV3//WuvgvNjMCL2lqT0jOvdmBAUBgp/OagkRJ?=
 =?us-ascii?Q?NX8de1WGqdh4nGcHI90v2RgkuHh0Loy8dJjexBnoEueSIIgzZPICsFW53RJ8?=
 =?us-ascii?Q?rOinZBgdmfNedp+VhyLKVfeJ6LnYmnlAX00BPdWOn0GSzpFsuFETYWDvJtWB?=
 =?us-ascii?Q?7gKyBXpyTOibp+bUF6LQjv1FZWSwx5cHosltvu4Gss96P3PD9ig81GcbYNh9?=
 =?us-ascii?Q?S2hOFnJP6+WMYlIejie4hzkZDZe4J4krKf2hwDzz9Nt3ncxcVKGcqqm8x/gM?=
 =?us-ascii?Q?IsKwHT97NpxQFhpqORTVvHmYmphjBHi7Eio5WCMDLzSwGH2+ZKYfxqjAj+Fp?=
 =?us-ascii?Q?kZ2N8qjVwy66nAqi76v8rWKusS8lj/KBVv64ZEAxhY5KMTzfwhtDl9+Kex7G?=
 =?us-ascii?Q?hjnK365Y3IyPmjp42jVe788oxUKO6FgWIc2od4aByT2P94Oaj2VoF/bg9x9t?=
 =?us-ascii?Q?YV4Q91Olq69Bh4vIvlZNXDda4DYK7L2TfQt3XoTA5W1FMfmSPXmbw06E8bZk?=
 =?us-ascii?Q?/ZqmA3Ubw0a1daQh5LFVn6QVUxS93Ip603SnHdx79LJrLCqFE/9/3WZ+7yHy?=
 =?us-ascii?Q?50Qcyg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb2080d-aa3a-401c-a9b3-08d9f97c60a8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 23:04:44.3812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qiD4M6x7yTqct1CVsA86YCA4PLvqvStMj2LGD+WMmWAVv8lckOoPQ8gAfmVawCMOp8UmcdSRq9AHUuC8LCTCaNaAxbp7RIFk1pJpYYT0vg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10270 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260163
X-Proofpoint-GUID: EgPRQ_svQCt6Uw6ajZ-K13yC76kHMp3G
X-Proofpoint-ORIG-GUID: EgPRQ_svQCt6Uw6ajZ-K13yC76kHMp3G
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the iscsi class was added upstream blocking a queue was fast because
it just set some flag bits and didn't handle IO that was in the process
of being sent to the driver. That's no longer the case so blocking a queue
is expensive and we can end up with a backlog of blocks by the time we
have relogged in and are trying to start the queues.

For the session unblock case, this has try to cancel the block and
recovery work in case they are still queued so we can avoid unneeded queue
manipulations. For removal we also now try to cancel all the recovery
related works since a couple lines down we will set the session and device
state so running those functions are not necessary.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c58126e8cd88..732938f5436b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1944,7 +1944,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
  */
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
-	flush_work(&session->block_work);
+	if (!cancel_work_sync(&session->block_work))
+		cancel_delayed_work_sync(&session->recovery_work);
 
 	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
 	/*
@@ -2177,9 +2178,9 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 		list_del(&session->sess_list);
 	spin_unlock_irqrestore(&sesslock, flags);
 
-	flush_work(&session->block_work);
-	flush_work(&session->unblock_work);
-	cancel_delayed_work_sync(&session->recovery_work);
+	if (!cancel_work_sync(&session->block_work))
+		cancel_delayed_work_sync(&session->recovery_work);
+	cancel_work_sync(&session->unblock_work);
 	/*
 	 * If we are blocked let commands flow again. The lld or iscsi
 	 * layer should set up the queuecommand to fail commands.
-- 
2.25.1

