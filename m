Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81063E81815
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjI1CJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjI1CJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:09:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B7DB3;
        Wed, 27 Sep 2023 19:09:16 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL6gOf028420;
        Thu, 28 Sep 2023 02:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=E8Tae8tilgxq+dGuQqI2tvDzTcZUjt/G8MKIOKdvkG4=;
 b=uqYWmJ5geD7DErjH62b+4iueygRLQFanTMULbBFh/Ojjzl8p/XfF7Ze+aQIo5V9cBvTQ
 tCkqvw7c9jNlksuMWjNIMTQ2HeiOHcY7PFSUpdU/l+GSbzNqdLjK5/sPyMpzF8QOAZlx
 WgMVQXnYKu17bWRBZo1LiJHRELMHIlAFjfUlK6iGdarFoncdr/Pl+Lo8RH5smexkmCb8
 iMLE1WhpjbhuJW/tyKR0oOZKPXSlW+HlqV24mjjWXR9x2Hc5NlPomjC0Z21Uu20E6iZ7
 4PKlH7eevgA3IrGVO74lUWVHBKGyr7WLRYppdcqzjFpMYghboPESKi+KfBIPVpuNT9sX hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9peeb0h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38S1VcfZ036610;
        Thu, 28 Sep 2023 02:09:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf97800-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4F90XkhN+NVFGzWomLmeFW5WNk+CCS8/QQ8MveLcrQhIVR9efEesoZ8EmB5WphSvhPVkW7ilzujiAqg2732+iZZrKhnyNJXFqR4bXC8b389RIdvL2751Ci7oq0Hz7Ck/2vA7t9tzNLnVCAIAbj05zsxjRs+rSwIXaHUM2Jdg5lJwDTohMVCuwx4xS3NYY+upw2LEG435/4JjZpxpgNvnqco37BlXLJphAGrs8HwssmIOJqd1n/0XgMLoyur815m+I4JdHNRbhzjDguHm4+js/n0Yi/RoynCESPv/yCAWupLsFyt7agrhr+MsHugpXkg5bWQU0T74/86SOdSoTIoSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8Tae8tilgxq+dGuQqI2tvDzTcZUjt/G8MKIOKdvkG4=;
 b=KYIY947LmwUuncCqCXy1Jhm5QEr9ih2kptH222mMo3TuYv8wHTry4k3UarY0c3uBbS+r9tInTiy9i25szaKG1zMtdP3j6LaZuIlPCDxMwf7RxJ4MGdbkTSmaHNB5Fb2AMc4nmEeqazzNuhRPDWiaIFLsLwi23SoRqDLi6G9OKTsUkkM8EX4sPFx4I96BOvrHjl3N3/77liWPn0YjDKAdhgUerET6x2qo50jTv08jnmIAwDIMSaMtFWf/5ubnJK4rZrHTMQbm+Azyl2SnurCGV4Zv+WGwpnkk4MMeVfHJ/vL9ntovZqSJs/OlaTzoZZkKh1+gKydPYfGRDQOcHWkiuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8Tae8tilgxq+dGuQqI2tvDzTcZUjt/G8MKIOKdvkG4=;
 b=ze0Aj9uXIwuKjPe75Kxl6UMrOacKLBP7XtIoyPVUeV1PlDL5Qir41zNtll+Yfy3e5ecAQTxFL8ZKza2SkSJ5Z0F2pdRmRcf6ylKAJl1FI9PqU3rHAZOZYNRDTzX8n4JRI7u1DR2s28vvW5y7OhjGzxad2/bvkFZ8rnijRuUA5fw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 28 Sep
 2023 02:09:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:09:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 3/8] target: Move core_alua_check_nonop_delay call
Date:   Wed, 27 Sep 2023 21:09:02 -0500
Message-Id: <20230928020907.5730-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928020907.5730-1-michael.christie@oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0119.namprd07.prod.outlook.com
 (2603:10b6:5:330::11) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: ad63f3b9-a05b-4d50-d5e7-08dbbfc7e869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UmiANx7uCUff6LxwMbFaL7rtGtt19pLuseFzlG3rRXg7vw1CHT6upZjp3YT509TsiLGOIjFG9XwwjMwHZciid+cJlDA9624uS2XjJqaEho0H30zGSZsXVeyFXZTFtzVBIk3JidH0fyYePFbEEpCD6EKcV6U17JmMsNFNUEbLBA6rxPWRFB4O19nj4YcR+rZxCtQxXcBVN+vNexIiUAeZ3jaNWu6U/+Whfu86eT1gTGotyYBlLtoxAYNwAi7uTQxLtQqp/7V57MvhUNKyXYkN8fufAb7LFdOp6BXARUea4KsB1qXMJibZ6d1/DMhl2o95VZ+kuzDd4vwmZSGq4EeXPT3aQbPOzFEzI5QzJjmTh8VmVXcR4I8vIdR4H96D5WqJFvJSnUx6bVPKVjXYDJxYo7iH70prwBdxqDJizKWH5zRsqltJ5gSnXo9eSBbz8PNFnu1l9GFCJFMs0ByAXeyzQRyDzQ7AR8fzgu6Rc0VgMoiSYRFzagzNDnmJH/pisOnOFLk04Ml6n1wnDs8853sCbb7najL//KU8MLyjE5+MiV83zcjV7mJ7YKk6SEyBDN55
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(1076003)(5660300002)(4326008)(107886003)(66476007)(8676002)(66556008)(450100002)(66946007)(8936002)(2616005)(41300700001)(316002)(38100700002)(26005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xpLAWZ0RVv8zrvdPlWXpzh5RHWnNUM29mHZ/rL9tdRy4qGsRcT784dO1JLRZ?=
 =?us-ascii?Q?qmBcO9w9oqmzpQyPzVE4ckg9QuLkR3o+7J1jmnrOMQg03hEsEPWNB8TBF+P9?=
 =?us-ascii?Q?qVFHON2nmmGDSUB3Bbrsqan3WWEPI4GYrtl8uOclsDeopjWB69AfhLbzi8PS?=
 =?us-ascii?Q?J7P32JjAjZ6kmH8F842k7YNapiN0vLikZB/k17s3Ls41DNVk7zI7ekGxY9FZ?=
 =?us-ascii?Q?hXSkr3EIRQ79OOqOZd2YoP7y81yUnPBPPs1hfC6kc554R/MTmr+FPZvN75zv?=
 =?us-ascii?Q?PKL0infFYauE2L6Ri/n1dVwbWZCjDgY2y4+EHtc+wHyiwLyD367hGaOJtaDT?=
 =?us-ascii?Q?VNxsqIrhZb7N43AbwPjYI6MWSWNZKpk8H+wGMivQBzic0xVLdCOQUSAjuW9N?=
 =?us-ascii?Q?3VhT8OhmrJwiEE9vJn47Sm1K/8Kv1Yn6hUztnrp0wz+oslFDgc7U9tHNndDC?=
 =?us-ascii?Q?b8rWS5qakiWrXWaO6dxZeY8DU3ujrU6d758BIXpy0yz0r52tpHs2FerF+vBk?=
 =?us-ascii?Q?Q7DegI2WwZywvt6qq2amIE+tuf2nAe11pz1qpL7aKbGKEtY8ljS6T0WxlzXt?=
 =?us-ascii?Q?eSrQptJjJY1JPaNI8jJIYahRoiScpIzDFtbahCZ1Dwe8NSldkERzZXRyy1LB?=
 =?us-ascii?Q?eE95XLTYxhZrCZeKlOIGzdFRfTzfJxsEFk5yG1TV6yCColYKbc2ICWNG3+oe?=
 =?us-ascii?Q?pwhBcCAoTTYYUkWHYNJQw0UXa0tIimoIX1F1vIvl7YQ1PIUGpmRO/E9Dven9?=
 =?us-ascii?Q?ZPbvlxMZG5lX3DphCCQvs8Qwg4z+576yX4KulJwPPiP8jSGNSYKbZrxvcOI5?=
 =?us-ascii?Q?EhkU+X/y2Vfc/WJc7Y3yh7EA/99rPtPMqMyxoTLvdm0/BG0zxdHyjSsdGrql?=
 =?us-ascii?Q?c58eNJtVkSMyDZyCLyq7TkLrOI2wtexvog/YbmXFW22GBS7+Y/ajCgxCvIKN?=
 =?us-ascii?Q?d/f3G+/LSa/yRTSQle6I1Fyg1/wXkKEUoExbf/kPzLHHxlUFX2lGBkPi6nQS?=
 =?us-ascii?Q?C4ia/6HpddpAygCte8qZrKoc4x9gZbDjvEDa8+rn1WHb/sp8QdKhX7OjRoyt?=
 =?us-ascii?Q?YAqb67mKj73jA0zeLX416l7V/NXPy7WmnxecS3skTQYC+K4HLDDrZ9hRZbG9?=
 =?us-ascii?Q?kAD3+zDmm3kgV8nbp1faCisAGAsoeZXv3hhUsqX3t3GzNdh3KqhAlu50GeDC?=
 =?us-ascii?Q?zNyQZmv3r6UGxMtnTsbU6eWpNuTIT3+Jp5t5tFpgd4lommYTgXqQG0BxHE2v?=
 =?us-ascii?Q?dx/4y27E9c6oSODf2XOxgjZcAF9Nr7Tuw9JbO5UKyGlK2qOpaz+z5rEXMRQO?=
 =?us-ascii?Q?ADh/e2RIXUtzzo+rBfBSUf5VK/ZRhGrAq8KW8t4uOqa9OevsdOnoeZz/reGD?=
 =?us-ascii?Q?YfSgwL9L7mwlisok6h+uMb3QhKfFsPx782ixGYAsp6oeY4qCbjSxGJP6QFVe?=
 =?us-ascii?Q?c2BFqA1ofb1OFwyvZrHNzfbVn3d6S1sLhNEYx3yT0XEj4t7QPeV6auLbA4d0?=
 =?us-ascii?Q?pmoOFmTMqCQmSKUgKPzDGEMCWBa5TMw/UD4I27rmPkzpq3fBRB/Tfu7kVTVx?=
 =?us-ascii?Q?dx1X36TyABrEez9sXxM6x6ytL0JiYe+ZBm5IyjZbMF6N+cuM8cVqfnkZLWq7?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /uz8luxSIRCzrVHjrcn3BKOLJSkgB3aqtFW9Ch4XhYG18H/t3gzKipfK7ZY299y9MLlUAbZGxxe9mmVDSKkYIRlBB3HUUswBCp/gHCpsr8jRkjFmxkfT7ByAucV61d6Q8xFWudR/NX1tviovLWDhMSJCHOD5l8qCvHKQFLxkpv6z87q/qKWV+XMSN92dMeySpHYd0idVatiFc0jWDOFH4i9DaOXiigSiquwyw9UrUJ9NHRPiLkEHWz4wT9BhcQi12sJRX4eqsLY64CsW4KnGI5jJmxbzlDRzOh3aQCLdHyhA1EmYtcWjUDXGnbqiCFAs0Rf4z4Ar/5exeg7OkW+bvPpvLDsl2Tj9v/iyaWE7dTQpnZa06H5gpBnBy0kzqhu08MG/k5+4nMK/oU0etgPnGvxqDVCXyEP04SyegYH2jsEK+jghXSYr2Tg7X0pb10FD7p6bpUJlowM6A8LLJdzFm0lgO5xVDrp1fv4TJrZyhPbjK6Ya1cMal7XfBJufdz75MtbiWoNe92i4ZTTZaZB2fZazI6DkWNOPzqiiKyt1CBbfG77KNxmrkOOO9wZyUqAbpk2vYWrFGd14lcFxo6PsTf3vs9CD7tjpM5Sk6lSPfHI15f5nU41ULcjCoyr1GbaqKcHBK2DABTrvG8PrGaUM5a/kdO6qOpbBGynHc9LVyc7SjNUcWvjlXHPdXn1n/zPz7zDcV27a0ozu/d72in9qhBujBpHPQKAwx43Ti20mR+Vi0eUbNGTsYBDOF1TeV8sDHd4Q9MUiyGcpM6F+ra6uSA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad63f3b9-a05b-4d50-d5e7-08dbbfc7e869
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:09:12.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tsxGJvhRW9KdvBdiqztpvlUxNQjgcD1X4lmZdUHgKcYRQHbYKMra2uhVjYlGV6XiD8w0/FDJ6+76wBsDWNVN0eiz4Hi+8OTqyvVFL9+06lw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280018
X-Proofpoint-ORIG-GUID: 4pR4qNHSsgi1qC3eczobj83LhaHCov8_
X-Proofpoint-GUID: 4pR4qNHSsgi1qC3eczobj83LhaHCov8_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This moves core_alua_check_nonop_delay to transport_handle_cdb_direct so
the iSCSI target driver doesn't have to call as many core functions
directly. This patchset will eventually merge transport_handle_cdb_direct
and target_submit so iSCSI and the other drivers call a common function.

It will also be helpful with the next patches which allow the iSCSI
target to defer command submission to the lio submission workqueue,
because we will have a common submission function for that which will
be based on transport_handle_cdb_direct/target_submit.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    |  6 ------
 drivers/target/target_core_alua.c      |  1 -
 drivers/target/target_core_transport.c | 12 ++++++------
 include/target/target_core_fabric.h    |  2 --
 4 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b516c2893420..1d25e64b068a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1234,12 +1234,6 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	spin_lock_bh(&conn->cmd_lock);
 	list_add_tail(&cmd->i_conn_node, &conn->conn_cmd_list);
 	spin_unlock_bh(&conn->cmd_lock);
-	/*
-	 * Check if we need to delay processing because of ALUA
-	 * Active/NonOptimized primary access state..
-	 */
-	core_alua_check_nonop_delay(&cmd->se_cmd);
-
 	return 0;
 }
 EXPORT_SYMBOL(iscsit_setup_scsi_cmd);
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 3372856319f7..01751faad386 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -850,7 +850,6 @@ int core_alua_check_nonop_delay(
 	msleep_interruptible(cmd->alua_nonop_delay);
 	return 0;
 }
-EXPORT_SYMBOL(core_alua_check_nonop_delay);
 
 static int core_alua_write_tpg_metadata(
 	const char *path,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0686882bcbda..709314415a01 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1587,6 +1587,12 @@ int transport_handle_cdb_direct(
 
 	might_sleep();
 
+	/*
+	 * Check if we need to delay processing because of ALUA
+	 * Active/NonOptimized primary access state..
+	 */
+	core_alua_check_nonop_delay(cmd);
+
 	if (!cmd->se_lun) {
 		dump_stack();
 		pr_err("cmd->se_lun is NULL\n");
@@ -1818,12 +1824,6 @@ void target_submit(struct se_cmd *se_cmd)
 
 	}
 
-	/*
-	 * Check if we need to delay processing because of ALUA
-	 * Active/NonOptimized primary access state..
-	 */
-	core_alua_check_nonop_delay(se_cmd);
-
 	transport_handle_cdb_direct(se_cmd);
 }
 EXPORT_SYMBOL_GPL(target_submit);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index dcd7d76d2f30..e5fcfb845529 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -206,8 +206,6 @@ void	target_stop_session(struct se_session *se_sess);
 void	target_wait_for_sess_cmds(struct se_session *);
 void	target_show_cmd(const char *pfx, struct se_cmd *cmd);
 
-int	core_alua_check_nonop_delay(struct se_cmd *);
-
 int	core_tmr_alloc_req(struct se_cmd *, void *, u8, gfp_t);
 void	core_tmr_release_req(struct se_tmr_req *);
 int	transport_generic_handle_tmr(struct se_cmd *);
-- 
2.34.1

