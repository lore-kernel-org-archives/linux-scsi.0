Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF46E8FDB7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbjJCUxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241124AbjJCUx2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:53:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FFEB4
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:53:23 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I56n6006412;
        Tue, 3 Oct 2023 20:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=DUefhzkjjEiO7/wVr6NH59dW8g/A4Tkn7dXnRQf3M5U=;
 b=4K3cCGwU9S/DDIcN6Ww5k3mt0kswYT1KtlWpa0sdq83ua7ylAdZySPF8csvY9HbBn42e
 aDHyLG6rIgzeaKmMMivAreNRtURi/VQ+FvDwKKSw4fXFOvsAD4vThMXjF8HbXOeX3VPJ
 GYgzK/FlydskZxhR5zHnrvNqHEi//OXjZlGVVvkiI/bvGFLYIi6r8l2ZzN02X0CdET44
 g5chgWRecPv8EpFfbkY4kOe4opk1lwra3FRNqfAFtQfWh/0+CGcMVxDzqhwdL0Ws5qfo
 ybZFKlCISj5yqGYLLUMds/2f1VsPtwTq7qEXmscB6OSch73xC4/qUq5cqrZ041lXqpwk +Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tec7vdnrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K3kO2033640;
        Tue, 3 Oct 2023 20:51:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46tekh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtufo2Po/V+hKLUxZhuzmOdKYSzWPtXk/lAGjIRYXpDa+pJE4Ni3WhpxeiULjjd/BB9z/o+/Ol15DrC5Yrc+R9zsby6mqnZq/0HgcAbVZ2pPk0u46QKRP6KvpIgRzSJzFC1abcvkYllTiERug3vsqpXHuu3bBstuKWY/mGAffCBe3nfcjN7YmZn4CnSdYQLuqtdCWkHabUmvKGdfOgfeXaWpu0p3hB6lo8uWdUP1O/5BSfYbTygWN1NxwCdyOnrBX5iePsPajQNSlCrVCvdJapFl10XFwXXjEqzHKUiCxf5dAzukSzsIyUD89rn4YwSlx6+cgEVTnVBMs7o3GfrJRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUefhzkjjEiO7/wVr6NH59dW8g/A4Tkn7dXnRQf3M5U=;
 b=Plk2ptwQjXB0yDR9M8jJc0APWLB5K8cQvsb3KPhgERhCBYlQY+fiJctMTfhzPEDD9ughMD1YawkdFTfFUAw/Jrn0bF7t4rqEyT6hz1E9ktqdFrxTuOGBxEdwaRYZ2owAUuOciWkHvGuw0Ai55gWkFjLIcxSNL0a6qWIFKGQKCiB+0EtKics6McOKggnu+Q7kbHnYLe/rptGBeAjc5ljjPAwYwUtvz6Hz1Dtl5CmZpmFhgosV8mO63ShrdhtlzW0MLlDDm5ULbWGzR4QzxTA727C9347xLyU561cyEFAjb3MlOyjEnIgxEXc0LmDK0U2lq8gfJP4NEodvzpy4quVnVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUefhzkjjEiO7/wVr6NH59dW8g/A4Tkn7dXnRQf3M5U=;
 b=lCCEZd+efYrweKDDhrwdCEUx8P9lebQ4TWEEB9fFpTssSAZy1eliYTUjlW3o5Ec+kmKo9xWrPl2xpVY94AywJzdRoOPmMeZXwPkdH4bvDqKTrRyjT/29J1RM2HzXFUnJAs8tdfLJ+ysslUalqXbDiJZMvfsdRzIWhUKGwV+S/z0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/12] scsi: sd: Fix sshdr use in sd_suspend_common
Date:   Tue,  3 Oct 2023 15:50:49 -0500
Message-Id: <20231003205054.84507-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:5:bc::48) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 66bafd01-717d-4688-d2fc-08dbc4527a2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gxS+7EW5/+TYkLJzpJs10fOc26JGn2aF4gmjZb3nW7nwj8UG7tBorUFZO2v2WpYAFharQY9+PfljLMTDptAVPzN64tsVkjIjjmpkw+IChe7Aqr/LoVXVLiWYJEm6Db0jqaZAIi1Tnylhwwm4CZ/aBcoxcFo65VoozFCG/OMdbMvNyxnZ5MXb1Gd6RGzYD+AjCW7Fp19JZVx8ctpenKI1tr5kCzi4DObLO4k5UKxONwU70MrG5NIPVd7qPzwMAuDBb3zdR6PVHJPjsgJguxz9kzsG3SntvrVoxoZCp8dH0fghYwjtK3hv/EUziF9e68HWuVcuWVIZxlxeEBEeCr+Gd5JcFqWs9BAu8AC62XWuWLpn35JGH0JswS/c4OQlHN45vhp15m3V0hlUU5g5QqiBNwSRbxlUpQrDItncVkfl00XJJb2FLTgZ7PVUblw3jouC38HKzF4OQQEjuyPssr2rsuA6bjyM9YGFFVmJF7cU2r6RNPfVlmxHPN3mhHp1zUCNZdWdDg6GyraEqGEfozS8B3lKKAMLNS1MLIWgMnpSUoE+0Ti6yvT5MkZyWrZsbc/m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?suawp8bPJwxS07XHz1cTh1n6iN43RKnmMK1+9fa5L+fKuwtEVGJB77wdSxes?=
 =?us-ascii?Q?RMKthl6tzZ6io6MdWIfXq6mjC46by4zfcAYkzSO7yKIrNSFqCUmuws8m0rS7?=
 =?us-ascii?Q?PKJX3ewvsbGm3c7YVDth1TtzHexHr6bHee1PJ0jTJyS2at6k6W8WlaDd7Oez?=
 =?us-ascii?Q?JXE7FZsWmOj949NjpiwkpHztWieMJk0K51ZFtZqz3tExFqXfwGGgeWeeBUoz?=
 =?us-ascii?Q?Unf8k8hovKmXhDfb914lu9lDEJIww3r16/QTsGkJG4tpYJSx0CFRtuPu+SuG?=
 =?us-ascii?Q?WBndGziImqE3I1fRtpJ+/2gxr+EDv24zpK5ApUP6+q9qQASzmcFfMLo+GL5I?=
 =?us-ascii?Q?HZdbgnYp7zRCJXhpl+k71kyM4AtnS+DaGgRGFFwyqFMvRqFPsGPGoCiWDSDe?=
 =?us-ascii?Q?rZnlVWodLUm2mL2T/VeNEodGXv5VU8MnF2KQyIAE8p7aM4uoxQf2lYIuDJxz?=
 =?us-ascii?Q?Z/xwxgWZSu2ogLxZCAlwE/1ne1h2BJhU4Fvi0AAiMs775qlQutYxDkZe2i2H?=
 =?us-ascii?Q?KuzgtXzOpoJ0HK1+gZlvdtzcCYT4aa4NQlKsQPJK5CvzASTLIxGy0oa6MVtO?=
 =?us-ascii?Q?XrBhNscMsdDWXnXsRg5nKaTlNxRBZHkYM7ecJbcd026vKMx9rdfeXRgMkkhL?=
 =?us-ascii?Q?YBvSIxdc6QGQPsWWRltx2RpD9dknPybY7j9IbQAZ6NOv5BZxJQxX4e0Tpjy7?=
 =?us-ascii?Q?AIOwC26J2xYl0Fvf/AY3MawTCyLP6HSDrnEVFD0BZmcskQ+yD4AFdbz7ua0P?=
 =?us-ascii?Q?5GfU/WAZa8J/CRKpbEsTedKlSHgREHnvkOaLkcKqMJqyqosrK9T3pN9nEl6w?=
 =?us-ascii?Q?ZK+SpbQsuquN8pYCw3Cu6JjdSv2/+1fPsqWmJ0ElCKqvjU6+qU5+6NDWlh6e?=
 =?us-ascii?Q?4PGCX6A6trwSiIj09rlHkvW7xxaxU3bGHhY0YDrU4LQFJAGPQ23RLAyV7q9l?=
 =?us-ascii?Q?j6GpK5OATWl4+FpsxS7BZsJ322P8gmKQUVysXEgXQVEhD9aWXIYt2qxcn5G8?=
 =?us-ascii?Q?Kgslct1ZeSbn2ZSqraGa/Gq9vM5St3L2qw8On/mqEdfL10lCGmFclW8aKeq4?=
 =?us-ascii?Q?suFO3m4jMmB6wJf90FJPdkNZ0905fcxyXTw/ZfljtZxYnniLZ0P08KW2EWCp?=
 =?us-ascii?Q?sNtOO26moYQL+NG20laOSJe2tUl0bSrzkjpj5vhIpxzLrc14uH+qplNTWa5H?=
 =?us-ascii?Q?4GmhBr6zswMAxj1wCbjaJwdUg4QqcuDJiXvRbgbp/NA1fL/qnAJN7mZx3SHA?=
 =?us-ascii?Q?aKhFwhPNC+H9Rkwtu4+jbmKpgb6Xmbyocq95difL4I4BIzNRouaCa8IJzuEr?=
 =?us-ascii?Q?lahrllNbEM6+hIW0sUcC7JNFDDmPsOd57+KulEzZo28Gg7peAhIE8RutJFkx?=
 =?us-ascii?Q?iK9ujcHcMsOo2vlCh1xYg55nbok7OQCzuKpYg1A8cbriwFqbyj1NK+bsu45C?=
 =?us-ascii?Q?pmNcZR87TkvXIoiiQ3uI4gIMZtKSDPx5a411UofNKH3UajGCTc/G0kpkwCIX?=
 =?us-ascii?Q?yGXN3HP4aIWXgsqBS/XdlcItwCfhH46G3ytiDraXN9SSssaOMK6MEpx7rZ8u?=
 =?us-ascii?Q?7gUk57o5JkaR6QY/wnWIreqlp1nb/t7T29cODatY0QzUw7VP6oAMF1UC0awa?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pFAk15ZTABKK7qzLDxqRqJaZjmrk1Wwhfz+AdRbLmwhrsYSUI/MZQj4TKLdypEEwhhGQldnxNrcdg0tw7HPD8OXSpPFPPbsT8ORxlav66QhWCz/a71vSl0M2gCFDtIuGwC8FRe0jGQLI0tznmlNtgDqxzivFMVsiFp6uxlTeTvo5vmnEVSmo2/Ju48doCpTRaFvy28Fc7/YfAaB/KwtyYMy3KuiszX56cjNvNPk1vKt2kI/CjNTrXKPCH0enrIxE8SuSB6SL/U7tbetSm/VWmk03EO3W77Fc18G+wWiQ5e70jJYESRkFxmm3mnYi4cCjrQOCx6z4PVYOhBIBBj0/4x949BlzxiHbU5gkKYP1Uygm17I/SmBYdfW6mBNVVkaZPomWk/jeOv56PpqPuyb73+uKbRL91sOrD6BU00/WD8KPqI+8uKBzIL2l8C/oDMD9SKSPrO+j5SWxqYTYKGFNh12w5qePBQiGeArue+1a96V2wsR8suyXUqPQJPtL9RctZ8MRpMbjmWUdcjfrMAAQmmQy/Bal2dInPJj7WZ++N1q0VqHmxLJjW4L/k4K5ser/lMFZk2bO2EakMvquv1ru9ICqNF3ckMAZKKk719G81ORLLXp0oyl7X6yXDA+8CZxuTOz7A3vNtrvOVqLhcyVOike2i6M5BHZQrH1ig2pw74iIP7ZZUhI+uuNLa+JwG3A+V/uxfa1n2tGFrXJaZMMLGhyvm6BXZ5ETvO+9fuPabimewbQbQXzyFCcd6VhxTG4LYB4MoJGqip0DLE77p+rG8fDBOKOat6NAQ40nxukhZBTP5fYKEXVoqwfc1DXGxsc/Jq7TNcRG8B6VsuXwiGlnjxFXrVJMefYtqhtZbuiQif8mEb6KnrgL8d2Kmfyxqhpr
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66bafd01-717d-4688-d2fc-08dbc4527a2d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:12.0455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lsaswbqZ2h6q1r0TlLQjY3Uhbu30z6ih0y7HUSgvsJWJ6pdfnqJTEh9IH2rqh0ZZvwXlAtvPQeNLujJVS0mdgcLHz3pAkYgqqgyMN3poPp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310030158
X-Proofpoint-ORIG-GUID: AEsNJKtjIfV1F4E_Radv1pj3VBeqSjvX
X-Proofpoint-GUID: AEsNJKtjIfV1F4E_Radv1pj3VBeqSjvX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. sd_sync_cache will
only access the sshdr if it's been setup because it calls
scsi_status_is_check_condition before accessing it. However, the
sd_sync_cache caller, sd_suspend_common, does not check.

sd_suspend_common is only checking for ILLEGAL_REQUEST which it's using
to determine if the command is supported. If it's not it just ignores
the error. So to fix its sshdr use this patch just moves that check to
sd_sync_cache where it converts ILLEGAL_REQUEST to success/0.
sd_suspend_common was ignoring that error and sd_shutdown doesn't check
for errors so there will be no behavior changes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 53 ++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dde9b6707980..75be368f3b5d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1564,24 +1564,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return disk_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
+static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
-	struct scsi_sense_hdr my_sshdr;
+	struct scsi_sense_hdr sshdr;
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		/* caller might not be interested in sense, but we need it */
-		.sshdr = sshdr ? : &my_sshdr,
+		.sshdr = &sshdr,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sshdr = exec_args.sshdr;
-
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
 
@@ -1606,15 +1603,23 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 			return res;
 
 		if (scsi_status_is_check_condition(res) &&
-		    scsi_sense_valid(sshdr)) {
-			sd_print_sense_hdr(sdkp, sshdr);
+		    scsi_sense_valid(&sshdr)) {
+			sd_print_sense_hdr(sdkp, &sshdr);
 
 			/* we need to evaluate the error return  */
-			if (sshdr->asc == 0x3a ||	/* medium not present */
-			    sshdr->asc == 0x20 ||	/* invalid command */
-			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))	/* drive is password locked */
+			if (sshdr.asc == 0x3a ||	/* medium not present */
+			    sshdr.asc == 0x20 ||	/* invalid command */
+			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+			/*
+			 * This drive doesn't support sync and there's not much
+			 * we can do because this is called during shutdown
+			 * or suspend so just return success so those operations
+			 * can proceed.
+			 */
+			if (sshdr.sense_key == ILLEGAL_REQUEST)
+				return 0;
 		}
 
 		switch (host_byte(res)) {
@@ -3769,7 +3774,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp, NULL);
+		sd_sync_cache(sdkp);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
@@ -3781,7 +3786,6 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3790,24 +3794,13 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	if (sdkp->WCE && sdkp->media_present) {
 		if (!sdkp->device->silence_suspend)
 			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp, &sshdr);
-
-		if (ret) {
-			/* ignore OFFLINE device */
-			if (ret == -ENODEV)
-				return 0;
-
-			if (!scsi_sense_valid(&sshdr) ||
-			    sshdr.sense_key != ILLEGAL_REQUEST)
-				return ret;
+		ret = sd_sync_cache(sdkp);
+		/* ignore OFFLINE device */
+		if (ret == -ENODEV)
+			return 0;
 
-			/*
-			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
-			 * doesn't support sync. There's not much to do and
-			 * suspend shouldn't fail.
-			 */
-			ret = 0;
-		}
+		if (ret)
+			return ret;
 	}
 
 	if (sdkp->device->manage_start_stop) {
-- 
2.34.1

