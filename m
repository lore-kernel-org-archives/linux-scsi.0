Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76EEEB64DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 13:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjGRNZi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjGRNZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 09:25:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A828F0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 06:25:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ID7mCJ027462;
        Tue, 18 Jul 2023 13:25:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=CLcjjjvF8IQ0WuP/tVl8sbeB68e7VBwOqOAZFRjLe1o=;
 b=SGOzhnbJ0csx8Z/RNVw5UV6qH222yfSW0kq1fYG5S+rLdvCDP9V5YLq3tFnsaFBCAI//
 i1Qi4AUrJEBJWFItAr5zdWXPcPcFkB1ts/QCpqr6wZh1qSg2A51WK+UKfXuNLCKBy7lJ
 VNMlLQeKMoih05WyfA8qtOWRJ77wT/7Q1C6L3UrqEKPrkW8epxCPGBX6FESLf5uWS2mr
 b72Tz9gBAtdGS1flQ3MH9DdfUqSCuhbVhGXEe/xaOFQqvu3uXnY9ZWZia8ULzYTdQ2hP
 oUWPJjYdgIO+4GrjWl662uHUMO5WoGgEOa1L3Hfpkio4YWcjwgBrPHJ14bLBbFPR+56+ XQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run7850sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:25:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ICSfWa000867;
        Tue, 18 Jul 2023 13:25:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw53gb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:25:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YC0X7cSHBvst66O4UUDSKi91DNyFuGBh/gumH/HVxU5c5u1/b5liKFwi5SzsUPzjkZjGrlQhmtCJxSzsDqUvFxaanDR6yQTcRwG4d20SvwO8juD5Pz4EDAgfXJI1NCICOe/FZ+1n8/kMqjejMtv5qnf1oKLA6j84Vwmjs0tpR74w5VtUStYntjV0NS364mm8H6pBJIAR6Qn/4ZsU2gb9pUYVW9BrOs9I1vVQF4yQ1Z3dfGYViedFq7R6TUPz0x/U4K8rKE3gId2MlvPioK6upRKby/xKkGT9kW0UNT0JLMnLAOIa6knFxn9Y5Y/EOP0pKSJoUmcf1SdeGPDtnPhL7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLcjjjvF8IQ0WuP/tVl8sbeB68e7VBwOqOAZFRjLe1o=;
 b=leZrHlR6upiLGhFx01yA8lkassOQKH/im4h58YAG+y++Fe1v4llJAGUwDL5udvOBOEggnlK+Rhdm6NQto7oAahVPEylSMOAIfCUzHb4a06TDa4/3y0du8T/dCGMQqHY6JVou79vg74h7y4Ir46vrmAIJ+3T9IMDlb45ICEAxlrx+unZZELGKQEkiQUWMfmstx6DPRAJhIyso7HFwUpEAPiKobRUpUIsdcs+UwFKzuPMo8tkMEqGBVfHSV7CDcKpfSyZ3wkqGTDGLWHv7EyNhIhb3U9+EX4khB4aaNk7P1ANonPKsAu0r7VovVqf+Rv9rx3rmHbSodmFxll+zxvm00g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLcjjjvF8IQ0WuP/tVl8sbeB68e7VBwOqOAZFRjLe1o=;
 b=Vmg7wLYNTV8G3VqMARvztvMJsE8dvrI4BEFQsde6tYlBCxsMabFWsZThwl9VuxxDGdjkGLBWoViXR9n7PjIpdTcv8k+mWkjirlXbrtlgYTqGGDx3wAp+WCQmBceUvgjZgMZz29psbQ4JGULBnhA+2r+L6TSeehZU/fIKIkNkEZg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.23; Tue, 18 Jul
 2023 13:25:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 13:25:17 +0000
Message-ID: <f0822be9-c4be-5e3a-c260-2a97999a0e3d@oracle.com>
Date:   Tue, 18 Jul 2023 14:25:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 13/33] scsi: rdac: Fix sshdr use
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-14-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-14-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0456.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4653:EE_
X-MS-Office365-Filtering-Correlation-Id: 038bc78e-ea51-41dc-d864-08db87926d2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ve17DjVO9521rL3KlmTCkRqX9R/SRU6D3b2MeEmjlg9E3OzIAZPdRBYcb67hfXicIkdfiglWy+Bbz2/6CZ96TxI+P5HE8GCx4BUNEaytAOn2v5sIwMrjJuhGsM5bqdByI43WvxJAPxe3PTV+lfzYjTGASTKB8a7xSNjQIa8DzEarbiXlLPsNT+NQjW5qIVtYpqvjDB7PpUyzYmLICE6rb/a6Z+Xyjxy3Y0Xl+K+Xw71ZH0GBILl3vKSmR5ppNU9rdc1J+fNAg3q7rneNMt37achulIL7BGW1Ny+Fm7EDi2w/XyaDRmJ/aZWmu1VADoRKU2Xl4448LVm+H+QoFyM8PNBuUFhWss5ofZHmwFLO9VDFHIQ9C5cg57UOZ1c/5upO4GjewcAcdMOT4E+S8vVxFaZ1TxIOLhRnDEdflBNs/sFP9LXk8PijLLtozJwF7iAh0RrMzt3/+MhidRiZfcCp8DXhXu8QZGhpPTVw2n+dIVQiKGdPn3zEqLWp9r1lkFDaV8KBpeUviE2YtoNq2haXa4IYzw6nbOVPwhQehAuNyWBquJRxsULe5KWmNcptRf7kvSHJSU/b1JEg2aqsvRBjV6yMcX1BzInjfI8zGBlt1GgFixpPZYhHdaj5sj7CPBzdHEeLhTXh8eHbCanhqVOLrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199021)(31686004)(36916002)(478600001)(6666004)(6512007)(6486002)(36756003)(86362001)(83380400001)(31696002)(2906002)(2616005)(66946007)(66556008)(66476007)(6506007)(186003)(26005)(53546011)(38100700002)(316002)(5660300002)(41300700001)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0ViZzlrZGlPemhrbEJVMFYyQjNzTTdxSnRIUGxKMndPRkIyY0ZyYy8zN1Jq?=
 =?utf-8?B?UlhFRHB0d01hRnc0L1Y5Nk41TXNSdzFJM0VhMlk0MkRaNG1mQW4waE5pZk1w?=
 =?utf-8?B?eVhaQkJ1bWRUN0czWDNQNi9hMWNxMVk3YnN4MHh6NUxITXVkNEFkMG05S0h5?=
 =?utf-8?B?RlphU3hra2FhS2t1cFZUTzJuNEdRVWpWL2xNczlkdmR3SjZaSXVuSUw5ODZC?=
 =?utf-8?B?THZTSDlaZ01BSGk2RFdrU3UrU2IvTXZKZ2RlOUYrUUI2V2trTHRyWDduTG5K?=
 =?utf-8?B?ZVZLUVFldThBUFpCb09Ja2tNWUJhKy85WVBHTzN0OHJYNkc5bDhkeExqQTNJ?=
 =?utf-8?B?bVk3QTRaQ0xPbFAzUjlkVlRvWk5ETXF1Unl4QTF0TWk1ejNjdmllUWhKam1t?=
 =?utf-8?B?NTVxdFZtZ1QyMVN0YVorMXdrSzNNcy8zcHZ4T1Z2K21KMlhCY2hxZXdrNlFM?=
 =?utf-8?B?SVVNTlYydVV1MjhFN3BEa3Q0Zzh1UUtJNDVvSEtMS2kwZEh0QlhmdzVaZFFC?=
 =?utf-8?B?MFVGUWRUdFB6M0VzT0lDL0ptU1dWNEsrMm5Nb2lMRGw4NnR5UytpZHFVc3Vs?=
 =?utf-8?B?S1JrbXR2MkVxakwyeTVZa3dNNGRKMzdtcnMyWS9OL0tkMVVsd2ZNSllvdUdG?=
 =?utf-8?B?NG16UlUzaGhFbFl1OFlOYTNIQk85d1lFVkk3N2dCaVcydTI1VU42TjFicHFm?=
 =?utf-8?B?NHJIUHM3N0lrR3dEd1BsQ2M0U0Q3b21xMkdobTlJQmgyMi9HeEkzT3g1OUtZ?=
 =?utf-8?B?OEhKODBrY1l6RTV5TkxYY2w3a0x6Q0cyUmQ4Z0c0UURTWGo5VFRxcS9Zdzds?=
 =?utf-8?B?Tk43WnNZUUlCUUtnT2tlekhsUUtUVDFIUGpKSkhzaC9wZ2hTVVM0TFVCdUs5?=
 =?utf-8?B?a3NpWkxVMWhmMi9BS1lXOE9iNmtrQmdlZmdLUEFIQmhaMW0wRE50YjBGdFBm?=
 =?utf-8?B?ZzZtMjl3aU1GeXZWRVdtdVI4RG9OUlVJM0ZwWCtIOGVPVnlWQll2d0srZ2w2?=
 =?utf-8?B?ZkRnVXdYR2JGYzZUY21RajVnRC9salRSb2NHVWxqNkQrMXo4Q2ZSZmFmS1d0?=
 =?utf-8?B?MmhGVjU1MURwdkJwc0VtbFdLcTMyb3ZtNE56TEFHZS9mckRuTlVJU0k3Z1VZ?=
 =?utf-8?B?TXlkZlVuYVIwbHFLQU4veEhwRkRLcWRxbTNJMXNIZURscUU4ekZxemZDQldO?=
 =?utf-8?B?L1ByWWt0RUlMNWJFWlNGZ0I1SG9yenkxZkx3N1JBOFR1a3h1ZHRGUFFraTds?=
 =?utf-8?B?WXZSOWZuK0xMMTBod05QOFdrVVhsVDNKTGU1eFNiL0VwWVVFY3gvNkhoY1Ba?=
 =?utf-8?B?ZjA4UzZaZDYyQUVlZkpCMnlmbE8wV1NIZkJ4VUVVRFQxNVNjRWw5Q0ZiRlNW?=
 =?utf-8?B?WjVwd2pleUFsVDJ6Q2RqaVM3aUxjZjMvZDZzT0J5N3IweUFGT3dMdEltcm05?=
 =?utf-8?B?UUJpQzFYbW0rVmdPR1EwSFpYdnRDK2N4TXk0Z1AzOFVkNVkwaXJZNHBNNjRr?=
 =?utf-8?B?OVFrcmN3U2ZveUhFbDU1RitZc3luR0NiUEJ0THNWbjY4a3A1M3RuU2UrLzl5?=
 =?utf-8?B?S1lYcGt0UGNkTGZJVzdLa3k0T0JiTC9JWkp1eCtwN1lIOEtWMmF6eVk5YXhj?=
 =?utf-8?B?Wkx4S0YzazZBRXpxUWJrcndSZHNtc2NaUTBWVXF6bU5rS29tZUh4SlZyK21P?=
 =?utf-8?B?YWh3RnRxL3o0YkhsZXo1Zlg4WVNJZXFEUVg0dm5zaUlhK1o5TEpVbUhaYmFa?=
 =?utf-8?B?dGMyRVFaUm1WTHV2ZnVEUDlNM1BqWXMwU3pxOWNKa0NiR1dQcjh0MW9BbE5l?=
 =?utf-8?B?YzB3M1g1ZWhpM2o1NFp2Ni82ZmJvdjI1OWJUZm14WlhjbVpHczAyWmh6V095?=
 =?utf-8?B?OGVOTmkzMXRyVm92ZGhzdmk0QjRHUk9oNFdQdFFtVmFHRTZ2RnVpb3RUQ3dh?=
 =?utf-8?B?M0RGWWl6alNvYUJkQ1Q5STcvZHNEZlpFQ3NoVlRGMlpGS2YxQTJ5V1BjNDVN?=
 =?utf-8?B?UmJEa0lVamtBN1hnS1lVaWNSeWFzV1FhZlRHSHdxSkRQN0RkcHlYZWhGN2h3?=
 =?utf-8?B?SkZicFBKWEJTUzEwUXRUQTNwK25RRXkvRjNEQWd1dWJIdHY5d0o0MUNyUzhl?=
 =?utf-8?B?MlFjZzhrd1BKNFBHME1ZL2VYaElVWmdzNm53dnU5N1JvcHJ6aTBxRjl3WEls?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: v2zyhgQ/yIY6RkAftb6unjYm0yuCXzL9vPDSQUW4QpFZDOy+ltZmOhsQEP2LN9mdL/wa4//Cl4E4CiPH/HsSlJM15j+3MPRd+ZpyJiEF9plqYbl0r+rhEHJHe8+lNBqzfCevNHkNo/kQVhxlNZtTnm8XhduYqKuoUzRDJOCkEhyK21n4dIyhOfzb1CDhT7tjIZXQ9mix38aoWGZ3jYXP7dI5fUnZ5entgQOo/bmpZDggf07SGpnbg1kHRgvQrUwfrBiPoU6s0gYZoh6SMGYy6FIAsdg8K5cBIzBonKT4DExFuPo/MO61/4YDYCv9f5+o6Ka0/exzumEaWaZO8pVWXBHEeqpw0uWZACCmnCGExCzqnMH8qAlA850UPy/l8RLzeANu6l4Bwuw2wC0GpFk25cOtsGnvdMsi5jV2gjF+Tle5ukqiStnoKAW+WDZKwkTpsP7vF+Mj6kstshFmOZgT6m76N4oWi2s/YWdn1qHDCu8SRQlVAZ6mD2JNVx5/kitOw0vDPwoZi8y0FJXdV3IcEcvAAiVimqezV0wQ6nKOOTq0eeXvf6iTnT/jqBwhd1k6E77fD4BDp+8RR9ZoWytP7GMAQO0rDbEJowlGxPnwYptFvtaeieVnqW+cONnQGnfL/VkwCm48AnKLS16imuaWG+Bdk1RLuCTa8BqWQANjXD+vR5kd+coCyuxHAcnZPacsD4HHicTtwLmxftIvGjbDW0SxcK9YEGGGoXM5w/I39JzcJgGtV4DCOgdh1Qxj48rAOznibumO8K3qPy1ZyCV19edrZb5Ffysk7NRG0O4TiVtVDVkn4tUWfOQKoUJLC5p8kXpl9Vi+Nm5Ri4DSP2gLPlUy9dodMim8YqwGFhyFYdS/t8T5EA2v7hXgEF/lQt0E
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038bc78e-ea51-41dc-d864-08db87926d2d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 13:25:17.6183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmT2+uRVJl1FoGlLstrgZ77nZDZ4HSfA2I9s0DLqoSxkLcxDXWVWfX+xz/Of5n5rZtmi2/hosbSVlXXPuWKDEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_09,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180123
X-Proofpoint-ORIG-GUID: bR40b24nXCtOKAjF7OY0NojqWh2ERSAw
X-Proofpoint-GUID: bR40b24nXCtOKAjF7OY0NojqWh2ERSAw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:33, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. This has us access
> the sshdr when get a return value > 0.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> ---
>   drivers/scsi/device_handler/scsi_dh_rdac.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
> index c5538645057a..cdefaa9f614e 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -541,6 +541,7 @@ static void send_mode_select(struct work_struct *work)
>   	const struct scsi_exec_args exec_args = {
>   		.sshdr = &sshdr,
>   	};
> +	int rc;
>   
>   	spin_lock(&ctlr->ms_lock);
>   	list_splice_init(&ctlr->ms_head, &list);
> @@ -558,14 +559,18 @@ static void send_mode_select(struct work_struct *work)
>   		(char *) h->ctlr->array_name, h->ctlr->index,
>   		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
>   
> -	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
> -			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
> +	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
> +			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
> +	if (rc < 0) {
> +		err = SCSI_DH_IO;
> +	} else if (rc > 0) {
>   		err = mode_select_handle_sense(sdev, &sshdr);
>   		if (err == SCSI_DH_RETRY && retry_cnt--)
>   			goto retry;
>   		if (err == SCSI_DH_IMM_RETRY)
>   			goto retry;
>   	}
> +
>   	if (err == SCSI_DH_OK) {
As I see, err is initially set to SCSI_DH_OK when declared. Then if we 
need to retry and 2nd call to scsi_execute_cmd() passes, such that rc == 
0, then err still holds the old value. This seems same as pre-existing 
behaviour - is this proper?

Thanks,
John


