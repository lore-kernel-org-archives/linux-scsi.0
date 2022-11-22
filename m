Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A190C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKVDks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiKVDkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:40:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F4927CE8
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:40:45 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3ZVT0003638;
        Tue, 22 Nov 2022 03:40:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PfqjuiwrWH9eKMd9ciy2KIfVpQShtSTvkJ4hXCfG8Rw=;
 b=TvJb1321jLFLsFYT92yTYwxw7C8S42iVYi4OrDzf+3bunYEbOJYfiDNRNUngB3wx1zGH
 eAHgJf9YT81M6nT6R+yrqhqLgctKjBGdl9HYKqUMdnNuzgImMy+JejylKCHWPx/Sar1z
 QQ2vN5OH+d6ynayeZrD7Ske2kXV80tKsGf7PDoDtVe9pGGbm+ckVDknwZfjncXlnOX0q
 eYvNRKDhhw58/nM85Np1M8jiKIUQN3+9k5qluYb7Fx0yWR5aUXtJO89ZBClQtlCpg/o/
 Lsvf1LIdPzjFGlDTUrDTCapYNE3jU80zkzwpBv0ePilF4iacyb1mLwTjWj6CBmgFaJ1a 5A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0edq1ccn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM2ovGQ039516;
        Tue, 22 Nov 2022 03:40:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkb0yex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzfJxG+O+yumIZyKVZdsN0h7KF0Vu2HiBW0di8GYfIODI1N3dqBrTyaGLNRbH3RL2F3gUSSUH77uXOnrpYKi5haF3gzqP/Ybsyxf+Vb5Vf9P4lm/2eoX1c4B5oUSWwdwspRZQQRKu7K6hm9yTTF5zCQtfD2eg1J0OdDf2MVRFQzPTkWvLWanVRMdkMCRQXOqtXQGrJhxd01invOa4XejSUxQ2xNdQoYStIXjiNnsgnvbnziWhf070aX+UyT1irP5gUC5/Zlq4cGUHimX4oMt6rpkGsCgLF2a1yjYm3PX/eScy/tmkJ6liQxTNjV5OlFzjvT8F5hdNIdrWkudaGei6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfqjuiwrWH9eKMd9ciy2KIfVpQShtSTvkJ4hXCfG8Rw=;
 b=iKm6aS1ITmjTFuOK5WgLpGWQFIaS7ei4VI0G3G30GtkOZ1JaphzinCi6PeOzqSOL9zYZ0ED69yMTSVp0/koK/UpaVZfSgm6oAVShovF8VGjx/ir5KZLupdtrmZlKqu8aM0PCTNEbL5cLvybEfoTR4lMJW5mKO0iHc1ufJUbeFJCO7tWbrXgr6ZN2Z8HMG+jbPpp7hsRYmnXqRXdd8dphHes39dzHybr1lceOMYfigwQ2qEiOoF3DZHGBKzlK+wcNFfEt5w5iPFoSJV1GsfIUJtwLHmhqgKur5x/RqYJKyMlurgdCFO3K6eygd4zZZUDKBIusOMVAZ+LrxzKWwvVwOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfqjuiwrWH9eKMd9ciy2KIfVpQShtSTvkJ4hXCfG8Rw=;
 b=v5eQPWjDAefq9kTczUfx+2HQ13dVTlLfXPf6ZOhwu8H9/7//grdLn0Q6KwTqVFRBl2pts/iWCQpq667ZH8PQisZf8+vMOqK9vigncYa+Z382Se6eOuJWqCM26dtTwAlIavNutZHrqGYaTeub1WAlDMDn/6uTUoIChNEnGLfQjmM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/15] scsi: spi: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:26 -0600
Message-Id: <20221122033934.33797-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0018.namprd14.prod.outlook.com
 (2603:10b6:610:60::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 93a4916b-cf16-4f1e-44ec-08dacc3b50c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZ2kwvzZFC574X9VVkOvJl6mUxXqWr9rm80sYqT5CBwcRn88sgl3HfmSHWhGz0heOkg8LY8JnjyQmJpCqP+7DV8QfFpu//Cqgv59WGEBVM9FBqnpZ4Linix2Y680spre8czmSarMm0sz80YR5/+smCrpunUuln/ptYZSpej+zKZYhhzHcT46btXRMz6Q+OE62ZoEpponNhVXfW132F7L5w2ygKT1RQ1RkubZTDLPe6um4qu2mb6Rptyrk0MvLTuXf5Hu5Q+e6Alu9AlRDHXI8cYauZrWQR03FyVMYMWbYpzTgCfi1YaGUZkQO+l+FjkNBul82U7eelO1GqRUhBzovY2yzvpcHg4ZDC6SBZ/BKGXgbVW6K8jsS4tl+UuBJygBUt7EHSWN9xsy/Au9RId89OBl5u1XEP2FYG8Ui5Kz6940skfa2zZ/dxZGHimp7fuQOub1Qj5qwNhU5ywU2gxDMlrj/GkBg1ix5KsA3DK3/Xj55dZv8qEhreggsUrg6x67Qg2RNfH3wskWbeH9FQ14BHsthGXEsAaz1X2zcoo+Zh3Nu3Bbjf8vFZdzsy+FuMekoAe0+SYbYyb2TRr8T1f+Db1f0hhzEgUfSqwAFLGgoYVKNWkruxPcgDCo8pE8rLn7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YZeJi8pep+0HeXersUJIz0+jX8g2Gi+XoDcZYxgcIFIglALLEODV4S5B+igM?=
 =?us-ascii?Q?goqrLpdBqInoxy+SzOiO+//SmgxFRU09a5OVmqa45Deq50A0wfksEKfGH77X?=
 =?us-ascii?Q?DLup48qkxbIK0YWJj6hLSS9vuiyHIW1gidkb/quUjp4ltcKQOhtXHmddPGFt?=
 =?us-ascii?Q?GQSe7+D2BveEImV/MaN7Xy8ewPY2j8xJ1CDE0wZP6uI8w33q3ZIneEflDhZp?=
 =?us-ascii?Q?kGmtrM0MT9kiqD4PY+oAoHVVbLGAKngZ5WOCEj0OPoo1CpMLYYUDqn5UY1Ad?=
 =?us-ascii?Q?JdRk97EayBjObHn5XxkvpUzIowaMM1oDbNHTbSNxVM1P3SnGmueT4ruwovF4?=
 =?us-ascii?Q?J4Ln3hkxFBWEtT3P8OwrG5NoDPFugooRdWfAV6ruU2zwDdbF/vmNjjnQvZ4u?=
 =?us-ascii?Q?2kXxqCTn/1pBqQyNw8/CEJWSZlayRrENLcwzNOsS4mWvS0Xo9ramRCdQS/W3?=
 =?us-ascii?Q?/Und81IAbeIkgdU68YQNcRw7BNGIDKvTE8vUSDLfvCdMuN5BYHxkjQmiqZJX?=
 =?us-ascii?Q?rpkwzWCVXogq+ztVjvHrO4rBOQtT69QmJw9qjvzwlIJCrt1I3unxguK2NvCJ?=
 =?us-ascii?Q?yZEdBzdHOlFZyM6wn5flbQKKSVTbesvAzt5H+15hQ7C7YRYgaJdKPZgGdWtu?=
 =?us-ascii?Q?eYw5LP7FfhslI67XRgj5GMtx12FwCZ8RD+EJam/B7JBOpaWtI3yTBd/jp8Jt?=
 =?us-ascii?Q?NccXhuGbzMxjjTf7ph7hrRdwTGLvJ/E7/FhlosApyMvcvQbJ8WjnNxeNiU8m?=
 =?us-ascii?Q?6Ag74gf10kBnXo9fr0ayuVticjYxAh8UxJVtbCXfsa/QErRPc18cAuDL6p3u?=
 =?us-ascii?Q?vTg4rmBiQ60J31JXHfK+nrjSyxKmSMqn9mqCfEW0iBsrR5eVTyvkgeAOGSq9?=
 =?us-ascii?Q?G+YVphxAr6XxF0FEVTxufLH9Lk9TF+LgAhl6NG7W824JuHooDQyAo6i6iIqR?=
 =?us-ascii?Q?s61Vcb0q0DxE00kYKBJuz+UhBHK1Bh2H3RuGUZVgwcpznSfc4eHLKsLKSk2E?=
 =?us-ascii?Q?/gh2I3BgTfcgbf1wNHBDiCElmNKJLxmQTLwfVqW+eycZTpB6EAYofzYNkWw4?=
 =?us-ascii?Q?K050VstsYG1h9USQ5HmpmIKAdfxBk9paabE1kQZLS3AmNEgm9FeHvT0bRqHt?=
 =?us-ascii?Q?8xIcfFeqY58fxujxntqBfbq0Qzgu2rCyE/90FipY2535FbDseIHK2h0xIfA0?=
 =?us-ascii?Q?lp0gUNjKpwti9lGJkQXp67fwrcfsKpDS3tpQ0/wziahb/kHYf0LN8ijtirgc?=
 =?us-ascii?Q?YqhpfCUMPNS6yTSk2qFiRs76WLnIFGzSuW3wp8uFLE5YUTHzfR96USb32TfA?=
 =?us-ascii?Q?k3q3Tt6bzYKRdlFT9YL+56GXRGyFQquYo1weRv2YFJefHB4QZWJ29mP2TTLW?=
 =?us-ascii?Q?DF+VUJZ0weWtKkXc74UA3kpc5zTSXiZX4w0EtBTFmmes1qhPFfvYf3uPn8lK?=
 =?us-ascii?Q?W6+kKC/PEjjGyQj1eHCcS5Od1J1TVNqd1FVQKrN+ED9v/jAfyN29mLegucuY?=
 =?us-ascii?Q?So/Aa63qmW/24T96DHSNyizkh+cyXPWF8QKDSjM+GdaMSXz5TYAzf2EIZweX?=
 =?us-ascii?Q?rpZKw5qoB6mNrqHaL0bFYb9VzpF5+h8DIl0+pf4aVXuVS/rct2npx3uGBL4M?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8jwrKgPKKU4soe0KWP6J2oPESdCAUhSC4eM6kOrTo1cowRmY5OlaOkk1k+ZnUzGPYUKUrzLNsWUSKsUFAq/rvXc7Hx1rB8Si7y1m0eOwRI9tOOmVkXLa3l8kvwPuFnVFdpfyO0TD4OVRSJ9RSB2QYoylc1TODzOt9G/sD2835h21RZVknEs4VpG21l2ymVIxqBFA+oFQdCvakdCx34Kp8sO13p6crYQtSu9YH3YYj68JOIvXvbQpKMC+af98qiepCbNe45Eva+6fy4lB777wakR6zqKBxv/DW9bPD9MGTgt7tMgKic4dnNo0z8Dus8vTi/xRYuKd7OOLk4ZKRNJFCl6K9ICMa2Qq0ke5Nq1gmF+CwETv2N5jWzaaR/S1OqkNOOhMPjCVnhFQLmyWh+7RrbmibSA0/CaD989002e/IAdejFsVSAAaO6SN/cOWzy1jy3LEbk7KN81AWemH0nnc7gufKPBWE+em2aM2VaJeDxUTV1gAnpWXXE7sUl49r1nCEiISXC3971x8d2FZX4QKrTJ8gtCSEMRLIa7kYHecioL1I2dpvffrVDYcG89Msl/D5FeY/wsjzawQ01zMAk+h/i+54mJ2/4v13e9bqEiiO+4fEvvzr67OGW//0sYEOPhSQICjrXAzJyu9U2h2udONlqh0CCo9AtNI9eLyYKy5zATcsV/CF7TCihG02PwVKnH1An/CGFpR/G/NFL+RknSXkN0cU2a72ZBlZtutFIckiHIsDzOKWnPOPP0m5VbcxCQJUKccIiOMN8rOPNuoBHRvbv8JoMw640EfPZRHXnP7+CVZBflU6of6N80WF93bpWAjU8VPOcaz/VMkEZ2Mpnk/OUwSytap25oUFM/wsXV3NrqryYV+p4gAlo7LQ8kv6OxN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a4916b-cf16-4f1e-44ec-08dacc3b50c9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:35.8100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ayen8vwQwkJ8gVKED/epmwseALcsrTUP0y6mJU0RR/4Nvru9a9iYhWEGNDYzPvut1l2OImFIv1KtntDdTxfVqoOfZWrHYQV3vwAlXJ2lKNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220024
X-Proofpoint-GUID: whfSExDTfsoIF8EmghmVnuoC9Z6QfayG
X-Proofpoint-ORIG-GUID: whfSExDTfsoIF8EmghmVnuoC9Z6QfayG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert to the SPI class to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f569cf0095c2..ea71135ab3b1 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -105,13 +105,13 @@ static int sprint_frac(char *dest, int value, int denom)
 }
 
 static int spi_execute(struct scsi_device *sdev, const void *cmd,
-		       enum dma_data_direction dir,
-		       void *buffer, unsigned bufflen,
+		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
 	int i, result;
-	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sshdr_tmp;
+	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			REQ_FAILFAST_DRIVER;
 
 	if (!sshdr)
 		sshdr = &sshdr_tmp;
@@ -121,12 +121,12 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
+					  DV_TIMEOUT, 1,
+					  ((struct scsi_exec_args) {
+						.sshdr = sshdr,
+						.req_flags = BLK_MQ_REQ_PM,
+					  }));
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
@@ -675,7 +675,7 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	}
 
 	for (r = 0; r < retries; r++) {
-		result = spi_execute(sdev, spi_write_buffer, DMA_TO_DEVICE,
+		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
 		if(result || !scsi_device_online(sdev)) {
 
@@ -697,7 +697,7 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 		}
 
 		memset(ptr, 0, len);
-		spi_execute(sdev, spi_read_buffer, DMA_FROM_DEVICE,
+		spi_execute(sdev, spi_read_buffer, REQ_OP_DRV_IN,
 			    ptr, len, NULL);
 		scsi_device_set_state(sdev, SDEV_QUIESCE);
 
@@ -722,7 +722,7 @@ spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		memset(ptr, 0, len);
 
-		result = spi_execute(sdev, spi_inquiry, DMA_FROM_DEVICE,
+		result = spi_execute(sdev, spi_inquiry, REQ_OP_DRV_IN,
 				     ptr, len, NULL);
 		
 		if(result || !scsi_device_online(sdev)) {
@@ -828,7 +828,7 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	 * (reservation conflict, device not ready, etc) just
 	 * skip the write tests */
 	for (l = 0; ; l++) {
-		result = spi_execute(sdev, spi_test_unit_ready, DMA_NONE, 
+		result = spi_execute(sdev, spi_test_unit_ready, REQ_OP_DRV_IN,
 				     NULL, 0, NULL);
 
 		if(result) {
@@ -841,7 +841,7 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	}
 
 	result = spi_execute(sdev, spi_read_buffer_descriptor, 
-			     DMA_FROM_DEVICE, buffer, 4, NULL);
+			     REQ_OP_DRV_IN, buffer, 4, NULL);
 
 	if (result)
 		/* Device has no echo buffer */
-- 
2.25.1

