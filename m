Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF89FC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A7F9610A2
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhHLC7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 22:59:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64192 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233530AbhHLC7L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Aug 2021 22:59:11 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C2uee3024415;
        Thu, 12 Aug 2021 02:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+yPAJ/XX9/X1a1h3Nd8pCPrAWepoxXkqeGQ2gWbbMb0=;
 b=Sq55+Cm8MKLzQLlgXe6Oe8PEPGKh1+svtgXSjYwmygOWdSFDXBHxM8NXVAPILk0nj6ms
 b3xyPjd0g7r6jK8XmvRKl0sV9uOXhrRAgr36euVuzkeEWYlshPBxsCD8ZLbGMcqsCTEe
 p5jvStzLzhL9hzFFIbvt2qRSRNt/1gVT6KndtZ3uMsP7b44AVb39IMlqMmyReC0FcQNE
 4z11Mljj6yXRK/jiNwIKerJTLHHcmKzjJ27f4SKNn6E/fYy9EbgPoMI4vsY3KewiRiEe
 ksEN4WGO2s0vcBNKMt7mF/quRfyRyKJPitJPVkS7/xyu2MVacbFfMZ6agYR1p+egXfzR Jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+yPAJ/XX9/X1a1h3Nd8pCPrAWepoxXkqeGQ2gWbbMb0=;
 b=edRgLLo74BRVTaA69/QRYqKPzy7uvKXAWwZ9yrSpsmm7uMm4nz/4UMhaq1BHVTBWPRSe
 JxlqIcPt9Dw/jjZoPDVgLO2hKKSyhHFdKs2w323KP+UyNiNF2WCrItMRj/dlc7wjT8Yk
 JjfWzpGcuQqLSYc/47zPjxf3iEKlh7v29Jz26i0K7vUDvwb9iIRffOtnGLtawSiuDhHf
 Ymbelca/DJ3wjsChWaD/kjosIivbCnUdGoKZgJkxlDc4YUvndItZc4Lh+DkuGmEM4yZh
 UwmkFvDu9T6iYjpqpvuMT6m4Yohm0UvSpzMYKUkQEtwmrDXvhUXf9MygO3LWowb0G5o0 Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3abt44c7qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 02:58:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17C2uIPD032736;
        Thu, 12 Aug 2021 02:58:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 3aa3xwc8rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 02:58:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIqUl6wxgXbw+3KfCYGHNmGcm++C/2FrfhiF7hzYQLwamYt3aU+J3RMdLKVr43OB/NJa72DAor99+enMc7U4wc/QGiYT3IQeN+OVpioP3bFtyQvHw/kIBy7oicDhtkNPXeA+7v6ooQRjED9T4LcWSAqW67QbacZmk4zbYD7mO9sGbyPviZbq9y137MnAmy0peqjy03qZ8a3A+zu7hfnnHspw5TBewARowvqZxeQPmTg/2aY23pjdX660HLMlks6PPIoomkEMpvHu7E81UBqKgzOteQmqTm3azecAwN7Mi9YmD1mHVBIcKPVRALm7G/upTvTyRLtHP1YtTnO+sVcXSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yPAJ/XX9/X1a1h3Nd8pCPrAWepoxXkqeGQ2gWbbMb0=;
 b=kkPRKSC4n2oqfQJoPGwI9m3ML2MsY/SHPyIabyqdV/SSb5+YraFUXMI04R6Y3vn1S5g9bRRbUNmLAGHQMHVL+wwm4agCSAOn2sgI6aTbo2gwgzLb9MejyurBnm/+xn6ovNc9nJfSd69Vcpui2CkgYrZahijcVIUUTU8S6ufgDA4nFYg8qmUVUasYfghjqdbtxfj/ixOpW/3g45xfWSVxALzRK1RHOifYRG2pJCmEWSkNAEufWiS5gcwfeORyiioNC/DbiKEKXc6uXc3bzq4X1BKickqXquT+aEqTdZAobuzDMdZziNbvZ3uWTkB2h2qpAZlWDY7OS5u7mWaXJ8wYKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yPAJ/XX9/X1a1h3Nd8pCPrAWepoxXkqeGQ2gWbbMb0=;
 b=EDzhtF1//OjAoVSMssOdlxRm3Q4eN+iJkn9sDHQi3NNr0mrP+aUrN+nPsrIyCCj4xNcd1U/BJMpWXOAIc200Vtt3o/oShsl9Qw0LBbUd3nITUtai2GPYFb9aKg0cWGSNWQ9teuImtDVhna9u7OZxP58BUqWwi8yS6Mq7wFreuS0=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Thu, 12 Aug
 2021 02:58:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.026; Thu, 12 Aug 2021
 02:58:12 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
        <20210809230355.8186-15-bvanassche@acm.org>
        <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
        <95223f29-1ced-a7a7-7fc7-90a3578f0447@acm.org>
Date:   Wed, 11 Aug 2021 22:58:10 -0400
In-Reply-To: <95223f29-1ced-a7a7-7fc7-90a3578f0447@acm.org> (Bart Van Assche's
        message of "Tue, 10 Aug 2021 09:16:25 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0005.prod.exchangelabs.com (2603:10b6:a02:80::18)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0005.prod.exchangelabs.com (2603:10b6:a02:80::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 02:58:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25acb8ce-4060-4eed-bf7e-08d95d3d05f5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46803ED5D6FAF5AFBF80A2768EF99@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRKpm4RWZLm5PGrMEaQ93DVGUnc5SXyk41bLeZGpOt9zDeonAfH6IpydERM8JIrx4DP2+LXZQD07t/GZl+b1hiAoXTamx8s76yBpa8Ls7oeECfJItnnrvCKc2RutzuUDOcZdiK6oQz94YsvNQiqa/YUoyLhFqRMGVXwmEO1ae4WYz15LAvIqbuI7Ii5MjYBOpaIk3hCJ50Cj10HfxwwdC5uU9wSeyZGj8IFhRj41RU9LpDYgC0pgQz9WNkAbXIpwsTXFWDt2XwLQvlBzcROcehjaYQwiRubgPBNC7jEdJ9r7/Bfo+lNIW1Mk5Wz3HH5m4oS/p6bdkjz1ETsEBy2+3ulEv4zHyUSjAY3uTvoBR2vDtGSM8H1zYjEo1Mb+7fk7gQ2GybeIGlRshIGeTfYjoX8octPmG9K8sNsaW3/ai8wJkfcc0hIu/DMjRWqgp6VNy1rn6yGjwmldNAHErexKU5Sav4u35127Bjy0cTLVYdvgjCnK5s/smRkSA3q2tAR4z4Lb/GkX7xmFh0oH6MXhzXjR/nqpWgTtM0bPyWlAG/9xNm7tEw54cMB16vxaNPr08u+wKTysRSpuppN6MghvB6JrbO5rkRB9Xil9CocrocDKir2XCfWE7p2L1yLvw+zqoLRwngaxYd9zzVdrykQjzhaHE2gnjCaWmnbX6er0wQmEFyF/n2OJusjhhdwlyDQVqz2AT8IxUBntqwCYkcMnGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(7696005)(316002)(52116002)(36916002)(54906003)(66946007)(55016002)(38100700002)(38350700002)(86362001)(8676002)(66476007)(66556008)(8936002)(6916009)(956004)(478600001)(83380400001)(5660300002)(26005)(30864003)(186003)(2906002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RhYft2a3AtBUOQ9VljlRSPGEUzmKPddiASsZANG2mg1O1A7mqZpHUmFTaqyF?=
 =?us-ascii?Q?0HxOcIzytL8R8KC1lxMqB1rBF18aaHJ3ZV5bfYNjLmSnWFS0MGCOOkDQOx26?=
 =?us-ascii?Q?RTNQAGZy8nSIBWT9zwTWbGGXQCIu6b92RZGa7WJyq5H15wkdU2+WAyZ1qio/?=
 =?us-ascii?Q?ZPXeSRli7v9V18ndrb5GUorB+TVLl/Yb3XDp/sgYAi62a4/0AO9lpKFP2+ga?=
 =?us-ascii?Q?eS68+CCMMxKPL5zCNP+KlVw76xbLHbYxvvOce65ovP34ueGNrr1vA5O4Aq3X?=
 =?us-ascii?Q?Qm77xh8a0pTWQiN3ME0VtxCqHp6wcvvLfZDFUw3/oUxWHslJvk6CjBjhDjf2?=
 =?us-ascii?Q?QCiQT2s7djsO3lbcbdDU7sIauW6olptgXbAO8i5hC3+vcoGP6AOMJwgZe+FT?=
 =?us-ascii?Q?RRZGhei0ukLlhfoz7aGEhT92oFQRmH0bHU0zjJLGoXhiYbHOHQhdnOmiUddr?=
 =?us-ascii?Q?UJTGYDgM55vxA3kzOaNShaGwn2NLeH/2bBbvkZ85NtwsVNaJeRHaYW9pfKMg?=
 =?us-ascii?Q?SQhu/yPvawsa6RtCG/7WxKPk1Jxc5EJ+ndvuLuvWvBC/OYL/1GNDYDfVWTqW?=
 =?us-ascii?Q?XcKRrbKpXc/N24sC5y4ZKuJhrMjInNkWjmDTTQ1itEdFyUX2ouU+CWEAll5z?=
 =?us-ascii?Q?TLego3im8z6p9FuAAmpb7h4gQ5krYihpozCcqLEs3xVv2IdyWrqQFD1jmKPP?=
 =?us-ascii?Q?g7YiQw8rUKaXZ1LU2IO7vJ5sytFPXanKguuPl0y7J0eNglUDB6ApmFOXDNHe?=
 =?us-ascii?Q?BwKj21+1lr8gFCx/mSL2HkIIVcmUNyvm2YwNG7zx3cwEptbKgrfrJ8B1zEII?=
 =?us-ascii?Q?me9jknn9agEqKBW7CzJS0x+9BgDkgn6Rcjj9kju+6CxA/ThqcbKQdICOFhf+?=
 =?us-ascii?Q?tqiStCnYdTw+5EjgKWv0V7uhNz8LDCuuGw6px4nTfd9CPzKUel8/ECPwOWPN?=
 =?us-ascii?Q?bX+dmG8vjkhQgiYMQgOHeQZdoMlFKnv/9sXZzPsBCZvlab0kAWsbjF0eJS/3?=
 =?us-ascii?Q?/i9e39gFNivf0OB6b5Q6wJzq/lTT2zFgZOu9aRNIVCubeq+h7DsTawR4A5nd?=
 =?us-ascii?Q?CFG9mRH2kR9DQdua8WiG3abXoEACtSxVA4pPr06bLvgwWw9AuDYEWauMWPjx?=
 =?us-ascii?Q?CN774Um9s5P4zY5APKTgeRiR2wiz8hPNbP89qCwujMhQGl6xY4ZpnlEZY2F0?=
 =?us-ascii?Q?j7Uj61AuR1BRyh0qIRD88OZP9LFLTe5TW96WjL5kxqb5xFqSDlhoHRWYpSlu?=
 =?us-ascii?Q?QeUQkSbYUd0n8wPEiN21ZmVBJrESuEdb/V7q31PFUa14+SZ1sQdDPVfAkX1W?=
 =?us-ascii?Q?8U4c6JEuXdoh3/MPMQ1emMp5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25acb8ce-4060-4eed-bf7e-08d95d3d05f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 02:58:12.5160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycUf8n+C/h9o+J4v56m+Cr/e1j2ruFH/A5XZPzEhQm2Wx01am0Lk03CypFIbtV7Y6P4xk/H3MnKOKgAar6AqfMi5t2vkArsz3m01hG1NCUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10073 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120017
X-Proofpoint-ORIG-GUID: K9TE1VRmCUAWPmjiYSzZNGAzSs6vdKYx
X-Proofpoint-GUID: K9TE1VRmCUAWPmjiYSzZNGAzSs6vdKYx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

>> Cf the previous patch; we really should introduce a helper to get
>> the tag from a SCSI command.
>
> Is this something that you plan to work on or do you perhaps expect me
> to introduce such a helper?

I agree that getting the tag is a common operation and I had the same
thought as Hannes when I reviewed the patches.

Adding a dedicated wrapper would result in the diff below. However,
after having gone through this exercise, I'm not sure it's worth the
additional churn...

Thoughts?

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f7f630485465..ef2c3a3c9f7c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -631,7 +631,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 {
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new_init(dev, scsi_cmd_to_rq(cmd)->tag);
+	qc = ata_qc_new_init(dev, scsi_cmd_to_tag(cmd));
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = cmd->scsi_done;
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a12e3525977d..6595b394bbf4 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1823,7 +1823,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 
 	if ((hostdata->tag_negotiated & (1<<scmd_id(SCp))) &&
 	    SCp->device->simple_tags) {
-		slot->tag = scsi_cmd_to_rq(SCp)->tag;
+		slot->tag = scsi_cmd_to_tag(SCp);
 		CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot %p\n",
 		       slot->tag, slot);
 	} else {
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index deb32c9f4b3e..563e93cc3b9a 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -224,7 +224,7 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
 
-	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
+	fibptr = &dev->fibs[scsi_cmd_to_tag(scmd)];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ffb391967573..c536ea9c9e6f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7423,7 +7423,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * Set the srb_tag to the command tag + 1, as
 	 * srb_tag '0' is used internally by the chip.
 	 */
-	srb_tag = scsi_cmd_to_rq(scp)->tag + 1;
+	srb_tag = scsi_cmd_to_tag(scp) + 1;
 	asc_scsi_q->q2.srb_tag = srb_tag;
 
 	/*
@@ -7637,7 +7637,7 @@ static int
 adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	      adv_req_t **adv_reqpp)
 {
-	u32 srb_tag = scsi_cmd_to_rq(scp)->tag;
+	u32 srb_tag = scsi_cmd_to_tag(scp);
 	adv_req_t *reqp;
 	ADV_SCSI_REQ_Q *scsiqp;
 	int ret;
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 3b2eb6ce1fcf..f4019fdf39f4 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1989,13 +1989,13 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		csio_info(hw,
 			"Aborted SCSI command to (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			scsi_cmd_to_rq(cmnd)->tag);
+			scsi_cmd_to_tag(cmnd));
 		return SUCCESS;
 	} else {
 		csio_info(hw,
 			"Failed to abort SCSI command, (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			scsi_cmd_to_rq(cmnd)->tag);
+			scsi_cmd_to_tag(cmnd));
 		return FAILED;
 	}
 }
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 7af96d14c9bc..855113bc028f 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -652,7 +652,7 @@ static int adpt_abort(struct scsi_cmnd * cmd)
 	msg[2] = 0;
 	msg[3]= 0;
 	/* Add 1 to avoid firmware treating it as invalid command */
-	msg[4] = scsi_cmd_to_rq(cmd)->tag + 1;
+	msg[4] = scsi_cmd_to_tag(cmd) + 1;
 	if (pHba->host)
 		spin_lock_irq(pHba->host->host_lock);
 	rcode = adpt_i2o_post_wait(pHba, msg, sizeof(msg), FOREVER);
@@ -2236,7 +2236,7 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 	msg[1] = ((0xff<<24)|(HOST_TID<<12)|d->tid);
 	msg[2] = 0;
 	/* Add 1 to avoid firmware treating it as invalid command */
-	msg[3] = scsi_cmd_to_rq(cmd)->tag + 1;
+	msg[3] = scsi_cmd_to_tag(cmd) + 1;
 	// Our cards use the transaction context as the tag for queueing
 	// Adaptec/DPT Private stuff 
 	msg[4] = I2O_CMD_SCSI_EXEC|(DPT_ORGANIZATION_ID<<16);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 0f9cedf78872..aa8ed0f9fd32 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -107,7 +107,7 @@ static void fnic_cleanup_io(struct fnic *fnic);
 static inline spinlock_t *fnic_io_lock_hash(struct fnic *fnic,
 					    struct scsi_cmnd *sc)
 {
-	u32 hash = scsi_cmd_to_rq(sc)->tag & (FNIC_IO_LOCKS - 1);
+	u32 hash = scsi_cmd_to_tag(sc) & (FNIC_IO_LOCKS - 1);
 
 	return &fnic->io_req_lock[hash];
 }
@@ -390,7 +390,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	    (rp->flags & FC_RP_FLAGS_RETRY))
 		exch_flags |= FCPIO_ICMND_SRFLAG_RETRY;
 
-	fnic_queue_wq_copy_desc_icmnd_16(wq, scsi_cmd_to_rq(sc)->tag,
+	fnic_queue_wq_copy_desc_icmnd_16(wq, scsi_cmd_to_tag(sc),
 					 0, exch_flags, io_req->sgl_cnt,
 					 SCSI_SENSE_BUFFERSIZE,
 					 io_req->sgl_list_pa,
@@ -422,7 +422,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
  */
 static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
-	const int tag = scsi_cmd_to_rq(sc)->tag;
+	const int tag = scsi_cmd_to_tag(sc);
 	struct fc_lport *lp = shost_priv(sc->device->host);
 	struct fc_rport *rport;
 	struct fnic_io_req *io_req = NULL;
@@ -1363,7 +1363,7 @@ int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do)
 static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 				 bool reserved)
 {
-	const int tag = scsi_cmd_to_rq(sc)->tag;
+	const int tag = scsi_cmd_to_tag(sc);
 	struct fnic *fnic = data;
 	struct fnic_io_req *io_req;
 	unsigned long flags = 0;
@@ -1566,7 +1566,7 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data,
 {
 	struct fnic_rport_abort_io_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
-	int abt_tag = scsi_cmd_to_rq(sc)->tag;
+	int abt_tag = scsi_cmd_to_tag(sc);
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
@@ -1993,7 +1993,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 	/* fill in the lun info */
 	int_to_scsilun(sc->device->lun, &fc_lun);
 
-	fnic_queue_wq_copy_desc_itmf(wq, scsi_cmd_to_rq(sc)->tag | FNIC_TAG_DEV_RST,
+	fnic_queue_wq_copy_desc_itmf(wq, scsi_cmd_to_tag(sc) | FNIC_TAG_DEV_RST,
 				     0, FCPIO_ITMF_LUN_RESET, SCSI_NO_TAG,
 				     fc_lun.scsi_lun, io_req->port_id,
 				     fnic->config.ra_tov, fnic->config.ed_tov);
@@ -2024,7 +2024,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
 	struct fnic_pending_aborts_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
 	struct scsi_device *lun_dev = iter_data->lun_dev;
-	int abt_tag = scsi_cmd_to_rq(sc)->tag;
+	int abt_tag = scsi_cmd_to_tag(sc);
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9515c45affa5..45397c422727 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -185,7 +185,7 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 	void *bitmap = hisi_hba->slot_index_tags;
 
 	if (scsi_cmnd)
-		return scsi_cmd_to_rq(scsi_cmnd)->tag;
+		return scsi_cmd_to_tag(scsi_cmnd);
 
 	spin_lock(&hisi_hba->lock);
 	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3faa87fa296a..e330d3ac19a8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5686,7 +5686,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	/* Get the ptr to our adapter structure out of cmd->host. */
 	h = sdev_to_hba(cmd->device);
 
-	BUG_ON(scsi_cmd_to_rq(cmd)->tag < 0);
+	BUG_ON(scsi_cmd_to_tag(cmd) < 0);
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
@@ -5894,7 +5894,7 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
  */
 static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
 {
-	int idx = scsi_cmd_to_rq(scmd)->tag;
+	int idx = scsi_cmd_to_tag(scmd);
 
 	if (idx < 0)
 		return idx;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 26d0cf9353dd..77401a61ba5b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3381,7 +3381,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	cmd = megasas_get_cmd_fusion(instance, scsi_cmd_to_rq(scmd)->tag);
+	cmd = megasas_get_cmd_fusion(instance, scsi_cmd_to_tag(scmd));
 
 	if (!cmd) {
 		atomic_dec(&instance->fw_outstanding);
@@ -3422,7 +3422,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 		r1_cmd = megasas_get_cmd_fusion(instance,
-				scsi_cmd_to_rq(scmd)->tag + instance->max_fw_cmds);
+				scsi_cmd_to_tag(scmd) + instance->max_fw_cmds);
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 4d251bf630a3..38d6e4b61e81 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -702,7 +702,7 @@ static int mvumi_host_reset(struct scsi_cmnd *scmd)
 	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
 
 	scmd_printk(KERN_NOTICE, scmd, "RESET -%u cmd=%x retries=%x\n",
-			scsi_cmd_to_rq(scmd)->tag, scmd->cmnd[0], scmd->retries);
+			scsi_cmd_to_tag(scmd), scmd->cmnd[0], scmd->retries);
 
 	return mhba->instancet->reset_host(mhba);
 }
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index a4a88323e020..fe280b349b2f 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1551,7 +1551,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	}
 
 	myrb_reset_cmd(cmd_blk);
-	mbox->type5.id = scsi_cmd_to_rq(scmd)->tag + 3;
+	mbox->type5.id = scsi_cmd_to_tag(scmd) + 3;
 	if (scmd->sc_data_direction == DMA_NONE)
 		goto submit;
 	nsge = scsi_dma_map(scmd);
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 28eab07935ba..93eaed02a60d 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -288,7 +288,7 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	/* Acquire hardware specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	index = scsi_cmd_to_rq(cmd)->tag;
+	index = scsi_cmd_to_tag(cmd);
 
 	/*
 	 * Check to see if adapter is online before placing request on
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 31529d8add0d..5b892b043716 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5588,7 +5588,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			sd_dp->issuing_cpu = raw_smp_processor_id();
 		if (unlikely(sd_dp->aborted)) {
 			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n",
-				    scsi_cmd_to_rq(cmnd)->tag);
+				    scsi_cmd_to_tag(cmnd));
 			blk_abort_request(scsi_cmd_to_rq(cmnd));
 			atomic_set(&sdeb_inject_pending, 0);
 			sd_dp->aborted = false;
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index ed9572252a42..7a5fa30f1ad7 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -92,7 +92,7 @@ void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	if (!logbuf)
 		return;
 	off = sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
-				 scsi_cmd_to_rq((struct scsi_cmnd *)scmd)->tag);
+				 scsi_cmd_to_tag((struct scsi_cmnd *)scmd));
 	if (off < logbuf_len) {
 		va_start(args, fmt);
 		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
@@ -189,7 +189,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 		return;
 
 	off = sdev_format_header(logbuf, logbuf_len,
-				 scmd_name(cmd), scsi_cmd_to_rq(cmd)->tag);
+				 scmd_name(cmd), scsi_cmd_to_tag(cmd));
 	if (off >= logbuf_len)
 		goto out_printk;
 	off += scnprintf(logbuf + off, logbuf_len - off, "CDB: ");
@@ -211,7 +211,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 
 			off = sdev_format_header(logbuf, logbuf_len,
 						 scmd_name(cmd),
-						 scsi_cmd_to_rq(cmd)->tag);
+						 scsi_cmd_to_tag(cmd));
 			if (!WARN_ON(off > logbuf_len - 58)) {
 				off += scnprintf(logbuf + off, logbuf_len - off,
 						 "CDB[%02x]: ", k);
@@ -375,7 +375,7 @@ EXPORT_SYMBOL(__scsi_print_sense);
 void scsi_print_sense(const struct scsi_cmnd *cmd)
 {
 	scsi_log_print_sense(cmd->device, scmd_name(cmd),
-			     scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag,
+			     scsi_cmd_to_tag((struct scsi_cmnd *)cmd),
 			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
@@ -394,7 +394,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 		return;
 
 	off = sdev_format_header(logbuf, logbuf_len, scmd_name(cmd),
-				 scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag);
+				 scsi_cmd_to_tag((struct scsi_cmnd *)cmd));
 
 	if (off >= logbuf_len)
 		goto out_printk;
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index bd72c38d7bfc..c878d692eec3 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1230,7 +1230,7 @@ int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd)
 {
         if (cmd->flags & SCMD_TAGGED) {
 		*msg++ = SIMPLE_QUEUE_TAG;
-		*msg++ = scsi_cmd_to_rq(cmd)->tag;
+		*msg++ = scsi_cmd_to_tag(cmd);
         	return 2;
 	}
 
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 95740caa1eb0..6bdabb60f58f 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -33,7 +33,7 @@
 #include "snic_io.h"
 #include "snic.h"
 
-#define snic_cmd_tag(sc)	(scsi_cmd_to_rq(sc)->tag)
+#define snic_cmd_tag(sc)	(scsi_cmd_to_tag(sc))
 
 const char *snic_state_str[] = {
 	[SNIC_INIT]	= "SNIC_INIT",
@@ -2494,7 +2494,7 @@ snic_scsi_cleanup(struct snic *snic, int ex_tag)
 		sc->result = DID_TRANSPORT_DISRUPTED << 16;
 		SNIC_HOST_INFO(snic->shost,
 			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
-			       sc, scsi_cmd_to_rq(sc)->tag, CMD_FLAGS(sc), rqi,
+			       sc, snic_cmd_tag(sc), CMD_FLAGS(sc), rqi,
 			       jiffies_to_msecs(jiffies - st_time));
 
 		/* Update IO stats */
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f1ba7f5b52a8..3b8d788c6eda 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -690,7 +690,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	cmd->scsi_done = done;
 
-	tag = scsi_cmd_to_rq(cmd)->tag;
+	tag = scsi_cmd_to_tag(cmd);
 
 	if (unlikely(tag >= host->can_queue))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1246,7 +1246,7 @@ static int stex_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct st_hba *hba = (struct st_hba *)host->hostdata;
-	u16 tag = scsi_cmd_to_rq(cmd)->tag;
+	u16 tag = scsi_cmd_to_tag(cmd);
 	void __iomem *base;
 	u32 data;
 	int result = SUCCESS;
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e2278b0125e7..c3217ca78428 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1202,7 +1202,7 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	    vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS)
 		storvsc_log(device, STORVSC_LOGGING_ERROR,
 			"tag#%d cmd 0x%x status: scsi 0x%x srb 0x%x hv 0x%x\n",
-			scsi_cmd_to_rq(request->cmd)->tag,
+			scsi_cmd_to_tag(request->cmd),
 			stor_pkt->vm_srb.cdb[0],
 			vstor_packet->vm_srb.scsi_status,
 			vstor_packet->vm_srb.srb_status,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a3b419848f0a..a83981cc8b1b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2676,7 +2676,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	struct ufs_hba *hba = shost_priv(host);
-	int tag = scsi_cmd_to_rq(cmd)->tag;
+	int tag = scsi_cmd_to_tag(cmd);
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 
@@ -6994,7 +6994,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct ufs_hba *hba = shost_priv(host);
-	int tag = scsi_cmd_to_rq(cmd)->tag;
+	int tag = scsi_cmd_to_tag(cmd);
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3dfc7ed79ba4..684a48a1cdb8 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -183,7 +183,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
-	tl_cmd->sc_cmd_tag = scsi_cmd_to_rq(sc)->tag;
+	tl_cmd->sc_cmd_tag = scsi_cmd_to_tag(sc);
 
 	tcm_loop_target_queue_cmd(tl_cmd);
 	return 0;
@@ -249,7 +249,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
-				 scsi_cmd_to_rq(sc)->tag, TMR_ABORT_TASK);
+				 scsi_cmd_to_tag(sc), TMR_ABORT_TASK);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6c5a1c1c6b1e..99a1c61cda46 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -149,6 +149,11 @@ static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
 	return blk_mq_rq_from_pdu(scmd);
 }
 
+static inline int scsi_cmd_to_tag(struct scsi_cmnd *scmd)
+{
+	return blk_mq_rq_from_pdu(scmd)->tag;
+}
+
 /*
  * Return the driver private allocation behind the command.
  * Only works if cmd_size is set in the host template.
