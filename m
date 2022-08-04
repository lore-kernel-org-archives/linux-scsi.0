Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF89CC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbiHDDlU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiHDDlR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4833FA01
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741i7a0011135;
        Thu, 4 Aug 2022 03:41:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ANiaVxgs1hDHKf4bYCoHFXpIzciLxQ3+XBzIWpgyak0=;
 b=0KR79EjTaLB+Lxd6lZ0on4GVkFVOBf8HkaxDgHGLrM8RzfxjXJFO7AjMOecgUnj7IQhF
 ZUjxX1cRdCjWFl/tQig5QVZZvrDmDr1jkAg5oyJ3vO17UIZlNkDAWVvbMfD3/sg226hV
 HgoaTS/F8fPe3cLxLCz88Dxp5CgaeCv1DB2ZkFRnN3jYqx7BFVe4Y/BG5gv9SnZRd5ZP
 ic/W0RDWP5BKSYSqVvdaY9tb4Okd1wNsNcaiodc/WoDCNvawD2pONSe8KOw1r0UFCoLT
 mufUwbhBOGQoC3Xl4zQkYsQFDz747IwoqOXzl9gEgATJZ57u8UDRcd9PW0Z8KCgf3yyL 7w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tkpw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2742MXgO014976;
        Thu, 4 Aug 2022 03:41:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33x1ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuUCHbwFTVtS9ISFD5AJOlGJrfCmweiZuWzlGU7zkz/DLr1ulcTrKTpHfBacXHTJ74IHqS3ptzacQqPjx3tipj+F7dts2/fDb8FQhyMAAYCI4SK2LxsbtMIb5Ijc3v0xPSOGYawMa0M3KqgfC2pF5fT0G6iQ+ZqgWvE3I45skByQ5tMIJnDPzaEa9tHyw9bp7k8e0G/ra8T/21JewFh0E+bryzfebsLFfkqG4Yy1MH1YEd7v3dWPcMYLY64f1bjWWt+gRZXVNF4+I6q4WVRLFGSwqzjk2Dpihu/F+OLW8mbIFKnfFqeyK8xAMnddPoON8WIJpIB98mxfymiaMCqF2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANiaVxgs1hDHKf4bYCoHFXpIzciLxQ3+XBzIWpgyak0=;
 b=DyWDv/YcMcywcX53vyOK/DAADE9fhBfhTHnCnO0jWO332DIIHAAqmCfojUzNof5mLTapFtVNGYpyhRnnUTi8mKhThLlaXAPiU7nrz1TolzrQE336kwbhiWqrYkKsTrHgc1LUFZnjtaOiYl/0foKuDgZkWdx3dSrAQfxv5U6zt9uEK9CVlxTqmS8DOomXg83N1U9Q6vSMozGreWyAMlOgYAgXpiHfQD0SiN3Idmfjvh8socic/rUVPzdfjazo0EwCd1DaiQUbb/sl+s/DU4y4z1oaeLXZPJbw/0XgCbhvPptbqwbzVzwQsmRWmgaizy1jSUBk9wk+dnORi881rhjrDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANiaVxgs1hDHKf4bYCoHFXpIzciLxQ3+XBzIWpgyak0=;
 b=zDSK7uVUoPaoCZRkrEweVdRN4TuY9jcE2QAFxmcTi4MeqMuiFYhzgW5+sFO7CAn/LkB8BmoYidwtTN2NtAc1XdeXv/iTrGKKIk3ebym3vCmEh8O7aD4+3z83REanHnD8x113HRKx4lkcJMZ/BiAoYWYx6LRR9A/g+mdoCNsxG88=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/10] scsi: storvsc: Drop DID_TARGET_FAILURE use.
Date:   Wed,  3 Aug 2022 22:40:52 -0500
Message-Id: <20220804034100.121125-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:610:cc::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d016887e-1338-4692-b3db-08da75cb2930
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6m22KSbrnB1XHOHq7OVqKzeyjX58Wbcwa5EEvBMsPYfLEfS8TE5TXskJAGpdxurJe/aZ1HipbAsE9ef5CT03LyDkXpvSayTGNOziMadl8m6GCpUoy49/960NZI9Spf8hH1iMxwHVRF5LiA2I2Wv/sGjBvXwlU7+r5hsTkDz+l8N2zZUPGEzaxFURIY6oUziVYeLny1kjOifPme3cPMKy+ptp2cLvYZ4ETDb0ooTjwsoZ9XYV7aO4xo7OvzRVPHOvAos15sC5HwlKvvXzbONAxrYa8aHYrPX2WB+ICOiQfgbB5WmP5BrRI2ka+4LjG+lW2j+eBousCG7ggLFW+WrkbAf7cEnXgp62yU/jVJsyvUZVamzgCiT5rbpZWy7r99yF4apin/iSo8iPe6xV8NjOepz6rkg21VTqYGnUY2XpaTI4TJV45lqNSVd7FHYsuuAMTS10mDTAt0Owu6XS8EPpFEi5lPtgOSWQJ/G72uKYyPbLMBbnT3wsPCqzKvYJ8Fpf/eC/VFgCqpUJlmJKvjl8zRpHon9iaV2uUWRQatN1yNx1UgTgFWqEZ72TvhPiP/ji5SlEnGDcDKExkAj8OuulBK4aG33OVKt6NR+Hq1ANyF+CJl7WERplwc5e4bolJjK6FUMjDC8/OkvDWI7+4PT3wyZgDl1Dy1WNRrqhxcVSLz9p3t2MNPGPsWoweQZDV88hAzts2tqZVRkqCXpAPuR5EARuPK1hPYLD5aEhA9LWw6on/Hp0EXbqd3Ycgajd+b6arL12YX7bcNppZFrZeOFQDg5qi72QOhdDYIYrjNl0S40=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(4744005)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nx5NYtDqIs5geOHzj7ubljsLnX8z8BbSgvf6iCbwTEJHeMlcMblBogorDmmJ?=
 =?us-ascii?Q?2R5OaV/fXA1NawhxxKAicmP0C2hF3quVElOrFkhDmSVc6GLxMfHsoIH1674H?=
 =?us-ascii?Q?glTSifYfUVyBP4AT/B2RfaNywScVGIgVWbTZr4iZx6fZjeRLQDp+mWDATZOs?=
 =?us-ascii?Q?R4aZ2d8vezpWzde2RVdTc71p+t7rIUoGEwFlNnfY7nKB5e+fu87M+nGV/MBQ?=
 =?us-ascii?Q?PbeOAKsax1BocNoSW0gkOhemfQ0CZ2x+APnbiVnFQDudupfV4BbFtDL9vpzZ?=
 =?us-ascii?Q?HsUvtDmghq1D8SvUMBmsMvStG7H/xF+aWnslfJVlZIHWatjlwoZhcyhd1R1n?=
 =?us-ascii?Q?y5XHbJJkvNOpbeHNJP2Ic/Dv3zo9fAzDf7Rhr7DuQpGkL5IWKjZoc1UTOyAo?=
 =?us-ascii?Q?YWJfE92HRcUnKPUdoncEE94qoujLDgpikV6aoLFBc84Q4EG5hnb6ImD1y9VR?=
 =?us-ascii?Q?JVVIspeBOEGYSf+Vfxm9rFLECs/QN+jk3OjhKpy+OrOFy/ia4NptOUpaMdTc?=
 =?us-ascii?Q?erq1w46faOv2dbipPB7AxCrvChg20D2IyIK0smzfDSjPWfB6X0eV1opQtEzN?=
 =?us-ascii?Q?zTXqbZXQCKzLbSfm8JDdUyoBr/CfkBnOaSoI2OJSfYi01U73/i3bdf/jwKrH?=
 =?us-ascii?Q?dBecWuELhnUYOXiQ1jZwNqfOeo79evErUV14/aNUYquve2HDUqfD0XumVk0Y?=
 =?us-ascii?Q?KBL9t6Tm1VV2G1ltSctjYiOuZQO5xjTunJ+KVVtxDYFcOAZeGW86fy8ZLytm?=
 =?us-ascii?Q?c5u1RgWQOkaR6zlgEvhugJ8OdVNeEyW0G1MklzgnhEBeTJZuVe69cGcjmi2j?=
 =?us-ascii?Q?8x0n5WyYFdprsQ8Jx77Z4GxGpxIcDOqydJaCXrnS8uN91SSvis/TEQS7viDi?=
 =?us-ascii?Q?VhtUyVRFwyNHs880pfdMD4Qrs7hV5S8EAI0vteFybbbYH32PnHda/A7cRIUS?=
 =?us-ascii?Q?kstzlrHanVOcHT7pAbJLZdCME/t0zkHoBwTR81CdG7cR1KV83ig4ednOyX70?=
 =?us-ascii?Q?9JF0SmyAktPPwlZZwlfk7QULuKu9wJtjTbkT1LgZl8LVaAwabYvfXpnQba0C?=
 =?us-ascii?Q?+qRfUENH3nlgTzi/pQYkY89P1lS76r9ogXWtDkO2f6mWCHguOomuj/tKmgPu?=
 =?us-ascii?Q?WrJ46u+najlqQEvuooXxryCQOSCpDgcnIyiI9f+r2fp5FV6hq60tkKPN9y7d?=
 =?us-ascii?Q?SVpi37CV1l9lZ20bFMymCzyBuOHSlqSHDtRBRw5d/LsFwjzBuBrt02CFLAUM?=
 =?us-ascii?Q?VtV0GDlSBpyN9pknDvk+RSCRY4HVBise+nAx//GHooruQ4XJU9OjqFYGKE75?=
 =?us-ascii?Q?JytzXk96jOuhWIfWulYI7EBfHSTW3FSptoPXVwtNzZE2e+wzRmbxFatgTqnP?=
 =?us-ascii?Q?tPk9nSK9yIu5ZmQI6h+dycdr9rRcy+CLouOuSsFlFX3h8r4U2UZROG2qENdo?=
 =?us-ascii?Q?IYo41FoPE3o+y2qgiNCKVjqshhnlrY0mRuTVkVye8frw/jC68S/jNdQsGZAD?=
 =?us-ascii?Q?qccxuU3WTI4+6X4ZMKrD3GowdmymQPZSJseMDfou5sZxSlh+p8X5IlRXEpiL?=
 =?us-ascii?Q?H8ScOQBUTik3GqngPaaSiJZi497VkHkYbgTEy5GKMJrj/HZmO0NfsBQ1qllv?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d016887e-1338-4692-b3db-08da75cb2930
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:05.7308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FItO3V8DXnab5BJO0/WIuwuh9LMyi7jyRKkUeipJ2qX41oX/lUeInfj5gsSqdjWFO3YBWKl+xbMDHGirLMq5a1lRoM477vYGpwjHo/uDuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040015
X-Proofpoint-GUID: HfIeL7RlNJ5ZqSiDS9i2FPeR2cSCAI_v
X-Proofpoint-ORIG-GUID: HfIeL7RlNJ5ZqSiDS9i2FPeR2cSCAI_v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

It looks like the driver wanted a hard failure so this swaps it with
DID_BAD_TARGET.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/storvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index fe000da11332..25c44c87c972 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1029,7 +1029,7 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	 */
 	wrk = kmalloc(sizeof(struct storvsc_scan_work), GFP_ATOMIC);
 	if (!wrk) {
-		set_host_byte(scmnd, DID_TARGET_FAILURE);
+		set_host_byte(scmnd, DID_BAD_TARGET);
 		return;
 	}
 
-- 
2.25.1

