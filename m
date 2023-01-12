Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE30C67871
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbjALDJv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbjALDJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:09:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDAC49159;
        Wed, 11 Jan 2023 19:09:07 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C33WB1006221;
        Thu, 12 Jan 2023 03:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+Ze1DNMsVU+TYK9w9qjmcx2srMLpuvIpmIq5z1QffKY=;
 b=cN8CLUxsvTUAnVLTr65m5Vl81MbNnnksCNyVSZ8lokNuassvnI+ogh2MvwWGCmyBDTBM
 wJ+GIcStu+BUZA4h/VQxUXOCUZyY7WPO1CLA2bKwhqi5sx4VMAm+c7ntUajQW0sj3zy2
 wPApBAvRznHomc3HyyBty36n+eeIRtVuQ+1BH+igsrtwA4ODdHYDWCeq2mYXR2S3skEL
 zSBdKTehwrN67lfIINhzIQ0aV7ML7PDsvASZR+91R8h20xxXkmb86cQ896KEra4dD31u
 O3O2hAefhF+xqHe0Vz5ffG7ypteU9BT10bne/t2GCV7lUQlUVXXzcfsmyBgZ94S+wnmW Vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n25k7gahd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0E1mI021731;
        Thu, 12 Jan 2023 03:08:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4pmkes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neHt/ijHUfmPbpL3W4GPvI4So/FZS294azdun8Uz+4HFmMjR02kZ4+VWGkv3fH9aw0635m6o3XMoh8PvIdoI7ldsz1xkb5FzmdQbsv2RAJijHBfxL3IjrBghkfPTbDlDTzF/Z6vXVIjnxsvqVPeDfpgzCQ9U/XD9iOI3TY32kl1i+jpI6etyjurC8CsEZ8X3X3jenmkmIrpJAobzA4RK1OdC19TY4lFSUQuFv5g8LVPoAIJKyVw3Di8ngKx8qI2/2xTkZTRXSnF/7D4dAW5DQF9cLl9D59Dei8qJXzJBDd9I8WGOieFhLWS7cDu1GMx2JiHCVw9+q7BkbLV3Nn8smA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Ze1DNMsVU+TYK9w9qjmcx2srMLpuvIpmIq5z1QffKY=;
 b=a6jmiRuEDo9K0HtSWKyV4059pSwgRHFnYVgZeLM//ZNSWcmr2uO/JyIfl4ilY1dtQ730cbmF/U4Q1832nNW7eJlrzGEfF+gs7oe+lSHXJ+WFrPrRpTSC4UVBigP7Edui9kZuhM0xJKKkvzJumMCfgE2fyD8zAzM2+p3dUbJaMvNrv5vbY9b1Yu124KgiraPdG+YML6cfL7oaGI02eZqCJo2UIMVIW4G9XW4Oc4kyK/4Gy0NSeac6jLPiQWSZIbynBx6z+jn2rnpAQc9e6GZc+W5SFFXr5o0ntZ8gbx9Ntlx3cqVBNpNZIdXs/mks68IEwYpcxCbO9gC3C1jHhllnHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Ze1DNMsVU+TYK9w9qjmcx2srMLpuvIpmIq5z1QffKY=;
 b=y7SGaw5RnPKt97RHCwKCZjeyRqQtqG40QLf8Sc9WxpK2lPC7rff0YvUBy+6Pq8GI3i+R5JW+tPkuPDLDqqctxjRi1rU2bBtqbiVCEYN2ispL3dI/wkA0pKCgvy3LP8U0v12/+uDvY1sk9luGm4o63mq6sKU7P5voHVdUvLzDtOI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 13/13] IB/isert: Fix hang in target_wait_for_cmds
Date:   Wed, 11 Jan 2023 21:08:32 -0600
Message-Id: <20230112030832.110143-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 68daa74d-cdd1-46a9-eef3-08daf44a5792
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9Xr5EXy2xBI3b3vRxoReOKnYZWzsAgWebODxa9GK7Ooa4oU0z4HS7GnNuyOzRpmKXpDuJZMu0Pive/8SyPDAyM+GUpI4xcZBU5TQhRtBOY0WtFedpupaQU9YKKjYTTWdxdnGNc6Nct20Z7fTwe4cX2oFqpANBOQ5FkKTzX5qUXBMLn1cHOvHcQdUEA0H2FGaHG2GgRUGhoHrB/NRioH0kDRvS8hG+Q2K27D+BerVQI9lpqAuvCRKt06naLMRLmKCX/mVpYyGVCNwTwVkNRQzNCk3LM4q59KhWrL5cEmwnzg5DSDptZ9N3dQIjTh3eyfQhDeKqfNm94SRpk3v3t3njReiD2NHztBc6n1nYxtWErLHKT3j0adjuB2PTLQ6sGmriH5WabThykt4EhQmPxIcGOIETPsYdUX5LSX63bw6MmPyCaX9mwKv/PYIlJIGpiZEu9aY+aBzRv/42LeQIbZ3CAMPdnD59mhlQbhuae+VXRfF8Tm2AJ8UsN5SLx5j6sveRtTMIJttf0kus2kUgOwugy8PtCiW9AJVaJAdz7qHobiqnWmgMMclrsAXt1ForXkdCm+DOR4kyHiiJwYg8QT6bYv01C4Mo2p5WlcLdBXi9GgPXG5gTzr6sauI7JEE2qUUmqhC8LDViZEt9ndp6IjLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ro8RLn4B/5uRokU9HE+NQPW2utQJSWmFfSRZSR+/wtGW1PnOiNiZAcz3Mf0l?=
 =?us-ascii?Q?7IRtO4FGE/ecE2vcaFAWsvs3ld4Mi9Jev63LnxEw8EOD+j7TPVAR2GCIt38R?=
 =?us-ascii?Q?iLDFWwjzAy2Z3Y/hPUF3Hsj/b0EJePCPk0EyQm5Lu6FLHc5YxSxZYcXBCwLY?=
 =?us-ascii?Q?sX8GMau6YDrJAL0RZdXCK1jrR3G40VWb6nas8mzXj3yTEyogMhzNaKV9SPb7?=
 =?us-ascii?Q?St1f1WCrL1ywYtzxLEoBsIUrEbDelPi5PwzgIG1CdDiitGkrgwWvMl/0f/Sd?=
 =?us-ascii?Q?r2OJ/zzOjdrkOqP6/4om7nFA4jwuG16KDFSnRTS2FfPPym1S0LWLsD+AkEjA?=
 =?us-ascii?Q?AY6kbevDOnURUQMgtP3FJEm3B4oXqF6uRI00gspQILb6lfVnWDPVtDuKZNb4?=
 =?us-ascii?Q?bZrScy+0W3m9aYhNB2OBOxYTCrG27pCTErO6EQsFiEIsey9AqWSGHIFwJbHI?=
 =?us-ascii?Q?9zZygvPYhNZPGFXJrWaUQskHOQyVoEzEFTBVJwbzlcp81Cean7pu+zei6XVm?=
 =?us-ascii?Q?vL9FKFd8hbhVpRobzOUS/DXYvzlBZI7pMu7eCXb/lX2yFVE7qsuet4PjGLMT?=
 =?us-ascii?Q?eIMSPwpd3VZNxXiP6zU3weH9JLn+sAe8RVZ4ZMxzg+uAuinI16xy3lgUWCh0?=
 =?us-ascii?Q?2kxCHXO1mrMJinrjE/W+L86TWffA1OdWqGbL9i0g5iEMq8dMnjJv1859NoVH?=
 =?us-ascii?Q?9mHJ+d/RxsuuxHq4wk4/vx+PzVoXjMPseBfo+qOWiayGmFKniB/5OPPMK1Gr?=
 =?us-ascii?Q?sm2VsyxgeXfa6Ka6+VV7nHAQD4V5keeSQET2LQEQzYkeTMNMv+jKx8LjQEAT?=
 =?us-ascii?Q?0aMvAsS1Shpd3S6yIe1A+u+V4CUKxRGjAJQRa4pHeKU6ajyM+Q5GSXD4/rax?=
 =?us-ascii?Q?JHS6ed1P8IS5Gc7Txld4Z3NbQYs2Wv2DTi7Mo18JvMCCiA/xU+1H+FeCd24x?=
 =?us-ascii?Q?uMyDx40xjhoqlkdB8dWiOVBxSUqPs/k1Zc7pt207VMRqEsHI7cj+bO0pii0/?=
 =?us-ascii?Q?XTu8s3jkR/Ifp5RserCb7Wy57xTQwQRq3ce75QvS7U7f6lELRnmTOTiv4A9R?=
 =?us-ascii?Q?aHp2/gzVrS/r1FZ+VtRcSAOzVK/NLKW44H62+xrd+scYxFF4tJIIU8ypJZ9W?=
 =?us-ascii?Q?HxFQprndAzTvZ5Pif0j7AKOxPaG6Zdz4Oxj6XeEutVZjfWhlTfU+Z6Udu+gU?=
 =?us-ascii?Q?0DoGl9x83G9VbbUlpS+dUl9KwpSutKjWfzfY6xNwpVZ7roCPOpTK0DRw1osr?=
 =?us-ascii?Q?8URbCAI9AnJJ1nqMXhyrs/8ZEgSYm6T2EFkmJ1e3btuPP4VcLN1n5dJyivN2?=
 =?us-ascii?Q?hU7w53UHN4WgDE5Q1guNcTMTIwm//92+siyw/s1idRW92IHh5YO9BtTaFEx6?=
 =?us-ascii?Q?1uJoxfUAKs7E3kihkeFRJao7TWPe09Ji2EvqNiKbXXsWHwd/RCxLry8h8onP?=
 =?us-ascii?Q?VUvjcnEiI2YRApbjt5aiZrZXs2A7hmfvKz40UUkmgsP59hDlTL03MQDf079H?=
 =?us-ascii?Q?+7q/DRGNh+If555ImjH2MwMm5Vt06Abm+l79konViPHdwEAe5KmaYJTx+L0j?=
 =?us-ascii?Q?YaCHrXQryUrvJ8aszgzUWo86BbmGRqNFPlwkZcX7x86Rr9JX8ciYVXtsjI7O?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3YLnp5lq/hnNu9NjeCeMwHK3fh8d6YFXvBWaoXkwA1RBrQF/2DGQMLi67R0usKqZ2gGUFuEuUwYeN2BP1pON5cwsmtPKcHLpcQANB6KMuFduPA38Xx+NfiHRKgRcP8iJYOIosgaAC+/R230dugAaewENaGT4h5B9pFR5HpYLWW7f2+VESdCgzhFNfQZBxkDn/3D5H73YgbJETzMxbVSMn1VdCgv9Gv66Tu6Z9mYSy6fOUpsbAz7ZUbMHXWo4mcvG5cQrKxvvkQ6MOhVBkG29duxEP/NmOAqRTqOuVPuUKX1AeVhtJL7BhttMfO5hI/+26BXe/EQx4CbooDzCWP6xod9GVgWgqPgPazaWflw/eQ3EDYqLJGiniBpSoBmh7S+s3x62THeE3q/ZcDy8SB8sBt2OEskGLn6+uOhgiJbQfctXfY/IuP84qnpRMHOAeHcqR+5YGCvvnlkEqA8JUeCatSkKDjdbNUfe50FdqyVKWuVGrvfN8LKCwWQTGB3zSVkjhgHSSWB+NJwoKqBgrmJUkmabU57ag8ZwIQAC5HuWVNJrQrsNPmoI95HguUzbC8o8Jd+f8RWsbwACHics2Bk0zxFFIGakaEDcbvXdOsFYc2OF0vLTJbeHZqdtixtTPA+v1oKYp9FNQvIbxEHnJpdHbTUOWg+jxpaUFcClbyr70SAJGjPJXE8HZDwHEUgt3srlHv6t0vMrPdIsiwqCO0efOM7rQkR6trouI4/oocgpCp/MbuwnEgcSY1Eec+r/pCKpUzeXB6ti/YO9m9xnEmzJ64+QE/AKiaTCqr1P5gMTpgjZRfzrX0YYoNhj4Ree/D72oVPQpgcY9e68IYg7QDc1HLiIMnNcULiUImKB6BmWVJyhvLBOjhFw3n3iOSRkAMAV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68daa74d-cdd1-46a9-eef3-08daf44a5792
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:56.1913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbSAndOkj7/g48nfsR7s04UEV66OKAAGtfEOybjkN1ALu9sAB2GzvNvBVQslrkJRVlZRmg7eY6FoO94nnwUXqKXIn9uk4ccI3dRtyu4KMrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120019
X-Proofpoint-GUID: juzF5H1072cnRCUfrK5ljOcaMTzj8dki
X-Proofpoint-ORIG-GUID: juzF5H1072cnRCUfrK5ljOcaMTzj8dki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This removes the target_wait_for_cmds call from isert, to fix a hang that
occurs when isert's calls target_wait_for_cmds to wait on running
commands, but also ends up waiting on failed SCSI commands or TMR
responses that are on the iscsit response queue. When isert_wait_conn is
called the tx thread is down, so the response queue will not be
processed and the target_wait_for_cmds call will never wake up.

This is safe because iscsit can now handle cleaning up both iscsit and
isert commands that are running/completing and stuck on the response
queue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f290cd49698e..516fa37494e1 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2500,17 +2500,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }
 
-static void
-isert_wait4cmds(struct iscsit_conn *conn)
-{
-	isert_info("iscsit_conn %p\n", conn);
-
-	if (conn->sess) {
-		target_stop_cmd_counter(conn->cmd_cnt);
-		target_wait_for_cmds(conn->cmd_cnt);
-	}
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2558,7 +2547,6 @@ static void isert_wait_conn(struct iscsit_conn *conn)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
-	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
-- 
2.31.1

