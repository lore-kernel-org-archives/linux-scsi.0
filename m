Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F13C11F66
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 00:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF4A961454
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 00:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhGAA2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:28:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50514 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236734AbhGAA2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Jun 2021 20:28:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1610QAeP009996;
        Thu, 1 Jul 2021 00:26:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9hchUuGnzhJsRkvJ34L38APeiaE3Y0FyzJQpahfveGk=;
 b=Ky9w+ATgZKq7o+qyt9ot0qRMRr2eY8EkzrFgYZuN0o2otIDASOvwoSDfJAbPbcK+jSjd
 8FzKhZo9S8y49GzB8c680l8hTUFEgUNqrVkp8gLMx9UL3IoRc8gkoLJWxFKzJSCbwXyT
 65G9La8l7GOyeuJoB7MsXQg9ckUv/j8aJaJcK0uvpJd4DPiok39x1bIVPQiO1CXuLtmm
 +vjv3q9HGHBloAFMDM9nIrqelj5LfYimRWd1fOd2jn3Xgmmaw5tJLhMxtWOeZ3hQqu/v
 53TFmXymOvN5G+35PYBDHquGfBjH/DWf+L9i6uWcf+B7P5Uw7KPUokgO0xYPlgJWrKft QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39gha4a796-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jul 2021 00:26:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1610Q5Yw136560;
        Thu, 1 Jul 2021 00:26:08 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by userp3020.oracle.com with ESMTP id 39ee0yexk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jul 2021 00:26:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN4QcVRwkWh3tm0WXvL0ItG3QyxYBl0wMku7X/GAU2J0JUzAQ5x2lyeuYau2X69iSNBhU59Fit0EA+SSK+ohp7pwhvIgvF2sDw+zumL2tY60WHnQNtF7X/ZcD+I86kK9bJQiOFssvXs+gZmdy8+hWNyEYSMtsHS9O6QARZIImKQGjgc3u+ZnFxOYv27vABFjNZk7oeU9TcKT2UEzB+vXLlLXv+/1GpW/HNgYk+sB1VUf9NC9MKLxsyFEYirShbO3rtUVkgtir82vOKqddIHfaRWB0S0WVNmIoMECguB7Kxbdqp4RzDK92eEYMHAb76xNHOwhyw3w+KFL1hI/8CiB4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hchUuGnzhJsRkvJ34L38APeiaE3Y0FyzJQpahfveGk=;
 b=F0dJNqkrHx1rBjlNuXMAgEUeaCGYXbp/ZRSTJVvFW2qEv3X6Cg+ZOev8cFi7HBVS0JESuofvxN0IXtfaGW0wptx0KOpDz8jeTcYL8/kjscKxwHJKUbAyulwz9cGZhMO5IIgVPE7B5UgirRRrmKnnU6qYyS/cNyx/hMkRaSYu4bQJHwNWaMWWhl9bs1cPFSfLr+dncRlObKu75nlrBCnm9epeZ36VfMFuHKvqhwtB4T3J+0xKwMVU7r/IqSAJMKN/sckJ2/8eBD0V6oNPSqd/qacxCIiC/h1tPx2Bb8x5azIonQh2doFKzdZphX6uS46U5TUPgDqBwm9Of4kTFWqMuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hchUuGnzhJsRkvJ34L38APeiaE3Y0FyzJQpahfveGk=;
 b=n1Bx25x0NkUj4+NUy5/7as9ymxs2DthL678rkgBHQykTDYTa1d1tIxjsthGgYmn1X3YUYy2yRay5Y3oXpy5dOdKBxMqRnP6WVOpttsMpku8qluMQXRMgf68vk+NFQxNYF2P9j4Ik/SeqpJ+vErWltK97np1LEqXOrb3pxmIqhMg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2982.namprd10.prod.outlook.com (2603:10b6:a03:8a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21; Thu, 1 Jul
 2021 00:26:06 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 00:26:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: iscsi: Fix iface sysfs attr detection
Date:   Wed, 30 Jun 2021 19:25:59 -0500
Message-Id: <20210701002559.89533-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:5:335::25) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR05CA0056.namprd05.prod.outlook.com (2603:10b6:5:335::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.12 via Frontend Transport; Thu, 1 Jul 2021 00:26:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5dbfdce-a50c-419a-c569-08d93c26d135
X-MS-TrafficTypeDiagnostic: BYAPR10MB2982:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2982CEE5E8A5C0CC648E047BF1009@BYAPR10MB2982.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tov2hMzzAc+asp+QgcxAJi+sSeCsXk2yDIyzWrJaVs715tdO2WROBLr0+PdDMjV+BdM4TFbdmifYIJytYRZfpQHiiPed8pp2sWBF9X5uZPSraLN64Pp95yuO7QPjMXndkH5nt9nC4O7dcGP73gNWiKAqlIra7+Q0OUTLh67743tSZ2Bj+8Wq4vmiMRZQUcmKFROp/04MLT9MrFJ0Rp7gbBnedCRJyktnhN5xrISifhpej5dc3ih9R3YQJ1sQ7EPFq0OVFZeYEJ9lRmNu85F+ZP04EPpPx1ia7/PZUfJUjNUr2TN665XepDFY7EjMefYn+gkiENHM0agiNKiPLXB/YNbrTuLXxSeUh65+ds6q7nu6gOkK+C1QH2KGALUkKAsmNWy7eFrt3N58RtS/1JiGKvEZE2eCNVQpFrrOtvaJzaAxbBjCjJMwl0he5x2uYXUfitPtJrXlJBCey8DX+mxzwOzm9QpUs8lhEHUzIEzV6RDyNvmPT2Qz9WrwphXBwOFiKHPd46viptjyXcnAKAG24zGCpT3Dxbspg0B0TFTQ2DzEYEu+Z0W94qs9qdO0De1pvWQStPIAHi63pU5aSsXpO5f3jj/S6i555OYY6QRZMMw0ahYN2dGpwIsUX4jNu7/tXHFXvvpcMZ4bd3K1GtNUtU6ixkZ3rZudIfgxmcerq8a0prs72KO0QTY8RWez15i4V4kuhNK1QTozQ4TzTx78HwA7z7Y/RhoA9kCQaTti3Wg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(136003)(396003)(956004)(2616005)(316002)(1076003)(107886003)(6512007)(52116002)(6506007)(5660300002)(6666004)(66946007)(66476007)(6486002)(2906002)(4326008)(36756003)(26005)(66556008)(38100700002)(8676002)(86362001)(16526019)(478600001)(83380400001)(8936002)(186003)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AGR8E3B1AmSYJ0xM5YSjy+9QSLI+Mz1h6cbTQntzPrIdlaHO7Wt+FmMscQl+?=
 =?us-ascii?Q?bAXPNe99DoGXTuO2PFh5W5N7nH8MLg3OZ2UV4qfJuKClGkEVTgVqiFPXrvTV?=
 =?us-ascii?Q?nkywBbYgYrhj3Pu1ahHoT/1kjmqoh5vmfdS+nX1YJq2HXxVJ897mbgKYHVTR?=
 =?us-ascii?Q?iBGF8AEL6rd68f0y4pHgxEsCxWCJzs4ZKNf9SKB0/AtDLwZh4ocIKGLwo0+A?=
 =?us-ascii?Q?O1NKJajrcm0hQdrCc9Q9VJ/ANNWrswMqBTvEssOBkm9AJd7IpOJlJM/D3OER?=
 =?us-ascii?Q?S5T1sByuQY5dUEUf465z4n5btmQW8Z9pB6YMRX1b3dTlM/eZGSwcCjceJoDD?=
 =?us-ascii?Q?gu1cTDUiHr9OTQl4eq+3q0NxwCpPYQQeGoND3G5WFNY+cvd6/Gx0AsVmYOaK?=
 =?us-ascii?Q?L5pS+D+NjZ/BgCCsUnRyLtyGNtnjua3yh88YjrELvkEbxTexqq3mXFnIxQoS?=
 =?us-ascii?Q?tKlCQwSo1j3oF3kbfkhdPCBbj1rj91Uqb0IBM0YykYwFeGLUGWAcl9MJdRMf?=
 =?us-ascii?Q?SFN7Dbhjjdk2o4wYvHaTkw+/AknfV3jguN3WQ01PUFR+ZO6Ggiqvh/rCKPIT?=
 =?us-ascii?Q?n5eK7eXi/ZckAJz6mi//KI76HehBWpkdPwhpy9nJ4zwaFULz3r4FQpDrRdXL?=
 =?us-ascii?Q?Wb7UNVKctbx6sdstZXxFUdl4HXeY88dvOl59RQn1ncP2oifgpuxaVQCXsoBB?=
 =?us-ascii?Q?WOVrsjHmVxiVftJ3D9cGpJE23G3+ONkA24vfEoIJZQC48XxOFWCoF2mAxLi+?=
 =?us-ascii?Q?20RNTjig2R86ynFPhbeactZK0c27ZfAvHEHT6hIaUhrDZ6oLWP0h+VIQqOBv?=
 =?us-ascii?Q?Oi6o3HDfjv2NIxBQjGDubJuvKiC+qULDisJtwKLqSc4JoqpbwRuGbzW5sak5?=
 =?us-ascii?Q?FiaaeuCrWiChXkY9+MFUGcnfDli2DAHyNJJrFizkO1DK9l1vCQGfv8DVGFRU?=
 =?us-ascii?Q?t4ddeClTeBkwAlas7gBjVy+wm1NQ+1QLgvu/p0ippGe50ZPejidWdburPYUi?=
 =?us-ascii?Q?ZKYMixhUeBkydKYGDMmS04df/Q/L91ielyuQiSxU0j/EETUcyUVwfzn7Rx/N?=
 =?us-ascii?Q?psXYcyP4M5q/ZjEt3oWd0zqqk0rcKbEArT3/9+oCKCLunCLewmnY4PXIg8qa?=
 =?us-ascii?Q?1T3MZOzgu6cZdVroH94uJtZ7QAbqZwagD3HSCtMRzEaJPXmtlSZZMc9mXhy1?=
 =?us-ascii?Q?5gLXy6l537gqursM1H8mgiv4TEFj/OKLCkbxpbnV+uvSbVY6MrIJwOVvJPZx?=
 =?us-ascii?Q?dNd2nULaoFKmGwatScrhgJQLnVDRr6tr39xms3jcpW/MrFotXiuebwXzFVs7?=
 =?us-ascii?Q?k/38eXadooqdCSH/zC4AGFAv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5dbfdce-a50c-419a-c569-08d93c26d135
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 00:26:06.8390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4O7BEC8WZrGmmdoNnrZklDme/59/IgEHOmeMQbe7e0kU1YeV/ECH4fpnm07chHveKWOe6hRvd9a9knFM/WGfK+UqQeBYs5tfq4udmTUaDZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2982
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10031 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107010001
X-Proofpoint-ORIG-GUID: 245weTLn1kV8xmpu_Pr7m6mfovQJF75Q
X-Proofpoint-GUID: 245weTLn1kV8xmpu_Pr7m6mfovQJF75Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A ISCSI_IFACE_PARAM can have the same value as a ISCSI_NET_PARAM so when
iscsi_iface_attr_is_visible tries to figure out the type by just checking
the value, we can collide and return the wrong type. When we call into the
driver we might not match and return that we don't want attr visible in
sysfs. The patch fixes this by setting the type when we figure out what
the param is.

Fixes: 3e0f65b34cc9 ("[SCSI] iscsi_transport: Additional parameters for
network settings")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 90 +++++++++++------------------
 1 file changed, 34 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 441f0152193f..01f6445b47c9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -440,39 +440,10 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
 	struct iscsi_transport *t = iface->transport;
-	int param;
-	int param_type;
+	int param = -1;
 
 	if (attr == &dev_attr_iface_enabled.attr)
 		param = ISCSI_NET_PARAM_IFACE_ENABLE;
-	else if (attr == &dev_attr_iface_vlan_id.attr)
-		param = ISCSI_NET_PARAM_VLAN_ID;
-	else if (attr == &dev_attr_iface_vlan_priority.attr)
-		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
-	else if (attr == &dev_attr_iface_vlan_enabled.attr)
-		param = ISCSI_NET_PARAM_VLAN_ENABLED;
-	else if (attr == &dev_attr_iface_mtu.attr)
-		param = ISCSI_NET_PARAM_MTU;
-	else if (attr == &dev_attr_iface_port.attr)
-		param = ISCSI_NET_PARAM_PORT;
-	else if (attr == &dev_attr_iface_ipaddress_state.attr)
-		param = ISCSI_NET_PARAM_IPADDR_STATE;
-	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
-		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
-	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
-		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
-	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
-		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
-	else if (attr == &dev_attr_iface_tcp_wsf.attr)
-		param = ISCSI_NET_PARAM_TCP_WSF;
-	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
-		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
-	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
-		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
-	else if (attr == &dev_attr_iface_cache_id.attr)
-		param = ISCSI_NET_PARAM_CACHE_ID;
-	else if (attr == &dev_attr_iface_redirect_en.attr)
-		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
 		param = ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
 	else if (attr == &dev_attr_iface_header_digest.attr)
@@ -509,6 +480,38 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN;
 	else if (attr == &dev_attr_iface_initiator_name.attr)
 		param = ISCSI_IFACE_PARAM_INITIATOR_NAME;
+
+	if (param != -1)
+		return t->attr_is_visible(ISCSI_IFACE_PARAM, param);
+
+	if (attr == &dev_attr_iface_vlan_id.attr)
+		param = ISCSI_NET_PARAM_VLAN_ID;
+	else if (attr == &dev_attr_iface_vlan_priority.attr)
+		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
+	else if (attr == &dev_attr_iface_vlan_enabled.attr)
+		param = ISCSI_NET_PARAM_VLAN_ENABLED;
+	else if (attr == &dev_attr_iface_mtu.attr)
+		param = ISCSI_NET_PARAM_MTU;
+	else if (attr == &dev_attr_iface_port.attr)
+		param = ISCSI_NET_PARAM_PORT;
+	else if (attr == &dev_attr_iface_ipaddress_state.attr)
+		param = ISCSI_NET_PARAM_IPADDR_STATE;
+	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
+		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
+	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF;
+	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
+	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
+	else if (attr == &dev_attr_iface_cache_id.attr)
+		param = ISCSI_NET_PARAM_CACHE_ID;
+	else if (attr == &dev_attr_iface_redirect_en.attr)
+		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -599,32 +602,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		return 0;
 	}
 
-	switch (param) {
-	case ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO:
-	case ISCSI_IFACE_PARAM_HDRDGST_EN:
-	case ISCSI_IFACE_PARAM_DATADGST_EN:
-	case ISCSI_IFACE_PARAM_IMM_DATA_EN:
-	case ISCSI_IFACE_PARAM_INITIAL_R2T_EN:
-	case ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN:
-	case ISCSI_IFACE_PARAM_PDU_INORDER_EN:
-	case ISCSI_IFACE_PARAM_ERL:
-	case ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH:
-	case ISCSI_IFACE_PARAM_FIRST_BURST:
-	case ISCSI_IFACE_PARAM_MAX_R2T:
-	case ISCSI_IFACE_PARAM_MAX_BURST:
-	case ISCSI_IFACE_PARAM_CHAP_AUTH_EN:
-	case ISCSI_IFACE_PARAM_BIDI_CHAP_EN:
-	case ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL:
-	case ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN:
-	case ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN:
-	case ISCSI_IFACE_PARAM_INITIATOR_NAME:
-		param_type = ISCSI_IFACE_PARAM;
-		break;
-	default:
-		param_type = ISCSI_NET_PARAM;
-	}
-
-	return t->attr_is_visible(param_type, param);
+	return t->attr_is_visible(ISCSI_NET_PARAM, param);
 }
 
 static struct attribute *iscsi_iface_attrs[] = {
-- 
2.25.1

