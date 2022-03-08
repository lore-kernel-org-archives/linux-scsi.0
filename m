Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C495C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiCHA3l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239319AbiCHA3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C7D25E9B
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:12 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LGAes022335;
        Tue, 8 Mar 2022 00:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=jQYCBCDDXzNRbCJkPDo0bZFgEvxpyXaqI9phr5yDp8c=;
 b=cdLiKs6t7IanrTbITbU5adxM5Fs51/Z9aA3sMJnRtuVMV+VrEXTjk3H44tfGfhyaJORd
 jsYrHevFVJ5BAmkmmL3CcOaWoJD5Xby90l6dvqXIxuNjyJrxB4wqC+7vnYmBiAclisco
 eB9+rHNAs9jmYAGticvEo2EevEpiNsPGmkuXT8Wx4YuPsrwl+98IC+Oz0huWSWdAICYf
 0VBFeOekkSj6VUK/sIeSWyWXGuuRAhYWLi7BpSh+vY2iwxwA+3tQsqGBAOwhexL70AS+
 OJ/mORDpBFfgGS5r9TZoqQgjZZ53tCLzkuHJgDmkThInj7FZK+QbkQMmLD1o3CtJsJTu fQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0njg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AKl0134578;
        Tue, 8 Mar 2022 00:28:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hs1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lv61+1k6Px6kUgnyYacz36xQPdmPw/gOIdDCUBh8iUd464FMDWK3DDPHnR6U65bWccSX05wBWWvBGuOWTLmc47e4/govJl5fAWTGyv8viQ6OIZ5KJzakKHx1M+ugis2C+L5dwoa6J9FEf47GYZJbLwxYYIrl+vOwG/K77LaAf24PZrOXrvjBVPr8dghXN8YNj5rVUKsS06CM1TSx8pWY8ZV7wCDNH3+GjW53Vuv2dCGYqL25J2ZV/+YC8C1dHwx4aauq2PNpGdxfbYqQmix0T9wtVCLBM7eAHkTP+jgjauXXwMmjKKbKKeqiAzdYi3i8fjwT0w9NuzwUIdhoqP/5Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQYCBCDDXzNRbCJkPDo0bZFgEvxpyXaqI9phr5yDp8c=;
 b=mLRl6z4JHjEMhvR70cyImUzrh96JsnW5jNDmC6kAR5NSoWfr/NNtrv6K75CrmghHK0aWRb5lV9Rv7DSRpOde2ZsOVmeU2yAaWhTUE1BWOaw+VWdMiuOrw0+kY611CaqBaq+WFfCTKxn+d/6m9bbvJoSGM/fQeqyFnsgrhcYWTMT2x0HwIpTWntWvCyg0zugmHOS0EOd4gA86ybtLfpDTc/i6Tss4w9iEbNZqKlwwufwvUrvU661qo6H7nCA5xWuV270PAPGn+gR7FBETEr7I177WerbWNT70ngh4VDC/6RSnH9Saaf4ctB1JPjRDTnjtqyoiN9sH4mRMd3TWbMOw5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQYCBCDDXzNRbCJkPDo0bZFgEvxpyXaqI9phr5yDp8c=;
 b=u3Hoki3maKzTU1F0kf5Zy1i2FPiFzs/XcDveouKdznmvhAhraw/TbbP9Nv9DQvd4ciYWUlRL555MEo+mWiAJkD9dfJ9Lcqtph3oxcRn+ZUjwQUzYKC2YiHR9QLErk4AinJsFvFvGLov9pdcBofyRhWYkdXjSotlJI5OXDbuTrZo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2809.namprd10.prod.outlook.com (2603:10b6:5:63::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:28:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:28:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/12] scsi: iscsi: Remove iscsi_get_task back_lock requirement
Date:   Mon,  7 Mar 2022 18:27:44 -0600
Message-Id: <20220308002747.122682-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e211ff84-b7f3-4f74-4d86-08da009a7fe7
X-MS-TrafficTypeDiagnostic: DM6PR10MB2809:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2809985C4A98176282EA4C78F1099@DM6PR10MB2809.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XH5XChwnuNJIqoDbqamQKIFEiPhZJH3Oj1hsV3ZgYgMdcbwrspnAjFzMy0QucnRZMGemmu0gBjRPzgY0oNLN4O4FizSmJZ2niHzHRweLW6fGxl7c0HhqVg+oD4UwR7V5FOlZO6vDesZNgrXChxX+JykFvaiRSX1+nn9xeu75B1sXBG2sr+ftrC+0gA2LRI7b+x+5stVqm0LT/UV1iS8usC3qrXJ2kmysZ0UNKHmY3PZojfMIzc39pNaavwEMiU6nUiWCAd3XPHi2DzfP1CAvOyMpoYIO4fRGuyV9fXowRdAhXJ6k674P8pDji2XdSVsSY9bGvBvv0oZF50CXhlCi8hn2PqqfjcmKzIujXy9delSXV2HhZAtNTTyfo2uhVqFztvRMH6y4EQng/5omg3pdpoK343qsKT1dYfuSjRhC7AASnKE2eexvhTjy6qfmfWy7tykH/SaQGITTdGGKVVIKNaQMGnyQ0kVUwJEgc+e2HVWY3LCZjIIFT+vlZ94+fp2gvQsGTT6Bh7lxf2nNcMrcqdUgT/LBtPRIzSujAi65jSWY0kKZUtB44fQFVX35IJ30cXMH8Wkr0yH+Lz/mhELYLQxfKwKBpYJvyPtvHeIATuHVI0oSXg8+4rkmNU0KIbF/99bn3C9OSye7iH27PZv+jHxKGzEcoXTZ9uFlS6d+3eM5hby1m1SI7h/RYwEgKR1ViIuX/fhpXR82In171EAm7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(38100700002)(66476007)(38350700002)(2906002)(66556008)(4326008)(8936002)(5660300002)(6486002)(86362001)(316002)(508600001)(52116002)(6506007)(186003)(26005)(36756003)(83380400001)(6512007)(6666004)(1076003)(2616005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CREgJYEO6Sx+kCTQSQ9HYZLAXImguXpBF2qsd9+rKZDzSQaSQYzuX5cib1NQ?=
 =?us-ascii?Q?xVveEcFlRgEKS2Nog6XjZ/Zz9QVL1P+0WqiIccGTBIG0JXyKmjgFQTreFq53?=
 =?us-ascii?Q?McTfeTQ2/chemKH3/9r5sZjphLuyZ4C1kIoPQkKPkcKY2oBQzUSufHVrG63e?=
 =?us-ascii?Q?Mj9lK+6QbueRuiM2xb7Vm+n/dOqoJd2hcz+7Ed51LDicIP0pQHzoIo399tjS?=
 =?us-ascii?Q?hpKLSwNpdvLRSufucbnp3f+Z5GCug39u/2qxmdqJNule9CQ3R14SmzVBRspg?=
 =?us-ascii?Q?nc+psybs5bigL+VUOllZLZ0S4LXldSJ063mxBIE4t5LW4+v6CLSkFm8M6F99?=
 =?us-ascii?Q?NzDOSKz9kQpMSzI8XFfokex/WdHdVw7YRgA3SzOEg/PIz1WY8pSbo+s4K5/Z?=
 =?us-ascii?Q?8PldbuADrcLb0UvdDwgUWhllfvtaIPXdUn2VJi2VZXPo3gSqX0T3LlgWs3AK?=
 =?us-ascii?Q?LtG8LdFYHrNjOSwKSxftHHrw6484NdOez0sr4g2crag2txdp9kTBEYXZot8a?=
 =?us-ascii?Q?hAlsNj2LCk1lo/OE80vgMZ0yAU2IoUy4n7ZMeV3yVOwYnTHXgjbF7Edzb86b?=
 =?us-ascii?Q?lpLvCI9dBHqB3J46OPxTFfP4bVHA+kWW+qv7VKRpT23bmjZ5mj1lGL5qdswX?=
 =?us-ascii?Q?D3weE7C6Ms6Rfzs6bBwxptIB/Sj6BAM9jNMo+XULXUkWiL7iXzp54waeQ+Pe?=
 =?us-ascii?Q?WXu4aCQW0Dz2ID08x3tAcvMZQkBDdDqgb+LLtM2iEyAprRpeoMzHyYEol9p5?=
 =?us-ascii?Q?bD+uDgI4/CYh1X35lc5xG0cwAV7JauANou0KZqTzTCVQP5ZvOlq50bca8KFe?=
 =?us-ascii?Q?E1uhc47Y4ItdaNmaDPziwN/1vOlbjAliOt3YT6OyvpxZhqYfbL323chzqmBD?=
 =?us-ascii?Q?mlLU7/lK5nxBqPlGLqlS02EwHTqBimcLdBL3Pnl/d2nnHnLJtvdEoBtKH9Bu?=
 =?us-ascii?Q?itBUeLfEuFccjng0cPnVuDahwKeiV/zcnnldhNxqPVcjQ2rCWxOpdg7vSJaX?=
 =?us-ascii?Q?5Rb93YQNIDchIcDOS/kyv1b3Ppl5om2HolOX5m7fo3DP2PD58SKmxjaXDYa0?=
 =?us-ascii?Q?Kyn5kmaE5wO/cjMyP0k4FsECcI/CMKZ+ZgKw+2X82O9WX3Ns6+81juvLCy/d?=
 =?us-ascii?Q?d3JN/yq3HhtToXB/LddyCLWRAuG0bp5GPFwM66MmdaDhKcik4qLbtDi5Zxg9?=
 =?us-ascii?Q?Z0i3ugy2etbjN8JMYrAPII7jInZGpjbSh6gNK+kRpepRcVMkE1tDIJLhrilE?=
 =?us-ascii?Q?A9ddkqkF2Wj6DYvoA6K0MdlTYN9TBfX2KDoMvI3/GXRxvC7yv1Ex8x0WBJEv?=
 =?us-ascii?Q?XkWUwjBJ4Uy+yS4LpgYw2O4IE8CHqhcOpw0BtXWK6LeqVQfflaDsXETJMNJQ?=
 =?us-ascii?Q?HCi369oTIDPrnlsGEoJOiaVwX9zHHu7m97tqQiMpq/f1CJrkJyw/Yy3tuVOO?=
 =?us-ascii?Q?uBXd6+Q44QmlStHYhjiuvjA+8f+1mkXfxTbomEjQL6cSGlpbFImMFl91c3dY?=
 =?us-ascii?Q?dtwLP46DfFqZ6AKUlkXQVSDhiNy+WBJiWLeIylGxRRdb8xMdTY3t0Wumnzzm?=
 =?us-ascii?Q?mZVDLzVQOcQyFRirF6Qx7uTyw7e3qfJkGE0/D12RakTFCfwSQBY0F1YxenaZ?=
 =?us-ascii?Q?ciS0j5oVOcvNy69+HwurWiVpFFdj21G0u7gYgUMP8cU2k+jpiFJF9nSO7fId?=
 =?us-ascii?Q?ZRQ5dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e211ff84-b7f3-4f74-4d86-08da009a7fe7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:59.8425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +I3w3F7wvo7CJZAikwFe+TyFHOAAGKtq08HUPBu2uYrC5mInsp+cGNU/cljH7w33N51oLrtP8GBzuCmUyt+aOs75Idu65SdJ7C8YgoustDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2809
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-ORIG-GUID: dezRTd83BM6mDajSjP3p2rttNA_ncYa1
X-Proofpoint-GUID: dezRTd83BM6mDajSjP3p2rttNA_ncYa1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently require that the back_lock is held when calling the functions
that manipulate the iscsi_task refcount. The only reason for this is to
handle races where we are handing SCSI-ml eh callbacks and the cmd is
completing at the same time the normal completion path is running, and we
can't return from the EH callback until the driver has stopped accessing
the cmd. By holding the back_lock while also accessing the task->state
makes it simple to check that a cmd is completing and also get/put a
refcount at the same time.

The problem is that we don't want to take the back_lock from the xmit path
for normal IO since it causes contention with the completion path if the
user has chosen to try and split those paths on different CPUs (in this
case abusing the CPUs and igoring caching improves perf for some uses).

This patch begins to remove the back_lock requirement for
iscsi_get/put_task by removing the requirement for the get path. Instead
of always holding the back_lock we detect if something has done the last
put and is about to call iscsi_free_task. The next patch will then allow
iscsi code to do the last put on a task and only grab the back_lock if
the refcount is now zero and it's going to call iscsi_free_task.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 19 ++++++-
 drivers/scsi/libiscsi.c         | 95 +++++++++++++++++++++++----------
 drivers/scsi/libiscsi_tcp.c     |  5 +-
 include/scsi/libiscsi.h         |  2 +-
 4 files changed, 88 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ab55681145f8..26e5446ac237 100644
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
index 5c74ab92725f..a2d0daf5bd60 100644
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
@@ -1449,8 +1456,17 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	spin_lock_bh(&conn->session->back_lock);
 
 	if (!conn->task) {
-		/* Take a ref so we can access it after xmit_task() */
-		__iscsi_get_task(task);
+		/*
+		 * Take a ref so we can access it after xmit_task().
+		 *
+		 * This should never fail because the failure paths will have
+		 * stopped the xmit thread. WARN on move on.
+		 */
+		if (!iscsi_get_task(task)) {
+			spin_unlock_bh(&conn->session->back_lock);
+			WARN_ON_ONCE(1);
+			return 0;
+		}
 	} else {
 		/* Already have a ref from when we failed to send it last call */
 		conn->task = NULL;
@@ -1492,7 +1508,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
 		 */
-		__iscsi_get_task(task);
+		iscsi_get_task(task);
 		conn->task = task;
 	}
 
@@ -1907,6 +1923,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 	struct iscsi_task *task;
 	int i;
 
+restart_cmd_loop:
 	spin_lock_bh(&session->back_lock);
 	for (i = 0; i < session->cmds_max; i++) {
 		task = session->cmds[i];
@@ -1915,22 +1932,25 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 
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
 
@@ -2035,7 +2055,16 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
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
@@ -2282,6 +2311,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "aborting sc %p\n", sc);
 
+completion_check:
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	/*
@@ -2321,13 +2351,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
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
index 883005757ddb..defe08142b75 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -558,7 +558,10 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		return 0;
 	}
 	task->last_xfer = jiffies;
-	__iscsi_get_task(task);
+	if (!iscsi_get_task(task)) {
+		/* Let the path that got the early rsp complete it */
+		return 0;
+	}
 
 	tcp_conn = conn->dd_data;
 	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 522fd16f1dbb..9032a214104c 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -470,7 +470,7 @@ extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_get_task(struct iscsi_task *task);
+extern bool iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 
-- 
2.25.1

