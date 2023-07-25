Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89EFC00528
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 07:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjGYH72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 03:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjGYH70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 03:59:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151C3128
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 00:59:25 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7ofpD019605;
        Tue, 25 Jul 2023 07:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=QLlB0q0Eu7GqRz0mVnNTkFQZ6XXtwbLbCSaXt/wJJfQ=;
 b=TVkcNOj8WmtI3inDFuS9K7CVqGeFY0vVj8+VSJy4xfm9XpDnBXWvdlegvpgq/VEHC2Ie
 Cw5aw7Vn3lLY+4CcMZgaSG21jIh6Dxory8bUlKoyoRxrtIZqo5w5CwpTqK3X/cKGHA6f
 u6EEHxOW4mhsipCDvFSUqn46foVs7QAtXF7it4dTeSLeZ4levPgI4MWTzcxc1ujhewza
 kUBoieDKDsds+j5iAM68mtk3opb59fRo1Plbsuf75N0jw54cLJS6O9nzcjf5/Jd2sZYC
 0HneNFHA2w6Vc0rZJ6iHaWghEE5QRwAzU26Yg3mE7W9/DSTfs1riDhYgUBHvPLhCUPKl bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05q1vh69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 07:59:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36P5ucIc027537;
        Tue, 25 Jul 2023 07:59:14 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05japnh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 07:59:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAjmHIT4ItviD4eA6NtpxwjRa50i4cIZBDXhsJtPNnO0fAmaIRih5V4hOXPg/rp60JNOsxh71grJ6dP1iDJStw3FQLAtCb6mVgvoRjNrKPuWvrd0AtWQ1ce1LToXU6OOrCuoMRRP0Xf+W3eKnMuiVlYGMquzLk8buuAKMR8Dxh9XZYZS373X5JTXNdq+JUeSo58HxOGjxi6LqhGJvS7uKCZblrSdUAEIT4B8CODkiFAFEBl74aXomCBU2a7PtlC2r8ENm8FLRVgLFkKSYjoXsz9M6pbotedkKgkzVDarJTJ3YNp3RS7WXzPodqJwZBS0aQ4XuAkExGeEEhTIR4qsgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLlB0q0Eu7GqRz0mVnNTkFQZ6XXtwbLbCSaXt/wJJfQ=;
 b=iJnsOsXYC75DFhZQNTUh1ltybGzpQPzasXBXVfiYZeNDVb+kkiqx25w4rjaidjx0khi1ltfTopXcJ/ei7SC2rGPx6Wk7fa6HGqq5/cNf3tXuXBmldwnW72Jhgl9LO4ij3HU8HjeDYxEX4lDqx+/4/f1s8SesEh8HXyS7p5/t+x1/weIos4/nRt7TWX4LA9EUw0nHViqAdTmrzCtaFJfzrbORP5o8L0BYjF3DBM2ywcQSr2MAczwb6WYzv252e39/ED13oCqBFb1bOx5PvhMXrbY5gqx01Y4CIFMaIt+oEtVYWFo3Wedgay2IO+E3ptIvrWA4Y4iI9yZuACA3lYYMuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLlB0q0Eu7GqRz0mVnNTkFQZ6XXtwbLbCSaXt/wJJfQ=;
 b=h0Q6TkpNw9Z0+/3AXutgPYJnpfYA1/F5ThFxE6Q6felWfogQteEyM6ea2JgqYtOlYJtmzEvMJLaYu9G3SPi0R4c9QUWXZFpWtc7dOeT2CknGJiyOPeAW61WL1aWzjj8f4M6wxPMliiev1OP9H469E2PQ/Tk2LrjSfKBcoA1FKcw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6689.namprd10.prod.outlook.com (2603:10b6:610:153::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 07:59:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 07:59:10 +0000
Message-ID: <256da235-24b6-4242-b245-afc818e11214@oracle.com>
Date:   Tue, 25 Jul 2023 08:59:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 13/33] scsi: rdac: Fix sshdr use
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-14-michael.christie@oracle.com>
 <f0822be9-c4be-5e3a-c260-2a97999a0e3d@oracle.com>
 <aef4186b-fde1-cf3f-c491-f2747f08f426@oracle.com>
 <e4b26cdb-9ef8-1633-86c6-81f2aa270d69@oracle.com>
 <e593026d-f803-ebcd-f9dc-3b2758432817@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e593026d-f803-ebcd-f9dc-3b2758432817@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0144.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 07f1504f-a92d-4097-3a1a-08db8ce5079f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MNYNFDOzIfpzTthkajEM3KG73AqGqCQAVOsvuJZC8t00vKVMiYMsmLZSH8brRaaHa0q+YYpqTyo6uBKFgoibWi3ytTSFGm1BzfMHxH2TH7VePu3w2LXbr9RRI67m9YHr/yTnl6RlKnBscCmbCyUEEsq55xhF35daeaSGn8gtJjEimJ9/5dj2PVdPt7F2xyWxigeH+WQAOgw2vQorR5IVPeWdnRHMThdDsk9XrR1dAIqPoft9gr7sB5g3s6Eu3RrOg8jkiN9ESyrAIetq+fOWJPix+8nSPpVJhs9Jr+mjfYdsSvfRv1PEQSnB++2Ly1pcbsuE9hxjiXZh8a7bd42LwZdnEtUwdevo+iRpY+3gq+0FOJtIXgcv/5OY6DJxjhBOB9F8ukjYaVvUYg+V4Qs66RVfpgeEyVgZs0lSz0//vWo3yqw2KAU0y4yOz3I2GEsHhUZX63PBkoeekNuCU8YaIGhwFK4A0LFswXg8zF7cP7hDyOwq4owd2DZZwOB3IzaUwWZ80jAOMFBCvJHaCThpnLqEprA9VajbR3K9WMAuDlVI726b0pIgl+VqTNeP0J1XFr2Ukmwagemu0BE0cAsMfW438uVCohBAFHgYlMDQSFJn43qISwhcpoinHimH+f+YXcngvpqFX3IJ9LLg4EbTQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(2906002)(2616005)(83380400001)(316002)(36916002)(6512007)(66476007)(66946007)(66556008)(41300700001)(6486002)(8676002)(478600001)(86362001)(31696002)(36756003)(31686004)(38100700002)(186003)(8936002)(6506007)(5660300002)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU5DTkRjdnZUTk9lYXFSdEl6Z21mNURCakVwdmRCNjQ5ZXQ1TUJaT0F3cFNt?=
 =?utf-8?B?WkZJZWdLZW5pQUtUVEswN0h5MDZIcUFLZ3JkVllRU2pyY3RVUG1LZVlKTDcw?=
 =?utf-8?B?VXpva09ya3NFczVjZzFmVjlPSUcyallRUzRjb0ZhT1I5U0daK3kvOXlvYkRM?=
 =?utf-8?B?d3JvSXl6YkNZUnZCQkg1WTIrVEZ3dDc4WXIreTNjdER0N0V6R1d4c0FDWWxp?=
 =?utf-8?B?ZEliSUZZYlE0eGNOWTdmZGNQN3BSYWxjdmRianR5SUJzc21kSUZZdUdGRFZj?=
 =?utf-8?B?TzdaaSsxZSthVGNRNTRhSi9jOVNhV1czRTlWaEpYWkxZU1RPWU9mc3QzeHJD?=
 =?utf-8?B?UlVqeUMxcmdhZFVtWG5XRzBYa2h1TDcvbjNsNVJLcVJZditIYWZUNlJyZkI0?=
 =?utf-8?B?aU5uVnJmQmpMN01qaHlYTWRzSTZWOGZHZkorR2JCU0d4clZwUG14a0ZmeTJQ?=
 =?utf-8?B?T3lKOWlqTUhINWhxcGthYmIwNkdsNjV6bFBRQmVrSi95MzBqZGcvVlo4K0xa?=
 =?utf-8?B?dmZJZkc2SHpXeWJUaFIvVWg0NnBvNjZvUHJDRUZqZUE3YWIxRENtc2k0bnBj?=
 =?utf-8?B?Q0JWUUI0SlJNRXQyU2NIZjBMUG9iazhwd2J0dDdxTURETTVpVzNIS0Z2ZFZo?=
 =?utf-8?B?Unc0SGg3M3U1UE5FUDNNQ3ZYN213TzFOeWJHRVdiaEZ1N05iSTBUUGhQYWQ4?=
 =?utf-8?B?ejhaeGI5WTZGbUFpYlRiOHR1OFRkNDlZazZIUGVmaGNoM0FBcXBZdTlvSGp2?=
 =?utf-8?B?a0J1cFRJNFg0T2VHNjI0NXphUEptZDNNem9MMjJ1YjR3RzMwOVFybXdiRlds?=
 =?utf-8?B?ZHVIVDRpNWIyVi9IWjB4dGhESmNac3MvMnZHK040QmhkUnhqdXdGbTdBYkEr?=
 =?utf-8?B?R0tnZ2c4ZDVGa2tQWU9wbXJ3bFRlbFpMM2l2UzExeXRTd0VGbFg0SzRuTGpT?=
 =?utf-8?B?TU5GY2hCNzYwcjBHWkc1MW9RTjAwbTMxZ0E4UGtqaXZIMS9BTjI4Z1lTb21M?=
 =?utf-8?B?WWNlZFEvYjM4OUVucUVBN2thMnpPZ1U3emJNZzlLUGxjTFVGM1M0a2xUbmVU?=
 =?utf-8?B?Vlh3Kzc3ZEVFd1orQnFlSnhZeHBuVU12Slk0cG9BSFkyM1Z5NFRVVjAvRHov?=
 =?utf-8?B?ajlMN2pVTGVqNWVDL3J5cjhxWTVUbnh2U2hEaHdWbFBoQ3Zsek1wWGR3TUtQ?=
 =?utf-8?B?WVVLY2YrREtvYmR3d0hMZjJZaFdlL1NoYWxJSm5zSU5xb0lwbk12Q0Y2MFJ5?=
 =?utf-8?B?STZxbkxZQmtudDJIVThiNk4zWW9zOFp0c1VZdldXczdPa1h0dit0SXBWLzdy?=
 =?utf-8?B?aHlWZlJmOUw5a0ZSMWFNOVVZVkE3RW9wb0MxY0VmM2RPNGV5NnRUZkFUQURH?=
 =?utf-8?B?U1U5aGdTR3BGRG1XOXlvVndiV0lpVGxPYXczZEFNMmc5N3VZQnpCSjdPUXVa?=
 =?utf-8?B?dUxTWFJobC8wNmRnQTlrZG1scmxkSnh4eUkwZnh6c1AyeFl4NnNmbStBU090?=
 =?utf-8?B?N0Z4eTlFVEFjdUVNb0wyM2RQaVFVMVA5OUhMbGlTdnVFeldWU05Ic0RlVjFh?=
 =?utf-8?B?M3pTVlBXQ0huaGJobnZjU1l6bXhVUG1OY05MZjh5Q1dZS2NiRFpIU1lGaVlD?=
 =?utf-8?B?T21PRlZrYjI1UjFkS0VCZE5HS0MzYkRyOS96SldwUHlqYk9WZHdNaUt2K1Vw?=
 =?utf-8?B?eGFJMW1xa2xVUnkwTmhQU0pQM3A1RnhYYUZON2ljTFQwMDZLTGZpNnVOMWp2?=
 =?utf-8?B?dHBMY1pRYzYrWThTTUVFdVIxOHZJUmMrKzRWK2ljem1zcktwMTc3Q1JFVmNE?=
 =?utf-8?B?Mi9RWWJ0NjB2V3pPbXF4aXdnM0RxQnJyQThhN2tGekdNSmRTV1ZpVEJwVUxH?=
 =?utf-8?B?SEZtY05SWFlkSDlrTFA3K3pjVzJ6V0dBTFFoMllMSWZqaXlqdzROS0hlNlZR?=
 =?utf-8?B?YlRIMm4wVTBVakh6Ym1OdHRaWC90TnhnaWJyNm1MS0I0RzBNckZtVlg2bnl1?=
 =?utf-8?B?QTFRRW9wY3FDNGVFT1dibC96MGtaRUhBYmhCMUtMWFQwTjZiMWVsZmlYZlNh?=
 =?utf-8?B?UzNZUjVTS0xQQXFITzZTdlVxTDVJZUFmNnpHSXNpalB4SmxEVEtHY1FtQk9X?=
 =?utf-8?Q?7DnL1DiPThj5f519Fx3KtWJBR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rpZo/rLn2GmKh2OJlPd9J3qcS4dVC+qWBTxH3cmOdJMCEa5nXVtNDHdnp7tsILehHERYM9dH6jU7xGDJ7zGzA/gwYHWR1PzttCp1Oyg9hRx6u4n8DF48+FJs4UPvL1XjABd9+b6NwccQguhGFKQT+6HAdOIFBBPvX3fOK8GnJa8MLhTcI/5sBYxXG5/h+1/sIkq7NQRk7Sb3rtij+WkKViwuxgAupbcKTqJaW990ePXxU1zM8QGeToPKekIhDHnagQvFdZZkPE9fGWiRMadBIg5dnQl+y/BS0SQ8PS8+4B95kUp5+TvuPKiGuS1++8TV1aaZhQV3eLcSTVUxix7Rsef6xY+wpaIRqIY6GOpEwJgiV6dPohtLB3oovd2LbBTWMSA9wLB2PyxFNw6JQFWSUl3dxZsre8yjlOZfZoXT+HHAauHuIFaflZOj+QyKsuzsbd3zRH6SHytBx+gaQC1LP6tMeLD5s+Ms+qIbXbLG1q3P0cAkRIEeDyfG3MpgP+n3v3HmRqeS4gyJOLkvrhNNlFyU2NjWdqIjm2uq+vBjkiAVy2HwogwRanueXiTWgC+5er6lCiXonUWwN8PXLjeVsxV5E9scDSX9B8ytCCxRRG52NYaasdGF+Mtae+1+zpxtwGvA5u+7+pD8ozNjqH+Wtdc+JJnL7EOypWfwQnMbzbKnLNP3myMqZ8LWO7nLfTYdQMR6X5HpeeCtnNE3fbyfE+MLgGwtWy1Quev9lmciHqiikgwKbRrKUJIgD4mhpeaurv/4TR1RaLdg1Nax4YqLe1jQGfosQSbFFuZn3hlZu3RUb75ATm/P5aMFxARJWWRxb9lEYBQEYXlSz+8OMfqoYGLDjwkP1phgpFOI8fc3E/hnbcj+0yphrKHkx7XGkefR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f1504f-a92d-4097-3a1a-08db8ce5079f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 07:59:10.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDqXLsWjxUmdSNf73HZVM476ZKZ1glDYgs1+7DqN98BWG4m4KzfbpHnhkKUk1pCcDL4uCMQWQRJQDL3FFTiDcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_04,2023-07-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250070
X-Proofpoint-GUID: wmP0j2WjJVzXH4rfrLlN08bO31iq9Pwh
X-Proofpoint-ORIG-GUID: wmP0j2WjJVzXH4rfrLlN08bO31iq9Pwh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/07/2023 18:10, Mike Christie wrote:
>>>> As I see, err is initially set to SCSI_DH_OK when declared. Then if we need to retry and 2nd call to scsi_execute_cmd() passes, such that rc == 0, then err still holds the old value. This seems same as pre-existing behaviour - is this proper?
>>> I guess this has been working by accident.
>>>
>>> When that happens we end up returning one of the retryable error codes
>>> to dm-multipath. It will then recall us, and before we re-run this
>>> function we will run check_ownership and see that the last call worked.
>>>

Hi Mike,

>> I'd suggest that we fix this up as a prep patch, if you don't mind.
>>
> Do you mean just change the description of this patch to reflect it fixes the
> second bug? It already is a prep patch. The second rdac patch is built over it.

AFAICS, this patch does not fix the bug where @err may hold a stale 
value. However this broken code goes away later in the series.

> stable can take the sshdr fix patches without the API change ones if they want.
> 
> I just put the sshdr one next to the API change one, so reviewers wouldn't
> have to jump back and forth between the front and back of the patchset.
> 
> Do you mean move all the sshd hdr patches to a separate patchset?
No, I was just suggesting that we fix the broken code also in a separate 
patch in this series, like:

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c
b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c5538645057a..5d338f12e68b 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -530,7 +530,7 @@ static void send_mode_select(struct work_struct *work)
                container_of(work, struct rdac_controller, ms_work);
        struct scsi_device *sdev = ctlr->ms_sdev;
        struct rdac_dh_data *h = sdev->handler_data;
-       int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+       int err, retry_cnt = RDAC_RETRY_COUNT;
        struct rdac_queue_data *tmp, *qdata;
        LIST_HEAD(list);
        unsigned char cdb[MAX_COMMAND_SIZE];
@@ -549,6 +549,7 @@ static void send_mode_select(struct work_struct *work)
        spin_unlock(&ctlr->ms_lock);

  retry:
+       err = SCSI_DH_OK;
        memset(cdb, 0, sizeof(cdb));

        data_size = rdac_failover_get(ctlr, &list, cdb);

Thanks,
John


