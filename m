Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766A1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiESAgi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiESAgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:36:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D13261E
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIq1o027463;
        Thu, 19 May 2022 00:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zNDMzd3ozPBbhQxOijWZaIue71pL6z1s07tA7W3XdYc=;
 b=Q4KNT12uSlXQaLCYo0IPTZ5Wj6Ipbcg4epKgTiHVdqGoYasCHkxV9cqLIAIQMRZznc9K
 H2tzi/3BM1LotiFEKiBUjDNDvPa/K/kv/EMO1XvMfWoIqKs4q6c4GIxwVI3yFh6kpU6W
 Pen9bbIY095D6gGF2w9XRC11CgZpzw22YQS6Y+6Mk4atEx6eLk6U40vzNBMUf6VX9UM5
 8qreiDj7bMUayZE2hOJiPwO5ScnwK7E59Bw8TS15BppTCG3F6O6Xj/v4kGFsL8Pmjlrr
 h2p0HjvNeJwXimzqogGYJGLypgN0N+D5+eXXt0+h0lLuAAH8Li7hmpxlB0+HT25Dk/9I aA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sauth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VF015306;
        Thu, 19 May 2022 00:35:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mntbmh1fhX3sXGhWWf4De2ZtWivcM1xWgl5no9dX9g7aLFNBKSM5B82xN1/MInfPsqcmLyeDUXb7rrEllIP0HxYnTGfQM82JnbOTfu28DtKHsjONgFB1XHYu8dpH5wBmBw2FOmampSSInvl0oXoTCgjX9phfpxgo23GCtq+qnV1Vo0HMEZpvasaSFqZTI456NfEiglscSBT/08NArnhDJzWEacHgV50jXAxAx9FA241RpQDvPB5gKTLE719C1cRUzuDluBpQY3xlxzEv3ClDjwPDxLey8xwPvGBhparlSES8PRFv40GML+tm/SlG0UZ+AEuaKp715lvov1TftVdSnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNDMzd3ozPBbhQxOijWZaIue71pL6z1s07tA7W3XdYc=;
 b=Ye+VmEznL+e+eiLgwGmxtQsb1texlJKO7/j0MFP/VuPicAuY/hR+XmTrJ3gt4XctvqvF2vueceBvHdSt0TrdkmBCNaeJ79lYCGVHowLZMcgR+rJy2EbGOaf4upuvOTJnBHSn3zQZjsLpIMlUOBp8uQmg5r8eFihS05OF8k389oxS3Dx+um9Liix8IZvK1DOwb+VMaJtnqZCh/LKNT9AXGn8T6Vy/HLfxu0deUZV72NAARXe6f3LTviZMZaZyqcDalyZpZTk+1R+Kv2SKpDYkGfgTl0NgSVEM7Rj4er0g5e6GJHeg8qohVTOmKphU2xnqS3scfs8KWzEhIIsi4uujtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNDMzd3ozPBbhQxOijWZaIue71pL6z1s07tA7W3XdYc=;
 b=egAnVGSQantVEoz5gggdf7qsL1jJk2lLAH9wgQHhPIBqIP9Kig6uciCig0X8ykBmcGWlW+Xnqq3lXj9KdoRNO2KQGVAp6ylSaT3qB3RqNykWvNH4Dhg8A/rxUnW6y/RSq2jpuyz74P7MdeHZ21iCPK4X2LUPx9EOrxOzHgre99g=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V2 09/13] scsi: iscsi_tcp: Drop target_alloc use
Date:   Wed, 18 May 2022 19:35:14 -0500
Message-Id: <20220519003518.34187-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24a9fcdb-1f9d-4be5-ca80-08da392f79f4
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3020DFAA4A8DAB4BCD8096F3F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5O3242N5RphIIk5G9ipb6gdJxaelFmMPX8ST4Ib/S/YES//ARIccyUT8j5XLPy91GUsnk77TiKjv0tyDHAW62UdmhJpOtH7IuXcI8pjkk7B/uUM/ZuLQ/ktje3FFN253udnFfCsZFTSP2mUvs47p/dGfk96109KcqVC3QKZwMohD88P2qgq+glqFrGIw0fZGBfuIRD7q6W/rtP8w17Rpz9YvwQyw9ULc0I5ZkialxTid2YsbJVnyAolL1hNU6M+63HAspJPSsH9Z7Sd9CVSCG75NLYcBaEnQh0Lm9SGsiZkOTcJHRxGo7qMJmVVrsCXEa31JbBREcvdteL5az5yGH8vq8kEWzaJN/x7zgLLkfgKdsnsSfnHnXCTJtW5CUiNSktnykGMWP6FZz55KSrzIaFJ3HKVuBZmjIf6Qzpj6DYHuAA8hnmyhLaOoc2ehFFz3AMzBK61KMZzKEjN+LwDyjgLGBmKp8RVruQTtsBwjENq0S+n1r/uf1VWMqe6zxRuXdkzFM4jXLPW5XQ8/GvL+IHT14YF+CkArIfys/Vq2YoP0O5P3NgGMAngdaVO1TjY5wf98ip8qqsho0Of1N7R9KpiwqfVkoLQgBpx4ehCEwO7VK5KNhgakrDpIaw3OjpnZkntC93jkzYbkq8TwLwbrNmSDmTRT4zDjVbg4yNxZLfgfgjqUDHRD5nejd+hJUxDhL2B1LkW+KgMgfa2+D1Ikng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(54906003)(186003)(66556008)(1076003)(4744005)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EDi2bkxx79Vtg+yZ34zM3ZW4V6ON3zyUwUJW/VDRzaiP3PudoKkf9pqZfROy?=
 =?us-ascii?Q?BFApwl4ZFOz3iJCely2lOITd9dG/80IIXrPZxbW7B3WUP+3O/huI3gN8ZG9f?=
 =?us-ascii?Q?4PZ/Nh89WVXdUdERZbTln+nhv31zPe5EuSNUJpJ76oJeE0NlxLK0jZ+P2aty?=
 =?us-ascii?Q?Q6MSCznmJg4pmcP97Jm7aDYpX/eDvYx82z5si6lYjH3ChNGW3iuQgXZ4pNRq?=
 =?us-ascii?Q?22Ra1gtGfi8WRiSGW6WsnHiIBjGYOQBezNG5BZw9ED7E4iCcQjE3wzeEiPht?=
 =?us-ascii?Q?cQYp+sBo9T4MisYzdrLncKiVt+7ZCR4iJUSZT86lmcvS4lK6pRtQpcT8ZUCl?=
 =?us-ascii?Q?bnmLNPL56pLyx6B7jkdw/ccRe85dwP9XSR+V1/XQmnXb7dGs2fc+KfJZae08?=
 =?us-ascii?Q?mKFfPojyVNGIf2MjzxfTNCplMXFflkhOK0wUVo7zxiOO7qei+utqBurX0MoS?=
 =?us-ascii?Q?I1OLpZqEyavA8Bejd+Iz+8XTbfNVIEj0gj7hAHyTbMv1k3gAQRD9Di2OGnE5?=
 =?us-ascii?Q?G4aVP/vvtWyNxiOxJPYsZSCzxi1tiHm3zacyaIGQREjVl1XdOrC61CawZk7x?=
 =?us-ascii?Q?yDfcMJnf/Bg5uvx5w//CJdRdGhZNf4iK/uXfJWWrnGIZj3uyj8FoUIFhO3OL?=
 =?us-ascii?Q?asljMpmHtbLoMUWLs48u+23OagYQC61UZCDdDln0ml4k0C409PsxomKep2rq?=
 =?us-ascii?Q?cpoQu9BRH84oBROtDFFsMJ9w2FXhoclc5J3n0suqF4bf5jUTe19URcJ7o5pZ?=
 =?us-ascii?Q?hWxY9mDzDX2NWdk6ngHVyo9wKGJTwbsihjI1jEgoXZkCNQM3C9WjECOvokjx?=
 =?us-ascii?Q?DtddRdooq1gjVF+RNkbZMZEAYar97COdPTUMUkSVINz6I7t+mXK0SZXQKdDg?=
 =?us-ascii?Q?1i7yzwtf1+J1j4sBBLMwpLX/ewHsiUx6RBPeLB//DRm4b3iOtsYMSrAYYCSI?=
 =?us-ascii?Q?W07S8J1dSC6K0z/Pi3O10FmGYXf540x2BKc5b2A8/szusijbEcAGQWwlZaBK?=
 =?us-ascii?Q?NCXHmUgkZX/52yuk6JZA84doDWqV7jQh9nixzFuaYlvQuPHB1jLrRHjK6MRx?=
 =?us-ascii?Q?N7/HDmRNvWkkDOWQJpyLSn5dbHIrjFjqd04n8WT8XWpYxyhSAm5N+M1WgIZJ?=
 =?us-ascii?Q?y9YjNn0jLlMKqFvIJI5U0yO6eBkAZ7QL19/jbXoTVYViOm2e43fkqhNcjZzy?=
 =?us-ascii?Q?CzxUY9rASLbB2qzqnzIIrg7vvxfq3uGVaAe3jjJn+MegQlFRgoDt63joQ233?=
 =?us-ascii?Q?deQd6fyHgrfjmJYSmFYfcL9dt2jVOb9MuRPd6BXSYX1tMRpos1RGqKjL9T+J?=
 =?us-ascii?Q?vPl75s8t9eK6DvLV/8n7zYDEBxIzaxU6m35kZ5v6IL6sfyo/gduf3DKqNjqe?=
 =?us-ascii?Q?XcmRUkyrkr0O2hYoexXCGz6YJZzljiIz4RfHi3g4s9gmSa6yw8UMYLMNqDAf?=
 =?us-ascii?Q?hDz8kb0+4dnCiaNFgBbvFFE653cRwvES5pWw98WBqlsSOCvS4/+p/AfqgxnR?=
 =?us-ascii?Q?HOI6wh66qaucRwfumQyLG/PFDD26t8JFmIanipLKgSWApNzI+EdhCZwu4XnC?=
 =?us-ascii?Q?3+rim+t6XxzOSjj+6Tv7g5coa0+Qhwf3/STNB/GsH8EUIHwYYxIi3qYS2TRA?=
 =?us-ascii?Q?qv0lvVdRjlxGb0MEcrC7ofSBOx9FSBNDYCnsOwOtQ1jZzg9zSSMQW0rFG4Y7?=
 =?us-ascii?Q?GUWsXQkc/ssNuqx60E9EljOv6cUart7avhwkXT7l+68ISrD3YGAdse2R12+R?=
 =?us-ascii?Q?ANX+EwLHALvrxYR4k0HBI1iDUtyuDSk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a9fcdb-1f9d-4be5-ca80-08da392f79f4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:29.9615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9cOekIlcvY2flEpR8U8QrG2gKvFk2oYXv3OiuVeXXmTDuRhYW0Fr7Oy8to/HfeJT98hn0ef5q8ySQnss5y34AnLrOFRwlYbuHsfIQf7zX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: ZeQ09PensEfcdP9eV861g-qm-G8mX6Ry
X-Proofpoint-ORIG-GUID: ZeQ09PensEfcdP9eV861g-qm-G8mX6Ry
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For software iscsi, we do a session per host so there is no need to set
the target's can_queue since its the same as the host one. It just results
in extra atomic checks in the main IO path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 5e3b59ecf5b0..29b1bd755afe 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1042,7 +1042,6 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
-	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
-- 
2.25.1

