Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992C5C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 17:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJTRVm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 13:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJTRVl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 13:21:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC4610CF98
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 10:21:40 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KGwt8h015155;
        Thu, 20 Oct 2022 17:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=gakjEclrisOaD4RL0mivbtLlnEw2rUxaVcbiqvIqBRc=;
 b=f/cKX/SEjGMtl1eUk4Issoqcv5BfsxbIxH5A25+bgWtrjU2gIyOJMSzMEkoa0mzvGUY3
 TXOAxfp9bssPN01pNYxQZUk5xysqF8oPUOxOKPkl/hYxUEtuL8oEdc/j2uiNmRggXZYg
 Nvpg2QB1YHM0wucrbolmCwlZhyNPkXS5pA4E36lg0NTt4YXQONZS2f9K553EE8BgBx1Q
 sse36xnyi5YPifrAXkx8V+wgkPmnY1pL1EW0CcTFcu/Z7Ls8UenDWTBAITFetJjnUDNG
 awHhF2BlbU6FW2r2LmUYsx2FR37Rp3+cpYICTY8ACmPV4QTq67lMo0veTlOEhfEIwACe iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu0679n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 17:21:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29KFW5iG018333;
        Thu, 20 Oct 2022 17:21:23 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0t64r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 17:21:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbzN/RAkF4TNPxJcg4er9iop/bpyoF0yu2Lv+tGPCqbNQAiOsNOSVjmp8V1iNoyysSC9+4NaajQiE8I4NjuaeoWBXRb/uzs7ps6XoAAf29sQ8NrmDxgNx0k6oU6RZMtu4jIhss9vkJA5Xk1ta/Rwjtf7boE8vAznGQBrGPU8ro6+HQZzFr9/Fj65Lz6Ma3sOqLjFrkhLrkFQ2uhBXpZhaDm0B7FY4AZwjc5KGDzWocbR8f2yfagaXCKoY8bgB4vgvg9GzItLxvO8HiiHE46Qe9398MN6KIhq/wVIIlfUb93xvC26KdLBOlNMGI9b/fcjvRoQEUxyLX1cyxcbIg95AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gakjEclrisOaD4RL0mivbtLlnEw2rUxaVcbiqvIqBRc=;
 b=WpD0X48iEZb2HmlVQJeXt9AKO+m30UYEsESdsb80r4Sa8bG+8o2KGfoDm8Z3vWtYP+IaHYTHehVoPd7jMcZr1NEgQtyXE1e6sQkuodnjI5CG5yXp2iEBoqyqpsOUe17ED9s3en0ou80qcENl4IbWsy8nG3zxZAi9Ga66JY0fUCOT0qIUZXLHb1SsPp4vLVcOr5j4I/OgVC5Y2QCbmfNOsI+zUHF08EVxMxV8vBmqukPli8tJlV4Ep0g0BEeud5YEzmIfb2y78gEp8M7TcfvZDYD7wuOr4+1AAsD1JPfHW7dsZMVhtgpXuIfoqfDAzQm4Vl5Hx5LDnn6vXofdUzBnyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gakjEclrisOaD4RL0mivbtLlnEw2rUxaVcbiqvIqBRc=;
 b=WEOguQ3y2pODTOK95RNp9GByspYgc5Fcke7M4k+lh6RfFVQy+7fq6pWMj1XX2Fu4nkEscxXz8RklrKIQRuE0zUePlyoV4UNCNeHkpYOR9q9eAjHSGtUF109afOIMsS3tFPLAFMO05fUqURHsmTPshDxLbmdeQyH84VPo1ofIxcY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Thu, 20 Oct 2022 17:21:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 17:21:21 +0000
Message-ID: <79869806-8c1e-9f77-c904-b5ed13d29f85@oracle.com>
Date:   Thu, 20 Oct 2022 12:21:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v4 09/10] scsi: ufs: Introduce the function
 ufshcd_execute_start_stop()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <20221018202958.1902564-10-bvanassche@acm.org>
 <d3d656e8-f855-9ecf-3d8a-0da0e0f12cd0@oracle.com>
 <c734f63a-9634-89ec-5bde-f0111408f0c5@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <c734f63a-9634-89ec-5bde-f0111408f0c5@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:610:52::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 13cf5da1-2189-4f32-21aa-08dab2bf81d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MUrLzYIynt/V1DIoUJhJfQpx4LxqnrlhcaanvahfOYgt8sV8R7wX3koqCb0QhrKDinaAdQUzrT7YNMIILFnjxkQgMNSSZutnLcNKZJYAqSsiGBmW/ySEg39VZsnePITf/L22G/yP0iLFRgU2cRe7beHMv99yCqAZNjMgnhsUXdBluFdtQIxq6aj6nCkNGAP0bB4S5/l7RApPH3Q7hXHKgCheel9GP/vKK2JH0TNWK2mMAGagXzTSiisu5tAXlg05tByfab4sORSR8ZZ0z++ApCpEIsAnc+bTBvlwu8dhbIZ2SL5S6Sc3nf8kTSOg6/6IV2xZ4zZIn8Od/qE0p8Yv+ufb21FAC3U8OAAROgAx1mPmdEwganLFnXYXqEA9UGEELEQU1oT1Ul5EOUK+3lbSofqqlbi+MxUKf4kr787oy4cDLNRVoWgX6HRMt5RERQ74POTY48xtkfyFXacaY4L2o/QRw+4V3F+4jxGok6IbRjBKMZKJECqu2l/jnmNqty7uVI58PN42syT29zXnkfl37wD2Sic/IoVP0eDDB2TrORtmaE1ul+21et1kUtYhqolIrMlnQwa7ipCzdsD9kFa4kHEtv3drBWezBiDoENddZ/w0q9eKZMpacBeEwQc6ppMPRu9c8fclXC36IT2XsHKVTFbLAjEvyPEU+M7UtWHdeHFx7on4mkzrCpSfeXM03xJKAgInl4esl8lnJt2bKAx5OuRcTHOphqjyDq5t2ocuBma+GqETPPjKAT9VSV3Y7FlOOcTl27iwFa4CvG8hcpEbcXKaHKBxf1B4OizjbkXZW/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199015)(31696002)(36756003)(31686004)(38100700002)(86362001)(2906002)(2616005)(186003)(5660300002)(53546011)(6512007)(6506007)(26005)(478600001)(83380400001)(110136005)(316002)(54906003)(66946007)(6486002)(6636002)(41300700001)(8676002)(4326008)(66556008)(8936002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGxxL3lDNmxUelhxNms2Q3JiTERsNkRtZWJSS0l5RnRlYTVlVWhVZ0ozNkky?=
 =?utf-8?B?Nmx2NmlLMm1Sb0M1QkNPRkg5amlUS1lXdXBadzlwNmZaZnM4WWVvL3RUbERM?=
 =?utf-8?B?T1RSRDNLL1ZnMmtFdnI0RjYwYlBhVjdxdkJrck0wNDRjeUdEeEkxdWswNFRk?=
 =?utf-8?B?RjlDdit3N243VjRKZ2NVWjBpUWdkeDFjTVJETWhYQ3dSbk5VRkREcjBHcXR6?=
 =?utf-8?B?a0k5Mzl6Sm1ScG5oZkNhMW5ZR2p3eC9paFdzV1hBbGhvRjloUEtkOWY1UGFG?=
 =?utf-8?B?Q0d3RDRQUndYMmZZd3ZYVm9iYmZ4N1dzczU3eHVRMk5HV3l6R21CV1NCWGJs?=
 =?utf-8?B?LzhrNGlvbWZGRm53dHVkQmhtZmZ6K3dYN0gwR0dEZlNpbDdvdG1wTnd0WGZH?=
 =?utf-8?B?c3RpdHBQMitzSFpVM201Y0J5RjYzVUFjK0FwcDZVNVlLWTR2MFh4ODV1c2gw?=
 =?utf-8?B?NmFXOUxhTFU3SlJXRjdPV3dXK2ZHVDFDemhNUm1QUFM5SG1nbFU5dlF3N2Fw?=
 =?utf-8?B?cnFLMzFKaUU5SGlNaTNYaGZWNnJTR2xUYjJkT2syNVdCMmZLbHJEMGlJUHJ1?=
 =?utf-8?B?aHAwT3NDajU3b00vUWozaXBlT3RXRUhoaXhSOWVVVFkyQUgxd0FIcWdrYzg4?=
 =?utf-8?B?aGZYTU1FWnI5REJDRkN5OGNJQUZYQ2tCQmNqMHh6ajEzcjVyM2kzU0s4VHRG?=
 =?utf-8?B?bndubUJlcmZrdlpHMHhEUVhCa24vaFE0elFDZHNDWjkxRlRtZzF6UU9pak8v?=
 =?utf-8?B?YjFKZjFjWGlnT3ZzcmZwVVF2UmJYVDdiWHMySlFmazBnV000U2pkWWVJNndY?=
 =?utf-8?B?N3VoNHJlWFJFS3lsTFp4VmNXa2JXdW9HT0g1SUVPMFU0KzduaTZWazJ2cDF1?=
 =?utf-8?B?NWQvQldTZlNKTUJVOEYyaDVYamZxQWdyL2d2S2hQSGYrSlkwUkFqSXNrT0RK?=
 =?utf-8?B?VENadnh6cGZHYXdNUGhoZCtkUWJlK2VsOVFFOUNKbitZb1dURG93eEQ5UXdW?=
 =?utf-8?B?RERTQk9Ba2UyZkJ3aEFyQW5NaTRaM3h3ZGRpUUM0ZnFZQ0k3alZKQWFiNkpE?=
 =?utf-8?B?eUJ6VmExNW1lTzA1UHVqZzV2MXVpT2hwS0t2TEdFVDBESzc2OGN4Y1V4MnQ1?=
 =?utf-8?B?QU14bnBCTDNXbDlLSWVBR3FTaXVxWlFTVzBpdkV1Rnc0SjFKWkNHRGlBWTVk?=
 =?utf-8?B?Z21RTEhEUHdvV1gvMmtVdVV4aHFpcStvbUVwMEZicDRwdHViNk9nZThZNnpj?=
 =?utf-8?B?Zy9vZlg3L1E2TENsbys2OXFoOUdCRGdiZ0kxT1lBQWRucDRCQ24yV0V2cHdz?=
 =?utf-8?B?NngxbzNpZUprM1JOd0ZCT2hoRm5DSXlCRHc2Y3JxTVFVSUVIbzFvSTR0TU9C?=
 =?utf-8?B?d3pEdXFxWGd2LzkwSUNGUVk2cUl3dkw4eVVGRW1LV1FSSGJjZXlha0hzUEh5?=
 =?utf-8?B?NENaVEFjQlM3Q1B5OFQ0YWM3cmt5WlFHUjdrN3ltMXJLOHh6YTlxb2VjdHVD?=
 =?utf-8?B?QWVEMENscnRCdDBxanBDODFrU2d2QjJPRWE2SmtpbUZnalpQditIWFI1NlVv?=
 =?utf-8?B?Zjg0Z3cvWHhEWUhxMW9GVjR2eWZIV0x2SFcvYzFjSm9TZGhXNzgyWVRmQy9J?=
 =?utf-8?B?QVQ0M1RzOHI3Uk5pVTFPOWtMZ3pLNG5BYkFwTmR4Q0xQMHhZcitZZU5PSEFG?=
 =?utf-8?B?Z2NCQTFaMEdiK0lsMVFDTWZ2UXp0OVRZOGt3VmFyVHFqTUw2WE5Ub0w5Zjd0?=
 =?utf-8?B?UmtDUTUzNnlFNjhDNTdiK0NjUlpkYUJwTll3Q2o5YlVyQ0xrWFhWTDVJN1Bl?=
 =?utf-8?B?dkRSQkdMWnd5MW9JQjNwdjZJRVJ3V1VoMWVsUjQ1blAySHFsQ3p1Q2lKdEVN?=
 =?utf-8?B?cXhlZVFuZDRUa29QZWo5Vnh2Kzd0ejZJRWtubFpSVmFQVVpsUC9uaGNaVFpY?=
 =?utf-8?B?aHVoZ3JhRFhKTzVFZU1nVGVZUUpzL1QwV3o5MWQxSGIrYjJlaHoveTlGN25p?=
 =?utf-8?B?RFNZRlpaK0lubjNCRlpqbW42M1RxeWc3RkJGcTZJZm1JZmk2Z1hOdHZvVDlS?=
 =?utf-8?B?WUNQcERvazdia21tNnQ0c1RYQnh0THY4MnIxUEwzSksycVVBN0ZVN2daRkd4?=
 =?utf-8?B?cjErdjlzR3RmdlNFSjNzTHhMd05ReU1SR2d4cHRxUkhQQlpldnVmem1wQXVB?=
 =?utf-8?B?bFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13cf5da1-2189-4f32-21aa-08dab2bf81d4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:21:21.4257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fmdbz2IGUVdme3L5GdB9Lg+UOknniQa3RuBf7hYch84Qsbtdh3zEziejY2NGqfhxIWV+ibMKFbYEFF/85UEozaol+GAEugvbO6TPGlpkyvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_08,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200102
X-Proofpoint-ORIG-GUID: pemE8f8KbTCBNEEhRl6Kiz_dVetIGMnI
X-Proofpoint-GUID: pemE8f8KbTCBNEEhRl6Kiz_dVetIGMnI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 4:13 PM, Bart Van Assche wrote:
> On 10/19/22 12:57, Mike Christie wrote:
>> On 10/18/22 3:29 PM, Bart Van Assche wrote:
>>> Open-code scsi_execute() because a later patch will modify scmd->flags
>>> and because scsi_execute() does not support setting scmd->flags. No
>>> functionality is changed.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>   drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++++++++++++++++++-----
>>>   1 file changed, 34 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>>> index 2a32bcc93d2e..c5ccc7ba583b 100644
>>> --- a/drivers/ufs/core/ufshcd.c
>>> +++ b/drivers/ufs/core/ufshcd.c
>>> @@ -8729,6 +8729,39 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
>>>       }
>>>   }
>>>   +static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>>> +                     enum ufs_dev_pwr_mode pwr_mode,
>>> +                     struct scsi_sense_hdr *sshdr)
>>> +{
>>> +    unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
>>> +    struct request *req;
>>> +    struct scsi_cmnd *scmd;
>>> +    int ret;
>>> +
>>> +    req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
>>> +                 BLK_MQ_REQ_PM);
>>>
>>
>> Can you hit a case where we have run out of tags (__blk_mq_alloc_requests
>> is hitting the blk_mq_get_tag == BLK_MQ_NO_TAG check), the host has gone
>> into recovery and so commands are completing to add a tag back and then we
>> try to call this and get stuck waiting on a tag? Or for passthrough do we
>> have some special reserve?
>>
>> If so do you need to use BLK_MQ_REQ_NOWAIT here? Maybe do the retry loop
>> yourself like:
>>
>> retry:
>>     if host is in recovery
>>         return failure
>>
>>     req = scsi_alloc_request(.... BLK_MQ_REQ_NOWAIT)
>>     if (!req and we have not hit some retry limit)
>>         goto retry
>>
>>
>> or have some special reserve command/tag.
> 
> Hi Mike,
> 
> No other SCSI commands should be in progress when ufshcd_execute_start_stop() is called because that function is only called during system suspend and resume and no other I/O should be in progress at that time. Additionally, there is a mutual exclusion mechanism in the UFS driver to serialize system suspend/resume activity and error handling.

Looks ok to me then.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

