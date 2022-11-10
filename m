Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46148C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 10:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiKJKiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 05:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKJKiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 05:38:13 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED2B6B3A8
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 02:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668076692; x=1699612692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KNqGSemVPWU0P8ZaCvsVwK7MuD/qqoJ1WDwsxlVr20Q=;
  b=EbrxvYRfZ9KB7qoyNSBV8cCmj6XbZ/aMN/XXNdalRLErNiMOGZRpmT+F
   XTLxpWN8RUID8HPIiKDgeDOv/aX1rxQ3aHOi5SDXYXxSGyr/2HIqahlJt
   UjWl2JJ9p4b1ckihqkwQgaVyapjymzk0wVDVfu31FZYPdN6cCKHBSUcZU
   lwQThAXYYj9GHRwcSspEeUnIJxPUc1tcWLaH6+1GS0GuXRmWK9N6a+8CF
   ETY1ErbclNQEq2KVb/nfVeHUCCYEkmQHtTD2fycLrOBuu/pQ5aEeQeNVi
   viubNdVzgyFlEq7Z5d5e79QwZu3Rz+q743qJWlUd3bGX4/pb0cyUfX9+t
   w==;
X-IronPort-AV: E=Sophos;i="5.96,153,1665417600"; 
   d="scan'208";a="216278679"
Received: from mail-mw2nam04lp2170.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.170])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2022 18:38:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uy5obz80CSdnldOXGvY2rCCkdCSwm8WWRxM/DrS487xh6VfLbOMK/+CYsbJsHf7Zpc1CytKY2qa0I4Ih/qXgAVMHH2G2gCEN2m+ClSy5SjtwNsIaV8x2xQq1No2c6/IjUDvbO+68QIRDmc5YitffliO/cGuebfX+S7Em+7e/55DMrupaMEkxTDbbcAT2QYzOHl+xan/G5quMNOw/JaZbK578B8/UlwJl+0WiMJWHiwls99gTpNIp1nafY63a0A3tHJXFvF8LtI4FnhSxeeIcoJ6K4IBtEw6zx0QTzpsdpAgA3gy8c5jQ+bqdnrzayxSCdG5qQiztv9vwrEM60TeORw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+V3meqfznyQLudw9iXHBRJ1Hz3V+vm0G8bBcfq6o+G0=;
 b=UoLls7Hf7F2ta6Jl8AuwsW31Iu7u45OpEHrMqR6bk1Uy1Z/tjmv+94FokPQJBtuPEA07fUzRFuqR036S19MHOITgB1944dc/ZSnu7LPnTF3y0GPTlV+3bxcvQqf97/EO4sH5kZUIJ+6KOY6I/+0wjYwbmI1UYEkS4W70015vlIrod9+/YbyYkjfryMLztnpBQ6B1DzpUOjvROwQTSk2j5BBxqbqogPS1oOkalMtAO2dXGYocxJNcNES2DpiIWHp3P1hIZKUuRrMm+tq0999hW+zfPWY4yiFr+L6ZigMDu8ALxfg9ateTAg/mnVQFMwjCTVJZ/Y93vRcNeIpaS8U7ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+V3meqfznyQLudw9iXHBRJ1Hz3V+vm0G8bBcfq6o+G0=;
 b=K3hdSpYoL8aBHw5IAXvwh8jgkrfhzs9MLQgg1jC0KSn4QvKUCHlshWEsWqnugVMLWTrkCMwsxfqnK+gXnLl3QVkkF0SY4QieiJxZ+s5h4JOEKmYzF0LM+KqElzF2TO68mhxFaqi5UBRYRim8YvTlcN2j7sfUHx2o0mzd2VNy08w=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM5PR04MB1181.namprd04.prod.outlook.com (2603:10b6:3:9d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12; Thu, 10 Nov 2022 10:38:08 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::cb5e:7ea3:2482:80f8]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::cb5e:7ea3:2482:80f8%7]) with mapi id 15.20.5791.022; Thu, 10 Nov 2022
 10:38:07 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] scsi_error: do not queue pointless abort workqueue
 functions
Thread-Topic: [PATCH] scsi_error: do not queue pointless abort workqueue
 functions
Thread-Index: AQHY9A+Zccbne0hZpE2K54tDabFWG643+OkA
Date:   Thu, 10 Nov 2022 10:38:07 +0000
Message-ID: <Y2zUjhGZoyzADUsC@x1-carbon>
References: <20221109074754.24075-1-hare@suse.de>
In-Reply-To: <20221109074754.24075-1-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM5PR04MB1181:EE_
x-ms-office365-filtering-correlation-id: 8dd6f197-dfbb-4880-68de-08dac307a7ed
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kamtNrOzLR+j0NUiiCnlSXkR6dpyEyydAIi5dO+ag4udx4ZVrq5U97miMJVZbuHwSZTgqBFK9rppNj/HWveOaLSOGTonU9DiB05aNwh6G4bZyOUuQq8JuEgEEit8ZIY2KPH55pdBX8dVkZqOSrOOmDWR3rB5jydWocokJTWB+Y1HlkfO5zGILUgJrO2wGP/15W/uq0ZQKDpf4EG5TCVe/cDEA9lqys2xJPGkF2NRyFjhamheNq/6RFzmwdQEm3fI5NnRlqb1hGe7EyWuV9X23eDPguo/No+Px/zv56jBpbWeY7axCInvL6lqCqfzAhJ8nx4EW47MWGkv/Sbj2tOOQjfs80ZKaHehhg0n1JFb9urh8BPS1C4F7IS5wZWVEZNdMYkg4V6w6hNJnSI/EoRVGtFmJ50OPgxax8hu/RphUxud56wSHPOV6NOP3y6jHmhvYSfF+Y/a4pBMQ7AFUkTd3aZ2nlCWxxOoa+NQDpcmzfa2uUw4ymVohNSxz7jWj68zBR3UnnKOW+yZ+FhOBxOzCyuKuZKhwusBgY9TMitO3f7IF8RwZKRCDd/yQW3EWPVodu+bZ/yHAlb4JN7rwAWv4vSVxV2p3XDa2boDzjhsXQfyE5flzjAwqLtoqyexpbs83kHS0TifmqQ+bmO6bJo5Mh3rDxSdRPVqfztbTaGwTzCa0OY1g7l7BgaNwxzm32EXj+YKHPTfim3IrIi0Eo7mhjWmZWTQsmEnE7h8XcSJdFg2x3txVVtT3FyrHeLPFgrf9ALufvcdMAeh2/yRfNOxJUT1Nc4bcTuL1LwajCjL1Ac=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199015)(71200400001)(82960400001)(33716001)(122000001)(186003)(6506007)(38070700005)(2906002)(38100700002)(5660300002)(8936002)(478600001)(54906003)(83380400001)(91956017)(6486002)(316002)(41300700001)(66556008)(6916009)(86362001)(966005)(64756008)(66446008)(9686003)(66946007)(6512007)(66476007)(76116006)(8676002)(26005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4wPPrlwD8mGXMP9CC1DPZyqgQxHSrZhk6DFV1nmhZAS/IR0nlmJlTCrjOomq?=
 =?us-ascii?Q?cTC9xg+1tHgvQWSUhvabyhYgCKqIt/ujMK7nxOx+Ev3sh8xebPznVNbSJZgG?=
 =?us-ascii?Q?7YIi1xuBqgX7xkK4b/W79fiPk3zqVaeeBCdC5D2Xdd6bT0iWOaO5K1U/evzf?=
 =?us-ascii?Q?Zz48SFZ39FCii3hO8n6FkLRi7zZ5ecafiRovR5P3Ca5t8brp1JQxUgQeM7ZI?=
 =?us-ascii?Q?kcbixooSaCNU2eRQLYjSNdNve44IubvSJ/oT3YOsj1WCGwNo7fskstHTWR8R?=
 =?us-ascii?Q?0NZcPE0dy8ps9p43oVkvTo5IJvMo3pz/gMjcDTI//V1+FzhIor85ad3TLsVP?=
 =?us-ascii?Q?JQhD/fCfqVG9TFtImZ1BlCzxFr1EzYHdQErWNZExhIhou5XkjjX8Pd0QU6Oo?=
 =?us-ascii?Q?Neawvhwlgqfw28gJUjjrlIBFoVjsvrm6pYw2HgrJKHzBjer7nRbvq355nGpS?=
 =?us-ascii?Q?LBCpTCqzW2qQ+6V2LpEQwkQmWM0sfSICHUZEKdZItg5HBFKRJPZCDJ2gTJ6w?=
 =?us-ascii?Q?Kpq9c3DKKoa5u7UBzc6ePWCvu18d4IQvCEahzd196CoQYfdIULqeY+aSC6Dk?=
 =?us-ascii?Q?g3T/6rVFQBEP6pW/fhgCkLmX1No28/JdXpZhYp6fDju7B2j0ixkk0Pv3yjVj?=
 =?us-ascii?Q?NJXdUq5EEppq77mNzckAi4TOS/22KX6nDLxwcraQwCeSGdNRASIswtGw2TiM?=
 =?us-ascii?Q?A6i4s58xv5PCkMYmSqjdrOiUMo2cdvchs161pnLTIAaDjXviORDRQ7h4nHxx?=
 =?us-ascii?Q?3WwBQtUjBgUtZha4uG+0lngORUXM74ADkUOGxdYq44bf6UySmYhDlstgqfq4?=
 =?us-ascii?Q?yxxydtKDA01BRznNPD+twzULWOKuh/32s43RzYhyQHP/d1BxrgXza0kgm2Qs?=
 =?us-ascii?Q?h/TIc2AtcZBeBHflGFVPUVbBAA0NFLSFgBiLfzbLKMnxXFAN7bXFOOZKaejh?=
 =?us-ascii?Q?raqqj9RpB4LOWp3nYNuG5eGV47pQ65r6VFKPwYHNa1t5p+AwgDmx9kMEWPjy?=
 =?us-ascii?Q?wSaEyMbHLahVns5ZD1yAQG+a/CRDG+R4JXkVoyQ9cKsaP6JJR2YtU6t0EKjc?=
 =?us-ascii?Q?XGHme0JYR9sDfCYUCY8x8gdOjYd7z6455kZVkd5DTLJXeAHnyI7MV1gqpp9g?=
 =?us-ascii?Q?gU4URgqhJ6rEra5DtdVkhxFeaunShmnYV0aTq2JJQNUD61X6wUT4LckdnS7Q?=
 =?us-ascii?Q?3QRvbi449GFCnQV9b28Neglc90DLoGo4gaAxYP7wIi7O7DutyuIBOIwXtULj?=
 =?us-ascii?Q?edJ4k4XYR6GHYnR+Vl9cV9gs81Hs77yO/YbMEhitlhyp6N8u/E/Zigd26sex?=
 =?us-ascii?Q?t23Mz0ay4W1zM7I9/63gN17gp+KS9Q01NMaZYErTNN88USegNQnQbxuPxTpP?=
 =?us-ascii?Q?Gg7YC0AjxHwBszWZSVhJIQisOQJx2l32L1gD8k3Pr5+0fyUKmsaHRb0+uOqq?=
 =?us-ascii?Q?vXDc7sXSkCC0I3O+DxzMACQaLVzQRw+Z5akElRvd//cVNYTC8vSK8tTjd85p?=
 =?us-ascii?Q?OHQodUhJX8gI4PbfAXmctjpudD6PZ9FWvv9BfkU5OC9vW/VMjojSxLvnIW9W?=
 =?us-ascii?Q?3MlERO7tlRx841Txoj/XX0yrP992rXYbGR9olDp+rzLccLV7FJjYf+NvSU4H?=
 =?us-ascii?Q?yQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5C161CC66347A047BA28E75C8C4BC641@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd6f197-dfbb-4880-68de-08dac307a7ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 10:38:07.5262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vmn5RJ2uqWDfxBBV/uq+WQrWkEd+IuRvtbQbAjrSirgzbF7vl1M6yiUyYV/G0oqfLkvOcX7HPcUY7JeNoc6rUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1181
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 09, 2022 at 08:47:54AM +0100, Hannes Reinecke wrote:
> If a host template doesn't implement the .eh_abort_handler()
> there is no point in queueing the abort workqueue function;
> all it does is invoking SCSI EH anyway.
> So return 'FAILED' from scsi_abort_command() if the .eh_abort_handler()
> is not implemented and save us from having to wait for the
> abort workqueue function to complete.
>
> Cc: Niklas Cassel <Niklas.Cassel@wdc.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: John Garry <john.garry@oracle.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index be2a70c5ac6d..e9f9c8f52c59 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -242,6 +242,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>		return FAILED;
>	}
>
> +	if (!shost->hostt->eh_abort_handler) {
> +		/* No abort handler, fail command directly */
> +		return FAILED;
> +	}
> +

Hello Hannes,

is there any reason why you didn't put this before the preceding
if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
if statement?

>	spin_lock_irqsave(shost->host_lock, flags);
>	if (shost->eh_deadline !=3D -1 && !shost->last_reset)
>		shost->last_reset =3D jiffies;
> --
> 2.35.3
>

After some additional testing with this patch, I did notice that it does
introduce a behavioural change from libata perspective:

Before this patch, for libata, scmd_eh_abort_handler() would get called,
and we would come into this statement:

	rtn =3D scsi_try_to_abort_cmd(shost->hostt, scmd);
	if (rtn !=3D SUCCESS) {
		SCSI_LOG_ERROR_RECOVERY(3,
			scmd_printk(KERN_INFO, scmd,
				    "cmd abort %s\n",
				    (rtn =3D=3D FAST_IO_FAIL) ?
				    "not send" : "failed"));
		goto out;
	}

Which jumps to:

out:
	spin_lock_irqsave(shost->host_lock, flags);
	list_del_init(&scmd->eh_entry);
	spin_unlock_irqrestore(shost->host_lock, flags);

	scsi_eh_scmd_add(scmd);


So scsi_eh_scmd_add() would be called.



After this patch, scsi_abort_command() will return FAILED instead
of SUCCESS, which means that scsi_timeout() instead enters this
if statement:

	if (scsi_abort_command(scmd) !=3D SUCCESS) {
		set_host_byte(scmd, DID_TIME_OUT);
		scsi_eh_scmd_add(scmd);
	}

Which means that scmds reaching libata .eh_strategy_handler()
now has host_byte DID_TIME_OUT set, while before this patch,
that was not the case.


I guess we could simply clear the host_byte in libata's
.eh_strategy_handler() (and that is actually what we do).



I just want to understand how it is meant to work.

Looking back at the code to when libata first started to use
blk_abort_request()/scsi_req_abort_cmd(), DID_TIME_OUT was only set
if scsi_eh_scmd_add() failed:
https://github.com/torvalds/linux/blob/7b70fc039824bc7303e4007a5f758f832de5=
6611/drivers/scsi/scsi_error.c#L181

Martin then moved the set_host_byte(scmd, DID_TIME_OUT)
to be done regardless if scsi_eh_scmd_add() failed or not in:
18a4d0a22ed6 ("[SCSI] Handle disk devices which can not process medium acce=
ss commands")
without really explaining why.

Then in your commit:
2171b6d08bf8 ("scsi: make scsi_eh_scmd_add() always succeed")

you changed scsi_times_out() to:
+               if (host->hostt->no_async_abort ||
+                   scsi_abort_command(scmd) !=3D SUCCESS) {
+                       set_host_byte(scmd, DID_TIME_OUT);
+                       scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+               }

And it also changed scmd_eh_abort_handler():

-       if (!scsi_eh_scmd_add(scmd, 0)) {
-               SCSI_LOG_ERROR_RECOVERY(3,
-                       scmd_printk(KERN_WARNING, scmd,
-                                   "terminate aborted command\n"));
-               set_host_byte(scmd, DID_TIME_OUT);
-               scsi_finish_command(scmd);
-       }
+       scsi_eh_scmd_add(scmd, 0);


So for libata, which did not set host->hostt->no_async_abort,
scsi_abort_command() would return SUCCESS, so we would not go
into that if statement. Instead we would have the current behavior
where scmd_eh_abort_handler() fails, and does a goto out;
to add the scsi_eh_scmd_add() (without setting DID_TIME_OUT).

Should perhaps scmd_eh_abort_handler() perhaps set DID_TIME_OUT
unconditionally, to match the code before the change?

To me, it is not really clear how the SCSI code is meant to behave.


I think if the timeout has actually triggered, because the timer expired,
it makes sense that scsi_timeout() sets DID_TIME_OUT.

But if e.g. libata called blk_abort_request() to abort the command before
the timer actually expired, I'm not sure.


For ata part, it does not really matter, because currently, libata always
overwrites the scmd->result anyway. However, there might be other LLDD
where this change actually do matter.





(For the curious, libata's own way of detecting if the command actually
was a timeout from scsi_timeout() or if it was an aborted command works
like this:

If QCFLAG_FAILED is not set in .eh_strategy_handler, then libata EH does
not own the QC, so it was scsi_timeout() that won the race, without libata
ever aborting the command. It then sets qc->err_mask =3D AC_ERR_TIMEOUT).

So libata currently never looks at host_byte(), it always overwrites it,
and it instead uses its own way of detecting that a timeout occured, if so,
it freezes the port (disables IRQs) and resets the controller, and increase=
s
smcd->allowed, such that the command is retried.)


Kind regards,
Niklas=
