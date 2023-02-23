Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56603C64EC7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 00:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjBWAUY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 19:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjBWAUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 19:20:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8EE41090;
        Wed, 22 Feb 2023 16:20:17 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MNiMoO007598;
        Thu, 23 Feb 2023 00:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=84jH3CnPM8YKlqExlJ2c48psiUYuVdTLqireivngPP8=;
 b=Xq0Za9yTzZAM3AVOAWqFrL+43IdVHwjfSos2Vt1YdyEJFkE3M6LIMGao326cOTDVJMOD
 R9lDBdYBDhdxyBUgWN4vWzEmFJwkBQHNp1CcEQV2RmiWuzmS4zj/tVBI8Bt2cNkyvF7k
 ADIYSCvt1y8+wcizWHoYSZd0+ir28wb8b45KCEWhbYuWgtmW2YvVvXrnELfDFvyu3tHC
 bpawkse6PxINjeGlhoUt4b0QOY3lHdaAaDgKzYOKz9PVZDWCbkcB0UtE+H9Kz42iVwZD
 btNnFpkXN68x5rLeYHRVbZ9yx9KVMtjh8Iu1YW4cs3haRKm3gg1j7jPunt0bgdpP6/XB 0g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9tsdqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31MMPovE027301;
        Thu, 23 Feb 2023 00:20:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn47j3xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffp8aywnKtNX+XX5SUMBaYQ8N0RHDzsfY2n/2r3KXbST5v7C7I8x3iIcYG1ViRfKoQ5F2Hz4Bucj7ov3qZwGmyynK9eNmnDN1+F3wlwsSP96t39FMlWRFa6YbgrIQspdjkly9p8tbah5nEOImrsoLcjOQiZ0dKOIjPoB/80Ra/m1Jx/HZwiFbqUoOCZMP/K1WWimo6L6sxM8T7FPZohi62JasUdRsgzxjAZDKi12R/aKMVGbxUKBE0gRN+PX7h3NDUYl6EaOYTdAj0qwJFXAcYmoC5Hutm3E8dlpTsagkodQD2w4u1n8l6harpwFpsFP+dBwcAA4VasZLAOYyBDRKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84jH3CnPM8YKlqExlJ2c48psiUYuVdTLqireivngPP8=;
 b=lfsqhu/cgu9osHhjzid3eNu8ybHBSnj4KumE/pQ4JcOCGJttGYk21HIhH5gR37bOlCeM2+bamPvKTEfkj1tAwO9frcZrQ1p4OzByXCfYKcG6D4hjQwfUXh4y5dCEsyOanN63DOQVEV+3yMsPVPk8m+WBGJHnRJPhcJmLlhVmTSPBh4qZDydXbZhlkSiKd0Yx+zqIhZLheaP73ZZHz3DXyjMzqBAxDRUYbgqwJRdxCVboRrwDLbhocVf/How+0gQIXWUvmzxFSttGZufFJ3HZ3yuhIC1aAHhYzPEuxfrNyD9O/xslYx4ZBivc/z/tZgSjthaRTknObvpbsx7zUnfxjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84jH3CnPM8YKlqExlJ2c48psiUYuVdTLqireivngPP8=;
 b=qOowPMIyAjCuW9uNZWL/pTM0KVR8F7kJ9hTLM7mLMC4dOV7ugWit/8Wu5wrjRUQjlixRIap/fA2Q46KFGSUkf8gAT0rjNYW7OWsMe3xHcaOXAZisXaw79IGq1PKV1cBI3N1TxjbJAFZuKSi02/GWUhDOSm0DmWpN4H8gqQeAsqc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5286.namprd10.prod.outlook.com (2603:10b6:408:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.6; Thu, 23 Feb
 2023 00:20:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 00:20:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/5] vhost-scsi: Reduce vhost_scsi_mutex use
Date:   Wed, 22 Feb 2023 18:19:49 -0600
Message-Id: <20230223001949.2884-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230223001949.2884-1-michael.christie@oracle.com>
References: <20230223001949.2884-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: 08a60072-7c9b-443a-8de3-08db1533b88d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OEC7vDLki9yMscdyB7xvCSG9xHcSNxH3/dmezyCyrBYkXKSllvHEy6jIIGl0Nuf/zTXnU8tpFu5JhtyHYjxYJGAo60/TyGNEi9P2WtvhEhPcYhJWr59e47B6Ch482So5O4ziknnEW0ES8Um1fCGUs4y0k5AHjJ1WsdOURYupp9qczTIqqv5yN22KPtgNQX/OseQLWYwGknQDLewpjv2ADEX+eenpfg18HwJQ52N+vtGsWKCBAkN9wF7oZOLGluPmm7ejojPMHd1lpHpivHkzm4vIHVL9eKk5xISrjVPtJQkT0JT0a7ArcCiGqB+1Av40lNJwUjv9jti5gBU+9HRQNNimr0Acl0W+25GON9tVjIJMJdFiKR16nQrNAgJyHf2KKxsgBp+YyFUOLphVmrdWB3D8xQ7j8S+OD7vqgqJeD8amn7woT4b5wthtEyeW30xSr+xhhnpBPsoG5QwvjS6CQ59lHltxdJhd2391phxi9L6jnWSfaELImeILYtl4dy4OwVZFox7VX90cPlkiUdFQ6iY2tauYc+9525TIpEBpes9ai2MJFKcO/tjYrADgMMS86SSF87Qkyih+Oa1HusSEEMN9yA1SaeVAlk82fH6ea3XHGwSTivVtIY5zzCh2j+kKac2y/GmJLG+wB06HMZCvdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199018)(5660300002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(8936002)(2616005)(26005)(186003)(1076003)(6506007)(6666004)(6512007)(2906002)(83380400001)(478600001)(36756003)(6486002)(107886003)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TAWkOZLpC7RxEMke9yZDfCeibMmAJN4HmRxf4BK7wDoVsPIIOu4n6mGlzE7e?=
 =?us-ascii?Q?iY2r5URhAVSTZEXY+mNxLF4i8Bm068Ku1YTQSPuotycFgV4TM2MitF5Vmx9C?=
 =?us-ascii?Q?Vj6e5o7fj2KljOXrP2WwyAiwNgkHcy2GqMMfQVO7As31VA2EYeD1/Sv6bosW?=
 =?us-ascii?Q?JqYVnoA4UV2sw0utPAFqTRBgzWLuHHBrQ9vMV/fAHjgH2qnMiua3fC4QF5oz?=
 =?us-ascii?Q?0JupMRl5CYXbZ8RkTBQM52JGZXGqJh7Wu7PI/uqKJqYLZtiJu9cQ0HfdbcRZ?=
 =?us-ascii?Q?1p6f6cP3hvMSRhsLklp02dCdFKBfF+oWU48pzpeIio4v0YNfnsaoerlc0k9I?=
 =?us-ascii?Q?xT+yzmwrNvq+1ak6lsDZq0oMH6NS8V4eVQQTh6vlmqg6aZON3gvGP0FG3wuh?=
 =?us-ascii?Q?Fuw+5lQeINaRyny9U1+k5KXyrqpOTu2KCd6Apj2TVKyBtDMpYtjkxAi3nnpR?=
 =?us-ascii?Q?JOgOK5hkwaejNXtQzRRx/iXnqPeAE0CSbyNaqpVlAe/iTHuxurlIPYcE/I3k?=
 =?us-ascii?Q?kUMKVIs7IcqsEV0RE8tvNWFsGZ1S1GZkp4fBqZ2bdZkLXS8MTlvEiL7MpyCn?=
 =?us-ascii?Q?/ndc/HCR2zZdpT0bYPg+Q8FBHLVJdOEsSNC0v2ELAhuF3RE2u4TyES3G9wJW?=
 =?us-ascii?Q?qE3sYAkZYPUJOsCx+y9dCwM/nlzmJdknx+IdavK9rhvXlGZBfNysFNGI6LUh?=
 =?us-ascii?Q?5O4psInTnX7jFlBE4Jv+UAbjOj+R6hfVx9lz+gF1s4FIQPaHITbmeewRUTuV?=
 =?us-ascii?Q?qte4McM9Us57x8OkNGXJVWqiTXGPH0i7ZhmZ7FzQ7ibeY5VdX/GVSgFAij9m?=
 =?us-ascii?Q?CNrqx0/36TUTCP7oS2+SFkzt15JfKxPGqH+4wCxLAd1VSLO+pk+fP2r0zWeS?=
 =?us-ascii?Q?X8TykK9/jrEDU6ViWnmya7hBEmuY/LDDHOJP9O4D9KMAX6832EwaDwwhwt//?=
 =?us-ascii?Q?mtUTxUilEpPPGsdf5+uOg1B5BkH/LJkIc0t90gOuwfWdaqdfCCrCfp/GfVMI?=
 =?us-ascii?Q?9SrEah6dnwGsuchEHZTaFjT0FlUmtOkpPctSud//piDxYcJSmNkmVf/bNNUo?=
 =?us-ascii?Q?JT4iWeT6NuNzeAw0mVshsb++umF5CKFSE3rsZrJCPsT9oIoef16mFpGQexV/?=
 =?us-ascii?Q?hvgGz6fMQ8zNI4FcPoXfC1fN1od+E1lps9RMAUj6Ox0ECGwUJkmBa7rotkIl?=
 =?us-ascii?Q?rYa2QuAEH7qlFsxoyAQfe4uXEHHOGxzYD/L1YlsgsxJ/Ia9SGuXq4ylBloIh?=
 =?us-ascii?Q?rovVshbPcfcJC5nEZ2ahCEpeLJovvCO0uuNJl86w5fZld8inB79EQOvczs93?=
 =?us-ascii?Q?sqkVyDoHoUrIpyhOnptwbUmorpcuUQq7SaE/MUWNf+Q0FlVNGkfXX1Wd+IBG?=
 =?us-ascii?Q?Kb3+I/77k1qW//htw1GxwhUb7r/YlT13cK4W+tH3i4KFIJjxbgxG/WnoWMe1?=
 =?us-ascii?Q?q+d2HrIWZIkWlz5y54RyLTMwSdiIOv21JlAPzjHwjQZzpzpuqcVYieDOEeVK?=
 =?us-ascii?Q?7QQejBscIWFT80mY6XGX+wRuyESXk4OBW+5ZeiPf6omEKb/q2s5gR+/Z9p4Z?=
 =?us-ascii?Q?L6iuH9LfJUnb/SZUVl5iv0j3hhuXnSxkOrewDW5CupA8s0RYyStK9HouCHs9?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ji/FS2gymTjodcCusYOZlq5cwXb/3NDkCA46OZEaOQJ4ZPvGGLZlgAJ8yPvb/rjB8nR+kGDHNYCMeMfXohHsXOLLHK4gf2/udyr1KD6pfJyxDELRhmPeZ+2zyQXG45GmkF2ktkbtlJUNkiH463g9huoj1/Sxyhh9++6qmYcqG+w35UI/ujP6iiOEHVHWKaj8HlOhZwkrdRfsH9HncDfwO13XcG01zAeLfQALqpy69bDSDL7r8z2o8GXMsXlCPiDOFZrArwvZ2n6HXvweD29INLxT/0BEv/rR05GDVBKaHT/T5cow3rpl0JT71TqzDiqep9hjaAoM9DprxbZl0uicOzppGqmXCg4Qkj2berXrL6DILCnV+yomtnLP6giBOInWmlFhpbwEy4tZ9PZrHLzirYkyVRi2RjE32lBopUBWg7w1jZbq2iqic/gpIkgZoC0+ABECuUfUfQv3kIM5NIc0us5N+TUuFIq/9VAGKdRejDsg1AS8rdlcrF9xIMyBGlDyzFPxdkdzg2WbABAQJBb8XVBM9TUs4vBb02n/rdMpxySQxkfHMRSzGkXGMiczGV92y3x3iWDXGDAPtnbD9+xZINnBSt+x0E8Wlgfz71M+gG8fgGZDgB8N9AAKVtklrruzYF8VFQpEhQhMV843Uf+h9g9pmRyQpgGHP+YUHfbt1gQWKkRhvEU9z2uooJhVjFhhvsQJDAVERf4NUMqS4PlsLyxiGtkyyY0OS23vjQKQcfKokBmTc/dF+UhDT+iZnIsMk7g7PKBrU1IilohuL+MM1kptEYlxyq4s3EjzCERefWdLEAd8p83cK49DYs6utLCcO1QF4PZMUYqjGZbGNfh1uD3jqxyVnYsGr0LY/i1d/p4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a60072-7c9b-443a-8de3-08db1533b88d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 00:20:08.8575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C9hrbjiscahBSoi6Qt0ehYf7JHX7/Kgoc/rtfr7/ZB/ZwsH6I3I+bW/2cdCSrVTzUWhQjfxmsw9kEnH2hxtr4RGh5/OwxhSbE2COGcc8vkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_11,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230001
X-Proofpoint-GUID: Jb6yT_rOu0HOl2sX57o3i3Zmh7RjbowP
X-Proofpoint-ORIG-GUID: Jb6yT_rOu0HOl2sX57o3i3Zmh7RjbowP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that vhost_scsi_clear_endpoint will prevent new IO and flush running
IO before dropping it's refcounts on the tpg, we only need to hold the
vhost_scsi_mutex while looping over tpgs and taking a refcount, and when
manipulating the tpg list.

This removes the vhost_scsi_mutex from vhost_scsi_clear_endpoint and moves
the vhost_scsi_mutex use in vhost_scsi_set_endpoint so it's only taken
while looping over the tpgs and taking a refcount. We can then now avoid
issues where vhost_scsi_set_endpoint has to wait for another device's
vhost_scsi_clear_endpoint call.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c405ab5c232a..75ea24f1c571 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1540,7 +1540,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
  * vhost_scsi_tpg with an active struct vhost_scsi_nexus
  *
  *  The lock nesting rule is:
- *    vhost_scsi_mutex -> vs->dev.mutex -> tpg->tv_tpg_mutex -> vq->mutex
+ *    vs->dev.mutex -> vhost_scsi_mutex -> tpg->tv_tpg_mutex -> vq->mutex
  */
 static int
 vhost_scsi_set_endpoint(struct vhost_scsi *vs,
@@ -1554,7 +1554,6 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	int index, ret, i, len;
 	bool match = false;
 
-	mutex_lock(&vhost_scsi_mutex);
 	mutex_lock(&vs->dev.mutex);
 
 	/* Verify that ring has been setup correctly. */
@@ -1575,6 +1574,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	if (vs->vs_tpg)
 		memcpy(vs_tpg, vs->vs_tpg, len);
 
+	mutex_lock(&vhost_scsi_mutex);
 	list_for_each_entry(tpg, &vhost_scsi_list, tv_tpg_list) {
 		mutex_lock(&tpg->tv_tpg_mutex);
 		if (!tpg->tpg_nexus) {
@@ -1590,6 +1590,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		if (!strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
 			if (vs->vs_tpg && vs->vs_tpg[tpg->tport_tpgt]) {
 				mutex_unlock(&tpg->tv_tpg_mutex);
+				mutex_unlock(&vhost_scsi_mutex);
 				ret = -EEXIST;
 				goto undepend;
 			}
@@ -1604,6 +1605,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			if (ret) {
 				pr_warn("target_depend_item() failed: %d\n", ret);
 				mutex_unlock(&tpg->tv_tpg_mutex);
+				mutex_unlock(&vhost_scsi_mutex);
 				goto undepend;
 			}
 			tpg->tv_tpg_vhost_count++;
@@ -1613,6 +1615,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		}
 		mutex_unlock(&tpg->tv_tpg_mutex);
 	}
+	mutex_unlock(&vhost_scsi_mutex);
 
 	if (match) {
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
@@ -1667,7 +1670,6 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
 	return ret;
 }
 
@@ -1683,7 +1685,6 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	int index, ret, i;
 	u8 target;
 
-	mutex_lock(&vhost_scsi_mutex);
 	mutex_lock(&vs->dev.mutex);
 	/* Verify that ring has been setup correctly. */
 	for (index = 0; index < vs->dev.nvqs; ++index) {
@@ -1765,12 +1766,10 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	vs->vs_tpg = NULL;
 	WARN_ON(vs->vs_events_nr);
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
 	return 0;
 
 err_dev:
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
 	return ret;
 }
 
-- 
2.25.1

