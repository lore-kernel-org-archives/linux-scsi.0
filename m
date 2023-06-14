Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C735FEB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbjFNHWO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbjFNHVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C6F2101
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k02v012014;
        Wed, 14 Jun 2023 07:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=pQ5x4e5F0/nfYtGXX5LiHsm1alVkiIUxO6MyqQE11gA=;
 b=dceZebATFM+oyGeYwjxmIJfdym/LvTZWmGHe9/8HQtyzR4/K1SY7VE4BXAbCvkqVboqQ
 +PiY4IJyjkuCFvjq8zdKfZhUt3TVpQ8ExIPD2TrdkN6OQ258BOJ7NIaBBtt8v8x3W2/i
 vjNqUb4N9F96AXkWa/UOZyljzdpyekgviPQUz0ofeQpwG/4tankHZCytKE24vYa4uG4u
 q2TlT11ctdKCIv/EJ8T77dPlCzuIJ92Oni4QmMkZyFQXVnbG6MpRnJo51aQl9FMRNH0l
 AhugPyb3i4vR02JjJG7anUxun7e/x1J7Q2QRA7LeUeW4v5L121SYKivc9xseK2RX3lyP 9Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fs1xxwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5NeEW017722;
        Wed, 14 Jun 2023 07:17:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm4wsc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eznJWfq4hxrUfGWY8wvTrmhZX8+7XoQX3NRwWvwMCvktlWDQWPqcQ8ze5l3n4otBp9bVyQxImxHfcInFSA9giVZHMlffh2iDj/sw2FBVdBK2O021Gkoe088DU4Spb/9A28fKnfIkUGf9aO0Eaz9V1LM/vmpfsbGmDCN7orSolIaurD3TCJQDP2tz0Oqs6gf5vMr9cnuk8jgzaV/+KGhp/zx2n0LTGrYRtvzbCwiVquRHiU0+yNVQvrOad7PJWIuXUr5xlVxk2wxBn8LBIHM5abYnqWLruT++h3T6cOOrjz3dGuv/k8X6Xx9SGKY6s0ZvVANiDG4C+xBLklUhb1n15Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQ5x4e5F0/nfYtGXX5LiHsm1alVkiIUxO6MyqQE11gA=;
 b=DzdWb+4TKQcxi9jhMsXF/6xCFQ/e+mc/WcokaxdmPhNVFMK/olQeYxZkHMkpIBWnHg4wjRrBfcCWHP2cW6fYwFC3E1DQuiKTyPa1zjnYq50VHlNXxZGrqM9lSDvNBGfkkUQikMypcgDP5p2QGHlgJ5p79fGC8DSksFW37Wc3PsSt75/myAQzsMbmnK97eTJesUp17QPqdi7TdcaE+z1xe3Fb/F0O1kPh3G+HyobzkA5Uw302TbTXPmtuORCEbLC7Nmb3t7W1J+8EWsE//GL2YjxsemewB9EezSCO3vlW0IBUDQlh4vM2qYHHLc1Qzr/OXVwQRsTJDF5++1mBbDEbhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQ5x4e5F0/nfYtGXX5LiHsm1alVkiIUxO6MyqQE11gA=;
 b=YRyFBynG/3zLbU1k67QUTVdRfbTCtD1OOmgr68Kud5hkBC0k+dG31ekokg6SmazWNMLT9TPz3hXY6yRJOWTXrsvj/7/yE4K23/vHj5AQDYaV+Cs81wLYwRD9JJevZ1P4PMlAKVlVCKfgtE2e6JOTjATyusFti1PUBbdP1bukoro=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:48 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 15/33] scsi: spi: Fix sshdr use
Date:   Wed, 14 Jun 2023 02:17:01 -0500
Message-Id: <20230614071719.6372-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::25)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b74a2e3-1d15-4b67-2903-08db6ca77546
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bt6veXCO/1e/hRHmN7eW3rRdm/IynwcbA3HlqMDhtZIhk01D67FoID6Bf0HqrX0WogKG4KgZiZ/O+8OQF/BA435lMu6NyU7p9vhTdlIEAPHBfIb2BXOnswXBVJrJQ0toEah3IvVl1waQv+2EisPDJ7lkSzULAqL2eLI0HKFrSGsfk90S6xSN6kNAWzi2BhgwG0xgpeVdZqgiCKcgvG9OSdLbOKNX+v6uh/MCK78+sxJ+6TdAW3fRpCaVmZJcEAZfo68tOt8gp8oxgBGutK/yD41fmBBEu02Pxe3iGLnQ5FqYBVc88TF5Wr8fVmEu9THoxEZIKRl6ff5wEKHU0+VtgDKrE7/O99LS9lJ2X14GUYx8MW1rZHOjG4wVdYEAlONHHDVgVV6ljl+H/xz6Gby6LdjQXC8c6GQXdtIWRum8bkkytT3CtuW1i2awGhdbQDyQrdBOU9QlrFVEd5yMZmA+jkbdaGRh/l4Qobfaei0RVsivx52or/ZGQs4KozuGf4quzDS53KWn90WvooFDO75l7le68D28Qtp9cX3zGPOZhrOHgC9JNv6Of2Ee1lkpgTVV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a+0mCJAV80dDgIo77VB79fRHFDCVhEbLpzZ2mFTBHBcRBWMHrKVE5Ov+xwmm?=
 =?us-ascii?Q?FfhawCqN/7wMQ3ug7sfZW7wdrTP3R3f9u95x+uVJQNqCUBGeLGDlXRDh7b5h?=
 =?us-ascii?Q?scR+jEoIlRc8teHz28GvNfZQbGe5iAVRFfoyMicyO6zVTw1H3FjKXs8tpkNQ?=
 =?us-ascii?Q?Jt7DS82RwrwMwhXaYIIIgD3/FI9mzcEY0mUuMsEJrtQZfzBhdmrax/eKyZo5?=
 =?us-ascii?Q?MWbQMjUeA/N0z2aJ6bwENgZQwff6rxmFx60p+7kk3M6rBjacik/hmIbD21Jq?=
 =?us-ascii?Q?zjVwDwss/mFkn1csA4dHdGKLoIFj5MWQD6lGI09vHhwAny7MYSurqDgEuvxD?=
 =?us-ascii?Q?ezgqL50fvX/Xza+vVRW/kPEiCJ/zfuKRRncrO8nlnLSa3OVkbEmqHTfilTGV?=
 =?us-ascii?Q?QBwoH6BcASbvY01amwDat1784bqr5JoyMABKxTyyxpTb4KF1a33PWB23oiz0?=
 =?us-ascii?Q?216QNI2d6Egos9DXpqIL8y/42BBfcVW343uPXbqB/uvKKwr/G8avwgznD50K?=
 =?us-ascii?Q?f3XEg4nSOhHJ2AVL/pziPRTlxpz6jHeu/pJo7q2MLHMUJhD49htuBv+2FaKR?=
 =?us-ascii?Q?53xCV7Bi/rWbYLv5NCsJ29iZrgez+L8GLJj5bH2EvvWw7r+Cwx/Rg8ZbvgPt?=
 =?us-ascii?Q?U2bpfGKE24mB+pb5Phe2r8T+gaF8oIvZ9/B5Ugzop8Oqx4UNedwdmkT+GHAx?=
 =?us-ascii?Q?dyF2dzr7BUcd1L7fS+nalmZY2g4D7Fk0WouogzJWOftvZq1JSbYw/lqNB1J4?=
 =?us-ascii?Q?PU0NJ76gFJuoQWKUiBdYj1vDNUa2GF5qVsw/darY/4qSdcE45DyRw6aupDdk?=
 =?us-ascii?Q?HYII+ssSRxz+NGvn+Z3/BTz4leG66mkxJJW9J3uBQvdc5qGQDHr7iRFKeaxw?=
 =?us-ascii?Q?lxFO0dZz4z7s2sOEesHR0YSje5OUCZm5wdyN/0YtjNSj3zQOxT6SBn8cFYg9?=
 =?us-ascii?Q?nsm1tT9f2ugFpVLg7KSsl+335OVCsjDiMkAx9cl3vj5Y3rWg3guxTQBjRoac?=
 =?us-ascii?Q?2ziL9kZxBsvjZkZeHRTEIt7wucwXRlgpbubkastJSneGmis79mR419A9ZXdS?=
 =?us-ascii?Q?qWrGn4nKNhOSr2IwPYcA8v97oOmJpiIaZAqMK81060EbNoRjVSUR8QDyA6dW?=
 =?us-ascii?Q?hkOXoA+eIAmwODnWiq2k+qfZirbFKVlkJ1fMOwsNlNqz6c9v4gO4M1LbtHyz?=
 =?us-ascii?Q?X6+fQXimB+G4UcMNZ7Ar7GGQym76x79r+qV5ws1EFFIN9bPV9KVU2yBhs3XL?=
 =?us-ascii?Q?NdU+kfU1TUc3Mz/r1yxAEPd+0piQMwzSERhCK8GExzye9ReotBcLnR5JxTMQ?=
 =?us-ascii?Q?3JbnMv8z9MdvgT0FbyCkTOOKPHoxavhCLR9W/EJcxZ1gQXxoBMWf2/9xqkCr?=
 =?us-ascii?Q?5vdo9lONRv75gqF/G2H+DgVRHK9zMkNxxui7pwjQqUPZOiBPrxS1tTAx4rgY?=
 =?us-ascii?Q?4OONtJT2AhuvdYxhbZLXGOUv+sC5lwoxjktPn1vOEYsgNlI6uwXQDD4IvOoF?=
 =?us-ascii?Q?jJqr5jfnHgqEcKTThw84/cEJknIMS5uR0k1345l6kykCF4R6CetqLbnbPsUg?=
 =?us-ascii?Q?Ds4ig+vwas/U5c7z9y6dH2njni7sPmk1oGCcs5umi+5nv6mMV0pB1jx8J69e?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Bl/B69x55W5qyvkJWA4y2FcbrJxQpHC6ZzfpcD5pSskA3DUT6U24GQWEUM5uSGIGnvd3jATxY1cZkPtWnLwdsx5/8K2+yaRYlvBP1KjFvDmvtEHKWbtcRFM/vnYgPQCkhJNa3HjsMN/oaXnnnhRJpEkScOv8yf668cSM9Wi6mfNUXtBUP8vBQU/53aqswILxHhXxiw23A7AvrjuChCvQPkr12OfSM1N/pL/LJvmGJicxpfrmoAfQZu+3R2W2iyq3z7Jj9M6zitGESjk2cIfwCqGtbDR1UeOuHcCE+E8ThK53ZRy6f7OHCiwC+iXBgOOs1ndGBdjvdrNwuK6oqxfuIEg0zO8eiqQ6LJteDgUI3mNkt0QbdBQNyAuIzj982wOB4kzkg/cCiv++1uUbX+wt5QMTEfbb1v57KlljSUXTaLosoIHt+RjBpiMEZeB39nSB/TWtDxa8PISSDcWX1ae4ofsCcTquqqSjH+WW/9CZi7t8RUA0tEDmWPEBFNFF/uY1H54X7p2FXrCpxzWopWhL9kQmKA27N/QyQdIPAN4BY83fYuVX13icY/SicQOnUS/j4SJ5ie3cMgxzHE9vKzSaJ9baBbSeZHYSe/Fx2/WnqiGxDJT3wcHBNHMntubGJyny2l/VoQhzbzlA8U1oeihhUPjXiSS4domVjV9bySPK6IZpfhTqkrdkyz5mJaYWkctS6twjYofCwYUie1wqSBlvNE5HSL92j5QBzKQEj5j4qYAzV1E4y/Gu5xTFoCdVsqEovGxdZZmTZudOd9L3klfrY2Qc9AMlJhakPny25qk3YRIoORzKgNXxK65zy8p1V/Ky3R9APGIhjnKX6MjUorbPztqDm8h/TcfhCcXCnAihbOiGY3najmhtFqEq5QyNZHSA
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b74a2e3-1d15-4b67-2903-08db6ca77546
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:48.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkgCEoG3T/3Dl/3RW1xvBz5l3Hqa8hTpOPe0EZaVG/AVMYdRT/ahUWQ25oR4s60TtyQxBSMLgk66jbKvIAVoEcoSxlAJduMzUN7i+M5hbcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-GUID: lD40UBDaeGrEopfBPwtoDZjv-Zda43yl
X-Proofpoint-ORIG-GUID: lD40UBDaeGrEopfBPwtoDZjv-Zda43yl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0 it will not have set the sshdr, so we
can't access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2442d4d2e3f3..2100c3adb456 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -126,7 +126,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 */
 		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
 					  DV_TIMEOUT, 1, &exec_args);
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
+		if (result <= 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
 	}
@@ -676,10 +676,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
-		if(result || !scsi_device_online(sdev)) {
+		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_sense_valid(&sshdr)
+			if (result > 0 && scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
-- 
2.25.1

