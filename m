Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A417C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 08:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiGGIZ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 04:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbiGGIZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 04:25:24 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00050.outbound.protection.outlook.com [40.107.0.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2466CDBD;
        Thu,  7 Jul 2022 01:24:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mi6ENvckCn6qD7zHnN3Ln31FEpKuVMi8nqylU+MNRIjL82+nKWhE9qH2eXd3Ni/8OHDoaMAFJROh9RYbpidj7li6X3axXW5umbH0DT2pfxfNvhKeTLhVOl8eEJoX2EXjmfO+ztUqXSlNS1KFk392y+KSYVjAi51775cxDWRSfAIZqTj5T7w75U5ZdXepCsJTtbzmOAZXbr57xXaJdoKFsLeWfaYj/raqNhuTDf6V0ypWp+r8ss8EhTMtsZoDT6RElG2L2pp/J1OlWop0H0pfYGVY4RCNIuZkJxRDQcA/0aULoYABSAs4642vrHes8pZ75B67phy3c8NuIk60mSWoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uImIaEsBXwBdxfR4EuOqhVYEMPnxA8r9mF2/rRXOrGA=;
 b=BL45a4F7yk6LeEcKl+8zac4QyaCpwIni3triojWD5bc1ttHjkuznMU+myVFzIESKhyegALhJliGubO2bJXSZ4czdsdP7XEz+EfKEEMIdCeGkiaMUgCEUaYjk9cR0Ni+9jc1BToFFa3r+0BuSupZ8rfBrU08gZKCHdofsZU3H2rYTaEeM0h+/1FyjQo5//l+N1ogsvYo7zFuUNVReqmzth1NdGBqOs8Dj56MsIQ4Uj9itijqy5ihnnxX5T4WbyVgMDRzy4l3g/wsvrJ1Rm2I2TJ5aP6FL4laI9ua9SYitk7eFelTnnb5b269o8uJmX4B4PiE8Fd/soOh7uTGlPRunfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uImIaEsBXwBdxfR4EuOqhVYEMPnxA8r9mF2/rRXOrGA=;
 b=TNO9/Dc6E46RgzaBLKGEhIbSUOR8C/z3k+wcWbtybwALu5H2QpSBeKuiemIOM60CEgeQiAdzrK6hp1XNQ3DygTewaMfSEJGz6OJSn3/pSbi6D1Op3tMdHmn/il4jgdAZ79IQ1C9IvQzjx/EWJoqnNClNK+GGqNC6/6mqkvoSzFCJiqfhkV5Ab/YDFN8B55lIpVWkueOuv4aphxRjJLb8NUK7WCsvYv9CrePeTYCITmMHfizt0V3IbCfzFnUIDQz6Pa+j6H4pevxdn4UnUCLqg1eEECwmylJOf+9NpUzo54w6y4MoVCV0oOZKk4bHoVeKoXPokiyAycxKAVQHJ/rijA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM0PR04MB5075.eurprd04.prod.outlook.com
 (2603:10a6:208:bf::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Thu, 7 Jul
 2022 08:24:51 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 08:24:50 +0000
Message-ID: <c0506189-e36d-f7e3-8a5d-71adb2d6dc2a@suse.com>
Date:   Thu, 7 Jul 2022 10:24:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 11/36] target: Properly set Sense Data Length of CHECK
 CONDITION
Content-Language: en-US
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <61593a434f543184f41df91a4ba858e1158fd33c.1657149962.git.Thinh.Nguyen@synopsys.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <61593a434f543184f41df91a4ba858e1158fd33c.1657149962.git.Thinh.Nguyen@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0216.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::30) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5edda248-c5fb-4074-19f1-08da5ff22936
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VkCYjlYuDbS95nqmPWK02g+hR193/xCGNxO26JEWMhQgIABxc4EouCMKzcztsIdITSxVrMEpLJ5MO445cuSLf5rlfYySd0Gm02QsT64iAhE966XIESWsGTWyWZ2y7RLSmvSyFD5O+AuVIVguAdhOo8If7o5ngoSoMB/rj7x3Wy9LLLSZuElXLWJ6ZCO7yknlhaWRmStDb+PfjKjQElkGIV/O+yb3BC6lZKwuEF1x1Ay6xMJK93yuvCAg8aHItZyTbxaRmOztsDwEGC6AUXGhBrAtXdVCgMFEtbncyQ1OnDCvunjGZiu4lLxz+mKzCNkM+Bw0uM9bqO1zjZYKgdiGvfR6diAkb3sNNRUh61MgnH+Jm1YsrOm3lqbFBc0OGPbP/SNRTSKx0KnQUi6h9rtAYn8IWcSTtdApjTv8hPzopt2JpccIinmOsJEb+i8Q0vfMI3vTWT7WT1NpngShHRHMOUWEpWWr4BVzmF9+7cctUYXt/M2vAnDLf+iYB3m0IfzzJw0oZdnCKjrgpIK6kHfQ/66w1xq64JsKPwrSSu9bXXAqgVRD4pCgrryCQTmOJ3199sbPGTJEufPGJFmPchtRiJeKObZXxWWxKb261fsa7d9LEejNmnVk9baQ7IFcAw8JhmQsW6diADohlNxZpDnI15lYziJUF/E8Yl/NSZO1g6gP40F6bAg6MEBX/tKLTabQJ5QmsYL3aUyttA9BPgkohwzbUKIo91RJgShYIhyUbE3O2kPwyl/vBxrNt71a7jUACybtwKltp8l6e61pFg4w3Qj1mBab6kcfNfo3BINUncAQtBC1NfrKbVuJN3+PzWYqkE1LHTwixX5N3zxSGGgrPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39860400002)(396003)(366004)(136003)(6512007)(66556008)(2616005)(66476007)(5660300002)(8936002)(8676002)(66946007)(31686004)(186003)(36756003)(86362001)(31696002)(53546011)(4326008)(6506007)(41300700001)(6486002)(2906002)(478600001)(6666004)(83380400001)(316002)(54906003)(110136005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qk1HLytIblZXRlc3WkxQZGc5S1p2a2d0RFFRV1libk5iRGhFZkFzd2lBQmFa?=
 =?utf-8?B?SjdFOExJcTB1aDdKL1kxdmJmUFlWTFhsMVZGWHhMdHJNVEFDYnRUSW5pRG43?=
 =?utf-8?B?ZnR4RG9vY2Q0RDU3NXdlNVdqdzdsNnpVbGNpY2dxSmI3OGZLUEZLMmJjTGZC?=
 =?utf-8?B?WWgvck9McWJwRXkxWXJvSGF1d2loRllzdEhmL0JqUk1hREZRMTY0Z3FyMHpG?=
 =?utf-8?B?UmEycEpJL09kWUNUNWdxUytBZCtGa2hGSGJSam5VY0NXRDJydUsrU3BiTExp?=
 =?utf-8?B?d3Z1Z3JyR1ZOSURpcHJLd3JId1ZWM0RUUmIyZmk2djF6TzFYUXMzbk40QjdX?=
 =?utf-8?B?bWl1VDdHcGlHUy9Eb1FtTjI1UXJ0WjFneGdVM2NiUTVJOXVHQWwySXI4RVcv?=
 =?utf-8?B?Y090cmNaV2xRQkh1K29aYTZ2b0NoMHZJU0U5OENTcVdXaWxldENmOGp0YWRL?=
 =?utf-8?B?ZkpDYzFSNWY1ZW1OY2x2UzJjK3c2SVkxU0FKNm53WVhrYmVrd0hFNElhRks2?=
 =?utf-8?B?dUR0aGgzQkFIdXZqRkphRW9qTHhzUW9kell5RXBGWTNDaHV3UXJOZjJkVnFG?=
 =?utf-8?B?am4zTGNVeklHRDhkbHRRZ3d4S2pvWG5VWFJsY0l6OXJ0M2JyTUtnNDA1SkVY?=
 =?utf-8?B?RERmd29vUFQ2bStUMG9maFFzRlF2cTRCR2JLTGJSb1QwVnBFeXdRaHg5Y3lt?=
 =?utf-8?B?NThLbTVkOGFJRFcvYkhva3B2Y2JIclQ4am16ZkNTTXVBY1V5Z3BoSmF1eTN1?=
 =?utf-8?B?VHliNHdiNEpvcCtvRU1hNzVDWVUzaVk1RGhOeURjRGdWZWJFbXhiSzFVSVM2?=
 =?utf-8?B?ekk2RTM0bVBjWTBZZFN5M3FNSFBxaHA5alRJV0c3LzhuRW5OWFJmUmEvYlBw?=
 =?utf-8?B?WFMvemlUN3pXVTlTc2ExUk5mUDVNSVRkdHliT05IZGtxOGFJWmhmcHpaeUdV?=
 =?utf-8?B?cXVZdExsOWZ5Q1c2Z1gwb015Z0xoMzlya0RGeThnMExsUDZXTUEwQm4xaytk?=
 =?utf-8?B?NFMvUnVYaGVLVm9Uc1BiZVB0L2liOHhyUTZkbWM4cy9JeStqT2VTMHEvb0FO?=
 =?utf-8?B?TGNVdWtBTy9icEN0RVFXNThySytWQW1iTTNwcHFvbzJqc2JjQVEvZHJjdzFl?=
 =?utf-8?B?alJFVTFhWkF6Q1hNL0g5MjZMRW5CdHU2ZGxNS3JkK25xSVlQVzRxYjZxOHlM?=
 =?utf-8?B?NHc3My9ZQ01DNlRUcy9CcjluZXp2eFR6WWxlNkN2N2Evc0VJMTNwUG9mK3V5?=
 =?utf-8?B?TGF3emtZeDRERlFQVnplZ2FYUVVBZjVlSXVMaHh2c3pReGpXS1AvNFlKQzh3?=
 =?utf-8?B?VC8yVFIrVU96bTFWa1FGM3dkbEhHV0k2T0FubkIrTWp2NUVsTXlNMHp5UVR0?=
 =?utf-8?B?U0JKTDJaZjBHK0ZSYVViUmp0RkdFNlVvNzE5V2JwaERUK3I5d0c2dFJpdk1k?=
 =?utf-8?B?K2xLUTN1ZXl2NVp0WG96Rkh3OTVWSWE3QUJ2OVdqejRFbE8rZzhWcDdhU3ox?=
 =?utf-8?B?VGhqTmVFaElLT2J6RkpNVm9uR2l1VlhXMUNyZkJSVm5zSzlBT1lkUkYwWW1h?=
 =?utf-8?B?YWp6c2lzQU41TnBOM2I4NW5JUkFkemk4c1VDMU5tQlc2ZW9MTkF1cDFDWDNT?=
 =?utf-8?B?bmljS3V0cW42aEVRVWx2dmkxL1lwcDNaY2ZHNmFnUXg1cndwZnZxR0tyMlpj?=
 =?utf-8?B?Q2VNRzFYQjA3Y2h0MDlmMmN0NDZHQ2FaY3NKQ3pZL0tHemZIb25XMDRSL3U3?=
 =?utf-8?B?bC9rVllJVFAySXVPSWdTM0M1M3l3aS9jK3RoZDFhbE02dEI5TVhhd1JmTE9w?=
 =?utf-8?B?cjZKY25KMkhhU0tMUzlBZi9QdlF4Mm03V2w5UmQrekxWTzZCSkh5cExxUlc0?=
 =?utf-8?B?NmVIYzRZR2pQVU4xOWRBZXE5R2ZOVkdDdk5oUmI2RWRZUGlxOGY4T0UvZkQv?=
 =?utf-8?B?YmV0MlgrWkN6SXdoS2xqb1BUaUZrZUt1MUFhdzJySW9EdVpxd29NazJZZkpT?=
 =?utf-8?B?OHBDcmUyb0RKcHFuMzdvUkZ4U3MxTzJCRFgzT0Fmbk0vU2VZVmtyYzV5Q21n?=
 =?utf-8?B?WkRab1Fpd3BGSExxNUg5TkZmUmZlRWlETWpBYWI5d2ZDZXpkRmNLNlM1U3JD?=
 =?utf-8?B?azhWeGlNYWpmTExlaWJQSm9TQUhVZklxeVhRUi92aUJRUDJPVXdJRFNiVXlX?=
 =?utf-8?Q?z1Ccb0g+1LjVGIxaIpMDp2maENAia79b8DHZGBWXGIey?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5edda248-c5fb-4074-19f1-08da5ff22936
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 08:24:50.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmBHpzHGtUO0rSqEYzjD0rXSAL28p5g85d7UG3J03EHs4dUHS80sc0TqclHrpZSqVNsPO4mcH8Hj+jRwJ8c52Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5075
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 07.07.22 01:35, Thinh Nguyen wrote:
> CHECK CONDITION returns sense data, and sense data is minimum 8 bytes
> long plus additional sense data length in the data buffer. Don't just
> set the allocated buffer length to the cmd->scsi_sense_length and check
> the sense data for that.
> 
> See SPC4-r37 section 4.5.2.1.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_transport.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index bc1e4a7c4538..9734952a6228 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3459,12 +3459,20 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
>  
>  	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
>  	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
> -	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
> +
> +	/*
> +	 * CHECK CONDITION returns sense data, and sense data is minimum 8
> +	 * bytes long. See SPC4-r37 section 4.5.2.1.
> +	 */
> +	cmd->scsi_sense_length = 8;
> +
>  	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
>  	if (sd->add_sense_info)
>  		WARN_ON_ONCE(scsi_set_sense_information(buffer,
>  							cmd->scsi_sense_length,
>  							cmd->sense_info) < 0);
> +	/* Additional sense data length */
> +	cmd->scsi_sense_length += buffer[7];

Doesn't this need to check for overflows?

	Regards
		Oliver

