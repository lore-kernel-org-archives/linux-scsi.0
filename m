Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D17EB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243344AbjFNHXg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243343AbjFNHWq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FDD270C
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jrip021343;
        Wed, 14 Jun 2023 07:18:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=7UfUmSlaq3YZ87JquXlhlTelvNGCUYkhgITvv2FC6IU=;
 b=kEx6cLEWRa74iZMi7xQ3msH2GFNcf2plI8PxLC3Jxh/uE+V8d+aQpI1egntvOQrH4dau
 PaDHezyhGhNkuYuhbmtWwHUDnJxZn9Nm/BDjE0vo1pbcFJX+u0z3iGX71pxVLUIAl52+
 lE6btxisBHxTSuYyjM8sP5fF47gQ+wMXqdBmI3pz7DGBH5xq4ZHgjimUI48KU6mH3H0z
 /rwhqtXWDYpfzKHTnoWlfCeDLTe9BSFcIoLkU5LmOFdSlA/f8Nn0gwoWzxNkDjfwD5EA
 J7RjKgomLGjhISzdL1UUjuQw2ZYgVJoxV3Co+X2KnMjKYoPYUBcyNQVfqVdzwdpfxhai NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3evsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E61KON016307;
        Wed, 14 Jun 2023 07:18:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56q0d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEOalJ6wJb/+zolrk2Srv7H3lR6GwoSp76bcVyjmYJyK3PpB0EL1dCFQT1WPVCfcwH263xzYVO6P1pAk9gSbc4/PC0nuw9TOtEPGSf2Ofr3G3/Q2FOQ6pm4FFLswqYRn95/tXJ2TXGL0+tBHaO7Y4lbUqgHs7yea6Tqtxd1VPkDWdXV/xqMFmjn0zINU15YatYfNpxJi1c5ayX1Dvs+RdQrnE61jqLkdSOYOJrL7kxRETKs93acLNtZLn4TXUr8D/NRNKap/kzBJxMG3C4FaqAl4sz7Mdlo7BbBoLHE7p0aEQG8QtgU93q/ttXuufZg+PCozJLxMTUwieQ7EhEEFjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UfUmSlaq3YZ87JquXlhlTelvNGCUYkhgITvv2FC6IU=;
 b=OJ4gvMGj6hW5jWr4L0lxKS9hF3iURPJoxFeyWLLG2Nv9vt3CTHpWbm+S5FgPI52uCveXxGwwFA3ob7CphIv7M9b8EZICXmbbRi2VPydueBICkzSoFRSPKQxkH2mm0UE6YnZE8wjBOkJ1aY62L+BBkAgrZarFNPjoyEKkqmGTAKZHAPiJzG0SGaqwRI/mKYmPUCRB8CKlCeEww0mGpmG6pw6wK4HYLB2uBRM9RRJSEugnq5n8Xb2xy1UTpmNDR7ZX9sm2CrTCgelo3Xw1v2jXrt53RMynNIkAOVAD7MHtlemRLgxll2ayz+5Cr1jbWG0SOGL6appTA3YThQt42RHhvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UfUmSlaq3YZ87JquXlhlTelvNGCUYkhgITvv2FC6IU=;
 b=kGka5apgeKoJ2/f5xByHRCD9uymZQzXJh2FFQiufeKmmvXqas/B4btdWSJmQKxFNB2msmcoW5bmSYR9qydwUn1x5yBmDUtduW6uU2+qbCN+5o3LcAfhOovKW1m8RucGG83niqlN3DubijceO1mFA1oUYg18e1Dc5yXZKzYY7Dmg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:17 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 32/33] scsi: sr: Fix sshdr use in sr_get_events
Date:   Wed, 14 Jun 2023 02:17:18 -0500
Message-Id: <20230614071719.6372-33-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::22) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: c678e915-13d3-4d58-336c-08db6ca78635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NjR+whon6d3GggMiMG8ZxSPyGZEYJ6FiwGl9rBizyFBTsU9Qti6tIaYmG8Rt18WDGQr948uuHEpK9ZAivvaxlWoyuZn1JCTTrs/M72KFoIB0QJmtKZMQ/wUkMM+oY46wag0mFl/hvmhieckr5a4EZSF9+6pqBDigCL6X55Cinln75ovVKppjojJ6ZKXlrl2Zi8+bJugHQVXQPCl0PKbd8QhDuYiD3IJzLDjVyXxKglnJ4WyuDWb1W2SagpqvGfahaSb7vK/XZP5wv58/8ao8QxWIU1Qz7o7z1E6StnMFbpcAnhfnbmuWZPGE0FjSE0E6AV7S80H+hM9U76C2icinmXKrR41rHBxXwCNmvHWD/qT2TM/TYkLpr3qg2VzABITCFqFaQOWhfHZ3+vFZM977eY5X+U1xgbwnhoWdGDOuYrAYduWzZLvaGKi23pF+5uZa26YK72ma1CCAnmg8qZBgOsVugaJWmhZQEToM6slepx7duTl0aamb7XWyH6X/LOHTMivAaruzhVIecjk6uTJX5UskD1k8R9Xgw/4NQEvIYKcstjpERN4VZ4/BCtd/677
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(8936002)(8676002)(2906002)(4744005)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dQCpbUGsJWpFTFpY2vVNYiWsX/vfOF3xyAuDKpGhXM3XQBxvRz/1KEj6xcAe?=
 =?us-ascii?Q?2CNEyo2i23h5zgf3HenWorWMt3gl4RuSzmvyeVLS3+keZCwPQ5PgmfgNhAPM?=
 =?us-ascii?Q?du5BXZZELCbYxBkwNAAcpnxpraxFUjSZCaBs5kZ4Vj+kc7VgpvTtNxDduMv6?=
 =?us-ascii?Q?XOQRLI7o94oqbJMo5GuNg9RTk6tMLZVmzWaLjNRSankdcsd/S0CExXuGigDM?=
 =?us-ascii?Q?tEk/dDPb09JIMu5yvIL86siYnyiMBEmwgmc+mUvsO+1P0qub5cM7m296g2No?=
 =?us-ascii?Q?SMn0bLAVnl46HwpV3ttc791mGCDFkug6iZIT7xcIIHehdmKzNm/xS173tp/c?=
 =?us-ascii?Q?9bpIUzoC1df5ACmgKHUqHoAyH+athxQJJuLiWw0Z0fcSenFiy0yooXeFXnvF?=
 =?us-ascii?Q?fMgv/aze6hw8T94WaIWBA8WTHvpRApMy2Gg9iz0wTZ8wou80FpbWL1jknuTl?=
 =?us-ascii?Q?diYQJPD1bycTngEmlap0EIfmXYlqQCAuMK41d+yl9iITWwIj6srlQUOpbbYC?=
 =?us-ascii?Q?nqElLm2rqDQrrkr8NfG7MtKBamuN14UDpVxUsXxzO1hX7xihPoi3V9Ycdv98?=
 =?us-ascii?Q?fHWonfyuhUSVntjXeiBpsDWnNmosoDY6bMS8MoVN0QQT1flUhgEjMKDD2b5c?=
 =?us-ascii?Q?K1Z2fL93rAmkXwvSErNVuFg/xIcDjaSfntKeo0WrdnR4JwpwS4G4cGS2DZls?=
 =?us-ascii?Q?fcZNDBouTG0L0rGSck8GMGoK54Xjw3k0Z347YrkI2p1OJAdlubrwKcIjOMNY?=
 =?us-ascii?Q?moqiQRlq3BdIyR3Dnhhcbc0UxUenT1HtEL9yS//p1fOWxsS3FUVUqocXKzQN?=
 =?us-ascii?Q?nSDtcTfbhLreaPr2nSlbKwqXNGBDhkjSPc05Z7NsW4SN7qqdV9KpKoB1OQgZ?=
 =?us-ascii?Q?3BJGaNSRatBSjylww7X8ak63uWYvcJk1Yrt4W4623XS48I84wX2E/Qbp91EA?=
 =?us-ascii?Q?wb8Txa5GtUdD9eZqnup/30MnE6I2rFFpm9Q76qizJol5K8KI8sx4QpwsiaKo?=
 =?us-ascii?Q?FjwxTDW3S75iXaqilplPM6j2SYKP6LOs8IMii48+fqzkJ+1vWj9OJOe0VOIz?=
 =?us-ascii?Q?v9C/Xq5suwY+bGsVyEXBNpYOXxeAwi7EN3oyuRmfrzMEauKaDBJ8XBPZZ179?=
 =?us-ascii?Q?lri6sJHED4Cx0piq/dN9/tHYQPSMWWMN8rljyiCpyxMjX0BLfF0mH+DFCJ8B?=
 =?us-ascii?Q?C36aV/gPXdcGgYn/QL6IP+ZouLSxN8DTAPx36yBh3Y5jRRunXneyS2wGTujZ?=
 =?us-ascii?Q?hWQ8VYHFVhPxThLNNoeCVBxJoHnmEOaBqQKdX3Noe66RPdj0I3TpuB7LDgnx?=
 =?us-ascii?Q?bRoAX8Z35fUgIzujdnSBsDpi42c9uzXuRNdvWMwrh75yQt+VAV4FqWv0BoQv?=
 =?us-ascii?Q?WOfy578wB2JW4ZMfkIeyal/QlbXjgFQ9tltzV3NLXz6FdWyRANNEZvJbpRgj?=
 =?us-ascii?Q?+f6+ueLtU12x3GBvVx7sKNf9YzuxEt7aQvbkZW7oEc6vbqkS+wDJnOeW0pRu?=
 =?us-ascii?Q?lmKBSplVI7lUlIXY60Bv27yGX1oATSD5cF/GXwgiK97ZmeE2SUDA7bDxSIR3?=
 =?us-ascii?Q?voZtPzYUqQ3wCzre0+HxV6U0DgBLNFsAyrja1piD4gUjxeo+T37K+AED6Uk+?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: A3o/fHnD5+iw2OEkTBeEMKnTsmjQK46HQCw09SpryEVd5edNRT8cxZl5Xvi7b/oyussv7CYdaU4vYtxgAgaaL9V6xsXykLxpREMwmM8ssFvhoZQs3o7V1ARWTgCLT+qxhzXFJbPdzOtW15EYKcQn29o7QxAwZapWHmB3q5rwQ4plnJyKMeqfVcFy+jRjbyGpwEHW4aLScK/mqVrsw4cQ+fWlN3Uffcmwn4h1K5fUxFYV8T5MxKJe2W7R14Y0GARbzZK01m0LApfQZXAfUr5Yd4Ic/ncJNmD7ZD4oHhWCV0rIyFQMu7r0/RGMoth/XgVVjBgyb3/PtPFFnzZ1NCzmVBHlRLk7KlxaP57WBGoM9DFVpu9ALIBbxVzBEVdgAvx46LWKqZdbYE8ywuXR+TsZwGUmA87I93hG9zoiGgqFPOLHxfrqIiqxmDLeZjjX/q63cGtjxY4gY5YKXDC2o8qAt/1HpbyKq3drro07uXEToOxge+HivXZJs2H+XKgyYxkTCFGlS/4XrxC1A5l0e0DvuTAtKqhQw17YOieyDNggY1p1pTJyYfv3VdCVGOC3Q3yNWgGIPQvWYecW5jRpRfQ7w9kxKWE53M6fvWdDJ75ObAK5nsEkydGeqwKvoqr34bOMgqHALE1VypITuXe5y2xM1PfCABTX3g9fDuXICSIeDBDoyy/SNc7s2SjYryh442l/AVA2lagAmk4YTVnxlIDlh3O6CUCKwI6UM5dCvSeoq10wNIs0Q99KV6Uoqcvvq0k49pWMuIAjfmOaqskKkC9A0A1E2k8ml1ItCQTuQn4y8bio4yTmkfrQ7jq9Ti36xlT/DzInkQujeFfQ7idR1Z2kaDcc3kBpawXBInn6oeQR31z8l3D1HbAzJ8scwaSOayMe
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c678e915-13d3-4d58-336c-08db6ca78635
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:17.1116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LRt2le+1hlNLMr2mK5y16gZBBV13IaOBq+myOf1wzmXrjHFzVbjjNy6BcGQgqsRQ4QfdO7I0Q30i/+ii8pDuFBdLM3ydAuf4xX3ux9oDkco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-GUID: AhomA05xi3QY3UeLfBtWZ3-iR51ZrI3y
X-Proofpoint-ORIG-GUID: AhomA05xi3QY3UeLfBtWZ3-iR51ZrI3y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0 it will not have set the sshdr, so we
can't access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e572700e8338..e77eeda89156 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -177,7 +177,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 
 	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
 				  SR_TIMEOUT, MAX_RETRIES, &exec_args);
-	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
+	if (result > 0 && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
 	if (result || be16_to_cpu(eh->data_len) < sizeof(*med))
-- 
2.25.1

