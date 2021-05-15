Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC356C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 18:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE55D6103E
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 18:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhEOSgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 14:36:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42930 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhEOSgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2021 14:36:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FIP88G152568;
        Sat, 15 May 2021 18:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/nUlcILqwtjvsH6aUWKDZ074FxJ7LEPhsww5aUzQ91c=;
 b=CbiWrp2eyGx2SsY6/dJofKoNtu05Et/webopHDB/lYwdEAEkTcYMHs6GfaOw12bw35Co
 5aO6Mf3EWgbg7yNMuRm51w3OvfWYirRwTKgejNoYl8xLyUPRyl68DO+dSBJ+ThKCYK49
 i5DgqIFnRS2ayyfRaJDmcPR/Aqp7q65Obh984l1ei1G3keMc2MOLD49HhSXZMzUwhuSl
 TPIiMcSox+NvSG6SVVmvA0cUspsgOOVoH9DF00sF7ye/yIVYMvgJnawAzb5eLfCyCFxJ
 AL6YVmYYdkJ8jICMLZymvJeGNLQ40NuU3Ax5Oqx49i1It1afsQtbSp3Yzh9/yyyZGSeV +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38j6xn8kxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 18:34:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FIQbMP080725;
        Sat, 15 May 2021 18:34:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 38j4b9yj8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 18:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERVQczDpc9PJ8uU0FxGlfuKX72OTxLx+kjn/iDRFWNFoQ+EnXaI21hXXFmaCB+4LcZ2AALl9N5Y7/mr/aKCEq3k34xrsFOhu0P5siR2uePqYXle0xbKeGe4LW67eP3EJlE9oJLMLdUzIu68D3kezK1LCV3NtSSZBD7Vv0sW6YTlXGjkZKzkPBButYzF+YsJeriPEir5fgeUtwII0l0tOEuSSWzjMvF5T+nTKOTS4a3RrzFoVEnE4xBWcJZH6yw4pOus9f8+V/j2pdYI4Ht0gId0TCXHWCJyIlYKsGzkx3pC5rE6XSrCGU2Y4UwGTTQJMiwM+HFVAByG5S67qIczsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nUlcILqwtjvsH6aUWKDZ074FxJ7LEPhsww5aUzQ91c=;
 b=gHgMejfjIPvJEOBNmS7l25g/7RqK82zX+FrtzH16Y/PJzPFbCPVE7kOWSpJ9xSMiuQU+Po+vbh1u+R4xTfHGLMEqNXz+9jS2hsEmVfqbeKENckFAFPQqzrFG9WyBVE7AZM1Nyt2ZxALI2bsSfjwQflx07+79DlaKPxX7/GRNc0zqOT032Ky5NF/H2f6vJYBQ1bpzmw7btn32B8H8sSdss4z7obJ24d08HCnt4NckUKk6tb+jbPOjzQuagGongju2ERpTIxYXcjo6oyxQGWPWmEjayTssBX7hafE5lZnwjkXmVlE5Yr3OhjvkmjzLqYBRiT/GBA2kpQKJwmB9P6gHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nUlcILqwtjvsH6aUWKDZ074FxJ7LEPhsww5aUzQ91c=;
 b=WKAouvWhi//NMeYtC7sjtTepU5dRlh9RJXLLFyEGiOdmpvEUEePM3ExQm4jd/jswQlb2nV2uxrzLvOEckAqQtmRGdN50YqYknVN4VqG2FavVqXh0bpgccWqdWXm5up9h8RkLbaKfgd1KYCm43cld/+CGHHdJbVLnmnSn5P49BdM=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4632.namprd10.prod.outlook.com (2603:10b6:510:34::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 15 May
 2021 18:34:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.031; Sat, 15 May 2021
 18:34:51 +0000
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 0/2] scsi: target: Introduce the version descriptors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1i7977n.fsf@ca-mkp.ca.oracle.com>
References: <20210513192804.1252142-1-k.shelekhin@yadro.com>
Date:   Sat, 15 May 2021 14:34:47 -0400
In-Reply-To: <20210513192804.1252142-1-k.shelekhin@yadro.com> (Konstantin
        Shelekhin's message of "Thu, 13 May 2021 22:28:02 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR01CA0030.prod.exchangelabs.com (2603:10b6:805:b6::43)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR01CA0030.prod.exchangelabs.com (2603:10b6:805:b6::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 18:34:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a7e5b7e-da1b-4819-5ca9-08d917d02077
X-MS-TrafficTypeDiagnostic: PH0PR10MB4632:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB463250F3C90EE5A2FD47872F8E2F9@PH0PR10MB4632.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9xv0XC0p4no9OuL9ZES82YKmUpmbPo2LvX0rdbOrwjxD3mi7LbnhsSCTF/SwGLdVqdSLoiufR/eAmAQP2GD/XtVttGUWSWWhgErRPpLNacIpyca09D2qwVa1aHs8aWzIRbchRbqyIUmxQnMjVFhZHlpDFB0jhzOCSO1iC0qfrbDQlKgulxQR8mlM+CJe2UYvZEhrqESNokbzVZtWqaA4+01DJTwqz05sbRKwZgvr+l6miOIlBU/qQorjb9XfW7MebBdvadJZAeQ1kpz2+aPwwib5jlWKaet/2N1mIQ+7uRo/l1tbAJr4KIu0LWHXMV/b3GRzrGUeoUFAc+oLtsrm2/tj9/tj0qezwsameQwLjepGVPoPFXn6jmSgkFuNU2VQG55qdYjcvBaHI9V8ju9no7Ux6ChKLgxgRFKFIOW++U8Y7KcHjcWxkD90L2K3+21p2wgRBqOgNJ/5bTP8kHxQHhh0xmJAuMBhtNEoWHytlDEBOR71ISNRwW82cg8CqWBzFH3ey+eEGeE8K4dN+MRoPdn0MQFxs4+rjokM979fvnq9+F2nKDTbGSKwFWkD8u5WHF2rS0NS151piMuM5yer7n8WNq90WKwLCXMVZ/D0pNeBb+Iv8o5vcmFZDJR7scxvFdFCJweJktLyhX0V6XRZX6H/xSZU9OnYbPS1T6mxfDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(136003)(376002)(366004)(66556008)(66476007)(66946007)(6916009)(8676002)(8936002)(26005)(4326008)(4744005)(55016002)(54906003)(86362001)(5660300002)(38350700002)(38100700002)(2906002)(16526019)(186003)(478600001)(6666004)(316002)(7696005)(52116002)(36916002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?F1MW4QRPAlPmlL9SkiZRYiaxtxsuJRzN92ziSkPCMKxq9CR0AiyF5UzqW3hL?=
 =?us-ascii?Q?MfI577w8T16ChrF+H5zempDOwdLLsltY8PykAfQ7daNKW7Lg+viX9Q7AsFh/?=
 =?us-ascii?Q?Z/9Pkf5gh756i06XKrGwHXH0+WlYoy7gbUpv3kEPCk8+/TL4Yc5p6cD9LqyF?=
 =?us-ascii?Q?wm8nji32Rtyh0L9Y0rTcIhCHaFFINVUHg6tceewwnztlrDIL4BZ9na3Lyev3?=
 =?us-ascii?Q?q1TnuTWcjeqvcspTRWQVO5RzK0cRPRCAXPp8fzUQpWp44tw7uIyvYgNt3d47?=
 =?us-ascii?Q?8XVUtCJuOYR6/ASylhL0ljrgCRhQcden+iHcOaTi0fRim0UpmAivGrDdwKZW?=
 =?us-ascii?Q?NO08pFf5Ds98cCO/ZcL+kcgOweeHLgi3E34gNBrxmFbPOYT71sNBchpPzqfr?=
 =?us-ascii?Q?N8Z1nOWCC9xUqiZ0xBXj7FZfUorAEnHzcPvEw9lfVIZxgS8Rb49xyVEUmF15?=
 =?us-ascii?Q?suewYmgKbfHRArSsgcsGmQLmqO2xQiLR1mvXCK9U+VOXmTFu2PgiTUq6Km26?=
 =?us-ascii?Q?yaqTJDKKIsIH+5nMnhi3ngW0w4bbUydH0heiKk+pGuSMZdeYQ8gmuglpelYm?=
 =?us-ascii?Q?ixNvGS1ntdYV+QoQkTaXw7qMpV1cooNs4qqo8bivDslYm29SORzIbkYnCGSj?=
 =?us-ascii?Q?MVG0JChDFSUtJe04bwZlssdW1FteciMMNddBL6YRgXKwzJ1o4gIbCUq8U47Y?=
 =?us-ascii?Q?+HtLjur1tPfTlvuD54HesHmGOBWHXlvIzlEfxVr6x7iiZKcluWWGDZjFqXg6?=
 =?us-ascii?Q?Yaxb5UP2uqgR79rR+KdvyL2ZOVcR2ksFfqHDRalSen7VNsQQ6mx8qmPD/4b5?=
 =?us-ascii?Q?rbIqGySTVlK5DEa5RSHNMj1hYtyB2UDgpY4/Gqm2ZcNfU1NPCZc9mOylR6Hz?=
 =?us-ascii?Q?824njKEuqf7y4PmlEKZRQwPlRN0HFZXoJKjqlYw8TyChnWlgx8ZJi1tw2LU2?=
 =?us-ascii?Q?WUI1xaOOlfmbWb1Mm1IKnOruRCXw7D3MaDBwF46X75S11MBg4s0FJ+TsoXjT?=
 =?us-ascii?Q?xYfRjauCdpGy5IeRArzPkLTMkOBz3/mRrVJakQSMqpkEj/HKg6RZSYyE4z1P?=
 =?us-ascii?Q?30679e2QLPw8MW3Wm7KTMJE+8fCUj0Cv8R3ix6VagG93RIY0bs7Dq6X9x6SL?=
 =?us-ascii?Q?Z5fldgqV9mf47xgUbtOqvLt4pmawaS4XNHTy5LVj8FP9Lol+K64ZAI0rdubF?=
 =?us-ascii?Q?wCQEtDDZM6n/mj9hqHtBZbxpXmcxsvfimJdAEGQFcdXCCVzYjBVXjKFfB8Yn?=
 =?us-ascii?Q?yeMhYMqYeGkufCri7n/NSJfmPSq4YOBPL7pdGcfnhy67PLwsQL4WrfSzLTfM?=
 =?us-ascii?Q?k77FZIzNPHUEs8Dw9nNu003c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7e5b7e-da1b-4819-5ca9-08d917d02077
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 18:34:51.5871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06baMEyrhpTgoEY0n2Hi5uTHa/552OaI3yQMGe8sT4qmV/x4kup7kPNDCvBt9gfX2Mb7bEvpAIEoeGp5bl0+g1bN1VdxmREIMxIBeZ1v8qA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4632
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=992 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150140
X-Proofpoint-GUID: M3yKMpARb6VzOuyd_K5SgPsOpX3byU-N
X-Proofpoint-ORIG-GUID: M3yKMpARb6VzOuyd_K5SgPsOpX3byU-N
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Konstantin,

> This patch series adds the VERSION DESCRIPTOR fields to the standard
> INQUIRY data. The SCSI primary command set standard bumped to SPC-4
> for consistency since the version descriptor values for SBC-3 and some
> other standards are not defined in SPC-3.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
