Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0E7C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 12:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCFM1a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 07:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCFM13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 07:27:29 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2040.outbound.protection.outlook.com [40.107.14.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529D523DA1;
        Mon,  6 Mar 2023 04:27:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR4w79aS0ERwSxQUQQ08411jcQVxopdMvGIg2lXnia/Kl9/Q/XwvTGUOYLnIyv4vZtLMixZtoyIZNuwNDOc87ZQ0h4K4ga0A5obbqu7BzQMPhRyt+HqshWUbBDwjId8F00qk7PtU8CvqlyRMaM0MncpmE0HxDYjZLpoSkt7+t4uLBPaAec7UjsbsHYXGum5qgdviJpyxPHueqSRIORaKgTDTJGA/srByPObgKb7ncPhdbfFAhT9IMH5+4r29K38Tc2+UM17OquDu/1/MrsvMAwz10XODXZe9q9yw6kxUw7MsFcnvcZQfD5Ab3HN2cwFvVRm7Wzsgqy7eQHzgC6ZvnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/w3i5az5y9/6CVgJ+Zl2Pnqx5Lz4c7nSl+UNRU4h2k=;
 b=lnfo9Vvfa58C63F9GGMt+nefRCM0WGcvmWid9UsVWlcTJ5s29dGoph9ty9h7HxX8DskVjKiTj9d0KslNmfBOWaLHLOV6Bi9eH+cEXkUFPwo1H5Ob8Wf0yAF87miT+NIhABIOTL9li4wPh/VAofwv+RnV0EFKU9ZzdyU/QEpHnCgNKynY/pm2B1prlSN3zFl7NV/qwqKrlUQZGt9CC0ymc8cC1BYWHJmJqhAUykcf9hV4hWLoB7REtwMvV6imB3scobSt3UtbPcrc5GxlhjWkQitPga3H2jhOoYMlHJZ6jUoYDW3z/m7dkzSYaDx/R0TH6V1lBQso//gwaRT2yUQOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/w3i5az5y9/6CVgJ+Zl2Pnqx5Lz4c7nSl+UNRU4h2k=;
 b=DO+eBpiV3N/qLYHtZxc56lltjOX/KZK8TleKi2FAwq4NHgMnE66wblZ4qZ+687DLi+EQH6yFYBELL0CdR/V/MA5mjYrT3Lk4EEJJHJICSYhUFvhhPAZ9EvnVW2cuNfzHia1qQeLFBRd53cruYKmsY2pBv5Gkp+hof4Ludp1gVn8n1mgumIR4kj/dNHJ914w9s2X/aY0c20SMItYjxmCjUAMdfRWZ9ZP8ZlUQm+5UiVgy7z+qrhO9dSyJlJTJNPEHP0Vb20asU2wY4QnnCOonWj9W/jNEhKaArKgStrj3TuikNfyvGMrENf0tgPN07Jss06qRoFihFSggXStRHzOLYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by AS8PR04MB7557.eurprd04.prod.outlook.com (2603:10a6:20b:294::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 12:27:23 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com ([fe80::2ea:4a86:9ab7])
 by VI1PR04MB7104.eurprd04.prod.outlook.com ([fe80::2ea:4a86:9ab7%3]) with
 mapi id 15.20.6156.028; Mon, 6 Mar 2023 12:27:23 +0000
Message-ID: <39dca918-caa0-1f98-0f27-82b9bc2de0bb@suse.com>
Date:   Mon, 6 Mar 2023 13:27:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 80/81] usb: uas: Declare two host templates and host
 template pointers const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-81-bvanassche@acm.org>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20230304003103.2572793-81-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::19) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|AS8PR04MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: f2cb6898-093d-4f95-efc4-08db1e3e2336
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Npgu1UsdrNwqxwuC6iQY/ZpSEw8mPPE+Gc3pgLZOgY04BG9fLnjzCKejz1wfOo2r8FGebKd2hRO+YZimcgaXAZK8EA2haRa6hNTCzXJJK2aYRPUSO49Iq7+DvTDnfR8V1aEhn8CbohopPbg6nEZxE0dh2qKKFtZXrEQl8odgcDKdnvQwSQk1o3NqSXbgibTPxxe8MRPRUbdT3bTmwMF9Xe27wqtv0POZCh7Uz1nhdtRiMkRMwc4Y4pYOErOsXIu0mimBTfIlSV2kfqHMAI8RLjP6qKv+Q9e5P1hK6/buwGxEPkRPueoVSoOsMfzAyE0HVxQFGteN+ReKjg6wUhztWNQ6fMJlHMq7A88N5ijgZsw5nFvxVuvMlFPu6k/j7DQBSJFczmciICw7SgYvCow3d8ocTwMdzCZhE/rv73PzJezPuvH+ssrn9FvK5b/2bcMtJ2eMbNg2cP4PLe3iAZCTOqorIXmOg3h/NSiAPNVZvSjnbaE1VKEUoQv6eJjBp+mqa3FU+rmiIvABELc28bOUTnXWqUmEuEeZJJZq3BxC/jcicduPJVX8hQAxVResnZKW+y3R5FUfFvNhuCoXLF84UWS4glziTwgz5XGJjJ6fCzlQ27wI6kLVcxD4HfvCbtLzQqpoI7eSV5yQOb2nKBwRAYbd9JH8fr+WrdAWDvfigdlgrI7Opul9pu/xERGPWAI6VZNPgC9VPVRKL3AtlDrk37ATctMt3q/2w5F/a1FAWpQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199018)(54906003)(110136005)(6486002)(316002)(36756003)(31696002)(86362001)(31686004)(186003)(2906002)(5660300002)(4744005)(66556008)(8936002)(66946007)(41300700001)(4326008)(8676002)(66476007)(478600001)(53546011)(6512007)(6506007)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blJmRjVmeFJBejF3K1N1aEl3Y3VyWGdldlBJUDgweGNYTXpwMytMYkNwd05O?=
 =?utf-8?B?UUNHenFQcmFZNWU5OWVuSHVYZktZL01YNXlNYmZDM2tJZS9qeTloK2hRbTJ0?=
 =?utf-8?B?dURGanYreWZCS09kVE1PaW9HWTA0RVZqclpXMmUwOFlOTEpnRGExNmtqT25h?=
 =?utf-8?B?L3ZYY0dNbUo5aHpWVUhxWDRad2VGSXVXVnNrZDAya0lNUWEvLzdUK0Q4ZEpF?=
 =?utf-8?B?S1MvSVg3QUk3ZXBYc3hYSUdKeW9TaTFkRk5JVW84TUhtZmpoWVFPOEdyanhR?=
 =?utf-8?B?cmtIWmpOdzdpNjRYZ2JvRThFMHNoNnUzVThLS1FJN09vSkZsVk85Z3JIaURR?=
 =?utf-8?B?Z0VRcVc5ZVIxaWsyV2Z2b0dJTzlwV2VZSGVXWkwzdGMwcGsvbkFNVUV4QWZk?=
 =?utf-8?B?ZExWazVQZkFsbmtWS012ZGxRUE5uNWpDZmgyNlhPMTlBNzlVc2g3aTBvL2FW?=
 =?utf-8?B?Slpnb3hEUEd0R0szUC9QaUVCbUFFeWpOam41NHRmWHJnQVFrRGxHYnJSRDVC?=
 =?utf-8?B?TWZrbUgzbEE4eDFZWFJDcGhidVVJY2xERmMxS0lRYUJ6MC81czVWVi9xek1U?=
 =?utf-8?B?dmRzL3N1NTY1RUZ6QW4yYVdSbW45NmdwekZBblN6YzVJOVlOWm1odUtFOUN0?=
 =?utf-8?B?S1JQVTJlTndGVDhZWC9YbVZtVmwwbTVBcjZRd3NKNzNPcG1iQ0dCWVF4bVFR?=
 =?utf-8?B?QTlUcS9RL2Njd2Z4ckFaeEZqK1pLemNwaEVHbUppQzd5Q1c2djkyVWkwZzNM?=
 =?utf-8?B?TXBRTzVCL1Azc1J0Zk9pUlZ1QVE2c2xYcThrR2RDUzlvTkVwb3psZEwrbTBD?=
 =?utf-8?B?eForVlVJT3lRMmlzOXhvMFZFbUdDNFVxTEt3TnZwQnMySDNwOVVEeVlhb0pi?=
 =?utf-8?B?NS9CL290c3ZaeDRsMmJYb09FNTV3QVVqNUlQaW4xL0hZVGpIYjg0NmFLZU5R?=
 =?utf-8?B?Y3pldmc0NTFPV05LN21qZzNRdTZtdmxlY1pPVzNlellrSy9NK3BoRjFsRGxE?=
 =?utf-8?B?WmxUSUZ3b0VFZ0JNdys2UTZtc0tpMkM4emJUNjc3RUU2bEQ4RVB5SXZ5SVFZ?=
 =?utf-8?B?V1JuVlNJR2xRRklPLzU2d1VBdTduWHZsMjVyUzd3V3pCZkdieDJJelBEanVh?=
 =?utf-8?B?cVBhNktSTVZ5Ry9DLzV6MFpoRVNPby8vNHJHNUtscnlSNm9FVVB0R2FkMHky?=
 =?utf-8?B?bjVudU5SWC83aGxsRk4xNWdWUC9pa2NLa25uSmVjOHRHWHpmYUd1MDZzUGhv?=
 =?utf-8?B?YzNNVTJ0Q1FMbC9WeEw0NzMrODJidEhaMzFtQ3dNd3FKQ0lWZ0ZraGR4KzRK?=
 =?utf-8?B?bEdJSlZabEhJSXdYOVVFeEtKS0FDWGNuL0FyUU5XMUlkdzNKQVNFWDJZZ0RT?=
 =?utf-8?B?MzJuaXhXaGR6WEdPbldxQ0x4N2hHVEtCZmhUQmVCS3RhelY4TDV5bm1kTG04?=
 =?utf-8?B?c3VnTFloQkdOZGJtZjBKejhld014amJ5L0o3QU9RY3FYQStBUU13a3hpWnJ2?=
 =?utf-8?B?Wlg4eVZzcVgvcncxRTA1c3RhVGxKWXRlNGZxeDYrL3BscnFEbzJ2QlZ3Vi9N?=
 =?utf-8?B?ZGhWNVl5SW9ERU10eU1zUDNFbHQrMkg1N2M4YmR3Z3VOT1JWVG9zL2R1U1cw?=
 =?utf-8?B?Nkl0eW54cnZXOXM5VU5CbGFKOExLQkViOWdsSDZZOG84TUdrRHhkaEpvMjN4?=
 =?utf-8?B?ZmliVWZPeWxsLzEzdUd6R3BCOHU5bW00WnFuYmUzUkpMSjU1QlpLZDNPTzVo?=
 =?utf-8?B?SFhQem14ZStFUlN3dmNIbFZmVDF2Ky9wQkRjSllFOXZxcS9zdUN4YjVuUWZv?=
 =?utf-8?B?Qk5RS3QzVi8zN294NWJVb3VTSFRJeEV3T1BQc1lqZzQyL2R4dDBPVUhPSFZC?=
 =?utf-8?B?QUR4N1htN3BhMlczb085STB2MEJiY0JwWE81Z2tySEhzeTQ3WG01WWowKy9l?=
 =?utf-8?B?TE84b1p2bWZidFNxejZOUHlvZzRhdVhNVVJTMElpOHhJRTBqTjR3TW12TVBa?=
 =?utf-8?B?K1pDVkJ0VmJCUCtwbjRLNEFwZjNVYWc5Rm0vdlIwcHh1WFRwNWJyUUlNYkZw?=
 =?utf-8?B?YkFlUU53UVdJYVdRY01PNXptU0ZJWjg4K1VVVGFaVkRndWt6Y0xJZEl5cG9i?=
 =?utf-8?B?SS9GcjFqakNjN1dHMzZJVzB6Z1ZBRVUxNlFLZ04wV0lNbnc1citKaXQ0MWY3?=
 =?utf-8?Q?5Rosrk8BD1Y/8yBx/LW1vPQii1NpiVw/FylVoyg687by?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cb6898-093d-4f95-efc4-08db1e3e2336
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 12:27:23.3165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5rhAIOWirvuIjiNWmErtyujOtIGwWwTr157/3b/+ZLyg+81bU6uK8jIlNN+8U4ZxbT74nQ/DQh29mGj9dHw+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7557
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 04.03.23 01:31, Bart Van Assche wrote:
> Improve source code documentation by constifying host templates that are
> not modified.
> 
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
