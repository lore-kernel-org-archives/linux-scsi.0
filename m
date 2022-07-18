Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0200CCA479
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 21:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiGRVWr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 17:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiGRVWq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 17:22:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381BA2873C;
        Mon, 18 Jul 2022 14:22:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IKqK0N032487;
        Mon, 18 Jul 2022 21:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7xy7dXkwqp3oiqFyoaW7HZh1HiR/GW3uNgcsL3+KkYI=;
 b=I76/8JO0liCW7uUxsmC355fnNCnBR8GwXUFQVVJqbpaYSsIKdPHORLT6INFsswwleMp0
 PLgfCiMn1k61UydgQcsrUaFOtTh3fXk69uMsPkhXCnNGbBOMzo2qeLqz9PO7b5aZVmJb
 1vnzMnRTR8UzEc1ykfG/o2tbKiF51c7cwD6jTBm/FCJ0icQ+Pxk33XveP+sR1R5PLa1r
 /uSnJq6xZvrmEiPysnnRXpioPDEGMlQJGJX+VPVpPSZvKhJtQJERL2ZuopKjy1k26QkU
 l9VeCqewueEuzh/qFAiBOCJYGy5GuXWTkVbNR3kxKkz7hST/GW7kjikwZDBJr5wnJNMU uw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx0vmfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 21:22:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IK6nNQ006501;
        Mon, 18 Jul 2022 21:22:43 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1gfwd8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 21:22:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/Pij+xAIAlAZtxLNKUIWcrAuLL91T03qmFrPiXqUJnL7XWzwlxKPF9RYFK9SeZpaudDrYSmh2I5qZxkqJ1Arw0vxRxjRO8x0zl8ZrF2tQuoDEzK9zVwhYPdW1igz7erXz0hYgZ6LoT39vAMr5tnonjwuMqYLGIslmPytWZTdaBJXEMMuzVhE/0GUkM/v14ghfBqiDU3xlkruIFVRW5zYVl94VpZOvrXHmxwN8MrwDcDZUUc+VH+ySB06uueko6r+VZjRPYsI1y9Q8H9Jjg6Q7q6XcDa4ftK8u83hPVxg02kPRw55MUMmERW6u8kd8BH+7zlOc/7HZvD5oHFK8EQDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xy7dXkwqp3oiqFyoaW7HZh1HiR/GW3uNgcsL3+KkYI=;
 b=ETLCrBYZuoceEa0axfKqEYcB9xgktbWOyR80+YXDJn4+qqxEynUyGQrMIU1SnXQ33Oc1lao3V+lzWCZyP/yTHFZ72M9IyE/mOIBKDB63OTRlb3dZgkiRbcghdzKM1WEDQ2LJ/6U/G1vFtnETRmhKySjWOvdoMm+LkDuLqzp9uU6cg17aUdSZmcYjauHsCsHRpuYhKzQILZp63zS9FF+7E60H6VBdPmoEeHRdFuoddeA/RW1c5RTfSDoPw0WitoLkfSQ5Xvjc/GiCIjfgmJR7WT3EMsR/rqrMfndyb/ZhTaE9pi6KVzbFNzBOPP18ymt+Sg+UsTCMyTawLqAphrbQ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xy7dXkwqp3oiqFyoaW7HZh1HiR/GW3uNgcsL3+KkYI=;
 b=siZQWT4exd9UFOlwL3v457vDUWZAv2oS7GvxEj5E3J2e01ecaZ7/RErwKmHcC3MKk2RWXWyZZc9tJ6kigQnn0K09UOq4sWrG18q1NMj3rqZUNtW219P04XQpEI5dgX4LLE2pVCHDnOwDJNDwrZIdrBEB5TKbRlZpSC5VqPWdpKg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2085.namprd10.prod.outlook.com (2603:10b6:910:3f::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Mon, 18 Jul
 2022 21:22:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 21:22:38 +0000
Message-ID: <9e1c0853-a5f9-cba0-2f51-05ac773f1fa3@oracle.com>
Date:   Mon, 18 Jul 2022 16:22:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] target: iscsi: handle abort for WRITE_PENDING cmds
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org,
        Nick Couchman <nick.e.couchman@gmail.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220713204212.7850-1-d.bogdanov@yadro.com>
 <0fc89e77-197b-47e6-f661-5f7f18f6634f@oracle.com>
 <20220718084534.GA12544@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220718084534.GA12544@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:610:4f::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50e7754f-0371-4d6b-d69f-08da6903a3cd
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbub+1rUtFkVt5nfIP2sDu0nx71Jpie3o6N75YvMBjbAnla8vcUvz58MAMU5gSXxxMJEufCDGWBMcq/WO9OTqPeEKSKthwsUcYQHqC05FjodeCgE3QWtFqjkpgR1DOlNY7Ahd26P7eblc5JT0FitzP7Nvr2xpHsBZORJ3KFdOv/yn281z7nbuNa1i1eJiZW84tj7/qmUTs/HHc/313c4bfmAjL+vkgLPQu9L8JLj+F/jxuB761+7/lXnsdY+Inj7/koWy5JDZdS+e9VCcPtuZl3mjek2TwEOC2vhtf6zsWyBdK1Fk8lXgKoQqwrwVycznc8e8OYNzzFGDvMig3wEtKaCArW6e450I3Waw/qLppJFRr1ji1PevtQByhBp10bOhtDjI8fnSejV0DybCGM0s1MwwEvOtHY5APkU4KFg3X2B8OTwEWbbzZRuRzryjZSD/Rxzu0QeWbVaICs7WgPBhCvMZB9giGdK9p0crUjz6XUNdYTm0exB5UcXUIzLMuRSQoJHEZWbgj8ZKbYEYdWcO9QetbuZmlH2YYd5kr7t0R8gKBeMTNNjS9RajAn3TJhqop2T1HtC+wycIdpnFU4+DaMPTMzGEZX2LBeVzMQmXVlc0Go7UfqywVIKwk8SWSv3hjs4eaZdmMh0+Zbc49hW9+5yi+qyMWHIhYMfDFWVfeLnSk8VEBr+/2QHo2rQPeWiJykKDtAKwSdK6oM5YInFbPkE7z/c+P8bgunM7y1YG/lCX1CN4g7pT/YFpcUIJ3/PTctHblj16O4jr8HmGe9ahnJa2EWxp/YV+FewbKjhJm0VpNHyqWFt5Lr0FnrfZCPQmtJyWRFueg2YLqVz4ruY5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(366004)(39860400002)(376002)(36756003)(316002)(6916009)(31686004)(83380400001)(38100700002)(186003)(478600001)(4326008)(5660300002)(2616005)(66476007)(41300700001)(2906002)(66946007)(66556008)(8676002)(26005)(53546011)(86362001)(6506007)(31696002)(6512007)(54906003)(8936002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmQvck5QYXc4ZUUvbmIzWWFvYytRVTNGYmwyOU9GelBoWjdGSjd4QXR6bHJR?=
 =?utf-8?B?bEd3S2Y4TWsvZHhPZTBvUTkvNHdCUWFFaGNzV2lHc0hoTGEzZWoxZUNTdVBw?=
 =?utf-8?B?L0VaVTd1Q2d0NU1WemxnUTRvbjNjZUJPRGlWTVZidkFWSEthSDY3emx1WXZq?=
 =?utf-8?B?S0N1aTRqcEJmM0FxayswTWZlOENYcXNCSFphYTZVWE5QTHRXc2RWaDhMd1kw?=
 =?utf-8?B?cStGc05sV01mTEF4U09rR1N1ZEo1NTR0Rm9JbDhIOUZpV0V5KzJLNmRmcjJZ?=
 =?utf-8?B?ZlN2RHV0T3lGRXl1Tldmc3FtOEMrcDVYdnZQSGxyRnpXTDlWRnVMR2NKNHBy?=
 =?utf-8?B?UWFGRHoreFRLNkhvOWJVYzREMTZUSitpTXZLSlM0cmIxNDZjM2dVNmtZalNa?=
 =?utf-8?B?SmZnVGsxMlZSSVZQbnN0NHRtRlZxZGhIQ3lacktXSkZWUzVxLys5U1Btb0VU?=
 =?utf-8?B?NFJTRE1aQXdWNWdnWXc5MkZ1R0dOcEdwNzhicjFFYVRpMU8rbStuRkNOZGRt?=
 =?utf-8?B?YzZoM0dsa1lTSW9MT3IvcVY1eWdibnhYQ2hPQk9QMFBNUTVEY1FzMmhFVVpO?=
 =?utf-8?B?cldhWEtUaWw0U2haZWlYR1JSWDBUTndDZ25HU3MvTmo3MUVhTFRSWGdxZ01p?=
 =?utf-8?B?cVB2VWNyS0wwYlExOExhS1hXR0ExaHh5MTF0ME9nQURhN1RtUU0rNllWM0d6?=
 =?utf-8?B?S2F2U21BbmhYaU9aTURWWWZvWFNMb21POG05MjNQZjhTcldmZkw0MG5KYncx?=
 =?utf-8?B?cURKeDRJQ1JTY1BBa2VHWjFwSGRrOVJaWGNQUzR3Z0tLNHNLWHp6OExJbXZO?=
 =?utf-8?B?elA1TXpwc3VyV2pNcUNGTUp5R2E5K1l0bzRaTzZJMHZ2cGdOSFVUNzNsV0dI?=
 =?utf-8?B?UG5PYzc5eGhDRzkwTWNOYk11bXRtMUJ3U1JpUUJJQkpjeXNZM3FQbGtKWWIr?=
 =?utf-8?B?dmovbFNzc2pROEFkK2pBazRHQyt0UE5RL0VmcTc0WFkvWG1xS2ppVXJDK3lK?=
 =?utf-8?B?RmE2MXJXZHFYSWQraUJRU1BIaGNKbFBtWTh2ZFdWMGdpSDRVU2NJdEpmL04v?=
 =?utf-8?B?T2pidjJ0dGZnVHR2ek5uY3hlQXd5eGN4eTNYMFFudTFFSXV4TkdJRWR6c09H?=
 =?utf-8?B?YVJUZ0tBVjlmSEZnVzJYSDlhUk1WR0l6aDUwMjBML2t1SXRmWjgrcEVOKzgz?=
 =?utf-8?B?SWptNHNLVWxMTVRxbXdNeUFVaFYyM1dKVWV4dEw5b2xkQ2g4YklFWGV6MGsz?=
 =?utf-8?B?M1MzcnpWZmNsK1hVclBiSUJoSStqUCtRbGNoWE9wSTZqV1Zwam1TSTZCT3gw?=
 =?utf-8?B?WXppL2g4WnhBYnBDeEpXOFRlU0kxU3JNL3F1ekkzaUFsZXQyN3dJbmVabm56?=
 =?utf-8?B?ZG5XRjdSVlBPSkJwVUcrS3lRUUsrZFZvTWFQejBnU0J3b0ZkOGkvVVBIQUhL?=
 =?utf-8?B?UGN1eFFEWnduNmI4RjZPVnJSSjZLc2ppVDlSYVBFajFZSlRFM2sxRmR3bTE2?=
 =?utf-8?B?cGFwT24zMnJlWm9vWlh2bWZBMFBxMjkvT1dBeW5WUUdOWks3eDg3K01XR29L?=
 =?utf-8?B?WnVPSjJPQUFXYkc3Wkhsc2FUM1BvTDhYNHdQa3BYelNLdzdQMXUrbHFOQjVQ?=
 =?utf-8?B?SjVnck1jTDBYQ29ScWFnWHJyaW8rc2p6Q2xxaHB2STF1WWdpWnh6MmJsTEpT?=
 =?utf-8?B?Ym51VlpnMlNJNzVTWjJkcTdaNGFOcWswUEE2QXRsc3dJSjB4N2Zhc2pHQS9t?=
 =?utf-8?B?RFNhZ3RaWStpeWVKNkcwSktteFdERUJ3ZVNqUmFPQzIxNUQzcnBXNkZQSlRR?=
 =?utf-8?B?N2JXT2lIZ3hsMVZseFlJYlppNjk0SGhZc2pWZmVSSUxGM1BaSXlwdmNvTVd0?=
 =?utf-8?B?U2NmWDJRTmJWQ3JiNGVNNUJZazViUWVSQTBldlVncmJ0MTZLZm1XbC92ZE5k?=
 =?utf-8?B?UjVzTWpoMnpQRWsra05GMGtYYzJlUG84c3lCRFN0V2VSZCtJL0VLeVJrRFV2?=
 =?utf-8?B?UTh0UkJ3SnZJd3Bvb3RCRUt2bWVCK0h3VnE1UEVObHZESEl4QndVRlc2VkN6?=
 =?utf-8?B?VmdERldxbTZEUE5wcytRNDdjQTJCQmppMEZ1NVY4aHRBRndLNlNidmFOU0J2?=
 =?utf-8?B?ZFBPNmFlVjlXdW5JY3ZucFVoNHliTkE1ZEE5QU50TjJ3ejRKamQvcGpCcUxm?=
 =?utf-8?B?cWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e7754f-0371-4d6b-d69f-08da6903a3cd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 21:22:38.2215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HMh8MLsSEEEf8TVieP+4KVIxA6D55VX7Iecs/CbEwkhVuFIB2a5/Pea+mqRdKs4mRm2cPledkeQ3ztfHXPSarRUGekwWa6mpx6mVYOjvQmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2085
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180089
X-Proofpoint-GUID: YkIT0T9mR6iKwfqBPpDPGR8fJ8cnkrpb
X-Proofpoint-ORIG-GUID: YkIT0T9mR6iKwfqBPpDPGR8fJ8cnkrpb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 3:45 AM, Dmitry Bogdanov wrote:
> Hi Mike,
> 
> On Thu, Jul 14, 2022 at 11:44:25AM -0500, Mike Christie wrote:
>>
>> On 7/13/22 3:42 PM, Dmitry Bogdanov wrote:
>>> Sometimes an initiator does not send data for WRITE commands and tries
>>> to abort it. The abort hangs waiting for frontend driver completion.
>>> iSCSI driver waits for for data and that timeout eventually initiates
>>> connection reinstatment. The connection closing releases the commands in
>>> the connection, but those aborted commands still did not handle the
>>> abort and did not decrease a command ref counter. Because of that the
>>> connection reinstatement hangs indefinitely and prevents re-login for
>>> that initiator.
>>>
>>> This patch adds a handling in TCM of the abort for the WRITE_PENDING
>>> commands at connection closing moment to make it possible to release
>>> them.
>>>
>>> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>> ---
>>>  drivers/target/iscsi/iscsi_target.c | 13 ++++++++++---
>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>>> index e368f038ff5c..27eca5e72f52 100644
>>> --- a/drivers/target/iscsi/iscsi_target.c
>>> +++ b/drivers/target/iscsi/iscsi_target.c
>>> @@ -26,6 +26,7 @@
>>>  #include <target/target_core_base.h>
>>>  #include <target/target_core_fabric.h>
>>>
>>> +#include <target/target_core_backend.h>
>>>  #include <target/iscsi/iscsi_target_core.h>
>>>  #include "iscsi_target_parameters.h"
>>>  #include "iscsi_target_seq_pdu_list.h"
>>> @@ -4171,7 +4172,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>>>
>>>               if (se_cmd->se_tfo != NULL) {
>>>                       spin_lock_irq(&se_cmd->t_state_lock);
>>> -                     if (se_cmd->transport_state & CMD_T_ABORTED) {
>>> +                     if (se_cmd->t_state != TRANSPORT_WRITE_PENDING &&
>>> +                         se_cmd->transport_state & CMD_T_ABORTED) {
>>>                               /*
>>>                                * LIO's abort path owns the cleanup for this,
>>>                                * so put it back on the list and let
>>> @@ -4191,8 +4193,13 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>>>               list_del_init(&cmd->i_conn_node);
>>>
>>>               iscsit_increment_maxcmdsn(cmd, sess);
>>> -             iscsit_free_cmd(cmd, true);
>>> -
>>> +             if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING &&
>>> +                 cmd->se_cmd.transport_state & CMD_T_ABORTED) {
>>> +                     /* handle an abort in TCM */
>>> +                     target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
>>>
>>
>> Will we have an extra ref left on the se_cmd if TAS is used so the se_cmd
>> does not get freed?
>>
>> For TAS, it looks like we would do:
>>
>> - target_handle_abort -> queue_status. This would not do anything because
>> before calling iscsit_release_commands_from_conn we have killed the iscsi tx
>> thread.
>>
>> - target_handle_abort -> transport_cmd_check_stop_to_fabric -> check_stop_free ->
>> target_put_sess_cmd.
>>
>> iscsi creates the se_cmd with TARGET_SCF_ACK_KREF set so do we have one ref
>> left?
> Yes, you are right. TAS case is not covered by my patch. But that is
> actually another bug (that iSCSI does not complete responses in case of
> connection closed).

What do you mean this is a bug already? I mean is there a leak or spec violation?

Spec wise we don't need to send a response to the initiator when the connection
is closed for a single connection session and ERL=0. We just can't because the
connection is down. And the initiator knows it will not be getting a response
because the connection is gone and cleans up on it's side.

If TRANSPORT_WRITE_PENDING is not set then we will drive the cleanup of commands
internally and not leak memory right? Is there a bug in this path where we also leak
memory? If that path is ok, can't we handle the TRANSPORT_WRITE_PENDING is set case
in a similar way?

This was the patch I had proposed when we discussed this last time. It's completely
untested, but just to show what I mean. I think it should probably check the t_state
like how you did it instead of adding a transport_state bit. The idea is that the
command is never going to get completed and we can't send a response because the
connection is down. The iscsi layer knows all this and that it hasn't sent the cmd
to LIO core for backend processing, so it forces the cleanup.


diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2c54c5d8412d..d0e80a2b653b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4088,7 +4088,8 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
-			if (se_cmd->transport_state & CMD_T_ABORTED) {
+			if (se_cmd->transport_state & CMD_T_ABORTED &&
+			    se_cmd->transport_state & CMD_T_SUBMITTED) {
 				/*
 				 * LIO's abort path owns the cleanup for this,
 				 * so put it back on the list and let
@@ -4096,7 +4097,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 				 */
 				list_move_tail(&cmd->i_conn_node,
 					       &conn->conn_cmd_list);
-			} else {
+			} else if (!(se_cmd->transport_state & CMD_T_ABORTED)) {
 				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			}
 			spin_unlock_irq(&se_cmd->t_state_lock);
@@ -4108,8 +4109,12 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 		list_del_init(&cmd->i_conn_node);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
-		iscsit_free_cmd(cmd, true);
 
+		if (se_cmd->transport_state & CMD_T_ABORTED &&
+		    !(se_cmd->transport_state & CMD_T_SUBMITTED))
+			iscsit_free_cmd(cmd, false, true);
+		else
+			iscsit_free_cmd(cmd, true, false);
 	}
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 6dd5810e2af1..931586595044 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -742,7 +742,7 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
 		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
 }
 
-void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
+void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown, bool force_cleanup)
 {
 	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
 	int rc;
@@ -751,10 +751,14 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 
 	__iscsit_free_cmd(cmd, shutdown);
 	if (se_cmd) {
-		rc = transport_generic_free_cmd(se_cmd, shutdown);
+		rc = transport_generic_free_cmd(se_cmd,
+					force_cleanup ? false : shutdown);
 		if (!rc && shutdown && se_cmd->se_sess) {
 			__iscsit_free_cmd(cmd, shutdown);
 			target_put_sess_cmd(se_cmd);
+		} else if (se_cmd->sess && force_cleanup) {
+			__iscsit_free_cmd(cmd, true);
+			target_put_sess_cmd(se_cmd);
 		}
 	} else {
 		iscsit_release_cmd(cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 14c6f2bb1b01..eb233ea8db65 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1554,7 +1554,7 @@ int transport_handle_cdb_direct(
 	 * this to be called for initial descriptor submission.
 	 */
 	cmd->t_state = TRANSPORT_NEW_CMD;
-	cmd->transport_state |= CMD_T_ACTIVE;
+	cmd->transport_state |= (CMD_T_ACTIVE | CMD_T_SUBMITTED);
 
 	/*
 	 * transport_generic_new_cmd() is already handling QUEUE_FULL,
@@ -2221,7 +2221,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 		return;
 
 	spin_lock_irq(&cmd->t_state_lock);
-	cmd->t_state = TRANSPORT_PROCESSING;
+	cmd->t_state = (TRANSPORT_PROCESSING | CMD_T_SUBMITTED);
 	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fb11c7693b25..b759ec810fa9 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -511,6 +511,7 @@ struct se_cmd {
 #define CMD_T_COMPLETE		(1 << 2)
 #define CMD_T_SENT		(1 << 4)
 #define CMD_T_STOP		(1 << 5)
+#define CMD_T_SUBMITTED		(1 << 6)
 #define CMD_T_TAS		(1 << 10)
 #define CMD_T_FABRIC_STOP	(1 << 11)
 	spinlock_t		t_state_lock;



