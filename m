Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEA9C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 20:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEDEE6102A
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 20:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbhDVUKA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 16:10:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50940 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbhDVUJ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 16:09:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MK54JE150084;
        Thu, 22 Apr 2021 20:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HZhOV5+UKgqg05G8ScAOKkY5b2U+ZG+VybaKDNuzrns=;
 b=yL96IP74cXphThgNCCq1u+8ycAHHUVs7lSlCBwRrn1XR0GHNDTBubwBTAPKS23Q/XTqS
 jQmZ4YwFGSbR9KO/mMsdNjDLTxSAWI9wrRts2rYmaVEQb7TO/sZEwDpPyGiZpAZGr4M+
 k97ubeVYB4xEpEs3zlR1dxp3gmMff+FLq3lORNa0s07SA15FkZkusb7SN3emm9UlyEE2
 rrrYN6USy+mpZ4YPF8H7ec1GGX3rd1y/1YiIw5wkF20ZpYLxYdV5xqgQnkOXrE9XCfjI
 dq91JB7pqEe7H7Wk2PH+n/mmnuPPXHFlUFFU+uppfwX74C1W4vwoGq15QAzd4k7eZY5N Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37yqmnpk14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 20:09:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MK6BCe054417;
        Thu, 22 Apr 2021 20:09:16 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2055.outbound.protection.outlook.com [104.47.37.55])
        by userp3030.oracle.com with ESMTP id 383cds2ja0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 20:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjFQzwuOUSuyturceBun2sXZr3aCerlMhQWswphSqOZHyPRK6bgs4S832NYFT8UWoMl+TxQObVSRlJMHf6MXj1VUSj5FF1OfVLxoB2Cnno1FoSmVzzB+j6QLGU/F1yvhRz+JUzQIyKBj/TmNeBEJE6sv/8P0OGYCdGiu8ppq+4n0StJPSkx3eZfQAZ8vMJU0y6nRUW4HwQjYAqtkBT8UwE9Qu13yIg3kcUKbdGGr88QU21hxiCXf0p69ppYvGMhQlnFQufnWfkjLcafEfi4q6OWj9BJXS8gA5jaVc8H83jsfBtgA/9RTMVB4ekGIbRDrulg6tirtBVPTysc6PffssA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZhOV5+UKgqg05G8ScAOKkY5b2U+ZG+VybaKDNuzrns=;
 b=K1OfsHvy0FtuVFxgg9xJOWTX/BtR2XaMIQLZr6p71OxvW3GRWSloeyYZnKcZTpWSl6mztChf2V3DeBOsCVmD3/xRd9Z4Yrvj9BYHdJcBnA1bEIzoX1XqJ6+eACHvT3AdGUlgK8y4De2WK/AmZx1jbENLORkYd9i47hjHtCbyZ3Ou+49YVqHIjb26CVpWWkJyULn/Yc0TulQ+c+J4zkx+3cFlt5NxJ3gcO0XgWUetE6W/Ohhtn2tvuf/44UvlTUEa+MHoh5IrYrfq1SB6LOdiv9XNMfHjo0BXHHcjbzXEGecJ7Dg8CuRwV76KvpE5d4xGDt+I4gjeJ7TjtgFQAMhi4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZhOV5+UKgqg05G8ScAOKkY5b2U+ZG+VybaKDNuzrns=;
 b=a27Eqp3mvIj9A03R4vEHr3xU/tyQOWY6tm5YO3jNEKdQ8Jt4E256hrmcJz6zkUfC0gcXAO24eW5MFevv+z1ygPLXV3q9qPRYljvEmOKB8UiKtjOztGjxWRBGPKxTsX3U8w6UnsgR6H/DjSKLJuezmNo8Sine5yWfhd+oS8jnCFI=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3061.namprd10.prod.outlook.com (2603:10b6:a03:83::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 20:09:14 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 20:09:14 +0000
Subject: Re: [PATCH v3 05/17] scsi: iscsi: wait on cmds before freeing conn
To:     Lee Duncan <lduncan@suse.com>, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-6-michael.christie@oracle.com>
 <cbb23794-ad88-1581-20b8-e0a5898f43d9@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <703d5886-ee03-6303-b935-7f6412b3c5dc@oracle.com>
Date:   Thu, 22 Apr 2021 15:09:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <cbb23794-ad88-1581-20b8-e0a5898f43d9@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0050.namprd02.prod.outlook.com
 (2603:10b6:5:177::27) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR02CA0050.namprd02.prod.outlook.com (2603:10b6:5:177::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 20:09:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dc39675-cd5a-4096-0e60-08d905ca802e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3061484000072BD4C8D97C98F1469@BYAPR10MB3061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: etf8mid9WzFHoaag7ovJSLPMYvunSV4qhIig9DTDJeQEgJJ7HWQFOq/O3xixj739BnWunTObVV69rq38l2r0y5BSSykc12v9HHP3GVuWkKNSi0xFJgAclt4d0OkPP83VZdWwCm5k/dSZMZqbdLbpZzpYCmULmOo8p8uA++E2LMVUnIb7PY2V8FJPIf05xqum3ckT74zIo0wOTZ4WCXlWcYq/AVy+uawkUr6S+Z3/esdxptbPct0cg1o77rvt6NUVRXi0YazlEKVMddY3ZklOV3w8DHft0SrQIn99EKQkBmE9p2DnXtgMf+sBdFy6ozg4VGGTXWSJSZGk7qcv41ulA9ThAim9CWWGVyKCncSqe0Ag4D0zisk29jXQBr817nbWsqSPEzJeduqwthwH7PbqcZQIm4Y5GqWviZjQ8qYqfUgToH61dGday4LS8mPBzgLyoSpeYCzylqnLc8UTI3OWFrfeD6h15TZiN+UGulkzE4hfamRCfeK/I2z+uPJCr+V9UgSBoazoHrATlQc7rGzkjdisXI6ct9dLdwy4jTxUH/9qbN+rkgRe8vCKP9XOxJNgKDT8GZCVZSj4A6XqhmCmrIMcNxOfUrxNKooYDejUo2EcG1c03Dm/g9kf61aAIG4v/KykTAzhBsbKczF+iwNhPuhuq0GqqZH3Zah32rpOZVlruYNQxLm4zXOXhq/+5/spk21H0gTW/fxI8+MapkaRtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(366004)(376002)(53546011)(66946007)(66556008)(66476007)(8936002)(16576012)(8676002)(31686004)(6706004)(36756003)(38100700002)(6486002)(16526019)(26005)(186003)(5660300002)(83380400001)(31696002)(316002)(86362001)(2616005)(956004)(478600001)(2906002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ajd2VzhKM1l6bnZTTDUwNGRVZE1DNCtBNVdjNmxvY00rRkFGa3hJc0hmK3Rj?=
 =?utf-8?B?UWF5NlhhcGdmSEw2enNFZmhQK3c4VXY0eTRFVm5DaWpHM0lKdFgzS3hNMmlG?=
 =?utf-8?B?N2h0NHFzZ1NDaElsaUo2WjhNZmlnNC9ORkI5aGp2OXlhbE1JZmZsYWc1Y1Rs?=
 =?utf-8?B?UE14aTRHckhoOXhyZ1o0L1hYREhSQWF3b1V4TmVIamY2ek8rZi9iSmpGQVNU?=
 =?utf-8?B?bUFoL25KVnU0UEpubGUzZmdWSjJSUlM2aTczODd2RG9yUklYYkFoTDM4SzJn?=
 =?utf-8?B?d3N6MDlSa0ZZUGREM01mbGdoemNCU0NSbWJSS1RHcHRKUkRLeWZ1U3RYUHZR?=
 =?utf-8?B?d1htZFFBR2lhNVQxcDQ1dzBCNjNBSWljVm9JNkUvMnRrdk5raXdBamVadnpp?=
 =?utf-8?B?L3daTFdBNk9QTFhlOW8veDFWZlVwQ2xMa1FoTmErUGhRdTU4ODEzMWJ6YmF2?=
 =?utf-8?B?d1A0bkFTeml2RytrQXBkdUpKMGdEaDJpWWpxbDU3a3Y2UG5qUTBVRFoycEc5?=
 =?utf-8?B?RGg3bDNpYVRuV0FSYllDMis5aTVaS3RzVDBkbFVjNlRmaVQ5UFlmU1ZHeUdz?=
 =?utf-8?B?RXh1S1JKYjgzRFEraUs3M1c3QUE4RXprOU5RWlJTVDlIU2dNRlltcHcxcCtl?=
 =?utf-8?B?ZnhvRWtwYkduMzU0eXppWnQrbDFBMXdpWlplM3RiZVRFQ3Y1TTY3U04yNkZE?=
 =?utf-8?B?WEl2RHg5OXNsdm9BU1lkeFViY2JIRmxOOXRFb2owYlEzaXB6R3JudVJzVUk1?=
 =?utf-8?B?V3dTRUtpazV5WVdvOGhIb0NTVmw5cmROeGJQOGZvdVRuZVFRczdCaWlxRXJL?=
 =?utf-8?B?OWVJTTZsRWdtNjNjNDhQTkVtTDhqK3lEbTlyd3pDOEMrY1RNMlFKcElkakdo?=
 =?utf-8?B?bVRVWENQSXpFNi9oajdYc2lZVmVGRUhpYVpHWWNyU204T1dFZkJkTkpzWm5k?=
 =?utf-8?B?ZDAxQlNFQkN1S1Q4Z1ZFWUd1YkhYcHFFMkJwTzJnU3dpMTFrUmd6dFFycElh?=
 =?utf-8?B?eWwweEhsWlBiWFYvakJpQXhIdGZqTnB1NEljWTA5L2puNWZFeEEvNzJzblVK?=
 =?utf-8?B?elBiYkVOaVpzbjBXdDZFM0llVHk3bG12T2x1bGJaUm10dnBDbzRYSFJlSTVp?=
 =?utf-8?B?ZW83akphUnVIcXVQMnRDNldSRFcyUUZ4Sm05QjdVR2w3RlhRZUh2WGxtUGtV?=
 =?utf-8?B?aFROV2RXcTYvQ2IvQjNySWNyUGpWTncwWm5iYzdVQUhXTkFHaHEvWnFyb21O?=
 =?utf-8?B?MzNrZ0dXeWsxdHN3eFRaWjl1bDd1UERpcHdjVVR0Z3djVUdkM1l2Zk5lUUVD?=
 =?utf-8?B?VWdLU2NHaEkyNXdvK085dnUzZGM2RjRRaXJqKy9BV0NsemxaTkVwWGZESWxF?=
 =?utf-8?B?TGlVR0djYjV3bHJRdFVWZ2dWV2JFNEFDUUxhaXo0N05NdVpwOHM5MDFQTWRs?=
 =?utf-8?B?RTM2Y3hidnpEU20vYnUzcTF0V25HZ1ZjL2VuNU9XajkwKzNVc0RMSCs1ZUsx?=
 =?utf-8?B?KzNtT0oyeVVvZUNzM3owclF5Mjhkbmswdm5aVWozdWtEczhCRE5VQkgveHl3?=
 =?utf-8?B?alNUMlFuUDJEb3NPVFZtM0hzNlpBM3VWdi9GUSs0RzhXcU85WjFiVXl3bDFW?=
 =?utf-8?B?U0pub3YrcjJBdnRXV0d1eTVBTEFWdGQxSWRqbGRsNzJ0eGNXV1FteXc0VmdG?=
 =?utf-8?B?QlZKVzJoMmc2NW1QZGNEQlp1QWtUeXFsVkloSW15aWZhNHA3Y21sNUh4dlNo?=
 =?utf-8?Q?64vR7wr0fpMO6MFUkPhRZajUfDdMwsDesSK8ulU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc39675-cd5a-4096-0e60-08d905ca802e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 20:09:14.4069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5osyNOmzSGPdEUsuNjoiBsojVTa9iIudx59eJYzamfrl41GA75NuXfEsYNHcywoqZF5hp8bUEEknR4F+zU4B81Z+M84AujG7sv1GidPpQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3061
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220149
X-Proofpoint-ORIG-GUID: muZCSOJKbRtZgFBplpIUuXdXM1p_bTRS
X-Proofpoint-GUID: muZCSOJKbRtZgFBplpIUuXdXM1p_bTRS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220149
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 10:02 AM, Lee Duncan wrote:
> On 4/15/21 7:04 PM, Mike Christie wrote:
>> If we haven't done an unbind target call, we can race during conn
>> destruction where iscsi_conn_teardown wakes up the eh/abort thread and its
>> still accessing a task while iscsi_conn_teardown is freeing the conn. This
>> patch has us wait for all threads to drop their refs to outstanding tasks
>> during conn destruction.
>>
>> There is also an issue where we could be accessing the conn directly via
>> fields like conn->ehwait in the eh callbacks. The next patch will fix
>> those.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/libiscsi.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index ce3898fdb10f..ce6d04035c64 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -3120,6 +3120,24 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>>  }
>>  EXPORT_SYMBOL_GPL(iscsi_conn_setup);
>>  
>> +static bool iscsi_session_has_tasks(struct iscsi_session *session)
>> +{
>> +	struct iscsi_task *task;
>> +	int i;
>> +
>> +	spin_lock_bh(&session->back_lock);
>> +	for (i = 0; i < session->cmds_max; i++) {
>> +		task = session->cmds[i];
>> +
>> +		if (task->sc) {
>> +			spin_unlock_bh(&session->back_lock);
>> +			return true;
>> +		}
>> +	}
>> +	spin_unlock_bh(&session->back_lock);
>> +	return false;
>> +}
>> +
>>  /**
>>   * iscsi_conn_teardown - teardown iscsi connection
>>   * @cls_conn: iscsi class connection
>> @@ -3144,7 +3162,17 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>>  		session->state = ISCSI_STATE_TERMINATE;
>>  		wake_up(&conn->ehwait);
>>  	}
>> +
>>  	spin_unlock_bh(&session->frwd_lock);
>> +	mutex_unlock(&session->eh_mutex);
>> +	/*
>> +	 * If the caller didn't do a target unbind we could be exiting a
>> +	 * scsi-ml entry point that had a task ref. Wait on them here.
>> +	 */
>> +	while (iscsi_session_has_tasks(session))
>> +		msleep(50);
> 
> Is there a limit on the amount of time this might spin?

No.

Are you asking because you think there should be one or because you just wanted
to check?

It's really like the patch description says and is a quick wait.

If you want to add a limit, we can return and leak mem and maybe crash because
we've left some objects running and setup. Maybe just get a warning when we remove
the session. Or we can let the crash happen.
