Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6034FC61DB3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 04:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbjALEee (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 23:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjALEec (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 23:34:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A37DF47;
        Wed, 11 Jan 2023 20:34:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C4AvrL025387;
        Thu, 12 Jan 2023 04:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ieMIC4DFP1NiXmsMf3b+4AvRSyvO2dpjVjLsHeiFp60=;
 b=eWAprpPxLChs42aFxPvtpxOhevo4yWlNy6wHRrEvfkViR3pUTEpp2cd9Zg8SEdHA7z1w
 daBbNoy7lavvij5IwS1Gb2Cl2LySD8Cwbpo6ci1I6l4Ga2hE6OhGogDr5/zOc1t/VPC7
 GRfVlHwZq6tc5OFiXaYyhGpC1x4JiHHGPdVCR5OBISOqwS+ZDRi6H1V2dmmpsJjQTwvX
 7uZCe/z1q72chcqJqAUj2jou6/UKtgVWHD5wAgrmGBUcTqzXHb37B0jqMcGRaZdR6PkL
 0psbZ2SZGvSqzs/qQ/kBPKfNlKI+4PXSzfKQ5VHtz7SgilzCLlYym6dNNlI2f4yRvKjJ dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n185tc8rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 04:34:17 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C4Iju7005210;
        Thu, 12 Jan 2023 04:34:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4anjuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 04:34:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpqUZPANAissh1nlB6hy3lnD07uffOHt3T/djYwJ3t9Lae+lnq4AsPvY8p69LO7lSGttj3bLoxxXrRBXKx4Ue1ZewqYWF6fnYZx4DgcSwfuWjEIVVp3f28XHrDGePH0VqCjXk0hV8ZGO/qKkEAUDO5PeMcJSsG5oq6g/fYaX+IoWPCax9SY/ZS1BGcy7dOOgVU77pyxxJkK2X9ZulVi7JHCEIaRKicE4dONtgEUtB0jT7GtDJgapOnUFWLS32wNTuuCekWIu37NL5etKuggzIB4JNSKqSKuFpl9XEpwwFtkbFZTv9kcMt3IfUs9dE/sc/GqNz++scR7obUM9eJlqBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ieMIC4DFP1NiXmsMf3b+4AvRSyvO2dpjVjLsHeiFp60=;
 b=d6ac1gGj71PMbLWgyOzyZRUw55xeUaNYlG7TCsgVM/0NclM+UuY22O1j2bwInvs9r1EPhaGNUUj5Ngcgb++1jPaFWA7p6Qv0Ny01XMUb3KB/vhnqwdn73MHFlusbV3aoeYg9vwzjoT7Cg5Kwqqu7hzIHDoU6cftl+jnaSJwQValX0QUCKrih0NblNI9B+LDSIm1Y8f3U2tqqTVQKpcwWqfkbFayY7E+RRnfZugV1eyMdRD4Yz1nHOfgxgEqYpAaTBfgPqNQoe7S3a8YX1ffrhDfdimuAeR5k/IBh9P5V2jvgyE0UNfnuBr/AFgrY58JzGQAlw0gAVThOgBqqeppSMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieMIC4DFP1NiXmsMf3b+4AvRSyvO2dpjVjLsHeiFp60=;
 b=n3UZYQoYbxPW+o6i+WAagaP59+H3+WWb82Xa4+qYh01snvFkjEDkFXFP3pHXJk9CWA7Uqv39Ayq6P0Sef49NWGuRpbN0II8fDR+OdBKzpKuTmxRrYZI0LE8mRGwhF7rxrOHIRWZLidA08HNiswPQzpure9T/J1XLR+/ptFiqz3o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6286.namprd10.prod.outlook.com (2603:10b6:806:26e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 04:34:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 04:34:14 +0000
To:     Dan Carpenter <error27@gmail.com>
Cc:     Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jie Zhan <zhanjie9@hisilicon.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: fix an error code in sas_ata_add_dev()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jswwewt.fsf@ca-mkp.ca.oracle.com>
References: <Y7asLxzVwQ56G+ya@kili>
Date:   Wed, 11 Jan 2023 23:34:12 -0500
In-Reply-To: <Y7asLxzVwQ56G+ya@kili> (Dan Carpenter's message of "Thu, 5 Jan
        2023 13:53:35 +0300")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:208:23d::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6286:EE_
X-MS-Office365-Filtering-Correlation-Id: 495553c8-3c85-4b44-de45-08daf4564285
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s/K4mqNgLx8FbSNd8b361YKxk7k0exOqjh4dGVrCxuE6hZesdR95266uitmUbDk1WvbAhXgXAXdRxIVWIR3G0d7Wd2AVzrJqs36xZZj3Fu4Ni0AsQiofn/e16hFPMxw7mjuXujzEB3W3llYyFVo7T1vyiCftYjEjUbFOHdCnjTxSerBkjXt0INhnBcUmMuo9qFtko5F1PUyIemXnykw13csSUIfBL/TN6PKk+yPoQPggqiKIWp8n2RVu/QfxZjsOHcek5T1a7OO53hORAYGF1JkX6Zv1Rt45hxgFfQV15Cz1kSHHKq5eLmtXFW5m1yeZ+engM3Kfd4vcfcEEhsYiapAD9hlZSfvI8RlwbgrEdNh2SrouWk1y/PE5Zvv/xVzftzw5jLH5m005ydhK7fd+u7kbKgt7lZHQssRLT2hwTTiWSb8jThOwnv+anh94PUvnux4dq8U6fG0/IiRJp+E3rRz2G9wC1s2Ty3zgfHT203SqnZ2ooxiXdT2T/tVuXZ//HWbgk89BlkRvMCGjv2P3bFAh/JIOjoqmpcOPJlIaflsC0kc8hz5SANvuE/TXJvs+x8n8NCCZKId0Chd7U3Lp45s14bWgXGyFKze6og3iEpxlWmex3dAuB5AV6TSE9QS7il0dc1zvJTkcmENQEbn8pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199015)(36916002)(66476007)(66556008)(6506007)(66946007)(8676002)(6486002)(478600001)(26005)(186003)(6512007)(6916009)(4326008)(41300700001)(8936002)(5660300002)(2906002)(38100700002)(558084003)(316002)(54906003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NAMx//6hBUyyeTpZNja+VwmYBG/7lrXk9WpIPwvd6zBKysly2D4101z73Vxk?=
 =?us-ascii?Q?T6wDezm8+tds+s3JFOQYPwhrW+hnd7IJeT7xWtMAXg+GoYAvwJFdp+RPZxI3?=
 =?us-ascii?Q?CDFbnZULlAldkBG2gUaDYjsUg4ag9MAfTLvmn2Kw02POJHXLyCCtSAK+vgAC?=
 =?us-ascii?Q?lms5mJU3yP8QYDRXD1Ve4hciK6D+AbIIOAt1Pisf3JGDnFpgCOYx4RKqGFAv?=
 =?us-ascii?Q?C58kNIzof8qekpZtweCLtboGB7Rz4n4+4Ylv/CXr3yauQgM7f5I3HVcDu+gu?=
 =?us-ascii?Q?KlPdKOeoqvCdMf+Z2wVEgRRqclzWa6HC0RVqpL40aAExsKVRqFEszesxG+8T?=
 =?us-ascii?Q?z92fJAo9LIAN3sDnncC0pmR5uVgorGbL2kXgFxH0wY6Trxsh+wiIbP39sUZq?=
 =?us-ascii?Q?03BeEpU/WwqzyjeRKd4NXaNaZELDTYolwW6R7FoAiaSuuB3nFT5iuEaPBxhS?=
 =?us-ascii?Q?WEnobmRxYd4uoQvAPZIdxTiPA6BqBOXFmKyldYa6QwUT6VpCmMlU4/LhYWQ7?=
 =?us-ascii?Q?FQBXt+5kvryYFAjgsLG2B25O9iGVJx0FYr1iIrRewIAw7c8WyfQUPegHKUSk?=
 =?us-ascii?Q?cg4+Mo2LzPJ/1tv7cD+cW4Wcx26VEPIqjbgCIsUy3KEZ3BCI6eNH4wGegZwB?=
 =?us-ascii?Q?+FWDamwqzVqNiY8IYcMYZmpaT268EmbbKCe5yMmaBx66WgN+lJFgS6vkVmnW?=
 =?us-ascii?Q?9OQkAx9sR4+z9egfjvfNo3Y3/dgMoAqVtvn9TtClMKSgADyHbeXjuWMKxZGo?=
 =?us-ascii?Q?ZD3/xgfI+8skCDRC/6gvOFhfbPm1SC9Puyy32myqaD+gWhqI1HnTF62Vv7hD?=
 =?us-ascii?Q?7RMLmFAO/ptQJyCJmOGz60yvv8c5Qa4tSVuHHzAf5LF2/yDsTEM7nU7ihr3R?=
 =?us-ascii?Q?U0EILQ9rWGjS2EFSRA2tSjwyz/cBgAhNsABiEvQfJnlv1ScWCo3UmjK8DCdP?=
 =?us-ascii?Q?CIhVm7Ln2Yoi0btDjdBhK2wxiENh/NCI5dgwdc9PSww9RAw0xlCYLln0ZHXV?=
 =?us-ascii?Q?thMHNjfAwaqXk6khJUxadWpEi31AgS7jx9dG9VdYZfMgLy+yEJDqoYE15CaW?=
 =?us-ascii?Q?i1pULty2bBLGOuaYP+GMTe69F8l2FuVKCnn38V7kp0CiuMMjMnpCgbJPl495?=
 =?us-ascii?Q?Rj8Vl1ukiv4tasLUF81IqDsl2RlR9xAcJCoozh2PI6y8D3vVm1/WKK9lhLgr?=
 =?us-ascii?Q?JLYr40/XpD4AZQvkxe+c5gMca1rzh9QCmfY233KEVhzekuTYJqHlEpayphZ3?=
 =?us-ascii?Q?SQNbB5jogNTDIvBbz1Rtsa+wdTH7xG+Ffu5jK3ZqaPpCO8bsIIIJ64k/Ldzo?=
 =?us-ascii?Q?JRE2pm/1nMMz7hHOtjrjx3AoWFPiigRN9zI6iA43oeTZmaS2A+LG6wGRldvs?=
 =?us-ascii?Q?dFnH8Ezz2wLv4lHtvn95MdB+bD7mSBv2TVHcfiN/l6rIdpR0o4lgNkQDWJBo?=
 =?us-ascii?Q?XKsiCjHcGc3v4wi5eC0AKTZeDQu9vTQgttbjUE6lSeuiUxyEhdvNRcjqkUPT?=
 =?us-ascii?Q?bZUzE6sswI+/eGCxHpQ4ZhUan5S+rW+WnQOtDvOeG1Z1AdTFqzQbKfy3XrEI?=
 =?us-ascii?Q?36crcbyKTYTydizQEzTsC8XxH6JodHxQUSoov8YzItleVugh185YOSxXP9En?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?LLH2v1PUHiIPhjCNHZs2+L3xp7HW5RCkk6GjMe/beCsj0GobtbN1pSwKxwvU?=
 =?us-ascii?Q?A/q/+2pJGwi8AasFdU2nU6/OgAG/AS6fN44l0TYJCJkhal+yCFSCX6CTBteH?=
 =?us-ascii?Q?l7gb/B2/jLxYWe13Yeabku1J9dqhffE6om06QUqLPSSukay/2mqqlKFEmRw5?=
 =?us-ascii?Q?558g9FmP8sGDayQj1AKX45NfmKouFwPa1RfXAgvrJoFJZBtLFL/nyZ5SoWI2?=
 =?us-ascii?Q?IK/HHBiX9lXVOdx3osLGokIjpTmrI6fHGFK5q+izWJPRSYPPMls1xNWSSM3q?=
 =?us-ascii?Q?CHlf2Y463YPmvm8OnhYbNeEhxxXA7EqRN3utYVXLD53ejGEADzxwogtkczy+?=
 =?us-ascii?Q?IJKLICjlZs7RI+buJBdadONtVeshItrFZFwprJECSxUsUJHbDhgGBIedfXia?=
 =?us-ascii?Q?HK9pDx1tA45YVpBLm9xqhsZbBcB2rcmV4E7tXrft6vVGHl2KhVlpBCQcoE3f?=
 =?us-ascii?Q?HuYoMB4weCSihTdY8ipisCP6qyIe/uTAJfnWmXGtEW3kvFEs+Tv8qKXrXDoM?=
 =?us-ascii?Q?7TzC7Tejj2IEOTVJXd0gVLv3hHFcitqwakqqE481pMhCzwxEmRwfJkBixaIf?=
 =?us-ascii?Q?tRwBithtDH/Fv1XkqOZXLVa68Y6NUKrgtJF2a5QLvjrPfnmsvy+lvORQKy4t?=
 =?us-ascii?Q?zNhT3tFJ2AzUDbmHc2lolpXKAqnhg/3QZ3hpks8ZUE/6U7KnM1TF5Ah/djaH?=
 =?us-ascii?Q?rg3UnwzThHD2sBKSNJLPMByy9XUXcG+7rSy7khVe3xbPe0/Dduj1J6a7Nf2d?=
 =?us-ascii?Q?u1+drIpFXI0IsbuCdq65PcPv/k7VYWJWj3TcGy66y+WJDtDXYweZhRJXkadJ?=
 =?us-ascii?Q?2LO0wvcSfx+kzvIJ5Xjjzz6IKNISfqbb0EeYAiZh2HcyTJMqPCXH/GLElHCA?=
 =?us-ascii?Q?ie6pSsgohI+we2iJ44PfC0hvHUmK9grKuT1yW6+B1wEAWyR/HDCl9IxheQnT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 495553c8-3c85-4b44-de45-08daf4564285
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 04:34:14.8499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOczM81WcQeaxqSwO5wfnEoEEn2vD4BLQ2RevS5ZHPUQL6olhHFj2Fq+4WvQa8J75eWkET3iOBx6rBA+mKG9bRGKACifCe5eVdVLt7oWFuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_02,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=682 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120029
X-Proofpoint-ORIG-GUID: ffjenKXbrLxVEtlpUxo9SY8SQficUQk-
X-Proofpoint-GUID: ffjenKXbrLxVEtlpUxo9SY8SQficUQk-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> This code accidentally returns success instead of -ENOMEM.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
