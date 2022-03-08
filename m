Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CE1C43217
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 03:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242251AbiCHD0z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 22:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241063AbiCHD0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 22:26:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7408C2B261;
        Mon,  7 Mar 2022 19:25:59 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2281wQwA022315;
        Tue, 8 Mar 2022 03:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VevA9N01CbuP/IdlhenTljt+JAHIQp1uQh+9EQfRITQ=;
 b=AFaOzZs6W5gUbam3DmK0D2xVP8Xzn9SAasMST8OBNxhCOMioPOKowJuJdWdGA9V4FDvo
 R072orUCajruOn+b5+xYhACMoUKpwPIPc3XIxlxAfpxsPUfteJ4Tn49qAzKJUMUpbRwS
 ujlhoR2nK8bxUZlvkNga0ilzm8RFnkQmGX5VrbxdUiolMBx45q/a2lJBscV6XgcM9JVt
 tx1umOvM9gy7NMV2n2csjdWvBNhN0MryltiQY7/DtL71E8efBYceOzqIQwdif0wTHNoP
 WOg3M9wnf8C87D58UPSVZvamLwC9utDuVNa01iOJ8Ap2XTVBxE5SefQiaBYRXnI3OqQF vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0nsqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:25:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2283P8QG191496;
        Tue, 8 Mar 2022 03:25:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3020.oracle.com with ESMTP id 3ekyp1qh5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:25:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKVqHFjc/+3mBN49N5i8xqNtIJXsKwX0jeCq8dwQD2XPVxbjMtYEELHRiTLokYOEpdBMx4BvlUXQvv1DxCR07XCiIl70Ds9HhwytcrooiCaZuTU3Q8tzf/9Fb6S4BS6FlCpaoylFhPbrFzaUoeykoxhHHRUdB0czXe4QMvPHkndRja/I3o1L9nm3RkWLUXZiX2I9YytsfeBWoNWgvegqjK5pXZlxHkbrt2NVSG9CFOyQZ6PZbPwI94sECBBd1PLTihUFaG4LWbY8LDwcYog0UojtSrLX2cC6+YitRVfpoi1g9DyWupAWKlsS1DQKeJzm3xwLDmpJy3pKDLY/VDbXDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VevA9N01CbuP/IdlhenTljt+JAHIQp1uQh+9EQfRITQ=;
 b=I/7kl2dUA1Hou/TxHrgkHee+V4awIp3WF5UsX/ugVuiJumNx3LYDXdaXVg7tlHD9ieTpXyA0PUH8nN+jXP0EtwJn74MRT8SZUnGI9wxv39EdrgPkAo20fGLj09T0zBEynqgU9wngB9wYYHOhH4MoGm2+ss6Scl85GjcQKtqTC/lHGxoWYve7HFJ9nm3Bsqf5+s8jPtYXqWmEq96uEWt69bIdkpC2AZdNUTNZImIAIihCkSSoVbW6XFeF8Xk+jOaIR2JF1WTTR5tpc9URL9ida6uBRpjYjT9p8aV8A6nWvZx11rwngiA2grmkb4su62WJ7rIaw0QXj05eyWAcWpQxHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VevA9N01CbuP/IdlhenTljt+JAHIQp1uQh+9EQfRITQ=;
 b=BsOXZ7Crs4aRQip9GaJCnnoRLxySY+TfHnpUXmPykH3ugYfmNPE7iOfzrB1UBHHMJukxmPFfU/uyaM6qqECGavenR+aqBD9f49CizFk2hbPyIylZbBcRCUTmwJ2G6Yd+lN3Ic9FunBEEYYyUVAygH63StsKTPLH5wYRZBmoJhts=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 03:25:38 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 03:25:38 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 05/14] sd: call sd_zbc_release_disk before releasing the
 scsi_device reference
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r17dp1lm.fsf@ca-mkp.ca.oracle.com>
References: <20220304160331.399757-1-hch@lst.de>
        <20220304160331.399757-6-hch@lst.de>
Date:   Mon, 07 Mar 2022 22:25:35 -0500
In-Reply-To: <20220304160331.399757-6-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 4 Mar 2022 17:03:22 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::17) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61820a2a-3571-434e-eae7-08da00b350da
X-MS-TrafficTypeDiagnostic: CO1PR10MB4481:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB44810F96E2EC1B1CE317F3A58E099@CO1PR10MB4481.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J++WLtR9CUfDgKsLIdG78OThnKp2Wz+wM5saOXPPahYUsPUI5EbI0O10MfGYB62vOrF9/HM9ycOGRyjrXH+lrOuCYnKzb40fqRKVsoGJE/Cqo6d3v3Ututr2zZBWRY680cWiTi4x0q/DZJCpziXAGe0UvsTBWepqJ/qOc8Y/CTCOkbwH4TmoY/x/KXALdry+tcgX7j3qTtnyGLqQtZKAgVHbNDipMGQIQk+di7UuFI0QfsTXzbwN5FxctPcVhxUL+Ucxfcu81//MEeBXiiCN1cozqEimCzipk1BtEe+9XQGSkzSIhT3lWRKyTmLsV6a89sZM47ohsuYfRVXT2GrW7rbD9NZdiJN0TtiE+idcGkE6ty6J8unB/jI3vwjWcO4JLllrkOi32vcCQIEkGdVDlHdFccwBJ6fZLJO7o0dNHMAkZ8biEMuiqUnkvXB+1DZw1dun7u0XRAJo4UqVizZZUSOK/tK9Q5+R+naY+R3xg4lRoU07oLdYtLBbmfa0EGPtu+v1OyF70z55LcckPCT+6UlNg4V7occ9DgU3UbFHiM/cRjpkwzw7tGo5uKFbrRuG45OnXaCvGZ8KC1IiuDMs5Gb+PIGp37Oi6HXR4UtksSM/bLM5E8zYIM8xraCYYEYP2A/R6L9ISMZfh+G7Vzv3HRL7T6KwtIpBt/nz+bdvbwefT/u7bsY9T4V0kMg3A2nhTm9R4MwkqBiMF/MooByIZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6486002)(38350700002)(8936002)(6916009)(54906003)(26005)(38100700002)(508600001)(558084003)(5660300002)(66476007)(83380400001)(8676002)(4326008)(2906002)(186003)(86362001)(66946007)(66556008)(316002)(52116002)(36916002)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QVegJUsUlIlKVwo0CjoVzgZz1VUydYXRDYSB7w1Ysby9sGq+8ZZXEZJkssX2?=
 =?us-ascii?Q?ry7UTox9anQnMyMIoEff2rm6a6fvn6dJa2NsqcqwOxk6TKCRRlG+wp/mj2tK?=
 =?us-ascii?Q?DvyEZZd4TQn16tFb4y8/+wGFoFacmKAixa9X+rwe+Lt5iOOeWdqSOb0JpZxi?=
 =?us-ascii?Q?0RCRz2gE0ABNLk43Pg9nvC88FEjpLWiGKaQaq0BDncm+JT2tsZ3CANAT8uTX?=
 =?us-ascii?Q?xguUq70rJzltLlcIjjb7aQX1OIyir/4MSAH4vJdyE5CC0pk6SYRDkVF7wt2Q?=
 =?us-ascii?Q?LAIKOBchpU63Rzt9MRR1hO5+P4z5YjMw9EfqJ9vjxSMoSfQt8b/oU3LSSOz4?=
 =?us-ascii?Q?YvazStnGOkw91LHfjhO8s8GqmR9fpKYhGqFnM0HDSN62XPpAlrjIatOoTJjT?=
 =?us-ascii?Q?XSpVGpF4MJ3eG6jOgzpVFH+VoURqvOVmHwfAIYOehL4EYfYrPX84Gp7hT4oE?=
 =?us-ascii?Q?KEm2b/E6F6ajGgk0F8EkB+mDDW/Cw4GV99xCW/TWFNL4qntS1Xn78daCRruz?=
 =?us-ascii?Q?x68afvmAkAPUcYrntZ8zKeCNfymMqKgshM0u3I7KknXFamWFc6wAtnvgf6FQ?=
 =?us-ascii?Q?Pos+cn+3dBkMRTSPXanu/1F0AM+omV/3meH07joc7xP46yjamJTJg6SbvNrw?=
 =?us-ascii?Q?HdhMOlxU3FxQuVat4jbGUe7a31ZdfyyCd+mlTUYSBZkuWWfSBjrqCHsnpBeh?=
 =?us-ascii?Q?4qgbbnKzlCQ+4nRo5OnInXBbVmMie3QJDM+/qTxq8UiqnGZb2ZPmCWnv7Yb4?=
 =?us-ascii?Q?lEHN/oLUDC+p31lIfejkLteOwQ2XIzMlWRliyejnhK6+tBHDrCmKbkMMNhrw?=
 =?us-ascii?Q?dC0VcPo4hzHDKIjqA3+SM7CQeAoF4wSLHZFxNojc+YKjuv+OwCmfUsbf0SvJ?=
 =?us-ascii?Q?Kra1lkd+bA8E/B5FaStl5EYQFrp7u/zt6wsWMQ6/+tvqBUshrcyqPnVRhn4d?=
 =?us-ascii?Q?Rb06z/ch3C1ct5XC6AlihYA0HHLYHWnmphijJr99BqgcYsP3xSzwY+9FsQmI?=
 =?us-ascii?Q?kJ5yT2QRicqCGvVTVQWrrsZR5McDlI/GL6NO8202c7H4Ta27Dk2e7NUaNaiu?=
 =?us-ascii?Q?KPlkt08d3LcoofgRICbeeeMxSZWmtnlfm/IYTNJyX8LpnY5FXAxeqLUPppWz?=
 =?us-ascii?Q?oNwBRues+4x1KSjJhK8+GRUo7sATleW/vWWogQQ7Y3MBIQd19nXY8l34HWyZ?=
 =?us-ascii?Q?wdEZAzW6MB6ank9zDGDVxWVM1zMJjuzZyT5Ij0NK5Mk7xN+zgj+Yrxm+wmMx?=
 =?us-ascii?Q?tIq31ktFU2eiC0hfIJx6yP4rl3VREHfeDIzX5EaQb3ZykOrcu1BqQDzCHuf9?=
 =?us-ascii?Q?pVx7P4ZkIX2+7uKeZ41gZ2T4FHsZrZwuMyddN/hplaOJETseTOD25zR2U4u1?=
 =?us-ascii?Q?SYHEsdXqJLwXKDI4romwC5+VCgA0eONUrx2XEXoBUBOY8VEtk57wCv7O9PXS?=
 =?us-ascii?Q?5yC/QYTKxFg0ls+ar8oVDoQzo0j50gUTzBwsTk+80S/en/f1XScQL/Ez0xi8?=
 =?us-ascii?Q?Az1NMv6hgZmw8QPLq0GP+cMN+BPOcY4l+QGjb6HVgMmRpQTSB/DvbcFuL9F9?=
 =?us-ascii?Q?UmkdBG68tPDfn7MzmC4k5+LREYAheCHtpqpawbqsWFzTzYuyxmJj4HwvvY/g?=
 =?us-ascii?Q?psWSVvsr1cesfz0rxtQGPZCltFlNhg7V6ZutwJk6L21ARPIBGkt2RBHjpwxH?=
 =?us-ascii?Q?aaia4w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61820a2a-3571-434e-eae7-08da00b350da
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:25:38.3110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lAx1VqJCUj9j9rJBVaKgjH8siELuzXVkBIpqzRYMvFhDcTe3FOvwVWelZ5uUwSAP3mxDTnBq/9rQ79sROzpcNWSmXHeZwvZ5yDWYx9agmd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=974 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080008
X-Proofpoint-ORIG-GUID: wQYB_gzcwoMqrFGvgMtSxBas5uCyOhaT
X-Proofpoint-GUID: wQYB_gzcwoMqrFGvgMtSxBas5uCyOhaT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> sd_zbc_release_disk accesses disk->device, so ensure that actually
> still has a valid reference.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
