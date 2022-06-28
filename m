Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8F9CCA485
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244823AbiF1Cd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245051AbiF1CbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:31:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDF42529F;
        Mon, 27 Jun 2022 19:30:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S1ZGRm002135;
        Tue, 28 Jun 2022 02:30:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=e7MzWLeMaXDhwCZ+jUEH9rI9JUNlGqVG1qneyQOzjT4=;
 b=B+hbr46lTbTPzvYg4IWKIdTEFRmTUnDb4X8+yacriwu+4hSJdnNXkEk814N5OlwIFbfV
 9LUV32VhTNydTgC1RaIKStB05a7Tfml0AMW5+I16HKolHmTwXsCXfRTtz5h3A2qw4D7T
 KG+C+ZApf9rutkkzBnrF7Ps09+LLCb1o1omzpO9NS3bxocGq3vp1D6e2o0Oq9IB7Aw+r
 HDOyy83fu6B9hg3xJh5ZvTJq1tFtpRhI02drgQw3/0XjB+r6c0lcvsZXJukWBJOPY4JC
 ma84I7YHkyf+KFcVs5wWxfm2Ou998W73kF4yf4EixOKtVsmhl2L/TpGe4DqdzKBhlNqa ew== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gws52cspk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S2KJsF018705;
        Tue, 28 Jun 2022 02:30:04 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt1t5vh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOjcDZ/OZTS5cyWotDYTotcwV7Th1QOCPhA6URfFWlI4B5/D3Ep/LgeUy5QXB4wQVLf9vz3ArHzMAmW8d+vrIMRQj/X6cnS0HcGYoSxSua736G8g78wF3LTrKsqJEln0rzp8/RAH1lU4yV25cwbYf75rlNdnwD5mJ96qpLN8hdu7pwo76uzY21z4wNCymWsXEtWcoOvJqSbiDJFW35A/xvc4bKnjPbRfkpzDDEiZWl3NYr86H25t+IIikR/kj9Deh56oVUxSqdcssNwDMgunjHNKMK5pNPszSXtdtk9Kt+HjqTsmEhTQk+5A6gFkcHuBnmidgr0g20eZG4HMPtBmnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7MzWLeMaXDhwCZ+jUEH9rI9JUNlGqVG1qneyQOzjT4=;
 b=TwHyrQ8qAVAioy5zP5PkMmgbrFDHlaShdkstljZh7CnvYlWwH9fzhRv6cyH3l570kniHB9Mi/krsj9/FWbsSgvnFIsG/4RrYvTRlVTwlOq6CSWaqwLjx2HEoUI8m7YjHGp9bhE7u6lRmeePVORnU06RIw53lheJ+cwL8YuwjtPt7Cgy5SrPCFpP2rYjNElN5V1/K34+Y3kyp3+Ij1GmsiYIu4J6NMhAP8Bjgy9mUJQeFUHz6lws7/H+nqua6gBgMwUBohg92jOrSll+EMmcjoiovz8ywIb2AYWc1jCWDCblm0JK13Q/164s5oxozKHnYww3HhLuJiUofHnNlq2/b0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7MzWLeMaXDhwCZ+jUEH9rI9JUNlGqVG1qneyQOzjT4=;
 b=QQMqdsgJQl2L5T32Uguk1fGgYsC04I0Pdr4uzCFon1CIf2o7fvDx0IaW/Oztu8E+NoRiOKo/QB0Yfm7Z1bpBlrfieImMfF7Wp9zK9ODZ3THVq7PbqFkorRrS29Z7+rfSyoZn2fb4/m+VxBlmmZ47VwbHhohU3KFQmQ4oGX1CT18=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 02:30:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:30:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/5] scsi: target: Detect unmap support post configuration
Date:   Mon, 27 Jun 2022 21:29:53 -0500
Message-Id: <20220628022953.20948-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628022953.20948-1-michael.christie@oracle.com>
References: <20220628022953.20948-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 315cdd03-5760-4882-a798-08da58ae1b23
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aH8h61QjoIqHPgioLi02JtTiOA+3AFn67Fnwp2m3yqGlKabmtqe3l6kA9I6aPljuEhKLrqa+ncl67thzpn54xp83wItYj5eOLZhKGDWgyfzpPu6tc/mqrqjLncv2JXSF9BHo+rAKTzMjVrktfe1WFUg2BSvrCDOWkeZWCHY0/u9HG6WmtprR8i9KLkHWWMKjUbY3A391hpVrdpM41/vutJ3FpNbNOQn9Jp6aadsz/lwFA9aX7zTq/OzaFyLVzgRFJph8qTrkRoKs1jyEPUcGYtgC6iwQMh59hZZA8lxI75vrwIF0HlC/8/bhbfRypRfvZw1EK1Hl+F0K3Q26x8jctgrrme9QduHSdd1Buw0A/T1BEmdKgsJ8SjE7WeYd/WgumQJnvocqDKytPekkiWVnY/iVPJdBnXwptuvSVEoiFvrG9oodtzDK4quCwT2BL9gCYV8Oy3gpsWCl6fNlSRNGnMqdcZsfP8Y1tVncJY49K86Q6QaL1w4FCl6Yi0R7WUtU+Bedau5PsyMp82qVerJE2WstRNvq67D8QYg7CxC4+sZPkwIvQ4SxpNLNmaVkpmujs2PXR0JUhdi6jjdURTr+2dI/gxTjPUCOcjwDJMg2OyKIiEgc1ywEz/dJQftbf1h4UfRhKQnn+z8R/nVvgllBX7RWism/eikcKZT55wswIg/Xx8ngNi5WG+bKRq6fd6fgw1c2BaOj7hvSKA0JDWvuN1xYV7KS4omNpMcdv4dGjgIhUX7ouSJkj74iu0pbvs/105cP5RWA905rfarDxEzWcDwxfMfEdt+cRRbCEXSrT2A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(396003)(376002)(346002)(478600001)(26005)(83380400001)(2906002)(52116002)(107886003)(6512007)(6486002)(2616005)(4326008)(8676002)(5660300002)(186003)(66946007)(6666004)(66556008)(8936002)(1076003)(38100700002)(36756003)(41300700001)(6506007)(38350700002)(86362001)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ujVaw3VSmMu2wdW7FEJaJ/gbbHX7h+H1rKIDh0NYovKVG/ORtXvECkcFeNzP?=
 =?us-ascii?Q?0fuIeMJth8Omwh5ACltatbQy34zQOagNL8Jsdyj82iKT4nJWhKVCpOKSPdYh?=
 =?us-ascii?Q?DBYR8C5bCw1nUEzHOQkJhieUT7CcJepVfSyIZCQTNggFw/f3QFt6AXA7SqAn?=
 =?us-ascii?Q?j5IoL+/HTZMTDYE5ofg5CUDLbvHedeZR3yQtEn4dIE9SvxInU5SU9m8piT2w?=
 =?us-ascii?Q?sAHbVHzlS8ZIeZC1WWbMX7dvQesMamFQnAxORKmirO9qcHbG6feYnzPF3hg/?=
 =?us-ascii?Q?EVxLiToH+yTDeax7MMN+HPq8OOfP66se6J4c8rNZmWPAc5AfM5zQPSrMM/jJ?=
 =?us-ascii?Q?PsoBOeM3Ne5YR5M/pkbpIbym6DzOy9RE+WL8CmT1GPDjyRdwdP524R1uh9HL?=
 =?us-ascii?Q?Yz6hgN33kgO7iCVA5tP7Grl2xYf8ZWKlx9CB85CGOU+Y9S9IRocsfRsWFFm0?=
 =?us-ascii?Q?sUqbpt81rJPAUZiMJHOqdAFrllOHg7Cr3wj+CtvIvvQ0QOM6Pz1BgT0NmkOl?=
 =?us-ascii?Q?PrItSL1eQCTxGZ8lXNARvxdsaSGqN45v5L4VNH0S5nyW4EqR3iqMcncbsZU/?=
 =?us-ascii?Q?D4cueGw5UR0n4rWmgoG0eZCfKcBeGd0H0Ug9J4TmzpDowXvnN0gbXrqNkoNJ?=
 =?us-ascii?Q?Jd/zu3bCUIEQBqp5U0b8uYgcqpQxrynVmDo6SvJijubdV79k0cM43SgQzSad?=
 =?us-ascii?Q?L9nTycOP/tlbfLaR92GNs7MFguvycGd5IHBAn8A8/DI6H6kAjBV3u3cX7AuZ?=
 =?us-ascii?Q?CtJEpHZ/X1KfxW0ioOHrqrYyGSCdDVrpmLkJrXQlnM5r1s4CD9vCCGyD6Vxx?=
 =?us-ascii?Q?SxyjGx18jAy5SUt8LNcwVH/HvL8gHOx0HoEOVB+xP4yeKOwF9OUcRn7xzAW+?=
 =?us-ascii?Q?1nrKgX7nm5U3P6w77gwHsCAS99peT++tI8Mmy+ITXfiFqduRv80wgj2Stj6+?=
 =?us-ascii?Q?O7KBHGz1Ag93LA8RKDf4tqegsccn0U8YOKwSDoKqClbCP66zSoxWySe4FpSx?=
 =?us-ascii?Q?YvdwAqHibNbGxQPwA5jhdKJINbrkXfqNR1Msfr82ZX95TKcLUmNEZ9DhBWzf?=
 =?us-ascii?Q?vkbQCOC84THkmcdvqRXbEgCFImUg/0fd/ulBQQDogjLsid+C4wP/X6VVmdp/?=
 =?us-ascii?Q?6dB7vsAuZQBFDjjr7WLPfLGYjTgBhw6GyjU4jo8rB35TaLTrcWuwWcDGzePw?=
 =?us-ascii?Q?gJZCAfivgxExiM8k4VevQ+6Imkz1og3QR3gP5oyeiTrbhcBYcL52mE6MWHjy?=
 =?us-ascii?Q?OGwjYVevGJw7jpVTcCeHkVOFSYG+jz87c++i9+SQCYkiKUipxWCtfa/cii3c?=
 =?us-ascii?Q?vq3RSdWDRHKWq5oYkPppucSJ5DYCPTK2LWb/qO3jEeJkzHHz1QKVhJVD2wQx?=
 =?us-ascii?Q?V+jhi/DWs1V12uW0DChOZxWuBxJDAvZBGRYXxWFi+zlFz6cD9E+DpIYiV4EO?=
 =?us-ascii?Q?FIMzhsdbkpniAd8pUijDilDHytlThpwULPZyA/V77pEj2+mhwkbeXPf7LL/R?=
 =?us-ascii?Q?Ax68p3fXscxBgXzofpdUXoHBxdLdkVmdTv/+cSE3YQfPxKQL5Lzo4bm5tRru?=
 =?us-ascii?Q?tZr8bjgbfHHrzbUEvB9v/dlUxVRaFbQRzHHleH5uY8ChwkhoejdU/e5yOwgC?=
 =?us-ascii?Q?Vw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315cdd03-5760-4882-a798-08da58ae1b23
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:30:03.1096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dcKLPqQqpib38RkpzFDxiBH6JsjSiqQARE7FIf2kgdemNKlWMQQh2F4n6iKn2jU3VAifuNZ62+qgpSuHCom/FI+s6Ts8HuNLglp3Brwv8K8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280009
X-Proofpoint-ORIG-GUID: BZdXaUHlU3KBQ-TOhsOffT0cDFxWh9Qg
X-Proofpoint-GUID: BZdXaUHlU3KBQ-TOhsOffT0cDFxWh9Qg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On our backend we can do something similar to LIO where we can enable and
disable unmap support on the fly. In the scsi/block layer we can detect
this by just doing a rescan. However, LIO cannot detect this change
because we only check during the initial configuration. This patch
allows unmap detection to also happen when the user tries to turn it on.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_configfs.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index bbcbbfa72b07..f28d3c6dab98 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -732,6 +732,7 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -744,8 +745,11 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("Generic Block Discard not supported\n");
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("Generic Block Discard not supported\n");
+			return -ENOSYS;
+		}
 	}
 
 	da->emulate_tpu = flag;
@@ -758,6 +762,7 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -770,8 +775,11 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("Generic Block Discard not supported\n");
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("Generic Block Discard not supported\n");
+			return -ENOSYS;
+		}
 	}
 
 	da->emulate_tpws = flag;
@@ -964,6 +972,7 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -982,10 +991,12 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 	 * Discard supported is detected iblock_configure_device().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("dev[%p]: Thin Provisioning LBPRZ will not be set"
-		       " because max_unmap_block_desc_count is zero\n",
-		       da->da_dev);
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("dev[%p]: Thin Provisioning LBPRZ will not be set because max_unmap_block_desc_count is zero\n",
+			      da->da_dev);
+			return -ENOSYS;
+		}
 	}
 	da->unmap_zeroes_data = flag;
 	pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
-- 
2.25.1

