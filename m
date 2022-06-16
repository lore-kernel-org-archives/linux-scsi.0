Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803D4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379170AbiFPWqi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379153AbiFPWqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFC262201
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:20 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIsdO2005223;
        Thu, 16 Jun 2022 22:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=cK2xinyekZ7au6sYfTfvqjthHuCIlIdKapR83NK5KEg=;
 b=rSrngq9gdkp4bOo/MG3DBz4L7dNM5S+B2XCOn3vUPmwZA2VHtJ2tV4mNXe647RMDrxgX
 otCBjNIx3lLkqKVNzX8L5t8s75upN02GLYwCa7fDy37WUTx2JK404CgUzFIMInFkclxl
 rT9SBrQBqvj/qF0weRvRV/jIkXcqnKehhF4YmqyC+X+790jWdIQ1B+MAwuPmHb/pKCsA
 cEigNDev4LSpsPJS0Sw/9LovsXWu8e53mRkoBKYHMV5DlYViF3EdM87Mwe5OD21JQpyj
 zLWTbT6P8+LCtbkQm0jayQaYR4C15vLD/rPbxNwgXgl/42axRaWLiOYxWXjk6N+8ZgEF kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjnscgbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaPd4035724;
        Thu, 16 Jun 2022 22:46:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27dmqw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOIbStocha9NW5x4PtxeL0bLhKrCzzmW0cjwsk0z+mDj5Z/xaDwaRvtbr97CiJOlONO82VHObYuCnsvY1jj5GD87iiPLAHjQtHBsbatSSX9NVhWNXJF/0dOUotTj/ogzsNsUoOzjU3C91xSBxBIZMKdB2oxlf+5db2P1NPOtND7VRl3oEQ1x3DP5uKLiS1Si4PoHe9Tie6dkaATZA8HWinPhhyWqwl1R6Ei2RF8J9zVeiCk3F/cFlC5vrelJ3r7l/E8lo78Eeem2xfZ/7y5EVsEgUyimRKLTlCwdV7eQJsED1sFPIp4t0Nr1+5GCkzV+oEz2/MwBYVn5gLqBSw6K9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cK2xinyekZ7au6sYfTfvqjthHuCIlIdKapR83NK5KEg=;
 b=W4RyXolx1aN0erGR1yrY5WC4G/n/KXi//0iHE83hopi0WptrE8cOFHJDjLjacEBFYnzNkLr4iXeVdIW6FmCmgUUYaickTBaVyn8J8ITFdOda8+h8DrlsVLAVVdb11O3yGZKjOaL2uLoq/xuWNStyur//jEF+Cnsb52xhqvh47vzudCICSFZz54z4g1MdQkuEat0pWC7KQtSiOP2aSPipnewKIVbdHXL8aC9Pcb+CTBgkP2EwR+s66H4vi5gqBO7+qcgcILIfHcWkijd68KGQLSM/5LM8kM2IEIiuCvoLCoy+6TjWCMX64xvCEBsKMG+zza0qmwRcLlIo2KwfiNw1fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cK2xinyekZ7au6sYfTfvqjthHuCIlIdKapR83NK5KEg=;
 b=Dj7Pw2WwREWEzjmGUVl3zFywTmAPZeiChPGW3l0757Pf7JpOTPKmgEO8ba746d35MhmlUt6ZEmmUje0OrT7383UMUaioLtZka0OyAf8JXrjZ8BhGYkgYH0PP2JTKFn7XRomaOAPGwNkXkt8KvlcyDD0kOah8MSOWnZssLzFisLk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5617.namprd10.prod.outlook.com (2603:10b6:303:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 22:46:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 7/9] scsi: iscsi: Remove iscsi_get_task back_lock requirement
Date:   Thu, 16 Jun 2022 17:45:55 -0500
Message-Id: <20220616224557.115234-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c821eaa-27c0-462d-0447-08da4fea01ae
X-MS-TrafficTypeDiagnostic: CO6PR10MB5617:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB561738F8B8C438D35C5EE129F1AC9@CO6PR10MB5617.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: isydP5a3K2DEiExe9IlhxeUHsjPO8BMyRGz2WLPHfDJhfMaquZKi68YmCDVsnpKQofrzSbDv9N9QQVSik6tgx6YcGZ19+0K4OAV+568tGzyY4DHSe+qCoK1He8PwhI42SLFCG3i/S1q13ENL3V7Ga7bDpfjbjXUgByJBMVWfI+BI6+46YPZlXVDRZFjYGZfjKWNv8HU0waNP3MlKKhYw0ECnyDLiT5pj10XXaPMUEzVEY0Jku9ZZh5T8qw/TxevxOsvfPmLPCE02KSvGFfHxrqInFuC/OV9lkash3b+FySDcrHVPyK3XUDWh8mJzRjyvwlkcwoGYhvMQuQglwEqTTQH+9VDLXF5LWeb+fxsvWpEJX2Iemn0YBTsUT8UkJuFXafaNNwMjxQCVIvWewAy+ij0SRjciR1gZmXmHHSExQE5y7O7JrbSw3ebaCF9WKeEbMpsfPyEqSh1HPkSzPECY/7fIo7U31qBBvfHn/QY2+edzjoMNvj82l0A+jwMC0j+kW7mCQwVmNWIvEq4spyqWW/L/ab3iRd2rOTw+p+XBoVvxPtzxcoJpa4L/oelwdY3BIS5p2yl5hZGeD8BWbzGgRIkBGcrlx6j2q8XXMqvov8HamJtCBpYWh9oLo5YtmZi/BDNgru3pRYO51PxvgX5Mm7DfhqjM0z51jOOvUmRYFgirCdTXl8KefK6gkuulwoZOB8Yu1nywunxEznDCbPWpOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(2616005)(52116002)(6666004)(66476007)(5660300002)(38350700002)(38100700002)(36756003)(4326008)(6506007)(8936002)(508600001)(6486002)(66556008)(8676002)(6512007)(26005)(186003)(107886003)(1076003)(66946007)(316002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ONZyodvpwgnv7rTNGdpxE0DVeNe6SVV1lNiqr8QJy409GWW2Bbiw1JY1zekH?=
 =?us-ascii?Q?Rvl2yoL9PD8DfhwSclGXrYNvwwhY6lxLu/i7mRWaIEKavy/QE5j3erTtUrEO?=
 =?us-ascii?Q?6KxBW9oAj2dcDQbo6saS0/t9VWaez/QjSOBsDHFNHj/ZojY89X9tOn2/TvGF?=
 =?us-ascii?Q?dv9s+qo7UcPpEvo49Mapiky1jPo9S/YlZD/IrkpT9bpkGspt7TxUXNjMj/8R?=
 =?us-ascii?Q?r7B9uvL57qZipfVHN8JcL5o4nl0tQHmQhyskxu8lRelNdoFXK+FCKZnIyZBD?=
 =?us-ascii?Q?CNT3fFQwgTzpxbaE2Lgqd3mhCT2ryymGX50tqRoc4x9swGwvacaUk+oytcWf?=
 =?us-ascii?Q?z74R3SjF1G9dgj1aOuRgZ8tsfL/Aw8FCegMSuDscGNYzIFX+2VgSBznHP1VL?=
 =?us-ascii?Q?AQjRwQ5r0sHpQBAb0y6s9P8LV41RFFEto8C7hY1048EhqNJ3XpwWzzGA7hNV?=
 =?us-ascii?Q?XNEerHWDNdXNFcN1EvfgmRrgFxQbTDPgAdWR2g8Pyw7KlCF4xv2IfTWJAjye?=
 =?us-ascii?Q?tp+fyRK2sxcmOHhIlsvnyfKNqfcKi6TK6yUgXVmxGwKBO70gw4M+5S6t6qP/?=
 =?us-ascii?Q?uG666dfOwTUBrjRxUh08Bc6nV44TLlEREsWgNCt1T3lClWAdIDvJf/f/KpPV?=
 =?us-ascii?Q?unOtINZY9FS2Sriiy5GUvVghBIEL+rjqTq2uO3u2Eu2iaNcEt+tj277/S7if?=
 =?us-ascii?Q?iO2l6/GfpN079CUzhGNiLsiQiDGe72BB7xQZGCT8B0IEVgv34pCA0byShhsU?=
 =?us-ascii?Q?NlPLlYJJ18dLSmq9kAlH4ecyKe7Cv8YyZRps2FVgP0AVCCXP2MTJcolWP5eA?=
 =?us-ascii?Q?o+RcceAXE1buTzuiHoBt9cQSqku015H7uS9AQLWwf5Vvmz7S7gsnlCHEKZD4?=
 =?us-ascii?Q?2EoGJY+io0dravDaQwpOabA6nlWsHnZTV9LzlEc0mVGz1vgcrMEQyRm5MYeH?=
 =?us-ascii?Q?LMlYUk1rcF6C9a7DFRvPBuFzrw492eBXHqaYao4z+ayVLdREFMjkHe1gyUqc?=
 =?us-ascii?Q?DzXIVawqOV8gizTPo+m4/fVxjeuAcae27BWLJWqKbCl8sgFG+bOe+zoVP9wR?=
 =?us-ascii?Q?FTwjsCa1RPkROsYogPGGgsVIk2lQ3nVcrlOjgA9WATTSWqHPjM/GEhHt0xa6?=
 =?us-ascii?Q?1zbuyXgRM4gdYfdAFMnb/V8oc1JreG00qlXk3apgdVIsNm3+Td0JbELsnvvE?=
 =?us-ascii?Q?W4zV6xHTb9eN13peMqzIVTe6QCG4kuwSTWyJj5VJYwdGA67Te08wE42TOk9a?=
 =?us-ascii?Q?a4+0t4416O3JNp0W44kVS/NM6y9fwUMKT0vnDVjA4azCh69oEIxAZtTUAMBQ?=
 =?us-ascii?Q?LO3Bm+OUmTcICFmc5TOmVc8gHf5BUuX7UJhIFDn75WQ7CpVEsqO9intGhm/N?=
 =?us-ascii?Q?VvRL9byQOmgMlRAnRYvNTH9VM0fM0x5rQadaDucUh9vhy8UFcCTCyWXfCygL?=
 =?us-ascii?Q?5yuGNkfsE/U5u/D99ZzTHCe/ahxVtegjwIlpfvcvGxxR1G1l0LpES8v2Dqz9?=
 =?us-ascii?Q?IxJ4JjJ+MXUZZ2/6CEyj5Eyzt3FGyqbkCUQB1lcPdaN65qqdsUEJJy9Ru1yt?=
 =?us-ascii?Q?SGdvlryvOT9FyHqGjmuoyDXmNXhSddz1sL/fV5anmI/CP+4AzIF8KfmX5e0a?=
 =?us-ascii?Q?HIGWcCpPWsmqRAZKZxBxoRoK9cRAM3KYok3aQ9Fy3JfluTkuIidjWihjUOoi?=
 =?us-ascii?Q?CNwO3s8Gxndx5XdSvehMNXlpOwqmk+dB6lQV8HnqwWO607JNdTufLidT3MbQ?=
 =?us-ascii?Q?2bdmaCKutPC14zsRR1PbbTX8FugSASs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c821eaa-27c0-462d-0447-08da4fea01ae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:09.7656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /xJlwXM5yrYnXKCBfEElv5XGiJHDlPtEc/DguRMuJ0EgHlwvcA2//azAeGVzIv3XyIlQPJk1l9FOLnSM3vyR1tet9plF2UNrSwBPQHz5rU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5617
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160091
X-Proofpoint-GUID: sI-_bQqP-0QI02mg1k9lPk9bCDsfPLzV
X-Proofpoint-ORIG-GUID: sI-_bQqP-0QI02mg1k9lPk9bCDsfPLzV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently require that the back_lock is held when calling the functions
that manipulate the iscsi_task refcount. The only reason for this is to
handle races where we are handling SCSI-ml EH callbacks and the cmd is
completing at the same time the normal completion path is running, and we
can't return from the EH callback until the driver has stopped accessing
the cmd. Holding the back_lock while also accessing the task->state made it
simple to check that a cmd is completing and also get/put a refcount at the
same time, and at the time we were not as concerned about performance.

The problem is that we don't want to take the back_lock from the xmit path
for normal I/O since it causes contention with the completion path if the
user has chosen to try and split those paths on different CPUs (in this
case abusing the CPUs and ignoring caching improves perf for some uses).

Begins to remove the back_lock requirement for iscsi_get/put_task by
removing the requirement for the get path. Instead of always holding the
back_lock we detect if something has done the last put and is about to call
iscsi_free_task(). A subsequent commit will then allow iSCSI code to do the
last put on a task and only grab the back_lock if the refcount is now zero
and it's going to call iscsi_free_task().

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 19 ++++++-
 drivers/scsi/libiscsi.c         | 95 +++++++++++++++++++++++----------
 drivers/scsi/libiscsi_tcp.c     |  6 ++-
 include/scsi/libiscsi.h         |  2 +-
 4 files changed, 89 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3bb0adefbe06..dd32a90ef9c2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -231,6 +231,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
+completion_check:
 	/* check if we raced, task just got cleaned up under us */
 	spin_lock_bh(&session->back_lock);
 	if (!abrt_task || !abrt_task->sc) {
@@ -238,7 +239,13 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 	/* get a task ref till FW processes the req for the ICD used */
-	__iscsi_get_task(abrt_task);
+	if (!iscsi_get_task(abrt_task)) {
+		spin_unlock(&session->back_lock);
+		/* We are just about to call iscsi_free_task so wait for it. */
+		udelay(5);
+		goto completion_check;
+	}
+
 	abrt_io_task = abrt_task->dd_data;
 	conn = abrt_task->conn;
 	beiscsi_conn = conn->dd_data;
@@ -323,7 +330,15 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		}
 
 		/* get a task ref till FW processes the req for the ICD used */
-		__iscsi_get_task(task);
+		if (!iscsi_get_task(task)) {
+			/*
+			 * The task has completed in the driver and is
+			 * completing in libiscsi. Just ignore it here. When we
+			 * call iscsi_eh_device_reset, it will wait for us.
+			 */
+			continue;
+		}
+
 		io_task = task->dd_data;
 		/* mark WRB invalid which have been not processed by FW yet */
 		if (is_chip_be2_be3r(phba)) {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1d646f02d516..07fc78aa1aa2 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -83,6 +83,8 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 				"%s " dbg_fmt, __func__, ##arg);	\
 	} while (0);
 
+#define ISCSI_CMD_COMPL_WAIT 5
+
 inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
@@ -482,11 +484,11 @@ static void iscsi_free_task(struct iscsi_task *task)
 	}
 }
 
-void __iscsi_get_task(struct iscsi_task *task)
+bool iscsi_get_task(struct iscsi_task *task)
 {
-	refcount_inc(&task->refcount);
+	return refcount_inc_not_zero(&task->refcount);
 }
-EXPORT_SYMBOL_GPL(__iscsi_get_task);
+EXPORT_SYMBOL_GPL(iscsi_get_task);
 
 void __iscsi_put_task(struct iscsi_task *task)
 {
@@ -600,20 +602,17 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 }
 
 /*
- * session frwd lock must be held and if not called for a task that is still
- * pending or from the xmit thread, then xmit thread must be suspended
+ * session back and frwd lock must be held and if not called for a task that
+ * is still pending or from the xmit thread, then xmit thread must be suspended
  */
-static void fail_scsi_task(struct iscsi_task *task, int err)
+static void __fail_scsi_task(struct iscsi_task *task, int err)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct scsi_cmnd *sc;
 	int state;
 
-	spin_lock_bh(&conn->session->back_lock);
-	if (cleanup_queued_task(task)) {
-		spin_unlock_bh(&conn->session->back_lock);
+	if (cleanup_queued_task(task))
 		return;
-	}
 
 	if (task->state == ISCSI_TASK_PENDING) {
 		/*
@@ -632,7 +631,15 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
 	iscsi_complete_task(task, state);
-	spin_unlock_bh(&conn->session->back_lock);
+}
+
+static void fail_scsi_task(struct iscsi_task *task, int err)
+{
+	struct iscsi_session *session = task->conn->session;
+
+	spin_lock_bh(&session->back_lock);
+	__fail_scsi_task(task, err);
+	spin_unlock_bh(&session->back_lock);
 }
 
 static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
@@ -1450,8 +1457,17 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	spin_lock_bh(&conn->session->back_lock);
 
 	if (!conn->task) {
-		/* Take a ref so we can access it after xmit_task() */
-		__iscsi_get_task(task);
+		/*
+		 * Take a ref so we can access it after xmit_task().
+		 *
+		 * This should never fail because the failure paths will have
+		 * stopped the xmit thread.
+		 */
+		if (!iscsi_get_task(task)) {
+			spin_unlock_bh(&conn->session->back_lock);
+			WARN_ON_ONCE(1);
+			return 0;
+		}
 	} else {
 		/* Already have a ref from when we failed to send it last call */
 		conn->task = NULL;
@@ -1493,7 +1509,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
 		 */
-		__iscsi_get_task(task);
+		iscsi_get_task(task);
 		conn->task = task;
 	}
 
@@ -1912,6 +1928,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 	struct iscsi_task *task;
 	int i;
 
+restart_cmd_loop:
 	spin_lock_bh(&session->back_lock);
 	for (i = 0; i < session->cmds_max; i++) {
 		task = session->cmds[i];
@@ -1920,22 +1937,25 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 
 		if (lun != -1 && lun != task->sc->device->lun)
 			continue;
-
-		__iscsi_get_task(task);
-		spin_unlock_bh(&session->back_lock);
+		/*
+		 * The cmd is completing but if this is called from an eh
+		 * callout path then when we return scsi-ml owns the cmd. Wait
+		 * for the completion path to finish freeing the cmd.
+		 */
+		if (!iscsi_get_task(task)) {
+			spin_unlock_bh(&session->back_lock);
+			spin_unlock_bh(&session->frwd_lock);
+			udelay(ISCSI_CMD_COMPL_WAIT);
+			spin_lock_bh(&session->frwd_lock);
+			goto restart_cmd_loop;
+		}
 
 		ISCSI_DBG_SESSION(session,
 				  "failing sc %p itt 0x%x state %d\n",
 				  task->sc, task->itt, task->state);
-		fail_scsi_task(task, error);
-
-		spin_unlock_bh(&session->frwd_lock);
-		iscsi_put_task(task);
-		spin_lock_bh(&session->frwd_lock);
-
-		spin_lock_bh(&session->back_lock);
+		__fail_scsi_task(task, error);
+		__iscsi_put_task(task);
 	}
-
 	spin_unlock_bh(&session->back_lock);
 }
 
@@ -2040,7 +2060,16 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		spin_unlock(&session->back_lock);
 		goto done;
 	}
-	__iscsi_get_task(task);
+	if (!iscsi_get_task(task)) {
+		/*
+		 * Racing with the completion path right now, so give it more
+		 * time so that path can complete it like normal.
+		 */
+		rc = BLK_EH_RESET_TIMER;
+		task = NULL;
+		spin_unlock(&session->back_lock);
+		goto done;
+	}
 	spin_unlock(&session->back_lock);
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
@@ -2289,6 +2318,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "aborting sc %p\n", sc);
 
+completion_check:
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	/*
@@ -2328,13 +2358,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 
+	if (!iscsi_get_task(task)) {
+		spin_unlock(&session->back_lock);
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+		/* We are just about to call iscsi_free_task so wait for it. */
+		udelay(ISCSI_CMD_COMPL_WAIT);
+		goto completion_check;
+	}
+
+	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 	conn = session->leadconn;
 	iscsi_get_conn(conn->cls_conn);
 	conn->eh_abort_cnt++;
 	age = session->age;
-
-	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
-	__iscsi_get_task(task);
 	spin_unlock(&session->back_lock);
 
 	if (task->state == ISCSI_TASK_PENDING) {
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 883005757ddb..c182aa83f2c9 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -558,7 +558,11 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		return 0;
 	}
 	task->last_xfer = jiffies;
-	__iscsi_get_task(task);
+	if (!iscsi_get_task(task)) {
+		spin_unlock(&session->back_lock);
+		/* Let the path that got the early rsp complete it */
+		return 0;
+	}
 
 	tcp_conn = conn->dd_data;
 	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b4700de3445a..cf7dfd61860f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -482,7 +482,7 @@ extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_get_task(struct iscsi_task *task);
+extern bool iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 
-- 
2.25.1

