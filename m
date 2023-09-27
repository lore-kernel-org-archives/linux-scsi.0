Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F73E82CCA
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 19:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjI0Tv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI0Tv2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 15:51:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D287ACC;
        Wed, 27 Sep 2023 12:51:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIwvpO002834;
        Wed, 27 Sep 2023 19:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=eCmJaKxazpd3yScBsI4oOUW2fokHtXHfYIc3r2S42IY=;
 b=27dSmEwuXMRn4Rv0JR2ObDD7zUOFNmylml0lKMNUDRYAXN6I7rR2hScjpesS8q3uEVoN
 hKILUWy+jzgQyYByVusZnZV0WBy+JSh8rr4/VstfYx+ioKm6kW7wykBmaN1lQ5GuIh5g
 vyCXOEVbZAlUZwSGSX0VIg6DLuDkHSa5QlMSPCmbfJlsZN8lIoc3yD/p96B72/QsDVOB
 23CTmQCVkMZwGWcm1NhNrJz6okxvLVBoSr0N0xnHdCzddHscPwOFxA+O9o5ENacxBHdX
 29mtS1laDW0C5hVC7s3XIG5C75M/v/PvDJP4wYnw63LFm/qrAQX6ZBRN2ooJU7FaJVNn Xw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pt3thu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:51:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RI0fX9030612;
        Wed, 27 Sep 2023 19:51:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf8dw93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:51:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kl6vr784neROLj27ceq82bzSKZKOdXJhJuNH6C86C7/rmPGbNpCMdWlECFleg47Vcya6QZ0UiyJQ7p2v5BXaV16tLoqcXa2bbiPicnLyBbVaXCT0D4gMF9pZbcOLJX3iUkj3ocvW/N4TqupPU4CFaG1OoTeI+mBXMVU6jFZmGG6N3LpnXtGt1yUVlYLZBiTE1Y5Sq0utqtGcuq28Nqmxbius29xz4HC+cFMnPtaoohwPNiuKBUt7N4Zfv4WCpkCz8vbbJxQ5QCJsLGwrCyXb5DAaUcNyEL3RsCW8UiR9bIii5Dw+PrsBvbuyXQuJzpquVX4+g6Q+/CEO5RimAIegtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCmJaKxazpd3yScBsI4oOUW2fokHtXHfYIc3r2S42IY=;
 b=SsMelMtAYIof8yQFBeXzhQJqZNXFDfTr4NlQU6mhU66hLpY/RBgwEwdMfhW5iyGd6NI9S07oWOsJf+ntrb6FtNZqDfPPEN0tZ7IvRyDlFAqh732qZpBNNHYXWM/Lv8h8e5G4IvG/h4uU7U4c/7qLeorButL7IOFn+g0T549af3fRzEohaMWLBRdusWdNbjKcWWWxjIcua2/kGZ8yPp9tee4fXHKqJtakNqzmufuHtMznTcIO7bp2vALQGbyG3OLxZ0406znPFojQsKQrzCpI1BmSrB/yOgGNwhtvAWPyCxSs7Saq8ZO4MPTi6dSZ5EY7J7/pqqcN2i+3YKU2SRJF6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCmJaKxazpd3yScBsI4oOUW2fokHtXHfYIc3r2S42IY=;
 b=TAo/XVgHv3npyQlwVNMNmw6vO3MaDA4znh7Xoj+Ss/CDQBbqthDyxQhQommiL0dop8YkVp7WTFPjK0wU/4BwgUb4I22XKFP9/uC9QHGiObYtiXprKfJXWmSPqb7g5I4BEfkvxRG+haojFdBcrk4be7h8bunfRM5ADcBBr1ljCEM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7309.namprd10.prod.outlook.com (2603:10b6:208:3fe::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.24; Wed, 27 Sep
 2023 19:51:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 19:51:07 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 06/23] scsi: Do not attempt to rescan suspended devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cyy3z97p.fsf@ca-mkp.ca.oracle.com>
References: <20230927141828.90288-1-dlemoal@kernel.org>
        <20230927141828.90288-7-dlemoal@kernel.org>
Date:   Wed, 27 Sep 2023 15:51:04 -0400
In-Reply-To: <20230927141828.90288-7-dlemoal@kernel.org> (Damien Le Moal's
        message of "Wed, 27 Sep 2023 23:18:11 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0146.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a91c9b-cb05-4b60-6b40-08dbbf9316fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQFErzQb6xSC4Qt/IVNAGbmCPFGqWxFFk5SzGj5FTVRAX/0rFDymi+/HOznm8T+lW4tBql4nkUE9KCYSCbFWHP3SiSqegwiMG6aZP96SOmu9OFM2tkNebH3BKCl2aPdKeokVUhfIl2rkHM4741+W5CpYPhztkTaH1gcBFMd23VRWwV6uYtAGOPjHg54+wBm+VTUsoUUlBJqH0BKqrTZ9ieEGaGnYD47qWdGD0qOe7bhlWD14+6BPs/Vc9PSFSfmbHHiv3YOyO0w3+oGHJA7QmLQjs3dwiE/OxoYn9HCUf/7E6zNdPW4CqY1fIuGJ08IVIUY5OLPz2ZRSGKTXR6KkqJ9BPi9zZ6pHg21O8TYr2QmnSpoD2QqUhx/xtYb9C6wuIfZs6lw2omYD5HEFE2yxJ5L9LuxF8JIxveKqAOpbGdJ10NrVLylSpHA9kVWFYtlrXRzZNsD5tacH1fH/uy87LXnWvHn3nlFMNecBaBCBE3mKiBKigzveTikAwybQB9g65C939Y6fTzsQQm9hxg/3Y1wmUaniWCpRQgSlizUDO9BzNoJpw8CguhhqhH+qdQ8q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(230922051799003)(451199024)(186009)(1800799009)(6486002)(6506007)(478600001)(36916002)(6666004)(38100700002)(41300700001)(4744005)(2906002)(83380400001)(6512007)(26005)(86362001)(66556008)(6916009)(5660300002)(316002)(66476007)(8936002)(66946007)(54906003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HNHFWAinQVY1hBCfTsyDBTunPpDTz5SW23ZwxyflZ8kjF+vDayJISBJi1w/v?=
 =?us-ascii?Q?DdBjt1cFFXGpPOzw+x+5opy/+p/YrwaSmMBTZhnGBIaCtkcXDdMgejYkdcxz?=
 =?us-ascii?Q?Z5SKsLLQGJOqzdYvJveinA/9xLUvG+xpXHE8rwKO0ypmyuzONJMa2881mNDk?=
 =?us-ascii?Q?Y1Vnuq2tUYAyNHN/kQI5+bl+ji7FhjJ56E9vs7Y75HXSM3CBgHhvIaEB/Gi3?=
 =?us-ascii?Q?oYT4DYUcNtF/0fLodgS3HniEPf/2Qa93dPVrBEQvWET9hrFyAeqlMCIakl8H?=
 =?us-ascii?Q?StuVe97kOW+andrpkcTpTcrcT7yWyrepZ+gz1w0R78mBDp7qByGmsDNYS8io?=
 =?us-ascii?Q?7N/fhBTzlgl5i1eSM23Fpw/lDnQcdndj8JwrykZz6puoN3RyxpjR0t/TdqsR?=
 =?us-ascii?Q?3ik2Wc5TfBA0B36LAlMpniyOhL2ZIdusGv/DEzGj0XEOKTs+g3FGylq7HajD?=
 =?us-ascii?Q?+rgXDW7p4r0OgkSYuUXaOiISinUieo78x8q0Sg5TS/0dfSaxYPwPigujAiGu?=
 =?us-ascii?Q?WdWp6NuNzzicZQ5k0RdMo6oHpUwSwDPGlx5TPqgsdFZNf6sL17iEpPbGFZSe?=
 =?us-ascii?Q?MJnz7GLgYp3vk5FgsJhiWhgK7/Rc7XLARlLfmVpbPiMJ0yDD+MBz0fqHVLhM?=
 =?us-ascii?Q?6cX+MG4zJ1BqUCYVshNaMFl4KqSFBtuNyaOi9SsZJROcjXHpmZ4p0Ep/ilWh?=
 =?us-ascii?Q?4ehuL9VETqAMHNMJtse8X2kBZ5uvd64S5OCcMHIrf0XWP/3VayJeIRMa/5qT?=
 =?us-ascii?Q?/X0vnllhe4kDMap1IvGRJ6ZSsmxbdQnEdiaY66OasYZUcK3m7BQkJYlLYXz+?=
 =?us-ascii?Q?BFG4x4PCKK+H587txnVV9RaKv8RSwEL8mWpGRY/wJR9iG+kj/2lWQzXeIvbU?=
 =?us-ascii?Q?Jl3y2BM9scoRJl65n/NYwBwKvIdGhPAkcChb3/yJcglYG9PORzBl/gnCIbFp?=
 =?us-ascii?Q?3cDyjQm/PYNsWa8xekZFibwXKoH+2pjU8kts8jKTYq5+Y0vwmhlDG+ma7gi6?=
 =?us-ascii?Q?Min7maXLqLvz3QfZt3MTIVV+k5Vv9oKhFfLRUjMfZ53M8jDh+sbWYWCjC3j8?=
 =?us-ascii?Q?i4zbCs4M/zuGDD2+CKTaOAgUkwapRAkqj6FpEsnvlT3XVbcCrpP6PAaMuP3R?=
 =?us-ascii?Q?+MrEOmoaoIRXKBmAkTNRQbSikTaEW/kuDYVpeL8Bunv9fjPwUHYaXILMsll5?=
 =?us-ascii?Q?MNmhmpGp4wptwB7G0JJZVaaRH0xMUP3jVxq6JgtQZutgYb345Ukw/IsxSktU?=
 =?us-ascii?Q?xtFBPDKnVhTJCKNaEK751ElbLy1osnr192stAX7azpP8U+5RsbVTmLQXcmnF?=
 =?us-ascii?Q?7cfDGChdjcIzAhbS3ZonaB7H8iJExZUYbzuWvX2704Op+mUAfg2xLrw5ZDXl?=
 =?us-ascii?Q?hJ2fdPZD3YtuabaFRUKnWo6fVr/6eo6y069z4KOcvZmeIof9iiT+hwf52iSa?=
 =?us-ascii?Q?/7eP60DUI6pHbjK0pDLiyJErxUHk/pLfvjs0CdoiLmFHVyCJ3AcfBdzrTgPr?=
 =?us-ascii?Q?yINoI9ijC4RdTO6lgHA3vXWZisBn3933jTGRWSksQXFQnnD6fR6LmT2I353w?=
 =?us-ascii?Q?/tQFokYGkUXUzvbrjuipbeidXl111yyC8RMoGYOT+RSPrHTN7XHCEglmZN8B?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?CzvUNUjz9luaBpC/4DGLN0jf1z2KcNKVFlbLrVZDbcxRwP3mBofQVzMa5noH?=
 =?us-ascii?Q?nwRMWI7Zl6zkFFw4yaypabGqiVfgFtXiIZIgYCuOz+XZTMeGbC5fZfZzj1l5?=
 =?us-ascii?Q?teD5uZP9zj3vNl3+e9LXZgB0av+RBkqT3/j3aLXZh0cjbAuhezxcZ1pFk2+K?=
 =?us-ascii?Q?fVhTL6nqtBYGH+J28yUccFXflMCY4vYdzc0BrZ3d4+zXbBQ4v5jyAk+a7OtM?=
 =?us-ascii?Q?toHfL6+21Ofr9xbu4+iStz7d+yxZCP9gq+Xz6g4C+0L6HeSeviGsQSraUbnD?=
 =?us-ascii?Q?KL0fL5yBNI9Nhx0H7Gy43H0L4sjySSSVtCobIl4097YNbmHZFumtOMMR/oeR?=
 =?us-ascii?Q?DgVGbA+fBG2LRmrZ8SPrTj9Xy3yQ2ofxJU1hgSMXp5QxHVvZEnvpmBeCU8aX?=
 =?us-ascii?Q?spiXfBoRHlZU/wDlTYZoh1tOIGTnVytYjRQhemGVbnGjpFlW0FosoE/4MJHq?=
 =?us-ascii?Q?lSxuNRBJ1nb9PAEhTGe6y4yaeveabZjnU7wnJL0R5c++xJmYvsWJPAa3Wgc0?=
 =?us-ascii?Q?dAOVkPfvvgEe+Pw7QfNRStIKS0oDs2I5gYAlJ5jaYQz2pMSoK9PI8ono76gG?=
 =?us-ascii?Q?+5MP7W4V5UdE0Xnbvd9Vf1zhVczmJANtfJS9u1j6kNBNh/vXEJhIbu5jSHUf?=
 =?us-ascii?Q?S9nAgzDUP8dMF0OGertHKAjIIYd70uC7TdwkcM1plAhxGSivMLb040/y+5lO?=
 =?us-ascii?Q?Iu/ERN44gqh/SRPC3Y9DyXJYZIOkT8RKtAPlLk3tIvYnKVpWnXNqT8Ogz84B?=
 =?us-ascii?Q?TqbFDHs1RiPOIRpp66m8NM/FKK6a5pLXNa4zelyZ7u9BykZFKKWod1tPf6QG?=
 =?us-ascii?Q?D+xkWgKYQmUkMMRkCtMQTxiiiGQ0kNZ1ezWFysfXb2JLlxNRNMwjH4Q5w5c1?=
 =?us-ascii?Q?SmgDG6K0GJWjqMafT7isqhXbfcMFMidy6/gbs+6EM3kiTA/PppqFqOfmzDGz?=
 =?us-ascii?Q?+mNKVv+uP56u/JTM5ETIMA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a91c9b-cb05-4b60-6b40-08dbbf9316fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 19:51:07.0788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: isVu/66x5z2IbEWWqvK/39riW0FGamD61sb447qKrY0jlC4Dz3Pd9wcMmUdBK4Xr8VI631l55ckH5/fKaa1n18pQQan+4zGo45NHH8o7XMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7309
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=959 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270168
X-Proofpoint-ORIG-GUID: _sQs8mGxlSj2rp-vDJlMCi0bqm0_HLMs
X-Proofpoint-GUID: _sQs8mGxlSj2rp-vDJlMCi0bqm0_HLMs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> scsi_rescan_device() takes a scsi device lock before executing a
> device handler and device driver rescan methods. Waiting for the
> completion of any command issued to the device by these methods will
> thus be done with the device lock held. As a result, there is a risk
> of deadlocking within the power management code if
> scsi_rescan_device() is called to handle a device resume with the
> associated scsi device not yet resumed.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
