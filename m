Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9336C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379196AbiFPWqf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378914AbiFPWqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4B562206
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIhsOo032716;
        Thu, 16 Jun 2022 22:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=B+G/OvNVzvhDw58d4fW1gXsXuKjx2evAw6uXQ6jCcKA=;
 b=T1+qtlx9SIhLbWilrDLoZJrSZRI+EI4jHomwjU2bDdnQevZ4nGBGp5CIX856DOFexp2p
 YPGd1OJmqJi97M6fvfCHlyobae8rcYvNQO7/pezkrnPMoNkbeGkjJtdLmFyJbEWIehki
 17iL0XSmRNwoicbp3lfEGHg+ngUS3IOvQ0uZAIWMtT5X82GKsci8v2+v1w1aDl710KKq
 dxVCb6q3xpVklgtn+XMfLCuwG3CARlaeh49yVNMn+XszUjHxGvAx4FOtKCcyAsYXlGdT
 tUtMj0ELfQZuiUakZM2Rn24fLcAtDCyahgvpiyj79uRO002vB2zX4sBLOw7mj1zTXVIQ cw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vmp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaOYf035621;
        Thu, 16 Jun 2022 22:46:10 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27dmq4-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSyk3grxPS87wF7UfbUoCJ0OvhjJL72FkfkHhH4Sni9rRtNMJeu2MVc9LyPpon4eeo6p0VJs7Igvaub0PO5Gvgd+2zgqYLnqpMKNvSMyuTFNb3MjLhxhMzDz41N2KDUkYbdeC8+HhrqyDg+USPXmN4EDpGxF2NSQgjU+2ut0KMphE4M/wjyCQclklU2ZEGSOQkwZD/wlMeaY3vpn8N8pi3LoDaZbXs4U51oaLi6/WMzl5dku3XHzCun7NY90uLbjJNzsf8MILnTrpaXrUPw0eikwMdQ3hqjlnRR/jpvNqkuhc4dBQ1o0ZKd1tbo/C9ddYVXB1Jmb5xuUQorXvnQj/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+G/OvNVzvhDw58d4fW1gXsXuKjx2evAw6uXQ6jCcKA=;
 b=fb0Kog1QAsPx5j58TonUMsqSUNN981ERCGICXg6jsutbFIvYLkfZX+NOTxBVn2NerTqt5umUUrgeWKVRK0GYbKhOJIwBxcloxDHJGk9BUZmJYTgmlTm8whyi0hce5po0aDoXLmkgq+Ohh01kCsIJ/dnzNgbI0u5p4YuUdysGywH27mi9iulq6fWqZLMf97hikmwtSop3T3SOJEY6UyMP78xQEhsfuM3tjdy4x848XrtnkI9WfY+QyQ9mjxG/dioHBSBOwDkeL6wbZVyG7/ka1T1ndU0z+y/cDD9DkjnPPTdGi/KrtEhtiwn5Zp2GTG9StHo5LhbXy62HxNwLrqZN7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+G/OvNVzvhDw58d4fW1gXsXuKjx2evAw6uXQ6jCcKA=;
 b=iyFux3UdIjLpa9bi0lfgeQgD2aUQUY0+9eUJ4Qt2/y2XXWQJYLuf1L53pRw2L9BIYCPLWc3YpMV6mp/lDqAgwwnFcu+aZrD00ZF9+TUgJkRt4fd2TkndcmBn4aTxw6Ci8BfVZx0GNG1k49TnEl2SQdjnVZCbh+7PuO29DyAaLq0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5617.namprd10.prod.outlook.com (2603:10b6:303:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 22:46:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH 5/9] scsi: iscsi_tcp: Drop target_alloc use
Date:   Thu, 16 Jun 2022 17:45:53 -0500
Message-Id: <20220616224557.115234-6-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2cd4ed40-7f1a-4d3b-fe52-08da4fea00e0
X-MS-TrafficTypeDiagnostic: CO6PR10MB5617:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB56176F23733AB8113F42EFDCF1AC9@CO6PR10MB5617.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U4tljvoMSP47yvlfhyqLCGpq3f/Tn2KDb6sEsB/mg6YOD5GLxG/YfrJ9J3tfKmxmP0ItdORkLhdqdwgCDSF0PnidJLLZmT2a2/kmXhfSCWwSbItzUG9Hjg8XfVdnsVtv8MZWavwaVjNPW9HEE/oLHZ9+wRAi8/RElFHOOzpefXRuRoLDhr4ejpTtKtASlkO+F97ZGxI+c05E4+ueDTEsa/YFhpfb5Re/MpBvKDHahtF56Od+Qvqb9Gic6fa9Y0Fwu2gDPqkPe6N4nCTvUeqeDwOLVaevHE2FkZAaoEc+WTlnLwVZ19uRQqBAi/vkN4V5ezsQ67BXdJW4pABqtYLNx5lUKbIr+Uo0Za4pqfpLcLPmTBOmtHTh+mg7OuJs0ulGyUnL6aNYyxwNE1kMzNZ1Rv+ecQHdyRLKZrwipTizPr8V/bCyz6E8BUJgUH+d0hx0jdcZgwnxd45KeKVtlosg8vjL1Taf/PV8i1DFqK2QFNMTJbDgdfPSLxOAwI1zOq5oV14MXTukj2nQ5Xj+o2T3mayNEDpEPSVKYsnI7U248pHhhMvb4mBKhs+nxGcOh/Wg7uxXFW+WiyYWW08ftCRuLf0hMeZCjgLeLCrnYg3P7tFIGpO9Hyjfcr0bMe+GV1uc7A6aqElawThcbLQIN0H06szoZtmcmq3lmxSxX1+8G6coAYByNgw6AIDeK07MN9yKAe2zc1KQ7RJ6Xy+pz0SKLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(2616005)(52116002)(6666004)(66476007)(5660300002)(38350700002)(38100700002)(36756003)(4326008)(4744005)(6506007)(8936002)(508600001)(6486002)(66556008)(8676002)(6512007)(26005)(186003)(54906003)(1076003)(66946007)(316002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B+zK3kC9yf2H3cX2I5hmjJz87acQA/QrdfbpOd9PivPA1FeGC7mvZK8ZG18b?=
 =?us-ascii?Q?Pew4qPwDQfFc0gAVmBqKk6RHapF2csa4wVx77k+cv/rMZ0TuiHdlsUvfjkrH?=
 =?us-ascii?Q?3FjM/rBljQfEI7ne31lZksLFcpfACy7R9NkKTj+NFqCsFRgsVAEMwoLj4HJ6?=
 =?us-ascii?Q?+Fa/vfvx1prBNDGRLgiG2Q3NviD9CX6wNIgcdJ63ktjfsXCsVajtiaZfaXMx?=
 =?us-ascii?Q?iTK4vpskX4TV+jTdzEeiyKbQkcDzSkbHWghU/iBKBH1Z8xVvwo8/SSRx4cgv?=
 =?us-ascii?Q?kvGPAcaBWWr2FdhvsjH2Co7CNEiqoPH8SW2jRe9lZehdoiqdqzlKvUHwL1dW?=
 =?us-ascii?Q?XmdW1KdWph1XwhiK+nDe9dCNRrQo0afiSdmXPgf2QxfNRzqQ+fgPJMWYKo1x?=
 =?us-ascii?Q?qChyYLRsc5Jy6sTAh0pcj9quDkGoyeRGUY3r4bTkMYb9f5bwY+9+Dsc916iL?=
 =?us-ascii?Q?BB+WZrROkTaaftwcX2KDqO61ADVay75gWqYPsDl4N4HJb1DKxuI4L+04bmqp?=
 =?us-ascii?Q?CTEjtweH0+JlE2E1kWUTinhWpRgnoJ9QrFhQO4UlhXGm4oLLdQsJgR4yOuZs?=
 =?us-ascii?Q?QrgULwa86HVuvzc1MSqVO6DZZiqWK2nrVRF+6otQD7jfYJvc0/T39wqFDya4?=
 =?us-ascii?Q?BjnlfWyTCgJXPZB7u/P8auSE/2ERIc9g8xrmw48aTNC8lAY2aMDkXW3B76Lr?=
 =?us-ascii?Q?jNKdHqR9Ew0ccdD3X2SC6WxAKcNnuBwLu/lAnjiqb8gbTZ8SVQeSv8NbWjBu?=
 =?us-ascii?Q?v/fvQedHWHm9rsO8CsPfRVg4BKMEJLltToUA9VI4qfFYxinodZV7Dn/Z2+Oo?=
 =?us-ascii?Q?hyqQqEu2eSPr7UY6B9UWgXwnD5bawquN5NUbbweN4BY8evfgJEHUe4DXkdev?=
 =?us-ascii?Q?9pz7cOjqXq7I8FnkqU4zDHmlTXNHpGAhoBbHrAyXBzi78uvVMX1ts6KFTKUw?=
 =?us-ascii?Q?blT4FO9cizkEvAgFzq0QLzBTnH3b648WP0/K6F6F/P4U7gsufdC0biCcM97p?=
 =?us-ascii?Q?NHbn/WfLYRsVVfLXITyKWtoUewgIhq3JBttSMn5cMPABODYpLbZwnLEntNZs?=
 =?us-ascii?Q?rEmOC3NPFNYBvPtnGn/i9P94Sr4U1vJBVTWCbKHNVBUgeww0aC0/QxOKs71o?=
 =?us-ascii?Q?/A5gncD3+rzIqSrwirlG7u6r9yBSGpAeQdOZWdETh9bDGJhvDcckwD303cnh?=
 =?us-ascii?Q?EO5FFv/H2f617t+erfxJAK99+x5QWoztRrIbe9UkAAcSe5oDPHU8NpaYLNkT?=
 =?us-ascii?Q?bJAbSt6SIzPyf+sd67f3oO9YXV0aMGpPgkgl8X8+QdGigJRL/UDYddHP8pOa?=
 =?us-ascii?Q?LUETIWQHfFSUD2yYxVrRvOirY/jQuLlY+nxJEtnKad5xyzUOva2F2s1xzKAj?=
 =?us-ascii?Q?b/3t5v3XNKl+JLXGsSOau3FWqDrGSsb8wLqq3l0aIdqfu1jbNovZIVm0FAVX?=
 =?us-ascii?Q?R4xXRVCGSBmU6iQx+Fr3joo9c758QjKgBrszsRGndM/es7NcE01Ob7nLK9A2?=
 =?us-ascii?Q?IjH1xDQSz0IjCfn0aB4WftxSe5AnDIqcCQJVmbx+47WQWqeIx86Y0gN+A0UR?=
 =?us-ascii?Q?x50JVrRVc2xKGY0Bgl3CdKbaj3KPJm1ivTUmFAGtKM3un7dR2j0XM0bQ74Gm?=
 =?us-ascii?Q?Z4i/X6E/gW95lkGiFsTnnxnYbol/S6TcFKf00ZsVJ18FT1lpVy+ZSPtfIVSG?=
 =?us-ascii?Q?7u4XuQYqfHdvL6uwJZpgDGx7Kvw9cwIKTRzkrSMoB5ZNEBkfxAl12+kt/92C?=
 =?us-ascii?Q?vf2H1Wje/a+GesE19H72J0urhf/oWOo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd4ed40-7f1a-4d3b-fe52-08da4fea00e0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:08.3908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sf4S2m68XiaYNkTziV/SXWBnecPThOiBcW0vSShSij60zpDA+hQeEXf1EbF16xAt+93czSAmh5nDmE/QpblvUsjYR9IQefFV85gxWHKWIr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5617
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160091
X-Proofpoint-GUID: D9Vou4EAsdu0O6Aqorenkdw4xrM1eDKD
X-Proofpoint-ORIG-GUID: D9Vou4EAsdu0O6Aqorenkdw4xrM1eDKD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For software iSCSI, we do a session per host so there is no need to set the
target's can_queue since it's the same as the host one. Setting it just
results in extra atomic checks in the main I/O path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index df38c6c10aa9..2cfd40cf2859 100644
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

