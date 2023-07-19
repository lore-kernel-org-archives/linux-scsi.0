Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69ACAEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 14:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjGSOph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 10:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjGSOpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 10:45:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5E926B0
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 07:45:13 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JCwn0h021952;
        Wed, 19 Jul 2023 14:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=WpUIBLqUcPVX5ssSA/GgIxMXFkGErNQBz4r7tsXk4sM=;
 b=D0a620zSzVFTcyOcIVgb0XjPdbsBynpNJqXntq+4QABV5DO+Tv9F61trdf5DK9xESM7l
 tWfCRdtgvkhif7i1kVavNrs8VCc2v3a0/VHunTPTG1FRMC9Sge77ndycysybORNNYelu
 xhTZiPkvQwB+P8i71ZC0867F09LvLXeYS5ZO9KZRXLe+8lW3uCweaX+yGVYQM3qv+FTj
 CeaWhlBGgM4VWoXLDakNdJyEa/PfEoyYsGMhAXC2SKFBkDp5QYCkv5UOPXZohTiMoatP
 p3Vd58GaWUBF1su/P0Yr3lzhpUYhONRCTSrKsxAiR8XxWTCQ4lF8oazgrRYB7SJSUjnl OQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88qqdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 14:45:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36JETXTM038200;
        Wed, 19 Jul 2023 14:45:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw6xy3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 14:45:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYyQ8NiEGNWeE9HKWYSAPiTBjVl0s8Sfi9h6s+a5kam3MItUl5x5nuGdzyr7pLfwZPoChHEC97S7C0O03VxP5fVb4ErKN6g4JHQKfXFDOrLDfr7MmYWYkEDF19Anw8Gtgc3lUfog83DIMnVumAgQ6Gbb3/kggrogHFXmYtN8LFsoQkzIe8fg94H8qGTnP1/oDzrKN6zszMU41UaMmeEYWv4fxj8xCsacVvzgo6T9duDBFeThUyhklqXCUUK2oicc194hC5AfdekaINdASuYt0gexAwk1+FXsv76PrCbJMckl4hdQoGVmlpBtio4d1UPkufxfgJvflrmuVGZ+eEYGTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpUIBLqUcPVX5ssSA/GgIxMXFkGErNQBz4r7tsXk4sM=;
 b=c5rQIp/2OCOFlJHV8QXJMdeO8j8kjWZvggPhTj13xFRaWwwzrYT0pqHA3727vQTG69LddkqkF0gvDYtITtt88g3xccHqhMP6Z4BaVdC59Pr+USEmWRbM/NLwm9cf8jMygi9RwqL1oaVWekQTP7ZunvFbPTzYio55PZQ/t01N6IhELMV20uMvzTrW36eqyM0UpPQq8MWVoXcVPTojnNqAXmALXPFI7rGjRs0H3qzyRwTDONO7fMr1h6xmCjQaZQ7IQZ8aJifHfoMK4Bb1tgvhFxmXWWqtHzAzN9UX+Lc5ssUJwEmEDPV4n6JM3T487FAPJJrG/KnsiP+pwZKew30iew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpUIBLqUcPVX5ssSA/GgIxMXFkGErNQBz4r7tsXk4sM=;
 b=GQyqy77mbksvLY1dp5XG71s4CYC1Ii/lzyPdXHXmBO72Y7UqbIWDtQQYUBt4OzJVeVr1HyjHIdMgWhUX2csY/nia5/wX13RMvNisz/UzVBou/eVOrQYAm9pvCwEcILtueZc+DInUTUW+AaJU1KozdCDvvNFeGq2uLm3OZ9dFf44=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB4860.namprd10.prod.outlook.com (2603:10b6:610:db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Wed, 19 Jul
 2023 14:45:02 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Wed, 19 Jul 2023
 14:45:02 +0000
Message-ID: <e4b26cdb-9ef8-1633-86c6-81f2aa270d69@oracle.com>
Date:   Wed, 19 Jul 2023 15:44:58 +0100
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
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aef4186b-fde1-cf3f-c491-f2747f08f426@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0271.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB4860:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dd16d77-e863-4604-e4a1-08db8866bbc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xnR95pyjl4X+onorqhrvrgcU++O5/6YEbkDm3VVcBsH2b8F54bJMpVmNp2VmBq6B1WsI9AufwExf6mqheQI/ECntIczmXcXs33k63M9jTNeyJnBvb8pWhaQifna02cWVJpB8fAWIzYigdPHdxkNCHqw4qkhe6AXjxSEcTFhOUc4K8KibHMSyllbSIKVIVfMv9w2pfjJ09jaKbEwo77pHTkBwPdDkXg9+ttUrLkjvHhcY/jbnpIJTi2OsgtUFNJ67LvvSvyRye7bitv3/sAAu05tETYqlM8+f0y6GsRb4t1N2Fdf9zea+YYADBN4eZXX4C/+8E+tyycRETGLc7A+hjyxUqPIanSHzTsCm+VV8eMUkgFRhRK3XxWZCa0rMtmHZaG9i5xbHEeA9ZR0B7Wv/+hlg+YICpkboFPQ+SJ0N9Vcp34V4yKiSvmbBXQ9b6tfZqW8QfVhQFIB+/VtJOsuQsQwZ7BCSUzB9ONvW9uwYZ5A631FM/ku2Ym2B5Xh2eBoBL1c9KNNoAuZcrRyCXbxsqN7NZnCdHorTEOyFvLzpmjMs/rItRgQVlKoUSjTn4T7KTaBCoeoWD3RT1qcE0PdPI9MdKn+A2h2K2QcoXg0wv6klEaxdnWJq38kTNEO+ye4VL+qFjVr8rY35yB8LdnJQSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(6666004)(6486002)(478600001)(36916002)(186003)(53546011)(6506007)(26005)(6512007)(2906002)(4744005)(66476007)(316002)(41300700001)(66556008)(66946007)(5660300002)(8936002)(8676002)(38100700002)(86362001)(31696002)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEd1eUZvVnpDU0twZy92SWxzeks5TjQyVTZTdEd1MWYvSTBoRjZpK3QyMWE5?=
 =?utf-8?B?Y2JNYmhDL3ZhMjZid2VsZkY2dS9VbytsWXUxVDdlcFJiQUtRZEtRUmpxbnB4?=
 =?utf-8?B?ZDJLR3R0OU05L2wyMXVxYUFwQkZEbmJidmo5aEI5aUkybEowY3hqWWk5amty?=
 =?utf-8?B?ZDBQY0I4YkhCL0MzUDlOTFQvN2FnOU1lWjQrbVptR3dSLzZtUGV3MzVsOG1J?=
 =?utf-8?B?cDhBU1pkWElRaVZRMjdMdVhFb1k3b2ZMU1kwL2hTd3ZpUi9CaHRDb1F6cThq?=
 =?utf-8?B?b1g4R1g0dVZzRFFLcUtrT3p5LzhpZGJJZFVEQzJwMzhIbEorUTZEK1dMSS9O?=
 =?utf-8?B?THU3eDlVZVd1MnJnMjJWb1dacTdpYjlMd1doQk9zdTd5bzdkSi9ZYU5Ma0lh?=
 =?utf-8?B?azU4NnFkaWkxRlY1cmE1NFJ6NTNlbS9SVlN3UG9kd3I5VVAvdEdWRmpEUG9O?=
 =?utf-8?B?bDV1amNYdUdHUG9pVmtQbWRFdFBaenlqQVFwTjY2Rm5RN1QraHBFTSsxVEZn?=
 =?utf-8?B?aGYwdGlOR0NMV2ovWXY3VmZnZFBpM0dFY2lURjZPbkxkNnNiTWovWk1ON0tH?=
 =?utf-8?B?QVArRm9FU0prQmlyTkVlYlM0L29IL0pRUzZoeEcwTVIydEJmY2pDdU1uZkd6?=
 =?utf-8?B?N0lDVTRZVzExcVNKVHN4ZVFTQjNvazJOTjYvbXZIeWNOLzdiL0ZJZnRjbTJw?=
 =?utf-8?B?STVwaVhYVlpuZDUzaHdlM0dIbi9yTDNzMW9GN2JrZDZQRzBYMitzV3UzbEl4?=
 =?utf-8?B?dHp1eHZJZ3I0SlhoVVJ4d1B1Y2lSUThhZ1ZhV3JsSzNKQ1RDVzljeUNVT1c1?=
 =?utf-8?B?Mm5NL2R6Z2F1WXVnVlovREpoblpodFl4ZmpUYTZYa1JzRVd3YUFVZWVHWE9z?=
 =?utf-8?B?WXNSSzN1V21Xc3hXQUtYMkxDRy9RWUF6NkE3K1NndDd5ZUVLUWZyai9ZN2Zh?=
 =?utf-8?B?cDdkNFJnb09DZDFuSURzREFlL2l0VEg3ZXRuQzRzdkxUZkNNWkx6bEJIY0N6?=
 =?utf-8?B?Ukp2WXpGazdHU0NlNFZFT3RSWDZNTnA2VHg1b2s1ZnVPQksrclNRQ3ppTkxy?=
 =?utf-8?B?SFkyY3VjaWRENmtkY2dGLzIwMkkxZTlOc2pZRU9FWXQ5bnFqcks1dUxaQzlM?=
 =?utf-8?B?Z2UrT3hzOUFsTXN1akFvM0ZaQWhkK1hWcHhxM1ljS0RnQ3kvangrOS9sZmxR?=
 =?utf-8?B?emE1WWs3K1lKNjM3cEc4Ujlzcm1lSEtmcldWU1JvVjJKNC9UdkIxUHl6VWNh?=
 =?utf-8?B?Rk8wV01QV1lzQXIyazJvbHoxZVFSZUdyem5NY3d1eVpIRWE2dUlzZlpEZG1Z?=
 =?utf-8?B?MGx3RTlCRGJWUmJNRnlTU2wxc2NONkJuSngxa0VoWXF0Z1k0UlVsSnhRNzBp?=
 =?utf-8?B?cFhtdW1qSlpERkFlRzE2L2MyVDFOd0tPREk4Sm9hWTNDekhCaTluVkNHRWdJ?=
 =?utf-8?B?MDhpUHNmT3o0ajF5c1E4bTZjaGc1Z2Z0dy9vdFlmNHphR0pQS3gxWEwzV0Zr?=
 =?utf-8?B?dzdDR1NhU0J2WHlYUFdiNzVLY29qZUw1OUhTL1ZpNUxvTXcvRDZFUUgzNXlW?=
 =?utf-8?B?Z3gwbHZuT0ZRWUFvWGs1UEdEVEJ6ODlrWjdIN2NFTnFYOGZleW9QOFkxNVhy?=
 =?utf-8?B?bmVsWWlzY0xFQWtjLzMwSnpURUpDMkZpUTgxUm1xa09OOW5saWJ4L0RLdUtZ?=
 =?utf-8?B?L2RiOHRtaVlkRGFEM3NYc0VubCtqYUsvMkVxSFRXMnI1SnBpQUprczJSdzlO?=
 =?utf-8?B?VEF1eFdPcHBMSkUwRy9kVkxrQU1Kc1Z0NWIzQmEvbVBOZG9HaW1FLzlpaVln?=
 =?utf-8?B?cDNUemY1cUtxWDVmM3RHTTllU2s5dnRtM00zYlRtYnViZjNNOEd6VUZuNTZw?=
 =?utf-8?B?NSsxSW1xNkxJQ21PUnB2TzdkU2hjNFJvVWx4WnUzR0JnelZ2NThNRkxSZGNk?=
 =?utf-8?B?Nk5Va2NxMllvYkwzWmN2dTVMNWR4cnV3S3BTdkRzQzdGYkxoRC9aS1l3VkN3?=
 =?utf-8?B?eldxOWVEWHIrM0FhSUE1RHA2VnoyaUtIeFBUZEdnYjR5c0xmZ0dPODN6K083?=
 =?utf-8?B?a1NjNnd0b2s5SnFjcndlUFh6TWl4c2w4NU5VenU4Q3NXM3NXWkJ5ZWZ5ZmJs?=
 =?utf-8?B?Yk4waEtlSStTM1pLSm1LN01JWFVhNk1JZ3pZU09zNnF5bmtoV1dDbGJRUHFk?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YSaX6X8wPxw1TR7e2RglkiLvhLjNPNGMG9kYzaXrOESFmIvnp8quw41PRJoqKmiVP1NjSGLXUOj9zmZEwikcAf+ofE+uhabfuaF3pzDZ1Nw2KBrd51FQfAHtuBYssGzZwcVy68QwP4U+u4SWQWRKKjR4Zg/7j5R0VkUw3iuF3UU2+cIhyNwSWhXMejiGLB9lu6/HP2Se0QS907GBa+hGSIqmF9nMPmFMkAxcljiKqiSgUXtaCNFlq1VLOMxsYhM3AWgKR8M3cEkIvmkoXOMfNzOYuemJUtjsxydpzJSgwn8+sZADmf1/r3hsyBS9Rf88lVXQ27dpyZngQbOPRjwvS6p/FRBAxygvZvrWogXhDcGReljApT5oufVn0aqL8WAZtSMY0w8czjMtBz4xN0ziQQrptODA1rkG/inzO+JIrwtcVJoopH4qwqlalU16sCGiCeD4nHpyKKhVuOxX1gN8x7JfCoDV88PQc41q2haDXRSESAl7WTgAcECVs8gcV6Tp9N9lmBzS1b9KS+REk+ugtVbDcTMXXB/VVuTYW2vBEctsqVEgWZbMow/XhQaehgmeCahvpjqHQ1BPvnUmVZ46nbq1047QjCLdvckcM8f3OOj+jC/LC6pBUmn95EYPKodvGLeARB7QgHkeDb4JEyR721Vlutl7VgZqkcpabgPUbtKbXPrgi7HuRzZ4Uo31GkbWVTQpa/4Sp0opJhZKF/BInX1kBZDnCpBs1ebl0HFnwoAqJ+M9/AG0fCopG3V/UWpsltdN6AudNi9YKffLbyhDwKV11OypLSI6NQMuzpim8inS0v2yKZCpTgqaczyVX6bruAxHqIIYiEg7I+UYuKj6znQUARFzql6mljyE+iXWVJ9q22Gyj88pQrmHW/n/yV14
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd16d77-e863-4604-e4a1-08db8866bbc5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 14:45:02.3427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auVLoysCsYBqv61c/soVoaZEMkmU3hD3mUIMenwloCUVbMVkH64U1op2hRdyznEkKvRbMFqyuLUdRFBwmZpSCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4860
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_10,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307190132
X-Proofpoint-GUID: LEPjYub9e68sjdnoHqlIY04PG0gf1VEj
X-Proofpoint-ORIG-GUID: LEPjYub9e68sjdnoHqlIY04PG0gf1VEj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/07/2023 16:31, Mike Christie wrote:

Hi Mike,

>>> +
>>>        if (err == SCSI_DH_OK) {
>> As I see, err is initially set to SCSI_DH_OK when declared. Then if we need to retry and 2nd call to scsi_execute_cmd() passes, such that rc == 0, then err still holds the old value. This seems same as pre-existing behaviour - is this proper?
> I guess this has been working by accident.
> 
> When that happens we end up returning one of the retryable error codes
> to dm-multipath. It will then recall us, and before we re-run this
> function we will run check_ownership and see that the last call worked.
> 

I'd suggest that we fix this up as a prep patch, if you don't mind.

Thanks,
John
