Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C02C47087
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8737960FE4
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhEYSH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:07:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42856 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbhEYSHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:07:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI58p1038630;
        Tue, 25 May 2021 18:06:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=xe34tHZ+UCvb6dLGEIVeD6yY1wvQS4hdwAXiIbxKTuc=;
 b=vMtPIugEnTu/Ar5tJB9rPUvqiRWnmBqr1jRVDTHEFwqyKUxYUiwKJ3fL6qWAfZyiREW/
 r1Z6xsg7sXYevyfaEXrrnFXENzXOxDayyuJaRXM9obUQ/tmy03DWSLjr0bHzHRx8ppvM
 1ldAFFoY/MhpboHArWU1kiddvghfdEwc96EltA4ihgLv/IdhXZ9dqeWuaukKQ0O15nxs
 apBzqcgRuuycXdPd5X74dyuNeLrtK/AeJsRZcoZwasNrPnRdG8w3SOQePPxyF3tFQubU
 PhRrm/XbjLvQlI4plAxzioMSl95+xHSUGwsPyQ8TZFkHHs/UACKlvS7K2ukrDsW9TWCI pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38rne42fxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6D77185054;
        Tue, 25 May 2021 18:06:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 38qbqsga75-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7v+S1mDGRN1e1ljtypOESRMewCrw5Gz0QeztVR2/HT+u62bNcLaWlFC+gcGKu5WVk+8MfUf6zxgNew4dwTeNve9MPfgut1wGPA+UttpxrGSjL+6w+0eV8PDsjgGwdmKjpsLN31EwXrVpob7Hwf0w9VWB66U8tE7hwC5tvChBBOwTZLBJDTRPsjochIJ1tHKOX5jmdUCBE+oVoJAVSKBT1TqbqQUpjKrbJKtF/XhQtE5oKv/xxQlnSwFfRzoJDB4mWFSK/eXbjQe6hvPV7SphA5yDZOgMBT7eEtv6pPNhbnCpcquIs2Zxp9kGAHXlZpGqZPGx18P9I6xxAdW8eUwEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xe34tHZ+UCvb6dLGEIVeD6yY1wvQS4hdwAXiIbxKTuc=;
 b=AT8rGppJIUBgJu27S+Ww5MY29qygyTXWVB3C76kPG6D9pkp4ESWjwa2acoDNqWSFe3IBpeiio9S6caD17ZmC9i/Jno2Dw2woxT1wBTcSB/r0sdW13F71tnatvr8rd0GovVSVT1QCmn8cCtWC8pdcrOS5FT1BYzQtveXwijZ49gGz+PyHU6wmmhM1JP3+s9W1NQ91TGK5Lt3wHa/9VpnT1zL7ozRP+Xw3W4VpuAaIW7v8eWegfORYvDzZ5tDCYuwXDtZEwOCPPk5410nRN4Fs3U/VNDJfpb3v+VA4Sybta+0xzLKpiB52AgNgjvQxzHvDctq/KhZg8NFa8TzEvoSzYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xe34tHZ+UCvb6dLGEIVeD6yY1wvQS4hdwAXiIbxKTuc=;
 b=WtdwQaTPwRHQBs1/cNSCLlzREC+fR/HTyRa95xzcqhxTHsGAhUpQn5ew6zYJTY/wXuXo3gcUf/v9bvfWgqOvBOsAQNaLaoN43w4PI+CMlAtuvxz1jaguioWeWjJKV2ZtX0BA4h25WiRnET0VFrR3/YDjzv9+HJiky0aU7LAUDIg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:06:12 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/9] vhost: move vhost worker creation to kick setup
Date:   Tue, 25 May 2021 13:05:53 -0500
Message-Id: <20210525180600.6349-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525180600.6349-1-michael.christie@oracle.com>
References: <20210525180600.6349-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:5:bc::34) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75e128ff-53b5-4f1c-c58f-08d91fa7c7f3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431A8F18D29D6357DC31078F1259@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7zXF9m/D1buLmjVY+bYXkTqRerSjFlVp0uhxZ6/LdMjyPZ1Z4+4JHbRlxv1fHp0Hv4UrmYfBvhgPbTQLhyvzKmj7mN031Mo9bcTBG/zANyQg0P0auZuUzaouHIPrsKh3OsYMU9PFRpAswwq1M94YUmdzZe6oFfNMmIpjdhPBWhOsifbOJqGdlT1UH16ryWKZaFsJQL/QSRkRVEqBoeLnbPVZTY1RFmlDP1Z2bS0YFil9LkUlIvlgMBgCtsIckxMyotyz/T4Twr90DlqVfszUF9GBfOk6zAgxF1CQfteuLNHT0qj7KeJGJ/FYHyzUcifo2zJxOKXsP3LT0qTCOE7pwgSIt5YVVET4NC+l2v7kZy9fvbCHBz4oXv4CL9vz4NmsPd1qLJ0A+w3HKmMEKPJmU3y1al2FyyA16nTCWlWrxyxuWfTcjhpxZgyDsI3GqL77skKq9KLspQqInv0GQr4gQr44ify7bDo3bBd4mN6FFrDIh8pQpi981DUpZMDGh3kP4gS4vdu5ILTIQqASJyd2LXH1C7Tzb1BVXs0xqprlPNvL4ropttGKXrKM9huZyGbNg/G/lgb2+spEJ8O4w7JGik1UTzHKyrUPinrGm2K31CN4NqnJDJ1yw0L+g2xILXdpnRXUC3xT7yuMI6/kfe9Pgp2zzo+WlaFwwLF+qCPkkIeGlzPMPMjcLpS6ZPfZ4YQu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(136003)(366004)(6512007)(26005)(38350700002)(186003)(66556008)(66476007)(52116002)(2616005)(8936002)(86362001)(6506007)(38100700002)(83380400001)(956004)(66946007)(8676002)(4326008)(5660300002)(2906002)(1076003)(6486002)(316002)(16526019)(6666004)(107886003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?E7MyYDJiF801PVqunbcWh9qc+GVFk9OtRdxdoBQoNUlFXK/kHyz54tvU2wc7?=
 =?us-ascii?Q?JQeQcPYUui+VOIY6whWLCOqj1qk1chGlIRxydWIFdQLdTfyIGjHsSmm8D8e+?=
 =?us-ascii?Q?4MhRAKefEPSv5F6Iy7ZWvGIIgtfvyeh0ydCD8gbjMYvQrwg2o0qY6iLkDu4Z?=
 =?us-ascii?Q?v8vllod5v+N50H1Ta+kepvGKpvR/P5xuOfDJws726blJ4QNFVG39MfCjkKNh?=
 =?us-ascii?Q?bK3kZFnbwaLwxmdJDD7LiTvxui1XlWfG4+NXWVTaJjELecKHxHo8/BtnG4AP?=
 =?us-ascii?Q?80yerySkriUjcJcQCNGHn3YYobmLiXDA71gH8A+eRSdRiedORkBjJyXtEiPm?=
 =?us-ascii?Q?8mGuiumfH+wQ3fRCo+g4Wec6FRi5yfQA4DNb800i8QGADyfaluSucxqVvj58?=
 =?us-ascii?Q?izUHFgqjwD5LO3T/HlZB4CYLZUSej4zy9vEyiVjdYty1oAnYCZBdrHKJMB5R?=
 =?us-ascii?Q?ssZ7cqdDqPWYTcPsNpvyVeYZPwJc7GAMQtfn5DX/z4KML61GtQ2addvMpK+p?=
 =?us-ascii?Q?zEMUwdLYNQijP3vqngDRMcC0udPEwrSF/NEP3nWvIvLiGg1DqkLxmW4/jad6?=
 =?us-ascii?Q?Z9+6x4EfDUYU4KYZIxPLOJI5DqqgB5OPKBTwBlGXGfRKjZiEjkuAPfJf9Zgo?=
 =?us-ascii?Q?99iTpvdTV8lBx0wcqlHPV1upXzBnQs3yrJbaUA5Ny2qa+CniV9mvEAjjd/F7?=
 =?us-ascii?Q?RbkI+IcGMezpGqSaeWeWbbkFXg91/SDPbOyXlUCuYMix8UEBvbcbIKRxNtg5?=
 =?us-ascii?Q?9jojKwI+sBPrpQEmAgD68Wx+k5xhpTRUFEczDddd1xeiJOM8W8US/TJHDuMv?=
 =?us-ascii?Q?o0PgRi5qdprZSWAg/Udbu93zJ9rc2JxA1Wm1fnctJn9Z1h0lmmjINM5mV0/d?=
 =?us-ascii?Q?dgPLlfERGmz1wcOWdz61IDaHZC1upAHFl9i1r0oRdw2vyWl5RrHxJQGuEnUR?=
 =?us-ascii?Q?ok3b0zjiOHUbXNM1ydVxsz9ZV+EJ0tKYBTNGJnWcUhy1lWtwkQgeyryijf8C?=
 =?us-ascii?Q?un3MUZ63BneqfTQ/r9k2fd7xvl40VvQpYXMOisBZB/bElK5Qi47G6SCeDjC/?=
 =?us-ascii?Q?dXBaDELRw5uqnulI2o+l3W/kIn0qQ6p+fCdTIECFv6XgFmSMN8w+6gi180mS?=
 =?us-ascii?Q?/TWxesajy/onLIBEa3QGV+kvrcqyQAxytpiB1jNreBJACaSfs5uVmQAJDdQt?=
 =?us-ascii?Q?lmEKWBiJ8iB9X+wd50r/lo7E5Z5B5NGufS/OSWJgNHpWXmvCVlZsHdbLnyWR?=
 =?us-ascii?Q?gJxzPrrd3CA02MJ4L56/GdkJPPIPI0jM+9I44QMCnHE7pNic0rGkx31qGx0+?=
 =?us-ascii?Q?KjxB13S5xnGcBTJFEDqkArjX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e128ff-53b5-4f1c-c58f-08d91fa7c7f3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:12.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iXbemQs8em70c1ySblAnuyy9dfpUj2u/S8mRZFDnLwwHgnLy1j44reaENGjj0Y6zUKn+/nA34onZwcIxn5LgEu6RUFNe2CRjj/uW0xTn/34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
X-Proofpoint-ORIG-GUID: emUMnK7tBc9MxTtuERfw7jv_9CKi_uRZ
X-Proofpoint-GUID: emUMnK7tBc9MxTtuERfw7jv_9CKi_uRZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch will add new ioctls that allows userspace to create workers
and bind them to devs and vqs after VHOST_SET_OWNER. To support older
tools, newer tools that want to go wild with worker threads, and newer
tools that want the old/default behavior this patch moves the default
worker setup to the kick setup.

After the first vq's kick/poll setup is done we could start to get works
queued, so this is the point when we must have a worker setup. If we are
using older tools or the newer tools just want the default single vhost
thread per dev behavior then it will automatically be done here. If the
tools are using the newer ioctls that have already created the workers
then we also detect that here and do nothing.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 0cd19b1a832e..a291cde95c43 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -629,6 +629,15 @@ static int vhost_worker_create(struct vhost_dev *dev)
 	return ret;
 }
 
+/* Caller must have device mutex */
+static int vhost_worker_try_create_def(struct vhost_dev *dev)
+{
+	if (!dev->use_worker || dev->worker)
+		return 0;
+
+	return vhost_worker_create(dev);
+}
+
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
@@ -643,11 +652,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 	vhost_attach_mm(dev);
 
 	dev->kcov_handle = kcov_common_handle();
-	if (dev->use_worker) {
-		err = vhost_worker_create(dev);
-		if (err)
-			goto err_worker;
-	}
 
 	err = vhost_dev_alloc_iovecs(dev);
 	if (err)
@@ -655,8 +659,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	return 0;
 err_iovecs:
-	vhost_worker_free(dev);
-err_worker:
 	vhost_detach_mm(dev);
 	dev->kcov_handle = 0;
 err_mm:
@@ -1665,6 +1667,13 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EFAULT;
 			break;
 		}
+
+		if (f.fd != VHOST_FILE_UNBIND) {
+			r = vhost_worker_try_create_def(d);
+			if (r)
+				break;
+		}
+
 		eventfp = f.fd == VHOST_FILE_UNBIND ? NULL : eventfd_fget(f.fd);
 		if (IS_ERR(eventfp)) {
 			r = PTR_ERR(eventfp);
-- 
2.25.1

