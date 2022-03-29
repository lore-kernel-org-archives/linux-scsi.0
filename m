Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C923DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbiC2SH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240415AbiC2SHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC436B1ABA
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsCGI029560;
        Tue, 29 Mar 2022 18:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Tp8LD/6eZF+xy7RVv9eqjQFFbzziXsbZOEI53Qomvt4=;
 b=QuZAZXzQ01g7uSeUR/egB9dPHnE0koeUDaENlfQgZ1KyxJFqD0qWa8RO6wPXFFGyx16v
 PWKMIloVstRuEEhDKZEKt2OYjEccfeajr6MiFBV/ELCWB6sMDTTb0ng/KL04xR77AK3Z
 UPHrIHYx7cj9ZAyIkiv9BG9aRNF++H/m8XKJfeAj8R82nHTiDhYzzb6UWr2J2E+H20uh
 X5Sh6BW04DUMOJmBNeFeV472C+AnqpO9ow+6GwxD0Lpoi3GpNumD9wR5gHMIS8V++Lzn
 DfocTOGE4KR9C9iC7ncdZP5HIdI+j48KoTIjdC7Yy/pgQSLYeedeFXD4hZ7KkZA3E3zW ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0fcv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJP048570;
        Tue, 29 Mar 2022 18:03:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjDETIn5gFSFysa4MMcjI8v1nkf/M7mPfG65F/VZlp5rL7wJ9jxbb0LGCrY0EDaKbhV+Ag8LuuMHvrTg4Wm+aPNjwh6pIZSFeGYhdXhmOPu7k//YMLKpME7FiDcTjbYuqKhTQxemQX/ET6jbLqfiKTd/SW5tRIqPOG04cQwk1XkRhIFHQUzBMgcX4ij960JKhHXJGnoZqVmV6enJHUm/ls1TKe14mfXtLs/7P0gBa7eF14YFmj9s21NkRHg65PoRnzfkeF41Sj4p4aZGBJGkq/VgacHYFpfgM1Aj0BPzPVlYZvhHXJg5lRt0H2P0ZgjgAPWDrK/oY2qOY0aJTJvXqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp8LD/6eZF+xy7RVv9eqjQFFbzziXsbZOEI53Qomvt4=;
 b=IKRLDOfZxvzN5pi++eSuRy7s5FQtWHRpaqb++fYMq2XEA/ERecmzc+471mL8BeD0c3WFrKngd5PD4QNV01EhC4dchbECBbfzv3H2iY0mo4KfzKqvnvWF/HQGzaLPWEXnOuFmitayqgW6qvf584DrVjIZ5Css33QagR5iH6j2xQDOOWRDtUhCno265k63TVYyP+OHOLCqkjqSburphPX4RlqMcx+x9yIhKqQNItGIEV41THQnahmwjW0V7P8WL41ndfeDoPtJYomeBbnxVysQPep2yv1l85bnn0YrwdNJHLCFhq3izGhsTa7CUj3GsoVeYg1oyPHuiZwUeT7ijW+5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tp8LD/6eZF+xy7RVv9eqjQFFbzziXsbZOEI53Qomvt4=;
 b=BZnBnGSKRXp6t6/DkuONScpP8TFui4rieoHgUylQuSAezoeSRmm5oclD71+k7KndsUeLUqv+jDEzaTtUo9JMa3byZhYdiwjFjlKzQpoBrhDxO+S9ACbG3PitrcRE7pISfQ1A45byFOz1e8TRurtC51i7V5HtDHIqKo3Vl8mzd/0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:41 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V3 11/15] scsi: iscsi: remove unneeded task state check
Date:   Tue, 29 Mar 2022 13:03:22 -0500
Message-Id: <20220329180326.5586-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f47b6bf4-e5b5-43b2-0991-08da11ae7474
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB358485D2A46F865E8E78B208F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oceJuIfkCsiDF3igPD6GnkexW9MuU9B7SrE8aMD3+65IGZ2X5Q48PRpqPbuaGpa9njBoTYZKYTIKdIuv/VgoIfTmodRzDn5IkEPHKvLVMShNi165nqR7kD6rWR2W4wLTs9ykkDxp9d8DZf5x/8SxV9i+h4UhRd1GflQqs+M8cq04UKQXcgaxjEtZ68T/MADy3p/plbbbddu1Pd4F81FhQn5lOpREsRJRkfaV/pQExc26l7Bjj3V4bqtk99uYEKFb1UbNq+/AiGMnSTnOF901crTKPAe9Rt7YHdGt69+Rtj5hKp2HqxD3k3doZK2cTMsMWE9EcjZOVqvAimKN2SySU2QTfzZ/74CUZU9CBnYUCE9pkvlvvRgTfZ93047tkW4qqMTWD/35ly5jkosMXz4ABgPkJgeXw+yg8v3pYdwhfYM2I1Jw8MMjW8Y0Liuch5E2xdEy6yQDVe8+KKAX/idAH1SgNMen7mpJzVWeN1aK5GheUJsFklpstOON+dRBWncLF8uqOGwvZS4nekfuLwTRD9/0rMjIhM41UzhU6Y1h+KXf7xvIOT8VNcFEvyOptmE8vWAmTYDanTcPmhyglyEnwkkePXDGUVaE9wtXpHe++cH12i6DYVYQlR6rAFhESEdwnmficYnoQahjrIAbnBdVVUeDRCMh+PUF0NdCBQwZGqavG8XJv8g9wFZkV+/SEAViY8yy5R3gz6PtQ5jNJdy8Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(54906003)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5vQaMQfN8NdRKzZ7PklPaeZ+B5WUfLRDMt1Tv9EyBJ67wZEhQ2nwDR4xCFYX?=
 =?us-ascii?Q?btUFyOPQVWdAEn2ne5t6J7L3cdKfk/lZkuPQ4b1SOl3a6LAvhDYiB6MoHKRj?=
 =?us-ascii?Q?GbYTHw6q+uKZqvv1llVuKuuUUU75EKdCfSHVeoFOzQIQU5b9OMw29qy3ujWn?=
 =?us-ascii?Q?vGcLIml1n4nTQ8hHZ3HBPuMiyUEXfMsdRL7M4z3rIu+3oWR3zTXpyf602mfC?=
 =?us-ascii?Q?HhQuA+62vmS5hlUAy2pKPhyecErqRJ6wM6CDYfuBoOpC0w9VRL6qthL0t9fJ?=
 =?us-ascii?Q?rDiMAcE29UNDcTD/TgSIFIBVPqo65Tw/Tr2I844NCJUean8etOW2QqTAMEgS?=
 =?us-ascii?Q?lv+vtnIiozaY6hpDdiuZirSUEf7a1WyO8zR6JwLM2NRF0EyY/RJ7ENcXH5NV?=
 =?us-ascii?Q?eZJHEIlNR0CUUFDmmno+NEAxpDegtdEmavx1KoQiskgAncTquQEiZZ5Egmfh?=
 =?us-ascii?Q?HLh+upZIJrwwciz8jJiC4LlPL4QFgf6p933MXd2mWxAyQruD33s8H4KWqczQ?=
 =?us-ascii?Q?0A4cTvi2PanNCiqZWjd21l4Db4pETBsB+/AiB/BGiS5sWcgIeRmYXy34snLP?=
 =?us-ascii?Q?lvv8W1xw+Iin48Sw2vP9YXMZSROJsACWhEYgM5ddSKRCyWa8wDuL6hj07Nux?=
 =?us-ascii?Q?DpPpAzl/j1W437oyaQ4t+SAEhYvqVjEN5mifPte+vq8BsK+EFfacTPprjLle?=
 =?us-ascii?Q?p9U5I3PyZ+bgIYyH/zRWGsPoayGna1nOADwYfQuZlhMK2ZQD1eD1/3iWSZZA?=
 =?us-ascii?Q?2LsCvVapcl8YAH6yCRlJL/ByYTrzlErFUzyJT0L9H+XCvwh2tRkFO/5WieT3?=
 =?us-ascii?Q?Ho17UQQ3bgA3jIqoMYAXAUCMr6HJhCaB+gCmPJYBVgfrQSqRdCMAn3i0fz1O?=
 =?us-ascii?Q?XG0TBq0cTYjXS8kv4X8YaKDRTyV1yUWtdMpus6mYgZJ14rDt1RUpkac5vVqG?=
 =?us-ascii?Q?r1STho/mJfLQWq7aiXb7mURF7WQrre7v0v9HHCJsT9RI1rPXlRVYGms+mloa?=
 =?us-ascii?Q?gWxaJ+qKo+++3cXBAwTaDY47YkDi2PM464Ook4Dd1Lb58oMth086NquceFAw?=
 =?us-ascii?Q?eOriqgUk35uHD5ZRvn6M7Y7qj2Y9VZuBC091yBpp2/JrmVS2fKTcBXXWD4FX?=
 =?us-ascii?Q?Jzn5iCNJz2tL1/18BD/BgXnoWoe1tsatpKFoaVfAPMAsbwaxbsgsJwfae1D/?=
 =?us-ascii?Q?SF6L3rczvhlBcZ2O3vNZ2RakcHtvZ93nQ6ifP3uxBjjMq03FiWeDM0tvhV7M?=
 =?us-ascii?Q?UEWLq7Dl1WX8+hpnwS3hYVE5T59ANfJChEt3LG1jCE8o4j2GZJmtde0kWWv/?=
 =?us-ascii?Q?Js1r1YpBSd6Y6fMM77CddHnyoAAIMjhiFEc9azOH5J26iZNM1cPg2Rj2Wohb?=
 =?us-ascii?Q?+RvD5Y6adx8bPY60Zt/vLa1XrNCy9HjYswLzti9o7LcbHhquIXvgGCjPgiml?=
 =?us-ascii?Q?3T/kSNZACx5Vdy4DS6GzLu0SWykUEb3fXnk9t5Jxq2DoE+1Uij+jJvGuluC+?=
 =?us-ascii?Q?ol1WcoT3MJvNVEQ/v3yZjVXD49nFT4UMHbcUspwsnSdN57P+ts9VeFC1gGpZ?=
 =?us-ascii?Q?bo+aOIlAjHU25pUaWE/dVR/ledSDSGbhbAWjniuRICC24wyqzD+3YXRBwRvy?=
 =?us-ascii?Q?UIX397GiXRF0cU+VqbUGbBpwznua4FLzHCkI+KZlmT5Q15XL/6KMl9M3o3Pn?=
 =?us-ascii?Q?j9eaDfr9w5GP+YoBFB6AleHS+2V9eOZwbk5vUIlnotDPKh1flHt2YOy/AqbE?=
 =?us-ascii?Q?c3pjpfDq/5mkHFfHt8JHfaY2r5DwzsI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f47b6bf4-e5b5-43b2-0991-08da11ae7474
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:40.4121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9G2kaanDYkXgPfH+HfHm5kw0u2ufhhE59QHh4vJjIfMRXGSXSdQRrw7yDVXYwE7jGSCdkLF14PT+B5ILOCG6pFTvaDB4rODvam05Ai75Nk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: f5rUoUm5ptK9W4AspDZ0UL1DQ7vlmzvQ
X-Proofpoint-GUID: f5rUoUm5ptK9W4AspDZ0UL1DQ7vlmzvQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch:

commit 5923d64b7ab6 ("scsi: libiscsi: Drop taskqueuelock")

added an extra task->state because for

commit 6f8830f5bbab ("scsi: libiscsi: add lock around task lists to fix
list corruption regression")

we didn't know why we ended up with cmds on the list and thought it
might have been a bad target sending a response while we were still
sending the cmd. We were never able to get a target to send us a response
early, because it turns out the bug was just a race in libiscsi/
libiscsi_tcp where

1. iscsi_tcp_r2t_rsp queues a r2t to tcp_task->r2tqueue.
2. iscsi_tcp_task_xmit runs iscsi_tcp_get_curr_r2t and sees we have a r2t.
It dequeues it and iscsi_tcp_task_xmit starts to process it.
3. iscsi_tcp_r2t_rsp runs iscsi_requeue_task and puts the task on the
requeue list.
4. iscsi_tcp_task_xmit sends the data for r2t. This is the final chunk of
data, so the cmd is done.
5. target sends the response.
6. On a different CPU from #3, iscsi_complete_task processes the response.
Since there was no common lock for the list, the lists/tasks pointers are
not fully in sync, so could end up with list corruption.

Since it was just a race on our side, this patch removes the extra check
and fixes up the comments.

Reviewed-by: Wu Bo <wubo40@huawei.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4b4333bb53f5..03a0561ba768 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -567,16 +567,19 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 	struct iscsi_conn *conn = task->conn;
 	bool early_complete = false;
 
-	/* Bad target might have completed task while it was still running */
+	/*
+	 * We might have raced where we handled a R2T early and got a response
+	 * but have not yet taken the task off the requeue list, then a TMF or
+	 * recovery happened and so we can still see it here.
+	 */
 	if (task->state == ISCSI_TASK_COMPLETED)
 		early_complete = true;
 
 	if (!list_empty(&task->running)) {
 		list_del_init(&task->running);
 		/*
-		 * If it's on a list but still running, this could be from
-		 * a bad target sending a rsp early, cleanup from a TMF, or
-		 * session recovery.
+		 * If it's on a list but still running this could be cleanup
+		 * from a TMF or session recovery.
 		 */
 		if (task->state == ISCSI_TASK_RUNNING ||
 		    task->state == ISCSI_TASK_COMPLETED)
@@ -1485,7 +1488,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	}
 	/* regular RX path uses back_lock */
 	spin_lock(&conn->session->back_lock);
-	if (rc && task->state == ISCSI_TASK_RUNNING) {
+	if (rc) {
 		/*
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
-- 
2.25.1

