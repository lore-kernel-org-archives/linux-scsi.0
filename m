Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B54FC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319E3611CE
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhDKH43 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:56:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbhDKH41 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 03:56:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7mv2H043449;
        Sun, 11 Apr 2021 07:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=xPgGNTPZv8tVFH2XfDVKdMvUvcfXMspj1YtoOj7Lzrw=;
 b=eRWdlxxfcDbxyjc/HWlcyvYXDBYkEN+3sP+/5FsfzbyGmnzx2mVV9RiDYVqE4/+V2AB8
 AGxr1NdwwGE5jOoria56eqwfcKqcCyTx5wI4wjTK54OCVur/Wckb0F0RN9nXQDPo8uVc
 MZXf36beg2FWedGFLG5SiM0qf1MqXl3dF9uVhQJ998Ip0CE0E/OBoxl5wF/ttQH4nv0q
 FN1Pw0QurT8TrRSCbxPQbcW79KdPdsYI1uK3/snEhWy+ct+KntI0xN9gDlS9hm+0QJcV
 1BJLRSuQTmdggV6Y92AsURThQu4237SkGBq9xUaLugZvHxWZiOw1OgyMAZhyUgBlegG5 Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ym99sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7tXbN017877;
        Sun, 11 Apr 2021 07:55:57 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3020.oracle.com with ESMTP id 37unww7qm8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYczr5S+tcp3ErMKBGFbQnPAfHDCrw4y9xIciLO36C2QUWJqUqaMe+5QgeJTnywy0h1BxokCDKWVn9aHV+5+yIscmnhHwDLJ1F6V3bQHk3UcFygvc6zyzJpxRRDo4qZv/4qUjBh6DFaZUSq+0Y31yBV7zgsjmlga7S6r413o1gEnbwZF/em+MO2QQGv5IB1/H6qxG6rq8tnKjP3WM6J58ew4PjZuSuOzaFeMDbujxAwtM/5uaKVkPuo0+fZfRO1d+hPbCZQ9vB87J8TYZA4kqMZYo3Lk7+OV6Q8bvmvBDX5fDyxigrqR6R1rbcshCD+YJdPv0ITQuBaDs4N2KPRp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPgGNTPZv8tVFH2XfDVKdMvUvcfXMspj1YtoOj7Lzrw=;
 b=JW4G91qH9xUT8b0JVrzoWBSU/Dueyhh+E6GmLvrWDj8LZDPpGGopj3Hx8394pL0TYbbmp5z0W2T0DgVxhS28QSYuAPpGXnCIsIBBnLvHCgJAmFO3Dng+7dWIAncwiraYTbJJPdQ7B1pV/AEl0a2nPEI7VzeDt8z3AYqgVyaD2fj+TMp6yXN2jYpC0XAIKP4eWW5PIlZ9BZEfd8dYaLbMQ5e6x05Dq/uoqFSChYmqWu4FjvRHRY6L3jzoQXEnVtuDr6neX9Rmz/n6OgTF58JRKWDonx2uGQ9R9SB7k0/ohckeQ0ftrJoy5tbMctvT1af3JpwEwgKivvmuaN+qyg4v6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPgGNTPZv8tVFH2XfDVKdMvUvcfXMspj1YtoOj7Lzrw=;
 b=dzptAKqDV8oeeSmdhb890ZdRxQ97G7tG7JJLdpSo0uv9nT+VgWGGlqFJO3JHiX3tDEQqHEv/5t9JpF4RDBSvQZRXePYZGA5SIkGFSoeBLIannvIy7gbVst0SHnJqNV972qJNn2ic4jKbqwPrsbH0v6pvSOhhhNpzoBviUL/OYnQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3842.namprd10.prod.outlook.com (2603:10b6:a03:1f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 07:55:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 07:55:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC 2/7] scsi: iscsi: force immediate failure during shutdown
Date:   Sun, 11 Apr 2021 02:55:40 -0500
Message-Id: <20210411075545.27866-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411075545.27866-1-michael.christie@oracle.com>
References: <20210411075545.27866-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:5:15b::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sun, 11 Apr 2021 07:55:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3057c409-900f-492d-86c1-08d8fcbf3c6a
X-MS-TrafficTypeDiagnostic: BY5PR10MB3842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB384271AC0381164DA61863D0F1719@BY5PR10MB3842.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7b2C8bsY/yUlVm+pQir3gtxgsEfx+ab9mSJRvMU2wDcSpHBHo9RrTh527e3IYMFlEg0bGQTOzQr/eZA4fcNpfjIOUuubQT/qTFIglk8tKsKa9E0JCoynX9g/FEGrHxMq/uj0jAQp2yx1rDDIGYE9QXu0/u8dXaPlDhthrYqfeqXp/ULnxTeKZNNnGS2Ji0xZSKKy/Ct03KfMSrL2hLtJCBMZEmISE4nGG/T/gJBlNy47cGvBeAFavfH4iDO1z8FN6xVVJoRccusPGeX972AR74RpqyyHofgpe+fxk3L3tdnLDbR8dx+stcr9MhHphXMg22ki6MM5j+XlYt7AVNfSmrBPM60fTMou4ALezojVHjqy8N8KTKQ+OoU7WpCqG9bs+Soya4y0NUzQFyFLhLwMUsBsSXbomEK3pOEq2oZ5xhCEWJV15Gnzu8nBZQwVBan3bI0aJS3wRqBzrtM0t0QLaSeNutkZX9lQ7boDrIM1FlHr0xe06cTP28fomZENjedK/t+HvRRedcMEl6hNYVw1TMzRo6iN/NQ8eGzg/zZYISQ1OxLw90ySxIKWhqkoSTxdI65yb5ZwXl5BHjM/rNKg9GvzjM7SHb0krH80rAKcHzIUbMrK/6Pc/59qwEemH4d/1MsSwdzRr80CwlXBYexqBV7LAfPiambKdgMvXfDpwrMmc+wKe1WwRMq5jU4h8soe+RcvkZZsBlhASYdf9fusw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(16526019)(6486002)(316002)(66476007)(6506007)(956004)(2906002)(8676002)(2616005)(26005)(5660300002)(6666004)(86362001)(38350700002)(52116002)(38100700002)(69590400012)(186003)(66946007)(1076003)(83380400001)(36756003)(6512007)(107886003)(478600001)(4326008)(66556008)(14773001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VSuNB1Zqh5MVCMK2ESBQeq8UT8CsfypfE9ZDe6/IU/UniKies6Rn5haNU1Gy?=
 =?us-ascii?Q?0zl6rs9lZr0V67jO6Wr4NHo19Ax4RGg1Aj1EJRy0Gfe92OdDho27jGu27ZHQ?=
 =?us-ascii?Q?rzMNmxVAgqEwqMF7s9teCcLO4zI8+lh6mZraexlIO+dg/N6eTRn7NAE8uBdF?=
 =?us-ascii?Q?LF0d5w3XfclyPZn7cdSv+jgCpQrxaaYm4ZUC1uN8z47H8pt/Z3w1RR/gGtQv?=
 =?us-ascii?Q?1ZgnMAKH7kQudSYQVCL4i7udE93jE6XoOjv8gwrkZbWd9IFhoGeUizJzJkaB?=
 =?us-ascii?Q?QXf+h9gWjTfYBf3ZfLgCcHJWOjVSYB7WXh60RkgTDXK2kS9xpx3oLfUQ/02J?=
 =?us-ascii?Q?BlLl82kxDdoVgXN+IOjvVuVfUUVh43rJSNg/zlGAOEbfaHUSBkGvguJfADmc?=
 =?us-ascii?Q?bWhGAwXm9DCBWlp1sWRffwrOu8EMgSZ1gh7zP1bmaD36n+Q7wIu761GYlUTo?=
 =?us-ascii?Q?61uWbH7EsxxFCEtYVF382aaKTTzTnY3HceINZy4DUVPUvRBDRSITTSSUxwTZ?=
 =?us-ascii?Q?7V4uNguPRtuyXcRyEM4YPhk9sPOKceoZ9Czva5IWqaBJGmatu53Prs9iG0Og?=
 =?us-ascii?Q?uOHHYDj+xIFIfNrQwPeI/5NxsJCg/FU7CwgRlzNEd6xfDAmN/3aK+JDlxihu?=
 =?us-ascii?Q?2fPLNXB03UdvuKOVehuxsIQqjSF42RSoP+N0lu4QkUygKu+1waBbLHCIq8ML?=
 =?us-ascii?Q?zGp8jRHBUi/yAZOQgBA/zZ0Xm577LGhhHWag9317uDlWN2Ii5TYZY/YxGpXw?=
 =?us-ascii?Q?Zh5GFr2lKkKJ4zNCajq5CY/i7VjNbKuV7CFUoExN9tZccUnVaDX6ZImFuRbq?=
 =?us-ascii?Q?pJIpTsl/r4vfhmvkr1k4+Yaow7AtVlcB0Sq7WVSfiwOEZkhw+bnYDzoCy7vP?=
 =?us-ascii?Q?oNtkHDK882E1qe4NdsDfxdYI3iHDOOTYrMMVBln7HMaFu8bZdB7865yMd1U/?=
 =?us-ascii?Q?zUpFVk68vxG5T5XNZuThYxf/VwVSKlrvuCRQl6+HeGz3t+1YE/2adAcqWNfm?=
 =?us-ascii?Q?euaYT8GQAwWOU9KrO46WcD9CTeOhBhfzA/cVAtyXhc48A2VQME9oRf6MZ5re?=
 =?us-ascii?Q?44g8YZhVLtebu/usd6v9GoKt96xQgXvtW5a4c345stRQOv0vKdQ27ttcVhHi?=
 =?us-ascii?Q?EIegHtevN7tzso2cGNUdEYdNBYDBH52I/KVRhwjvbJ5t9ds8RrQADOsOKXur?=
 =?us-ascii?Q?FENpBsjKothEf72ET8WoBYXkhTa2BzutCPXTMQmasJlXX/TMuDtqCmRIWT3D?=
 =?us-ascii?Q?hPxlF8VFkBcEGRy8mF1myfHv/+SbQinan1ECiV9gjSnnQ0T5sAt9LlcE+Uor?=
 =?us-ascii?Q?23WJSjKi5CXT9XLvMDCaQprS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3057c409-900f-492d-86c1-08d8fcbf3c6a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 07:55:55.7381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0CQoqIhHZJfVNanUNaOO4yt7JxwPedHBsh/P1n21Tb4cwbqq6joaJ4KiHPcGxlaJRMh5CAocrq4ZS+vTIBATnODRzSHLM5ZYdxU5XtnmKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3842
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110060
X-Proofpoint-GUID: FbCHUwbnNVtBG09paBOy1zFEl0t51yuG
X-Proofpoint-ORIG-GUID: FbCHUwbnNVtBG09paBOy1zFEl0t51yuG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110059
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the system is not up, we can just fail immediately since iscsid is not
going to ever answer our netlink events. We are already setting the
recovery_tmo to 0, but by passing stop_conn STOP_CONN_TERM we never will
block the session and start the recovery timer, because for that flag
userspace will do the unbind and destroy events which would remove the
devices and wake up and kill the eh.

Since the conn is dead and the system is going dowm this just has us use
STOP_CONN_RECOVER with recovery_tmo=0 so we fail immediately.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 441f0152193f..168953cc0ff9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2513,11 +2513,11 @@ static void stop_conn_work_fn(struct work_struct *work)
 		session = iscsi_session_lookup(sid);
 		if (session) {
 			if (system_state != SYSTEM_RUNNING) {
+				/* Force recovery to fail immediately */
 				session->recovery_tmo = 0;
-				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
-			} else {
-				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
 			}
+
+			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
 		}
 
 		list_del_init(&conn->conn_list_err);
-- 
2.25.1

