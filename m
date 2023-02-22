Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6878BC61DA3
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 01:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjBVBUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 20:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBVBUO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 20:20:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E792FCE9
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 17:20:13 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMhrpd013260;
        Wed, 22 Feb 2023 01:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=xh9fMZ6P+lfeh6ddr5VBcKEfhvZLDJ6qFd3geIGHt6I=;
 b=ZZjCGGtJdUoDvuvg3aHvfeahUqtrg9idMa9c2SBHayNgmYCekwnUsyiKh6kzRzi7OF5U
 qwJSViw4mD+U6Po04dcODYdh0qxSf6uwz0TXc0Bl3asbLVCuBfFcjZeqGQb2Jtgncnjx
 1LY6A3UW851GnATkipEPPa8teKgzYots38mcjYXTyzTBKbQjAtB3dRzgIeb+WkLDBk01
 blD4XS6F7zgBQZzra4tB7uAPvel7CmQAv+XYFJUwSum3RfM64mrlDaZoYwNliLCZ2VWR
 Jl/gxgmNMfdGASmjd1BuXRZmDIs8RLlEpP6Q6o7kU2TUMRTsi7P4jcFPYUyQSRfSr25K XA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpqcesa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 01:20:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LNDjTl031377;
        Wed, 22 Feb 2023 01:20:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn45x67p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 01:20:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIUxdKBlWSDJiVO8uRq+sK89Tx+Oss90Zun+VmRD0pKjhB29SI9B3F9fM8IjltJApB/reYlosa+hLaJP9Fg60LGx6Uc/ZeUbQlzEJJ3TzwMsXvbzxxhXRdF3wp4iw5NAnMtlQr/qFDspCFaOUS9UjxJ4wODx3RIsTxyVKo4xF258Ng5ut1V+VgvjwOs0I0a19aPNt/TVvhQcJWcZPTvsD3a07iYF1e0xSFTQXSYt9WQaI1h0/+BHuTlZTgAbzGE26ubesb8eCzjZqxEGrgLlE6MetzO4BfCouvbvUXB1jeIeZ/+zvn0KjzTFf2FF7jaZM14KdXWTE6JQwk6qLq2Fnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xh9fMZ6P+lfeh6ddr5VBcKEfhvZLDJ6qFd3geIGHt6I=;
 b=GBCYDLgTwuv9YhMBmX6dafc0V6Hi75PgwO0wW7UoErO3oqTF9FhQezZGzaVU8V+aCzOq3U7SmmKMJahbDJvJu7iRF85rxHphKz1HF9vAATI49hVSU6TOZqy/Fu6bFH8in0zG2yvCMTHDe7IDQ9Dzry/UB12a4zyb0BJk3UgYWOyqkgc8RSzacqLIpp7gMFlSCbpDJvwtCZ7fUTG4UFCRQQSyPZPC6AMYCWXKWTLSPLZ+yAuIY73l9s90GM/IG4j71qKPHqN3Jz81X2uopbMOWo4qE1VglBZ9MT91WjyoBjK9A/l+ci+o6pl0j33NihN2WD/MmiJdmxBZZHc1fwtVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xh9fMZ6P+lfeh6ddr5VBcKEfhvZLDJ6qFd3geIGHt6I=;
 b=D/mu7UbMqaxQBuTErteW5jxT5wZA5RaxakzY47DNOdUprlJ7Smd1Dmvk0VKH5thsxruWa5GUcvezl31KsexzbMVxg8mvK1GF4jVnAA2Q2SX97jfFUroy+RBOAdjPolOK/Ma0HQJ53yQpAviml00ZQIIakh5qqLbiEUyxkUbgFSc=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BN0PR10MB5223.namprd10.prod.outlook.com (2603:10b6:408:12a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Wed, 22 Feb
 2023 01:20:00 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::768a:9658:9df:701]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::768a:9658:9df:701%5]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 01:19:59 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Remove the /proc/scsi/${proc_name} directory earlier
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7pmpkcs.fsf@ca-mkp.ca.oracle.com>
References: <20230210205200.36973-1-bvanassche@acm.org>
Date:   Tue, 21 Feb 2023 20:19:56 -0500
In-Reply-To: <20230210205200.36973-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 10 Feb 2023 12:51:58 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:805:de::25) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|BN0PR10MB5223:EE_
X-MS-Office365-Filtering-Correlation-Id: 923df6fe-5a5f-4e27-f329-08db1472ea60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzzJgUZ7nAuDZ02Ot4RKlE5G43v5CoFksPyGlVsWxtNO2mCpeBLJLEVxzc1pLy8hToDvMjMvdtVg9Nol+Xfnw7jh6oMEMwzg1qpK5r1CnavZfN37xtdQSBcQQnGZoloRPDJWUiBpzgpzWpDDfK6IOWnT3cuvp4RioXXwGhRhgbD5iL6K5hHHhN9RrnC7/7htZeF1FQwMtchKpnQqb6egjueqp7KGxOu/RkaX35J0f1btA2FiyKL+MwATNTkM9MJlqObiA9MhKlj5ZqlWacsDY9Pn02QcamIEju+71F6Jl9KHoEKbiUNvnZFB07aqFY4rlvvdgOvT7XOTbjK5OqCa3B3L2iQgksrsLfH0UYb3QU4q4epAfGjEz1wAlwI6YbysraxOAhTmut9KqvCT/rGIDYhnMc0fzHI5g9teGwtn2Rn5XcixnZc8ZvFedx/hYV8p3oNObQdXLvkLTt7Otm3Zkl75fQ2iDnDZuX5wpf7aslDG3yU5i9Fy/tlKT8lDzqQlhW9J7EiZwu2PALyVuy6dFSYAMkhGTpqr44/d+rBLCx8OC6jDmMeLH+0w0qDroLp2hSRZfmZWZQEGTHTq1rKySDkVP/2TVWnEph2/iYV5vx7AtOyPHUFHKTEtso88VpiAkm2emIw2eukhrm00aUGeM6RiHquIaFrZ/z8C2ypFLywKahEGGLfiOgF8sqd7IS9C4sv2g65Ye26l12X7MB4x/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199018)(8936002)(54906003)(478600001)(5660300002)(36916002)(6666004)(86362001)(2906002)(6486002)(558084003)(6506007)(26005)(186003)(6512007)(38100700002)(4326008)(6916009)(41300700001)(66476007)(66946007)(316002)(66556008)(8676002)(228453006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FXGBoZ4r8yJv+TaWMsqxTLie8EQ6XhPMswnWfkcp+GPJJbckWDdbFVX+LbGV?=
 =?us-ascii?Q?bwnFnbVjUT/I3IRWg2c92IeXCxjafafBwQZN2jXtvhK8nZYJfLuqsP54WSJW?=
 =?us-ascii?Q?+bmLMHrb7VycFsx34E083AsPVck3rzUyVG66PyX8QZLeKl4sa/akA5HpbVDq?=
 =?us-ascii?Q?kup/r3ogNCe66BFmu6E0X6Saa9kTJA4psBrQQufs5UzBtfS0uqrEqSn6vSUL?=
 =?us-ascii?Q?uX5uR0RqsaR1yxEJt1bbxDVpKR52Kx9VdoVqDGqoNv32D62IsEsPHEKBcLZ2?=
 =?us-ascii?Q?Y0nUoLq45qchF5oMZFAMWSqSZcfQ1ZH3SJCT3Cg0ErHBv0buL2uPqbHj0rUJ?=
 =?us-ascii?Q?EYV7rqMe2/20Z6xkNSRftBwiDzD+FHU/6IW379G5Tjb4ASt36oqm8eLIo55T?=
 =?us-ascii?Q?/UT3R+lGAykksMU3pLJ2xxjUN0ny3URcvVVbsFADXavKJ0kj02r09PfX5a9B?=
 =?us-ascii?Q?IL8KA8mRuD26bSOuET2mI9gtVLMsSPXLmhwj7SCIQyaVmDgyVrgLE3pEAsBb?=
 =?us-ascii?Q?SAogaJqk0fqoJBkVSV7JIdLi3vuLN9F0URbspY4w7BtiTBk/Z7qApa2+9vac?=
 =?us-ascii?Q?0B9kjVhoMjJ8+56zLGIE9NQFax2NL9iBIROyYrxXP6ZRtF0opdNGbY3qAXdT?=
 =?us-ascii?Q?H8axF+wQfxQ3GHM/dOfjzZZDwcPnyGN9gh6HEmmc0TgjPI0ZOPkrFVdI9Pca?=
 =?us-ascii?Q?ulxCDSvKCqwZksyNh5B/xMyi5RTKnNsDags7aHvGh42kbRmJ9MJofAEdbzqT?=
 =?us-ascii?Q?TCoE1H9skHdfFnC6tlRzL5N9MIfMFhwHL+7LH2h0UrOGVHRRdfP61EMQ+uDz?=
 =?us-ascii?Q?ZroQtiY61qXjvHvc/t3RuMj3QRTyX6Thq48IepZoOajeztCivUV67ACebE7v?=
 =?us-ascii?Q?RfpS2oN/87UGt6XXWOpvbijgjCiKCw20gWYrfSxKZbR46TjuxEr0MzYqaw9m?=
 =?us-ascii?Q?3ELNBpJheB5+hpZV1YTOQlsNBH87rMYihbn8/e1le8rCTXN8B9cQrXOKxay+?=
 =?us-ascii?Q?Bsb/aKglftMv7brmiuMvSRW8B6tHw9Le0Lb00BWJQzVqqDbdozOFju2ENMIE?=
 =?us-ascii?Q?jMCsnaIPaqsRJ6AjhD5ZbAcV3n8W2PXivIuPnm6joDmKY88ApT+y1GY3fe+V?=
 =?us-ascii?Q?/Bsv/8/0ZqBJHzAro51ZXF6NlqqM719xlNpDyXngevpmNIHc/soBnqZdVDIe?=
 =?us-ascii?Q?iFvsOFUSi0BXPqDroqyBpPb3xPbrDHGeVOLDueDxsVSBuetc/d62kJt0YiF9?=
 =?us-ascii?Q?sFPRdj95PWzoDMTNYRPbbIgWRjJWw8d1SZ2cpEg0r73YFIJ47UEbg5Ng011q?=
 =?us-ascii?Q?cl9kMLVPKUPeEpA0ITfdqXL3LK+PzyRI5NFmwo3S4n3JoGt6wcG57E82yBfM?=
 =?us-ascii?Q?SChGPxGhfTNLjK4mLZf6b2RWDicU4TEaeRrSn3HuYAXeKu8a+TkFyu5uSA4L?=
 =?us-ascii?Q?KSDi9M71448Q0JcT9HVc78ag6aCvlBPeX7nv4qMw850/0mBt7S+Hpy2XtFs9?=
 =?us-ascii?Q?b+StYxMSqunGljPfDkagpmDFe9vtqM75xsdW62IM4W+/mWUZXExqfERTglZh?=
 =?us-ascii?Q?Nhm4wHy+AvnqPlOI3wWEplM9hs+Nk+fYyEIJzvwAh1SEEZBAcaRjSYj7y1cp?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GvrA1jUY5X1paAY6FJaYICxVopaysadF/eZZduXAG9jl+wn8DvQyYIAROJKXUnKozbrHPLTWiaDenHak7KXC572st3cIUb9fssjTDAgO0S7c7BWXDnyWvwrKkXz3m/DGVSeWBSzNrOXYUcwl9kRgnTvMppIiBw2pPise5sfjiuhrzBsKjScySesL/2ndXd2DbpFFHuDtYdZrLcAoTZYluk1SZZFOVLGfhOstR+gGeZn9m33SUAAtY6r/EfuOe+pFSh7gJHkPVVIRiZgoBGIHBtHql9KHNRhi/MD9dSsIEnPrUmgfuDDGr1O/Q7YN11eRkFdVzC2q9nF4SoepXEl0QqoRlGzT4B6eg0MmLBkOn/uBQC46W/a+9cuOph5/GNdr2E5iRBQTV45eNFy+8MWnq8mJlglB3w8qGCmlUMvIwpXqHSIJisOw96m8A1vKE+wTOV+MjtlcyT5NoIhCgWL68Wg17LI4Uhkln2bDtyJcLcYZ+gsA5BbN0EDYoMQGKKTVHO8HhL8HJ5KinoQox+nqIqZenbdN9QzQZm2Snp/UxgXck8AHWE1itpUMmLyonjJaspcsayNpYWlALhDHpH6iuA3G7uwwcNYMUlNkK50WOZaHrtfbop7Xw6ZlJlZomojlYxkGGRCeftzLB5wAdrVCFDtBf1TBURrQcktO2O1+ZxUORF5+WHl03rsbS/OyueM+fg9MRJZU9AQfy4BdGNj1OjDPYFGJA5YKHHbtrMRyrAp2NCoAV8gvSUL4mxuMXVAC/JmXbO5svi/hFdwBjwypzJl2oSljgW6WAdrm3GJKYV8wa1ZmVqMFedaisvNj7Gs2EhP0mRvN1mj0ovhw5JSCR9C//6lokbVSgF5V2rLacRY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 923df6fe-5a5f-4e27-f329-08db1472ea60
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 01:19:59.5669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxaeKP/y3h7v5yl5J5uAKyLMFHxE1BtgWV8ugxt5Hw0VEoR4aH8nh17LVKf/j/YPTN3wCYj1987sm9GAHlZbJ1Z1tlX/zBJ7cer3tDzg/b4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5223
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_14,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=812 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302220007
X-Proofpoint-GUID: sPnN4xbmti_kZv_Q47pQMcmDhvMa6-V5
X-Proofpoint-ORIG-GUID: sPnN4xbmti_kZv_Q47pQMcmDhvMa6-V5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series fixes a race condition in the SCSI core. Please
> consider this patch series for the next merge window.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
