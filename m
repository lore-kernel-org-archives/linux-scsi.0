Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F31BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 21:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiBKVyd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:54:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiBKVyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 16:54:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F87FC6E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 13:54:29 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BJ4vLG019126;
        Fri, 11 Feb 2022 21:52:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MwNmyFQP3vHbdR9CrvCXKLojsKb0gPSN3aJC0vr6tuo=;
 b=HIHo5cOBMl8lc17SUb0XDEQTlZL1hHrWOl0jMHDg1CfCnG46RzugVyQ1AflhS0ZqeKNV
 Qn3eh4K3UJDeR0hn399kpMl2LkJtPJPrDX1pawLrFTpTPkqp508KDCsyVMt4I/DP3MRG
 49X4y0orSb2mNvVTduLnLx0bHwOP3sKo1oxwPnUn9vOyJzI0s/2KJvu8No9qf1TnQNVi
 7VqFQaAVqZLPQTg/5h1cUagaBJ08R6+E0LP1CvrcaNfg/ycnw2h/UKDYiLLTEWa6A3uD
 tERpuODDYcWoeyBdHNqA3ie9+5gyKesVSYKCxVzIh7V6pafE41PR+Nmcpt+a4bN5E9p6 lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5gt4a7a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:52:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BLoHE5087412;
        Fri, 11 Feb 2022 21:52:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3030.oracle.com with ESMTP id 3e51rw0q64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:52:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SA1DoU7btdGFofwIVXONtuiBOfg/lcHNxQlotNUmIUZFv5vWU2Ge4LZF9JOtclvB0/OwhEHIaT3gqQMGAgRsqhRspdJN3gDjfsudN+tHwcKYYXTGJoZLtiHU76Ih302fKCSj3rIvyAIvmFVNAMwbsstMSDzjscYBZZAM5E8uSGlokF4fPRy9ry2et2F+RkBrHnvKifF8iICSyStx5HoIiPYOdhVZioVVKT/7JrW3nvJfWrK8/nuOeXhDMbUEY2FVpAq8H/jW1edRDnTrQyj9HyYqsmlLjormYU1cYpiOrnxf9y1f3Vol6QYKDYIwgSS6VBrY6qOAdNxWPYnyXpRbuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwNmyFQP3vHbdR9CrvCXKLojsKb0gPSN3aJC0vr6tuo=;
 b=WEGJJOW1m3vusQq81TpicyQ4bfkOtxN1o8g3dBI4/UxIzMukd5RwDkQAffzYgdSbQE8PdIAHp665t0U7Vkc6JW/mmaVWhfYvCtFuECjSfT+qU+mkPYDaUya1lasqVEwjP5govY6iAhbA228pnaBHfTVL9RH1DveomP522QmQQcP8bU+HNK+J+L9dJ/N6gikEkP317KMc1XsIJmTC3TMAGJT1nq55RVjsKFjswnhYpZ8GSedGaEWIm4pEiYvm7ZSqNOCsLevlitkocrJ89+U6rozY5bWmP9N9MSD/bV4+djC7miC3EGMiyPSTUo2FMJsi1Kx0Mtbs9srjaoDFloTrUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwNmyFQP3vHbdR9CrvCXKLojsKb0gPSN3aJC0vr6tuo=;
 b=uLRSKytRVM051WgMKo8IF/0AoakVUs2Vhfkn40f2X27D6LAJPwHfT/TWPtISKrqeplraQ9Y5xjtgwLXyYuAiOzAMiY8SvM6hAC9zC/RB318FDz1MwP9i/Yxyv0b6iVad3syEwTPUdIAvK2gUl/KYkSDcll/zTeXRGLLA6psjSQQ=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by DM5PR10MB2011.namprd10.prod.outlook.com (2603:10b6:3:111::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 11 Feb
 2022 21:52:02 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090%5]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 21:52:02 +0000
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused qla_sess_op_cmd_list from
 scsi_qla_host_t
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8xloyvj.fsf@ca-mkp.ca.oracle.com>
References: <AS8PR10MB49524AAB4C8016E4AFF17FFB9D2D9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Date:   Fri, 11 Feb 2022 16:51:59 -0500
In-Reply-To: <AS8PR10MB49524AAB4C8016E4AFF17FFB9D2D9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
        (Chesnokov Gleb's message of "Tue, 8 Feb 2022 15:18:38 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0146.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::31) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15d2ff7c-9b49-461d-7cdd-08d9eda8bc9f
X-MS-TrafficTypeDiagnostic: DM5PR10MB2011:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB201166D283807B88CB0C37F38E309@DM5PR10MB2011.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PfyihslFqfyBSqE3S2RZTPs2yie3H8XDtESrrSrHdsDbzrHq+3a9POjJaNoFgsFAANp/L+K0mNcG0grWEdIeAQPARF39UrueM1JF41xpzsBVem5u3Fqkpp9vYySqDqNWuOyfH0EekTC+7n2tQMfy7Qzfh9eqmpgxo28XMBBSeF2r/7oqBD8YXMjlY8HKhOr62CrN6NvY+xhKwYlb5g6qj3QiX7gmXSbgzOQvVpy2tzojuKhwg8HOcvLSPD45C6tVko7TMOr46a7Rk30CNenQNcX650OVDoBuKUCkPCdp5P5jgRCXhtWrluq9mYKtj3X/LHlWUnAv0JIp5LfqzZDXp/WslU3E1IDm3wsD8fK91GcuT1YyOdwOVKIEkNQBl05Ly4uSdtjCaKpHpg1SLnGbGQNfa9ezm08Yg50eX4OG06mLwHBUFgbx+eM1iaXzDyZGUk3n32MPX9Qv0rdlSjuB15vRkmm1IYSO/cSAYir7e+2TskUbczolltfrbXqYE95hwj4LhJz2a/Xc+FpKDBsGNoGtsRPMqDitrkZdEXSrEAX16r2tpew16SAOUqZv2T70ZOkOEFidDFSu6HNspB3ohAObTg4syrjQ/NmCIaNUUcxMwDZpHb+ksSdYaofElUnUk20K7a7N1FfwzcRkAfka66o0a2nhZtPncEF7IixaxWa4Kd+vLLPUI2TTrSoeIxjlPMb/3NVAroNkq3fCbTKQXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(6506007)(6486002)(52116002)(186003)(86362001)(6916009)(26005)(508600001)(6512007)(8676002)(66476007)(66946007)(4326008)(2906002)(5660300002)(6666004)(8936002)(316002)(4744005)(38100700002)(38350700002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pdWsNh05Z4xiqMGYEa5qYfgpFTb6JPg9+PAcasnrJQ/jlWakoaHSCUf8SEla?=
 =?us-ascii?Q?86J4aNCExJy/97uhbY2+CGeYx5k3SeMaZnkyFLktSEW3S4SXq1J+/cCHnQnW?=
 =?us-ascii?Q?y6WS3Ne6tZmcgyJ11bYuiwuTqzrNtM+e9nSsirvBd61Qjbeq0EQtobPvjqUT?=
 =?us-ascii?Q?ya2NlMzcJIOD473UZ+2+lWeZ7u7TCaEF5q+6jwB5AjYQLKvkzEmhNbKIBRRJ?=
 =?us-ascii?Q?7Er6nKCruDI+8d6zxmBB/1lL46FpqfL+ejcL7E26EiqA9AGyUakIy+AQ0kpD?=
 =?us-ascii?Q?SoH5kJDf5dFgaRNJy46HXMltl/38yK54vGE8YfdZ81ap09RMQNFFleA8DuHU?=
 =?us-ascii?Q?Xfi0+9yiPoN77Y8iWschluT9FYshtBQ3xJ5k2g3+EWUc8icKZdTVkhUunu0P?=
 =?us-ascii?Q?d1Snf/FKO4TyAt4Nq95Fe1UE5rsVlXnP2o7drOk+Ir6BJdG0e+xJiFurOYVX?=
 =?us-ascii?Q?bmtTA7iA/nJK3GtWktb4K8LIdUgcoR7rerLMcPz4d7UM4CaYvtMUAA00HXc/?=
 =?us-ascii?Q?KdhGavVkR7gI/5LI1uaIpfdpBlmaD6q16+F9JmPbLou2bcka5xA+7cCO1zPZ?=
 =?us-ascii?Q?Y2v/P9VVkhjs6ifdsBw5qABVQE/hEz5SX2OhUULETsJvffU31UslKcetwqdC?=
 =?us-ascii?Q?vMgjmjgk5uASz2L6MPDHH/oc+jRWvZ0Q3VojhwUlRz87zwGri8tttF6cpVRT?=
 =?us-ascii?Q?OZCPCDOGycDh45qHVx83fYk66u7HRI0LT9+fWRfGX2PZFx4nLzvZ+s38vXWx?=
 =?us-ascii?Q?DOV3UEKQVdnaovRop8k82/AJHjwvqFnC3zb+jjnBuJLuKAx8RhopMLpK6ZUl?=
 =?us-ascii?Q?4sOvSVGp0qVLUkyhwwjoOmBdWIIrF16PRdVw2aa2+hHa9GytGcxyFFvQ3wuw?=
 =?us-ascii?Q?zUUIIbPuiWtwxVPLsOYC/Mr4ay5+BW6Sor1Sv19DZAjqBcBTL2kcmmEtYgFe?=
 =?us-ascii?Q?R/npRe4I7n3QJaLcX1YTk0/OthmdNcEDh0Nl9LQoLRnNhTMnW+L5LuCICzVF?=
 =?us-ascii?Q?2mWNygWZGseOsmRv35KKXoabBm7mdx7fvpiKcCFPCEu6qYIzrYFok7XV1zXG?=
 =?us-ascii?Q?TQ3XhrJwsC4+aC6iLTc+uy5IsUgFUQnjWe6wleNbjm7MmSEHAHkzSn3Es5Nu?=
 =?us-ascii?Q?5JzwTHMaTKneTQsFpko6iqJ4+ihJ/eDcnivVPrc5pynLG9yfvX44r8P0EmU5?=
 =?us-ascii?Q?ncUYsl7j7yfHbCkP2k+ahBIhmVcSaDDB4taTYtOAXWYAtlBUK1BfJzWw0yuD?=
 =?us-ascii?Q?g8Ci1SjFG2wC8sgyC79QDqm3aH7FxJXTUFFE9zsofMPvDqS2MLLgbHvLZ0WZ?=
 =?us-ascii?Q?CPXC8XL8gK/74mB1OtvLha/A6OLOJ2SYYKSaesbXppzmbX5JKSMUoqHOWWpf?=
 =?us-ascii?Q?2zs70zGn0k5HkrU+OIHvVd895dLxD9qC4BtdtVtlHczvnrpq8OAvAUhrUx6O?=
 =?us-ascii?Q?sBQ0utE2HFF8kL4an/60qjVB3aK4z11Oy6IYwNXGEngy8useTWCLcooSwmGq?=
 =?us-ascii?Q?nMvmUH09rW4rbpxSQMktiRb9L1aDiRchHWXmdJ+wcl5mcWJmxthC9tYqikfR?=
 =?us-ascii?Q?LxnGefDc4c+LdUXTHT9gZ4BFI2WzcoOTjPeSmE5kPNofU7P1Pd/40cdlwaSh?=
 =?us-ascii?Q?+hlMa5yj/7ZMWKi94+YH2OLeNQl8Yr7ar5FFVpSLI676epL5hKuNa4mYz0R7?=
 =?us-ascii?Q?fnJ3Rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d2ff7c-9b49-461d-7cdd-08d9eda8bc9f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 21:52:02.5586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5oEaS+rn4yuw8k6EFo5FHJyGcblBVuJYdpYvumxhcRhLM9XrExJxR1b7nP7UvdYMobLbS6BijklybIhSlKd3va3ETmBUUXJjzaANNKDxPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB2011
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=997 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110109
X-Proofpoint-GUID: mIVTPNq85I3OJIwGgtS9Ung-dHlx52Da
X-Proofpoint-ORIG-GUID: mIVTPNq85I3OJIwGgtS9Ung-dHlx52Da
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> The qla_sess_op_cmd_list was introduced in 8b2f5ff3d05c
> ("qla2xxx: cleanup cmd in qla workqueue before processing TMR").
>
> Then the usage of this list was dropped in fb35265b12bb
> ("scsi: qla2xxx: Remove session creation redundant code").
>
> Thus, remove this list since it is no longer used.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
