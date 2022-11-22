Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89815C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiKVD0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiKVD0d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:26:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA52B23EB9;
        Mon, 21 Nov 2022 19:26:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3PV54005007;
        Tue, 22 Nov 2022 03:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Er/VgwqdkY1DGlRlbjJQSiy074jnTDSmfxArJvxyMCM=;
 b=knsvxqUWAQlFS19ITnd0//1N58cMk5sn++JRCi06KuHIFh2wihyj23w1WgW+UJd2wFh7
 GLhtDzy8cMGWpX0tWa/lixWeYL6KASLWo+2IThuBuyqQi+QByrq+z9Sr805EryxqKxou
 O48txQqa/m2uV1NdJy0EXfhCWubVKbat7hBPOVTpIxqBH7CQUGnqWhr5RvtdmZA131VM
 7K5qyHilf+Dt5RUzKgzoREdsLrfYMuwua+CRAUMl29zLnaQ4oYIF+KyLKxCHTNxB+ogZ
 BmJ+3H+RATcbIPVuixRRG+kIsdk2P5szIq6VzcxButDjQt4BcbXAIlAT2pq89BRavCcY 3Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0gas0wy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM0tgI8008247;
        Tue, 22 Nov 2022 03:26:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk46qyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEN9/twg7q52mL2V5onktMmYo9LGOVHP/O/tR2jfKzPtxEBSWA85zPkKw2lyh8yI+GVkPrTmdrmsPXTjNo+SL4949U4fwZMtwJMR/VsXmcyXc9gP57B2vzTdAFTdykrvdPfeAdWunbNeyPXf+KPIJOChsR3mdFici7LESZnqgL+H3cvRATQRDBvsBwMk51cBR50bmnAVGHYffOvsewJxa7YnA8b1l3f/gI1CCIJUABGurDYc7ac704tcvGVwynIrcvUi3msDU2TvEyIztzmygGiVqNRqOhf3QlwZAqu8a7UlFgFaJW+9EMensfEIAkE8Zs/DQ/rILm4CXtdWlnBUpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Er/VgwqdkY1DGlRlbjJQSiy074jnTDSmfxArJvxyMCM=;
 b=LIM18s+iyFD0+ilOPIKPXb2ejPJeQBi5gC9/t0wZJedF5drjQPAJJPosGh7C33ZeLNgaiSxg1+S3/vAnrx9aQPTMK50xTvZh+Y6vTW3K4ssOW/3sQbiNK7Jy0qoARJSY0U1HICUIpUJRtNpkXR3PjprHm1/2Kw2fyo3LQFBWhqgqRNapNDpKtJVjTDo4WKZaKw+mgIu3eJHPLwTi26lfUeaxdTtlmG0M6/Wl+6DTLZc5+JMczpJEjGp56UI7KS/stecTIV3eQ5xT3IW4ZbmVhYb5R1SIqgDe7CfrCie7aRdh6804fx47HNcHDoEwxStvYKBh97WgKlf/nvkSQcrM+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Er/VgwqdkY1DGlRlbjJQSiy074jnTDSmfxArJvxyMCM=;
 b=fJyT/LapNcLA6DkOl6G1kzP9S8+EYdOVuUDtXM75Bv6ssVOd36PJasJwObSa+l/iXrhKbypW9d9Eu4DT8gNbpJxRCfWwZZHDM2bHBE3G9WYhz1s/qbn87gesOai8YCD/P9MMsjUeTdqM4d2BTxznWC1M5rQ89T4CV8zH8cUcpmI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:26:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:26:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     chaitanyak@nvidia.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Subject: [PATCH v3 0/4] block/scsi/nvme: Add error codes for PR ops
Date:   Mon, 21 Nov 2022 21:25:59 -0600
Message-Id: <20221122032603.32766-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0002.namprd12.prod.outlook.com
 (2603:10b6:610:57::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: 915a3e22-811a-4aba-2e75-08dacc394a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZtU0sCOK30itO2b1yFEHystqDkHCy6b/ES3yqjyM23WFaxV/up0R3HBukpAE57VxZ6iziASwM9e1RXNs3E98yfASOAefkXbE9XyXFNtM3npZnNelYjr2lrdydO0aIYO7djDMjl4bxDHLZfNZ9hpwA5tk2mpF/jgA2tG+5HHnIk7qzkSZDr+Wc+EBPyrd5uEW2HP7KAAD4f7VY/D9UNouZxWdQpbxp2h6iZTKCq+mE4jOkCeFur6nv4Rr/xdm9pP3g4eSgjrmB8du24x8AZ5ruJGVf+hydz+KbPUMJiR+Z6lcAXQxs9uxqDs1WX44CLdBkM6HZHLn4EHGqubUFFY6qRhyBtx7zvwUEQF3vnbAOuhaNGsLy5JEoPteDxK+lYr72DF1xj9E1MzdEtMkGm/LFaY6qZQe9W2KxVAEhd4I/g1njtF9VLTw9jCgqbA01/j3jLhNIwXeRurYlELedljeqHy5Ve6eptuaqMAo5fFItVjoZl1JfpUiPhEzpNm/yzfD3lYFlBryoxTYdS2d8Mchfqgj3N32uCIgfG7mWdloE9L64QV57vYylD/ABGsF9QGu84cr0ICkaIMMReHfVVFkaj70Yrf1ttWAZS4cchTYk9lSCDNRVYrQI+7AyPQ4ize5biUOAq3NTQ0jXMtyZxC5BBLXLBF39TjGBlnLuIt3h3jsI3nZz2brNhZ/UK5Mmif
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(8676002)(36756003)(86362001)(66556008)(66946007)(316002)(66476007)(26005)(478600001)(6486002)(6512007)(6506007)(6666004)(1076003)(186003)(2616005)(2906002)(38100700002)(41300700001)(4744005)(5660300002)(921005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uUgOrMBrqIGuRxLw926evM/bZNZM1e/C+M+iTdijwFbfVgrVV075kgMmXpVR?=
 =?us-ascii?Q?deg3ghI4RLwPUhbbUJpKrWmMsnHR1G+eDMrclYRhRuHQ9IC1pN6rvrR5PQVG?=
 =?us-ascii?Q?6vj+MZavRiJVx0SEn/x8HFJwLvYFOJ8UifJtBP4DBY1ONMSvzMfW2bFOXg5D?=
 =?us-ascii?Q?U5o65nvM+EKyI9dc1kn+MmXcQLvZ/v77nfMb8HFqgvBI1rNngfgtCt56QodQ?=
 =?us-ascii?Q?kJPrQf/eExIH7zcAMxQjKf5LYl5SOpKXX53y1G7g+9+nU8oqbc74PdAR5S38?=
 =?us-ascii?Q?NcCoYbl3H8aosVu7pZNWyoqTe2BHn2iI0hRTwMc5A6ItK2q9+T/OI9Odl5sx?=
 =?us-ascii?Q?/6VRJDxjItxJBzZ5o2CPqBJqUzYJHHCeGm7eAiM1rve2ypbxNw9/ZGqaznSG?=
 =?us-ascii?Q?7f2fhwDe62HF/e911vip5JfsInVCyuIX9gYevy4x8sypSEmaj8OrBdL2qNT2?=
 =?us-ascii?Q?BJPgzDEP4Qm9Il+7j3d3TI8F+BHbSsom2XqiWGNTd9wCGNT1PCpozpVg4m4e?=
 =?us-ascii?Q?G6ksouvw0O3owvyNICUbnPQdMfOr6etSg0cfyqWeUnJES1vT+Bx/eCkRnfad?=
 =?us-ascii?Q?Z35CRTqmF+tk9y78pTmqrXSYxPseQCscQat5gH9lL/kNvD3uAvBzHdcQpLSq?=
 =?us-ascii?Q?8zaJkibpBTpZkX+hV5wxx7EdkXMivXR7k9eyJkvOZo8z26SKvOBknShaMF//?=
 =?us-ascii?Q?ngk37szrN13coqHUbUcwSOZXeaZO9l6XWO63Y0vSa+NwFIxvT/fhTIEiA+AX?=
 =?us-ascii?Q?vsagP7TVE1mo/RwUpy3FGpl5l3zXgbvhNSTYkivaYFfF5Wqwfl2YPJuPhW2d?=
 =?us-ascii?Q?zJTLZ6nEI0wgUQxLi0mXllaDMX0a8GxK5t534FIDd+4zExajHB+QYos3sbPI?=
 =?us-ascii?Q?pOKDxN+u7NrFEIfBLVYjPNY6HNkE4I39KDiDv3X+1NImpGmyW87fAtlMH9Tv?=
 =?us-ascii?Q?EoDKrE9MxCO+yxxaIg78r0PowibnwYjF+9aVkBxy9C+l7p17OakPCafuwt2L?=
 =?us-ascii?Q?KPL5iis5YhiFG00xxNNH+OBtvEaqYP2BSnx39pzAenoHDYU0pC7Hcjvpg+Lk?=
 =?us-ascii?Q?AX/k2tKAYMLVMNAap59MkMFNBj9XIw3s8ssf6Nsmic6ZZU4CkEEEgZgg5YDx?=
 =?us-ascii?Q?ee2bbRs5Hj7o0Nf/MSCcyjRXR9KO5SfHWAWXdIU2+i17kMNR9XL74/hPdUlG?=
 =?us-ascii?Q?mHVY3lmXXbg3T2/1zwMS/vC0jKN4K0A5dRTZchqk0o2DwQVjNcDJEcGCfysd?=
 =?us-ascii?Q?RuuzCYV4IbB6LHAcu1VL5IAU4qNnwVa0+KMAXqV0RfP8ltmxaZmP1owFDdsn?=
 =?us-ascii?Q?xnjK/32/xInNu9qrKwGPYSmf37x10QsbHC0BwaHGs8orQXoFgsuvC0HCgH4p?=
 =?us-ascii?Q?7MQM2Kgnx69XFAH+BrmmVt+wMuBMKPoT8hEc6MXisEiB8yj91hvGDLHxUhx0?=
 =?us-ascii?Q?7SA4wYSA71yu5OzT+abebVQ+Mj9zYJnk+5g32CPyb7wj7GGX9Wu+JK3+e86R?=
 =?us-ascii?Q?SyAd2qo98Vu90fmc08CB0fYZjIZxhizl05D/f9aBG8462kPw/0oJd2W9EtYb?=
 =?us-ascii?Q?uC2i9UEBDjA2nbcMDE2V/cJCmn9gZ7LaUT0CzlPD94Br6tabp0LD5368EtAV?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?+BpPwCFDHpgs54j1aEfv464idThQCfPHbp9YTrqPOd++Qrq1V00DwdGFMCn4?=
 =?us-ascii?Q?QGpR+lWhECYlqb0xJDVFpax9v2s8ekaYWBHvJTtbtxeTGmrvJEygeTwug567?=
 =?us-ascii?Q?ENFZnAvcwQtYxQkOqPve7ajtoVYG6ZTVWB0p3EVRqd2cAsn7iCq5OWMX5Jt6?=
 =?us-ascii?Q?0W37tWhPIl4DaPfDRnayKhH/93DjO0pQ0hHrH2xFFJy9jiymydqQqJ/O5m26?=
 =?us-ascii?Q?8QWsDBnF/QW+yhilbZK87Xv9UHgOYAt7OCvovGXDk74FTCHEO+MV3prYyYfp?=
 =?us-ascii?Q?7o8k1ZYAX04FLy1aO3OzoJPUgKBzsk8KllRxSgQMrWq9KqGnzqCqVXH9q6H8?=
 =?us-ascii?Q?WuyeDFWC1NWOLOx5g9FgX4DbyB1QzOWjWvLCSIJ+JMNFEMJQeON+gXiecIi5?=
 =?us-ascii?Q?fc3FZLpAGf/kk6va6uwF4mDZTmzmtWn7Jo1dN9ZANywJ9KcsCPgD9sc09jqF?=
 =?us-ascii?Q?PexI3hNMLuCKgICtpLpjix5PWVp8sI0iu38xucH2HUC1V7fxCPAqOraDqwmp?=
 =?us-ascii?Q?IfIqfXnoLDbGhUyMANMSX89iTS6351vj5EVEPxayn5PZ+I7wKjzlzaHD2RnP?=
 =?us-ascii?Q?Elary6fRdHLwDXSsSo6Ee0vrvWIRug4aTkslONDAKCwu//JWsAkzud7XMy4d?=
 =?us-ascii?Q?Pa9//Ks/H2rLDFPYunB5FVBMGM/gh5hFckohCVCNvVRb+nO8er+8SJVsPYNH?=
 =?us-ascii?Q?gicf37muzeZDG1RZcIhsyRednysK+BEmFsye+urQDnidrmEcTjuYXbqwPMk4?=
 =?us-ascii?Q?w/z4xLuMgq7KODoixGca8vBACOTPHle7zWJZt8MRZS2jg66A7SBsZtk70H4d?=
 =?us-ascii?Q?MURBripSYr0P+/TcVJqswZiSjh1P071NY4kfaUB+rFI3PJGW5IqiizmjD1TC?=
 =?us-ascii?Q?esG3OordLAJWGkAjx81ZyZzB6dSW53SCRkK4hNDt3S18OZpnTW6DF+DZ/Zv/?=
 =?us-ascii?Q?lsUoNeYPEODo3kpQdf/N8ODVzVxH0N4g1orm23vr2CvYzVH9Vf7oBWd/6mlr?=
 =?us-ascii?Q?mLnVfetRboAQFAjVgdKcZE9hoQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 915a3e22-811a-4aba-2e75-08dacc394a6f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:26:06.1598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bXaQyCbTsSF4Ph639rfDM8upfzeKtZPFsGf9vKYxi4ZPxa8NTx1phlmZucjkItUxl9lB4jdg1FOwYrBgjQA+mYWAyl8qPUAxAHRrAey+Ro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220022
X-Proofpoint-GUID: 4dYzkTa6iwoBftotHX8axV4m26xdqxZO
X-Proofpoint-ORIG-GUID: 4dYzkTa6iwoBftotHX8axV4m26xdqxZO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree and allow the PR/pr_ops
users to handle errors without having to know the device type and also
for SCSI handle devices that require the sense code. Currently, we return
a -Exyz type of error code if the PR call fails before the drivers can
send the command and a device specific error code if it's queued. The
problem is that the callers don't always know the device type so they
can't check for specific errors like reservation conflicts, or transport
errors or invalid operations.

These patches add common error codes which callers can check for.

v3:
- Rework nvme_sc_to_pr_err so it returns directly instead of using a
local variable. Also do the same for scsi's converter.

v2:
- Drop PR_STS_OP_NOT_SUPP and PR_STS_OP_INVALID.
- Drop dependence on scsi_exeucte patchset and include status_byte
patch in this patchset.
- Check for all nvme path errors with nvme_is_path_error.


