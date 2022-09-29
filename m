Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4E9C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiI2CzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiI2Cy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:54:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D4817E15
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiROR003466;
        Thu, 29 Sep 2022 02:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IiUH5GG/3BQ9wwYU4lzcYnFaZSMe9E2CZT4vaCbO19Q=;
 b=yIWtz4AXLZKHTHRXm05dFLq7xyUfxvXfvWt8AYXaoDXtIDJG45Iex+qrAON+xarZHpAX
 K5+G6PIMODjSY06DftQz2lnbtK9gWqZJIRHceQbEGKAGR6BGi/DOHD4ZdYdad1yGuemr
 NlDNSwdmwi0Mhk4eTCeLapG4ZFXDLgCE5emBgGXHTO9z+s6OP0Lxaki41PHR9sC6szFw
 2qe0NiQAeBTVMcMqFKpUWziZXmwIOr/F108rgKIb70TFW2PrY2wDS4GhrqQOPLGwmROj
 r5pSrBqxeMqG0bRO3YvYvoBHveye0MUQqOmC52kbVxn4/2aR/7YkjbO0SWJrcLpN2VWu 1A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwkjcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T0sHJU002307;
        Thu, 29 Sep 2022 02:54:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps6v7h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ck7DHRE+wxrHs9BCnaFr/IZDcFmcr65frHBZRo7/OrdgEw+19nWxjR16So0rdrjEkqFlhauCmfuzwRDh3+sKmFKusJWcZmHOdRBN4jW2ZkDU//FwofwFpxIYA21UTVCXQJUdqimaP8YUhHfDulmw/QEeMGvLvCMjhGcVy+q6WNMh3aEPEhly8T0egqsB+hOj8zmwQOz7PQfKKE/qzReqv/Z7TU0aeIvAg13lnu7S1ZrP9H/ewn2R19LuLmJ2S37u5y0Xdytoj9m85gC+icZ8OCjVSpWA+CoGc3onz79nA2bEAC+/4cQjOSKvWfhkTQscivAkLdBRZsoNeKI2/U7s2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiUH5GG/3BQ9wwYU4lzcYnFaZSMe9E2CZT4vaCbO19Q=;
 b=fH9ltU9PBPs1isGPYsJAaRNX7++k3hqGMX3JtxjexpLWJFakmbD8CbQgUAogaLE21tGIJsRc5L3+4k4mCWEYoY6xhamqgZAU5LzMXSc+NOOZJc5kegLSQUoLFY+h11P425Euo9LShjNdPqULwlpN3rR3skrKS5Q6TKppa4iaTfYYTVtNckru+pMYtaQ0s4GAqQpkOwTdjmNex6XcRA09VCkGUJIpNrk5MgRqKK2V1jhGNX6PqXl2AxSOoDpMs+5fyARskl2Xpc32yhgGMkV6u6GlGZ1XZB+7v39Mt4sjnHBluXEauko0rs/LDV+RnD4epPbm17QzvWv5M0lCENCqyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiUH5GG/3BQ9wwYU4lzcYnFaZSMe9E2CZT4vaCbO19Q=;
 b=qyslTs/VuE91Qq3OPLZrUi1kWWbVaiR69zetZ3vP/JS89Ngw03OSNZIUGJHMV4HLEGajfFPci/XCexuYuLGKRjkANWBmVzFkjHUgqgeOL88dovjWGYl3982WIhqPVUPO6ZzAljx/gbMWfCNqNGuW4owF23vYTpDta97RWlocFhU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 14/35] scsi: sr: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:46 -0500
Message-Id: <20220929025407.119804-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:610:74::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: e062743f-00ea-42d8-0ef7-08daa1c5f04c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8o87gcXbiwjk/VnXF6RWS7yxo4g367QaxKro5zKA71LB1EAGumMX310odwuMwM+lShOhdWbc2pVkQZovX7HaFcwayqcy+yBnz0icuUn9GnoIwnqA5sCl6dBMLb7GOLWaTXn6cLu2XsyS78d43GyJl9IHHDnlBalTYx1eA7QtMYeXvztlRKypE8fIsBV1QlIpKvEwuEVe5iOzoUDL5EmLsp1InDzg+xv9STlluGERqHHN0P1NlGwhVEhGDkpL8iuUkjT7cw4/bmy8PG5xTqstg1RovxJ4Fl3aTDW4sBq6Yoy5nqV6pBxjODJ+QklCZdNYDadfskyxYHgG6656uJ8dlrLlFma1lUAAaE64fqJPL/gtmghmOpHqwaK29+ZljZkez5hVUT0+v5I0BUGbc0/B3pyUBE/DCgglDW1T5pej1A3nvbn9xqSscz0sDrS3R3GmMKkVTl96YbpJMRIAelBVYbIBZGzgI4ebUVmAF5x0+D7F14CX3u9W052EE082GLom/OJWubaaYoypwrtOR5EWQ9amJmtpYUHwFiC1eu2P3IeFwdgizmAxxvSkfvO1eTE1VgsotNmOyyzR6cPmuKanTGQLHGONSt10NaJjvXEbSjcPHJiwETZ1odkF79xQzOakTOADBBNbPZ2PpifepBPIaSDFaJRe+3GWd/3jgrRdivOi+sapxvX8SZtOmSMLdLHdAwRjCiimEuNI3NrRFSWzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hUzsmZF69onCPRRKuqZFcepOUALwVz9b5ZATiV9giXwqgaCvC0DGdOWBdQIY?=
 =?us-ascii?Q?7Lg4mB7MxeVHEsidDlbaOFAinvHr6LUIS9T8vULE+ZW09uOECLVpYuvLpHsF?=
 =?us-ascii?Q?LmyE5DxvtCIIZRNXd8eWBnAPxKzmsDbILweEPuaj+4I7FgpA3vx6aSS+aF/i?=
 =?us-ascii?Q?LVnwbC/465xbw8uXA7iXFLiel0lv0X9J3bDM/2k8dnpFlR5+Y91a0Lyr03tU?=
 =?us-ascii?Q?R1YJnYkllUM8MTJhb1uggOjZ4kWLLkG5tncr071hiXW/Mv0K62RQaMlettDi?=
 =?us-ascii?Q?g0YJcZZMlTHz/WQqItmT3AbKyEbFusNUBPv9jIzsgDtaIdSXt8pjrMkm9ebr?=
 =?us-ascii?Q?CPgpkQKVasYYpYEqoPfhsnbh5NJMHM3253YMblbEPgezm25UCkf8exivT9p4?=
 =?us-ascii?Q?WjSRkgp6QUp0f/lmFNCwcEvsc2+42y17FZf0rA7OP8yPE4fxb/Yuo/i4Zb0E?=
 =?us-ascii?Q?hHB4aMh2vPOJxxleuz0EwSXe48ltin5d+F4OCAWAJpg+hwOB82v5VLLACTLA?=
 =?us-ascii?Q?nKFQuhQeDqcVVMjK8sP6i8md9KnZY8+ocbOdQhC4CaajfKdy/vCaMVAv+Tdl?=
 =?us-ascii?Q?GiLFoWsVRKYCZi9mKNi/xRD55vMtmbYaiVL4FrJaPiiy4Et+y1xo45HHhp9j?=
 =?us-ascii?Q?L28f6/2sA3kaXV2nAngoehlRFlcsVY4aLSWLL72MP4DN0+PLqsDnWzWtXW6S?=
 =?us-ascii?Q?czvm/cFqMmsGX6XNwi/T53gva403RMp+LCuLaGsCDKGRPMDD3FU4pvi8Gn4a?=
 =?us-ascii?Q?qP17ElG7k2XzWQAW59IIzfmZVfqPctfgNt84tefnAtDZgC7NwwVvTzZQUOdO?=
 =?us-ascii?Q?Y1oDyn673qdvapFLQ4rhuCdpUAv1fEqAZMEK+uSvw+jUliWpbIvRaV0xb3UP?=
 =?us-ascii?Q?L4/u5Kmq4H74smpnP8ZHW8bSLMErGTQ04hayBeL31FYflt0QKg53ykDIkU/P?=
 =?us-ascii?Q?E1+WRGZ5zlbW+kJeg7v/qIHcKUFEnloqHGExdYZSIUtSu77S76+/MjmUF/SQ?=
 =?us-ascii?Q?k8Jt+i/c+xIOFcBMnJlV8W1CHOUvzQBBfnCyTnTdckY5Wu/0K/QXS//TpUkZ?=
 =?us-ascii?Q?VQIFl2M0MIplA5/+ZMPDDrH0WklxjQgrst00OM3E//EPm7Sepw65mfQt57KF?=
 =?us-ascii?Q?J2wR9S0InCJvcY25efi2gSufbevqNteWJHtSRVZjgme/gZ+e+/aXXxyOLJW4?=
 =?us-ascii?Q?Cjhhk+7JQAzcPVQYh40OMJ8rNMTWf703vOki5jbzks9NZuwNrxVmLkHhg5B7?=
 =?us-ascii?Q?Sfp3hiA+iZNrg2wIWrqt6GtMT4XHLCKAtJISoDt08o+Jy00pWVWCnTaGbKoK?=
 =?us-ascii?Q?cVbDhFc8kveyIOppd+LMABfo9K2yuIUQNCsCRLyJxe6rhMizLjAxMsTsQsIj?=
 =?us-ascii?Q?MOGUo0e5MEEUA3/udJhNRC5GK1q1pQkjBvZ38GwYphiVb+pQW5fnut/U8LWv?=
 =?us-ascii?Q?eUHeoQlb7W+lCTHwmf6dZjtdrwWlu311fiO7qKrpvEhCkkJU3tcqRvP07RdA?=
 =?us-ascii?Q?p5l9t2HvWigo+yhmiSVwJ5vdEU0q4v0+Ob2towbKcfPJzbQ6fOhMWA4Y7PTW?=
 =?us-ascii?Q?Alpc3Dx7R0ay1NDSUH5C0j5+l6aHRmPc7B9SrJ/QELwXF16ybtPvKWelNm+8?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e062743f-00ea-42d8-0ef7-08daa1c5f04c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:33.9742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUC0r0bGxeK6nAxjzQoOzfotv2+UMOUjl75/rVITwb4y7xmuv3vMEUSODgFMshqcrUcptrn10r56Gufm/xYWAWTRybZckKwpfJZ84gjRadY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: OujJ1SpXqINymwLBpv6uR0jTlsiGh6-F
X-Proofpoint-GUID: OujJ1SpXqINymwLBpv6uR0jTlsiGh6-F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c       | 22 +++++++++++++++++-----
 drivers/scsi/sr_ioctl.c | 13 +++++++++----
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..e3171f040fe1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -172,8 +172,15 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	struct scsi_sense_hdr sshdr;
 	int result;
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = sizeof(buf),
+					.sshdr = &sshdr,
+					.timeout = SR_TIMEOUT,
+					.retries = MAX_RETRIES }));
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -730,9 +737,14 @@ static void get_sectorsize(struct scsi_cd *cd)
 		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = cd->device,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = sizeof(buffer),
+						.timeout = SR_TIMEOUT,
+						.retries = MAX_RETRIES }));
 
 		retries--;
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..3d852117d16b 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -202,10 +202,15 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
-
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = SDev,
+					.cmd = cgc->cmd,
+					.data_dir = cgc->data_direction,
+					.buf = cgc->buffer,
+					.buf_len = cgc->buflen,
+					.sshdr = sshdr,
+					.timeout = cgc->timeout,
+					.retries = IOCTL_RETRIES }));
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
 		err = result;
-- 
2.25.1

