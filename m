Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C5CC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 08:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiGGIBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 04:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiGGIBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 04:01:12 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2044.outbound.protection.outlook.com [40.107.22.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FF52BB34;
        Thu,  7 Jul 2022 01:01:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYxxGriZ4WmzoKtLLgEQDdmsKpYhIFIweI3XuoUM324skJtsiBYnT0Orx5jzNS17N5djRciM5LFMXplAxd6G0Z6cSqWkBRhPmPdnl8+v9qZGA/GedvrFFhQDJEXHzFBRUEnqkao+RqRBWCi4nwyp76z2fCk5VvByF7C5WenmKrpo3SX0xn6edx2z1ijjq/xKfYPCyBGBS+pwjA2HK5HQO9sVwMG0WEiMN37GGuLhvunHW901aJkZxkO3WapcDNmoFRA6ShXKy9TAuSdsCq2ScO6rH52NN0hMud7GKTXt8sYYEteZLTowVWlV7Z93+qPExwv3BhyqS/6hCmX+lpptPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPDh8MB1ZF0TBlrJqrjL1CmqFvNe6NtCbwcV+r/1jAA=;
 b=XYKnIK61TLZuK7QLIIfnoJDEJYMHtP9HA096+WTdUSDYbmZVozwpEsyR9K5JRtOrQ7lIOU3q0tt75RwzYKsjGI5/KFcxa8mgxU+riPDiJDXeoSJCRV+JxnGrrGup8GzsGDDMRYfOnNauPfqrhltlrdo7iRzbbaujug2zuOv9WNyJh27Xb6uFX9v57POvxkfXstDFoxCDgp/pnt9uTiUVekQTvkGjx2LZHane3Nir3nrLGJI+Unur+n5bmDch4BrnTbcvZmdfrcx8JpYun22I7d4imARCOHeVXpoVNch7Jj10JqfnysbDPxD3Cd+9W4kUnB1/UyB6GBCmf0BGQpZStQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPDh8MB1ZF0TBlrJqrjL1CmqFvNe6NtCbwcV+r/1jAA=;
 b=WrysdhZ4nZRbUIjxwb3D/PmcW9ImbjL0wEMSDnmS5A3TEXK5+9xln6NGJkHYAjCQxOBN54uBdco2e/nrPlyPFovBN6y2VsZqWFRsBnAxm7gFSavGrWMUICqP7awQbaAAWzWxB+jj6PuX409K8X9MjGaKXJAWS35KtjNT8fQM6GxYRUxKnTmqWlSv6C9Z5DivtOGGowdLzewcERc98UES0bSADpNQvMd47epSf6VSpWaoqM8m4b9u2sTbh3Z0GoHsAvT5CKA8Cr7fMFzwtvY2mDK2lsQRBn4+KWZdKBbF4INuYTx2F/7lm5WTVWrbKnDAx6Vozx8yxoOwNdaX/4AtZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM9PR04MB8439.eurprd04.prod.outlook.com
 (2603:10a6:20b:412::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 08:01:08 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 08:01:08 +0000
Message-ID: <2ab8a2af-a3f0-c67d-13db-a8b4efe797be@suse.com>
Date:   Thu, 7 Jul 2022 10:01:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 01/36] target: Handle MI_REPORT_SUPPORTED_OPERATION_CODES
Content-Language: en-US
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <118900ffaf094a279f7799ac9d2c73265c889121.1657149962.git.Thinh.Nguyen@synopsys.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <118900ffaf094a279f7799ac9d2c73265c889121.1657149962.git.Thinh.Nguyen@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b::11) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4256846-fa92-47b2-40c4-08da5feed999
X-MS-TrafficTypeDiagnostic: AM9PR04MB8439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2DwlfHQ/lYoUabm/wnxwbggeV7p51/jRFmL4TbH+ERmtz6zxIm29JnKInKc/oXQco3OdtRpDeRiMLhoZpzjiO3PXXHHrkFJZ+xTWkdlFSfLwv7iUCPtxeeZUTX8tQRpOwzzr4FBYSrwwjVi2AhUldbvyE1RdvXBJ0iCBOycUXpaqw2G5G4rdwlYvw+2dVJi7nLk/bXy6siRM682SmibK9NM5RujNEDSJOzmxXu989g+/epyX5SEDVBObSWQe783FCyAfFTCbpuZZE5eUY9ZcG03trlPJR54asOloTxndq5qoUY9JhhydIY3tHwYhNXYWpC3WT+TRKYMTyfUmCOr4GnoA6jfbyTvG84J8MFahmkHHyrt5nVskh3QGMAEBC/cigzX5ffhU4bXlZJRcUnFaJWe+aQeeJjMvGDS9TBYJcByzSRrW64qOGSjWbsL6cJ+imy3fFcrKivdCuVcTU00uYrc7egxIANGDaUHNpzjasofZ5UPjklHsWkJvmK+neCNd9N1GSNCHYcsJZ+TdDCrihawWvuWljTQ4b8WE44Tz9qfZWsSMlZdgviHtc3CC1UJMoFT4T4qGyyZgahCn14bbCtzTDFhufIQkspD3QzyIorVK2aZiO80fmUTkWZ09jRJe35DuSkKKs8UIT+6GsLMV9+uLaHsAx8UceBJkTjjC/exbryFvJjDHQ30D4pM7bCNbKi9IENUieQRN0K2lYJhFcY81qBSljrFpSSmH6JryuuRykcxGwXpWz6I8sgm7kKSbTCiTaAiDH1lZRDQzQtpnyOM3xAi6j409v1HD3bvv/Tscgs769DiYWIr1BdBu8MFO02Nao/TVn/PHPZ6nQz8rgaWYeERQcK3nekUZV2xgSrU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(39860400002)(346002)(376002)(5660300002)(186003)(6666004)(2906002)(41300700001)(31696002)(4744005)(86362001)(2616005)(478600001)(6486002)(6506007)(8936002)(110136005)(53546011)(6512007)(54906003)(316002)(38100700002)(45080400002)(4326008)(66946007)(66476007)(66556008)(36756003)(83380400001)(31686004)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODJFVDczTFltTGVUSDVRVHNaSERTWlZTNGxmbTJCQ1FvVHc0WkpqNVpLOEZU?=
 =?utf-8?B?VDVaWjU4eE1MRGE1NEVMRDlWZ2dDa2poNloyWTl6TnRTUkxTVEtKRERtK3Jm?=
 =?utf-8?B?R3BOQWlkZmp0VTAvUkpGaHcxNUdwYVZ5RGpuTG1rbUhyODIyUFdaNXh2R2JH?=
 =?utf-8?B?V2FhVXg0WWxHZUdDcU5ONUhNbUdiSDg1WkJlcXl4NEh5ZXkzcWw0VDNXVzA3?=
 =?utf-8?B?THpVRmJDdjArVm9WZFV0SnRaRk10N2ZwWXd1NUhVTTdENjlRV3BXUzFhUVAz?=
 =?utf-8?B?OFNKSE5kbVdiMFA3VUgyVStkTEhqOUk4dWVHUkpvUHkrSmxsTVpPbjNJOVBS?=
 =?utf-8?B?ZFZ2WjB5OUg0T3A4aXBzZzVacHhydkRrM2dLa2UxNnFpa0pUNi82REVrMnNi?=
 =?utf-8?B?M2lwR1RjQWZONHI2SktBQUhQdWZicVVBcmk1em5QbjhPQXNmOHJzRjRxUUlB?=
 =?utf-8?B?blBYL0k1RlRYSFRodmtXV0RnVXF4a1VwWDd5OW1CRDRYeFhaVThtWDc2Rnk3?=
 =?utf-8?B?bWdiOFhOY2REcFNHUUhaRHJ6OFRRZUplaVE4NWtQTmUxMk9kb1lJUXllZ1Zj?=
 =?utf-8?B?Rk9qVTNmRzd0WTgwUUtUcTlIZFkrcUkxUlY3NkpwR05KeTMwOWhwK2UzTFJU?=
 =?utf-8?B?Rk9VNkhlYjlJYjIraHNISjJiZjB4WUw3cktFM0I4WlN2cGQyZ01kcWJCdGlI?=
 =?utf-8?B?RDAzK281SlpWTlY3VnQ5Zko3NjR4amN5aXJwUmIxN2xPZkYzNzVzSGpiUDY5?=
 =?utf-8?B?ZllIVjB4cFhvRUQzQzhUd2FlOG1zY3cwVXVwY2tIZkJxS1BIcEMvQWpRYUZh?=
 =?utf-8?B?VHFkVUxCbkg0Y3g2b1JFUXJNM1A3enRVKysxbGVHOFZsMi90UVNNUFFsNjIz?=
 =?utf-8?B?NmRlbXhvN1RWSXhKRWFuWG0zb2NXTlpCTFJ0TG0vd1Z1dURXZ3lBZ2RvMENx?=
 =?utf-8?B?UWVHWFZSUkE0TzN5WEFPUSs0eW56Uk5EOXYwZEMzbmMybUduS0lEMjA5bUk1?=
 =?utf-8?B?cHNUSGZLRzNlM040NURFWGNTUm9qTGYxemdGVmhwalgrT0ZQM1cwdW9ENE83?=
 =?utf-8?B?YVQvenYzMThaRlNmTHNPOTNKaUVOVlVuK2hYbmoyUmRMc2o0R3dHcmUxaTY2?=
 =?utf-8?B?bHc3VnBJNkcxMnUzRUp0RlJBTjF4c21BSlVjNzRUaVhVTE9PUWRuWVFSaFVJ?=
 =?utf-8?B?SFBWZ01IODZuUUIxdllqTUc5S1E2eDhXOGlrN0luekM2UXQwaWxOdmdvNDdX?=
 =?utf-8?B?Ymg0azY5dE8xRXFWSDJXYk0xV2RLeXpqbG1mWVM1UjNBNXNNZ0ZFTG56eWZu?=
 =?utf-8?B?QmRkcjYrOEJQSjd6bFFwNmF3SEladThxTThXWlE4TGxsN0Zlam5pRkZwUUw1?=
 =?utf-8?B?enhuWUNaUjZXYWlURXczR1dQbVpmdS9mbngzTjh6VzREamFtN1BFcWV4MTdi?=
 =?utf-8?B?aDF6MnhPRStXZTZnTEc0TytlYmhmV1lUdS9ubkw5MENJNHUyMFlXaEpRN0gw?=
 =?utf-8?B?eXFBVHAzd2pZdm4rZnc1SzNnWVoydEdjemJIbzRLOVB4Uy9GWUhxZjhUOUJp?=
 =?utf-8?B?MXpzZWJDZHBHcjBYWVFvV1VadUk1dU9qOVhuTzJBYUZpbWRIVndHRC92Y3N4?=
 =?utf-8?B?aTlmSHhjNE9HYktCZFY3ZVFNS3ZHREx1dWZNaEdCcVJOTzlxLzM5VmEvMEt0?=
 =?utf-8?B?RmhDb0xGQ1BIcjN4a2lsUytaM3M4ak9rd1NCTzVTN1ZSUEZwM0xuQm4yRkhX?=
 =?utf-8?B?R3V4MGc2YUxTUU53bTFWbXRZSkhJM20xWlMvbk9yZHFmV01pYWtjS3NvblFi?=
 =?utf-8?B?ckxaS3FXUXVPbGpWR2VFSTRiWUJrczBla1hEcE1aK0JoVHBLRU1PaW1Ra05q?=
 =?utf-8?B?WmxxQkpoZ3JEdklRSEx4cHoyeUExTkVMZysxTzZudnh3MUFISGR3ajYrclRx?=
 =?utf-8?B?Yy9TNjFZcFlRS2ZsTXdxb3R3ZWNEc2VoTnBIYktDcDAxS0x3NktuQVlPME9P?=
 =?utf-8?B?YmE5bzB3SnZJN2FkMFF2MFFpQnBZSVFhS3A1SFU5T2JaMU1hTUd3cmU4bmhJ?=
 =?utf-8?B?d1htTmlPTUd0OG9Ca2l0VHI3OUt4cnRxa0NpUTRQREJ6VFZmNlZwdUdxNlAw?=
 =?utf-8?B?djRHRU52QkRkT3ZIbFUrZEx4RXc1RzFrdDRNeTcxMkJZVkRqU2ZiRzVZRHp3?=
 =?utf-8?Q?IpEIgN4wScbi+XgGJIIwn8eTlB7M0qvxfDRX9nS/V7xM?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4256846-fa92-47b2-40c4-08da5feed999
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 08:01:08.5932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yjauSaxTyQq4eTpP0aUKCBTihVLqTBqPW2TJvmPciYqlDEEq9laUwnHX+WhCzrv1yOwcustpZpAT21+MHn2CDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8439
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 07.07.22 01:34, Thinh Nguyen wrote:
> Microsoft Windows checks for MI_REPORT_SUPPORTED_OPERATION_CODES. Let's
> handle this MAINTENANCE_IN command and report supported commands.

> +sense_reason_t
> +target_emulate_report_supported_opcodes(struct se_cmd *cmd)
> +{
> +	unsigned char *cdb = cmd->t_task_cdb;
> +	unsigned char *buf;
> +	u8 supported = 0;
> +
[..]
> +	case ATA_12:
> +	case ATA_16:
> +	case VERIFY:
> +	case ZBC_IN:
> +	case ZBC_OUT:
> +	default:
> +		break;

Why the NOP here?
If you want to document something, a comment
would be nice.

	Regards
		Oliver
