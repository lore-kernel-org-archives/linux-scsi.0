Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D8AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 18:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD6564E62
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 18:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBKSOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:14:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46146 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhBKSMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 13:12:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BI5cxo050252;
        Thu, 11 Feb 2021 18:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=yPOCmxbpdSg4dn+uPpt85Xu4RjGwrCjxrL0/yA65JwE=;
 b=W+Kpv4PxWmlZuNusQbUTKJQ5vUVHx8yKsdXjdmBpdIa35JimJu/Tz7Kb0emcWeMGLl8H
 k1PxhYfZKZz6LRtmWDtxwcWA/+oElbsrBkhrZuVQ5SEnija9EoM2a1YMHuekWu453V98
 gU/wEVzslrxzthn8EaqOSuWuVAWw3sA+1dr36iDEpmACB+t1bed8s+WGfrWAUsP6QIND
 lyfLC0Jjfqz9k1mg9hVkru8G+FaH2Rqnbh0FJYg4S86CQW1AisTi7PWwBAaYrbfcVqqZ
 TlXlP3azPq5U5aIvVo309RDCC7usWQGialt8kDsvIYnUm3P0P+uDlKoR9ayJdwosiNnQ Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36m4upy3h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 18:12:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BI4m7a036197;
        Thu, 11 Feb 2021 18:11:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3020.oracle.com with ESMTP id 36j4vukt0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 18:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ge+PZTvRMTyiYXxJ1tziHwK909u05PzA69eD1Mp8PPD9C7jvYeLun9D1B8e4+WpdBk0Jge5ixKMO0BHgN+QE8Fvw35mCoRRM1cTeEhBYpbf/A0HU0bVAdYUDmBFgbeApcIgiwV0a4f6vPZNAn9Xjf29gsh11+0Da3VHG7OLi9YCj67z4BaGnqcHKRY+d6NQCp5Sf98vXGBDpkq9hCaJAWQUjmW/aSLXB5Odw8lFPqwqdFBkT2wBFOlx7S87r20FS+U5zuCKOyayYzGfADKXg0/0IsNPoaXBjeVKuvwCel0d/kpwjC3lg5kRBRVDRa9trdT+4cBZq4uj4rSsyYW6HcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPOCmxbpdSg4dn+uPpt85Xu4RjGwrCjxrL0/yA65JwE=;
 b=kroT+z8+kUy94KvzNklvVtRc4FhXWm6OC+xeWy6cu28NYH2noQsgV6CERKDK/Vw+eEynU+U1en4cbZgFEIl19S/LzhKb+j7L9IEJV50Fkmxkw6IHfXva4/DQdKiDzQQw449/LbcYd+MrpellqCjxAtDXijyyhnQ4TCJWqA4OWziJRmTLCP6KvcHZqA+E1pMAdKGdYeag+/WQB2r4pbt0LZMXLseFXr+Oc7AL9N4ipkK/R4xBtWvAkANxZy9awUaZy2/mvZgZyunnED6tHw4iWuR7HPYOvLL/V42T0ArjMtSI2fVT9t65leRKsDFdg7ZRuFeL9efqWaopjvClGyK9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPOCmxbpdSg4dn+uPpt85Xu4RjGwrCjxrL0/yA65JwE=;
 b=gtmRtXx+sJH1dpwQsHm0r1zYrwsc2kCi/Qzine08iBdO+PJSlFhE8ykE9Ef6kakxWrkdjLZkuf+0TVFPZaPBlB6egD/VBH+jf74dPyvCa83mpI39w6ACZS5bqV64S9h5H2p3Yjtiz8AKrz1roowI/25P2UpvAOEBRdWari1L7LA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4243.namprd10.prod.outlook.com (2603:10b6:a03:210::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 18:11:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 18:11:57 +0000
Subject: Re: [PATCH 14/14] target: remove target_submit_cmd_map_sgls
To:     Christoph Hellwig <hch@lst.de>
Cc:     loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
References: <20210211122728.31721-1-michael.christie@oracle.com>
 <20210211122728.31721-15-michael.christie@oracle.com>
 <20210211151750.GL22082@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <81b24494-eca8-d30f-5aa2-8bdedff0fd81@oracle.com>
Date:   Thu, 11 Feb 2021 12:11:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210211151750.GL22082@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:610:33::26) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR08CA0021.namprd08.prod.outlook.com (2603:10b6:610:33::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26 via Frontend Transport; Thu, 11 Feb 2021 18:11:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eba6f36b-5dbb-45c8-ccc6-08d8ceb884fc
X-MS-TrafficTypeDiagnostic: BY5PR10MB4243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB424368CF06E364769E507823F18C9@BY5PR10MB4243.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHFxZn8Jw50Mab0GGj9WZer5uQSU4saSzPF7V087FKS4YomZagQpPFviQBQkqMbACfdV6emI+GvjZ8XNum0Y8G1oc/TnUQvMcM3ibVIQlqItIWvaUADE7P6fuABUhZd4LQpwQZweQytR2M4YkacRBDUmnEslVZwsCwcV873p8tG7laSg9vTQUwjPgDTar4uF6TBTRSI+jKqPlXiY9LvejcDXOKW82dqYo5WBwFS4uZuZ17WDW2XLzVnAjYO89vGqGFCDWihSXSgELzKAhlevnURDRrMHrWBCIofQuwadv7qa6YF5kpKj4z5STlUme/q82dGSdgUiRbrnLy/8LWPGpFrRy1ehISkzwkgsG945SW1EB7pWGdP82735J0Nk77m0MFTCSjY1WL8BG5MAVDqDKrzogESeHx2Hpn4+zfJ3F1SooMhmTm3dNlo8jg0lbLAco4umKB5ojoDH7zNWFFUbVV8J2rZFqmaJtbSfznl0A7Tc98q4gM/cVo8odx/w8rNASqDNgmzBvPbui6h3mP6QLSaW5NDZU6Kp6YO2Ex4hnIK5oHW6B8Wz2UQ1AYckfyp2DzxFZu9YIGNOuxKi7cIi/t50g0klqG5yT9DfNZ5FeAwcUnnzld2cOsoP+Oh4kYeD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(16526019)(53546011)(8676002)(86362001)(26005)(66556008)(186003)(83380400001)(8936002)(66476007)(31696002)(66946007)(4326008)(5660300002)(31686004)(316002)(16576012)(956004)(2906002)(36756003)(6706004)(6486002)(478600001)(2616005)(6916009)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SUpMYUpRa2VPTzRTWUw1RCt4enVGUkpLNWxrZzF5UitnYzZEb3FkcGRrUm5V?=
 =?utf-8?B?NDJxaHZ6M3lCWlZWWVZ4UjJvYVkyTTBwVTc2Z3EvS05rMGVpd050cE1MUC9L?=
 =?utf-8?B?WUFDUkt4K0c1a0UxcTZZdnk2MkFiZzU5MWVpTmJieXFCVGltbFVGTVFoMnIv?=
 =?utf-8?B?Y0tpYkhaektxU3VmTkxqYVdRODMrVWNQY0FlV2tuNHA5b1pNb09NbnhMWStx?=
 =?utf-8?B?YThPMnM1bkZOZmN2dTM5NjlBQmlSb0NRaENDeVRQdlJZS0JUL2tRRDZ6M09r?=
 =?utf-8?B?d0QzV1h2QktGdFJtck1Bd1hzZ3RUVEVQdy93dzViUUUwc0RIU3JDOFh0OTdq?=
 =?utf-8?B?MlVqQ3Y3ZmUwSGxDN3IvamhKS214RExXL0ZEUzhiRnJVSjZoSEFhdjJ6RlZi?=
 =?utf-8?B?aW83NVA3N1BUNjFlZFozT0liMzZVcGI0c2R2Qzc0dnZDbFUvVDRSQW9xMGhL?=
 =?utf-8?B?V3VpbG1JRmdGL3QrelYzYWwyTGZuK0VvdTZBQXg5cHRPVnFGSU5NRjY4QVFr?=
 =?utf-8?B?QlY0a2NxWUV2d2hReDRuaFFYK0Fna3VTR2NUMVlscW84ajJORVp1aGNsdEM3?=
 =?utf-8?B?RXVTQ1RRT1dQUElHL0dFTHJoNEdpdFdhM1AvdFdLL3RGc281dkI1bnpsdFUx?=
 =?utf-8?B?MHVIa09OV1E4a0ViZXd3MThsU0RvellOUVBYQnFWakVhYmdmdjdkRmtYdDNK?=
 =?utf-8?B?QzkrdFVOZm5wMEkwVkhTcEY5V0Fsd3I1TVEzZjlubFhrRzdoRTVUaks4K2Fa?=
 =?utf-8?B?ZzlNdndUczErM0RtWWtocXdFbnlnV1NUdlhDNlN6NmdSaHh6djZqa25iVEw2?=
 =?utf-8?B?YTBRdEczUSs3R0FpakpNNmNEOXVILzBmbDNWS0FLdEJDYjJYRzBmRXQyMlNH?=
 =?utf-8?B?NjJocVdDL05TanNkOFJTWERaS0hEdit2cVl4alY5Ylo1VUl6UFFDZTRKeGZD?=
 =?utf-8?B?MEg1VGhJbUJ5MlpSUFRwSWUzMGFUWjVETnFjTTd6ZDYwNmVBUW1BZVpsN3FW?=
 =?utf-8?B?TlExdG1OOVc3L2c1UWhxMDA3RVRXSTMwTFI0Z2h3Q0FyT0NDRmVWUU5DMDRi?=
 =?utf-8?B?TjJqRExsNnlRRWxyUjFiNmdNN2dyaDRwRmdjaGFvNDlJOVg1VVRlOUJWK204?=
 =?utf-8?B?dHZ5dGRwUEFQZTU5UFc1SzlNM1gvZVJGNzBlbmJ0czExc3RrZ2NlU3NsNnlw?=
 =?utf-8?B?Qk5sUmIrdUs1WmJsa2ZQd2lnZHo5aGN3VjlqMjBTUFpzNmxTRWVTejltRktH?=
 =?utf-8?B?czVtbmorMDgwUXhETUl2TjZzTXk0TllWN0FYeGh1blZwQU8rd3dqWVFwRUs3?=
 =?utf-8?B?OFViYk1ZWWN2MTNWVmdsOG9INWtOUnlBTHdhVTUxNWl1UmdtU0oyd0VvR2Ri?=
 =?utf-8?B?T01HOHUyblA0bU82MGphUXJKbUVObXNPb00rYm11d1RueWlIbUV3SC9ydkRF?=
 =?utf-8?B?SzhINlNiZFJZaGpRbVRzU0FCMC9uWnc1YUFVRGtCeDJqR2JQc1BhVC9mOXJv?=
 =?utf-8?B?bkZPSWo0b25kU3JYNFA1TWdUaXA5TEFwZ1hWQmFEYlgrN1BZNEJWdTRmYTN6?=
 =?utf-8?B?UHZTVVRvWGRsR2t5OXpLRzdzb3JMKzZtYnNZT1ZZT29ZZUNieHpWYk5uZWgy?=
 =?utf-8?B?SWdqZjdpcFIzb0hKVmdjd0hDQS9NREUwclBGRlVDZE12WHNxK1VVSFcwU2o1?=
 =?utf-8?B?bTVWT0FrQ3lZTXpEV0dtR3hzcnlkUUJwaXhZV0NnQVhFSFl4a0RVbHI1bm5m?=
 =?utf-8?Q?15nFmjxPKFhD9irnPdlVUi6We4x59v7Oo8MJ3xG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba6f36b-5dbb-45c8-ccc6-08d8ceb884fc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 18:11:57.5088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxS2Z2Mmc/msrb+DqU7PejXXX58x+HyZeWbHS+HOY6RHpYrTur42yDEZ2NUhDGiUSwiOtkFHHA8oT7+aGsD8dFsh2On/SWOIPe4GZUQ6+uw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4243
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/21 9:17 AM, Christoph Hellwig wrote:
>> + * This function must only be used by drivers that do their own
>> + * sync during shutdown and does not use target_stop_session. If there
>> + * is a failure this function will call into the fabric driver's
>> + * queue_status with a CHECK_CONDITION.
>>   */
>> -int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>> +void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>>  		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
>>  		u32 data_length, int task_attr, int data_dir, int flags)
>>  {
>> +	target_init_cmd(se_cmd, se_sess, sense, unpacked_lun, data_length,
>> +			task_attr, data_dir, flags);
>> +	target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0);
> 
> Do we want a WARN_ON_ONCE here to catch the case where the API is
> misued?

It would be nice, but I couldn't figure out how to detect it here.

For example if the driver calls scsi_remove_device to prevent incoming
IO and flush running IO and so they don't need target_stop_session,
then I have no way to detect that above. The driver writer had to know.

