Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9CDC77B7F
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 22:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjEFWqq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 18:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEFWqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 18:46:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D02156A5;
        Sat,  6 May 2023 15:46:44 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 346MkZt0014502;
        Sat, 6 May 2023 22:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=F0m+w4cq36XB63EtuQZY9x6zPOb7vQrzoQ4XUsYPsqA=;
 b=WDt8uRwdhLU6ooZcvFWhqJ04UZ168hVr6O88YMef73t+EUin1pOWKyRbq1+wN1Om4k32
 exGNiseM/ORInJylxxw1X2U70qUHvcle7FpWg4e1AsQ2+TVurzzROBRxkrWQRQsxBrNj
 /D0rko3cWc0z+wUbd1ZFqc+8vNZ28O+sv8/yFeEMF8lKaQjlAfMIbgCH7aLZ22rDtaIR
 aO59Yst+w9mdqUMPFgr0AGKl5M7rGG0OoDF4P69DrSVAKb3mQV1iRO6L/WDNgLXJU9QG
 PrjhYqava9Iz08kVbOchYsZ7HBXJ1ShEWo6HzplEytdfvHgiyl4mEgFqFAx64rpGnp3J YA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qddtch05h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:46:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 346KcU2W038384;
        Sat, 6 May 2023 22:46:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb3ug2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VC4Y5Gm5xDkd0ho/zf3z2cVfsMSBxnGtbRAUHrgJR/OTFu5/k2ho9sZn5fT53I5l1WueEJeWXwP6Hw8EXYzSrpQu0UW5LZR6ddwQc9OwkiFcjk8mdYCLasLmBPv+F4MIbz3qP0mGgX54Hv/fttQ69ze2dh0I6aYRMY+Su7eZvAojHG5F+vDK1AayqOVubTqTTkwHV6ZqvPRPsP7a2xHu2FnQQlFTX17eCtBPZA27a6QPrXSTC8Ivxz3em5WEZ42se6tE4JvA2eZ4KvllfuU9keyGEfVGf4W3ks/gonq7qUE37Pn0k91IOird60jnBbMf+NDkw6xoVc4b6SqtfHTbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0m+w4cq36XB63EtuQZY9x6zPOb7vQrzoQ4XUsYPsqA=;
 b=QBmmIZn40QWHZbHsE1Ijue4omn1gh89RZI4Mjoxbe4zmxUxwHUirqzhCw1EulMSkMY+obsvYrU5+9Y1oAg1hA/wJBN18SlUNQGO44PQQvIvnkPUPEQP8MuEegfR2phYSiAM8R5YjvWfySkF9+Zh2FB9NWU/QiM4JDza5eHUfksefAjoIbFUsgKwVmH6vbxFI0K4jcT8wjy7ntbru+P/2vTsFWzVYHvFRgFApc9OL6C2iLYri/hGDZvDnrDDQXSMX/g+roPc26dZjXS3gGxEqX1oQBRPS3qbrferANK4AfYT0GgcdvTFSmsp65zzSmUQeMbVUVqYD4J1+Z+1CxPs06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0m+w4cq36XB63EtuQZY9x6zPOb7vQrzoQ4XUsYPsqA=;
 b=rnhOAfaD8bWq1oNNGiPTcowFNTtW9pr6bqmCY77UaxNjT4fLPksFCdnj4XDRYgxiFtoa7PihYyANOxRWApPNCFBPf2Z298wGI7BLWx/HrygSfthvryF1VNppPgjgjdWJdPqz3DbFvhw4i2mOYg9B9/9e38UstBPZyOq8UUG/z2Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7084.namprd10.prod.outlook.com (2603:10b6:a03:4c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 22:46:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6363.030; Sat, 6 May 2023
 22:46:31 +0000
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Andy Teng <andy.teng@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: delete some dead code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5yh2i4k.fsf@ca-mkp.ca.oracle.com>
References: <68fce64f-4970-45f1-807e-6c0eecdfcdc2@kili.mountain>
Date:   Sat, 06 May 2023 18:46:26 -0400
In-Reply-To: <68fce64f-4970-45f1-807e-6c0eecdfcdc2@kili.mountain> (Dan
        Carpenter's message of "Wed, 3 May 2023 13:40:59 +0300")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0573.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7084:EE_
X-MS-Office365-Filtering-Correlation-Id: 0afdc88d-63ec-4919-75b2-08db4e83bca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tAzLu8cPTL2qWYu0oA31KTts+pan5uAQdw8+iL0pbgQYK2B2c2OgtFdoAQx4R+9GnmSn/Jaa8k1wi+61mI6t8t67Pz4/zYVsa9DhIx18xm/jx3CN4xWoKQrLOLCY4M63TWUs/SnL2d9w2V0xyfDMgw2oYjNrN0K8BxXxomIZPbLrB+kqnQ3aONp9YRRFC8h/kbweAl/XFr3mr76P4kzezFlAFh06qTXOrpfje6nORNq1k0+/A1nqSn/nOvzcik8Y+sAQ0YQppg1+KO3hdQeTcZo/2QwhqlAZSCPhKviSWNg68r4sKK0szJ2zv9YO3mgWMRvgxZvXpgKRPWyAsFNJ8ckhXSQlJcpxi69w5IqSEuvxEQBo00C92esMNLKEFan/1dAc/9m/TneheTv5CejTLOQAZLzJRSUif+sRsPZ+HDJsLjrTCNgkH5DlvblnnGzllrmosatl94F4/nunzPprhaKTmyRP14tMR3BbgN0dG672Zs1ETMqhiQGErEFk9NsvL5N5YxpY4FH7fhlDVVUssYrr7yDpL92zIC5V31Srhbf3NzOFaDguaCPbgeRFZgn/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199021)(5660300002)(7416002)(41300700001)(54906003)(66946007)(66556008)(66476007)(6916009)(4326008)(2906002)(8676002)(316002)(8936002)(478600001)(36916002)(6486002)(6666004)(83380400001)(6512007)(26005)(6506007)(186003)(558084003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?crz0DNdYaFHhXqN++S7zDoFIiUYPQrrSL/wBLI8uezILdkkk7rukZ0vShiIe?=
 =?us-ascii?Q?oNLDxuZMVuAMCqiPLDe2oDaaIXXOc42/nF/UBhBkPu9CYoLU08MhDFpdSC+f?=
 =?us-ascii?Q?4mErhWUlMEG8A/KJuhdYIsETn8cXn968BiapP7TPm2fnWsolN3SXeETpUiOR?=
 =?us-ascii?Q?2OhJfOXXLHVHlnOpufNJAGoPS+XiNSN0yICMrGBwzcPRXV/NsicA4SnfWXY8?=
 =?us-ascii?Q?+5mo/XGUN9zLN7cC1ovMTtE9KfkaZMrOPyWzk2uQ2syWALPIitDtVQlZqQIN?=
 =?us-ascii?Q?g/SAXm4I8lXrUSAdqX8aGX2No234u5MKBcCSmW9SM1Mew/2mTOA4yVdmyz+t?=
 =?us-ascii?Q?x7ijeA0+Dhr2sXMWOziot+jblEFhRfB2jFs0Rg8CBx78xqg6KpkQuE9F42MD?=
 =?us-ascii?Q?T2CmhrsHL5B7NYez9TtqYZe0U1vyP/b+3eXpAVuws1YO/1rQWtAf7H/WGx2w?=
 =?us-ascii?Q?Bu/7BzO6fRuRyC99CqpfhLzi5wttBtY3nd+tA8CNgI2/Y8ozgwF60kdR0C2L?=
 =?us-ascii?Q?LSltXCNL4VIAK/CEIc1S/DFrgFIqrIZCySKOAM9/GIO2G0owQPUOulo6eKDn?=
 =?us-ascii?Q?E2Aal9LzqsGnKBuPZINXG1fd79nwTZF+v+f2mf8uoqj2ZIP+XGM2k79nEbD+?=
 =?us-ascii?Q?s02GSXPQmlAQENjjmzlHJPDKeGWguuqH+cmw6523oUUGppcaNgwox4F9jPYK?=
 =?us-ascii?Q?2dGPYQKu9O3c5wY0DRiPZXcoo2UKZZ3uoT7N4up4doERnvZpwP4sOvQFckCM?=
 =?us-ascii?Q?ZIsOm2fzm6ojZH4L8aj/TUDgxZwP3WmcU8Wn2BbRjatyHsHkZX1d/QUWWBjd?=
 =?us-ascii?Q?Hbp7co2P0AyTOdZZUA5A1Ph5Xvr3uLGlTHoejRIrfGvbDcxPbR6XE9l8OFdf?=
 =?us-ascii?Q?8nAT23JWngTrLlKxR96/Jvj8CqbQ/E8bfJrn+tKyMbMiSdxJIc9xw7z++Mm9?=
 =?us-ascii?Q?V3tPhA6AAwCcWwVpzm52NiSgqoNZZDoUNSg5WEZns43CCOU/Qz5M3ZtrGx0j?=
 =?us-ascii?Q?hB/XDcMFEmgUTGHiIcfdKFzPO9lXM9FcBD9dtYDPF1aeLXa1IZqhnXgfCuXN?=
 =?us-ascii?Q?0RWvyLhaIW6iGy83oXVZzmRr/LTMgflbjsXUkodDcRbb4XlpBNm5q5gdAdLe?=
 =?us-ascii?Q?HvCsYtPWAKOmrRa1U1xkR70rvJt5oHZaQtrJEWoISFVoGHIG4uEfba5X1ZT+?=
 =?us-ascii?Q?jphmgilT58Y2aXe7fiS7vMDGj0R0vS/te9T4cw4ufUImf3MHJtMhiqjXlL4P?=
 =?us-ascii?Q?x/W++PiHIlIAO13GCfPgaXUW2UOjPm+QzvXgEJQchB9C9BRP92NtVN03kOkd?=
 =?us-ascii?Q?5HcNmIj8IhSy30ih0qvidJ7UFERSqyl3bpsohORsZJneE2tklTiwsV9HFlEV?=
 =?us-ascii?Q?UvzZpdhQF/N+h6hTlBRCEEZqcj6DdO4k5+RVDmzGkoX/mBvtlIsen2LE5RG0?=
 =?us-ascii?Q?tmrITc/xpMKRSPPMK05yz47hAJLJV4/kcok5svx4vqRXBK+DCtnCiwoWMcN0?=
 =?us-ascii?Q?As45xrWLVUb2YrKnpks6Jczk1D0CoqWliWNpHjUUKiKmdSO5j2Zmu2e22gr+?=
 =?us-ascii?Q?93titbhWlw3PLFP8GK7sPYUrwdE+0xN3lOe7CntcePQWwP01tG7qmKmIaj9o?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?GtJCZPYdNbrYFMiLMEWGWGXZd8ZgtOF+fI5ISS5jZIV+9bI/q5AUT0FB3zfk?=
 =?us-ascii?Q?QuXKYVNhppCYYbcVa6JrQY3jFmMAMLGN6n6alKHlGAXbeLNH1IK4epCAxoBY?=
 =?us-ascii?Q?xS3ufCcnpaGrAMFzPeSn3CEccon7uQXN1iP7AZjPw8pa2NNYQkCKfWMvd7lR?=
 =?us-ascii?Q?2vDuZHMSuKiCRjZFkpU5L9Po+DRGI1K8KCHp2FP2eAdqORfTuaxO0E3M8mxd?=
 =?us-ascii?Q?25HdL24inZ11tj84ohUFGp1b8OzH882xC7EbPGo6lF/raF6ECZvwuhaCc6zV?=
 =?us-ascii?Q?Kiuw5F2WUvYl1PhoKZ9TohxVAO0bp9TN/q8hJff3DIR8tNGcdU2GCEfYEH3P?=
 =?us-ascii?Q?8HiGQN8CYTdyCPrHxCXjp5yCwA+HZVo1FqfLqIVEHvcBusOwQqgp7ZO6vBIG?=
 =?us-ascii?Q?15ykeii34YUJruv1Ykmxte36s8Kj2YSOlvCPX81rpdTtpWKPXtV6jaaKsy4V?=
 =?us-ascii?Q?84a36Qwe0wwWZJSM9og2jqrgrha5PYkf44o5SCNkm+MrrxFuGy8qBqPxbi9b?=
 =?us-ascii?Q?yCAK87WVpEdYGCCv7T5ONep+nppQTEJYVDRSRG46QWT5uw1kHcAdQUg2TGVR?=
 =?us-ascii?Q?ASak8sHPm2fVOj4ZaFlpJ0DnlFF1wBQdx4LERVz83zUmLSWMgyb1bFa+C7m1?=
 =?us-ascii?Q?FLha1/RtPNUj29cIZmoEiSpJao/VOvqdGzMIaF+Rl8aOAGdmWBhlS+ksyFKy?=
 =?us-ascii?Q?KdcreXxa4uLKTa9n7mIFUgmthGX/jNVTE8VfOM0EhM2AaQsX4NyoYGZRzRWF?=
 =?us-ascii?Q?m1+GKz7XNH49MqSy4XFgjH0nDuWFqjBAMkeYDEZnz4qWbDdbG8iZr2bU1AzT?=
 =?us-ascii?Q?7QRsPhj3isvbLeTA4OFZR9ao1H9hxGEGhves2pNZMrzWTu5XuaDTCD1rtQzI?=
 =?us-ascii?Q?HFpTU7cRDHdn8qi8wdqKqQ0s3Gc9CN2uxk167X4RLBN5qh5xdFfdVUFxRsQJ?=
 =?us-ascii?Q?lTYLC+Bewxs4eSqDTntb6ZpOfmTz8sAzWRvQALzPL4o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afdc88d-63ec-4919-75b2-08db4e83bca8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 22:46:31.6810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WUH5Yw3fCvYi8e83wg3qkH+e9dPCcqpJdf0ocYCDCxNnIjaA0jbbF0St5IqZNK0UBYisnIZOdU3wZ+djP2jcdfBfqdNK0o3wpUOKPIy2qI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7084
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-06_14,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=800
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305060177
X-Proofpoint-GUID: aqkFV8tEfLcCdvYq_PNV8SySh64P1g-n
X-Proofpoint-ORIG-GUID: aqkFV8tEfLcCdvYq_PNV8SySh64P1g-n
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> There is already a test for "if (val == state)" earlier so it's not
> possible here. Delete the dead code.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
