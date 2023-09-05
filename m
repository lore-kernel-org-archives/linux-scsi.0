Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569BBCCF9E4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbjIEXYw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjIEXYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:24:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F029E
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:24:47 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385KniTT009361;
        Tue, 5 Sep 2023 23:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=DEZ75sKHRKKsziM1j5XF4AaqkVGnRHTGS9mDfdtHGSw=;
 b=o3zx+vaRcNt57Z4Nlom/MA1pANN9xQYUoiu80rbelEcRz0mlmfFMF0oMp6fDEUMN79Ex
 xVitBQI7Vc3ITB4JbdSQrNjMQZbmjmeN6TjlXDTuJ9xtn+2r+KAxeEAgvYf2i/FkCyxa
 rvHL4280JhNyho2Rkhl8T8E6ucvdVSn7E9JtbTsC8jH80fJFLXfJCC4rAz+ExzHxzRgc
 sPXEqto/Pj5w0TV65bhwz4QCM5MlBU2v7QvkEC/UDS1RqnjQMVphnAV/UbdU1J4W7r2t
 7+OaiFMijNkGYzPsj/Y0vRLa0KQh2065Kd7862CBDZ+nPzmSOFG9ul3fxlDy6ahUqipU 2Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq389bv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:22:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M2ToX037100;
        Tue, 5 Sep 2023 23:15:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbpc5m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:15:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cScUc0RyCzPW/2HjLGTrRww1FWomvexGVEU91DkHzDwTLgM/5Wtp7zQ1Pl/5dt01gAOrX+LCsHLlkVqBdlvQ5L2XHT3JP/DUSv1Mj6xq4YkE66yvxaU9C95fskA8b5TFnUzjtHENdVbTTq/i/xp99Y0AkX1A7O5dZSTmjArR4DLeAF7dCDJkIPBgt79E/xoRxzlR/NcYI7vW40JEasoxx8tchSmUt70k3UQ6HcCJztEpzps8RlfZoEUDh87tb/APtRTCfvIZhGbndf37j0OqVQB+K589oWKst1LS3azYELymFNtMDPjVbqVQ+qWf3k+UFZlAwbEpdg+9tyNhgk6iRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEZ75sKHRKKsziM1j5XF4AaqkVGnRHTGS9mDfdtHGSw=;
 b=LryXku6Z22dI41Zj9oE3C/1Le9oNTI54pWTqDe+z/O4OPt18eCViIaJOSg3K++fK47nVaZDs064NQ/6SZC7rvrHLBHjDjLhCCGFlf/G02uAvJNi/GmNXow3vfavWoUeQe3jlwexpJH1BKIu5g15w7izmc/+8pjHCtmM1l4drYzen7vRVUrDgAVUjG454yTWSAnopmvOEQxJxTR0OX7K9JirmuSANTP23N2fqyZa+kwhcjJfsEQ//GiALH6Vhg6iqnoBe4+QbJdN3UcI1A0fFPIbDZE6iWF9xMvzghoII+3NIbicKGZc6vNRIVTJZNZ4o6Zgd6ZfKosRAKQX08hVrHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEZ75sKHRKKsziM1j5XF4AaqkVGnRHTGS9mDfdtHGSw=;
 b=lbne2EUEkPl5Ip2BpLpxCWTh5cppJf2Qbv6Kzt5nILRNWGcXdmhePozZGhDqjZZg3fCh6IJfkwvxRoeJnurCIMWgyHQqO949AeY/LR53SxmMiUaQwV5lXXzSC2MHmzguY2vOeeMaWTXtaHScDghaynL5Jcr5mT+pWPFZNWOSDIo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Tue, 5 Sep
 2023 23:15:51 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:15:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 01/34] scsi: Add helper to prep sense during error handling
Date:   Tue,  5 Sep 2023 18:15:14 -0500
Message-Id: <20230905231547.83945-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR14CA0061.namprd14.prod.outlook.com
 (2603:10b6:5:18f::38) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: f13f7729-8c39-4eac-d7de-08dbae660bad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fE5uYkg8HLeZ9wGHO7m9lS91TOjQhO+wkZ4+E3q9VHcThR4aC2l5HnnCZsHKzK7PIXA1wcSDOP2sRuDi91khO2nJAgZfci2pb7+96+qfG9Dq9bnWLoZF2zIwFSm6VvAwgvxy5jJZqQx7OIyDsBz5X+RycZ+VWpuwmztBgBZSP2r5UTDIjC5sXCIocwyst/UEGJVkL2Firmz+3SqdNDoQGBhHp/eeGRRxVNDJNow/rCpava30lPqfOP9J0uieqrempni4+bRyE6CD8otdAlItk+AAFu/tjr4FtT8E82RZcTYSFWKSMIwl4fH2wXoirMuj8V4qCA6pMDVQHtSoFJPgkeF4wGrDHUySiBaru1Z+WFKoVRLMul8Kprgj0GgZC/ixAWezhBXbROCiDeAlciACEUT5y2jFJKZulBg1RgtCJdm+JD/YppgquWAMubOMwzQBCylw5he+mVjcoSoeN7ROzU9WE85h6vgHsxZLZMziZj3OoUAfdjyKODj4WzW0cfCj1jzB/8Fg5HRYJ+L9zsZPBreK09+uIiSaLBjKKeImuq2tGh/w6QCaWbtVPgosMTOt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199024)(186009)(1800799009)(41300700001)(36756003)(8936002)(8676002)(4326008)(86362001)(38100700002)(66556008)(66946007)(66476007)(316002)(5660300002)(478600001)(2906002)(6666004)(6512007)(6506007)(6486002)(1076003)(2616005)(107886003)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?txPAnU0G9ulOJtI4r4TGFbDmpF23EORUOpA1DMOpBowU36R2Mb62N34OB97x?=
 =?us-ascii?Q?UNcs0qo8Aigjni5NSc7mN63ou10JbB44xcfOUIedQkulB60yPDcpcrgflNPZ?=
 =?us-ascii?Q?SRFwvseLExQyX1nNbZiO25mVc1/onqxnn4Y+MKbGC0gvcEHBpDJVKYugqk05?=
 =?us-ascii?Q?SbXFnWwNsfI7CxeKrNrtCiZvcU6h0BSEq0GnCUIPSfypbOjHh9iGz+tyMiSS?=
 =?us-ascii?Q?0Irw4ozdn5LlRYD/aV9vtBWvL2BP7SiCTViLoPnfZQ6rDIIXaYVbpK9G0TEW?=
 =?us-ascii?Q?8a/mO3EO+Q0NtuUjv4nkbWauqYpEcaVwcz6iW6dShrNN6Vj6m4NELzlhf+S0?=
 =?us-ascii?Q?oalTr4rX4Un5qyoM9R452ymJwGJiJdaShPTRIPS6JCJjrcmQVkcouiEeIquT?=
 =?us-ascii?Q?CNuxQ1TAIq8h8QdBJv9CIDctjbheH+xKB6JQzNRTYiBCcrRR7RGPII6qKiqd?=
 =?us-ascii?Q?StSc17Oq8bHQSloL4jHD0YSk/MSCzP1pBYXRFrgT3E+GyXXC+T/UoOoXlT17?=
 =?us-ascii?Q?pRsR4QtjzbnrbAU2Z2WvGNByvhYqWAZGS9fyu1oOpIEGhsnAzWLznCbRo3xY?=
 =?us-ascii?Q?QragU1H/jO3XGghO9udr3X81s80aRdp31oYcFpAk9JJRG9WJvCVr2zD16V32?=
 =?us-ascii?Q?P/mEtrsWKbXqPNmlXuk52NLgaImlgl1pSvENMsr7u0QoHk9p261uE7Nl3ikN?=
 =?us-ascii?Q?rII/QTY99kk7S3bHzCElHIl/hilR0AuB+nJ3F7j0j6jjL8ABFhbZhj8TUkCf?=
 =?us-ascii?Q?XZxjpl6mO48qDXxUhqm5xLaC7ngyc9k7P3T7EJn3cf+cf0WDzPkuYme8hU45?=
 =?us-ascii?Q?0bRZhENZypJVKRzQbTreZCYbHd1OSQ7WSiERCI8Fck82y40EUdzdIOxIYKZB?=
 =?us-ascii?Q?7a9xMacP6ncbfq6gf4C1kAOQEBBnuXjzuFHPs4whoN7TsxcvHieeM9uXW3NX?=
 =?us-ascii?Q?HOaHiSFcwIyVyeNDYlI4B/Gg9IBxT18+70i/xXPMuikUFE4towK8BiG6HvHJ?=
 =?us-ascii?Q?L8UM9pUiiOlwrKWdSmKwxCpeDVoPsZSvWYiNODwQ3wAwhm+D5wUxMac4z9xX?=
 =?us-ascii?Q?DGYoGXTWMYx3dMqCB4BbtCdhE2tRAmlCxRVIK/pzrCF4rwzmoLUa428Kf6t6?=
 =?us-ascii?Q?a92TlJ3zdKKylmIFsV+0KOI12JOFC2ruQKhvxrOuUd2D//IE+2VRi2b8PXJo?=
 =?us-ascii?Q?d7phWvjtp4uhts1iM4ApcmCXqOUl6PLHLVganL7oLM4bgcJYb4GiFzWBh5bJ?=
 =?us-ascii?Q?9QpIGITss5TfRq8RaJQf0yWXVfXnUJl6nxaxa7le7lZ1TKzHs4Be8YC5PJ3u?=
 =?us-ascii?Q?/2wvzXv/jY4e4iez+LLAY0jKEAxr7/zXlQWGbC3P+hhRj8yObpBRpn1l4C8Y?=
 =?us-ascii?Q?UEZ8w8iHaQnVAI3kQsQNRwcT3IxIAIsOKgi/fFXwjTwAIV516aMmdLDhIkCo?=
 =?us-ascii?Q?/mynd1JK2cwbDqRs5M4mof/r3m5A7JZGRrJyn9mUV8mLoq8swr11f0hUhzND?=
 =?us-ascii?Q?PFDp7lANWvYxj6mzjXP85TS0KDNDbtM4AXXkHRUll/+ZYoVAgnKy0QCYuUx1?=
 =?us-ascii?Q?pYS2NnIOPUgS69ekq1Cwex85x7xK/k4B2cpq74qkaZXIOjsFsQ3YxO+adVS5?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YDtL2C15m/gaExfG2g2Kvqw8hgms4OCeckrmNnf1GDNGOX4ihQez5cUIEEkoM7OTqNm3WIEf+bdhPEwAg/0RF4u6rYe3R3y2KBYsBJ0EwJgg0ZD7Y/I0c8+6GztmHsngcn3UC031N/I6qcFwwXd0mA0k19M8y+/vDzD9G3eBUG5S7RILBraAdB09I9Zlqun8BIBF0Ve5snamELwIAeTmTjr+jNAHvWG4WJKcr8OGIdMFR3oAwRsgXb2ZLvJTjQHeSaIKa5+HgjG1xdNcckwA3knkUGfWrGVS5K2Sf6bJWd29ijut/fx6dLJABXQfETUMMkQK8sOavi8vwNUTptWxil/Dihml5CI4H5wJNhICNpxcG/2Ot+P1UIqzkPWHG5lwD+am/Z+/XgmYFoaC2a/F9xbkAop4e/ibpkHPOm82FAbfBlo8I6/YywfaQ1jaeAx3jVVn5itvX2NzKNu15sCt/EmbwxKn1Eo10nhAw2pWg6RVwaz5gfzebVp0KhAapq8R2w2j3tzGmbRAe5uheEb7GJWkZsU7G7Mo6+RUZZuQjvzW5FHMgYW0Dj9DxM1mi2Ppu2zsbtoltaVM8hIuMzZZu8+JP/Gt3nPeUlf3OpGKQOZAFBV2IBkM3xm9DHMNjs+Me8G6CNzplNmWafcJNZhknHFoUdlu7dTFYus0ukA1nFg6lMBwyim+R1e+Vo+MEg4wkX7Ko6RNoJjrdEceMXFsUK8JGHIS2aJGtRS2R+dwmlFOvTaj9FL9BaxUcd1a5EmUCwUiOa25vSSB4o0PPaH5fwxfr0sXuCvQIuF7YeW/mbFO1AobDkK/bUF9JV0lvQmhals01jQkGGSVXKRAdgssx/76K3rqCipvDW3fcdnzAcTRwtpnMgeZE10F3Wponimi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f13f7729-8c39-4eac-d7de-08dbae660bad
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:15:51.0524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TDAxlxYZ0N+Iy8BdFweTuoKQx7WZeTxmBVcdBGp6VnL2zfixYQHT2rd4PcH0Zm2DJtMM+/2Hm5lMiS+qfaIYAg7fUYazrNR3hiqSZGPb80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: lG_6IWQUfjnV1M5uEwsWChq_K47NqLe5
X-Proofpoint-ORIG-GUID: lG_6IWQUfjnV1M5uEwsWChq_K47NqLe5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks out the sense prep so it can be used in helper that will be
added in this patchset for passthrough commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_error.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..7c3eccbdd39f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -523,6 +523,23 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
+static enum scsi_disposition
+scsi_start_sense_processing(struct scsi_cmnd *scmd,
+			    struct scsi_sense_hdr *sshdr)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	if (!scsi_command_normalize_sense(scmd, sshdr))
+		return FAILED;  /* no valid sense data */
+
+	scsi_report_sense(sdev, sshdr);
+
+	if (scsi_sense_is_deferred(sshdr))
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -539,14 +556,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 	struct request *req = scsi_cmd_to_rq(scmd);
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
 
-	if (! scsi_command_normalize_sense(scmd, &sshdr))
-		return FAILED;	/* no valid sense data */
-
-	scsi_report_sense(sdev, &sshdr);
-
-	if (scsi_sense_is_deferred(&sshdr))
-		return NEEDS_RETRY;
+	ret = scsi_start_sense_processing(scmd, &sshdr);
+	if (ret != SUCCESS)
+		return ret;
 
 	if (sdev->handler && sdev->handler->check_sense) {
 		enum scsi_disposition rc;
-- 
2.34.1

