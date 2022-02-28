Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1058CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiB1UkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiB1UkD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:40:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C5B1BE9B
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:39:24 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJ3BD025527;
        Mon, 28 Feb 2022 20:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HTqQxHtMbbJdtNvjb8TIFX8r/S1aYEtNKccLPgfe+mI=;
 b=J4YHRIH4IFU75OQOCZUnRMrhzGkIR4KvmmSRt728CRAWemYm/Ap7jXdOyG7WfiP3cXOS
 5tsbk69VpfLDSRQ07W5unNXTM0FruIottcX3Qa8sZlp+zVkeXTYc4oyL++A7xkfKNY0V
 50j8P5KHp1O92iuiWF/gPGRhKpqQN2WS2F+voS1y7wRtK4L998l/aYRmAjYiSn1MAtGY
 Q6OKBZPcWaemru/y9NU+2QxyLlFNIZafsj9dqrVmcZSdVPoWlLLE4Fd+X0AS6NYsYhgc
 PxkKeJmMobQBZaxkHTJlWbbf7F0trNdCwv4jjfwHtJ9+Rq0qAkpbSZwLmySGxoc7a3KP 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02nhx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 20:39:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SKVH65041168;
        Mon, 28 Feb 2022 20:39:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3efdnkgy9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 20:39:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1KjEuai8Wvxhi/xRZKTNcz2uZVNbNe2m5DRIVFx1it12C9JrwwW51gxRUBCbzMknfQ+e26NaX+H05klngnHoDd7mL4MZbitoq28VWbeAga1l/hxouR6WplZPq4sCr+UQrHiFRJkszntF6LiFTFRAk7091BvKRh9V89203QU1/l+kXbXdFC6kyB/L9Q3FPD6c7SxKEMJT7MQjymiUalc+xA6C3HYhtKVAiDZvoZ5qwiw2a4JcNSHJ5nVW+EPXOcdbP9E49bVHzjRiUlhLYof4Wtp1FulZYgZphG/HZmVG6/dIzwkwL9guGbqruZYwGvd4OEOBguEjUccqMXTqYG9UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTqQxHtMbbJdtNvjb8TIFX8r/S1aYEtNKccLPgfe+mI=;
 b=LrN/EJm9DNiCyrEKJ7bbpZEKl9VqDM9sWZxIE47aq7q76FTYn2v3BnP5L62nGpbp1pmkHgWv9cEiEz7nv968HlAQP5HIaIQgt3Ry8wUcWt+W0o1pBEIYWUwOkC7fpJRNaKIx2J8uESxzBRJy6kqCbkdp5F0zlYu9/9U99+UR+AcZN7mfe/d5soSkB6N5nNK4WuXetMaLaV4uqj/tij0T2D/bscXgmOQH1SsDSrcTTaDqXgMWS4nQU9yqNpWfG9clHbWUkXvbLS0tCoo73kIPhRWK8hmKKxk8GWMmMLJimk0+mjh4iM5L1CUeEaE/SOSbd9KDF7W6pDNS3aKj3o/6KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTqQxHtMbbJdtNvjb8TIFX8r/S1aYEtNKccLPgfe+mI=;
 b=LGhsrzuNPqSJQd+CMrf7MjP2AqXrnHRTskb4XWl3h0SdBjTw5HRu/hwhtVEqjAuvxUwNPZ/Ddef5rqMQwjHXkV7lpHZP92mutcE0VgOIvchhJnZvteNTSnE9ZBjoLtxETOT6oVhr4dNZCo+6Kj7MOYlxkjFwjadsOPGnTF6jehs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4282.namprd10.prod.outlook.com (2603:10b6:5:222::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.25; Mon, 28 Feb 2022 20:39:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 20:39:14 +0000
Message-ID: <298112a4-d040-d855-e07b-558d2fc482d1@oracle.com>
Date:   Mon, 28 Feb 2022 14:39:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 3/6] scsi: iscsi: Remove iscsi_scan_finished.
Content-Language: en-US
To:     Lee Duncan <lduncan@suse.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, mrangankar@marvell.com,
        njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-4-michael.christie@oracle.com>
 <e77fae9c-d612-003f-5b9a-b0da4b389b14@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <e77fae9c-d612-003f-5b9a-b0da4b389b14@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:3:93::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bea2fc3a-1910-4c00-e2db-08d9fafa61f2
X-MS-TrafficTypeDiagnostic: DM6PR10MB4282:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4282D10E9F372DBABF16F967F1019@DM6PR10MB4282.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s82ruB6kR3LP3JBgfgaZwL4sAJXVzNgTn7Uqxx53MxM8G5eqjzmFc+s+mdreEfKldvK5CMws5Hbnvo3qE+RROmbJCxG6NXR3yFznENDLDxAffQS0nZFOG2i01VbKGH4+pkQehWbWR8g9bb5XvqkwPos3cCaQ6blW1mq9UjWF7FszzFqQy75WLj5mMxpCpHwa3Sq+a7Dezc2N/xUtcmMANqv6yoZxrgG+7HxJPHgBkslKShrXiDc/9RZ4k86H4BKnZc5uVMUVeWDGaGGL7PGeZvaCmJVFDqAIfebr8Gc3suNjHz79UxTAc5SwPD72dSdBIc2IccWE68IVGHSi462gbQupJhz4/WFZBoBwcABHsPM0vPL56mXsVyledsvuWR/ZEpp2ZxFbzqGUbJiWaUohygnwKRAyhioGJfuUdf3EEXqsdZkyWH0JF7omkO4j6Db9CoqDwmwLyO3XSa4TDtYU1yu15cn1prAXgYEbLltqxnz4Jr2icLh696rH5iVSQzNVat/yguXNiexO5Ci2ivmMiYR1BbiDWE9aSjHCR5aez45fHwiJiUPWL0tukpRz05cujhz8ChTS8w7rZwuAlYaCwhTaq7arPWfHtjv5scQzcWlBVY9TALD0zz3jc33SbcRrs23xNkfJD5zYw+ebj87wCdbaZG0j5j30haOwVUW72Hiyw3XxqlrUZrznqSz1+2LJAyEDe4dn5YP+aIb2/3UO3KtJO54gtuIVZbWMqGPee4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(83380400001)(26005)(2616005)(86362001)(6506007)(508600001)(53546011)(186003)(66476007)(66946007)(6486002)(66556008)(316002)(31696002)(6512007)(36756003)(2906002)(38100700002)(31686004)(5660300002)(8936002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVBmK2NhWWI2Z3BHdktBQlY1OU5USzExYXpQUUxYREtNenJxVXFCUmVpWVZG?=
 =?utf-8?B?NVJick80NngvREtWR2RqV0hFb1JDM0N2a0xTUmp4b09iSjZKTGF3RDA0Ri9x?=
 =?utf-8?B?SGRTS2xZS3l3OC9oUStEMXZqSHZjZi9ZaFFqbTBqRlU3QnlRQWRIYWxYc3Ba?=
 =?utf-8?B?aVl6Q0trbGRzelFMU3FGS1U3bzJEOGRBSVM5Z2Z6aVN4cEVIRDBQaERLT2Ir?=
 =?utf-8?B?OGNnYmFIRDhieUZ6bFdFbVZ3UEY5TWxqQ2N1SE9VYUtTOUxzOWptRnlkS2Jz?=
 =?utf-8?B?OFNuV0lRSFBuRFk3MUM2VllSeExVWmFMcTJGVWlRZHpTSm1wWGhhWWRZdHZP?=
 =?utf-8?B?Nk52RmJ4Z1VjRitMeE9UV3gzbVZTclNTQlF4OWtLZm5waUJ5U2FNc093akhk?=
 =?utf-8?B?bkdRcnFNTmF6bVJSYVdPQlhyNGdySS9xVTFVNjg5RHdJRUYwYVRCVElOOGFS?=
 =?utf-8?B?d2RERUhMTklkRmpMZEgwdks2RDNtdUJqMnNwWWViUlk0bGdoTFY2RFVGbnR0?=
 =?utf-8?B?Q1FwdS9JeDFQY1JaQk5ONG44OGpSK21YOEp1eHEvREFVUktBWnZ5OW52d0pT?=
 =?utf-8?B?Rjc2LzdYWWMrZmFKRHVtcGFSaUc1NG1lVVNIOXhjZnhiQk96bnFpM2Zaemd0?=
 =?utf-8?B?dFlpRFhVRjFuZkp6SnBHaUNuTzVobEVrZ013VzhDdGFDN21xa1lMK3ZCUk9X?=
 =?utf-8?B?SGxZTHZHRDlmdlRzVFhmbDBMa3REVGNHTFJDdGQ0cXc3RmMxbStNbi9qc1Ba?=
 =?utf-8?B?eWlXb3BVN2YzQTlmOU1oOU50RzNHQjVHQ3R4VkZRMFc1TE5QS2ZwTkkzSDNF?=
 =?utf-8?B?L2VpZEVGSWhRUkJGblF0RG9xbmo3YmJrY3pzVi9sWjhWSEZvUDBVcGZhNTVu?=
 =?utf-8?B?Mno0ek8rSlNLeEZ4c1JxSEpjTUtGM2toZGZGdFFuNVkybFBjYm0wTFVyTzRn?=
 =?utf-8?B?ZjNqUVhzdHN1cm4yWkduUXlmK0FxUGl5Y3RmMXNuQ2VZMTdUTEtOaExVcmls?=
 =?utf-8?B?RFYvRVhqZjdsVHQ1amxTalJiRzhtQWVlTGg0VDErSHE1RTN1NGM2MUdhYkJC?=
 =?utf-8?B?aWt1RnVKK2U2QmFDRWdQQUt1eHJmSXN3RjZJTysySU12c1RsTzNnRXMxeXRW?=
 =?utf-8?B?WGJhZ0czZDBiODc3R2VCaUFsUE5YTjV4RGR0alZSSDRtR2c1WFV6WFFzS29Y?=
 =?utf-8?B?OEU5ZDZzb1FYT2syWFNlOVNWdGg1UlFKN1A0d2hUSVRTbmFCUEpjY09iVUV1?=
 =?utf-8?B?TG1Iek5ESlQwalR3dzFCSGpQTEd2cWRraDBjOGxwSlBLQURMVzJlZUJWZDE3?=
 =?utf-8?B?MklMZW4rNjcyb1dZcTJLZUl5Z2M2QnBiTSs2WEtzU0RDZU5OY1FFR1dXa3pk?=
 =?utf-8?B?b0w2dy9WU01TTGI2VURBQms0ZDBLUDZvUjRweUl3eXhHTGQyS205dVhaRE53?=
 =?utf-8?B?VmlYUGtOZWpydmJiNlVRN2pCeEEvVm5MMm0vUUU0NHVZQ3RYZkI0VzNVUCtY?=
 =?utf-8?B?S0FIZ1l3b0hMdWh4OVNqN2lOYzFuZVQ4bnE4YjJPTHRVR0R3Q3dWQTdVNUpn?=
 =?utf-8?B?YUFEbDlxYmRuZkNKdkRVendWbFhuV3VYa3c1eDh2c2hjY0Z6TFM4MzJabS9m?=
 =?utf-8?B?SzFEQVk5YURjVGFUZ2VLU1c4b0RtLzJsNFVrUlQvVE8xNWJnVk42bmFpQ25u?=
 =?utf-8?B?MGhwdXMweDVhWTdhbkpoTEpEZC90cGhTN1cyajB1SC9DaTVwRzU2UUszV2NR?=
 =?utf-8?B?NVlpcDVhYTM3anRpZlNiN2VyVkZ3SnRFUlRMOTRGaXRZYmczVlV3MW95T3Zs?=
 =?utf-8?B?VE9nWkxybkdjUzhqSnFhbHhXa2tpbGxpR1VaWm9jc1g0dTkwQ0FUcFV3UG1y?=
 =?utf-8?B?ZzlZVXF2SmJBTkk4WW0yU0VFWTB0d2lpTDVjR01OMzZ3NWI3UGtwdFlobWQ4?=
 =?utf-8?B?eGs5NnpRWHo1Tzd6V1djc1p5T2p4U0QwdmNLZDVBWGR1TFByZk9pTmpNMHda?=
 =?utf-8?B?aWl5dGlmUUlNUUZIZFhkQlBqc01XVmY1Sk9KOXk0bElJdDJyZ3dLLzRobUYx?=
 =?utf-8?B?bVE5Yml2MlA3cDdMRWcwTU41U2Nhczh0MndCTm9jdGJYREF5NTV1andOY3d6?=
 =?utf-8?B?VUNwcng1cjl2K09kVnQ4dUJWT3lnUTJaUXlZaWVudHRTUFdNd29vb0x4NWxa?=
 =?utf-8?B?WkZ5amxoTmQ0NUVXMFpDdzZicnpyelM2eTFadjR0bGRHdjVJWXpKTzZTTVhB?=
 =?utf-8?B?ODVncHlEMmtMWWsxVUo3ZlNIUnV3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea2fc3a-1910-4c00-e2db-08d9fafa61f2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 20:39:14.4836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UXz3SiPC6T8TZI4vasz7k1XVnSwhRmq93aduiwg2E26ZolpUj3Il65oAbGEDZL43EZTiFSgxwmq0RbfslMBwmiV+vrga0H80Z8SNtSlW8cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4282
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202280101
X-Proofpoint-GUID: y12Z450fWNR8ZZMNBDJptyf36_sClGtm
X-Proofpoint-ORIG-GUID: y12Z450fWNR8ZZMNBDJptyf36_sClGtm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/28/22 12:05 PM, Lee Duncan wrote:
>> -    if (shost->hostt->scan_finished) {
>> -        if (scsi_queue_work(shost, &session->scan_work))
>> -            atomic_inc(&ihost->nr_scans);
>> -    }
>>       ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking session\n");
>>   }

....

> 
> I have no issue with this, but it seems kind of unrelated to speeding up session unblocking 

It's related because in the next patch we stop creating the host's transport
wq which is used above in the chunk that was removed in __iscsi_unblock_session.
