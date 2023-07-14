Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D31C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjGNVhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjGNVhr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AAC3588
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:46 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4bbD014922;
        Fri, 14 Jul 2023 21:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=lhqwKUhVo0nv0zUMT0iBk2OrhAmvSi3FEd/mIHhXiWw=;
 b=IErDkrbaEGqtxXTOLPHUU//zvb+GwjNs5zjERXZFuYc1fyxZ90ohB5Aii9RiQFW06e4O
 GMUlZK3Ej7Th/QcZsNId74Jki70fTezY3DxtVUBcyat4/MJdjQzcovi9wIuuLfsoqG/g
 F5SCFsGvcLOaBG4HHOTxtAqNoUSNp98qWC7nsYkEzTQ9ZRn8pmF1TpRpLOkrfwGOL/d2
 HT6fWraG3lestl/wnT/geAOdo6ztBt0nDlg+Xv0gfVmS0+qRBR+CR7y4LxjW4d9UHfyJ
 USDW+YxaBPvf66hkR43CIhLF/xIxHHUYev7/60MUJ0X/5zUTe9SKG+eX8n1vPp0JTl6m nA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptx2f62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK5Iqi027199;
        Fri, 14 Jul 2023 21:34:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvyh6ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhNTJ2tcopcudQTqYDcBXpmR2koFiIYmAxNUtCZq5WhQFTTPIFm4aPjPYLcpYM/eTXkvdYn/MlGQ9Qk5CyEI/AHKmND4AY6ELvwpZ5yAzPA9YkOWkrdwBvg84Pzic4pYznWbBFB9iHKEM46QFK8viz09MPPlZlI5L4FEoYT6pzFAKWDRCNyNdSYVQe7BHo7Cpwu2y4PKdI7VSyGc1UnjbAT5ZiiQWXS3kJFck/9QkO+l3ViF0jf9g0gX8gwHK0dy5sN9ZRRtTpVA3LrIG3ZvY627Vkf80iPohNgy0MSLqwWnMe+pXtvMkv7EFhdsOazyNxTX7fJe122YLcLORKGiAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhqwKUhVo0nv0zUMT0iBk2OrhAmvSi3FEd/mIHhXiWw=;
 b=iBUJ8YKSNUk6mlvFiERjO6N9Mfb4Y7kju97sslGAEn+y8dc7nMd+j4P04AL8OfnmB+D1nhFZ1Aeft49gyIr7uLPKAD/8pzmIQllkJXZmTXfzqtZUZFBH5BKB4LJDSGvvoqtemXQzn/4g1nUtZSfk7sssSaT/zDtfzSjGXgRfFjlz2iz2iHSBQTKjENS0BPoL0c//K8+uFZPcsTIvABkPR802LP1DPdPQwy+56jcNFjPFg6qtsDk2zA8is5/E1SF3UGRKKHfaJ/L3xGno5lm3HR9zBg7a96c3xHFr+ixcYZMOgfgghZsozVRvkHTib/F/hqfdV1qRrPXfdGw3kqXTMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhqwKUhVo0nv0zUMT0iBk2OrhAmvSi3FEd/mIHhXiWw=;
 b=y1ed2QXEXNdBc5lJtt//42P3wSU0pUMEkerAibPf46qBu++pmDy1+cRgxmeW8oZm7NbMok6Ki9gXappePCzRXEP3uhr42B/lCR1dKWnoHLAcBH942W3zsW46DpmC1AWukIjqQfqH+gr5XVdqPrmuIOHiOYg56Npo0+VMClNKKFs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:37 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 09/33] scsi: sd: Fix sshdr use in sd_spinup_disk
Date:   Fri, 14 Jul 2023 16:33:55 -0500
Message-Id: <20230714213419.95492-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:5:80::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 93019a78-7b82-46db-9471-08db84b21f8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: coh4V8dZKAthVtx+lt3/JxRpFTw1OariHKsIg48ip6sUx1KU/q2plLOz8dq/vuwKfI+6mIFaaPNL4koIR+17xb2hI9ZWk3MP2tZzwOhEhXmxeD0nMo/v2yk/T2Rwac7MuYCfv1gUwgWNtng9Bqjp5LgNrQGJ5gpbGhBahvivSgzvktkrLFVjeAvpWTfbZcRAJmBjlT1js/keJyAT6VjD4CddTiX7sd4zZtPlsc57lk66ZDaVaQBFvxmTelpzcP9mYqqkMa5b/jWOEzeB5ctU0v7QiVynFWBq7mnVJrIya24pvD6laCQKuOHO2rE6zbxDCxwwO2Sy2xJp3re7nRHLplG+cK71N+6Cku64n0yReCbFy9jRYa4JiufUcmQiakhhlCUbAWQxyEoujcf5NbR0NfqtvN+qEMV7v5t2hXsxth5ZHoSJfji7/U3PiacVNYBInNj+rraWEyneW6repJOSvPkGe1I2tVKXKmu8XyyC+GCltHfr5Yu5k01MJ1Ud50kI4CgD4l/MvZqRiccm+4HZMMjIJOfB2e1Bwk6L5exvemtXVbrHZMhH+Am2Q0aeClMO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0kCG2XV/+dr/vb3qLS5pf7a2FVmSZOmD68X4uc/IqWsQyaOxi2aZ6mdeXbPR?=
 =?us-ascii?Q?7V/G9/ZqJkSiJ5FdWtJ5fJ7gDR56ULhVORSA51D6d0dgfL2+u7OOw9GM07lu?=
 =?us-ascii?Q?TbnBmHh/AXdvNByU/4DsoBWGjdIFNyycoXpeMW9DGE+gceMs7ooPGj9xPXzf?=
 =?us-ascii?Q?gE7yi7nJe6ciMXMKZUD+klcwc3sWCCdMqEk9OI6BfgRs35frGgJlwV6/tKuS?=
 =?us-ascii?Q?5k91vbSvzxxpGt2A8RHxaqblvAFKlwsMiuPrgWLB3oK64dHUcWlILzwnJB5O?=
 =?us-ascii?Q?W/eu7/k+QWZNbKL7XMFlMRPjsuwt2guK/RI+W4+SVaBGdKtPbiKvQ72djbl6?=
 =?us-ascii?Q?+VP8NIfYAb1/2/DykJipllepf/4XkmsgO2rTo8h5EvIg0QoHry0uG3c7nicw?=
 =?us-ascii?Q?1d4OxwWgHMMaaSOk3KuLcwsWX0rh7M0t7p4PL4vArxorJ8OMX5UUkGXTq3co?=
 =?us-ascii?Q?SHbML5oxYRenXq1jxDWihDZ2Xa6+PkK4dbtVHQztjfjdyobmv8EVOVE+u/Lu?=
 =?us-ascii?Q?MPkUO9U9JuLwL+Y7D2hKhPvP9I1rTOkqwFsj4uSYKvismygGobryZRZY0E5e?=
 =?us-ascii?Q?eHX8V48s102D3qFGlAWjt/dTUg43yuiwdJyrXot0OjKo7obvbYQhNoU6zBn1?=
 =?us-ascii?Q?RYjGj5X1qm2sVyoeZXj5OWbmWGl4eOzcPhUpxML2UKqvNDSETUwCNae/efl0?=
 =?us-ascii?Q?TuzbNuiEahphI8Tc/Qou6nKXXCzs3w+16B50eWZrBD15witRXTIaPrVmHRPH?=
 =?us-ascii?Q?U4WqJDywnkzVmbSHsZdWHn+RjWfmoOzY9rqa1dK/RbnXQoUkNYhx6jjRuPDY?=
 =?us-ascii?Q?pTsRd6AOcTwaD1UbJyCP/GQ81rd3xCKYkDo6oc+qqwEoIIt0qEJ6qD2CnNJj?=
 =?us-ascii?Q?DixWt0AWeZ/NA25bbHsywUJqmNWT35K4tq/p3l5VnN30Xh32g266XnQChZn+?=
 =?us-ascii?Q?W+08RMbklxKoibNW7owxtZiS/hcNk7QR3goPsq7bs4YisJvm23yqSugoznMi?=
 =?us-ascii?Q?VLku4Fdfe4C9a8HD75kNu3BCQHQwR5Y00Vopy/tiqtSyAtUMAjUnGrcyoQYU?=
 =?us-ascii?Q?qpGKghunwdm5Gz/4cEs5/G4zY/0MrpwF0PmbtHOTWXNn9gIT6jg1+u2s4Wol?=
 =?us-ascii?Q?yreav5Bed3IyCu8E5ryDiexexTaM8pvzvqOiEf/pzvgL62u2LyO901JTMRol?=
 =?us-ascii?Q?GCrYeEiZgFWdVcXFvPEGVwKULJYH3/+HBuT/W0wC7gn+pfDx1oaJ8Ff+UORe?=
 =?us-ascii?Q?+QEW9PkHvXIgYnMjwIujJAYPzUr1kwP9eyS6hL/nnx8wc5UK2Be5+8rCUSp+?=
 =?us-ascii?Q?Qc90NWN9J8xSBgMxjLDzsytafT9KPfVoQvi4HpGWUrYsKV7BZ96WNRkDtp7c?=
 =?us-ascii?Q?oYy0vEw36fPdMSixGaBLrySsi9MrDJAqfNcBboJliPhXum6HlWskkjCzLgkj?=
 =?us-ascii?Q?lAVBfp8MJwW8zOertP9RMBhuvsFPH34g9aldqdtTeSbyAKpvcwabWPE22e1m?=
 =?us-ascii?Q?a/ICGvYUhzOg2emBMr+1WeBSp3DI6vYQAQ8hF5DRCh2r9FiMVqHkiE2i0xKD?=
 =?us-ascii?Q?1+qh/5uCDmQR1iB6Q9Q2BhJxfwgxBTMk19Y695X/Zw2/dR18LwzA4d15bWNB?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gJ+G2EDPj5yqWS/mslywJo8a89rJMF6LN+M/0PMfZcw92FxmoeByEhelWmruGbw9GGa87k+GHTd8+taq/ICucDzFUDPpvTNUwOLwrU7ZZK8ZgnDn1giTx7Q2J/PNQxABSlyfgh/4k/fmG3ZpntEHPMvXwTXFzb/fWASpcsqSFuoStSqIBOXht7h2q3nRDq1BO0qdnlirtAnHE2GhJZfjhiKf5rXQN8gvbHnX1T4cHzyF2ardeQX7xFuej8ka4TDSZi0VDx0sFiRrWYG8WWP3jNKguQ2Fql6dQm2WE19LgHMRlFfwr8XjcCKWQvjYkpZFoZZdke5k+0isgleh37Q+PkJRbtH3yb7d2ClNJvBJpj3Qtj76S+9wD79JXC/uju9eL+uASh6aiaKeBQs8mEa0GbH68Z+3q7Xwso4uGwWZ7J7H6HycSoEqb3UdPlROLH2hIxvlSAttvKrr3VZrrHSW80hp/YCGpLf91pwRw1CYe9wg1jApdPCQcMbGzfIMKsLI6ToZWrdOCuBZX5207bfhUULwZdartydOO2Fr5lrH3U/UTMHY6bj/RSpamCNuROI2klqO1zzoFnYEXkTTyVT37H6YePz7U0zNaB6/DPFuzybe01D84ciUNLgvrVWrpsWz9q21achUAzc2JPcd6uGTahcUD0grRg/AfOe8UwdF+fbOvo4GINnKmEmtizJ5SJFsJ+AdhwQLwq5DXGCMLUds5BqPrOnhR5iIKeU1OMcLRCorfq+I2KZ/kE3KjzpzePpE2JGhnGyvZs964S7NcFvMl2IeQ/VQsdAZr+KyWmglLgRBX+7C25IDol2bL3O3yTLES0GqPFU6bm+M1Xou8QilUlOuRyFcxJTLpKqWiBoMgOI9HApZNdjMfeswI4pcYiJY
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93019a78-7b82-46db-9471-08db84b21f8b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:37.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9v+MCaWnc7TuS8vEscSJSfsufiY/6ZwxCq05rdSuNrQFG2+52Donhg9QvLgO5gK80+w0y40srrjDe4An8K/+sS9xVjj6N0XLBgZmB6Etlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: 6suIGZfvp_j1x4PfSsP0nElvydmtxC2u
X-Proofpoint-GUID: 6suIGZfvp_j1x4PfSsP0nElvydmtxC2u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f75e2d7a864c..753f18457ea1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2219,19 +2219,21 @@ sd_spinup_disk(struct scsi_disk *sdkp)
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
2.34.1

