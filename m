Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44010C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 00:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F57164E40
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 00:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhBJAPf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 19:15:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbhBIX3z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 18:29:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119IiMJi062819;
        Tue, 9 Feb 2021 18:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RBvQgOIQkiqLhXNyq5lVBQQIOJik85d94bDvUBIJaRI=;
 b=r35njulC2eC94ou7YXHGk4fgz+XVJBJY9lwtofjsH7yjRqNoGwfTzMUvHOOUKyuWxsCH
 ptabc8HO2L1r7i8MAmzN5Ndgiet6aLlqVuw422oAsTU0XXA7LiN9Ha4UXEsbO/1XXo5+
 y+fwDdHB9M2AI1DuSwEfkGYOcH+99EYH3dJcNSuGcPT6DaDu5YDFEfr6e3Nex3l04XSt
 l0bYIjPUxEjCBgXe3DIhSp3hf0ULAOfv6QtSxs+RdBzRI3+dAt+QiOMDGzEpnnusjsRL
 EBMnNl13Y5tQgWnX7vv+1OKy2TPB4D1AE/eZjd1bhIv4tw9+7q6yw+JmmJFuHuOvIUI8 jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36hkrn0jag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:44:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119IPQF2072593;
        Tue, 9 Feb 2021 18:44:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 36j511kyh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:44:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecI7fmnmek48x9z59JkdmP/7KSnwsRGCBnvGQEdjUU333azzCydI+wMPI1JkuOE9BzHi39Tz0qgoeV/GylFk7Nm66hsnMhmCbtKiwDdSS++xY15yGEhdvWvfAwwP+kpsdWUuYfdTPAfaogIFzVdP1C70k5fB4RYztgQNV9372S6DsQkNRB0iCnI8N+fIvhX4aRwAc5zSgq9/oMH8hRU1k2aotyFPu67MNM30XF2kg02hBVxqJ4QU+2JBnGapQg+PU33p+ANotbPs1JlanVVOcGrZTmUOUTcD9fXSWNVnrzGuLQuZF6HceFL+LlXEk7SEeOMWYI6jQAPg9b5BUfAUFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBvQgOIQkiqLhXNyq5lVBQQIOJik85d94bDvUBIJaRI=;
 b=g0QEgb2cqeCR/jKcvffSKjaaATYwlVoYr989X32HcNYsrhKDx1Gi0VW64TTBcDMaCwoxWDtPn+YGI4jo/ufGLt2ZkKX2WAFJXmK6MVj5xHQ2dpLDSU3AJP1nU8oG1S7vixtIrOcz4EJbYVVHKs0hAuv5l0xdKS3uVLOca2hzEHxKVTIu05oJkmLDucFwO6lhBzRqmyeYzTv1ikwrz6cYB1+FsQDywoBMH74Y3UMVjR3QiE8ACfX92boehOUPfJYLoCAe/KimdpVL/VMT01KSOI9+cE91zz3TTGARusT3s0JXMLYKrX+QRhPmoUC/TwRi8c7IWBBuXwAFL9in0rsOjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBvQgOIQkiqLhXNyq5lVBQQIOJik85d94bDvUBIJaRI=;
 b=w4lSGwUGQ3VOvMDeRr/+0fZ1TgcMV67dgBIjJ91/wMlk6UDxWNgIFD2u7cftb9xng41uvkreJNzSq4hAaN1/1RlLaaHhd8wtDlbhBWZgcfMIeUDwTj74AvFRlAKiCNzZ2V0WYThV65HdQNQ6fHRKFMuX5nBDIX5HkVJyN3uufVo=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4195.namprd10.prod.outlook.com (2603:10b6:a03:201::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.28; Tue, 9 Feb
 2021 18:44:19 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 18:44:19 +0000
Subject: Re: [PATCH 06/13] tcm loop: use lio wq cmd submission helper
To:     Bodo Stroesser <bostroesser@gmail.com>, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-7-michael.christie@oracle.com>
 <70353be9-f6cd-6931-ea87-5a393e418a35@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <44208ba8-ee34-3643-b082-41e3406c5411@oracle.com>
Date:   Tue, 9 Feb 2021 12:44:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <70353be9-f6cd-6931-ea87-5a393e418a35@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:610:32::33) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR07CA0028.namprd07.prod.outlook.com (2603:10b6:610:32::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 18:44:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95227cec-04cc-4612-3082-08d8cd2ab552
X-MS-TrafficTypeDiagnostic: BY5PR10MB4195:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB419544B4A2884C50B3910FACF18E9@BY5PR10MB4195.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:98;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AaSEQN32RHMsnB7qwwFSwtdTgHhB1Uzno9+GxeVqylhCqSTOfz56ghunLtsErSUS62ueP+n8zvFRb0n1TZC1c8Q7uoqOTZWI9WfPDg+EIblfVXM/wpk47kOPhZ5Uia4uVk5jSn0wXfbsWVeNS+BrACwHkRMkhOe+1iALhH5hwJg51qT4qbM4DYCPdlRUbJ4k2+ND4vCnhqcqhOCRV64ajqCTblxYD0wwfEJ2D1xq7ooLI5/865vpj9Qr7AAsGfocPz/nUHesQ6UOKNEWJDiO+mrsHkFGglxmucETLGG4jT92LIg68FgAFFebKj/r4Pu7IaDuFKqeznZkS8SGTFM4wQL+hdWCueqkSYNiK/SmFO5Uu/gDQ9fQm5JybW9+WSrGx2kWSjqWDi+RGzOq9+IhZjJkX80kHPpqtJy3815wjMz3CyuR7sCAo7o5ISJDRsNXzcFrsSBqNy1X3qyTCqkFj1uSRn3Xg3WWYpzbdDnGr5+4w46D9Xoa7ovymRlTPZ7uGXn8gDsVjSaDYE2evpPB3bon1sDs3yTHsDm1qYPzbWuW+hvSA4ehyhELvfDJYWl49MpeRcKs7mny4driV/Ww+fZtPlOc/Dm4sgqDtXDP0qqOniZV5HrMwN7GmXc3xxUx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(2906002)(8676002)(31686004)(31696002)(86362001)(26005)(8936002)(53546011)(478600001)(956004)(36756003)(2616005)(6706004)(316002)(4744005)(16576012)(66476007)(66556008)(66946007)(6486002)(5660300002)(16526019)(186003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OGpBTlRwejFNdXJ5OExJVWhxUEk5ZUpJaDhGaTk5QU9tcmQxTGpmSGFkY0JC?=
 =?utf-8?B?bGVFWWR4QlJIUEVTaVgreUx4VlhyTUlmaDk3S1VqblBRSFFkQWQzeXQ3S24v?=
 =?utf-8?B?VVh0dSt4RVZGcmcvWVkyZ1BiTEtsVUpzTWlqUE90ZXNNRU1EcyswdXVmSGdP?=
 =?utf-8?B?bE1zdWdZaWErRHoxYlpsWTZmVkduNEszSkljTmNWRldTN2E1bzFyRXc3bVlj?=
 =?utf-8?B?YkY1a2hFRk1tcWxmVExHUXdUS2MzVlZjRXlnQ1pDRStlRGxrNnZobHNhRGFJ?=
 =?utf-8?B?Ti9VYVQ1UUdzT0Z3WVltYTI3VnZIUW1ZUkJBL3pUa1Y0SmZjWG92cjVDdnJi?=
 =?utf-8?B?enpyekIxNlEzRmlINVB5WmNQUGFZSVRmQVdkbWVvV2xmUXg3YWM2SjQxWmFp?=
 =?utf-8?B?Ny9GT1lXVkc5WGVEenVLUGlMQ1drQ2tFZGRJVzRlRTJieGhTWFQ1cTE1RzUy?=
 =?utf-8?B?NjVTdTVyVElVdEVmU3kwelg3Tk5ta2ZRMXBSSlQxQ2hwOFNVYTFCQy9XYi9v?=
 =?utf-8?B?UmFnUkVKSlhkOUgyWUVWLzg2cDNiK2ptQmZHb21tZTV5SG45a3k0ZWRCazk0?=
 =?utf-8?B?L0hHM3NBUUxWek9QUFM0ZzhkY2o0S2E5clBxekgwKzd4Yit1TmtBWWFQWmVW?=
 =?utf-8?B?MjhHR0pQWHBFMG8yWFU0Wklnbm5FeXVPWW1qVndMeGdoK2d2Y0pNMWRDbXNH?=
 =?utf-8?B?czMzakgzYlg3bWxOMko1b0kzN05ITkVoQmRmYzhLemF3TlNyc250OXJpd3FC?=
 =?utf-8?B?bmRQb21HQllPbmxxOHAwVXJSeG8wN0V5bzYyZVNjVk9CVHIvUmF5dFNnVU4y?=
 =?utf-8?B?MzBtQkl5R0pOTEwrY200K2s5Y3R1OWh0K1lLc1JqMGVxK3dYTHMvRDVEUWNH?=
 =?utf-8?B?V0ZCa21LaFJVSThUZlhjTmlNQnhkeS9JOVY5U0E5ZHViS0ZEWUcwbzh5emF0?=
 =?utf-8?B?ZzFjNlZTd2YyK2R1K2ErWTBYejBmV3dxeFJzR3FoKy92S3Y2OGU2NCtYeEpV?=
 =?utf-8?B?ZGxTRnUvVkJmVkwzNUFmdjFyM0U1bGVEeHRqY1VTblU4WG1WajV5L29vN2JU?=
 =?utf-8?B?K2w1TVNxdWw4a3pxRGNPUHBJUHAzbVZoa3VQZUcyNW1yeHd6TnhjQXlqdHFE?=
 =?utf-8?B?bGhhaTJSY0lCK3dMcFJkcWgydXI2dW1SQy9kWE9ONXdrVDczc1E5R1ZBK0cw?=
 =?utf-8?B?MFdjclY2V3RlanpVeVZzOHR4VE5JOUVmMEQwYUVuN2w5cFVjQTcxYWZFNkp1?=
 =?utf-8?B?Z0p2N0lMTDJuOEdIL01UUjJncnN3eXZVN1IveDFyMURIOVkvQVFJakdSRXEr?=
 =?utf-8?B?RmtqM254aFB0V3JFclp5OW5BYzdhNEtmeGtPNzJXeDY1ZXNaRld2OGx6ZXQ2?=
 =?utf-8?B?dzZEZEcyVlU5bXRFVE1TTzFyd1RmeUZPbnZ1d1JQT2JEMk4wUnVwck1KOVJk?=
 =?utf-8?B?aGNiWFF4cHlaYmRIOHJPSEl0ZU5CUDdKNzlyQUNvS0l1R2RrcFJTQktjeHh1?=
 =?utf-8?B?R3FXTTNLOTJweVlXQ1c5QVhsQkI2SEVBU1dBOUl6VkFaVkZka0YyS04zekhB?=
 =?utf-8?B?b25YeGM0UmZHV1ZDeXFSYUU2ZVNKdEF5VC9MMjYwSjBJMnRCRTVGa1FwVzZD?=
 =?utf-8?B?SUdLK1Zoa0hTZ2tJam5Xc1llVjhDSzgwSEJwWUE2UjNaRW9JYkxUSnJCYXRN?=
 =?utf-8?B?bldETTc4WUpPbUIxbzVoYjFhZlBRdFJYSGFwdklJL1czem1LbStQMnY1cWRz?=
 =?utf-8?Q?LoeTfOZX+iYz1qgEhlp2qreMS2SpjFrDQAMaf4N?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95227cec-04cc-4612-3082-08d8cd2ab552
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 18:44:18.8477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUaMtWaQErs+cwofKKlErN9LwwXlgWtzbtYacJl9f1rU0FjPNBZKgerpfMkemfGyIhv4t7hX7Qx9CKnDbSpE0TcGbyjcGzsQBF/OVolvwtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4195
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/21 9:59 AM, Bodo Stroesser wrote:
> On 09.02.21 13:38, Mike Christie wrote:
>> @@ -179,6 +184,11 @@ static void tcm_loop_submission_work(struct work_struct *work)
>>   static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>>   {
>>       struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
>> +    struct tcm_loop_hba *tl_hba;
>> +    struct tcm_loop_tpg *tl_tpg;
>> +
>> +    tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
>> +    tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
>>         pr_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n",
>>            __func__, sc->device->host->host_no, sc->device->id,
> 
> AFAICS these new lines are not needed. Or am I missing something?

You're right. I'll fix it.
