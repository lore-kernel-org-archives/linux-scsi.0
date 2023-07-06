Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73002EB64DA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 02:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjGFCFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 22:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjGFCFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 22:05:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4721FD5;
        Wed,  5 Jul 2023 19:05:03 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3661A1nD016107;
        Thu, 6 Jul 2023 02:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=rIXl5KET38SI8CUYk14sAbROUHLMFIdJwT6+vxHyCYA=;
 b=lugdoQxbDa+iUH+JExRFd8xT9rEyiWri99RuULOGQaluZfX2SW6KCh8q1r/2OaN+TLF9
 /aURaFSCea6EfrjK94rSkhmrzQ3u9j0q3+PdMdqZkN7X/ikt5CL2VSXthyoC6plaPoAG
 cppmvaH9o/waoqr+9wBUMUMMVrDORdjBk/ml+xKClO8+1QXzo3PUALf6af0DFAhDVRHK
 QIok2JwIzY/pDQctYQ0nuuZTsRpHRA83Zv2F0eAMbk03byZLy00xrvZmjxkMV+7xQJFy
 T/BAyQx5mikGm2pbqP6w/+/ivParoH2fjFhnfQDFQgv6+3f8jeNlcymMj1N4+aM1lMKb Gw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rnkpyg1t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 02:04:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 365NbAs6024321;
        Thu, 6 Jul 2023 02:04:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rjak6u9ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 02:04:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MniEXY6ZimTdWRxxRLUkSrFraBbNSDHWSDgXVCU5yxS9AFoqlsCVw5aF6iiWBcEk1yG8kofrW9MClb5EFaEgC5m/0pmW0MZ6+xK7cPD4mvxUcLC234Y1QyNQphebLIBiuSEtMfbBnWEi/OTepcFB9L2I0FNM8Wj20uaydCNmnR153vjl/Hzkuoq9BIaDYk4tb0W/SpsmzHHFSO9tEQJz9E268cHOrAwV7jQ2Axa1GdmMw6KvOJWcR3XYDSZOe+eAu4lgLmb9G7gbx4RbSa2eESx6JilatwatjsBNbUbw9mSF7rUkplQHfrTZGFNjNZQbXTnYOxgdC3WyFBr3YRw7TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIXl5KET38SI8CUYk14sAbROUHLMFIdJwT6+vxHyCYA=;
 b=KIC8KD/UM8CdTQ6X4HRevHxrpTR7EyoxSAcHweQDNlxCEM4byRDjMDju8XD5oxXcloUYZehwVayBpLQOvBReU80NqgrcpU5eDNHFKPCqpCtIDXvVk9G8C84zW5FzNZYwNAPxcrSPPeUlBi7b4obMUzu6csanADVDajDXHx8cYGYkDguUekLKIlqdw6sJGgrgfZuAOXYsg/QRoayMvSAgD034VluKBM91wOAnoMZB7cWJBrMDsGqQYoUA8g8fLYmyZsy3fYI4GApExmKqvWtUS56K5vFp/a7HI2nvYNfy8l/Zmbd6pdSN+6lX6d6Ko+kbPtSx49hOc2orCUT4iVem/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIXl5KET38SI8CUYk14sAbROUHLMFIdJwT6+vxHyCYA=;
 b=Q82FqQydUC8yO0+fNJHM0AMNgJbRX6/IhxHUfZLGF6RD1qERm3Xz582mUl748/tJcvfHDwcHckegO72DFK+P8RFJymhWDtr88/8zPCXwD2Iod2D2GX2AF7JtGUmM1zT1HfRjNcnP87ELUeE44dhTY5TJ0yQWOInpjup4l4bWqOQ=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CY5PR10MB6072.namprd10.prod.outlook.com (2603:10b6:930:38::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Thu, 6 Jul
 2023 02:04:45 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb%7]) with mapi id 15.20.6544.024; Thu, 6 Jul 2023
 02:04:45 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/5] Improve checks in blk_revalidate_disk_zones()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wmzdkd7u.fsf@ca-mkp.ca.oracle.com>
References: <20230703024812.76778-1-dlemoal@kernel.org>
Date:   Wed, 05 Jul 2023 22:04:39 -0400
In-Reply-To: <20230703024812.76778-1-dlemoal@kernel.org> (Damien Le Moal's
        message of "Mon, 3 Jul 2023 11:48:07 +0900")
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0014.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::15) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|CY5PR10MB6072:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b5b5c4c-39b2-4ece-0c4a-08db7dc55ece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPeg+cqQx8Y32UB6E4p+1pUj+jBgbilGg5AD2zodcqc2i2k1p+IrHRvOG4zppdhbAFTA/udTvVmw3ymkZCsklkU3W/KCiBfZOUFZmk6XYbJFsTAgyMYs5LUtnKbxARawLXpPafq7q9dqwZnEegFOT9EQpRYNLeJgBbHrTGj78LU47abSa5liGU0at94fLfEIZ+7EJSnsK8pu9+8k2xIh1chSub9Rf81xWB01P115jSQ/Ogti6i2wz0R9BAueNaMsfXipYlKklUSOgvrMl+kaQ19ww8SjGCd9ne2XPrv6MDAD6cJaUB4pT3vraLRFrEwMJAF1FFrb02G/7+Uf/O6UbieGzMK0AFbuarHE+9CkxiZnguxqEqtTbYUjv/ckeQ6M06Oy4KdBskFEnEObem6nOxrqEof8/CiNXk3l2ZWFKkA7ihlIgKmPBH8TGHWTrHqTz4er2mlgEVC7XEl3Q6M+4lQRFQSObPpP/IoHiHLDF0t2yNHxbCpJpxjJQFkdl+MI7E17rhtAZU0TLgDVnJiUNWskEW6q/IomxLgNho7+VtV+cqyc/9oAIb4fIxqCWUrN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199021)(5660300002)(8676002)(86362001)(8936002)(54906003)(83380400001)(38100700002)(41300700001)(316002)(66556008)(66476007)(6916009)(4326008)(66946007)(6512007)(186003)(36916002)(6666004)(6486002)(478600001)(107886003)(26005)(6506007)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J4UUMRhue0RNbrQm/1KwxfJtEQam5hJTk3XL5AFMZ+yC9HpA6D7EiWYiLkG3?=
 =?us-ascii?Q?l/vXr1WNgHVhNqb7FQ45xhLr10FTM7JUAuEzhuZq5mBJ3cc4Y6gFk62+I2Kr?=
 =?us-ascii?Q?wMF80xHkvJ9warjcCe3kNFu1J1sKj68xmhtU9hc55l3c+syW8NbbVEjwosNo?=
 =?us-ascii?Q?GqoW+81dXpDlaYfrPT3X6nnny8mYCo3Tl9NtJ1wm82BrKo9Hvp4Ss6T5rAVs?=
 =?us-ascii?Q?8lT8z4D1qHzZqJajn2c/J3/Xw5oQegx/w2I2g7hESSPBvB3RGuYkoVCwARQp?=
 =?us-ascii?Q?4Pv5PckBUNkhy3X4yyne9gsvUSna/A+mzb8ruviQoaJZlCJvvSsg8O1OcC+g?=
 =?us-ascii?Q?eBV/d6/wOQvVq4njOacfn4I3/G1rzqDUElJO7ONRrnR0zW9/GdiDn5v1az5G?=
 =?us-ascii?Q?/nDm6ky1wWDyWxRJBcxKvRnle2GE+GMdl41Y2nBFBauSg9z6zpgE2cxOGAdZ?=
 =?us-ascii?Q?/xNtQ+eeFSjwC8VkK1R3CQcahYt8vEF5L9Ic8JHDpCQR2Su7Ha3fhWYkQN70?=
 =?us-ascii?Q?ibZ6VxTi7xuUCxqmXPxNtCnYgraDz5+JeMwV3GYdggbFkF8Co/o04T8IUAWA?=
 =?us-ascii?Q?IfmPUKyjGRbKxxnqmaXXj3Jqu+uVpqtF81NbxJ2VR3oGusq8qQaHwyINc+rh?=
 =?us-ascii?Q?RYZHBUhRIevsrKclyNr8koZtMWHJi2EsYMR9DvYEaToVhNrwkhyyzZwQF9oi?=
 =?us-ascii?Q?nKX20oC3V+c9mDGXcjATTsQ6G4vUeRFAueOOf8untCVPTIvWjBp3t51YjRPh?=
 =?us-ascii?Q?xoTkKDL23fTwScHWlsafcUmDY5g4SApE51jQbD9AMKzqjg2CelzSAh+od/ha?=
 =?us-ascii?Q?bRqW1G7rtCyfdwO1fLkY/kRH4yWg61UmIF7BAn98n899Pzq7s3zC57pvXYo3?=
 =?us-ascii?Q?xgC2tdqMbSY2qUdulHuR0eFSxWvcF8Ox3nExxKMOKlviecDHdREOLqCq7GFN?=
 =?us-ascii?Q?ZB9dV38NHyp72iIicKK6T31+g6IyPdEAa0KSIjuXcqWywXPVfYqxMOveijNI?=
 =?us-ascii?Q?dVFz0NX+kE0z68iU1qrQM6Vg6cHJ9R31g/3OSLprv653squSNGDuvcUSpqA5?=
 =?us-ascii?Q?+eLKqHm+4B7EBGsT6mvVBb5ady7OOITVsoeGHWI0zBOQxZWFyVcz0qXSdH6C?=
 =?us-ascii?Q?HgDZPCsDzxfzgahybwqd8fw7lkvS8mEMugdTvC1Yi3yadWQcmH+1nrWdL6Jm?=
 =?us-ascii?Q?JnU2YY+bS86JfBopy4wWd2HwZVVjGSilPZNehGnzJCHPQUQ7ZmNT6W2IjFrE?=
 =?us-ascii?Q?GpLyPzkmT14gDl8rVOamm4PeW8OAGA779qXuEuUqUaKuigXhVxaAqxaA/AvQ?=
 =?us-ascii?Q?j8Dv/LpSSnVE1dXYyFO/aaGVrjCPKRevNezkuuHXa04ABqN0uKWU9d+Hz9Oa?=
 =?us-ascii?Q?Etze27bC6mRqLpqOozoIZb9A48sjpPbcdmEShNB64eFppIXGhbxiGRWnijWP?=
 =?us-ascii?Q?WqyOKT32DVq6RqxZn7z4E7fOPnPEBIt3r5WeJ0g6vnxRZ4wKsK26Tsdf0LF0?=
 =?us-ascii?Q?p2SEmVoZeLmxASfrg5xZ001p1iAIXNX3LZYDTPfLYVlQ+oPEGsVY5COeSB4r?=
 =?us-ascii?Q?M+vGGRRrKzHTfjqr0VhnYvPElzesh+lygQ3BY7qj6/ijDSFDacoREmQCGyHA?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: acxjIZOHiOvBXGYO1uL7tsVWz3O2GdjeA99TRyIW8ggYMwI+a3B8h5PYZ4ERoLVcxht2OuNY3CpUYa+/Zp8kKAWkijUJilx/daZLCeF31hikMIxQKCY6fSoYj69mPJhHhQUZ/nwlVlNRDq5FDKsC/RtLGj0H0ZrisG7ywVACmAj189+df9dWu2w55jb3rRIOWpr76fSsvUJscYbi6hKyMbv4Mhs7gA7y+yd6DxJpqIcycKmjm/hFZwUNCr+M39ufjOi09sgyqCNBM9ZyoeLIkbSRnIw7AFxwcg+5yL4ZOZQ4nChgYRkBiSCuIxYHIzQ0hrLNXaiTnt0spWJSoV/l3nmbsI+y3RvjQLpCEVb9Yp5kfzSpgRra1jWS1AIJ1ZIgPyy1ftkHocfQNCobo0QsJnqIF97h0qaNfTdZg5d6+ECD8N4eibtwqWmWXTpbtG+GpNphIqyHiCeKuhL9MNnbpknQJBmiczEdD3Dy3XrJ8i7Qi+i1YZuwslNLcAbpc+EoUm10yRhUGSJXhDntZi6W1C3JuyMwjMvtIq58OBFjZkJwjeAjO86y81wCFzzbFGp6YW8eTp6YsRIcmDAfE0c2VjV5YJJ18o/GLMGLPu3drFU6fFGjzZ9erVo/TrBecKZnlXgZUoTrFezUluBBp5v74f4KVnapcW5wBIcrb8ykZnOwi5GIYLmpgmSBh2MRrVZfP3LPtYfoNgrMZl8uPgvK/8HtCtSYTtYzelsakbW72prchwv9/VdRMVJ4RMouQXRM7JXrwwtMnhWfFd4+u34/6lqvwvIHCBcmgHJsUW1xUDxYHKfwKjq44o9VwoCNcI5gzj6Cc6IB0yI2iA8kEUaYLv7JLChtmZLMk6a84xpjAGEhkvOfrhKKs6C9Li0oLJy6
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5b5c4c-39b2-4ece-0c4a-08db7dc55ece
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 02:04:45.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71DaL36ImMGojxr5Uf+8sLe0nYYdxT58ohfohrIvaSZUlPrdK1Guc1p5lQ1rVWXg9jHwbJC1XyzL9muJjtnkn2rRAT/TnSiMHyB+stV0VQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6072
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-05_11,2023-07-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=349 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307060015
X-Proofpoint-GUID: j66nsEM6Tc0qPPHnuiUsdfmqd-SC3rrh
X-Proofpoint-ORIG-GUID: j66nsEM6Tc0qPPHnuiUsdfmqd-SC3rrh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> blk_revalidate_disk_zones() implements checks of the zones of a zoned
> block device, verifying that the zone size is a power of 2 number of
> sectors, that all zones (except possibly the last one) have the same
> size and that zones cover the entire addressing space of the device.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
