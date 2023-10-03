Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69672E8FDB6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbjJCUxp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241126AbjJCUxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:53:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F4E5
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:53:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I55in006253;
        Tue, 3 Oct 2023 20:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=bYuYfq0KX1VWy+GQhMkFCKnktr0DaIP/0QSWrqmtqbY=;
 b=vNwTIATRtSwmpw+baJ635WyAh6SwdrE/u3/J/rnszosnDd0/K4FVso61nQbTFwxUc9v+
 QirdizDRF+ybm/drDGYio6O+b8SI/MCihitXbqtlv56hf3H3lpv5/6oTumuH6IbIve9y
 8tN/tAjcXeM14/F0aDaDIdrLoxidK6MA8aKU3+4ERLl/fKmoP5ZrxG12dKIsdzozEn5Y
 cOCt7vu/N9IIxcEehO7rtJ4kYrLBe3rtLgLUn6wM+icIqYCoy1EKJxeBavmQ7RSyicbO
 OYzfXOgoVZhLXfO/LVIdkTLboX7gfxSC4dZcycDeNHrNJn8/LEUu6XTri1xFa1oXz+9u yQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tec7vdnrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K99te008651;
        Tue, 3 Oct 2023 20:51:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea47425h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHyEYP+Oq9/mt+9lgkAhgWxNgHMU658nnF6HXLCjWt4M5o11kY+kSHIUbjcV8/TZRShYc+hFBs8gD76lxiflKnjqo6a+/dyXbgo6TUoRtTiyiIle/fuHVnk3dWXhpN52gyliBU4agaAvfBqTg6BKInYeAfP2ljE5afWpwViQnsqUKDw0fpaDBenuqhNmibkC6VS0/VgVotCPNIk/SPi39uCxIVixCLj7vx+aJqM9uI0fu0cSVzf6TqMagzjslGVb87J1/qmD7ttzRtWVDOvK7Bj2nj71c/gVKwLw+wKTY/pCsLKQwFawppMoSOzBFJQ0woJ7vZWd5VM88eWKwWSxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYuYfq0KX1VWy+GQhMkFCKnktr0DaIP/0QSWrqmtqbY=;
 b=bP4F5vPZ2wtR70JUX+YZaXLWXC6I27vhGERYDs2BopT2vpNlWa7mFWYMQ7VuhvfTaHhbYF7GCjBvlaVlBDBmkaNLakqav/ElltoGH/e3drWfV0DDQQZr3hvz0Y+Xwb7qlrU+y4FH7UOVkobGd80nNZET9Tb6XkVR1Wm1se18ycBsTeWp8bq/A8eKJMBUiem+zEH1pGhonerLV/qiiCMFMGDokBdt2KMDNf50C4dOsvBzm4B1pSYijoci0krrGH/eSKT153iM/ZdperAh1Cedpk2vzt1zBV6CZ28mjZyPP9Z6vft965Wa6h8LEz9N5fp2FDvAVJWzZ3tfGCH09uTLfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYuYfq0KX1VWy+GQhMkFCKnktr0DaIP/0QSWrqmtqbY=;
 b=GHdX0WTXGGzkm3o0YVX/BCTghNDmReq6g856iE/XUP6SJTdj4mAkXXzH54Bxixj/mfylDYBqaH4WkYdkVfa5cOUUsS/puQ+/SKLW9xiWqc+XSYbRITzK6TUU3Q9cQAgFrwK0w8Oze+IkrPPuQ7tCsDuzMUUpB2/ur89HzKVZSwA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:17 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/12] scsi: Fix sshdr use in scsi_cdl_enable
Date:   Tue,  3 Oct 2023 15:50:52 -0500
Message-Id: <20231003205054.84507-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e45828e-75e6-482f-c501-08dbc4527d91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYLIbPHOuyTHf1aUO45l++QEqfSBYnBESEMDy2CMyv+GRxVqu/SRHBphlIRDTDjGNkvFp0wDDDWc6zAmzPxBsAha2Cxeqhdbgx0ayp26Kj6FsoB3QuhoGUDmYnl0TGY/K3uIOHdqa83vCtCEbRqELxG+XJonHtjQ95d5HqRp8xPJJLAUtjoEXw2o+em2XFYFa+ar+ahLhvhRUCgyylNsCezrT2LkswG/38WODnzoL5iOFCfSKmRAbp413v8gX+FmFSp+2PHh74ZXOcEaC8LvV0hONRYSy4k8XzPx8uS29FK3H92e0Ppopc9ucJroyxrEUke4GdomsXJv8NCRxUORind/kxQVXydiTqOW/XPK9qosEXKUJWz2GXo+Pd00NRJ4lqZh/7DQqiLjgWRlqlgUkDPhXaEEeISX/IdWmyrPB8ga/ame5S1DRJjjJHz8USIgb39dc6emoi1KoZkzQk4HSqc0xvgcBbOLQY+ZrhEbBwjMJ1KKXbjqOSxV4f1KpZxQc2LeZpVL5RsP2oUr/PH5gnSj/asfqfo0FJKy4pMTPVfz7iECjxOnrODHdYF7Fanc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RrkwhUCDT7zt5P/T6xjv2Z1tG8kc742gWamOBZha3Zfy6EKe7mnKFDIO794X?=
 =?us-ascii?Q?UwETaK1qS/2+DBxtg3d2WLly9nnDEal2awNNv7+ZRC5CI1TytwDDzqUz1a1a?=
 =?us-ascii?Q?ws8oGmqQCVuP+0O/yOncvSM5wNBgDIoj/Lxmde7qx2TcgxKyk5DIKXs5Bd6n?=
 =?us-ascii?Q?PzntD2N9QKbjMX0Yx7c8N6r1sdBiEGkJTR5XojkH7A37pQLsCj5Z6T7/cyA0?=
 =?us-ascii?Q?qNSX6BVNO60RtFhHua8RZrIKijQ1wf4dYgqzCw+unnpgcMHQ2Ot3HDmWH1Uz?=
 =?us-ascii?Q?CGrVByP7me3+6CWkItQE4f0+rXHZULNX5C89Ax4ddJ70+DmO13vzsU2ucaur?=
 =?us-ascii?Q?C22E7ER2q3vdyNkyByxU/z+fCjmXw3dyf+Zvj8NwQclLwJfurl/YtlMtND8Y?=
 =?us-ascii?Q?xga8Qb8J6SSUA+67+9Zb59qJNpCkfR9zmN5k/ZZ3Djy9a0Bng6likGc782WN?=
 =?us-ascii?Q?cUbuQzkWNGRVfZkit5IEnbxl/E7a9Md//zBO535ZEBD18ffaTnEbjudUMPmv?=
 =?us-ascii?Q?1AXcs971wNrpxGKkjq5Ad5bpPzXT/Xt/h6IhZmcktMSx5Ja56cmLBxuD2W2d?=
 =?us-ascii?Q?0Er76KFKAgQUXdYan0OPvnT3sPgiF76m3AfAmFgii63t8s5v8OZOYSgdHWks?=
 =?us-ascii?Q?WbgYLB+WuqiggfyEeY0iLoikUBVchpImfmZ/Xmvvo+1BnOZWag23Zu+yaipX?=
 =?us-ascii?Q?T7CQsAB5wD0MzjFUjATAysejAYQG95pnkR30ZD6lGt/wnlOnTw8qy44nnLAA?=
 =?us-ascii?Q?lO9v6koXg+pzB3SMIkgg8nImjzCX2CoymVTjYKmosZ+pZg8yiZAzJnd/vwYz?=
 =?us-ascii?Q?qc/Y4Kr7T3lWxSSm1lHSbGhss0PZyCnkPnfMut3hqcY6zCqAfMjPLbCLFvlu?=
 =?us-ascii?Q?flXPg/8gKYXNm4bLnmBRnCn3tmL1P3XAxDmcfWcDbAjIpQcS8teHT71kzGLf?=
 =?us-ascii?Q?ok2COjRBPnwh1gmY/y0/xg8BTc9YQwq/HsUxIi8s9BWCN8iE1JU4pbaXwJsL?=
 =?us-ascii?Q?9jTroxzmpqNlIT4CZTF/Pfm0riUfP8dKfUZ3+X1bal7iIm8myq7st8wnbm1i?=
 =?us-ascii?Q?ixQgwFoPEnGg2CmrUbv2Z/tZ9nnCX+gfpM2cuAxHTLJX0BgCAt3YLjghJtrn?=
 =?us-ascii?Q?PvGXXhExc7666fni9nj8+RPv/RoCseXKXrtXvtuXseR0cNBJUjm2HsMmoEBP?=
 =?us-ascii?Q?T96Y3h9Unzcuzz8urcnh8Ro2k8oWEqL2hbk+t1ckhZHjfdGcq7gjL1QjpCQ1?=
 =?us-ascii?Q?vhkKkeROMIrZ3OJxrTbHRr4Ny2H/BespReZE37BsQPbLmvzIB1Hbc5mulL+R?=
 =?us-ascii?Q?Ety7CC3Lli1N62CCMoOALDgrteLQhcVMEtR6cXbBbuBPpNpzIlxwrOe1RoQt?=
 =?us-ascii?Q?qMusGFM3C9B/vcIlnSNctNfwmDUJEs9mNjLtuTm1AaoziE48fyImOZV5b2Qc?=
 =?us-ascii?Q?VbVN/+KdO9HZtu3bqePQHzgWsUu0HTI/4/p0FFvJ+QUFu83+xFnyWvav9SXM?=
 =?us-ascii?Q?5EoOTxHb9+cR97TpLMA9RgWcmoejXBaPjkoNS10Gqgp6ekTLrMNTd6TjhNXD?=
 =?us-ascii?Q?dmbYFGfWLEelJI98lNoKaZf9nv7uDCI+m4wJ2/YOJwTCXay15y6IsfkP5+17?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CRhCttWWpED4F44ZQbdLriaEMKC6A9Wr7O+pTD/tXXW99h5m1uoKwXZYa2/vTiHqruoUWKCV8xsqkdQ6mhW6HkMH7GfgS1Ct/hwNY/33yge1Apo4j1+i/NKWZu7YTxZDpQY1J1l7SemO7luZjo8Pwd6eaIhTAYBUU180OBLXDq5aFcKp5UMUYH33XYIM19t3e0FaqGQsoHQKVPwGXa8XHYgij5wNOjJR/vG0ZaqO9YOl8p/BTEFAypwm5Y2YVDjkw0ydw/6Cbbdh+BbDjKphKtwPDJGjCBDHZrDnhO7GcuzWsTsFONNN92khkUPDwEIHibEHsZICVaS+K1KV8awaQAMCGDtdXV3ouzqMiTTXzkosUhII47urU+rLQ8xJR8ANgdeHUSe6LJGXg0bOyDWcvuwzqpz0L9S1P2c40k/Uzl80j+RQs/2xHKgobNJP4wLQLdkIYXPduncyHtDsyCqZXh5p7KLE6w/XYs/GIOBNbAKwsmyETX97h/KuuKzFyopBbakQFi6Xa13JvHKQzKwm6lHSFSU+yIFbA23HXnYiKJ+C+53wRJqTKQ2qqgzECn9qQQGveyg8TXBWnbrvJixPA/5pR6sKKCVN7hYrXhqiiqYxlAY5Vgna6nbqif37hHre3JINqYvgmIFHaX8tE00eRpOBk8aEnNPcO7Qe55vxrhkTfOaCzC4OWtorGcEKCG4MqmhcTM4tHbvMFyun8mTvsvQ5RBbGfZoVit/j/B2dDr3KiAvAxYeiyo8AC17JZxDAcPkVSX66SqLkgTTApwzENxsbeCL9M8kDaYEp25mVfU1YGF9aLC5/DphhLKmKXoh9+vNmZQWMVp0Ms5gLVqyqYOSzRweBXlrquBIgkiNaXW4AuHvq8VVT7nWLFur4vAYe
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e45828e-75e6-482f-c501-08dbc4527d91
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:17.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cb+ANdmgVEhlTeQCL8dxzAAHDF/LzqWww4WcAQl1Efn5q1mel7Ndq/sXat0GpTnkkAfGiIJTMnY/eyF+s6jBOmmOYfs0DRQpv7MufKBVk8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030158
X-Proofpoint-ORIG-GUID: QugtZk3Dasa47SgtUf50Wxt_Des_Cs01
X-Proofpoint-GUID: QugtZk3Dasa47SgtUf50Wxt_Des_Cs01
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
 drivers/scsi/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d0911bc28663..d1c0ba3ef1f5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -692,7 +692,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
 				       &data, &sshdr);
 		if (ret) {
-			if (scsi_sense_valid(&sshdr))
+			if (ret > 0 && scsi_sense_valid(&sshdr))
 				scsi_print_sense_hdr(sdev,
 					dev_name(&sdev->sdev_gendev), &sshdr);
 			return ret;
-- 
2.34.1

