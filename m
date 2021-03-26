Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DB2C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 16:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571FD619CB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 16:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCZQYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 12:24:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhCZQYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 12:24:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12QGJAal162803;
        Fri, 26 Mar 2021 16:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=05Y0guXbsCCGJcEGHgwvoNwfxGqKhcKbDQ35FEFGSRw=;
 b=WmpC28P4Aum9iH0S1W/YHa4ASNQxJaiTXsAqJVHwvZxUe2UJ+tRHl06rF5bibsROxCAs
 NG8sLuE5XOfF/wcIyCeNVs7CW1hbaS8Me/5B8snLhC3Q+cPoQ3yYOrxGtqZhiEvXCPyf
 ELOlevEoAiJ6VcrvsK7DDV9XaNLGtQ9/YHvmCda0QYwozulYCL4RE481nOiLIUrz5ry2
 eq5YriUyfOwHHbV7G614PF4lnsGbRoAK49qcvYlXD4MRu8MFzT1LfPl3ds/d9Coi4UxI
 NZv2SCd+rTZlgpyGbYgYt2IVX40aMF4V8eXzhuIvN53z/w9xm38I/1Cu41zacS8dJdmy Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37h13rtnbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 16:24:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12QGFCS0046495;
        Fri, 26 Mar 2021 16:24:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3030.oracle.com with ESMTP id 37h13xvg52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 16:24:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1k8kkeULi8WaozUBw285xHKO6JG57i+5eTWBLeJVhyktKCKJ6uDkBj2YC1trZus2hBnNGC6rK2ev95EZNs0MhYmA0ffM74CkGFniqpydKwh3jRUd40N0nz3IgvRKCqYIz8qNw5khgjC2t4MdlUgfzjzlenxZs93TPkoYK7RKatDX9enx8Hc1udVLPNWsMLsq1MOCHVEQQK00EgSOdiH5iFGIt/190mG06mqXS0AoMiWa0yWNCuWYBX9f3zsLhXylj4NWHaKH2CL8GyD4ccA9G0MeNlJ4op+hECr3AD+Xf9JzjtSNtSGvMZ66OaSHj+i3ujqm/MXMMdxAJl/SPQcwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05Y0guXbsCCGJcEGHgwvoNwfxGqKhcKbDQ35FEFGSRw=;
 b=Jx/4LrRyt/cQrEQV+Jqektm1wDCQo7CYrYAX0dQ4LRNP9xlEUxVQ1OhfeWP3kzwPf+Z/kmvH+OCBWog1qkeeUDl8F8EeLOc1HE6Ly1z2dR3ZUWEtXVGiyJPPOh915cqpKes9YeGhlNF9ix29nbX76b0Scn907ZIiRfR0OFfSNIimrwylxKdIN55GcL/ZgXJqu38YTZa3vEQN8TJ5KwR5GgkXaqLkEZY5oHoxJ18jB7Kv+4wqKFki7E4sipZl8CjWRfrg2hLIgmDakBbCUoCPcnfLHp/JNvultYAKF+asui/9jYicUP1eUQkCNmOCU3qAdEIzyCuCRX7nVuR8xRsBPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05Y0guXbsCCGJcEGHgwvoNwfxGqKhcKbDQ35FEFGSRw=;
 b=hnHaUVOs84ueITBm1uiWE+3ZstObeXpa5iv2Pn5k7kbxOftut0Ew9w2/Xs0t+FRN/rsZhoFT1dnEwortsoEEm3SeZ3K5G+yESl+0JAWNslFt4o36f1MhuwroSZ9RTTBa7PpOJcQvrjY9jL9YCVAgVl37AaUXlxJyv1w1fVBFvAU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3574.namprd10.prod.outlook.com (2603:10b6:a03:119::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 16:24:19 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 16:24:19 +0000
Subject: Re: [PATCH] target: Fix a double put in transport_free_session
To:     Maurizio Lombardi <mlombard@redhat.com>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
 <f03c8a67-d015-d503-726b-647b4f327b25@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <0553e265-2795-86fa-5f8b-634d8060ec84@oracle.com>
Date:   Fri, 26 Mar 2021 11:24:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <f03c8a67-d015-d503-726b-647b4f327b25@redhat.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:3:101::12) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR22CA0002.namprd22.prod.outlook.com (2603:10b6:3:101::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 16:24:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 488792b7-7445-4d5e-e21b-08d8f0739b5d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3574E9E41C44C63309AE75B9F1619@BYAPR10MB3574.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cQSiBXqcB4af0r0bie2gZZ4NmBQA90baCn7UTFY8mltNm9oRxSM7DeN9VGvrXPxmEW2im7E1F21nbKE0Z21cnP8YLnJHDlywp/HOZK9YgErNeTOroDJMtiaxdgF4fY8d/vh8ShuAiOboQMykS/k12saD45D5NEX9SY3M3hooBp51enLeBRw6l3DuQzNEPEMxU3EarL4x109t8Wz9HfvTiVrb/QN5NXGS5CHx68R+B86cjORCyWHAX/rVj/uR0J+JjsCV0ve1EZ5gPVHiyXRVem8j2izU8E/9HafxzYKyEcbuTS/LOti1vPE3+h37nd0pbrJ0QWS17RUUl0oaXu0K7957h4wu1e/DMJbDUwHvxrat89I4gACqopMqpbwHKRb0U+I34oHOCgwgjdkcYuL6pBAQmIFwK4MUeWMK0/d8q+t8eGl/0Dnm2esQn5aatLVVNA6dw16mLMfjLlT8V4icWpPRAs1nAs2subLhrTYu+t6PU0DigfUE7hKwjKTJGNfEgOXe7sKCH8wPTyjBAtuEZSXkvG9N62z9jEPWPfd19msqPQb9DG4yRg9D6gvfxmy0BLepHyBGKBAmhXI4x5fbNdeRq8j2eAjpBaubfcPeLnWhDZF/UI92c+83N1gMbSd1OMpfaB0Q+n+TyEWCAr6tMOsfBK16tF0ZXMypHwJGRkj2/beYugDq4eKYQKaN2cxG/WNaWFSAtoaIoeo0AJxAtWp16kNYGmcOXrsKFgUuCAlC67MEMpZN/UGNLIJDFek
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(31696002)(66556008)(66476007)(31686004)(66946007)(6486002)(38100700001)(2906002)(4326008)(6706004)(53546011)(186003)(2616005)(6636002)(956004)(8936002)(86362001)(26005)(83380400001)(5660300002)(110136005)(8676002)(16526019)(36756003)(316002)(478600001)(16576012)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-2?Q?pcSB9oclSHM3KBXGPZ6T0L1PBtrhJg2KDTR/9cL9kL1ZdfnwSHudDVA99t?=
 =?iso-8859-2?Q?U70wOsY0LEmN+yW9ZGoKUVB3lWh8TdzWY2rIthmK56pypIkjj53uhpJEpz?=
 =?iso-8859-2?Q?A/6jcyGxbawsJoJB9mMYtmOJTeXNcON458t9bMHxhYLxJR+Oo1WbhSkPXD?=
 =?iso-8859-2?Q?TLiJlVMg4oazh2pe5btbFd7m7wGZSUykv5/cAuRoGyWxklhvmbCl3B+sFh?=
 =?iso-8859-2?Q?TH0aWy/FjE23SX8dlVV3XQFPOcjj9vs4k9Qf5S/4Irrf8odo+NXQXKOODu?=
 =?iso-8859-2?Q?rHYNT9s4lDqdhmNnyxqdo9xyDUlYsiiDo6B8vJLweAJxfUUuVXfj4HYei+?=
 =?iso-8859-2?Q?BcKPzK+FH8kHUIhnyYXDB4xlYLNHEhyNwych8n52s00MrRUCKq/3EK3JT4?=
 =?iso-8859-2?Q?OWnwZzleDec6bvBSjWNwKtOqL8MR/YCmfvRf6Ec1KjHboMhPREdHt5t2NX?=
 =?iso-8859-2?Q?rCILxjt2XpKbp8134Hv89IyNwRfMqfO52ExEnMvpCXv03PYi0KbgVFOfNM?=
 =?iso-8859-2?Q?O4Y9GsinheQJ0QdeO3Df7MefWS6FA/vMJgr8D0WCoy339Xq8ujuRcqYItY?=
 =?iso-8859-2?Q?c+4HMi9dBCJu5zz7orhY1of9n+/i3SUmE9ZlkXJqrSzsLRB4/6NW5lCxK7?=
 =?iso-8859-2?Q?4sbYso/7nfCBwRBoQR81fsv/08r0Kjy5xyhT/WK7R4N40EpgzEzqUKDqbr?=
 =?iso-8859-2?Q?6rVaCJWcANUIHG+Tee2LZFY5oYpkw+jA0spNUBmvk7HJpkIp49Z3PLixBE?=
 =?iso-8859-2?Q?wkuoxuoR9qIcO2Kojn1EZlMEKJcElZR4RIcxIxkxee6eqmryZAMGN3joeP?=
 =?iso-8859-2?Q?m+fHNqbF7qkB4/2qB2r0FzoT342wyO0cni4jOMKP5E9C/ljYAmMlyTmmA2?=
 =?iso-8859-2?Q?M69fFhppREAuc9B2QEWA50NZvDI9qFrpbU31StEoKJX4zudoZyuc0zUOtg?=
 =?iso-8859-2?Q?Zd60JaPMKFH+81oXCkbuzXIe84zVahNT3Iqvz6Wi4DLuKKdnY+77zYYhri?=
 =?iso-8859-2?Q?O47X1fiCzB+LKu9WkxXeyrP8IED0krUXE259o9NnNoP5m2EBzv6kWabJHI?=
 =?iso-8859-2?Q?+5d0VdWv/3peIHqN6PZktjXtitNLIS4oSC7+obnI0+D+Uqf40ROBnOMUKb?=
 =?iso-8859-2?Q?zK9/GV3PpOkCVS20q0XSObUmydjUTQqweXRvvSx2inLQzKeC6aCqx+HgCp?=
 =?iso-8859-2?Q?n4x7pESh4W+xKFReHLi/g2LlT/9992Elx4dOu6lgjYglmTLKKiVODUVqnu?=
 =?iso-8859-2?Q?lFWoSIa7pWFr4pHFfBWTdDMn2n/fQaLqYxz4OAQcUpHxaJBuYcNjVPsDPc?=
 =?iso-8859-2?Q?/kXf5wshwp3PH4YGs/2RWCFoRUF4YIH7EDNzatDkHAf81gucuayNUa1gE0?=
 =?iso-8859-2?Q?iN1tSSZ/xN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 488792b7-7445-4d5e-e21b-08d8f0739b5d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 16:24:19.5279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fT80WwtGmMOsFoQ9LlCcrTv80KpcoSIaPQlzxCx+/BwW0HIn4sn2gStecVUn/o/4Skcrdw3mpShp/e1UfUbPU5HIvYfujWLcGwOYnpNmRqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3574
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9935 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260122
X-Proofpoint-ORIG-GUID: a_mLnJurz8iRRUbyoFR2C-fSsCn8DVBg
X-Proofpoint-GUID: a_mLnJurz8iRRUbyoFR2C-fSsCn8DVBg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9935 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/26/21 7:31 AM, Maurizio Lombardi wrote:
> 
> 
> Dne 23. 03. 21 v 3:58 Lv Yunlong napsal(a):
>> In transport_free_session, se_nacl is got from se_sess
>> with the initial reference. If se_nacl->acl_sess_list is
>> empty, se_nacl->dynamic_stop is set to true. Then the first
>> target_put_nacl(se_nacl) will drop the initial reference
>> and free se_nacl. Later there is a second target_put_nacl()
>> to put se_nacl. It may cause error in race.
>>
>> My patch sets se_nacl->dynamic_stop to false to avoid the
>> double put.
>>
>> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
>> ---
>>  drivers/target/target_core_transport.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 5ecb9f18a53d..c266defe694f 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -584,8 +584,10 @@ void transport_free_session(struct se_session *se_sess)
>>  		}
>>  		mutex_unlock(&se_tpg->acl_node_mutex);
>>  
>> -		if (se_nacl->dynamic_stop)
>> +		if (se_nacl->dynamic_stop) {
>>  			target_put_nacl(se_nacl);
>> +			se_nacl->dynamic_stop = false;
>> +		}
>>  
>>  		target_put_nacl(se_nacl);
>>  	}
>>
> 
> FYI,
> 
> I have received a bug report against the 5.8 kernel about task hangs that seems to involve the nacl "dynamic_stop" code
> 
> Mar  4 16:49:44 gzboot kernel: [186322.177819] INFO: task targetcli:2359053 blocked for more than 120 seconds.
> Mar  4 16:49:44 gzboot kernel: [186322.178862]       Tainted: P           O      5.8.0-44-generic #50-Ubuntu
> Mar  4 16:49:44 gzboot kernel: [186322.179746] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar  4 16:49:44 gzboot kernel: [186322.180583] targetcli       D    0 2359053 2359052 0x00000000
> Mar  4 16:49:44 gzboot kernel: [186322.180586] Call Trace:
> Mar  4 16:49:44 gzboot kernel: [186322.180592]  __schedule+0x212/0x5d0
> Mar  4 16:49:44 gzboot kernel: [186322.180595]  ? usleep_range+0x90/0x90
> Mar  4 16:49:44 gzboot kernel: [186322.180596]  schedule+0x55/0xc0
> Mar  4 16:49:44 gzboot kernel: [186322.180597]  schedule_timeout+0x10f/0x160
> Mar  4 16:49:44 gzboot kernel: [186322.180601]  ? evict+0x14c/0x1b0
> Mar  4 16:49:44 gzboot kernel: [186322.180602]  __wait_for_common+0xa8/0x150
> Mar  4 16:49:44 gzboot kernel: [186322.180603]  wait_for_completion+0x24/0x30
> Mar  4 16:49:44 gzboot kernel: [186322.180637]  core_tpg_del_initiator_node_acl+0x8e/0x120 [target_core_mod]

We would need more details. We can hit that normally when the target driver
waits for stuck IO to complete before calling transport_deregister_session.
I think if you hit the put bug, then we would have seen the refcount warning
in refcount.h fire before the hung task because we do an extra put.

Did the user switch to ACLs? Did you see my comment about it looks like there
is a bug if the user were to add an acl while dynamic was used for the same
initiatorname. In that case, we do not do the put to match the one taken
core_tpg_check_initiator_node_acl. In that case we would hit your hang since
no one ever does the last put.


