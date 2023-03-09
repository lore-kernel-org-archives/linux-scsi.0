Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B98C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCITB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjCITBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:01:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A21FB27F
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:01:15 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329HnOLQ018259;
        Thu, 9 Mar 2023 19:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BQfsYxXtfIolDH9558aH4yPaQJ7cLyZ+Z2O/65+YDlI=;
 b=SA7QT+dMBLk9CFgZEOpNy/cT8BZO2jL3w+NBoYKD9ajtSkRGbujh/jv5qPtlWnYHGz2M
 pFMaBtL6CET0YEKVWj7M8aZdw3bFRONTyAhJwFqB/5r/ORk1l4e87huNBGP3na8qZMwj
 6Qrb/bmCsCTZFXo/JSzwTWymeqz+eTmW3D0CBjO1nitA1sM1LMlyvIYpkV3QnBFE52RX
 IxprH14PyDkLqJJTMaN1w03MOavgccSguxi+jsNmR9iUxUjW34FFulelqXO6h1+JGmYW
 yZ00eG0g40TCROsG8PUiNAoGGB0EiyOnSH0Ur7FFLc1uwt6VaPdJ8shU3wQTmPYv0W1b GQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418y3kd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 19:00:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Hj98N021530;
        Thu, 9 Mar 2023 19:00:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu9w5h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 19:00:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYHaFIv6uk5bGkNc69DAD5L1jY//abAk3tgcIOZR/ka0paLqJZ/sx4St5o87DhjW6BVEpsdTKptWxyBk4KopYho2BiEJU0RF8kaEz+zSg7dL7CWDHXNEP571WCiBLCmQcvhd2OaqF8yg16uTAtsKue1zfDQxomszjX7PC5pgl0PpBnrCL0I1s8z32hSn7tNeKYC0/SIaG3c5yORVn+y2AZvWH+SFNQTbobD2CKQg4o/oTXUvTOdPBsmCCNkwTBYYJDz1ipuVjUp5j6WS7zmtek3OZMyWKg6A4OhZQf/9Zbr7YmCb3oQUcj+Z1zpufHnRq4084/tqwKHYg6tT2PrG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQfsYxXtfIolDH9558aH4yPaQJ7cLyZ+Z2O/65+YDlI=;
 b=Mt4yNWkDvrI5vkUQjeu+q8ixQSaoN+zJPHhPX+p2DHwaObvl4gTQMKdKzanJdyGKLkWblFfHapf1H/umJ3QTudGz5/3C95HTYQONB4m80+oEF63jG4cA6CsZFwF/PsPgap+sjYj6yPyA3GagLDSFPq/lhAO/hGgWCXfOo+jMoc1knSBPTrHpDLWJNPa9g80Eq6HohBRCZbpUu0r13BruboI9V4gGnES9wz7JTNqRnYtU+7MTsdIYoMUIPN/lUg1dzdyKtFK7T61zvfpwSuKQZIiWhJ/hPUC785Hk65XGOuwxY8tgJLWxfHK65DXfS1JgaZYVO3MsDFoIylqaLjX06A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQfsYxXtfIolDH9558aH4yPaQJ7cLyZ+Z2O/65+YDlI=;
 b=btBHWTIuUM46wDhL7g77AZAkyfRSQ2WM1ShnWQEQ4K7OZEiyW8/wgFsSOE31HUiJwqFPsg8E3+Pgzyxybhw4uGbg3URBewkw7ULlj3cyJghvrhLWLMT3U5WavllhZFeMalki0/+aZL5KKahSGiywQ7dS4oeBGksIs4jsWfwsR6k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB5920.namprd10.prod.outlook.com (2603:10b6:8:af::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Thu, 9 Mar 2023 19:00:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%4]) with mapi id 15.20.6178.017; Thu, 9 Mar 2023
 19:00:03 +0000
Message-ID: <65a75b0e-fc55-e036-c259-de58a363cea9@oracle.com>
Date:   Thu, 9 Mar 2023 18:59:59 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 01/81] scsi: qla2xxx: Refer directly to the
 qla2xxx_driver_template
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-2-bvanassche@acm.org>
 <fb29154c-fdac-8b45-1e8a-4b4e732e4dd7@oracle.com>
 <db248a4c-14bb-3e8f-7d25-c7e56ac7efcf@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <db248a4c-14bb-3e8f-7d25-c7e56ac7efcf@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c6fc8ba-a67d-4346-d5c0-08db20d07d62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mgWf185iyltXqarUq7ApM37dOCcbX5/7WLtOkqJJScIVRhGUsXwTh4AwYGnVvMqTIUAWvpAYmIBt2WK1DxSNCeutXRbajMKVzTLOnEuP0uuMci8FdLxoeWKvgGCBZAMtZH4tyvT3+dhx86yZxVxItIYpkS4idieKmaE9H07voZGsmer5E3lmg5hmTBOsOo7c9by2gBxg7FoOTJ6T3jqe7dQQZhl23UpsuRhd2il0e39oB02rdC6uXxqblMMziMybTTVqTmSLMy/q9+BRXvrrS4YnxVl+n2zE3OnWBokx4ZcgzRaV1tZ+xTCxe7oEVTDUG32ZvPvP9VnHjLuGntNt9AL4dmBMu5C2+llprbV+yrdDT8jnUZ43wvJuGF2j22ZTd3YPMXNbxgS2IQ/pH0a4EWz67Cua3a2JuoWOWzDo/Myo+3yheUjqnhuDPd17fzMU2A1gbe5WX4juUGbmXJtAY6JTdGQrG6mZ8uPnAc68fMX6/cZ8JFzMOWkAXHO32bV0X3zC2VLlhKGAEJLaQvolZyVMghbiwpkEBmlgNT/gHsuMqrNso0qrD97wNRFZYO0FXXkuTq3skxZ7f9wjBoPWnkrQyKHsQ9ZcMml1XJZ0EwvqIkwhWVe9C6YbsOBb1oUFnSxq9RMdjQnXlrH44DNl39AEKBgjeyFW+TVJxVEKxi1GBN/Xieaiev/bj+IGeLvuFbvZbn8/Rmtfl1PH7uEFkYEmaBr6MIGV7Q8MgwBrR0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199018)(31686004)(2906002)(5660300002)(26005)(66476007)(36756003)(4744005)(8936002)(8676002)(54906003)(66946007)(41300700001)(4326008)(110136005)(6636002)(316002)(86362001)(478600001)(36916002)(6486002)(66556008)(31696002)(6666004)(38100700002)(6512007)(6506007)(53546011)(186003)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3ZZQk5mWkxrdzdacEtGN2N5ZVlkK1VSYUxHUFRWdlpnQndLeDlLbkdPU0tL?=
 =?utf-8?B?YVh3Q3lpVVRGZ1J3RWFSVmJVeWE0SnFFVEp1ZnJSazBQbjI5b0ZiVVdpQitu?=
 =?utf-8?B?YmNPSUYyWTBsODZRMU5MZ0ZiVVpzVSsvSkdickJIUjlKUk15VnhxRDhRQ2Rt?=
 =?utf-8?B?ZC9rTXBIczRlNEkxR1N2OWVnYit3QU1oS3VJL0RDSjE2UUhNY0FaTkdwbXJR?=
 =?utf-8?B?NHkwT1QyZWlyVGdyTFBrZ1ZsM2h5MEc5QXhWSTcybEFMUkY3REtleFZGSHY3?=
 =?utf-8?B?ZzNETW9OVTB4SGpCYkhiaXMzN013WUNkMTlMT1RtbjdhdlpJZU85elJWcFJO?=
 =?utf-8?B?ZFMvUnV6d3RLd1RTeTFtWFI2YTNTaUFuUWNzWE9ZTHREcndyT3dvckx2UGdv?=
 =?utf-8?B?eVNxZU91VEdvSElmMzlJemNnQklraGFGcW5ZZ0pTNGxkWms0NmRnOXFHWmg5?=
 =?utf-8?B?SmZuQmwrS2l6NmxpUjVQSFFrUlVzc0Yya25pQTFzaWt0WjJqNG9aUkZUVVpB?=
 =?utf-8?B?cTV6U2Z1MStaOGwyK0ltODZMMjhZVlRRREllQkdxSXZzWWdyQ01Wcm4vTmJ5?=
 =?utf-8?B?cUlsMzhDWTBkUC8rOFBBb0NrRG1UaUUxaDNtM1AydUZ5Q2N6aGdWUlFqL2lT?=
 =?utf-8?B?L0ZtaU1MeW9XdzZ6TE1IUlV0eG10R25EMlI5TTUxQ1VHenh3QnMxZkdLNWJV?=
 =?utf-8?B?UEpHQndPbW9NdjQ1WXEyaXN1dTJuVWJIcEh3R2RvUDZmdTkxTVZicitXdjdI?=
 =?utf-8?B?aUthWlFlYVBoOS96ekd0RUhzcVlMVjNwdnl6aGg4T2svMTRMYXJDQVNjVDJL?=
 =?utf-8?B?QXZGak5zQVdvWkM2R2NBcXlCeUhETGRQMVpzQ1hUTVE5T01tZjJvVzlUUWtB?=
 =?utf-8?B?RFhNN1ZtcExoSHBBNHpQUHM4UDBNUHdmR0xXUEFuc3BjRFN0Skp5T2lvTU1G?=
 =?utf-8?B?cHdSMU8rQS9kUkZveHlldUtZVHYrOC9icmNlY1ZySWN0T1A5TWYyM3FOMmFs?=
 =?utf-8?B?V1JXMmZUZmZJUEIrcjU4TW9YU2NidEg0UTVRWXBZUTJRY0MwcndVbVJrM1dK?=
 =?utf-8?B?cTkzaG9SeGpwa2F5Tm4vVFRSZGxtZ1g2enJ2VHZ0dHAveGxIejU2ZUlrK2dF?=
 =?utf-8?B?RFRwWEt5YkdmWnFWR21UMnRDZUVPeS9haW1ldGFXTi9mbjdMaFp4TXhQc2Vm?=
 =?utf-8?B?UmNMT2tjTXFVWFJGU2k4bkJUdS95UHFWd2J5NjMyUVlvdEd1VEFSREx0NURv?=
 =?utf-8?B?MXgwY21qOHJpeDViKzc4RkNpdXErdkhjbHVMQXp4UlVwMi9neUlzK2NsY29W?=
 =?utf-8?B?M3ZmSUptRTYvcm9aZW82a0xnSlNucXVZUkloS2FjdGpvZDdFVlg2NVZYNmFy?=
 =?utf-8?B?WVF5ZzhyZ3dDNjg5aUVXZ2k0dkoycmh6WkZWSkF3VVFQTDhCR3dlSGwxcVJM?=
 =?utf-8?B?SS95M0RONDVSaHVraXlBWTVBRkJCTGgzd2lEaUc5SU5MY1JLVHVjTGE1d2lX?=
 =?utf-8?B?T3c4eld4NEJoR2k4VEFiVkFzQlNVZ0kySkEyUVh4ZEZLakZoTGNLcFRmQXph?=
 =?utf-8?B?LzRod0J5Q3BmOHpUeDMxbnJpZE5iMm10Z1RuVm9MWEIwT3Rsc05KNlFSb3Vm?=
 =?utf-8?B?SGJvTXZvQ2Z0ZkJpTDZ5Mjk5eG12dWloakRtS2x1aE02WloxbFZJbmVuN0d2?=
 =?utf-8?B?cnlXN0U0NWU3ZituSlJXQzNZeVJCSUJIbjA3OStGTlhnV3V2WUxUUE5TUHo3?=
 =?utf-8?B?NjYveE93Sk1SZEVkY0E3c1M0UHhDQkF6MVNOVEVxSmgvVlQxbldLWEQrMDVq?=
 =?utf-8?B?WStpMUZ2RTM1Lzd1bHd0UVJvTytWWWE2a21zQ2lnNmcyRkV1akdOdjQvMkhw?=
 =?utf-8?B?QVdWUHVvbythSnQ2OTdHcXNvYVQvbFhuRk1NOEFreHBSd0dRcGxscUtNZHQ1?=
 =?utf-8?B?enVoSmgvYkJZMVlvWjB5bnRRNUJJQ1RrZGNJUnhKK3h3cVpLUzVJeTRrTysy?=
 =?utf-8?B?Q1Y0OVFmMGlwd0kwY21XUUVRRFZPS3I0aXZ4Y0J3UTVKZFczeXUyR0NQeDd4?=
 =?utf-8?B?SElUWkF5UDBQbS85K21ibXpyZVYwUThBNEhFbjdtY3ZDWkNMcW9wVEhrZFo4?=
 =?utf-8?B?OHNxQ2hCU1BVQ1ZXTVdIRG92U1lwR25CWTQvc0V6V2szTVZnTzhENDVqK3Zu?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qBCIoFnOH5xLpR4Q8QEt3Pt7LsdjAZe/5YLCnuiOMoj5429J3LqEz1f16XBATbiaKKIfrG3ZhzWPiwLiF4HSGHEGyIhHzsvvBPXKrrbKT4O8YYqCOytRGbhpX7Ia9/iqZ8Rjsz92WUpvldacIg+sr6dl5yYa0RGEc4r1403fgPbn2JkEmcgKNJO3XyLhP9EKUN8kOrCXDDZPdgPv0FpKVmaftXok/BlBVVP9B4V1kEczpP3g9JFGx8VGSvTwETfoAcqdfgZvLaO7hOjIYHLplBM9oUJeLSUjMXIhN4AgWBQJg1rRyXgYwNgP50VzJF59WFvO5LlBdKoBiYw5gZ7qHPXP89PKLqb4fWiGaG9Bk77y84a2MgUTtX0sGmIGSbmEVdj/h8TQd6EaNK4I820qa/ZlAxBupP/dQW5gkBr3OyNXHg/t3E096GIsdz35hV/XizbhVuXPWUXJn7dSl+bXyFnUONwX5TT0PVDdtweOOm5DIhPmU8M7tdPIz5RzLAMwvtiuWJnt6UrdNxBT86GTlnPmsbwznMiPq/vCJ7h000/xIf+yRzwo4XgUYU89/o4DXB+rwh+iaXP+IHpiwqztYBP8P2f70m+H8g7xe746y36mDZgxH6w9BB6xTbooNrjjyfBcHysdAo9A7Urbu6k+51ds3juEeuht+VoZUGdXfxsuB4dLw1RnpBLkDcQ/LX7hgMN/UFBrXoFXDwCbXDHSB4kwRSGHR3cipWUf9PgJZPORQQxR1vmBjuRJzdlPGq/XaYRLWhDLWqLZ0YmQeE0yL/fF0vXXYz6Qxdywmh6mxfDpuRaKgzrr5Vyxb6nOkbvuygPsxuef9himUD6HYBKaueCxURj/hNaMli7RzXS12wg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6fc8ba-a67d-4346-d5c0-08db20d07d62
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 19:00:03.4316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXnZb/MPEIdJjESV1hY3pv72Sqq9wYmqZVElU8n21LQqz7zmJxm2Fmf7/2WOQ9lDodGUBegodmR80exI0YOVgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_10,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=996 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090152
X-Proofpoint-GUID: NjJoU2aNt3WgsiY06-X8CmFDgp5GxuDG
X-Proofpoint-ORIG-GUID: NjJoU2aNt3WgsiY06-X8CmFDgp5GxuDG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/03/2023 18:42, Bart Van Assche wrote:
> On 3/6/23 05:10, John Garry wrote:
>> Apart from that, I will say that I haven't studied the driver in 
>> detail, but my impression is that we should just set this flag 
>> per-shost in base_vha->host.active_mode, and not the host template 
>> supported_mode member. Indeed, we don't even seem to be making this 
>> driver scsi_host_template as const in this series, which I thought was 
>> the aim (and I assume because of this).
> 
> This patch is necessary because this patch prevents to declare the 
> 'hostt' member of struct Scsi_Host const.

ok, sure, but I am just saying that that the pre-existing code looks 
suspicious. However, as I mentioned before, things like this (modifying 
the host template) could be improved later by someone.

Thanks,
John
