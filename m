Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAFDC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 15:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjEaPqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 11:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjEaPqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 11:46:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5759A12C
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 08:46:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERV51016257;
        Wed, 31 May 2023 15:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=K8pv9EG1hZN/TuwT6AEy9PV7kZF9ChDu41dM5hLVHIk=;
 b=pyg6hKhC4LsD4/2N15yWFmencQi/eANkWnf1nTWeunIPdljx2htHDK9AAK82rYHviLgb
 SY0Jg053neqZw8NePrhu3d4oszCZz8+UfLmXOSv3Qq/5GNqnvh/VjM1x+wqhX6AwG8BD
 8CQTOiiQBZRomOD4nZovFxonzhaATbejlmPL0etnKCttDm8C7N3CbLBwe64G6tF0BE1L
 Ldt20GgtDL3lnHK8EbA0GNOtnbWU/4neCVHKezm+B0PZ//YqFfFR6+rPIvBfimXKll7s
 FVP3S6sdIE4gVqLs0JsflZSlNhEaeeShl2VsPdj4EkWDoONqoB6XgdJKB4APfOk/qUr9 EQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmep74h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:46:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VFbIB7014609;
        Wed, 31 May 2023 15:46:07 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a5s7ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:46:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqxIvRLnS7d+Jp8f7fPwNXBowSuSObvqAVA+xKjQC53z24eQ7vbUxy7rtEAa+/ocjaqj0KDPwp5dhM6u9SDQRTReeYBBODPtD0GvsY4W7h+bw8eJ3Ti/29mRd7kQna38C9TDQhQMrvOnAVjlm5Had5ysJahLN0qD5ADzcZ0LiyIq15bZVeTx5Am+c1I1mCHnqsO5VnOhWFbeY2fVcoEb5C2u+KZAeu969lqJINVCyf3D0RBZLtked5Lpv/facTlNFo3FH1wHiscqrXp0g0OUj9gzYszfoxbOgZ9qxjGHkLfFDqYPfn4b8UE3u+RFdF7FTor//A9oeYL4gKOVIn11Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8pv9EG1hZN/TuwT6AEy9PV7kZF9ChDu41dM5hLVHIk=;
 b=LKJBd6WeCv99eWwjP86iuqByh4bSn4ONGiy/LNdQ4Kt7achPE8WgXWbF3k0Uv6aSJeauIs7t62hx8PUESzkgXYBHhF/ULSTUP1lvqdGzWs3Qaew5wF2ByG7O9xZG7/B+QIr3WNbETY0X7yxiv4iDLnOWnpzXzi6YzenG6czAjfAJrC6w1fhTKeo102KLV0s9yzCUv3QWlNiEUTlpXJe+mrwsDuvb7EXbiptuOkRldZMB2SRLHhEXj/QtzN52TqLPirsnmyFl6XlA8mIPfsXlPfK3bhkWOgjAjj1X/Ud/ajOfwxG2gV2TGjdRQKlCsbtpoOgj5UTAcDxYOTMR/KFm2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8pv9EG1hZN/TuwT6AEy9PV7kZF9ChDu41dM5hLVHIk=;
 b=ZdKiljTP2yfHb1v5GuQ6UXR+HEX+bnqZKew4A1RlI47CidrvdoZ3NoI78dnvDARC+WpsPvwmHXDyAKIEu6eW/Ofb2WoeCEPYxDXJU2PFkIad1H6S/qvhtaTTtNYUXc4W9xUaVEY3u6RXds76233iXuTecb0sPj/bzmetUF9RM/Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7090.namprd10.prod.outlook.com (2603:10b6:8:141::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 15:46:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 15:46:04 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 0/5] ufs: Do not requeue while ungating the clock
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5xkfqs2.fsf@ca-mkp.ca.oracle.com>
References: <20230529202640.11883-1-bvanassche@acm.org>
Date:   Wed, 31 May 2023 11:45:58 -0400
In-Reply-To: <20230529202640.11883-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 29 May 2023 13:26:35 -0700")
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7090:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a9b0146-77e7-4463-fedb-08db61ee2492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3FpmebUpVQfPmcexg//x6NWJnIZfw/5BIYZ+zP9X2UJQBek/2MSFuQnYwNw3mt90oPQxzaIcddLkpksEIIj6K2xAsE/8oknS5f+LmZ2AesIB47r/5QGkiARxLQLXh37fUSl/1CWI81udb/FHrys2fRui49sg/+32pZ8rF3POV9eD9e36qQI0eU1a7/0jNZs+qyC0R3tto077YACE66A+MOtPjdes1XDcP+nEVLVF8H3P9rpC2pUMhSqEZ/GCG/D8PkZU4IKXJEOvnevFt2jZtz0miFjEvYkeKc62+4KjZFRUvj4TtknWAz6OMvhdT9hW1jv+cbymYoQ9KI5j+ZVm2L8dtUzRVryoj7p/GsJs2S1bmXGTCTbMU1wkvAQCQqpVvvwrdrn/RD+FQ0N00Qni0TPS1gWElBmA5PmiCmpk7WVReBn7VTyYg28Xm+R8dHSleMe4yU2IFDb01VRpYfLyF++PYcdVSAg0Fml7Kuqr8885e3nd2ULFmyDgwzWpPt6i728mRHklSBahxwBAv9abNorbDlxfzlyrlTu9EarjKVTu8x3DAT2eRMS5345722W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199021)(2906002)(5660300002)(4744005)(8936002)(316002)(6916009)(8676002)(4326008)(66476007)(478600001)(54906003)(66946007)(66556008)(6486002)(36916002)(6666004)(41300700001)(186003)(26005)(6512007)(6506007)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BNDE/IUIXRRGSFAUqisF006Km1oc1gWPE6O/9tzmoBlphFajc6zch02j82Wx?=
 =?us-ascii?Q?YutVTSWyXhes/kVIgPozeGGEUS46BdcDnjj7P5DO7LDIp9FubCAwPW1YZDYZ?=
 =?us-ascii?Q?HCGizawNSiLVgl6xc4ynzz2riRtjKXtjEMD4br/Tbs0Xd/C5tUJGNxvlu0W0?=
 =?us-ascii?Q?qUt8FxvIsZLbVqIhui7P3eKe9P1RsmnRW1mtKuLckoDmBXBMQ9OwlloL4Ae1?=
 =?us-ascii?Q?64W9k1v4ADgkOTmORW/umLjbgy2AszJoVhulNsgfar4lGctFcWAa/vaNlE0C?=
 =?us-ascii?Q?Ec88I3EDsZIOZu2RnI8SJu0MWO0BA09hZmPXKwYz4M4iuxUziqxo66WCEHhI?=
 =?us-ascii?Q?6jf/9SH62CvtBRcIkZGQK4Rdz4O1snnXjou33GqQaYj6tEcX7RtgwQzQU3P0?=
 =?us-ascii?Q?7GlFHgXnSvj4TtVq60ZU/E3drBhX9UcWrOqsnFgc0xYablMCxiHjuzbY9TdL?=
 =?us-ascii?Q?/kHPhl3zjXAORdKhFjEj6ua8jsO1TUk9BZR5Kswny+4ccWY0HVw6d/3z5i1C?=
 =?us-ascii?Q?U2nVXSfIMsO10sl4a//IVmZNRJ9hgTda95IiJA667fMpAM0NlLeNLUHM3pSF?=
 =?us-ascii?Q?EiG80hGwDzqS2nEItUyXP9/u1AFegeTM+ursBQL9nK/vMEF0T6b1tuVCj072?=
 =?us-ascii?Q?QvpjjIeX589AL/BzxJARg+guF+ubye693yWNxyRdDSUa29blqDe1TW+S7qA9?=
 =?us-ascii?Q?UOJ+bWMvhXBwQGpjyBUJZMli670UFAA3qTzVv2MWgGKVMLDgQUHLOmbcA8gH?=
 =?us-ascii?Q?FXXLL8i+DzJZ5MVnwL8r31umrrT9v60p/y7w6qEW0/X4fCmW1iWA8BM8Q1+L?=
 =?us-ascii?Q?N9nS1s+symZO28dD/S94O9KMzAbkv/SQ8+nqWaMEAyoYszWmlCF/L/guv74J?=
 =?us-ascii?Q?6Do64Ldi8YDU3apTJZHIrM79z02f7uRZ9ttfavBuxexYORSkFzVgMr4Vn/BQ?=
 =?us-ascii?Q?Xb5P9yBx8C35ij/0o+KA0w9TnHXfstjm5ET99uxEKTIVj7p/QNVDD1fj+sXM?=
 =?us-ascii?Q?W/0VLIYwN0pAQL42PR6cI2hThxQUsBnJrk7fS0DrRSTEJAJ2oeNzWmMhs9GR?=
 =?us-ascii?Q?Oq+P+19cbothKAMHcztE7M1CwBcDNCXidBcpRT82sxoHmlzR+wJKBt6hm07N?=
 =?us-ascii?Q?mPzGbH9Rl3fVY7YkmjMiIzg2E7Tnab48JnOkm19pHV2UPaHtAGFJgjWvjF/m?=
 =?us-ascii?Q?TP30t1LaWI+J7Vlfvj5pNwitDhlk0tBFaadc2CnjXciblV1O3gBsTM8IXjYR?=
 =?us-ascii?Q?U+lS0muPD7+u0/PbzeInn+/R5qYbObcrMh2kr0wmXEa29j3SsiOCTa2Zi0r5?=
 =?us-ascii?Q?f4Zfv404mDyahn7KfTaHMUPddyhsnuQaT89lWxRomWQZ+6y4zetH62hXc9j1?=
 =?us-ascii?Q?mUh7/OhWMGBs4HokQ6q4d43OHDuFZLDcDkBQKOdPsEEZHgZ0ZNMsKBGqOcbY?=
 =?us-ascii?Q?whjr0MHsBcxlybtz3q9ZA2j/GQibBWfjz2W0gIm2mBxwsLI45NPc/l+6dc0F?=
 =?us-ascii?Q?AEIJlZzIsLVW2CfaoaG7WT0KevabZBg/aUkhXw/pnBpvbGJpkppX3OqV0PxV?=
 =?us-ascii?Q?HuKLhMOh0/8L9a3MHkKTfTxQEINjry+AnvL3eT8cXQBcW0hD+mhZ7bTxP5S7?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4IVOkQEwbLeLMbKIj12dT02CehnPuUhd5yLHBleeEndxWZEcqHDKVFiTsZyv/SrcFRERROK9NvTKY5epeNCq4PsxvQevERF+ULkPtQ49leA6X92EuPmXZqkCQXZJN9bia4EuCNVPmrJASOFGKPqcGjp/+NYWDqCMYIE51ejFQPJ2PQO4gUtKacvat6t+Y4bYBfQos2GbuioO15+B4xrEqOITiOTNGQl33mjuoJpcjG4xB3oZNFzSJCFYqM0NEsAB+J28HtCPX/D8x6UBuL8YFYxAUcRiQu+4rANn8dyJtqL9Yl0BtoKRssjdx/h6Q6PVvZQVOSNfSenyt9DyeHRMjnaNsl24sDsQIGfgfNkInWiEI9eprK1ow4TCFD1Z7gKnUYyhNaZJHfk5rWHVumggJSh6gyVkMATOth10UxPsSv7hrTHb2l4GbNy6WdMdlQH03zqU8Mt8DSVx5L/LGKHGsW7eVmrXaxVwNXxeNORs51zp/LaL0enESxStBVtwKzuTvXeKM40Yi2Mb+pKJ3EoCHbKhMc0jNABoqG+QwbyjYWyS2bHVom3yDi4w2UuzGH+ONAEVxDWRWeoroEC/7PljvE5MeN+pbsRI0+Sbh0JVsnkXxLCsRgA/A+pt2m9oBrXusAUqaIQ38scpITBzi92nOMSsEWRCbncLGRjezYdQHhj5fOBKqq8IPvwyzXiDtbzOF+n4V1ilH/RVdtxRcmiSa9ns11DKivS+6ZUivFOLwqOvzK+ApLvbnky3zIKzKxmLjMDcY6HQxgZgxhArrDzOuuWxJG2SNI4KILHNbztgMQF4o6VQR1F1KnI1Xs4E45oT+ihqUxrjVDWX2JSesZUkUw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9b0146-77e7-4463-fedb-08db61ee2492
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:46:04.8229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eAKUtwZ8mVKLp+d7wu4IGKldRYuVIJo6DwG8SY+joG/eMbhklFqQ9yAvE1+GoMwn9za6aQtiLEPJyY8rk+lLKfmJYy/tMcqxl+tIEh0W25g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7090
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310134
X-Proofpoint-ORIG-GUID: H-pAgybfYDh9HdDx5Y-B7-5aCw-iFdXX
X-Proofpoint-GUID: H-pAgybfYDh9HdDx5Y-B7-5aCw-iFdXX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> In the traces we recorded while testing zoned storage we noticed that
> UFS commands are requeued while the clock is being ungated. Command
> requeueing makes it harder than necessary to preserve the command
> order. Hence this patch series that modifies the SCSI core and also
> the UFS driver such that clock ungating does not trigger command
> requeueing.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
