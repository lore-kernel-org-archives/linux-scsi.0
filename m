Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C464E8FDB6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbjJCUxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241106AbjJCUxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:53:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB96BF
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:53:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I4noT014379;
        Tue, 3 Oct 2023 20:51:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=NOev7xyoovK8ktsV58b4Le1y2SkZuIC477t/WP9J80Y=;
 b=KjbLmMlk/Cldj4RH8C2+of47y4kjDCf+RjuBarMikhPrziqLzbMsP1AwTIVdmMMYonQo
 6OI7HPTCvpd/OBqwrV6L9tLadA8StcA1F1Y+fgZv2zdAc7+cxYXhxd7tMINdCC2LKLD3
 MDqX7vzwM8mlteBP6RSr8jB3JUPq3C43SM0jZxnsF2sKhyw8l7urjOa+CoyKBfxQAwbi
 iCyHwDUcRGqBb9KyO/fYHcTVc0UL7+0lxDz0/rwvUOMltJk+JgUIrQLCHz8RLnCGlbVl
 n84LsQWa5JavW1a2F8qSBntw42+P5dYeJIhEmRj0wQknrIyvZSRwWv1AcALiOuBVfsTn tQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea925ryf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K0bYw025731;
        Tue, 3 Oct 2023 20:51:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4d11kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTc3hUdine5sskQmpG/sHMyz3SM8Fort/mJ9iF13ufnjSBMGEPhXJlYZPwFwvFvYR9r7odUomGHTHOJ+da67bK0BsdeDNg8fa7YYElaSxHu1cF/stpQqCfbCBTLMATi71jYOK3AEGCBY/xx8JzApOlaPXtqXgDcV/Pr8N1DX+1eVAEU1LODlHT03b/tYJlPhP2u1JvNXJOksca+Cvc+DjNPA65riotE5Jfjbj5xiAHRm0EusSVEGsJXFitpVc+WiB+fCKC5u8/RkIEgjWC0tSBxsygk2G8tjD5eBKPvOvkU2ac3LB59YyMRZ4oEG5EoNhIQDXF5OTkFiUFv5a1Xk3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOev7xyoovK8ktsV58b4Le1y2SkZuIC477t/WP9J80Y=;
 b=lZjRmp0fosq2qp0Zyv/Sm57BPORb7Su9e8ukbDZwK77oBEDKjQGh11MhurPR/pukcRx3eExQBd5+KN43+9sVEa0ZRXag1vRsjm5KtdxRVmq1GUooO9wJTLvsT16YOM3Q7Y3uqQvNRic/cBgYFcDBMDbCQVw7i4JJ6NDsgxUxCWfQj3Yo89spmUwU5dQhUFhvZRJT7/xQKqIu1N1sm0HVU99hRPC+i49gzaE7lqZAi+AGqQv3qHSWN+QELjJlK0OqNi/gDBD2Aw7ZkRxjpT1NLD9ZRblKY84X0YP/+0ohA4XDGXmwvYlSD9lb4kZQHLqzLXYQdHL2ibfm8CEHouHq4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOev7xyoovK8ktsV58b4Le1y2SkZuIC477t/WP9J80Y=;
 b=ZWrskCB6RQI9QTDMcrFPJj1ZXkkOMriVzWjlAQhfgJi1d1o8Ld7yxEbssXYhW8Lk+xcmT8saZB6VicyT8c3Avm5qHXxUq/vuLQWxDaek+q1zrsx4zolFiOhlCEpoFZNJhKVVala8rGeg7yPiw0NNXF6DtGdZi8WV+PGR1dlu5tg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:03 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/12] scsi: hp_sw: Fix sshdr use
Date:   Tue,  3 Oct 2023 15:50:45 -0500
Message-Id: <20231003205054.84507-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0003.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 613b7019-25f4-4a37-9a7b-08dbc45274cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: daqCkMarzbbiaT6aLSlrcJyw71ZEZDgLX0CIW5upVmtQOO5tTnnCUNZkouCvYTbhMuRSIPeGnc9CZo1gJW0LiNXU+pu8Oxbfqi9vUfScOlQalq4R8tXQt9EKZxa+ipy3y7mPVKJo8KRKdNJLD6xc2X5U+h44VVPPe3Ugo8dS7PaiQ27qIpxIdPyxEa4flDUHrx40tfTzPbbCp1covJBUlgojt1TGyCeSm2uKzDpNIXGqR3IpHrv+8BSFeLaSzle16SL/Im23yK+PeRWJ3k+MR7pyeQ2eB0iJ1tlxQDwx38631Jmp8t3pOgCVkaBK6Z+9UcndG2HQqHzPvKvgYhVsIJewCdB98sDLUGY7WDkJSBkSgcb6paImEJjiUg3uWyaZDVeKmjkGgFxAkfzsBb5HmxIVlS37MTXxJ+BDtjsKN+INUOhhkC3+wo/NMjbnsFDVupG9CDJeZ4CdlxJSQrQP3oPrEo4neTH+VNUz83OmgXNy64zRxhnRuJbuHJ5axdfW1rXq+aeFVo8IL+8x6Hu1aojOHapkYIVcYWDdEj1ugwhNmIcee6aZ+KEPGvPYZMEV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MiuUNt3xtVWpbv45Yox2O/Zld+nDg/EMX8fA0FmtM9YbFRlUqkTKgaY6mTLF?=
 =?us-ascii?Q?lta5HhIgay+s0OzExxVYWRO2SlEWUTAyIlr6RMVdvG67kGEn2WAhVU9r/2GD?=
 =?us-ascii?Q?oiz3M0/TpjTgCyHoOuOxaoNQFl4VjUuYhGbu9RPCZIdj0pg2bGVo4KuJlTGO?=
 =?us-ascii?Q?9Ln9/TExhQlFjy/Q5VCMKaybWKE6B07hiqSIIuIPZ9QikHYNAv4cfu7utP0G?=
 =?us-ascii?Q?tns7jy95GDMX14GAtB74du5SuuwSYRfuOJ6pHhTw/g/CaV032xEiHHq1sATU?=
 =?us-ascii?Q?1ynufJ4/ITVYoPXelrAKSgtAMfzvfvdkkokeTyFzxBQn8UnAxJZi1oFvyj3O?=
 =?us-ascii?Q?B7sLSTJAveza3MV/x/vw60Ff8i+iDt+bVcAhf7zVxU3GT+Z/agN4Oz7Aev2j?=
 =?us-ascii?Q?ipEeaSfcnX7K1kf2sJNV7RBTkN1K+wjP5rTNSQqcol4ne1bM13cmbbrn7Kk2?=
 =?us-ascii?Q?ThtWHa3o3NJhrc/dFVFlZqU7CWX27l1XoPvNctqX/chNr/lz2CDE4K5c/chC?=
 =?us-ascii?Q?p2zeaYbfQGWXj8MN3gT7tvQq//JVBg0H0PIy1JVkJ5NQ5bazRe/XKE/wb2/c?=
 =?us-ascii?Q?HeVxcZvL0HSVghq7L6eBJybmKhTwuzGsBdztdek8wLGFRuu0p7LCiXWFZFL/?=
 =?us-ascii?Q?qguAGuY/7k8VoWliqFKV/j82N6CES1/QhX6SlkRWqBHZUny1YcKwErk+MyIx?=
 =?us-ascii?Q?D2gak6eKmmIv+wzx9NNP4bybnfBQloAH6FI4OQw781E2fF+DYmcjr3/hMuiZ?=
 =?us-ascii?Q?opYxo1CMAMPXZxSi25ybVZqQC9SyP7z4M5Coeq988rO2bljLF+XJHsQrYMWY?=
 =?us-ascii?Q?H4YUGtzSx9axVL6G4gqs2VmIwDawmba/h3WMwzP5SyyBOZ9EotPZzbpJZbGV?=
 =?us-ascii?Q?8+ows/QqeKzxTHIen1zj9jrdu4dPLTzo9erCEoHeQvtplBqVmcz8L0kMaadV?=
 =?us-ascii?Q?ekFLSEwzrXm23q0A4aHIS17MWYSjgKgFurCrEk5GVkQnMVCDiaxMeNHlw5M7?=
 =?us-ascii?Q?xKQENUejKBQBARArJPXdpN0Xmm9PFLVw/x13J6bpWYrMPzDufAkTDBwf+Ekv?=
 =?us-ascii?Q?KlXrJUpDSwiwlhVLqwQI8NqNM2mGvsFtP4RsRsOH6cq7K3c1/ipRaJ4EvNsO?=
 =?us-ascii?Q?97zCnY5BB9sM9b1zg9MP71kkEA7tk5Dlfq13UB14yx17azVM4iGrATVqZ9i8?=
 =?us-ascii?Q?fpKPAwUjVIW424Y/MafVZwBQGAhkxvmv5Tgdr4mh907D0yyDuqQjtg0Jtnyn?=
 =?us-ascii?Q?xK2onJ+hM114lg6eSjV0hLfGXRUw7IEImyoRO+3g2TB1YDp2tz/auVdcn+St?=
 =?us-ascii?Q?6V6F9jwFEqbBwYB+Cs5uDq56MqRJJrR78fZxR0leh9CyZAwT0B7jkrAOMpQQ?=
 =?us-ascii?Q?zmWgKTNq1QakhkbpLE9qMCVn7ucxEGvnlm+dWHlExlOScth4F4BYyV6SRqo9?=
 =?us-ascii?Q?Fdbj7B5hd5BJSapqZzLIsAwngidRhMkVXf7+oY+gNsvYPlrmX/UFECLbPNgF?=
 =?us-ascii?Q?E1QwkwMlR2gPVX8DKiDyp2kuxOTUIos6rlFgNe1MkqPF4yiAUfI3aoL5hayF?=
 =?us-ascii?Q?gsG07vHaSyC6OLjqwAa131P+D/hBFlqvbqvvTNhjhvdJc0VhLkHsDMEZIoqu?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QxjdIa8gSA0G4YAczniy9a0JlkdjVHif5wiMG/PmVF88MujIKcKta1MA3EkJrvYZZg/XbHZraKAyuPHA/aDhoyarX+zk49SfYOcpbzO2Axmh/MYlNdnWL5NQttQM7irPNnzOe5qBclssNhOhWIZhM3lUBHpOfKOyjkHyUgjFOs9tGgA8S4LVrTrkHGcC+XJNCy0eRY2XtoeuaJbLRmF3m7tDRtRauUZBFFZMwGszOGJXdoNLWKiaMbadvsrT/R1Q6LGna7ZAIspDPB07DrDTRU91KUyESV4TnoLOPsrb/AKej0+Yy/XsRs8zqV5StUPh6VU/WgTwaqvailCBKTt1sMHEb1JSydI3qcSqdcNlh9vm9OEmecB7xNsAgrD8ZEOb1vuI5+bv16dFoWoEmDQG+MYcDBeQG4rxwqclaz3uHRmz2piAlpMEf8AR4j/U5yNVr1MVsGtJwPS5JdBAOSQ2RbP5NrVHXnJSURtZXuHMQ/iM2hCoAI3FJW62efF0odT4qU7WbH/PKm5ehFh6FzBej0AhjF/G9L78KrnC468SRpzzYNtSu08reC8ruFynATG8OGws8A3fAxXo0mynGBiNIs+AUCM05icuf3NDGlO03Wmq8qTne2K1FLWze7t0tys96IUJNeyydvTf7P8X8Wks5aQPUa59SsXVDP3WXsTGwcW5370SDHlKKfuw+e7Vz7zNw3WNmIEkA9eYi1YrZv3+Tc7fW+aG63ccREN4AFYHmmVAaI0cbUHylYWq2P9vM1CTubBy4pwx15THPiefVAtC8jk89nKCc8B87S4Lo9UrYTCZTyM90xnFQmKt9+PnTPlCDbkYufGh2s/zaxwTORkmIhDr+o3QE9/I7Mw9mi2nWp8YaThyj4p8uHyynbrdqcC9
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 613b7019-25f4-4a37-9a7b-08dbc45274cb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:03.0270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HLnMDhqHNHyJiGW+W6oVlzaNTUumJ84lSlo+C9AGjin617ftKd8PYIFoTjdoDpYxtD5XPSyByvybkv1pmR3jt2KGZnOuRpHe/Ea+ivg4xI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030158
X-Proofpoint-GUID: 7F9ENLAdQPTNzmTs4CdDbcCPB4x21ov0
X-Proofpoint-ORIG-GUID: 7F9ENLAdQPTNzmTs4CdDbcCPB4x21ov0
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
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 79 +++++++++++----------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 5f2f943d926c..944ea4e0cc45 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -82,7 +82,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 {
 	unsigned char cmd[6] = { TEST_UNIT_READY };
 	struct scsi_sense_hdr sshdr;
-	int ret = SCSI_DH_OK, res;
+	int ret, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 	const struct scsi_exec_args exec_args = {
@@ -92,19 +92,18 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
-	if (res) {
-		if (scsi_sense_valid(&sshdr))
-			ret = tur_done(sdev, h, &sshdr);
-		else {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending tur failed with %x\n",
-				    HP_SW_NAME, res);
-			ret = SCSI_DH_IO;
-		}
-	} else {
+	if (res > 0 && scsi_sense_valid(&sshdr)) {
+		ret = tur_done(sdev, h, &sshdr);
+	} else if (res == 0) {
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
+	} else {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending tur failed with %x\n",
+			    HP_SW_NAME, res);
+		ret = SCSI_DH_IO;
 	}
+
 	if (ret == SCSI_DH_IMM_RETRY)
 		goto retry;
 
@@ -122,7 +121,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	unsigned char cmd[6] = { START_STOP, 0, 0, 0, 1, 0 };
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
-	int res, rc = SCSI_DH_OK;
+	int res, rc;
 	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
@@ -133,35 +132,37 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
-	if (res) {
-		if (!scsi_sense_valid(&sshdr)) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending start_stop_unit failed, "
-				    "no sense available\n", HP_SW_NAME);
-			return SCSI_DH_IO;
-		}
-		switch (sshdr.sense_key) {
-		case NOT_READY:
-			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
-				rc = SCSI_DH_RETRY;
-				break;
-			}
-			fallthrough;
-		default:
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending start_stop_unit failed, "
-				    "sense %x/%x/%x\n", HP_SW_NAME,
-				    sshdr.sense_key, sshdr.asc, sshdr.ascq);
-			rc = SCSI_DH_IO;
+	if (!res) {
+		return SCSI_DH_OK;
+	} else if (res < 0 || !scsi_sense_valid(&sshdr)) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending start_stop_unit failed, "
+			    "no sense available\n", HP_SW_NAME);
+		return SCSI_DH_IO;
+	}
+
+	switch (sshdr.sense_key) {
+	case NOT_READY:
+		if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			if (--retry_cnt)
+				goto retry;
+			rc = SCSI_DH_RETRY;
+			break;
 		}
+		fallthrough;
+	default:
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending start_stop_unit failed, "
+			    "sense %x/%x/%x\n", HP_SW_NAME,
+			    sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		rc = SCSI_DH_IO;
 	}
+
 	return rc;
 }
 
-- 
2.34.1

