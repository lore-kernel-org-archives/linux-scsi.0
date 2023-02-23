Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3802C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 00:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbjBWAUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 19:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjBWAUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 19:20:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B8023867;
        Wed, 22 Feb 2023 16:20:12 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31N029kp022694;
        Thu, 23 Feb 2023 00:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WT+D58Mm/6m5WJdmwoMcIEWA+gkAk8jkSTlxzNZiDT8=;
 b=X8GCn1la5UAwtN3lU4Bj9yPuDj/0cgE3nAvk1Q9dXT50gxu7lQ68nuwcDHZrQFlh8zCl
 liecDmgCgID0pT09x+14HF+HYQZA2+j5KmCYJ9vHmqAMj8mcHvswrnf73+kCpu21eRk7
 CF2tGmf8i18iFZpZqM7D83oLf93lTDKcy2I8qxRP11VBHNbWO9I1bK/v8As9i9PAsZ26
 DqwCBHRyRxO6i7WYOTMOIwHG7736e8kS4fWKAO6Tgp5vyF9yJZNHACwLIlNYkPd6w7YD
 noe1qvzfB3NoXsv5lvpKpKo1nAIXZknsa6cVMwBWCL6+EZUSo9nRx2Tc8cGX8JSRICYv Vw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnkbs9c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31N0Cq4h027367;
        Thu, 23 Feb 2023 00:20:08 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn47j3vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCJu9NVwUUBjsrlSVNoQgMPPmgAh0Ksyq+tsOrYXOisBHQTo55yh1MoLZv6k0RGvA7g0/qZGqa7o3YmSSjBzoXXIR5vjJsDzDsMNxOuulwTSGgN20NT11wZDFJtEd2FFc9TJjcTqSmyuNZhqfj9dIHEapYkRC7la6sVnSUcVMC2DDICITrdIw7PG/XoJ+8DYRIM4fMek1m4rLvKj6VB4QHht+GeNx4bk8tR97ar0vtSSh2qU4Kw69+KszpGbI9qmpIBTbMDwGKQJZjtmPwS7JalpM48OjssryoEXhIgVkFHiwVKQvKGn9WMF2zPFPKE78Gth1WOw3EekfYTc8TvOZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT+D58Mm/6m5WJdmwoMcIEWA+gkAk8jkSTlxzNZiDT8=;
 b=afU9rEGrHdI5Uap2opOUPaILYX/kx0q7m3u5ft6MCkRUW6rlKWJtv5wtorPg5IHNxZZ3Lzc8Ng3zaeb+EfFIEpwK+KJiyMAjMLeXXqQXvaQZMA7QI1FCusyed67KQ4r/Jo3/jjrXy8Dt/+mB57qxXti0mruVJBXX91QtCzffHR/p3/SyVkyo5p6oJk0JC1idH4xo8vEIzX+Dy6vQRR/T6IS0ImUwJNfZGgak7HkDRk+2+gYlBU4+QSzT0jePLBQxHgVoNQrHcEu3a5dh61zUnEFlQoX9XIlxdIKnlNEmULZOf2iwGX3CKmRFhp+J5YwuW6Fth6XHO8/04+UF38YbAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT+D58Mm/6m5WJdmwoMcIEWA+gkAk8jkSTlxzNZiDT8=;
 b=epJwEoLrLsZ7Pw/5E2VuaM7hBiGBIRh/rIH9SX1lG7XRvyR6Y4FNEZ2nO04hihptezdhBK3I62qkHCIXTDHpUFTneO/42QgGhwtg5ogie5CqHimdfSbNqIneekw4JcVmJOoTgYFrmAu4sUvjFhE57vEV1orKYyu3VYXXoEKz3MY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5286.namprd10.prod.outlook.com (2603:10b6:408:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.6; Thu, 23 Feb
 2023 00:20:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 00:20:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/5] vhost-scsi: Delay releasing our refcount on the tpg
Date:   Wed, 22 Feb 2023 18:19:48 -0600
Message-Id: <20230223001949.2884-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230223001949.2884-1-michael.christie@oracle.com>
References: <20230223001949.2884-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0047.namprd06.prod.outlook.com
 (2603:10b6:5:54::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: b20e4834-ef35-4f73-426b-08db1533b736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0gKLrbdzxfwtHomuqlHw8KqEYWn/xa8+mwdwhYSqOg3+JTn5uc3PuQ8312R7d3XwgQd9aBhDgNRp3+Ljs8QbkdrZtMmUUtHtMcI7ObzyWoBVTRIsaNdwfr1aTu2OXDUvT7I7cR3Y3V/n0zK8dl4aDHBj/oY9h33pGEGzUI6VyC5P7H5o2nriZ9FfYJSLXFPoe4K4PvdsRw47F/fDkQ8dvtFFkMAtmDnvA4Lwc3fYpBthqKiqUsNMNTb4+1Cxrll3y0VRZfzknBGqs/UlpAAG0GV8K/4YtgTocBiwjAxHEgJDry9CewxGFcoT60Ct7SguRgRcKqsLMkfcOpjilXdlkesLfjS6L1WtqpWxwSdbexDiGevePZe+/bEdf6RX3dv1ilhv76mWffwKJKoeOYNSwL4vP/LTt2mI523DtMjBm5o+Rb/9SYmgxtPUPnL76iK90rdi3Bj3ol+evUoqaUWGE9eFpF2B0oq4cQ+mOp8XdzzKgNWzysPbky9Gn8hhm3QIcCx8+ShPTMOcv5MG9o3eat67VoAGxzUr/uvrqaugG2Fxn8rhbRIpIhsTB0kTQ5hxdk2n0uj+PjNcxnGaIKi3kxDLC0IVVYEgY3IwCQgFrZXUdb/VTRIaP7IQWqFU6GwQwbCmIf2bHylW1WgbX0dsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199018)(5660300002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(8936002)(2616005)(26005)(186003)(1076003)(6506007)(6666004)(6512007)(2906002)(83380400001)(478600001)(36756003)(6486002)(107886003)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HrFZKzwQFtULC/fnygsARav0zxdtAZQCk7t0jX/Arlrj/CP5W3ytUqMiKzWm?=
 =?us-ascii?Q?Pk4ooimpFH1RzAWC0jtTN4/Kn7QpIrDZVqYLGjOyGjfo1Kt0cbTinoDEpayl?=
 =?us-ascii?Q?YgSDP5dowcFAhzrz04Xb3TOLUnDIxzb+4gUEi+YA2NO7TJPcDzoepTJtmV1Y?=
 =?us-ascii?Q?Uxjw6/oTxWxIYPrzeVGzqoW9LBkQZfRSHb3lszP3H8lMTgaM0nvWIJm8oiu7?=
 =?us-ascii?Q?erBJUuBRqVGOgULs1dVocFzZHqbYawp6XQoT9fj66FKWCqdUwlgxse2F1KHE?=
 =?us-ascii?Q?LU6Sm2Ww7HLAAp4tJh3tyYe4Y8bbFMzYlB5xU4awpNUm2Ajlo0hwf5z5Xamz?=
 =?us-ascii?Q?XNiJzDdOpvOvDbt1cx8tnohCDVMpNU7ZL384s2Po+ElACjxIMhFc71Dybt3M?=
 =?us-ascii?Q?rbBLgFhUOqhAXsfdsC1RWGj8vqRxoY/iRJPn3ggC5bxxAAxGCzlEN13+r35A?=
 =?us-ascii?Q?YusMr/0OE/6oQOGffs8AJ3/+X9kQU/RT7Gr9s5OuGUaB3P1boc0jpS/7DFJ9?=
 =?us-ascii?Q?FhT0GPY9AdHuc0opRCTlPc7DQCy1/hPLNGzDIlcpuGHVwRz/T8TXuRvWmpi7?=
 =?us-ascii?Q?6bFJFOsZXtkFbq88dSDYHU3nPHd3NjLr9WBE7IMttoB6WaypEa0lxkyOBK1I?=
 =?us-ascii?Q?e2I4Gw1NDYMs5teeosT/4gpNeMn7EW6AesWQSPxgtcnJ5KT/RhIT4YJ9rHBs?=
 =?us-ascii?Q?G5rHt1A9CEZbtoLE4IMpAMoQu2DMN1gX1pha8odWa6+CTFgk41rni/zmpCqc?=
 =?us-ascii?Q?UQF5WUJYOIU6zoOffj47A9KwvDBSCOUjyci5g0mQHGNb5PCps5PAJ3orJ0nN?=
 =?us-ascii?Q?GvITQypuxGhddLWoZaAm9ZjCV4rsLvuV50+o44GljlV8gZtA7wNeszENYFuh?=
 =?us-ascii?Q?2lTpLBLeGGJhWfB7nYf7DQkv92Kexr63te4FdQD2Yeyib6WSm75M4jydxeh+?=
 =?us-ascii?Q?uOGJyUwiSCKzMOxdAHybjegyhJ2ZCos6c79P0tXburM2nEPsNo7emljIyqx6?=
 =?us-ascii?Q?jS9j47ZTv7V/seW/17QFeRDj/ezeJeBUqCZpSY3XZl0Rnhz5GNUrPD0OuKVZ?=
 =?us-ascii?Q?STC+YBFqv6/8e8fKOhUUIK5cgbBLdEZRghbxwmk2AT/QJ0DcB2cU8QX8AUQG?=
 =?us-ascii?Q?zgznHHGFbcJnopty/mvajfxFPNLaMkmbL442XvXt5PHjzwkx6TFsmHty5WLi?=
 =?us-ascii?Q?s1KyB4iUUPK4buVLV0ijX7Mc98Ar2vRwQsPHDz7FDwPiab5mCXdo1eCAVbTL?=
 =?us-ascii?Q?MrYDU6Kf00ANd6JzMhEACSg+YkXohqRJdQ/78fmILqCo5VZInQWtdADGqENo?=
 =?us-ascii?Q?bLSlUoSZoXc/g1kss7GvVH4aifh1y8VtO8yd+4UHODcbtTtyW2lTyGZRNj1m?=
 =?us-ascii?Q?IijnSkRVQMroxzaBdLrL4qQvm/0GhrMImB/anIECJT8iRER/zo/1/4usivPs?=
 =?us-ascii?Q?reV9YkmZnVwBKy+VH8qOO5pbzbUpmI+PTTFJIsILJsU3atAzcSPId0G8RUZp?=
 =?us-ascii?Q?9TzafTrtePGwpLqLyvLi+echxnPg3So4P+/9ViNBBK93VqWQO0/qMx6t6vuM?=
 =?us-ascii?Q?1l4qDKEwMiE+q3uNCRAtf9Bo3x2+zWTSu1SHlZ1uTQvctDimI4UzUo5Tu0vS?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jRLgWdKYCTVN/TQoymEXq9GguogCMM20JIh5pnCcUYTeQThfb5Zh34BDxUSoKbbq8EJZkcfdzp2BfMwld3xhb+lRSmRBR0sRfwW3QOFEANe4HV0FU2ogc3F91x/dkXe+eNOPRQ3jjd0Fzi0pP3H12Bp+hou+dfDQS9Wqhvwyk+i/BlLEkJ08PzBJVIC2nzrwzLEmzVlAeDbm/ffzsCtRKR6FoxEKI3Qa9GTSqf2RLC+ttXkk2HJHgT+tsHzEgOuYflZFo5j9YuhvkoXAIhzHkkqV397IRpTG1yyZUxQnReXQiwhxFhwAkvCRnDDwTUxuQ+CT3HrmELBQ5keXkXxbJUSfhQSyEhd86V+ilJ7rUsHqbLpeaL1gBx2TG0C5bk5xHv/zMZ3FUPRqY5CNNG8OEyfHDwR/+NsALJSwve2neELdIgJiO/FyLlhWudtI6EZb8uTeb2JvzTkAqj2VA03+K19uZE5TQzRnXIa2e0sUyEAwB3GIA/iryQFRLGKf2KlPsa2MYsOqzBgSqpsVzZElg8W1owveswtqH+M9uuVjC2V2CPaZ0Rlj7yLGlge2gF5waO8VOf3LOoNu2EwoPVwmlj81N2VC6u0ytWrP/l0DsOH0SWCjdNBc5Kec3h6soXc7ekx//Lh6XpG0Qzcq2HvoRUOpd4ZCIJo9LLYFm82s5wq4RdWQ+OvQcI71v/gzn986CN6O5APhzSlFVWbe0aSJD+pVg1PYHvbVpbv683rcbKZuUbE/FFeqDE9ior+gPlQvis1QmZx9NSluoiOj6s6fDS9/svH20+ui8I2cQmxxI20cGhcHTZbi5BxYKETJeKz8Xx+PzxLE73w1kikxYFFG7skDT7BhDNGYflJE1vh1AmE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20e4834-ef35-4f73-426b-08db1533b736
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 00:20:06.6077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5cCeRV7yUw1Mc3D3tjdBVdWUo1fpjIJhM2s4ZVnoMQ/bQ6/txeNLBlKWeV/AXCFgwQlvlFUOn+IKk7a38TdV4USF7tYNqpw0HBlaZDOxsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_11,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230001
X-Proofpoint-GUID: f4hPl-MkA0EKsB9bu6fR_NnHB5q2bSBR
X-Proofpoint-ORIG-GUID: f4hPl-MkA0EKsB9bu6fR_NnHB5q2bSBR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently hold the vhost_scsi_mutex the entire time we are running
vhost_scsi_clear_endpoint. This prevents userspace from being able to free
the se_tpg from under us after we have called target_undepend_item.
However, it forces vhost_scsi_set_endpoint calls for other devices to have
to wait on a flakey device's:

vhost_scsi_clear_endpoint -> vhost_scsi_flush()

call which can which can take a long time.

This moves the target_undepend_item call and tv_tpg_vhost_count-- to after
we have stopped new IO from starting up and after we have waited on running
IO. We can then release our refcount on the tpg and session knowing our
device is no longer accessing them.

This also moves the tv_tpg_vhost_count-- to prevent a similar possible
use after free with the session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 62 ++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 9e154e568438..c405ab5c232a 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1704,11 +1704,10 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 		if (!tpg)
 			continue;
 
-		mutex_lock(&tpg->tv_tpg_mutex);
 		tv_tport = tpg->tport;
 		if (!tv_tport) {
 			ret = -ENODEV;
-			goto err_tpg;
+			goto err_dev;
 		}
 
 		if (strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
@@ -1717,36 +1716,51 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 				tv_tport->tport_name, tpg->tport_tpgt,
 				t->vhost_wwpn, t->vhost_tpgt);
 			ret = -EINVAL;
-			goto err_tpg;
+			goto err_dev;
 		}
+		match = true;
+	}
+	if (!match)
+		goto free_vs_tpg;
+
+	/* Prevent new cmds from starting and accessing the tpgs/sessions */
+	for (i = 0; i < vs->dev.nvqs; i++) {
+		vq = &vs->vqs[i].vq;
+		mutex_lock(&vq->mutex);
+		vhost_vq_set_backend(vq, NULL);
+		mutex_unlock(&vq->mutex);
+	}
+	/* Make sure cmds are not running before tearing them down. */
+	vhost_scsi_flush(vs);
+
+	for (i = 0; i < vs->dev.nvqs; i++) {
+		vq = &vs->vqs[i].vq;
+		vhost_scsi_destroy_vq_cmds(vq);
+	}
+
+	/*
+	 * We can now release our hold on the tpg and sessions and userspace
+	 * can free them after this point.
+	 */
+	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
+		target = i;
+		tpg = vs->vs_tpg[target];
+		if (!tpg)
+			continue;
+
+		mutex_lock(&tpg->tv_tpg_mutex);
+
 		tpg->tv_tpg_vhost_count--;
 		tpg->vhost_scsi = NULL;
 		vs->vs_tpg[target] = NULL;
-		match = true;
+
 		mutex_unlock(&tpg->tv_tpg_mutex);
-		/*
-		 * Release se_tpg->tpg_group.cg_item configfs dependency now
-		 * to allow vhost-scsi WWPN se_tpg->tpg_group shutdown to occur.
-		 */
+
 		se_tpg = &tpg->se_tpg;
 		target_undepend_item(&se_tpg->tpg_group.cg_item);
 	}
-	if (match) {
-		for (i = 0; i < vs->dev.nvqs; i++) {
-			vq = &vs->vqs[i].vq;
-			mutex_lock(&vq->mutex);
-			vhost_vq_set_backend(vq, NULL);
-			mutex_unlock(&vq->mutex);
-		}
-		/* Make sure cmds are not running before tearing them down. */
-		vhost_scsi_flush(vs);
-
-		for (i = 0; i < vs->dev.nvqs; i++) {
-			vq = &vs->vqs[i].vq;
-			vhost_scsi_destroy_vq_cmds(vq);
-		}
-	}
 
+free_vs_tpg:
 	kfree(vs->vs_tpg);
 	vs->vs_tpg = NULL;
 	WARN_ON(vs->vs_events_nr);
@@ -1754,8 +1768,6 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	mutex_unlock(&vhost_scsi_mutex);
 	return 0;
 
-err_tpg:
-	mutex_unlock(&tpg->tv_tpg_mutex);
 err_dev:
 	mutex_unlock(&vs->dev.mutex);
 	mutex_unlock(&vhost_scsi_mutex);
-- 
2.25.1

