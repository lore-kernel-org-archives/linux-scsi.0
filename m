Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790EFC6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Mar 2023 08:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCWInn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Mar 2023 04:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCWIn3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2023 04:43:29 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2058.outbound.protection.outlook.com [40.107.20.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336181043F
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 01:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4Ri4kvFXtFzBq3JqLdUEXamEcfwDHaMR1qNqQjKAL8Da5IhTXLsmRvdcD2SOpREqkND9Y2mXn8JMzRghaBXLsjFBlUyKOsYqSZzeWIZys2a0aAfidWbLQY+RRufSFXS3RujNowOwhwsqPm9IGuCCa4QfNpCHP72kV2adsutu0Kx4Msq1J9u6xzE73uEfK9/q7Zi/2z/hwpez8VNIWi+3yQ+oNMlunQLCMIQqlcOAEApVsQOIBwKsODCK1BPz5nSUi4EK+15hoIp7lE76xcI/k29RHHLSiRWpbJMeHucBVUsz6+JqysxhNswDeqsQ0SfLlUgBzyIHXrbaAhdAgIedQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eco2U9SPKARfY+kh3ME47RU2jUuIFh7l/VNG1JK8ezE=;
 b=mhZj+WpbWzPDhXAoFLdmPQj/ACMgnHR+pNA7q36pKRPo9vYVczJA3qIZIC1mr2/PJQXcXxQpv4aMGrZmvh2cHbNLbP2z6Z+/I+rdXW4QPXK/0pjSp1o8BNMO9m+sZv30pmUdw8I386DTSOShjdsee8rO4dYsz+EVmkWI8xb7o6yyeNdZKTLJ5ktpmFX8XSrmdIKh31tfRK1Lz3IrZQHuFGkyu4SyGCP53uUBTGXewbrTVXNF8/f4TqztL50dQCmsqjL/noAtc3HMlH4ZxzmgVGTg2VBCGCmKM5M5n3/TgEphvYYSowhbRjw3ZzwaiTFieWK2cT+kVtLvLJzh412AKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eco2U9SPKARfY+kh3ME47RU2jUuIFh7l/VNG1JK8ezE=;
 b=cORPAAPB6aE8nx7sgP7DmeGXI0Ig5LOps8aX57mEYFQPB/8Nir/aZjCyru7wK+eQ6rEiSnVVpr82u7x7VMKNxl9DvblxfPXglp4/meE8m5f/cxTr2hUenAAwOfY2i4QrI0YQz6ZnhcqEWXSeImsUD5HUm9OHV3hYLHJim9TseALvJKvqxTAuLf3B1ICDe4p87FQAy/cpXJYcuLtjcT4Iq7O5C9bw5mXcrxHtC+r3G63PPCEaA4OePplVBBrUYiPmgoLjpX/0AUso/llqNXwr/1oeI/AwlT5J17Eb1MdlI/fvIfDhoMOAr9i58aqkGz38yWb/QlIGBtyAiHX33hvpiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by AS8PR04MB8516.eurprd04.prod.outlook.com (2603:10a6:20b:343::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 08:43:23 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com ([fe80::2ea:4a86:9ab7])
 by VI1PR04MB7104.eurprd04.prod.outlook.com ([fe80::2ea:4a86:9ab7%3]) with
 mapi id 15.20.6178.038; Thu, 23 Mar 2023 08:43:23 +0000
Message-ID: <ba44dddf-4ebd-521a-dfd0-a2057d487893@suse.com>
Date:   Thu, 23 Mar 2023 09:43:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v3 30/80] scsi: dc395x: Declare SCSI host template const
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230322195515.1267197-1-bvanassche@acm.org>
 <20230322195515.1267197-31-bvanassche@acm.org>
Content-Language: en-US
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20230322195515.1267197-31-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::12) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|AS8PR04MB8516:EE_
X-MS-Office365-Filtering-Correlation-Id: a2be134a-e6c1-469c-fa1e-08db2b7aa934
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6VZbw3QxE29SyoGJh/i0lAkkVjCChljNEbRe3CLUjO6hy83qq63tcyDfellAKQLpOkXKvV3sXOvbvHNDN5tslktvBKRQWCIQH8cNaGp5+LzavwqUHya+tj7Io6dlIgqr91DQ7oPNY+SRMWUuAQtLGESRgGY0EWcsywWLzhDV0LGfTiXbDCSf+d3lLqVOgGrWTaRyRv/c8S2BPnhWIh7fxWuRo7Aa4g9zNuDlwuJH7QfgrhcHYSa/3my8h3Bi2/y64ZJ0hb3Tf5+e5cdBghcluoadSuwKHU6RqIFPYR9z+n+iNSuEiy7jz46iqt4K/jQMiCfvB94tXXyxe5WWfgRXZuYJddmJLVCWO8kEu1VHPAJwNONBg62lHy53F6tlH6Ibt581oS2GIzj4G3Y7ZQoeaV5zfMuhnwMc+6Dt+4uTZyN1gE9prNW6mnasyoO412/n33943RCH1ma/FooowtT4ZzWskDYgSFqj5evm4u4fW4egG6CBmVH7AV2OQHTmxqC6qp15mm5jlE6miM9g6llmUvtW/2LdKQsC3Sh+J+h/7h0+sBqYGBLceYtKGMhIF8urDvDROu1Ut7nSCPuB1wWm6Mx0iDrdSZUL6AyCeufWyhH4xny8fD1EP8PbrdwBxb0Rp/CqpZ3VKI88duV18SvYIxGiLO35n/G0xf9Z5Ein+zpA3kaszbxe5qS3TMspSnKJCXoUfuzlyrkFIbcjakfZ+H50LbZ+QdtEFNrEBQq2tk8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199018)(31696002)(36756003)(558084003)(86362001)(38100700002)(2906002)(41300700001)(66476007)(8676002)(4326008)(5660300002)(8936002)(66556008)(66946007)(2616005)(53546011)(186003)(6512007)(6506007)(54906003)(110136005)(478600001)(316002)(6666004)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amdCUmRhcGxGaTlkajcxM1Vad1lKU1VKRjMxcm9HMElhQUZ6dGkwK0d5TW03?=
 =?utf-8?B?bFBTaVE2NTcxVXVRVmEwTHNvYzlwRTRicHRkaVI0eGJaSmNHanFVMHRrVzZr?=
 =?utf-8?B?c0kvQXpNcGZJNTBJUjI0SUhFWXB0OVpncm0yaFZsUDNxMTNJdkpVTXpmZHhB?=
 =?utf-8?B?d2VqcUpBUkd2MzdjYU5LRWd1anh3eVR1NTJ5RFZEUklYMGpQQXRKaUUxSVdV?=
 =?utf-8?B?YnBqaEJZeGdSQjR6WE1kUXludHFYbFVzL0Y0T2ZoKzFnTEozSyt2WVlMUlRH?=
 =?utf-8?B?YmY1eSsySmRjRytxaUNlZjd2NDRoZkpsVi9Fb2QzL2hjaDVnWjhzTWVwUThh?=
 =?utf-8?B?d3lnTkRxcVM0ZzJkckU3M0tZVkNwbS9WVjZlYzZyNlNKSVp0UkxzcUxlWkt6?=
 =?utf-8?B?UERoYUdoeFFBNHNSUGM1ZEtGeDVOT3NhZkRPbnFVbTVlMGdUOHdLUVlyc3ZO?=
 =?utf-8?B?MlcyelRKTDV2TjVCVmFQVE1HTXZxQ2dLck85ZFNrUlNab3E5UE05VnBvMDQ1?=
 =?utf-8?B?a1dneHhCSGNvQldzdS9SODMwY09RQndiVitSMlBKbHBBRE54MUU5c29kTkFh?=
 =?utf-8?B?RDlwL3JuQzBwd2l6ZmFSTVl1TXdUV0labDVwUEhnRDFMeitXRm5xdWxQaFBo?=
 =?utf-8?B?NTk1dUlVTWthUldmNHpNWm5qMUdxbXVJdHVDdEpHWDhmYmViOUhDREdwYllq?=
 =?utf-8?B?RDFYVXEvczBTa0x2bGFqVHpOd0NxV29iSllnNGZZZUJsbGpQTjdEYThrNmhO?=
 =?utf-8?B?RnBxTy9wNXdmUTNURFA2dzRqSzVhWmNLcFNUSy8wZUVBOXZOSU9UVElPTWk1?=
 =?utf-8?B?bmFTYWYxcTlFSVQvTTRNdzY2Q3RLUHJYQWlsSHkxSHpMYTU1NDQ3UldSck1i?=
 =?utf-8?B?V2U1YUpLWXNCeTZSQ2NCNm8zNWVaekhNUmVNUmtGUmJDVFJpdC9wQkMxcHFw?=
 =?utf-8?B?cG5NS3Q3aGZXQ0RwWGRZUUdISjA3RUQ3dmNSQUlwMXZZRmViSlVabEcxWk1t?=
 =?utf-8?B?TjBDVmtWcmo2MFB5bkl5OXVOWVpRQUFoZ1VsQ3FkOEFVbFJoNVplcWNNNkwy?=
 =?utf-8?B?ZXBVRmJ3U1locThTNXZxa3paRENTS0tLZWFaQXVaUEdncU5VZWNwZ2NncVlM?=
 =?utf-8?B?UVM4K0Q1R2dCNzc3MDBhMExYc2VnSWNaWFNjc3FPb1UwU2xCamVnaGo5TlBE?=
 =?utf-8?B?N1p2dHRZSTRtenpSZzdrcVU2bUNJTWFxQWpHZ3VxRGV3a0hmSElpUW0xT1kx?=
 =?utf-8?B?ZThvQi9Ca1ROQ3B3aU5pWlE3SkFEQWFEMFh4WFNXdTJPVkVscGx4dTIvUkF6?=
 =?utf-8?B?VjZic1JhUmpSN3Zvd2wyNG9xUDVOMnVVcGl1QlV5Sm1XZW5ZamU5K3I2dnhB?=
 =?utf-8?B?cjhDWVI2T1cyVU9IY2h4b1lpSzA3Zk1CUnlnK3REbm1kSFVnT2xlT2VJV3lG?=
 =?utf-8?B?VmN4RlBVSnVVNWxqSkJzdk44VGRmNVJJR2ZNUTVZZzZPQmJVVnBwYzRaRUJh?=
 =?utf-8?B?UEFYeW9IeldVUUhTY2xSeDZWS1ZIbkJYRENDZVpvYnBvMXFrNXpPYW9YT3lX?=
 =?utf-8?B?OHNHTkkrdmgzd09LZlR1dG40UG1kbkRKenl1VUZTb0pkVEY3ZHNzVFNyVkdK?=
 =?utf-8?B?Qm5zNmd6VXFoYkJCcWhSeFRsYU9naTkxbytSb1VGNjNWSklBd2hOdDRSMjZ2?=
 =?utf-8?B?bEtHQVI2SGt3a2FTY2R3T2NDUzhNb29xTWl5S2NFd0o2YXUxbVhLTkJyaXRS?=
 =?utf-8?B?VHVwRlQrNG11QmVaNGwrTGFTWTRRNnV6TlNiOFRpcVd0NjB0TWpCa2RQWkpF?=
 =?utf-8?B?YWdlZlUxdGx3dEducHoyYjhUV2lVVnl3RkpMRW5YaEUrQWxFS2taY01KTlU2?=
 =?utf-8?B?bVVZdjZxMnhkemhKcVo5MHlZN29STnE2WHBFNlB0ZHloT3NFbTdxcEJBU1VC?=
 =?utf-8?B?ODBCTUZDMFY4K3B4R2h1NnV6Sy9rWUVOSllseTVUQk5PSzFjdkdveGFiWGhD?=
 =?utf-8?B?Sm11SHpkK2ZHSlVwOFRRSUJ6YkI5QVhxdkVrOEw4OVgzQjBTM21Rd1FKaC8x?=
 =?utf-8?B?UkNyN2VLeXJ1ZHJSaUNka0FJR1g0Mm1YUDAxTGx6VW1jWFZBeVdXRDA1aWE0?=
 =?utf-8?B?Q05uTlE2d2dRdlZPWThJS1RweWducVNZUThzL1E3MkZjZjh6SldWV0tIelY4?=
 =?utf-8?Q?BZ+W04//AO5FFZZL/nvtsdDK2DM/gS4tmhDMsNaYu1Wv?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2be134a-e6c1-469c-fa1e-08db2b7aa934
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 08:43:23.1332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgCN/x8Z3KKFfDa1BaZ8Qy+3T4EZFONzQkYgLOU/hJWu5G/cPawGmlZDHbHrLL31EzH1wbvZYAHShUPqL4wirg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8516
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22.03.23 20:54, Bart Van Assche wrote:
> Make it explicit that the SCSI host template is not modified.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Oliver Neukum <oneukum@suse.com>

