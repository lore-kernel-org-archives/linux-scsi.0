Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED727C6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiIVKKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiIVKJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:09:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F8CD5751
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:09:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA53k7023893;
        Thu, 22 Sep 2022 10:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=FL1oLUYEbL00qEv7jhKKC4V/gY67TgXeyer0vkxdVCQ=;
 b=xPc2XHqAdfw0+zOAwtpJq/t19iCHzjK6Ev1HatrOetImRxsBFftjtViz7gTWbVieCIND
 GGZM/VRk3O6TIlrxKn1/eAZnTMM4/XQ9UeJsHlwtqttXHJ7FgdUVjuz/8+a1tbP0fm+v
 ZuhHK22FCQED3KnIOUVG/TP6eauUra4EfmcGObkLSopusqUCRVzSOqGGTnhaoJEaTDT1
 OtsYGT6dALML7MnnhaNEE+DEK9aLuBQMQkfQ33ywyOEEM+P5E985bK6tK4D3k6c0s1lD
 w9jRjyLw9thRRT4mEK4fk5nIdUbke00yYtIY79z2pezUlVtRz7Hxpk2jX1ZYw5hEvDMv 5A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0mn7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8lhQi035368;
        Thu, 22 Sep 2022 10:07:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d4dyrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJRbggGAGpEmPEof+RL7kCQeaRG6gHlgEBk7f7XGEAqiKlYld0qzn5Pzz9PBia5VK+LKcNWlToQIVmnWcA20pcMrjGNgkf5PjP6VwRxjymn144vrFecJRdTX5372DbnzkF9BZumKr5rBx9KHgK7XdbUUKn8YCYn5mZTOjLjb8CGQpNFUCx+UQPTuNVB5zGjNchV43VGtn6iwloIrRFmk487wR16f3iH0z3wQ2OrGJia4XT0ZHt0SEyx8iwh3dle7++VS854VN1nNsDaJ15HahP2rLrbAZPt+sfnYrDsVBFt7FVh/SQkXN1fiomOyS2Fn5wTcKDRdLkuQ+qLezPinFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FL1oLUYEbL00qEv7jhKKC4V/gY67TgXeyer0vkxdVCQ=;
 b=jRm5QEzjo8KAOOPH2yUvKJTPr+jmPDDU3cCO7B45DXvTwIt1yQfZk2kcAJ1YPBRcoct9NsfN5T0Yfzoxw5/A2kQK7nftYCE1CbQyMz12k81rSa+hZSmcpgHrmqzWv17sAM1glQeGZLiMKLW2JUacRYBmKveZJ4R+5BqFUDGB+pKiRTSPX9tiivhzT3OtnhoeEcnXge2rF6iELp+HaSfLiEecJF7zxNjYoMmQnNDtwZ65+JfpXpgmMz5MnvHdrLX57si4LkfU5/hU65170RMKcIglDfYKr8VSoNDfAA13UtfLsISPi+M81pawbSQ4pmt9D9jA+SkHoCEKPQ1kzQllXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FL1oLUYEbL00qEv7jhKKC4V/gY67TgXeyer0vkxdVCQ=;
 b=qun/3QbA216s9chpClCANtos30JTqKFqnqrRcKq/6buhGvYH1oygcQ8zu8lackdb8E7bhRtbb342bGuh/IxUktlMjb/075x/yUxhQk/gKE+5zGHmU+yAlANWHx4qlZSwL/moPKP3ivIVjFDjnjwajKBOtfu+NZsyRiK5xB4WiJM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4317.namprd10.prod.outlook.com (2603:10b6:208:199::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 10:07:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 05/22] scsi: retry INQUIRY after timeout
Date:   Thu, 22 Sep 2022 05:06:47 -0500
Message-Id: <20220922100704.753666-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:610:4e::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4317:EE_
X-MS-Office365-Filtering-Correlation-Id: 61b7f9c8-66d1-4a88-c5e9-08da9c823986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ya2WEmWWjhCwENJIqAO8HxcKAZJI2GBVmuZHjyBWpvqEh4OEuZFg0U6pWLOEhr9dNYM5FFbSQ1kIg0HH2MSE3SObOvhy6rtW3sUqbexa4RLR3boPDSKVGkxtLuz+DtCzt5OLPte8lZB2I2ObsA5MELoR+lNisx9ffuR8QvD+WgnSb9iRSKsS5nvstgpgY5Aadu/892uHH4p0giQgHvRGvb2mnAGbwxLpTaYDawB7zIsZrWIz+SlfAQ6ygBvRzx8mYahVpZ+u3AzlTbbVZzyx4HVT/FWBEsQ/gEaPwRWm0mz70RhzHOXC1CdL4HUlWxXzdUYwnlRkcKhNqIUdfjz9t6H3IBGachmHu5ER8bY4BciLH2B9VUdglaecjEeg96S+Fim6hzl3w1PVvepq39kyzrLMwr1rkYwd/wW0PY3fxqPMCyRSqDb9S3wzE1vayCsDmi2zx6ZzoRbe6s9mdjdlq0Qv432DbKZvPYsb88sguYfVJdS3EPNA8VsiViJqBbNochXxzaDQPzqI+etVe6Z34HRhw/xAfCxtyuY90kG7ESH6jp1xqXFFsXvbxBiQDg4pW8K12ov1bs4356kuE5nlWhb7wuUXgD52dx0qm1T2Mxv4lvcpCsP8XezLGQa1SO6eaBAPVBBiif90TJgj33hVAd3ct2f+1+3qQ1Od7dACd3gRFFpGZr5ptikE9soyNftIL7s7ybqplvGUYTpyqxVywA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199015)(2906002)(86362001)(38100700002)(8676002)(6506007)(6666004)(107886003)(26005)(6512007)(4326008)(316002)(2616005)(6486002)(478600001)(4744005)(41300700001)(8936002)(5660300002)(66476007)(186003)(1076003)(66556008)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8mr6ZotBlo+Y9e3w/QxorxGy6SJddlYZ9Clz6vsXeVdR99mIhmxKyutaHm/w?=
 =?us-ascii?Q?Cw/tiKxX1QTBRE0iFt4djDeTuPWe0SMt6gweZsM6gDB5xQ83CUZc3a3nrBIa?=
 =?us-ascii?Q?OF2LH1VWQl89e/uJZceafeCYFDtYzarnMbOzbxIe/H2APoXorPe8+iVjizDT?=
 =?us-ascii?Q?DWSTUavCAaTxzRXd8OqN3epsMS+DwrOdJFZg6/YVJJ7T6HPiW50Lt7BiTdIN?=
 =?us-ascii?Q?WM2e2AgZpVU12oFnLlKr4Gu2BUAZe74t4ORSlQxvX9QxySWDkNbdkDE8VN4D?=
 =?us-ascii?Q?q8RPNLFgLtu8DvWW1iDzKBHdBD4RbCTbaD9xcr6W7MIldnKGlDyKZnPX5cZp?=
 =?us-ascii?Q?GiuoNcG0KEFd2XspWT0Ay2xZtVGRDCg+wePKtMcQ6pFGZC9QBnccZbjtbRIV?=
 =?us-ascii?Q?Yp6pQOm0q5SiPdgmOBaAp0Tq7yR8lZu1OgXQIruGCkynLX1faoSDsZCAUADj?=
 =?us-ascii?Q?p48fIqYLCafSEkANTF/8G59vKTfOn6HwXAcwEGIO+j3hXnHTPbqrXIFXdc+W?=
 =?us-ascii?Q?5o1sXpmfQTtPGe5AUPw7wh14FKmJns9UmIRhYTw5T4FEnhXZHVwblsu47Zq/?=
 =?us-ascii?Q?0XUTdwpxnJLY34G1nXpWqBJOcNk4iNe4f7Cd9RuLSTwkGf9jJe6K7zrtzVIB?=
 =?us-ascii?Q?JS/n+o6SwgIEYctieDDQZFdmzGZ/3zoZSkYjBjL4iAuAMJeAyNadQ8TdaxIy?=
 =?us-ascii?Q?Ai6tkP6sZ+dvgZMOuTvOAsPJAgWL1AIeML8WRy2oa2tb3ggAg7lUg6JVUcnL?=
 =?us-ascii?Q?mbw9syt722snPnFfxRqHBUtLOe9Ja21iWljxQkrqcjetvD6Vgpmm9mav1wPx?=
 =?us-ascii?Q?RDYvGCF/eITZPdVpixt1wdauDNCg/+8Hh/A6wmjYAPLUJkIWm1anu/6Zj3jg?=
 =?us-ascii?Q?bRSi2p+QQuj1eA0IIVRYrvlHQnsGE6+tuftFXQQ8HmD6MbvQwc8hjM9rbLnH?=
 =?us-ascii?Q?Xo+krdC2IlEuKQ+2n9249G7BmL0sU+dzL3xL68epDhVckyaymlZOclJW3Tef?=
 =?us-ascii?Q?F0NxxnzurehGKddXtqZLadHyPRCMocCjRFNektaLQVCRQzsEyCp7rwe8kPZ8?=
 =?us-ascii?Q?0uviNwfqURSvUWjjULgO19JhTg1R8C13Hw5GFpW1qTyq5CnfyrfnXWtTRkGk?=
 =?us-ascii?Q?d+by7vUv1K3rNbu53AZobcXdn2C+13Wd678HSjEDyzXD9Pnq50WypFRBdItu?=
 =?us-ascii?Q?Z4I0APSA+NXIy+9359N0OvcJBFvAH3S328pn2IZbl1Mb0pj1cS+PruV3STCL?=
 =?us-ascii?Q?n+C6Ji336WftV8Hv2galtY98Lpmfr71MP5mOc9pHek/CTb6WuWxgRl7AXRQS?=
 =?us-ascii?Q?VljabiFpooZFGCVsh73Uz2taWwkgDKh5pa/TQjJsq87CYl19uSyPKAKFW4BP?=
 =?us-ascii?Q?w8OUh6sRRICd09qORTflFhqu2ZjX1CLEVjkRCYNx9Ujgyfwgxy1WTEiv/fQk?=
 =?us-ascii?Q?52jLBbhcY04z+2tc5PvqSuyDuEwMZYfNNcKhcBVoSA4phQbM1JDfPxka7+s0?=
 =?us-ascii?Q?E7aY3AEr5ifinNVxbxEoRoRYsLSOoEzgQ3IvXqjOd1X4ymVsskjEw48IaPOX?=
 =?us-ascii?Q?2ElDNVMy94qltLvR/9hznWOq1yqiZb/0eZDe9/QHqPlTEfPfmfwPTu5z/mrw?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b7f9c8-66d1-4a88-c5e9-08da9c823986
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:15.2411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjg7jK3izTb3BzSaik0cp5DMDx9q49GdQU4NGuMem8+jX7RZ1TgvrrI+XKLPO7VVEKdDFwudeftT0Q64B/Dyx0MLNyGLjjL4/jDjXfL/JJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-GUID: uJYogKkYn6j_QPkg_zOMq9IEcXq2mBL7
X-Proofpoint-ORIG-GUID: uJYogKkYn6j_QPkg_zOMq9IEcXq2mBL7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY up to 3 times (in
practice, we never observed more than a single retry),

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 08eaa7ddfb97..744fb8b469db 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -669,6 +669,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 3,
+			.result = DID_TIME_OUT << 16,
+		},
 		{},
 	};
 
-- 
2.25.1

