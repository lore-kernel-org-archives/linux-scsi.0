Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86375C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C42A61428
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhEODHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 23:07:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58836 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhEODHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 23:07:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F30bqY140010;
        Sat, 15 May 2021 03:06:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=VvjzKDyxTq09avI4g/p5MAKIqaepsc2fAzc8FLII6D0=;
 b=vVYUSS8LbrkEVpWMCmpXO7r/JBglJ0OknI1XDjQKg0vcYhjfWImcpBZKeglHAzyrguKV
 E5CSB+CDdCFH5kb3MJ9/+eVOs+xV2BaVWBVUhqX2AUcqlBgnXCJ+2NWrWKQdT523k+MN
 BQkbhnOU2IPcCmWOsf2mAdOPitk+C6uKK/jdzIRByiXw/FtqG3Tk1qzo6ZRVnNORdjf9
 5j8hgNYVDkN6WKbPCDLn5bEF10m03pDuBCF4TfHxsGOYKYG+SoQWgkkUunIVFi5ejwQw
 jwceXP8nkQH9qCbOIRvqILbRDeHMs2stXXrhvitMFwRMCVmDWfd6U4BoDYfVmonAHeKF mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38j3tb82y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:06:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F35oBJ075644;
        Sat, 15 May 2021 03:06:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 38j3drav1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:06:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBxNe37kSzNrna7ZQfgwnGRn1nlhneVYNtNhRqB6UIEX6698gmNyJ9snOzUjg1HUb7P+w8oof1jx3CYIo7J2lAVWJls4MuCZt1PWkT7a0GX2VmEm29VukSKipn2HNBpDjOHeIC5116sIJABkhYNh3DbSXAVey5+5nhLXR4WO0D7Fu20madXXK2z7cRoGbBFm+2jGf0qn5WMzGq+luIe5x3nSf21JSr22m4pLsrtwpe8om1vLXRmGBTRyN5r2p+OyWTwSqpkWTZYs6qkvU3APaKzR6zAMmmwlNAiEyK5rOaGBZhsp3S1aqGaQ3j8lckzcemKYQiJ7Gzb12BC2WPfRfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvjzKDyxTq09avI4g/p5MAKIqaepsc2fAzc8FLII6D0=;
 b=SZXlsF8bANb2XSaFAOBG32ycRW9kyJLuB5JllpZ8/OzWOUIQiuGg6mok6DE2KelyBy3hoCZ/TYCnW8/9+/e21HqJP59WT5DmA5YR+rmbN9v1P6u17bE4AkDriFIOqFYyj8i3fhWPskliFkOkNnIfgUPnmvJ7a+CH0XAgjHJ+o9A1O/zhoMMBTEWBL0BdukQq9V1jnl6uzGNxIn1evW4TieRo8vlawfpjTPGQuwxejyexvegCxSzvf29K8oyacBT/EVDHXd+0XdDo2/jDhTGSPMig6LDHL/nelgUmMb+qj1HR+DFlhfHpM4TEq4GTH6aly8oaDy6ysgzeOiXOnKnzNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvjzKDyxTq09avI4g/p5MAKIqaepsc2fAzc8FLII6D0=;
 b=JMqAqtkhpSWMI2Hoq5e/O+exk4YqkujxNIAivqNzcGCNzSWL8kzkmvLLh4LGIHkQ5lOo4UWXlC2DsyHjZhve+VXAQ1MeC+ogkO4PPObCtQYNoALOqsMK7tJeCRxdfQBzVFyUzntI8r/Mel8o8RXYk7pETEBLmDSqfpx0RWhH1GU=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 03:06:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 03:06:14 +0000
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: message: fusion: Remove redundant assignment to rc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s4gae77.fsf@ca-mkp.ca.oracle.com>
References: <1620814327-25427-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Date:   Fri, 14 May 2021 23:06:12 -0400
In-Reply-To: <1620814327-25427-1-git-send-email-jiapeng.chong@linux.alibaba.com>
        (Jiapeng Chong's message of "Wed, 12 May 2021 18:12:07 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 03:06:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e31f7a9-f472-4d92-fc6c-08d9174e6696
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45028E04F8A03646D475F9198E2F9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KzHQeWC/gERA6uJKL+XnuSS80KkqHsbrpHulONa9F8/oRNGzuAoOlDqFvY4C9SXsudSS0ZKK+oQaNIRWwn9gGa5UlD2ShSsDbBtv/10vF7cwr28EhlOnTcqNERm0f5+3NwoKTWWmcNpQamuilvKi7JMvCYsU88OaPWGYPIQ53adSb8RfDAInmPxYwz6pQJ+ItzQFSkcM2V6U74ZqsSutp3o0TWFi8H6T2eA8iISq4lmNLK7v8I7wtgvOKBaA8BHSVBYDHy6096/4PVKwZq8lDQR5i7YuHY3VS0QtROkMlylQzxRqPcrYfMNeM+jNdKhhLLZcTpMBurn1YMHuKJReyoiPBUk492CmFQC00aV3CqZmL1QaZ9DDVaE6lxcb4Kp2XePyI8O5E4wVYsaFbe5D4J89CusoLrUrWrEppHzXIGTxeMiHeVSeqbUSXu723FYQWSSzt2yIj8asefncI1sGnWs2VQLz0S7RM45vQ8bxb73reZWphJbrZ3+/t45CaSO8soY9ldxiy0aUvanyTlsb2KjjdBN+09ysUb/xIGCIvLdu7d27EtkqkkSJclUWSmPdV46wcF4WYFG0lrFvUrw60WMAIRpdJ+NMWz/OHzgHN9DkQ8af/tePufCaOnOtZG7RfXLA5CUehcE3qP1L8LarORqL0lZ++Vcl2SAE9cnWfCo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(8676002)(2906002)(8936002)(16526019)(558084003)(4326008)(86362001)(5660300002)(55016002)(316002)(66946007)(478600001)(66556008)(36916002)(7696005)(66476007)(38350700002)(26005)(38100700002)(956004)(6916009)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VX5IElOmgRk43UkJ9iyH2R+ikaUe6GUUSVusBh/GLY0grzNpe7NbVgPj6cb4?=
 =?us-ascii?Q?x8Zoh17Qm+UzeEuymwgxhujUopTiLNghp6scHHTV6xexn1hnTsZrXRLU5UQZ?=
 =?us-ascii?Q?H+BCvYXDQa4izex0iVJ0+C8AZie7V5zs+8ncVJAEdKe4CUi+AU/E4ajIJ/yh?=
 =?us-ascii?Q?V4t1pzRnMbuFkX+qEYQGoVch3SqSK8gVBp9g/PJrW8U2ab1XHblRWzXNHQRB?=
 =?us-ascii?Q?QijZL8H1R792id+iwxwexqJdHFWbmvZfqLxwlRFS5pS6WHmyzi1tf/VdQCyw?=
 =?us-ascii?Q?a/CR7k448k3jWl/1dF4jc0ju9ShbqJDhbbOaZISdmnAtcJ8x5Tn5jHUj44tS?=
 =?us-ascii?Q?xdktswcieyBFzrG7zCs9OcGAhGubQgSSXFhC/vc2gyUI/qpBpgCgI4bWLciB?=
 =?us-ascii?Q?4v43ptcKUYFvx5TRaNfN7WivkgDRyLnMW+u2ttlWKj47XVa+Rg4mVBWM09um?=
 =?us-ascii?Q?865N7YpoaBNjwZ+bSnI3cx0IznG801BrOExfkua39q/13Jx97mwavmYXwGmq?=
 =?us-ascii?Q?Si8J5aRbDhteUGcDfbi4zlEPmAtj8hiEfcZgOTQkiPWr82pNJ2t2NUwHEm3Z?=
 =?us-ascii?Q?GfYoTw1vuulDTVIpZOEmeSq9PlPbHH4bSQoTY6lb7ZJCeehB6PAj/1qnaSKW?=
 =?us-ascii?Q?GFxNidMtBMxjKSF8CclETfwqjZ/hImO/toZ2yyZLtM5VkIQIUsCI1ZXuhm5V?=
 =?us-ascii?Q?JnV5to1dCmTb0jpsYQs7bgl6lafa5WeXbUmzPaePTcaSr9rpSTfh2D9guAxW?=
 =?us-ascii?Q?dL/qPKZTjkfRjovBgCx++/PGh63N0zpgMPAK1S6PdA2GsnjyPmxtRzz33Q7U?=
 =?us-ascii?Q?Qg0MCStRZaRLmJR7ALX6dDATcqP7NdM8z97vy1O7RJ+8CKdmiG8y8etLp15y?=
 =?us-ascii?Q?ph3bQHIDy22HV8ot2VTWntqNWA0Ps+jrOnSrs/3u9kxqqHbEWXDai259VZ3C?=
 =?us-ascii?Q?43gLwGkDpd4sp0/Y1c+WLsJowmLlTnh7ef8GKeGBorHio1MpELIN39p/kpa5?=
 =?us-ascii?Q?Gm1VJqnhtqwDS3XzDOG7QucgxbFsIynslJK6rc8/SkinORplLbZ+Z+oMzcx8?=
 =?us-ascii?Q?qdvTtuD2VZyrnRIRWUApv7bVM6mZkB66uBpc6HDD/Jwc7gnBJnZ/INMT3DBW?=
 =?us-ascii?Q?0FPoELbgijMsHgzOpG9K6DxkBM/LRPAMskORuJTtmeUxMRY0ksTFdXszl7fv?=
 =?us-ascii?Q?VrTlC3+21KWPPCdLQW0XngkZlTiDT7yP4S7+ENCZuUAbzlAQfifkdOlcYy9/?=
 =?us-ascii?Q?72ohvTXB2y+0edvWG1xEUEhBbZBX9QMqHqeQ5McE1Sdys2nRJ7oHU/5TxRU+?=
 =?us-ascii?Q?bAM4Z+wao4LwRFBvfGwQs/0G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e31f7a9-f472-4d92-fc6c-08d9174e6696
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 03:06:14.7407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhjvHajrr79NgWTYvh7OpNtXvM7cpb5YblmmeGFPMJc2KHAFLPxIoYaMx72HKL7LSSFiO998l3GpobdwS0CRor9dOT9iJ4TtioO9cmsU/8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150021
X-Proofpoint-ORIG-GUID: MDwXs_x59aV4I3QshYp1PFLI3VTxjVXq
X-Proofpoint-GUID: MDwXs_x59aV4I3QshYp1PFLI3VTxjVXq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jiapeng,

> Variable rc is set to '-1', but this value is never read as it is
> overwritten or not used later on, hence it is a redundant assignment
> and can be removed.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
