Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47336CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240114AbjIEXQU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbjIEXQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:16:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78899CEC
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:16:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385KnmCn009395;
        Tue, 5 Sep 2023 23:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=d8wdGjs7rwZx7ffAWeXlfWGG4DEo+UtPBzEVKZKWq/c=;
 b=k3tpnYeS0Qn/F5G5Dgpm6/4Vwj0Sg2Cmpze+wP1FLhNUvIrrhEi24NvqdMWYYViTn5Qa
 MLIxrobgux1GP74i1TELRSIDhufx0inBZz2Ypfo13XZl7jQeaaRQGtunGCDmZXbA99fo
 TzA15RG/CmPlP+ad5sen48qigoABCTbB1gJqxMtXgTuQnFSpbrfZbFYwDkG9YB85D636
 OAyaL4+qw5n9yHNiC3SFcGsjsvqsOJV4htYXXMZe4LOMd1sw2RYbxL1ofeU4j3z3SUd5
 3TtuaTUeN4H1lQeKqHXIPj/abHwDJb1Adnh1IaViHco/7ooXnokcBNJ7bKUJf/NIXxDm AQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq388x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LV2Ud007675;
        Tue, 5 Sep 2023 23:16:02 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5exba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWpw8E7pMK83MtgPd2C7Fa3WFYgQw4/vZM33HTG8jJhn7xT2Zi6MmrbjJFGnlby7LwF5LwIiWcwXiT6IOd0UUZOauY8jx5sW4t6PULg4d9cUpvu9N5ZXysUtqVo+WLVe5BPP4YGE4Ltg5jCf7dTOxhYCW++/GDiDFraqU8o58XSSrGnyA/gaSSFHZRVWvwDRaxSmnwmkITRFaeINvzGdPH43c9c56ouLrsKe/n8Mmx8XYT3oRb4nMqnsgcSr3yC5jZ4QWxSlrMXaXRajN2P4Zgg1DpK71Got5xPXNmTXQ90bYABYzaPmRwDdNR2Ce72K4X+mDj3nzCYDGxlyX3lhbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8wdGjs7rwZx7ffAWeXlfWGG4DEo+UtPBzEVKZKWq/c=;
 b=AGVfrnKHhjdS7lmRCSVicQNxZSZT+MIXYDAYhTJDXY4yUJ41qfSj0G9HVlONrFjmvmk0ugwY60G6ymwZnrvXZOVuBkhWeaPYRWynRcf3zj9jo6rKqmI18PicO3KmJKit7sbBuPnY2QEANWtLFnPduwsAqR+YpLIQa747mnGAOrfAMfnW9LZqwhzKjAPDxxNw+ctm/45JeAt8omDFlc80qt9hNs1/jI0h6vYRUty9K2klgeH93z38O9iLkkQedHuOyq3M7QnkWvLDwFexc6tIdGs/c4mNu7fE3RO1W3ULJ8zbbBb7jA6iHpSURfA2WyKgH48JQJCz8D90S0Gvzg2a/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8wdGjs7rwZx7ffAWeXlfWGG4DEo+UtPBzEVKZKWq/c=;
 b=r/K0LgZ03MPW5Mb90lJEDOHEcNrYYameY9PH54OEmllOkElf84+oItwrTUrp0ID5MDp5eld2MvLL0lzdHihE9gpZM5n7xysmpyPqikMErcSrCGNV2MrLvBYMV+78/DrNXcBM9diZ2HPopCFQsvnS3cnX4Ij9DN3XgdVhfIlOWDY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:15:58 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:15:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 06/34] scsi: sd: Fix sshdr use in read_capacity_16
Date:   Tue,  5 Sep 2023 18:15:19 -0500
Message-Id: <20230905231547.83945-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:5:80::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 9de03eb7-5d9d-4ef6-8a87-08dbae66102d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+qE2PAf0XcjPHH4PIbew/uuPLgi42umEx9yga41kKtcYAxHesACuFV86cSNcQrVYwDC39sfTHnmUIn2eS2qQEwcatOWbm7KTPVLQfA+G59yIosybf0T/b8UU50edrrmaVHIrwYrQWgAQ/WGK4adzq9VnPYR2GI7iMgmzDGqq22ovR4bBXv3UL60BrcunyW8BJKAAbNu3r4DCr7hI8A+iAwXz5jsH/zTH9f3E8GkiMt8BW/5zXgnKLdEfOLXfA276T7AxiwCVzkJm65zJuLEn79nU6+icU3ZT1W0EoeY6bMIrgTWaWNYgUTZRH+5Mp/ppnvWWaVAYvFo8L56ACDLnG+yVlRWZMtinTBVFBP9LpH9WI5XsHE9sYvWMB/hrsJk/dt46+dQSRPtj+jyEsW37h11NdBYqcBbLhfptmIxFwkW5T+KojUnFAR79m0/eIyuDXZp6oZrr3bNAjlxJJ6wCaUuXcvyILzT0NN9lwLQOMB9KF9GaMavvG2hYhaZVcSM5+VOfdcIt7qJMMT/xK5dqyAYWS7kcUTkAK0NBhL8Tng=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ltpBsoQKcakueueokEdftnsW+n3SBjOwlT3q2DFg3GF07IY4iwV4VM+HpAis?=
 =?us-ascii?Q?c7uHV/EB4/WxttC3HEDz6S9r9kgH+0nAXYkBpHldSAYFg0TGaW7l9nshVPs5?=
 =?us-ascii?Q?o2k0bAXQK3NBhZrqe+K4AF42YHHWCJm4XayOKWNsyxq2d5AI8wFmm41F0a1n?=
 =?us-ascii?Q?DVFJV4ud/PO0mokkYdiEJqGB0eSenw0ldSNHygtPc33HVjuKF4689QnJUhZz?=
 =?us-ascii?Q?E9ZNFFcqi8YZzCWrdSFRBZiUmWtAUUyafhrpnTStEwF0xNMNtvvOJ5kfXavU?=
 =?us-ascii?Q?J3thEaKqKYnASs4E+CusNIfYhzmMsDuf9/HtpHmq4Mx4n34oVmvk4Dn/CTL6?=
 =?us-ascii?Q?Ub7H73SC3mqFZ44fKAqcGP5KSoHWvW547+y6E3vNVuoeHQa2CyR/sNB0ix1z?=
 =?us-ascii?Q?4nOtweSLahVUawFbmzNRa4dYyYPWq5AJvEpS+w53jFXHRjvo4l4WIjTgAoIy?=
 =?us-ascii?Q?+FsWliMkNAbRBmMpNZHoN3fMRFOcy/VcvIgMSItjTw6alJKDqCYR5GxXHQ8h?=
 =?us-ascii?Q?nWlJSINqE454/p09m4CMfvrk/62JWoHqnKFU0BV56dNNep94yKU06cdygdxz?=
 =?us-ascii?Q?xqUKt+HPCeDjwivh5F2YYq/QIdsUkoQQXPKlKPjGQtffwx9hhHPO2V6b4ksg?=
 =?us-ascii?Q?WJ+S1Z3xpnIwZZFrIemqwcukKVwRXN3/JKdWD1RjK70P+YRgfh5dmZ62FvSI?=
 =?us-ascii?Q?wH6RWwFW1/QhhdS7EU8Gtc1vNOZX3USzOsjDFXWMvZnmrqdg4YQEqOlVsBcG?=
 =?us-ascii?Q?XHhypCcTH5JoqKoXa0bniuUrSWxF5RjsIa/B6upgmUEwg83Ix9leMN6BcGYW?=
 =?us-ascii?Q?uwPZeaQFt7LsUo43lE7W9nKLh+pbQHktw3JNbplcb1OQXbvnQws4Hq3EUnAZ?=
 =?us-ascii?Q?GuKwy0r/nW5flAa2nmRSjOHZp6UzN0hOJff3+Az1F+oORELz1twJG0OXP3sS?=
 =?us-ascii?Q?1HXOka/gFOYAKkjxX/7PjIrDXTX+u8Wm/9vtfVD5kWH/+I8xo8E1/zaJ5CDV?=
 =?us-ascii?Q?8VFeYaRaAH8cAFEBaVa2zp+kjh6AkMB5teqQXaNBCLh79TsPdmckmfG7RJTO?=
 =?us-ascii?Q?bLn4HOf75NAVoHdvaZ4ayaNrkMByvEidRDvAtkBvXRcsnl63L/+++YPQbizr?=
 =?us-ascii?Q?SHMWvUhZybPCJPQpZgaV/IsWx+9chJiWe2G7frR1NoHfDv9qzlL0EKJmwSfx?=
 =?us-ascii?Q?F+S16nqElj5trEOKxs2Bpwot2DBBwPuc95Sd4dO4McJE11HZodEBRry2zpKS?=
 =?us-ascii?Q?nQEoAHptPhDaZqScEcWTpcF3IgS1HC0Dig9pbiRraox3MR27syliiuGREaDO?=
 =?us-ascii?Q?y73OMg15xVezIcCPsosyVLAmmcbejqoVL9cuQf/jJ4+5aXY81rqsPqzKQm4y?=
 =?us-ascii?Q?+0No2sbsSBwf18c7lKo6a0gAFhOjZEXL7Jtk8WRpRcj90bzPw78nPAoObmJ4?=
 =?us-ascii?Q?DKubTi8LbBn4xk2Pn1ta+KBxT/WiYDIAZPW3jYi0U0GGobDybgIPQZy+sNBZ?=
 =?us-ascii?Q?6ecWokknzyc0Swc7dDdSnJYR0mHmH/BlQ1y3PYMcitB6Xr+IWiX8DIZMqlXO?=
 =?us-ascii?Q?ZEpuVlF6uWntrBK4ggFb7Hudne+Euhj3vjjx/LfdaROSCnmlL4hWOalScWJ7?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: csDK8C9XXeiknHzqcMHgx1y0l0WgIFdwNLJwg+pjudwsMTxBn1qTCGqjW1GhnxcapOzyMFMyNyQxT8742RfgsayK7utoDKRgRNJwviWpzdkZ4zswiqPORq2rD7Cxiu+2b75OEzQf4qHtHQrMDzK0N4B6aXlNM9pYBhtW6an/WYplQppwH4k7ZTStIkZe2r4HzviW9r+EuTz8kHoCgaLn8T28DLIOU+kmypyr6/EXfc9xDcVc3lAQDbNK93/NmcHUsgD80bJO3ylytpsIhmkFcT+Q8Twc5kok3/YKxtnuPRAcKnqd4eAx59OnQb/Q4R/BQOIROgg3Dyq/exGw6RYFvuj8v7OLRM6BWDq6zrrxAfTdt6XybfBzEDzyWuKIRKaR7vqJ4+GFPCUUWv4NugVwHmuSyrV8lCtZQyWCh4S/F8aQoQmNt3yXu+4WJhdaTocR6D0B6sWjBhindE3PaROelYGh+yLGtNrEYBGofBKiNFnCaZC5WqbPGdTIEswKa94fBp61jRVHqngxr2q0y++BdwAtbFvJ0ppNw6QVCe4PR5EoW1nuHO++VhaSBZx77sKXY6ZI3czgB33GpAK7MEc9ocL8dnxusNJ10JXhaxe35H/nbHmhjUcX6xct0cH4OAMf4gNJfKH90eu4nHRZ7NbEXAVwFhnOOODuNr6GiR0Rm1jIGvd/uAlskE/wgn1wR1bkpLYM9p8s+tgw9gAb15MyNjA+pGJM6166fRdwpGtfjFWmg4h2WphAbvFNnb4DA4lRKZA2fMxot7Sc1OHasG9YWxxotEGG3A1qeMfa0Z7/lcaAjoaiTsyDlFJ6y6mFIuewT4FVH1fnPGalkjZhTJae36y0yP311q6biufxOoa3c2ESb+8M1m+Wg/viL04Rffz+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de03eb7-5d9d-4ef6-8a87-08dbae66102d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:15:58.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHL0aeRmZx/NQTda1BTidq40ic2FH6gr7CnfhNzLm4O1Sn0iIEUFoBIhqZK4wrgqI25Az3Asg47TVx5Keo56DE/P7lzfjRVnZyHSfmCYBxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: Gou6zn6GmYkzjVE1qPOPxx6deaKDAzWG
X-Proofpoint-ORIG-GUID: Gou6zn6GmYkzjVE1qPOPxx6deaKDAzWG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4cd281368826..70178c1f3f8e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2388,11 +2388,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
 					      buffer, RC16_LEN, SD_TIMEOUT,
 					      sdkp->max_retries, &exec_args);
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
-
 		if (the_result > 0) {
+			if (media_not_present(sdkp, &sshdr))
+				return -ENODEV;
+
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
-- 
2.34.1

