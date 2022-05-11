Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C212C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 02:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241266AbiEKC3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 22:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbiEKC3r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 22:29:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B18E21A953
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 19:29:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AL2nKB019308;
        Wed, 11 May 2022 02:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YJmP/xm3NwoDoYnRfw58D/jI5zgPvnI6mwNR+hBMcQ4=;
 b=peZoBSJqlbXOX2kKQHbTRFBdMD+UrwvzPo0wOjrPRKe3g8m0HFJVaujSjUZ0mT39c6iB
 z7/6obkT4hYr6hFrOqXSEPuh6W2FOR7+ha5OJT9Y/aJg+vI0REsXO8LMhROFKHPOJp9Y
 LoOkbgMo61r5tGGa5N/AphF/xZpEv/XjUGxzHK/yf84FXuR/Avt4Jc/3TpqUP6+EhLeH
 +zw198bMNsIoBSYVrwhqgAQOBMyP4fPWQjjLWCxVXPz+WahsBKlpCB0ntb/ISafTRu2s
 UVzuk3/WlGTrxaOt6Y1kzVa6qT4DXQnGb+pKfX3iFaZX3n/rqTAGwpRM1DtsZVSSu19u +g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgn9r34x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:29:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B2LeN9015402;
        Wed, 11 May 2022 02:29:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73s8cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:29:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcFIQQPHggP7igOpGpBu62Fcija194sU5TtRcKBTJKgV0m9HEzWtZpMtZfG5tswYp1rG1DBCDPozydgPpRPD7Y3Z41YewP456ui0GOwm4kjYYP2JfkpD4e70FztlGBziiG095ZSMgih8V8m+3kNPz/AImywDkSMWc7o6V22iAafOx6rQuSqHBBFBGLROpy6wFNNE3RMXDl7mXcUD0koml8G9TIBNom4XWlgQOzcVWhwDwNWk2XSCjGWi+mMSjkU2KhMn2kCy39RRaO6ORX5hykHN7b3QAeFGHEuNuWm5H5b9FbVcDoA3xUxe8/ekB18efwSaDBVli44Igf8kBrRfxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJmP/xm3NwoDoYnRfw58D/jI5zgPvnI6mwNR+hBMcQ4=;
 b=S774J7amYKTN2WE21R7AAJ5lC7dFzVZQNtWvZQ8pVwO89JZGSZ1Cb8BXm1ySMNzTrnxSdH7b6zpzcZKIe1BkjTJtFeu2Qcrjc5knvbLgy8ZDJjvtYFFmu+/Gi0+eGxC1pkPVz9H5e8mz1kGKK1Mlnfads47kb+xUtI7iOMx30LSFGXKNzzll+gAQIVAdCiSgpmQktreJ0bZlQ2zNnrVh+ZbA2p4hsvPNcdnEB0EwFwZV96MGpRiGf1lQfKq1s89j8QkuC1NLiRXfNFkGDfRarFZBSRV8Ombelk8t9fV72pA8zS8rPvqXKKxTh6Vm9AXhv2Y+K5hHOX1VRH0IHTqw0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJmP/xm3NwoDoYnRfw58D/jI5zgPvnI6mwNR+hBMcQ4=;
 b=YlJUfaE92mv8D7Dwk1uDXqsSStx9nzcuBCtVXSk5aNebtZwvinQtdd3X1Dxp/uw5Mynq7tIQGUkfx8RYf8IePQCpawrhN/CcTDvhgBLiNwdXYdo64o35jfWMK+tQmg6tlPiCSUzdwsWX1J7zKYx6+oFyraISgWUMdnjJLwAalSg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4569.namprd10.prod.outlook.com (2603:10b6:806:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 02:29:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 02:29:42 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH] mpi3mr: Increase IO timeout value to 60s
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilqcyf78.fsf@ca-mkp.ca.oracle.com>
References: <20220505184808.24049-1-sreekanth.reddy@broadcom.com>
        <20220505184808.24049-3-sreekanth.reddy@broadcom.com>
Date:   Tue, 10 May 2022 22:29:40 -0400
In-Reply-To: <20220505184808.24049-3-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Fri, 6 May 2022 00:18:08 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:5:14c::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b92717a4-b311-4e71-d68e-08da32f61b28
X-MS-TrafficTypeDiagnostic: SA2PR10MB4569:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4569DA2D21415F71D6D086588EC89@SA2PR10MB4569.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8EcL363J7mD5bxKdL3BG04gO69dFAnz7YBZlKRc46s74nMgdUPLxuyaTSnXyigvjgQXB1kgmStIoI5zqCq3kbUoIBVYDevWEruho+x8CAMM3Rn3KVpxyGDDWBbvCAMumrlsRhARdjIOOPIQkWt8lLMlWNI9FeLfAm9mrkKhS+T2YmJ7Wygqr/WvDFrqRjg4GfaDpCPLLFmuGW0W1d+iLFM1vee+f2xYXbE7GmBFDH6iFvPOquK6uxvEPXgP4XXfF+YBmDP+NDArpBukKDcr12b5mqwgQyWEs6lMH01BYTxAPOw5GrR9giHusQTLuqK0wPJH7sxWG+eepPtZOvODEGulpIPlKCO+0wN7xc38epwreffl5bZ0ebm9UG3oxMZo93UPJFCB4lNS/reS2HqyDTpRAT7a2iY7o+rntkzpjX6Y09l/uFcdiYo9MTczaPrCc7y9B+vE/6rZ7qztaw6NECXrOyJrI3LluYBBVlhcdFeg5vsMGTErskQ0A8HAVlwQu+KjRZyToU47TvmNmmxVHVUf7+uKYa6hCxlstJIeBDJb5NJzBwrOAPUwJdd+d4CgHG09kQH1CMklH59Vao72a2W07Kx4vOiATEVM9+ZYizvLj8f+bdg1iKzGU2Oy37QZJERKEu2reXdEv51YoQPH2z9Md9Uv3fJggFn7iNcciioZvp+5NgQ4lypa6Z+Fc8jSKIzdzmhZMeN6Aa2Imd5jl+TCQw6yZa31jaiPLkXQXPkE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(107886003)(26005)(6512007)(558084003)(8676002)(4326008)(6916009)(186003)(66556008)(316002)(66946007)(66476007)(5660300002)(2906002)(86362001)(6506007)(8936002)(6486002)(508600001)(38350700002)(36916002)(52116002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lqB/mwdoMP4SluMVqv0EIEJoNtIul0V5brtBB86ewBiUtKLaxVGpZdWAnVqa?=
 =?us-ascii?Q?wpkMWe72d7FWo4dcY0U/l2XOXw8uw6nY8jCZrhHW1qyJ+o/JgKIDrrVVqsFg?=
 =?us-ascii?Q?ccXAId4kxtyTww8t5vyHsINBrIzJy8svuypiUx7VjToFYn5IzwdunxdzSQHV?=
 =?us-ascii?Q?8uQHOXpDMAYjxN1HUwBDjz8Er00jQxNMUpxUb+oQNoayrv7nsYhZNod+Z9UV?=
 =?us-ascii?Q?iHt8dfckOt5sOmMIsTvtsBeMw0n/84A3NXj/aP7SooF2ufQ2tnKHKD1rrz94?=
 =?us-ascii?Q?hiq4vYyPE8fFy7s4Ite+n/mcsPygLaH5D7KjJ+JF3FqJpDDFfm6Vnen7PqAk?=
 =?us-ascii?Q?fT04zVmgE2Fw7a2dmdC/Qydx/EjI2VgsRW/TOZ7e88nU+HOJOGyV3XKOaIuQ?=
 =?us-ascii?Q?FFibbwpaLxmsVLY+otfZbPN9G0USYMNI+CdO83fIGee62TTKbnvCxIwFtiHq?=
 =?us-ascii?Q?j2d7CPjybAoPM6wi6tkmj+2wZYAd60nrZnt+DxN8VhXToOn2f8I+2DF1o23C?=
 =?us-ascii?Q?opE0BIEmsfx0S2sjMCL+xbBDhoRqzQk2FF2w0HA1laE+LPfNhry2fkNgEYyF?=
 =?us-ascii?Q?3NaSUe9LRgw9J9PM3PwsWg7kw+B6R+k1/Ublo0y+DlxxjuGa3bbWqZnNMoCr?=
 =?us-ascii?Q?5V2qamFyyrGE2zpaeQuaF72pcJQIay/Aon/PfegsZRtwmR/MLn99xU085a+T?=
 =?us-ascii?Q?3CPpHC00IxKZDH70/2P13ijCv9SHgMOu4HXGRB0cjayJSzUtj5PoYqWD4WLB?=
 =?us-ascii?Q?Q/R+HSS7vpUGLN+rFd0C7G9bDeIlf3q8JSVZ+xBMUKNjWjbf4x3Ul5VMN9Fu?=
 =?us-ascii?Q?UrBfbkrLchz1nlMIDmGrh083PyQsfZ1DaD2SfgIEWRnyqqRBMwdj8AObdc/1?=
 =?us-ascii?Q?ZTJYPzwSVJEv87JZ07rtTeqwajXpS+yzvteTl9fCCIj8WD8Ac1GwOG8L71yH?=
 =?us-ascii?Q?wDTWO7bXxBumerHNtqEFeIDO580yObY3s5qdtCraQJkTvFEofAI2Y3zCgmDz?=
 =?us-ascii?Q?W9ZUGwRM75src40MPRe6YeC6MIGKaf6e4LH7jhT1e5gWh3w9Urleh7nfDeBi?=
 =?us-ascii?Q?9yPSejQoz5MhuQVaBBJqnGil3/OvV6swdV9OPQrHqt3+whwiW5MqZlke/VFa?=
 =?us-ascii?Q?0+edLOK1axaZcalia5DRwi8T9/mhd4k4q7SFp7WVoWiwZOaaalSCoRs5d1kK?=
 =?us-ascii?Q?WPyczgxGPBaeytQHSBe+o2Uf3eO/N9AiYZ5L77sUP+7SXYIOM7MUv+4R9WOo?=
 =?us-ascii?Q?wmWtWKyhxvxq/nD3DS8OJ8WswSmnPDoY3GZRBHhuqx+VoHwdH0aAFtslERha?=
 =?us-ascii?Q?urs4Dra+dlZT3Ggk0U18LEZzeb9k/m9khKVe7YJ7zzwN3RPgVp7h/6tiXYLK?=
 =?us-ascii?Q?c31aJfNFXQhFs6g+aoxhgVMYzpVlsKdDvzQ99qW2Dy0zcDd+bc3o+fTh73Z1?=
 =?us-ascii?Q?klbLVElzSO+qWHU3bRCjezODe+CnegBDHf+st5lZD0X3i3eAPjG9hCWOTgJP?=
 =?us-ascii?Q?QBt6asXlasuOa4ToZDlcy5vBposowbYmks/+/DYSdAn+U2jsFFVPCPotqQbU?=
 =?us-ascii?Q?2CIlv4k8okfpwnV1ODFaLWpdBn5rqu/pGd9ibSRv/Av5sHLv7SyO9e7nWX5x?=
 =?us-ascii?Q?8yD56AjPOdikOwLl+oZ67J81woBQXEc2PRCHiqePWxjj3Audqw1tZMMbw9Cz?=
 =?us-ascii?Q?RbmIQcBJFfH0BQBf2RirjwsB2pctI2Hk0LpgBMggPAaEPvq/PoWqrUXzOAT5?=
 =?us-ascii?Q?tdnPoz6zrV6zDGqYRbVH2ycrIaEvvf0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b92717a4-b311-4e71-d68e-08da32f61b28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 02:29:42.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YTI6Ev5sBEl8Y4HiT9GrjYIYg0WXbd8HKuE1j2w0P567VTSqqiUT47IeX22nwYc8/NILX5xFl9XsFl/zmrXbmKn1E7zow5xhZ3FVZvJmcrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4569
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=648 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110010
X-Proofpoint-GUID: 0JyM4sO78cIn7_GqcK3_VBYAuow6FZsU
X-Proofpoint-ORIG-GUID: 0JyM4sO78cIn7_GqcK3_VBYAuow6FZsU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Set each SCSI device's default IO timeout and default error handling
> IO timeout to 60s.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
