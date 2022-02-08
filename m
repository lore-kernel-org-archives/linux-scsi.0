Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EC4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 04:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346812AbiBHEPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 23:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346775AbiBHEP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 23:15:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA782C0401DC;
        Mon,  7 Feb 2022 20:15:28 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2182W8JF004446;
        Tue, 8 Feb 2022 04:15:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=g5uVrvTpwVAKDyO9CmKHQQrCM9nE/ptjIJal5M27AsY=;
 b=dcep8tAwUBqkutUw5iI83bk428Fr+k4AhHbSlXACRJZNsxWt44/2D63XIpN7akx2nlK4
 4jrCveqkL2mXrFsOy3pSVz2OuCgjx24ETYzjLZYD7c590HUIcrLGOPhUsWSZwNCEgFwA
 VmcbxX3exGeInz4naxv97cTF89iWpzOYHgUKOfM2++8pHuVl0fMa//4mMRXOmH7yeaKf
 wXk1APn+T5Yb5P0QD2qCfoBQYSYUNO7C9s3ouAIbxpiBGaMtSi781SNuL41UGhlJklUr
 ZNlcnPMWw57yjWBiDJ4ozPblRQXeR9L69C0qyYncd/jjD/wuVg4TSJ8UDF9KGv4YfSBs OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1g13r8nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:15:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21844wBG146724;
        Tue, 8 Feb 2022 04:15:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3020.oracle.com with ESMTP id 3e1jpprmkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:15:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEVTYZUFxUGOKMXUNJfTouF5f2nAiXctn+QNlJuaoznFu/ifCNGJCNCJBFEWTCQCCYuHreR/NDWpSQptHi4pzTqGhPpoKAalbbdowIyBuHfkFD4KA62EpPLOPlLgNn7Ynd1T+7daM2aGIQovCjL0sro0CV934OAajjdgks6+gOK5eoGtwdueoVrpLSzWugcUNcYeaSqbUOc16lIdFtVx+qPqnFtviKx4CyGIuQph+avKE3W95rBT93STcL6hcmxUDqsC+AAUeAMKJQN9lpZPCJLLluRNw3Jqxm2mJLsEJfg9lfuG4ct33/moJs4sKt1BmPJodBRNgsj6Mxx9jNNHkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5uVrvTpwVAKDyO9CmKHQQrCM9nE/ptjIJal5M27AsY=;
 b=MO4O52eUkQyZK1JdjLCurs1JmOCdeSlkdyhncrdsbB+ixHLTzKqbsnlfNWncazR+LxrYFqmCek2DbBk64M/kjm2e7kiW0r1K6k1R/PEeQdVbAByjc+DAiGxJYMn8ToQMW1IInUNSBIU5Ru6l3hNDFSuxKe7JXU8Hn0XEHL4u/GrvXfC0u4/aRCoGIHEByPWm3bu1xmj5HiDs8kKN2WgHG+Mb3nzy0gPgK5H9I6c7xPjjefmuId3kd/S0HqD0p7gPMlptpsSFAlKDheIBPGCVyYzvMTjDIJYMC2qS+/3DW30jzIIfYh4OdJ5uSQbEIJ5afwlVurt2+iN/bwqQjELbKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5uVrvTpwVAKDyO9CmKHQQrCM9nE/ptjIJal5M27AsY=;
 b=c/M3V/QOWe3gsCdgITm+uKNVja1YWAsOt2eWklSV1xXaVQDJh4hD2YHPwTLJ4MHySlK3nUyk8fQaKxQ4w3vXhUfcYPLBTsTYroxI+hAwgZ3CzuiHE1FRO63LOzbRprCsolYa/l8iWMjXHDZ/Kq55tEsyZeUBUp5WBgOKnO+4eiM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4299.namprd10.prod.outlook.com (2603:10b6:5:216::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Tue, 8 Feb
 2022 04:15:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 04:15:01 +0000
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/2] Add scsi_done_direct() to complete request directly.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135kuxadi.fsf@ca-mkp.ca.oracle.com>
References: <20220201210954.570896-1-sebastian@breakpoint.cc>
Date:   Mon, 07 Feb 2022 23:14:59 -0500
In-Reply-To: <20220201210954.570896-1-sebastian@breakpoint.cc> (Sebastian
        Andrzej Siewior's message of "Tue, 1 Feb 2022 22:09:52 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0054.namprd11.prod.outlook.com
 (2603:10b6:806:d0::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07cb4a99-39d3-4678-50ba-08d9eab993a7
X-MS-TrafficTypeDiagnostic: DM6PR10MB4299:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB42997B1D10493D31004508EA8E2D9@DM6PR10MB4299.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55P0+2Mk8yADWHxbnUQN40jDHFaiaA6Mnw96rkGhW2F2IHXWE8CMVcDaBUzjc+31QEJfJajdvexl64BmNo2dmw+c/db/eRVmxpdwhBmmrqdcpvCIvEyRxdc7wJzPlKBARIBEnr/jNb9RcH8XygtIH4RM+7P0c5bKXccrsz3Di1+4ekzqd8NBUCHD1/1F9pNIVPgKQvJoBHtbqsQQwUdCtzWFqfHI7WaeBPKGevd6ZnxzCJrF9/BLzqVz221yyfOdfYNRxUhTgkghG/dBh6kJ/SWZtf569aZ4iNF4/y/akRIqvY/bgf1+G56hvHskJG1RWRz4EW+xMbtE7lUHSaaBuJmdECV6jajdTb/P99fKxKxIiLTTvPcD6oBQDpDmiG3M1pDNFHdPMh+ftEI776e3POg9/N7qomxwoi3nn/NmAB0/uIB1pr56qRcbUfN+tFbl3WRXwwfK5zcm6UTZYjK9NlLuo4izj9usjSAiB2bBFR0F9yx0PEZ9tVIpEBFoWd/XU03IH/aKny8ZTn0HB4jiBxSpP9BbvasGnl3CbKD2nVoieka9aNZtWwxM2EfN++n66MxXiTQ1nVMUKPTsNhoZDVr+WiTMdw7FTA+xXp0uFQtOJeuvUP8F1dyZf0d3VahGENjEbe4MFPLcbQZRKU2ORnUdyXdF0DgkkTOJFlO4JB20uIhvrB+AAl0dgOS14BJiP34Wq5WcSXziM+5JwhUvbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(508600001)(2906002)(86362001)(6486002)(186003)(26005)(316002)(36916002)(6512007)(52116002)(558084003)(6506007)(6916009)(54906003)(66946007)(8936002)(8676002)(4326008)(83380400001)(38100700002)(5660300002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?szUpiIdMx3h/Abfxv73XIGLowlmUV/oFlr26yZ1VxMsuVduYvEPA8sQaCmYG?=
 =?us-ascii?Q?JceKPysKM6NYOtIkKxSMPfRhJfcmpk3qCE7YWfvPCckx01nUycI7y+IjeR4i?=
 =?us-ascii?Q?6jEy6iCAhBTW+Wk86mSBhARVYfoD7hde5XYpENmzuymgrCJyOzf5JOZTZtXP?=
 =?us-ascii?Q?pqmd4XxgxOR0z9S+p5iOW/KFWC7gEMVCr8MD22TZKZei4kDr1lA1V3rv78Bf?=
 =?us-ascii?Q?Ff4tK3lza9XLgkhTGxOAXCMjvRJWIxlaAbTsywbKw+R8nE8OvHfBPhD7mAEO?=
 =?us-ascii?Q?G6W8tNZHO9BuiMDZamglCj62wbcYILhQXxwYfUl9bsxeMZqymV5xLfxKIDqP?=
 =?us-ascii?Q?tsI3SFgiCxm8oAFVCLiSJ2cjUv8JmszQk3ua54lDQbLZK/WQWrtvrqXxahYr?=
 =?us-ascii?Q?2opsuXgGvKtjxNhXAOzO9T79z9izkz+P2poHpXRfVHg3IV5YWH1PgfjHz+85?=
 =?us-ascii?Q?iIFG40CF2wEfdkcDUcLt06WwYAG82oZX5LEmc+Y7uLEuDLtqfAi3oGU69Ifg?=
 =?us-ascii?Q?7pau5XS0LRQAEF9k5IJ3QUkXFF4pUxUFoukLWVB5zBNORQGVXKxdzi1NIUkw?=
 =?us-ascii?Q?j/Ftsiq1pz5HpsldYql+fYTth+ylY5EHYAFHBI8EtNsi95S1DRBLhSY0DqdT?=
 =?us-ascii?Q?p8wlkuFrXCDyNXxge4AMqCNKNkv5FI1UP0YYEHCecACEMqjz8cENTSvRcbay?=
 =?us-ascii?Q?gNfmeXOwPoCpcmLooyeAkKMbC1JkOea1UymzzfIbvCIDbKduFNUTuw7vNHQC?=
 =?us-ascii?Q?4VCF4iM3mByFe1TagR9algmJUj3JslLhUFRdXRSeO42ZhQHdxul2zFtKTcNU?=
 =?us-ascii?Q?13mRNVoU1RLOaLHcaHtgXeSaB7IeW3HXYZDKZaE5sO98GLJcVkmCc4LMpsoY?=
 =?us-ascii?Q?A6f5p14aEKzuqEpg4hsOSQOQ+W4C3hdafRFA+wpZhRM1C0iZKCzPzQsaG9Hz?=
 =?us-ascii?Q?1pbiJsHVqLf4pT+55e3K+1kLiVjC3qyTnupct1ZcynOHKnRdEorLFIDz8UQG?=
 =?us-ascii?Q?PXRkl86g9OJpoRbUtZJ9lLNOrXGIEzAxMV2j7J26BfyOhUeSpMIawxu2Bqn4?=
 =?us-ascii?Q?nChguZhin59XNRKUyCm+j02ywB+5ibFWKFaF/c2VQcgqRSN50Dy8zKAu6NlQ?=
 =?us-ascii?Q?b0+wNJallVQDyikf6Dc9YxoNOyDKJpI0tIM3bffwfsxGCeNQqffxXUTjUmqt?=
 =?us-ascii?Q?8v93rm6o7qNl0t/URQwGrmsUSfah+LcF/BN646JO6K/upqBU9zpVf1B335+3?=
 =?us-ascii?Q?CvgGEvaguOCy+OWZ3U/f+8CsVt8Tp9mDlXsg9QlJFHPb8uUIdhs+II8lRwjo?=
 =?us-ascii?Q?IazfbxXjmeR4zPJDEwoTdhostObPbGqA/WVlLwcgqb9mLgN6mWZZ5XkyNWzO?=
 =?us-ascii?Q?5f9BsOl2Bcm8NHgWDSpPuxpXTg6ouj81lvOKUJ2MNc/q/5Fzatd8TMKF7jUW?=
 =?us-ascii?Q?gLbn987wWyzNHg4YNn57nPNeoEsa6UJDc6pBPBXe801xjxDvqZLJ0nQpRaHP?=
 =?us-ascii?Q?WZOmxdngNjAWPrQ17X1f8GEcLSiOGY4Pe9xcEhm8SKw8CiTHTeFm/URHEkDo?=
 =?us-ascii?Q?GkQ/r5cCSNonLtskEey6wCY83Y5yVGjrFNKaeyCmqSaiGB2CLz3+sl/uV7Cl?=
 =?us-ascii?Q?RVblUGpj72EHr++dQd4d5LMoEK4Bii0a5C34ew/sPyOA8d265ZOQmkUSJT9L?=
 =?us-ascii?Q?ntOYRA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cb4a99-39d3-4678-50ba-08d9eab993a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 04:15:01.7810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GD23x/SlnfXGx18tbvnPcN2PSsPNQQ1Nax4sYxV9BHVzE2VXE7vCJG2nzRhQqLe9vXATS0W8eQ7p2ZJt/w4Ds9jcPV0wxhQSCeOoIJYNLMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4299
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10251 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=746 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080021
X-Proofpoint-GUID: gBRfFV9qYBFTjrkWDUwYXaP_pfGFt8Ck
X-Proofpoint-ORIG-GUID: gBRfFV9qYBFTjrkWDUwYXaP_pfGFt8Ck
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sebastian,

> This mini series adds scsi_done_direct() in order to complete scsi
> requests directly via blk_mq_complete_request_direct(). This used by
> the usb-storage driver.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
