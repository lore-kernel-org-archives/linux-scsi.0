Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E29C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJPUDf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiJPUD3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:03:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEE82615
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:03:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GD7nOO013302;
        Sun, 16 Oct 2022 20:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4LlbmSThvVhxDqjW5AcPdYBTOYyTXOuIh/PUoH24gmk=;
 b=ApTKD92j5nF6ta//rAbhvcwP/i0kHfK+8YdgSfq8HI1X3vbLHrNq524MJ+JU9vlF592B
 lnT4Dt1zUNvwgmMnKujEH3bsstsSyzskAUudJdHVkLDdbvUBBiCC8YPuGh6jM33k6jFf
 5saz71yId5gh31o2GiGIAV0u5fJO/KdDFptsAD7TKbzJEIdl1AJBMf8chwqt4igjn0os
 GR6eNpToHQWGZqWLe+WtaRxVR4ulAN53cGQ0mc64ikHmHXSBTZa5gqFCI1z7QZzmLfsL
 Qxit6mWOcrFqcxdgQGlaIwR+KZdxhnYYY6vI693jWVtiDGgiYDrCcXJAOxXPSIJ8qxEA ag== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k85mfs5rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHbSj034322;
        Sun, 16 Oct 2022 20:01:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54e0w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgZAUf8YRBMzo9z9aDV6WpyWFFgnMonq4DChU9jNdcFWCzVk1vYgxaPIXuiQsde3FSHF4M2WXUiZnhcnx0f9IMzo7hX/nybsSiqjsHeaEpRwdTIP9hgAAGl1Q0ndF7i6iUwnmyZv/wjKwOo6cQhD2sUqyrxYzZmg8N1CEt8COTgEqQ2Rz57pnwMTf0ZQIloQ8GYLJpSoALXPkJa8MObFPSyjWs8jrJV5mUcoYWuMBrmWDG7AKabOFjhzctq23gZbU/HNPfQ8iMNsstKzBu06HifQ7Mxl+uXJNz12XxZgiFg7SjvgT/a7azLTQVnBFKEYzz12B0TncO+zXlbd8Dcuww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LlbmSThvVhxDqjW5AcPdYBTOYyTXOuIh/PUoH24gmk=;
 b=RjNmBtz4JbgGiXpGCucYyKPTmN+89SR7AgyCthNhvakxWf8SCjQKXB74YsCsQO9jaP90B/1LzCxJAPVG2/0xeYRDIido0aDU48jcZGo9MWqGiQkE76LmsW8X9wXHgcaq3f81zmN57aeqI9qRdpBxX7SEBkx1t0BCHXLgGaMautuMzqulvrEKmviM+pHueJtorI8Lt5KsC8LaK9p9RKKtv3O7iz1Judb0h0qvG6zv/waXOhJYdSElp+zgTVXUlKd8xo67qGG+QutXKGLAKI4b2vewK8cYKTVso7AWivuTK+eSP0GVS85FVxD0Hhj1T8U771ocmGV1vnPhR+rFHpmpJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LlbmSThvVhxDqjW5AcPdYBTOYyTXOuIh/PUoH24gmk=;
 b=YqdpMhFuVIeIULP+ORe6ls9a7YyXttRfiff1NRLcNx75472VgdyI0EWZ1NwGL6Q10Pdyi8io3KpgAq4RXpoAyekZU/9WLA6FflAxkX+oKaNV5APpq7jLnHG/Rvu8UFo5fG1q77goXUn7/EZpnRPApIP4toHRlm9zvehRIdF6yO8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:01:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:01:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 31/36] scsi: sd: Have sd_pr_command retry UAs
Date:   Sun, 16 Oct 2022 14:59:41 -0500
Message-Id: <20221016195946.7613-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:610:38::46) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: cc224a89-64c6-48aa-8679-08daafb11d54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gO15dZMelt/slv/dCiPkYUv1AOTeMTiUJCyCub57Mg6sVigshiVUjxTeKqWLw+XLVSPn4+qlrcwYyLE6vDKr7fw/mb+hOwfCiaR4Xsv7dO+k0xMlZQZHMaLbGEEuNpxwV0Pax28pExwPSlI5wnyzSkVq3GUxFje0zwLjlMQpan2J1ZRFzSGwVFJj0KdEjsyKoNZWK37fUze1U8mJxaCr95jwxo2GCYjJrVamZV1rXEjxxLou2yFT2Q89XNDr4mcxqKK+BDCdpWvfBatoHwd8FRDk06NIyeDP/OqYSg9iKGK8jGvWLNPtEX2g1dHiqWt+d3XIDgtFhmOY/rZmqE7tDP1Fw5yN4zsEQzVNV7JN1c3694mt6qzdMUFHyMJGwXTIPJOgvN6/scZYTI5TJot0GVpl2WYx6CiLyW8amT16+8PHLkq6Jxs0HQelduDRI4yCKWcbl47PWdZTuooeq6UmdZfPXkuhzAxlCoak3cnALHirKb8cRsWrKWflhBfUc89MUPMormw74KZikUchPKvd8WWcHYaNV0QoycRtTEFB0TafOsg3/uku/wKXXKYdP7irbqJNBoZhb8hWzaCzVI9+TBEVuCzvFdFgplb3HZanTImsmpm5hN8osmYRys6lGGvhxmba62NUepsSFReeamJ+LYQ1i/aOtT4Ef5ALnlkvh6OuXWywEWR7l2eb4kvMC/TVvtd98ENZKG7oUlhaoae4zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sDSrOxGPYAcoKiJpXemVQrOj4QG7mrZG8XTTvcpPyNHl+16N7U+BTI6p7pB/?=
 =?us-ascii?Q?mUnw36r6nbJ8v7tU1dOCt0pg3aB2ccVtRDomVBWw7OG6ihHv2MFIkh+LA+Ck?=
 =?us-ascii?Q?lcSTL+npKWv3DO6op6E5IrTPZUS64bLkjQLQCEgeQ7qRrEktF+sTtKznAkZw?=
 =?us-ascii?Q?CeZEuBInnFf3hjZPK5zUf0bopl9KCODWmPmebVqPcy8FNncJTfn3cMWHSglX?=
 =?us-ascii?Q?MeVPmtpcxFz3Z/28qp2r8csWE9B0B3PincYWN3lp/YGJ7xupPNBiRuQECb9D?=
 =?us-ascii?Q?jU3fS5gu/Tkgj7qsf7SZ+MeBvPXw003KcpBq3cEdwnAN/JbLv/3IEKwwZZk0?=
 =?us-ascii?Q?bYeb4sUt/pncFqSGrEU+38Q58WZCizQ9yQDro2E1a6MhUAiC+sePrPUk8I2D?=
 =?us-ascii?Q?BhxXyoGPAmZO91AdTSBGspJ2O5y6jFSg1a8o+ZMG85JCQeHBhT1TSGj2rDaG?=
 =?us-ascii?Q?Ktshilve4jnj/13vm3NbGLRnjzx5KeG1Y5el3SXtm9vG2v3pTOkFPq93bcSE?=
 =?us-ascii?Q?B04464S8N98lJ6CR4Oxikq9duVEp6Sxe5IUF1DFbQde15+bYyhcYAz6rKbIx?=
 =?us-ascii?Q?VpegqbT4B+fvC5o5qzheXg/3z7+aWKZw9uqm6x1XH1qs+h5s6myyULEmFqoJ?=
 =?us-ascii?Q?NuKHlkofMlEc/uAil8CFAR1fuw8/6fnBsUVcwsIhHLXl4zCQeDrx4/8mSueH?=
 =?us-ascii?Q?nR6GFRk+1U6aj0envCwTKB+j5Ow6CPbvX5PZkN1D+IkOYa2905BG4E2aDfjn?=
 =?us-ascii?Q?Sg3YSqjkQSq0NC/9tYgrhHpT7pmbhvqv8QFrmU1CiY+J8bthI3MLTuZ0YMe1?=
 =?us-ascii?Q?o2MH2i1ECbK1YLrA7guGGV0eMmVG1uCPiS7//XUE9rhpWnxONDCwy5lMPLuL?=
 =?us-ascii?Q?lqMMsjsLoS2mJvqvNlncLPPKEcMj4ZL3cuIl+GwfC4S1cCpwq2IiiUNMY9u7?=
 =?us-ascii?Q?TC4q6GkNle1a+Xb55yehvFzRRwYcFtSvS3esshLkW6GNSOgrQ27vjrWjm8fM?=
 =?us-ascii?Q?8cmmA471hj7KacgKGqPSvw9bMxzRoeKwIw9E4ZIHrf4b0L/9bKUPWZ3IDiEG?=
 =?us-ascii?Q?gPoAlVrhnyQp7A0KC7Q6NKBlufdcBlwqFnhENkXvJSHntNRXBkZtlCUXJI4t?=
 =?us-ascii?Q?DPJN5dknfUGgX+aZ/U2jAqTL3B6u8kNke/BV1ou6aIVchdXqVsFIHA6kC1wD?=
 =?us-ascii?Q?iTQM9rUfwOX5BkV6Cby3POTtfYG75cYbTCKmFEpT6Og/1QT5EAdmiayH4dCB?=
 =?us-ascii?Q?Ys9io0sqc8z9WSyC3/JDY0Wtzq7Nxp0q0BDWyY7JqQL7doqj6I5xOd1neiok?=
 =?us-ascii?Q?GywAKD7OsbUTcxTANvsWvpfZkgI1rzpWBNV0ntmHkrsdKw8HN2fGRcCo/osg?=
 =?us-ascii?Q?/KghvX3jgL8v0bw8GyhblKeb/s/Y48d3W/KF/cXbgx1QEkZNEbUXrve8zEoh?=
 =?us-ascii?Q?wMW0Zi3LYCLWU/gmlxtItudIJk68/rnaRAMRiw4Rf9ZK90cuuiuDKwwr1Tna?=
 =?us-ascii?Q?oRpInpDIweSzDLeASI6gDJcE0jwMS5EJnyZHiORitn4+Fp2ERf6AVHoJFvcy?=
 =?us-ascii?Q?hkg+3faCs41xh2Bv/KG6GPX/cyk21PvqmJUq6QkxaaOS4uVYNXFhL4uE3p/f?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc224a89-64c6-48aa-8679-08daafb11d54
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:46.4216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7iVcimQisTax5MXDrxunrzPR+TKs84vDKJHALxSktEVOseEWhQsyYReTxlDdNUhtm42wc+h3tFVIOnkAx0Q0d9bMZfsI2Yco4jhRA/u/s8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: I-74pOb9Ffyqwj85gVVnh2bD_m1PyNO4
X-Proofpoint-GUID: I-74pOb9Ffyqwj85gVVnh2bD_m1PyNO4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c0c29b948476..d19e2d20ad91 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1723,6 +1723,16 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	int result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	cmd[0] = PERSISTENT_RESERVE_OUT;
 	cmd[1] = sa;
@@ -1741,7 +1751,8 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 					.buf_len = sizeof(data),
 					.sshdr = &sshdr,
 					.timeout = SD_TIMEOUT,
-					.retries = sdkp->max_retries }));
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
-- 
2.25.1

