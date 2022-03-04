Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F67C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 03:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiCDD4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiCDD4f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 22:56:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FE217F69B
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 19:55:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240jJ39019453;
        Fri, 4 Mar 2022 03:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=SfEFgq7Wjdh6/dnGy+5Jk3Uo2z0Q5bUaxqW356KII3c=;
 b=L6BVnQ0uXegI7+9jK7SrPzPcbXHrPFdO3o1KQf0fdWBnuka8+hM3Yewec7oM+PfwabKi
 pplqgnympkxeIjyCGVJ6+zVeDWZsA2KVdpxgDou+rQ9RagZBt1HFuY5jjBhc9UWlpxuR
 4CB6og6U498r39LJEHZGUe06LpW1a2RN9zHkAvLc1NuNdQsME8iBsT2wDeLnFBvBXiBD
 3jiP7Dea/7tN2zQ5liioZCyXgZikOIoqGlKrpNWYlJxQc85Yafc4jHxl8d9ZVQtRsf0S
 dbAEsi8Id3c7e4x2dVLmR0iP57VzWv3CMd4SXqDipvgtBNTIK3xSnlrhPhE4rQWUXPjC Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hrrpfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:55:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2243k6oS121303;
        Fri, 4 Mar 2022 03:55:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3030.oracle.com with ESMTP id 3ek4jtgkju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:55:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpBuskNS2I5Iqp0RKXpQYV5aNC6kfjVyzvjSliZ6dW91X/ugVqULtSpzVO7XN27W9Y6uElnk2YLsVrdHYlMqY4v2GtogrAS3r44KFnowPE4IO58J9VkhNSuOfQXYAQoMEZiCqjB/tYq/D3w/zcz4NfBA0X2up2m7xnElC4lGeNj/9C1b63BNW3745VmoK/GJZEJsXtjyweo7gxC7Z6MKUW+gSYmAbRA0SpCHSjuBMnRXmVsDA6ruBvbFSftS/pVJ2pySx1rGVrriF0Hsfc/9ATkX3/IYAZJDa8aEnaSZTDQgCm5NSoUkM9HYphtIw/S6irPsP4ubkBTFuDHnbwn8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfEFgq7Wjdh6/dnGy+5Jk3Uo2z0Q5bUaxqW356KII3c=;
 b=OHgLkFaIjP+lGo2jhNruaDq6mhTh/ZUC3tRvnGTBvBj3tw2BQr2tVvV1DpfTeVsfeK3QMKFyT1B/rNtzoIgtymyaBszH9sXvN35KAomZJvFisXYdFjgxZf+FfDN30KU9rTSoJKOXBTPcFOt3uQNMNS1YI/7Asc+//eTkP4nKd8k+jwZtB0aH5hUQsLdNVnsdoYJvWFGDGTDWcPT4eYnvaEiyGjoJ4t62XQofuO12E9pGJLjm9w89aOLO1wxB7hyleOGMyAMweNUOcdqr97+gMnYudFwjgZ1qCUG3qYVqfJnMr3nRzPILOB7s2jsrJQEwedmrWLHjOJaMa+T4sYuCYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfEFgq7Wjdh6/dnGy+5Jk3Uo2z0Q5bUaxqW356KII3c=;
 b=GpOccgbvd9FVYcRultjzKlO7DiNF4UyiG79bQ550kcIPjxdIP7NavKO9lXHOwdSMjOBZ57FJaPJ+HD0flAh31WhCQmhjaO8J+a06LcF2nk+rH4XPcsXeYvDHVIKA6WuQzXBABQf0s28niuEZOnhocwemIsqJOz+O3mbc+2ebimk=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BN8PR10MB3508.namprd10.prod.outlook.com (2603:10b6:408:ae::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 03:55:42 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 03:55:41 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 09/14] scsi: sd: Fix discard errors during revalidate
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15youtm4y.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-10-martin.petersen@oracle.com>
        <c088db8c-19cf-182f-8d2f-e990b5a0c35c@acm.org>
Date:   Thu, 03 Mar 2022 22:55:39 -0500
In-Reply-To: <c088db8c-19cf-182f-8d2f-e990b5a0c35c@acm.org> (Bart Van Assche's
        message of "Thu, 3 Mar 2022 13:06:34 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:a03:114::23) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b25f90b-e8b9-4613-619f-08d9fd92da14
X-MS-TrafficTypeDiagnostic: BN8PR10MB3508:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3508D87FB077BFE1435409EB8E059@BN8PR10MB3508.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B7vfkxQ+8/dVefQFKyuicNkCBQ4TVxNCZXCComf5dxu+26gmHNuWpJmrYwe8F3Try5HT9LNTDMpID4xZej2V22aHXHJ8O5flY7iPLIa17+mToDRxN//S4pt2QGwp997NVFhDzaPfzSUOuGHf+4ljgJ/NTw+OfZriy7unZ7Y22oIAlgSzxit32HnswDcY5Kw2eXBUVYBpTOGdc+pBRnkxIvsI+OksQtkC8xsLsmILnm6SjlO1WRkCJXtN9yajxOmIuhQ5ImFaF3xGLoY147RapMGaUm74ciIK+kq0ZpIbxNgIHMKYIYmXu2xr+ZGoHEmHbrzCjXFzq+a/g5iigAEQian/c2TQI8Ojt7jYbd8M20nEWmFDEK2qMcZ7/by5U8zQuSkh/jouS+T1dqT70IfDI+v/4GCS50i7uv9yv9CHtkjJqm5qnMeXg0eUdExIaLiFDIrRbj8FeMitorw818mKAP4Ik5UlEtj/W+Y1slW/+xl6v/695AGmIBgNFViHXnzWmRav1Vu/+Sy4n0lE2O/AoVe/jgUlGZ/r+3NQ1dPIDc+UDTROtNBsWrKYHyjbQUHpsaV0Y/CR2+1CiNqDvGbkO6zUJ35Lp9hqv8UrXZVnaY27YKZXcxh0ccNwJNyVRfzRrZk+x52YOOXPxEgUYBa51fAWTf0FFoOJdqNl0/cO1wJU5n2qvzotmH1SWuZzcszlldHRf0/QHa1gj5quwyu1Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(83380400001)(6916009)(4744005)(26005)(186003)(316002)(6486002)(4326008)(8676002)(8936002)(5660300002)(66476007)(66556008)(66946007)(508600001)(38100700002)(38350700002)(36916002)(6512007)(52116002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tFdZ/g/i7+SJKQD7nFU5py+N/nAdKdRbeHKAPpUZRbn5W9oewHacPVERG0XO?=
 =?us-ascii?Q?P6Z8HG6wO3wg1GviK0We/yyqP/Pxvmmx2qUNJc/b5G6D4vK/hPbYjf0nT23Z?=
 =?us-ascii?Q?PoLdXjU8K0HDrbe0ONzrQsazoNDHY0ZPIl1FqJvndTSIeFekKLH1wuTwJn54?=
 =?us-ascii?Q?K5kfu7WsyD0aFHf98HdFP6maVcF+N/3HHmTtQhI/z9dhUUFEut7ofT95f9E7?=
 =?us-ascii?Q?fNOmT+8NK2CFdO1z6bwZ/kmR+KmMaLBc/dmADx8H8Hla4Oss5t6rTGugBAY8?=
 =?us-ascii?Q?VfLlt8D4QIzwkDEZeCBchSRNTYmRbihyDuPrsE4w7AMCC4pyLDh+APc0fFEJ?=
 =?us-ascii?Q?WVCTLzbC6ln5oSGVRafU2zLRTdoQudK4joAIuqLXFvcwcgS/Rj4ODzLRq4Nu?=
 =?us-ascii?Q?h1i9osoyU2v0/H75VH4SHOAKnKyHNnArZBTBMPjYaENrCi94VSLnApcNsXpd?=
 =?us-ascii?Q?F4+I7qHo95HNft+Oa7B7rFC9paX9BwIGVuRwc9+cImzurzIw6FAnzFL/oV06?=
 =?us-ascii?Q?BYd8zFbsKDeeUlPt5QKF44WIbk9U6nAy6mtGFMLIB7DzWAB87yd3VIQO6iKo?=
 =?us-ascii?Q?4nmWsTUmYJjlBPwo9rCTVjTgAlubda59YhpN+265tMlcCi0Hjypb6Wv7gzIf?=
 =?us-ascii?Q?2iTGRUsrgh7o3GuiTa2j8M1qcMxe9gR3XvNCYjSMuqFRpyLOZPL5DopqGZ0y?=
 =?us-ascii?Q?+hHMCTENbX9jWwMFZYXZELMy0lT8t5PoiM7sLmx5A29wtlsZ3pUjuhYlgsw7?=
 =?us-ascii?Q?vN7Z7kjJg8NnluUE8LwQuj455F6ZUMpBmM8eUtZDZL5h2FfixWGHgCCbSrFI?=
 =?us-ascii?Q?BnrlXXXlmb8WDUHlXxthLlqYxuJPHOg8ujxZPnhVkuS9xYDnALc66v3TBKRR?=
 =?us-ascii?Q?wwb9XuNFY9Gb8gvVMQXIvNVxgELTaLpTghlZxhWx24GX2qjcDzoAmOuRrGgu?=
 =?us-ascii?Q?Vf8Fi13tfeU7h+P/c2nx5kW6mk6CDGFb5soJKpTpaVk1CV6lrl1gYW9/Uxp7?=
 =?us-ascii?Q?IQPNCzJEnEtiwcOvcI26+SkpRk7ylWSiqfcivGgPsksLcg+/FViykne2utj2?=
 =?us-ascii?Q?uy9FOAp8n3Wu9/8udTMYBOwyAJoMHOlw2wZYQqxMnO5yHAaCKzaFXLBqgEfB?=
 =?us-ascii?Q?P+AmBU6wq8Kf51EoBH32rmmOqnU5h9bEOOV0VtOTeMx/exlo5IPjnY9mSPw6?=
 =?us-ascii?Q?+Bir7xjnw1SzTDPtNesVdW90u9p63daT6Semvu8fw9ic98F5LfceKR8GRLBm?=
 =?us-ascii?Q?vQlyigAqWfVgdNLYIM3AVBKHBY9uEj4uSbq4nHVtxVhJ3OQKo7T25IFOuih9?=
 =?us-ascii?Q?fmV3MCUBMOWqhfDSCOHi1ymUUaPlagXHnZylWngc5WeQrc5Z85cufLKlZAS9?=
 =?us-ascii?Q?BuyzyOYc83Icc4VHkMnAfAneDf5SkmoLAMKiNslbpeRUU0vb35kUzfiZaJF/?=
 =?us-ascii?Q?5A2KFizNcgZvDO5qWbXMgddey+KT6MqbYfnOVkxisHFwKGV1RIgTcKB8Hx4k?=
 =?us-ascii?Q?hoyNCSsP3zveQbwKDz9Oc9PBhqC87OvNaG/Hc0QIctz6pbYu+PzLPHRvo9iS?=
 =?us-ascii?Q?l4e/6FvC4GUMrZXXQlj/e5c4O/L3JHmTzbvwBEwIEJaZULgnecscHVpTMARF?=
 =?us-ascii?Q?aTsmNWoJJ/8MJOj8SW+nUcZRgZ3XZclo6MipIyT/+mKKH7fUs7NmLqcFNqzg?=
 =?us-ascii?Q?cudzBEw8SXm8W4MA2jQROurxAaw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b25f90b-e8b9-4613-619f-08d9fd92da14
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 03:55:41.7019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ehz7/WRZ22y8Hc74ns5UXXIYAKSP6ywl+pbSGZVEDGj2unFzd5gTJaMvQMyTzdfT4TXezU2lIDfaJ5wFdCAkOPLSo05RWvVBDeGO/7BSh9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3508
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=953 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040015
X-Proofpoint-GUID: HEZ6Q9fkTTnUxilGDsMaW3XMkKexT40q
X-Proofpoint-ORIG-GUID: HEZ6Q9fkTTnUxilGDsMaW3XMkKexT40q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

>> +	if (mode == SD_LBP_DEFAULT && !sdkp->provisioning_override) {
>
> Hmm ... is provisioning_override ever true for the SD_LBP_DEFAULT
> mode? If not, can "&& !sdkp->provisioning_override" be left out?

The two *_override variables are used to prevent subsequent revalidates
from clobbering the mode configured by the user.

I experimented with various approaches for this, including having a
separate SD_LBP_ mode for revalidate, using first_scan, etc. In the end
I felt that the boolean was the best approach to capturing the fact that
the currently active mode was explicitly configured by the user.

Open to suggestions.

-- 
Martin K. Petersen	Oracle Linux Engineering
