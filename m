Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9148AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjKNBib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjKNBiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4B81AB
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:15 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsG5E008833;
        Tue, 14 Nov 2023 01:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=lBn+8OH8bJzzXWR1hyDc5gAZXNZRJ54YZBc3XrfwnWk=;
 b=rOUUS8gcfSpnpuCse0IZymhQrWh6ndsLmG/NacX4wlDqN4jFEz+olH5ce9cLGh/DpXYk
 KYriH12cUFrMUF4wwsn1r9D/cpPAN/68ksVJPoWVhbvWrOOdgJIZlx2qog8s3MiJQvmK
 o7iRCnHytkDCQD7Wvb3McbWqdPRMsMXemPcl9fXNUtag0+ggtSvoHm8nlGQDxlxLdfoi
 akUVF75kvjP0vXMww4+jszJ5jBQbF0LzSDTxw/k7NsVDqebPS8rnLVkBSJOdNfrTXaxk
 x3EyLWeeRRYNBFO54DyjvXVrNCILUd6/eYg1eZQthdHeLMttgtwl0uPfYvXJACGWd9Nm gg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2mdm7a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1Badx022702;
        Tue, 14 Nov 2023 01:37:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxpxgwjc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Atyk7nsJi24E4cFGJRrQE/bRcNDEF4zFMuHwFlXriBBehb1wUyfFWkjbBroq5Sg+eh1qFnHJcD0ZgHYC9DLMBDL/edVE49S8sfO4FJZJ+JwvEC3998r2RWAYcdEjlBofpoxpsCkGAlP4XuMr1sK9bf9PiJ52mWPlFYtQabhOc4AcPVSbsyaBq6+hJPbz1+Da73iioJP3/0FcPipQptERCdiEUHnonZ0Do6G3Okzg73eAdfH59wdQY8pf4qdqfyidsNhUSS+RY403VfwD1hf6sw1NmvHYRBM8zLe5PI2Vs/8Z4g3kzoNjEVnv/fF//NkA5si6tYMQHJZiqkE0J4e97Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBn+8OH8bJzzXWR1hyDc5gAZXNZRJ54YZBc3XrfwnWk=;
 b=lzGz7FvvLkNnKDTIv25sUSB1o44bHCI7iWviXjkYTBgMkYDMTe99mXXC+mUGycC2/2aPUnGWswiH7haBDM1rN+rHhV1swTocPvB8XO3iwia8GZGfzUdEIHHuMf/uEvjolc52eJ7ngALUty5XXxxf4CTkq1BPkk2EMzquQb8qb2G474mvy6lkfuy7K0UbtY9KaW4ixGuYjvzEnaV/XZHzm0YhZrPntAqpubYEZElPB7h3eNlpy+V9ubSpIQQNFewj0ZRWalsZiT2ErggEfJ2yUEFzE28S8p+eJIlP+kkdHqtZUbswNk5BTxgrjlT/SCUBoLGP460k3MwUVE8T2JARSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBn+8OH8bJzzXWR1hyDc5gAZXNZRJ54YZBc3XrfwnWk=;
 b=JttDYN7TxnKiZ0xCpdavn3Ms50KPiEY7njLgiWxz9VRBj5VgUI5M6oPE3I27A6MYO9MNGM7p2E2bNmxzEU1eFPcdAMUzgRz+jVfW3S1prxfttVAMfBbLgCaDi5jBqMqvPl5FMozILku1MHY1Ow99+srNedSWOiqgdYIOW06V6fk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:37:57 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:37:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 04/20] scsi: sd: Have scsi-ml retry read_capacity_16 errors
Date:   Mon, 13 Nov 2023 19:37:34 -0600
Message-Id: <20231114013750.76609-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0077.namprd06.prod.outlook.com
 (2603:10b6:5:336::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: c392c728-ef42-4f9d-c764-08dbe4b25484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owoUyYLcm2dxmIjXF/WYotDYnlo+kOxxgaPW7nGOpysUdvm7fFj3Kt7beWC1iYqVHCpHmmCaYobjMzi4V2XXTqsJuF2EiwsFE3AIS0I6La0WkWFYk82O6NPnYo4ze/jKHIEh1oRxCmmf+1Ay17WBPWSFuHL6A4Oub6qWhCgjWZX01N8roQbs3yXmGzRH2Al/vkG4a0roPhx8UxpzdKQn7cFvC/YC3T9w6/FICOf6H8XryxYsmc4Vumv34heWIFRvcZIBARzXQWqnN2UB0Cpz8v0zvnsiWnWOZnt96lf1iC3ZDEt5xZrN7RnZ5KFO3NbU3RC2avLe8n9yS/IfLRMN1yTOeGvIVDD8QGKJtEfZv7rq9pSdeLjWUo6AHVTMN/Eu5Se39irOeOL/DSRBLQmSFn+JED7/VPzy42tKhWQEkjlCXIXLAPopOe+mwMaJ1Z/GuH5jxqZ77V0w1KFf3G2q8x3SbcwmSNMgWg8B9FvY0zu5EmuF7iXx/dXb09VvCeMSngcz5BXClV9nDaDF/J5xJ5svQY2ET5aALDjCS6s+Zb5ZkWd/b0lrntzPVLiAInPt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wKXJJ0cWmslqCy0TiurcmaQZvbM6oKSP1KMxwi4EaAUDlqs2oWaw28fgDR4U?=
 =?us-ascii?Q?b6CNqHWwY8qk4SywSJ090rsZhjSwPrkkigqXo2/5GlfV26EfWJUTdrWAVgQp?=
 =?us-ascii?Q?AnFWggPTOLy8QFerZ5vpaHKt1nnv1XpQmlty73e4fZ1ddP9b8eM/JskaK+pb?=
 =?us-ascii?Q?7hHc+006J8lyaXpGJLqjtR2T/ApxPAtZJ98daLl39ENY1JRNDYoHI/eUMgGH?=
 =?us-ascii?Q?oSznVNUFnWCoUwUIlw9ZavtQBI9kqTw/QkEtMIZxkZIN35PPzEUIlqGBls/9?=
 =?us-ascii?Q?o1/Pt37FWEWt0S/6UsUMovv0TJNCt/iR29kexxrdbf3PLTVhn+UGeM9/+zue?=
 =?us-ascii?Q?OzMFkrbNvz+TjpFtRk8nF/Ff5z8rbCA1eAnfHErEzhNvFrDA3aMJstpsQv+l?=
 =?us-ascii?Q?5K6+bB2OSL6R6ntmwxWqlPX8gVuKPKJgTaGeUcxwvFH0StNN33zGZjvD1Ev/?=
 =?us-ascii?Q?yCydbgMwBMW4xbcaGiOG9IjJGcOzdL/pPhT7xq9rP68upn0g3NOka7rQl8mE?=
 =?us-ascii?Q?j0nYJbXM5lTVAioHw9NV5FkFU9dMN8oZ6LUgSsdHxj/CyccUA6NH9P2I8Ln+?=
 =?us-ascii?Q?sUhxrjiHY/yzwBB3GLj/xIFKSnD6Hu7sxth0duudq3qWBi32owBwXCB+qGLl?=
 =?us-ascii?Q?b5dFdcy0dxvj37eMsKTlHWDfLtQNms3sNjJGvFz8nKO9V6YUrvVhfN6PB4Sp?=
 =?us-ascii?Q?YXynuUaTzo/rey4ASBiDa2KjpKOPJ/O/2vxSu0roXDuoMLllDZUixGLYwje6?=
 =?us-ascii?Q?Nv/g3TKrScE89791CqKSa04ezFkeT3N7ptsPNilDo+VFZBWy7s98j8l2guc3?=
 =?us-ascii?Q?bbnceMX6ZtvQ1TsO3Nn+SKC2ZKSFuz25WrE8K8MdT4PAS4YlG7ufUKpFeuvF?=
 =?us-ascii?Q?SpzwvSb2cfrnM3AeSSOBOIkMjnUOjwrFVS/b6ZydIjA6PtGtmqLza9Yi7rgx?=
 =?us-ascii?Q?txmWsxP0F7vSttDb7aXEZ+43s8s2picYiAJQUzqgCxD5zH+7bwR/fbCEI4Sq?=
 =?us-ascii?Q?ThE72l2B8vma61GlOSQNigWo6HmQ3+GRkKn0SD4ICWVhEz0fGviPnB3Zfhb+?=
 =?us-ascii?Q?9lohkT1PLg/IZCgyY/JfqigGzZwo+41h6vDT+jglCOKjVrvmduAwsq8aSQoQ?=
 =?us-ascii?Q?sxuigW/DhR21tf8LJryzPs16+xgSeip3FopNk1MgsfGnT1ovgPLkWcU2Aqa2?=
 =?us-ascii?Q?MOuhuAXM+Klba028M2NxkVyu7/UZ7JcRG84uGxg3MMlIlAVDq9nFY5pOaUyE?=
 =?us-ascii?Q?hem+s8CHNbl/ofoPqUn5EDQSHGy3h0wtWca3WWGtSFSs2fUXHdGb7FEQiTys?=
 =?us-ascii?Q?LJ8p8Vgff301rEA2ZoaxCogtz/I2tBTm+hWbqSu9Q50P32XR9nz6LHth0bNO?=
 =?us-ascii?Q?4z4viGPDBY7a32YWvysL9yzY3L7OUGdHuO3IFsR2EdpLU9oOFcJDGYANCcON?=
 =?us-ascii?Q?bB51K3N7KpfmOmDty2WqqySQUkIM9VFXpzuWHQd/Osku9OWe4/e1tippQjsE?=
 =?us-ascii?Q?+G6cmiSYjjKdajfJ0VpJ7GhAfVPQSoAXApMWOCPSoCz1vY+L+neYe0TtcSdL?=
 =?us-ascii?Q?LQi7C5iuvfV/5WAmyCu2CO4SIhGETC5wDMcpgZVeNM58KiCDt2YRviHtKnt2?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SJOkWT9/YOzYE8GHY1nuUFQ/81HVDO5k2oipj7ZxvYNs+c9BUEFetvkMOKByhzQ0u1yN+skIEW7rQD5L/r10Xobu79OUvGH9HzKaftKAIX9QM8nTvsLcxaGUTkmCO3qjbdVtMnwJ+rMaHEtieFzFMYfR6WYaLpNqBsxfta/GDdb+tbkJlxyiivHVwEhpRColN5PJzC1Cr6A1bKy3+HbGaIN/Z1tSgBc1od5cOgOIo+weU/QCS/rc00VVf+XXvjUFuBEwiD4C/CJRdAz+VgIp8THKFr8jrkjZi27gbLxUIx+JMbMk3al/gMfUamNEXh7siaabVbS9dLvMWvlGRdTQiYQpRpnF37GiWkYykZEQjvELScXsXfvfPsBdhIU6zI0LRyMdtH6WcZPnX62sVpz3iQBa0wXiefmeNrhG7PJ+YJs92NnvCJH5WcAkZRzysP9dBw4ioo+hSPJPAZBFXbcNwDHJeJ55ObPF7NtRGSl8fHjeA+4WYLzWxkXeFBDBIa/61eKBtHplYWp15KQGPNPlzJ1lahpMqh0xw5PErX8EitP15MgiKaI+M2OH003pM4t6oGrMFN45tOm9oDqsuHdpHBpiO00JYwy78iBV7DCfg/FQxBd/n2V2Mm7K2WnC0BiOAwa/gLPIX5oeiBKkkIMfCNQwevj7Brf8fLzJzt6V6zYlKXbPGCIVPkKdRyBYoTWtKjWRpoPYZ6SuKbpMZmGhumOF/lK24ywY/Di+A3nVAVWCoSY8dchQyjb3QxQwPrm3GWoVTolnKJ/3rilKqdoJEqxHLPXOKAmgEtryKWr0rhZldDcQSjWOQQVisdLfoutwHkDTXcI4LHSoIGOkoDtqJZYm7TUE2AHVbng+m11vELakQTuHtN9hO5o+aVDTIKWF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c392c728-ef42-4f9d-c764-08dbe4b25484
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:37:57.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NakIzvQucMk6fub9JlFp7fzwQeXDBIpOa3aEFbQFYnmy15QS2C7DGzJgZp0NyPaEE39n+iqd2/UdF08wahSUIR44VfOs+ipYLO8npzEJig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140010
X-Proofpoint-GUID: D8vxoWpmk1pJNcM31oUIeblx1MuVcPh4
X-Proofpoint-ORIG-GUID: D8vxoWpmk1pJNcM31oUIeblx1MuVcPh4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

There are 2 behavior changes with this patch:
1. There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs since the block layer waits/retries for us. For possible
memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
retrying will probably not help.
2. For the specific UAs we checked for and retried, we would get
READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
from the main loop's retries. Each UA now gets
READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
is already 10 and is not based on anything specific like a spec or
device, so the extra 3 we got from the main loop was probably just an
accident and is not going to help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 108 ++++++++++++++++++++++++++++++----------------
 1 file changed, 71 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa00dd503cbf..1af04b01e1df 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2453,55 +2453,89 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
-	struct scsi_sense_hdr sshdr;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+	static const u8 cmd[16] = {
+		[0] = SERVICE_ACTION_IN_16,
+		[1] = SAI_READ_CAPACITY_16,
+		[13] = RC16_LEN,
 	};
+	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failure_defs[] = {
+		/*
+		 * Do not retry Invalid Command Operation Code or Invalid
+		 * Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Do not retry Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Device reset might occur several times so retry a lot */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry 3 times */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = &failures,
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
-					      buffer, RC16_LEN, SD_TIMEOUT,
-					      sdkp->max_retries, &exec_args);
-		if (the_result > 0) {
-			if (media_not_present(sdkp, &sshdr))
-				return -ENODEV;
+	memset(buffer, 0, RC16_LEN);
 
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		if (media_not_present(sdkp, &sshdr))
+			return -ENODEV;
+
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00) {
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+		}
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.34.1

