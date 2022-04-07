Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3339DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 02:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiDGCul (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239541AbiDGCud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 22:50:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CB420E960
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 19:48:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236KEQAn012575;
        Thu, 7 Apr 2022 02:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ykvrs9PbIKMfORlWPFNICVU3fV7QuIKt3ERODsvX87Y=;
 b=a2YS0eda47Kagd99rGJLIikWaKleL0wpSG1S15QO2AgZBQ7XfS7KCKLUHlQfR4RmgOsI
 GbhCsptI6zdqAYuJ5A/sy+/FSlrK7vUtyK9NCjOHfsRxcuZKaRgz4mXDi3zsVvFBuSBa
 hIP8pjF97v58AVucwWWO44UUHVokuogJTT2iVCPu9NBABs+E0BeOi0DfItJ8lgDW9vY/
 HNQUQvxUqzrpDgluyRtOk6w4r0+xOOVWyz53mknnNGJh5muUkBwW/YfRS5DMV2Ubl8YH
 wgTnkcw0FOFYq7hyloOfDrw/dcoUwFKNelNg6ZJptHhuzR7CYc71rt77WGFUdX/lKYPE RA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcj9dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 02:48:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2372lMLi004664;
        Thu, 7 Apr 2022 02:48:31 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwa6wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 02:48:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGmIbgJ8rcn5HXl01JLmh1RNxm3pMpB/caO9KEk/n+czpO+OGLETA+aOlPlULIbwYXVwjq6CvYKk7BnPd5iHqO6O5EMuF0N0EvLM7ZQ9aFAqK5lrbxyJsbXwjlknK3flKXEgB3gyvJxpsQvT8Ao2ghdh0fBr165Ik9x3WYF7yPo0hDZoTJtj8IqqEag2IS6szKMLxeh+Njq2bf1RecdGMyAownF5P8UdHERVMadZg1db4qwKFNT1F4KF2+lifYM5/PuQ2L6gzeKD82t8TLU/Vncuvmap+dS//oMCI8E6+RBtW9IjeUXp2vhuGpceG8NOurZcy4QJsa/+tapleA0zKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykvrs9PbIKMfORlWPFNICVU3fV7QuIKt3ERODsvX87Y=;
 b=d4WTbmvJcSw4vwIpZgRFt+XIWQADkX/gNtF2dINyH38nDGaBnAyVNOfOsJgvtTGEL6FFEbZ8RYF9BmttD8TEFdiF7veh2u2hBHxoeJ67N4wGIBuF5y35AbGbaHY+Lr2OenyTBVJ+HhEgeYtZLEGtb0Q5VYo9qPXFo8L9TQGBDJAJGyIGPUctBytpGrgPuoA2ddSi8LlHtinyI3Zubv3JiKNwI0uIdV43R8Fh83FGSuVc8KpsPkUwkO3bUJaoQaSTI2U7b0XRUEBcSFTonz8UUa8mW9d8ZLrpBxtwKTAi0s0yBeLGMPC/kVm1hnKnC5rmQkuRifK1zlKIIekefP+XHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykvrs9PbIKMfORlWPFNICVU3fV7QuIKt3ERODsvX87Y=;
 b=KxhSSsUTqM5RFQ6ZSXN6h1ohZ1NFwk3mRHdWEuK7JW0bLdgNPjqh5fIOR/IH2wYaGyqa6vU6S8yjjD5mzuYUFPTqf974CttVJ50DSmZVe5WR3YwVU8KujFOiJb27l7STwDEZsSzS1Jvld8FGm3f7AWMRRKPbWBHBNszKdN92vXY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5274.namprd10.prod.outlook.com (2603:10b6:610:dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 02:48:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 02:48:29 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0c1linc.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-13-martin.petersen@oracle.com>
        <fa37071c-3e68-9435-5f8b-6f3920e59ae1@wdc.com>
        <45050814-f512-f764-007f-5fe52e224467@opensource.wdc.com>
        <yq1v8vlljrf.fsf@ca-mkp.ca.oracle.com>
        <42f5ffa7055f4207490a184f39336d5174581167.camel@wdc.com>
Date:   Wed, 06 Apr 2022 22:48:27 -0400
In-Reply-To: <42f5ffa7055f4207490a184f39336d5174581167.camel@wdc.com> (Damien
        Le Moal's message of "Thu, 7 Apr 2022 02:36:02 +0000")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5139bbe-bbb6-4382-745c-08da184118e5
X-MS-TrafficTypeDiagnostic: CH0PR10MB5274:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5274A23926CD17AAA2E960B68EE69@CH0PR10MB5274.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTMM6jnwhOkUYrgBenvK1b7L+WbREfYLrTAJBST7qx3YEiGDQ/wC+w+w/Yc00+48HCgM/huZxPydzgCZDVwXOZ3A327Rz/mgG+hHeBKyjw28BCa4lTHa4pjv2sg4VkdDOBgtBQsXr/vOhE70E5JIyyQA9QGQh0y4eCmVcoteb8k6opXYVlkkf72S0Ky4Y2uaI5co9gLcudL3eQNDFHgFQFNR+gkLN8ZBjFRUdy1ksbtr35oiM4p3mPynL53EYzD54jo5RXNUyUBkle0e6hRGF5IrqkiZd4nu9BPiMyfx9FQep3O3FknJlm8xOFhEEp06etFGVqJ9sbLLlIwrp1y+o3l08I4E2WAIcWpHXOsKSoGKRX6q7W++YkW/Rl1jK2V5BgfMsIjR+kgjejvRgDukxoJoewwN+ie+qH/qnzHlqs2QuD1qRaYy0uuA3PpF01QaFZ5sHw5Z0IXFi/c5c9TcgIMADbpLujE3fSPzR943Wn/odd5VEqD0XRujOaQe+i7dvwOAkfwXBp0JWe5zBI8uYlEVUcXbwIQIBMrgTBeCKCCk2G8YNugOTCSN7lTzUc4toPz7euQj1k5EtX7KnFvT4cLUQEDTEPuUTW17jfPbFY5scQBSuifXnwv4EweHhwuYLqeCachsvW4EdH8Q8TW2GrPo49NhbYpBcVVKdcJsjjlO86IZpP92Q442zMBFkKzQ80PeSEz2YDQnQc19nkMBSWs4HamBmg+2ktoB7qTVGJIbUrWcJbeJScTiE74To/gfYtYu3TSKIWZdNzGgmdXzqgNewVURojjR5wlE909J358=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(316002)(66946007)(66476007)(66556008)(4326008)(8676002)(38100700002)(38350700002)(86362001)(83380400001)(6512007)(54906003)(6916009)(186003)(4744005)(508600001)(966005)(2906002)(36916002)(8936002)(6486002)(26005)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GShO83/P4KRiGXjlP7A0uaG8e/uXNx89Oonxn2zQEC9bKyiQkwmar+A9L6IV?=
 =?us-ascii?Q?fa/p84P/L5q6XMckRNQ9lDm0fk4w3GtbDssXAJsPM85nYdL10WqXdX9DKqyc?=
 =?us-ascii?Q?mkQ5fSD3CryLanjGzGgD+fg0O7PfQ+0aeTWDJSRrcZUDACwLNabdJOM1DlTJ?=
 =?us-ascii?Q?T+P667iN0oVFR+oIaa2MpUDrAa8PlmT3ptFGGUMMU4rOGSuwpgZJcayk/ZpW?=
 =?us-ascii?Q?mESL0LvCCiYlZUkHdZcgF+urIdEl1STGjQKqmdoHnLxsONbuWuJtEF3SvCBq?=
 =?us-ascii?Q?uBNYdfpoNy7wfzZgh4DEALSeKJqPEvCTZD54Uh5CvKiIXDPceyyuANC/HbR9?=
 =?us-ascii?Q?hmf3f9He+vXCrAvBzSQSGPM4qWmZ7VakdOBrhxPYQhmsvPDnIU3AH5NfBQPZ?=
 =?us-ascii?Q?YNy4w0yBwigIC9yTu2SWRr6aRKm6x1v4RH6g+uH+wirxrNKPiF3ZqR/8iYMy?=
 =?us-ascii?Q?0WjBk1GkC4rGB/ERIiDNktLrnKQRvVX0UuaCAsMC1I4QpGiJ8ifprgvi4kA4?=
 =?us-ascii?Q?1/aOeFqsMdcFClxl+SJsjQcpdqB9VKRu6qR6NKILjmbrWlWLZG79w+Fh+tEE?=
 =?us-ascii?Q?A8hhFaio1xeGnUomrLHd52uFuBRKitG0RM9lAZdf6bg3nK47kJBqekBj8Kh0?=
 =?us-ascii?Q?XpOrLo+w8L3X8IkVl2ViFK3cV6v6fls6RVChG5mXx0MTiT0YmwEJQaWaFdpH?=
 =?us-ascii?Q?lQAPTCnFWjwrxz4tq4rNHjngyh3ll0evfewsJ7BP9X0Ch5ZUguNAWMBEKCLY?=
 =?us-ascii?Q?jV3Yl93Fy/6II1HQIvwsdlln4/c/0VmUzwVa4xPUK0NYorZw4uRDfIAgbDzx?=
 =?us-ascii?Q?f8ijQn17xW/5x3J61BW6tcrswmUxOK09hxPpdCdvR9gJPs8VO6ixFgBH/Q+8?=
 =?us-ascii?Q?Lj7Ktn/OFVvjjpjwET3ZD8h1ZldLkff7QTtglwK57EmIfTvLO+wmgjAO2vXL?=
 =?us-ascii?Q?cbWg27OzhIl6avK3b2Fk5MnpJUo3M8sPk+OYh6sPUv6iksBdaxAhW9ZQYpjR?=
 =?us-ascii?Q?wFqlrsCDk1LeBMSyC3BP7f8hh0HcERjuOhUYNJ/CQQYegEz2Y+lFvz40x/74?=
 =?us-ascii?Q?RQ6FEvqelRSdLxxAIx50B1yvyJc+30epTTtkS6Z8AEjg9m0UpjjvF6olvqMo?=
 =?us-ascii?Q?Dyxj3mPF1GFc46Z78OrLNBkJA/wxXR7dk21v/Ez/dKrZnjdP44JqswxfOObk?=
 =?us-ascii?Q?3cscgKPbhWyVmogsxU/I3L4Zqx5GU+ELqQ7GOpP0IYpM4o7nSgaPL+k9pGJu?=
 =?us-ascii?Q?aBsRjQpkqVi5J7ncVm/qZmEExBiCsCrBgDoH7kvhwIbPuRy9DMkuWmRxk58K?=
 =?us-ascii?Q?ScResFOuh9C9hQcvTrtMFQxY7cqM58xd6ThBZqYnzz/X9LLfLZrb7BlClMK6?=
 =?us-ascii?Q?2cAvH/kCeG+IM9HJ2569ImRNM7phVgrzW9qMi+6CMYGx2KbTZODQyv5ZR/xh?=
 =?us-ascii?Q?xXJ4FhQUXQPK0nXdEOpXXjBedh3wSp7J4Xz7b5+aSKYXGhH5co1vmAQoT5dm?=
 =?us-ascii?Q?9vvRPEpD94lb7Z+1yBja6HTp1SVuFakDtineD6YwieCMIBREjPqbDQLxJnft?=
 =?us-ascii?Q?YpOB8OI/iXc7m1qJJ93JORsCj/g+JMSXiSahpU1uUo3YEz0xaP59Hg1rchrC?=
 =?us-ascii?Q?I6UdO7MGuKp2iD4pigFv6BIf0xss6WJmd/UQczIlyhLZOvdBUHAmfaKSoKON?=
 =?us-ascii?Q?sf77MkRYVg2O3AZxg+CKIJ2Kx05gOX8fMChlA+uijwsZQDJI5NSNALqFIlo4?=
 =?us-ascii?Q?OJiTUeBUb7bIuvPkbEZ2xAgkjU09idk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5139bbe-bbb6-4382-745c-08da184118e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 02:48:29.6602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqQarTGyBrKfnICRrHKRwexA4LakmWuRQPevPqBkcCIlnkYCgWpIrhWgTOZ35QG0tR31PNQf/6mdPVA1T9N5yiYOMWHuhvkHckbLPBwVGJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5274
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070013
X-Proofpoint-ORIG-GUID: gRmpjUtoKKgL_4YucoaiycoT85ydIrCY
X-Proofpoint-GUID: gRmpjUtoKKgL_4YucoaiycoT85ydIrCY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Unfortunately, the patch did not help with that Areca RAID controller
> problem. It looks like the HBA is crashing when the VPD page 0xb9
> command is in the discovery. No issues when manually doing a sg_vpd of
> that page, which fails as the RAID volume does not support it. I am
> tempted in putting this problem on a buggy adapter FW... Any other
> idea what could be wrong ?

Yeah, I saw the bugzilla updates.

It would be good to know if the tweaked VPD code in

	https://git.kernel.org/mkp/h/5.18/discovery

makes a difference...

-- 
Martin K. Petersen	Oracle Linux Engineering
