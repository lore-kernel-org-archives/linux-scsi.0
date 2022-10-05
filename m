Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41CEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Oct 2022 17:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJERBC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Oct 2022 13:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJERBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2022 13:01:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120DA44575
        for <linux-scsi@vger.kernel.org>; Wed,  5 Oct 2022 10:00:55 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295GdVEK030500;
        Wed, 5 Oct 2022 17:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=hBOEVwAYFqsltI69r4IeOvYJrL8/IccP1l2luXKcBLA=;
 b=iCEibs/P+T/JxKAAq4IN499dUPxEKSc5lt8+wo+DUoI4ByieuV1JL5XExSwaIjdE+ITz
 SziPPeUVfmRdNmwNV3rrO2t7V4gy/4Bf9HpbDFvLsPk5gEVCVxRIPZ0b+NReFGX/0xOy
 dnWL3QU/Ovg9ByLVhQY3qZ1blnQvbDXB7jD9ZZ2mK3eF7s+FjNK/lv/XQ12SemW6uSlZ
 8LZdfRq66B7a5KQSSKUP5FSDID4wrbO5U+L+iPbZo2AxkoUT0j98weBJXh6Q0/70ni7F
 lZiirJghZftH3WUDvBOYDQvG+PMSVdxidhJ/s8JSUkaHr95VHIvOVy95rNo+A8MZIb45 iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5thtah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 17:00:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 295EYe5X005141;
        Wed, 5 Oct 2022 17:00:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0baj9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 17:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KT7CmrH31uQjo5apAx0HOPydL9fcD1LqrwyhvLca1v87MwNxgs1ODiIBRNchEpK0BxAbETi9IiT1JnGkIR4c0U6zlzuqP8hTrQPZ8LbJMKQtiHW31kPZrXQhO8zbg+xU8L5tbxYXJVmUs4L9CGcMoJlxSxirI8ltsYskEP975BW11Ob+VuuhVdXGrx05iyHMfSwjLfX13b+gFRlGdlb5Ef7gzoC+giCJqa0TCkMvOgwEuqNCmhNJZi31ZEyh28na0fYFBBo4tax+A57QoQGZQ0ikQFDepOAjKnSn9V+TbVVSmG8xs/KYvkca62Wqn4P2AKV9T87ZwArBZo6Xp3g5zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBOEVwAYFqsltI69r4IeOvYJrL8/IccP1l2luXKcBLA=;
 b=BQqUsI3HfaHlIWMPLPolgLill/whJyMjSAUr15DoMa4dmCf6gvqIoO+VPBjoXE5S3WHJXYfvIq5QtbVI8wYV0y85KTFCLgytVJD6w8EQThi9l+t6RXLCXbpdY8rz4jGQSYTdi+bOUbiYNPNbb+yJ0I6Gxdgck7bQbtJJELdAMT45+UJLjEBS3RricO+8K41jO2CS83lCsG/G0oyqASCvoY4pYz+/5NCdmfkkL+LMhs//7FmBEyim9P9f4JQhbM+WttzltqYnSezqdVKAZs5EQdp4+6MhXmQkwYdbD8lietKdxNdk8TC9NjZ7RFRkKNp0p/JNTw+W/CiEn7cDJJ0S5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBOEVwAYFqsltI69r4IeOvYJrL8/IccP1l2luXKcBLA=;
 b=pIiwvi5pRQXzYJozCXdupJCDto/9w+9kqDHGcToaUkLQyzIGocsl+1e1jYN4EhGEcg8CdX6pEN9PPaY5yZixJpeq28OjiYvAPgPf3xyqnMl6Bt+iPpxBQWASe5vUd04Kpb45yG6Kj91rmaT6Dumj//dUeiCwZJW9yDhSs+JTEKk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6628.namprd10.prod.outlook.com (2603:10b6:510:20b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Wed, 5 Oct
 2022 17:00:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.034; Wed, 5 Oct 2022
 17:00:36 +0000
Message-ID: <07ec60b3-2147-3194-ee6d-49139bd48c95@oracle.com>
Date:   Wed, 5 Oct 2022 12:00:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 32/35] scsi: sd: Have scsi-ml retry read_capacity_10
 errors
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-33-michael.christie@oracle.com>
 <4fda7b49-7fc0-7372-961e-e70c870d67bb@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <4fda7b49-7fc0-7372-961e-e70c870d67bb@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0342.namprd03.prod.outlook.com
 (2603:10b6:610:11a::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6628:EE_
X-MS-Office365-Filtering-Correlation-Id: b3cd269e-060b-4107-49bd-08daa6f31f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PRx1ZQLo8GxWbw3Tm80fJzmEt9oNrvIdibFYoIFApAOP+SW+mNbY56dbHWtrkCazsN4T1eaFXgCpHX48KQaYjbP3mCNnVYvRTQDu4n4CdavGm8S7/Pw1WTo/Ywre0dJvkHLlL2qNMFDE2lmDwZD9DrFj17r2wewhyj0oSVgZfN9Lj+NUxZYRMGxrPFQnixfIfs5PBZaZHUgv7rqONbHoxhCwujEoh5b9UgzcLeMl6+UTxVxuFUPtvjrRu+3Cbdg0IbVQyKyzDnFPvTsh/yMf6h1/TBJB1J3HXMJUXyy9ZGV5m81wp4vjd8mhUGa8zjEvKDs+gT9Wxg3WMJxmyLLaNNidDfTEFl5UGTMEPpe68kKKOin7n6pg8RJDyDvVMmgWK4zXNTPqmR5WTqPgkADbYrtH8qF/5t5Td7uRfCwNgTrgDhXHDYbqC14t7eJHo08+PFWEPuBoT0c1v85RNJ6BaR586q/N/9nHkg5JMvkGSeZ8+XAZI+MScpsxGpb7tqYbMujIzmCh1lBIIHmbLN1sQoBiZieqgHmXtN8e0kDYWOGSmf5VLF7tSyR7cK0PHP1g10eqipjUNuJw2oKKpw/6xHL65uuo/MrOAgoFTfxZxpo+h0FoVotG8m2X2ttYz+Uv0sxT9Eeiv2Cr8Kyo0rwAbiEpUEnZ0AkfR7i2h4jvpN9QiRgoCXBqlzUi+r42qR2WBDG+jfPdFNNWNUiOIYZbYG1X01AcGHTGdVOM8fCEBbWC7iXqAvXg4kQqzH7pDCSNPRA8G+xLDQTm8LGmdjcNEZHYDuy5EcQwy1oGEDWbvY4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(4744005)(2906002)(8936002)(41300700001)(66476007)(31686004)(66946007)(66556008)(8676002)(31696002)(86362001)(316002)(6666004)(2616005)(6506007)(53546011)(38100700002)(6486002)(478600001)(186003)(5660300002)(6512007)(26005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUExMDJKdFNWYnA5ZUR2bFNVcHd3eTRlSmVvc0JYcGxyMExSZnpmdWwwaDdS?=
 =?utf-8?B?Szd1Q1RFUVNlVTdudUt2QllhYnFxeDVzcWdGTHc1czZiT0gwb3pZWDJtZ05h?=
 =?utf-8?B?K2cxSFZiVThHd3lXREJoVGxCaHg2OW1mbDZobG1HUDRXdVBBajJiWHAyOThK?=
 =?utf-8?B?dXZvaVdNRnFFdDUxajdmWTJ0YmtQWlBGT0JpYklQZm5vaWtINUJwL0pQOUpm?=
 =?utf-8?B?Uis0UDhvaGg4ZU1pL1hZUnJRWWRLT3hsZFEzcEpIUmpNcjlwT2xkRzc3cnhx?=
 =?utf-8?B?SFZFRGszM0Y1R2dSdEM3d1NXTjNaajYrdkJTd2ZGY2lnU2wxd3ZiWlY1OWVR?=
 =?utf-8?B?K2swd25yMklJL3A2YzNJekt3UTlrVUc3dFlLem41ekFQMVVCZ2J5TjF3OWY3?=
 =?utf-8?B?Uy9lK3YrVlJTaVRHQVVFcU1IaXV3OHZHMmFKUGU2TmZGQk0rTnNrTk9vZ3hV?=
 =?utf-8?B?Zit0NkM2TFd0WFd4Uy9NcjBuRXZUUCt2Z1MwWVpoS054aEVHSTdtQ1hWN0JJ?=
 =?utf-8?B?NHh5OW5meUljMHJ0Ym05OHFPK1c1T1gvNTBJZzVoY2E0SnVnTUFTTTRXZGpF?=
 =?utf-8?B?M3R2YTVQSVFrNW9NTlpRNmJRMWdOSXM5bVJDZFN1bzJVZm5PQlZhejhpZ0px?=
 =?utf-8?B?S1hYWjhzSDQrLzkzWENXUVpyRitKVjFIRytEMHdZRUtKbVRpdVM4K0ZnUjNV?=
 =?utf-8?B?QWFnbkdkckY3Wmg1TFlyYVc5c0NJV3dhZ3VIZ2xkemZUcU5LK3NGRkxYUUN3?=
 =?utf-8?B?NDhuZzJKUzB1S2gwU1BvLyt1aEZ6YklyU2pEU0dqSkVMNjBkUy9XeUJxckxG?=
 =?utf-8?B?aFRQRHJmVEJjN04wRWs5MzhRT1F2Sm5hb0l5TEVzdUZldmpHTXkzclNHTGt1?=
 =?utf-8?B?V1NZMUxzSzJ1WVVPYTNER1dNUkpkRjdJOEdjempkTUVuUjQwL2duRkJrK0Qy?=
 =?utf-8?B?YW5kWHBGalM2aVBBQkZIVCsxMGd3UEsyMG9rMENFUEo3azNseDZQSDZIQWNi?=
 =?utf-8?B?RWZ6VW9NK1Jldmt0WDlOZG0xNXExTnVYcnIwN2N1TVZWa0trTGdzZGMraTRj?=
 =?utf-8?B?djdzdWxoZVJxYTYrcFFFRU5LaGFJb3NmeWtYaUIvU1MvQm5xTGt1bmNjZTBq?=
 =?utf-8?B?RjVKRSswVUdQaURLVTRsdzFHeDVab3ZTanRIZzBpbUxha1hKK0VqVE9QZmJh?=
 =?utf-8?B?bExEWEZzYW95VlNMZmRJYzlKM0duV2FRd3pJRm13bWptNHh2NEt4OXZPWlp4?=
 =?utf-8?B?bEVBZkJDUm1wSmpiRi9aeG5LMXhNa2paVmdnMnhkY1FXS2I0anZBWmdZamhX?=
 =?utf-8?B?Y210YlF5bGxkRWRuOCtacDJxYlNqTk94VlNwTlpnRHA3ekFZRUNVeE1FakY2?=
 =?utf-8?B?cCt5aytkMnZoM2lQNThDbnF1dnUzRlpsYWZQbVA4NzVxMWFoNlhiYkY2aCtv?=
 =?utf-8?B?UmhWMWpiNjRqWS85OFZHcW1ZL3hYblRjeDFEbUJiQ0hacFBwK0tHd1laRHBt?=
 =?utf-8?B?RTlCVWVadzFRaXVKQkNETFprVS9va2EvN21lVlVIZUFGYnBFZnBXRlBDRHIz?=
 =?utf-8?B?ZW9jRFZ4SUFVZUZBZGhkRC9ZYXUvWUwxNDFzL2R5SWRibkY1Q05mT00ydWo0?=
 =?utf-8?B?UjA0NDJaTTg1T25xdlZnRUFhMDNHL09lMlZNNmlHbHpvNkRmY3hzbWlMU3pZ?=
 =?utf-8?B?ZU9YbXJXbERsQXdVWnpYZStnVDNmRjFtcnp2RkNHYnlTU2FqMitsY256SXpV?=
 =?utf-8?B?VDQ3aFg4RkxqMmhpaDV0QmNNL2lTdTB1WEErVklUV21kUDVlaWhnSEFUa0JW?=
 =?utf-8?B?OUd0RDRISWdyRkFiRTFrWlVHamgybHIyK200dVZTYk1EallrQmhpMy9wNU5P?=
 =?utf-8?B?S3Z1a1lyU29WN3Nhc204YWxwZ2o1WmhGdFZoNUpkMFlVWnlna1c5YnZKQTJM?=
 =?utf-8?B?UkZtb25xUFdIS0MxdEhIMElmaHc2UVl5MHA4ZWRjWlZPK21QUGgzRVd6QlRa?=
 =?utf-8?B?UDc1NUlFYVMzVUxCdDBpYWh2MlZhMXdyTjNNaTlCcE54ZStKU3FaMkVUOVlP?=
 =?utf-8?B?ZEgrNWUybjIyN3ZQNHlmWkRURytnLzhhUFV4VFd4TUNGUUlGbWNZZ3h2Skx1?=
 =?utf-8?B?OXNmM0xjUTY4em5IbzRkTXFJZ1A1UzY5ajBBWGlYbk1GRWFqRWw1VDBiRXh0?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tcUXMJgw90yEIeSzOQrTNFb1zHOdDv44lAA2B/7rsTPYqdeXOOVQzjA2LOKrr6xWgryr3QQ3SOaAJzks8kSBkvzBz/uU4BV0EW0Gn937UF3kCyCQxC442pw7Avl9g5pIkDD/LG2ivAfIaMijXPZe2npGb0nSph5sN4kxMgFXleGsaNUrel07tfZ+XWuZ+PrYtQZcld+ywOB3rinet9bBqGR5Ehw+SNEHnx5VJXLJrH9hcUBwpwrJuD4ndaZxNK4kKqOGgZ3XSnUh4CJA1vMSjhBVW95fBExDmXTsP328i04GR6JPY/2QWSaNNzGiXfR45geqrbbMKnSYGRudm/q3Q2+HkKtK6gsXMyNak7TkhgxoMUDCh31jMCwAxwZHFm5UPFYpI2pL6fU4zXYiMEC+gcN6hK1f9u47uEwFbyDhPvp3A9ys0VTxg7LMjYxZ0FPYSAxqHrbn5dC819dj0J9W5faE0pir2gT6O4qrPyjD7fdIY3aZ8zXgQJdNG2Oq2qB21SbCcas7uSg5IKkT5cfoI7vM8vTppm7c+zijkEWe3E6fAP9Zl7y7dZJj98gTbI+JHSrWrmdKDXch0v65iUt2CuQxX97i30PB81QIKhvx7w6b+xJg+qV/rO6OgIN6t3akWMuDD48CZuZnMTNIL2l48JIpgQw6B/iPCS6Txbj4opOSEMp57a21dYf+iaAmqVCvtYQEiNoK5mDnRk4ZXowfTeF1+FLSfDvrhbKH2/HM64jwvhbUhGGoHTYn9eworovOKkGcNTlxX8GkltBoXG+jVfAe9QxoJzJJkMUNT2BrV1qskmjFOJwBGF+aknzuMrN0drt/+d9So4YDQ5CppDDSRTBKD4gxR/aO23aCAnTk5mfBlDMbVymdnKlBu0M5dsjW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cd269e-060b-4107-49bd-08daa6f31f44
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 17:00:35.9429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUSEvHjltylCJfFio9x16GaJPmAzxu4yAy4rFNFAUryN41YR2ryvqn/vd4bFLHNaNa+7VKcZxwNefg8BRJnMqcy9Y1Eh15fL7vRTnd/Jcks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6628
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050105
X-Proofpoint-ORIG-GUID: -st_1Mb36q_M7UhKyTjPRTauMpsKEWb-
X-Proofpoint-GUID: -st_1Mb36q_M7UhKyTjPRTauMpsKEWb-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/22 6:42 PM, Bart Van Assche wrote:
> On 10/3/22 10:53, Mike Christie wrote:
>> +    cmd[0] = READ_CAPACITY;
>> +    memset(&cmd[1], 0, 9);
> 
> Please remove the above code and change the cmd[] declaration into something like
> 
> static const u8 cmd[10] = { READ_CAPACITY };

Would you be ok if I made these types of changes in a separate patchset?
This patcheset tried to only remove the loop/goto logic since it was
focused on retries.

Besides the ones you pointed out, I think I can make maybe 5-10 more
scsi_execute* users use static const or at least do:

unsigned char cmd[6] = { CMD } or { }

and remove some extra memsets so we end up doing it more or less the same
in all the users.

It seemed more like a cleanup patchset so I didn't want to mix it up as
this one was getting big.
