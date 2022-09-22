Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98607C6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiIVKHg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiIVKHY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F72B6571
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3san006440;
        Thu, 22 Sep 2022 10:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=VVgu3lYKvIFRr+GLVoSKfoPBoxtramNcHfYQbQm79pk=;
 b=PUcGDMkwJh6L9lTxZtzKLEiYI6yxFlQ7bQTyqlfTO/7k9EcEYC5vxZ+DdhLjXxSQhdFJ
 d1IoXXo4Cgb9JIAaLemPNoyoFH2GrTdyRb7IRNf8zwE7E12zgzx4NrH+QMvor1Wn+6GY
 MO1hDWX0/EyX/SIoCbyr4+5hOWTnWb5sGbtMhUW/zC6zo8AUD0La/T+zE1f4mPXbyZyN
 P4JbzoOK3xWtbgeHyVR3u90tmC5HrGN7PYLrU0oEXgqPnIDy6fxwfGRc0ZHSJGOMJ+zJ
 SK2JMnx5CXBMcgTCBm/cIEVF7Qu9cQ6uAw9DolTHq9EapKN1ureDb2qys2dw2vu0SpVh OA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68md276-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8liXF035391;
        Thu, 22 Sep 2022 10:07:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d4dyqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDOKuu1PZtcG+XDFcYSGZ/B2Wtkswos9KK0HGVpJFJIBuSmSVXCy4HOamHk34RNYCccNvRPnS8i6OJTgQJAAMRxN9x+R3CWQI8gmqGpJdrPAdQjlMW4/0oIjApV35HOFhbpZhJQx29RrFVYcV1mPeqqIR7JfAc0A9PreM7fZvSlt3PEPQ+xTlPRrX/wm0pjZYZAXX++u4eq5hwYt5nq2uMGUa386S6ccbXPyy6CzLnpHhyUdcbfZ63uEZUMnGvGvsYqow9Tb6sAQvhn1lwbIvJfAGiS8UU4/k3/lkl/DCU2BlP1EWzzXNIsb6lNk/G0EBUNm9S/OWni7R8mciRN60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVgu3lYKvIFRr+GLVoSKfoPBoxtramNcHfYQbQm79pk=;
 b=TqVaXW3Xo5Wlv8nXPWc9lJAiUvz/PJHJpseKkb2TPoLNNv+Fg/hzOO6d6GflPOE7ZQ6FZKBzqQD3nOvViU8/MqgimTpewyxkD1RjtSXghnLvBwmwm1mrbfZ7ihPoz8pHEIzG8E1b4Uc2eIgwHRuTK08gQuWMZK5TWR1kwlfbERKG6eZZZ76kP1J6h0y1EFVncAtqBuzLdPB+I0vEhQ0hXU/j2ibIk6q0wGY60e/J0oWXzYZY6GBc2n8wfwCf4rHhs/nz0a9sxQ6QMpDEPfGtSESOnZm139kOt58MK2IU7gN4YRJs7ViCNp7kSG7PDWbpQ4fji8zDFYnaFhDe9bHr8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVgu3lYKvIFRr+GLVoSKfoPBoxtramNcHfYQbQm79pk=;
 b=Z0B5/Y5JkCaqHE9MS9k4+W2JVFSAl9gRsTHDUF39bxweBb1T7juJLZGgyZEf7QiNrOgyCvvQoqLtlDnvj92heONOAcywbEfNt27vHi0q7CtAXyAHmKxVPZrtdKg9i6bqcCVuYla5eHhhVLjDOCm/eiFdfG4e8uyEq/e9gKbysF8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4317.namprd10.prod.outlook.com (2603:10b6:208:199::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 10:07:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 03/22] scsi: Take an array of failures for passthrough
Date:   Thu, 22 Sep 2022 05:06:45 -0500
Message-Id: <20220922100704.753666-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:610:57::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4317:EE_
X-MS-Office365-Filtering-Correlation-Id: 880a01ab-6fc1-497d-32fe-08da9c8237c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q28x5fW7T937Zd6B+TwvZBQeEb6zlEGqjhfGF0noaMWRGm0zql0mtoUWFQz6BrDoBpvRSvaXN1aE3Pb22Ygnj+GwRZRjgiUZmhwLEqZqtRTkX6cMnh784Otq+1/YuxuXrBPIb1KG0Orl9B6n60DfNrpNknsasd7P8y2Z9eAkGUOlwkYo5edfk4TNx+OYgf7JR3WJYS6TBuswkHPwr81H9bvZ5AOw90AyVmaG8MWC3y2tnqjEmNBCu22x7C3ICh01tTF9eV9FHpPGOdZChNuMxa8iY+KOIwL1FLNb6tvJVEK8MytcJ1geBShpiU9NQjdXeoOLFL/TCeVqUmfh7KSONw/MBVKaELEUzfdHxJN7z0Nc057bj3DtDwmgofRMZKzCupCExdotcQDC+hcpMni/KGtwmzRIebetEquZShr76RqcWDEl3/pOn3AqS/pQc+ORFOxH85E8yFdYXnlgi3CTYIIqUEeE389+EHcmBqrJdd+R0Dw2qq5MRT7vzx9x4aQnkIxhXiUvu0jQmYyoSf27f5wtXI81KcX6BfMIt+b5ezNzEza/Ww6e9EH70Q8mLnDfXtaqzvppf2R8eWpuT3iKeB+vM7aznt/ga2ptwmGtibxlOVLofZ8GdljsANUoZqsRBJxVdg1dQ+F06PtQR9+hG5RX0nRSO9Yk+8I6VdxUkqsUQ1Cr4M5VgaRp00WsqSiHyBK1hXUtZPhWojAVFA5sqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199015)(2906002)(86362001)(38100700002)(8676002)(6506007)(6666004)(107886003)(26005)(6512007)(4326008)(316002)(2616005)(6486002)(478600001)(30864003)(41300700001)(8936002)(5660300002)(66476007)(186003)(1076003)(66556008)(83380400001)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iPisH1prBlVS8FXnco5Sv4OdXC1N8ndAbFjyFe1rZRW7uOmB7PKUonq/BZCp?=
 =?us-ascii?Q?f9WgQ/VmsrYl5tWJUNRFg6prBMBD9bwy9fnhxb0GNT36QsnMfC452ubS2nha?=
 =?us-ascii?Q?s6dBynMoeU76OXsV75JrZyfjwl5bCx1Ru9364mwi97ukM+nG2JmFYSqVs/W4?=
 =?us-ascii?Q?FHyInr2V05YGQkW5G++RFNXXApsG6dGzir2xB+sf42HPjZgohdf+EvuQI0lS?=
 =?us-ascii?Q?a6iWAnhTmkNDDp01yzLG5Lv16CvPZJX5hPcW5lGQBh1sSz8xYiREws9VcwMl?=
 =?us-ascii?Q?73VV91LoEtGsdEPaW5NaXwBVfvYSSxtPqwscFEZ4c4kDxqXTr16PYtgVg0Wa?=
 =?us-ascii?Q?zEYzPzB9fcID3r+UjAtOmant2ocIqq7pyoB4jZ7zroia1DQu9r/XRCqllieW?=
 =?us-ascii?Q?kCegVHhBUHGN+Mwi2cR7UihgqZuIwqOsCpqGvhkJFWqI6MQ6yVl8aNyR5hjm?=
 =?us-ascii?Q?RrCe3KqrpcKcH8PZk6Fn7zRv7xk3rqP5nQuqnKEj2RXwuMz9Pn/DfefnuCPs?=
 =?us-ascii?Q?2c8Jc0vZOEmfbexEWboAt0mSFYlIKYVcnwrLZUBXuX68o6GSoxhfIYqX1uFU?=
 =?us-ascii?Q?Ri0u09k/VQVOdLEBWDCxkG2u7oGO8zRX8tfZzOuezB99l9flzRIeZP3HjSRC?=
 =?us-ascii?Q?3GZvTgIYvRGLWP+9HcfbMxzqnawnP50YyK4ipscXRHiBMVbv7QF/cMWsA0g+?=
 =?us-ascii?Q?CHjWSxqA40LuWaaAehTPZMtZ7QsM4k+z795qI7mC96xdK/Foyt3kHF8hgHcz?=
 =?us-ascii?Q?QoZJcH2OBJXU9Vkd6+z7ZXAlS8nnN97p54fEBVai11Mo44gZGOZQRGLX02xF?=
 =?us-ascii?Q?reH/biFVWAdkdmEn/+PF/pddXj7KIw5mhwAnszpSJF9Y0FkI4p6uvzSr2JYE?=
 =?us-ascii?Q?VxHCgvYjUqAmTaiCazoggYKlZI5zWASwBuC+f1/slm2Xv3JIf0Ubk7S8J7A9?=
 =?us-ascii?Q?6FTPP4TX8KQTqbC+vgH1NL8QK+x5D0psWp4bZ1bSpA7cZw/BquShvEeNmSmH?=
 =?us-ascii?Q?hRl8jr3onZ842sWxPGHPVa45D/tNy8uZpgKiJpGDTGP2btTzj393OgM0vk38?=
 =?us-ascii?Q?s1znpUO6kb8+jE8uREUTHrwcYi5+vDyln00w2mWoqb7cS/2GjL7VcOIfNLYF?=
 =?us-ascii?Q?quE7Ck+2xVCCpJ7wn/yDjWwRp8TJxnSFotj03oE2pZJTJiaEYftIV1FR1Wf7?=
 =?us-ascii?Q?DkPaDTNhFFdprnanos4HQ9qEVTFFZudFRsylOBEpmQ9932bljahUQry43w0F?=
 =?us-ascii?Q?AjnkJ/u9ZWx3KZ4NP256T4SLn8TXO/DgGPNcXoaUxpCjGtmYGXsUMnm/FjG4?=
 =?us-ascii?Q?GgfyZOJlEr7rYi/uYXKgcgVHdUxg9kWHWm0SdjEi6GKEP5h/dKbVngk+HEj6?=
 =?us-ascii?Q?FTk5y9v9V4WAdsKvIh9YK3hiiQ+kygmU0NSYGkU2Np6GPvOIW9MEhG8OP46d?=
 =?us-ascii?Q?BzTptOZZAmbY751OGov/bVbGRXD9bLwKWIkzCY0z84Py6mvlOkmWlSA40ECl?=
 =?us-ascii?Q?ImWyV0aH9OtWWTFBP+qJDF2Iv1BoxIAd4+aDf5oCpLmUbaR+fezezKes9ajm?=
 =?us-ascii?Q?YDtUfn7bQNg/5zxahIuiGJAsSV126hMZdPsBZpjzspIELCjNpQlTQsIIuhn7?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880a01ab-6fc1-497d-32fe-08da9c8237c4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:12.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYm6XGm2Gfjl69oJZWQw+QlhbhK6Oe+xLScFgDQJxNCtAoOgss6OJzwVKw645/PL20hkxw7ifUbM854ShcgmXacUDLgsRwZbIjcPbqfvUL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: SAHaFIepMlo3Yz_vWKx6pPR7e3e0aXWs
X-Proofpoint-GUID: SAHaFIepMlo3Yz_vWKx6pPR7e3e0aXWs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows scsi_execute/scsi_execute_req users to pass in an array of
scsi_failure structs they want retried. In most cases they can then drop
their sesne parsing and error handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ata/libata-scsi.c                   |  6 ++++--
 drivers/hwmon/drivetemp.c                   |  2 +-
 drivers/scsi/ch.c                           |  2 +-
 drivers/scsi/cxlflash/superpipe.c           |  2 +-
 drivers/scsi/cxlflash/vlun.c                |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  4 ++--
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  6 ++++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  4 ++--
 drivers/scsi/scsi.c                         |  4 ++--
 drivers/scsi/scsi_ioctl.c                   |  2 +-
 drivers/scsi/scsi_lib.c                     | 11 ++++++----
 drivers/scsi/scsi_scan.c                    |  7 ++++---
 drivers/scsi/scsi_transport_spi.c           |  2 +-
 drivers/scsi/sd.c                           | 23 +++++++++++++--------
 drivers/scsi/sd_zbc.c                       |  2 +-
 drivers/scsi/ses.c                          |  4 ++--
 drivers/scsi/sr.c                           |  5 +++--
 drivers/scsi/sr_ioctl.c                     |  2 +-
 drivers/scsi/virtio_scsi.c                  |  3 ++-
 drivers/target/target_core_pscsi.c          |  8 +++----
 drivers/ufs/core/ufshcd.c                   |  2 +-
 include/scsi/scsi_device.h                  | 15 ++++++++------
 23 files changed, 69 insertions(+), 51 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 29e2f55c6faa..cb8f8e1c8065 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -414,7 +414,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
 	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
+				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL,
+				  NULL);
 
 	if (cmd_result < 0) {
 		rc = cmd_result;
@@ -498,7 +499,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
 	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
+				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL,
+				  NULL);
 
 	if (cmd_result < 0) {
 		rc = cmd_result;
diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..cb4549194771 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -194,7 +194,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 
 	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
 				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+				NULL, NULL);
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7ab29eaec6f3..cdef392be5fc 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -197,7 +197,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	errno = 0;
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL);
+				  MAX_RETRIES, NULL, NULL);
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index df0ebabbf387..cc1a63986bff 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -359,7 +359,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	up_read(&cfg->ioctl_rwsem);
 	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
 			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
-			      0, 0, NULL);
+			      0, 0, NULL, NULL);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5c74dc7c2288..dc934800edda 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -452,7 +452,7 @@ static int write_same16(struct scsi_device *sdev,
 		up_read(&cfg->ioctl_rwsem);
 		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
 				      CMD_BUFSIZE, NULL, NULL, to,
-				      CMD_RETRIES, 0, 0, NULL);
+				      CMD_RETRIES, 0, 0, NULL, NULL);
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 610a51538f03..335daaf90bb2 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -141,7 +141,7 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 
 	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen, NULL,
 			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL, NULL);
 }
 
 /*
@@ -173,7 +173,7 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 
 	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len, NULL,
 			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL, NULL);
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2e21ab447873..162d822241ba 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -265,7 +265,7 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 
 	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
 			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
-			req_flags, 0, NULL);
+			req_flags, 0, NULL, NULL);
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 0d2cfa60aa06..64345f9125ca 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -88,7 +88,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 
 retry:
 	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+			   HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL,
+			   NULL);
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -126,7 +127,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 
 retry:
 	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+			   HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL,
+			   NULL);
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index bf8754741f85..fce6886b8319 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -556,8 +556,8 @@ static void send_mode_select(struct work_struct *work)
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
 	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
-			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			RDAC_RETRIES, req_flags, 0, NULL)) {
+			 data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
+			 RDAC_RETRIES, req_flags, 0, NULL, NULL)) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..d6c9e18d8044 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -310,7 +310,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * all the existing users tried this hard.
 	 */
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len, NULL, 30 * HZ, 3, NULL);
+				  len, NULL, 30 * HZ, 3, NULL, NULL);
 	if (result)
 		return -EIO;
 
@@ -532,7 +532,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	memset(buffer, 0, len);
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  request_len, &sshdr, 30 * HZ, 3, NULL);
+				  request_len, &sshdr, 30 * HZ, 3, NULL, NULL);
 
 	if (result < 0)
 		return result;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 729e309e6034..cd7d25edfc77 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -74,7 +74,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
 	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries, NULL);
+				  &sshdr, timeout, retries, NULL, NULL);
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 56aefe38d69b..7e4cc0b28f61 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -200,6 +200,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * @flags:	flags for ->cmd_flags
  * @rq_flags:	flags for ->rq_flags
  * @resid:	optional residual length
+ * @failures:	optional array of scsi_failure structs
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
@@ -208,7 +209,8 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
 		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
 		 int timeout, int retries, blk_opf_t flags,
-		 req_flags_t rq_flags, int *resid)
+		 req_flags_t rq_flags, int *resid,
+		 struct scsi_failure *failures)
 {
 	struct request *req;
 	struct scsi_cmnd *scmd;
@@ -231,6 +233,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
+	scmd->failures = failures;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
 	req->rq_flags |= rq_flags | RQF_QUIET;
@@ -2138,7 +2141,7 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 	}
 
 	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+			       sshdr, timeout, retries, NULL, NULL);
 	kfree(real_buffer);
 	return ret;
 }
@@ -2203,7 +2206,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	memset(buffer, 0, len);
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+				  sshdr, timeout, retries, NULL, NULL);
 	if (result < 0)
 		return result;
 
@@ -2288,7 +2291,7 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, 1, NULL);
+					  timeout, 1, NULL, NULL);
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5d27f5196de6..ddaa9e7b3e34 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -211,7 +211,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
 	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
-			 SCSI_TIMEOUT, 3, NULL);
+			 SCSI_TIMEOUT, 3, NULL, NULL);
 }
 
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
@@ -677,7 +677,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, try_inquiry_len, &sshdr,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid);
+					  &resid, NULL);
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
@@ -1479,7 +1479,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 
 		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
 					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
+					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL,
+					  NULL);
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index bd72c38d7bfc..4f4c2b155da0 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -126,7 +126,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+				      RQF_PM, NULL, NULL);
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba055021..c215da95fb8f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -673,7 +673,7 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 
 	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
 		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
-		RQF_PM, NULL);
+		RQF_PM, NULL, NULL);
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -1595,7 +1595,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * flush everything.
 		 */
 		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
+				   timeout, sdkp->max_retries, 0, RQF_PM, NULL,
+				   NULL);
 		if (res == 0)
 			break;
 	}
@@ -1721,7 +1722,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	data[20] = flags;
 
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL, NULL);
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2065,7 +2066,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			the_result = scsi_execute_req(sdkp->device, cmd,
 						      DMA_NONE, NULL, 0,
 						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL);
+						      sdkp->max_retries, NULL,
+						      NULL);
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2125,7 +2127,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
 						 SD_TIMEOUT, sdkp->max_retries,
-						 NULL);
+						 NULL, NULL);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -2274,7 +2276,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+					SD_TIMEOUT, sdkp->max_retries, NULL,
+					NULL);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2359,7 +2362,8 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+					SD_TIMEOUT, sdkp->max_retries, NULL,
+					NULL);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -3609,7 +3613,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		return -ENODEV;
 
 	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+			   SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL,
+			   NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -3752,7 +3757,7 @@ static int sd_resume_runtime(struct device *dev)
 
 		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
 				 NULL, sdp->request_queue->rq_timeout, 1, 0,
-				 RQF_PM, NULL))
+				 RQF_PM, NULL, NULL))
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Failed to clear sense data\n");
 	}
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..1c9db71335a7 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -159,7 +159,7 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 
 	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+				  timeout, SD_MAX_RETRIES, NULL, NULL);
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..8f5a6370f334 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -92,7 +92,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 
 	do {
 		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+				       &sshdr, SES_TIMEOUT, 1, NULL, NULL);
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -133,7 +133,7 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+					  &sshdr, SES_TIMEOUT, 1, NULL, NULL);
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..8b28a8a28b45 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -173,7 +173,7 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	int result;
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL, NULL);
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -732,7 +732,8 @@ static void get_sectorsize(struct scsi_cd *cd)
 		/* Do the command and wait.. */
 		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
 					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
+					      SR_TIMEOUT, MAX_RETRIES, NULL,
+					      NULL);
 
 		retries--;
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..40146ef3afa5 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -204,7 +204,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 
 	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
 			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
+			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL, NULL);
 
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 00cf6743db8c..052b30b00b50 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -349,7 +349,8 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+					  SD_TIMEOUT, SD_MAX_RETRIES, NULL,
+					  NULL);
 
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e6a967ddc08c..554f9ccef001 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -145,7 +145,7 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
 	cdb[4] = 0x0c; /* 12 bytes */
 
 	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-			HZ, 1, NULL);
+			HZ, 1, NULL, NULL);
 	if (ret)
 		goto out_free;
 
@@ -196,7 +196,7 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 	put_unaligned_be16(INQUIRY_VPD_SERIAL_LEN, &cdb[3]);
 
 	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL, NULL);
 	if (ret)
 		goto out_free;
 
@@ -231,8 +231,8 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 	put_unaligned_be16(INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, &cdb[3]);
 
 	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			      NULL, HZ, 1, NULL);
+			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, NULL, HZ, 1,
+			      NULL, NULL);
 	if (ret)
 		goto out;
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a202d7d5240d..601648352aff 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8782,7 +8782,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		if (remaining <= 0)
 			break;
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   remaining / HZ, 0, 0, RQF_PM, NULL);
+				   remaining / HZ, 0, 0, RQF_PM, NULL, NULL);
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2493bd65351a..85c5baac1b17 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -14,6 +14,7 @@ struct bsg_device;
 struct device;
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_failure;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
@@ -458,24 +459,26 @@ extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, struct scsi_sense_hdr *sshdr,
 			int timeout, int retries, blk_opf_t flags,
-			req_flags_t rq_flags, int *resid);
+			req_flags_t rq_flags, int *resid,
+			struct scsi_failure *failures);
 /* Make sure any sense buffer is the correct size. */
 #define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
-		     sshdr, timeout, retries, flags, rq_flags, resid)	\
+		     sshdr, timeout, retries, flags, rq_flags, resid,	\
+		     failures)						\
 ({									\
 	BUILD_BUG_ON((sense) != NULL &&					\
 		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
 	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
 		       sense, sshdr, timeout, retries, flags, rq_flags,	\
-		       resid);						\
+		       resid, failures);				\
 })
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
+	int retries, int *resid, struct scsi_failure *failures)
 {
-	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+	return scsi_execute(sdev, cmd, data_direction, buffer, bufflen, NULL,
+			    sshdr, timeout, retries,  0, 0, resid, failures);
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.25.1

