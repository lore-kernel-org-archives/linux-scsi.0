Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489EEC678D5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 00:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjBWAUP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 19:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjBWAUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 19:20:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4A7460AC;
        Wed, 22 Feb 2023 16:20:11 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31N0HFQl003422;
        Thu, 23 Feb 2023 00:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jW3HSCGNQzDFxSxggapaugLhqWKpwDvq5NdU9JGGR3c=;
 b=CTGYjfCbEzU78oiMlJg/VnjrzrekycOey0wjYUsUjdOlbkRbpbm8+s1pKMOyjZVY5qjp
 DDzKOZgDc2hLzUHkoltMEsngo2p/sg7kcBbrTplRgb00AG3JjGUYjVVakAp35k3QCn25
 raw6fhadoa1LZdoto2bTdBuuStKdt3XxmKVjj2jspzfRkfIS0/jaImDoBmGM8SJpR6ti
 CWnw3kFaIAR22wFQOBFyYil6NX9pqpWOx05HqJdJ+eCpgLFVD6+7UZy6VwEdzb13J92S
 GYLLdEm3S3bVHG7tgv8SvXR5CQundJE7Qpq94Ie8fB5lBeiqDWjnD8Cv3xT/cGGmLyRt kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90sbrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31MMPovA027301;
        Thu, 23 Feb 2023 00:20:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn47j3v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nyrn9SFzoKb3iIf1Swqg/Q8KF3ulf2N4OlmiVj8PXxQogqOrmC8ff3/fZT+F8kMazqbywmp6SIEPc6ujeKZlnFktQInjjJZTPvxQn7XOoJzW2aMcjB96edWmtOegQeobjSNucp/0Fkpd+MyPNF2BCSLmvlKqIM7hUntvfwtNpVvOiqdV9m8FTRHrfHOgH2fTZPX9xIlPYjNLO0sn2ICL89CtHoYAN6Imf2Qqr+FQNVLy4yblusDJZPCoC0YwFSBfNw4niJ/vd5Pf3RIn4JpBTJ4f+i7yWKdpX0OgEyKgtEWeRZHtXhFPa6CCSZ6HBoMZ83iZS7R3BVCTKimwIHXrIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jW3HSCGNQzDFxSxggapaugLhqWKpwDvq5NdU9JGGR3c=;
 b=SX633bLBLLG5XMrSvEk8CjgR2hCJZKvi8WVvno/oCPqcfmMTxlSu3YAvTtmd2Ucii2TZHuELP/gcrDHGJzXtGjRlr4xyaMhxW3clifSt9bl7nweywuu6Fft0/qsyNtwazG5K+JHZsfVEYhrz5jtjvgB4tfzU482GcG++Rb01VxHXUJNCbNmRIw3ut7/3VN23dBzq5hRrGmQVDCRYea0TroxzYHTG1lbOFb0Og+Vin7n/Dbv581FTODZ16CZG7f43MppuhM3dMyEiwGJJOCVx5H1VbQFYe4tkeEQvLTtNPXA+iiAsmWzPxgXE1jpaCaNE3OChfJXCBcyFKX3FBpPtFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jW3HSCGNQzDFxSxggapaugLhqWKpwDvq5NdU9JGGR3c=;
 b=s0dhco4qb23Z3+W/YjvFRZOV8Wi6+ymKqPe0JvexKNs9LXFJgKhPfTeNShy91cyO3UK3ceX2/glDGPuHYX6ubNGPibTFH5H5p1/HeVMioGlOd1zwFcDF+0snj0tUu52VTaNNtHnokq/ywg+zt3Y7JL98qsfgIuUJn0lwIORndVM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5286.namprd10.prod.outlook.com (2603:10b6:408:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.6; Thu, 23 Feb
 2023 00:20:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 00:20:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/5] vhost-scsi: Remove vhost_scsi_mutex from port link/unlink
Date:   Wed, 22 Feb 2023 18:19:47 -0600
Message-Id: <20230223001949.2884-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230223001949.2884-1-michael.christie@oracle.com>
References: <20230223001949.2884-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0166.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: cfea0f79-aaa6-4dc6-a4f4-08db1533b60e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C4Iw60UX1a4LIxeb50eBSunybkWMNwp0vWZAjM+FmP+HRQE9gxrP+E2aHD11APcCO8VT2V2REvavhzjv3eYzZ0CyirR/R6MYXmiEvCp3DDjWaFZmQdaX5LD/M0v7RrYWpdsphi4iI0k8jeOx1MuiiDDvTpwya1Cab02oXHK0EePsI04mp6T/CjfwNk/9fw7BFM9iCughig9+6jdToPhgGmu6qtbjLcBBeWW1/Q9sWSqYuxvsF1TncOiP9ge4rBkaCJiBn7ngP/kZvVZKSV+WCP5kGdOovZokOmpxsRqCoUCtF8FwpvXRIDvcmSJ0YROAqKzTqZZEnpeVmsozvGWI/C3LJNP0P7NCFnIFlqp3l3+/sKjwV8DBCtOz93dgD1iyHszi963YCzLsQFynPYk82DYvFfoM45QaFDjGq//hbCoe5niIoJxOUJMnu70A+jc2XhpA3x+x2VsYS1HwJMrSFQBRkMtzrXkzdU5jta3WgMcJ81Dg7eDDWECQAekTEUl6uyJMDst1zWVfwij2T67Oq9CV4LzFrOsmhgq9n9ZOrp6ZbKqW1MPNvJv2QlLouWKMT7XXB/xrfb93yh0aFkIGsROYsfOPAxCGkVFtXa4RIDrKXjDMUkMKsIv6MmEkhjVzbEOGNs1E1FNwc6Y8e/7RkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199018)(5660300002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(8936002)(2616005)(26005)(186003)(1076003)(6506007)(6666004)(6512007)(2906002)(83380400001)(478600001)(36756003)(6486002)(107886003)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ixm2APumW1NCIu4aDq8mapzRdjVQ/ua2yVTOmKKhQxiOC8fxZFqq10BeHUHn?=
 =?us-ascii?Q?/Ql1CQutR8JqNZWpAScq7eiVGFsvdamnJ9Qeka3Mn81wVSSsaYffH5jaRicy?=
 =?us-ascii?Q?adkSCey0BIA2QfA6HKQQcilhenDsqcggbOgfpgnPdF813Td1/oYLW/DzUXwh?=
 =?us-ascii?Q?ofDFY/KZdgOA3TIj91/hM40KrEKCbdCPGLQxqQW/zgg6XEK7JAf3jJ4UPEGg?=
 =?us-ascii?Q?kITJ1v38sAl/XVtW6433mF7OBoSbaF+SGkchAZZlL+dXhCqqKICW0iSoPq3R?=
 =?us-ascii?Q?VBUHGkcAfnlpmItL7qGH6Xfj7pqT7gn4RgWHNxOjaBCpNsG5K+OWvV3djHSH?=
 =?us-ascii?Q?i8qZa0rzgjhQiegJgLWTTdM55rI9AqVdJSXFtrC+VoTa4rV21hy9RuOwFcyS?=
 =?us-ascii?Q?fXkGGGhD70LHKMidYK9Z8lKxWHdDFpYUdmT36QssNvZrGrlJ9Fi/rdUfa4ef?=
 =?us-ascii?Q?XjnYvXeYp89sIVX+LiHhQ38v9e7yOVaUmnYZdeStbHDOEY0Zb0d3g2LevB44?=
 =?us-ascii?Q?E87BDLLBeTcJESKYOpimz3Hu480u/vSaDumsCDe90ZKh363YGPXYT1IJ3+iY?=
 =?us-ascii?Q?lPSobJidp+4uudfOnGiAXGB71V+7wMdHnKe+558BZnG9jxJvWASUGJBijyBM?=
 =?us-ascii?Q?9J/ct7IPsujsjk+xD+x1U37WOLHJNvkJZLfwm2/BdWyg+myEFuFRFueAQMev?=
 =?us-ascii?Q?nTJcEL9+x9qqtMMyCuljJwJPSYvAb2GwYL3ppCzG33al5cjbmZaogxrV15nf?=
 =?us-ascii?Q?GEWtZN+ZWgQGe20Gd83pbxUbKst0KlTrkK6csbJxaj3jy1zGqo1xT0bj3GJt?=
 =?us-ascii?Q?AUiEb/riQbAHQmw6sRNz6gI6sWvAuwRnIhYNECWwC08mIrc4Wc5tK0nXEl4g?=
 =?us-ascii?Q?uF3iACBfuKXpOQj3cOUsHHIms/CchbRVkr45/Maw00jUo6e03vJae31tm977?=
 =?us-ascii?Q?0tw8RadwvwN3dI5rNKDBDxo8hGc054JmWNgjNnNgQt6XYK5c33RWW6V74QnK?=
 =?us-ascii?Q?WChWFAaMPSc+GzvQTuspzhkYKeBpT0wiioEEVIpTwkyus8mDmPCJCUIIaDb1?=
 =?us-ascii?Q?E4JDhce3ePFjdXUDXp0xH9v2T61bkbdLU/95L4r8X4TGtIjkdRy+yOmpTZpO?=
 =?us-ascii?Q?MyvG4mkYUpinhN2mdNTlSs/OSAtzDM3+iKL/R3MHG2pRpGzMXqqq9Ejd9ySe?=
 =?us-ascii?Q?cV5qhBypIHmKyvAl/kHQvkhLNh9jwgquv7G/bHo9CEEm9jtjFEQGefqbZOwO?=
 =?us-ascii?Q?PhvaXfzXuwyjWZkHLpDYVgt0aFPkt/x7VUyStFG3WlGtSSyM3PDn1gHty5vF?=
 =?us-ascii?Q?9y4FOYd1CB62zi8UcUI/WzFQzcp/fsrWuu5GjdW1Y3KBgj9qsaaQ61K5x1sb?=
 =?us-ascii?Q?z0lad/k4vGDQ3So/LChPBaqG4gwOZ0UMn66yeOGqQ3KiGddg0MVALzgDLSIe?=
 =?us-ascii?Q?aOlZE/crVRPUfedAVbCswapM1EzHg7+1asHfzzyi9TT8b4KTsaBZy4sp9lIa?=
 =?us-ascii?Q?BEcGUFZ8wf9NCoXHSaZRTnjn/KrjR4uJYmAoGAdWd60zORkrCLMT3X6teJnG?=
 =?us-ascii?Q?i9Uepl8MBXBZD4b78w5hWrv+ooyL6DxXf6PqtlN8SFfH/ZqTc8T+dcqeH7Ax?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: io/G5d7QNBFacVP9B81GKJsZRaIAQpcQ/M6Kdr/+X+DmlObZ2toL3SLKcKFSSKuQ6nnZ+oshbWeafXErmowNUXjlvakMF0XioJMo+ks4Q1fMRTtsLgfgAVE8h++JIutf8kYgXGFqOKFsKHMnsyEOkQvq5shRul5JCVR4JArqEpwtgSsG6PcKS9fkbMu3nxZwuQx64fbtOmXiRA5Ka/U+QBzh99ouyglw1jb5DEd/kG4LrGrWP1YuQvdzmXqlAWxhnJIWK6h/JSk+S7CnoYNVuMLNQ555L6J41XZvXBrBez1RYKNJjUf5sGmN9ej58pKke5WQL435AQwFzTiF3BoSxK31LIt+q38Dx8OweTwrvgqymZRvU+s+m76He5EjiaIODsZTKiyiPiRpd4TVuY7WNvu5wgbH/4UI7eiEHyW9bfYFcOcYWl90sL3cBsQjVDA/aXb/5b8cM9vIu+6aoJubXI3UQUfmDqi9CT2s2y/Xtdx779fDiWLDWi63xwjXFSj8haCC/IIhywWZxKBT6XMxhu9XEt4ak8ALdiF/eQpSkKugu2TxRtc5B9lyEbDSNTagcWIXFeQRBIIPtoV+1EVLqQB0WwJGphUaC0X+UnEDjrTUa0OJayJifJBJxl93EUTD3KXDCFxw8Lti7RMk72R40kgCMX0Slsz5o7eftqPiL0LpCVKYVeHevYpiyE1q6AEjkeHZEujSrBRnAmCd93LRVwppD4QLuLVCBXARt1b3giwQciub+NhQVPmhbz2CkXBYpSyKLkokvNd8dWXx1ECmnflpT6weJLGbo7UpIgrk3hhvXlKzoDlKd6FREAuBRXkZqpn7MNzRE11s0xjFr5uDozVLdNuX2p69q/OuJMmm/UU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfea0f79-aaa6-4dc6-a4f4-08db1533b60e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 00:20:04.6547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l0+FMVYJqErRD7CMldimd31kUZB0Feb+iVQLr1bNrWcK891jSzStvaqDqjBSJ9RUVdYIUOPHYu7+bcKkLXw33E5wjuIBO6cp71uJt0pmIYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_11,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230001
X-Proofpoint-ORIG-GUID: Iprwf26T4ozvu1kHzJiO4TP_qosUjuEA
X-Proofpoint-GUID: Iprwf26T4ozvu1kHzJiO4TP_qosUjuEA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't need the vhost_scsi_mutex in vhost_scsi_port_link and
vhost_scsi_port_unlink because LIO has a refcount on the se_tpg for us,
so it can't be removed while these functions are called. This removes the
vhost_scsi_mutex from those functions to avoid cases where we are adding
or removing LUNs to vhost-deviceA but are stuck waiting on the
vhost_scsi_mutex because we are running vhost_scsi_clear_endpoint on
vhost-deviceB and it's stuck in vhost_scsi_flush waiting for a flakey
physical device.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 502d64b53d9c..9e154e568438 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -232,7 +232,7 @@ struct vhost_scsi_ctx {
 	struct iov_iter out_iter;
 };
 
-/* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
+/* Global mutex to protect vhost_scsi TPG list for vhost IOCTL access */
 static DEFINE_MUTEX(vhost_scsi_mutex);
 static LIST_HEAD(vhost_scsi_list);
 
@@ -2038,17 +2038,12 @@ static int vhost_scsi_port_link(struct se_portal_group *se_tpg,
 	INIT_LIST_HEAD(&tmf->queue_entry);
 	vhost_work_init(&tmf->vwork, vhost_scsi_tmf_resp_work);
 
-	mutex_lock(&vhost_scsi_mutex);
-
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count++;
 	list_add_tail(&tmf->queue_entry, &tpg->tmf_queue);
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
 	vhost_scsi_hotplug(tpg, lun);
-
-	mutex_unlock(&vhost_scsi_mutex);
-
 	return 0;
 }
 
@@ -2059,8 +2054,6 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
 	struct vhost_scsi_tmf *tmf;
 
-	mutex_lock(&vhost_scsi_mutex);
-
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count--;
 	tmf = list_first_entry(&tpg->tmf_queue, struct vhost_scsi_tmf,
@@ -2070,8 +2063,6 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
 	vhost_scsi_hotunplug(tpg, lun);
-
-	mutex_unlock(&vhost_scsi_mutex);
 }
 
 static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_store(
-- 
2.25.1

