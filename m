Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B90EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiEQWZM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiEQWZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D0852E55
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:07 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKSZNC023116;
        Tue, 17 May 2022 22:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=r6ZftoAn+JCpElG885086mzsKgInNuIhwMdTV7Q48Cg=;
 b=QiBJh9TSMEMOSNh4nevtjwPWCYN8hmDfN7DNYcCz4kg54BkbkwdSdK9zIU6WDIH+HOUd
 a94A8ZObwFYrAGGaXBRwqJO5QQX3yjhoT+Mc/JQ/ElHHBV4LRKuJco+7d+C2CWDutjsB
 RE7n32ydcQihiqpx1PO9rRiEFMhboO+X73kx9TTT6yyHFs4SDJ51d2WIuzMuL9NOkZJb
 tCmaLlbJ4/TmXXWDj2MTPex+jfDaNZxJYvhsg7Ll/7hxJSmUUXaN+Eb8twyGN9I/kcrO
 4E1WTbYYfS0QO4Mv/8E7IXs3zy8q9ZcNNk9cSlIYk6FfeE10w2cNyFnLW9kzDWC5rrIg 3w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7ncu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:24:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLghw031743;
        Tue, 17 May 2022 22:24:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cppmnb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6fceidUmzrxsI+UjlIkG0Zii91hhWlR3eaq7m9+hjz110MM1VR7B5EYv6BG26ncL59MrYzXYhr5vd2VYvnq2ZL4VXWfqH9wpfz28Alwncs/3rXfPw5tmBQxOeqaRCZ4vLdSgObCLTn5l3zVTe6VozvzU9VmcSJrXQp0y7xwzzGoxhbT+8RqpDphhDH+BV5hLoMVbbYL76I8DuIsh3CmlnrQMWOI4AuH09mz3Gdi153j1I5kPJuVe7vpbMxJlSqNJJwHqpUmqWjYhqlg1OkV/P5nVnjVSpMUU1yWmV/H3cvlzgbQRZKPy/R/i2SsSmd1WXXWB244CH5oz4Tu0E08fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6ZftoAn+JCpElG885086mzsKgInNuIhwMdTV7Q48Cg=;
 b=P2EROlDVkZHSvBXCvaorXA/gw0cjtDehZlcZ4hnPyPWtiMOU+WRtlyDghnJ3WVR4+C1JspRzT2Jw34sQEvZat00he0/rWJEaBDFMI6XEwNK/yjnSD7yebo2s6To9mRnzakWNsuudFAjIBB+UOwe0Ry/VEIOXMP6lzucxTL5R+R/r6iqjuNjk4MYRfWu35/BSbIK5D8o48duRJrjlIxAmWSVeQANfBaMZsQL2zViMjxGmepOy4M/pFGTBebjFUPkuNUa0IDD5FKkdnddwiT3C4c5F5RX5Jm5RwjWJG/2dMCz0One27u9TurJlWC0UnrLBhJkrSnwukVuUxhXsC8b3Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6ZftoAn+JCpElG885086mzsKgInNuIhwMdTV7Q48Cg=;
 b=Dh2XzMaNItg9FQV8d3/3GwKa4wLduH3e1lDv1bImmEHhTWgjmsupydYuv8qvD2TLmDNskLcMQ0u9K/LD76EySKWz/FPJmoa0RYHiuxywwfYmW8Nc8qR0wxZzqkWnFrp9/v648mTdxg5++GOQ6QD82whzCDEZvkNySzIp569GWKY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:24:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:24:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/13] scsi: iscsi: Fix HW conn removal use after free
Date:   Tue, 17 May 2022 17:24:36 -0500
Message-Id: <20220517222448.25612-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25ab3ca2-c54a-4423-1e48-08da38541231
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5517398FF8331BAD1A9F477FF1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UPsmWaKMfwy3Jv3pcjvAP56leEVNb8jHDd/EtVebTTzUlVPM4+ONvx9jedDm43KSEpMcP3WfRFXBsb7KfXayXzG+QDUH62SW41jnpZaWzG9J++NiGFox6MxNA6avmdws6y3nT4bfpGON87choATuhw6c0K9yLIHx+TdwW8NphVbSBAWnf+KOmvp36meirpR+UISR0y7fHVS+9IOYxRjUv7Ycd5uTDHA5NZJTqgLw1mJ6pD+DhHnVku2MMdFXrSGUsdLTl2WO48YG8y6FzMfHOPVBi5iYjUeanFTJt69Ezwja0EncISBlGoCwILPXtWNAy9Hm+lTIFXcs7IlzQudEJ6uO8mgTdcvGf7ND19g2H8WggHwl37AfQVZwzOM86AZcOEaiY3E3FpnKx7/hRDYZGaCV7FEcostqmuXaTIS8A7rIhn9Jly23YJkGvgnK2BELLu1jQtqHphJ70u1nql+z0XCV+ulyICyaOsXwJQh0dUk0kX2xYLr+U7DJnsZ2T1FzK7Z9qNmDyo38+gEauxBk1uos8kztYoTfs1r4HYkNuobqvhnsTHqNQ/wttI45CyYYLshO2okc6wfef39UkOk73xxsmSmyXRYpAr4a+T7iUsrlq98Dz3Z6N79eBz3jquTdlAACxHXKyS4ngOTO/QHG3DJdNE0ZaHdpLVLbiUmY/0RINVpyBRBebyzHzgo1wzh9mMnjJcuRTMGl++4YB6YmCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(4744005)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ipab2DWjLuUStiIii2fuiFAD2FXME3AqP2zu1nOZRbvlLqn9OPkGHCdUyTOy?=
 =?us-ascii?Q?uo2c5UsIAM52ceiapIZtGZ0Uvjk0XH/hGVekvY9Y3yrh+isyLWuS3KfAbBID?=
 =?us-ascii?Q?b9eLFNkDTJiS2p+WYM5kMemDnnuPsP2OhwJA/p/p83xYahhBSoEC85eAI/kC?=
 =?us-ascii?Q?1szpzHnW13PaYceX8ZEjGgWiA2BPAGIM9k2cWrNWMNZrlV2tOKjMfLwJxcnm?=
 =?us-ascii?Q?KNj6XRtXD3vwlrFhIQeVPZPu0aUYKZhjc0lFNxNkYjgcbZEtaUX9TzvGBXz6?=
 =?us-ascii?Q?gAie3UI6HjOFrvqEJShbHAw03rJDRTlEV4QTNKRDdW9sYD9v7ti0hVjKY4lK?=
 =?us-ascii?Q?yIV4roBQ+YGDPoLEz3cbhKk4qdnOS6D0F5HWGwNSIRBRYCYqgdrfOG4Kg6kI?=
 =?us-ascii?Q?gpifjCSlUNNvJwCNxDv4wV/jbr0Vbu90zX3sQFyGJtO0ydow66eju8EkUypP?=
 =?us-ascii?Q?RgBwabPJGLIy751g3kR6P+oa5RWwscsfv4UOgeyHhvA3UWdV4rwjMTQ6qpLh?=
 =?us-ascii?Q?ACj8fGkU5SMEyL4gD7gEMNTjJY4NP7Sbm72aBwRFWmK3RbJSVAOcLTkvgMQJ?=
 =?us-ascii?Q?csi0Bx/krnao6ZJyZNMqA5Hx/wKy73UvV9z6JS9EiaK6rCfxVaWxPERu9rfF?=
 =?us-ascii?Q?iwSDBcAr3eRqfQTVriPW9tQyWp0BqjyZV/Mh8m5MFizTQvVW04fu3omSH0O5?=
 =?us-ascii?Q?khU9V8BOzU07YxAOtPPWXW185LeJjyjR0oTmmb/JfYHh/0Msv9GnStM3izET?=
 =?us-ascii?Q?WAR5bepCmBdwZ31Q47F8i8BXJRo/Plg+86hmdiEM7XBZVLY5+GoRAHSKVnlQ?=
 =?us-ascii?Q?VEnUnqZF70gjgYAGAupU1loitYZXtrLfevvGvLSLT2UDYs8Ewt+rnK5YptMT?=
 =?us-ascii?Q?8AQDCOJZPxD51ohR8f8/mRV1UcvwcIIb3Ey82uTZcOOl0fUveTombL5kDn5r?=
 =?us-ascii?Q?7nzpV/YzncxKzj/7E4kS7wdVd9FzPIx4wceOgt64lg9x74HphoAZaODcFbdM?=
 =?us-ascii?Q?GmsV81JLQr74Qa5gWhFUD82bVvjoTbMeULcHYHiqGlr+r6xsNcmh+Yzs2QSX?=
 =?us-ascii?Q?w6vw3y+OrY2/9I+gtJBAdaBwUfVDPW5aaVH8CC/XSW+AOUcqRvcFQ/7ixy2k?=
 =?us-ascii?Q?/boOqQExmLenobAYeAX2dgjxfywKcV2kFLhubmQJ47PC3VxrLztPSYE9IkKD?=
 =?us-ascii?Q?HnLWT2bAnyX5gw6K1+0fbYga6a04bsrm//gPiBcWIYJAfjz07LdtkEDj8apj?=
 =?us-ascii?Q?aixaVeG7+MqmdCEfcvhSJStGvSyEXy8E3TixPAs0QXC34H5HzSw8Oguk8/dL?=
 =?us-ascii?Q?BGsAmt29tmGqTyi3AzAnqGcvIamHEJdK72glRboHQ7sZ0XCquovshymsqsBE?=
 =?us-ascii?Q?KxZTopHBJB1QStGIfT1+XDAMk8mEy9CeXiydkRAU3bjK/Ual1iljJXG9TCsj?=
 =?us-ascii?Q?U58+TiJoMr+Q7B6GiephCO/pcfRavC0FeXIH1XoXPMb5HRLebone0oSGseHN?=
 =?us-ascii?Q?F/13ya49rS8O4zu/YuylMl1yUHxA57nK0Ftk6Bz0fMux2do1Uti4ndNDLGMa?=
 =?us-ascii?Q?VdjOGoqL5Z7/3Xrpuo+CbuwZ4N6RRmD8yqMVX6oJPyJ//Y54UPPfmGHHjpcy?=
 =?us-ascii?Q?+L/kFlAfSVobBGmlzF5YCti1jxOcb3+1YhTbpZZIgjjjyaFRQcPeHVFo//04?=
 =?us-ascii?Q?i6KBmx1UHvlASyrr7v6fR3NXbBlMe1vl5kVdeGrOCc/nvlusrbAH+GbXuBkO?=
 =?us-ascii?Q?WgnLvs/nTiFDJl+/EcnXS8VWhF6Rrfk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ab3ca2-c54a-4423-1e48-08da38541231
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:56.1526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sw92QL/85b1WdygHD4MIW6qqSVOo1Uh/TbJNQCsQR4aN63VZuAhFVT1fp/Y8XVwfeIEB+BHjjVzIYt6HXzTY97plHFuMs+NX0lVaOOW1dyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-GUID: ao-Avn96Bu7534CgwB8jY6g1JiEmfNaF
X-Proofpoint-ORIG-GUID: ao-Avn96Bu7534CgwB8jY6g1JiEmfNaF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qla4xxx doesn't remove the connection before the session the iscsi
class tries to remove the connection for it. We were doing a
iscsi_put_conn in the iter function which is not needed and will result in
a use after free because iscsi_remove_conn will free the connection.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2c0dd64159b0..e6084e158cc0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2138,8 +2138,6 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 		return 0;
 
 	iscsi_remove_conn(iscsi_dev_to_conn(dev));
-	iscsi_put_conn(iscsi_dev_to_conn(dev));
-
 	return 0;
 }
 
-- 
2.25.1

