Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8ACC47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8A32613D8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhEYRtW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 13:49:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhEYRtV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 13:49:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHjQ03038745;
        Tue, 25 May 2021 17:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pIvg3mXRthOH/DAj1sIPSFQ+0rR3T4+AgoKP2ls7USw=;
 b=tYeFhrWvAaI94eQXES1atwZJE5bCykCSQxu5CaqyCL3kc1j5E8QOQrTUcBwcBVHTgS95
 k0aH0KypyyB7Heyc9uqQIYQBPbu1M0GLboJO6oi6zZR/m4dGtlKiQRLJInMBOh9Sma9q
 k+UvP72fnl2vy1BeSkSsUhlpoP9XxDk/5ZLYTAcu7igPFfVks9XFqOopsmtpYwWBoBhc
 96x++bU0mW3WGleH/IWLaajVTuF65MbFPqZ8MyD/SYVOBwX+1NuhL0DC0bCEgF4gaxIQ
 BL178ooft0JEt6y1wXEdO5joMocYKKCCjqg5UK0MpDHRrDhJAq3ZLwYRWZ6rPmUXjen5 iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38ptkp6ta6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:47:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHe47v042965;
        Tue, 25 May 2021 17:47:46 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by aserp3030.oracle.com with ESMTP id 38pr0c0mdh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:47:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbN/TsctuxN3aqX/nCMUicJ9XBoG4oy1DoWlybK3/zzYV0Nb5xffaQ9ytizTXXKoTFBYIiOaiEaO9dPLUV3OBJ9hCaTN1AqEhTTGilptsIMW4fYyJC/NgdwnNPjFQM6DaLqOgkAwArwJY0tg8F8I6B0VMiMFspTHi0aavImQrqev90pF0YeG/eY767ZWWxWV7EmQ/hfD8fkkMpu14vAG62nDvmk+ae/Sp2NCkUZF9LPZayIHnmIU32KqxxKj24dlE7UHtik044qY0gDeo61yAJmAAS64tU3tJfsO4cdLifKyrbI+BpOUP0VjfcdIHUNw1Hyy4/Xt81CyNnJRsprRtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIvg3mXRthOH/DAj1sIPSFQ+0rR3T4+AgoKP2ls7USw=;
 b=n8DVDlsnNCJ4nkcrAxY7wcFQw2gNYn4IHeHWV3ra3no7s4YjtsFuTvDe5AnMBJ/m0nE3qQ8Xs9kR7qhoqzyj3Sxm6aI4UNTmOVBulA7uN4kMWSQM3CSF6Cp2xsxvG+8shjtFDiSC+DqRoMKM9jLtcGxyDSbvJUjl/RGihsAemVCvrqlg3VDn/7LxlgBypylGzAG0ccdNWi7AVHgvbRHxOc97RcfrzYNecTe5YeXDNwEsrj+fgvGOrsNmj6eyUSYc9oX/Vww2pWYssLvNqc+xipSs2hpH4mi8aCpkAdAR9V2wRdC/BYAx4xSD6N7YXClFLmFrFMayaWfCxYIN6e2/zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIvg3mXRthOH/DAj1sIPSFQ+0rR3T4+AgoKP2ls7USw=;
 b=SZO/4JV9mdlcQtrmBGszWffRvS8472U5fpo4ZwImZhCxcDs4UrVehAAyAmSSBJyWTUoAURAiUlPywk4IE9fqx0oUAxi9wXuGuEhDTLpGsjBA/xHdzOq2ZvTXniHPAe9hkDyj/P6mGpaEvnOBxzcb0xosvTnq69Qu4rKnaLGE+G0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4720.namprd10.prod.outlook.com (2603:10b6:a03:2d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 17:47:45 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 17:47:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/5] vhost-scsi: remove extra flushes
Date:   Tue, 25 May 2021 12:47:30 -0500
Message-Id: <20210525174733.6212-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525174733.6212-1-michael.christie@oracle.com>
References: <20210525174733.6212-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR19CA0009.namprd19.prod.outlook.com
 (2603:10b6:3:151::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR19CA0009.namprd19.prod.outlook.com (2603:10b6:3:151::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Tue, 25 May 2021 17:47:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dc9693a-dcf4-43be-db6c-08d91fa533d0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4720A56B9D88A79B79A64008F1259@SJ0PR10MB4720.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eIHsgV3RlQcraunmAZN2hsq+8RYoU7evt0wyanjsfyXPSKWKc/hpvmrAYVWKs/P4WuvpT8pyvuuVHvoGAdwO7QhCbP/0GYqWCbCEhVbvhPBceDUuyoJGePssrQf/EF7l/YUr7jiMlHb6sEZILSesakwzemhwZjxBkri0+HGS3+uz6dxM1h6Hstm3tBOjh1EfQTMy3N+d/75wSdqT5e3rqXgJtqUPqzfVIqgTmJMB5SBG76MT70rfMC4489xPhqMrMIbG84UikgGvdWwN9Ph1IW48phVZ1Q49XbnW6d3CvoKh4DMpBIDb4xRNJomY629CZOAoIggQWhjxzO3dC4t2Hah6CBNOZnePwKpyhmGgUuDPAEYAVBTz/ya7lCse5bvd5j/zzvGmOkYxXw+9/JL+S/Xr3iRUO4e8fFTxddHptLigKSAYVcvaJ/DyKVkKLXctPT+xVbgkx+6Jzf6I0Ypx/JyhZBrHhjE7VoKDGKw1K9A5rlWiX5IR2yuX0AXgPwOGYUX8yT6M4qKNFiGHB/6WBp+2JeGNRjm4Hq3jq3uIR5sBg97SDfkW2zr7zzq5tg1oeFtsFGN8rjgSdUC2vlKiCNoHSUvJisbh+yXPsjUPnYJ9blQJ2FT2WYXlBAJJLaimEjRNWEDePj927KI2Ap8+Bh97LaBINVP/gaU2xMN2Otq3af96aSsW7APXIrJbDk0K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(36756003)(83380400001)(6512007)(107886003)(38100700002)(52116002)(26005)(66476007)(478600001)(38350700002)(86362001)(66946007)(5660300002)(66556008)(316002)(8676002)(2906002)(6506007)(1076003)(8936002)(16526019)(186003)(6486002)(4326008)(6666004)(2616005)(956004)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I9weJYfR8OKULZ3V/SS/5gdfFuQ1GsIiCDuo7DP6/QCW5kdqL8u0UPoW2J2f?=
 =?us-ascii?Q?k9C5XC6kjmr2l5+T8CFhIrEWBu3kx9Cwj6mRvJsVN6X9xJfYbNttY+rMF4ME?=
 =?us-ascii?Q?4dvwJaL8Bl0RxXNc5o2T9vS4ACmNCFiBdcsdT7zlQn55MqaMb3bEVXeNYVKA?=
 =?us-ascii?Q?yGIrBVFjJp/loKW53GVM7sbVIyeLxhN7Mt5SL9U6XFowCCQfsJr56blfiauZ?=
 =?us-ascii?Q?52wFg3dHOi+n4uwbL/CJVVfQy800ZOJ9ysF5B0E5aweTsbviDxXEjK9dMUWk?=
 =?us-ascii?Q?onLwnCFDuXFCrsA49Vp+M7JCqhz6Txp8VNBUgQ1w6YyF80gflI7EnLOkqLTW?=
 =?us-ascii?Q?Zq7kanFaR2updkS/3BsRYsfdNVV9PRTFiN5xYMBdS11wmcmzXDz6/8cea+A1?=
 =?us-ascii?Q?d1TV1h2F5Zen1NQ/dpD+ZHMC933eJXDoPQOb5StyJD9XqMSjmcYvCWR+etAQ?=
 =?us-ascii?Q?cKLJkReny7WreGtriX1+8H19b4Mm5vSoJZIT9z9AET9JIW1WumGDksZ9NDFK?=
 =?us-ascii?Q?X5kwUXuUdqE13UCjRVd3JAJAO/dYa8VRzHJKEdY4NvRyfRKyq2zMUX0H0VjR?=
 =?us-ascii?Q?24RZmkyjkYYPe8C2iiYQiW4+cN7131C2QzAHMbhZYcpJKhH16/44MMT/BRid?=
 =?us-ascii?Q?EjSKjDyJzWU1jXSzQHx6oHterKxDf6fDDm6WM+wI3MI0hlSfPo+DdyvNy2Mq?=
 =?us-ascii?Q?/R6/q3apSmyKHP8a73M6U76mBl6uESZewryV5F193JWFmwVdghv+CnkoZhAz?=
 =?us-ascii?Q?T3zky3myaH0RZGz0vDRT1T0iMO7Wv8I/OcpV2RLDPA9UAtgokIB3mmGG4mDr?=
 =?us-ascii?Q?XsT16vXEr2CZxGIXZF9G6vAI+rljbw5Mr1w+ZTcnwIHA6GF/2aGqjG/xcTfB?=
 =?us-ascii?Q?5Dt/aXIwPD/KClKsVbmkPYhjF377IYwuyGihL+4KBA8FfAjl2/+74N6ShFuH?=
 =?us-ascii?Q?dxvSbNfBrF/I5gMrTL7sKCfB9qjT4sJyL/SIAu4TOr8eFDIrWUDr6An6ndtn?=
 =?us-ascii?Q?B3Yq5C1H9ZdDuzpIi3PS7tWn5EHmCiXKu/0+kqW7ewFMrzh4FJRKfDOQgTXg?=
 =?us-ascii?Q?P3zhly5prx9tywp+2JBx0pRXgSbiaSi5qu940T0A4m9PhyFaWwqlydhosoGL?=
 =?us-ascii?Q?KHXBSMgSM6n4QN7NrLbpBIxC7Omb0eMc6p/X8/GESEvFl2VRL+/3cY71hAjw?=
 =?us-ascii?Q?Vk/3+1snUfFIhRqOb/EdrZ0mvanbhqG/v9p1UaHlopxQkRguWi3h9slYcFCw?=
 =?us-ascii?Q?VgYaZ5ClAhxy+3sO3v4Rm8ksMt0GLGovqvDGYckSR+2eA7KQObOLYku55fGD?=
 =?us-ascii?Q?wPvvytnmqVdP18jZ4LHuXQsx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc9693a-dcf4-43be-db6c-08d91fa533d0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 17:47:44.9955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXMq2OLxrya3K8wDsFpKS/ycRJT+tz1XSQQzDcSluMVCm13vs/ggfsZs5FBYzOz0LRJn6eDij3o4a0mcdNilTGACZO1J6M74enVFbOphe9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4720
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250109
X-Proofpoint-GUID: 4Mmkitthf099WLRV54IdXd-5z4EGgQaV
X-Proofpoint-ORIG-GUID: 4Mmkitthf099WLRV54IdXd-5z4EGgQaV
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The vhost work flush function was flushing the entire work queue, so
there is no need for the double vhost_work_dev_flush calls in
vhost_scsi_flush.

And we do not need to call vhost_poll_flush for each poller because
that call also ends up flushing the same work queue thread the
vhost_work_dev_flush call flushed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/scsi.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 051a7f8dadba..2f9633ef26aa 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1445,11 +1445,6 @@ static void vhost_scsi_handle_kick(struct vhost_work *work)
 	vhost_scsi_handle_vq(vs, vq);
 }
 
-static void vhost_scsi_flush_vq(struct vhost_scsi *vs, int index)
-{
-	vhost_poll_flush(&vs->vqs[index].vq.poll);
-}
-
 /* Callers must hold dev mutex */
 static void vhost_scsi_flush(struct vhost_scsi *vs)
 {
@@ -1468,9 +1463,6 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 		kref_put(&old_inflight[i]->kref, vhost_scsi_done_inflight);
 
 	/* Flush both the vhost poll and vhost work */
-	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
-		vhost_scsi_flush_vq(vs, i);
-	vhost_work_dev_flush(&vs->dev);
 	vhost_work_dev_flush(&vs->dev);
 
 	/* Wait for all reqs issued before the flush to be finished */
-- 
2.25.1

