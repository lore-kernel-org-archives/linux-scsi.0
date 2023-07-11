Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2F7EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjGKVrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjGKVq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:46:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8CC1711
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:46:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDGv8018412;
        Tue, 11 Jul 2023 21:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=HvWRYAMYxA9H5i0Fbn3/YEudh91viyA8ScGquI1LWRc=;
 b=ujiDyc7lqpD9qx78Or9b+EQnjM3kSU5/gqh9tXQcj6M86SD+2HzOiImlZ09OtrT7BSuq
 +9PKpPkqx7JqogUqQq/7PaJvjJJuiVjxgK2UBn8LibVz6scYrzWMnor454GCWEanph/u
 9Ff2C1fge2Pq4rpFOhf21ZgdEG0exTaUpwOEqH/f1Vhy5cKxiIWy41q64uceCibD2xz1
 7S9YT6uzIH9zRh8dWrfVQcEOu4AMpcAUATuzMngj0Lc2RALoOQT5lD6QrmX84JbSJfiL
 xAkTpf6+KU8JTjdbKaHL/ZqmRY9egE08fW01OFj9Z6DMk195T/BvTYnyO+YROeDPsQgu cw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydtwxyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BK1hBB000797;
        Tue, 11 Jul 2023 21:46:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd29sh23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9tyrsWQghqrn7DDt2FK0FPGzRzzibBlrvG/PrHQMrNooOkmcc6NdK5hie1V/bF6fjJ9OAc3oyNbLOjGl0lWokM/oxRlx9ZtSk2vrkJi+QfhvosMMls9f3HCzdiHN/ijDMG+TB6p5QwxrDOrnGPMNMtamgMoJSUtCg+SPOThsLtHysfKS3fBvM8/lng0LibXLkx1z0dfntN8F6uZKGPwuus9i+4BfauIj8pp2kZpb5ljrm56MExot2BI3GfqyfRay0oJNzELViWkuWugdXO+Glxc82g9vuYbkK86ISvdV+D/ooYljC9CJBDgxjzsYJlmzO2dy9JI+iTl9xq2lLOJbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvWRYAMYxA9H5i0Fbn3/YEudh91viyA8ScGquI1LWRc=;
 b=eiKMCxnhG9azUfCcmDsn1AhouO79kD4301W9kyyKFWU3hrH0JF48BL+LE/msHh0VKJKAh5Efgc8KajCTerWlpGDjWQS3ttwC/2I63oCjl/wKu1Hfkt3MHCgMhh7cYwa/t5KWlOAOCHNsOvPffE129CAnKH0BhXTRBSZg8LxgNTiH9kuIal3Yjol9Kt60a6eTlziybXN36UbcA3j62jsOvFC9O/Ki61CCXFvTlnf6loqY+P7gTcB9lAH30umY04MsRT2kAyobCJLB6IC5JKXtXKURQXqw1QqJ487bR6TTyGKPBYHF/8jGNKsKQSXo5WxHbsAdXVt70R+0yoRoXJfM3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvWRYAMYxA9H5i0Fbn3/YEudh91viyA8ScGquI1LWRc=;
 b=xxPv7Ifm7d8VvctkzrPHrPbeT1OWagAbqRvHzPBdM5ErgO3Bn6e1RakowsXFjbh0I1+n1spEVvF+USUHTsLW3uL5U0vyGcWQiePBzh8CU7t0GDxZ9084hyf9x+Zhn1HqIMvvYH0Xxbocam+D0Z6013dQwflAGYFAcEDln4jiIZI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:37 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 06/33] scsi: sd: Fix sshdr use in read_capacity_16
Date:   Tue, 11 Jul 2023 16:45:53 -0500
Message-Id: <20230711214620.87232-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0059.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c857e6e-58c2-43fe-4ac9-08db82584d98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l4Wz4eo1kTWjnMGkdeJ0tqNEzGQV4yx7UWxIlpCJT+j+Qizc9NCTruOT3bzrkRYGXPx1na3+M/GTDfb3nNR2QiJQg+ldUDvsqpOkghCtyYMsclzRlhyNhbdySseeUVBnuEVPpPXerb/CWNjPLORhOtWnb3bUOW27IRWvNKrV/bq0bOoNnVN0K59cU3Tx37zhiSqu120GU1CtATBCLjT2j97gTxP4W8ZYVZ0i1fz+iTdN/1HZEgun8twBb17p/E+qflhmR8Fm7kmHdwOSnhBi/cCPGqU49BDkO74EORDjaiCacldXVt6SznL19dtgILBDTCjwqbEn4MJPtzeYOX09ZH4fBxSbCJqp1Sz/lIWSUnNWzFsqkFWMmYWz8vraDEb+LdyLUReH5VuGWbLXsloHmGaaKqBzA51K54UqMWYrghVYfOi39FkqviGY933UfW10iKKG3S7VneFQmibc+qjc+4fxoQRIzY3dW7TBKfVzLW9NTzVcfuz5F1UBxdM/w2YkDRpAB9AIKM8Jhpgm4qsde0NJSlXDYVaeJl4Lg62ORNk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+79tpuBP6APidu1hoV59/TaHychizmYaoQK3EJQrQsnYsyVH3ewdkc7r/49Y?=
 =?us-ascii?Q?zY3oqWg4SHaFd40KoxjZYyIe6XbBXobqyBB8ke9kt2QPOid6f29nuiUEMYwb?=
 =?us-ascii?Q?BCWUVaXpXjl30z4H4NvIy7WUQOi1tCn14KKPyt/D5FDWFxukWVr7S5uCkpeg?=
 =?us-ascii?Q?D7fuZS1cIN/TVxerv54GP4/l41hvL7jMNz3OCCS/8vfve6Ia2w0YcH6q1jno?=
 =?us-ascii?Q?jG0r+CqVqE+30n+ohx+HO06F7zywlkHKlsKcMnAOqt5DLR4P7u7Y91TAfD0y?=
 =?us-ascii?Q?MFwpWquOEe4n2konHQQss4cQZtGyoXb+ZBs438SwuOaMIfuH5uFZI1vYoT3J?=
 =?us-ascii?Q?9dSeXJ60yZGdj675Ax+ACSqoZf3ZjZQavvdYZw+hh8U5TTdDyPuIcpIPXgZe?=
 =?us-ascii?Q?qr5cNvYSzpkouXH71jUo0K4i24PCeW8la1Pmb7Hvfb0DUMHkxmqfwsDN77w3?=
 =?us-ascii?Q?RKrRLzVHJayzb6qSv5SCl/bvI2aLAQkb7aVNojkrhi/fd+kZNF03wSBs4d7y?=
 =?us-ascii?Q?zXrXSxdyiIF3cH17XDrgKyfHbiwetvfCdVJoA+a47v/WukCQfbR2F7A3KbJo?=
 =?us-ascii?Q?VJDL+b+Knf95kwhC1muE7qWuhylOFx1wN/gue8h4dRULaqu6/ogpJ8EuTU3o?=
 =?us-ascii?Q?SbCp7rKFrms3LR3RWppgaMdV8Pl22PRB2Rs2FbKzNrQSiTaOYnJURB5az9+A?=
 =?us-ascii?Q?wByyrBLcdYVY9Ibprkvd3Sdv0/SrSJSRjESP9rgUN5AD6vmthTuwWsNGRVDX?=
 =?us-ascii?Q?R5pWlsXVwGgNs7YUIUlFq+5Yn9DjyXY35Cv6Hr+hYKuNOMt+uQsHkpQz6fn3?=
 =?us-ascii?Q?2czcBoifNGRntKF6W2HVk8MYS3b7/rDTMfoYMJgtnHxe74JqcDC36BJ04lya?=
 =?us-ascii?Q?LQhsMu8eZrWQvYFA++st0MY1/P0bf4O+9ZiKXch1c9cg7kZ3AYJ3Nkcr0eHz?=
 =?us-ascii?Q?I4CegdChXkev2D1PZZAsl/MEqytBmAxujwUia54Jylhk9VsP2bw96wNQaXnY?=
 =?us-ascii?Q?vrLSiIO11103PEzq9VGgGAFecyN+BTDfY862EtKTs8IRYSGcOrrP6oLXQaR2?=
 =?us-ascii?Q?EsZJv7KJ/ZqpwDFvfYHlaoRKPAOwNKlaYcCPSX8+x7riu4Lpyn5wxfSa1G5N?=
 =?us-ascii?Q?DOiaG6uqBu7pPuPRRgPLrbms8aQJ9WEfFFov0RXd3sM/aew9NCiccOolEAi3?=
 =?us-ascii?Q?NEbbubHJoT798noltvKk8Kv7OqAem3PKojrtnw+9Ltsr1gHELjUDF36uLO4B?=
 =?us-ascii?Q?dzIUqP4Rr28G5h0cgRCyq4xSyMv/WGSO0ioFgQlhyXkfkORwaA5sNJVBipu1?=
 =?us-ascii?Q?FrQhPZDM0ZSrnlyBfxKvFM2Z9YSnrmKGzaWtkEJrQlnKm4pnkOkTYjtg3PA8?=
 =?us-ascii?Q?9mE9U+Mtdw6R0FooIXhMeEsDXLIBHnYwrcrdUj4NoP1Hrdb0cSxOmsnwVwtG?=
 =?us-ascii?Q?Gimf6qrtZ8FaG8ZvQHyajHaXuAyjSRdYOVM6CrPGhguB6l/wQwYVae3xIiFD?=
 =?us-ascii?Q?K+Xqpkee4tfALBrKGBMhQnm+kqZOEJebhNNBd8jjbZoGv9MRGj4kE+vvDJAJ?=
 =?us-ascii?Q?0QdoSDXEFQhguIq28FzHQbaZoUqF3XZXe44xhWP+nNc0Es9WUaGvgz4mvhRS?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7h1q/fvZyZsbOGXeZk5z/L5J0hzmKJOOSvYvXtgkMDFcejSdQ0Wh1GbfjXvUc3qGX8UT81YuIplaC+xcA99qbUyfdQ5iq9WjpX9NW1rynsE7dWrKwVpYdY02r+90p19f4UyRw4j1MUI9bulPXLDzXz0ZN/K66ajpQUfv1T6aVfE09HdEjSHKAhwTLawoovpl38pvdgGuiJfaLxWSVY54FxK+uw9Bno6UK9V3xnciG91JYrGYpvbzI4wPz2hy40qgF+wvM1ygkTSsP5lWHMQY9wZB0k+ijRCCf4bI25zZqoig9wSz919+yPVT7xmCCAtomUlBYtUzXcSWtm+rqH6MTPTsmknfGXIfAJur6kIvWYz3BMXPt2Rxksc8DkDweHIF0Hvo9SSgpENGdkpxOTR43jR9lcwWXROBpH+Z6VRZU7tTmE+SSajGVQPH9iPtiCH26SAat8DTGVO5Ra8N+l3VjmyZiZxTLlhw17UzF7WMvGDZvywc2rNl7Bln9k3upF95Cxq6PfSk4ELc4fqsAz3lXdxFhij3hUZcfZ5nVb9Xe8lgSvWZNIdoXFSRy0Yym8PJJU/2BeaO+AzhX4EW+lGPask2U4nO5s34s3DQ9rb2wl/5gytIu2Xprqe+ZrFAa07vByc7jTpA9mX/MO0UTGT7I/2s+Hoa4l9NB0W9B4r5W1Gbbpoz2/4o3oSDyHGE6OMXQuvQTqoaHrxxLCtUVQvkCGAammcN6FKlZxE/UKna8lPLWAeu9/XYSeZ/e+7HcP3dPO5UQ1NMemScs0bICeUy+3r8y/q5bcB1czc4q+CHKsPaRDoN4/5vUcSw7MYfqHVJBV43U0u6kXGGIMu+1AJOQFfZgusg6UhqtdOrck1kU8vIJCB1n00mxFaQb+PQ4gas
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c857e6e-58c2-43fe-4ac9-08db82584d98
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:37.6009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJnWhLwWt3s+ybaUx6QvbBqIHRmbxAf9qYEjPVM4JyRtiehGMnT/XLAk2Y7PsWk+EbJ2KruVp/q1zgW4RAUBs5zhgG70kBdICu+qYIg0KXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: 86XQs_1uT3BSrzfT8Fmb-2B1lIrKq6kQ
X-Proofpoint-ORIG-GUID: 86XQs_1uT3BSrzfT8Fmb-2B1lIrKq6kQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 84edbc0a5747..a2daa96e5c87 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2428,11 +2428,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
 					      buffer, RC16_LEN, SD_TIMEOUT,
 					      sdkp->max_retries, &exec_args);
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
-
 		if (the_result > 0) {
+			if (media_not_present(sdkp, &sshdr))
+				return -ENODEV;
+
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
-- 
2.34.1

