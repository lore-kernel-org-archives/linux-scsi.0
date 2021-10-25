Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE84C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 16:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 049E26023F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 16:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhJYQHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 12:07:13 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40872 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230511AbhJYQHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 12:07:12 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PEto4Z030360;
        Mon, 25 Oct 2021 16:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=aJHpTdFSGIuEiCzHxnsRFjzMx8vHe99WKm3WH9aBVoE=;
 b=q5guxQhTePg1N44th9kNOUmUP5ytH8DSSME79p6KZOmJcsEmpDidBK/J5rFFQLk6PilO
 d+Pd4mgHJZ1/70reIdS1108yPpMzAuWPwZnPUE1ZYeMQynbyje2xfzXut0vBtN3r40GS
 OAEAt/3LU1UNPlx7TCYklCmF7kNl+wjo8EX/0hN/AvPaxz7w/2nL/suzsbNzXAb3QsHy
 /k+MJBbsholPK0lwUZV2R7Cp4Pq100MI72llTsN5PN67Ce49WDNa/+McuYZq1suIIU1b
 jOOIrQsym1+W9dZc+jBbHDlUjZuA9gwcvvf625Wlaxjh/uJ+G9m1UmnuWzf7AeBs6J+M PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bw6v1v3vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 16:04:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PFtro4167268;
        Mon, 25 Oct 2021 16:04:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 3bvv5s8a5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 16:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+TTfk1mwxtJBvvrQKYNmFzFETIIeVD+ydUKVJ/NimmN8fzLAp/gYH9MnU0nwhV/omVKmA1WRjum1ZIbia7I1AHcH59/BzvPQ43hNpt/m8aQ7YeUISdy5sk32ZZ4rdHcdAxPFdylvCxwUG/Ko6wMJHXmVjEmBPVPam955erx80TDDAXe9h5ARbzFrsar5U8fdQ4FsDnyVaUcxk7I3Gq7wE8Eb0M2C7okhMoFBqWwSzenzpZy72LkaS4TksG1jjX7AIxzENnt4zsIA58y4hyIE/r2jGj77zw0zv6Iy0TA1HZyzu/qIkHr0VpH7BapklrVaafxUM9agBdw9VXZKuh+/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJHpTdFSGIuEiCzHxnsRFjzMx8vHe99WKm3WH9aBVoE=;
 b=cfSvgboQxGfhg07eUm9IMq0V+LBpOc+qBS5gZY87/jOZk38GN0UbA43qHmQWwZ1/bNKz1gHNZksv84b6rfzCJgyZ/X3x21FugAJXTl87eWi4OuS8ufAZ0gxmnGTFDlscS6K6HAUfktwABCLM9hSsrIhkGglr/F9n5PX11lnlzSalp9o1CdXTRSz5aEuoaAapxaToKJatRejF6953I81qmbaVibs15/mHKnCguZHuKwnSboMdIE63wICa8/Mcb3m1mPbDeGpqq6gt0cZzTiCTDUS2TTQkf+MPx9ieEG2oMW+++hYWdVFm/d+JoiFx9Rn3sC5ytA+Yl/zxbmFa5juJtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJHpTdFSGIuEiCzHxnsRFjzMx8vHe99WKm3WH9aBVoE=;
 b=tdzZdRMzvlMHvlPfLb9alZ1/m1yD+W6O5qA2S+fd+4k92LQ2v9ymDonhb2I2AE07aAszZoFKOfxWkjxEHGk27wjDXEdRhhq0SJmNgGmkmwl+Gg31F0Z/Z+dgW8ZmPByINTo5XdRyjvECbN9Zs4cPnrcXZ4C3tgxJefp+rVxafhs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1689.namprd10.prod.outlook.com (2603:10b6:4:6::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Mon, 25 Oct 2021 16:04:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 16:04:44 +0000
Message-ID: <e2d7796f-68d7-1cca-f9ed-0f2f2f3fdeb4@oracle.com>
Date:   Mon, 25 Oct 2021 11:04:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <20211022064359-mutt-send-email-mst@kernel.org>
 <94289c36-431a-513f-9b52-b55225f6b89d@oracle.com>
 <28250f62-ff38-901f-6014-9e975381d523@oracle.com>
 <20211023160838-mutt-send-email-mst@kernel.org>
From:   michael.christie@oracle.com
In-Reply-To: <20211023160838-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0009.namprd21.prod.outlook.com
 (2603:10b6:3:ac::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.19] (73.88.28.6) by DM5PR21CA0009.namprd21.prod.outlook.com (2603:10b6:3:ac::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.2 via Frontend Transport; Mon, 25 Oct 2021 16:04:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9b7371d-2c95-4a53-f3a7-08d997d128e6
X-MS-TrafficTypeDiagnostic: DM5PR10MB1689:
X-Microsoft-Antispam-PRVS: <DM5PR10MB1689ECA29D3CC36400E14AF4F1839@DM5PR10MB1689.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cvDneqNm3jLdYyLgZrOurTVu03kVk1EJ6ZdUL2oMIHqxRS3MAXKnP6ngP5pmVyppQjaBGr/WpzMqb3p8L1Uk+URUeXCHBRPu80r0/zID52UEe6JW5vQ1hB+r7bE2NI07hXhZPDbsJkYyoF+agyzJRaH2ZPMPAHmHp9ZuIvqjWq/ESzMPe4iAweLZIHd9BF3vON00wwGODJZjPwRsLzmmTHLA0V19b+s/FqI+K0pBFpNLkIfwveSuaRNBCFPIdYn7IdE1+G20u9bkGN8XKqrsHlK5QTpBH9C72aK3aw2zJycvcHySNyBYkbrzEgijVzlVa09bSUU7k8at6+D5oKgbshBHRm2ZlZgQqathvuuJ0ck25kvjxot6077pK/zNgupuXJn65WPNUXRuQEhrCHAVM9OJK4a2/nT01pBtozGLGd3PVZvUCOnWuC4rl1I+RAMmVXOReCLp0NXRNQEfx1tS0k/9DKpR2emoqXXF3TFJ4DuIFr7dBg0O4CP6PhjDuEzFp5q/vOIykj6aSI0bnqVhZc6YA2UO9Ksvxg01Hh+Gyfr6QE/L9kaSM/MopYJtlXx2AHPQwYDsLpYBrD/b+Z0Xx1yWYOQc9vsLgZqTg/CuobRaJ1cDXhfrgO6/H3KZuTDzzufD0EHTr8MXZKGTPO6td1RucBJ2wJls3ZCxCIa3qofocOPbwzsNqn6kUNVjXoYUXwRqT3Mf1PT/I4NA99My3oDJ54xC2FJ12fW8FUfKjDo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6486002)(2906002)(66476007)(66556008)(4326008)(8936002)(8676002)(16576012)(186003)(5660300002)(316002)(6706004)(6916009)(53546011)(9686003)(2616005)(956004)(26005)(508600001)(31686004)(31696002)(38100700002)(86362001)(36756003)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVlrYysvVVpsRG5vSXJrUDNTUXlpenpUTVVzZmo5TkcwbEVON1pDT0t3OVd5?=
 =?utf-8?B?ekVreHJ5UkswM2pIUFBSczRleTVRVkE1RTlGcjBFdXU1N3RyM29XV2JaS21x?=
 =?utf-8?B?VXJYa2JPL1lrVkVPZzlxei9yMVhORXE0ZXF5NXppRnlTRlNVTVd1VzNieWRu?=
 =?utf-8?B?MGRXb1NjWmhxREU4MUpuWllIZHo3bGFrZmxwaFV4NUs4ZUFoeGZqdnFFaWFP?=
 =?utf-8?B?ZFhMSkJETXVUNmc0TVMyTlJMdjVPSmRhTzFIWFFYWUhDeCs2MFF5V3o1aXVl?=
 =?utf-8?B?MGt4eXFzcGVlZTE5K2dBNkJWb2VvZjlrMEJpbTRJdVAvNE0rMmxuanhuNmNo?=
 =?utf-8?B?MlFzeUEwS2Vrb0w3VlAwQjlBbnArN1cvUnBxNndQMjJEVTNPdUU1R2hsWmEw?=
 =?utf-8?B?b0l3MnFWZE9YdEovTDhSSUtyNG5EVW5UYUZIRVlITnRkQU45MU5Ob2NRc095?=
 =?utf-8?B?WDYvc3JwdURmYmRDUHhrOVUwT1VJOTBaaUdPQkZmK2VEOWFXR3pPRG05MVF0?=
 =?utf-8?B?VlVvT1d1aUxnY2VURjN5MkJ5eUs4dzNjajdQOXFuUWh6RHdIdE9GeXZpMjhJ?=
 =?utf-8?B?YUxIUy9BUHNicWV3RGp0ZGNiT3lSdHoxNk40ZmJQWlFxY3RVK204enMwSGhB?=
 =?utf-8?B?WW1YV2xLa1ZpTUd3OXAxa0pPV0s2RW1iRGZaYVlZTXViZmQ2VDhBWEZQdFRZ?=
 =?utf-8?B?eEJDWk5vTzBPQ05DWkhzbHpHSllZNitXcUVydTJpRUg0ZTBwcm96SmFzbndv?=
 =?utf-8?B?NVI0VWcrdzNQUTNNNkhKVXI2aVR5T1RZTDAxS3JKTnF0SysvYnZGSVYrQmVV?=
 =?utf-8?B?ajRNcXFQdXl1SWxTTUdLVmVxMGYvMlorWDlDZWpxeUxpbC85WFB3WS9OU3Mx?=
 =?utf-8?B?WmhGQ1orTU9KRURUcUQ0SHlTOEJzUXRTbXhUOENGZDQraUpNUGtwOE5WcnN4?=
 =?utf-8?B?bnEydk9TMEE3QlhGNHQ0dHNnRWFJMjJMY0dPcm1iY1gwc05Gb083UmVjVzhQ?=
 =?utf-8?B?d1dDaytYdEJSenRIOHdXVzNJdmF3bjhWSkVLa3VXSVlqRTR0QlhuZTg5UlJB?=
 =?utf-8?B?dXBlUXVUSE4zUElNTkc2d0xSaVF1V0h2SmVrWXZ3UWlsVTdBRmV4MHZxMWlp?=
 =?utf-8?B?S1RRQVZyOVE2N2RTQkRaY2g4VVRydnNXTjk4MjFXd1AzbVBDL0hqTm45M09X?=
 =?utf-8?B?dEJYMjZDajRuUzdHS0NNYnBEaXBVV0RyTzMxVEZtT1ljL3AvVjFPS1p5b0pB?=
 =?utf-8?B?dTVKYmRpdFFFbEhBZmVoaFhSZ2tXMVJOSVFRQXFocHRVVW96Tjl3NUJQczQ5?=
 =?utf-8?B?UHRDSDU5dUMxZ2lXSFVxaWdDcnkxeFd5b3ZnMC9aZEJmb1JRK3h5YmF5OHRm?=
 =?utf-8?B?NFF3UUs5cUFFMi81cC9VSE4vd3BmYTN0M2NhM2Z5TDBBZThiMWpacjZ1NFF3?=
 =?utf-8?B?aUZJQUpJM3pFc2ZIOXB3T0w1U1F4K1MxT2J5WmlEVTA2U2pVYTZQS0VwN1Q4?=
 =?utf-8?B?cjJHTm1Ieno3RHJjb3dNK29VMm8wQy9GQkpWdlNYNm9ZZTBLQ1Q1d0tGeE9j?=
 =?utf-8?B?UXhwZ1ZmQlY1eFZzNXZWR1hsdFlNVGV0VTllSm5XUmZvYnZEcUlJRVlBQ2Vh?=
 =?utf-8?B?eTljT1J1TVZncW9mZlpyUmpXWUw0T1ZIZ3pZTC9abkExVEtYbWhkUGJBMEFj?=
 =?utf-8?B?aUtlVUVYWTA2N0VHTzd2dnpXUU0rSlNXeGdQbXUrejVCSmNEeVBTS0JEVXl4?=
 =?utf-8?B?VG9aM20wM0wzSTRlTEJuVXB4clJQaU1zVC9hOVhXelhpSFdrMzMvTlhidjFm?=
 =?utf-8?B?eGRRcWw5Qi9sa1hwb3UxaEE2cXowZ3NRcER2aTl5TWN1SWowWHZvWk4zU2xX?=
 =?utf-8?B?a2lYUVBvSlY3MnlkTysrQnRlN0I3dk9ienRnem53Y1pSa3czZVU4SXdkZVpK?=
 =?utf-8?B?VTA3MU1ybnZhcEZmc2RwNEdpVyt4UHEvMGVoLzJNNkJDU2s0dmhZRUdqdzNQ?=
 =?utf-8?B?WkRHeU52aHVNQ1pCNHMreU5QWndLVDZpeTJxbE9rZUNWUFM0N1ZqNVRxaXhE?=
 =?utf-8?B?UHFhbXJTSnhDM05hT05qN1FwMFhoMEdzWW1aOHBIejdLbFBPSkhmK3ZjQ2RT?=
 =?utf-8?B?UXd0aFFBbEZSaGxFc0RBTjRWWENNUkU3Ukg2ZTA1QWNvVENNOC9idlhhcys0?=
 =?utf-8?B?THVOOHVOUC9jblZIaFlZRFZxK0tSbXBsSURXZ3U1dEJTekUyd1hEdXBUMW1I?=
 =?utf-8?B?eTVXS1MzSTQzenhZd1lUbEkrZkpRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b7371d-2c95-4a53-f3a7-08d997d128e6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 16:04:44.1098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f2/SXA8pkmbsyDRK6oi7e7CfCcOlOTtG1N2SPZs2dtWkxm0+t0mM3HIO3gkzbxy6j7+eW8Dvtmc9qja2Kxn34HfuceVDAx4kCeIK4HreEyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1689
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250094
X-Proofpoint-GUID: 7ANCQNtQA82iUdk7eZwIm4uO_FB75r4a
X-Proofpoint-ORIG-GUID: 7ANCQNtQA82iUdk7eZwIm4uO_FB75r4a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/21 3:11 PM, Michael S. Tsirkin wrote:
> On Fri, Oct 22, 2021 at 01:17:26PM -0500, michael.christie@oracle.com wrote:
>> On 10/22/21 11:12 AM, michael.christie@oracle.com wrote:
>>> On 10/22/21 5:47 AM, Michael S. Tsirkin wrote:
>>>>> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
>>>>> index c998860d7bbc..e5c0669430e5 100644
>>>>> --- a/include/uapi/linux/vhost.h
>>>>> +++ b/include/uapi/linux/vhost.h
>>>>> @@ -70,6 +70,17 @@
>>>>>  #define VHOST_VRING_BIG_ENDIAN 1
>>>>>  #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
>>>>>  #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
>>>>> +/* By default, a device gets one vhost_worker created during VHOST_SET_OWNER
>>>>> + * that its virtqueues share. This allows userspace to create a vhost_worker
>>>>> + * and map a virtqueue to it or map a virtqueue to an existing worker.
>>>>> + *
>>>>> + * If pid > 0 and it matches an existing vhost_worker thread it will be bound
>>>>> + * to the vq. If pid is VHOST_VRING_NEW_WORKER, then a new worker will be
>>>>> + * created and bound to the vq.
>>>>> + *
>>>>> + * This must be called after VHOST_SET_OWNER and before the vq is active.
>>>>> + */
>>>>
>>>> A couple of things here:
>>>> it's probably a good idea not to make it match pid exactly,
>>>> if for no other reason than I'm not sure we want to
>>>> commit this being a pid. Let's just call it an id?
>>>
>>> Ok.
>>>
>>>> And maybe byteswap it or xor with some value
>>>> just to make sure userspace does not begin abusing it anyway.
>>>>
>>>> Also, interaction with pid namespace is unclear to me.
>>>> Can you document what happens here?
>>>
>>> This current patchset only allows the vhost_dev owner to
>>> create/bind workers for devices it owns, so namespace don't come
>>
>> I made a mistake here. The patches do restrict VHOST_SET_VRING_WORKER
>> to the same owner like I wrote. However, it looks like we could have 2
>> threads with the same mm pointer so vhost_dev_check_owner returns true,
>> but they could be in different namespaces.
>>
>> Even though we are not going to pass the pid_t between user/kernel
>> space, should I add a pid namespace check when I repost the patches?
> 
> Um it's part of the ioctl. How you are not going to pass it around?

The not passing a pid around was referring to your comment about
obfuscating the pid. I might have misunderstood you and thought you
wanted to do something more like you suggested below where to userspace
it's just some int as far as userspace knows.


> 
> So if we do worry about this, I would just make it a 64 bit integer,
> rename it "id" and increment each time a thread is created.
>  
Yeah, this works for me. I just used a ida to allocate the id. We can 
then use it's lookup functions too.
