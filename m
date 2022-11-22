Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AB0C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 09:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiKVJQs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 04:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiKVJQp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 04:16:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD0DC3C
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 01:16:43 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM8snKS015886;
        Tue, 22 Nov 2022 09:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=No9nGaZnS0sRWHy8YG+xlVrbPSAwlfGsZrODEbgFpAM=;
 b=h7QL7f8SO5vDN5isfzjR6UfG6/mIWJza/YgImT4t5hE/v90h2dWst906qc4aRK0HgIZ9
 hxGENOqVEbvaMrc4GHghKzISWhxY2aR5/tSeGJ+ShkDrc4N2pnbwGaePdI8sf4SpwW9A
 7QbYgOiCcVl3yhJ+hHs18G0h46tndxxJhco3Vl9YguKl5FxP9EI2Iqk2q2TlDZ09LSJl
 WmBwSFj6+fKyZYS+hLEM82kIhN/D52vTfagL8CeB1w5AwtFPrK+aUq7XZkQ6f5kuAzgJ
 TqqF4fFWo9XP6hg1PzBXni6bG0x6XALyLQCoMq7VX9CZ1E7e0NGCPQ1nWHWAcbyt2eM1 mQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0gas1nfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 09:16:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM8UaK4038880;
        Tue, 22 Nov 2022 09:16:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk51wn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 09:16:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aiNjZgQQMsvnPI3dVd5MP1jtO6+3GIDtEAvkhXRg+flss/LS2zGxIcTe7iigk/QQE5i47+v4lfx/QmO1ONFWnBohGzKPfOWiWgbwJrkVq2gItFxR6dJUeN/YD7GXR+42kO1/P+rOJFCYpYWCHebaAZwLa5MXRjabgGYBhxlyE7wuK5c4T9yee+KAUwv5dsSTcqv8iB2sALNaVtll8bKvMffvDreViq5zCOwfnHmx6zY+M+qSMOtZRi945Ebs6aH3oj9zDOiZr/BqB4uhGUz7SOL82bxeld8q/vIVFBlcDQ4qShLJbDf8McUa8jz23xu+U8sM6IODK46dBaXLrLM6pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=No9nGaZnS0sRWHy8YG+xlVrbPSAwlfGsZrODEbgFpAM=;
 b=bo9oKzY1tgukKnS8APDe8EEf5zYCHsFmNbG0SnysIKwGLZ0vltFMDpUNxvut2tGLRtsYuRLx+pAYp7eQEDHuUhwLR44jO++LYE3keqOo/4k8YP3GACmJ8IigO4NMC2zq1PBdP6LZxZvn7Sp9egr7VwTYbDP7ClIcPkg/KmWyWs21H9zQaEa4LokcZsAIDuzA/jdU7DxY6CMGUUsn5ng25zkgCg1wIzwH6/7X9w0/UAedOdtaliViob7A3Jvye1JHcmC5l+0Ng+8n+qa2UjMzgI0XoRoHmN6oAemi18gQXC9WpuJcYevNMxahAeJpgA1JiZ4V941vU/gzUVtQ+7QMEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=No9nGaZnS0sRWHy8YG+xlVrbPSAwlfGsZrODEbgFpAM=;
 b=eqkBw7mzNxvqlsp+t1/ZupuM0e1CYMxf7jDc4gTWtoUn77CqJnxBubnm7upX3g839xSFeT79qTQOIYIhcz8wOm5jxgKrjeuW84gmaw0hXPBKLOR/W/boip4x4dKNynJOj2lC7oKlKbntYE/Q1+NJJB4NDYEmd9HC+mDzEPZHFR4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7009.namprd10.prod.outlook.com (2603:10b6:510:270::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 09:16:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 09:16:31 +0000
Message-ID: <f89a2bba-3988-1080-8c9b-bbf7bec3961c@oracle.com>
Date:   Tue, 22 Nov 2022 09:16:27 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 01/15] scsi: Add struct for args to execution functions
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221122033934.33797-1-michael.christie@oracle.com>
 <20221122033934.33797-2-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221122033934.33797-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0491.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7009:EE_
X-MS-Office365-Filtering-Correlation-Id: 053120fb-f1ba-4d2d-0939-08dacc6a3e3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hBKlJfECojfcYbK/yebRuPsKyRbhoTvGVDKjyLrFpfoacXt++PcPQFPYPXn0o6Xk/o2fr5wO6cPEIJXdrrjoKZhrWvQGTObvg3e0dl/LP1iF+B6XXIQ8Xcq5zSKksCiFqk4+gGF8kjNep2oDs6woo2RZ92zgb4ELP9NnpKpYpR1pE17bHLYbUdryrXzERzWzBZ4/7bqg6h8ErG2zvdJiKuvsDYUp1jV44ipHQWh/Zg3i3+QfmJUufLxfXrR/+9IBPZb4+alyraNopEEwiKomTR6NTyfk5iJkF55dDowWzIsB58EhShJ0Gptg0zSmDEFBB4TJwu5RuYl6cS1FyFFECC+8hfsglkfRE3ziXVHqD2Z2kxGlJwFQHEtWB1Dc6QYt41JI8PuUU1vl0jORn3CFw3acfS28dmq/TcljQS43TG9bI6mwbEwVBY6fyfNaCmEq5ZXcCvbJpvl55K4q8rwi6F34oUar2h4OotI5yJ2WobMk678RHI1bAUpKRhbaGvIMo+yaunj3xVVf6tnlT38xDjyBA0RsZfqSOSRwE3vWQySn4lEu6rMYHJ9YhxG2PoOI6PQxjH5xSzkhBc0cCW2ueBpf2SBsvM5nQUB5jDaJGD2G3eYvu4hVGpEdy7wBH+B8roSd0geTviimYl0gpfoDLrAzQOBJ4XMYHhAnUDqc4Iof0lDeJnpjHv8ARhUQ7DbJf2rQ7QegspqmWw98H2+0joyzP74EsBsQ7foHxXRzTxo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199015)(31686004)(8936002)(8676002)(6506007)(6512007)(53546011)(26005)(66556008)(41300700001)(36756003)(2906002)(6666004)(66946007)(38100700002)(86362001)(5660300002)(31696002)(316002)(6486002)(36916002)(478600001)(66476007)(2616005)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2hTYlRpWFZYNlFQR3VQNSs4VTdJNFpkNDI5V3BRbm9CSzRIdlkvZTc5R29H?=
 =?utf-8?B?VEFJRjlGQ3p3MWxhbkZ4VmgwWEZPQWNDVVhsNmptS2NHMy85eHdIRTYwaU1O?=
 =?utf-8?B?UjU1ZGlKUGp3SUJ1ZVo0OXZIQXpXVUdOQkp4MUYzRkxjWlJXTW81ZXhxeE9n?=
 =?utf-8?B?dnhteXlkY0VQclJmSkpSVkZCZTdleHdqazJIVklPZUQ2eGdUWEVXdWxWbG5J?=
 =?utf-8?B?Y2U4THVlRjZJV2dNck9tWmNxRUhJdmhSemIxYUdLd1FtTzAwTFFZbVFOcGxP?=
 =?utf-8?B?QldPdE9mVGRSNzByQTNPZ0oyb1BWbHNNMjFTUjU3Q2ZUdXJ2RUk3QlpYS1RB?=
 =?utf-8?B?Y2duVWVTUWVXVURybVBEbzltaWc3eGZFdU9jQmtCSXVqdWY5UUZUckdJT1dJ?=
 =?utf-8?B?OTk3amg3NEhNek1uUVdYb0E0SFg3YXVzTFdITlI4WlpLWlZqQ1VTc0dvdmVz?=
 =?utf-8?B?Tnd5Q25iWFE1TitHblB3MVhVRXdqUk5rR2tUNW1HQjd3aENIK2UydTBhSkwv?=
 =?utf-8?B?SWJqYnpyVkxYUityakJ0YVIvUjBTSzM1T3R2M0wwRGtoTm9CQ0VWcVo3NmRX?=
 =?utf-8?B?bUhjWklwd08vWEw2bHFMMDBrOTlLTTFkM1oya2RPdzlJRkZLdVZqUkZVck5O?=
 =?utf-8?B?ZW9uSWdwTFNmMUpMVjVLSjhFeHFOOElIazhSN0lSdjJRYzRvdEg1WG9yUk50?=
 =?utf-8?B?cENma29qUnlJUEFySTFsb3ZVeEo3NXJjQTV2ZDF6ZldERzd2VWdHckZWRXE5?=
 =?utf-8?B?U1ZjV05pLzVaNWVQSnNMUEF3Y3JyZUZPNVVoMnJSUzR2NVVncldKS3NHZ0Yy?=
 =?utf-8?B?UlJGMVlHa3N3STc3UGJJMzRSUk42VXcva3RSN3MzZG5ib0EwNDZ3VWpENENW?=
 =?utf-8?B?OUNzR0l4TFdibXE3b0toaHA4ZUZKRTNDeCs3RU91Yk9IVDZvVVNGUXc0R090?=
 =?utf-8?B?YVYwQmRrTk10cWF0RitaNy9HTWVjY1ROMWNMZGJ2cnk4YnpOU3FRMm5uSUZQ?=
 =?utf-8?B?d21Ed3VHWGw3RzREdEVoa1NHd2VJczJ1NTdsRmJJa25pbUw3UkY3bElwL3JH?=
 =?utf-8?B?akJnTDFBZ01ZOGU4S1g3bWN5andwR3gydmRJR0VXY2VHQUZDK2ZTaXFtMWpB?=
 =?utf-8?B?a0tGZ2NBTnBSaFhQbkFQaE5JOVRvZG9sdWNCM2RTa2kyNTFsYWlmMGo3OXBh?=
 =?utf-8?B?SUFOUk5FS3M1cFJqMTJxVFVBZitvWW5abDBnNCthRzhRdm5xWWxlaU5mem9o?=
 =?utf-8?B?MWM2U3Z3elo3UDNOZ05FY3NsT1hzSUFkbjd1VlVHczY3UWxSTmN6cDJYcXQx?=
 =?utf-8?B?TDZXeXRsZzJJb3I5aEU4VmVYRlRmWnFGV0htN0hXMnpDRnhIbnZnWXQyVE5I?=
 =?utf-8?B?TkVHbUhSR2FTZnVSNDA1TFN3TUIveVpwYnVubTR2aUJyYXp0bFcyb1FLUU5n?=
 =?utf-8?B?TGRpL04yZFBSa2NTQXhxVXJOalNsU0srT0NuL3l5dEhvMlphMFJhZVFTcnl1?=
 =?utf-8?B?NEhiYlhrczlDOWZqekNCdW9XTG9PZm9YN1VCaVhlY1lhMlZRSGhQUXYxcU1V?=
 =?utf-8?B?UnE2M1lTRE0vRU1GQ0ZxNFNkMXBveFVnY0wzc21vSHpvNEMycDl4Ykt4RGRp?=
 =?utf-8?B?ZnJWWUpFWGR3eCtkS1BlaWJjMDBVNlhBUEFLWjFxNDgxRXkzK2FneEtMd3A4?=
 =?utf-8?B?YUJIMHIwRS9wZVZXYTU2NnhOaEw3YWhvdEY0SmVlYTZ5dVJudzF6VGdmU2dG?=
 =?utf-8?B?b3lzTDlKYTdTNklBUWpubkRuNHFiZTJTSGpZcXhkL2dqbjUwbHRXcW5ZeTk0?=
 =?utf-8?B?RjdtYzI3WDIxQml3US96VjJtQ1FlMjJrVHJrNXlXQ21pOFdOeXFWZm9aeFIy?=
 =?utf-8?B?TVpEZG9NblI3dVBsSWpQdVhROElNRGZManhaaklqcXR0OGlyZ0gyWHhVakJv?=
 =?utf-8?B?a21Lc2pBbmtYS25TWDBpTFFIQjNUUU5UY05nS0IvazI2R2lBa3kxM3o5YzN1?=
 =?utf-8?B?Z3p3RHJ3Q0M1d0tZdjBMNkN4NUlqTndJcDV5ZTRhZkMwQ1BrK2kxQWhYdnQv?=
 =?utf-8?B?MGhjQVN4TTZNQkNtcnpGZmIreXBneEUxUE9ydjdKRm9SZkhGMWhraFNBQnpu?=
 =?utf-8?B?WXRNQi9BbjNnazRxREZ1U3hXWm1oMmROSERxZXdCYmZnbUhKVnV1NUJpRVZy?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: u/92NKOJS0h2dIoEK3PMDqvbAiYNPTE2Pys3f1aMf0AaO035RdMtF8SxotKzqsuuuwfS4ql+V5Ul5vdGAIH6OHDnbFAMSFhPId0jzyKZXITlLGW95nm+sfhWEJaZiu5C6fs11380F4hzqriu+Azgj6cHeiX2s9EslPMiW+aaz6phpemIJcqVQj/qtCQcO3Hb4VBGjUcOZWrvC6wpGRQ8A+NcnvLWP5MjH0jSw3/rlSu2V0uoFdan9+p8nS35Y1vqLmxU8HVbLL13DsX8tUw+hp6iq9ePiOVwxPJ2/A+Gie/b3RDWtLmsjb5N9tcWFpBAz8JXQ+uJ5DZn1yiIUToB7QXVTo2sTqnO3ic82T/HRoxGwdhx8bRpIc7iicAYOYqKhD91DQ61Y0peFVoAvMW2BmR19Yu4vnPCcbHRP+N8LoMh4Hr4bKRbe5yYQQhlZqAaB8UnuxsP426bQk7G4K0fBEKlHuuwgpMb6G8AP1+XRofcAhSsFKNfHeEmKUGUiz2u/RzNTdRipW3khgIormzMwO6D2aOa2iLikrm1D03owZLPPE3tq8600JWxrkWTZU0THXLCkVPB8xvRVbdikQiuHkIM/DEvufTHj4XO5ezaarWy9tthjjSROsQZaehA8D9z/lMlZh108i/pZhQMVQrn26PQNiA8dHnenEZuXhA/EqgRobBJxZM3a07Sz/wlWPPqIBed/gkW92SIA4k+Ynj2XymDTP3wJ/Ea3AP7anI7qlz/ReXj8+2vlwJSw8k3VYrcPbLia41kp8M2sIzX7QD/DjlkzLYbwJB1zbQwkskcTiG7gLb/Q1E/mYUFquFbCy+D35FJZzURLqQkmk2VSJ1p5koWi11aMYhf+ecBP9gJTuzhziWa1DZTwFJQ50dcw2jb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 053120fb-f1ba-4d2d-0939-08dacc6a3e3c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 09:16:31.0630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I9E9+tgbqpgRoWgoDRiUF6nmfVPaRJ+uPW1rB+0lYunJhXbcTqyQM/m1PZGySOxs1cJqEDn7bl+Ej+bsLDr93Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220068
X-Proofpoint-GUID: Bva-DxqzXgy5zxZyYBp6GZ-962KBXtBF
X-Proofpoint-ORIG-GUID: Bva-DxqzXgy5zxZyYBp6GZ-962KBXtBF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/11/2022 03:39, Mike Christie wrote:
> This begins to move the SCSI execution functions to use a struct for
> passing in optional args. This patch adds the new struct, temporarily
> converts scsi_execute and scsi_execute_req and adds a new helper
> scsi_execute_cmd.
> 
> The next patches will convert scsi_execute and scsi_execute_req users to
> scsi_execute_cmd then remove scsi_execute and scsi_execute_req.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_lib.c    | 50 ++++++++++++++-----------------
>   include/scsi/scsi_device.h | 61 +++++++++++++++++++++++++++++---------
>   2 files changed, 69 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ec890865abae..327eb2df5583 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -185,39 +185,31 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
>   	__scsi_queue_insert(cmd, reason, true);
>   }
>   
> -
>   /**
> - * __scsi_execute - insert request and wait for the result
> - * @sdev:	scsi device
> + * __scsi_execute_cmd - insert request and wait for the result
> + * @sdev:	scsi_device
>    * @cmd:	scsi command
> - * @data_direction: data direction
> + * @opf:	block layer request cmd_flags
>    * @buffer:	data buffer
>    * @bufflen:	len of buffer
> - * @sense:	optional sense buffer
> - * @sshdr:	optional decoded sense header
>    * @timeout:	request timeout in HZ
>    * @retries:	number of times to retry request
> - * @flags:	flags for ->cmd_flags
> - * @rq_flags:	flags for ->rq_flags
> - * @resid:	optional residual length
> + * @args:	Optional args. See struct definition for field descriptions
>    *
>    * Returns the scsi_cmnd result field if a command was executed, or a negative
>    * Linux error code if we didn't get that far.
>    */
> -int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> -		 int data_direction, void *buffer, unsigned bufflen,
> -		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
> -		 int timeout, int retries, blk_opf_t flags,
> -		 req_flags_t rq_flags, int *resid)
> +int __scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
> +		       blk_opf_t opf, void *buffer, unsigned int bufflen,
> +		       int timeout, int retries,
> +		       const struct scsi_exec_args *args)

I suppose that you could alternatively continue to pass a struct instead 
of a struct pointer, so no need for the checks for args being NULL. As I 
see, all the direct callers of __scsi_execute_cmd() pass NULL anyway, so 
another macro in scsi_device.h could make it concise to implement.

>   {
>   	struct request *req;
>   	struct scsi_cmnd *scmd;
>   	int ret;
>   
> -	req = scsi_alloc_request(sdev->request_queue,
> -			data_direction == DMA_TO_DEVICE ?
> -			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
> -			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
> +	req = scsi_alloc_request(sdev->request_queue, opf,
> +				 args ? args->req_flags : 0);
>   	if (IS_ERR(req))
>   		return PTR_ERR(req);
>   
> @@ -232,8 +224,6 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>   	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>   	scmd->allowed = retries;
>   	req->timeout = timeout;
> -	req->cmd_flags |= flags;
> -	req->rq_flags |= rq_flags | RQF_QUIET;

Are we accidentally losing RQF_QUIET? Or does it matter?

The rest looks good, IMHO.

Thanks,
John

>   
>   	/*
>   	 * head injection *required* here otherwise quiesce won't work
> @@ -249,20 +239,24 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>   	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
>   		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
>   
> -	if (resid)
> -		*resid = scmd->resid_len;
> -	if (sense && scmd->sense_len)
> -		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
> -	if (sshdr)
> -		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
> -				     sshdr);
> +	if (args) {
> +		if (args->resid)
> +			*args->resid = scmd->resid_len;
> +		if (args->sense && scmd->sense_len)
> +			memcpy(args->sense, scmd->sense_buffer,
> +			       SCSI_SENSE_BUFFERSIZE);
> +		if (args->sshdr)
> +			scsi_normalize_sense(scmd->sense_buffer,
> +					     scmd->sense_len, args->sshdr);
> +	}
> +
>   	ret = scmd->result;
>    out:
>   	blk_mq_free_request(req);
>   
>   	return ret;
>   }
> -EXPORT_SYMBOL(__scsi_execute);
> +EXPORT_SYMBOL(__scsi_execute_cmd);
>   
>   /*
>    * Wake up the error handler if necessary. Avoid as follows that the error
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 24bdbf7999ab..578f344e330d 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -454,28 +454,61 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
>   extern int scsi_is_sdev_device(const struct device *);
>   extern int scsi_is_target_device(const struct device *);
>   extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
> -extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> -			int data_direction, void *buffer, unsigned bufflen,
> -			unsigned char *sense, struct scsi_sense_hdr *sshdr,
> -			int timeout, int retries, blk_opf_t flags,
> -			req_flags_t rq_flags, int *resid);
> +
> +/* Optional arguments to __scsi_execute_cmd */
> +struct scsi_exec_args {
> +	unsigned char *sense;		/* sense buffer */
> +	unsigned int sense_len;		/* sense buffer len */
> +	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
> +	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
> +	int *resid;			/* residual length */
> +};
> +
> +int __scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
> +		       blk_opf_t opf, void *buffer, unsigned int bufflen,
> +		       int timeout, int retries,
> +		       const struct scsi_exec_args *args);
> +
>   /* Make sure any sense buffer is the correct size. */
> -#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
> -		     sshdr, timeout, retries, flags, rq_flags, resid)	\
> +#define scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, timeout,	\
> +			 retries, args)					\
>   ({									\
> -	BUILD_BUG_ON((sense) != NULL &&					\
> -		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
> -	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
> -		       sense, sshdr, timeout, retries, flags, rq_flags,	\
> -		       resid);						\
> +	BUILD_BUG_ON(args.sense &&					\
> +		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
> +	__scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, timeout,	\
> +			   retries, &args);				\
>   })
> +
> +/* Make sure any sense buffer is the correct size. */
> +#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
> +		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
> +		     _resid)						\
> +({									\
> +	BUILD_BUG_ON((_sense) != NULL &&				\
> +		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
> +	__scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
> +			   REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
> +			   _buffer, _bufflen, _timeout, _retries,	\
> +			   &((struct scsi_exec_args) {			\
> +				.sense = _sense,			\
> +				.sshdr = _sshdr,			\
> +				.req_flags = _rq_flags & RQF_PM  ?	\
> +						BLK_MQ_REQ_PM : 0,	\
> +				.resid = _resid, }));			\
> +})
> +
>   static inline int scsi_execute_req(struct scsi_device *sdev,
>   	const unsigned char *cmd, int data_direction, void *buffer,
>   	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
>   	int retries, int *resid)
>   {
> -	return scsi_execute(sdev, cmd, data_direction, buffer,
> -		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
> +	return __scsi_execute_cmd(sdev, cmd,
> +				  data_direction == DMA_TO_DEVICE ?
> +				  REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
> +				  bufflen, timeout, retries,
> +				  &(struct scsi_exec_args) {
> +					.sshdr = sshdr,
> +					.resid = resid });
>   }
>   extern void sdev_disable_disk_events(struct scsi_device *sdev);
>   extern void sdev_enable_disk_events(struct scsi_device *sdev);

