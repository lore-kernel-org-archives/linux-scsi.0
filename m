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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28472C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DEA6613FA
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhEYSU1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44126 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbhEYSUV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtZb124464;
        Tue, 25 May 2021 18:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=58VixA2KhGBI4+wjiKN+w4Drvj+2oKWAZL6V0tidLns=;
 b=pPCY9fulOn+y0zRTzfonMS4V6xlMtcjtrZDd1v+I0wqVSVmweH9DvkmriweXxjddOVTR
 xCJ8Ob8Eeln847D/skmT72sPZWj0dga7Eg4NYZ+ql4zjMTicnaAJLsU5XivHzWuZ4CAY
 NUWy6oFe2F5LYKtK+73I6Bgr1/A14r0al1k9vJGW3+RC6OTLxCFVA2/xkbhRMGUXUaEk
 byKne6q5n3JhBXDvql9w/fNmYg6QjGFKxfAe1vLdjB3JTyxYc2C9PvDn4+kUr5RCzS8k
 f7FwRCD8EJQwIfcxU7Wh+uNooFNmDNC8OorZoujFnpeDYPhninIaKWF8dHkXeYhKnn5G tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfceyrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGD3L010875;
        Tue, 25 May 2021 18:18:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 38qbqsggxf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1sPVQcbF7Xe/6f8fMFjIZVrLoZUlMdV7D2yqSibS59NMIkwDqY36Vadh4QNbvf2VBMRW9CIiSYwkHB0D3XoYdHvj+1DVVa7wVWioq8ub2VwvXUb6OjohYdQiy2lSu6Lbq8x8R98KYskIyU/2qZSqX+04ZtIQv8yTUjEcmSH0bxVpRwK8ep6BGORsjVX8glrWe9A8YLXkYoumYYFlJ9oECM9EEcMJpM2jB9cr05ufhvq5WuyI8uM0a648EyCQc1emUfELAV3AFLpLpWruVDe+VLrpdgfz27R9akW0dEhS0hgMK3nRKN9rxBe5b7+wxw2FD8LqZbg5+arlAncnScrZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58VixA2KhGBI4+wjiKN+w4Drvj+2oKWAZL6V0tidLns=;
 b=WlkjW5AjKPcVr055HPpDIn5RL1HsJ/mpOmo9jae2m3m5r6aQhNf8A9sKbNWHTcRQPTE7Y30u1+fyYpTYUIz7ku72GkAs7eKIy7MJ3bvUvqkq/La1GjB81iUu7P73rDyBbwKhtYlxFiYyGwyuiueQf05b5hzpOkuc8p/HUk7/sJQEFXty5JEO+VjDgTyVUIx3grW01m9I2wk4o7qd7VGTAy6ihnKPdNAGA6OPcqkXfzqOiKV8cZ3Y05oL+93WCR7u6mrJWXmukqpCJ/0JAboLTlXyLIA46CnZ2HYyOchh8AYD5D3MqY26mIDgDK1/4/A7hz2/j1gCqN7kcfLF32uIhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58VixA2KhGBI4+wjiKN+w4Drvj+2oKWAZL6V0tidLns=;
 b=bufW7tCTCK6pUHupAGJUHftS/DIn7ubARIlgBtBL9Ve/Ak3P29wdPlMLHIRn2Zbrp4fnqZ6LJF0rRSWlpA53Dt0EFNRuq2r7KJRLaFMkPgf4prqGRJhvbuxfOdeZavxIoxWiPjIcFLtGeAzYRQJ2mro2NACBfR27wCgwdmuLceM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:38 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 09/28] scsi: iscsi_tcp: Start socket shutdown during conn stop
Date:   Tue, 25 May 2021 13:18:02 -0500
Message-Id: <20210525181821.7617-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b07b9eb-d0b8-4303-449f-08d91fa984a2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47678DBEA8C22CF91C0A9FFCF1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8/b+wdGj80A3Tdrez5enVDkfNH5R36bZo1IBGGnZRcyvolzqCSAqyLza1+0upcXVKh8T+cuYkH0GRvIpbPAwwpeCoEV3Iuo9hzt8QyNrxtn2VrHcq1kDZt7fSfVPLB5cWXH8NZeAHi7YxfxDNlsqq8XTdl83iYlfelHUQtc2bnNyVcAbjwuQA+gEGn7EW1eJZMpGOTokTbbLK7RcKS9mdt7jYecClk9OeDv+e+iyvjcZwoRun+Oo0K4MSATgPI+5YFZNfeQh5/jwmwCXZnkWcsunl+MIqr7Rf8Z7KxgB56WOmUFEl8QqXFuvS50fJq4ZricHk8is0l4vwcq2aq3mmUTOFhy8ws00e2Q/Bzt298BNzHaz9pSf8vJITheEwegil9HhCdtPlrg2+xVHisOttQL4Be+fT39tZEfwXFQsztavjR1qZsXFnoc8DDmqdIbE8llJPlzlt+XnH/eruUI8bA98HYM700TDZo3Xd+Tu0IQl2CRr/mzS/9GsmOKcC6fUoh3xdRUJmRr/Og0AMdn+GWOpxQiMT+jmHraUii88+HNTNUicmT8ke/yK6hk8eYl7s2BuoD6pqYXJSbAmjFUN7SX+2AmSfSCauHhRt0tT6L39tviZG5PvBNfp7ScYyqLTYwgCGJDyASmbuRO4/xic36/LxoSXudfVDWnfEK7Hz36dm3GpQwS3TyrveubHs4J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(4744005)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(38350700002)(86362001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sVUExpha+czi3CO2xy8cF8xgr0LnCpZMe0QbC+galfox7+fJReT7EA6A9RfA?=
 =?us-ascii?Q?3l/JAw4nC+1+lYTelwRrFhdjvBguuTudNdSN5ntbgwdrNsOy3K85RUO3bG7n?=
 =?us-ascii?Q?cZyM+HgzYzK1zlV17hWssUQ9iX8Lw+pCqr6BOJjYaoftnMehu/7zGNvfx1tO?=
 =?us-ascii?Q?jcQdnb9tCH6JxjYW0oVtC0pB2xKkswsmQKn63cLbqHGEbQvY+iwQ+ygvqdDy?=
 =?us-ascii?Q?tWIaY454/DQ98OoKnN4oW+BW0VF1vkTjHkTk869dnkFUE8SY5FeqxIo7KZ6E?=
 =?us-ascii?Q?F3mbEBc+LjuFMClfeBPfJft2HrCj64IANWqD1c9eNHa7d3hBPCNMUlcv3Sm7?=
 =?us-ascii?Q?fcukTXGCQpj1Dwgx5aT/EugZI1s8ldV9cZb5mogsVQM0Ljz2bF+037Pcuk3e?=
 =?us-ascii?Q?+fsi9oghZDClok6pxFaOvkh+3YiUKlb5cv9Mu6Xk3zpiFPVJkpEk2T09VMzz?=
 =?us-ascii?Q?/mVKTpZMjYDGQnA8dxM6XLdA2eHIUkzmqCx4XN4O5bRmCjpRyF3gX4Q0SPEz?=
 =?us-ascii?Q?/lozQK31gENY93ewQXOAh8scqJWzKG4+hWT3hVN3NLoTpIK9XYmPNzaTc8h5?=
 =?us-ascii?Q?jrQS7JUWTg3gNKYKq9Ua3m1czCz/28eTerqAfeWOsQHx4Hc4mxT8zFWZhA48?=
 =?us-ascii?Q?I0miM+vXzjDVBkZCvyN+tWI3O1eJIcfc6MYPbYUO9b/clrSnENgE1Oy7fKQo?=
 =?us-ascii?Q?dq66U7PF6qnhrVp8EKdTWsdzgWlfD9DtpXh//hr9VXZ1Pg3WZ/DV1ZD74QJn?=
 =?us-ascii?Q?41x4vh9mHmudCscyC7lx7Qb6ueBJYsX7holVLpDiUTNPiOm9EiNuIWQGLImk?=
 =?us-ascii?Q?VKnX8TdtfFTPy1+hgRkje1uZ7z74hVI9IWMvzZESDxRh48wxgGk+OQXX4Jk1?=
 =?us-ascii?Q?WbD9j6Sh/+v5LFp2jbpY1QR1Vd5uKhAVLFTZeyss3Dz2mTZ6RR27fX7WiiM+?=
 =?us-ascii?Q?zNFjBfe9akxS8U2e3+vuX+K0y4E2gxjY2X97BK+vKMtO5XvnMRpbUWl+UPnb?=
 =?us-ascii?Q?E7yhvPOz9VEN9p2EZFb2CzTt1JpK7/401eQH8dCeGrnxb9w7VvB5W7w/BTQj?=
 =?us-ascii?Q?143PXqqPqyHUNdwLop+jHhf1S3gmhW/JFWyPSzldX1zLRVrg41wBKoQjKcuD?=
 =?us-ascii?Q?98/WxbfFDa0TbahUXfEb+0ym3vSzp6nyNWg70C9hoBV9o/8gDaUMfvnzwcpp?=
 =?us-ascii?Q?cztqMnqX2f8PR7naSISmtADoJ0e1TVjXq8DG5mBBgSvtLf9b0z3fs10EfPen?=
 =?us-ascii?Q?tiv7RyjsQEpnk4+MHDUc6jP6INYvpXslJbFG73tvbxQ8NUU1sz7XAr/QrVwd?=
 =?us-ascii?Q?9LjbNHYQgCPnlV7GJSW4c3cd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b07b9eb-d0b8-4303-449f-08d91fa984a2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:38.7305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEwMWRj93edqaeqgzHFZkrLdO7AB+Qo/1jnxoLgKUhQaaHnSJWdgrMN/DeIePByo+9WLIfAOzFNPYMzDfqHk32fvMJW1zC2cKrxjvKT34ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: UveNqGTXMnliYktr-Jwnm4g2SvM5ZohF
X-Proofpoint-GUID: UveNqGTXMnliYktr-Jwnm4g2SvM5ZohF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure the conn socket shutdown starts before we start the timer to fail
commands to upper layers.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 553e95ad6197..1bc37593c88f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -600,6 +600,12 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	if (!sock)
 		return;
 
+	/*
+	 * Make sure we start socket shutdown now in case userspace is up
+	 * but delayed in releasing the socket.
+	 */
+	kernel_sock_shutdown(sock, SHUT_RDWR);
+
 	sock_hold(sock->sk);
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
-- 
2.25.1

