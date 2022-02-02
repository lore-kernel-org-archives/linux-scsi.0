Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2958C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Feb 2022 08:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244609AbiBBIOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Feb 2022 03:14:41 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:36810 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240053AbiBBIOh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2022 03:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643789676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JD1TndRU/pm3eTspMFhypMgzmtbMFOj0fEQRR/FbSYY=;
        b=cn5L+XlazZYJflFsDvpmqN1DSo2zwD1gZyyE8Y7VWxiGHOwsOBcM8PIht98REctCAEoTfU
        ZjrIhh/2pU64Wu3/vLlHRaj0Yl9R3r0CEThcU4pjaA1dR9frAjf12fJVbMXbJY7SU7599a
        3q7agP/yE4x8mELbaCQSZDzVG6oeoSw=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-6-_td0PladNPanT-vlLCLOMQ-1; Wed, 02 Feb 2022 09:14:35 +0100
X-MC-Unique: _td0PladNPanT-vlLCLOMQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHPF6Vm4GT09QBi8JDPLlpoyUDwUHaXJcoMVfOTwz9JmauRyD70ZVZMPQM9RtrAPzwf+OxElIu9+vVf/MXq83uPFK57UJccCZN80srTjz1/Q4SvXx6xFGkHRjo7nqgwjsoFUYl2ltyFKZ6ghSomE2zUhUQrcscdAD95qLn8ECe/o18/oe4pGEVklyrNJh5VtpGX8GJvokIAd7CPhGPKRXbTeftY1lK+3WEvarEZ+nA4BCdThH2EPcvz8JR7lXQXcz3TgjYZkEehVmHaUP1CJmFwbTFxc0W9dTF3Biiy0o9FfI3pB3qSDjnpd0oQbg0W1nLnEC/qrVyikcZIfZme7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JD1TndRU/pm3eTspMFhypMgzmtbMFOj0fEQRR/FbSYY=;
 b=bt4Mg1EdNGxiPui8X1S2b5peK8ScOuSXaoEAsGN9PcLDpkcJo0ADGYxOm92zrE6cKSQydPVH/NUTT5HlmecThRX4bENEMwgmcRTBw3ZMw16fXjBjqpSM2mcqZ4kgX8KEOOidN06Xg8IVVYTGfOhde14NOwxssLu2/2CC9y62clM1hR1cZPBT0+v3fZZihzRB9s0Te28kgDSMGMepyJ2UbnZeiJfO4KSlBGn+tuhuzF5YJGyXTs1vBOXpknuP8s5S5NGwVouDNKOy5u465cI2FXGC99HXH6jRNtS8mG/eK6uJ1/AgWw8DeQMPE/+qaKsqgb4sNz5fA5vEO9QOYBmpxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by AM9PR04MB8537.eurprd04.prod.outlook.com (2603:10a6:20b:434::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 08:14:34 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115%3]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 08:14:34 +0000
Message-ID: <ce08a7f8-7ac3-9fd2-073d-a6b212c3e55a@suse.com>
Date:   Wed, 2 Feb 2022 09:14:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 40/44] scsi: usb: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-41-bvanassche@acm.org>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220128221909.8141-41-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0329.eurprd06.prod.outlook.com
 (2603:10a6:20b:45b::35) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f14f8f3-8476-4a47-4177-08d9e6240bc1
X-MS-TrafficTypeDiagnostic: AM9PR04MB8537:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM9PR04MB853709BCD9500EB737C1BA9CC7279@AM9PR04MB8537.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tqDmfvcr1yGW+p1BgVJt6gu0HRR5Pr8aRgPtuB+RGL60yziGvLp4UQ3xwvW3Qw9ySsUvkBIF/tJqU4oLBsnzbFjsN1YxzsO8WTCySf7ZKcl+8vCLkhzJeaWs3OBg6rXyGkihb3FUv9wsJ9cDLZlqajyaTQ7RgrQrg0hqbP7p2xwxtUZk7bZPF6dAU9e+nkUBEYYOW+okaPZF/LeD6agUhJgIBNM4/4D5izkP2WrNdM8X6gM4N87c3BBwyO4xfaV7STqHpI/m4FoGEImKRKBEW9v8SXl6Fx13OfvYQUZbnEEWPDLXY9oI+iUwAO+UMcl4KC4hLb33kz/EPbna7QYre1bOYrGoWjJGKvFNeEhfsytoxZQx97o06zUtpgJPHxw+9e4pAjkkFEX3pJPAr4spIYgiY0ThqhOCZEFRrj6owimATCk7yDyMCIYIlqjmRZmUpVbfLDEzNHn+JCRTpc75HF4tddRzDlFSV8X7VlUpao4MsBBZro209IiGMeiv5Aif1801zPoaZSz7KR0HErxxV+V6FWDF54w1IzyNDUnaQvV0oa4YkLCWl5Oks5nmb38vDUYAajIicP87h8SFDoDF9EMb40fKnHWjgiQ7aIU+vRaD42z/wq4/9FOqE2M63Sz/jCJ38OGkwRKANf1IEKg4ZYx53cwMjQas4nk5g+erq2suUSpMBccQ+V+kzJ+yi+RdzPGE6746WjIlOzOu1r1AQNQduJIm3Wfl3hfGuOkqEfM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(38100700002)(31696002)(4326008)(66946007)(8676002)(66476007)(8936002)(66556008)(86362001)(6666004)(110136005)(54906003)(6486002)(508600001)(316002)(36756003)(4744005)(5660300002)(186003)(2616005)(53546011)(6512007)(2906002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVZKTFNmRFp4SVNTaWdoSlBWOTRjR1o4RmFUM3R3Wi80aTZLcjJ5K0ViMWlI?=
 =?utf-8?B?QUpOL2FtS1ZKZ0I4anRwck83MmU0TEszZm9ZTCt0VVA4R1JKY2c2RjcycWlz?=
 =?utf-8?B?ZnVBaU5BZVNkQU9DYTR6RjZpNFJYNGNNQjdVeHMwaDN4eU9MYSthZ2ppNkJq?=
 =?utf-8?B?RFhBTi8zOTk1UWxvaEVhT21FQlMzNlBBRmI1ZGhyVVlxM2p3c0tZWmw5cjhh?=
 =?utf-8?B?ckFad3FVTW1CSlIvdVR5WnZMUWQxTUU1UGNuY2t1NFlXY1dpYzk3bERUOElC?=
 =?utf-8?B?K2FKVzVlbXB6WlJWNmJCdGV6dk8xWHZsMjlUUVRFb29meDR4bEdsWDhTcW9F?=
 =?utf-8?B?ZnE4aDFEUkZzOGpjZFBZNk1wcGNhUWo0WjNOdjlFQmJuWVFLdit3aEU2OGZR?=
 =?utf-8?B?cXZMc1oySC9tSGJ4dGlnNmgrNzVkNDNndlN5QWd3YkpBczFGd3pSaUJhUTZF?=
 =?utf-8?B?VlFoaFlodkpmSG5LWGlpN0NuVTkxdzh1VlVtZW81R1dUNGVCUjFlRVp0UU5x?=
 =?utf-8?B?cUtGdTQ2eWZRbVlQZHVWMlE3S3E1dVZ1bDBOUjFzalBOQUxCT2Z1cng2THAw?=
 =?utf-8?B?SmJPK2krTzlVTjNqazBIbEpPUHhjWkxaSVJ3cGNTYWJuLy9HOWJCemJzY2l3?=
 =?utf-8?B?dDdlTmordzROdHBVc1VNUjBQWngrUTJxZnBZSUpkVWQzNllEcEwvY3AwTGF6?=
 =?utf-8?B?am9GVGtSWXZnb3ljTUdEU1hiSmVnTmxOVWtWWHY3OE5uT0JVVEEzL014aVJN?=
 =?utf-8?B?RWQ3U0VJbGo2YnhzUVppcTdpRGYzQ1hhRkk5eGo3RWNNc1drTThmbEQ5c1Ft?=
 =?utf-8?B?QitwK3g3Snh2VTZJbUs1cGwyNzgweEQ1cW82UjB2ZE9WaElMd3BKWGhoK1lN?=
 =?utf-8?B?OEFTeE93cHUyZTJKUEltM00rR3pOY3V5T1kyQzFMbU5veTBZME1MZlFzNVNQ?=
 =?utf-8?B?aVJySFc5VVRFZmlmRVN3UFFnb21NSUl5VnAzNW1MOUJHb2N4eDBwTW92WVFv?=
 =?utf-8?B?OUZXWWhCb2Znd0tVSmhEeHdpRTl5RjYwRFo1TGErMkVLNkQvdURtYjBNdTdK?=
 =?utf-8?B?TGxPaFpuSXplWnVxU3IvMExHSUN2TzlsakMyUnRhY2l0aW1QOFN6TXNvUmJJ?=
 =?utf-8?B?bzl4MGM1UHZWMzVVbzBGT0kvVlpNWWhxcHBadGhhVysxK3RJTkQ4N3JNcWhi?=
 =?utf-8?B?bkovMHhBQ25WcGZxcXlyYis3b09DMWhjNnhlUzl0ckMwdE90THhOQWFFQnoz?=
 =?utf-8?B?Vlk0OFZDQlJROGxraldPV1FPazV3cE9jT2U2aWxmYlpIR09UY3pIZzVzaUZ5?=
 =?utf-8?B?akFMbnJhTmtSbkxaV0RUcXRWTXVzR3JFQnNMMTFhRitRNnFqeG1IMFdtS05R?=
 =?utf-8?B?MmN0SDdkWW9reGhXWUN3bVhiejE0aGVNWGhwQ0hJMWNpZGxad3RxbUVDcU1v?=
 =?utf-8?B?dVRkTS9MU1JWWlhUK0FXY0NuMzhwVm83L3ZhaHNPVmhzeTFZUFRBT3V5L0xh?=
 =?utf-8?B?eXM3SkpKbTl1UCtzNmFERS93eUlxV2pYamlqS01aSHo0b0RvazlqOFBJbXlX?=
 =?utf-8?B?bUNpK1JtYUIxWis2Sm1wcmxhbU5PY3A0Ylp1VnJyT01wcWsvN1RmSVNITk1m?=
 =?utf-8?B?ZDYydkRUTHc4YzJHZERTeHlVcXovc1dSdDhxUm1jblBNc1pvTVM5VDhJc1pP?=
 =?utf-8?B?Z2o4MzZMV1lOanhhQlNGTTZSVlhpNytpZ2pFdTZpRzhSU01vZXlaOVl1dWN6?=
 =?utf-8?B?MW4zV25nS2F0QU12SlY3ODhVQVc2ZStvN0JZSHpyNllQb29SR21iSkljQjln?=
 =?utf-8?B?d0I4MUtFL0N6RWtkRFhxaFc0M3JVdElQS0xsVFV3VGNOeEc2bThsN3dzUWlv?=
 =?utf-8?B?c0dhdUEyWFltQXUxN0xGNmJrVkxHMGV2c05TMzQ0TzlFOUZ2dUxwVUdLTnp4?=
 =?utf-8?B?WHkvMFZMK25CYlkzVDdtTUlqQ0YyQ291UUZyN1dndkt1bERnZGJ5ZjdhMHpj?=
 =?utf-8?B?UnBvNzVtdktGeklhejlsbXpmT3FCc2plOWJ2VTEvaDBoYzc5bUJsUzdkbi8r?=
 =?utf-8?B?cXBBQkgyZHhBMWZNM0plMFVYNnRmTGJ1U2RVVytYaEU0dmsvMDlXUVY4Vzg3?=
 =?utf-8?B?UlY4OWtUazhVeGYxWkRKVFh3WTNUNkk3V2txT2hBR2tiWitEajFPQWVaaXhv?=
 =?utf-8?B?ZlQzcTA2eXhoUzRpS0s1WVlnYjZ1VkFQRFVjTG9SQU5FMnNycGY4UnQ0OElk?=
 =?utf-8?Q?IlBLI36Y1LV7me58HVtbm4FnTZlm86GGBsg/o8L95g=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f14f8f3-8476-4a47-4177-08d9e6240bc1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 08:14:34.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: palQXesTXB6qd66dCw+Alf3QPUteaEnJKe+kBu3+8wyE4QJOFj8fx+XuemSAL9+IBRdRozVl2byOcrm4CZOd2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8537
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 28.01.22 23:19, Bart Van Assche wrote:
> Set scsi_host_template.cmd_size instead of using the SCSI pointer for
> storing driver-private data. Change the type of the argument of
> uas_add_work() from struct uas_cmd_info * into struct scsi_cmnd * because
> it is easier to convert a SCSI command pointer into a uas_cmd_info pointer
> than the other way around.
>
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
>
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Oliver Neukum <oneukum@suse.com>

