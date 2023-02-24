Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCD4C6FA8E
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjBXRry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBXRrw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:47:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F99126EF;
        Fri, 24 Feb 2023 09:47:46 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHiVF4020896;
        Fri, 24 Feb 2023 17:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TO6pTuTsC+1k3tJfMWqYHkIv8dKNdHCte1twy8L6lt4=;
 b=miP7JJdBRmr8KycPsFAaaGS8lqZIRvLh94aLPp8gQqq7ZlYXyFYh7HXxNlUaneWmMsof
 AtjYjsJ06e71mLjOzdLjb2/qyw3Jab3w7TGhkGvO+Pj4V6S3h8wvWPXz2tbC8tvr2BoX
 Tt80jQ6l4vUM8iU3phz/GMV72sO9catEB/6VFx2Gei4Buiu6dKjWPVxerYRXtOe0NutL
 iws3tojHVBf4OYq7j5gdHvSqwp+sepfHlhZSOS2SB8jq0Orrcy9CSX9+ZE/8XMsE0BP1
 pu7qQBo35ZI60ADL7CzGMCSlcnfwGDmY5SBTw1nQHx/gOOXkcArW5SCqdnbvzXTuhMab mw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpjadkpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OHJGXS031548;
        Fri, 24 Feb 2023 17:45:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn49wjuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2tZNKkCD5LFS7a4325NOdxAZzw82IJH+LyMDhTtBS5oHZlVHkWZRt0Tctydi8XSAJvFM00MYJITSOcwCEa0/yO/zSqs7k9Xec/HD1J3Wy63tU4Y/o0t+6Shq9KMeKoTNOe9dm08AI0CVQbqq6RkwAoYndfaAhGgqc7AtqH0O/1auNhPOk9G08TeX38jJPnriHvAEUJQB4xBmqkuDUrzJJC/ZaQDUadUP1ec8tQAzv69+dQxg/HRRaIoCmZTbTrgsXSHcb+LtV7XtSLfEy+5+rOIx4rRe6Tr4ZHAIcHi3G5jP7z1DeAv0/Kf35x8W5N8EWN2rlVRraDlVBDbKH3HBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TO6pTuTsC+1k3tJfMWqYHkIv8dKNdHCte1twy8L6lt4=;
 b=MCC3wSwA+ad/vwcTUXjDjnbkCrXsoh/JByI1NMTeraZHXdihgd6UIPE9muRP7ledz3ZkATuqzHZbB3E/TkngO82oB7YsSoBxFG31x5oooJt87J8jJ4W2m3j3JFowJbMXLRkA6Yl5Z3VR7p0C1/oScUNnMn6iNKWOVZgPLyQok7wiFpNA9R/ce1ebWjC7IAw31kmLKoFncOJT5QC8/UmnZ9l2FRZxxoWfdDr8Ion6163ER58zFtdXekcDOfe7og6uhlWaosK4RtN3gGCStLW77lq7fCn/YMWaoORwv/2pdT6VApw8W7NuOzjrl/2nlqhjkOFsjWSzAtRQolrys5l3eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TO6pTuTsC+1k3tJfMWqYHkIv8dKNdHCte1twy8L6lt4=;
 b=PLjPdTR9Pm8JjSXLgACCgR43YOnqlXr3A0ZjzuL3w7S+EtT7FfHCqbTdtLyE0uNXGbKZB4zcsyANyx6Xb3ku0Hm4DK4B9JiHLUlxugz9zBmT9FJygUMCVrI0qayzbOFY5AVqsF8lE9/7ErYMa16BVDNpX3hBYtk7jpzNFtddO6w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 07/18] nvme: Fix reservation status related structs
Date:   Fri, 24 Feb 2023 11:44:51 -0600
Message-Id: <20230224174502.321490-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0045.namprd06.prod.outlook.com
 (2603:10b6:8:54::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 81a8a8f2-be5d-4929-0502-08db168ee375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M5C0Vgiem8ZYQtGFWc5fe/+TWqz3Q1qrs+y9lhDOZiMRMygnv+ht2Eaha7yvSKorxqkEPtBc01FlbUvmHThKYwLBb8yOSlqlv/Ln+VMt9y+MP1c0FPI384b0mNmZKLRDq4+MQDL1WZQ5vVUNwovXRCs5Dc6Pq0BGh11+x54R5mZTSnGt+GtL9FOFkfmGFsTJdNRgdiROx//UlLIJjWjHLvCJkpUlam1wkBPr7qf5MKwv+MteoZB0pIdNPDibeNZcOyXS1ndhfv/x5jZqME7lJw9P9VrlGhpCRGL3/7ARM0bFhlwgMKSTJ7p+zGF0OSOkkC0jAKcxPlGD7wLxvvxwhJoZlkHSXQPMCPK2dZIx7E60VAEbrg47B66594dt+1os7WasiH3fQo2Hur6dTE+ye6aySSGw4yPKyujJ508cBGJ18Kra7owTT15yaIi2cdOD3XKj7EKE+XqiOXCqjrJgWOIc1D8NMOWAacrh1PnkSEhC1zCy9KferLh/5xPb0Rdsc4OU0XKFN64rsIzInXe9JO5GogFcJHicYNAP7ucaPPY7QcD+gKcX3zN6hjmYY2JCBB0XVzfW5Bs/8h7gi2jwUqn8Ek2k+EAvBwnKqomlGJxBbeHY6I5i9OKYMnWzTBtEuz2rN0uCNmQFRE1dJA2BfDGe9y4AQGgUGSAGwrgtsXtgjXxFdDpvJpybmnfhpF7z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NCwXeyx1Sh+Bjb7+IDFPQnOjxh1zgDt95Aj8yVKhQpEim4BQSRL9oec5UAsL?=
 =?us-ascii?Q?3eZx7SAl4IDXBCyccl0HkPX1Tm0+BJTRCpO9yK49vRo08qzA7w2quOUWK53r?=
 =?us-ascii?Q?+921+C0Hms11TqiqySGQJCCqOMkFL950keiXI9rGc//zrNL4GAGsILxn2ClC?=
 =?us-ascii?Q?S5uVJbneLlPhWjrjY+C4LdkkFol746Pod44NNy2BtC5E09LA7SH89Lne9+Fz?=
 =?us-ascii?Q?JwCUlh3hw5dhqJDyITI3CqPqXgyW6aEZgBeiPPmsx49pUU9vQOC4MDO97K03?=
 =?us-ascii?Q?WXjNUQ/8Zu64UschaerfskzIBB5DrnWMku75jvSJPvjC18cbUkl7sU6CsGz8?=
 =?us-ascii?Q?h0pqIs3oRCTOb9Q2G0CqOs3gT80+AdicmSF8cAx92lMKe+5Ed6X8gEcDpgnb?=
 =?us-ascii?Q?VSooLJ2fpFbVFV6VqjsVtM9n3JoP60fksi4SWN1gH/K3iUSauM2hInHK71g1?=
 =?us-ascii?Q?plcA3l38MGYO1vMHABLBnhuU6cn/+IEtdzNSggnPOdVyvwEiZzZDND8nWIm+?=
 =?us-ascii?Q?eCXNJVFVLmLLGqL2FtsiwiB8Jcc/hrSZNBEZ9e9uQJryn5Ex9R3BdARJenXb?=
 =?us-ascii?Q?Q7F+6rjusO1zqFvYolbPVFTtCraC2oo9QGAfi+qWBvmQE2ITp/MSFEq7/Ja0?=
 =?us-ascii?Q?xBSArny5xPIFctPG399PGM/1ywHMM0oVJS3MSvcQrlpBSehW1S3J5eRU2195?=
 =?us-ascii?Q?7O339MweUsAu6n9B4AUWQulYPuyv/ws+9A74VykmFCi1+6Qe9IpBDbwVXHdf?=
 =?us-ascii?Q?8VhxTDpKHRtp+0y2JseLAywwM3pH+HqVL6Q0F9FyHx6XY+GLK1tGX4wbCsPr?=
 =?us-ascii?Q?ezxu7xbU1j/i5R5v0w/aFa7E6gyaGzExQDIi8/CEGQm+ysErdryHHjNhBKQT?=
 =?us-ascii?Q?HqT9RqS3e2aHJqKaP+fbbf9NZhWJbzUnxUrQAyuD8jH1+J9D+oe8AnHtfZzj?=
 =?us-ascii?Q?rGsOOpmyndt+we8vM7Z2lbBCZ7fLDNQHbq434sFD44sPXMadF1Q6mKzWdM4W?=
 =?us-ascii?Q?WPdSxAyaUO4eEQfoFAMqcl76LDivqy/ybBnCONUIe549tyh9UM2X0h7pURGr?=
 =?us-ascii?Q?N6CdCJLS5o4mlnhDt8z0LVlMc2gt8u9t+4j2lYGeG6o/Mzc7UbUkvS2y4eBZ?=
 =?us-ascii?Q?2Y/SQqznyM2jDQV3ghHk8a3UwJStiiBeyAk2tRRwX033KpJhWv5LKSE02Mr9?=
 =?us-ascii?Q?lmpIXdR32VV53OcEojePwQYTb8RhpS1helcxIq8R7l3ZU6eDxsF3WlYHb4ln?=
 =?us-ascii?Q?YIAmtbhz29h23lpuQP5X8NS5atxHWUzlgxKDxjfQ3796Nm5x8S5FBXTOFOf4?=
 =?us-ascii?Q?O9cWcNgis2lDMRreAEzQnhUJv14o6BQ1UwP8IKV3W+hPOZ34tUQNI6Zu9OWO?=
 =?us-ascii?Q?6A9RFzIeFd14iZ+6xbpVGg5LFBr6aMvKlq3TMU6ocfIdhZGguNv3SPbqMZPq?=
 =?us-ascii?Q?24nlvWYzSHS6/xNufXswFOd3NxXXeYMlX3gvtzsf+WUcRjEwouJFCZjD5cf8?=
 =?us-ascii?Q?/9P3SpxWLJA9crMHpgOlVWhrnaDU720f8Rjo3b8GIazqHQi7j41VlTD9hhlb?=
 =?us-ascii?Q?8uk40JXU+5dKU5HZZN6dQgV3rKK6UF6BYH/eZ7LjiDyVoTbX2eg7pgyvCd06?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?6fza2lM82RgTm5mz9T0QaokHzXDDlnszblR8phPTW/+wUnkmCSwQga/wMh2Y?=
 =?us-ascii?Q?tJwaVVejtVDtCuJdcBBOs5MS+RJu8jMb0yHqmB/o2eg3smGpHrs17TOxWGJo?=
 =?us-ascii?Q?PKwZEvoR7NVYcZg2qpp0OCltr4+82bK0S2sABrIXS1ou7hD+nkZkJ2Q053dl?=
 =?us-ascii?Q?1jtB2P8PvhXTPTEvTMmmP/0a/+LaIgzvhMAwwkUg5jqeAzYEzZbc02fUqf9b?=
 =?us-ascii?Q?3kc8vnbOte613PlAf5yuJV9Vge4cAv6EXN6Kyy/zrBoCGaFGE80HcQIfUFj3?=
 =?us-ascii?Q?G+3zI+2cbQBXPjOwq77adxoBN7wxDt5M3U0GWrkBirnrOveUPCRKOWqgwLwO?=
 =?us-ascii?Q?j2KzaAlgZp8OhqHQ3GlXPgDZfzyRt8QYhMP2vQX2Rw1zFwvU9ZL972tLu1/i?=
 =?us-ascii?Q?cruqA+3XoXqxkgNibM1tbWZATsveV4tuIxAyB5a0z3X51BnT+CMRDCiUfBQ+?=
 =?us-ascii?Q?1PwP0YZAS8pDkRIXH5tM9oDId/vs/sYlbX1jX9nZbGEBHttcp8ztmd9ZoMZH?=
 =?us-ascii?Q?liR6E4VL6huz3xKlFh9xy6hTo2eNdu0Rn/2sBDVg/QFM/YPfNnjo6rSKRqtL?=
 =?us-ascii?Q?v9Vd44GV2pwgBZ/ARxGy0VdRR41EGQVBI9UToc5vr9F+tNzeYQM5+TkwtCQx?=
 =?us-ascii?Q?LPSImSRJkM1QEHr2AxeFSkqvHpxo9wFkBG0uExlN5YqZcNok3IV5mkS3bXdn?=
 =?us-ascii?Q?5NnmJL805PKdfr2bPmjfv8nQI+plEe2htffL6jUruK2Ti/vNcjyHjvtx4X5r?=
 =?us-ascii?Q?0YZVVvPQazbGP5kuJPwsdqMXyMfwYWpK59WRPng6kDQ52WDaBZ/1VQnNCEAn?=
 =?us-ascii?Q?ZNzyaN1EJ41/y4EQkgWoQbmviKLR1WGRFn85TWJQkJpAeX/j4Zhi/YpM6M+3?=
 =?us-ascii?Q?X7ySM9AemllTlufXg7DPl1ZRKtc+NdHEvVZSKgtMLx9YxuH/Ur/bNvn6k/Mj?=
 =?us-ascii?Q?igV74x/ehWJtQBiLnYmxHzyaZBy26x19kHw5WfEhmQQGGQMV5DqBqcKMnUt/?=
 =?us-ascii?Q?h8iezXUG8LUfxGUQPRFmlUMh7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a8a8f2-be5d-4929-0502-08db168ee375
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:16.1727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dRqTV7JssHgtKbRmXgAdAxKdIzKHwvpZ5SqEJC3Tzq5i6B6WVjat5aRYGqzDYaxkn8N7p9voTj952uHmKxhN5c0FnoM/k7fNrWraldV+yCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: HmVitahcqGZK1_wCibtmC9KZuEOlJv2e
X-Proofpoint-GUID: HmVitahcqGZK1_wCibtmC9KZuEOlJv2e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the following issues with the reservation status structs:

1. resv10 is bytes 23:10 so it should be 14 bytes.
2. regctl_ds only supports 64 bit host IDs.

These are not currently used, but will be in this patchset which adds
support for the reservation report command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/nvme.h | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 4fad4aa245fb..c8c504926462 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -759,20 +759,37 @@ enum {
 	NVME_LBART_ATTRIB_HIDE	= 1 << 1,
 };
 
+struct nvme_registered_ctrl {
+	__le16	cntlid;
+	__u8	rcsts;
+	__u8	rsvd3[5];
+	__le64	hostid;
+	__le64	rkey;
+};
+
+struct nvme_registered_ctrl_ext {
+	__le16	cntlid;
+	__u8	rcsts;
+	__u8	rsvd3[5];
+	__le64	rkey;
+	__u8	hostid[16];
+	__u8	rsvd32[32];
+};
+
 struct nvme_reservation_status {
 	__le32	gen;
 	__u8	rtype;
 	__u8	regctl[2];
 	__u8	resv5[2];
 	__u8	ptpls;
-	__u8	resv10[13];
-	struct {
-		__le16	cntlid;
-		__u8	rcsts;
-		__u8	resv3[5];
-		__le64	hostid;
-		__le64	rkey;
-	} regctl_ds[];
+	__u8	resv10[14];
+	union {
+		struct {
+			__u8	rsvd24[40];
+			struct nvme_registered_ctrl_ext regctl_eds[0];
+		};
+		struct nvme_registered_ctrl regctl_ds[0];
+	};
 };
 
 enum nvme_async_event_type {
-- 
2.25.1

