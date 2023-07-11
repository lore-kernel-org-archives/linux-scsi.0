Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E6DC0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjGKVqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjGKVqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:46:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222BF1704
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:46:45 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDCQi003228;
        Tue, 11 Jul 2023 21:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=I0z+1LUB0S36t00ZKL+XxjMuxLQDU/YxeXIaUXER8v0=;
 b=MoVPSY2Ya2N/rhB7466+G31UqYKW44MXsH0Bnx5RGdNQi823/aG1s4eN/f4dwHtvOJ8A
 k+gZN7Jf9ryYGAqi3rOBXi4WbHaIF8bKf3xMpD2d7FgIRyMHe8GweVSuCHvU37AUcsrK
 M5wl258jnU5Q27Q5obgrv5Vf9u+cLaqF3o2NwhlnIouVgs9JcBmXE9tgh1NmIBVRRa6j
 ZIAFTvX6N4VzO8jB5q/64FbiM98QBCfWs1bIpm/jgwSG2o7SKup2FFGq7ohsA9EQuFUj
 Bj0cxvXNHgW/R54F98QiEntqROUiNDrtJeKmu8zviSN7mFicGjuJw5aATxhIgGtAdqBp 8g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyud647d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJtAUB026913;
        Tue, 11 Jul 2023 21:46:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h5q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fr7ghn+moNli0RcntR+ajFjRtaH1RGkI/1nAhcpI3n5h90EJjY+bTjWXDG73cU/HK5aFSFNrUf+p8Pqq4BxmFHHRtvntmRTTYLnJzTWZnrQoj0hUQntWXjNV10Ep0rEhU1FomiqzhUlEJQ9tQ0nCvWnWSYODn4FbrLmK6R04jbnifrBeRIYF+Gjfd0INSZPcYCxkr+SE8ev+BLI/MYU1fhyfI5v5i7vT7dcGogKF1IsPjMnmv/rs05frK+DwGAiTzzP4dgk4v11beyqD5ZcHtrFilwL2b9cxw9dwbjfjVlnNGwJONlxiGm0CY17FGREIwE009S9ldt75TDYvDwKoAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0z+1LUB0S36t00ZKL+XxjMuxLQDU/YxeXIaUXER8v0=;
 b=nGvzQZNhNYaMJxlu6zTMJ+WVBVUIMMZ/baHwkg2oZMe+t7LRaa8OCYgCf19qud4HbIW/yXjDLsiqhyZ81oQBVB+AtAnRwatq+6P0CuNvIs8DbC1mglcUl+c8LCmheKK0BUHTupeby7JLv5NKGHdAYzBt58tV1/Cw4Hoi/utgajzwJzlkNY9goUamsqutmwTXBqNEC5xHzNxkTUx0VmQiNYsNOmJKqmZYMIZ/j2Pa4vx6pT3xQGouYvtfHJ1guxVMpGjaGd2d5BzRJ0WCfI776Tj/8diChfzOvc+CPHHnh2XtYaOnqgA3fM9Du+oRqzXF6Wzfp0exm43YZrQIjJRqwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0z+1LUB0S36t00ZKL+XxjMuxLQDU/YxeXIaUXER8v0=;
 b=kibQdZ9bnCqRuRHJAqnbl/aN5tSUSuMWoxmR1AVVku2CbC3+H9KIiEe/CozhlOoKeVWg5+pBg6t7w1Q7Icjp9WbJbbvRGruJENvijuuQuea1wuMkBnnJKHPDCqdbkCBVDnDoWEYUlgOE/DgzCXSXEVQPCKHy5itKg3UNBMDcwO0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB6950.namprd10.prod.outlook.com (2603:10b6:806:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Tue, 11 Jul
 2023 21:46:32 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 03/33] scsi: Add scsi_failure field to scsi_exec_args
Date:   Tue, 11 Jul 2023 16:45:50 -0500
Message-Id: <20230711214620.87232-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:8:57::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: cceda902-638f-449a-babe-08db825849f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z/XbBX3hvYw7GnqnPoKrYdEToVrHE6scwCs2gPqffbWgTlsmaaOuEsmHYhYLXsCzXVvkdHcjRZo+JXsBZ7hhWR+Zs2th39n1G54gfs+oR20HXem1rwW0KOIEqTKf4m5BRh0yvX4MDwFtk43cgOPZq9bc3N8js013HCx88TlQSxkBHdriwAMiroOy8CcPKJm6dTetPqEVXr6pK2MrhJy9gxrhdvzE3ub/yg+Qk+7NEof9gkXwcy7egPZI1TU2Z0+dlvyhjrFyU3cewT9CJgWWngVlJdOP4JOOCDoRIMpS/IN+IYTkEgi9/jEJ+qShDAxF3eA+12SSHsfjR7OtS+pv1AmEI8VipQt6uidKo0ux9Jhq8Z5jcMV/PaS4KiLFk92d/+OcTiVzCk1pNvbd2BCEoAYKF4jEXwI5yv3wQ4UCG3LJungwH5xllCZtOEcgyr/qz1MyLup7vboVhca1ef62OXT6A3hcHcbDy/6c5ZxA79k+Sk5FduWSbJ19aWMA1ukWpzop82C58XbkqYDkLM+q+5QGEGetPGw4rhO6w5Y78lIIrarqHKh2TaZ0kEXBw1Yc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199021)(186003)(6506007)(2616005)(6512007)(478600001)(26005)(1076003)(107886003)(83380400001)(41300700001)(4326008)(5660300002)(66556008)(2906002)(316002)(8676002)(8936002)(66946007)(66476007)(6486002)(6666004)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jkRAqayeM2uMYjz6t+7JiwdmPA+1ddfIO1cl+kmfUir3riYA2pV1/WWCTnup?=
 =?us-ascii?Q?A7aSGO9fGf9B1uBNpXGXF+RFTsqx6TouqGtBdQD3lQnjb9ZwUhDxTXFy3tDn?=
 =?us-ascii?Q?35hyMjViI5PG14UwE/I0gTfkNkWejmbKdQdHITBE6CLPH+F8sv1LwfHjqfW8?=
 =?us-ascii?Q?6kobhwTIy0F3ScdpqM2ODg494lO/BzTM9BqK5Rag95QT4PRHI7h6ctsMegET?=
 =?us-ascii?Q?5Z9DDwahVUDTL7xL3PLRn1JISjl+RQ4iPXCxmvwoF/K2Rc5RKoxXWsQpzmPN?=
 =?us-ascii?Q?zF6Cm4cxjGMS1/ogP6HS/ONotvzS2/GSw9cjh/CzIhl15ITgbW+4UaCcPoMH?=
 =?us-ascii?Q?P8TD+hN/q/bZlbuxGJVMKjxhiJcnTUH49uAgR1kyzIqYg7B59fMTzSOfPdoS?=
 =?us-ascii?Q?03NqVYtiNLAXev4DeE1kdJxiGn6zwj8uDcDkVTfhyQVF9gm2fRLvuf81bNi7?=
 =?us-ascii?Q?wSLFtQc4iY5tOyxu+GOqkVyzh/Y7DNCUymDN+nZlXVEPo0zWt0Fbw6ie0Get?=
 =?us-ascii?Q?N8PtWlEfq/cU4evNdEa46yg4mDTKb3E/QWCO4IKjkC5clGY8cTYpgHIOOPZE?=
 =?us-ascii?Q?yFMI60iQCnodyqWXLKiKOXLu2+eO5E8AABe800Z0ghkTvqic+fdknR6NhbHG?=
 =?us-ascii?Q?btpjlDUBoaDlzC+RwLZr1kei47VPjpLdX5toC16JbXS0Reu6lBZrzIE4Q8mG?=
 =?us-ascii?Q?fn0T3NlcLeZEeB5u1oTgYwwj+C2l66t5BEFCJgwYPWKvC649NigFVrmlEzvW?=
 =?us-ascii?Q?BdW4UsvE8lcregymXdjaMzCguDLSNhturkPjXxkcken+6oHnoqrTm5rd+RT/?=
 =?us-ascii?Q?X5tpza9NBna0HEdmEw1YvV391xviYL2wxDDBPVrpMQq9aiYpCVBxy+eDXtKz?=
 =?us-ascii?Q?tzcrunZTrFZ/hx4+xIix8QneY+RUyO14QT2GY2VJb4cJyiUBWuGsraaPRjDn?=
 =?us-ascii?Q?JdHsgVbgphORcVTohnROPItDgWQxs5ayxozGJXIUr4MFvIwaQ0Ibdwgowjjk?=
 =?us-ascii?Q?tBdggmwUsYmEjlPUfRu/5UO/Nhna4WZwzAw/hYnIzQbsFAeaAsgLyCXfu0q3?=
 =?us-ascii?Q?KtcdwiJNzmNnhHlbwNhk+tEcZMirBSugM7M1RH5Ie3+IiKNNI7bYSgTHRddV?=
 =?us-ascii?Q?itMh5DGxyY8XnUPosTVGOSwNd6mu+Nv0EChsGUloMNazE827Q1wPypX+iAwh?=
 =?us-ascii?Q?2gjZVRymzqDquI2Yj9YqlZK1JLrw/y8FlogbOMcdSRyLgHRSaMDXwApVcg6H?=
 =?us-ascii?Q?lkDFBcjcS/4FaSun4vyJdkgZliA6dqJ13MjKUVa+RFHUrEl7Q6VqCj21I2WJ?=
 =?us-ascii?Q?VbCfdLFRLOfJd8bim4x3j6QYCGNN09H3LvGuFtJMjqZ39KPEn4l3BplAdaB8?=
 =?us-ascii?Q?KDhVapJjA8BRUWU9ZnGb/9VKsH/dfSGOu5489pjlzG1Y5vyBHJOBTrQtWjuO?=
 =?us-ascii?Q?uFwHFtPx9oMsgY82ILjqOnvmFhXAWeD+kmvXxu1LBk7pkPk6EF8ibn++a0SY?=
 =?us-ascii?Q?KO/kq45QaM+8qy4H/e2NFfYKA0VZFvheLN1jhkOX3iPEMo76ogehEAJL/+W/?=
 =?us-ascii?Q?2xSQUeiGcIqK6inCif5PvewgFFA7EUhKE8crczjFjFL/RCIJryjrnR8c4DzD?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: erYz2SO1R82o+/ooxK7kJA0NXy9R59aU22EIKEsZ2xnfepsRbJAbk+QWHDyob9/SUJa56TnNLbg4Parwe9py72+4D5lx83NiEzl+ShmtXbYiub+Yyah3jdsjTAzW0HWQL3IF8/tgJfv4qBOqNvge2E/AUFkt05Lm+EiawOa5DzdUgw5o46JppIAllaM885P3yQhnmLdflexHIYm70zDU5nCQyrTK2jpnjwIAPAm8m5rDuaF7g0p5wYgfI4kxUpx7YD2ZfxUXpavLE6ailRfJtHO49+S4puIHvH5YWrxdXEDeW41PHe7jd0hRpI85RfspSBy2iB+s7D0WWeiPXGy/oFzGBiSHIXh7A6uBsIw5bm0WEspOLQ4S+tIccTVAq8i9cUL/J87vAvLsT8psPJMK/I2qY/k6R80ZJ3uiUNX4as3ngLJC0ldnXDbgcYzPL24HuqjLdV6UXL2jiiXz2LQo/LIXhpKpMQu+1gezZQpLhGTR5BHzT7ZR1ehwIZZSeC0eYE3OeP0jIYgtqDgsSgzhF41InWEwb4J9hlgjp9zME8KQ8w4ZwgcnZGIAFl82E+Cb0Kc9dQ3wzZbjDGWhsMRL1OtrxK9Yi1paLSPi7noygIfkhMpKmD5P4IYqtBpEbxPO8M7FzIJpRAuq3UZqKXRHTQEkS/738dhvjC8FlTOZkYOMPmS40BP1JqrncIXwOg1a25OYWApmpqRdLLDc3pxm05XWCzh+w+lk5vlEOnEROowtFz04wFLe4Yu+eVCdtHK+DvMP52MbNcCyjsjUIORlyutHopNR1dbKAZW7bfBm8zeNDZeAZZFDB5U8vMR6TCYKdlfN7MrqOmcKHOii1nrkrMh8BXAavQ357uuLOMXYXZ4EObXysDQcAwmTB3Va3Zf3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cceda902-638f-449a-babe-08db825849f8
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:31.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pL2rJKbJYhZdczCc6cb5WTBOnf95SUPEXqlz5MVuIQGJQl9XmWKLJ4w3uMMWFH9XBMwRMmj7RiSZMu7qALow2YdWd6daCK6BHX3dNER0kMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-ORIG-GUID: KxdQyDBSuIj_nml-BY5hvhXxynHuGKbD
X-Proofpoint-GUID: KxdQyDBSuIj_nml-BY5hvhXxynHuGKbD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 53cb649b2f28..f539fc4b7148 100644
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
index b2cdb078b7bd..381d08220665 100644
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

