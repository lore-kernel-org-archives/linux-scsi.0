Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555C8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B2160FED
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJUDg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:36:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49906 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229817AbhJUDg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:36:26 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L24luA008005;
        Thu, 21 Oct 2021 03:34:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=5oEf3UXPfNZ2BQGDQ5OLBuILMU0EM1HYRwIINw3vLdE=;
 b=DiUJcKxKl1+4Ie1HeFYQMuqoPMDjpqq6D8kB2vJOGiI+5rBYukDI9gdqGoXQgMlNVdb7
 +BuepODwQHENlUBnAsc2j+uClBadROinc8rsh1YHENmYG8QniV2vpm0/afrpDy5KPf3I
 MH9Xom6XWGRRTRwe0Q0PBNog++h2cdq56R8mpDy2Pmnr07k3dwEw2s8IbsnmExqAYQM3
 G9/DHLhf/iTpd+FYh2+sLo3wCLfM1k4YfO9JwMbqBEGSRV0eZW2G/iH8N0bbmeVn37M6
 SlMKhx+xiikMWZ1lv/TlaXfUFwO3DlqPo590+nXehaliD8u7ran9tJpAhT+3YYUTPaAW 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqp2jhcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:34:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3LC1c144971;
        Thu, 21 Oct 2021 03:34:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 3bqpj82qk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:34:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGRyIrdeBcoNm1SCbUnWn2S/6D1HsiFkGcRdF0tRPeNt+wNW8NaDc3SZPED2nLSTLorfvVeq0DK+3KFFGKMjXeaBcIFtc/f44PlskhtyNhfm265I8Qoog/vpl420pbMtb4hTmkKYSuUXYNxZkZjRsEhVHRXV8FpG4+xUHJmmmvE5fbBHzqkARbv6hp9X/956sMKg6FT5W3TzEKopIzqiU281K4WXySxZS8FEezwuArUqHcJcT5YV+JLcczHdr6O+ZXbS7oTIQlKoLTUpwY7gRWynKHyinflF+KEpfAxW2EsOhoLnUA6WBuSYtcY8hj34GijzY7JSqgbwJ8KA6hgDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oEf3UXPfNZ2BQGDQ5OLBuILMU0EM1HYRwIINw3vLdE=;
 b=nOEFLs291ikPWfruo9OJDn4JOd4P8qeQ+rQCa79Ehb3qP8FpWCLrIpHUDaOBZdlai2DKdJSek1/lj6fb0FbidCeIFRaIpSNjKfxWSWVXkGhJ1tkZxKXSZXvsHE1iS1fAKsCKGiE6PCNKGJ0hq9rmbwQVsC7LfkUqSCKgcuDniFK2wg6UlM0rG8TtOAFp9qtYjdxv91pBXP6JwYu2jfdzgsJ5uah8I0vazXgIVeydddWkR+GmJ7a7JU9mQFUGKIeq8akCBdMJ0FLC28C6OBCWn6HWGrWvFhSv2nst02yj/QZdE9F+iWbNJ5sNAiNRy4tBVy8hL5Q9bN9ALU58mHgkzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oEf3UXPfNZ2BQGDQ5OLBuILMU0EM1HYRwIINw3vLdE=;
 b=EFRcuoKXuM802fs3b75hEFIbNP2qjZ2UFk4422qZETBqe80yf5bGe1iWfjVDMrNwanf7at473uWltyZiBRm30DKwg+NCdcknPYH5R3MoU3gxPSXrIuoU8FgBDZfSiTDuBtQZYWRdqyN+Anc15k5gIH/InXDf3XyFcB0/A4T5lOs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5707.namprd10.prod.outlook.com (2603:10b6:510:149::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 03:34:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 03:34:08 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/8] lpfc: Update lpfc to revision 14.0.0.3
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0i76ogs.fsf@ca-mkp.ca.oracle.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
Date:   Wed, 20 Oct 2021 23:34:06 -0400
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 20 Oct 2021 14:14:09 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:a03:334::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by SJ0PR05CA0096.namprd05.prod.outlook.com (2603:10b6:a03:334::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.11 via Frontend Transport; Thu, 21 Oct 2021 03:34:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a88c9940-cdaf-4960-a78a-08d99443a3bc
X-MS-TrafficTypeDiagnostic: PH0PR10MB5707:
X-Microsoft-Antispam-PRVS: <PH0PR10MB57071C8B743F798875FADA698EBF9@PH0PR10MB5707.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHa6gYeg3MTLbMPA6/eCZgksqTUsjNeUt9grZwCN+Ybk6P41BiFHBTHXuN9w7me2jRPypVqq56zYoxb9BxsHFq0zbHaHVa+FACUp0jOLWkFzRERKEj8aPFpkEP7LuxD45/KdGsRQGtnPsDS/kzx7BUa57OE0Z8GPm76ymhSmwmtXr2RyqGisE9Wl232HreIuZtcOfRHDmLijC2oxATOwRM5AWXKn4RVITjDMeuw5u06qNegGhU+AK6ckDruHMzetxy45G88GWLgRxwj1vaFWY0Z32DiNxhJrbZgV30pgvXkdLfDbdsSOXyX47w7L0bzIhhjIo9+6qpDqZtJlTUM458iX5uVty5Xa0mWd24x8b40oJW/I0wR9GNmuMM+DMtOYuuBWqf9UhIK7LyprxKaLWKIlNgTQjtcBWF2SArZwJY+nkuk1Lme4YNT+vz3g478VUCo/FSDzxamLxHC0UzRQvwy3648E5JoB2qQsv7J/5oaOc9wPDMnZHJztONQExGi5uyXEP9/k/0xudXhOJgdUKk6H91NgXj8PSoDkbe4RSI9pscBqidwn4JBXjZDUdnKK4qkaKt17VkdM9GzNo1ZnXuT95iq1CGrkA3tJYKSPh1kFq3Ib7XFRcMWwygoB8RKbFdhqU+MnVBJJHi85uZRO1cVsQJpbtY7f2jNGolRYLo+Cy4KZMRhh5eOLhp8FjzjjZGeSrJc6R57E9zdtN5/UNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(66556008)(52116002)(66476007)(55016002)(36916002)(38100700002)(38350700002)(5660300002)(7696005)(8676002)(186003)(4326008)(956004)(15650500001)(558084003)(83380400001)(316002)(8936002)(26005)(66946007)(508600001)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nbvgn9Nb2V5C9EWRUKw+U1WBPBrV6DInULgl9pn8MlBUt04Vd4eFxusI7kJS?=
 =?us-ascii?Q?WFWcZrAUk6nsvtzxCSes0R9yloFSVc/zF5jfy2e3h9vfvhh4l02MN5uX9wFV?=
 =?us-ascii?Q?Q9j3N1/pjRl1kqt+tA+StzF7lcHcNbz5i7QVwldMkMKQgflS0ktcG9NivfUh?=
 =?us-ascii?Q?UzmS9s+9sC7XvTKPlBBm7y1YkA7jbYu/FmojAp06ttwc1quf+MA7hCyoIij0?=
 =?us-ascii?Q?/CAffVpJwpP2enVhIkhqlBr45cVvkRkTGhTQhmZ7IdS+p6v920w3/zQwEG5u?=
 =?us-ascii?Q?tdFed+WllyhcwjZCe7lKekPJk4LkLYvITjceP/Z2P+MLD0Fm3pHVRhsfUmRm?=
 =?us-ascii?Q?gG2oaul6VAn3OHfEJdT/wsWcUNUha56zwHVG2BnbsGh1OmX2UPt6OjaL0hni?=
 =?us-ascii?Q?rri8ra0grU5UQxC0oAk9DwWheQ44+nXKCVPbVYMxAETreajOD2T5Fq3rzj9W?=
 =?us-ascii?Q?IHPuBMSDTZ3JR9u6s1KcPRY9cQIv32PqkTC7V4Z6yp+VSL+VwCX/v9ESyd98?=
 =?us-ascii?Q?BaElKPyWjKwz9NCaZgTQFMo6aZj7OwI6iCniux8GRVc3EjAnBy5thJQw5Wzq?=
 =?us-ascii?Q?elZNNKszkszf3+Xi6XMs4/MiZoyN/N1sOMTZ8tmvMZt3q5978gRXNsUowJJJ?=
 =?us-ascii?Q?nbtJPrxKE66Oh+8+w1QESUlqSOX34koEa3kBuhXRXLGEhXDr1ZZD7A6ZRTK4?=
 =?us-ascii?Q?x5aF1JWdICQmAThjey29Ef+xgbQeaxIAxTALEbt5Ur5qkURxJy0E7x4P8IyZ?=
 =?us-ascii?Q?PFBt8WSj+6HP5TR79QDlh2bNo92YlG/OXk0Cyesb7R7AvgHzdveOOs0RTxXI?=
 =?us-ascii?Q?ZHowa2MqwYaOMAkxDw9C4GAL3NEjyv2sGBGrjf7jsKnktvdOqM8MLCtJNg2l?=
 =?us-ascii?Q?ftAvlTcR3WFo05OY3mBTd0sSllpRyWifysNmq7QlKVSZMWLvpeAflsENmUNn?=
 =?us-ascii?Q?tsMUG9VVf5uYZ8AM5+jEDoWDOzQgEHSsgpxpI7foxvxj+cbgvMhpWuSVzzXK?=
 =?us-ascii?Q?7c9Q9TAGQCJ/Wfr69SNQ0bFKc+mIuedim2i/SPSlG+lMZ4dDZ+tHs6iVydhO?=
 =?us-ascii?Q?GDluGziK5hwSY3Fn1oMoVZ/iPOqJ8aMZ02TEjzMRr3WoOXUPwoQGm8PjIlLL?=
 =?us-ascii?Q?Vo3fqnvKJCVgHlxxZwKxqlIzDOerAnKLdGuA4s0aPSeemN6NdHpYcz/pNC/+?=
 =?us-ascii?Q?NK5Yat6OYYR+5Nbe7xsnigR1PuAhsg+e+EQ71HJHxK7N15FHi0SONj/VmLZa?=
 =?us-ascii?Q?z8xnr833uM2pN1i15NnJJmbSsNZ1aRD+TmZHUYXQpTXpsBOHhEw0th1oqOGT?=
 =?us-ascii?Q?CIhotUmT6yAlXoot6GaZoZOtWu5PCG88rHz+e3qZtNzswWdDMyN7L42Kn4EY?=
 =?us-ascii?Q?p16wG+v6u47g6wQwC/ZWMH7TBXh86I9f5s5pcAIrveuDNUk9SAkJ9ZYRa5qO?=
 =?us-ascii?Q?g3OurLjysw/CeuHmOnvikx/+GAIOBzKz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88c9940-cdaf-4960-a78a-08d99443a3bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 03:34:08.2058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: martin.petersen@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5707
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=812 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210012
X-Proofpoint-ORIG-GUID: N0uPN8QHTH_09w4wwrcujOzpKS4H8eZa
X-Proofpoint-GUID: N0uPN8QHTH_09w4wwrcujOzpKS4H8eZa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.0.0.3

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
