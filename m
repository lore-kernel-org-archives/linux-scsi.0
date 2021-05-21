Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C29C4707D
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3CBF613EA
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhEUUCC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 16:02:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43962 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhEUUCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 16:02:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LJwXmS104437;
        Fri, 21 May 2021 20:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HEzZYQOQNs/EemiuBbuqHRFmDacodgmX7QI+zctPI/4=;
 b=hj/qAeDwZJY4LFoaTF7IrRCrY/XbvSzKQ9526ShPnlT4nTy6nP2IOC/qqBByvejv40At
 fdySdnx2/m6rwglH/QFFEq83yYHwYc6nwOlqZhmH0WABOpPxuItGclvKxjOnIsor6Yqf
 zGbss3xKQlpgC2TVmH6eN/NV8uVijJD6inw80DKIKn0SDNmG6vJ6PWuihtWRHvHRTR3F
 qI2poY3ZAuITOYIsVFm6cjq+ZZTsPPfl6145Rki/wqtKfTrRD1YXI7x9SUF0yzfPasLf
 s/ZKRNNjws0iI2EFKdGGct/P55PA6fnv8SPHszyDXCGoe+e/5Xn2snq8fU3sSaqmGRW7 uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38j3tbrqje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:00:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LK0Lhl097039;
        Fri, 21 May 2021 20:00:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 38nry3prf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxnpKjUxzqkAW4BOepNDtjrItluaBbZlDtolJd+aLQqXYslcSsMwzCeYsUlXt/gXXYZ4KcQMrcyICSou7wmp76tAHlsAxV5xo0s2JKRQ8IpNDVXfUqMvxihJDwz0eq73FInjDDSAvG3I3CTw3f4HjjlO6KELisfGt5AIkIvQoDkUo5qlD/bF/c1sIZGsPrN4/dCAMJHNbw/8v+bXhvg+vC+dXte14ENWAyRg5iuZOTYXTkmo1WMJOI3IjlyyZVkiCJ7T9KfUb5vfyZnrP5rPCbUsuNOUomMO45B3DKbYNSlKUguP3MwJ/++l1SXRAcLotxdAZKK3HveLtBaphCPB8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEzZYQOQNs/EemiuBbuqHRFmDacodgmX7QI+zctPI/4=;
 b=BVAw6iu39SruoUJ1nanV+wHsBcxUi0W0c7lifcsCknlWUmU5Mu6a7koik3uzwjgvqdrGL3CA1jV0ixccBvJDBnu106/veO9c6fjAJo6qtp/KWllhPpwTFnl9uI1R/8t9lyya1zCtUuJtCaTcNUBpR1wCJxBCItdaq/r+DrIybkkOMpgwro3PPRrfFHANi8vbOKZcjq0ZUIRAow/otptp278U4ToEPcJx89VdYv+Xcw7i5vCboPAsIFMfJ0TswOFc1yZ9nD9S7kmDpg4LYpBddxGxbp/6YUhv8AmtNwhbko/YTovhjp8sIpz/ywti9rIggd3zrsqJT0VxUSJ/QqCCzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEzZYQOQNs/EemiuBbuqHRFmDacodgmX7QI+zctPI/4=;
 b=FCv1E0BfrNOO8gIl6jvrKZlSsjXlUe7rMLGIEwjG3+btDjMzNg7Aezr3ynoWMgSqwowaC+Le8p1Apdyzfs5Rn4/EBm0fsMP+DUPB/hW8D/wwGRT/GgyLRXUv5grL9+J/P+Md2CjZMtGtr8FDCaroLD96If5m8aMaTNdOlSWE0NM=
Authentication-Results: philpotter.co.uk; dkim=none (message not signed)
 header.d=none;philpotter.co.uk; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 20:00:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:00:14 +0000
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: skip checks when media is present if
 sd_read_capacity reports zero
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmxj526p.fsf@ca-mkp.ca.oracle.com>
References: <20210506073610.33867-1-phil@philpotter.co.uk>
Date:   Fri, 21 May 2021 16:00:10 -0400
In-Reply-To: <20210506073610.33867-1-phil@philpotter.co.uk> (Phillip Potter's
        message of "Thu, 6 May 2021 08:36:10 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0092.namprd11.prod.outlook.com
 (2603:10b6:806:d1::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0092.namprd11.prod.outlook.com (2603:10b6:806:d1::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 20:00:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10b7bd28-3fea-420a-7bf8-08d91c930c3b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4776:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47763048C05283D0B8688C178E299@PH0PR10MB4776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uA6r5v1GdjyH5oNZgzDJHKATxUY5EMzHPe77JDSnIczs1RJ2rUG+8qP/fuGtaTLDb3dIaHVY8UfNLM9zvYB1Wsmez9NSCVJc9XRDm0bqwej1LKq7xoVw0Way2ds9LUIrcoC6nfTfCfsUWsyXM0c4l5F7madzdBsdKm02dBeji1Js4hMzjJdN+wZLZwKWSC3Kmbk+fD3aHoWV+hGa/PBBnjQM4x/SGMnL4dVWiTzZqH/6jKuMwjsNsOBl2J3qQaKfi9vPxDmESwb09hZu1sIQKpcMXiiXZQMtb5vUQWjbaQilbm4v4KMrf7CxULGni1nNE663UBre7l8cl9s7rYlDiEdauQ0SKV3yhjdrILp3eFi9IwK925byv7yBjONxPZlnbhW3cUFSFfQy3JWEVvfXtpuEGk7BvCNR2KXWMvwi98xUSO11lLmNBmGEfGQGHMeAKHyOVuFZYxNL2VFcpueJHs2SDCwKW80JkQdsXFZ3esHoSLVuKmZnz1Iz/oOgF+tm4NCCA9WDrDjZd5UHMop+e1UKE6URBqroSAd3EubS4t+JHPUrR5cDkTN/xd2/6qe5209+5FzUKGkwH7/19czFaHZIGltfMRMvoDAA/FTf2bOYTiLTDyfE6hMi7Ik9GIhpL7hWvcctGHhec9vmTSi6BLuRgdXL1shvWulExKifeqsWOOY/QL5efuYMwu7d4Z0UoCHUfbEdOC/n4KrmgHf5TmR/9NnHvXcxapwzpBa4qMMAPbdiQxsDZrAGNvI2SrUOcxYg0ODpIWZ3tHsAsG2LyPbeBwr/aKOwX/LEeBb4W0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(136003)(346002)(8676002)(16526019)(36916002)(2906002)(66556008)(66946007)(66476007)(4744005)(478600001)(26005)(7696005)(966005)(956004)(52116002)(5660300002)(86362001)(186003)(8936002)(6916009)(38100700002)(55016002)(38350700002)(316002)(4326008)(83380400001)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ey1TDn/dSe6t0fudbIzb58FvMtkuLDJ9ZL056ZrEmp/2MlIkDd3JOzE+Qap3?=
 =?us-ascii?Q?ITzAe3d4fOosmgxnX+RFvQ9x3anU6g6IxC6F70DDKMO5QX3OMPADyUpMJanb?=
 =?us-ascii?Q?kzV9+TISl1jx4V4LHZRkeB7864zdOqIT9gJ5oWiTOOLFBRgV6uepGl56yWZJ?=
 =?us-ascii?Q?hBs5boom6ZeLYeEsOnt8l4JYP0R5BSXLNSmn8hjMp3haU1WQDSVzYiOQjTGU?=
 =?us-ascii?Q?MozSMONj3Kcdg469ST78ve25YCd7Wg4WFIZzTiUGZEhUMQUeDqTly/GTNt6v?=
 =?us-ascii?Q?LzkQXRumFC9LbavcbRIORCSNbZFZdglXWIoughV8GKC1XugSiIqjUzyVcPD0?=
 =?us-ascii?Q?SPWo1E3KrddC6hCiW/fawOCDNDTayj5lC1dIpag1apXrZVLCRV/626Lbcfx3?=
 =?us-ascii?Q?IgS1fqgKLcrZWFbi4DhUpeIgNe2LHf3OlzKoTd+MI2zIjb3e8T+fql9z1XY+?=
 =?us-ascii?Q?Zn8LMwsTuzDh+JFnWmkn/6WPW1ZjnCt5RNNz8mJimn/rhmaPuSRKyJ53diVw?=
 =?us-ascii?Q?u8J/WFm/2GFIhDWTMkjTm+CLA9gTE0RBly+CiyZHfnt7WYp9C1ju0ar7pGtv?=
 =?us-ascii?Q?A6xgC8R6Pe+KBVv1uzervDN47sj3I6p2ppnl/JxnCEn/1v3ylUKm2Iwf1edj?=
 =?us-ascii?Q?gUG/w22/r2UG+wtX3lC3tVIm/VKGvENXW7YvWPHAjPljr7sO+xuOsA/M2dLY?=
 =?us-ascii?Q?HnsIJFTEHJlGhAlM6z4Xs27w6nAqzvpVgAdlkGrLpwZv9ijBUpIctflyRTtc?=
 =?us-ascii?Q?PZej+n/Zfg9s0nqz3Gs8/UC4UCNvJnaYEijJ4BuqUle7hsn52K7L2MFTo665?=
 =?us-ascii?Q?CkxtZE1jXAwMIclFbMjLTP29iwtMWShvrWQiH/mdkEeH9Rt/dioDF1GdAMS0?=
 =?us-ascii?Q?Cc2jTnZK5LrWNZI0Lb29EyJjPN6NAs6dfLwe2KZ9r3r5VqsJWPFEbAKZTsU1?=
 =?us-ascii?Q?rjpPbuVPXTLsDFuVquPKXhRq9QRCn+2Dh4JEuTUyeYcL63Ya4uxzIBwpj3Q/?=
 =?us-ascii?Q?kKDOALoO99HBeXYPn5EbYRmNLQoioSnb7FHGJgW78WZQt/kl83VvUz+tCT0j?=
 =?us-ascii?Q?1jVJ56osb6PbFKefgEV+ZTagV2ksMctNnK/G8/k0sY3mRqd3RVg8wD8aoT6Q?=
 =?us-ascii?Q?Grs2e0SmWNpT7k+toAwSR7F3MDHLXEVNbCSKaI5HmbHBV6qm4CJoXTSxOTk3?=
 =?us-ascii?Q?6TIQdyYMEMfn9yKfgspA2d2NcvrolC56RgQy7oHK7kUci7r8DIDmJ4hL4zeZ?=
 =?us-ascii?Q?GwWPRi9PWmIppsfOkap7+ObAmnSle7f/anWKUzlO5dprlmU65LUOuY5TEhT7?=
 =?us-ascii?Q?T86rJc/yMFpXYYCVPEhd/ZqW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b7bd28-3fea-420a-7bf8-08d91c930c3b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:00:14.1417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4EIvMs8IkJCIYebvS3uhzg1FLhP9t4FdCJp9X0YIm9ApaXMzhqrnpsSVx5GLGbS+PsbiLspUoWJbIKE7rmXslo9KDcukcm6SJM9jNfgEpQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210107
X-Proofpoint-ORIG-GUID: J3t4oxWIIqHT7bAZaS5LRwBmQsxO7hmu
X-Proofpoint-GUID: J3t4oxWIIqHT7bAZaS5LRwBmQsxO7hmu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Phillip!

> In sd_revalidate_disk, if sdkp->media_present is set, then sdkp->capacity
> should not be zero. Therefore, jump to end of if block and skip remaining
> checks/calls. Fixes a KMSAN-found uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=197c8a3a2de61720a9b500ad485a7aba0065c6af

The reported read of an uninitialized value is in scsi_mode_sense()
while inspecting a buffer returned from sending a MODE SENSE command to
the device. The buffer in question is memset() before executing the MODE
SENSE command. And we only look at the buffer contents if the MODE SENSE
operation was successful.

As far as I can tell the only way to end up reading uninitialized data
is if the device successfully completes the command but fails to
transfer the data buffer.

But maybe I'm missing something?

-- 
Martin K. Petersen	Oracle Linux Engineering
