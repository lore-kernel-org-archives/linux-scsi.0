Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DADC4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B53A61246
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhFBFJr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 01:09:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53066 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhFBFJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 01:09:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152501jW122090;
        Wed, 2 Jun 2021 05:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=K6vhwnHyb57mjkZkeJJkBl1xivfGexgfXpj7EEdMivI=;
 b=OEFfC+mt0nMf9e25452GbKAGQj6x45cBZqsWCPxKN17CjTJpT3OPva030t1dm3oyKEXd
 qzVQY4Ow7hKLl50o1otZPLPHpicdDv+rwtm3eh634e2UA76FdsNNCoKolkZNEpOc9rlH
 k34w1mbZOwiyTbiBaWUbDzv9fIWodUDjmmuSZXS1uEhmUGgE5R6ORXCN48CU1VZ9vjIn
 NyxLzQl6FdJIKyABjJnxsYuFKYdYFbUEO4DDxy3w1ZIL9rd7Fi7MpDfrZpdtC7Yo2OWV
 TAVngQH1enixN8sGHIjJldVrHJwVGn+7tCkKDY335dBfqqGNwc5woAHGEWMBVoJDD3CR wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38ub4cqdbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:08:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15250VQ3110985;
        Wed, 2 Jun 2021 05:08:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3030.oracle.com with ESMTP id 38ubndqgat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:08:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gs7AU56o4WtrBg2Wzv6TXyH2XNGi/fRnKSppeQGPV2fSXnyrPnXIAeTLMP/tJQVEOzxq3ivsMcfEDhrgSGtr65l78Z56A4cTW85XOoJJDsJgSSOCmOqtK4nsODGjxJcgiex/MQoqC3OJsZj/LBaaUCQRawcRd60k4+l2OV4l5PhYKgt2KoCT/uKbKaLi1DufxBLOJ2Df+naYxsOcAGI8oWRZCgY7P24ar3sUvSGIxq2BuQqSXeAKWIBykjtdkixWpZOx24cN+OGG95xGz1acDH1IA4+zi1wCG4lMsIXQZXxjWMf+VHav2PO72MIjXQWPmjCkKvncJNNJkAR0oDEBaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6vhwnHyb57mjkZkeJJkBl1xivfGexgfXpj7EEdMivI=;
 b=k8B4unAApNk+FOpnOXZETkoyvtc+OSagdOcgH0qdU7jTQQLLrAdc31QYH0vcMwet6rxnso6xk325OkTsUAk3Q6BKKRoOmwJ9bTgvl1Z/iDBfpjgzES4AiX+wLqEiFjWGy3KO0wSTvbfT+8GQq9Rz/FoCneKmzWRECBzcM1Tvp3HbnhEcF3IbUil67aZYozyOH08s3se78Ksp77J3cinp0sC1Dk7ZLSmwoeOiXPHHqghKg1YvNiSFnPe3bUwsSANmcqqiBnOb8ibeDyvV6Q+fipgVm5c4sOoL19rIKoYUCDh1pBiKINgMiNHutuhlJQyh78M8fju6ns8jiHUPgpTxrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6vhwnHyb57mjkZkeJJkBl1xivfGexgfXpj7EEdMivI=;
 b=vE/NSr6HidDre7LC1vvqGAhqhJ09uRlLi6eXsD/tHk4XS1PAuQz3ey0OhP0YZONVFNVYcAbsbmvaKUKE5uvBH8Dj/5ee/XueZhsBWyi+eI+DLSDSSRaKGE6aLequ8wkWUqMCPWxkJG8eenq+sbwBf2ph/UJRfYGFk6gFYMMODOw=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 05:07:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:07:59 +0000
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH v3 0/5] megaraid_sas: Update driver version to
 07.717.02.00-rc1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1hkonw0.fsf@ca-mkp.ca.oracle.com>
References: <20210528131307.25683-1-chandrakanth.patil@broadcom.com>
Date:   Wed, 02 Jun 2021 01:07:36 -0400
In-Reply-To: <20210528131307.25683-1-chandrakanth.patil@broadcom.com>
        (Chandrakanth Patil's message of "Fri, 28 May 2021 18:43:02 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0201CA0058.namprd02.prod.outlook.com
 (2603:10b6:803:20::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0058.namprd02.prod.outlook.com (2603:10b6:803:20::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 05:07:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95eaa498-4086-4bb7-f149-08d9258463ee
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44374964EAB140AC0227E3638E3D9@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ydPqrxM+us94HEL3oToLoY4Pc1M7ZH2fuv/VNkQsibzWKac1djJcCK6KLtZigbsCEfxsd/nKe9txTjgtrVzbsbToYs518AQ4j2N59+D0mk3w3BHhoJNo5MzY9CiYcILwHIztE3rhYLhm2q4KobeQAzXCpnGdv4xq8o6dfOL4Ag2nDtODImG8EJCxBs0GmV7OYhlph4RSb5rWejvxrn1Ir0PxViN36XCuySVVUhgqytTG9bdoDBXPDesuIE7LyMmI/6Df9SjTGTWNlR+MvsLqWO6JHAHx7K1GWBIIInSJxHttp11ooelgTZFM4qQojkU82smcyL1PKLarM6KH8/hUQm5M1NyGKal6S70vjr1nVU3goU6UPyrLrF/+4LDDFuOe8fs2jdhZ09+uc4+vGTqSWTkfDICLeSJoq+L1sTdUvj4f0PyR6BHKd88skp+rRifUUgAm9ATAld+okeH+n5VLQZ/WlXnJJG+5VtUHCW2WNwTQMp2liutUPBRJTlUQFDaaEHeQjF2XX4RZ5mT1U6jRvUhc0pXxJZKTShv2y/U/T3RwaV/WQ0lVjumWw6DqrqKa0bxrXKAyVyazMBUigQgwFwFC90hkkkA1OJbbUUBH4vmaOgRcox6LPvV8pOnxfaCzQuHJKWCm2GHrV4JBxfFO+kCao0eqD3+cDLFn0Syyg2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(346002)(136003)(86362001)(26005)(38350700002)(38100700002)(8676002)(956004)(6916009)(8936002)(66946007)(5660300002)(316002)(16526019)(66556008)(558084003)(2906002)(52116002)(7696005)(4326008)(55016002)(36916002)(478600001)(66476007)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o9SIEroNWMEvPXnCze6T8fOdmKowaVR0rkFYs8kJLt58jAFIfKfU5RGdI/gW?=
 =?us-ascii?Q?SdBMQkYrCHphrqwGpA728d3VJ/L5fycr3mqS+BqL1TtEtFRVMm6q3z6w32il?=
 =?us-ascii?Q?7VhbOrLmTTLT3Ndt5Ol+EPQGgaCcjPcbGCwHJV6gSspfbfDuWuDAaPpCRv3D?=
 =?us-ascii?Q?6MDl8E74Xw/8j/hzfE8KGb4MyYkvLpdLILDBwuLXiTyzwZWTS8JdfniJM21s?=
 =?us-ascii?Q?yI00qNx4TulCK9BIivxJo0/1m8PfZwLtXZRuVHD1tbtBzlEVVMDVlg17bWnM?=
 =?us-ascii?Q?K/2TWHh3zdbIxXnub/WKwYtAd6tJLOm1dtBjQ/QSOmPWqZFgwqWe1X+rKYiZ?=
 =?us-ascii?Q?GPeGtk+xk1R6eayvmLcBK67wW0NIx5vH0RzvPE/sOGGfz3baxeAlhPJe8aHv?=
 =?us-ascii?Q?dqgWbUD2OUq4pL5USLo9TRU7kwcqAXMIKYpQqnqEor8VdBlmYDkDI+O7WlT4?=
 =?us-ascii?Q?Avq7IrKtZrmNFJCHFDnJvNuTUGQSgkFDUessN/ItrpW13BCRFb21Esn7gIGx?=
 =?us-ascii?Q?6k8Not92Vz49ka+VHLToyk+O8mKfdmQ7TEK1tW34gweVwqn+EqKbb85PLDm/?=
 =?us-ascii?Q?vgXKvWwTx19EKCdQypTHWYYEeXNy9EB0eJKAuoFqWkkKuUlp35sQVBem0l+l?=
 =?us-ascii?Q?xaU1nTCx1ve4UD+E9hC1MW5KbZFtic+g/kxOZioc9ndQ7oDErTPBiv0ohoQK?=
 =?us-ascii?Q?qXth4SX7q67p9PzogU1mxiJtDvZJr9yi9aDodLufDq47T5z7gvA41z7dJavM?=
 =?us-ascii?Q?QQnm7wLBg3dAQ/MMIZrXcX5zdqIx4weLdujOwonGsLGGt7LG8joMWlqSVGaH?=
 =?us-ascii?Q?8UWyL3r/yEZanbcJvdPz5cjXHHugs2zF80jbkNwl+7ph/tbhazb+BVJl1yXO?=
 =?us-ascii?Q?b88vkYm8EVpBMc5n9Wk42lsEt5Axv63eGwOZhmxiaNaxwKHl+jxF8/+2h53o?=
 =?us-ascii?Q?g4rSTdZAdGCGL/CCLnyfNPCIWFdZpfxTrsHgVkI1ELxa+rrXADzqN/kCDD08?=
 =?us-ascii?Q?Yn9rthEq0YObop3zMP0jQ+LB0PU8ij/WA0PlQpR0JISyMRE/bXd4lLHWfTWA?=
 =?us-ascii?Q?e8i8n2PfpFqgfuny0YKQVnaMQtofFUOv+8kmqdTjCOgB6QyX+GvDfSrf+Cj/?=
 =?us-ascii?Q?7Zf7CqHO2xbvYnlANbn+Yo39IQdcepc+VMzlPrvzl9zSkI7Cp4pV2Xnv977o?=
 =?us-ascii?Q?RwNJbxizKB+y4jrPhgk/6zlOIeSRIH7vuoL685Maw1f1pqf/y9zklHSSeZUY?=
 =?us-ascii?Q?wcZ9qL0kBSm882NnCifr1RLPXVoAAM720ZBOS2UYNSnPlJp6TXU8skfTKwfn?=
 =?us-ascii?Q?hAaX491e5MxvmaEz1nwcthph?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95eaa498-4086-4bb7-f149-08d9258463ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:07:59.4460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHqcZiueYyp9YJmXHrwVbkazaGGUEqP1aZW2R1gngC8qIDpIt1Vsa/muMiHGMXvy7hUrk4tTFOijNYNrshZXmxpSMz3MCSMoZCro07B7xUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=884 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020032
X-Proofpoint-GUID: hyTaKWR4lS0VcaqieyZnwEuRxqa4XTfA
X-Proofpoint-ORIG-GUID: hyTaKWR4lS0VcaqieyZnwEuRxqa4XTfA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chandrakanth,

> This patchset contains few critical fixes and enhancements.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
