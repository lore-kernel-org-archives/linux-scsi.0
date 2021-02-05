Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D987C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 17:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C185F64DD4
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 17:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhBEP7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 10:59:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhBEP4j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 10:56:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115HYYdk008798;
        Fri, 5 Feb 2021 17:38:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ql6lQ5WKE2bEs1poRItUKCW2/ctc9wZNURJ0EfandIY=;
 b=rxHP74nyvZG1VZ/MR2l7P4FLIoPiU36kU80XIvOapiGg/HwraB/G467b+WXwmo8ERgIu
 Z9WM195zr3qSvSmm/BAawgob/BYDkfLHE76qXtZUs5zFuXnT7iSELtJcDvJy89jvr8yK
 7mNhBodjuM6fKjbmN/W3M5JTZBm4wBWQzubICmQpOqKSWqgwrnATCyfD+Z4arHsIivzK
 IqmdAvAci9B5m/bDqiGfA/M+gl9C/vY2NEWcBJPL3fc4W6mwqxQcmxalG0aZ+ieMZgY1
 +ntfRGpG8ToKws4ROYJxhjOBxRxtUll0kK8SfPkXf+IxrB6ewnCuGJNicUh9f/HAfVan SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36cvybar1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 17:38:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115HZgq4024531;
        Fri, 5 Feb 2021 17:38:12 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2059.outbound.protection.outlook.com [104.47.46.59])
        by aserp3030.oracle.com with ESMTP id 36dh1u8b38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 17:38:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjV86ixqDntfgV38adgYbLwrWYtWwdm0FYMcUJq/RCmMxIu4cNqNXzhgbUZi7gJCt+yRDsMmGqW5fZtVt2KfWcONIKpqYIsZm1YSL1jSpaZF2csyFN1SQ7qmVubY5HCwZkDXGfSIu0xYuvjuRUT/DrVpPlae1nCe++K1VPbbZrKRgwTylrNzQ8ZFay29paS0Cj/wyBqrQJ6dMicJS5wtE8c810zv2X+JZ6DWYA47ATV44JFurIxlgLrVqXEHRgKvRHaWTU+8fSjOPLRnwSWnfp5+WMyhpjsfrCeIXn/fz4tdrfPWADalwI4my+VmoflQbv7Y4U0aIM3qFfiCDMlsOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ql6lQ5WKE2bEs1poRItUKCW2/ctc9wZNURJ0EfandIY=;
 b=f3dSFlIxwPU6+NUFOqayoI2EYaD4eiMXyXXzraMD5qlaautJUS+4iEXHHBu/vceTh83xFVuDPY0WmB10HWl12Lq8fRRJlLMlDxafkbAzwLHrg9YUrz46XU7GyuAGo08fe83L14izJZdlanhrBzJ7pBErI+SzEC2TDQG7iIqh7ezgC1gykBmeO7kPyWJfy+gkK0mL0YQ7R/MVDA84jQ1VspX045eTxqNDc9Ec3vyqSpGPq3iox7OYst4Nhb3n+xH471WFDfChYFohDfpl3lDqHm98BfVcnVzSbkKgKh8c2TFvhL5Bh7uDVuMgScghMAzNWb/wrfIR0ATD4sBZHvusLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ql6lQ5WKE2bEs1poRItUKCW2/ctc9wZNURJ0EfandIY=;
 b=vVdEHXCti/YSgo3+FyPP9ER83ky5gPmhsf/vaC7a6hRjscG6UhenHE4HOFETQUIGFTWO6xILzKO0PWn/T6XXanMJaj6ua4npoQmBnc3TLy6uQFMhNwUZGhDa/dvpSvlxGbWKHx0768ZqRr1OKdgZFVGLSteqBG6lo7bU089bNgQ=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3795.namprd10.prod.outlook.com (2603:10b6:a03:1f8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 5 Feb
 2021 17:38:09 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Fri, 5 Feb 2021
 17:38:09 +0000
Subject: Re: [PATCH 05/11] vhost scsi: use lio wq cmd submission helper
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-6-michael.christie@oracle.com>
 <20210205111638-mutt-send-email-mst@kernel.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <26fe5be1-842d-d85b-c00a-69694bebf709@oracle.com>
Date:   Fri, 5 Feb 2021 11:38:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210205111638-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:610:b1::28) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR13CA0023.namprd13.prod.outlook.com (2603:10b6:610:b1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.18 via Frontend Transport; Fri, 5 Feb 2021 17:38:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d91af2a-c7a8-44f1-b2f6-08d8c9fccd94
X-MS-TrafficTypeDiagnostic: BY5PR10MB3795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB37958FED2A5FEBA370066A2FF1B29@BY5PR10MB3795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FltHqIwQ3tJ+NDPYv8d4KpZ3OOo4UyFqI9dXUNoteRm2ODgEr6Wdr0JvdRXHGtz7W+3va9rX8EPWgglGWy5YaLWJK0RKfo+TkLWghTGNujVY3tIIe6xh+xpf3iTj1AwVvrW6DHrL1x1M7T6chzlt6TTaDQnx+H9yTZ9G656E5L5IVSRsQN7WRXQ6+Wd0SNpS98ShSWAS9ulRycCSADbt+Iw9PBPY1i7AUCI2fovkvRBrieAbhcV+9oU2QFFVyJsr6gOuH0uLT1b2BRKcj7UXXwZBy8P6lrMSX4nBB2NFfHR7rnsTBj1H8/dM7U913gHYfitCOosk9K3YBIdfVOnwXlJUWlOazYBFmvCmPy/5A45LRhYhVESgkYrhaovBlUB99zKrtkAfLVL0jQuIbqV6CedhXl131c4oEB1+aYDDtpRpB2y9VRWQtw3EOEEsQ315jnDhl47DzzVnDLqLXl0cHd5W2scWhYN3KyUr/jbI64TMvYJWx0IW8OPv56Exvq3nmcIAZMpvtQvhMVThEQ/mr4mWIpRzqP3XpzIB88bMjlCKqwgTPWUoeb4ltkLICX58a+UKkFixdPHrDBMMdDXu2kPUeNPBw7KU0OEvPzofTBxzJlKzRlt7UxiRXxyQWrlo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(376002)(346002)(66476007)(5660300002)(31696002)(316002)(66556008)(66946007)(4326008)(2616005)(86362001)(956004)(6706004)(186003)(53546011)(6486002)(16576012)(36756003)(26005)(6916009)(2906002)(31686004)(83380400001)(16526019)(478600001)(8676002)(8936002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bmhGNjZKcWkzekRkS0thaW5qWmh5d09VYXJkTTN1dTlNZzhVTUtmeWJkUGRz?=
 =?utf-8?B?VmxLY3R0bnZwSXJsdTAxeE9lTHVXa3YyaTdsVnV2eldmSHFvdngrOUtxQnV3?=
 =?utf-8?B?MDV4d2JQc29lY3BzWWlJT2d6YU9RcUN2eDJPbDVQREZQVmhkWnh4bHF2NWtB?=
 =?utf-8?B?MWE1N0pzcmJ0NXY1dFR6T2NOQTFEaEdYV0pKUEI2endGZUo3S3djZGpBWmRN?=
 =?utf-8?B?dEQvczhxeEV5Z0hMWFlxRDUzNEZvN1RWTjZBNHhzZnk5QmhqbEpSMitJNjlI?=
 =?utf-8?B?UGN2LzJTRU5wQzNtZ1JrNThhWmFnWlUrWVBRVEx4M1FRbEZEZ2cycFcwR0Jx?=
 =?utf-8?B?akVQVlZ2dG92QnlTOTN0NzM0bXJoK2tRL005QXBMVElxejluUDRDSG84Z0ti?=
 =?utf-8?B?ODl3dG12OUFBcitGaWJSb0ZWcWc5cHRwTmZHbTRXSFhTQmEwOW53OHlyUDVU?=
 =?utf-8?B?eElpL242SzYzbDhZSzF2NWZnOTkrVHFHOUg0N3dzdS9USTcyd3d6ZVBGYzgv?=
 =?utf-8?B?MS8ydExEaHRuVHdBT1lmTjBDY0VtY3NUMkk5QmlBTTVBcGJ2S3l0cm9nSytl?=
 =?utf-8?B?OEtTa2Z3a3RFZU5GaXk0cnlpcjd4UnpmRGFmc2ZRc3R3TVUza2lNL25QNGVJ?=
 =?utf-8?B?b3hEQ084UytOV2orTE45ckdlMUsrZ2dkbVlaMWhOTU1nYlZHN0l3TW1UMm10?=
 =?utf-8?B?L3B0NE5GYW96K0xZRnJadjh0NlZSaGoydkE1amttbFdrZTcwUUlLOStwUkJV?=
 =?utf-8?B?TUJSVHhQZURBU0U3cWtFZzZRYWg4QmhCTXRqN2ljZ280YXBxQXJ4UFg0Wmpp?=
 =?utf-8?B?RytnRGtEbzF5b01qcis0RHBhcHJkdHpvcmxTSUIybGJUQVJuR01mUVdLVUFC?=
 =?utf-8?B?YXZzWlVqSGZLRGJhdGlxZFpFai9wbUM5SUdQV3lSQnVwU3M2VnZ4Q0FGZ0JP?=
 =?utf-8?B?QUNKOHEzbFJVMzRZSWVHVitwWUhkbVZXdm5rSHZSTXh3OVVjcksvNFZJYW5G?=
 =?utf-8?B?RVFiYyt3eURqd1diNzN1QkptYnEzOUdEN0x2RzNnTnZZRVFlUS9ZUFA5RVcw?=
 =?utf-8?B?U0xNWDVtVEM4MVhwK29ZRXA0RkhXVjg4ZVBJNlptS3JYQitQWDRzQWhRdjJi?=
 =?utf-8?B?SkZhOWxxYTE1czJ1TlVneUlRNXhGdjNzTDIxTUJialFUQnlhSE54NXJwOFBp?=
 =?utf-8?B?MnRaNU5ocWhzU3h5dFRoaDNqYU1UTUpuSXYvNW1ZWHRoQ1U3aUV4VDZDcUs1?=
 =?utf-8?B?ODd0VFFESmE0ZWRYUVRNVGt5Rk5PaXVITGJzZ0ExdHNvU0k3ZnZGUVlyQjVS?=
 =?utf-8?B?TS90dEJxSlR2eE5XNXZZV2Via1NQN3F5T1JYMU1GcGdSZTh3dzhoVzk3Tyta?=
 =?utf-8?B?WDMySmkrQlNxUnVOUktTQnl6Q1JCUWcvYmxLMGNjMDZnaW13bmxBTmF0cDQr?=
 =?utf-8?B?TjZmNUVrWXh0UFVwWVM0bHZMV0pFTTdTQmtJM3pSTlgydkJCK1NvaVQwRndQ?=
 =?utf-8?B?bzdwK0owSk5oT0U1Y1o5M3JjMDlidVNxQnZaUEZYSERwVlZsL3ZINEhnL201?=
 =?utf-8?B?d3JzM3FIMkxPWnZZdXArcWFYcDdDaGVvTXVXTE9NQjVIZ21PaUw5KzR0ZWRk?=
 =?utf-8?B?dHI0YXJMMDZnK2EyeG5SWVJwZEJ5WEhKcUFjU0gyUXV5QmptaUVzOFdFQllM?=
 =?utf-8?B?NC9GMjh5a0hoMytCaGViVXFOSE9MQ3VhUHhSTGhSeXhRdHVHdHUxeFQ0K0U0?=
 =?utf-8?Q?gcykgOCiTif1XS1B7lVqUIzKn3nHsq3tHq3TOaJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d91af2a-c7a8-44f1-b2f6-08d8c9fccd94
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 17:38:09.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jp76lOhdrAXQZwzYS96uOyZTE5kf/xRR/h18o2RWg9U6V90uENjjSjJJ0esrEtqZzCo/sOBJEtWw9M8T+CVaGBcmfjUzgyJSDXaSlIJjr/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/5/21 10:17 AM, Michael S. Tsirkin wrote:
> On Thu, Feb 04, 2021 at 05:35:07AM -0600, Mike Christie wrote:
>> @@ -1132,14 +1127,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>>  		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
>>  		 */
>>  		cmd->tvc_vq_desc = vc.head;
>> -		/*
>> -		 * Dispatch cmd descriptor for cmwq execution in process
>> -		 * context provided by vhost_scsi_workqueue.  This also ensures
>> -		 * cmd is executed on the same kworker CPU as this vhost
>> -		 * thread to gain positive L2 cache locality effects.
>> -		 */
>> -		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
>> -		queue_work(vhost_scsi_workqueue, &cmd->work);
>> +		target_queue_cmd_submit(tpg->tpg_nexus->tvn_se_sess,
>> +					&cmd->tvc_se_cmd);
>>  		ret = 0;
>>  err:
>>  		/*
> 
> What about this aspect? Will things still stay on the same CPU
Yes, if that is what it's configured to do.

On the submission path there is no change in behavior. target_queue_cmd_submit
does queue_work_on so it executes the cmd on the same CPU in LIO. Once
LIO passes it to the block layer then that layer does whatever is setup.

On the completion path the low level works the same. The low level
driver goes by its ISRs/softirq/completion-thread settings, the block layer
then goes by the queue settings like rq_affinity.

The change in behavior is that in LIO we will do what was configured
in the layer below us instead of always trying to complete on the same
CPU it was submitted on.
