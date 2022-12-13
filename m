Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FEDC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 16:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiLMQA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 11:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbiLMQAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 11:00:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7376D132
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 08:00:54 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDtN4r021993;
        Tue, 13 Dec 2022 16:00:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Back6kLSv6yhl3Iq0dW27njP9OeIZoGwxyyQPxz+1KQ=;
 b=oY1FzlU0yP7k8kYpkHZv1d9hOMRlhXOMv4PusNzcl9JGg+SsE0kjVLIY3JIW4yIrwNez
 5gGm4ZPBI6FClXOv4i5pmp8cYLb3x3XNeOq1JJtuBRW7Hq6Wp/V7DdBNkCcTbl9ISjIU
 eVB4QTRasm4GVsnhZV6v3ItELPB7+fQbzdaSei4YfXCMHFzAdzWKoS0/g7ZI5GPE8xNo
 AWs0nOgLi6RRecqknXSDWel+qxjQ66mixvkVZ7Fc6/hgOxNB/NWOO4ijd0LOlZMi4T1u
 1/dB/aDd5pB8eXS4v1MHp5fEjTZjegsT7KvUAAMqqMgjCG6aGY3JeZ6V26A0clcnywh6 5g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcgw2dqn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:00:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCSwI039967;
        Tue, 13 Dec 2022 16:00:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjcgx29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:00:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggzpELGq8Ko5sj58DpVscW0iS370iQYjnW/lJJbkBkkZetfGrgGt41b3nQFzFTAcvAaHstQKisO3plCvDKO3gaQsrbq7Io6bsxA9cfoz9FkfGQ7STHsZyQDd0WbJfg/PO4edG7F6TiQzay/9HfVhyOpVIghogoXqzExRghB7faeujObXv6NDqQRDSgbc6ohA1fMk/dfYAVAeH78sYAhZ07y+o2M2McHWid9OsgsuPB0XgUCOIt3oiDK0Ja425C1bqbN/l60opWHLKa5buP0jCk647QXBZrA4Zv8DprUBeIcJgLaWu8xjhzU5dNzRbh+H/uyu6tvVBp+YcyZPXaCwTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Back6kLSv6yhl3Iq0dW27njP9OeIZoGwxyyQPxz+1KQ=;
 b=eDqP9lVDzLogBaycdWADoeBvGez8YVEzganmVdSPGFqktGOWlE4hzsawMMGdfsUUWqyi/RQVod1Wug/jNqI7Vywkj+U96xbe7y0UdJvOJVl5T0gOWqRt5KbD0OKlTCUNx/HJIXIvWob7IJV6J6KpR0EFZpHRl4NA2PuYbFuoUSNVIAykfWmSV6/SRzf4ML1tuTP9V9z8IvL7LsjhFzBZVxsheIFGfR091S1emTQgEeTeQKAs7E/PMwGjmF1RLnxax981lkGFN4kTv8c5ZLMRA3t9zIoNtNfBLqoDZtygOsTSmkd2aONzwoGEz6OFBcJZrhaBvwAfyOP//O4TDgmbZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Back6kLSv6yhl3Iq0dW27njP9OeIZoGwxyyQPxz+1KQ=;
 b=JUS1YMdPc7LaxbnimvdIks3dAQ6zAV8BdRUFkr5I6kHt5WzqsA6r8R/fnb1xAgkdOTduRQwrTFPVWUNmLrZmSdGEyEfNYijiv1rmAQ0Y9NWdHW/Ju/eIlFT6I0RgKhqY78nndwOXWIlEQiJeX+beZdlxIpgtpK+J94WYZ6Bu7oA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5350.namprd10.prod.outlook.com (2603:10b6:408:124::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 16:00:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 16:00:25 +0000
Message-ID: <a8a2a6f6-b322-45a0-50f2-0a777cb90dcd@oracle.com>
Date:   Tue, 13 Dec 2022 16:00:20 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 1/5] scsi: libsas: move sas_get_ata_command_set() up to
 save the declaration
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221213150942.988371-1-yanaijie@huawei.com>
 <20221213150942.988371-2-yanaijie@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213150942.988371-2-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0194.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5350:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d42d8e-a636-47b6-5c12-08dadd2324d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQqYzT9SuaFk4865p7yhZP1XLBT5Cz+1s9sgf79+MZJ2LeVvi6APmLgMiYLebNOTSECNLf6gerZl7lkmrMvW+XB11B70Q43Y/dAmaraCQ0MrODHxpHl8wa8xI36GxqW3SFjAtoWjI06rl0kmlli/5OG2zbP5DZSFwkTrs7gQ3l1JSdP0a7err3MvHH1j/LkNKCkKuyUzhf5/l6dQKDNC3NKCf1gqYftIudz4bS3a+OB14mm8uJspWeNubuvrLh2PibOJ/uVmDH8Qqh53izsjx0XpxeeKmGl6bzKT1JqUljZoEnaGNm7WPIRQNdla8BPIPpuFYqCEITLpfpDubfTbPzb0jLq5OrfjDXsyahwINSRDP759NK51+Y6cbTRKvBGdD9jZIFWxZ32GoYVJ5T89/TqBH0ZAVNYpVvuJbYBu0UEOmUP5d+9Q4bfPbjcWtF/H3WOdn2kbedSolPtVcjDYzY+rthM0pCVJ2B3dbZZL731jnfdjc2TzPmVfRdMI6El2TbYh0KEDdtf5PKk9efBzNke2+AlCi9tWh8RzreaBgASPkU1iQvJkS1vHi2rK+69fcExnttzM6qtNsOSy84caoylPRM2T7KnNa6VKBT5Gvk7nk+WtaSN+04qDU2dBnFaDLYBCI1tfmpDblCJP4i6TSvkcJnUw1ebTG6vt/I+Y7O7Onv1p2HM8y0bMXIwVmzwZ419Wrxlb9+w0fwG5/rQmbE9dFCRXFg928WeaTGCYhHE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(8936002)(5660300002)(4326008)(41300700001)(4744005)(66556008)(31686004)(8676002)(66476007)(66946007)(2906002)(6506007)(316002)(478600001)(36916002)(36756003)(26005)(6666004)(86362001)(2616005)(31696002)(6486002)(186003)(6512007)(53546011)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWYvbzVXOGIyd3dmdmhPb0VlcHJiRldqbzFoOEhMK2FNQ0R2TTg0bkJTK3d2?=
 =?utf-8?B?bnNKVjYzVmVPSGkrSkIveFhnQ0QxUUJzRFUyNTdUT2lmRWd5dzk0WUpoQ1BY?=
 =?utf-8?B?bHZLTGdwSS9yeWgwZEFYdGI2aHZHcDJraHN1QzR4NGJqSldTRVZacmljTnFu?=
 =?utf-8?B?eFdIelFEdit0TDFjUVlseFJKVGRDcVg4SHlORTgyQUhBQzdpUmhpRU5FQ0E5?=
 =?utf-8?B?Rmg5VzJWTFdEMm5UQ0tpUkJMbHpZUzdoSjB6cVNRRmYrci9UcXMxZXhwcGhx?=
 =?utf-8?B?dWVzdm1mL3diTGM0eUxocEdqWFMxb3J3L3hjWkozTG5KQXVwbEJPM1JJbHh1?=
 =?utf-8?B?Sjc3VS9qSkFJaDB0bS9PTFd4Zko3dU9kU3RnUnM0bzBuUWhVN29LcW9tdlVR?=
 =?utf-8?B?bFlUcU5TUWtEcFlDRkMxMlhSbE9uNG52dEtKTWc2d2tVcU4reWlyQ2lHWnJj?=
 =?utf-8?B?Z2ExaUFtSjhnMFJnWWRVQkVIclhZRXpmR1FFZHlkUVlWbEtxQy9EMFAwMENQ?=
 =?utf-8?B?UGd2UGx3c1o0bHNUN1ZtcmNpWWpZQm1UUWQwbDlJQjJqR2RQQkZjckEvOW1i?=
 =?utf-8?B?YlZObnp0dzYwRWIyQ3E0aSs2NlBJdXZPdDB0VGJFRllOaFNVNTlWVy9aM3Fj?=
 =?utf-8?B?bnZPenBQY24yUUVSejFkZkZQNnI2QWhCRkgxWVo2UUFibmRFMG5KMmpEZWpt?=
 =?utf-8?B?dVNIZkViZGR3THpPUUZnT0FBSW1SMVI2Y0pKd0FxaXJzemNId2pMS2JUQVNT?=
 =?utf-8?B?cEJsU0N3VTNaaDhqY3JCbndhWC9Kd3FrcitTQ0NwMmlrZHFCS2Rua0NqWHZK?=
 =?utf-8?B?OUxkbGtkY3RCVk56TzhVWXZ0Z29jdXdjR3VhZFh6aUlOUFk1akRsRmMrYy9P?=
 =?utf-8?B?V05US2tDOGZOWHZ5dVpxSkVLWElkTmdNUlNwY2lnTVMzNEFLUDZ0QVp1UFRp?=
 =?utf-8?B?M01hZGN2c3dRaHNhd24ya01MUndEWDlQcDBxbkxsRHVHbzRtVnFRekdEeDdz?=
 =?utf-8?B?Z0hKOG5GaisyTmhpcnQ0RFFYaG9RZ2RUb2s4azVlNm5wQXNpZ1R3WFdLODAz?=
 =?utf-8?B?djMxS1VFYTVkM04wL3lmNHRMQ0ZIVUllaDd4ajYyYXBVb3ZGS05iTVMyeU4w?=
 =?utf-8?B?dDgvWHpkTkpRRUZDWnhTekF3Sjl0cWJBYnZibWVUNFF4ZXB2THhabGVnMis2?=
 =?utf-8?B?TUdWT2dSTGhvODc2bDdyRVUxWkFnZVpuMzBXNzJ2UFJpQ2lUUnpMU0NiYW1I?=
 =?utf-8?B?NHFKQWcvUnpYeFB4T0lrTGdwT2dPR1l1ckZveDhXcjVJUWpjMzUwWTRUZGRu?=
 =?utf-8?B?OWwyM3RjTFdESWN4dHFtbmwrcW13T0dJb1MzVytvbXg3c0JienM0czdiUWFN?=
 =?utf-8?B?RVVJMG1wK3Q4SzRVVEdhN0pWZDNCc0ZyNkQ3NTAvSjZxSjVCN1UvS2VSOHVx?=
 =?utf-8?B?UjVHK3RleGRzN2g0eTAxc3hMRFNhaTdrUmZpV293OGh6dGY1OFIwSzFrMitJ?=
 =?utf-8?B?RWhxdDk4M2ZzUDBWUWE4cThCMFhmNU5jYVhpenRwWnFYSU5aRnkwbFN6aWZx?=
 =?utf-8?B?MGRuNitTNUtrQzhtbTRlRmU4SUlJdzlacWROZWNqaW9UcmY2M0lsWFFZV2Z0?=
 =?utf-8?B?c1FLTlB6emNBT3RsNHRpL0pqUWd1eUtxRHFSSWN6Uk1oTys2bURURkxJemEz?=
 =?utf-8?B?aG5uYmplVlpBQ2toU1YxT3JKN1RudS80R0hUVFRxUkNndXVTMFhwZ1NGM1l5?=
 =?utf-8?B?L0pyR3N5cEEyN2YwRDd0WTY0WjV6YjhsQlZGVHZpOWpqUXRETG1JanI5aW5w?=
 =?utf-8?B?WWtvMFUrajVpV2srY2hJTjBwb0pwajcwQ0ZJekNUbUVLTGRqT2ZRb1N1UDBC?=
 =?utf-8?B?ejZkaDFrQ28zSWoreDFxQ05iT3M4TTYxU01lUk5Uc3pIZGlqOUZyczcvdHdq?=
 =?utf-8?B?THpLQVZiTXQ3ZFlxQ24xTFJDbDhyWWdFVTNjSTl5Y1hXd3UwcUcyc29XQTBG?=
 =?utf-8?B?YWZUYnk5TWlrbXFESzNoVEJ5U0YxVys4TUpoSEhzY1hyc1QxQlNqOTlYYzNh?=
 =?utf-8?B?TVdaRjRMdHV5RjlEb1FpS3Rlc1lUZGU1Nkc3elN4QW5UakluN2NIWUdIQlpX?=
 =?utf-8?B?QTRXdW9hQit3dTc1RFQ4NmxqcGpkYlZJbDBxM1NYcmtvZHRwa1JLd0ZMci9P?=
 =?utf-8?B?QWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d42d8e-a636-47b6-5c12-08dadd2324d4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 16:00:25.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDekn0Dm6iCFhEuGcTEe1rpQ2y79l4reZyT4AxNHs1xacK97+jwWyPecseTbtDPEWVZwfbySLxrCljz9eoEHmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5350
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130141
X-Proofpoint-ORIG-GUID: 7bxLJWBFzTWytqTVCiHubkeTc-C0fFlb
X-Proofpoint-GUID: 7bxLJWBFzTWytqTVCiHubkeTc-C0fFlb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/12/2022 15:09, Jason Yan wrote:
> There is a sas_get_ata_command_set() declaration above sas_get_ata_info()
> to make it compile ok. However this function is defined in the same file
> below. So move it up to save the declaration.

nit: forward declaration

> 
> Also remove the variable 'fis' which is not needed in this function.
> 
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Jason Yan<yanaijie@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

