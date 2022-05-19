Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B85DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiESAgP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbiESAfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:35:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FFAB0423
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIpmn027442;
        Thu, 19 May 2022 00:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=K10sKvF1Z2pT+NmvyTDNczHpstHlMiLonlmnWg0odeU=;
 b=OV1OBp2F/FOpjjm/dyw1CpUANjwu419pWXmhq1p3TZOO6tzJb+hmwScLdniAoTKlWtW7
 ueGtJEP3fiNgr3/J5bNlCzPRjHob0yZrjusEnTQx6Edqyhjzqwg5s2Qd0afjz5T/Romq
 R0z9W3IHLka60nkiQVDZIvMIKLyOe/8e/GdExlqvXLHVA6OAvDRVBfwcvbQ/pSdfcavW
 rxC2g9XBPTT8kMeuJkbS6AfRQ8nrGn20ewkxz5jEFBSS36y0tI8z4c7YENuiJ6RzL88b
 ejhu8gGWQOEQU3dQWuJy/UMrmueYRs7+Bhh63rZUt38Ec9pKFiZBPkB2x7Q+BlKO/KB4 lA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sautg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VE015306;
        Thu, 19 May 2022 00:35:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZ/33HznaSZD2/VJPsw+LAMn/a5/TdXE7bozugwtWYXJ4mJw/5vwh3zwrRmG+ZSz+v+a2mYDMcvjjTEUHAKvqLGC6gQUMYSmLuTpbrg6BWKJeMYqNikl4A+9iyxAPB6dL4Ze03gScn2ucJhNKR98oDQImO8VPnkJEIdmqLE25GK35SiIRFQga1/PEcSPZ4UuZ34vsU3LSJNmkiOnZC7BLvDZbVeoqgTVzBvp6UVTTH9G45R7tjaQ6lvXzxyrIe3+3AGWErFhBCrJUuPBk0MMfwbRTb/+gKJndu89lbKtH9IHW8yZPa8c2T+9iEqzsZI/n0q7dy97Zib8TbC9YfyLWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K10sKvF1Z2pT+NmvyTDNczHpstHlMiLonlmnWg0odeU=;
 b=lXxR7euOdXlBiYN74AXuYHXVGVcCbF8Xkk9iMHgKtcPmts1aEPlv/uJW5G/wsMc6VJLjsoYaGwzsd/2ZnqZGcfgBFQCkuvP1UmXTSUlMBPWhZVr59SFLJevFb4HjJH8XJaan0JIovs545v/en2TB61i0NhQwN39S8P6EDYXI3fng5LZWUyoSIUnsOdDS85MSkwKaxRNe7lmIr0mSzytsKroAyo0OKE07szr250fcVYXp3Mq1dS3d3vMj2mZ7po0PFVZP6ZYy5ddPtiQnQFYNkkSxTnxycfPIEljW62iCfMpVZr7zripOFEpnsG0h0p75rLcsu+p5xO3Dd79eQf9uZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K10sKvF1Z2pT+NmvyTDNczHpstHlMiLonlmnWg0odeU=;
 b=IE2t3hJqbJ4dFTJGL9EkgxJiADtsvBRyNLH72kWgNFrpn7TgR5JKSJoPY7H2Ld0XfGmPvS8LhPaiHlZJ7r829Sk5Cn/yVWM1YkGdUxHxXSSLzjFMpCQXNB+I3ecL0vQbOknTwSIonRt+TZ0ZG/Pr7EwXG2ct2GRrNSPjKh3W6Hk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 08/13] scsi: iscsi_tcp: Tell net when there's more data
Date:   Wed, 18 May 2022 19:35:13 -0500
Message-Id: <20220519003518.34187-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94085280-89d0-43df-1e8f-08da392f79a6
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3020AD08D5B9B71EAA17DCF8F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zfOL/rq88PcG+kV+HB7gj1BhRpS++T0CuQBY3djXZCodVsEChhts6KfrW+NXULu+VGxjH4nFmc8OlqLMzWaDvk0y2XOQqYZluaRpxh98PUK2sHO8X5PdxJYw3V+P/Y0VU7neMzlj3adIe9dZU7upuvunKYUzYnaoeE9EHqfLcON5w/lfKj9hEgm7acs85wazINpvkcj6tMArFNniqQ78ryYVk8l3VHns6FuUsquGoTtO0Yyn3VulI2G76j9HbCc7zYHPG0y0ZX134bLjZLvXM4QAic3/6uy1MPqFFA1hTq+grSexPJfdi7y0fIkm/sChjQIKl3ZSdMTdPKQO9jFaAeaZmXifZtLGeuvywxHR3VDlRCvX3WtOIkfB34p2sjq81LgarOgDgxtGwQAATyxa49mUiI0UntFINQ6mWr+7xas9F0COtZmkLjukM5GG97Akxc+iJLjnzmCOoBXBhUQymf2IIJkgaZzKlN+fu4BYXMWr9khLRHd3CmAkXi5jU6baBagZ+V+GW/k1yK++ZX07ydTBRIRz49mt8N6XeuTkhebEB1urCfDK5pOJhQLBYvBFPj2RnudM1juYjLltpV4UjKxtqsyhBPXePCMLBTk0BxiqoSqMhxkGYtg3h/5iviEB+nBCuG04EwLDaTdH+0SbxZdAquDdEbCIQzBSiB77uK/Zh3YA7ZpX8CH/Na1Nnq30RNhNF2lLRKBnM/h6gOwA1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(4744005)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kxjEYldn9rw30XLXSMyljb5sYZeuOGDM0uUKzYnglkksZsdLvA+cvf468z67?=
 =?us-ascii?Q?P2BdpJs/aMuuEFUj38QQlQ4563zrnF4rEzjDu3F/73J1h8aMjMMVVo5l+dAV?=
 =?us-ascii?Q?jZVFGwAKBSe0rh6OgQThpRgmo8oqlhTDU2gqNQ+W8gOi5EA9oVRdBbZZHF18?=
 =?us-ascii?Q?t9bY7cfxJFqu+WLb4oFs4v7c+6jVG8fESOypaQ6dnTIQM4ukKw9RKUKZqz4T?=
 =?us-ascii?Q?AovJUTFNWhEkqABdfLogelpG+liB9xrc8plEJhrS2uFL/zy/HBl5e3AMXf/0?=
 =?us-ascii?Q?i6MGJh9bLsDYJbegvKq22H1JHNTpIlMrlPSrc7k1KsL3T1vq9dmCF6zYsOSu?=
 =?us-ascii?Q?WQp04PtJ9KWGf0jrCSipVb2h4anLaPf7+Q5lOoVME5eFeuS5Owvl2Bw98C/H?=
 =?us-ascii?Q?lzbNveuQKJD1jojzt+YZb5OO/Eus6hxvH2mGwehyzjaw3XwX2UwYPqymQoWl?=
 =?us-ascii?Q?HABkhs0rU7S8bRjDlUgWGjg6OyrXJ8mxtMbiTHHEf7Hmuj9OjQI385Ql3hie?=
 =?us-ascii?Q?DnG7t5hUD0n8YlohRr55/jkYxaSBv5dDAAMFUaTQieDd+/3uHG4wa+K4grgm?=
 =?us-ascii?Q?W0DAdE4WEQmkBkZETlRJhmfOGlQ/6Np22KMwY4f/tCMjsa1T0O3lvNGudHst?=
 =?us-ascii?Q?F67HEWzzVw0l4FlvJuJfEgsRMW18I/OYb8cu2hupKZWbbuuoIDcbNefMy9hK?=
 =?us-ascii?Q?0waqIKir8iHTZa1fAvLCCaW8/Dt9HPPcYl0aMfOUQiqvX91DebWx/u/w9zzl?=
 =?us-ascii?Q?pmh29EGlnUgt/3NRcoz6elZQts5ZYC2xCOJHVQ8+4xY2M/8eKE4LxpClE6ru?=
 =?us-ascii?Q?miLoLviEtWgD3THhQjGR3JlyK0iqdahEQYRuOanZ38fNDki3KSVIDdnjnTJF?=
 =?us-ascii?Q?ru+zqSDhaNvPGSw14y21efVsvplBkx7Vu2H0Yb7lGyaDwFges4W96rR9Cc8K?=
 =?us-ascii?Q?NqRQvWmo15dO3M7sC4a73IPQ3fQN+gai2lteSlSD+edr2gBm2duKSRyFa2nX?=
 =?us-ascii?Q?uQsVRwZBSLLnGGJvP5t3nnQcaRg9f4cOUOsRpUoN11E8ELAmcc0bxhsOOoyO?=
 =?us-ascii?Q?vXYEpFhZP4+sfdlrbQiMmUKJNKTawTdfbjeqh30OHLGT1teb+gPIJI1/vsUy?=
 =?us-ascii?Q?HU3T/XcCXrLlEV4P5wZB55PIEICoMweCocFy1xuK03VJlkLAo3jf3IqZkqQ1?=
 =?us-ascii?Q?7H87j+koAPQ/j0KpXrb6EXipDlkijAF/KqngpKybXnYg2d/BweOPmOGKatOH?=
 =?us-ascii?Q?wSEb9Ec3UATVPnawTmMMtgWAHW6676I4m4vwCAkpBD/8I29uaNO1hEo1vv7S?=
 =?us-ascii?Q?78pfHkcEH62XCclSO014IrK/KxB9tyv1mUYr85FQzpiCf7dwGWmxthsbzmig?=
 =?us-ascii?Q?DduZJjMVGIigaz3wqTCU/sIGLa+4Gsg4mT+nBFMaL6vzreTrvcR76gIJm8iZ?=
 =?us-ascii?Q?ljSgJ1INmt5tl+zyKCIXORf778TvQZapk1q71UpRukTvaWRl29jbH5NXJKpr?=
 =?us-ascii?Q?LYBYb7aItkdffkGyI0Qb5Ks2GOBJuy2GDQXohSCNkycPg78ulgvOVl04q/lV?=
 =?us-ascii?Q?HC2U2tRhWfASu7nylHdeRJ5XxtRv2rnVqejAIIhTll2neQ5Ja3s+NsHu+yy+?=
 =?us-ascii?Q?MT3Vdryr1IKD5I2iolAuEg1el1OhqbpGAZvaUXLqRTkTVuUMUvsvSWMkHQ+m?=
 =?us-ascii?Q?lVYAcrPWzirH9w0Eifhy0lSWU0ycLb3DBYUCY5bbdXzVgLdF9DQbB6UAnd/E?=
 =?us-ascii?Q?kv3LO/NXBsF2iqBXwkoy2uK0U81/7BE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94085280-89d0-43df-1e8f-08da392f79a6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:29.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRGi3XaYbHPKV6qd74lb0bioiZLWKGOvumgq0AktZ6n00fFR9OuId2bYChF+yPdMmU7uE7ewTv00ydBEpvC8M2xG+7iTLjh9VfZWbA5NQKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: -pDUnigbKU1eJo4vA-jYnc-DzuzcRb4-
X-Proofpoint-ORIG-GUID: -pDUnigbKU1eJo4vA-jYnc-DzuzcRb4-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we have more data set the MSG_SENDPAGE_NOTLAST in case we go down the
sendpage path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 10d7f2b7dd0e..5e3b59ecf5b0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -306,7 +306,7 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		copy = segment->size - offset;
 
 		if (segment->total_copied + segment->size < segment->total_size)
-			flags |= MSG_MORE;
+			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
 		if (tcp_sw_conn->queue_recv)
 			flags |= MSG_DONTWAIT;
-- 
2.25.1

