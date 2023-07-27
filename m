Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672C6C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 08:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbjG0IMP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 04:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjG0IK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 04:10:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C6730C8
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 01:07:35 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0sF6k005227;
        Thu, 27 Jul 2023 08:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=kNVEIvxEba3UV8TJBhf5cxy9k7c8wmw4Igfz05zUucv9xpmALhjcHo6lAxEz/V7GdrIx
 DAe5p2SPGCtgXzpBxWqqRy5WhENkwL6jgLrLnVz2dpOLcnEx4DX5x7yVPNZCi7y/aEqE
 7g1tXc1qfmf51pToF3cr1mT8yiTpKomwDWGnTfji880Tijc6GAsKmL5G4UdEk3j2aRZW
 3zUHuOVpXrC6R2Pl4Ufo6Wl2VQqB234rDOjBKuHddAb7eRN860UKUeWU2yiEQVBSGrgK
 Y3L/vL60KMeaQY82K5P7HvRgJo5pLB+kwpMfM1qI20mD8EtutsOM1mo38tn8Aptm5z8e Rw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d9987-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:06:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R7Qe1j025271;
        Thu, 27 Jul 2023 08:06:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j7t76c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:06:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jl3aFM2+jnGmg95zc2X4f3ABLpYg8BtH2Dq9fTbXz1V/oIlJufaghCf8f9/6/3Xb6Hx41a13tlTLRUxNHt6HoMbOqYGsk40lS2sEpCSrbsXD31nREnpEnB+QC7/CdE8iSixpk73Gl6c2ZI/6DHDQvrhA/79Ot96A/gLwGdAjDKkE4UJWX3QpZYNhXghaXkWGpzPs4KfRqwuC7Mm6N5Cj50q9alWm+nvK2fQR7FvVQblvbdRUcK0SWPGYwSzQDRika4dp1I4duHxiyVsFBMLm/XB+C6YYspz+w8KLr35KwOPkUZROOZaiPG5Om1kONl3N7OFeptEvcGWSP7zOdadMKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=U7A6aC2s4I2ENMC8xzQoy8N67gx0FNAYa8JQM33sZz73PDwZ+i3TlRumkclLEOm/sTu3qKG+0If4K2SRLPhR5eD4sExV4sHMxwCZ4PI2Ir5SbMHSlMDXHlXda+PSV7KCmmp7kRHukY871xru6fLfowyKrgRMVUcWS695xq1FZRzSrF0YdlHCUcxoydFpTZLbXNYv5Y8f5U7FFUE8GxYtei7TClOvluorrEjPUgmCCVxxOuwMjbz0TPXNHcSefnFYMqqO4fIvmC+a0nnMUm5JxqcYiRafeA9Iljkf/4YrXUyJ7riyt88tE9kX6NpVeVG968BLfDVqmCw4lpvKOu/n4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=aJaux38KV+szqsN4CGlhWOxuuJk2rTfL8L+Dl3Skx/JF99er5xcunOoDcgtGViCHb2MSPHh1tX0cFSvi5LaH8huPAc5yKXaDtThEGTBjUEDMCQvhPnIctzqMypfrLbhD9JwNki8Hm8RNMZo4t56RQvkmjwL9fXa2oWWpRFbO7Gk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4839.namprd10.prod.outlook.com (2603:10b6:408:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 08:06:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 08:06:27 +0000
Message-ID: <f3e37ba6-b5e3-d27e-c12d-5364b03a3a02@oracle.com>
Date:   Thu, 27 Jul 2023 09:06:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 32/33] scsi: sr: Fix sshdr use in sr_get_events
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-33-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-33-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c01d3a8-d976-4a72-b69f-08db8e78608a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5OA9IlWJd13/2MJwyvsoC+Q7ovIjZ+AFsShPJoJHPAWX1D2r550ULKVGbKm1um2qRQJpj24iTfGG6F0J0t3OiWasAWLa3NfXQ65RprY4L0ECyfNx+775+b9OyVh58VfmvXrr7L9p8lhzFgWv0z9WRg4oSDw84/1XLcjZXDn9Smc+q2TskBWOQ60f/LmSTdYICjcjO4Xvz9938ueBkadPoao/7qGhaSpFodUxxp6HbVpqi5oYlLMXvjhjYb8QwG8YUBoCRKsyMFExTrmMcSGXxPBdIHm8887lUQSFQqqPdOy70z6BDSwhFazjseX17VYxwAPXqncT4BiyBMtxWn6UO8gv4DkqU0ubjEbZBDA/Qh2oAASgsKoPc3CPq7djOo9++taoy2twELeWxqNEPpLoU31A9uva1TG4eUAOf6twrtD/N08wz4JceMIFo6Xet2pfaWIeG9K0Vxj3TrI6cYSQAFVXOj2vdtkBp6BUduRd/ehUYWMj3jjWAa2DfjeYGOjBJ13q4SdYtHsPK16vk0B4ky1LspWsAG5UjKf1ZfH1cGcAn+5uk0qmNk4Escxi1UmCxXcHp2cTLDSAXRTFAbBhDQTk/+ruLDfVrEfGRLMrM+xFplj0Kxbw/3gXp0YgODH0dQWsQEis+tPQCuyzy7xgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(66476007)(6512007)(66946007)(41300700001)(66556008)(6666004)(6486002)(316002)(36916002)(38100700002)(2906002)(36756003)(478600001)(4744005)(2616005)(83380400001)(186003)(5660300002)(31686004)(8676002)(31696002)(8936002)(53546011)(6506007)(26005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjlXN1hXdFd3QnYwNkIvUXVDM213UklJT1RTc3pwdHhlYWMyNll0dFdxcFpM?=
 =?utf-8?B?RStiM3IyMlVKUDYvQkNxS1Q5TlZCdUdQNzlYNS8weTFoa0U2dWlTanNhNmk2?=
 =?utf-8?B?MnFRQ2UwRHYybWxPUm01TEFTOXpOelBlZ3VralBuaWJKbEZ0NTZOT055Q1dl?=
 =?utf-8?B?Qk85VkRiTndGdnJSMDVqc2pTWVppdzJseExZdDhHTXZnT2t3M3FFYm12VWw2?=
 =?utf-8?B?YlRhWUt5eUhmRkFXZkkvc2szY3FOc094VlJQT1lZU1F2eGdDdXpjOTg2N1o1?=
 =?utf-8?B?SGZCbTQ4aFpLc1NkZndKYkVQcytlZXd6b0RSZEN6VlFCSFBGRGhBWk9qTisw?=
 =?utf-8?B?c0k0bkpGeVF6MTVoZ2VlYVZjT2JSN3BWY3dTWXdXT1R3YjBxU08xVkc5UFdr?=
 =?utf-8?B?N2tYd21USEdkL2ZRamx5NklqSmx1VWxqb2JpdmZJTHl0L2xlT2hkTTVIbUhI?=
 =?utf-8?B?b1ZWNUJsWUFtdXRjODBwa3VtOE5FbnA1cVdsVkJYdXJnUUk1byt1VjZrWlVW?=
 =?utf-8?B?ZEJTdzlZcFVCKy8ybFgzWWFXcEg3aWJBemlRTmVJNkFkWGdPU0c4UExib1c5?=
 =?utf-8?B?c3EzOVRlZVZOL2JvKzd5YlZkSCtjSzh4Z0xQekI5R3VVRHhvYnZtNE1CS0tO?=
 =?utf-8?B?VFBFd3dBNXJJTjZ3dEFHMDRoKzhwRGF1VkpKR1VYcW9ickhKQzZrT3VpR2pW?=
 =?utf-8?B?WmNHMncvMyt5VnJPMWJYeW10eTdlWVN6VlpxMXhaYVcxU2NiNXViR3ZpWWsz?=
 =?utf-8?B?VnFrVVE5VjRORXRJNFBLK1ZhRE5MOXk5TklqS0ZxcDN4YVZsNkxUVERTUFZl?=
 =?utf-8?B?eGJWa20yQ2RiZFdXRHpzV3lNajRXS1pCVm5sakZXVlNWWlhMNTJDbFR2eDRJ?=
 =?utf-8?B?V1lLUjhqa3FBb0E2TlJLRWpURjk5OW1mQU9Sc1ZTVW56dlN1aytRalE0V2pV?=
 =?utf-8?B?aEZXRzdHcjhwTFk1NFB0eE93TFBYSkdBdVg5OUVRT25YZ3RPdzlUaU5ZZ09i?=
 =?utf-8?B?M04wZDdjb1VDVDZsSlRqWE91WWhmbDZ1cDhBd093MTJvOUswSzRNOG9keEVQ?=
 =?utf-8?B?eEVPSXF4a09BOVVPOGkram5jbU9MUXRnUjYzZUcyUE5kbnZ3QVE2M3JMdVFR?=
 =?utf-8?B?K2pDMjl0MGUrVDVlL1ppeTlJa2dSOUU0MlFSMWJzbk14ZXNtS3ljaEpZSDQ2?=
 =?utf-8?B?b2Nra09RaFdSTEtKejNFZVQ3K1BpNStGWUpKaGovc2xiY1h0dTh1ZFBCVkQ4?=
 =?utf-8?B?bHdPSCtTSVNtclRUcDdRZmFIaFVPYURsOW96TUptTFpMcG0xR3ZIYXV5ZlYx?=
 =?utf-8?B?N29wMmtyQjRCK0ZtL1VJMWJIVjJIYlVHQSs0OGpnVVZjRVI0YWFHUEJmdldB?=
 =?utf-8?B?RmkrVEFqRWxyZ0lWQU5CMmxPS2Flam96UGF6T21SeDdqdGoxYWFpY1VnT1ps?=
 =?utf-8?B?ZEFqVFlZd1phWFF2YlBNWlJPMmJNNmlVdjRIMTJCOCtWVlVRSXFiWTEwd01s?=
 =?utf-8?B?QitaV29sMGZGckxlSE1nRkV3Zis1V2lXd2xlZVFuUGF5bzRkMGZYSGU3NEcy?=
 =?utf-8?B?aTZyMllUWUZ0cVhXOERRWDNsK0xaMnVCeStFQmdCT0Q4cTN6a0JKMGg4VnZq?=
 =?utf-8?B?amVoa1VQUWFhSkFES1I1N0M5azdDQTZqMjJKZGtiQ2Q1Wng2d3d5TGVzbUx3?=
 =?utf-8?B?QWkyS1k3Zy9kTzQ4UUxvc25Kek9OL1BPL05EWllWa2VuMVJVMW5UZ0dTNVBp?=
 =?utf-8?B?TTR1eW9IVjRhRjN3NU9COFJPZ0t5TVFJcHdPUmxXdHlrTmZnekVoSGNtWitn?=
 =?utf-8?B?MXo3eFdhZngxandyV3hjblM2aFp4ZTJDZW82RGpXZmZYLzVCL2FjRjQ4Si9x?=
 =?utf-8?B?Vy8zZlAzTlRjUXJRdzJ3ZnczSjVyb3lIUnZTSTJoYzM1K2pkbUM1VEs0WndV?=
 =?utf-8?B?MEd3RWpBSkVvaTU1RUZVcm5Nd1AzQnB6V05lWXgyNkhCbFNqNnhjc2JUVC80?=
 =?utf-8?B?RFZHdUVhY1BFN3R1ejk5R0FFNGtOelhmVTBFZCtuMEZiSVJNNTk4dm5UYmZp?=
 =?utf-8?B?dE1OUFNDcEZZL1NYcGdla2dqZm4yTysxTEd2Q2JLVHpzK1RnTzg0Z0FqR0hv?=
 =?utf-8?Q?goUHIzCSz67R9jwxc9kONQzAT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7WY+47BNoiKjKHEYD2d9D7YPvfAylE/zRnplzc9kezn4mby2edEHDloPGwSaOXdp02VpZFxmrPgJ+W7WJb+cMAC9irDrsAf8AR2Q/evEmUxlA2zcUP0WqTvbl6+a+LzQXNIvdnK1r6D8PKQNkNBQZSnDOoNachAZrBo3dhAdvgVbD7P4ZkLKCd4ALfrANyZJ2Y+Tk35O2rv8jte3iO+YSebuNtrbfdp8oJVDBDcd/Sz0shhxnxHfnEqBlLh7iucN18RlCpwXR0miIW/PcAhAy1Vub8+gR4myJozkdfX9k72SbEw2Y1vOaW5shiR1Yvsfx+EaUNfWl+03/33xQQUdQnZYgnw59uGpkQnmMzZT6Njp/uU9f/YKQIRVgOOTfPXiheL+brXje0lxTiQi3OZlq7s2TZcdcKnxR4dhsgCWESpjrr5y3aIofRrAVPTwiy2Axd4k0c22pcNmOylCxowTRMe9GdbNheQ5kFNILpymEyr38zT2YDppDNbzQTKNZTGOI5PDxzc9tsCI8w+IhqJIv8F4dhzMj+5jiUe43+91VvaUMr3bT2+wvgAnt0VgmXhvJff5C7IbpYEeGTJIgA7MKtHez8COb0jXcf8LaUZJF8nz7wA5pgU2gxtEOcwYBLD2WWOV+cCjRqVPMdQO4MGCGQ+yGifRKq04nTDu6AYLTJWbD7Zn9uzwm6AK/J9mgxzBOw9lE7dQKEZcZYizBjHAQ0MBtF7PpQGfb7CeZ3tRU9nMbhYfMl9HVcdEAAqUqWVdqsk2Bj4ss2Gfn7U2fROlacVWeiRnsyFL1TjZazvHKcPYySXt8r4OptKzYqrWuQSYe3gB53Iqcz/NAbj38xVwf3Mrc1X3sGpFsC7G7m6k03JDdn/pP8atJ7buUW3kXHqI
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c01d3a8-d976-4a72-b69f-08db8e78608a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 08:06:27.2328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61hAIa6BCHuRSLBEN5jAYBRpeogetEexo1c9bPGcv+XRgMLv/9kZDpBIcGKOkLjgT54iBfjrBck4JwASKN/gGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270070
X-Proofpoint-ORIG-GUID: 9xUPJEmT-QPEAzAVcfHeUwpMRz_Uj4xA
X-Proofpoint-GUID: 9xUPJEmT-QPEAzAVcfHeUwpMRz_Uj4xA
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
