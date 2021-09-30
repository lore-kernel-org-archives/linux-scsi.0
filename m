Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15858C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 17:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5E2A619E5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 17:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352913AbhI3R7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 13:59:39 -0400
Received: from mail-oln040093003003.outbound.protection.outlook.com ([40.93.3.3]:44556
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352908AbhI3R7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 13:59:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koZ2YjUja8ve/RjjwtCB+nKn6/9wqsV77uyTuWyNygTdBqe0FqAXUhDJjHC4dzMbNM1K3J28HAfSI9cgeC7oBMCfC3rAU5DBIItcVsh9GByyNpbfq5qQkZivfCEIMpdwYeXe/Sw2pubKjVpcd78xLRWsXSWBFviqHN5Liliv0B9PPyuASH5VP7KMambMXnWsCxiEWDUHr1oIMcKml8b0tz+cml7B+qQ+Y2xefQCOXdDEFa+XEck4LuIDoFXavjWD6k2MjhhjEcYUxJsTVOkuQICTJK1vYkwQhiD4KIaTwy3RYD0j6Haerkxyfewg/rmT4V9tWWV48dCULzBs/TpHmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sc7EjwV2fY8KMSE+7A0zMzGnA+nZmma7LNHdt4xKJ2I=;
 b=XNbJlFe6GB4UAsK8njR9h96jDSsFiv70JyKQO2A6gXtiqQKv0oPqCleYfkEwrmanDxvhE+RkC3j+Phlpc1HJN+vkC7+eMxgPR6TVP+0caHvivxuSr2Gj1wRakjupyp1qNTj5+ZgZZ7zYxqLOmDOFnw1Z9+WbNEuVqKSqQNMzn4va+4LMVHB6TFspcfVTciJjcewWVwdCl0WMpYQ2D9qqzul7s+jhQ0TTFkp4wfh1oVb4zMEJn0OUEbNgy+MflxNhcI1BoJj/ymHLI7nNycJd+TkQyM9yCH6MqUQDzdHsoUorrLHIGnqlBdI9hsMyFXqDVuqGg61EXMWa9/LNcqhBOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sc7EjwV2fY8KMSE+7A0zMzGnA+nZmma7LNHdt4xKJ2I=;
 b=FshN3uprSeEYjlixfaCwiA1PDHAAWQ+GzmxWSaaK+ptld/KdYR+saa9WnzCCNxtsFu1rXy11GvcEqiPiDkVdVQmFgts21JlYLACBbx2npM6j8R3nMTqP09BAsM0Rkja85AeMu+Fhm6nHsLbnJ1FQOyaMM+/sbOKuNmv1GT1VeL4=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BN8PR21MB1267.namprd21.prod.outlook.com (2603:10b6:408:a1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7; Thu, 30 Sep
 2021 17:57:51 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::f8ac:5395:a706:f38f]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::f8ac:5395:a706:f38f%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 17:57:51 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: RE: [PATCH v2 72/84] storvsc_drv: Call scsi_done() directly
Thread-Topic: [PATCH v2 72/84] storvsc_drv: Call scsi_done() directly
Thread-Index: AQHXtX5/dbkpzt0YBUeHOaxmIN8Ttqu823MA
Date:   Thu, 30 Sep 2021 17:57:51 +0000
Message-ID: <BN8PR21MB12841C43D1775DACB542A1A8CAAA9@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-73-bvanassche@acm.org>
In-Reply-To: <20210929220600.3509089-73-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8e795b08-d87e-4b23-871e-1fc1ebd85eaf;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-30T17:47:21Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9432bcbe-75f1-41f7-dda1-08d9843bd234
x-ms-traffictypediagnostic: BN8PR21MB1267:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR21MB1267CDAEF30646F7C803AC56CAAA9@BN8PR21MB1267.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PiD/GIxD2stg51G90VSHMH886EHeC4KBI0zGhSO2TjsrQhHECrCdm9a7IsLvcSWLCrQmIXsaZs83DQcAgrvCRJ7a+EGiutl7KovMe/n9y7xp1qniPh5bmdeqAtpBu3349TIJvsSruF4YN3AUod7Ph3mP10ZnESLBkRPEy266yNXlo92IP/JG3V811NLk7YJ18TGYK5uaiULjte0M7GxVdE1l29pU4aJOcRXjmMwbtwKVCb0coONnad/hVB2JiOE2HYCwbaVBEVSIY5lC2uNS6Et1HqyC3F8Xwv35rikGRnCRajF2Zh0OFNwzCs4hpvN5RBlmU0uVBG37gouMQuIZlYiAMubvYTUJGJVxNoKoCB0GJgHsm19f+4CMGw7UABrXBEsit04FNTd81v8AhQyoIOGZAqDHH5rEZSWajPuZgFvsXArgaA20n7bgNK4aEapgH6MXjiOomGzac3tHr38zmpb/lE6Ftk/7jPOudnZi7+1+glG2bWdeb3ZeG37WDHJztIOz7mfkFd0MYTVtSQSRlplTskUNzCNhkHd0pcwwLHet02s0mAI55V7x8nhRjF3Tz/z0GX5wOm5PZvI+mUco0a7NtByz6YdfQaWHWJAgmz+0k7XzhQgZrIGurbYGWT5p2YhJikC6RiZvJEy88Cb2Xn5iLwVMRJsxTndgelnObfHeHbdV7xuYv+cmjyEnaiGjkkcvAwQzaJ8Yx1zZRhNKuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(26005)(7696005)(6506007)(66556008)(53546011)(9686003)(55016002)(10290500003)(52536014)(5660300002)(71200400001)(66946007)(64756008)(66476007)(66446008)(4326008)(508600001)(76116006)(8676002)(86362001)(110136005)(54906003)(82950400001)(82960400001)(38100700002)(8990500004)(38070700005)(33656002)(122000001)(83380400001)(316002)(2906002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cjyLgjVAzC0I6T1rnPcjQQPwexN2k7RWqrpySA67z4xYUAK9cfhEuW+2P1Kw?=
 =?us-ascii?Q?zI8YqyoF1h68c3zbD+XTgiVvexeNaW/5KdUv0sjVmfqNgOhADlFjxrWZdkNA?=
 =?us-ascii?Q?BOBKQtg8E97l6QVyhx7KQ1V4FV9cQiobP+eAcTUgeJZmQ6hTmx4RMlnks48F?=
 =?us-ascii?Q?Il+aR1BxJ4vfrKDt7b5kOnwxUqOWQ1ookLdj49jlUWBea8xafydOkhKw5fEt?=
 =?us-ascii?Q?9V80HGfrwoG7yas8YiPnIxPP+NMnm5gjz8I85X7FvWh5lshXdjJgVBc6Xg0o?=
 =?us-ascii?Q?7MwONCpFD367zm7onPUk6QQbzGtckvJ5HoJX9f2V87FgfDKwQpynaK36g0Ze?=
 =?us-ascii?Q?gHDrZlMnjJ33UZZejk/uRb1MaVqYOvwZzfwFfJmAizxv7TVriOXW0iWb5jw2?=
 =?us-ascii?Q?xIUcP3h+lYYZLK4RWZYdN6SfrD8CJS2Y50OcmmSHPCKnRD8S1A/RkHuZmLKt?=
 =?us-ascii?Q?4SfVUaBAe31jz8L63+oMvHZNXirrIPNyIloDkbi6R2Dq+/1eaxEVRfxqagvq?=
 =?us-ascii?Q?4dBWuXAdEC7rMlzGIrsXHNAjENIwvT0UoH0nCbdOjJIoH19HEsKJKqco/wtC?=
 =?us-ascii?Q?SQV8mgYojLGli+de24hd/72wXw6UaEj419wvnXCoYP94hzxIyuQmYPVWYpgb?=
 =?us-ascii?Q?RsAt/97T64Ew98YUfuFs15Fs4oEdzysObNGJ2EmeFVXFRhfxc/rgyg1nWrtQ?=
 =?us-ascii?Q?rQ21FIVzWLTWt2mCNB4f6qx6RwIQiIXgWUjgojBZhzYJj2IPdZusIAIFf9Ts?=
 =?us-ascii?Q?HSPGpOHl1dMXD/18gtv/WIHzqHFI2ElPEiyl6jrwkFO5L424oLb47XNoRVIe?=
 =?us-ascii?Q?/eQ7SwS0vf+R3tvEffD+degrTJT9WIQBM6bIPwpm8VCHsnus2AQ7zcoC6n3S?=
 =?us-ascii?Q?VkhiA8zAth5TKuN/A4+pCyaHu3GXANUHjsszDbVyGMra5cotGfp6J1CSshze?=
 =?us-ascii?Q?Ez9rE0zzIyERu9tj3ai2g2qnuDs8meyeipVE25yDdcS1/XWjzNMhYyctpylp?=
 =?us-ascii?Q?56We7f/y9KFeQCv2IaSe0URv4uGWfJObzO3sCxHs08l3UNhmrWoLjxP77OiH?=
 =?us-ascii?Q?axWJzjQTPI1lis1o/sD2w3G1dXuVvlqFZb+UyMSsygQDww20FXiuY5qXUf8S?=
 =?us-ascii?Q?kMIqFyQjphuI6Sk1R3qbRud4zC58GDU+1WswKjnS2JUcMiTNksjq1wjTKhdx?=
 =?us-ascii?Q?VDd1Jc0N5OYmhKZCDP3HghP3EwmNbdKfuZo29+Ir4ePkjNDKx96Rjd23qFNv?=
 =?us-ascii?Q?ULAfj5a6E8WsD5lA/lWg5n9CPmxOfMHJ1LZW+dEGl58wYdJUwVqHA6QEUNn1?=
 =?us-ascii?Q?0LS95ztK5GUvSjLPJG9HhvKK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9432bcbe-75f1-41f7-dda1-08d9843bd234
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 17:57:51.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PORLpZFjXBDKdg+mDkdp3aQRNed7A6yq8xa6a0MnEXl9wzAbOOaonoyo6CYovBA+Spv62umyGw29tKn8EURW9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1267
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Wednesday, September 29, 2021 6:06 PM
> To: Martin K . Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; Bart Van Assche <bvanassche@acm.org>; KY
> Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>;
> Dexuan Cui <decui@microsoft.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>
> Subject: [PATCH v2 72/84] storvsc_drv: Call scsi_done() directly
>=20
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/storvsc_drv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index ebbbc1299c62..70d0b1dd0f75 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1154,7 +1154,7 @@ static void storvsc_command_completion(struct
> storvsc_cmd_request *cmd_request,
>  	scsi_set_resid(scmnd,
>  		cmd_request->payload->range.len - data_transfer_length);
>=20
> -	scmnd->scsi_done(scmnd);
> +	scsi_done(scmnd);
>=20
>  	if (payload_sz >
>  		sizeof(struct vmbus_channel_packet_multipage_buffer))
> @@ -1753,7 +1753,7 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
>  		 * future versions of the host.
>  		 */
>  		if (!storvsc_scsi_cmd_ok(scmnd)) {
> -			scmnd->scsi_done(scmnd);
> +			scsi_done(scmnd);
>  			return 0;
>  		}
>  	}

Thanks.
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

