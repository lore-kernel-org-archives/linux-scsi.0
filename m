Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD38E8FDB3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241118AbjJCUx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241125AbjJCUxY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:53:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62134DA
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:53:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I56fV006336;
        Tue, 3 Oct 2023 20:51:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=GlTbko+4an/EbVgofn2WGWqLaTtQFO/MiJUZDfDTzhw=;
 b=fv6cvQTOHqxYdZUyJ3RY0fnF+hSg4N1jyESrx0J/4xcYiUV9LESQLS1NJPjhGpIE/4UY
 pHSBYe0iO1dILjYV94x4lBc4iDO9hV18oNf5bYzoQMNxvd05GxkTmHBOZR8gXXlRce4Y
 Ow5iOnWOeiYJZwLBcVTpV/ODgnhLozbfl5hNfcZ73XPfz6EB8b4j4c2txfvHyqFE2+Sv
 rpu0KWp2LAOQQr8CCP0OvF1nyG1VSpyy1z3KvC14YGEtQjh8LGzDWP2roHZtLmaAwHrX
 jEhWkzaGC9OG8xox43bofaCIaaoZ8fA4befeLZ+JI34T+8kRCpbhXoc+ULlJoXDMbJLd vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tec7vdnr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393JXwR5002947;
        Tue, 3 Oct 2023 20:51:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46kvc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCVsdUWyZcbZJb67a4Gc90m5yAn8ZZYbu87Jr3OblF97597nGPJq6lc3JJPekIladKZlt4DyW03THN05jnd451QcnoL+4bOeNfzUqSQTiAH0taqxLwFESNMQxd+JqaAnJySAILJweMO2HzVMopkXUAT8/X4CN0RTsCi8zWkaviIagXCRqt4rjWKRpV5SY3Oik/fyWVRRXg4GZvUJjJ7+bHp0WTJV5qi2rhWLiBlQg6HwWRTjQUQ3JHH0mci/XijE5x5lThircwIHfR2irbuvfzOZVXlpiU1nmiq32e6JQ9OTQI25W41YR8vr9nRXpxXNOBafDnjOqrJC+qalMOnVjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlTbko+4an/EbVgofn2WGWqLaTtQFO/MiJUZDfDTzhw=;
 b=B5Ak4sxM1pWcMwj42PsVu+jxfSgd/OcSPXACdXAvvUUEP7TV2UNXtfOpd19FUCoH/KlVcHc8VumSqMpz+98UTJx26dhhGGE9hECaZyOJ/5aRE91BstTaFWWfLmbh1qrNAP7p0FffpzCM5dRE3TTSgwZkasGyNXieNtUtMvuuOPJykxOtDgGc1WVosGS44LMFsf9/LQ1fSCJwXNXXGKWJbi2tzFJSa0OuJD9APzkFeoArj5BorjixU8xPPitBTkrrErYTX5QbJyrcHoPdk8UPnntL1uYWnHALrykEDrRr9LllFXfoz9THBHnkk0f8ux61AEjaDo1/fTAENOxcgOboAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GlTbko+4an/EbVgofn2WGWqLaTtQFO/MiJUZDfDTzhw=;
 b=Ray8Pac6wDeREiFlfz26Rm1j+gvHB944Wkghrr/g1sCi8NJFGG/qO18l8y+6uiJXtjM6zfEaR9+NWL16taksvOL+WWSc+RgN7UGXurDIlFq7+j8Yidun6XV7S+Og8almv5nQjv7lrHdh0DE3efq8pJsf7si0z28j85IfMIpn1oM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/12] scsi: rdac: Fix sshdr use
Date:   Tue,  3 Oct 2023 15:50:47 -0500
Message-Id: <20231003205054.84507-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:5:3af::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a7abc1e-58dc-43d4-dd80-08dbc45277a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8hspxAGlm0lDvTnpuyTsYF3V/upYsSn4PGpvYQq7g6LVEIjgoLUv75cnb+gfm2UdXh+7MiOGuryJ8d38DaFTSS69w5uz7NA4oiDRm0KLrxQPga1jeON+9iHcLkiY+trOLJ8hGXkI+IpiQtEI9I7SqHHlfKzAXWvFgaIeE3sCgITffNRZdk+MMhZlUbnXEPLkhmgXH/ZwxKUTaX2H0fEyqafjYw6Ddk5kbJjBTOFjZbc6umPYDi4FZTbM23RGwxUmcodxBH3ymHqYOmyl0QqPw1bI8GOpl7tnb/WrTsO4/0NPlJqo3FrBCUOpxZsUPUt0JWuOT2xdhGHoEZS4St0oKkJ+dZojtACSewmBZH6gLNenw7u0HNjyqGUjsfHNj+Axb4DUtbwdFkki2QxYJVuR1aG/nG6aQM/+QiL7G43wURd0U1yXfb8m3riTMpMN3w4pvqBlU12rbpEaqmgCjDWayTA8PVXB+Feb2Atr9HDhCXhBogBXuMkeRwvVPPcuu8vneukvxAoHcq2E+ize2epZdo4e7pR9WGYfeW1o6gfXtiVs0LLjx1JdCEBZfWpoqaP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tc2LpSeMakVLJvsI5MeCha5GbyhLmVSE7R+Tc2GAC0DAzrm0oOFH3DBxuEs4?=
 =?us-ascii?Q?ibYp3/VV54FAumJJKVoHs5sdEyPKZOxbL6WGBVjMWRm+P4yc5rGea40hPYGY?=
 =?us-ascii?Q?t1hML/uPaU4gnkzhJ8Ws16VT/qCHUqppOiu879Dw+oSgAe7UQz012YU2BlqO?=
 =?us-ascii?Q?CMTHNurrKE1ajiBS5Ug81K7OnaXv99r/siGF87N4Cf25LamxnkDbq8zpxiIV?=
 =?us-ascii?Q?ydF5+DY6bvRY+2HX9u6IxeJibs9hYHlXKdd756/nB+t94s6JXcS4271kr36m?=
 =?us-ascii?Q?ghOVp/N8teLk9igiDxwNv7xFEKXM3QgPpVDzduuUWK7/UcQX1XIgZTKWbUg3?=
 =?us-ascii?Q?vzPzXJ2ApBm+5ianKK5hmPF7jqKz+6o/JS8PeO8y6xhh4N78jyEhVTvehF4p?=
 =?us-ascii?Q?a1piUFjCiQ5FC7ewlhXxxwBbvQYJzTazdi4OwF7PDWkpyRA7zk6XlW/8cNxy?=
 =?us-ascii?Q?8QPwn6zGHWf+9vDnaiTri+kczYv6AmS+uIhajgzaZpZBgFbVgRJSLAEHL4PE?=
 =?us-ascii?Q?SlKZ64+dX8RWL1LPkIDeQ/VCrhZ1SkaAhmzYDLMXK5VK9tBwrFf1BTS9YKMI?=
 =?us-ascii?Q?3NNsSUvceyV2uPzskg0E6V5njGU2Q35ApVENNk+DPBDG11EpLB7ogOtFJnzM?=
 =?us-ascii?Q?y13aokHwYn5mUFppn5JaATfZdPMFMn/2ZCuSVTODFpOkA0DDZlHXErv85gH5?=
 =?us-ascii?Q?fKG9ncnOD2xT8jrhj6EKAGhlwRri9+DSnnUMm0BKEFXxuGw6SZllfAlbVMcy?=
 =?us-ascii?Q?VFyB5P2zN5Uo1UWI1rITKufdd5lPFNC/teh9Opg/oySfy7lRLaJfqMWbU1GT?=
 =?us-ascii?Q?e3sPS5koELsVxwFC1MAek43jw/hMNAsLpaXQCtZCG1Ly1CJr1xD2hYv9VRbO?=
 =?us-ascii?Q?QeiNOEfavuoK9sgMHXzCkDJ73aiR4ecmDZf9Nl39xph4fCxmdVnE3zxwGlxa?=
 =?us-ascii?Q?D/Rp/Y259LVjgtXjb8KvhcGYSKRiDpC0aiDua7rWSJpws56MsUHYKXqgp0pD?=
 =?us-ascii?Q?qzupTuA7IOFyu0kelSGU5Y7tShxbHLatpvlpMBkD34d+o+VnVEDAQ/1sAr5F?=
 =?us-ascii?Q?4s5v2GCJiv/BbhtsKnk62RBSdVwg38pkFgNpJ+y6tNOeebvraleYM8b37Wau?=
 =?us-ascii?Q?8Fcy2UUbAe7EKh70wYEkjEXbZUA5sMEZ/0oby6BjnMOy93eGy79XfKal2Gnx?=
 =?us-ascii?Q?aXo7LQUskPcO5qzRPhlycGqDOTxQX5xpQIPGLu1LusNZT940j/inhEemZiDi?=
 =?us-ascii?Q?JuwTr6CdLsDrCHH0fl1dQ8SEGJmCEh+Sfp8gtCDC6mRvkKh9l8/dkjA4uZd+?=
 =?us-ascii?Q?d6Ic1/MVDRI0tLG3qZ9aGWwoEgYOOrcR6TsSRre9dXoj5XBB2tswrTFUvikE?=
 =?us-ascii?Q?vpyiqJ92HuybJlcCTYCzTGjBoMHzZpqq3tM++bsCVdYAdr4lLtQSgzhBAVP7?=
 =?us-ascii?Q?tJ1hIfXMoJf9uao7c8I2okDV8+8PWV5bIEeFRQMuMRvZLTzlVJ0LygpSJ6W5?=
 =?us-ascii?Q?01Hnj5K0Y86AFZOR6daBITfP/d+86/XFK6MUJP59J15E2S+PdCXMEma51Jtz?=
 =?us-ascii?Q?ORIgAXOQ3rZk8w1HIJKCBiHbmFXvBhIaAuNTO1boz2fIPivJRRBCnMm90llp?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: J67c6JovGAQxyP4uH8Xrm27DUA48LuFBP+JxCmsN8IP10XRxqDutBTB3xmwOz9E9pnCDkSpuuTRBeAAi5SKHoPleGpPeJCGmrT5zFr1QStTtEW2CdcMCieIKYtoDYmp6JQE61DoRA8whUBZ2kN5Optn/yYsgGzmMteogKwVO++AMkYyt1IpV3bzpWYZueswaR5XEd2ZIgFfcP4CN9/DpBP9B5o8ElwsD2g+EFJ9jtP2Zj2NBlc0mLXAEhxOTlX1/+BMFxTx/qC1EzFTPFZF5vxBBTCHHjNqEaqZ94vwabyw8zR8jpTlzX24ytGBcL3884vaqwDP0UfK29VOK28do2dmJ4diL5T5zZsneCCZEaV0MpisNudYP6+im9lJ4JzzEp7B9aBx9m3MFjw9XqL3EApHtVIPZEw2obmBoSNmAAAG/jU9T2fcxWIUP8AcFvNYmHX/mbyvvU8f2X5XfpimftvLJk1UV5LP8DPhXcy2LmAjYhNTckKv3VJyZgedpz+2+SvVEDo+J+Uhlr3Ha8QuUu25XVglG6RHX3GtgcV0mtEp7/lZG03ley6nP4mEGvvqSned3hoQ7ZpEzL7UjMwKKBuuHKMZCHO9G7qe5SemczXIaKPByH5Mgf0wrY+MWY0iWsD6+Lr3CEsZfDRrQMnSADMjUrXbga5yZBLeV2XtD67M6/7jO0kKzvPXfLRvuCdsy+jt5wkRPmlhgLFBM6+jYQzBm2NFNQld/jzUp6Q54Q2ehbJUFNGvtsHMKlI4dcFZGqLP19JAbMgZQ9spQo/IkT6q+XRDlhA4qJklIqzdAvOVFyHw8yCfgnhBQ8tLkXeF0/L2FqpgefUAYv4He5BoIOAWLg75erx0WltflRYYCKCGs9oHTcB4xSDXKPSt898uW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7abc1e-58dc-43d4-dd80-08dbc45277a2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:07.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuxpzIcirX/puPYB8p0ZFTKKGkWPH3WQ7FAi5JIVbaF+B4Ldhy6mPkzz4s4sQ15l+gCUZ9CDW1wH4Jc7P7ij4PatIqsvnwaVRLthGaRWUqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030158
X-Proofpoint-ORIG-GUID: _kVUE622PCKgrsb2EpIIbrOn7-fffJdy
X-Proofpoint-GUID: _kVUE622PCKgrsb2EpIIbrOn7-fffJdy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b65586d6649c..1ac2ae17e8be 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -530,7 +530,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err, retry_cnt = RDAC_RETRY_COUNT;
+	int rc, err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -558,13 +558,16 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (!scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
+	if (!rc) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 				"MODE_SELECT completed",
 				(char *) h->ctlr->array_name, h->ctlr->index);
 		err = SCSI_DH_OK;
+	} else if (rc < 0) {
+		err = SCSI_DH_IO;
 	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
-- 
2.34.1

