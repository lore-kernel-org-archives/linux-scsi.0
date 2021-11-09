Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC51C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 11:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B576D611BF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 11:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhKILzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 06:55:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20600 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234597AbhKILzY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 06:55:24 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9A07B7017419;
        Tue, 9 Nov 2021 11:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=mtBpW9qMc8pf1ci5/11SR08qGm4E4Rl5cNRbqtTH0ds=;
 b=VwtWjrHhungu5H/Wt1RuoQFwWIviFdZpmy/bXnSguXi3ebDzCceqwbIavL8hkcMfo3/T
 l0Xqx38/oe/lH33IU/N4o+yudnQDmNN9U8foskCOxvDXdg4tsaAm0ADdcs/WL7GliIgy
 kCa+tbojZNfAjcSXX3hwM7JK5sveeKWeDk+S1oEsnjjZXfOA3+C/0gv+58YT7bTPYIcp
 GH3w+gb/4XZP9g3wdAgchO3obmhDgYrdq0u1WbaEhL0bavR5tNqoZml0SsZwOJr9Tkps
 Qx4sSe3PMMz5XUO0rkD4DLBQbZ4XD07IB9CYZBrOdqej3L80BLEffRVlqY5s3Rk+dtHD sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6sbk9y4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 11:52:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A9Bq0Ke051605;
        Tue, 9 Nov 2021 11:52:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3c5frdtq08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 11:52:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSY8BX/n9s6P6P5iCXLavGCp+Z64nTx4r36Shs55EQsBAfVFyuVUT/j6RdFKJmhXDKthps577fdd7jfeg/3CQdRT3EWOYyR3jKNBJJcF4h8pPbKIjYsTGLkKKT0um4mLJ0L/SWQeCXakgVQduDd3OHA4xo4ZzSDAyO1s0LHI6Wbm7rMWfKgaKOeQnzozI3bnN9B0Ve8O5iIn0Nk9WHQvvkGlMtboTvy0WUs1vA68jUk1B/9y/ToO0m9+b3XumLdTfKq3xfJSxRqAb1x90tDE7OgUSfAgy9Od+qeAdf/kX6gT9OOhmxn44DvNle1FE8qcmRs4ijxsNCz7QHa/UU54Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtBpW9qMc8pf1ci5/11SR08qGm4E4Rl5cNRbqtTH0ds=;
 b=Bh6BigVb3H7kKAAAJLyN6SLgCaO3XMK3GivvkS6HiI6srYrVbDQZJZ5MdFlZX8BOF/C7WXkgpiVTMM+v0IbbZPLcElcc+07H+IVJ8C6VZD3bIdVa57m01uEtGV5XBB0/Nlbx3Dusyr0kYFdLzhrZh010+GYRVDGHBUQJpCA3ocDDGW3s6Is4o0pVMRhFQkTk89f30t2NG3JvVRYrspvnnsaYAjZsF6fCe5ut6jasfjpe0RcmjAuQWDESfI5fVY+9H4Swo8/DY+hU6T366VOsei3IOvWLMjQp5x9yD7niFTMDboVSjz5YzTxypMqOBBsKvsyrLCGPEWIedtj3fwKX5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtBpW9qMc8pf1ci5/11SR08qGm4E4Rl5cNRbqtTH0ds=;
 b=dcpPXkdSCjIoa+IDu/c4fkxYXXuCq0bmFykV4Jv69Lvhm2dG6AsvVOQNl8cb65tiIkiGciuk4H+YRrpplDjHC08DjEu97kFbkgU5i0rhKR3gxixCOHz/GvEBroPfiBwJ+J95/BUk6NfLBBYlyJP3Ic7x89/WJTsn6n6hDAlIu7A=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4500.namprd10.prod.outlook.com
 (2603:10b6:303:98::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 11:52:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.015; Tue, 9 Nov 2021
 11:52:33 +0000
Date:   Tue, 9 Nov 2021 14:52:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: edif: fix off by one bug in
 qla_edif_app_getfcinfo()
Message-ID: <20211109115219.GE16587@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0081.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0081.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Tue, 9 Nov 2021 11:52:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 132e2ca4-79de-4e0a-c00d-08d9a3776a8e
X-MS-TrafficTypeDiagnostic: CO1PR10MB4500:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4500F6B826A2D07B9C5EC17C8E929@CO1PR10MB4500.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+xIpuE2/O0pgVzWw9Ro8x6f9E3kr1cq2tB/FJxsbbdnxzrZKaL3VdlQDm3LqNAOrZ4HdQn/e6FqyGxzZq2jd+RPVj1iHj0Mge2mfW1buglQKiQSfklsYvduYY+eIQQsQzDXRpfidG5IYi+ubtYSS/LJh7widTo3bESHsfP6WBg9h90tfaNK7QpWozpHSrUzXv2Y8U3fRWbvUce+1x/IbLwYoPcXRlmXSkUYjMotFXre6cEuEANBLp+lX1Ndfcj8yd0WRWWF+Ty3FGfwHgexmxnljGvG3zwVv4R+vwv6rR+KwRZg+iib/AM1bc6/hdioIr+uw9r9ZY6Aa6BYj60ueRuQqXWgTBrJ5eqWbvUFgwsLwkrtiu4luNj/85iwOlPR4eCYXe+yous/XwGFu6NXWnrYOvaAFFv3igVO8Cv9RuLPlwlbwDJvFMfxgw54lF6QxXPolgGnWmdOHH2gu0SaQoLMNvHxF4+me552S4Zif8p3rUejipccYoo7LqG1D6171JqGaMtFlIRRh6YHE8xuiGBZq5e8PJbyZ6pbz/ezUV/VDMQLuyBDsai94T3/SCQKGskY+xXBugHdKcdWOmR2xaHFgCkleVxsXsSWtU3WvGofzHbAtMlE9h/mUxi6WcSEcKhtSZYMkzdLoj4qnQih244FtXllzFMFEzLGzsIibzaocSj7NCVuhvOHcJOJiON65ZrgPTWZrlbX5nMNSJcpKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(52116002)(9576002)(4744005)(186003)(508600001)(316002)(38350700002)(38100700002)(8676002)(33656002)(83380400001)(6496006)(8936002)(26005)(55016002)(110136005)(33716001)(66556008)(54906003)(66946007)(956004)(66476007)(9686003)(6666004)(44832011)(1076003)(2906002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ea9J5XgsLoEQBDrSi+yAlnGy1L3TrqZKXVlA9NonXb0Zp8DmqS5SAwQUA5Ea?=
 =?us-ascii?Q?8mMPfaoDAKoY6/CaKLav4RQgMAiY4EFCBkzV5sVmyhsafAbAG3mNWCz6q1Wq?=
 =?us-ascii?Q?V/ouXfPtwqJGsdjBQAF/NXFaxpCq3JbudJjd8w1YXSI5MKShx4j7uLjojKYf?=
 =?us-ascii?Q?NVYXjQX2pkNvTr4eNvcmcOfRdlr2PVg9vMQ7FYAsoEjGqZHZoApVjXu0svJY?=
 =?us-ascii?Q?1MtuHvIbT5HZkunQoQJDjgDBnFYQEmAPy18kz6fzUTYoTXz0hdxnUPmxCsDm?=
 =?us-ascii?Q?V0NgNXhOg6xdsWbUaFIux8A0FrwoJ19LRdbzj82QTm0b9fsHDsj30uRmxNS6?=
 =?us-ascii?Q?6VDGCdOlS8cbIEvPl0+QDcMF9MaO/Vf8n0mqpE3wT6Jf+Mp0GNHWg0gI0Pns?=
 =?us-ascii?Q?LXKtnLcBnh0esCmqnxCHvfGSR4VEBYpbsLMVts/FR6wSEgfme+oK12gytC3I?=
 =?us-ascii?Q?oEuFWWYQyiUVsrJodq/xQfjzDUtTRbEwpOfZ3hjEzL9cVnXWfZNjNLLt4Vu7?=
 =?us-ascii?Q?zrP8yKUj/ndgG2ajcqVWrl5wyjYOGsEOayknb5SqyWrKDDotsuXkEGQvTghX?=
 =?us-ascii?Q?iyLLnPmOu1oMqZwMeUxvxTKgjdaybzT7DnWx1+OaLLOyZop4rOi8z7OBFVhs?=
 =?us-ascii?Q?hFBNnI61AaiFviULiNsEgGk+8CSqicupvIip/TrHKrHQo3x2LveRaQ6sF7z2?=
 =?us-ascii?Q?cE3Vo2RaGRf6zEB0u4N3VFrNULYQGTFE464S+j3qzu6JODDYxv2DhU6ZiUsz?=
 =?us-ascii?Q?MiLPWtpPnXFz8Qj+q77YA+lsQ0eJu/Rq6yfN9LYxeTLDnQrWrbz/gr1QsPLo?=
 =?us-ascii?Q?uOmnA+28h4wVk3/Hrc7inr7ABk+SUXwnFistZcdrh+qRNJ8vNM/HSpkt+/3P?=
 =?us-ascii?Q?4N4AWDm4Fe6UTO+ek3LfVi5X1mZl6jKmjsrZz6L4FMAUj1/hQVSgwiqFu4hh?=
 =?us-ascii?Q?BFfveNcffupUY9ekoBxUl5yFje0+xQrOo9OTs0zjMtrmj7WzogSHo1lgNyyV?=
 =?us-ascii?Q?EmSC4A7QQ5vgHze1kgCa/J+8pQV/pTnm5WohiIvx71K/QXCm3T/bnwG9L8FU?=
 =?us-ascii?Q?mxTKhLEnU/sujYNmEL4EOlwLf9lKWbhFxHpUorbZcIipXQM5YOgvy0pQSmMG?=
 =?us-ascii?Q?HuEBG8fW0fRDcw4e/uXx7X16NYdzw3+OfHRRiiwzS51oxYkW8QCQe73CXx+m?=
 =?us-ascii?Q?WHiDDVh/q3bwsWkqDd5PKF60sDnr3BPYRG9gIScsMKOpMTM+ozaHQztC8rtI?=
 =?us-ascii?Q?1qZGarkNT0qEFfMBTpuLFgAs5Jw9nY4956N6nrIkbKHgnKH4i89T33Z4aqyY?=
 =?us-ascii?Q?kOfSPytSxtb5pl1kes+R2FEdDKpxKUymTLNkcOLn34bVlRt+3UVpU6xKQNJZ?=
 =?us-ascii?Q?6Bl7Xx91pnyBaAc4mHnp4FJMhOE7+8g50egAEL37rm/oPjyRrADbR15S0qFs?=
 =?us-ascii?Q?dmoSFMu7ej/jPfuH05t+hxgf6pK4c2xYge6Yyan6LYAYVcqZO/vRhSP7uEPo?=
 =?us-ascii?Q?m0bArVIqjGIPpYE8iycn+BOzbQT2c/7OQFprAH57BLiaJUEcf/dzTkQFjloU?=
 =?us-ascii?Q?mcO8IsS7517rRotjPRhElOfcx8AP6nMmoXTSTSHjWyJ+L5+Sezf1BbYJuiCf?=
 =?us-ascii?Q?f00qSHe/6G1Y+OcA5EYz+dLlBU4Cg02JSwIosIlxDe458UTVZ7fJZc7W92u1?=
 =?us-ascii?Q?07rpxZ5STrr9sqloDpzv/wbFiug=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132e2ca4-79de-4e0a-c00d-08d9a3776a8e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 11:52:33.7979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kt609JERUkQQ8tJ5Ffx668tykNra/LBWNR1lCa6Vvn3GtmAC5y3qiClKH3UhoyPMSWmN1t2qO9W0C9nvzPjRUP1WsRA7O7wKVfQdu7Om7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4500
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090072
X-Proofpoint-GUID: 6gzOUAskfxiiNUTe3heStq1WWgEir5hf
X-Proofpoint-ORIG-GUID: 6gzOUAskfxiiNUTe3heStq1WWgEir5hf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The > comparison needs to be >= to prevent accessing one element beyond
the end of the app_reply->ports[] array.

Fixes: 7878f22a2e03 ("scsi: qla2xxx: edif: Add getfcinfo and statistic bsgs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 2e37b189cb75..53d2b8562027 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -865,7 +865,7 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			    "APP request entry - portid=%06x.\n", tdid.b24);
 
 			/* Ran out of space */
-			if (pcnt > app_req.num_ports)
+			if (pcnt >= app_req.num_ports)
 				break;
 
 			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
-- 
2.20.1

