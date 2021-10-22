Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854BDC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B89661215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhJVFXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:23:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41322 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231144AbhJVFVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:52 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M3wkIm006091;
        Fri, 22 Oct 2021 05:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=VpZb7x7YWa+u43wu7GzcKVXpo2dcp8z0pkMKIqOYlp0=;
 b=a4F9My+tpnoCSusb3GURXlf48wH97RJTy5LDdk38uuhyxdXGidbYcUO5XjL4P/1ak/qZ
 BFpTsqeFes6nhqe3H4f6z3zZWmefVa0k0hwjeOJpmFjecjvYhbCOp5O2efZF2K1t2DL6
 l6XKk31IXF35FlkrFoXA1zufCvLxJXYBPn+cihGk4HtZeCADgGaL1+WyGqC55LpO51vb
 61JEI07TS1uPjISOMGRJ4gcPMapDuNeKWHJPnzyhIoDH65rhVWVv0V1Rb6hp0+ty1rbp
 wgy2bD+7obnm9BGW5J2z+kPEzcxRb5fQCFzyXwlFYLLG1QSA62ztKvE8tFnCUBXwxaqM MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bunvd072p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIi139141;
        Fri, 22 Oct 2021 05:19:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBzuOFcDz7I267DrtIcRKaaIWP5a7BtjkXY6RaIDJ1B4qHba3o4LZC84Y2Lk9Yq6GQQ/wWEwCCwO+jaYUQ90W3QnKQ+DLyHpau3yDbtoQzxtes4HkXrtxgF/yLv2GKOETH/PInaGgqK3IjoP6bCccK5rnkoOatugIjFPi/KTP949tKGh0g7XzkFOcWMGQFOPMkpflrVqqhS2E8lzIHyw1iB6R2HT3Z/jO1T5dVi/Eg975kfLR6uMMLpB5ayXJtwh4c/febUihtRXYs0a2WDwUjYn6ouLnrFdFITfGjtJOgyrv1xjZbgtII3d3z5Sf12Vtn7W2Y5QFZ2NRpsMr85zcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VpZb7x7YWa+u43wu7GzcKVXpo2dcp8z0pkMKIqOYlp0=;
 b=MCez3NktL/o961D8bgXSZ3xf3gtLrH9GmlJvhZp8SS3+16JGmWkB5fmyHvXc3n+T1ZqP2+lQ36LFl6JiiRJIeKQttaRZSJkMKi8GJ/9fkBtOmZdSkRdPHV6nWP8aCcuE96mtUZ0Dzy+uBaqYh0FJHOaT8qH7+P2Bu1sGjt5wRdtCVeYc3ZHGtrYXzoMU2DYlzdU1GVnj8quF/lGZqq8TDvLuukcUqMkgxu9skiQmqSHYQ4h4jBhiTflZC9lhvVtaZ+TJ6sWCjImOdSJtCnyrhs3COwjRgUSK5RKrGK7t14W7AOLFYEx3NtG/KcHtdoj9g2GnQtooRpfhtig89QgHAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpZb7x7YWa+u43wu7GzcKVXpo2dcp8z0pkMKIqOYlp0=;
 b=zX57mR3q4dnNPqfJRdugjnnPVyPWFxOOZW4l6Mblak7DPo9V5QBK0FYwA47XdXAgiSCfsFDk4PWzdx+oSJrvRlyjfkVSc7rF7wa6hJ/fo/SQxuMC7mW1e+u14OSfUSeAWMHHxXqPKf9GjO1Ol7hibRQQ/T5q9laypZs/9ibMlCs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 09/11] vhost-scsi: flush IO vqs then send TMF rsp
Date:   Fri, 22 Oct 2021 00:19:09 -0500
Message-Id: <20211022051911.108383-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 204f2eeb-8a53-46ed-4cb7-08d9951b85f1
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4974876AB2130C1F8840AECEF1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWeXkLBT6fV1MWjnpoxFHlnwKe3LeeRYRk8PgVM8iloLlvBVUHMqDeeOD6cFbjnB9bCWwKhJTrmdGtY2RxDHUe0u22YK8GHEJ+UlHCln4V6HF8fFo0uyJ/VLb/XQGd+RbUg+uJtIH5XXQLcXmCY/Au+PNtDL7CIpqRRxqsf+sTBJySv/yleZfOahWhdTZkXVKz8UXMKKiXozQhXCy0wmFh/yEe0sMDGSnkGQhyBH3t2BKBipuvI/3ohCc+qGlj9MtNjIoKxRls1Nm6ONuWrAaHC9p8GVEt7X0hc5POh3BdjwoxRYbMaGrOdlu6kYUuUaDYqMMoByaOQFNiFb6x4sNw4lC4e82CXBd0cVrTLbuMmgZExDOSvcdpA4Y3NzNT782Rh99lI8OxfMvCmDxL/2447wvfa+QLDkq6PCyxvKxcGqEBPKBy5MX+Jepy2BNnUEbTSNF5tVGYdk4MQBoEyQi4QTE27zfEUA/s4ollMjSAncI1GX+6xeqROZthp9WcKsWOWow2ACLuoOLaN9k5KaliY6luvBhAX1+GBTjC/qehpkSK+jC1BFx+Hu+H6HFyA9yOakeD9OhECSRLqVet7t+0w35UVnzhm/v1VK4IHESzXgyLTo6lYurdnGzi8Z2F6/9NwWEIdy+i/IUusiRwONrqFVlR9qRZrK1kdQaKipiScBbDcl80MBPFfwn63BrLpl3mUtsMKRJErUHqQYukL3Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vEUyhtYTeyZPls1meduPsnHce/O2OYM8uAN2Mo2sqPJpIjR0AtJa7MNSJ3Ks?=
 =?us-ascii?Q?503i3ueTow1V2P6KWKc8KMNFPlAkMIwZYFhmQRo6uj6pse1AZ384m4Hl8Y3s?=
 =?us-ascii?Q?E6FjFrNjk0FGJyLzRY3Nj21zVs3ehlvCzFmDVDLktXch3hRnLiPDDBDdOvx+?=
 =?us-ascii?Q?mTvbprQeABap8qeh+gBkX+nFfaPIbaB5OrkB/KTSx48EJgog2Z+DLRA7pMZV?=
 =?us-ascii?Q?n918P1VLo32LukT+5ayWgZNGASsF/2zuvkqZPQ+GfBpZJU1Qzqz7Di561tTO?=
 =?us-ascii?Q?qnsQ98fTf31fJrAi7lGUhxxIMesXKBfXzjI1BOjdfTsbfStMUm21xUkNe7FF?=
 =?us-ascii?Q?XZ6B682d5jsBxWvHmciU5V/E1/3l5/GeueL4ZF0X3ep0T3HSf7f6htZQmfgr?=
 =?us-ascii?Q?cUEBuOZzfAzXj+EByZiv2ALGVq5eCMnDkbZHWZjW2xWKyrbm7N5h9mia5iSZ?=
 =?us-ascii?Q?KvaVigcibLtS1nzA65RcECiMccvu+/JWvtZAq95rrQI8e+bU7148tW2vXaGs?=
 =?us-ascii?Q?ZrxJ+eu3Q5CoyRmzqlAdbk/JBrowdNsc7+4qD1oA60RQuhjvYVq8TJ0DOL9E?=
 =?us-ascii?Q?pWniFaFskuC8c3YV4oLdhFs6uVknX6XcF+wh63/4oHFkAy2mY8XfGdZBSYqA?=
 =?us-ascii?Q?adYhOKkmV2XbogtdK/iyeGE7yE1+MN32MZQieNcNc9R6cfLDqVsdMe0mDEep?=
 =?us-ascii?Q?1g7YcrXeo40K5P/ByW7Iye3mq4c37SFuXAM4kPpUq08fsSAgjbP73Z4GpaCL?=
 =?us-ascii?Q?kqRr5iCU/WFIIdRrOXFWg4a3LPGDeNDp9CRBZqVk4O3IIMrvUo5i6OFQwmKA?=
 =?us-ascii?Q?FmAm2yU6LoI0QA6QFbUCr7ThdhJnu6V/s9pBiztPCrxJKeAM9JZn0s2L8Nt+?=
 =?us-ascii?Q?f9LEtpuvB4tnMV852u5+bBYbgbNYKkhUrNp3mofSjNMk7YTn1Ind8tkrwlUl?=
 =?us-ascii?Q?anSbR2XYHY9PfHuOmQ31GHuB/9nNZuKWc5yGClcezSylsTROa5jLf3o++13W?=
 =?us-ascii?Q?F5ryXKf8By4JgDCiHCkJ/WhYDFlHzJcAHXR+AZ9OtIKyKqBtTIioYy0tSNcQ?=
 =?us-ascii?Q?mKw4z0XHXKY+/kkc2u4E68Rj147dCl84tmNmsPudCHQ6PF4bGpxdgbalREpQ?=
 =?us-ascii?Q?l0vnCdw1yJJA/8MyIb95mrP5uVzYw/L4QwIH/Z8oUgpU4BecQONJMKSy8QOJ?=
 =?us-ascii?Q?CWnhSUv1IPBr7muizrtVwD8kUmA5yYFG2A1NRgma4GUt0k/TdqZBKrRgN74z?=
 =?us-ascii?Q?lO+0QTuCvNPBH5SKYhmJ1n2Z1jjAr2I1zkKnZ+b550qtqDkNtD42LpQJT4kK?=
 =?us-ascii?Q?uEvVqtg+jmud5qEJlWVmt9NX46+lK40fyQ94kQZrexmiaaHd86nImQnht5sA?=
 =?us-ascii?Q?GtWYQ1nWnoRoE8+oDhLeiaTUiDHQXDbWVzf4JKodyCUBqzB00sfuDK/HLNGk?=
 =?us-ascii?Q?4aazTe4VxU5w3vuS2cK9Ix2CJzCle4Qo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204f2eeb-8a53-46ed-4cb7-08d9951b85f1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:29.5444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4974
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220028
X-Proofpoint-ORIG-GUID: psLVTeUoHjIzHO3xnunRHWblSXx8CaoI
X-Proofpoint-GUID: psLVTeUoHjIzHO3xnunRHWblSXx8CaoI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With one worker we will always send the scsi cmd responses then send the
TMF rsp, because LIO will always complete the scsi cmds first then call
into us to send the TMF response.

With multiple workers, one of the IO vq threads could be run after the
TMF is queued, so this has us flush all the IO vqs before sending the TMF
response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 08beba73ada4..29d9adcdb4fc 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1153,12 +1153,28 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 {
 	struct vhost_scsi_tmf *tmf = container_of(work, struct vhost_scsi_tmf,
 						  vwork);
-	int resp_code;
+	struct vhost_virtqueue *ctl_vq, *vq;
+	int resp_code, i;
+
+	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE) {
+		/*
+		 * Flush IO vqs that don't share a worker with the ctl to make
+		 * sure they have sent their responses before us.
+		 */
+		ctl_vq = &tmf->vhost->vqs[VHOST_SCSI_VQ_CTL].vq;
+		for (i = VHOST_SCSI_VQ_IO; i < tmf->vhost->dev.nvqs; i++) {
+			vq = &tmf->vhost->vqs[i].vq;
+
+			if (vhost_vq_is_setup(vq) &&
+			    vq->worker != ctl_vq->worker) {
+				vhost_vq_work_flush(vq);
+			}
+		}
 
-	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE)
 		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
-	else
+	} else {
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+	}
 
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
-- 
2.25.1

