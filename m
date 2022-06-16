Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AECC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 16:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377534AbiFPQJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 12:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiFPQJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 12:09:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B333443E7
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 09:09:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GFqajB029748;
        Thu, 16 Jun 2022 16:09:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LpNyaKsx1wno1rGnpfL2QHr1cyI+mg8FS9IsKEBPAgg=;
 b=oHTgl/k3ZHeSAGgTkuBWHpyxkLJkVs2XM9UlvePIRxertfg4ma/TFmWfPeSX9p8My0pp
 Sda3EuIyNc0YdPsw2cPvZOVcus3oR/TJQyzc0hal17sXJuCUZiSM/COM7ZS7wjm9qJaj
 gfRno+Hq0DyF9kSWpJsSBdAIXt659aVvamac0AcEvmsqFdxu1VFf82ZgyB0plp7UQTEK
 TmLh/RAmNnMHy0ztB8KDuVgAu5MNB1wu9k8SrzBvRUJdIxAhtnM+J+zNAY7dr4kmrLdV
 xNr1eDIIX0uMmapMk4pj9jkhJ6xMnmY04h646SvtMesoMD3w6VvhGCVYXyI7ZLqKMCpg wQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx9kfjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 16:09:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GG5fn4010291;
        Thu, 16 Jun 2022 16:09:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwc6yur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 16:09:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLnOg5a6ZTE+8bmIuvnsCB6qARttqavVa9FvjQG4TxEQfrzLE4C2L3XLJVHjYW824O5Dud5P4nbtscXVfhewP0XQHVvJG8W5NEgOxUDLQdDruj48JpCSrC1twB18c0qGrMhiqy2VOlGl6WrYmNg4/KybW490xAl+QJLdL7iGGX4CchVVA7DMAtFsrdArn0zTvSg51/9OsCl1YkfZ3eP9Edf2Eu8yHCevMuy21Uftr1S0mw61waajkmLzcha9qeAW0gsdNedlLwEawoztfRn+BJHwunxSPji6dySgBsWzwX0aW8L4HL0IiYlO8Y+x70df96TbKNo94gX+u3gMk5aMkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpNyaKsx1wno1rGnpfL2QHr1cyI+mg8FS9IsKEBPAgg=;
 b=dL9TPNl5kCPwN6Gj5E4ksbvG1bD9O4JFlEzZlrex90dVuWYz348YXJKxgADvSIlkrYwbApXC9bZsRF9Pn2USGs+oYxPHEibPPLblpvTBUETqEnLpshvNMS+qQLDg37bLafA1LUUmytn6QtBJIyUBnbdoF+QXWHmT1HsGudwVUrEq7nssA5Uw8mw84vhhwbLo8ZoPS9cke1ENi4ea0eYOB7g9qv9OJSwI1UHxUV+9/vurjMu4RR0fgcu8l9asunOS3xgfLRHqOsnhxniIZiHfgCJfpQu45kinTOwS16n0/Orps/D5iVjxQFzBCx3jod9kqnkuh4bNAc1Sydgzc7xYYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpNyaKsx1wno1rGnpfL2QHr1cyI+mg8FS9IsKEBPAgg=;
 b=DostSZV040mYD/f3mxOpGix/GHokZAb4H7187su0G+lRYN5x1aGMirgitGD7pwR9doQ0bQlM6btuAc1gSHX1EccxrEje7Mvm3k8sPnvxfsirRASTI2MKnj/sjy7PaMoV55px+Dmmou7uLArtlrrEc5bTC4kMAiKNYZCE4mkX9xg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 16:09:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 16:09:39 +0000
Message-ID: <bdb0bcd5-2558-bc44-7037-107effcdca08@oracle.com>
Date:   Thu, 16 Jun 2022 11:09:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/1] scsi: iscsi: Make iscsi_unregister_transport() return
 void
Content-Language: en-US
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20220616080210.18531-1-mgurtovoy@nvidia.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220616080210.18531-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0226.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0753cac9-c46c-469f-f728-08da4fb29d99
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB584829DD332A3E5B90B7B449F1AC9@PH0PR10MB5848.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 71jmFv0c9hsmKsCS6+pTGdSwx9aK0i64cByYre5KnnzseuZNTHuCCIbS/71uXh1bBJOM86BdJsGD4cSL+VCt6e6bLZLBrwH0+48EJQ8igPBss3BG5EjNCDkHy3mR0neRUK7sfbef8N84HGH2VZsGu97A2aPWHNiSeUwxcJjWGCElZXsGmOmdzzKC7BrdR32L7OWjwoYLvXZOgTfwQ9PRE48uujY1dVeCTbL0iAgV0CjsjkvDOUAkGeWyL6ba+M5RzVfj7t55pJvAj12bJilcKgIJS05KcKgd3NF2wGRMYi6qZbRI0jYpRdusObywmPSFtDWZyn0ucFpNNEd+gXicWjh7VHgbAdpwV6rEemG0YHJVxpaLjy+sM+3dnzlWIvJRK3aaAvhYQ08LO48KfyGmbO9uJSCRR8hiBwjkOgvgKGHKDc+RQIwpOJ34Hr1z8E3k+1yg90lcQppi4n/MLdbJ059+KCIWHFaZWS6WNJA06arQbE7ZyxNDmHJvpoYZApKJfvXxVUtoTnUrvyid643GRHusLbO91nS9rp2XFYpV9cm99yZSqnVgLNcyEKoe9+jKBlVrfraps2ecwKLCgLflRA+5wKJ8WkVXKDbKJCSdSjK/2zd2ww4XeO/F7JZcbVIWqzVpZ/rX245LhCRHIavfiltSrCkNS8fMF4QPAsXoapGPrD8CC92ezvDwWFHUyVOq8ZucNLK5uqSGa/yobZQuvA12P6X/mTyei2YDTmwFmQ+DQ6Mcs55GnQVU4nYENznb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(186003)(38100700002)(66946007)(31696002)(2616005)(2906002)(8676002)(66556008)(86362001)(31686004)(36756003)(316002)(6486002)(5660300002)(53546011)(498600001)(26005)(558084003)(8936002)(6512007)(6506007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnBSWEtMc1F5VWMrcGIrYWQwYlJIbVhOYW5JVGJ2dVRoTXRHWElaQjNCYndO?=
 =?utf-8?B?czhJcVl6eFdtc29wbEpzekNxSHlVZkhYN0ZKb1plMEJ3QTd1SUszSUxhandJ?=
 =?utf-8?B?TnhpQ2k2WVVvdmI2ZCtRcElOZmFVaVIzNVBQbExaWEEySVYvRGxqaURWY0Mr?=
 =?utf-8?B?ZnR5S0prWG83Sm1xOTBpNll0bjkxU25wNHgvVW9ITXNFZWZyVXF2bEVLQUh1?=
 =?utf-8?B?ajNFakdTTU9ZOUd2UysrWFpPUHZCRVF4Sm8xUGxONTJTNHdBVE1JVHdEWmhv?=
 =?utf-8?B?cmlEaGxWTUZISXd3SWhFclppZ2Z3dG9uaU9tRmlKb1k1NnFMMjk0TnRpWWZn?=
 =?utf-8?B?RXJkQnZnYzFZWHJTb3hhWnViRXdPc1A2SU45ejlsMTBQUmNhNVQ5RTI0Rkl3?=
 =?utf-8?B?bUZRTDNUZ01IQVZFWGZieEN2SGtXV3pjdUEzdHk1bDd0aGFZeUNsMUhzWk9P?=
 =?utf-8?B?bkZyQkhsbGRpNERSUFRxMDdaRWk5T1Z1eWNjN0oyazRNT0JNYXcxTTVaL2R2?=
 =?utf-8?B?REdpNy82Q1FjbEg2dnIyUEZtN0d0WkV2enBRTFRPTjJZQ3JnakdvazdQU3pI?=
 =?utf-8?B?SDh5eUp1dFFyVHIweS9qTWtrTzhnNGxVVHA2b3VPRlBOQlE3R1RwVGlTcFBy?=
 =?utf-8?B?MTJJV2syb3pQWTQ4aXl2eGlUcElVUDJIeENIeWI4UGpxMG1yc1pOVEJ6S1Ro?=
 =?utf-8?B?N1A3WU41dXRzWTgzOWdYWG5TYW54WTIrUW9hdVFJWTU1M0h6aSt3K2FqaGgv?=
 =?utf-8?B?MThrRGdiTWVMaVNiUWpSVHk0NU8zdDczQk9jdlFUSlVCR1JmZ0FIL29ZNzRN?=
 =?utf-8?B?K2c2cHg2Y1NzVkUyeDF0RTg2MWxDUTZibE5XRmxhSUtXMlRTRG9LMHV0Q20r?=
 =?utf-8?B?VHVudks2UW9rdVhYWGFBUEVZRERybTdMSFc0aEZueDUwQks1dE5TVkw1RnYz?=
 =?utf-8?B?OHlCcW12WTBIZWFZWWlMU3kxVUcvcmlZQWJyR2xRV3Y3SHNqT3ZNUGlwZWxs?=
 =?utf-8?B?b08wUzc1c2E5ZlgvMC80MTBLeWdBOXRjc0E0azd4WEhnWitWeVFzdVZ2YkxT?=
 =?utf-8?B?bTZMM1lXbU5PYVowWTRRUHZaZDRyYUVVVDJiaGlvNTdTbWZhNFVTZnErUkgw?=
 =?utf-8?B?R1JqNTArWHNvaDBFOEJNOWxENVM4WVF3Y0JmRTZvbUdVbForcUVHNzg5Ui9t?=
 =?utf-8?B?VHRPb3BHOG82ZlVOUXlZOFBwRVVHRlUxZ0xSKzVKUnQ3L3VUQTFGYzg3dm55?=
 =?utf-8?B?bEhuS2lJT2ZLWmh2bTFCVnVvNVRKVnh4cnV4T1RISWY4cmVwTVFtLzVUVSto?=
 =?utf-8?B?WnBuM0Z3TjkydG0rZ1dLTEtTL3lybklMZERZOGtPR29TZG9SbSt1RmVXalp6?=
 =?utf-8?B?S0s4SHp3QmJ6NEdGVlBhUjBWUksvKzh1OWt6bWVqT0J1eGNyR0hzRER1VzJz?=
 =?utf-8?B?YkRZS2pCNVFxMHJFa2FxUXVoOVdjVjh1YWFVZUwwY2FBMTJUWEVjZlhmN1Q0?=
 =?utf-8?B?Z0lWZ3hQZGE1T0tMNWg1dGJ4VW9kaVR6S0ZvM3VSN1FTNnhJYXRMZXhseXQ5?=
 =?utf-8?B?bjhqSWxPN0l4TDNVWWhIWCtlU0pJZFg1ay9hL2JDTE5SZHdseFB0ZkhWSjh0?=
 =?utf-8?B?UkY4alZCcUEzTUhEWWRRSHVEYm5pMVB1WWkzb1pCVEtGTytDbkpDV2J2ZmRv?=
 =?utf-8?B?YnRtTE1reTV6NDM3YUJMOFNyeHZ1R3kwN055aGhBWlJmYjRQK25ibHI5SFhV?=
 =?utf-8?B?czV0QjF5R3FFV2haWGIwOEtKbmFicjkzek1uYnhiWVozQUkzOHM5WUwzWVNz?=
 =?utf-8?B?c041ZmFDcTB6aGpPS1p3cXVRdWxXWW5JUUovMWd6K240SlRhbmxzeHU3T1lJ?=
 =?utf-8?B?bjFpeUpjdmc4NUE3R3R0Zno1QzJnNi9MVkw3Zi9iZzdoZmJIdGdCTlNGb2Yw?=
 =?utf-8?B?MERva1QrdjZYcjNWUisrQjYwSlg0cWIzQkx1WkMybUs5Zm9aTFNoL04wM2Iv?=
 =?utf-8?B?bmFTblpSWjRjRnlWUEliZTZleUdjMnFPN1QyQzI2N1FtZ0wzb2dIYnMxcXlX?=
 =?utf-8?B?MU1DbUlJb21TcGlOY2F4ZmJXY0RSLythVVk5aFhkN1FDdzlrK0xvdEZaaTNX?=
 =?utf-8?B?eGxIS0NDS2JzVW5xWlNFME10OEkxRjNJZ2VBTXRFWjUzS2owdS9STjRGOTRk?=
 =?utf-8?B?ZFB3ZzJDRGJqYUdZMnEzTXNkWXlqNzQvUElnTkVBUEFpWUxFZkIxZmd4MHA5?=
 =?utf-8?B?cHM2cmlCbkY0bGFnTlBUSTFnbUY5RXViaUdEbzh4T3pjQmhhNGh1V2xUbGhZ?=
 =?utf-8?B?YlVNbEgvWDVoN0J4UjZiKzVGc2VPUUtYOElOYnV2TGtCNFlETjRwR1ZVTmw0?=
 =?utf-8?Q?6/bf+1IAegasrCN8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0753cac9-c46c-469f-f728-08da4fb29d99
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 16:09:39.4170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOpIyll62Iz0n1mcNAIjKt0K4ylCUDkOFCKdYmCDWA8OD41D54ZMPi4rb6JvEO5Qzne8Edr4gHURvlQ1T7itZd+LewOOxw5UrKHdM0N1vMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_11:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160067
X-Proofpoint-ORIG-GUID: G3kr9fSPiMphjtVOPyfUeglDmRNfFep2
X-Proofpoint-GUID: G3kr9fSPiMphjtVOPyfUeglDmRNfFep2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/22 3:02 AM, Max Gurtovoy wrote:
> This function always returns 0. We can make it return void to simplify
> the code. Also, no caller ever checks the return value of this function.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
