Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64839C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Nov 2021 17:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhKTRe4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Nov 2021 12:34:56 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:39617 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230190AbhKTRez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Nov 2021 12:34:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637429510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIC51ILg4KVM/T4GeULZsHp3ozJggXSBIyaZDeld2os=;
        b=iofEIEFnf993GSfjiE+0uvvGE7/KWXwlAtQ8AbpSx0gnBLtWzhhM37IagWFytnB/SY4+xO
        ZvnRsozq3Cecku7nouSURPPaHkO860NYHwXc+FyT021wYfojnJA9zhZwRxIyr5mVEaH+DZ
        d8huVHOldvukhF3W25dpL3XSywEjBcY=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2055.outbound.protection.outlook.com [104.47.13.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-q7G60P0LP5KLnkwLGG5zgQ-1; Sat, 20 Nov 2021 18:31:49 +0100
X-MC-Unique: q7G60P0LP5KLnkwLGG5zgQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeX5Ez/7cpDmKdEJ+nih2kqPnCRdliDUqdKkcccpiSWN4NfB3A7c4B3INNf1fzrDXIqZtQl9ojQqS6KvWo4v+tUPUv0S0RLD+2/Le8P57fdjAEHiK62iXZ4SMWCD6pNLyE+rlHBegkw6ebE1QhltmvR77uRl45uHlVA6dtDKVGA43s4kqCOxVam9JW937a4mbaXX1GyDkvHqRo+We5lEDUEeuffTX0AmdJvv2wjMnbIpFOroRfyZTLpI9O5AGEYgBzVsbYoVKNa4LhYh06SZ8FaL1FxAYVETBbUSAV+e7A/9TGFZ19PqbroUldyaswXOtQqQOd93xchVSQtI95dAwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIC51ILg4KVM/T4GeULZsHp3ozJggXSBIyaZDeld2os=;
 b=gM0sjyjq1M8En4HUvID1RCXwT9ZcC579RoYoE+ngojEcoQ2PoXZRuEve40oNm4yO1bLIMJPbMgqGHfAlDQE0oq2+pU3IqK5s/xTA5ZZrNBOj/3L7YHkwKmvjUaDVhRq6ZhbD5IsKQGuiieZ1i8sqXFo2rZMKE8c8rDXQzKKVGupnYkFklz+pxjziHuEGbL/OJwfPAwTHesdsR+BJA+/KAwOQ2rWlrUoQRWvL4UgQ+mBx64mY0BSh2q5HD85hXP4GH4JmkcQpnzK/paI4CjA7PNR9Auq5jRYPvH1R+mSNgbrzVyQJ8nrodElA0P2ygH0qgd/i1mwfdFlwvyUpQMp6Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4072.eurprd04.prod.outlook.com (2603:10a6:209:4d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Sat, 20 Nov
 2021 17:31:48 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4713.024; Sat, 20 Nov 2021
 17:31:48 +0000
Subject: Re: [PATCH 1/1] scsi: Fix setting device state to running
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20211120164917.4924-1-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <424bc88e-2f22-6d46-683a-d6a39d456158@suse.com>
Date:   Sat, 20 Nov 2021 09:31:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211120164917.4924-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0039.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::16) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AM6PR10CA0039.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Sat, 20 Nov 2021 17:31:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f21a6858-3e6e-435a-08c5-08d9ac4ba14f
X-MS-TrafficTypeDiagnostic: AM6PR04MB4072:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4072B44CE900830FCA4238CEDA9D9@AM6PR04MB4072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lAMY4+ClnwPHmdDTC6Ezv8NuONoCS3hXo0pvZ3pESFlK/ANNgVqresDHF+O1vkTZY0LzS4Z38m5vzZe+Ud886TjwZBxIehK7oX4yaV5flecPogNsHaPm9LgVkT7rXJOszBcpLwkiWeB+EAv1ZuNayUS1RJo1edI5zGN5UeLbQSw7D6UC3Gg5nk2katcCy+sUJuDVPGqZyV87x5UAX74GJnEk3jc6KdbqO5SDySzT4VLX+ZHLwNJbD2oZO9ZEXBYPA3CWn5okD19gxiGFVjPPxLGprQZ1Fl4KOmw0ryBwWu9argnCWnR0wPid/+Ozbn3x1m+jNvm9Gcpc7wBV/bIlLtrNHP7W7VyUu3MlsfscmfQdqSHqMazptQm8oC6zL56p8lu7kYF/ZLiNAxmq5CHY72V6l3uB1++sQ8dkjUuW+aNDLiLfo0n6vAS7DyUvwgCXvAw03XUDdlSymJoq6XPtwrhVvKZJjTkMsEW3yOqm1ZLP5mI7SYsHpPYtApdwANYxleiXGFcGh8k24X8aV9nH9IhMIsA9iKVxDDLaqh+Zv2PuxZE0HROz7zNn1aXq5cbVDVW3PavnFuvnlBQTpAG3bbKPPAu6Gh4QuplO/Xrq9tfdkxMwjByLKNLCPTmnpZOyn70jK5mi+x72WTfphhRhFaXSe7HK+QsKOlgFl3qltBUMfdHcH82opRjT4OObaMGsEpOEkXVvIEFaM5+wyccI3CMwSN3BOg5OAE9lEGpuz28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(316002)(16576012)(36756003)(186003)(8936002)(2616005)(66946007)(31686004)(956004)(53546011)(83380400001)(31696002)(26005)(66476007)(66556008)(86362001)(508600001)(38100700002)(6486002)(5660300002)(6666004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WldqVFp3Z09nQ3dLVGpPMldLN2Rwbm1SQjRybVBlaG5Hb1FDNlJzS3NMa3hU?=
 =?utf-8?B?cEtKTDBKR1NkaEhtWGN6Uy80NXk1VVRUSElFc3BEdXVwUlBFOFNIZExMczB5?=
 =?utf-8?B?YUQvWDJxL0VBWGFIY0g5d1ZMcncrQmlKME5OWEpzZ2thbUlzL2plczB2Q3BS?=
 =?utf-8?B?dndxRDV3UFZYNmcwM25wZ085OVJCYU1MU0hYOEQ3ckF0UXQrWnQ0WVpiYVNP?=
 =?utf-8?B?bGcvQ3BYMkhqSEZWY3ZZTU1iT1o0WnBmTHhjQ003THdvTlF6anB6MTJGZ2pV?=
 =?utf-8?B?Qmo4d1Z1clFTNkJpK0VPVFBCc09CZDF0c3dYWkd2Slg3VXp0WEVxV0NhSUQ2?=
 =?utf-8?B?cUtJM24rUSs5TjI0cjEyZU1BVHd3bjFmbEpyTUlUUHNRWDlVeHR5WDR6NEdF?=
 =?utf-8?B?N2FLNkU5VTVJZG5jdXF3MHVVWDg2YU00NmdmQWxnT2JkTUMxVW9VL3NiSWZV?=
 =?utf-8?B?V0hLTStOTXZwMHN5OEs3UjNGOGlTbmppckc4bCtDRjJmV05WVkdobTYwcWRk?=
 =?utf-8?B?bFpIUU9Bd21LaXY4NERoc3MyTVRtR25oOWZuOStSclljVDQyaWJzUWdGM2gv?=
 =?utf-8?B?M1M3ZXhiRlJjTXVQWGhHeUFIc1M4b29wd2tTY2dZOFozVlFudjd3bmRTQms5?=
 =?utf-8?B?YnZHQUxwR2pKRHB0UEVXcFRkT0xKeXJwbTBPRzhJZEtJTWdaeG9weDVKRG44?=
 =?utf-8?B?dWR6NnRFalZpMWUzR2dOQ1FrSHU2OTAvajBNaFFOSWJHOW1BYmFwejNmZEVz?=
 =?utf-8?B?TFpJeTROdjJQK2t2S3AyRUxpWDZzbHE3NHl0RnJWdmtVVDR2VC9mZ3B1eWNU?=
 =?utf-8?B?NUhiV05ZYkJWVHlPRjBiMFdsUUxSSmkrVk51MVFyN2NuUEdFbTE5QitCaldR?=
 =?utf-8?B?b3RLWDR5ZGt5bDB5YUlQejVlVGErci8zZWRSdXBBc0FwdlJ2SFMxazVvL0lm?=
 =?utf-8?B?UU5TQm1EY0wwL0swZ1VOeW5CNGFpY0ZHMFZIdnVraFFGd2c2NEVpb05qbEpt?=
 =?utf-8?B?WHFqVVJlWFFmMzFnNFNqZWdGK3FLbG0rWnk5QWh5RFI3K3VFUXpmL3N6T1N5?=
 =?utf-8?B?dWVSOVphN1dpS1hqZWcxTlVVdzBIUjdrNmlRVytISmdGUzJhMDNyRUpWeEJo?=
 =?utf-8?B?aEFlM01hdGR4T2JNR1o3dHVWVkdwbUJab2JEaEV4ZFRJckZMQjk1N204ZS9J?=
 =?utf-8?B?ZHNkL2pwNTA2T2J1dlNmbDF2amhYQ3doWERYajZxQzNSUXlpV3g4KzZHT0pU?=
 =?utf-8?B?N3ZMWU1NTXdzZUpjcUVhbUZKWURlRVd2VlpDeGVDTndrU0hxU21LSVBtck1s?=
 =?utf-8?B?RDZCMloyV2JpVzFxTWZoZGcweFZ2eklXMG1nNHdLUmU0V0xzRWc2b2pDWHBt?=
 =?utf-8?B?ZEtkajBpVnpibXBpTWxYYU5UOEhrSHdLWGlFUWhuMzZ1V2JMY01vSFBFWWdB?=
 =?utf-8?B?MHdsU1ZkN2ZkQ3pnS1djb1pxakNHTXlOK1h3ZzdZS0swNVFHbVFhYmZ1aWY0?=
 =?utf-8?B?OUFHOU5ETVdUUmRZdUl5MjA0dksxQTh1NndROUcrdHVjRkRXSHJIb05BbE5x?=
 =?utf-8?B?bWREWHpLa1RWTjQxemhFK0xheDRrR2xVdXp3Syt1K3pOc1VQODNvOVV0UXhB?=
 =?utf-8?B?MHRtdTYwOEkyUzlCSERGTHlaT0FHNlFJc3ZnV1EweXZtTENoanhseVZFbE00?=
 =?utf-8?B?TkpVZ0ZsUFFnaEhKTWdBWGJNRktVd1FMRy9vRVhsT1JZQWFoZmxZbkFHWnFG?=
 =?utf-8?B?QUFVdERHZ3oyTmZ1K0RRM0hOczNtT0ZRUkpaN1ZRYjc0K29uRGNDRCtUNTBX?=
 =?utf-8?B?WDFCL1VrckErWERKNHduRUhTUVJ2Y1RZZk9jM2lpZ0J2QVZydE1hZXZnaThS?=
 =?utf-8?B?Q0N3ZXQ4R1BMV2hFcnc5OEVFYk5qYmwrZjgvMXhpMkdDbkVLUm9jYkd3d1cz?=
 =?utf-8?B?blhMcm1CYllZS1J3RlV3aCtBMEtjTVJDMHdJVWhMOXQ1UktaZ015UTdBeUpB?=
 =?utf-8?B?V3lWMWM1UGZPQ0h1WVl1MTVBRGRMUmFINU9SVmpTOXVYZERIRHVzZVAzdDNl?=
 =?utf-8?B?MW1PMkoyNWcxZnZtVFFnZjYzMHJGYlJZRXFpeERDekgzS3c0Q25UREhUdXRm?=
 =?utf-8?B?ZFR0QUZ0akpYdWU0dG40d0pqVERqanhaS0hBelJYamJkdUpYL05rTk9nNSs2?=
 =?utf-8?Q?ar0vc7/xJFquD7bAnBmDBNw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21a6858-3e6e-435a-08c5-08d9ac4ba14f
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 17:31:47.9541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oli2UW2aPA6yUH69rIdLt7CggyntUCQKN9EPjniqFXO3pzjGwmPQZU+AoO11dWKIQXj3DZtN1xfwOMz8vx++Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/21 8:49 AM, Mike Christie wrote:
> This fixes an issue added in:
> 
> commit 4edd8cd4e86d ("scsi: core: sysfs: Fix hang when device state is set
> via sysfs")
> 
> where if userspace is requesting to set the device state to SDEV_RUNNING
> when the state is already SDEV_RUNNING, we return -EINVAL instead of
> count. The commmit above set ret to count for this case, when it should
> have set it to 0.
> 
> Fixes: 4edd8cd4e86d ("scsi: core: sysfs: Fix hang when device state is set
> via sysfs")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> ---
>  drivers/scsi/scsi_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 7afcec250f9b..d4edce930a4a 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -812,7 +812,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>  
>  	mutex_lock(&sdev->state_mutex);
>  	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
> -		ret = count;
> +		ret = 0;
>  	} else {
>  		ret = scsi_device_set_state(sdev, state);
>  		if (ret == 0 && state == SDEV_RUNNING)
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

