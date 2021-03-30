Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A43C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 620D661955
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhC3DzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhC3Dyo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:54:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3hhsb103300;
        Tue, 30 Mar 2021 03:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=svxjXkKFfMc+ni5C0m3NgVm15IGZ2NeSvJnl6J7cqsU=;
 b=G2h9pqxCo+ZmrzpqwTFjH+qIXTjKTh8O+6nHEgjdFFdt1icQBEp3AHElFK0KRpqmb0N5
 PJ9ksuTAy0yqpMBt6JRVOeRQ6Hv4cFUvrkdLJdL6PhL3RKAhNP9KchQR5NwjXh+5FL8s
 mz+D9OwdkuBn4inEY79CbLLfOIiErUFDY7/9XslMqjXUq6zgtUuoegD9J7f5rdjG34Vh
 /Yw1Uq95jEVXTS53wKmpaHgXI7usg9RcVkvvb4G1GtvNKcdsGDUJf+UhSt8rLy7zi6+f
 I5Xf8sPXLSxKe98FZlng5AD88o9uk/HiflsqLiF58FZEAoyr/+lcRCv4S9h6rNdMxmQL BQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37hvnm5kaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:54:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jZh2151928;
        Tue, 30 Mar 2021 03:54:38 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3030.oracle.com with ESMTP id 37je9p60f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:54:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrlppKOmtGCbtB+LF9B5b0BWbFc7XSaaThVx8XUn683j8zc63zRmRDaPfuDSZvNRw/7Bxl7CFJ++7h2lQ+iJ+QaWrUyJBXzWhv7PbWgrovTZgFOp9YSMQY3jHMh9yQjrKHvktWVMf5TyLNcg0ImHVXRcuVrMufHCG66uLfDPqrQna3GOzmKj5hRJANNfksgAAT9p0H5kSIOV1JMrOuRA7By7Krb5syeV/RHjyDzuvURlxGtF/5GFnUYSHriDC7GtY/BoETHeel2FHV25YDKzCIx8Z4vzl0PxnYrjHFFQ4CA4D5lr0VDnybCeAFEZoQ/PJZcLe5CtLkvj1ECDlnasDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svxjXkKFfMc+ni5C0m3NgVm15IGZ2NeSvJnl6J7cqsU=;
 b=OcGGVohE+olCP1PH1XP/Voc9AFzYWYVxLS4QdtcCvO3Ws944I0o9sClm/sDDLHXv8d/YwCVRQx3vHr0PE9O49t8KJCjIBHJCTgHk3EqcvVNvtCAR3ml3YbTymFFAuAn5A0V5KFvyYGThjPeNqoDfS5BkjdQH42th79dKWDh3JtJyW7KfeyJHpjv8nObVKlBuZmGUdB6LekuknkbsvMZ5VRDNNSWR8yRIGhfq6PTNPw8iA9E6f48DDJwtEH07GzNMJE4Zv8RczuHE4EbfK04rbP284ZaVEqywXjv1Z6vPUuxCA3sLETFiVB+IHlOQ+DrDrn3lklZT6YRDS/BVyphcDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svxjXkKFfMc+ni5C0m3NgVm15IGZ2NeSvJnl6J7cqsU=;
 b=P+TdwqVHbLqAHpfQ0gFg3ws/dzd5Bbmx4U4FbbD9EAp4+Gl9kspCNO5XkTeUFvesjCx4IZFDH9nE8Up7byPfQ2uUc3ASHaKMwgYON8AYvt0kQbk1ZbRsIWTgmh6yc3JvUDTMmdva30Gzjv7D3Hb2u21vbwnGC30QDcYEGFx+yG0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:54:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:54:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     cleech@redhat.com, Gulam Mohamed <gulam.mohamed@oracle.com>,
        michael.christie@oracle.com, junxiao.bi@oracle.com,
        linux-scsi@vger.kernel.org, lduncan@suse.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V5] iscsi: Do Not set param when sock is NULL
Date:   Mon, 29 Mar 2021 23:54:32 -0400
Message-Id: <161707620840.4613.15045963219806560927.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325093248.284678-1-gulam.mohamed@oracle.com>
References: <20210325093248.284678-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0341.namprd03.prod.outlook.com (2603:10b6:a03:39c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Tue, 30 Mar 2021 03:54:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2edd3b42-7087-4867-9b11-08d8f32f8906
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB475831EC765CE5530227D1DA8E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PrFauUKDIojpPDsn9RJuFl7u0QBaCsI1Nqzaj1BJHH1BO7lrAsvLDaozf5BlHR/xu/eDLeVx4H30aXNY1cB7G1w8tNTH1dGQCaMlWxy8MGjQW5SIetcbzh72Svm1hh863Zj6RGvsBCRzjp54oDXJ4gPjqgpTOYWcxayrjJTeFVD3h3PR4fT0+1zjsJmAnXNkMjUph1dkS+Zes79DgA91pqGFJWPJfLNdJceCL2AKKK8eqTq2s35p+BB3XpqUBJTSFCPnq9eAel+d4Z//uVZ+frmO0M97pAn8JlgKVigs03JJAJcU+VVJqFZbx8kWtc5o6tV8wHs67Ub7UxyigPiQ0b18g2hMut68e1Kc99Yw5pP/vSqYWRDRqRwm7Rrm935PryLm5opgH0caWEQHAqyOc1iNZVISjIY0TDYclAcnGA0IJ/M5rw7OzKc18AIL+TpXiKNkhwu+KC64fOu/vRIV8GGgpGBh2olq7qonvzuOXLuTrPBiJl1Nn6WuidYMcoZSsLy9Zlq+5X1aST9zJAR3LSpi7SC9GLKdJ5A4lQhYUJoKBJY41AzWZ2zrv+N315p39DTMJgqV24yWdZmYndzf79atCP/CW7PqP9u5E10FSZ8dZcwBPlbc79krkxgwAlFtZLtCiio4xN4WpJkDBsV0auZYrUbBe7z9rdE+YkJBPKuUJrocgpzRYMMGLL844O+Cv5/XghpPzmX2duvnqGWE/y+/SyywvKsw+JS/klM7N9M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(366004)(396003)(346002)(66556008)(107886003)(103116003)(186003)(26005)(478600001)(52116002)(7696005)(36756003)(86362001)(66476007)(66946007)(2906002)(83380400001)(316002)(6666004)(38100700001)(5660300002)(6486002)(8936002)(16526019)(2616005)(956004)(4326008)(966005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OVJ5SENub1l2QVg0R1grK1VIQzdxSXVFdzV4WGFYVzh4MFV5WmdFY2VwVVJG?=
 =?utf-8?B?a1JzZnVNK3NjQ2ZMcWNHSlZQZXdEU2laREhITWRTVUZ4VnVVajEwT3UydDBi?=
 =?utf-8?B?OEZVNmpVUStGampzVjAyTzlnbnVGaEppN3VRSWlVRFgvc3BqY3NkcFNzTnRo?=
 =?utf-8?B?SFR2S0VHTklDeFN2Zmd4SlhVTk5oeW04VTl3dlVuMWRob0kxcVRnWmt3RGlq?=
 =?utf-8?B?NWNmME5LNml5b0FSR3haRy9LU3I0NjUrZnpxUjVEV2JXTGhqNGkrY0pvRDd0?=
 =?utf-8?B?YXZreTViTWtjaVNMb0FkdFV5SlI3S3dpUGVRb2U0cE1oa0REQ2Q4bENxd0FE?=
 =?utf-8?B?RGs0cmVwWUlWRU9Yc2phQ1ZIaUtlVHAvN0xWcWtxRDBERjN0WnJOaDVGQkda?=
 =?utf-8?B?K0FmV1duUkhSZ29nV2VxeE5jRUloQzI4anN5b2tuNGs2SXlIUTFQUjk3U3dk?=
 =?utf-8?B?QWRJTm9TaVRxSHI3ckJzUEROd1RxTTJMN0VvSTdyYUZQaFpwbUd4SE5TNFBW?=
 =?utf-8?B?OHh0cjcrRnFwN1k3clRDOHlVbXpJK3c2UHRtTExaTUlFcjVLNDEydUtMNGQ5?=
 =?utf-8?B?dFlTWi9DU1ZLbkY1MmEwZlFVeElsYUQ5UXVFck9GNFBkN1lqeFowQ2RtUEZD?=
 =?utf-8?B?UFVyclZvb2hlbytrL2JUWDZTZkswWHI0bHdWQU5lb0hzc3c0b0R6TUVxK1dK?=
 =?utf-8?B?a1czVU03WEpDanBxZnZHSjVnRlNWRVBFUGQ0QmxCTXpmVXVkMzhMamNmU1dB?=
 =?utf-8?B?OVB2eDk3RU82T016L2lDOUNSa2FmUHFjMnY5NmErZW9qK1lQT2JRNHJKRWcy?=
 =?utf-8?B?TWRwblAwQU52aDJOekhxd3YrV2xOUjF6dUNJNmlSNDM5aXJTRm1tbTJNVE9K?=
 =?utf-8?B?SHJiL3NZaFJsTjFLeEM1RWtJaGJkZzBnbEtBQWNMSlliWnZmNGkxSG5OSm82?=
 =?utf-8?B?RExoQTY5Y1MrY3F6OU1UMXc0ZDBEZW9LWDRVK2tjbEJkNkw4cytONUkrOXNm?=
 =?utf-8?B?eCtqYlZreXA3c0lmYkpEbVJkZGFvOGJySTRQRkRsQmlUbHZMRDJQSEx2YnhX?=
 =?utf-8?B?cFBwRnlmR1YwU3g4MTJkNzFjYko0anozV3JuaFhKMTl4c004dEZaR09vTDAv?=
 =?utf-8?B?RDFjWjF4ZFlaVkoxblFoSXBGQWNzWjdtekZUODFhUlZOeWUzZkV0WUx1Yk1J?=
 =?utf-8?B?ZUpnc3pUS25KNEU1L3cwSE9nYWZXc2luQzBtQWlvMjRHV1RvT1d4eXZNRjA5?=
 =?utf-8?B?VThLTHYrVVNqWUVEZVlLaldnRlpYcGU3KzBXUEJTQTVobE8xYngyYTZrNFEv?=
 =?utf-8?B?TTlURVJpaEx5Ykw2R0ZSV0c4MGFmeTZKVmlRK2N0eHRiSTNYdGIvNDlpRkRy?=
 =?utf-8?B?dzRWSGpOZ2x2Vm14bVJwZG1ackJwLzZaakNSUlhTTjhCNE8zTExqdG5hRjlo?=
 =?utf-8?B?TENIKzBPN0d3V01odVNUSEZ1NUpSK1FYK3BoTDdwaHVqa2pHUCs4a05iQWNW?=
 =?utf-8?B?N1EzVVN2T1R3bUxhSzRlR2h2dXowWHhqZURhMk8vSTIwVlZvMU1CZVhYdzhy?=
 =?utf-8?B?cFNRdFhVZVJub0FmRnJoY0lPY3RYOFZFMDluaXlqRFBuYnZLVmlMM09vcDVv?=
 =?utf-8?B?eHI3WmJteUVYbFRSaTAwQ1BBQnJCNE1uYlN1dzBtY1F0YUxuMjNONHptc1BU?=
 =?utf-8?B?b3d4alB3blF0M3U4L0kwOGJvZVNkMEtmcHo3QVo1aTJEQXRjTzJ0UFVmWjZ3?=
 =?utf-8?Q?hm31NUBusRGOxEjLtKZIFSY7FJAbEqpT2MtABK3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edd3b42-7087-4867-9b11-08d8f32f8906
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:54:36.3129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMXa9D63fGCCC4q9EzVwofbeM1wy4xVs2jYuaN5hWs5ZgeGni2o1ZNq4QBpGR2Z2iNRGb7HVK6wEB7kAP7aXsUUuc1bxDXhkuCaZzLvqdT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-GUID: QF4IcyNbqktThjhqb3iUvw69WKgYs5y2
X-Proofpoint-ORIG-GUID: QF4IcyNbqktThjhqb3iUvw69WKgYs5y2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 25 Mar 2021 09:32:48 +0000, Gulam Mohamed wrote:

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
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/1] iscsi: Do Not set param when sock is NULL
      https://git.kernel.org/mkp/scsi/c/9e67600ed6b8

-- 
Martin K. Petersen	Oracle Linux Engineering
