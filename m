Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46105C001DC
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 20:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjGWUTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 16:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjGWUTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 16:19:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832901A4
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 13:19:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NJ01wc001286;
        Sun, 23 Jul 2023 20:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=LBdcjSsssgYaGLT2uFDRichuCXECdmn9FopZYtNOexA=;
 b=pBIrsvbzNTZpboRtT8bSwk2QohhW9K3WUMYGQIHw4fnhpVM8yklWe13n95qOs8TCZWSR
 xuqGNGX5+uejPN4wr0nS+NpooWdi452lkLoC1XuG+lUZtYPemfB56/Dp6mFOCfMJRcGa
 CxKgFTU83/Mx2SI/vDv2aKDYkksi6ayFHEjhyzFxubPosbOFY0V4Xv/kE++YfBZhl63Z
 X0yThtan7lRreTERjApA5j2l8y2+/bmRMqN6cxuM5koxk4yQkzgFlhB7QTlenefn6RTl
 A+jCYX+g8r4n9Q93JSG3Paa2CwfpOGWroD+4xz+tVQirKzbo4olqI4uy5eAnVczONBid HQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070asfxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 20:19:09 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36NJu5xZ027598;
        Sun, 23 Jul 2023 20:19:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j8xvbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 20:19:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnZuasVtIotRlvEGch2qVciD6AuKBWahKPb30W+Vk55bHO/fs2dKx22/0AInV6OcemD3wmTTPBgytcjTTbAYWMg3tBVr088pvQIQbgGeP6TNF1cFeaDGnmaEcvAZwE+UNe6iTTedexHbv+csEmVVXSrIHyfmtUefYr0yMzWJON1RyH8VblUUbx7nzmyf4oPKqhUYPLnoH7skLPeRs3U6Vqw8ROn4CyfTNWwxRdky9Pcv8saQYnbCzXu8wN3cL2x9LOwcREzz5En4C5GofFg1fQpOfbhw8zluzTIsMZv5aE143Qy2HSERpM4E985DThCTz6mY4geJNuTXoWvjF/qgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBdcjSsssgYaGLT2uFDRichuCXECdmn9FopZYtNOexA=;
 b=EqUlJ5EVCL+iF4UkTp0Hsu3sNipexjOaJNMAOTVu03ucbmbOZsXzMzT56Jhd2N0UBJde7wWo9gsMRFRxJYrLHSjqQ0BkrY/MkEaEulLMxWTb7kanzgwRB+kDOZ6PfClYL45O2nDiC96cq2fLQwOHQA7vB2KqfUtPC4y7FH2BWlH0gGux8wt6tbi16xvxKc6nqGYN36r4rb3VEONEcKVBOS2OpiJnBPGOX0SwEsCInQnxl/92t86u6Ib+a5IV/ZR6RR/cZ/S3lrzgAYW/S+DiG0fr65w3X+wp6L4Wc0p0/drgH+oL2MhLIDxDORDUCa50aLsTu9vSL/Kh8D0dlgcO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBdcjSsssgYaGLT2uFDRichuCXECdmn9FopZYtNOexA=;
 b=UObp0muEfAJm8tCxhP6FxiNlSHqZOKFdXMtJu68MkpqktkgAL9EUCRy3ihgMgjdcdJbD3dImY/f5WdEbNYs5e4HzW4MNFiJIts1FNUbgCsAYr1l/5k+lkXvxBBhcxri4opTnNsGV0GZ/W0c9oZIh9sOdjGzlyxiAo+x/C1p0x2Q=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by DS0PR10MB6173.namprd10.prod.outlook.com (2603:10b6:8:c3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Sun, 23 Jul
 2023 20:18:58 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536%7]) with mapi id 15.20.6609.030; Sun, 23 Jul 2023
 20:18:58 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.14
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8ea4c0r.fsf@ca-mkp.ca.oracle.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
Date:   Sun, 23 Jul 2023 16:18:52 -0400
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com> (Justin Tee's
        message of "Wed, 12 Jul 2023 11:05:10 -0700")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0338.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::14) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|DS0PR10MB6173:EE_
X-MS-Office365-Filtering-Correlation-Id: 15a6ed94-16f5-471b-2def-08db8bba0bcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hd/tG37oYRh+unHMH4Gxns1GkK+LXUfQ4xzn6EsLY8IXNY9nwswJ9cwbuwdtSw5hsTzcBKJspwtp03lluL4hGgH49dFz6uFxjTwNlyVgw/jIJZg4goKvdqn0JFT9JMdZu3kD1ATAVkSCwz8e+MvVmUnt+V2XAfcFIxwbjwBDtu5fuXKZPp6HIeUZSGZKTwwwhKE8NhgamsmN411F/BMjnHIqCeaUA3yDDYGplQPKWHfIS/qOu5EGdAclUNi+6M454lRdnWBeOnyn2k+kqr4+PLXd4EoxgmZ+I7ptNgaQYJ7ibdeKDAy9MGNGXBdtJ3stMXFjeiujbhInASkSLV9bI/FrvNBwtV2SDmlOj1wfFqOxqkUkWF/mpofcKheS/NlXQL+mGqMjsmvQh60LB+xoRVQeSvDQs4eRvp5mC/IY4I6jHwREvyCgW0uWq+I8ulNbqa9yd+zkwFh+5k+fryPnjD8Wz4E6AlvlRSlgutHvOvgn6tKZkO7M+a3REuBSPkMRkrYN4BV8q3fUUIjby2hSmKP1vF61bF+4jo5fdFcT1P9hxutUI8TcD3oi2vwzff4z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199021)(6512007)(6486002)(36916002)(6666004)(478600001)(186003)(6506007)(26005)(15650500001)(4744005)(2906002)(41300700001)(66556008)(4326008)(5660300002)(316002)(8676002)(8936002)(6916009)(66476007)(66946007)(38100700002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cRU/q7yknGxuQD/D9SvMVsl2y4gBBm7nYD83YImxqq3ciyXv2GnuwIjc/MpX?=
 =?us-ascii?Q?faKUvOwdUViyYNIOxQYKh4Iq+S6TrlE3K3X7fCs2s6N1N+7He5kzw+nd/AYX?=
 =?us-ascii?Q?XUZJNyXN0fQsyWrTkvFGZOIA/A7PW9XvbdqExDygBjvQSBYYIX4mQJ88kfc0?=
 =?us-ascii?Q?s2hVIRJ4yChyjjDv712JfDUAtjjt5eILNMMbAQuNwzdYdIueKkTv67/i94Ts?=
 =?us-ascii?Q?pUgp7YnBosIXeVgsEYNFL7CfMCSsqiLHTw+GQWtf1k33ZH8gCG2BD6ZSIFoX?=
 =?us-ascii?Q?BWqR7ccM5J3gNPDANt+kL4pH6TMoSyPc2l7OrwQii7UNmH4JhCH/g3l3y8oC?=
 =?us-ascii?Q?rA9wNYqtWKxz+L3etwt6/4kSszpqguQvwdoRqRPGZIEaifAjBER1BCI2PUB4?=
 =?us-ascii?Q?HKKub/FgkPWMLD2MpPieG6/2brXCzLhi+QrVsccAfZlX9DheuQcu8ESfyFuU?=
 =?us-ascii?Q?COROkpRWpEYAd7Q7LvIcvXEEPoOf76ghylnI1dlIuEvHII4mX4oL0jGUBS1n?=
 =?us-ascii?Q?whDrZsrvgs714dPAtHW2IggUaeuM1MIxEgY9atVrwDhp++wBnLmG9iOIwixS?=
 =?us-ascii?Q?7OKvpxiZoh5zfAIide4e/CP0qd01Sbuyue6V0FLCPdbizIEjv+v5c1EbQUq2?=
 =?us-ascii?Q?sTDt+t3pjUOQNM9L73QCxeCJLYxyliWrTUnda/NqcY3cb1v3z5pcdOsBc1dx?=
 =?us-ascii?Q?+M3GSdWXxLzHxppC/9y6xgwBA/0iPtxs5o0neqW2WU6xFCdU8PyhAJifY7Cd?=
 =?us-ascii?Q?L7LEouc5Ux1NDtiRruF55X29wZlMWZhMIspwasy/XREhKCqitPXsVU2DIlZL?=
 =?us-ascii?Q?U+VHcNgym9yuoJexKMFztFWkLH43oGFQW49Uw5vamwod8NRpHErDVDl2YI7U?=
 =?us-ascii?Q?I1A/ZX1p20AtVvIWUq/UYfQoX4Tem40/U2s8R0H0nYPYuVTGN9EwGvHd5OSA?=
 =?us-ascii?Q?A4oAwe+ijriVCLsFZYZhj7N2qyJyxrTcoYgUQuPICq2DuDuUifCURtLA+2rj?=
 =?us-ascii?Q?L6g581ZfgQoZkBXkDCXRyqxE5OWa2PZyOLNxXdVCloNj3zvre4wsR+DsWI7v?=
 =?us-ascii?Q?1n6ok9aCH4ZRsXyvXDteeBa5m+88HClfNNqRSVBVYkVEOrrhnHZOCn0vaHPp?=
 =?us-ascii?Q?Nm8teSi6jbmSjNSevR2+FCGLnbSzb4AnYaY12IxySpSGsyYs/nOFOlC7g1WP?=
 =?us-ascii?Q?mA++VvbKxlrIzZ405qGdlzKbgnmRDtdK4hXBFZqCVhYQl1lgrJtmKg03BcB+?=
 =?us-ascii?Q?6hWtsbI30T+WHIIbjQ3hMD86mYJFPX9Krzesl4opsiQbgGtDCw/Z6jKj1Xk+?=
 =?us-ascii?Q?LSND+awtya0+bqXLgl/d4pXLElMgx/X/j9wcgLB+btWFYSqEMn4iP4jvlyiu?=
 =?us-ascii?Q?MBwxCwq6YsWmcTD+/Rl0jGKevO5d0FwdM+Vw//C/3i+m15aS3hYbc7vhhgy+?=
 =?us-ascii?Q?+V/ta+HhBVqYxwLK2GFQuei7CoLk6hDYYoOeu0mW72UAMXGYUZJsvZWq/BxF?=
 =?us-ascii?Q?bag4jMMR3rbg5xj/BGR+CkbCQQrIlpyXH7tHOkJj3FNPUn0PE49MOdBLdOgX?=
 =?us-ascii?Q?6ww3QLMbWfuz1W6JIFhoG1dx2Njgs/pOuXEHlh0qlUNPFeJlRj951ZHADWI0?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IiszuB97p5hkMz0vklcnFTUHZPcpNaE5cH56lY794154C4GrC/SNmEx1DIT/JmeF96z8Fve0FIoOzRPLEqmhGuCgBOnnBlv2Yz8R6jey+bgy8ty79KcyLJZqMhK1Epdz2XogG7zJP82NrCMuJdxt/e1W66p55bJoPfTwAsxnVd/4oG0fnJ8OKqi3VeSE5XB7yA07+X50EgueCh3KZgXVhYhlUxvdVD5qPJsw3+lahUx9EFJV3b7wj1uTH2YPsL+OaSlgh66+eDemy3gQwyE4RCN1M8IXt2KbRD/3WRYczc2FAWuiN00r7VY56wdmXhWPGcvJKAnf5KwHHO21985r8ULUJTo02zWU03WESOWHML84/H2ssDfN7XBJaFQqZvTTrWetI+l+uq5aJeCVXtdcbK4sVHJkp/T1NoRruqKyC66DXWIWtuPA6ZHuhdcnOwtQVcSogljl7o24ObLpT7WGd7f1cfd1EbaSEL7GuvD67AXcB702nqECHdNLyz9699Qpx/dCMrtOjgv4uFJtrP67pXxlyv8Sh+pPu9OelWPbV9BwI4oTLHAaxFK/8+l46HpXGbtHwpI5l3t/Aw9I/BP8EVzBw16A3fVOuRZnWt046U7ayVRKBypHMY6/uUrtj8nQyIqt82N9hjwjArw1OalBX0D3pBMwzFp6RR8fiSVfUrX808TLiBWHwq8lJdT5WgcKuDnnk+l2HwIFOu7vpU/h1SBEFoFIj25nbs+xCwIG6hNn1vK39UYQDUsJgzegeYlOKkJrOrLEXgyrkEDfUH8OgHCAhj0215tYpNokwjJ2FdJ7OHzF44hu0HEJXPjs+qzQ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a6ed94-16f5-471b-2def-08db8bba0bcd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2023 20:18:58.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aq07aZIYauWX8VbvKzJPWPMYgrk+UXf6BwI1Lw9qt5Qbv+ZFB8PnMNQb61vVSEwzq55OpBFccuweGH9XnYt6URtAz5WPRylbhuri9D2HbfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-23_08,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=587 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307230191
X-Proofpoint-GUID: snMjJ6dYsh3yDGo693LiB2oyTf6-BW98
X-Proofpoint-ORIG-GUID: snMjJ6dYsh3yDGo693LiB2oyTf6-BW98
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Update lpfc to revision 14.2.0.14
>
> This patch set contains logging improvements, kref handling fixes,
> discovery bug fixes, and refactoring of repeated code.
>
> The patches were cut against Martin's 6.6/scsi-queue tree.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
