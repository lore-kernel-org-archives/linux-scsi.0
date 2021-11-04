Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85129C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F00F61051
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhKDTIN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:13 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29866 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234238AbhKDTIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:08:00 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IWckf001571;
        Thu, 4 Nov 2021 19:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=tecX3TKZejVzr2ZrluTgNOxcyIPArSV9kd7wAux0mCU=;
 b=SEYby1ot+4QAQoULBn1CtRucGc/cUToQW4RdoAPhNtSXZ+El48qF7V5i6Gkyir7lX4le
 qOqjNVz5BM54hR58ruHSXMc3iUo6fsEFQfJZX9fWZS+qYC7voMB8rOwOJRD3dBl/eLTh
 v1BQHNzcuel+hL+Sqnaaebuhw/zjmBVkgTsvG5Xv3jvYhtnFBvrq6UsYmEIzk9D3JtDj
 OJ5GGy6iYVKr7u5WCObVL2F+NmctPkVbjOkhqxB36awZBi48Cw6j374a7eqvV4YwP06v
 tPfNW/vdRlhsoZ2bUyCU2/WBMXY9EyYVA+JL/jGzJRE9uLdm2hR8IEPSZilRKlaZKT6+ MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8p9u80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIi122897;
        Thu, 4 Nov 2021 19:05:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwuG9MaZxz2k7y8i76qfDRADGUyVH1/nlAqiOuUTNcV69NUEXYuHkHA3xCCI2xuadte4MS5IuvlAPY7BuEN4vt7bxlbY142Wh8K1Av4PgZfl6MOk4DamGPgSxenE7+pntJE/tcdmfzb1+x5oMB0GyLtxO7aZ4pDP1twc7ZG8dQhBMb1LIz78C7dpjpbFBs3hkVMq75KVYdHuHNrjiOvaAlkC4yZluaL43UbfViT/MJ6Hl5/mJmeVHX4d4YCCntQTLughpLC4KfcNHdtbcnwFPScQRAT3NizNgnrjbrHe2PW/5gTfztLGnRYjOvG56IGooj0/sZDRU4u1qtg1Mb2dMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tecX3TKZejVzr2ZrluTgNOxcyIPArSV9kd7wAux0mCU=;
 b=DOzsVharuUZBUDqgFEsNLD3R3Ga9o81eRzU30I2BuF1Oe7mySZNRUS74RUwFZbOEQ2oV1JcqduD3LZPqJ9kV9Pj1O8JGs1xm2CXquw808iNCdA40lLM721zzdWfQENl3QQzJ6Yso0rL+bs2B8QdBRHF5L7/+VICuSVmgTBzIobHphZCv3G+zf1AYbJaz9dJp9xkgM4/214eWy1SatlhHOBGirb6l+9JdVAXMgKtv93AWOz1/qGY0CocRZIasjayUq1D0m8mTuqS2hCs1Vkz33cJS6SBTbSgGU71Dz0LXw+AghpKhfxbdK/yWZYKwcL0F5bJNrv8cRfZhsGqeShQ8Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tecX3TKZejVzr2ZrluTgNOxcyIPArSV9kd7wAux0mCU=;
 b=hXTvr7cbpTMGWrG5iXohY0cIK7Wogp8lLaucaa7lZSssKXyUt22mcgZkR5fhP3W6ICy958F/wkJwRj6VOoQj8EEG61SKYh/Q087uu+ldSbgZkys1FC+6AbddkxvLb3A8H+iQn+bl4kVhzuDBMbsjNP0BWpQY3OwiuQw5BPGz9So=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 06/12] vhost-sock: convert to vq helpers
Date:   Thu,  4 Nov 2021 14:04:56 -0500
Message-Id: <20211104190502.7053-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64797a84-1f0c-4e56-ec57-08d99fc60769
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2873A96C1764C735FF69B69FF18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4cqOsbzO1ALbDzYK5f3IjR4N4jnqDmusVMza/eYO2zUVWKXep//HuzQB+ohx+Nxl8CCeOkmQjYaYe9InNGrDnfuIlSGZR++I4PPBQnry01FWmNpgWQHoF9B6Tk2uF5OvurY7W1ALm/zFAe8L9TDw+JAyjGD4TFKnWMKyMxohGqroqCE1UIuy41FOZDAWFoYnM69KX2+aE1sjTLuWhLkMpWYqI/dtYvhL450iaLA91TvkQ2iy5/EFqJFH9RKH57JpcJUxq7buDIHJX8k4a3ngwL3SHlz8kF9DhhM/V+lPJoXS30sfvgkkLp5cV+ROILdJLN2H2N3BDwWk10UG5jtAq4Z4kzoDZGwgS0FltYiOpy35IbA6OSj5BQS3FuZ7Ca1VaKyHijntezHTxOCYPSk9Y7wGjBJDB6QzPxCnv8b91zI6zruwlVnk6GzehJLrAZkkDwBrF9N2RoFwECvPcgXIol78UArvKh5i/WuiLKn7HsUE/eNbhp7DhNL8YzX/swG/30HXuM0NPyQkZvFnYolromdBdXIzaFiJAl+tolmCYjt7+29yvaGV7GtkIps+ajOdJdPvvT6cZ9Qro016MWB9bXpaE6FhnwCi+0tvPo5Zle5TXrv2jfrywDw/KvXUDM+B9mQoDkSa6j+bjTArHeT+pgvX8xeZ80jld2m1JzHb8zyHomdKgmVR/XbBLdzBiDlv9J3TazJTDnV7CDUVunRykA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j8u5b7nWV+hlmA2fl6s9dQiybNbXWRQrDdD2OSD2Qnkj7ofaMdzinr0M7JeD?=
 =?us-ascii?Q?ElzpX0MHPv/V9iK3mzu4jZRjOYB6Dtz1/yMeLN0F3h3ztZOld5wmE7M5wrVm?=
 =?us-ascii?Q?S7PIk73heIhNvupDVflxR7oFQ2WWqE/tZJQCgxDc7TH5yU14KcvtcY3zgPM5?=
 =?us-ascii?Q?Ned46/6hTzYFrCpK53Gsw9Q081A3kyMhuuhfmeh6e9BDEK80p9H2q9OmpcOJ?=
 =?us-ascii?Q?c9lmCVkBfbtBuImwrwsoAtr66x9Pzh3r2m1mcD1hodvgJkWEC7YKTCfsZczp?=
 =?us-ascii?Q?RaZjs6+1W3N1Ijnioi+3t+Yz3t3J4ZdDl7vFr0n4Opo2ARBUDXi4QOzf+6sE?=
 =?us-ascii?Q?ZKYgveR2lK92vRQjaym/PBNOGZCMZeb+kGxy5n6TAH73E/PdKJZN0E0SQs1+?=
 =?us-ascii?Q?zYGuzpSn1z/kEaMWughlvsMvcXBU7GBvpFrLRDWRmCH255sNe/oiCfrOEh8x?=
 =?us-ascii?Q?YMpnZso1tDWo25I8YckZvptNMhG2uSbBm5Petkm82HwOZRYQ5o7ZcW0ihp5j?=
 =?us-ascii?Q?RtYIY32B7UoLJaJcyCrbUVyxEqRWDrcCXMH78DZ6TcV99yVgAcBY0v/EUhEJ?=
 =?us-ascii?Q?NuCj//GSwCo7QiVFakoAY8Vzm1hbusrn5Vwh749Ktv8zO/g29DEc2RqJ9PjI?=
 =?us-ascii?Q?PS9XXv3Vn3XlRibFusn6mw2wTExgqntAFqDSZjC38bqrF567XytJmAZdvtb1?=
 =?us-ascii?Q?nO5YW7CFaWLVx04s99OczGHqh9EG3sl0zid9DbrPQsnAQUov4jxcDwETZh0p?=
 =?us-ascii?Q?KJ8nW18ulA7DANQQhI9Cu1mqFgONspMaCgfHvBiOooTNpMlMEoW3Y2OAsb+w?=
 =?us-ascii?Q?mR55rbywcOM8nSm4WEEoTKjOAvC3ghjfWWNz4flHCUfmvUIguyEts1qLldux?=
 =?us-ascii?Q?tOwQTj8TGYj9xmmAD+NhmmFBsCk9A6nT2Q0RT9V5g8NLKY1kZ6JRyC2D91oa?=
 =?us-ascii?Q?kmuepalBc70kTiHMee5L1IDDjZhKqOLUkDmO6AJjT4QXjAUKj0LAYsr+EPVy?=
 =?us-ascii?Q?bmZGTcF6oy4oFGTL/WZKKm7Z42wwg4DT8JVe+41nA40Nf8mnz//KCoqI+dz7?=
 =?us-ascii?Q?ggyi64UBkWbSbLK+m+IIEW74/v9Ha2Bj5VzVwg8MNemV9SRXhueRcxCnRXiR?=
 =?us-ascii?Q?FImyNWHFTxbmluASAiDUt+ngvYgVJ6DsVh77hFI1EIBNv3ddBSH5x0lpVViz?=
 =?us-ascii?Q?unaEJW7raNfKXai+M8qRxHctq/9OD8LigA1kr2lnsSTFrO1LG8z3F/+lSqlZ?=
 =?us-ascii?Q?uHSbubgmmklDfPbNcivjuXHmS/Xs98kV/RPBHQILsl136SGKIL4ndBdPNXFk?=
 =?us-ascii?Q?5QQLDcnr2kr62PxfWKwb6l1/e//WMzN6ijZmxlXWcbZOchdNNXOgOaVFXo7p?=
 =?us-ascii?Q?I/d3qireSvbduQ34afIelOaH7YKh7FsDfH8/ifWHKts50JRQFffaZ9GDPIXK?=
 =?us-ascii?Q?akMN1Zx4tlRvG4lcsicbHdGQgk0S+2LiDQQrkKjtajGl8orMbMrqGrvHnppR?=
 =?us-ascii?Q?UAUgBfI3oZlGv+ZITbG3U9ObpDAXuRDixOVPVO8owlY6tG8o5sRv4taCRnF7?=
 =?us-ascii?Q?QOaroLRLHYM01HXjiUN3vIDAFgLUq1pG7c/e0dcEpkwtriEEd0VqDr7qYwrD?=
 =?us-ascii?Q?S1717zD8fXDHpqkzgm0DX/XfNDw+ZPrWk3PepRnYn8sJILNQWEAIaobZNfCR?=
 =?us-ascii?Q?FIj7fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64797a84-1f0c-4e56-ec57-08d99fc60769
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:12.8818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5mYxXIkjnExPNUajTSQo4vggiDQRquyzO57cLT9JMR4n5/OAblhAPVR2a+OF+puB7XEu6JfxhTK3xTv7I/+SAM6vx16e0KEvTLqV0lUm2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: e8UrUeOu-oKJ1tkjJRY99aSR_t2tNzOX
X-Proofpoint-GUID: e8UrUeOu-oKJ1tkjJRY99aSR_t2tNzOX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert from vhost dev based helpers to vq ones.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vsock.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 938aefbc75ec..0c9681e120de 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -300,7 +300,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 	list_add_tail(&pkt->list, &vsock->send_pkt_list);
 	spin_unlock_bh(&vsock->send_pkt_list_lock);
 
-	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
+	vhost_vq_work_queue(&vsock->vqs[VSOCK_VQ_RX], &vsock->send_pkt_work);
 
 	rcu_read_unlock();
 	return len;
@@ -612,7 +612,7 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
 	/* Some packets may have been queued before the device was started,
 	 * let's kick the send worker to send them.
 	 */
-	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
+	vhost_vq_work_queue(&vsock->vqs[VSOCK_VQ_RX], &vsock->send_pkt_work);
 
 	mutex_unlock(&vsock->dev.mutex);
 	return 0;
@@ -712,7 +712,9 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
 		if (vsock->vqs[i].handle_kick)
 			vhost_poll_flush(&vsock->vqs[i].poll);
-	vhost_work_dev_flush(&vsock->dev);
+
+	vhost_vq_work_flush(&vsock->vqs[VSOCK_VQ_TX]);
+	vhost_vq_work_flush(&vsock->vqs[VSOCK_VQ_RX]);
 }
 
 static void vhost_vsock_reset_orphans(struct sock *sk)
-- 
2.25.1

