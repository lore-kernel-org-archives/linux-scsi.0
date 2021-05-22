Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571F2C04FF3
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 03:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 284C7613CC
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 03:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhEVDZW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 23:25:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34582 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231166AbhEVDZV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 May 2021 23:25:21 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14M3Nv3t000844;
        Sat, 22 May 2021 03:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=SOYCtXawy2w1Eg85cZi3aL3AA+/In63kslETA9pvkXA=;
 b=nRJp/cFUkAVb8HTyNAFDE07ngq8qf0MJmzAJp0loKmJ1SWs+0LnTKLvMPu6E8AvcXCU3
 6lpXsVJs93Eh1J4Bri2d/J3Vy5Lcfmbt65I4h0QMxoVV2BLQvx+45iU5bGUKf5YXEY9Z
 FUnQF7p6en2pLyDRgX8noxfpg4MIdAOhZk+gf+ep4gJBT/dhu7p9suP6MjzNKe15Ayt9
 PSUMkYhAiQiKZQAfGZx7bNc2zAUZidhBX5K/KIfUVmtgbpkiAsVVJRgLFGX31gpcbxw9
 hGu9HaahN6Cv/TMGI3hmXxZ6vQdHVO/FB9qQft45LHFiGCC4Lb6mInULdwDJZo73hAjL mg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38prccg0xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 03:23:57 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14M3NuEL025564;
        Sat, 22 May 2021 03:23:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3030.oracle.com with ESMTP id 38pr09hvc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 03:23:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4Hi/FZm3KXeQZAi+fRhrok/hZAlxZFuGTYFaabk4TymU2zxTgGmAUpbHR8/vbV4qu/1819umWYp9jusuX1pu32mRiQOtDPnfmVuSMxLH/oVxvRpzdiPyh3b1gpyONT4Omy7B6rR1tNoFWhqFsGJrcOWyqhOId/IVGD4VudybDrZBKdQ3zDDjCHwC67qE2Sbca/OzJliNNpjv53TI/ewdReNh5fD8DaSkIwnFpwPlDsshyXdarOGkkgDNr2ZozUHTGefAeIykU0nyuI8Az36aw8ulTdMMm5p6x0rPad3yiB72gyncRl8mxLRCZ0voiyLwrhUeeV2gmnjpk4WE9bkXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOYCtXawy2w1Eg85cZi3aL3AA+/In63kslETA9pvkXA=;
 b=i4ank96yO//2T3ZY2pSnAykK34By1SBsgE/NrbxIfHL2PhIJFxMFc7MpVpOzNRTJKCRUNkbVIl1/KPTxwEPctQ81khiYzeodj34oRZ7Ei3i/QUq57oZDO91iY5v3FIV0G3x3pA5BcY5LYVFPDdxKhKavsSahKs38RvOHoXAtFGgRJlBY4NmVqzDg0tfC/qmKguHNcKKRDcKoXGGhAyUm/jkHTnRnKp/kWsRAiT/zkIafJ2zffDYRC8PisuNkVcaRu2O1pH3jPoHOwRaT9aFU5Hr7UTkAOOPyYqZvpFUOEWGzCK20tWu388t5ncKp8s/zMG/T2SMopm6WtNNEhyH2uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOYCtXawy2w1Eg85cZi3aL3AA+/In63kslETA9pvkXA=;
 b=lmoukKsUFYw4Tuv9MrXei6UnbBwUJ3t7wuEjdvhMgStfM96pjLjm79f2DTwhc3r4mRStIWjwPd9BU1UiP1k1bOH4kvt/bPXi4zJSyAchqfBmr/+Gz+vfw64cXbF6+Ms+YkyZVT2Xs9dYJDWcgBWy7rWTYot2O2fY0TDTPVZ2ffg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Sat, 22 May
 2021 03:23:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 03:23:54 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/11] lpfc: Update lpfc to revision 12.8.0.10
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf87zc20.fsf@ca-mkp.ca.oracle.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
Date:   Fri, 21 May 2021 23:23:51 -0400
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 14 May 2021 12:55:48 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR16CA0017.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR16CA0017.namprd16.prod.outlook.com (2603:10b6:a03:1a0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sat, 22 May 2021 03:23:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc9e4d70-c325-4dfa-571d-08d91cd10715
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46627F21BB2516ECF9A750D98E289@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBz+iQgkDP5rRKR8UZIcolHbL2gnBHO0QzRBzIjMR+nw+vuz44Cp+NCtukro7PP4Lq2KfA3kJ6hD8jxBJTyhjmqz3s1L7jywijLYBas3eXS9VGNosP1ixALiy14vKhGnpn1AQscWZ7uStHluXwuTG1/1IOuvcdiYSOQ9rfLrGOduMkKFhtoorWwHiTAn2NjCPsAO+hzSOJWuaQkiLTAdl1K5y/reoGIp2RZQiSE3V/CQtb+cdD4X8oDRGRsrLEELgaCGd8ob/4so6bxSk20WMOXeUt0agYewUDVp8HhdfTSZVw6rvwkU1dbXsbc+fIzYaPycrJ9a4oXaDphwxnh5gTz2A0S+lMEXVUHq7EIonSU+Y+l1FMAidbgkEA7MEraA3iX0bsIVNU/5yMUDI7raM2V/QhcXmYXKhoI+dYzCp/icWC4qSU+mRS1AnTSbJxbjm7wTq05FmwcLHn8Exen4sOQ1qV4R1vbQ9zVRjwhGO82qOjicxUDhahrGVt1IkC+ZkayDSIrAqwYWDjGwBNBnLWmrM0M/vTTuXjcIH8fbdLcoQsn697+RWYl9ZahpfUqMkbsc1Ayyhnuhvw7qWVCxSRx6o1A4ClA2gOVbwnxWpzpIuZhNgdLA7h45MTHIUqqj3U1FQ1TDYK/LqGCgyVuEV4+t2mHuuFpUvFjZv/PJtFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(39860400002)(346002)(366004)(66556008)(66476007)(38350700002)(7696005)(26005)(36916002)(55016002)(86362001)(15650500001)(2906002)(8936002)(5660300002)(38100700002)(956004)(66946007)(52116002)(6916009)(4326008)(316002)(558084003)(8676002)(186003)(83380400001)(16526019)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?X20udIX/ItApeQgv9LFFRW2LVsSMFZ3ziNzzxEAB1+ir6Fz9AmI3WfnXgvZp?=
 =?us-ascii?Q?44NnC1T1b7eAr/jieDwuwESF8BM1e9auh34VvjP7g9Isu0397oHCORp73bMU?=
 =?us-ascii?Q?hMzX5VVI1MsCclt9z01sNTfaa+d+U4JV9Yf0OTIAewm4/oh3T0RDdfw4SqUh?=
 =?us-ascii?Q?Rfomho+j1qYBm96HeDauj9Yp79m6NDeHDNoswaJsgWUi57A5r3ZVtBvnRRvE?=
 =?us-ascii?Q?nYWA39ENcT++p/2KUBy0NTZ2135N5zjZLSawB2diK47c7vLdLKOPSUu3hl2v?=
 =?us-ascii?Q?JEmC7R/bDwyk3R84r0dJ7afTKZh0tLjB/9emnTef97EYPO68ymBbrwfFPx7i?=
 =?us-ascii?Q?iNxMkNe2CpeaQBRth9/8b0kRCXNwQtqQXn5NtbeuLh07GwTueVV72ZICsFf0?=
 =?us-ascii?Q?uC9YTzor7zvuGyQezi/QPik6NdEM44g0WHmg+UmLnARKWRr2oe+Q2tQgIHZb?=
 =?us-ascii?Q?aTWkqSRt/XUgDYiMIeJPu3BB78bvK/n9XLZLRxf292pOdKDaScDhtWpqNHoL?=
 =?us-ascii?Q?dnb6bx1QHaSLOWlvuw7RQRNwpARRngqeqHweltd45/mvguIsr0/s9jfzPbzX?=
 =?us-ascii?Q?ntd7YzHbcK5hqkZWP1ceNETp7nAr6Yk1s8hTRn3ksoxMrP1Tz/og2kuQKzFv?=
 =?us-ascii?Q?pN+zVIsu/6YVPTgp+yAmrbXJVZMg8xaEMuJM7nx92NH9x/p0X64CQF8FRZGY?=
 =?us-ascii?Q?CVCJxJ9MpajRZUzHMWcKYAOS4+i4QbcC5oSTo4YzCmWfvHQI35R/g26mfeNp?=
 =?us-ascii?Q?UZysn5D7U8iz/pbVlmGUZC23hsmDz2MjUg4onNqDZ+JK4lQT7UwHSrrIdbct?=
 =?us-ascii?Q?NR92k/19fFSW9lHIjnPnFyeeFAhGwT4hMpw+MdIwP6UuIEIwbz+/pSTpoCmG?=
 =?us-ascii?Q?hIlvke99FlAa5XljGh7KG+fTakch/+w+HOZkd87jsTCTJom+4TW6j8mmNNjn?=
 =?us-ascii?Q?EHlDJ6YlMXiC+RTSbBHEVrwOH3oVNSP1/kgeBloZNfozZw8qNAeYTwDxm00S?=
 =?us-ascii?Q?JU8hxoySbodQtzRCvwXFf8ONVN4XOX+4bvSLGuoyNA3Ukx4PVqvItiuaYG5G?=
 =?us-ascii?Q?geJSaIZLfJk0AAXk1ktpmzJ+lU1f6odCKpnUnbKhnxk/fJJvhQGqIXHnMCZ+?=
 =?us-ascii?Q?WzMLidcnyQl+yjVOB4HkitaCEYQQ4Mpox/gxF3ac7cUHWjCXuaqjiC7euv+p?=
 =?us-ascii?Q?G8ftK80d1sRemeLtJ2BN6h0XRzyvEl4OD120pESE36bGd0jR7qzTvBt2Tci0?=
 =?us-ascii?Q?y/22NAFaeAdm1LAuNyQnBHsAmD+J9woQNGeKPcf8PvSEmuGcKxUAZUtH4yqY?=
 =?us-ascii?Q?HT8e3AUxROLuIyyYk5LTL+wg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9e4d70-c325-4dfa-571d-08d91cd10715
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 03:23:54.3392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5cfcqYDSdcS6R0+UGoH3LtNOcPvAmzj/EtfKwYyEe1YsjZ0NkqjSOEWTK/Fm/WLNY7jghza3n0AJr4N9wYbwCcJ3v6Zkze3b3S4ev2HUIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=990 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220019
X-Proofpoint-GUID: zcVWXSTxBrIJvOdUMgCohz1lDzs2PZHA
X-Proofpoint-ORIG-GUID: zcVWXSTxBrIJvOdUMgCohz1lDzs2PZHA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 12.8.0.10

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
