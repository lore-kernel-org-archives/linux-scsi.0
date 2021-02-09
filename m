Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD44AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 18:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96EDB64ECA
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 18:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhBIS5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 13:57:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbhBISt6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 13:49:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119IiZqr073739;
        Tue, 9 Feb 2021 18:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2OTArJVgA1O9VMZs+gqwxkEm1RSQClTZJSKIg9Vl7mk=;
 b=YZQl6IeykKyc3QyQkEHZ/0hTwCCBJr39O3sUflrwolA0oWpwNGUUKShUS3YCdqDzGG4B
 GR9LVUiapTudNjad0IEZfelIWR8U3746jyOhA1KHITon7QB0ELnjIQz3Nu9sGfiBT5FO
 0eGZ9YPaFW6B2mEqmNlnX89f06rtv/DybinBMwyBAt0+DQLX4xBEtVKbUb6FTrWUQKmK
 z2wofO86LX7kK64qXMx9ADJ60PwfT7UYDXCSpqFojJUTCkNXRL29QPTp7zIRlw4/Vw3C
 VD6B4CTjYRNKBpDr69NoBpXUfEzAaw2XkOLg21Oth+Ktp3KPIHvyb3gM8VM1VDPyPHh+ tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36hjhqrn6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:49:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119Iju2k128496;
        Tue, 9 Feb 2021 18:49:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by aserp3030.oracle.com with ESMTP id 36j4pp3up5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:49:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R19/GuZCLmbzwjLgl9OwyOnmW0Jy1pqWxdj2vLGUr4Hcog5OCvC8AGUGOdcBjSR3JteqSBb2QHNIv3JZ05xlVl6Wy0QPNkyL7ntNjjUyHPZO31kXOnY0LWD9ui2mpeuzse975FlcAiw+w3wC+CRX0GsgSHPwDcIPmKrx5htHguj/Inw1VjFIkkB88IVIyEKIbegzK378SVZGssVxSJW2CKIBfZGr2AmXd8SVNbXfGriwV/orUf89J41MrolO1m29O6FnMzSjB9Rio/5AtEo2ZcbLXMXg6lQ+wzWkaKBmXRr/WI5mmCDoo/Kw6bCT4t2wTge33W6kzHOZWUGt4HOL5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OTArJVgA1O9VMZs+gqwxkEm1RSQClTZJSKIg9Vl7mk=;
 b=XBPwwe2FIrXpde1eGpg2MNRashJqqdI/+NGZtH+LvxwBm2LkQUgsXyhUDx97lqSeu90bL3BAyk0nyKJdL4wuZoF03idcXkfC1WXyUOkCKaZkkAgcT6SM64nbjLn2Kw1o+Pfzti/cMH6oPCXnaJDA+LXntmUwzXYOmoZGtEVAUeBg27Fi84fz+ShSnoI2JKEdeAkxignVBWgb1DqNA7CvDUq9S2OMiddYYxOfB9/h4eGo545ujqlxVDT+job9SIYZKvL90pDsorNPViG6Ys9/WT5Kkhodn6aTm4qwcpbWIWx3djp9zu6eRXhvKBEYspV45OGBg0CVj1TagSYoqVVC0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OTArJVgA1O9VMZs+gqwxkEm1RSQClTZJSKIg9Vl7mk=;
 b=kWHpkUNPxIfiaCAGrfSdzz4bBvoyl3WkqDDhTEUpSvy3FAHH8a+tteHvj96Xw6sJX/DFb37OgX8k4P0HWi8Ie6VjwxjR7MgTvizFrMCfr6vw6pyCn2LU0IbmKugUwk7D8fs0Dh5Y2k83b4md2QGiu+oRr14I8OwHdX4OPzOZsO4=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4195.namprd10.prod.outlook.com (2603:10b6:a03:201::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.28; Tue, 9 Feb
 2021 18:49:09 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 18:49:09 +0000
Subject: Re: [PATCH 13/13] target: flush submission work during TMR processing
To:     Bodo Stroesser <bostroesser@gmail.com>, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-14-michael.christie@oracle.com>
 <47fd4d39-33ab-4d9f-bc74-5826fc47b067@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <c45a6710-f677-c5eb-36ae-401b10c51d58@oracle.com>
Date:   Tue, 9 Feb 2021 12:49:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <47fd4d39-33ab-4d9f-bc74-5826fc47b067@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:610:38::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR05CA0069.namprd05.prod.outlook.com (2603:10b6:610:38::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Tue, 9 Feb 2021 18:49:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af364e25-750b-427b-32d7-08d8cd2b629e
X-MS-TrafficTypeDiagnostic: BY5PR10MB4195:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB419580E99C6D9A9556AE3613F18E9@BY5PR10MB4195.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /rSP5l4WqGoE1UveaRD/BL+0wa5vtsumHrdvnJnaSUzLOo0J6LzkWt9ATqp5Q/bII0Qmshg8Qxfl3GZMJsT+ukw6x72z63W2Ix/FyG0dZp0vmL1+TpA51EPSRnOr+qM1/WdO/jNdGS2jeDsXmpwgd5+8CySFZ8l+baoe/s9SBd5Rcv5Vi/rqOAXCP6vmVR9Fd3e0K8Ub7ASnBWMLsbL+tZAqiufSirdhRnl92lhl7wxHp0EZMm6RjH+9tyo1hYHqj6Knthb49QlhCe3hxf/M+Lv77c5FjN4y7JjhqqD7XuBnw3/Fhfr9NxSSaO5PsmN/XwpRq5aVTlQWfUstKCoiELJvsaOwmbRi/qPAOH3py5jYgJJtk0Sr7yPyt5wtwinzJ4b0Qtb1NLU23f9vnf17qIHpTn72QRbea62vMLD9eZ7TluDrXIZZRn+MJW8+i3/zzxE/rnCLRE/iYwqUzlTn7680ninsv9KYi/FPc6nHB50bv4oSCqOkwn6UTOBzuKfIRfXmmQz0iFozNGcuBPoglHsJEVndN7kPMPo9ID/y92+Xy1D2pthQHaX/7X2yjDFjo++pXP0w24pkL7v4DflCwp0T5JSyKJxt7r4UO60GEL1mOCoVDgpkCnrNmHY6oZTs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(2906002)(8676002)(31686004)(31696002)(86362001)(26005)(8936002)(83380400001)(53546011)(478600001)(956004)(36756003)(2616005)(6706004)(316002)(16576012)(66476007)(66556008)(66946007)(6486002)(5660300002)(16526019)(186003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OHpsTzhINGc3Zmd3dWllcXJGdEZJam1yN2dsTE1sTzRta3Bsc0tUdzh6VUdo?=
 =?utf-8?B?aHhIRDh4MzkxbHNkR0EwMzFtNFljS29LZXoyU2UrNnErZWtsNXVTaVRnR0t4?=
 =?utf-8?B?WGcxejhBd1A1bVp5QUg5R3hVQWIvL1hlZmhKOURXbk1Lb1B3ZzE3V3ZlQmFh?=
 =?utf-8?B?MmlXaGFrR1ZWYXN6UkprcnZHNUdGM0YxZ1VLajMwc0Z5d1JvNEo3M1hpWTdY?=
 =?utf-8?B?ZEF5dTBhc29EOGtGc3QzdlFyeFlVTlVOdlJmWnBpYUx2ZU5oYmZwcDhjSmJs?=
 =?utf-8?B?R3A1RzVmaktzTmlCRi83bDh6b04xUnlVZHVMcXlIMHZrenJpUmJPY0ZBQ0Rm?=
 =?utf-8?B?aWZZbGcwRjRLc1FPZTB6bVZ5NStGVUt2aVRNcFI3NFI2bHhFU1B6cjgyTCs5?=
 =?utf-8?B?NFJJczBzZXdTSHBrb3JCbTUrUUtLRVpCR2h4cjkvRFl4MEx4L0VOV2ZvM25q?=
 =?utf-8?B?RnFsYnJDOUVSdkhldExTZmZ2YStmOEw1OVo3aEY5YjRQMWRNTWY0TWc4N1B6?=
 =?utf-8?B?SzNDSW5BMkJhdjFZbDVaM0FTRkhteUp4VEFFSFdRR2gvNFBsZHI1Q253MWp3?=
 =?utf-8?B?L0tkcGxWU3FucVZJS1VwTEFjY0YxbERyazV3c3A2Mzh3cmJuOUx0TGxoYzJP?=
 =?utf-8?B?ZHNvRVRCVVlEOWxTb2RxNys0bnZURnc2ZTVLOFdhc05KZE94aGZWNmovS1Fh?=
 =?utf-8?B?b2p3UTZWNGFRL3h5QnA5Wko3NTF6VlNXYzlFS1BjS0dpWEczREQ4UE9PaFFW?=
 =?utf-8?B?ZWpoN1FDRFhUdzVwVFNrcDJKeVJBenVKbTQyOGd4S1FvZkhYbUQ2NEwvaDhD?=
 =?utf-8?B?RldCSEpYMjNyYVhvdm9pckRXVWM0WVVQY3ErVnNpcnpHdFA4dnNBYU1EV1Yz?=
 =?utf-8?B?YzV1RGhqamFIS0lNM2xnZS93N013LzIrWmllUkxzUHo2SDEvbklKNjBaczN3?=
 =?utf-8?B?WGVTcTYwb244ZDBhR0lWeXppSHJ4aVRQQ0dBdlNhOXdTSFNkUXRPMDltTTF3?=
 =?utf-8?B?dDA2MkdDUnRlTTVrc3BqN3phQVRhbVZ4YUdBVWhQUlpidUx5TnI5S0IzMEM3?=
 =?utf-8?B?aGxkY0xpMklMckI4MEpqdlhCSUFUOThsQnhGZWNoWDBtSlI4V1pMY3pyakpY?=
 =?utf-8?B?WTZzc2gvZStFMTd3UVhNYU9QdFR1aEQwMGthWXY2VE8yaHUvM1A0bTk5ajJW?=
 =?utf-8?B?NEhZdEdPV0RuWTlRRGJJUE1pRnBrajI1RnFqSVdKT0xaWndTN1BjWXBYMXB1?=
 =?utf-8?B?anp6MjVkU3B5R3V3S0I4TEtpaTFGZlVZTjd0bkZRZCswY2NsNS9jWEt6Z3I3?=
 =?utf-8?B?TGh2a1F5RnRYc1FpNWxtYjVSWmQ3UitqczJ2QVdWaEMxZVZza1dLaUNFWTl2?=
 =?utf-8?B?Mkt3R1V4aUQ0RVRsVklza29VMm1BNFdTamJiQjNiTm5OOUZtTGsxaHRFZGhG?=
 =?utf-8?B?KysrMEhRUEY5RFFMOEZreWpWY1F0cFBsenZtT0F0VFBLSFFhNUhpWUtoTTRq?=
 =?utf-8?B?Vkp3Z21EZEZwS1Vtdm5WZ0ZSaktOL1BnU0FZYmpxajVJNTMrNVNXbGE0MVFJ?=
 =?utf-8?B?N1JXT0NHU0lPTzczSkNCNW1PQ0xldWp6TlVJSUJpcEpDZk9DbWovV1Mya09m?=
 =?utf-8?B?SWVXUXlkd2FUdXhKZkR4SmtocThqWG54dmtFbnl5YmdtbEpNeW44ZEZpbXBo?=
 =?utf-8?B?STNRUWtJWUZZTFdFaGZmQVlDcWJZR013b0JUN1BWdlNILytRclc2b3IxSlQz?=
 =?utf-8?Q?UtX2kFScVNWi9YMnoelRs/wuIx7O1LV3pyJJZke?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af364e25-750b-427b-32d7-08d8cd2b629e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 18:49:09.7606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5QdALTXExmIHSWoFA6/EjGI9fPADPrJWpc1vdTTr+E2pd1BgYh93xhgiGKY/UMfq4cPl0S2rKT0hxx2ze9XOueFZeJL6qPPWcIMJxfX+H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4195
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090089
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/21 11:05 AM, Bodo Stroesser wrote:
> On 09.02.21 13:38, Mike Christie wrote:
>> If a cmd is on the submission workqueue then the TMR code will
>> miss it, and end up returning task not found or success for
>> lun resets. The fabric driver might then tell the initiator that
>> the running cmds have been handled when they are about to run.
>>
>> This adds a cancel when we are processing TMRs.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/target/target_core_tmr.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
>> index 7347285471fa..9b7f159f9341 100644
>> --- a/drivers/target/target_core_tmr.c
>> +++ b/drivers/target/target_core_tmr.c
>> @@ -124,6 +124,8 @@ void core_tmr_abort_task(
>>   	int i;
>>   
>>   	for (i = 0; i < dev->queue_cnt; i++) {
>> +		cancel_work_sync(&dev->queues[i].sq.work);
>> +
>>   		spin_lock_irqsave(&dev->queues[i].lock, flags);
>>   		list_for_each_entry_safe(se_cmd, next, &dev->queues[i].state_list,
>>   					 state_list) {
>> @@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
>>   	 * in the Control Mode Page.
>>   	 */
>>   	for (i = 0; i < dev->queue_cnt; i++) {
>> +		cancel_work_sync(&dev->queues[i].sq.work);
>> +
>>   		spin_lock_irqsave(&dev->queues[i].lock, flags);
>>   		list_for_each_entry_safe(cmd, next, &dev->queues[i].state_list,
>>   					 state_list) {
>>
> 
> Is there a possible race?
> 
> I mean, if cancel_work_sync() is called for a work that was queued but not started,
> can we end up with cmds sleeping in a queue until a further cmd is queued to the same queue?

Oh yeah, you are right cancel is wrong. It should be a flush.

