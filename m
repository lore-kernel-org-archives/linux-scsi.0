Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4306FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 19:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0778261993
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 19:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhCVTXI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 15:23:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhCVTWg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 15:22:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MJFTsQ064355;
        Mon, 22 Mar 2021 19:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZH+woopkreE4Xw7NxlE6LbTQiYrANbFZ0gb0x/zbj8g=;
 b=PQ7Og+wR9trCufy8y6pLgQzJTQuC3YIAcj8OzAQejeUJztUaFS3ecsuRwxJ4rIva+KRW
 RN7ujcddk6cvJV8QI8AaSf/BHpsX6UJDhc1t6KdXE7CI4G0WrdsR1cEd0bBTm/Za66ks
 O6rlScmt158w9hnyC6fw3Tz814Wawcc50i63+acGrpLDWo5PDbYDP+F7rRdr3VL1G5ZF
 ksNCGp66W66luKtWJdhL5HaGM4PqH4qH/LzIp3khzLXQ0P0Rz2X0t+HuCAAPeFfoPXtZ
 CqiNHQAYOATuxDXXC16yo428QHb3asn6bCpTX0w69coX+JBenS4DRngz99TN8EkRNSKz cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37d90mckce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 19:22:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MJKdMq128039;
        Mon, 22 Mar 2021 19:22:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 37dtywg2js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 19:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ad7pCQVx+wDyt14DreqIsExlTc5eZWlV5/QeuVil0QIES8ltDYB8i2uHnLGD1bJWmKw0Fv7yeo0K12P81v3T+wwS4gOz6NNKZmm9AFAmPulEa92AKX7uB2bSmW9mjD/aJH1sK8BzoyjaKomhy4Q2cTKIPyYu1EOwlp2Wu3T4V4ZP9RdWLafy+OzpNMKQff6kgvyW8C0IvnQd15VwWecMzCmU3Sa22h5OMsQZdYo3KPp7puvJcJoKrHL4AMPiGj82+U37s1CwEDHd10POuQao1zUmkje79+dLkB7bAD6m+aeAkyj7GSnHf/r5cVHQS5ZCveg0wEDgOepDm5tX3okaVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZH+woopkreE4Xw7NxlE6LbTQiYrANbFZ0gb0x/zbj8g=;
 b=XwoO143YQqg9oM48yg0ix7E1VqGn/U19kEvluTHRckA5N8x2gd6U/+EiJEjBMmgA+W4JcA8E3jM1ZJbx2B020LUKqgLj9vILFM8klGrVIUuF4fxqLEl+Q9uO2NwB8Dmt6Q51JdWFD5W8f7zD+FhqjiSaM3C7TBXo33MGfs61opv7T18BQb+c2+cJ5x14i2pU6jNoUyCdJBE+2eE2wBJtzji4UEtaM2A9AS9yuBlj6IIuLx91MjsY2WUlvGmSzY2oIUbOdLXViwaaviHNqWyfnN1rRr4vFgGGsxAWwlx9JxO2pr+snGTkILlyltUci9hWFj0LVOkDoiMESPoMHVDpkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZH+woopkreE4Xw7NxlE6LbTQiYrANbFZ0gb0x/zbj8g=;
 b=xBl8jkVLG9ywiEXM5iX2U2fwMFUhYmz9UvxXgzyuH9t/mtd506TP4BlBHZ53k2KqALERLybMb86KK4nlTKOAPMijQHaYpagKwN+gxmY4h1IsP9kOhKDvTcnXhigi+Zljaz4WdEyKZnk2sXOu51WhCBW/tvwV5ZYvte/oQgjBDo4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3622.namprd10.prod.outlook.com (2603:10b6:a03:120::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Mon, 22 Mar
 2021 19:22:27 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 19:22:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH V4] iscsi: Do Not set param when sock is NULL
To:     Gulam Mohamed <gulam.mohamed@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20210310062651.179792-1-gulam.mohamed@oracle.com>
Message-ID: <66c54dc7-d594-ad07-7c35-face5a57d9a7@oracle.com>
Date:   Mon, 22 Mar 2021 14:22:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210310062651.179792-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR07CA0109.namprd07.prod.outlook.com
 (2603:10b6:4:ae::38) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR07CA0109.namprd07.prod.outlook.com (2603:10b6:4:ae::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 19:22:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86bfcc5d-ed61-4123-118e-08d8ed67d43c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3622:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB36224924347F0004FA73CC5BF1659@BYAPR10MB3622.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LofqrXl7KdWeFs/jyYIkN5/FjyRnU3Vb7rJZYWVP1zvvLeU0jkT3MJM2GIzVshYw85rOj3HW0MLYLV99T7jM1mi5bgnTht7QflNloyaWT8TB7kncDAskSmlxOZnCWgOd9NTLPqPipm+W3e0tKvllNXOKiRXLkSQXyvtbnyIowCjpBUggRJUACzcU/qVthFZbimAabZhClBnvuLC5O/FLFxS7HiMLJ7dtZKzF+uClb/0KMwPzpwnZBTO3gXMdEPLlhqteaEkEik1JcuB51567en1A44gyKMOj5Xy4kUNtKKfTnsXYbHJkiWa9OIEF+T42z+Kqpe9JNC/hk0zCz3f7HoKodd9BG8t8rsH5fAWabvWZ2rm7ArOI+7CemTxBnqO0+FA99ptyGhFjS3KGWVHGfIb+BAPhkZNTA4D8cTcXbix5k/H9jDgAHnXPzQlru92ICRnqbfFodMI1G2rj8te12dTBx54DC7E04Dpzc8rdrRskAa2JeRdmMZMQ1DXG7I9rgyiWMkB+rq8KNyTc8mr8ZqCyLy9RiEePSR/XC9MhsrVI0e370FZxiwY1Wf7ylkfTAFPYZjp6tED/pF8rLCG2/kGB0Ga8M1owBnCPWjvejhD/KVFp9b+UUL4wslbuob+fR3KCFOFgQsBWNyuDLHTXujyu36QqwyYd4uxIn4E7s5ys0QKqDIHgr1X6n2ocCIr1gScXzc8Gb0TECIs+Iygck7azqrwZpGKG18xfeUcsSfFXT4iNgQd3T7rapo5F0ru1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39860400002)(346002)(6706004)(38100700001)(5660300002)(26005)(2906002)(83380400001)(8936002)(2616005)(66946007)(316002)(16526019)(8676002)(66556008)(86362001)(478600001)(31696002)(6486002)(186003)(31686004)(66476007)(956004)(16576012)(53546011)(36756003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cTZDZGdmSURYQnozNzNxV3ova1dxYURYVFRhU1EzR1B3WnZncUZuTmxlaVRv?=
 =?utf-8?B?T1R6bDNwazNlOUJLc3RTbkxKcWVVVUdmbTFwUGJVSTZiUm0vTkkrM1FGUmdw?=
 =?utf-8?B?QnFMS3NyUHQ3aUVVN3Y5QmJGU1NUUEFTdmFxRVAyc3cxbHp1am9SbWtzM0gv?=
 =?utf-8?B?SVFHL0hLQWlhWENacVNhTE5zLy9MOVo5ZWxyODNCQTkvWmFoVDM4NWtWWTlB?=
 =?utf-8?B?bDFqZlVhaUZYblcwZFk3MGI4WU5DUUdBYlB0U1V1ZDcrRXRBMzZDNGRWRjdP?=
 =?utf-8?B?SzJiVFZiTWJ4YmVJMXltSlcwT1hHT1haQzN1WURYUTFWVUF0WFlIZEFCWFpm?=
 =?utf-8?B?U3czVnBscjkxWVgvTmVIS3NQa3lyYS8ydCtmYU90eWFFUHdaK0VZQUFkMVNr?=
 =?utf-8?B?aHVudFdSUUxXeTBHT2RGOVJ4V3dtM3JoRlhHQ05KUElxa0haWndCVWhxYjNo?=
 =?utf-8?B?ZWxxVzNwYUhGYyszaUVqZ25aTE4yWXhzQ1FwZzdMQjlGNkVEbWpnSWlpNWdQ?=
 =?utf-8?B?cmJnSHpUMkZDRi85UVF4Qy82d0kxOEhCb0d4eHpPVzNiMTZTdFlvTHQ4VHhC?=
 =?utf-8?B?ZnBYS3hKdU5XRWxsbEFoUEpDM2NsYUwxbG5hZ2V2QTd4ZmVZOEJST0d6YjFz?=
 =?utf-8?B?QWZYZ055Uk1LNVBIV25oUVFxN1pPWndLWlI5NnRyZ2UvbnRDQlk4Z0IwUjRS?=
 =?utf-8?B?RURDanZHR3hSWmtuU3NlNC8vcUFGdXhQcGxqaG51K0Y3WTBQQ0piZWYyd2Nm?=
 =?utf-8?B?R0FBRlI4dUt2TmtpK2NOdzJxTlZBbzhDcWxIVTVLNnhkVGwrRDBTcU1XSkx6?=
 =?utf-8?B?cFNUM2FUWjcrTmFLaW5WRzd0T0ducllmWXYzaC92UXg3eDFFN1JzcFR0RjRF?=
 =?utf-8?B?RGpoWkxFMG04bEgvTkFqeHh3RzRkNmh1Sks2NmpFZWZRdktGN2lKRFptMnFJ?=
 =?utf-8?B?Y2xwQ0ltUzlDVlljWHBuQkRWZG9nL0xMRXRBc0pjN0JnWFBOVHdXQ0tyTUsr?=
 =?utf-8?B?ZDNoeFlCYmhDbm85dkV5NzROeFhranNOdkdkajkwY1VLaUkzZFQ3QWJrWXFS?=
 =?utf-8?B?OWNGbnpmRWM1eFZCZGhQbjBDTEg3OUJTSjBEbzM2c0l1OGtPemo0N1I2VnBZ?=
 =?utf-8?B?c1FhZytiWS9iVjd5M0VlTmRUajVMRUJKZjQwUGYxUkd3Z3MvbUhZVHRvaWFW?=
 =?utf-8?B?MEo2RUxCS1MvTnBwVldmbVIzMWtRTitwY0FYcGtncXhBRm9Eck5rSUFlWVQw?=
 =?utf-8?B?MlpYUVVRUGY2WUFIVUdTS0o4U2dNNG1QRlFjSGY3VHY2VUVNcHBNRDVuOU5i?=
 =?utf-8?B?c2VSQkIzREJ5QjVsVysvck9tYU16cC9FcEZZYi82L2pGbCtTR3Z0VHFEVWwy?=
 =?utf-8?B?YmhKWktLSkxtN2RZeUJkTUNHbnFoY1ErTjI3cnY3UkRza0VOL3BxZFh5dXM4?=
 =?utf-8?B?cGhOaDY2K3pqNFJGQ1RmcENHU0xpbXNHdStRcTNENVdDeGYrRlRJMHU0Z2xR?=
 =?utf-8?B?QXl6c3dzblMxNmlFZUhaVVl1SmZoOXJXdEtQZWdBby95bmVDYVZXNGJ2cFdn?=
 =?utf-8?B?Tzl5Q2VpdWY0a0VSeWhuUnFsYVAxbmxkaHJ4Mzd2V0lhRWtJNng4NDlpYlFk?=
 =?utf-8?B?aUJpbHVweVQ3Q1U1MkNKSXRlcnlHVjJ6a2cyNjVtK0FvYU5PS0NQTGo5NmpB?=
 =?utf-8?B?cUVmcTRhRnFKK0Z5c2dFVWNReFJsQWhvSGx6QTlIZ01vNWdkK1BaVDFIaWdG?=
 =?utf-8?Q?Q5ZFRMoTRinUPdi2LIDcBJENcZozt2oSbp/hv7N?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86bfcc5d-ed61-4123-118e-08d8ed67d43c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 19:22:27.2285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7EtfWyaQfDcVtPNBqPi1JCWpAxPk0zjjJKDy6/tRnd4yitq0i3bJLV7btnf2rWyh3/1CyCjVb+0tB7XJauY5k2NUQQ4SAikTsNCxv6lcBwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3622
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/10/21 12:26 AM, Gulam Mohamed wrote:
> Description
> ===========
> 1. This Kernel panic could be due to a timing issue when there is a
>    race between the sync thread and the initiator was processing of
>    a login response from the target. The session re-open can be invoked
>    from two places:
>     a. Sessions sync thread when the iscsid restart
>     b. From iscsid through iscsi error handler
> 2. The session reopen sequence is as follows in user-space
> 	a. Disconnect the connection
> 	b. Then send the stop connection request to the kernel
> 	   which releases the connection (releases the socket)
> 	c. Queues the reopen for 2 seconds delay
> 	d. Once the delay expires, create the TCP connection again by
>            calling the connect() call
> 	e. Poll for the connection
> 	f. When poll is successful i.e when the TCP connection is
> 	   established, it performs:
> 	       i. Creation of session and connection data structures
> 	      ii. Bind the connection to the session. This is the place
> 		  where we assign the sock to tcp_sw_conn->sock
>              iii. Sets parameters like target name, persistent address
>               iv. Creates the login pdu
> 	       v. Sends the login pdu to kernel
> 	      vi. Returns to the main loop to process further events.
> 	          The kernel then sends the login request over to the
> 	          target node
> 	g. Once login response with success is received, it enters full
> 	   feature phase and sets the negotiable parameters like
> 	   max_recv_data_length,max_transmit_length, data_digest etc.
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
>    of time the login response was received for the earlier on
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
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 16 +++++++++++++---
>  include/scsi/scsi_transport_iscsi.h |  1 +
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 91074fd97f64..19375f1ba4b2 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2475,6 +2475,7 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
>  	 */
>  	mutex_lock(&conn_mutex);
>  	conn->transport->stop_conn(conn, flag);
> +	conn->state = ISCSI_CONN_DOWN;
>  	mutex_unlock(&conn_mutex);
>  
>  }
> @@ -2899,8 +2900,13 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>  			session->recovery_tmo = value;
>  		break;
>  	default:
> -		err = transport->set_param(conn, ev->u.set_param.param,
> -					   data, ev->u.set_param.len);
> +		if ((conn->state == ISCSI_CONN_BOUND) ||
> +		        (conn->state == ISCSI_CONN_UP)) {
> +		        err = transport->set_param(conn, ev->u.set_param.param,
> +						data, ev->u.set_param.len);
> +		}
> +		else

The else should go on the line above

} else

and I'm not 100% sure but some people prefer:

} else {
	return -ENOTCONN;
}

because the first chunk has {}s so this balances it.
