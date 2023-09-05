Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F432CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbjIEXWm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjIEXWk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:22:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428A69E
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:22:36 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385NL1s4029889;
        Tue, 5 Sep 2023 23:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Axd9TLHli2jieWkZ0nXfGVUlLjRrPig60/zF9fNNrnw=;
 b=QI0ye/md35tE5eos68nvbi9hIoPEI/W5A4nzlb8Gh3+j3m3/rciEo5unw+gvbtiR9rMY
 1ANv2uBVRzgR/2n+elpi4BTkqmixtjsKrDl/hnjqCFC2Xh7N0MG0dz+xhEfRYxeTcr4w
 QCKsgcN9L66PNI+CCakV3cn5X24dC1lT8JRqMaQjykOeDHvAUrgP1e8mVOISxlrf+xI8
 yfogiqAckaDt835lEgHbsq9LjX67HHeDYl9rDASteOCS0Q/WonoUmJ0/1uOaGF3rjBbg
 gKUjc0UL3pWAnOtDeaC6YikwPp5y5p+6pYTZuobfXDwLYMJVJaT5WSPcFdierH/66sPI hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdwu800c-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:22:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385L6KUw006574;
        Tue, 5 Sep 2023 23:16:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5x007-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6xRUDE5QxER4oV/63A9R2c5UNeQFcbSh1hxM1ta6CdMElTYxXKRFIIOf/XT0/uFKVHqMuUNC+ak42JyLPVU63/eGpajn+7PhSEH02c7qEIVpKwvTxDraHrOxPgkRV2ccAg8b6OjVCu8pb14fI/ZtXEyM7XZ53F0vjnej+L0YpHEZED5E1a9OPn4HOPNqBXRyN8Rfs8A/vAG68ABbqBeBvj96NQ7boyaS2UBUvG8OcDgtXPPZXvo4iDHzrowA+/roFg2Rkwb/coYBvOqlOZBCkltPpKSiYiOoyEKKQQM3EVar8xu/C+XCH7Wr3llm3bLRN7P0bz5BolxxTxMugVP7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Axd9TLHli2jieWkZ0nXfGVUlLjRrPig60/zF9fNNrnw=;
 b=O7UmIq6PlzxK8bhTiSF3yiun+pPTHSt9sSvF6sdxjC3gcWc5BMpjlUIZU5eBcN3vtTN6b+omPgbDTSImGgX7zCzrTkAowpaSSvKzGwP3YFH7Fujwq+CbJZt8msK46k15DJB1T85N/X0RinMvIQyYho1IJGiQ6/1Afq28MFRae1W0J0vE9jHcfix8RfqqF/y/b0HYNr04/Fn5DFoWonru2RZs2QoOkOjCfhAZ+ECQpoAlAEd7bKq4t7su8TRO9FHiP6WqmA2Mcz7aOYT53FUKvDgVPniOrJZ3fPrgMPZgbI4k4hizKBcKXb1Su4o1Hiyohp5tzrFXyOInwm5l6U7jtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Axd9TLHli2jieWkZ0nXfGVUlLjRrPig60/zF9fNNrnw=;
 b=hwTS8HEpeWUdqsktxFfrgf5hki/JMo1tUQ7tx/D4cgTUgPyYi8xsQ0hepwJL+K3bdsAsAWYdN5Av/5fvFQZdrjuQQMPUbmsL7WkCiCpQFqyN7+ISD950CeClBR9mthJowVQZtwlw/2kh7zQL8M4LLAVhrNUX/yzOe2OQqkcIYZs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:03 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 09/34] scsi: sd: Fix sshdr use in sd_spinup_disk
Date:   Tue,  5 Sep 2023 18:15:22 -0500
Message-Id: <20230905231547.83945-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:5:80::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c3548db-f213-48f1-6b57-08dbae661302
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NyxXf/nNsKf1z7+EhIEdPD8UkXel0LxjKut8cWuThp54zGGELuRcuJQUwJHAjN4816hMZ5bxhQ4mMtOirql7rB+RbSNgOvQr8tPp+HZqYO0Z3LiHyqitfHmEtCHcMqJPTy7YF4cEgHUvO27T9g+B34+cJcRe80xWaVpmIYRPxKxqHfKNcJstoveCD4GtaerQEOp/74uf7bOlRSgs241i2pbmlY5opSf2zcJTawpJ+O32z917nrzkijMfePH/k7qxB9ZOPyj7I4lIihqjsLbchzWJAorJLW+ow2CMpCL3zmjCqO429od7doXt6R+rhHM/TZQEpMrYSptnsji2G3OYuJE99J/BsEkQyaegwuQ3clg3ssplJFFPZ7QpQ6J/gq4vHKghP5LW7/iQPJKM8A8XZiPjgGwzC9FCYKUaXfDb0WVczXh+yBJJieKNOtlvkrp9pn2oUV+ZWYZFaOEhgpEHjI8WvAMhhu6H1mMshIUArx9bHi+ZFzQjp7bt3tLKZQRphSkVk+t/QACOGm7o43Z5zttYUCySNykhzX0uwmKIbUayZ1sV/tKLFl/xzFFJVSBW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?svnpim7zIzuFaLGZEB+gFjcWp6hGUPJs8N/DAxSUCfesYK2QHqc6/4UFpsBH?=
 =?us-ascii?Q?3wsHmErQUy2Rz/WVAc7+gH9JBc9ZmxXxyPqqImKVumi7V8dBIH0OOSk3YDAS?=
 =?us-ascii?Q?KV6M75xrttB1htcfdPk06WHhmhttLRCr5QqUBiH52eDkag6L1tkkafHo2d8U?=
 =?us-ascii?Q?0jyyQW4HhAwuG8zmHU5b7wM8soN6UdB164CTBDd3/Bkzhm2fQATVRq5cj9VS?=
 =?us-ascii?Q?0FNInzjslC1RJmmb/MX1abNSUZsTMhjdY1k3OMmJUDqQ3kUmxtdvZxDI0cAs?=
 =?us-ascii?Q?H7XTfDTrf9Y+HtO/OppjTIZy2uWIbcIpEr0HtUi1QuFxccRpBfM0cQiVYPft?=
 =?us-ascii?Q?GmNUUDTcuzFTd7mb6IjzkErNzHaF8Ygl4o0+vWYwm61xA/vAflks8Ai1m4qV?=
 =?us-ascii?Q?2HlZeoSHyQk0SD+tKwxJ7MQitvxw8i+5C3xqn4TgTEa/mzQtvoWJsbjQJ/zQ?=
 =?us-ascii?Q?peE4thWm87RqjezBvY2LbtzraO82QBq61IWI4XkQ22+KJ+UOnDx+S9j4lgJ5?=
 =?us-ascii?Q?VWyXYIb0AX927oZx+YQNAZGBbioAqoCg07JfGmUBhvD3R//m+Bzlsn+Ryzba?=
 =?us-ascii?Q?ZmbZh1gPT0TLm+gge5ZGxm6Ah5+mmNF7GUtFzUh9jOj0X/pJ34IpYKymxCb6?=
 =?us-ascii?Q?/F3HocxeEbIRW8/N3UzGvlOtLJDOaEgDQxlHDkHvF08OBf7juTYH/HmA/ota?=
 =?us-ascii?Q?iCQwzmAcJIG7yvemJrf9noHN5bAJrE3u5LY/zJ6z9lwJ8mzz3B+BANvnTa5r?=
 =?us-ascii?Q?ITACXV/VXw1kwEnVzI7iCfYOnS2pKjWhxM64d9gktJEIlC2+KS9ksxvYJCDd?=
 =?us-ascii?Q?d54fBdVQLF8BhXE76+EIEoSszxOgYwbe/VT65lqXyiDpcveYRV98ownOLDpi?=
 =?us-ascii?Q?VIpKgN+OZR58z+EbRrMaRjUPARcGvE08XHOOdVu50kiYRO7Q6N2o6g/x+19H?=
 =?us-ascii?Q?Ndbo+xzLHUTDN6+AJfGben2ThGE3Mn2dOBn2KEXTQu/f862zBM6avuXye6WW?=
 =?us-ascii?Q?64gl3imov0412/jqFpFeh9SqKJLrkm5cJDnFCfKZWZHV90iTn457SMzc4UUh?=
 =?us-ascii?Q?+Z/Ggit403jfdZITTYE1H24ndmJrMkV8SfEYL5mQKyUazsIoasgp5u2EjReR?=
 =?us-ascii?Q?iN9sgPvVZoJtqZQ7e4CnXp8RcGktyUl60MxizBBWwrtwD9uxPijEbzHvhULU?=
 =?us-ascii?Q?tKoAeF/w3c0EXi2UY6YiRIqqh5NZAXaO6aeG0iZNKnYofmnmza4p2O91k631?=
 =?us-ascii?Q?99Ja6yaveNfmgR08OIL5QV6oVhmjo0tM2HZolistDsI1tcw2GcnjVJnSmVVJ?=
 =?us-ascii?Q?MqUM5367igiV9o+IdsFEwEmobKaivpxVgte7CrPBf5coRl3rkiW7FR2H1TJS?=
 =?us-ascii?Q?qpX1aRcirKhNRIloX3Q17GE2XadyzD076v34NokiEQ+f7X7ER3DLwnEyV74h?=
 =?us-ascii?Q?DcptXwmh5aBri34VeHT5ypXIyK1FjuKA23SWz+VNUJHSpJ5EdZPm6iRwr+3d?=
 =?us-ascii?Q?MGyh1qkZDV7f6wYcJuMmd6vX4QQ9MV6XIqH3de8505zNw0QZGBwsLSy2oPsL?=
 =?us-ascii?Q?mnrSifRn5akzZyBP3EyVEN+uW45Yn0z87U/02oy+vRDeUU3mpBBCg4Ry49u/?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wg7QN9lFrDK+N/VpjC3dkKsn/2ypASkqE8RcZt0EBRR+Dcugbf6JxryAk+7jKYasLdpOZidcNpg+KEzVT4XKfHVQcXYmeqI/8M0SiVecgfuLh7Ex0oNVpNc7BloPIh8z3VlvJTRFfvWtkvu2nuFN0bhaepooHHciakPi26oMOYbYtaIE4jZh8HX7BULTYJ5jaFurylr3ebZxOIU09ewBtkvAHFzpWqDnDW/3vv/KHZwzAOnJNKmrXatydw5uLL1D8Ft8Okvyx1IyY0rKI4m3HvVTtIcErgYx/ovSyTQTnpNGRf3tdOZdDlaE43/Zfr840CxmbC9F3Af0nd+N66tYbGR7oexdIFgjK5PorouHu/eF1OItu0y+IJKxlc107FZYhmg7jGaui4WW691/JnyWNi9kLnmgItjX52EEmKr+FmlKceLI8qRg5MwEDPKBHjIIw5Z92vT0KDJdr7IBEePqRrIDLkbCEpMpIWzEEAXHWdcmX5MlJVYBzoCxFGqZWzwOQ/sguINJhWMPg2eKJOJw+aurSrLEbMIvggiAK0MpqgLyHsdD9mX9dQLN6SECtp5Xl+pZRpOdABt6TSOwVwy1leE7936unXcRyAa6+fEUYVrkR/HRc8sNPQMJc8RkEVVmbDK5165clu6sXuJsAwJOBN9K64lbB1yuOyUWY5PezCWHAat92Jvoq2LJOdXOQqWNYFTK4x/T8BgOagptGYJAt1mplC7NeT8LlM9dQRDig0NxApJ7crOUf8VNlKsHulg8in/VDPoBe1txa0yYq/zt04pjc6zxNaavzTCKSv/x+aHkLocySQ5oBgGcRYQsWmr+DgC2sPRETM3S5x0ifZHfR5Oosgl43aGHQztxBuJyMyscGZvH7JQkFMZriCWliIiJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3548db-f213-48f1-6b57-08dbae661302
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:03.3088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6nlrf23Q4/Kkx0r1DXxVIHZzy3M3QtlHfDnz1hL2cTj9Oh+KsxhIq4SMHUNgewEPaXhueUwygVCz3zoHXKwkt/cMqP9C1pMhEMJmp2nPkDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-ORIG-GUID: 6Zx_4F0viknDXf42CMpBP0tKx6-QpfZt
X-Proofpoint-GUID: 6Zx_4F0viknDXf42CMpBP0tKx6-QpfZt
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
 drivers/scsi/sd.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3aac3041c83f..74967e1b19da 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2180,19 +2180,21 @@ sd_spinup_disk(struct scsi_disk *sdkp)
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

