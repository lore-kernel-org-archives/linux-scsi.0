Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C51FC433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 15:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 258AF61A1D
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 15:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhCYPqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 11:46:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55230 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhCYPpj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 11:45:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12PFZ1Y6133693;
        Thu, 25 Mar 2021 15:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JPwyAKbKpI76OVGLD+gBlqwFD47fweQczvo3bG+jV9o=;
 b=h20hdyGqA2Neirx2ZMBK3pmXaW9ZCoUh2edzeD/2VZqCqyGZmokNevbx21QHRMsjxuG6
 W8GKaYot4XdVpmsZnGiVhPPUQ8wzhtyENMlGVv6KoyleAvb84hs+8zlEfgMB3W8bUPTP
 JVSAkPGqUGwtb8ppNrbl5bvTmjF12gqFgvgN1P/WrliO7arULn4zS5Ps0R/85LlMuCYA
 OFJOozNqe+X3ErUXlakDkh53ZoXxz2GU4McDK+sfIDTSkWwaDH5A0PRjQWKUpkQS73rm
 obCuDXoJzgyUrtVAnXXmw2ivfDkg9Nlux+W/QC6FB1EuqP++GwfS1nCItUigqZ7xHOcr Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37d8fresyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 15:45:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12PFaWLo144466;
        Thu, 25 Mar 2021 15:45:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 37dttuu5bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 15:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imWFIMn4GN/ufD6Z+Omq8uiRsK3jfRjlreH+xil5imYB/j3u6oRhqDswrb/gy0eKKwRYOofSaJbCUu9azvqawz4PWk5Fa1kyu4IgPOkmFxAdQnxRM4hczd1mW5K4vaxEnsJ7h9qSJg4Ri6DNdKmObkXHsToMTDfKmEMLcNqBwn4LwVPfd2X43vyh80bdAqnnySqarl2ai/SxDMcpelj4//4MvB1R3IR7CsP/zTh7Rt3a5B+66RPjKm4zF9jYA+dZVEeFAcZHstpqyabb3op8hWlB74kz3Mr08y+Zq+RNxbxdim/vUnwQvqz1AB5oM/4uTp2IjnsnFp+kMGz03F4xig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPwyAKbKpI76OVGLD+gBlqwFD47fweQczvo3bG+jV9o=;
 b=jZyqJmoj6JKMVg9+F/wAHLtvVET1OXHT5YgKmsaNLmVmqp1JQNjmPx7PHexD1RKcF/ibOMSrvr9w6gvpDDTl/qA9NDcNeXegR8gzRRR/jD1SRN3DHHbbkARRdcpZb0jdbe3URpYLVT7j62xZKMjbFF/zllTlqKXUV7ma0SEb4z6aDUbzDQkfax2DOD6iqv+QU9XF7oNm/O4GhIsbZ8V+M39N8xZbi+NTJcf8+YZhjPP4BGICx5QGl3txz2Hi2WEWNzINbms767t0zTO3YRUYf01TqVmyuBTLE+9M+e+sNtGNgX+WOPouMyWz218QUoknTiBhnhHM9a0Z7uZsDvvYpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPwyAKbKpI76OVGLD+gBlqwFD47fweQczvo3bG+jV9o=;
 b=bG2wInpsd15H/NZgCFTguxmUQRae7h/VMGwyu089riT+MWEIjcjkdqaNDP4eQOrPNLIZczgm6t1CLnca9fpI1hEZyqWX8hz4yW1eDhpJ+Em+mffqokitdP4RN837OgEn9pA6KCBXe1IewCmsJUT6E8djIJiz/r1L0zvlDXeLHbQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 15:45:30 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3977.026; Thu, 25 Mar 2021
 15:45:30 +0000
Subject: Re: [PATCH V5] iscsi: Do Not set param when sock is NULL
To:     Gulam Mohamed <gulam.mohamed@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        junxiao.bi@oracle.com, linux-scsi@vger.kernel.org
References: <20210325093248.284678-1-gulam.mohamed@oracle.com>
From:   michael.christie@oracle.com
Message-ID: <30410504-9616-ba2b-2ed1-6a40b0a788ba@oracle.com>
Date:   Thu, 25 Mar 2021 10:45:27 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210325093248.284678-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DS7PR03CA0115.namprd03.prod.outlook.com (2603:10b6:5:3b7::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Thu, 25 Mar 2021 15:45:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a9f11ce-b383-4cac-6ee7-08d8efa504f3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3429A2793BCAA3E0E47ABE08F1629@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BtxW9VJ/XEbki1BZv0m3gh0sV0Ad5G0z3fwgURP2Oql06Q+0OLGPhMM+TnQRafjxFe71Geb5vE58QKvvtIFp3IOTIoebbNPQKtjft8vRUP18aRQpAJ6u+EPLfZHfOsGwQQmfWrN0gDu43jHk5oYr7eJBjg9ws9Q+NMDkXRQ6cV5K67AXBGYiNbSUedNkXNxFotmqq+oLxDtUbF64kApc8qMQf94RFyey3KxE+OJiRF+nnJq9Pb7eWbpiQc3mpoKvW3rzIPq1JSSorwbsRbJuTmSiufxBoGxWgoiQWKf+Tl6/DQFbAqY3kICc3NKEM8umlECj8HLtDMPwZPPkGQuqN8gcyQ8FoA8xJ6rP1e7A9igI6BfX2hc1555w0DhDQj9iom2R4S6nV3VuLYwTTcvN8nax9vijkYlrtP/h/TF10mqV1ASmg7zTERuIKojG2h6GP+9dwkCUrwLN7JN56IFHoq/ysj+kPO6D2T6Ej76KD7MlwMyneSHM8QaM9quqTe2+ArrjHbwE66ek0THUv0lBUr+yfoQlToXPIjCwRE/UU9LGYaIHATgZ1YoVmRW5A3pz/qMpO+r9Zv0ESTC57JCU5V0+GmE4DmZ9AkyYxvCH4T/Djh6Gq5hLCHJ6pANIfRP0TjQ6ySotUxQnpv9V4ppS1n8W/e9AovvSPFPVj4YAvRi4CqgELGguxjdT9Q55QTa1/XIIjviTRi9gMYO2JtO7gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(31686004)(5660300002)(6706004)(2906002)(66476007)(9686003)(8936002)(6486002)(53546011)(66556008)(16576012)(8676002)(66946007)(956004)(2616005)(26005)(16526019)(38100700001)(478600001)(83380400001)(316002)(186003)(31696002)(36756003)(86362001)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YjBzUnJSZVhFakhMbFZaTzc2OE5DT0FCdU80QnYzdm1tdmJVSkpvTzJoYjJm?=
 =?utf-8?B?cmp6S0xwSkVDR3o2K2dKZzFReDllUmQ5dGhIajZXUzRJUFBnRHZReXBhRFRv?=
 =?utf-8?B?TERZZDVNVnFGV1lDbWN1WjIrK3EvWU91ZFhDbGcvanFmVGU1UkFIVndKTU82?=
 =?utf-8?B?S1NFZHV5SmtVRVJUby9uRFpLR1VLcUwwN2E2SmhWRDU4dlVMVVIxRTM2SUZ1?=
 =?utf-8?B?bEVZQXhwUEp1ZjljSTl0ZXF6b1ZyYWhVcVhPcjh1U0l1SS9zTTFaOUZWR0FP?=
 =?utf-8?B?blY2Lys1SFpMVElHb1pkcEdOVEY5am9SQU5mZWpKaml4clNjNGJXYmdSQ0s2?=
 =?utf-8?B?Nnl1ajQrMk1YbWlhaDdjM0FvZGoyU0VJdkFQR2x1UU9PM0NaRFNhaUhUbGFZ?=
 =?utf-8?B?SytWV0sxREVFSTdsbjVZRVNhdExsSzcyMHNDSUpZZkxkRC9wRCtwb0tmN2ph?=
 =?utf-8?B?cWlnUm92djBzMjhITGsvNnBDNnBtdmFmOHJjejhTejA0UDZ5NnBrb0JkU3g1?=
 =?utf-8?B?OHdyczdIUjE0WEVlVmhORTJORnBEd3dsTm1iUzNOelZQSXhHWHI1bkNTa0JZ?=
 =?utf-8?B?ditBU2hxeG9RM0M5ei9iVGlJZkNUS3lYNEloNERJaGFndUUwcXNaWEc2UDI1?=
 =?utf-8?B?Rm9ES042N25jL21iTnV6clBZdXdSZ0N5VE56cU9rRzFDeGZ2V2NndXhrcGZ0?=
 =?utf-8?B?alZCWlRmZ1NkMTVNN05LeUxIaS95OUdudmszOHpJTnFYU3NGVGJzMkw1TUIr?=
 =?utf-8?B?RXhqL2IzbWpzY1Y1WjJXbnFQbXMzM0hDTCtPTHFZZ05TK3BqZUZ4UU9SaXFr?=
 =?utf-8?B?U2VRTXdSNkZmZkRTdThkVXpHVk1oZ0xtQzFRdStzTVAyWjJMZzJ1QW9BaWZl?=
 =?utf-8?B?WmJvZFJ0VzNKK0V4UXdpVThSUDJUa09BdWlWdXN1QTd5RmNONmtma0ZvVjV6?=
 =?utf-8?B?R0dUZlVMTDNhQVhpUXF5WDBEeU91VjdPY1RCOTZQOExWeElLUUZwTU5nUzd2?=
 =?utf-8?B?dVZpUUZ1eE5Dc0FJa2hUY0twbFIxdUhsMHJHeE93bDJ4MlRwcmN1RXpqMEU5?=
 =?utf-8?B?bWI4TWZtWDFva3BLeXZuTWpFTVVXaCtBVElCd2I0Y1hQRjlJTTJYNm1sQ2pq?=
 =?utf-8?B?M3p4TG1YQlNvQk5jQThhQXlYbVI1MWRhQXlUL1I0RFV4OGFyQnc0TXp6ajkz?=
 =?utf-8?B?bk9KUGFzaUVPSG9kR1Z2YnRVcDlyMTU2Y09OY1AzYjFrMHk1eXc0eWkzUnFB?=
 =?utf-8?B?WkdscGViMExWL0h0TzNzbkhuajh1SkVCWnorRFNiWWg5YXUraXJIazIyTXBN?=
 =?utf-8?B?VTNOSklaR05GeTlha2p1TnRQZjNsVXBESDRTZU9GU01SUzIvdHh3QjBWV3Fk?=
 =?utf-8?B?MW9zM2dITnNqYVREK2RWN0xMNFZjc0ViTVg3Rjkzb1pEVWN6NW5yclNSTXph?=
 =?utf-8?B?Q3R3TzBoNlRtZ2pZWUFobVFmeWlkOE1oNXJrQi9oZkNlVEwwcFpLVkZhWDlP?=
 =?utf-8?B?Tk9QZGFMWjhvVzJpNCtRSVRCdXBhdE9rUk1PcXJzVlFzcGV3dGF3WHZ5ZFBL?=
 =?utf-8?B?dHJnWW1nOVlYL3A0Wjc2bmp5bHU3dm1FRDNaZUIvRkROdGRCT2owTmZndXdE?=
 =?utf-8?B?OUxBdlM2Smd0SGc4R3h4S1RzbXYwZ1VYYkEySHFabDFGeENLNmJ4Z3l5NzRy?=
 =?utf-8?B?aDNSSm4rdVJ3T3VoVDZScWFxQVgrWlduKy9iaXBmemxCRU9nUllHRXM1LzFE?=
 =?utf-8?Q?oCqtG8Z7zRnH0mH1GndWqvLJZJqkhKGg6j+A4wn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9f11ce-b383-4cac-6ee7-08d8efa504f3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 15:45:30.6668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94XHEdxDInYUwQKnMkL7a46w21LFQwfd+vm9sD3rgjIrA/rtpoKGhsH8QEAYD3IoUmET+eDvzEIg+cERqxDZKU97YTyZIfey0tFAeqNn0w0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/25/21 4:32 AM, Gulam Mohamed wrote:
> Description
> ===========
> 1. This Kernel panic could be due to a timing issue when there is a
>    race between the sync thread and the initiator was processing of
>    a login response from the target. The session re-open can be invoked
>    from two places:
>     a. Sessions sync thread when the iscsid restart
>     b. From iscsid through iscsi error handler
> 2. The session reopen sequence is as follows in user-space
>         a. Disconnect the connection
>         b. Then send the stop connection request to the kernel
>            which releases the connection (releases the socket)
>         c. Queues the reopen for 2 seconds delay
>         d. Once the delay expires, create the TCP connection again by
>            calling the connect() call
>         e. Poll for the connection
>         f. When poll is successful i.e when the TCP connection is
>            established, it performs:
>                i. Creation of session and connection data structures
>               ii. Bind the connection to the session. This is the place
>                   where we assign the sock to tcp_sw_conn->sock
>              iii. Sets parameters like target name, persistent address
>               iv. Creates the login pdu
>                v. Sends the login pdu to kernel
>               vi. Returns to the main loop to process further events.
>                   The kernel then sends the login request over to the
>                   target node
>         g. Once login response with success is received, it enters full
>            feature phase and sets the negotiable parameters like
>            max_recv_data_length,max_transmit_length, data_digest etc.
> 3. While setting the negotiable parameters by calling
>    "iscsi_session_set_neg_params()", kernel panicked as sock was NULL
> 
> What happened here is
> ---------------------
> 1. Before initiator received the login response mentioned in above
>    point 2.f.v, another reopen request was sent from the error
>    handler/sync session for the same session, as the initiator utils
>    was in main loop to process further events (as mentioned in point
>    2.f.vi above).
> 2. While processing this reopen, it stopped the connection which
>    released the socket and queued this connection and at this point
>    of time the login response was received for the earlier one
> 
> Fix
> ---
> 1. Add new connection state ISCSI_CONN_BOUND in "enum iscsi_connection
>    _state"
> 2. Set the connection state value to ISCSI_CONN_DOWN upon
>    iscsi_if_ep_disconnect() and iscsi_if_stop_conn()
> 3. Set the connection state to the newly created value ISCSI_CONN_BOUND
>    after bind connection (transport->bind_conn())
> 4. In iscsi_set_param, return -ENOTCONN if the connection state is not
>    either ISCSI_CONN_BOUND or ISCSI_CONN_UP
> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
