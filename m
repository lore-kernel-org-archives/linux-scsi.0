Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382B7FA3742
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbiJZXXQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbiJZXWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:22:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57CBD8F74;
        Wed, 26 Oct 2022 16:20:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM1x84014791;
        Wed, 26 Oct 2022 23:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=g3qt/ijaZ+vHsvm3aqmwlHBCXPA2Ke6nOsYikt2FlT8=;
 b=xcIvLiBIq0OccPllY+k0PBUBEN5avkPSiEi+gViN5FbbiFEnZGbFG1KIxaAfLTnjElz2
 +feO1ngZPz3wl4qaqJnjXZU6Wd8RmYnkeKOCSdugIUHiP/f9ThfF94NXQvtqVpwvM+Hi
 mZF2nG7OGPLc2msyCKszLYBd9vyzfwq2A7SlQ030Pv2qO76c+Z5AqCn6IC2hw5k3VUT8
 sE60mOKVEX/WJYn5h4UcLeOdejUs2eUlExS2Q0yGdtmT/25kFTHVpRgHRnPa95pYdk/1
 HJ1qWXu0kvgtgdqtU6FYROQVhOzo8g/OoNPb7HVW998nJvF6PBq8Egs3MhS6DLYYxmu6 dA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0jew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMDn5h006678;
        Wed, 26 Oct 2022 23:19:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggdrfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNAfAfFLgD1/F2y4fQYBeTGK6Giswwgscy59Wl6nbDGN4KwyhPSJAjbyoOpg+zLlRp12fL5aBxHTOC9JuuUmQFe0OkeXcKtKij5KEKnrD8/0/bX8UYtwjEm37kwBCgaa6aVJpfNJyVEUE7JTHRxiz86838k7O7iW9ejeTD+R76nhELN+uU/O/9pXcX8w9q/gz5qw6QJgdpjqiiMUfzWYyeNSyklDe6Fk9NJU+0npFI2iYETgufW34qCkBRJQYZr2fDb1OXnY3uHP5clVn+cG8ZrtQFNNBxpwtxhXEgNRMmk9LwspEMssmW7kcGL80vSdmpR29SeDiDZ5LkznkvDKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3qt/ijaZ+vHsvm3aqmwlHBCXPA2Ke6nOsYikt2FlT8=;
 b=ZgYD1rsrwRxSK7mZsRDrJe71YoFbH/ZOr+0exuBUHJlqqLhh+43Ot0/82uzZOi482prBuUP4eRKQV+miWBiUJKNzSIeDzGl31z5X+QYHRwJz8p0cXJ52a27MAh6nbajJjeqxvDP/AOQG7ySAnmNDed/MGJVAM7B/SN3vCH8hL+BsYqqHB4Q2L/ozJYJL9ghixjdprLhIXl9Tm2nA7SFd7lVRTqbHz7aWV6oaYPSBeLAcKMJRvAP5pqaNcyftzsno3oSh4+3i40wEhH1X1mwDaWzuaCZNdRvuORJEntb7b4ntMVGcWFKpnCwIrVmBZH9tFSk1KAmpURU9+I6x4otjKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3qt/ijaZ+vHsvm3aqmwlHBCXPA2Ke6nOsYikt2FlT8=;
 b=WP3VgFqVCnCzrAbTtZaLwvVrwdJB4krIX1Wf/Dzx2uqTgUA6MhJgn3cATxfyCpMudKYnBFMQTsDAc5o7lYtLgCDBln/4Xd9QTSngckxkvSb5T6NnnygjwRz41vY6kNfuyPsH49z/DjW+2Y8cWo4T8/kXvx5d/GPzlWgVxvL6R3I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: [PATCH v3 00/19] Use block pr_ops in LIO
Date:   Wed, 26 Oct 2022 18:19:26 -0500
Message-Id: <20221026231945.6609-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0087.namprd04.prod.outlook.com
 (2603:10b6:610:74::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b2b374-a0d8-4ea2-4e5d-08dab7a8934b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuJ3Qj8k073tqx5GED3nHgt4uCqAFrHeKb0X5IR8lEFjMZgLi0+Tk0bWwRqHTBcn1pRPREng7wsXa/1TdCiTenajTN8c+Sss/2kCpI6irGsJcvEwZiFoZDSr7ll7q4mUyv2Egr+kbfuIPZekQr8jVzM8cG8Hce5g2g7YhYzSoW2SVvOvLRPpfdGiFiKYB+3KqGNqFkM8CWUcv9tmq7jWEMkJrvHK7NDwwRHSVHpcvXSwpJ2Ga1pFAQ3oFjHRrK36y3EftPlWczEeDKSHFhvXG7k6g484wcDKewJQ5aKfc/xKsaj9LEgoSXQyAHRkB0/o7JmomuAZbqc/tnNBS3YZL5RNtS09+uwnx3wmA0qzo/ASc2XdFD9IpZB2RhSOsmOhEywPOW0xor7uT256seqcnGPlQTGqm2E2hxbyfCzLB0dYBbKzTi2/ROVj4M9eZ5d3LrOUUCBYA+Vk94kzTaNFOsrgwSvfhi5c0aVK6u5A7Yfws++d58StWRdqFxjLB2y8ngbst171oEO6Xjr9WYVsjIE4gFttYhfmnYeCBmKSdCYU5aFUIt8c1AvQI3HUa2+e17JI+uLRfEsvOzJRD6et90oSmi9bettcQ82SEMcNuk6z5iaG5MKdKgqv9+rtMlBz6h4XPgylZDV0++/L4k8LSb7AnIxf5IEi+bQVrbXiP7ylRGe4v110vgHc6Vs/KwibDPKt9xhZLRjbubkRxCe0ed50sDAyvRlQq1aaNhJZeG9OFQdbK45494V2pE7CCeSdpjxNemTNUxusvVxEywOrCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(6666004)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(966005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zqmv+61QPhzch/kSKK+EoRE9qZlFfa/Z6ux7+ZPpFR28ZGYWplm5qLGBb50+?=
 =?us-ascii?Q?BUOVIjS0itqvvnEQgyLng+MI3dNzxg8n5lZHjawrgHx2WDB6q+jODMpgishe?=
 =?us-ascii?Q?bVLyFTtqVcsTkVIQj+KLbsWV1wizS7RQl2uJF0y4y+tBmdZ67N+AtU18KIQW?=
 =?us-ascii?Q?2YERt5z5W0Xt2/Bvy0S/UY+GrXz2jIhHtwCSf3bE/KPlKycPrwG6U7OmBSN5?=
 =?us-ascii?Q?4OiovaSgXj1ndlHfhmd9LhS8l/2csz5Z26zVTvQqGCQDzBHLNwkDo6HWc/bP?=
 =?us-ascii?Q?Rqhymq46FBbt2hVkWD+33oDeLtcDo47n+xEPXOohC3ae0WGOlhTdczC+ODNJ?=
 =?us-ascii?Q?y7e99BQ/IbifJPR6QJjQ68wKygazN+xKRQdgc6j/ACA9ZIXRnjzQTuaezcFq?=
 =?us-ascii?Q?9Lk42ot3z1hag9FLhI/+3GyFmLbbEsww9ZnJt+OqzZydvhhIdY9hqdnGjydU?=
 =?us-ascii?Q?SOMieyhKb5TU6pPDKiK0vxdDwJWCHHLYiDdNY2uAm2SH36ovHDCdHPbd44Cn?=
 =?us-ascii?Q?4KfwfQO7QJ69MJPSYNuBSuRwSoO73ofTEgiOD7AbMUEaSgsyieH3tqOzAsly?=
 =?us-ascii?Q?bTQHA3WVbDD7avH57civbSiRWGUe0ZJWLKdVrdqzKFF5iWDFTECNIE/ien/d?=
 =?us-ascii?Q?eZnsLQCfatoaQ82a/3MZfkHhHhknz66/HVEu/Xniekej54XuoZ58POXCJ85K?=
 =?us-ascii?Q?0xr3UQgUrxAc54dwLudcykJb8/PrAjH1w3CGeI/01lTqNHpRUYQkGobJl+wO?=
 =?us-ascii?Q?8InmBHZ0VjcS7QZmKhiuLfJj8njvVfZeaNm9xlzdNN9j4cKUSLIRofZWREt9?=
 =?us-ascii?Q?oLYIYW/jVN9b02QSAINXz9vjM8BUCTWPk/VROu++C5i0YnroqC3Avt+7CA0N?=
 =?us-ascii?Q?/ub/UHgZOL8v0VXqNcuYdmif8/kOvat6QBsUnNJdaqLQlLt3Sy199oMm3XHo?=
 =?us-ascii?Q?CjOBHZHjeOca2FU3qj/53i7RLH8zPA5VU1QHxpajjubVYXoTkMqwTjDLGUyw?=
 =?us-ascii?Q?5/kWfIIaH9qVmYCdfMBNzpF2U4ibns0t1BHQnomOXVJUZp6al5rxWBnWUAd2?=
 =?us-ascii?Q?PLe+7i0ul7zwnvBnlfm4M7PCSq2y9uxzGSaPb+w4VoxTkZpz63M1WRSiZ0QB?=
 =?us-ascii?Q?wmQSH188Ovnb4PXRRXdpP9Vdqt60qanblUE2lbC3TWN5BnfWKnTcLKuuiVtP?=
 =?us-ascii?Q?vnN0G4rHIdrhebZeoCwDxesUWa724wSGoaYj2govzQMAJ/0wv8Jwd0rbD2s1?=
 =?us-ascii?Q?EbfQye/O5FamXmltLFGp08Oklhci5nwdoQ7oy0jfhxq8oD9VbHFbgdQpo0JC?=
 =?us-ascii?Q?ra7bP/85YpmWuf9REmiW/HFUjmNtMEtkyhG28+PMwN92cBP5qRslGuq8Ms5i?=
 =?us-ascii?Q?/j9qnV+qdl8KcNvvxOzzZxrdW0FYVGcAn0G7zWkXrOewIcOmGnaqroFxNlof?=
 =?us-ascii?Q?4+vaU0Do4rYiNASwpm/nc27NjxdOY1lW6VNH69jUF6r7k/Yk/XWmKtDQ+DOz?=
 =?us-ascii?Q?a3hlxuVMtnmrJMHjYtV3C7KUMVENkdSRhbmSePKvsWc75Yh6M2tfNll/ffAJ?=
 =?us-ascii?Q?E2J0oiD/jLEbExXuUu48KpnGxEXN8uK6rs7A+OjSK4IMtCYhvUW30PQ3Qi3p?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b2b374-a0d8-4ea2-4e5d-08dab7a8934b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:48.2264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EcRHH4EfjEfTwO8qIVLa5JVuGe0XH9Jkcyvadkp1bTvALka5RmSfCKIisR24M+JBKcjZX7dU55XFSuG612BlxVr3pvVbbtKDnnhVfGAbu+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-ORIG-GUID: L1-gdQRgUE9BRo_Rc11VtCf1xg5mh0CG
X-Proofpoint-GUID: L1-gdQRgUE9BRo_Rc11VtCf1xg5mh0CG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were built over Linus's tree and this patchset

https://lore.kernel.org/all/20221023030403.33845-24-michael.christie@oracle.com/t/

which allows the SCSI layer passthrough users to control retries for
commands like PRs used in this patchset.

The patches in this thread allow us to use the block pr_ops with LIO's
target_core_iblock module to support cluster applications in VMs.
Currently, to use windows clustering or linux clustering (pacemaker +
cluster labs scsi fence agents) in VMs with LIO and vhost-scsi, you have
to use tcmu or pscsi or use a cluster aware FS/framework for the LIO pr
file. Setting up a cluster FS/framework is pain and waste when your real
backend device is already a distributed device, and pscsi and tcmu are
nice for specific use cases, but iblock gives you the best performance and
allows you to use stacked devices like dm-multipath. So these patches
allow iblock to work like pscsi/tcmu where they can pass a PR command to
the backend module. And then iblock will use the pr_ops to pass the PR
command to the real devices similar to what we do for unmap today.

The patches are separated in the following groups:

patches 1 - 11
- Add callouts to read a reservation and it's keys.

patches 12 - 15
- Have pr_ops return a blk_status_t.

patches 16 - 19
- Support for target_core_iblock to bypass the emulate PR code and call
the pr_ops.

This patchset has been tested with the libiscsi PGR ops and with window's
failover cluster verification test.

v3:
- Fix patch subject formatting.
- Fix coding style.
- Rearrange patches so helpers are added with users to avoid compilation
errors.
- Move pr type conversion to array and add nvme_pr_type.
- Add Extended Data Structure control flag enum and use in code for checks.
- Move nvme pr code to new file.
- Add more info to patch subjects about why we need to add blk_status
to pr_ops.
- Use generic SCSI passthrough error handling interface.
- Fix checkpatch --strict errors. Note that I kept the existing coding
style that it complained about because it looked like it was the preferred
style for the code and I didn't want a mix and match.

v2:
- Drop BLK_STS_NEXUS rename changes. Will do separately.
- Add NVMe support.
- Fixed bug in target_core_iblock where a variable was not initialized
mentioned by Christoph.
- Fixed sd pr_ops UA handling issue found when running libiscsi PGR tests.
- Added patches to allow pr_ops to pass up a BLK_STS so we could return
a RESERVATION_CONFLICT status when a pr_ops callout fails.




