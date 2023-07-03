Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D365EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 07:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjGCHXd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jul 2023 03:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjGCHXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2023 03:23:32 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA20D1;
        Mon,  3 Jul 2023 00:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688369011; x=1719905011;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=N4xHNvNBRnS/jHz4n3CA5Scc7WzWQoIGbZxjNlV5PKApg9CvHNr80FuE
   QK9i+qW7nnh+tcUQUUlbWJlcEKwLSVRhzmgyQ13mgdO44nkjh0ohfW1gD
   1arOw9sMB4YeFS2odgL8P52fvX4iaHCSXq4zF9AQIkosK2tsZPgZXaraB
   wb3Qw+3ZN/wmtT9m5lhYOai6kdLr8Dd/SPVYKr77F29057OytPswXpb/5
   o7Nopnl0a2FUNhPJjbINvoWnPtvQ78jMeAnkezjBY+u6ZzU04VNp7Cyzl
   /PiWgD5sXjYtsFOerqZgiM/hrcYFoShZ4UpDoHKcxHIPWYtOc6mxL+wag
   w==;
X-IronPort-AV: E=Sophos;i="6.01,177,1684771200"; 
   d="scan'208";a="235452684"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2023 15:23:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnhKMS7flRzVESrgCLwYVBuspbpS6ktnSAzUO1Q8fAO/+9RXJ6bgti0Ks8+0lFe69zJCr/rZGdDY3pkgnnZqEBGur+tXwb9qCQ9OVFLVKqZzE73c+Cj9qWHr93j0uE3s+hQigO5Qa0Et1ZsE/Eg51WsHbE6zN1UIAvKbLPMN8xW4gtj79YvZDO+7IG2AmI8jiyJqO4iKDQIA3Y4dmicNevyXqc2fXBOeVHnPrzM0uUBn+bLMfTuYXnQBqyc9O5Y5RpAEu3rjWsjwJveqgjTHrGwiVZvXtgpbCKdjC4SJax4d6uSDMLiMiI5wkIE9uJCd9PS9UVs6dqb7LDhxIDe8Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=GIitawMJjvCqmsi5irVxaj6Nrj3qT3MFxU7P6GWPKzHr+Q+q/bMuf+XHi8peM24MsrpUjJmo247ybuVwOU1/OnVKERTnGlvJ53hanaE77//rJjbQaDCnUUXJRa0vGsgat+zjXl74aywx18Go6jtsR8zejbmrK84oz8jTrR86H3viJM5xiaXDVNfVMQv8lr9mb+EQZgTy7Vf2oLm+k3QPnTNz8NyEVVNYSm59IQG9+FginnETtVrm0FvfczhDVbDOKtgntAUQelE/RzTJVD493cEqMaxJYiPWI+eWa427F4uX71bpz4fNe0MVA1F+VWzfkRt/ZZljMSeHBskYpCpecw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=BqxymfVsY0j0Z4xiM8a9Gn7BUkXNcoFfnBxoGdriQ4gQYysT5hp7n3IMM71dXtRHXXIgudH+XP9F4OTTySwW1XEktDqN6Is4X9twLPHTwPCGmKQZiwO7fEDJ++dnjxRN8KiXo0QnWOeDQ4agQ1Kzs0vts1HD35S21kPxu4mPP60=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB7019.namprd04.prod.outlook.com (2603:10b6:5:246::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 07:23:28 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%6]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 07:23:28 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 1/5] scsi: sd_zbc: Set zone limits before revalidating
 zones
Thread-Topic: [PATCH v3 1/5] scsi: sd_zbc: Set zone limits before revalidating
 zones
Thread-Index: AQHZrVjYlhlkOd48mUqmNxUDCIhsoK+no9OA
Date:   Mon, 3 Jul 2023 07:23:28 +0000
Message-ID: <fb209ce9-4ffe-8dee-8619-624507965bda@wdc.com>
References: <20230703024812.76778-1-dlemoal@kernel.org>
 <20230703024812.76778-2-dlemoal@kernel.org>
In-Reply-To: <20230703024812.76778-2-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB7019:EE_
x-ms-office365-filtering-correlation-id: 03a262ad-2131-4fed-ae05-08db7b966578
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nCJjb0oLoyWkyO+LIWDTbr3cSuiiFOgClolQeHLKnqk9eC/NMaSD0+eYdTbFanReb2zKzTLaJMMkPzOI1elne+cRw4SmBNFCjgbv7z9BXvUq7eHaCsp/DJAcMWKEyywwJZ24axXsIGEmctwAGJCQZQFw64XA1d8SOaMfeIHW/Qi4ffqnpv6ddZX0//L9J0EM9wggbSoa3BkqHLU7NfIa4dPoKtziHpxPyKijlVLwcAumMgZT/2Yw/WtVZM7avRKMDBbObOjYSqcs3JYNkvZRtxqcpsvv9xvHml77zv8EzZqVqh1W1m3W/Hb01aphSOHkJ7clcRVuN5zZTnrR7Dn3HQDDCUIJXGdTk1RdduKM4i/PfHMmfs42YVblndGxng6FkY6TWWzNv+P19Cc938DHNeeKmvYKoibIIZvsmfoZTFwrMaDI5ZAiJ+hXFPUI6i4n1fBGfHYMwKQgvCKZABeDpswx/0zNujTR2S18n4/AHwzK97NYP5+c3yk5sYMGUMWoRQM6xAn2rAqT8mYJ164PXTeOkpjOELaFXY2tFup1fnfk88zIy5bKF5YNVKgl5r1dq670GwtGAJjlF8cz4qaMXRA0PBTL1eTB7Eh8ThUaSVsEk2mqzs8ClpC2SbMzPKgcWnQTCtzhVNPunhhOIT2w434aF4qX7ccFa3/3oqhcRALQ+40tVtCXL+Ml6P/1kcwX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(31686004)(82960400001)(478600001)(71200400001)(6512007)(6506007)(31696002)(86362001)(2616005)(186003)(4270600006)(38100700002)(64756008)(66446008)(66556008)(66946007)(66476007)(110136005)(91956017)(6486002)(76116006)(316002)(122000001)(5660300002)(8676002)(8936002)(38070700005)(19618925003)(41300700001)(2906002)(558084003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEFIOVo4N1p5TGljcERJUGxSWWVrbkhIQWpiSEdwcFVoMWJLd05TNHZ3TkhJ?=
 =?utf-8?B?YStLSEJNNkZxZ3p4N1dWNmxIcDdWVHhVTld6SFRLdUxlRjFvUnlIZ0ZxK2gr?=
 =?utf-8?B?S253c0NlTXlDNTVhTGloQnRZeXNCeG1HeWZ3TVhRZGdhWmZjd092eWI2bXBB?=
 =?utf-8?B?eFd1T1lGN3lDcWNwSU9raGhKK3VXeEZvZlBlK09jaXR0TmliLzA2VjhIakdC?=
 =?utf-8?B?dFpnckVzYmxwNlRHYnd4TndXSDdLTlRzMUh1aXZaeTJMVFRIdmVwLzF4ckN5?=
 =?utf-8?B?R09rWllCRVB3VlBzRGdZenlTZkUvNWN2dThiZDNGbWM5aWFSRXI0aS9yL3NV?=
 =?utf-8?B?TUpJYWhjY3NCQ1M4cGpjME1JRXpjbjRBR3ZVbDFmc1NZRjg4MEJnemJmbktP?=
 =?utf-8?B?SDhLRkU3azFCMTdQclNUclNybWl3RnNSL1g1SURXak41Wk1LQ1duTVN1S0Vk?=
 =?utf-8?B?QVBjYU91NW95SmIrNFIydmtIK3Brb0Mxa2tudmFpRnBXNjJTNDR1WVdCVHVU?=
 =?utf-8?B?OUphWmtqMlorUHZzSHVpRXRuMjIycVJsUGJTRHBqWHIzNDM3c1FHbENsZHhW?=
 =?utf-8?B?NXJlQ1pNTm9qWCtoN29DSzdFdXVtSmI0MkFLcTlILzIrOHlUbHFwekg2NSt3?=
 =?utf-8?B?b2FYNk93TzVpUzR1UndrWlNObUdKS09DNDBxWStlTTFtbk9RTHpCSGdQbEta?=
 =?utf-8?B?SUlmemQwN0dPUFJEdHpha3U5L0xEenE0SlA1ZG5PdWg0eDBGUks0alVjZWlw?=
 =?utf-8?B?VXN3NzNFT2ZHZURFbzkzOElyODI3d1BsOHBJZytpdjVwbm13Q3BySGtYUzV0?=
 =?utf-8?B?RXRDcTRhL0xlSk01NjJQMUpWV3RoWHJJcENDbkhqVXJJcnkwUnlZelRZOFVh?=
 =?utf-8?B?YWk0VzYraEs5YzB3L3pSNC9zNUhzelM1eUFwM2JxeDhtclJjWWVJQVo3R2Ns?=
 =?utf-8?B?Z0hvNXRxd3JFZUt6WTNIb212L1VOWmdZY1NCRW53bVRmOXVYVjRwZERPdElG?=
 =?utf-8?B?WFFmUy9uN0g1T3RxTnhTUi9ZQ1h4eUlTaXNsQUs1b1owUGxoWUZGNVFzZkpj?=
 =?utf-8?B?WlR4aDhHOU1qeVVueW9VN0xuRHVwRjZaUW96RTVoeDNqaVVxcXpxZFRVcjk2?=
 =?utf-8?B?NWs4SUR0NExjQzI1aUFGbGZ6VEJTajh1QVM4aHo2dnE2MURyeFFXUzVZMmRk?=
 =?utf-8?B?Q3FFME4wUEtrZ1kwTW4rUkp5blE1bi9TU0pEbE1YeVRMajgwMjJhQnovNEF3?=
 =?utf-8?B?Y1M1K3lzZWw5TGd4ZytPTWt5UWdoZWJPc3dKdlFMTmR2UGxwakg2VDlmWm1p?=
 =?utf-8?B?czhDWU9YdG1iNjQvUlNHTXNGek5OU3BGSW14dUxWOXFoT2VLQnkwRHV2SUhw?=
 =?utf-8?B?K2ttOEVvYkpNOHBqbVp1VUM0Qmw3VkhGTGR5em5QQzBZMmJIeWg1V1FOMEtM?=
 =?utf-8?B?RmxWMUNXbzYrUVZpZkR2VHkwYktxWUhFK3dlT05OLzdCLzcrZHRYUG4wMU5Q?=
 =?utf-8?B?bE5XRGMxWjN2REhOVUd3QUNKQXJYUzRUVlJGKzJ1aUtqdytKN2NDc3QvMkRv?=
 =?utf-8?B?VFErS3BZd2wrTlZML29oaHJ6RlprNG91MGVDSGVWUzJib3IrY0tnUmp5emdE?=
 =?utf-8?B?MElUbTdiMHd4cnBpK0g4bjVzRWlESnh2dWlYdTNaeks3cXZkeUo4Z3JrbHp2?=
 =?utf-8?B?YThBRVBjL2p1dkYrckppN3JVTkNzOTFmODJTU1BYOUg5VXRjK3kxeWMxUXRa?=
 =?utf-8?B?aGZuTjJlVzA1SnpZVzJkTzR6YnpqbWJQbk1ObURXaHpBbnVDVjFaRWhYNHNG?=
 =?utf-8?B?NFM4NG9GUkNNTGV2Y1U0Sk04TzRCYjF0eWw0RERyQ3hNYzRrVVNwZG1oaFMr?=
 =?utf-8?B?VkZrZDJpMVNKaEFNNEZEeTJUdy9YNUFVTjRJalZYYnhxeHUvSDQ5ZEpuSUpG?=
 =?utf-8?B?ekxtWmlqekY1Q2U3eFpCR0FzL2h5cGd6dldLZGE0eGwzNW53VVdaNEQrZXpo?=
 =?utf-8?B?LzZ0V1NIdVJJbFY2V3g0Z3pld2lVSm8zUmZYeUxybDVITklvcTJnTlhVaitn?=
 =?utf-8?B?UnRpRW5sbEw3TTQxanBCQWhCbHc0b0lPU1FLditrM212eUJQUDBWMXRGcVh4?=
 =?utf-8?B?cHBZdW1ld0t5dHF5TlZDL281REkrN3JLeGhSVThWOGt3K09rNCtnTVFlc0Fy?=
 =?utf-8?B?UGx6UjNBRVN0TU1tM1NFUnYyamdSS3RRVVBmaXJkR2Z6OVVtb1FEcHJ2TXZq?=
 =?utf-8?B?dnh1WjRIN1Vnc1dObFliZ0RtNlhnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3323C36A199EA1499C4F7FF7DCA34F30@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WTI0b0FHdy9CM21MdTZhN09EcllFVXd6Q2RrWUNYUkZRZVkwWWM1cncwWkJn?=
 =?utf-8?B?KzZpNkZNM2pMU2tIUk5ET1pJajdYSis0RjFzb1I0VW45dmJLZ2lpR0lYQVlH?=
 =?utf-8?B?WVcxNGxTZ2hrNjRSaStkTmxZQkpvMnNTSXhJcEZFUm04QmJtYkVzb2poanVR?=
 =?utf-8?B?RXcyOVRDYWZITFM0eWJDMFZIeHRWQksvN1lmTVRiaTJDK0hkNnIxYUFMZlhQ?=
 =?utf-8?B?WjBISXlEbHBsMVNsRnJIR1hCcWJvVnJlUGNxUnUrekZ5R1Y4U2F0N09WWWxy?=
 =?utf-8?B?b1UrMVVoTjE5NFdocTNSOU9nWFk2ZzRvWnpKSDRkQit4ZlE2VHVneTZlaTdy?=
 =?utf-8?B?UmltNFFmMGJTMnJxYVVIQko0cmsyVW1YRStHS1dGU1Fxa05IdE5mci9pRUs4?=
 =?utf-8?B?WUU1TzAwMnl0cVVrdmwzeWNyR0VEUVBRcGJMUVl0THlVRG9tSDFuUlQ5MUs1?=
 =?utf-8?B?bzU2WXdBM2xpbU0vREtSYVI5VWcxTlRhMXl6MlRTSE1WODZwWUdkc1ZlUVFv?=
 =?utf-8?B?TmVPblptT0xtM3BrcjA3b2NwREREUDVZYm45M242ei95NEovNENUS0ZpUCtZ?=
 =?utf-8?B?dmJOWkxPMzdranRRbERLOS9sQXRnQlg5R3RDUms2OXUxMERnNjlsYXNpOHFs?=
 =?utf-8?B?THZaSFpJRUJ6S0pOMmY0R1hBRlRueGY3SUpVTEJVU3lkSG9YeUhkRnRuekdZ?=
 =?utf-8?B?cCtsMW5lWG0vRS96c1I2NUlDOUYzTFNFaHFQK29SNVZXYW8xWTdNYTZrZjFI?=
 =?utf-8?B?VzAwWFFXK1BlRzZ4OXFPVHgrTng0U1ZSbWo0ZnErTlhVbFpKVTJ6aXlCa3U0?=
 =?utf-8?B?Q1ZYZUxnSW9lc2ZBNmhqbFEzcHpZaUErTHpnNVlNZ0lYYVVMTHMweVQvN3hG?=
 =?utf-8?B?QnhlajBOdzlEdVBiYUFvajRhczZvU1hYMEhYY0tkUjN1ZkZiTWk5b203NnJ2?=
 =?utf-8?B?NndXeEJCdkJVLy9ncTNoZExBSG9NWGFZU3ZkLzZ0T1FGSFNLZ2h5UjdNVnQ1?=
 =?utf-8?B?OEx2UXM1NFkwOUhGTFBEaEkrUVp0eGpVYUs4UTVRVDdJMHpiTnlxdlpLdlFI?=
 =?utf-8?B?cXV3ZDlWZHp1bXNJcVZyelliZWJ3UE1FRjVSNTRvb1Nyei8vSlE2ek42N0Ji?=
 =?utf-8?B?Ym5Qa1JkY1dKZjNaMHRlOVJhTTZZaVhCMzJNdGZrMjUwN1QxNGNFUjJZTWlo?=
 =?utf-8?B?TGpaZzNIZHR5d20va3dVZWtYeXc5ai8zWEg4SmdUNTN2RWRXSENQckxtT1Rz?=
 =?utf-8?Q?pM6PIyCZl7nPoO8?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a262ad-2131-4fed-ae05-08db7b966578
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2023 07:23:28.0751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G7Tppb9j63KpTQvJ+Ka5ZRLwoRvf+ki2BU5Nq/rXTI6XJsT7TOm4kVoxL91mAWnRXuhwcwNWDK8E+OF1IoUGX41jAPB2kGTqhJhZBCbM4qc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
