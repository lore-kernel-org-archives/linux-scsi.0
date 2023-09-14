Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD0EEE0206
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbjINBHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbjINBHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:07:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA82E170F
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:07:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38E0BQTR014746;
        Thu, 14 Sep 2023 01:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=3mgt4I5yraH/jFb06z9MA9WyMxepTk9FT7tygNjeb3c=;
 b=g3hfFMee5q6Z6EVhIIxYx1Pq12WHOnB/DGhvao7/Pi1/K7QuT8KkaSSSxqi8HG5Va68a
 L0O/ajzZyNTUcHvRt5HB53hhCijQqA+4f8p7+uhziHDNDwfmDPIesksNFfBymszqk9zX
 93lG62yXNFwPEXWUe7e/19izZiMsCcjDXz/jKiiluky0MREgy5SU1ScoaaEbuhqVXAzq
 86xS2gxFIjOJYQLHyrEvENFYNa9cFv6zzypzC7Qa1obUsJridZ9HtWVpkUDUctD0eyc2
 rYWiZ90IQ72Pj2mgvQ4nzcXmIY3NNsxLK0hHsMUm/eC16UrVx81Vz44KPcKSzu/QgASr yw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7pkg32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:07:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNB70S007754;
        Thu, 14 Sep 2023 01:07:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5810q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:07:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVtywaC7KMZbUiBjW2Yw5Ubeq4jCf8wGnbZz/X/JT5CDXPPvUNWvhYLw9o5XrmhoU6ucKs37BIAupsZOmTr0g+mI9tQ4I8S4SghTXd7pgJjpMnVJYJalBlcBvxuagJS3tkyLOstpAJCwf3uQOTrj4LXrp5pwDAJ5msVEV68IWYLj5DfrVD37zqyhWTAyhOu0nKWVJZZOtR5/JaRAeTXgEC0Hf85w2YWJrZrHA8CGQrrxZ966ZySv9LdleixEU8pl1A0LiHd4x98hMI8ykCtA/z6kc+fm0l2LRLTt4QAV8Hx8K3OwzfxTrSV/YUgYR6sSDwPUUB8UmN5xo58PE0NPNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mgt4I5yraH/jFb06z9MA9WyMxepTk9FT7tygNjeb3c=;
 b=ZBoTkpxJ+sDFesFsccahbI7CXGWhCgDGjSLUn0/3DhSUKZv4wpDt00N5hVa6ZP0+6bfIduURsl8ctJ2gk6aKzh931KWldTpOrY7pcsZgvdbWu4oBroSZAyr132y+3ImQEZyRJIV86mPNyfnkZpiHuIi+N4jlymPnhg8V8TClmvXx+SMI4X9F+YO7WV59NNBpvycM7XKVqk9mzDynJ4jUM3E5IVIALUhkuTFSsmE6qen2c8jFVH2lqG+cDHkYsDthn7TBihth4/hBIi7ax8oa09UzACypP9v+HrjR889m/mKr0A+wfVkvw7mR5bcZduQK7FKOzc09h5N9THBA5WnpQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mgt4I5yraH/jFb06z9MA9WyMxepTk9FT7tygNjeb3c=;
 b=jg0RuuVOJeFitJO07eEaSBiJvRjQ/BqqFeHcPwCT1C3RrVwmkO5vI4Clh2ZETuv83VPx7iqBbK1g23fOzxdnuM8om51aAI5Wp9ZFxhusfNnBcMiKPIeTxhozEciYnAuOTwuN6h2jj74XgB9aVI1hAkffCAHhUjnRyG1pG/ZNYuc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7579.namprd10.prod.outlook.com (2603:10b6:208:493::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 01:07:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6792.019; Thu, 14 Sep 2023
 01:07:04 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v3 0/3] Minor cleanups
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wmwtef66.fsf@ca-mkp.ca.oracle.com>
References: <20230912230551.454357-1-dlemoal@kernel.org>
Date:   Wed, 13 Sep 2023 21:07:02 -0400
In-Reply-To: <20230912230551.454357-1-dlemoal@kernel.org> (Damien Le Moal's
        message of "Wed, 13 Sep 2023 08:05:48 +0900")
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0114.namprd07.prod.outlook.com
 (2603:10b6:510:4::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: 71770672-6add-472d-7fec-08dbb4bee8d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: daJ8eYh/0rRXQGDZ4UgUPC13KbxEiKWm1A0gYNA3jZc5zplER9VNelFH1NB2jajybn9KY0VB+kY91pt6lr1H0Kxssg9Rj4gyCfWsUzIc0zP1qH8enEOTI/PKt4yaINQuNAW6SxF6OuhHc8JKyNEzaShHYquHt7WM04RLrAaz9SdtE98o7jtH53Qp8AzEOj3SqE+fwMj1gLbWWUXcqiAp13ojrRiQ6Hegh1QL8r91+x5BQ5XKV/KiJOFfD69UF7EogDC7whzmO2VsxtWNvi/qsjXU24/C3V0uTO4eDIn+88IqcE/02dbANtDESfp7qV7RCu367yxQwa5BLQA79ZOREt80XBXD7wX+HUXC9OSeXP19+xjpABysIhJ6Dtg+5zWmq3M4v4XyhxsM9/CnRJ6iIBh7UsYw1zWMxa/6J1HKveXLbxJqh42m1yYi/BZhTCcEzNbJ2PNYNXA9b+cv8PcTeFZX28rtlWaQmYTslYvPzFO40wbodxQ3BIVoYRVrSRW0YzRwUWjQL03MPR86rIgcCd9yxKiFjLqr2754Zvo+5Myf74Rc3XlWsdOr9m2wzlQN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(396003)(346002)(366004)(1800799009)(186009)(451199024)(6486002)(6506007)(36916002)(558084003)(38100700002)(86362001)(107886003)(26005)(5660300002)(2906002)(478600001)(6512007)(4326008)(41300700001)(8676002)(8936002)(6916009)(66946007)(316002)(66476007)(66556008)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u3YcFO/v73dLjf5m1DTMwIkVS+kR9KdV5t4ZJzX6FsrJ4w6AUfwz5tnNt3SA?=
 =?us-ascii?Q?V3y7E7jodgzEKy7C6XvoPhWomSfZcrA2oxXPAu0nAR//vlXPphv0eFrx4Hol?=
 =?us-ascii?Q?ixYkERFtwnnGlGt2W1r7HFGbXGoTHxZjuOYluyZfE3vMheYUqDS+UTjBtpX/?=
 =?us-ascii?Q?XPOSycbvDKLU8Wg5I2478knyYJSU67OcXeIvQ2ubSDMy6SAEeHUgx4Y2cvyM?=
 =?us-ascii?Q?SzWGdNZGNmdtwLULpqdajqze1WHOygSaoyVJKqQTyWRLJIN+soemwpMGvO34?=
 =?us-ascii?Q?C7oso/WIoITMDswGjtn027046RxormiJVBSOn+On7rq1v3hWCF3Gj24g75tV?=
 =?us-ascii?Q?X+lQpc0FBJgp/v/pnvy9/cDlOsLBXsNl4n56W0I4OqtlIfycMtyWONm6Qv+K?=
 =?us-ascii?Q?H817LB5Co5pnDaWZrVoBg4pqahAUJeTuIODyDZlGthluM/CnG7Hom0SZOPcG?=
 =?us-ascii?Q?NLaqIuOcO+1rFdL94UN9Sp9cIB9ZI2SRve6DxXAVrqKERsuRZYCJuVOKJeBi?=
 =?us-ascii?Q?rIVJy32LdQMjqW2bAtvNpkidB+SYRlee254fIOFKfsEwTOmnqxB30aFGS+vu?=
 =?us-ascii?Q?Z//osFysUbnImLF2WpejywbL/vMWdl5k8RqP9jMuoK/60OIFtaY3+uCjJ84L?=
 =?us-ascii?Q?M8TzilhfSH02NW2LTaVP/3L3/CF2n7wY3p7Jo7z8OWBU6V6uIQRzC0WRFf8n?=
 =?us-ascii?Q?5mjJsbVxWUTpvIMbQUfZ7+wilmbIr9UW1SiYvFPD4D8LCyquyhP+yzw6jrBM?=
 =?us-ascii?Q?bwDUNJocmJe9+u9w8hjANRBZXyDdJRo29ZIMdzXTHBAPybyUMX1bW8XY1DKS?=
 =?us-ascii?Q?nt9l0kA3M7C1DERAveagSg0FcT/BwTOzeufvI+PEosdqxmqA0eSJJzGhlapv?=
 =?us-ascii?Q?NNrkc6uFKI1CVz/aoebOSus0w3+hhRE/U5Zq4Nn0/MqpLgi2/tKE2vECaVhi?=
 =?us-ascii?Q?Fian9xQ7iz0tXQsOvMhnUX6Zci3sV4mjDjQ+db6NM5Ya0J0zR1TbjVYAJjVQ?=
 =?us-ascii?Q?k4BQeCaVr7wxf1WR7f0qjtxJfIgL08zlzuuKovnB6Lz18Ftvx4ZUN4liHY8M?=
 =?us-ascii?Q?TDkPwSw6SkeN2GCqD1v1Z6+v7XF8ZxgWrGGhzb3hTAeIuIfoy2gh509QjDAh?=
 =?us-ascii?Q?PLgMoCSq/1dQrkrWNacs4YYnTSK2+uPg92yywFi+QVKu8nWp1qsN1HAUOR+z?=
 =?us-ascii?Q?UAtMxr9d0z/LeOfm4OJXd3hMAiydsqO/B9uXBkfTUXyAhGylAykL3LsUSLyW?=
 =?us-ascii?Q?q1TPur9FW6UsY13twZm7X3XCK27ofFdLuY3a/XEJEHqoNaWMPAyGwLx+iaey?=
 =?us-ascii?Q?mBOaFEQ5NbRjsX8u5oEhGuK+mk8UBphC21CPo8FikgGs6cEVPTT4tUzI6S0K?=
 =?us-ascii?Q?JNZibU2reicLpRr6wFJv1vCV9gHNfTRbgFjC2Orp0fn5w1zU6R/SGUqqPHon?=
 =?us-ascii?Q?Q+JLjXOnGxtQuA36VpdGRu3u1ngWQcJMN7Mtv+2S+KhCWZa1t2VQShXU2wgi?=
 =?us-ascii?Q?iStfOh014Ed04XPXt9XetZ1GCci0+HkjVQWsq97jLBqJInuprQpUzmVEzd+F?=
 =?us-ascii?Q?hyS4Q+g3p4+gKD1aCK1eGN1MJYkqPRm7wt48I57lWrSYr3ZSKllvEIH9qZp3?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MLio9At0yNdgrr3G8U1/IbJGLu8sKXEHoEJdtr0M2JDaNog5xHLeO048I1j04JBT2zxijmTWcUfZ1wsLy6rm8RuzPvhsykxGSk/CrELScuEbf7KpuiMWqLYtAP2y9pFbUI///l7ufGjj4709Vrwuu3hAaLTFmNn40kqyo+WrUCDc4mBPb80VY9c3cuBu/vScsEw7EdG1JTnAYhFuIi5RaI/fd4kyDl2FlnFVJmiFBGVUcPyiNmFhKYykuZ1PnxLfYbTYEKamBWklu+i2nW3eBo15YuvoJoU0or/CF+Dq//2HHeBn8c2U9gLw6skLeJuw4Uub7n7x+oZ0MSI9DYAhPZI3wu4VZ2Imge4SC2KAK1hMgvESRRUcPLQV1PuQomA1gTzLMpxP8d4nExQKoE5jGDtCkKroYiKmNBW77Fi29A0KJmr3fnT3/kOAWYo6NYjWpfeT3iBPuMn7G+xjHKDKkiZafxscS/n34Z062H8UjeOUOt64phlNuIK9oWaLCIEdWouH/8vJYjeGEjRJDnoRIMa0TI5IihP2p5Dg21FtoJ2oZCdP2H1LjLT7yW6YRjH3UJ6HXfZlsHxrmERLBe9vbAQ2Or0xPQTi3d1t5SmwUsZQFEyKon8bcIofdSmvDPsZ+6fUFEhxgyHanMZdReHZE1SkQq66VTrAB2ErfYQbQy4fE7k8AwUsM/FQoZrcn5T9i5CTEjBRpg1ptZPy9XwujvbWOs6uNDONnxQqc4yABkfUJKyaTo39g3VUdeYhWN0wd6eF2KTZj7dZWu+3jpObCIQ1HOzMEyz3i7CJnqAThyk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71770672-6add-472d-7fec-08dbb4bee8d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 01:07:04.7419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +IVOVUwdl1OsuUxLO2TejK9YXAR0CJGzoDCCk59UUjMfboNO6PVVCRq9nd9RgArAdE7QK3JFqnmcO3YkkAr9WgvxQODJUmFMhLY8rwj2kfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=521 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140008
X-Proofpoint-GUID: jxhn7-Xf09ChhtLHABiMzZI6PHNZhzgp
X-Proofpoint-ORIG-GUID: jxhn7-Xf09ChhtLHABiMzZI6PHNZhzgp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> 3 patches to cleanup libsas functions declarations. No functional
> changes.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
