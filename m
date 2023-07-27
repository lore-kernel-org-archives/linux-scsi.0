Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC49FC00528
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 08:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjG0IHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 04:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbjG0IG5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 04:06:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAC749FA
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 01:03:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0u3bj011008;
        Thu, 27 Jul 2023 08:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=FvX7acno9wMwH0nlVtlx4IYLELJlDDCzZBBbZYV0DbLQ1f9ZnD+cTv3z6XU6kVtGjIVc
 1v0gseyQjqIVggmFyVWUO5zIsb7Kd/HFezvBD5b18B35ZWjgypHhp3gKCRzRf70PNV3t
 DmgInMN6VGIQvvJTeSopDv5Q6vzEjbVe1z3zJP6RSvgl3XwEJDhihUt4JvFb/WFvPvMl
 Fj2pNPYbuDq5oC1MNsWBuCID6olNlr2HPcj3h4r1oI+UqLnumdcJQlb2sJiFFsYtuT/W
 kKjtw/BXMTgcrfv6grWj7E2EVA9SvkmGJFutM0EaZE4uRqJiDj7kseijbBlG63sDqLDQ 4g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05q216nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:02:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R79qfF025412;
        Thu, 27 Jul 2023 08:02:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j7t3gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:02:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUdEGVwtN90osBHg1lDDTYTKDQ0Ic7wdbr5aM8XID0z95ynFH0FerB32GwBwrXA0+O08SMJf3HR9bP8uUnoafEYKMttP46jV/5KnPsqT/CZ94ku2WRCYyQwHvMyPUvTnlG0SDb6JqCAncxXPWYJuCMhOhDHI3PNZyZLUSCtZpD+AHLw03QOiA6aA6XKjhMol1aNF2D9rOWO3Mxxud3NofR9P/4lmQg1tBcj9UNEK+2jvF5aXUJQQdnXtGuq6dUQgLu0pkIjcFhoD4r6tUI/ofOk6QaRZVLiE7QAmslNCEO75+3RqHJk9kRF0AB2D9Kqdes+IX8DIotFumuvmMr0dCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=SOazGfYXU8FZT8ROdRlvH6mg35Nnf+y2ka0ihaeos0uXsDVuTLaNsNm0SY2keFZehFjwc3f5Rl40F792Beyf2g5h8rcaUQKS3SBVZNitJW9NGA8gJNKz10pOasvSp8+Dfcj/Tv8YC4d3acQCmk0U7GEh8koKvtl/QEDDNoKEHL0OF8iB+gkSpQqDJvrBZPiQq53e/ELLqL3LSMVFFsUK0iR9aO7DT1LQq8T0cY4NZB8BgjOv1wcSi+UP868JrTWnhJ5MueWjeuS+qpDUZT2zqC/rNMdrbRNgcI4c3wgnjEJan0A+PTpnG93C9ozma4Ls/gjImmzIrll6HYR41JR4wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=V1Qx6AOyskkuhjQtS6dPYEatOSJRzYQ9QJLzlQya8PRvF1FqogRDwMXVWAZF5avY4aEQo26c3L5aWzAlcAlE+YoBRFHcaMo4MUorZ16+V3PZ0FgzoleMrTPOKbgn5Jbgd7MypBRrSCeQ0X3SFyyYeaiX27gjA2d+hRVTrY16yvo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4839.namprd10.prod.outlook.com (2603:10b6:408:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 08:02:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 08:02:54 +0000
Message-ID: <76eebc7c-ef4d-ab8c-a45d-1e44d381335d@oracle.com>
Date:   Thu, 27 Jul 2023 09:02:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 29/33] scsi: Fix sshdr use in scsi_test_unit_ready
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-30-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-30-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0434.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: 946b6394-e6ed-4dac-7dc8-08db8e77e1c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kz2N6PXhifuiPV0U4is6FK5M18tYpWgGGGmTmT+uFrg7JnOjWwg0UjImcTM0yi9YkwxvLqVqUUBaDm9aqjBbEjzbHQjieHbbTCcsx1KUx0B1oUKX8Ox2jhoB/8iHQDt14SfoUyRcz4pfzKiPBJJqnkO25XGTEKCAvrCFdpVW5JkVpDvZDmH9YPUM9CSrUDCrpyHJZL+Omb1ep8QYEnFvsRJx7DR07HtXAgyIxmD3oEl+xFeD5UluRV323eNaqrE34L+1l2DP7wq9rt7fMtGvOshU1ZZWg5bb/F0rRkjT4ZUNwMm9CnNgLvaRA/r+EcktFA3ZWJAQVYbezBkn5uV9khChrv2BGiL1hSE7NUJR6iqgDY1/ab6WIHtDO93NaV14LKaPFYL6Hc9YcdrpJex1YWAnqXqw2Yv6ykZA087/ZyS3HDx/pY/aNi99/VCb5KmVH8BpUs2q/GwlsEvuPk0quTTITo6oGhjKsxGvb/YRpFXjQx3R9PP873fjtCIG/OO3OLQLkWCevBYu5d9K4Xhwgj1IG+FLODQKa6GL8pHkozYaJDeIAzx57cgBFvsXDNIAFAsC5fhpnoaMPx3iACfGTsVRJt3HSWzKBG4zUVdEK+captuFzVhZWMNkQhk46U2SUNwiDNd7GqG9Ir/3owRyyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(66476007)(6512007)(66946007)(41300700001)(66556008)(6666004)(6486002)(316002)(36916002)(38100700002)(2906002)(36756003)(478600001)(4744005)(2616005)(83380400001)(186003)(5660300002)(31686004)(8676002)(31696002)(8936002)(53546011)(6506007)(26005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVp0dnliODV1UVNQaVZCODRYekVCa0Fvd01wNVRKZGRGL0JnUTlXWnU0ZUhD?=
 =?utf-8?B?UloxcjJsWTlXWlZsOE9zNDZheHBySVdjcjF3Rzdia01IRGJQV3hiVHE1YS9Z?=
 =?utf-8?B?YTV3S1NJbXd6a3hhN3hrdnJJa015WVVOWmRzUTYvR1hwd2xtcGRGdGNZdWx6?=
 =?utf-8?B?b2RGSG9GWVphZkRpOUFvbEc1bmdydE1EMWxCMTBDNThoRS93ZFp4dFp3dllm?=
 =?utf-8?B?eERPV3lETXo4eVJNa21kemE0VTFwRzYxdExDbUc2RzdUYXVGTldISTl6RTBZ?=
 =?utf-8?B?aGVXQlA3Q01Sd041TXEyQWtLWTlUZUdJRkN1Q1hCU0Vid3RQU244UmRaU2to?=
 =?utf-8?B?NDlWOW9VOVZURWJNWERsSEZZMzNKMDJNeVZ4dTlhT3ByOXVIU2xka0JqV1o5?=
 =?utf-8?B?MHNHNW5pQ2J5MHM2VDJrbjhLMGFXT0FZenBGQVpvamRuWWF0TmdPZW1CZ1or?=
 =?utf-8?B?VlNRMmZIN05KSHNtYXRLS0Q1amNsMmdPREFtT3RsdFRha3h5dGEzdkE3OUZ2?=
 =?utf-8?B?R0VZTnhBYVBKWi80cU5YbHh0T2xDb3RiWmtVMVVSd09oNWdJemJPNlNoYnFV?=
 =?utf-8?B?eGhSMVV5STBQa2s4YW9rYTM3OGZjcEpwdU5EN29sL3F2Ymg1VExuc0FvMmVG?=
 =?utf-8?B?c3NvQ3ZPdnBRa2VnZm54ZjZlY0RXZ0xoRHlBQmgzMDRQaVFPa09nT3VNOEFP?=
 =?utf-8?B?RmZPc3BsQ0YrNVh6ZjNsazF6ZnByeW00N2JJak0vakh5ZFNIMjZGYjhLeXZQ?=
 =?utf-8?B?RE0ySkpzaCtNTFFBTGw3RTd5c0MxOHZ0MHpHOWFsU0VuNm85c2VOQkFWSlhJ?=
 =?utf-8?B?SXpqUjNnS1IrQi82TjZoTTFkVE9kMUVQYnNvSXNPaTloNWVlRkZxUUxsbnEz?=
 =?utf-8?B?R1hWL3FYM0VNaXl6eDZNL3kvRVJxQnFWcDFGemp5YmxlWVlaaGh0bWtxa1BC?=
 =?utf-8?B?dlFWcTlhM1BIUXRPU1FiZUplek96cjl5VDBvd0dZRm9UK1kxREl5UHMxYWhZ?=
 =?utf-8?B?dGl3RG9iK0c1bXFpVjJFODBDcy8yTTlKTkUzbVBnWXlBNWJVckRnYUl2bWtZ?=
 =?utf-8?B?WnFYUzBYYXovM1RQMWVZTm45WWZHUzk0QVo5M1R1VzdFMlBCaVBHbEZDbk82?=
 =?utf-8?B?T3pGblhqQ1gxL3lVdzRwT0RLajIyamJlT3dISHJWcGVJRmRqblF2ZWpzWnpZ?=
 =?utf-8?B?Tkd1c3FMd1Q4cnBRNHNyMkFNUWczUzVMdXNSanVQa25XMngvd3hpblc5aW5U?=
 =?utf-8?B?eU9XZllsdTRwY3NCRnpQbm1MWjJQM08rc0t1QStNT1A2U2ZqWEJ1WEx3d1FQ?=
 =?utf-8?B?SkdUWlJ4RGVIRWt4OVBhNWEweDRXYlpmemV5QTVDcFF5UGdQN1dUTWU1cGRX?=
 =?utf-8?B?dEtZZzNlUStDTjBpVUcyZDk3Q3RRajlmK3d3ejFtWFU3VEdMckNSS3c1eGRo?=
 =?utf-8?B?cy9KdG5nM0tNamxVcmRrQXZXcGxUazhzMlJwcHV5Z1JzU0ZYcjdacWJDUW1s?=
 =?utf-8?B?TDN6cVkyeU16TmJQc1Z3Qm5XNU50MWJwdmY1dnZTMTlHdXQxTnFienFpb3pv?=
 =?utf-8?B?OHdUSjg2ZklwU2NzcUlVV3gvM3RHaWpqRTBzR20xMVhSNnoyK3k1OXFmbEta?=
 =?utf-8?B?WU1WekYyR1FMQXVhcnhDaDlEcytnOGZzOGluQ0wvMG9tU2RrdWhqL2ZjL2V6?=
 =?utf-8?B?SnhVWC9CMzBUeW5ENTAzOENsV1dkclA2cmNhck9OUFpXSEcxeWl0NDBlUlhY?=
 =?utf-8?B?QWdjcitOaWREVFQ5akpGZUtWK2szWEVNZU11elVzV2k3Z25GeGZtSlVpU3VZ?=
 =?utf-8?B?MXU0MS9kWFk5RDNDaGpRa0JkNXAxMEVITlVteGlTYnd5R2lBUWRIS2F1WFRv?=
 =?utf-8?B?d3FnVWY0d3lINTVhODZXM1VWamZtQXBsZnZOcFROb3czSHR4WnVjWFhKck5a?=
 =?utf-8?B?WENTby8rSWxWK0RLYnpRSXhWSzhocnUyWmxLT2J1UWMyOWxWUndjWkJBeTU4?=
 =?utf-8?B?cVcyZlZXTHRyV25KRE90VnJUZzczdC9vdEczNDc3SWdMSGE5TjYvbkpabWhw?=
 =?utf-8?B?UEc1WFhrK3I3V3FDZGpmWG11YUFxWUhhaDBrelBta0FrYXYyNk1LM0RLa1BZ?=
 =?utf-8?B?ckdnRlR4QW5uMGsyU2ZOaTk2RG9DNFA3WDl2OEM2cFhtWHVlVVRlVWl5cGpD?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Wgj7oDYMUnTeq3pSPaf3XsodxogrwdjZzDuRUZ31BQQSOBxYj62XYFfy56gruxr81hRcKTQipQWtUISDhdQFH+y6CysoHUEYOhE4TZySC6rGv1G+ze2+Rwt7AxH9B/MzljIG5JRTK4xsWkwYK5XJgyXtwyeu37Jo0cfO9WcpBfIsCcc+sGZFONM30DT88PA7bjrfz+I+LZ8jwbA0y2zypiATk/jZULJoov0E3Hozi3UI/uQfqywAwsq/gVKMXqUAMYFxMBh4+lJZ5qj68Dzo1RxmhAqBXt2icWe1er7zEwqlwQVuyhv1f4J/Bs+y9Z9dgRO6dXbl03nt3T8p6TJm4bTK+gNJ4ZrxW/nf5E4fJwb3SFdkqPCtIC0AEJFlug48xkCnhwWYXsgWmjyu1vqcnh5QF4A02d8IqQ+q9EaBs5I+0LLdiCRaciJcihN3duHHTsgv697AvGGZZeAm14W5kkj6d1U1WbpAzTKkZyoCIcFm0TDZxbl5+7xxKvhMVCu282KpuGKeh7fD38sXrv2TLHN3+q1XwaE+ONqTpFNoN68OyDCW88eb9b6JD3gBvjqGOdJmFloo9weQyWVdHUMfDJ0cbPZP7sZCbKaoTDvgUEWXFY7taJcUfotdesWwqd2MYmszMbiuYyCzndcgE/lYhl+y/ytfeDnFOBuwGqzmPY9VcgoQG/fSN0obJJwnuN9xod9EgTBdktp7UUpthNrPNsrLZ+8oZIs7Vp03qcgSL0PoeNBS1CJurytFlLIwz5RKNLWTG1eIgCIaRk47AHjIcNFdEOdt+fM4Uyb7kqv9eUdW9tjBbRQ3YgJxfxfo3KMKCQQq5Sv0IFfBE6+faV9RHu32PV0JOHX2Pw3nL7oJgdhJIp+NlWKGi0XOnAxt52Qu
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946b6394-e6ed-4dac-7dc8-08db8e77e1c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 08:02:54.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6GYfIMuHXlVxNYmOn6pl39Nb170UGxulfuYAO65uvrxPHA5hGeP+0Qii+8Ut8dgdwMa+0Ce5WNw4Md6O39ARpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270070
X-Proofpoint-GUID: x5b3MZcT8vTNr0z1T_Crh43QRlwZk4cB
X-Proofpoint-ORIG-GUID: x5b3MZcT8vTNr0z1T_Crh43QRlwZk4cB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. This has us access
> the sshdr when get a return value > 0.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
