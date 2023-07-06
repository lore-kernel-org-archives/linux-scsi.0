Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BE8EB64DA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 01:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjGFBi1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 21:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjGFBi0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 21:38:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18971996
        for <linux-scsi@vger.kernel.org>; Wed,  5 Jul 2023 18:38:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 365LaTNv016764;
        Thu, 6 Jul 2023 01:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=cMjqhwXM35WpT94UI7XVo0hi9I/aULYh2FDqnbeVqCw=;
 b=eD6jEvc6ealp4NGxHLXIfOz3dDQGd4ELxNjCUIcnarT0iY4yUpfmTPQiy+Zi4DJbTM80
 1DF0uI9sOd2g5QI/SiIf/4K9MYJ1wB8+VS8B4fqtLVhx45IdpRsTGMIfc+v2fdYyHnRO
 oRcyMV1c3tw5/qPSPEqAfQOKey/iLnKbSB7CQZGWGeMxkw4U7oxjARTX0SmiwPP3iMYy
 VdD49X69szYs/oGvgTAzJYzdnG2PTNV/PWFsLjeCwVzHaUS8d9dnoinICJDJroi8wuaJ
 q8vegU6B7ip6+KhCGs1C+d+kgTO9aUUo3NJUf3dEUFTdl1olHg5grSyz7ddj0aatQW5H Iw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rnfkuga63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 01:38:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 365NlZdd025202;
        Thu, 6 Jul 2023 01:38:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rjak6ts0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 01:38:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Svf6HuQuglIeFAzLwJZ8jdmEdnv8kndA20i1P/I08jRtmTNzyOdWMn6iW3w12bIF4J5nRKOhVlXBgBW42bIp5MovKoMtHcZXjs90MMZkUjhz14HLbwGO/WJF0q+Md5ey5NNBLONwJeKuAbWnFeOnHPwSQDTi0Nh+Ti2BiIpwEm+MwAMfq7s6lpuh7AcXiWSjhcrfheaaV5iUsrf59iL7hx6Mq4lLXSoL1okTtxhfNZAyR7dsbnZ+7OzfDSEiZjjJrRClw3CkelTT9GLtzSQHXtI/VbPqh0EKrOk4ZlHtzCOit//q8sObun6xN3PlUpmA542O2/IVOo1QtDHeT/qIOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMjqhwXM35WpT94UI7XVo0hi9I/aULYh2FDqnbeVqCw=;
 b=IZp7xcOniNIa1AZm5pRReIHb7aCtyyJR+/Ejy3z31n8DOEgWo/i1+cyabPEwkCvySgySgkSxohONkTyUqSThGM6yk37vwh59YiNYq+ZOm+em9Z1Jx1214xCCV6B2+cgMYRdNtH0KVJHos01WKb9QXg5YYOV7PSR+A+DYAOzBIsGw85TKN9U46EMsoHhv1EHXTj3aD768VtAiBGCKdNG+XQ/Oqzizh9smjtQoz50xbtIeur11R4G8EDsl+unu+7OOtcZxfaYEuh8PeETzSlq9GX/vqG+z0032q9C8Vyvm72bvcnQ/HjF4K0pXtLVhveDsE9cOhKi44/TDvam5vZBhdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMjqhwXM35WpT94UI7XVo0hi9I/aULYh2FDqnbeVqCw=;
 b=El8kuEEowkbwIwF8HwxvJ16zQrNCQqHYXPL2UiFyhd8CGt8eU+PfHVH8O7PPakDG15m54+euU2laIBL3cGPjsWb42vFhwcQz5uAP7CEZdexef+/Gi82ehPEx8BJ1AKJg1aCh2Igw54LKiefF47prfke8k3hNoYES30GbjN2ijuM=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CH0PR10MB4889.namprd10.prod.outlook.com (2603:10b6:610:d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Thu, 6 Jul
 2023 01:38:11 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb%7]) with mapi id 15.20.6544.024; Thu, 6 Jul 2023
 01:38:11 +0000
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: remove dead code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1jzvdlszu.fsf@ca-mkp.ca.oracle.com>
References: <20230628150638.53218-1-mlombard@redhat.com>
Date:   Wed, 05 Jul 2023 21:38:08 -0400
In-Reply-To: <20230628150638.53218-1-mlombard@redhat.com> (Maurizio Lombardi's
        message of "Wed, 28 Jun 2023 17:06:38 +0200")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::17) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|CH0PR10MB4889:EE_
X-MS-Office365-Filtering-Correlation-Id: e75a7f8b-98af-42cd-0324-08db7dc1a89e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jR5m0Ol0rs7oHT6yXHy6I1n3lcJGYB/eBlYVnMTAhJqfyxdu3vjoaZxyW3cgDBqfi1tXpgDgLfFFlkJkTzTMhCQ5+4d/3gCwDiRQhyjC8zbv4Es2LckcmXSW0nbun8Sazl4bCHpaop64doGfN2gnBdhUDMlnP0CxlbpuClaBPd/0W3mpdsocdRXnhWjRW38jfnLNwPRrtBTJHkXXNY2F9Z+nq8vaJvym5UJjlnJNrG7AKoZVucwN/1gDxqWj+GM9bWxn/m0vg7tr53hfGaDqvhSPJaXejgIpIzaT4SLAPEzWGJ6+kHMWlkBcISKX0H6E6d5axeKBStiqJjeXB6CSROt1nlT3WGODZVexiq56GsB5G9U4cp9gjDZALAXyN9Pb0zWhfQHAFgsOfH7+VQ1xLDAYwdddFq3miqbact0cH1eFvm4r8GHNNOKuMuDyPN8+kSt8xkY7UF/P/nyWkvpBJaTpoQOn9U6bwg7RBaDa60lerILr1C3BYVxbL1z3wrGvMgNx35cwXWAfO6rLtSrPrdd9/ueOGhq+VbCG8pdxYE0Ux374q2FL2Bm2ORtra80r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199021)(2906002)(66946007)(8676002)(86362001)(8936002)(5660300002)(36916002)(6486002)(6666004)(558084003)(186003)(6512007)(478600001)(26005)(38100700002)(6506007)(83380400001)(66556008)(6916009)(66476007)(316002)(4326008)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yAgOG2w4p5EelkdFEU+o1MtJlqZjh1GQiDfJ1+N8s/hxkwya/q/CUHO1Beys?=
 =?us-ascii?Q?U/3chIF2cB1/gmrrltP2sPmZaBrnkUsPGiRR/syGFZ9uUaMBWmANDXPn+sCM?=
 =?us-ascii?Q?JNalXBd1TtEGeT5inUhDhAxzNk2b0soGkqS7VaM0avaIGerhZ1YdvDtfmz3k?=
 =?us-ascii?Q?3zo9IimvbEMRZzOTBoM3D2Ee0I1EcbvIN5obzn2S5LOFV79ZU15usrIce3CC?=
 =?us-ascii?Q?UnQUziBPTLEvP7D/EK2nUecnEQy4w7QP9uYXFxWfUKFcj6lTGS6JTF+0NQkG?=
 =?us-ascii?Q?DEPUbp3V4Imh4VFxlOGP+3pVkNT0g+i2a9ZGr9IvGaSO0VjilnpXNXIRzbvB?=
 =?us-ascii?Q?ow8PMpioi4tP7mLWKQWqRJy3Y+Pgp5Rh1SaQaN1Y8viZ1PT3ZKm3ZgNiKiX8?=
 =?us-ascii?Q?ID4/jOR0cKJmNEQ4LaGabRaMpg3IIbN1MTItNGSvt78GehEkZ2vJAH/YT+g4?=
 =?us-ascii?Q?12EoSCpjbKNLhOq1EnDDcXDkjaNHJUhkkCPf09P8fyEj8MS61xV4WPzK0lGb?=
 =?us-ascii?Q?ADfq8n8qW7sVvVGSFsY32dUxkNZqiNtG5Go2fVH84lSqjBWjsAHd8D5TuaY8?=
 =?us-ascii?Q?s6fu0qCvkSEytjBOlnEEEFFgJZjGz9GWOSUzAXOU5u4/pkqgLFe02j/fvXQy?=
 =?us-ascii?Q?i7r6/VTVAsWejXVijQts3pTaW1AoLLbp6jolPgXiA7f0a1i8RqC5/vSSdy3k?=
 =?us-ascii?Q?Lsku5dpK+iKp1LGhiP8sacaprl46LcoqXeaX+LUZtnsLaMaJR0kESem7puOE?=
 =?us-ascii?Q?+pVyAPPPe9ulMGu6H2H6bl0dh6EONx3xjvY4mfqt2yOmoClwSZE6VlEFlQ0D?=
 =?us-ascii?Q?ujgzeDC1IQmkb6OVxsoh+L3jH19e/XXjWF8xmxNVFQ7LRkQs9Fd3WbcOp0O3?=
 =?us-ascii?Q?lEOHb0FzwVDnT10+pEUyshjOLtoudD2N/wSQl2zjY+87OedWJEj1RDz2gwtg?=
 =?us-ascii?Q?Bmwzkgrq+3zyhOw6e7ulvbbCwUmZPGTCy7ys86atB3OrVfYvRXgFwf3tjWqv?=
 =?us-ascii?Q?B+Zh4k2UXX0U/xeAuiQDao6OkDSWGY1YJtefto352saRq8lI2G8pTqWT7wzQ?=
 =?us-ascii?Q?IXV3S6PmMNx2dYw9mRpyO8Hz0Dz6hrS9n0lf8u3ng1hZ46mLWMEuaBYzlJd+?=
 =?us-ascii?Q?+QD/z/PgqWwVWtAuR0HjQmC61+LH7IozIk8XwcJDYzzx2DhJTLo8H/o8sHGj?=
 =?us-ascii?Q?G9fPGeL/JJiqe4aHfhXVbafVfiKHgjp25kMC3wz0KncwlcOXW3AipQbs+mAx?=
 =?us-ascii?Q?5tpRz7FfTBmNTIa4qzHRuSCrV3mnftAbOA7ZObD6B3KDZ+VwkTM3gQ1kJE/B?=
 =?us-ascii?Q?adX45/ZSQiDlMrymgDJY82HgpDYkuSmtQ3fACmp2eJ4H0gJ+CROu+mNfBhKh?=
 =?us-ascii?Q?VXmMy1XoaMJJKXNucVwudjla5xAYrFLHzSegW7Bl8vITkZQhE772n+qTBZM9?=
 =?us-ascii?Q?pSU1T9+pvuym2gua82muxk0TtDPGHaG2kEg3OjJj1FSTmlrTZ0PxnDdyHrSE?=
 =?us-ascii?Q?Xl6EIoHiNyiKG7AQGr6QUIZTLRNVMjBdOITrLQlwKyUbVFohjTzK/e1OluJO?=
 =?us-ascii?Q?z/HtTSt3g5xqmfm29JYhAFwwdtYpowUIDYMC4QBeOzfmiX1RI1dwKCeYL1/L?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: N9YR1HdTqckfYOU8h5Jn122wYvbEAK0GvhEeRvypPyLh1NMOYjYfU2Jv+IkWWrvkzyB1TBXtTk2kYopAW69s0+S51heso7IuA3eh0V05uHFShIJk2W6QpsgUC8nEUN3Ro6i0gWt9cpP2WY5pm+o4DqP9ofOVZBftPj+2Yh8iNaT59FuQneqy1WytH8rEo4rR1c1Tkv4I3sxo3gK00e0mY3TzLNxMOJj+lGQ7244eSEwNNAU8wRVLmgHpzeNWkAbIehE/Y8IPq71Mtrgo1qtpoH4Zb9oqRMy+aNIK9vL+nDtcrZhUgMz4+N89I3qUpUz9MxN2KkuMiIcu4ymLRoLXV4G3NTAhNHRYoMvaYBxKqeHef2Rib/uipquvg6mH5DcFdN3FLPOmYj2//QymyZgmsGD3DyVcAlGvXK2NVIJFfE8CLi+Rmj0JyifUNcFbJjaDGMidtgf6lPHValx41fQFAUKgRMDAUMJDm8Se5vm5kU2sFKKmwZhm68IzYY42Cyosfs+kMTAwd959pVe+cHbjT70iksAVYb/1yyxLwpiDfyLIqvQyDlyeYarxjV86yk8eVciZj9npdypjXcN9ii2SygymuYaE4ZVnSMOiUTA/NLTk9hee2UUnuFYLj8uAm7IkFPalMGgSPV0WkeC4opcmgMRAgC/PvwTTAPledIupTij9/Y6lKFPBibYYbzznw2IZEt7vqeT04PjSiQt3ao10g+meqOIFcIdWM4UL/CrtnK+Z4AQgDdilLZhhlpEn9mU/lKQud+7IZqd1Im/Zdc6GqXfVkRJwGw088lB8+nsvtxkJsIpnm93pQx4lbagvJ8JMB+51i2yyhcSujw7tIc5cgA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e75a7f8b-98af-42cd-0324-08db7dc1a89e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 01:38:11.5245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9EntW8wXjknSxlms/ZmCxH+xxXVBkzzSryirMJDgCEBilvFuSThIl3WqKd3qAzDVH+lt8E5//il60jTySwFsra4VSmDGMvEmlo7xjE7QgMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4889
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-05_11,2023-07-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=852 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307060012
X-Proofpoint-ORIG-GUID: KvugQOcDbJt_JRgk4VlqwfVnvZW5Hksv
X-Proofpoint-GUID: KvugQOcDbJt_JRgk4VlqwfVnvZW5Hksv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Maurizio,

> The ramdisk rwlocks are not used anymore

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
