Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9EBC04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 03:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbiI2DF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 23:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiI2DFy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 23:05:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA157F258
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 20:05:53 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiRoL003459;
        Thu, 29 Sep 2022 03:05:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=o5Ps0Clqi5d+VS8MrwF4D6dP3/XDtGXvuRdGiUNkATM=;
 b=3HGQL1S1swsRk4jhBylt1qwMZf81j3GQtB4oSt8yTvi0G36lW/SYxqeIbmHYWkvLTJ/W
 2C2sTN5qH8Wgz1SWa6F0/ytoRjdfnRCz7Ejr2+HCVB6xe3xdwe3xSryiNxWKJTggDo3I
 UZNBbPWdHslGjvribKKzG4BmmVjn80PoPk3EFbxZSeDl8NXLDf64atbS+4JV/3lGXq6F
 Ku0MamaecM0aBJwz3iH5SVXxCYfkFXaEl7mpaapQAUGnuqcruZqMjFc5z8bs95c+ql3l
 jcFJP8p29HMPyKSdvP8o2Ir+zOsGp/kqTZYXZZKXgNq1GwteyEZtUQw7Di1Gezfu8opc fQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwkjqu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 03:05:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SMvNCH033540;
        Thu, 29 Sep 2022 02:54:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv22qta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiT9bQyL98qjCc3HGoZeGetqrGlcJalEf0pkEEYgf+HIlzXr3UjW4fs7RPS90YdMgiBdmn2/cLitXMHypcw2eEkbblY+UaKMGkVAgOTZ15vNDvCLq1n0R/GGEV/WgcdOWSF0KGCAE9/whr99VbieMUwpzcNV0GmUSEb/w5esv4ThrCe2MSMmdy/0WXrvISMZuMDzTg/s7et6D5R9VO8qcpzfRoSDgoSO6L414R1U3bUNASPUdmPgiL2jshdGQ/hcRFQrsprLRcxJW24VSN8QndZquJXasfipuKVen9ycC0wJIpJXcB3md4kHie97o2yqld10z/73xEbQSKkHud+j0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5Ps0Clqi5d+VS8MrwF4D6dP3/XDtGXvuRdGiUNkATM=;
 b=g+P7YuglWfgSWb2M02uAt7z/m7iGF9+E3Xp0bSlfpoRUOQZzibJovi97wuahEGlXVJhTwAsZ6B4qM1lVH3IV2FjlDx95KKCzOAwyYcBzpE71LlnosaisUfqFvRhBvZ/8R59E/yXs3A/ZaucyHN+FPpXQ2dFbovo23/ihTBpXzv0bAsBcLefOm6z01e2Huz0ulZtDCVB7No59c7JwQYzjnova2Gpp3AO8or8+OPHZokCIYAlREvGe5XKAqRUbpJYK3swRGXjwfEhXUc4JoTkl8nAOAfqCBxikd6xw9A0haXhEjTfF/ggAvhXmtvTm/P5Y7Gw0Z+Y4MljlhTv+9+hFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5Ps0Clqi5d+VS8MrwF4D6dP3/XDtGXvuRdGiUNkATM=;
 b=VWrqyMGw/A4CnvjYTcv/CdptG1sQX1LolNYfv9HwqTkKpZGlJlG4czwHunS/o/Nz4x57HW3aPjK5/t6XTJVMkhLDcbHfY6uXVN/GF0tNh+eDjYtoxgUgN3RQcHJVI/ZBDW4HQ3HurkefPm2U0ityFXr10ztUqDvT0Su5Z5VjoBU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 13/35] scsi: ses: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:45 -0500
Message-Id: <20220929025407.119804-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:610:74::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 3174114c-3f65-4ffa-6bdd-08daa1c5ef81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0PUHTi7wbMh12cKEYXDnAmiREyVlWRjPG5S7ew64KOba+VhLSIFm8E+oeiCG258ePDLtVVJa+ow1zsqYidZcOGHBUkCPPjiq9aYc2e762GXd3znOjWUzyQ1fx0wdKNs5RC4ywbzPYVdnz6y/0zg+9B0DZSSOuTZg4Bys5hvkDdzlCvO731g5p0pPzkU6YkolylmXBlK8jebMkWhzEDxI80/dbAmjHwZVhD3ckl2CIjVcCcARSqDh3GxBZAXLM/PDjn704n6AmU0Cv67BDe/MdjThi7g4OXe6PDzGFhL55PaalbuhoUyaqjy6jCKaWGl8gQjTOA9FMQTuNw3h+S+58/MIP4NEemNhejr1d2GY0ANDv94CSdxHkYtSuUZ/jXh9PjVtn+nT7gyt2BeLwK4XdhBaeacgOjeX9neJPUYg+BxfP641jzaPMoO70EmD8YkVMDdJBc20Z11udCIfnsDsWn/71U87Q4G7Bot8DI1y028vXnatLFk0Ek11CqLrg0aBxoQKQuAr/99WTatQGm85wDNPWJlyBxMQr1i5vOBV9NUeQDS3m7fKYyBJBaNnswAZhR5a8eBtejs5H8pmkQARz46QrKghJxVLuU0NFkEJZDtmMZ10zd1CAMJ34C3c82ZVtuZDwyyVbOfxmXu5XRRvrwYgs0mUw2fLI+MUVz6l5+P24RQptsm5jEFr27uw8iDju72UUnamnKRWc8arm+8nxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KJv84Ha/SvB5gT6XfG8a1Bs3qm5McSrFNZF4rpeRpfzikV63X/SMzcsdx+3T?=
 =?us-ascii?Q?fG3fGUzVNk2hMbxTCDubTiEVSEXnUX4SeyZ5MTaW7953cD0VK+ICcbwFnsFa?=
 =?us-ascii?Q?5GEaBM/TgOVP3nZ/XerylJLq0HVNwk/vUwXtAqBpXeBSI69SgRIC/wuUo29+?=
 =?us-ascii?Q?pypYLTMA+o/zomp5Ag8AIwcy2wLfNajocVKwKuCOsin0fQniXlfZmAGyyXIz?=
 =?us-ascii?Q?aEFNZgwXNSEGFEp1BRoUbxh8SOzP722ES6okl3DrCVNPeHOpVVsvzOO/t5gw?=
 =?us-ascii?Q?Ua2k73xS+VqSmSf4nNBVJgiZQAUleQkT0BhOmWWwjOouVccvGppaxitIUgEK?=
 =?us-ascii?Q?WkCsvjQs3maKV+/al0KAcF+2F9kd33rqskTbNsrk8+CbOSuJFLFPLVd9ozZt?=
 =?us-ascii?Q?lpdgh1q66hNecO4b8+zArZQkKzXv1L7UxQYXCp6W9JFi+yvf2g/grCWLH3Ca?=
 =?us-ascii?Q?cNcDQ5wPR4qFpaNGtmr/HO/MUuBKf1PVSaWuXhSnXhm/txkK1xJv7jdJ2UMK?=
 =?us-ascii?Q?47Zswb+IAh8bxswR+1c8hJgSUFmJPKDTH0S6kK3Vyz85dczWEJu1l3hFaPmF?=
 =?us-ascii?Q?P1yO5k3CJEVf4qfgAEksVb0O3KWBtzLt/FwBwXqDJuERrS03kBpCb9FxGtv8?=
 =?us-ascii?Q?MXpzxSA+FfFLlG9FHsmpJS7A6kp3c5/CxB4daOIEZ7bCSls8Q2d1Cjveurrw?=
 =?us-ascii?Q?qPdFsMyBVw3CvxnXcOLidjNL9+M4jVlRj/WF5WSaOr6y/mSLvCfcCZmyuRGd?=
 =?us-ascii?Q?j4ZKPXvq6RZr7PoFLHe1FfpdtGnkuA6IapbgiCw/kT3PwpUarGXUgVJrJIFF?=
 =?us-ascii?Q?8S60jn5ax2+26O8y3KFUO7VSXnEPqXhvTc2HIJA80ESYyqpkdGttkZYucJup?=
 =?us-ascii?Q?fEzY6hj5i/sRVbyYHMj7k5Jb3YTS1N5JrXWFSSU+eMFzwW0Era3doNLA8qeX?=
 =?us-ascii?Q?gHOeD6UuAT+BjAfysZSgtw33qxvCPrsvJH03PrDOQZnaWbUjF4UG/tqyEwVS?=
 =?us-ascii?Q?LSSR390T5BP1PD2hsjayNRaJUDrYC7HBL2MJNuaNHMFyJNyPJHuD+n5FH05z?=
 =?us-ascii?Q?DoCYGWzP8sVSICusVfzIYFyu9A1d2R5oYjBBGiveSR1DZY8+aZugVb2dOSsJ?=
 =?us-ascii?Q?WQvGgS0hH6pQMoEbkwYgKFkLw9O++76bUWHQSgFQv9uFW+J36fdP34kvRm5J?=
 =?us-ascii?Q?OuRDshCGv87ELpTgwUYGWgNxZMGMtuatF5+BKVeVc4p12TqM6p6spi3ak5Fc?=
 =?us-ascii?Q?G4M/IsjyYqtKYWBEbuHLihP4QnrDxfJd2ahtKfXzpXuWc/SgzXMclNljRJ4K?=
 =?us-ascii?Q?uIGc8ZoOYD5pH1oLjqdbC1J2tcEnPpiZMtqSse0sfNVtTahdqLIYvHngMlVF?=
 =?us-ascii?Q?OC7QDrxDHaQ7ht4QGOxmB9b36C3RqWYj82lC5na17kaYPaYdG4eFFTXsJ+dR?=
 =?us-ascii?Q?kxGMcNwKeV2O0dw9fJV68yys3c4fnUu0B8KjdcuVPoAmm9jJ95WcoNFOOGk2?=
 =?us-ascii?Q?HwLuT9QJ882fO83x6h6bxNAku9sPx/1AfG9/vfofmZY9ItuH+Dd7PCQ0gGdC?=
 =?us-ascii?Q?Jn0xu9XQUo1JNqS2eEilc0jtnxC6Bqp8CYN9GBFkkSHN6gxyJ8U17+A944Wy?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3174114c-3f65-4ffa-6bdd-08daa1c5ef81
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:32.6305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DBPUgwtxGpoxECuUwpNG7kNUqdmawMsK3I9BkFPEFFk2o832ek8lqT67NHYAwZdQcCmjkmEjTIov/lr4688Pvj2HqDnYJIJJL8wY1fR0itE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: EablzX-PXClsa-aw0gO6kCtcSgtODe9F
X-Proofpoint-GUID: EablzX-PXClsa-aw0gO6kCtcSgtODe9F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..c90722aa552c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -91,8 +91,15 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	struct scsi_sense_hdr sshdr;
 
 	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+		ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.sshdr = &sshdr,
+					.timeout = SES_TIMEOUT,
+					.retries = 1 }));
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -132,8 +139,15 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	unsigned int retries = SES_RETRIES;
 
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = DMA_TO_DEVICE,
+						.buf = buf,
+						.buf_len = bufflen,
+						.sshdr = &sshdr,
+						.timeout = SES_TIMEOUT,
+						.retries = 1 }));
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-- 
2.25.1

