Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6453EB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 01:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjGZBFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjGZBE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 21:04:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603D2211F
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 18:04:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJInN8010840;
        Wed, 26 Jul 2023 01:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=AoNBwsswbTOESIiEMCmrzE3t3xdoyfbCgC8JFZPOcto=;
 b=RAWwIclFp3t/8uaGkJN9jrbLYVFyxzW/PyDnck6fPi3ApExsvG4kAZNJqqaZKe4skg2w
 neWit0c9eB4eLVsUeFanheMyaoJeAAvuJz0lpLG4/rO8EHWFrQXsRqoM7dW/yovf4GAS
 5IhDoBnVFwqxTD5GB79898Tl+W8syeX6j4yrIttZmb4rehwpfknVwR7/uGvFzRmUjzrs
 H7wnTGfSfWzscu0pnODVeKunRTMqEKaRAH6+dLt0wWZEhlaOjCw4vBJea6qdmLoebWER
 Pe9FP2dgV3Qewf0rr/HP585+QZh5Hn5+zogDBADVll8kdwr/z5XHVAIJ1eo186F9DU7l WA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07nupatw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 01:04:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0QT56023062;
        Wed, 26 Jul 2023 01:04:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5h2t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 01:04:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuG15Rpmwi8gYUseST8zwLd3xzLdqPCMDW7YJRgKKafKtkWmSlUPv3xe3KMEtWU7pnJ+QddLxCF+A2bR907eZW11+SsrVBep4nwTrxHZeZB7s1Zxlc96WstWzBCCH3VgAMZaucYc/14ORWLSfYufcTdGPoWj3BDL4dWwbHRlTDf4GkFGyORlUri0jjzyFnu194UY9HYCmohIWcdJRqTmmHod2YSV/Acr//sHmnphCFrmpW9PB+A5BAh/zt87xjJPai7qmtH1R3ADG7cH2wc/SqwgMX/rTvxbOEyen8+juoCrwGwBwPWmjvisZkAEF0vaz8ldEMdb+es7LR2z6ro+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AoNBwsswbTOESIiEMCmrzE3t3xdoyfbCgC8JFZPOcto=;
 b=kRG53JhcgK2bKVDh8cADpB1RVxWsy1XQ51zH0cV2Ohba4DmsLYTCjItlULlxu+UmJs19lRdOqKWsNx5X8e/q77LOW5b+0tl5/TGo4EOJzLnzNz/ywGrfqPbeeYzMixQoaIYWlR3MCy1A7zxNltldyBaxeD5pk4w3vOdNl0XUV6EmbTxaWPeU0pT3mhwoByaYeNpVJVTXPWlKFQl78hHRguLL1WjrM+tR91JHsNfcjEfGPnLUSObli7MSolvp17htav9kiiGqAExLGLAd4bLQVRkVj3hEXEaBAI/gUSKFjeXmJ9D6qsAJW1VjGAu8MGKEnJu5B7bToogPaG3fd2L+mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AoNBwsswbTOESIiEMCmrzE3t3xdoyfbCgC8JFZPOcto=;
 b=pRqj1CUrOg+F/77JGBfUQL5CxMX58/4uHh5cRu78YXLMWWvk7YDCD3Us8buUtFknBVnCdR8/marI41ixVwbGk4fH2vAmv/uLXNlNapqjCB3rFgqPex9WXUQ1XqS0TXJNb9Ak+MLbKezwAiKlWD73weLQaaVKMcJ3lc2yEoVyuhc=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CY8PR10MB6490.namprd10.prod.outlook.com (2603:10b6:930:5e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Wed, 26 Jul
 2023 01:04:52 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536%7]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 01:04:52 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH v1 0/6]  mpi3mr: Few Enhancements and minor fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8e7zds0.fsf@ca-mkp.ca.oracle.com>
References: <20230724132303.19470-1-ranjan.kumar@broadcom.com>
Date:   Tue, 25 Jul 2023 21:04:50 -0400
In-Reply-To: <20230724132303.19470-1-ranjan.kumar@broadcom.com> (Ranjan
        Kumar's message of "Mon, 24 Jul 2023 18:52:57 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:806:23::28) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|CY8PR10MB6490:EE_
X-MS-Office365-Filtering-Correlation-Id: 25b1ed46-ea13-4b90-ccea-08db8d745162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fhlv/+tkT84qlyWCDCAygJXYCnD2b3WiaWgb3qgtwB/UQFyiYLnNJTeOiCwFf+0E3Mngsf1ADHQpingyoTzoW/wtmPtkftivUnD4ceaBDZF4on3d/WZPZoZmcUyeu4iF9Wl4sbOMJLaExh+iUb7+6CZ8MDYwbVCBtx4mn1wHcidVE1fC2HFS8PNE5IvHoNqwXPPLhgO9DcB1M8SqOOEDJj9/ck+BqqzgtW3KlM7emDzPuoqp/+SOnpEZ4TDz5gEujuntmu2ZNJZD4nBR7I3ILJx88KR683Ury7H0yoHtIfU1Ud3HE542ZvLPzX4CpHQC2VPHfS6pjMnPtSz89ivP3Htay+9txTVCGq6Dxn/sUEO5L6q9TCmIRrQqcZRXJwj21FYDjb8Y4ONNtXE4B7oRqcA4XAfOvbhb+sIZt4msl/wkTjVY/IdajC+rmJLK88pSbWTAIWew+n6OfzI6uO7AMqjG8o4VwXKyGO0rrN98fP75+cUetqcQPu4eEQFUTMcE8t3XAIcpUxzXZCFW5aFqdF7uzLa4MNZov+WYKD5mbGa0DbMqag6a+uR5JSaUFvrd5IcsGgi35vyHG99OPniYZ4BZj3rUAZrleDXnxsowK2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199021)(83380400001)(5660300002)(2906002)(4744005)(41300700001)(6512007)(66556008)(66946007)(66476007)(6916009)(4326008)(38100700002)(8936002)(8676002)(316002)(86362001)(186003)(478600001)(36916002)(6486002)(6506007)(26005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?prd3rf/dzJFre3aAY60CLvS80KTNHRFJNX62M0GL7hxFWXQTirkSWRaOdWRo?=
 =?us-ascii?Q?mZrYfvI8QRMQaTPK4gXQWeitMMlpxp4m3HWUfDnvIwuNqt+aKFQx3yVZU1Vc?=
 =?us-ascii?Q?sGRygFRA+0W81pCtmw9tbHvrygb7BM/4Rvy7vUpZCqxSuScbBOxVjaHnJQEg?=
 =?us-ascii?Q?FAJBFC2Qz52Cy7OnTTXnpUMyZQMOEiei3u/mpzuix9tz7h6CsNVCaaFky1RE?=
 =?us-ascii?Q?fkwctxrQdQmWwdcJdjOb0WvKs0o+8ibSSpbHxwPk/mO973WEr3AqhBasx6Qo?=
 =?us-ascii?Q?QoS0OA4RlO5MQVZ7t506qBUJTO0dUPwLhCm0XFGbvD1RwDqyv4NlikO6Qz1w?=
 =?us-ascii?Q?2MK5HGNWRmqJhCrDzepXSNgi+DEOwu9DdVg55zXSZbksnWtg5zl+rAS/dLCx?=
 =?us-ascii?Q?6hPu5QqMJzBLOHqT1Cnb5Y3smXfO8c120mX5zMJTwqsN/jO7J+6BO97KP6WP?=
 =?us-ascii?Q?HcqDTN867PmdakU+t9pycNP8PnF3K+LiWkJdHbxL7oeJt4ayEWTzwFGlapAG?=
 =?us-ascii?Q?mhHxWYaYVlXO5vY3hBIs41TmrqUzgP1zTFJjotmAAz2ovCRMaS70kGCaY+Qq?=
 =?us-ascii?Q?DBN3Q01m6Ay7alT+prgMMhJgaLoH17JnjXZGBRGYWgFgSpdOCpygx+5rMGY6?=
 =?us-ascii?Q?5Pz4ZNpIm0HOJlYLlZz7MfJym5vJN4TgRDkUyrOF8bRRPKOs5MumCRscpK2d?=
 =?us-ascii?Q?t1ZXkUwCoMZOYJvUdcvb4PnSnERlBdHA9FQJyp2+/IkXDIwiV6frSVfg3Ojk?=
 =?us-ascii?Q?7m7Tlm6jjjtHEp8r2RlF78rbTSDQEuOnW/xCy2cJv2V3LoIWFlXs3A0rrokk?=
 =?us-ascii?Q?rqU7suOte4RFaNEKfIDG/IWk+nbUPu4ZKEhhtMRkYGBdUUme7J/hgQf7jPNr?=
 =?us-ascii?Q?PUCQdAQyL97DgJC4/gcM9GNpQXMDzC5GmNvWtoDoMXfGAUL3rXpW0/RWlLv6?=
 =?us-ascii?Q?qbboqfhaSgfGgG8XqoCZH1lIPymPJq3cjrflBEH91zl+RY+grzkUdcLOvjJz?=
 =?us-ascii?Q?XxLuTIFgTsV5cQt5PBAh3VdxGfFIaB7IRwxh9X8PbJbnJYM/3YnF0Z26Uluy?=
 =?us-ascii?Q?3ebm+S8yp4R4ussUc0BfJe/y0kDSsI53EA5LV47lGjJX2al9U89fP+CmqD4z?=
 =?us-ascii?Q?zs1X14OX4lOewOpJi40SGLXEQKbFderQGGCYp7JMLiYlNprqLbzzKdwpVJ5P?=
 =?us-ascii?Q?o8ocYoJ1XNq2DsQbxRjBpOc6xfAmgXyrDicbWNUT1ifIiMGGlL74TwmvJEvg?=
 =?us-ascii?Q?okhue8hUHwsbDCa161FJuG8jSkvMeXr1kdi2ZKdRea400lE9aT3mMIck247I?=
 =?us-ascii?Q?sAMQQf9Z+eCaf5rknFv9zWtcjj4z0EtOP5yAZRr8CNmIvs5rXxVaze4hB00H?=
 =?us-ascii?Q?5jAPzq7DjUftGUjDfBq4BbU7n1fs35Sg/ipmndfZQ/TRkqqV8HSV4lWBgJw/?=
 =?us-ascii?Q?cxfLqavJqpy0BpFxaPxxgMjIt1or1xFgOtvciCkBVFP9b3DcwNCgXQOnm+gm?=
 =?us-ascii?Q?1K8lJegRnsL+7fry8T3DtwTzAE7TWr9VlVik1i8B7YqUfE8wwgjr40Gmfxkr?=
 =?us-ascii?Q?b4eEsJsXeU4j5q/NJdkQeLdvz2LVYh+pgzw1sX7WCyTwwiWb75yoqoEcFCdp?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XK+3QjQsyjND8Z6Qf58mouLV18NjWkmG74m/S0XW2+XdTQgJ/IWjGU7s17eSJUzU+YdTbB/VD+ZFax5nZjJv3dtE7rtFhbdeAFSO8bDA3pcTcO/l5DYbt9CF9ifGpmoh3Td8ChD5CVNfI3TzZ4sktfkJsj3v17O6M/S9V0p2EuFifjHDkdzgLRjZ2Ie9hJrTJG7fhVnFoN2mVNmU/f2118vw0EHLs2Qt7Oxgp96eATnNG0BU7jva8LA+Jkff60d62QcscWJwylh4eBfJBnDy0C1ZLHnJWHdpn/oo7AEeeAanu+tXjgqck9n63NiwpJgPjZQ6gLlR8JIYOr/eqXrX++sopBdYu2ucDk/lByfvv1ox+bEsvDrhPAkbIFVC8XqFy1zOkXbxgB94BCElvbExwY07kxUdA3h6T3T83kwyR9pWVnSPKzw7HAU6G/MQkb1evU/E8/FCgBav5QLMTvO3NmmakYGoSm9cPtfxuydF9LPuNcOxFdB3fW6zSvrl4RolCwHt853lp5ci3YhYNgdYJ41koW9afNVJLlm20m9AB9n3za0hd1sr1U/hGrMWxZ+fZ6tXuwhD7NVG3yNB3Ynb9e+wDLwO7WkKrDs1jemNEtgbN7+W/MKJZImsyA9ng+Wnl1Kmdc+dFjbaOcVNgsQQr1MHQOb5moDBEN47uq87J0OogcHLC1B899raYNJYKFWU+0pVw5Kj4HFNQ3rdxvJSbJcIWc2/yfE+advRV1xphyzjVOEIP5Gagyi5u0fkSdFDUVljYpk2bS95ezPG+LE8kDE84Ko7BNNv/wAnD9RuL0g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b1ed46-ea13-4b90-ccea-08db8d745162
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 01:04:52.5411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BMf2n7U2qIkBX5iVrabDp2NsUfwtk1C5WbCbSkDJlw3FMmolNPQ5lh9PtnjaAIXzO989Zrb2LrqhVv9TDpgss+5IDzlxvqaKjcLi8phqH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6490
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=718
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260008
X-Proofpoint-ORIG-GUID: ZJOAingENLGLxeuF3rJlNPxqPQFQomWV
X-Proofpoint-GUID: ZJOAingENLGLxeuF3rJlNPxqPQFQomWV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan,

> Few Enhancements and minor fixes of mpi3mr driver.
>
> Ranjan Kumar (6):
>   mpi3mr: Invokes soft reset upon TSU or event ack time out
>   mpi3mr: Update MPI Headers to version 3.00.28
>   mpi3mr: Add support for more than 1MB I/O
>   mpi3mr: WriteSame implementation
>   mpi3mr: Enhance handling of devices removed after controller reset
>   mpi3mr: Update driver version to 8.5.0.0.0

When you repost a series it needs to have a new version number. So v2 in
this case. And you need to include a log of the modifications made since
v1 so we don't have to re-review things that haven't changed.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
