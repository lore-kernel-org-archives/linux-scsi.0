Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93899C04E69
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjHHChT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjHHChS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:37:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE228B8;
        Mon,  7 Aug 2023 19:37:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781iPHb030955;
        Tue, 8 Aug 2023 02:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=GrJZzkSWh2elkbdjRoGKfEra3Cex7y/92i8+Gs6TN+4=;
 b=v2sQ5ksOh75KlPavGLoHbmL2Q0FKrMQwrMj2XVxFR9CBVUD93ck1LNwn5L213WVAaxM9
 XbgoPWqCEWsCns9XXddA3OxBynCByRnId0lUbHPzUAIBvYb4G9RHy13DROJE7MFGqEvR
 769Ags+E7GYS30J/bELY2xGaGImaK8YXbVimtUJK/G0pSe6JSDdHADhHs7VvQ5iLMmrO
 AHZ8tZlvCUC6sdpvGtLVCxOGsfl4m2lhJEu+8rDWLE5TJN0y6t7t4f46Ya6L1Ld+FLU0
 gglHrLerdsEsEAy65OS+rFW2M7CRg7STcJ7nN4jCGY28e/l6RArlCK+Lv//34Ntev0WU yQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9d12c5ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:37:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377NUgsd022825;
        Tue, 8 Aug 2023 02:37:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv5drfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:37:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amxHuawY00UWhB742bnUZmHHevextUFPhbuA6xlk3Vp5O/GOx/Vi8ozO/oAnsdeQYfBs60EBgstEIJEWTfFPtrwtA0+En1adJ2uM9A6ZoxxwYb0STF5nglpiz98fCrYyb2aq7EsF+tDFFmzNh8qWZ3dqyl2gt00r32e/1SE/OY6ViY+JpDTKGtDbbZ2pXMMs9tI4atYFZEnsopHz13gfC+cvBCXHJJ67Xb6QsFLEaayLicv6jja1YrSSTTslefoazgUHwcWdg2Aj0FXhNxjJSTvleR4+izPqhLfRu6kRS6tH+ahUBuE/k2YR07CwN5NdpNU5EdoUMxVIa9DTUgmApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrJZzkSWh2elkbdjRoGKfEra3Cex7y/92i8+Gs6TN+4=;
 b=PcByY8m3E+XJBXu4VthDH53gStn42+7+mbYI0TrRcqGEyKq6hwtYuAkpp5XRHAlPQjENSkqXg8zsTYbW74P12PLrxh1vVeFFKOtMF/q5g1O9FP/t/MTh4AputKXAirlQ6THk9yNcS8I676z4Dq9OjGv2uwA4m3n+HalmCEtyogTmZP1voNBCDye1r+lnJ2FxoYAmIGjhPFbxzYIfUvBBqWA7ayOalO4dVxLsgzEbR9L+6cKozbKNG8QqyxklvSCfObFH/COtHO/Hxh4/iI9fn8EZ1A0JyKzZmRnelsYgDER3m5PdLK9srNPSWhWg55glxNXJiFh2Xr9WHMkFoBGfDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrJZzkSWh2elkbdjRoGKfEra3Cex7y/92i8+Gs6TN+4=;
 b=OaQpxzdcVV7R4GpQy13re+aS7AEJf/qPOoW4upcHNr+ZgzmFcvnIm7vNL63KwCDy8bYBOaF5f5qUpSa69cbNeUK9UHQxhfCib23bq0tLLq0VOkc7o7xqLd3LDcbVOQKdmWifZAGrpkdbfsDw5jAXQVtlSAIsNTmiMgNDX7Ht50o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW6PR10MB7590.namprd10.prod.outlook.com (2603:10b6:303:24c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.25; Tue, 8 Aug
 2023 02:37:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 02:37:12 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Perform additional retries if Doorbell read
 returns 0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sf8ujmf2.fsf@ca-mkp.ca.oracle.com>
References: <20230726112527.14987-1-ranjan.kumar@broadcom.com>
        <20230726112527.14987-2-ranjan.kumar@broadcom.com>
        <yq1o7jsq9lq.fsf@ca-mkp.ca.oracle.com>
        <CAMFBP8MS0hwd9-bfVrPi8yTB3Es-w7ugHwEMyxtb8R-mj8PPCg@mail.gmail.com>
Date:   Mon, 07 Aug 2023 22:37:09 -0400
In-Reply-To: <CAMFBP8MS0hwd9-bfVrPi8yTB3Es-w7ugHwEMyxtb8R-mj8PPCg@mail.gmail.com>
        (Ranjan Kumar's message of "Thu, 3 Aug 2023 13:46:12 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a03:505::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW6PR10MB7590:EE_
X-MS-Office365-Filtering-Correlation-Id: 9883d0e9-5241-4e5d-476f-08db97b85eca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJCLP+nCpVxB3axB/zoWKV4DO8Ee1DG2uYk+VlwnvIcY7DKIAaJznMuJXi5yqkjl8F8J2HhV1MYjG4eCWRX7kW88hcDHLJNdNRlN5/ds0wTlN1SvU8dFOpZxy8yZ8LU6DfBdfB/VA4KTXzk7tgMh/Vkmm6oAzlfEsA6A4N1Ta83WIk5ZY6Gg2BxiGcK4+H4nWMkvolWjTDd1KDySsubCaMkh6TrVWjvL8rGfyz5ia+Mi+TJm42ZkVXYLoN0Fr4XpsXiXX7ybiI1fTyIu/91UH/aU2gdSyBGdDTj8uLRARPQhIFg8MTV0Mns23L7Sm2h6LiVr8H0RhCuOFJjO5YVvVsHxMFNs/K6aYMMUP3iO7tE7+IxkzSaY9Ea+HYhNCqi/gumZaUey1x0A3qLJE2GTbd8Duy0cW+SU2/A82f3c2w615cEPSV3hYcmMyW775zA5fbtztwj4hOjdyRIIlHmBferdLdxsZ0wK9HaScy0bQXSLt86wC2d5gt1xNfmIYM784Pnwdi3uZJvoLcU7PiMingTw3D4oWPnZUvJWn8txVpkwtuu0OorgWObWCxROOu3Fhv4yrPg0AOsExX19UlSymYEhQATUJmTITD3fbiF6cuBYxR9ERhgceUbnAAe11YaygKoYZfzU+jFm9D6MiufNEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199021)(90011799007)(90021799007)(186006)(1800799003)(6512007)(4326008)(316002)(86362001)(6916009)(38100700002)(36916002)(6666004)(66946007)(478600001)(6486002)(66476007)(66556008)(6506007)(41300700001)(26005)(8676002)(8936002)(4744005)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qGStVNfsBn8CO6U2ctPvb8xdpsBYyAHrDjByy/KAmwNwfLnw/ylp10MNpX4a?=
 =?us-ascii?Q?AHpW2kzMCFXptn2a2BFwJAhGzCpZZxLR0ZR0DzjUwEwMkaPXtQn8t4AqTqW8?=
 =?us-ascii?Q?S2DxeRMw9emQQ+yon36UIHWNU3Tmzg2HaMoBS6D9slLUZuv4MINwwq21cpXU?=
 =?us-ascii?Q?35obwDl/ndJCi7xWtkbg8qHglU24mJxN8ZU2IOnvT9GfGqW8DJDifmsbsXvt?=
 =?us-ascii?Q?69DWH9O/xYoMbbF0C7sZ8/cjaMyKC9t/CIpgofVgtDmludgCu1LkpmAJ/SLp?=
 =?us-ascii?Q?593J45xmy/i4DCGstM/o+5QIGXrM8mWmUjRl75uGZ//Tjf4+cr+OcDi0JNFU?=
 =?us-ascii?Q?oReRGAOphUlMmsIIihjFVdUSQOc/oRZ/TKiPcHokOf/36+YUUMAvsdbWRlPl?=
 =?us-ascii?Q?EEpzLcycu9M4jjMFAMigGZ+teEoE3S0XHlKuzGfbQdTz5ya2n6ANcRsuIbgh?=
 =?us-ascii?Q?cmoeB/4QnNR7XOGEnCEvV76jyCZBNEQ/FHJ50BP16eMe4jYauEBfXoefXQeg?=
 =?us-ascii?Q?NFpnMVmdGc5Zsmnn7A2QcaK+WNRrtstKNmiOr6PNs17Rj6kxo9Q+/dJvfYzV?=
 =?us-ascii?Q?2++M60iwpo6aNloSq6t275Qg4H7LRPa9xchNSDhTcoLaFEXI1nPEM3/6DvfQ?=
 =?us-ascii?Q?4w5iMWRcsPM/ElU+ouWKA6pNBb+k3dhZxxTaF/4LuZg5zpchQEaxckv5jJi7?=
 =?us-ascii?Q?44uMCkf6l8hLkRCXrn5Ex6NvUK+kJLjvIQ3sWKa+Wu839b+g85ZohvBKuHHV?=
 =?us-ascii?Q?OHs2xpuvY7N+N68a1tx51IgJVlimKH+1kvoJCddHB0NncXQybxt/7lw549jW?=
 =?us-ascii?Q?b4La4JxquP6T/MgtRlOg6NqvqLp9LR3eVke6/06s9baemAyxw9b0pxexubTA?=
 =?us-ascii?Q?OCOyL9TTEHY5dF2CDMSsnRki9H86Vcx3Oj4AslqNUR3AMP6Rf621Z/IAgSIX?=
 =?us-ascii?Q?jDAwWkVt7bygTPCUZHu8OlNeQWg+7FQpOsEiBO7R3/FrOXomBlwkQeJJxMCK?=
 =?us-ascii?Q?RRdSgThxMEi/wxrWtIqdAhxaYkUMOSbbSCc4dxg3Mue7nB+fAutvgrVxUWdd?=
 =?us-ascii?Q?SxVxI0EOjXVxX7/WJ+xtzD72yv12qd3D3+0He2/ngIo9/Eo+d14Q5mngH4Ym?=
 =?us-ascii?Q?depWLjbiaIrH5xU1eLd8fCOEfMgy4OmBOGkW9J9D/CLrs8/d+8D3WWKMg6lT?=
 =?us-ascii?Q?bapnUW6GSX2uvhyL1vwrsxBzpOIKBSjQoAx2iAPhqQOH0qCWyHFR7H79tR30?=
 =?us-ascii?Q?fH0vcFzo8PYmk19KyiMObhoG3n0afKKGfjoWC6H76Q4Vh4AZ7+fDEh85Rtjr?=
 =?us-ascii?Q?d2UHlp6qeB6O5p9NJCPaNdZOLzi7aKc+U4DO8SeaZlWtQQhI4MjTanCWqha2?=
 =?us-ascii?Q?6I2xOBck5Axw26rK+QVPOAiKr8wc2ycOK+4AWboO9rlBnq8m5Yxva6QlRMfc?=
 =?us-ascii?Q?0WwhZ1Rf5JZE1KC29hKXsVZFLpUIqz42yrzaTzhSLHjXZ+qSyukNEf9gibE7?=
 =?us-ascii?Q?E1ROZlMd3tjXph9kvFSALWYtm6A4si2dDmGeOJKQ/jYfpEHSyku5U2yCHd+S?=
 =?us-ascii?Q?vE2gxTjEoYuAbjt3ZEer+ltPjNYMUg/pArNUBhXhAioabIpK3D34haM7bK6O?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3Xi72XcEnigCuachw723cCjwWEg4RMRHhjA5S+JwVu7dhfr0wpxxudIDKpxgMRNqbkJYHUy9/XBmy1xWT1wrpOq/hd/K6MTbVUSudxEuE052t4x7ymsu3JzY1U4i1Qzl6aALM7iMVjc62M3meFnxL6byw03IWxnkWb7equSqrOH7Hs6VMSOQZcH2SF24uomUwEUfnk9YsDuQbNJvc97E8z7Z4Ggh+SIo5e7VilydkvvD4iaD3eacOEecMpivF9G+e0Tjy3S948NM0caCV3E4Rjv1WU3dSYeSKzH4EEdqh9tnKdqCxPEXwB6ZczDovJGAQnwJEp+TeDzJsu9ThlRYjMfl00uoDDQgMIeIb5AQNsY984KD896eEmp+VviOKf0b/Y9v8H9/EUYvTgdmmsAnnqWevKGf8h+Vt6IL9KfHpeUDbZjpZcCuNcW/g0CbJd4idJL+ylDRPI6UwzRS+at/wlIPDP7P7+hFlyxAR720o9LweXOWPSte/5aH9rhBuFFSjU6dCj5f4zUX1zAWJ8k8mtz/LHpC+0zuw2HZmrHDm6Xw/2nsoNi1XYcZ6DBZF3xkk+atbJhxXZecRILxW/I2ugzBjjvrbALCpDipKhEvoDOdMkWxQyxU574tiO2pmvIcnvkebZeQc4oLvg3S75FRB8/QlAjiGtj6crYAOstxD/ppn6uy5G7ktOjtEFZxPLFUn9d48Sby9Biq59eLmIBiPNPD8Kk0FF9wHeOSKkPrJF66r3kjGTZkpfaRur3nmlO/NqBTzk7ofKDarE3h6L55YlfaZwfUfWCoJD/djsVp2/g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9883d0e9-5241-4e5d-476f-08db97b85eca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 02:37:12.4642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ER7tnwPnNGm+rOhJIXmNOQnyeG9voh8ygBMTX97uzRQi2oZ0OF2WuKcvM6vryx2pqhJ9eQVpaq9tQDQ02nTI6nUQ5P1kv4XwKnbzKZMa7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=880 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308080021
X-Proofpoint-GUID: gnn9CrkDnr8og3PrFIq1TaHL1QbVwk_M
X-Proofpoint-ORIG-GUID: gnn9CrkDnr8og3PrFIq1TaHL1QbVwk_M
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Ranjan!

>> This HW bug impacts only a few registers. However, for code
>> simplicity, we added retry logic(of 3 retries count) for all
>> registers exposed to the driver.

> Now the recommendation is:
> - Increase retry count from 3 to 30 for only impacted registers.
> - We also do not want to reduce the retries from 3 to 1 for
>   non-impacted registers to avoid any regression.
>
> Hence, this patch retries upto 30 times for impacted registers and 3
> times for non-impacted registers.

What is the adverse affect is of having a loop iterator of 30 if the
non-impacted registers always return a non-zero value after 1 to 3
attempts?

-- 
Martin K. Petersen	Oracle Linux Engineering
