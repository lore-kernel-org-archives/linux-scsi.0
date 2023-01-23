Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BED2C05027
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjAWWOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjAWWNy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:13:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC62939CF4
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:13:23 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLiKxP025538;
        Mon, 23 Jan 2023 22:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=uicPtf8cr52y5uT3OJfOB4GKllv6H8jMUhm74YHTjkk=;
 b=JhawqjoPHOaCo2MAqC66jrqmlu2WFUl2W+kw4GtAyOWDgkZAuyE/q0iNMeb+FjzDK1/B
 Fnv73hbKJDlVJAHWqS7G8+7hQkjQfROEe2iwrDL0d3P7gv/wf6kD/aNE8jeP5Ea/5FMt
 pJs1JIM2ODY86pV8Ws6uPUgzkljiEarVM6dvOB5nzHUvoCthwPF0JZJDondQGsaK8COA
 sw05O5tXeMD6dCbqObLmHP7JbZeUksyGrtQ1s0grZZbQnSSuXq9g/gwIz6qAv8dpfdgI
 qjT0pJkLI88epxzdIkM7Dw/jLdSd9nw78W6lpEBEikfpNCRAeTQk4UcI79Ie3mUZF8SI 1Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybc2u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NL0D0v001298;
        Mon, 23 Jan 2023 22:11:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gadtmk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdSBz1xhLpfIJFVcoUQY41o/rz8ernHHwahN4FufiC9tx4SvTi24ecoWeh1SEqptO7MKmFk1RzdW6GdX5US2BU9FHsemMz0iXhkVJeVSy4kbVmzyE72ahbrKLoS4WLaxEfxQwGOvRynot6AWfODhyiaRGgy9MhNc2LQdntdvbVMHYLlrIdODt87blnD04cS4xXXYlFZOnLhRb8DU5j+O5UFVx9AeGdray8Z5SDLdisM0D7GvMSbM//j1it6kQkyB05BG1iaq6Bm18nb4M5eTgxpNfAjkRs2XvplaCxXuOGiI61lsV0N8z1Ou0PPh45xDZWJf2wNO4l8Ine38MbvBGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uicPtf8cr52y5uT3OJfOB4GKllv6H8jMUhm74YHTjkk=;
 b=bdWy4LYJlxIWaoIdInVKE1jDIRNgEPsptqTdeEfwMPxhpVNij62hJzgNbQDA8DK3UXwT3rbAuWjSmaMECwrjooyoqysuA3UiUzSyqD8HMH/4ZJlb74IVfLWncKAIklheVCK/EeI2KbcAml6yae3IbQzVi4gCWNv5942jJl2xz9NfctEVyISIkxBz69BzQAMecwiyoq6n3ZyckLsMdMegAgzWjerZQPRmyKcj4E6WRygvXw9wuSTsTq6nPc7BO2vOcuuYGP66nH2KSYxCiixnHTUpNEPmzdR/+4umFA7tdA7H7d1OMoLH25C3wA/6JB7nGeKWhjqQ80JkgrimX7JxvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uicPtf8cr52y5uT3OJfOB4GKllv6H8jMUhm74YHTjkk=;
 b=siEHT+FbvmuoeeI5DTuIBXXDHN+AQ98wA/UhSZYTNKamuFre1X+dUfBqHqkH34YXHCcsp2PAwvTagjdbdo/1NuqMPvuu8BrvfbI4AhlglJXYgGDCU+yPs4poOiTrYI8ZFHDp7zpNrnoepTk12Ju8osRKd8W7ecUEdgxJekgVC1U=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 10/22] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Mon, 23 Jan 2023 16:10:34 -0600
Message-Id: <20230123221046.125483-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0109.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 340885e7-721e-4f4f-668a-08dafd8eb8d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQSlUbaaVQvUYZiCbwDNElrehKvMjZ8t7enrCmDW3CHMLYXVGUDmDi38/VY59brgEOvD0rU59w5JaQrdRhENh/c/M7cen4LeCDt+tEEG6ZE00nUYGjRe/upgxNoA2eAhViHvesLKzRx8WiCS4/MZcicD1m+op3+vtApAK0fSFE3JmQZ3cGGhWLQhAfiZQ7hq43gQ0NRdxPWWxJie25wK79qFCJYk0OW6AGRKGjgme2qZK42AUTz8/KVJhRCdPT4T/NphW4cAJKmamrgqcK3htpBGTolxZo0Yl6DdF/iHOHI7N/JAKWJuJ2Wxl0y4F8jwRMNOl1/Wj77AJxanJ/QNSr6sr7TG5AnoKIKJT5XoAViSUVf7HyrRX4oZqWyiqM3WRVPTf7xRchqqPiMwilZ0GReRM9q+W+c47KT4/kBso+ZDtbL/Tr56kryrfo5xzLTP3u817m7ciHvax/33lTT6puk7hUOMZScHzvyJnJwqyt+gDnWvOj+rtqhl/VhwHMsnWXSW2sfEnms+79za+vIb0Yea51uJq+txdUVKSI2sfV2IoH3sN+fmi4fW4jurI+DWYcyp2MvlWX9k3zrg0ciBp3LD2YcmOoMX6f23fREB6UR1H0smYQot8a8hgFGsWMlRqJowWcAvfOrdsrGPhp93gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RqmtDNbkAidOhJVu2VpWi4TlCuZiMzBw7hkADd9Xb41/vuyU9qX8Gh8Hidsg?=
 =?us-ascii?Q?aWHmyIfSbIpPMPcU/xLi3Y1umcULJZLo246+P/2VX1GkB7uob06ghKhU/uxl?=
 =?us-ascii?Q?t5wNB5u1kI4H37db4MAAq73sGCOQrapyEtKXOyFD1e7sbJAjJYDKU3O/Bky3?=
 =?us-ascii?Q?lXf8kUk0bg76Odqzu3/ws8KxBKj3HyklaLX7C76E230CN46xZRDLuhoFYFva?=
 =?us-ascii?Q?rnlccjzMMVrVZrRL2S7FSv/4fbuGykP+DuyDa+Bkmk14ZZPCBLemaNd5Noj3?=
 =?us-ascii?Q?ruCKo+uEqKpY9a+Fgv1cUB/ZIRxGIEQ2R+Vx4kg2tgKt+AonGZUB7Y2SvdSn?=
 =?us-ascii?Q?As/zMH0TwMETQc6iT5FmTbu9yRkMnG6lY2eZz4G+CgnK+u91VNbruLH03HIx?=
 =?us-ascii?Q?cTqBlZvRzJWQBwSlJQFTHZ9NwZRhcqTQpzkv4oFs02kze7GWY++PE9w8GcK8?=
 =?us-ascii?Q?sSOBVXb+R9/C2xclaVlddFQh9YK6NXkCmnGaziULxF8IvDa/8dTyJpa7pcJ7?=
 =?us-ascii?Q?9sihcxCRE1bRjdM/jpzUIHGqOv0UgVOdvtMH7Cjvcd3LLbpsgmjqnXSoA3jP?=
 =?us-ascii?Q?r2EVV+d0KqRqUqkhNFcrr/23+E0RxfNQ1Cf0ZboLYEWdVMa3cbQDkD/xHKBn?=
 =?us-ascii?Q?P3qo3Q3FtOpxNz1Si9zAAS8uiF/MGaC0BoQpI0AO6dr3Yf21rG+s1U3ui6aL?=
 =?us-ascii?Q?2NTY5Kp9SMNhAwny3jxUHIc+UbVcERGNBx8GBitnLWVDh5OBwTxFcrEsV6H/?=
 =?us-ascii?Q?4pE6ruXYrzcV5Rv7JbOo0eB8pe3MaRkzdWBwHC0QADfXP4LxJWfTfJkAZ53U?=
 =?us-ascii?Q?MZX2Q6E8OXSI0ij6YOUnRjOWSDj3r24qRX3Svt4q+wcYGe6SVsS8NIuya+Xr?=
 =?us-ascii?Q?8Xl4y0kYsoL9Re7VS8HKYUBvsnj/jyM+SXK582amMaFRWYQoCRsvCT7jYydt?=
 =?us-ascii?Q?P8xgfSPdsHzbs2J4CrnAnQyhTDSHGaQAd964Rz8Lo/roZKhPbAcKLEPAI1ae?=
 =?us-ascii?Q?gBjKe/Gu1fCDCtsKroHkiD052lfUkhtZL2f1mGy3yG/5FU9OO6rpvm2FtZ/e?=
 =?us-ascii?Q?KFxmEWMxLiOv4nwV4cPiyIBIM5z6geDOj4iCaeOQ9RUtt0x+skDwA1JE+Cn0?=
 =?us-ascii?Q?VDUBn3VEVM6vwW5GGpf7/tB/CZl840KYWIridm2uClzuPM7NI/kGO7Et/ZV6?=
 =?us-ascii?Q?E/nOu737TKsZG2SeVJYYMU1T3qg47iJMY5r4EAKAV2gX45wvtggFKK2HNDU+?=
 =?us-ascii?Q?5WdATzA4Axqum8Kf7DpdZZZpKluxy2lfa52CTpRBQ8NyNcjut+iXr5/QLDFJ?=
 =?us-ascii?Q?Q8G6Djw/V6jdfbzu/XUnkGQhtrlY6HyUxU93qVyoSSUSV+cWXA7NVZSo+GbN?=
 =?us-ascii?Q?ZaSL8jsRiA6oF/S5pr20SvrC/caR/6UHTZGYxa6Lh4suH5y5Fyx2CCkdj06z?=
 =?us-ascii?Q?nd4DV3sMy5yIfbhbip+i3ppeu8KB5PsUJuF46KeyzMwYIcyu28V8V+VcE+qm?=
 =?us-ascii?Q?iMano0lJTx4EzRQd20nwolh6V9v9PDdsqgpDBoFMeRjm6EUJ8LI1oW2go66a?=
 =?us-ascii?Q?CyHHfMSqgOj1PQAJyp1NVGMJveKO0f/v9FrA2doGP50ZEZAx0zkxYEPL7WBw?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: p5LnNbqmFTxGEz2RbMI9eudLSGuQCRxgkHps9AOtJE+TuU9A1B7+3A81YG62mXQtyrKu1j3Ej0SmSmdbpPlEeVVUx1iONCm1fTbZY4A+xdj5P7/QzniL8bh7xif/xFYJlAWkz+rh72kfVg0cOnogMCy95RZZ6echdChHyAPkIgBhxwAPGIHUOfBHfwJG/9UKIpDaU3Jucf78H6A9Phr2NpkzpD+bqALc95uLZMJbfew6H7YfUqy8UoUv5GKFRgbhxCXdsUi53u+nrMP5ozDant4ZcEgOxGhGnmHHlJtydEMQt+S0Hc0i564BkseksIODErbMkkO6lvdQBjQE7rOYhKW1945y/mKSHfYRUV52eESEkMc4vbLQrRcYLQDBe3Sxy0NXwGde6b/Wz2okBDsZGDSjWdhbIXeCoVtLVjI3l2qhq2X4WBl4HYrEyxKuiFU0tQ1DIdQngKluL95OA/yeNat+dJE/8Ffv5FfY9BrgLiiMwCSKnjmoza0MiyEycrxWwuPI5JwUGTV69ADzZDLlqT9vZZt7WIFvZfWBCyAQCtXBHVMrcYLwKwM+boTomhZUZMU0pijcS9V6MJAMfQp3K73VE7KKc3MGiL5zUz78IuwiTPLIKZSsMCBQhzqc20j6TClOld+W0wMv0PKTSNyuEdBU+8hUERa0nVDMP5nHEHvjoQ2rA6PcNtj25hH/oY0ljLcQ+rxEk+3VWlHYjQHnIMWw1tiOAZJ+nYLiftsaNE27XOAc5RYYcjl0kRzo+yyKdPaVKJJgjcwfAj/3ul6Fbopfd5LEa/WjQT5QzXi2Nb4YRCDX+i2CD4E2WQi6r/pnzpwpq6VB42GSHODqGtEWpZ329GRXhamcJPYJDJGvKnali0UpQIb44KF7G0yWqSJy
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 340885e7-721e-4f4f-668a-08dafd8eb8d9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:05.6191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPJuG0/hPoCf+q9vMKFD+vqn+AaimbCS8uuK3/poEN7UsfSvbbuxXZAmCPKmrAXFq1Sj88zliKK74cbnPbWVf8N8TAdBLgfFZkqotIkwA0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: kMHBntzoCaRi0ijzKMR5RaCSPm5M9crB
X-Proofpoint-ORIG-GUID: kMHBntzoCaRi0ijzKMR5RaCSPm5M9crB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

There is one behavior change with this patch. We used to get a total of
5 retries for errors mode_select_handle_sense returned SCSI_DH_RETRY. We
now get 5 retries for each failure.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 91 ++++++++++++----------
 1 file changed, 51 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c5538645057a..a1192cb60406 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,8 +512,52 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	spin_lock(&ctlr->ms_lock);
@@ -548,24 +566,17 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
-	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, MODE_SELECT command",
+		 (char *)h->ctlr->array_name, h->ctlr->index);
 
 	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args))
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.25.1

