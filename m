Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E577EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243212AbjFNHV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjFNHV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE120295F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:30 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k6u1015552;
        Wed, 14 Jun 2023 07:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=q3Lgco7wqD18t6/6i4FAJLYtfYYJ7t//4yJltDwkcaQ=;
 b=c1js+58eKgDY+cRrgGDzgOodfmbFzrDa2PBd3cQNQ7mKpn3lXoyaiUzQNZ/Lq9JO9eal
 TIszCiIZJTBeBe4TVBeQqrh+crpq0UHOe5pDA1CB2tEF1kN7mRB/53dA6tGgQ5YoqGjR
 DaGMji5r+F6bsdpCuuPQDKPJO4hc06U4J8krtarc7ZB8aJCjQR+MnmD0YAobJiFZaH9I
 uYzwDLldr7CebLEgT9+QTwFMQ8khTCSvVtYFU0Mu99aY7/jhxIx876gy94h5XyLFzWl8
 6dUBPu4MjJJGPrk0H13JYUX6JLJJcuH+zjyQVbOXouF6h+EuGAR0PDEgWVMKusKIuoyQ kQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2aputa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E51DTH008450;
        Wed, 14 Jun 2023 07:17:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmbexd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iscN6WW1PNFpa6cb8nVIV9kmpMg2sfiV7xDRHEgbajDerADjoWoyJfx4+19dwL7Q/xZ0h5dBQ4LhOXo6nKlkiOiFHhuJJamfYAt/1zn3r4kcuo6HFDnVH12DMPk9XLD2NVYFS5456ByWSGg6NTVwFz9eIiJpK7uHt7nnVqqdeHJW8u3AYcrpfvRObj1xFyrc9HHbatgd41Yzum9NSbpGycImnff0tdZ3oVt1mz0DhU+4QuHU5SSiOdWGtvrTJKgq+dOV1HN0c9FrW4xkCjMyJqRzx8Mb0tp6H8IB2UfloBpwIAyk4pEXpMqmGrt19xVG/uNp+EWh8X5SW8+US2wQzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3Lgco7wqD18t6/6i4FAJLYtfYYJ7t//4yJltDwkcaQ=;
 b=cJ5i1VYvEoTQJ65e51ZLXFZHesrqM5TmtC2kI0vDEPNn+NXKivK9JwvisYSKIoUpLTgR0hsz4f4dDg3EnPrGs1tbk5wP8F5wO+xmLuthFuSbvwS37oAZM5RS6UfSrVDbczWwaWqbXgaLfU+ssr2ubWq4h0W1X8V20HMxi0jIEvHMLp++hqK7bhjYjjpbA4ZWERGe5j9uZ2lYXinzrzDt+KiHOS7xWx6snfDUx6AIhYXy6cebYuTkE5QaDLsr3YQ7Wcms2/prPxsk0yLO6JPLcJJGhP8xrpQemMKvHWWhk9djHv33SADKz5lXVubxBFC/cesAR3Wps/OfUfQj+7V0AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3Lgco7wqD18t6/6i4FAJLYtfYYJ7t//4yJltDwkcaQ=;
 b=oIItIjOqwli6uyzn+iJY1EkxVa0LzVNKz5YIGDbv6MnEmyOSu1ElnzjVZdVNpzwLY+4At7mD/MR+TqzdjnaXfFSSMAD89wIWNBbu2/IzVKi6Bmxz3VmbYBLsw7NKdndXT/eUdX+nk1JpvZUL6DLr1E9wjA7GaD/GG5Ujq7Xg2Yc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:38 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 09/33] scsi: sd: Fix sshdr use in sd_spinup_disk
Date:   Wed, 14 Jun 2023 02:16:55 -0500
Message-Id: <20230614071719.6372-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0020.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 259d41c1-0316-4635-11c3-08db6ca76f50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFW5/7xX3i6lDbSar2UqcacXXYvIIzKz5bDL+97jThGR5V5N0hssWVjk36s+uULh0zYdxxxTg/yr3MZ8GinxqNnw6gSsofUDubDRYvYYcgtglaGMzKAJR3OAWG5WlF0lFukFAKjI0VLs9+8y/EZ7SF4XxReMQVFF0VnqqLmV73sGjYYpzx8HP2S8VsGWVNbx19vaIQHh4uOMsAz6WzNWVVO30NTg3qs/CHYSxei4sn2P4nBJIj4z6NgergEJVh5TzpjhGNjNl1/PYd1xXCGosQloOGfAMKjumqCr8rp7daXOgxjCe+xISvOuQPz3UDH9uevIQHVLuGLIt/a2Zsz+l3pkm6b7OQPkQaVA8+jxKHRP8zqBqcMGrjQEXx80PHGIAeetdZqXs8ya97AkJFTZMbZRXXYacJhTGacMe4Tq49eECuu2mt6ObBgcQgJwqcsEPnhZWXizrw93EZ/Y4YKlVN5Y8o1J1Cta2694Ayt4ZXklOUFiJ7c+NxTXq/ERjKYQLX75rshoS54GBYzZe/8VEujLTEvnFNTrHEbvYeqkTMXTSyj5ILV5/ux6cVJd37No
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FttiJn2JvQTqpeMk8hniljz6qqKOxOd6v0Vd5Z19PJA5FMqzgHhicMwH4lQt?=
 =?us-ascii?Q?DMI0e4sNTqH2DtEj6k82nISElOpRbCqet5mj/y4iSMqZxdvtHgqUYUBRKF9H?=
 =?us-ascii?Q?9kkyUE92RiXb+HmsvuzxmV5mOY0kbqNKejH3owDKRoX9CR/EokufYoL6hMF6?=
 =?us-ascii?Q?O0ySktde+jp5AV+HIo8Z85ScLpuKBqyVTwHHbSt5G6HWl6qmxgh5tssunTIZ?=
 =?us-ascii?Q?5eUeQ9L97g8gn5h62FosIYW1y16yBQMJzPODTrXsYlZseSZZ4q9YkRldJ1u6?=
 =?us-ascii?Q?VZUrE0VL+CrrFVahiCPvf4ZuxmBYGVnmfkFo3qKXdd1nSwf42WR4fSGDmWBj?=
 =?us-ascii?Q?I7UASghiOuen9aysjcgHyvZUmthDXFu5Pp2oTa/LFibp22ViWxlaGj/1snez?=
 =?us-ascii?Q?HwW/ernnrgFpKUYuVbih3q10BV1U5goG7qWatzOM0EvdW0g9QjgiWI9hkNNL?=
 =?us-ascii?Q?H9mcNzYCJZ4kCYoHpbgcnT5K+9TyQk/N76s+mY4I0bDRFvl1HHI2EPeu07cB?=
 =?us-ascii?Q?6hR/sl8bM4eHOAVjNx0eM3XgjUemueyxuIU3TmC52Zz21nR8h6RDHexhP++3?=
 =?us-ascii?Q?EsJy8GwU+GYK9ql8LXIL6XhNAb/p6mOXfWfXTLryIxnvmOFMID7pB0pdwM0C?=
 =?us-ascii?Q?CHip+WoAIsTwpXMyRyO2GWDmVG4KVUYZGOpBH6DbP/jONV7bMUJFM4iemgKQ?=
 =?us-ascii?Q?HQDmpY4K4SmrTWlMUpDpwHnBfanEiMACTuwUu67/Hr/TbwpMmrc6pkN2QevY?=
 =?us-ascii?Q?fRvIQFBWhFZnN/iOE3m97ta3jZIxEzt4jFzUP5J4EGouu6yfelZZ5Gwo+rMM?=
 =?us-ascii?Q?vesmZgUiw0jCf+SFOr9fgasg34Ik+tkCMT+AMTfFY5pTH6Ej+G9vY8iLoOCD?=
 =?us-ascii?Q?sOnmJhGx9zeYPAbqvNiiXXX+1wX2ZXWlsDXs5n5+IcoEp6+n6lxO/J6ByjP9?=
 =?us-ascii?Q?sb4RY+sH3HprhvniIMScop0jbTHfKTueIIenT3uIDSA/ivBPy+G9JzA9wgtJ?=
 =?us-ascii?Q?cB5kx+goxQuYPqXVQkPME1aNf8n1t0R3nEquell3nBrrCEkP5KrwI359rj9H?=
 =?us-ascii?Q?zBBNLqfZZ+9ySi8vwoBazYvs7n4VqpMer4uqo/+n9M0TjV8bcXnG7HUoy7sy?=
 =?us-ascii?Q?0CBYl9Oj7WyPDC1GrMdKyhFCkT8Uhuk6EwUZrvavK9iG02GhictcO3723BOp?=
 =?us-ascii?Q?o2B88tPkxUXei9FwEmF/PX3ALXCsUKIuJhExElMRrYpjbx0UHx5d5GEE5kwy?=
 =?us-ascii?Q?KO/ORj7ir9Q+GYtz6n9a7tw31UTp/18yRDGHCFwNyOo+CfGq/w0tewkjj56A?=
 =?us-ascii?Q?xDeestT+1EI4n1ZLUJjlf4HREvPcm2+L2Zag0WBEDxnwsbb6lrTRoeEk9rdN?=
 =?us-ascii?Q?q85xNRD2XAk8s1XE0H9U6aUA2uDyI6Au5aN6ZoVcyyg+3b3+qbgfVcydLWxX?=
 =?us-ascii?Q?1ndJ5mNoEMg/j/z4u6kurLdXxgw+LUMGMw86veIFmHulXALEjA1mEuA9pGy6?=
 =?us-ascii?Q?Mww98eN0buIHNGpnunLlfLqTTATzt64ZHVvNeg8qY/3QylcGWPttGE1es1Dq?=
 =?us-ascii?Q?oRrUmeH0cxlhpSgzEWHckxIxwTmy/FJ13L8MYj2b2r6Mbm/BoVr66vkqQvas?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5A6SiP4bKr78ptUGyxGszzQfFYpuQHcSffxHAUdmZ1Dea4ZlBaXqTsOsxs8mqJZzMWK8Yjyl50UPtuwX0jXbtKYA282zz+c3weazEgB8Zy04rmodI6q9kYHcuaiqvxMC3OQy5RcMO37zIGSjlJde4qRsu4KCbjCiKtNfhLerhxI+dWb4ZQwsyWKZEYXXfi2040ZhfXXG+oHr/GLdie17fIQ8VdqQ9pz085PgZnud1+tAqyi9XNRS/OmKi5h0mXq8i4/M68TGjS2iJrWrUnyyjdD7ADjdJtvmzgcL/h+Cc2e1kM3Dtl8LtQSg+ouTnnVicQYyxfgFNPPZZAs5/UYJApA+YkULZ/CNiRfjazBIFIosywKctnLG9CbHFZceAIZ1N4aX20/6wAyUTwltAXn8I9oPWd1CRAPG4bALEwBK8q0FOzUi4yP2XE53Pu9KoLMXrJk9qgeCr7N8pekYnTpj8ADvC7HSIJgRY6c3t/fHIVBb11JUHccD9y5OUVR+bVrzQEsovLKhNUWiZuQBl3pt07UI7CfaCoc4N5J6La46hivk74MYir3TFQPm9OKO37FzjWkXWXWGO7Lug78nJBDzU34q9BnK/JphLoo2Ur54wHwJVLjljyvZa4J6wcxEH6qIjaolJ7j+TePOIHskaILYsUBYnkWxGDk4u3/tYWt7ONtvSXFuhTk5ouUJzAFKZtg+iznCFsJernhwBUmXz2AN0tbwO72BYZ6M6OfKk32JIwkvFUgIfHlEeZIA1XdkoUelXxVEUndC4UDITyEqQroIw39bdgxXoRGjZ0YTzv0KxPlO0iuFG1ub1sxT3F+9YEolKTa/IbRrYKyAodrb8s46Aah8UxX7/QG76QM8WLqQlhEIJjI66wVeNyvAH+BEBuAq
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259d41c1-0316-4635-11c3-08db6ca76f50
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:38.6998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hZkUqqPd8B3lkEY5cVUoOPz0iOtJ/U9JSWvKdabecXxt7UxfQgMLX9qMQX2jHAKvgDUyVwJ7/PI8dRKbfl5JlC5b5JRg7sv+FuQoMUNREM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: 5_OLZtBtoCNmVQUEjvxlJByzAFtCKhBF
X-Proofpoint-GUID: 5_OLZtBtoCNmVQUEjvxlJByzAFtCKhBF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the_reset is < 0, scsi_execute_cmd will not have set the sshdr, so we
can't access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1a1011a8ae53..e34cc9daddce 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2220,19 +2220,21 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 						      sdkp->max_retries,
 						      &exec_args);
 
-			/*
-			 * If the drive has indicated to us that it
-			 * doesn't have any media in it, don't bother
-			 * with any more polling.
-			 */
-			if (media_not_present(sdkp, &sshdr)) {
-				if (media_was_present)
-					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
-				return;
-			}
+			if (the_result > 0) {
+				/*
+				 * If the drive has indicated to us that it
+				 * doesn't have any media in it, don't bother
+				 * with any more polling.
+				 */
+				if (media_not_present(sdkp, &sshdr)) {
+					if (media_was_present)
+						sd_printk(KERN_NOTICE, sdkp,
+							  "Media removed, stopped polling\n");
+					return;
+				}
 
-			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
+			}
 			retries++;
 		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
-- 
2.25.1

