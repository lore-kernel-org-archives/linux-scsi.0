Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313A9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 18:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BB5164E0D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 18:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhBJSqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 13:46:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40816 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbhBJSny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 13:43:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AIPKKo147076;
        Wed, 10 Feb 2021 18:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TXDVSBH4Z13VcAZTUjT04wrtAkuvsHMu8A5UCM+fszw=;
 b=MrZLZj/eYj36dp/qm+rXFRhrdtRv+MWDIOkMeqGdjWyoT3X3bIbKPVReBg5KMtC2ibcH
 it+e94/25TldzFO0FznkSIpALEsFquLSoWMexFPdog10Q3PtNv2eKyATl8YlEWBpxmvg
 8ZsE97+rM0FkiFlDVXzUOKwiXTPuO9QoS3oeVJKqV25OyibHRc37r3tYY42IVEksxXUz
 ndJOfoF/yFkxAGoeFHLarf9BD6dJOxA5os+1v+SXr61z3VF91T3XLntax7vP9MJXOnjy
 2mwMObadYgYfneANWKkB5TRFlEtDyiSxLrpbr1l2h05oC8iDt3nx2hb1tjfYDghqvTdW bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36m4upu4yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 18:43:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AIQ1VZ137862;
        Wed, 10 Feb 2021 18:43:08 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53])
        by aserp3030.oracle.com with ESMTP id 36j4pqh61p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 18:43:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOyuCtHHx+cqLgluQQv9TGZ5++whYgEgClBXN968nGdeoUuKBvwQaL2T70M4JxxCaA3L9orXm7yqS7+rs5EUz++F2ePpJRWQ6nFdYDuillt/zKPLJREqGY76VHEl9+t7pUQ+1sgDjVb1vYOXgOl8c5xpTihGosi60cbH8qLdFNd3a7sUmoCmVyiFWKtcPsUN6lvEOYtLmnIDwgdUJic186DKBhpgMMXBM9b7jDrXCWjLfQpkqy0DUafvjNRF39mm/qa4rbHwbuj/bu7PaFCCR79wZJD++eQGsMHxi6QxRHF1BSSnGkauWGIofaVK2OEUms25sbT3ConmXLGbkk1Ntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXDVSBH4Z13VcAZTUjT04wrtAkuvsHMu8A5UCM+fszw=;
 b=Tvd91XDhj6PyMZgLGBmCFLkPKJfxgAuCswM8USaQh3OfGiazaOf8om6H3FAn6w1RMTfE47EZ9WLDrOusoVIJELicTEEgZVlCYatzsmc1lx2PsVOQE4pgXLKhWNCw6ey8n9nYSUJifMnMYPX0gAacTtNVcB7pvZDGXqe/l/AqEb4Ic0gStC0WrloBeen0/mKrZ8CzibMx7/CyairHyjxksL99mVMm4R2g/2tgMuUI414snVA7czCOwCfz2pxXKOcLRU+R0z9N3AiqqwvI4mWOLV+vmn/mihJ6aN+XCyS12LufW2aaWrFXxgiC22fDcbRp9f/hRhLjZIqaPYO+/5ap5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXDVSBH4Z13VcAZTUjT04wrtAkuvsHMu8A5UCM+fszw=;
 b=qIIhABqWeLPoPmGF2KwJehSTp6kKbRDdEC4FAZh0x2NdiVvhfz4fHCmsUGe5uP2iF+E27maLsVfeQ1MMIBxWgwULuEpgURg96JATR41XzfYWkfkrKf8UqdNkUXaC4icMlcBzFEn8EihoSz4Envzl4esodTCWN92+fIAcQAjb5SQ=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4308.namprd10.prod.outlook.com (2603:10b6:a03:203::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 18:43:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 18:43:07 +0000
Subject: Re: [PATCH 12/13] target, vhost-scsi: don't switch cpus on completion
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-13-michael.christie@oracle.com>
 <20210210084415.GF2045726@infradead.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <98188084-c6ca-4f02-871e-176790b5da14@oracle.com>
Date:   Wed, 10 Feb 2021 12:43:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210210084415.GF2045726@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:610:b1::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR13CA0002.namprd13.prod.outlook.com (2603:10b6:610:b1::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.20 via Frontend Transport; Wed, 10 Feb 2021 18:43:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a47b3b13-3edf-4a0b-9348-08d8cdf3b4e5
X-MS-TrafficTypeDiagnostic: BY5PR10MB4308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4308EFCAF16F426096F2EC24F18D9@BY5PR10MB4308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXaaJqIbhvlApjpYifhval6GQEdLNFORiZe28yhfByC1BsPdzb8aDff4TCCN2NWiO4ZP7/waJdZ/smMe0yMeUZ+POaHoq1fNwOs9cWBz7+Y87E0rfjrDPzx933lS93dmE0S2zfGgpD2tRQ8RSFZP+AmVeuo90HOZu2S53w7yrqlpIYyE71kZxRon+yoYmBQf7NtPp28IZ7m5CKxYUbmBm+0ambBZUSq+ti0zRUKaxM/XPYLUbXuZ74fT/EpQDX0Rg/0cVBQ9Hvd83eA4h2oijudI5w5fSMvdIIVTJN0MPIxhWRrsuUtqMaz0dRu2RZUzfDmsH4OqtXQUVPk+MHqH9u0FVJXsq67csU3Brlk0CYal4uEOyA7McU6004U0nF5kta/T9VmlU1LkoHSjYXq6P00+TTnUZfg5Mx9gjcfAijv0svBn4q07+qqqZfCu3m0pl4A8fvxHM4xvm43jMwYEqnudJrqhYZsltsu95yC7B30A8mwwpFeNuTs1zeKt9cF8FfKtmhoAByVw52VDEqvg3dGOq4Wv1m8E04p3OA2IXJN+tGWX1iaeiSq0ip9dcp4NJYQAa+aioi0Es4iNcIGEO2q08hjiyniwK2G8x14zG7ydvge8nD0xzUT81zoVats6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(346002)(396003)(6916009)(53546011)(316002)(66946007)(66476007)(5660300002)(31686004)(478600001)(66556008)(6706004)(8936002)(16576012)(8676002)(16526019)(26005)(186003)(6486002)(86362001)(2906002)(2616005)(31696002)(956004)(4326008)(36756003)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?LzJ1R3R6UGFBaFUzSVNUWHNnOURjc293RGEwbGdHdjQxUVNsUDFORXhadDNG?=
 =?utf-8?B?UVk2by9DT2xyR24vSS9XSm5YaG1wdG4yd2xEaGk3WTU3Vm1Sa1Bza2duTy9C?=
 =?utf-8?B?OVBmdmw4QWFZWGhaOTloTzI3ZjFSZDROWm11ajR1YUw0STc0V3QvbmlxVzJk?=
 =?utf-8?B?SXQ1T3R0NFl1cGUxVFVzdERqcEpVa3ZqbVh2WG5hWC9wbWlMa2EwOFNIUm5F?=
 =?utf-8?B?d3czd3J4RUlxVFhIK0JCb0ltZ1I2VmU2dE5udTVKSnpkcm0zcHJZbkdZUVVa?=
 =?utf-8?B?MDFXN214Sml4RkhIeVo1VDY2eVhvcGVON09FTWJsVnRBczh1Rk4xMmtDTlAx?=
 =?utf-8?B?ZWE3M21KTFJSSXFaRzUrd2ozclpnSmlQZXkwcmltRlNkQzJTM2hsSFN3bUdB?=
 =?utf-8?B?QktTY2VoQWRKemlvcDVvcU15N2hNVFBtTmZUdGxJVDlobVJsYm92SUc3Tzg1?=
 =?utf-8?B?d1ZoeTdUa0lxdWNZdXpHY1Q4NXFUM2M2MGVDSDBlbUZXUHUvOXZnL1dLNW9t?=
 =?utf-8?B?T0YzUCtIeWF5dEtOZ2c1UkZndCtFbktraG9hSzB1dGQ2TlF0WUk5dGduM2wv?=
 =?utf-8?B?RmhmdHJHU29nZjZYQ05LaW1vNUdtVnNGbWd3VUhISGZOazQydnJWNS9EaERH?=
 =?utf-8?B?UU5jSGxxYXFMKzlYN3FLblVqdlNQdC93UnB5QTR0Z1JpS3ppMjNzSFBJUjQz?=
 =?utf-8?B?Q2gzRGhuWlk5VnlmcW1ZTURFY2Y2RmNOODVQNCtiMmFBb3RXWjVieXVMNmh0?=
 =?utf-8?B?TlBUN0M1M2s2Z3VpOTF4c3hXclRITGc5VjB2OXFhQURpaFAvOEhBMFhFQXps?=
 =?utf-8?B?M2UvTE41RmprTCs4d1UvOXV4NlRsTk10UDZWZSt6V0N4TXhndzdJUy8zdE5m?=
 =?utf-8?B?eTBjQ0FDSXdISGhhblBNcURiWHFoOWg1YzBMTnNkREE4RThuQ0M3UnF5QTlz?=
 =?utf-8?B?SVpmUTNjUnpvOVE2L2tDci9DKzFGaGZuKzl4U1Jpb3prVmUzb29HK1ZIamR1?=
 =?utf-8?B?YXVGNktHTE93cjhnZXhOTHJVY3N1YWp4TCtCY3RFRFJwTTY1Q1p3WTNEcC9m?=
 =?utf-8?B?bXQremsyRU5EVS93aEQ4R2JEdHMrNVVsSlZRSExzMHNDTytyemY5enBxWkZP?=
 =?utf-8?B?MEhBNVBXeGpWS3JQTnlQVGIvRGJVeVljVFRVK2tEK29nYmlTOVZCSVdBa1pi?=
 =?utf-8?B?dkQvTVQxZzRFQzRvZVRYdHpackl1S056QUw2bEhycEcxM09LcGFvVzBhZWVC?=
 =?utf-8?B?VzQ4bVlqWWNVeXVDRmJBb3lvendrSGwvTFhDTVVuempsOG1RR0pvZCs0eUQ4?=
 =?utf-8?B?bkUyL1MwZTNPL212ZFR3Q3A1UzZ1MVNwU3AzZlp3emZjT2RxRzVQSjZsTnBy?=
 =?utf-8?B?eHIxRGJaeUxUUlVIVlNWNGNkakVnZDM5MGtGbExJQU5kZ2VrSXFHcVBrbnUr?=
 =?utf-8?B?YU81azF6aVg2bGt4RXY4Vk90bGduQk9uM3dmNkRVYUc5RUVRNWdIWHpMVnlR?=
 =?utf-8?B?YVpYa2YzL1JhV0dDRkRMUlcrSWw1aHJyd2dXcytVYUJrRmxtQ1Q2YkhZanlV?=
 =?utf-8?B?MWRicW5Nc2gxbmtHMlB4T0dIQVBaMlRzclBIMEh0d1BqZDhvT1BtaDBzZzEy?=
 =?utf-8?B?VTh6SHpnMUNGMml2bGhlcURJOXdWU240NTNhanpFQ05Bc1huTVN6ZVBBWlVQ?=
 =?utf-8?B?Z3JnTWQ0L216Q3paSnlBZFZxL3lIZ3R2R1BlUFROZ1hjalk4WENKWmlLNGor?=
 =?utf-8?Q?74bwuXS5sJERhOklCKlu4plzsCRHzdQXJyBKaOc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47b3b13-3edf-4a0b-9348-08d8cdf3b4e5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 18:43:07.0535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUGSK9n+E5GGg1jyLjCE3bLr6f5b2bLnwpiOlFFPage1erfac0YvKNy50g1osVLcfrqFIMMpCsb/iPqyub6gtKN7+604kzdjDQ+cTWYkw8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4308
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100167
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100167
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/10/21 2:44 AM, Christoph Hellwig wrote:
>>  	struct se_device *se_dev = se_cmd->se_dev;
>> -	int cpu = se_cmd->cpuid;
>> +	int cpu;
>> +
>> +	if (se_cmd->se_cmd_flags & SCF_IGNORE_CPUID_COMPL)
>> +		cpu = smp_processor_id();
>> +	else
>> +		cpu = se_cmd->cpuid;
>>  
>>  	target_queue_cmd_work(&se_dev->queues[cpu].cq, se_cmd, cpu,
>>  			      target_completion_wq);
> 
> Can't we just use se_cmd->cpuid == WORK_CPU_UNBOUND as the no affinity
> indicator, which would remove all branches here.

We can't right now because the workqueue_struct does
not have the WQ_UNBOUND bit set. __queue_work will then do:

        /* pwq which will be used unless @work is executing elsewhere */
        if (wq->flags & WQ_UNBOUND) {
                if (req_cpu == WORK_CPU_UNBOUND)
                        cpu = wq_select_unbound_cpu(raw_smp_processor_id());
                pwq = unbound_pwq_by_node(wq, cpu_to_node(cpu));
        } else {
                if (req_cpu == WORK_CPU_UNBOUND)
                        cpu = raw_smp_processor_id();
                pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
        }

so even if you pass in WORK_CPU_UNBOUND, it will do raw_smp_processor_id
and add the work to the cpu's worker pool.

I think if I add in a new tunable to make the workqueue bound or unbound like I
mentioned in the other thread then I think it will do what you want for both
review comments.
