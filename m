Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4066AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201EC61246
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348748AbhDMXHe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:34 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47184 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348739AbhDMXHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMkwpk169430;
        Tue, 13 Apr 2021 23:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=I1Oe2AWVorcjAuB+4EZUsQ+4mDqnLURyB8JF+FnjzEU=;
 b=Wp/6M2Ks8Iuy/ZJFzeScrjFYp48yYqZQDhDo87U1Y3+iL9LNoQEeltKIAVzNG2kvaCld
 Jbxx4bD4wfzPRdWPSzRSg+lSUtcNxscRrgdudNRhjUSudTAoSglDrZSFE96C6MCT539d
 qtnx9meb1hC6g2Hz4CUK4Ek2vxb0PkDpr+lqXnPDog9Quk4hnkqZUmLyCPwB5QxWDVGS
 ZXzrfgvVJMJJ4qcQqJHplkxyJAhn1VJMdSVg8UrveFD7fyQgqnNY5PyCsgIKky27rbSl
 S48skT02S+pww3uGmgzQ/vtHCWO2yewObDOAUVIdE02QYSfS3RIumil+Mx8PSupoAMq2 uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbgsw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjTR0105371;
        Tue, 13 Apr 2021 23:07:02 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 37unst1tvs-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXwRM+KrlDDWocths70h7p/Gb7MEzonX8zXCRgk0+MN3Y9hvOFuP2j5Ak5q+hCHhoMa1XHhgrwZCtAX5cxE01UdBGfHoan7OEjURhdLlFnlHdAMmlaWXJkQBs1BQJOT84xMPYuH+nbuCif+yo+3vR7kmoooH4F9ySHXxeCdeGw+DmVLcHqCPTwKGYUzcVp0BHeOE6DIppDgVpJdxcILHjqnBHB185QmEvYHCXVkPaT7KOljspWjnrqNpy2pfaMGUGbXVCtab1aHyQt+TpEXdoa4HCDvIdf/L7ItgDQJme+AOBuVsvNNkuPTbOuQhzkuIu1ducC9HbKooy5yLMjjfgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1Oe2AWVorcjAuB+4EZUsQ+4mDqnLURyB8JF+FnjzEU=;
 b=R7XtWn/n4VSH69fBmsZP7MWkOp07XLP7WNkP8MyxYmEf5N4YGXRxC93o7SGDvcQlaVp/YvRsnPb9ZgRzmJ9VcfstBNjc5Dg4k8/uyJ2V7mMfM3IfWeY6cwdDwTLewMNp9eTgYgVJr32+ehfc43s4fFnBcYkkE0zlkLXcCj5GGT9iZZ3TgLab6VQNG9s0v0ZUOJI6ZYKefAqS+kFTsTmu8QOuiLisHBtdWWNYzuPiqJu2rsK0o/UfXYytCZxrKxNIpWRJPlG3c0ziAxTRV3b9jz4VRzbHpTqdrzODrf1Qrj1bsPxYUwvXuWZ4zMgXX9JsM9A3Qw4/VJE81LNIoX4qyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1Oe2AWVorcjAuB+4EZUsQ+4mDqnLURyB8JF+FnjzEU=;
 b=NJ5dedty3UBOHvjZfyO8DmWnc+28Xs0k5FC5Gfw+aWfgcsfJYTwDJ4uB79GWl0yXXZtWaADvBwS5Hw3he7ZScMSZaTJ/X5TRjeFO0ngxpr7aQ6ePkTVzz3QSZsrf8OFMJJZOuGmQx/W0+DpUG0fSq1G4gzwTmsOZqoTaufbAtcQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:07:01 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/13] scsi: qedi: fix null ref during abort handling
Date:   Tue, 13 Apr 2021 18:06:39 -0500
Message-Id: <20210413230648.5593-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413230648.5593-1-michael.christie@oracle.com>
References: <20210413230648.5593-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dca14cf-c982-4ee2-780f-08d8fed0d86b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2469CE0C45301ABC961A3FCBF14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UXuCBQiABPQUwvKGG1D7r+OLK/IIxQy1APcSqVwebWvu+X0Szxeqq8jKoKlb7eTPgnUn6V8Kpjb4kraxKuF0UaCm1MIp9PhxJuxkKwzSS7Wz+7bZkHE8qKXhrjC+SnDFfQdq9Qz2blQmQZRAtmU/RSx4PmBywCDykwaxfiHulnRJIt4Unp0AP96LpeiKjZqJaYqpL/ra4dm5JMB6eQVaqeT3uHnhUs2FRB1bSicwCDHy3vAqE5Ku0QThtHwpQS96wT4SX7lrQLkjCPJJgIGvJtIYhPicpSCGnGotwPiyD2zzAiVETl2YrD2pxC596zq1Mf0s1TEH0PI4OCUuMStRPHI2BicR8AiX/jUlxfkJK7gqyT5kyW519WvcuNaQUJ4xl1rsu6Zi6gKrpcYE0W323uHqQwf5glcl8o+Vd03nrnk+pgOHB4bQtspUJvt06UXc0qH96HKNjKr/zhh5DTOMam2byVXlNmLm3c9jgC+b/jNL2edHEAl5d2ndGLXsip3LikXkk+7D70bZ4PyEXY9YGUa/i+3tmIcDIjlQoTJWza/tLTylOP3XL/OmP1hDBy5fODqLBbNKrbGK2pK50YAlNm0pqs+UgsIOL0KAxqeL/O5joTyO47303trzN2c17rdQmYvLtFyu2nlVc/hLoElEETs3ELWuQsOtOQb7Jce99qBwUX8fhkjddUXYZl8yOvZZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(4744005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tsMj07jVR0BUBKDCsRgcGA95wcFqQvzADR5jpm11LiLRCpxeeyAUeVu8fM5U?=
 =?us-ascii?Q?JI6+HogtfR0TCWsXojKmICQSOav2+Q7gUp7uyBaCUQbHZ2pd8FZ7pN1xX8cm?=
 =?us-ascii?Q?H3xv/dVqxRLJS6HmoWqr2QyQp1zEIxBbR1s1tyReKoqTkRPRJhN6K86MqrRu?=
 =?us-ascii?Q?dFRQQB2M0AHgLmqxZfuINWrEgkdlEchvX4Q2a9HtKQ1UIHFGs69vDLaFU5Kl?=
 =?us-ascii?Q?KEtbCoxeq1+ZesL/3nqLjxL0pvCp+mdj8KkMZy2lQz6ipzV02Bh/FV/Gy+0f?=
 =?us-ascii?Q?yESXVVk052V8eP3hHoHMGG34fv+fNoazCOxnkYY1J/P+RYCiB2FTb/bC2WgJ?=
 =?us-ascii?Q?N0qVDKZfC/i2DTT5Gup4OgulAjF07w6pOSEllSp0p48NsdwCnwB98RZ7zR3W?=
 =?us-ascii?Q?OY+lH5xHHl4odYqpP0Wi0Er4j+NpoPxme6fAVLfGLY9OAWXB8aVjaDdcwhXM?=
 =?us-ascii?Q?F98K1Dp1xEVMq64F7Zuy8n7o04jufiT3mUSvewJXHDVCp0QzjX4X3aijW3gT?=
 =?us-ascii?Q?0Xb7oGb9PDALE1DAyfWFicIrMV3TZ5MzbWuFyAPtgCXD94BWROUbrKWUHLTg?=
 =?us-ascii?Q?rjp60FL6m8siqujHCICUjrufFUNlckweu9HDJ42HA4t0GvJe0jBbSaKczXWn?=
 =?us-ascii?Q?nuW5AFTyHD0hEgURd2e8pkRNpcajt1XyutqCGARuBhjz9yloF+BZ1Z8WmtdW?=
 =?us-ascii?Q?1DiSq7yweX76FW4s0Bp4dNBZcaHA34lMhXSip4XH3RnwAx313RGKLvlcYqS6?=
 =?us-ascii?Q?So6uWlLXapFNNWtfSQmOliFyOGLB8taiap69jCxJhxMVhdw6lbvZmsfNaajg?=
 =?us-ascii?Q?dq/kUpob1XHlzHKYVn/DB8I5wm38EfE1RVsuB0BXp4YjpY3bed8Yk26AXoW3?=
 =?us-ascii?Q?DVc8vbo1DW5Ds/BQqNeY56OUlcz6NDayxbOG1xKyv6ddYC8JhlihndWSdqaH?=
 =?us-ascii?Q?hZ61zm7ewrGDNETY2NDojFFBNPeySf5K2L7OSuuHIT3zqAQ7gyHGNwgTo2kl?=
 =?us-ascii?Q?c4usq6LGB7m5frEM5ilj8E9MdHjR0Rb2ncaMi+9hvsT/jYh1yzzoGTXjJHLs?=
 =?us-ascii?Q?UK0Vrcbz5HpOy3z5jNFPUnUk4HXRHj5COfMeQbgI/vWp5GBtR+8O1L5ZNkSE?=
 =?us-ascii?Q?J8Qt8GXWjUu5kaSZbtxeaWrYh2stOsImb5FD7/p8XqdBToGiOmIxZxroHKCh?=
 =?us-ascii?Q?XKf8ycrTr/oQsfeVVbR9IEk6bnJZ9BphMcBAKH7Dmy9ZZBNRb2nLqv2duwxY?=
 =?us-ascii?Q?LeZSFwNVJXMTLW4c8PM2cjcGzuUy8aPKyF528MHkfeLc3coPYHwNOhwWBPHs?=
 =?us-ascii?Q?TPwRFAGPRAKxUgf+wA8PkUVg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dca14cf-c982-4ee2-780f-08d8fed0d86b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:01.2798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PpTM6QeGWwB/OIwVdsaqLMUl30rV1Cj9kZH9rB54/XgZ+ry49zxveZq7O7qI6zmy7zsvtyefLHX2jjqFfG5rg0AEkwSApWiN59+asCYW0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-GUID: eqnbOCLGIP5BY3Ia0noi4ggRm_0VmLsT
X-Proofpoint-ORIG-GUID: eqnbOCLGIP5BY3Ia0noi4ggRm_0VmLsT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..cf57b4e49700 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1453,7 +1453,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
-- 
2.25.1

