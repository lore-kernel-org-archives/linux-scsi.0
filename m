Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4994FC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8AC611BF
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhDXWHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48352 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhDXWHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM4fus050796;
        Sat, 24 Apr 2021 22:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=mDNbYJgqw5DdfH6QIt5Xjxj2oRs7MJaiYV+Yc58AlWA=;
 b=oW4aqgIFtycSQp81Zl9MfAb8EpOsUZIyhZiERFuZ4AWb/sFF+rRJNV1qvDLhQfOv/sCG
 wEvmL7a452zICJwGYX0LhfMVlpXTFR+lXRA3wGk9VwGWaI+XqwPCCG5R7c13CRbr18dB
 GMTMDveCHNyS0WnT3T6eV1VIGBM60/UMUmZ9S1z7lIxBx7NiWmknzCPb5EZNF8XKkMnL
 GhcGWHo52cfSlYqR7M0Hwc9d3WaKwWmiCq+5hFXbrEZbFPQGLy4AT4LDYe9kWmIQ0+S7
 Pm4IxqlpSNylFMBmHTvQ+L6zEuHgx6aNnZlrudFopaSPGBsJEdXIhqURWmkdcqgBPsFD jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3848ubrve0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM66YU182267;
        Sat, 24 Apr 2021 22:06:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 3849cakfth-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzijEIRcDqTXbF1p1OCHdeXKvBKg1cJ4fWlf71LqdBSLTphrl3Df5HeD2DU/wDmGFq0kkbJFnASWD6uTPDNeQN/OcAsbHGcBMJwdlFTevI/d0memezGoEobumEEX7OnwSb2P+VUIMWFeLIYBu/of8Sl1KPNsrAptbxGRMSgyrKGfbzzo+U/BdTSC1rCzqI9bFI6rq6ua+PCUNjybQ1af0ijgrZLGD0FU/oZPfODog13+04cEt2cFB6j8ZfuluZiT9Xde510llG9Rb0FoNpluU7NE3pFo9KpMpV6laEn2CsRs6+RWPEsMRt1V9fDxSZECPzMRyqKMA+EK0W0bFj0UyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDNbYJgqw5DdfH6QIt5Xjxj2oRs7MJaiYV+Yc58AlWA=;
 b=cNAnEE/rMEJ7jgEhS7332M5300QISxVaMFcCNHV3CJmNBR53TEXl6kT/geOlwqn8risSmyqEBCzsJd3rvnqlW8xjntN6BGcCek+wSuh9Q7qLo7qdXtBZKBFKRZwtKHY3LIoU2CeNJlfAOjuV5P2X9vktRtigb2qDyKnRFeunH8p17m2PdZ7K9x7IWu6v/wlKLozvGJC33KXIsSXNkJE393RmUcH0+TLQrQo/kAfIxHbm4rjtQR2yq/+DsKlsN0VZ172dNBoce/5PeQkeKWbwGBhX43jxrP9hUjhtjNJooCBoPbVZEQHKBMXne7SEmohxdHtf02uz8g8JYBQ2a7qDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDNbYJgqw5DdfH6QIt5Xjxj2oRs7MJaiYV+Yc58AlWA=;
 b=dSHebFn8c92TosBCjvlSowkhSIsngocInGLUd3lsIUD1UzimcCJBIbWqtYF4nJ0SZ5exwRt3o3UlQr3GXVX+KipGhUJdlMvfHtYaH5/+A3Waqc6/iYNKbCbKQ7OsJrJiFwSj3pWoeNzA2zt18QHjFz5w1Hh8QDpMIo7Msktw8Rg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:20 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 07/17] scsi: iscsi: move pool freeing
Date:   Sat, 24 Apr 2021 17:05:53 -0500
Message-Id: <20210424220603.123703-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fc8639f-2134-4a4b-ba64-08d9076d30d4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33173D2BAED5B518EF7B3AA0F1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xowG9iRFHS7scRnDeiGIej21DA18gI8Bv1q8v98GbURultsxsmz9CXC0E1iMTXB99db9aQpvDlqW80+YeF8j7YUcxp3z1sJBF/SYvs34YUtKBXUZNftqbuFz+FGE1jrbbI0C6w/YrRVoEWbNUJhIJRoOUgenR3nGUangl0ZFVEASg2W6B6INNKcVccvnMJjodGprJk+hWNgh6LOYmpxSe7CXVhlCZp5GypOVW/yd0YbRbrw7H8Jvv3CwBM2n76dyJuPwj3RqEBu7xc5x5evvneIS4TNVYwyuE8FBCCYUidabAU/ypZ0jxWxmSz6A1NHGSw/KHIrl2Cfmvh9fqcx/QG3o1Mi5jzliJs6Y4w6yfbsFjao7N5bENScbvzIZI9z5Coogy2NXZC9j0T3QVDLtI+uyqE5iTWuhTYrAfd8aK4H6fMgIQwxVUFxbvcePPiDEXllO7YPtNt327VyH+lAggSIsCLiZ3D2B5uOeI/QHvla0gosLbQ1dZh03WB3TNNPIpNxOACEQWIHstCc+5uAPAI6Gq+7PLWh64a62TfgZMHg5vAa0/uIHrbY0wtLUactLr/aFIgwn+/oDv+MF7Xt9ILNmF66XHhhjML3BmCcB57H8oYOlwm1s3qVD99lL57AhzbCW1YnlEYUr+1lyuuDwmEtC309JtEwCcRbEmJwGQdNO8dVrM2CnT8rINNwQTNfq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(4744005)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jECkz2IPm4IfHRoruQ0Sv6g7tohtmm9littO8wf2fCTJ9J69IAeR20e3grRJ?=
 =?us-ascii?Q?H1fPLERDnm/iOwR0gJAX9x5LanDmM5yRiqDpiUNRfANO0ktYM6rySiqi9g4e?=
 =?us-ascii?Q?15SL96sd6K82Q5JsJXouIstU8xWcaOkp/YjNfQ0WlLUOaYDly/WrsqN05cKY?=
 =?us-ascii?Q?lR38GG6YccPY4L4ggXk6wTt374fuppPlaIvmgoC5JajllG3Z1PNwa380GHII?=
 =?us-ascii?Q?FF/jGvpsGryqJL3G7YTOYaMCo0HD3clCQy6meaR8VNrulBtntVGsPkU1UD06?=
 =?us-ascii?Q?8HbMdKK1HKSHoZ1KOkOrdph2rw7Yyfa+YkJN5NUUe9qLFwH92QhK2wH9T+m0?=
 =?us-ascii?Q?b1ceEfx+gnLPFBcWyydwtqkqxb/E8HJPJS21Vy1Rs3cIOF02rs2Vk5rsRRn/?=
 =?us-ascii?Q?g5SS2u4EpCdR5tbHJ7Jdy0eam+0YtFU+a7T7pZJEOfQhCbnzA4O6gh1j6D7w?=
 =?us-ascii?Q?hcy/+Pw+4lv5KxBIxs7152bjMuMYKCEjnE9PVgGwqMZbyQEJkHgdIIe8LIR+?=
 =?us-ascii?Q?GuU7tj3UuxNeu6D+oKQFYGYGHPq4Pj35lZbG6x/Rvcz19RJrLapxKIRxzFzs?=
 =?us-ascii?Q?dlgAG65fh355i7xnKWZWwB7krrQccLwBdaMBYIHbBSTNGBG4ZBSJkwz2gub/?=
 =?us-ascii?Q?4W4hbdYX0eQz0MLGzFRKbJvFBiE/qTz37i2vDG7DVxQczujKHn8uRzMxJEVe?=
 =?us-ascii?Q?RDEJ63fnXAqVVffq7zlP37Q7LCOersCNTqlCaUpKuDVhPj/vRn0qW4IsE8ra?=
 =?us-ascii?Q?5jQg0OZDYocas5qR7glzijVvkSHXOyb/N63MGkWdswd2yPatY63ELPNb1MjH?=
 =?us-ascii?Q?8VB9UMX7cR+cbmgJB6z8va9YF2wlcaSf4YlMt4J1JGUmTq2i8LsfyAXTD1zd?=
 =?us-ascii?Q?UMUGA8jqcL1gZD4dXxc4jgq5dd9wqRUBne8/LZHeXjS5ipZFsxVSeqTxJURb?=
 =?us-ascii?Q?Ya9RBEr3V+xhkJFTqsG/tHtiomW45KMJ1LAllNstCxMzLxnHGN/9+idtnW5b?=
 =?us-ascii?Q?1mCnDmsjjczfqvO07DpL7xQpLxeAK+VNekazNveDpGLVKy/scdpi3kbN+IfW?=
 =?us-ascii?Q?FLCIpI4N1ubHt5GHqOS1sSdLtPIQrN7y3fZ9qDjuRisCW2ftce2Qb/EJuFs4?=
 =?us-ascii?Q?r3qJ0sEqUWZWQFIJKZYiPa4YXPUPGu7TqwfVmtAdL5n185hjqJbR4KcIuk+T?=
 =?us-ascii?Q?BZfY3lFmqut2850vIWMcogbDJU6QheC0DbVdkEndMbkr2R3lgkiIhDtA8o6W?=
 =?us-ascii?Q?7Zbru14re2A42eikVxqmDiCAMV7mI7znHbbOEpT3X4Glz6tnMApX9hjCXz0H?=
 =?us-ascii?Q?mdts7bPSX6nJWFW2UT1yWoE2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc8639f-2134-4a4b-ba64-08d9076d30d4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:20.4081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOaRjLtOkbDl/VJ9q+DwpiSP8Q0D+gG50NmqxEl66D7wyG8E8roEOJmH+w1NwuI+V++BJw04r3QzDibp6dNiS+zyykNVZGqm9rA6ChczonI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-GUID: Sn-yqWVNWAH7zahbkVSAtYCgsjwrNpuN
X-Proofpoint-ORIG-GUID: Sn-yqWVNWAH7zahbkVSAtYCgsjwrNpuN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This doesn't fix any bugs, but it makes more sense to free the pool after
we have removed the session. At that time we know nothing is touching any
of the session fields, because all devices have been removed and scans are
stopped.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 32363e758df2..216afafe5f73 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3029,10 +3029,9 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
-	iscsi_pool_free(&session->cmdpool);
-
 	iscsi_remove_session(cls_session);
 
+	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
 	kfree(session->password_in);
 	kfree(session->username);
-- 
2.25.1

