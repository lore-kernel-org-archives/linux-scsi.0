Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A720AC04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Sep 2022 17:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiIYRgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Sep 2022 13:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiIYRf6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2022 13:35:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A63417A80
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 10:35:57 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28P9RRbc012930;
        Sun, 25 Sep 2022 17:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Krp90n/w8bq440xaFXc5HAu05j+FoxJdwbOuUCjns6g=;
 b=rNSZvGh1ZG72Dt3fz2WpSrfDmyXZJk1st142OVZyFScPm2aaDEpXE7YWRGw3UhC+15pa
 ih8G1vg98I95rKCpWmdy/k8rMWlT9tpnh476LJItppoCY24sHxNS1f+/zZovpMOui40u
 HR+xbEirQDf1TyYwd+TGZ+gSpdiihl90pJ47/DAVaY1dCJ9i+sewOau16Ok2svH1PWkw
 d+OsAbFBRY3EeTEwrn0mmCw/QGsE70ByOkZPZxv8fA4yQ+3YF4Qr57hWN9C7AxyCvM1F
 4/scXpmG57Xy9sdN+nZWiWwgtYGMdw3f8nuN88jDF8Fo/nV36hdcU8B2KMLQPbIS1HrD tg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstphyk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 17:35:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28PC75X0023774;
        Sun, 25 Sep 2022 17:26:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpq6br6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 17:26:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbrheyG1DUloin6zMu3RBayTmUgslCMhs1g+nPGRqHbO6lVxlTZtLUWc5zIuXq8ooZN7rTztv8O+iT6Om4zrff3tNodQ/+cUBw7pc0F1XD6kTYCu7tz/k6ZLnlkypnooKPKadGg4rlV3YPsUIvVXAF8x6vi9u7FwW3KtWSd/bPv6fdQOPFNNmxzj4MgHK+k+UiorkOqnb6eaMYt1qWF9is6r4C+JL7VuGvxEsSyujc1QCY+9MjGx70ASzyrjzZcaLKymU3y2KdZendJVdtMI+mrzPf4NgUWuHnrXS/LjBM2LAlTcxawjRR6UXM+S0ObrWBz1LNfWA8KbqjMymy+oww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Krp90n/w8bq440xaFXc5HAu05j+FoxJdwbOuUCjns6g=;
 b=Zav96YkpFQXxAmN62NPkYWm0pIV/FjcHv69+TgwrXO7F7F9aRLO+8epjf+pcOqJDu38UDhQyfbsOOJLT8/8Q8AkvwEeCuR/nou2uYnRXsbBFh8vWVdgje15qmdpDCR2zSj72LLAUDKclJ4dWi/77Kt59ojdB+q4Yh3ZX9wxfk/JscMp61ANqgQpOaaGX691yB0w/ASv2/NhVx1YxVbo8K32aQsBWQJVpEErwDejaRK4cUK4h/QcR/zxHQ2RSVuuo03XKXniwtY1Iiz7jioIBrjjKhohCfn11O/Yo/3YNifmnKE2rAyAEvsxpLY8n5evDN33JB9w/O2E6WZJbpMWGUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Krp90n/w8bq440xaFXc5HAu05j+FoxJdwbOuUCjns6g=;
 b=A45+XvgAkSkXGsFfZ78jpQqEb090zq4uD5CYKXKTdYe0dzT9uKrawmrGTd922Y+h10IZ5QSQny62m5qdelualjY3DWyrCkWYUqwZ8AaSSKslbg6s1YYV4P1762KeinxZmE8Gez/6YOnxfzWbkW5Jpe1AgvTp/JcO0vS4m4uUAlw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5124.namprd10.prod.outlook.com (2603:10b6:208:325::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sun, 25 Sep
 2022 17:25:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%5]) with mapi id 15.20.5654.020; Sun, 25 Sep 2022
 17:25:58 +0000
To:     Wu Bo <wubo40@huawei.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <bvanassche@acm.org>, <qiuchangqi.qiu@huawei.com>
Subject: Re: [PATCH V2] scsi: core: Add io timeout count for scsi device
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qrzqsbv.fsf@ca-mkp.ca.oracle.com>
References: <1663666339-17560-1-git-send-email-wubo40@huawei.com>
Date:   Sun, 25 Sep 2022 13:25:56 -0400
In-Reply-To: <1663666339-17560-1-git-send-email-wubo40@huawei.com> (Wu Bo's
        message of "Tue, 20 Sep 2022 17:32:19 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0040.namprd07.prod.outlook.com
 (2603:10b6:a03:60::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fd9050f-9ab3-4b52-de89-08da9f1b02d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vYSzpYl9n/RW6Wpqcrgw6NZ+WzwgCay9ShOF2d8CLHu9cX1INo8nyF4EDBx3MKMpuKDu0gDNbvrrMChB73T57biT8swglQa3GhXC52ay4EAGJh0+stlCjHAysBav7FOksPjHvlhEZ1qukC+sxBkgPrQfOeXlrlb9+XiuqzHtXE0vVtFUWM4CJqTdTB1TWktQqQ9mR/ApvQjCletDWSHMsC0q3tFnoMoS/7gIOO68wMbCEDzrThFPtjyWSROLV4lBu7OC7cpcdB2GMfg0w243ve5uUHGxdsaSs+wXOLHrVTeLAsIUz3rXkqFDnW0enLQxBmEtxMXtQkgbdgeyq3r2kdgC2Tp4N4WxUz0qXerdP7w5PLyqd+G6u7JYxv20BHs+igKaZA0FErKRRQnYc+OxZqETeTda5tP1fsTm3HD3dbIa8OqQwFumCISvYe4cORVQGuv3TSpXRGgvRWYS2AYoDXDm4H468qAOUMFxdRbrbzwoACIVlUZ1EBQ5He5xYdwr/m6t+uwYl+h+pZiDMsCSejyH05wwmzanRpGJnh7XPhhB/tblHI4CYLhLWFlZrPnUKEmSuk6TQqBzvuk6IMZmM3mx5QkM8ixh2wrdYXfVV7zxUfzpqrntivdllZ/1Xi9oi39mQx04uvaRmnxq5njP7C3PlHwgAC0E7w5bvX/YtHniOQFwKFS2ANPGM1G8lFFNnCtbDG1jws3yuaHmtq9Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(38100700002)(86362001)(5660300002)(41300700001)(36916002)(4326008)(558084003)(8936002)(8676002)(6916009)(54906003)(316002)(66946007)(6486002)(66476007)(66556008)(478600001)(26005)(83380400001)(6506007)(6512007)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7pq9ZW3wa8eMU/P8uyvJWW/ZTxbEjH5YG+1wFM0LLLW+SNuMSxxb33ncVTUo?=
 =?us-ascii?Q?gSMXDBPeKcDfMnHPdpKsqyd0rt3D2H0IVfcv2SZz+EOASkDLPt8biErI7kED?=
 =?us-ascii?Q?/gm4psbRFKBPthUAJ/6TNIVd4xjXx3GgjoAdtL3/1axgurfJxzsL/jpufGxw?=
 =?us-ascii?Q?6y5dRzC4El+P1I+L3DXEqQ2+f8mUxDwdS0khgw4G2FpTs5JYIw0BIFpye1+P?=
 =?us-ascii?Q?xt3ROmjJ8Jdp3/J9Z+i/CKEtWPJYpaVI7DJQ8+N/Iy2WczFjbaL5IR3POcOD?=
 =?us-ascii?Q?WTqVY764foqquyKAg8Lg5bJcCK+5uKHedVWsIgvmTPxJBxn9qSd4ZdhA0GZp?=
 =?us-ascii?Q?AOx6BPJ53MO8HQ/6F0cVqJKaGrbKCmmKOQgDMA9kbLjKv21gf3Pv1IwoZQPD?=
 =?us-ascii?Q?W/kht6Ce0vIKCTfZl2VJJ95WiZoA4zT3p59I6vOQD3z/z1EmoPmtnXdzlYZ5?=
 =?us-ascii?Q?QVVl+RhVtw7yNAvDKWCHrd1+koYy2KGgiyG8PFuMw8t19YsRrtuzdwSno+SU?=
 =?us-ascii?Q?2GduFZyFJiM/amUP77X8Yz82s+ZCg5++g8F78T/544/4oZZjTsX4ey6o7P51?=
 =?us-ascii?Q?JO06jRwv0SpRlYkABZnY72R4hosbbe2aZmQdos3lNhxpiZqleCLph/P+ej8s?=
 =?us-ascii?Q?hE9Dc+BwSzEdpseVZ92NAjJsgNayK/ENBn3bI1BQIZ7yn57DPk5ThDf7i4Mm?=
 =?us-ascii?Q?D/bMjV3gR9jwJOiqHJM8YgSeEAy5WiP2uDyCRRT1xL+LQ+3liCUm+AblixNn?=
 =?us-ascii?Q?f/h41GJVx3KpD/MrzhXua2I/+ycaJsSVTMq91kWZ89WmSyJtR+gEbebCJwKL?=
 =?us-ascii?Q?1U10StWJQdsCwkRvmJoGazxdF09MyaMRuP1Div0oiQwBzWIOtiXA5ISuzC5a?=
 =?us-ascii?Q?NLtX9TSZ/zz0ltmeCp+Lm7wTI9CY3djf/yCsVjPeDoCBOryF11ufqrcKLtu0?=
 =?us-ascii?Q?juGO2sFqPjv5FU4uxmDVpHTmQiuxe21qoMhlHvsD4oeIOjg2oZeMhvIW9XXv?=
 =?us-ascii?Q?K1MZpo5mVjOXtJ5Q7rzhkjHxfGfHSdDeBsKtC0XAYorNSTHxz5dIC1RXOXKE?=
 =?us-ascii?Q?1tfOqh7aA93VNff2XcIMcLDTbQepy1h/dL9CZfp8AKvS4elERW5odFzV7gzp?=
 =?us-ascii?Q?InFup30IcKZizR9jzvcYYUW9Xd3xVLQLECGAqT4PWy8zEM4yOmhaYEPDPPPS?=
 =?us-ascii?Q?6GcO0yS8ydjPY5NZHrrlR1mychjiR78bC+q0BSwAm3tMSqHDxG/c9ltoBfOz?=
 =?us-ascii?Q?VKZPU3fkB1v7rBrbx/XnSppVLMUre8bS8RCrO4AVUe2nfshyC/ohTi+r/gy0?=
 =?us-ascii?Q?M5ApRt1mVmxVt39ilTgE9Bwh25r0M5hg6FlwiuIMr2j9Jz5bSb1RpMCYKAov?=
 =?us-ascii?Q?JvSxj2pD1091k3AHJ5orVGaAYVaD7sr1JVPnyOSOWDHr4x5PdCN9EuDUnpmi?=
 =?us-ascii?Q?b1Q1bB1EOEwLoBKXbVLa+1wkMLwzvR5tK/ZI5RBNSLfkuZokQYvvtSUjWbjs?=
 =?us-ascii?Q?YuqtFQvnxH0yP5cqGse7WPIKj/m/z7KtzFtSndyz7tzTKxwMTYsXs4hl3I8k?=
 =?us-ascii?Q?j43Jt5kS/N1w3zJ138PVfhxTxl86Mu5tFEOTE8ASADbIaUGYBFYjT3cy1VHs?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd9050f-9ab3-4b52-de89-08da9f1b02d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 17:25:58.8321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVl1MnbnwKJChE3gJWg5+hKtlypKVDeInnPPbd/LYTKzsHLOeXm1teG005sBn7MOnGBTQgML6X6kmdfPHUk4JiEbSB/yPd4yTcA29/+UCvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-25_01,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209250127
X-Proofpoint-ORIG-GUID: 0SA9iqaJyyWcSDvX5ZDz3L4TYusSo3bW
X-Proofpoint-GUID: 0SA9iqaJyyWcSDvX5ZDz3L4TYusSo3bW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wu,

> Current the scsi device has iorequest count, iodone count and ioerr
> count, but lack of io timeout count.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
