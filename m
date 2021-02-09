Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533F9C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 00:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D57D64E42
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 00:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhBJAPj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 19:15:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33472 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbhBIXcG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 18:32:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119J9G2O053698;
        Tue, 9 Feb 2021 19:10:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MwN8ZnWuyE2D6z4qimIJpEbxFh7DBXShRPc5qzzBtvE=;
 b=zlTVJ0SX43uhzWrLgc657EdRVBLpBBXNt8ugwIlBUf5Zxep/EZjgc7v/Qvp26L4jeBQC
 B85Td28aMqbmaAifNiZPvUpXiemxjnwl6C68gcqKhNNSsau7/WjTOFAUewSpyHtMceX7
 xBinubKpgM87hiEAdR++XBFlEGn5ax4qNp4koP5IAV6DMQf5pt7qcktMBukpKgyGFgI2
 REOKo2qFDdXLp3J8+LERjhxtlDJBYSpCoePkHtemhKQVS58toZTDhaSHyfmwnxleYmHe
 8cp6FUEC0d6yIFtNDFxEoJRZf0BbBpLmpRCEfYOO+HWfGZncIjmiwd5NbHpRCObCYRyt PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36hk2kgq8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 19:10:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119J5R7E054908;
        Tue, 9 Feb 2021 19:10:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 36j511mx3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 19:10:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+2wNQC3ctsoyyQGXo8EdxtinrgCbL3dBCVvcHJ9uponolzTOPahdYunpHddiD3nzTuqE7xVKegphzTTIKeMmxJ+PzwaQXYrrMo81mear/pll3viZLA3EgjXd5y7meAjT8tahrviqm2Vg9yAieBUzcx+8jdo/tSGoDBkFBPjvLfNHXx50ycpApfg+mWQcJsc8z/ZalJLDB+aLXMz63mUCKx/qudWHK5ffoDn+DWvEBOp0n0hNOotBBzZhdtX+L/fjQmW7SgtxXZk3ldn+TQDfjae+VpMydbIO07AAOQLMvZ7YLTOxoSLtOnT4w5LCFhsPI5EfD6g4xke4O4K1v5hJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwN8ZnWuyE2D6z4qimIJpEbxFh7DBXShRPc5qzzBtvE=;
 b=Nivffd1XcG77xql53Cb69fvfMEZeSuKB6OSTmLIpQGpW9auEJV+NIOylKIJCvA/5ZltdXBjvhNWVgz88U8ob+zPRkWnSciOFxIHtdh00Z2Ys5dcB1ZmlowBhnvwmQMGzK8AJCHm3ZHhWYV0LDSCZlTDXHedByDFfJHVM3FLJC8JoYkvaAK4kV6e1fZq53jJ2BfX8/FkgCkEmkoZRUIo4GRMw/uEBLjg7urp21pnLTCLR4y9e9OV8a99QPkjn15ohAnBcQ94SbZHStwTjutJ5Epckaplf3Nl0nW/QyeBxhXMMiRjRgfatwB9QkbThSgfMFc12vqc61vKNNk1slIC/iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwN8ZnWuyE2D6z4qimIJpEbxFh7DBXShRPc5qzzBtvE=;
 b=tIcTvDxle7Wtnc/g107OkcDeT35b7yf2S6uwMhK5QzpueFhRm+tlvyJMyNXQ2mX7LpBjyLyAYnf7z01FXJj6H9SF5ku4NCBka+//oGou718GCy+jgwKYr2wVzVtFr4FLyCW51Qlq7+cgf6bKkcnlgMRqEv6BqGOXMAScMdq3qmw=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3318.namprd10.prod.outlook.com (2603:10b6:a03:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 9 Feb
 2021 19:10:27 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 19:10:27 +0000
Subject: Re: [PATCH 03/13] target: add workqueue based cmd submission
From:   Mike Christie <michael.christie@oracle.com>
To:     Bodo Stroesser <bostroesser@gmail.com>, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-4-michael.christie@oracle.com>
 <206a3f41-dea8-2152-4811-817138ffb580@gmail.com>
 <f33bd053-3a78-fc9c-0ec5-2b5e97dadcfc@oracle.com>
Message-ID: <1e9d1f94-9e14-f487-e723-c4c7fc0be0ed@oracle.com>
Date:   Tue, 9 Feb 2021 13:10:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <f33bd053-3a78-fc9c-0ec5-2b5e97dadcfc@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:610:e7::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR03CA0234.namprd03.prod.outlook.com (2603:10b6:610:e7::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 19:10:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8294e2ca-4773-465e-de57-08d8cd2e5bea
X-MS-TrafficTypeDiagnostic: BYAPR10MB3318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33184E6AE8632FCA6E2AFEF0F18E9@BYAPR10MB3318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZFTqfk4SxUcHE7l6HflFac5M/qQ+Bpn6zQxQmR2HsbPIK32FLRFrM53GnhqWTzwM2ZuGPrQZpiIigVQAo4eT1/MYExhvvjYq5nfiDdRfOni2OHvyy/uwfCfd9cFeEWrGwTFqjgrQT4otZ2Sw/pxicjm8ZiypnSYEetPejNbNOO4dW4jha8A9uJlcVOx7PnOzI8jy3dUUTil51ssOyxnMDnbFz66xGkpo0c7DU9OWMawR5Vg6zknAcQeW0T4P853IbsEPzGTC5Vzb/DDxP01fq041KO1LM5TDInKwM/7fJooUfjUJuwpUN9fKzeDxvNhfz8VM4bM3S+xMBNXm8dbFGJOu3Wt9eDsLH4aXGwZuxziOC3pVT7mOZPn+EiB6qg0tv04vBCXVzvOlD0tszzYeKSXR8UYOyY8lpDrxv7fOHLoCOMivEoPuiMMbmNtBgw/56swsmx19GVi/2mpnRaQqsr+Z+kpas/OYeYfbPAAt/9dhX2ATMaFyWTcNPuX3rTvy3ZmSCU1LTRYPzjHe3/sXd42oAkBflGqqpoyuSS/ecsDEGMXRxqS66eFvf57Mtcc5Ajsqj8NXVZItmXt7H4CkxpIieRpwetiNkAbjircVjRJc7f94L3MeJC11gqniCRfV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(2906002)(5660300002)(26005)(83380400001)(66946007)(86362001)(66556008)(31686004)(66476007)(8936002)(36756003)(31696002)(2616005)(6486002)(8676002)(186003)(6706004)(53546011)(478600001)(16526019)(956004)(16576012)(316002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?emRYeUdrRFl5dktZWWtGUjZTQnQrLzArNU1PYjFXRHN4SVpMbkZPejl5RmVR?=
 =?utf-8?B?N1ZVbUduck5JVGlrQTJpbnRmTWFiYkhOSzQ4MWtyWllIOSs2NjRYR3pMRFVQ?=
 =?utf-8?B?Mkx3cVdBd0tXQm9YdXQ4RU01RWM2anlNQlBrQUxZaTJkbFp3NlU1UzVHQjl4?=
 =?utf-8?B?T294WEFEZUJNRk1EZUdkNUxaeE5VclJNQkp1WnJycjl5MnZvK0lVeFY0THV3?=
 =?utf-8?B?dU80V0NBaktwVThDSFRoVmE1djYwMGRwRmtxY0QzNm5WdHF4S1dJTnYzbktQ?=
 =?utf-8?B?WXRINEhraS90Y0Z1ODBIUGNpK2FlMzNONEZSY3k4ODdWM1BXNFBCdVgybXI2?=
 =?utf-8?B?RnRSZ3hVVFYxbkRXRW5taVlMVTBsNStZSjU1QUpDRUQ5S0p6WEdWTEl3R295?=
 =?utf-8?B?TTNMZk1WYnhhamtNMDZGbnFXMW1sTFcrenl1bXNQME1YOTlJNUtsZk1oWlRV?=
 =?utf-8?B?OWdJYm41VS9DV2JVLzZNeDV4V1hWaThTTlBZWW1VQ1NjQ1ZmU1ZpOU9DL29k?=
 =?utf-8?B?SkdrR0tFQ3kyTmM3TytTWkdyUUltL2w1bkEyQ2t0T2Q4U0lsQVF5VVBJNmps?=
 =?utf-8?B?VHNicm5oajdoTVljVXl1aHJvR1NoYmdJUHhNcEwzVWtDRlRUeENrRVNJN1JV?=
 =?utf-8?B?d2ovMUdtZStrWXNEOCt0WFluZ3dpdEQ5bFhNQ0JxTW1BTndTelhGbGlmWWo0?=
 =?utf-8?B?MTgxWlpCM3ZpaVRua2F1YWhHWWVUdHFza09rNnBOWXBnVjdYVTlteTdVa3Bj?=
 =?utf-8?B?STErcVpkYkpuTkM2MUdQQVdrUlhIaFJwRUo3aE50VFFucVJuckxDS2JNYXZq?=
 =?utf-8?B?dWZkZzFEMUkwSC93SEY5RE5tbXEyWTVEeFkwbXA4REFMMURnd0NpOGhGSER3?=
 =?utf-8?B?Y2ZhSndlZ0NNalY0VTFNZHB0cXQxWDJuTThYN1ZOOXRHbXlJYmQwRENXckRX?=
 =?utf-8?B?cW9tY1BlWTBhY2VkNG1XenAwbkFxZGhuSGxhYkpXOWJPdE1hTXBTUW0zMklw?=
 =?utf-8?B?bVdmbkJnLzl4a3Nqa1h5ZWFwMldNMTJ0VE5OVlVTK04wN2pLa2RhNEgzRFhO?=
 =?utf-8?B?UGNqRnhyN3FPNUNneGpYQzAzSW1pelFLblZ0TWFEUnJjOW5qSUVZSFVuN0lF?=
 =?utf-8?B?dTZpeTRqdHIzMjIyK0diTGFPbnZROUIvTTE0eGpORE1HYTRZbVdqRW9MamlE?=
 =?utf-8?B?dXV6bVl4VmF2MEdxbXNJdjgwY29MOEFnRW92U3RGNXpIQUM5WWFuRGFYbmRq?=
 =?utf-8?B?WVIxT05tSkc1clRlN1RWMGc2UG02aE9KWGh0NnFvTFRMZG5qdjhHWnAzbyts?=
 =?utf-8?B?YXlNRjVyK2k3NUNyRmpsemFtbDRWb0R3N3ozV1N1SlJxUThFVWdhWTd2aFVJ?=
 =?utf-8?B?V21SYjNJeGVsVStyMmlCOU5CcVc0VW5DQndHUGdLcWczVGE2Ri81eVMrNDBk?=
 =?utf-8?B?cHc0ZXhGYnp5OE9sUU9HRVZBVkJjUnB3eDhncUh1VzdYbWorS2ZQVmVBamlh?=
 =?utf-8?B?NE1hVFl2S0lFemJZcXpnaXRVOGFjVTBEdzc3Q2RVeVhtMVRkVFZrcWJ5Nksw?=
 =?utf-8?B?WHkwdDV5QWQ2UU1rSzFsMzZ1ZTI1VWNPQmRSbjE5aWxRRXd6eDBERDF4ZUpi?=
 =?utf-8?B?Q1BLU2FleEpDRjlSNGM2NGJ1TkF1ZmdZSWlqTDFTaTlYKzlLVmg2dFdEYVZ6?=
 =?utf-8?B?SjFHSXpUQnFSMHdNYWh4NGwyMUdEVWZVR0dzc0F2ZHR4bVBQSnJEdmdnYXJN?=
 =?utf-8?Q?kiOb077FzS+LBNduBDNQyqjDsLgHlpcrO06/uPp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8294e2ca-4773-465e-de57-08d8cd2e5bea
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 19:10:26.8902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGcRqjMsOE/yXxTLzfktSYhETJD4sm2l3krEvqTMuQdNjiRqhh2Cs/EbkWJ05QQwyGdCdvHpNa0UFGY9tbY9YjTnjuZyDIDvT88l7eJNPwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090090
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/21 12:43 PM, Mike Christie wrote:
> On 2/9/21 9:48 AM, Bodo Stroesser wrote:
>> On 09.02.21 13:38, Mike Christie wrote:
>>>   +void target_queued_submit_work(struct work_struct *work)
>>> +{
>>> +    struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
>>> +    struct se_cmd *se_cmd, *next_cmd;
>>> +    struct llist_node *cmd_list;
>>> +    unsigned char *cdb;
>>> +
>>> +    cmd_list = llist_del_all(&sq->cmd_list);
>>> +    if (!cmd_list)
>>> +        /* Previous call took what we were queued to submit */
>>> +        return;
>>> +
>>> +    cmd_list = llist_reverse_order(cmd_list);
>>> +    llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
>>> +        cdb = se_cmd->se_tfo->get_cdb(se_cmd);
>>
>> If I got it right, get_cdb is a new, optional callback.
>> So, should we check, whether it is set?
> 
> I think a check is not really useful. The caller has to implement it
> if they call target_queue_cmd_submit. It would be a BUG() and so
> either way you would get a crash when you are developing a patch.

I'll actually add the BUG. It looks like it's preferred in the lio code.
