Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9890C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 22:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355853AbiDZWhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 18:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbiDZWg7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 18:36:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6BBDE09F
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 15:33:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QLjj0R015530;
        Tue, 26 Apr 2022 22:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/jWBDLMh2QivupLY+V8YrbNscNNFMndakAFSkIZQZLY=;
 b=C1lON1DV+Eovy3imEg6nVikZmoQOWS20DdBIUobyvnOWThhSc8hzVS7i3NLP2pGx2z+L
 P5l1vUTENVwuo+us4cuwqAN1HTEgM8VQTyjBCSkObdNFcY4WChjmWQ65hG/DP+6aW/24
 zVaudEZQWzw/iJhJ0X2nwXk7l5A9+XG3pc1iKhpJl7NwQPPcIytZZO+PRiF1H8BeZGyf
 1oGf10DuKQZ9cjZh3lFiFq9p6a4h3vui81r0ReN2U4H7eIkOZL0d7Qnp/Prkc4uD8U8m
 cZ8qigRyrm/pE0lt/Krn6BhbrkUeXh832sm+DV7g6Uto+PeXRoa8wY0c4y5Klp9IAOOV 6g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aqeyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 22:33:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QMU5nQ024796;
        Tue, 26 Apr 2022 22:33:43 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3vvmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 22:33:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gg2fu30fc+qPMMOLT5EzJq2GB6rrDgrzjYILPpEpClsORssWwm/VFNEM6lOGZDHJGwP2rBf6VMzjp3JaAQiwhQP3bGlipz0lO/icF2Mzp4FKRc+FN0zrvTQOA3EvavEunNtP/0dYupQhCVqvnqYNLY5McelLAAV5fpCeN/1AMANd2yJje9avYEuiFYGH4uFNY40YdfKBysxv2EzcKxm83qMTkMf/1/6VQsuZfcgO/VqelfduHu1FB7+9phUT+B5ixaF53hUOS8jMa5X3+wYvzpvzzdcjlWRu3x9Q8+yWouGDgeEZN4YW7Zm+xOGDOklklSbeuvS+IC0o35UUsBDkbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jWBDLMh2QivupLY+V8YrbNscNNFMndakAFSkIZQZLY=;
 b=lGDvNSt0DRLa+7OHDPIYZFnn9evoTA6bL2nb79CaUjX4pGdeGCpGa+W16jeYFxs4lQolrOtwpTe0RBtqjfCWHo24jGbsTGyjbrCxxv/+V2FbWt5TxrfvjfE7XqcDEEvFuDxJJDnTBrFk/GBi85pMVxXoxbEH7GUHKVK2z1nWXDugr8ebWNcHV+FJ41PLuNhSezN1Pkt2VPiZ1hXFwRCK7BKfEMNu/PP3kus8n0RWa5hZ/0ZBB+4X0gjpzU03elSt/Zh0zlZ4pfi8MlPJzlr8BalLSyjwBYxDNKWZOse4UnRogZeHn0DlBeSgIX3CMH8MirhhMNvJW9t6x+SpBUagNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jWBDLMh2QivupLY+V8YrbNscNNFMndakAFSkIZQZLY=;
 b=O3bN9eGODPdmXIjtsRCHB+2FZl3c+Z/yiHauLbu4tP4P8PbSnHdhgM4hJkiBufJatrdX3rTWLzFkNrV5bEZRwnjIhDFtNT9zC4DKqpTaPu8CWg4yIC33HyDHXJkURFlwlkh6WxFGLuJG7YNrSPC1a3TxuR2R7ycrpU+GIek87AY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB3047.namprd10.prod.outlook.com (2603:10b6:a03:83::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Tue, 26 Apr
 2022 22:33:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 22:33:41 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] lpfc: Remove unnecessary null ndlp check in
 lpfc_sli_prep_wqe()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fslzpj9h.fsf@ca-mkp.ca.oracle.com>
References: <20220426181315.8990-1-jsmart2021@gmail.com>
Date:   Tue, 26 Apr 2022 18:33:39 -0400
In-Reply-To: <20220426181315.8990-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 26 Apr 2022 11:13:15 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55e6f877-828e-4ce2-c5cd-08da27d4d063
X-MS-TrafficTypeDiagnostic: BYAPR10MB3047:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB304736AB65A77AD909D13A558EFB9@BYAPR10MB3047.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gKCYo5WWcsNjtYHKE8Q9AqxX7kHscWDQVc/S0NLZh/zvLDpl19BRuJIES5UXLH736RVoAttY/EJbIyefojCenLwDip96T647LhGHx/Sn1UQZs/eQA9nrswE/2RBqqW/D6cG9ru2wQHwaErpFaxQHir3jng3rhvzj3OYjdhIMnop3L0wpni365gk3P7F+8+ZD2o6KcOVwfoP/LL27JZZdAvxSznF7lBhp2vyRGP2xVFg0bfqh0RPumTkLjrHr3Ns5+TBBR7e4Z5FbAD2QEPCAZTFJjxsNo14EFgKBLtcamCMGriODj9MzgfWZFGQR0nNltqkv88SOwPk22eY+w/ytIkPqUkKKNwOBV4v2e3m0SzMsiZit8mBSS8QJhfR8uIsHrbfxF489aLTkKaLxOY1WiDtshVF0enevNsInN36QWPu7cfahA4NyihpsU88FwDn01TLcAmvolN8Y9hIN2t0UTZ+lfGR2N8mDcPeU12sI1IBRayD9nRqdQignmdvABEMIwITg+LdHUj4yjE5xaW73AC+IpLHSVb0EQCzX5cIlbkvfWoKuszEFKFSau5ERPmEgfRcFqykId8k9EH7RMbzjO4okzU+05eU+Dngyn/bGoYK8PsD/Us7QjUw0iAV0NVqcYDp4emjduGARwc0hdDiKGSNrThUr24d4z3b44h/I/3rwfAAtCQ4HqBQnlvz20PEUOqQChX4xc+umXw7eJHeRiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66476007)(26005)(66556008)(186003)(6506007)(4326008)(6486002)(6916009)(558084003)(316002)(54906003)(8936002)(5660300002)(6512007)(66946007)(508600001)(107886003)(83380400001)(52116002)(38100700002)(38350700002)(86362001)(36916002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BEJX3REzLc0eANKkLa8UbTSvKiME12N5G5DAr7y37tB/bsxgxkPeacfhgYD/?=
 =?us-ascii?Q?9W+AcoBtTDAzP56LpPHf0xen1ZHtbwKCbU3+gMG9Zlltgi1PjtE41uPldlP/?=
 =?us-ascii?Q?LlOuXg9oQpmiIhqEamQCD1i4jmYezSWio4o/4oIAxCEv2aGpFPQdpI2d/ByP?=
 =?us-ascii?Q?Yc6N59LbfIpfdYxYjrerUGmm3jQjyTHVVadOWNX6u9Tcyhozj7NTAavFpTcP?=
 =?us-ascii?Q?4UXINKeKcUi1JeWkIs3d7/sHFllxWUmhKJxuXeKN/lB0kOW78tostmoPqirG?=
 =?us-ascii?Q?Wi56iSpGFKF8KoV0zqTSEilsrujFjv/Oj3YhjYbxefCLbC4g0JfsSkG5KuOz?=
 =?us-ascii?Q?vUFIcNEhWPVBUOjUCkUaW7lEtNRiaTeyQD06XdxlmBDMlXIP8XQdp2kt35O3?=
 =?us-ascii?Q?k1UYMmp7sRO7poY5I0CaMpDauCnwnsd5TWsG6JoycMB5d9ECYhTUCxXhT2Cj?=
 =?us-ascii?Q?0RV2eFvvwLThoF3r283pON+GsMVcftGx2nJBsARQWX9LGkwig7ZbnPObVZ/n?=
 =?us-ascii?Q?kCQShLVrla7z63IdDkJmVa2iG++O6Yn8nOYoje6X1q2l2c+B6ZMPcUiHTENV?=
 =?us-ascii?Q?+NuQnjlhLx4PL3x2yuGma5GyiwZl34crFvGGEYr3WKsS1vdK9wGYEzLukJiO?=
 =?us-ascii?Q?hgBQAsHG7WJTVrskmFKvRcDg1HMR7HJ9LDPDwLycth/8H009sNb22ZHPXKS7?=
 =?us-ascii?Q?FWXKeSnl6+V0oUdxzE96eXKFz1JzCT9zH96qa4+yS98P5fBoY4r9pUERpgji?=
 =?us-ascii?Q?mcm9mpBa1WzlUfd/piYX5JN/J+ErWq3RfdPU//g//ccwkG5VvoewnzHIW7qc?=
 =?us-ascii?Q?QCJ8oguYjstSDBPhjP8dGoA/YaPoPhbz3vQsGRVghNLFLPt+mXe8KI1Xcik4?=
 =?us-ascii?Q?qwUhajCY2PFuP70jOIXZJ3WElCwutfYSCpmRDHKM3FZ03eT6jlBnprS7Vt7V?=
 =?us-ascii?Q?BtLMjUlyQoZ3vYZE/ifKwxt3cRFI2Qcs53/kopWYNJgOM51z4h1PXUJyMVC7?=
 =?us-ascii?Q?/EdBZ2fIS3x4z1KSeBUZW3M4MP1e4lCSdzst819PWPS9zgnWhbnsFaK6Q6a6?=
 =?us-ascii?Q?vCdwXdWjPijASFwSILuLKpdL5kf34aAfofCkDzMV+bN2U5stklWLGazZ+l5g?=
 =?us-ascii?Q?OqZwmEdhqydfOaqHjO3tmyCVhAT712WABAbYp4qKCl6vNpg1IcK975gjyKFO?=
 =?us-ascii?Q?ASoDaiFNqccRySDfdQGcgEmTi6BsfeQZz+Py7QkOex4uewD529FcivA0xrsk?=
 =?us-ascii?Q?A5pSc+SWb72jmCnXvJQk1yGmjjjawywXNxEE9iK6Lvoye7XV/RpyMx9XrbvK?=
 =?us-ascii?Q?BgGHA3efLN06HU7w4UexJ+sNJXTR4u83DDqND9qk9up1ORbxvVhpYqq9+UWJ?=
 =?us-ascii?Q?q9FeKYs7NNoBo9BOBpVP2636Hl0pD2ikQEuNZc9793tBUwQG52FfZweas9u4?=
 =?us-ascii?Q?1I8NGIIAQNJEaGUGl36UL0PyWOlXOa0Uk+fuk8tla9AJeaKbBBi1FfC4Wl/M?=
 =?us-ascii?Q?FQ+3GKA3nFEWOt/Zcp9L9hz0t8Pn2fQv/D0wL06Er81uInwQ5fA9qOAwnMPx?=
 =?us-ascii?Q?OSExV72mlv3l1NkNLc0+HsJ9xIkD9Jvihtlnoi85I/hbJcjEIHoplvHbWbOX?=
 =?us-ascii?Q?CTiI7v2Mogg6ZRBSFaFPdF457sIgp13sVq8Teyu61R9ava7Mrf4tvait8KHH?=
 =?us-ascii?Q?YXwe2VUCnCYW08FmILsINz/hZgDw/UBqujVuh0lNiNyGk6992mUilr6sb8Ih?=
 =?us-ascii?Q?P5YnTynWJtGjdwnzAKJR/clM1OqzkZw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e6f877-828e-4ce2-c5cd-08da27d4d063
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 22:33:41.3002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKH/KNGpB4UrkHOQT3RKJ/cp0Kj+WGFOSvrUc3hOwqgwFfr0YbnuQEJAGTQ/vn0v7wD0V2QuqjzuqaB87/MIObaxAecJqskdzd1bZpqtt+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3047
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=744
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260140
X-Proofpoint-ORIG-GUID: VTOL-HfwkeTfvOHm5FVDWlOoWUwOwN2P
X-Proofpoint-GUID: VTOL-HfwkeTfvOHm5FVDWlOoWUwOwN2P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Smatch had the following warning:
> drivers/scsi/lpfc/lpfc_sli.c:22305 lpfc_sli_prep_wqe() error: we
> previously assumed 'ndlp' could be null (see line 22298)
>
> Remove the unnecessary null check

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
