Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF15C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 10:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F166E207BC
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 10:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rvxAA/4A";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oTBKo822"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgFMKsd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Jun 2020 06:48:33 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43724 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgFMKsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Jun 2020 06:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592045311; x=1623581311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4IgpfZfmeYhZ9M/EAl7XrGDkFqpnupz//KAZOUOwULQ=;
  b=rvxAA/4A9j93r2fogETegJWfAoHQGny3HKvxZEKXQQjtBKozShcu4fTY
   YtxhfCHm0gQec/sASeSokpx6kqIxZDiSxkvBJ/RlQQWv+Ri67MrWwXV+N
   6SgC94vB+noYqiRPHHOV8wPh9HRNrR/SQsY0pHYdrYiiC+DWRnyKGYA9l
   /gKZUXp/eeW9FR7+xt6NhY6QA22EH45HQG3i4uOiXZ3Fv2WiET62xYbok
   ur1sbmgvlTZknsNTTpEO5e+Rw4pbhbYrg84bt/tuQip6Dcfj8pVJdf4jZ
   /US+Ltawf6XOAoofBcGs/tTxsykwtXMOVa5OOZtvE9Ytl2hKA28URFrt5
   g==;
IronPort-SDR: A4uP8KPI/Uho8AJqq/h27cUJEGfAPMj0hZSlApwiYVI+n5ud3E6RVENCvdwKBExu5kdkzmvs+9
 f4ARB0mLjeSfx5MuwjlQ5sQuHLg6mG7MWFYU1qu/ZtT+AhGYz1SMwwM1PgDX2VQtW5I+vfLu2O
 vAwpLmyxzM2Ess/NSpm/j/84aVDJRv9fDGRHtyQSyxVMS69BszHTIZ0V57gF0v5WdCuuJ5XvuD
 IrQTWXadVMKfEkiJxYuhywPTgqXxXVYAhT29GVu4+kHpjLnHS2vKo2t7tKeXVp+2QHwp+0A34N
 C6g=
X-IronPort-AV: E=Sophos;i="5.73,506,1583164800"; 
   d="scan'208";a="141297128"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2020 18:48:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsJviH/+mF3ftwJobPw9M7e0IEA1TP35+kZdLbpzT56yJKtlQVN/84BwWA+ESkoYmukhblJ8lCUHV1jOU83ualqoO/15kRwHx4HEupd5N+jI5i/IuqrUCucdr4NgbxIVlCkKbsetCtQbBqOsgWtahd1MZJy8lPZ5NFL0cyQWk+oiqop7UFkj0YNo0XldmFsEujWpLCTf0O0896GkeCFYjMDqJMI3K/Wjcxo/KqLOJ0ZAh4tPAzqbXMqCgNNCCeii6ES3k90EXWqGO/psADfntvDFS3dDEfTVqSe7iyD5nJNfAQ1ejweiM1acOeZfQ+I0iCHQl9PaxV7p4/093nynHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSXHUdViFcpIqWc+XbbZLhvjFyxuR6EGaliBuIzOTPQ=;
 b=EFuoMqkEOiOjZdl+h0FSXUxFQMKYkl3On7IwDIUM7cEUX4+0pw1mYH0fuxlMiOC0OHn5vf3miLjqXY6IdsBeQZHTszRbb7CupaU7u9tZxsfYXhmwAi8Dtrc+cPVGuq+dokLJxz1+98k8dytThK7SWjYIO4VEeUiy3f6TkOruuBHGT450miRyiSSn3jB5cULeYT6f1aIRr1EnZjIBqkU92VWA57rEgfIi2e6IP7518ERT3c/Ar8QN4ptKBQY76Q4URIShdnKkYJGqmrLNiJxkO20b8NAAZ+EnkLcKB6P14aq3XdZMxtX1CPR/chEp7dcFrrB9tfCMiaci5uwbaHgjJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSXHUdViFcpIqWc+XbbZLhvjFyxuR6EGaliBuIzOTPQ=;
 b=oTBKo822X2Oqch3qxZFQRfjIzmMfRgI7B3ROt33eZ14rSLTqKMbLu22UGcY4GYQ55CYqk3VC/RLwYiN1uwsQ9WJfa2w8XTgRvDtlfzySjh2rKsRsTmyHD8fJItiKle8/cV85WDt0DHLz9xfawt8mBb4CQ1LIbiW/oC2s7OQD+x8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN2PR04MB2350.namprd04.prod.outlook.com (2603:10b6:804:8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Sat, 13 Jun
 2020 10:48:22 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3088.023; Sat, 13 Jun 2020
 10:48:21 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v1 2/2] scsi: ufs: Add trace event for UIC commands
Thread-Topic: [PATCH v1 2/2] scsi: ufs: Add trace event for UIC commands
Thread-Index: AQHWQMuVYKwzY3Iyf0mpsLlh28O4SKjWW/nQ
Date:   Sat, 13 Jun 2020 10:48:21 +0000
Message-ID: <SN6PR04MB4640968DCD865651AFA8925DFC9E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200612151000.27639-1-stanley.chu@mediatek.com>
 <20200612151000.27639-3-stanley.chu@mediatek.com>
In-Reply-To: <20200612151000.27639-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:d566:1f5b:a970:690c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 38c49df9-2682-4548-bc75-08d80f874a9d
x-ms-traffictypediagnostic: SN2PR04MB2350:
x-microsoft-antispam-prvs: <SN2PR04MB23504F74D9050C91400456C1FC9E0@SN2PR04MB2350.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 0433DB2766
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QH5mTo6UV+BvSumosL/Z+5ok43M0WQLW0twp4a/hLeCPrbW/uxNYAg7uHpebQcQ3MOSoxIpiRpq7COvh8iWdzOsEMd5u7289wmS2w2yweBO0rZXhSlpY7XspcaHGd5AC427pvrW1L+OOkhcATK1YlkBa4Kkw4nYDZRosJZJSQRwpwyE+An+Zuj4XzXbwpCgcJenEtpO113vu168VLLpaojcXCyEB1fvMWAl42nztcyCu4k1JhleO/j4OaCqrmYI8v+vCF7PeP9/H5UQpKE516KElm3z5bgh1HHehe3sj5W6pf4CGQln+rlpIFIFeQ1cmJjCdsFfKE9nt1Grd0pxBoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(55016002)(71200400001)(66946007)(64756008)(52536014)(66476007)(9686003)(66556008)(66446008)(54906003)(86362001)(110136005)(76116006)(316002)(7696005)(186003)(8936002)(2906002)(6506007)(8676002)(33656002)(83380400001)(4326008)(7416002)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: oEMjgJusKtEp2UVTJOaU10qz8zN82C2jCoBW9hkrVwhGUaYT6/MqbByXW6lO0Za2g5oJmxEGLx6hvsZedpb1x/HTau6slu0RQSZJZ0WDrx9qwWXS6G5bxfeA3t13Txedw9j0+iE6Odlv+Piiq0eO5egHz+a9WzDkY8iM0ci3Y/uj9MZ+oWeXnSZfECZwEl8JICjVIf5rpRiN0PlDVsy7nQ9K2/YgIZK0I3bK/WdwQso76dDVj8M2sFAKi1Skbk8N+cAYSLoAXLt0VCnk/oR9qxJ4+0BOm2yuOx3SNPIa80N4Xv2/ndks+u81qV8xTNUxRIFr0fZwqF3nDX14wobFxQw7+ou+0sBAp96TsjW3P5c233PPjKkGMrGToYqpIcb9WJGf31/3sOIWr0HFOqkIwdP1MdDGx9UiLzK9/Twpo4X+otUdSgs7gdIY+GPATgwFFvMRTI1mIR6J6cTpLkqdzMhKxQOcwbfBOhPMHHMLJrXUZdsS8ChuKCCTCQzB8n7WVxTrtaD5MxAEX3r7OaTSPYYu1IRhV5O1t8ZeSW4OH4t09HznBnLESMAayXrT3r9T
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c49df9-2682-4548-bc75-08d80f874a9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2020 10:48:21.7929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kB2K77rChAkj2gpARUuGEtt4Ka9wCKkd0YzTqG9dXebrPKgHcw/Z7IEHQiapeJAngHBKe3Hy5/IFCkGYRJ/tzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2350
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
> +                                        struct uic_command *ucmd,
> +                                        const char *str)
> +{
> +       u32 cmd;
> +
> +       if (!trace_ufshcd_uic_command_enabled())
> +               return;
> +
> +       if (!strcmp(str, "uic_send"))
> +               cmd =3D ucmd->command;
> +       else
> +               cmd =3D ufshcd_readl(hba, REG_UIC_COMMAND);
Why on complete you can't just use ucmd->command as well?

> +
> +       trace_ufshcd_uic_command(dev_name(hba->dev), str, cmd,
> +                                ucmd->result,
> +                                ufshcd_readl(hba, REG_UIC_COMMAND_ARG_1)=
,
> +                                ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2)=
,
> +                                ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3)=
);
Why can't you just use the ucmd members?
Why need to read those?

> +}


> +
>  static void ufshcd_add_command_trace(struct ufs_hba *hba,
>                 unsigned int tag, const char *str)
>  {
> @@ -2054,6 +2075,8 @@ ufshcd_dispatch_uic_cmd(struct ufs_hba *hba,
> struct uic_command *uic_cmd)
>         /* Write UIC Cmd */
>         ufshcd_writel(hba, uic_cmd->command & COMMAND_OPCODE_MASK,
>                       REG_UIC_COMMAND);
> +
> +       ufshcd_add_uic_command_trace(hba, uic_cmd, "uic_send");
>  }
>=20
>  /**
> @@ -2080,6 +2103,9 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba,
> struct uic_command *uic_cmd)
>         hba->active_uic_cmd =3D NULL;
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
> +       uic_cmd->result =3D ret;
> +       ufshcd_add_uic_command_trace(hba, uic_cmd, "uic_complete");
> +
>         return ret;
>  }
Can't you just call the "send" and "complete" from ufshcd_send_uic_cmd?


>=20
> @@ -3760,6 +3786,9 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,
> struct uic_command *cmd)
>                 ret =3D (status !=3D PWR_OK) ? status : -1;
>         }
>  out:
> +       cmd->result =3D ret;
> +       ufshcd_add_uic_command_trace(hba, cmd, "uic_complete");
> +
>         if (ret) {
>                 ufshcd_print_host_state(hba);
>                 ufshcd_print_pwr_info(hba);
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index 5f300739240d..cf8d568d5a13 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -249,6 +249,39 @@ TRACE_EVENT(ufshcd_command,
>         )
>  );
>=20
> +TRACE_EVENT(ufshcd_uic_command,
> +       TP_PROTO(const char *dev_name, const char *str, u32 cmd, int resu=
lt,
> +                u32 arg1, u32 arg2, u32 arg3),
> +
> +       TP_ARGS(dev_name, str, cmd, result, arg1, arg2, arg3),
> +
> +       TP_STRUCT__entry(
> +               __string(dev_name, dev_name)
> +               __string(str, str)
> +               __field(u32, cmd)
> +               __field(int, result)
> +               __field(u32, arg1)
> +               __field(u32, arg2)
> +               __field(u32, arg3)
> +       ),
> +
> +       TP_fast_assign(
> +               __assign_str(dev_name, dev_name);
> +               __assign_str(str, str);
> +               __entry->cmd =3D cmd;
> +               __entry->result =3D result;
> +               __entry->arg1 =3D arg1;
> +               __entry->arg2 =3D arg2;
> +               __entry->arg3 =3D arg3;
> +       ),
> +
> +       TP_printk(
> +               "%s: %s: cmd: 0x%x, arg1: 0x%x, arg2: 0x%x, arg3: 0x%x, r=
esult: %d",
> +               __get_str(str), __get_str(dev_name), __entry->cmd,
> +               __entry->arg1, __entry->arg2, __entry->arg3, __entry->res=
ult
> +       )
Personally, as those trace events aren't very human readable anyway, I woul=
d just dump the uic command,
And let the parsers do their job.
And if this is the case, result is redundant as it is part of arg2

Thanks,
Avri

> +);
> +
>  TRACE_EVENT(ufshcd_upiu,
>         TP_PROTO(const char *dev_name, const char *str, void *hdr, void *=
tsf),
>=20
> --
> 2.18.0
