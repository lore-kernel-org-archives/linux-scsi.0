Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07600E8FDB6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbjJCUxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241131AbjJCUxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:53:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46C7DA
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:53:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I4oPo014401;
        Tue, 3 Oct 2023 20:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=myIXlPUUs+aWF4FaahpIwHu04bdlMeLC/y41ApmW+iE=;
 b=OmISWbszS3AunAf8mEkOd1p7DfSYHoBRJ3S5dht9++1057l4OoNMTG7Rdbn+uQFMlhYO
 yDIeKV8MAfrK1XSkunkuOD9aqvh0zC6SeF11R0NpFCN9AAJfQBeEOtBaR7ZAjMc9F/C0
 rA4dGYLJzzozjQdkNR5SlcOFH5k4qxtL5Z/xaj4o8ScQ/7FCeE32PG9nnWtwd8+6heBF
 4XnNzZgLakqiSGBX5osQK5/jjbxTVGYrHcNsC3tjP8R+9hJ48y5VLDyVF4IxJLa5nuMV
 hgQBBVeSE50//Pn6NjO7q5NHl3xIiuv/O+TaAO2GLxpZUJkREaqOtnl7aXuce6jahMCk 6w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea925s09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K09YM000576;
        Tue, 3 Oct 2023 20:51:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46j5nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5Cre+aeJD39eypsmCzMUNGNdJmDWRv6yC+vTTz1iYBoVApjKwoPgjNBHo9oT9Nh/Fvu2hia5NWkLy2kWY9QnIrGbyQ/4k2B9H4lOf/YvVk3BQcqpg5d8ojeYjbL2dPjDAaocjGlAnZkHWDt7KTH6pcFMHyU4LEA5WhsvMB2jY8BDQeksYum8mgT9HM0Xn+C7AO0qmUWm/X2iWDjXOa3kRMDCopIJzVgYC9fonD3RgXLOg+rBDhRPzVaA4YMqfeKuMKiT5iqgVRMHv/GvbHidKbytqybXj9HOJHhzV5ihmN+QNKa3OR+Eltayo0KonNiSBNHnXoSU3X8YxZTB1cBkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=myIXlPUUs+aWF4FaahpIwHu04bdlMeLC/y41ApmW+iE=;
 b=jKLCF8L+MyVcNsgXAmSbO/TKqT8xEwcd8S8cdhRBR7o79NfitQH148CubuiUDApzp/fVnusdxbpyH/mrGO9bE0ztkWxK94xbC2ORmqZOO4fkq6//jkOIq0iqOjC7lSY512VOJRM7GRXfd8Tt58KbNatrYQIARY210B0UFGgnERmgbWdK0mEyWsOfrIqt06zoVZkPoIIQ0H/Z9L5Jz10oIZA5tccQVMIjFRqeMhJ1FBttkS6J2QYJAKG3pO9zZRyx30Da4KQaLh/pwagadry4rBd0bMqxs88awuR8eixyxdX/fS7SJTw54z39+hDg+7CbjMDDI5unzTgCuzc/xRoz7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myIXlPUUs+aWF4FaahpIwHu04bdlMeLC/y41ApmW+iE=;
 b=dAqCUq/o5zv8gc6LDEn4lts3VADQMo2n1+Omm/8+/mnHbG18807CQ35y9w/+AU+dZCY9/Tab9DQhdU7AzC9m9y4IJTcz9IZJJ0DYHitCxIZPkt5ClPusiusVySJ2ZZQt8ayl6Xmjw3OV72njGBQmtFATYZuz4EVb3RiYPQA7YtE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:16 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/12] scsi: Fix sshdr use in scsi_test_unit_ready
Date:   Tue,  3 Oct 2023 15:50:51 -0500
Message-Id: <20231003205054.84507-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7cf8da-a071-45e4-670d-08dbc4527c78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FbhMzBitdyOWQMBS1RnK6Nrsz4zlJHanVstxSA5AXOnMYW8WJ2h8G0RWs9hvHGp24PsyB2LDNqRYWsUFBXcl6WAEPG4GrE7NfpNIHpB0Aq30Qva4brqfARvKW21CDUbYqKA/NXKwwkqPTm2f68P7CVpW1Tqdg8QlrIsIQCHhRlU2ah3aWxe9mDsu6NksIQ+LV1HXr4Cb+/FRoKDMV8L/0pVkq59QfhHO/X3Mi6pNpWI6zUV4gKXI2qUvbW3fsUso/F9vaLDRTU0fvC3mi3tVQpsPoE4raNsyg0cVp1tquB0Z+i50/ZThIblw2IJDgH+DKTs4QHwe80UTrLNGpxSWQUCFIEQ7WvxgRa92OHP1NHrSpKaoWjRAEONgydEy3F6ODCw5iQZUBznU3kkSBCXQzZIev9l0v6KVpmU3W9FaRUhwGHy5uNYqaFQL6N4PQcE8jWGbQXsA5Z42TM5cCg9fVrciwlSGVIO6Ncntd5WyQSxCWm46Yb37BxD2rxW+lsOjgnBB5wiLs+kWbLskU40AwcZKn6HbRP/TmDsMJvkRirVPYPKgl7ysQ7h+orYVKmPG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kCoeWQEWClZa2HrDLpWRXtlCNGOlzOKM78eC7aUl9LVcAUgOJqNADA75rQys?=
 =?us-ascii?Q?/gnQ0iG7mbQ8XyuiWPDBTU9kTEyEyuDLQJ4PWCDW2Nqmuh+mmGeDC8syBymy?=
 =?us-ascii?Q?ZYo4vrTpPNTe8LM8HfOG1dD2TdEa0eM9CZ9WeqmTMlCNfNN6IvI0TRzFVVF5?=
 =?us-ascii?Q?ecWR1FluHLlt/Qfra3PVCGLpRuoTRZquo82Vic78sWJvJLFkkd2B8NBtG1EN?=
 =?us-ascii?Q?gpoiVNRB3BwkE0863qs+ZtsyXSVxJW7ydecmhuR4cEP33GfRAVwyv556ewoG?=
 =?us-ascii?Q?ig3hqTL5DQ2DLe6MujX1YlO+EZiAOrBh9ew5hixAiblvV035Y5m3k6VHUmkt?=
 =?us-ascii?Q?ZmGz3c9umGqNXYX1SnZuCE6a1gJi4sBpRJw99PMReAteqjWOwjFDdPC4iu4Z?=
 =?us-ascii?Q?PQgsHoHZHxMPgiwzYCkphDINvLgHx3Rfum4AhZZuoV57qQpxuYPF9h18KgiP?=
 =?us-ascii?Q?IbIBllLrzukDrT9hfN4xaBwbJwvgUz5hMP+0ta6HbG8B87Ec6x72QormJbnq?=
 =?us-ascii?Q?F9Ss5/c0Vr0gXznT7Q5J6IBSBvO6qZrFqrBXMOFXllCVGu0lMV/UOJ0nr39b?=
 =?us-ascii?Q?8FKL4t7f1JIWjksGkMb6hUO/1r4Tq51QuJdpBTpgQIFajNBwRNEhDVRXQ40I?=
 =?us-ascii?Q?qcYbbT2i9bBqsU+B7SRux25PuFLQnzZlklh9Hb3CR69Yql7fZHkzHlYtZvLW?=
 =?us-ascii?Q?sBl/BcdqdlzS219OpDdmmKH1wyP2wvq0HewtHPCYinhApAGcg4ABT1SN92ML?=
 =?us-ascii?Q?2UVFok7PbIoAHMNALWB5n2uT28FEoeWs2+ELD7fLZo1KqipodASEvjp+90zC?=
 =?us-ascii?Q?xVQzhso6Q1PNBm78Cv06RvgNDgRcz491cHzCI6MGnYwmP1KdeI+91oq+cQw0?=
 =?us-ascii?Q?AFYW0gVYtxVtZmiRkdSgRc1742UhZynl1WGu1JCenkQg6dPsXedZxBN9aFyd?=
 =?us-ascii?Q?YJYb0GQAzxhpHyR8HJ8Xt1OvT2iohgRlJ7fzF+lruha/sBhakafrDlICt4BY?=
 =?us-ascii?Q?7tiNluW2EyptjA6EjHJcXnjhS0BMuFmCVpM4oU/vigfzMDGZq9NknNjORR3S?=
 =?us-ascii?Q?62kxWNXmM5QKhMVjaZDZGM2A84GqZDPF4O6Z32RVug0zFCVuIiQxqgn1ZzS4?=
 =?us-ascii?Q?WVviqkbYESJTFN4itCtEaS8LMyN8JNowmfhAtRma4+6l8EmkYnCtBmCvyxbn?=
 =?us-ascii?Q?WK3M1CZMBalCI6HiTszoiLFnd2/XeY6NU3cuL1zG3uuBRloJTEImxMyka/5g?=
 =?us-ascii?Q?PRGLJSSVlAHY8uPZrW+NT6ZjqIuVMkfUW8q2qbhleNlG/Cq1fchc63Lw0Nil?=
 =?us-ascii?Q?u7OedDNkpXt4/BHA6XH582c4A52wb0HbC22ng+NE/r8+eBInvS/ZjWeyjOwz?=
 =?us-ascii?Q?uMHfYKaHVw10F7mXC01whH+QwYH39Mk3LpjE3gZmo7iL/H8Guy12EjI0E5og?=
 =?us-ascii?Q?iFrh27DRn1Q8IU3afvdF2+jb6v5zOgRWmVn2O705qCzYi1k2i8LR+E5pnaF8?=
 =?us-ascii?Q?mgiyU+YNhlxwCd0MmN0W4HxGAn/wotlcd/xA+qhCchaE2G5HXFSTeY/MY+4N?=
 =?us-ascii?Q?wbqBLwtqL+0oGxuexnuqEIR8lhnLTombmqXOzrvCPNQHLBjqW1VeQeYxB7la?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Fku2Wq6kAa1+pnd7wc1kSUVSs7IWmiNKER/RY8L25BO4FoN5FwCqmk6Aop51ha/9kZQuhUNEvD/+gwl9IknmRMldTb/UZDC1+bIyx8H/5Epnn5YMkVgrlW8u3FemW/lFILYc/8kE3gXN6J1ZPGGyu2qJkI6NLHW7wk0LApg+FKsRuHWfn61Dop9H8gdT8sjRVCjXoynUCf3wVXyWcvE6eVVAEcT+3bgXVO0uCI6XjgiTVb7p9PuImrrR0494N4g5SmXcsljn4bswztqKuUKfx9ZGuEXcFJELFm/3s7Q8D7H1/IXdg+uN372SGejk7rKGtCL20LEnhBdlD7HQyUBadsDvAu3GPO8r71EKH25Ec9YJw3El5rp+8Qevf1np3VMXlfNwrx+hepqXRDvvvvKqDER6nZilKFnTOaGYt3ADH/N7wFOYLWN75p95bAYIge6xD0V+lxFidrMBhWa1kbwf6VyQsJ6JSzwgTW9y3DHetnbuGnfkNUc588vbIKmunRARGyEyBAnQNIFuXHwWuPc40M/Ct0za9g2VLC7P/YfF3Pwi2jWJElFjJAIS27qFoMhvJ7tFZmUSL0mt2mM5SnuE3WW+kRg1vEn6TnTpsDuYZTL3jb2Q3qTcCJXI9GtG+roTLnGtn/ZjRPNULcONMFee9P/dHBwNZGE0gLcyI7H+yylF479ZZZD8DWJBoi9+6LaJmopLm8PmFfARbtfj5BcP/BdnSQG7UPi6FDSi8ap27U9+2j6GjYG+mywuKHwHwqrVyctHH0jtXbGoeAFfbxDYpeBmXCtp6JqaWiuEdz9lq5F4owrIDo1wn3ljx/73bNsu2WlcEgyGWZH+LUjMYA62xLKgO2epdSrqVIGh3GxpAe5XMzaSJt70DCwA8wqOT4rC
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7cf8da-a071-45e4-670d-08dbc4527c78
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:15.8936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0Mw1sZVeLQRh0bmaTuP8DSih9+mTdx/SJ56RG5XfFS8BUk40wpI/qgN0Gwjbh01+Munwkv96r506VfCQr/DWoaUVXwgjybMk3Mq/Ew33yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310030158
X-Proofpoint-GUID: 1OlAsfdjcvfO__A9CAo-KcpLDlOM1wSs
X-Proofpoint-ORIG-GUID: 1OlAsfdjcvfO__A9CAo-KcpLDlOM1wSs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c2f647a7c1b0..195ca80667d0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2299,10 +2299,10 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	do {
 		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0,
 					  timeout, 1, &exec_args);
-		if (sdev->removable && scsi_sense_valid(sshdr) &&
+		if (sdev->removable && result > 0 && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
-	} while (scsi_sense_valid(sshdr) &&
+	} while (result > 0 && scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
 	return result;
-- 
2.34.1

