Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A360AC43603
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 07:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E13D22464
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 07:11:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Bim01TN6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="H+iXtY1Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfLEHK7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Dec 2019 02:10:59 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:26495 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfLEHK6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Dec 2019 02:10:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575529859; x=1607065859;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Vcsp356+xptM0EOXCuBMYXzJZ+XQOd5sHcEcWEw62w=;
  b=Bim01TN6kv9lUb21SqKtA/Wi8CX22Geki8b3ghbgo1BA/x1YbKMmsATV
   BJNZzct9Wn82/1ifnsSSGZ/5xAIHJcsKcDRhlW0P/R/vBRilvw8TjX1b7
   FcthXN02WSWEmvfrTNhXseDCDCYE7qxtcla+WdZhxgVEdv6qw2oSAUwrx
   M6IXJNR7mOEaKjj4CxvtbLNMLYPGcYZuyvWHd8cdeihOmPWY0jj4mjo7U
   98WoFd6DdI+r7EHcEY/wCcc+5k5zjn6fjbG1WfG3/TvXelEocY7ik7Wic
   ad6icz/8YHTRpF6XHva/6uXUsQnpNKblBV9P3JN4tcGRrUjm+P6ttnh9E
   A==;
IronPort-SDR: GnT8WoR5DhqPa/PxxAzPe2nMiMVelEuyFMg2MMNgryTxVjX4T7aTHfci/0tu6D7GmW9WrUdEds
 d4MLO0Qduk+JcMoHIn8Q3XVpXQlqYNO7w7hFYMLGW5Hr7RjmmtUvuzRNB4+2A5PMxabnfZ3gz5
 7NU7HLu8GTgPtRY/RRoXO9JaX+/iHbTnn0VKy8XvVHvT8TBW8xxsX5xGj376bkM0hzPehphLo2
 6sukNlJ7BI28+P4rVoy+4Z5zg/GvC5zHvsiyuu7FWrrXlMjYuvJ1I3cXlGnwtDAPYWgIt9oaE0
 Znk=
X-IronPort-AV: E=Sophos;i="5.69,280,1571673600"; 
   d="scan'208";a="125433992"
Received: from mail-bl2nam02lp2056.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.56])
  by ob1.hgst.iphmx.com with ESMTP; 05 Dec 2019 15:10:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZMOc3WvZWZ7WdsX3VrRyu8GUtegGYnZrG/yfpqrG1sS4bWp8skOFuJsZy24TH+ITusTF5TOQVxREKjFHrABApX3JrtPHBJkgRuFqFv9Y35TbM1+Eny8NRrSpZCVmZG4eQJMX85jrvbK7v1GcPwcBn0kOHvlfaG7eq73ihoJkDrVHxtDWBtC+llCmakTFK59J75/Vxzbyctp1dB5vqsk+UY+S9d/P1oWU7zH7jxZ5TTPaJQ+QU9fK9VX6KzN/UyZXbcMnK+W1LzCX9otpRckzpQ9bA1M1HLa6HLTXVzQ+AgvnEPADr3MEemCzXO38hVqMo4ilLKtGQYLuDST943ElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1ubc7aTAViHpF/TaJ+zw/iu1WvXwKpLeZmOlEaXEBw=;
 b=MUVTYNpdWbNv5V3cTGhkAiOYZRUbRk5mU4lWhyzHuPhzEfDyenOkAmebhfu/1I8NLL82T9RvF+ePEES16W6K4jXJ/uFCQw4qZDSaW/VuDBswzqDShcCPecrs/SzxESUdzP3kw+WsqQ0y4ktBcUfojLDe5FhVpR0x9lNl31PLByCKDrVwz65IotqEenprf7ChSsBsLrqyCIKtJeEu1dH5iYjSSCSDbGGrL4p10GTBxKxYMky6kfd5kJy0FAdcn0OT1usKTWx0Isbb1NXQB1o7GEj0swAUOzto2TJbEuG2REc4b5TZzayh7o1E44/DkKVUScZTaFVT3gcCqzga/CAxbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1ubc7aTAViHpF/TaJ+zw/iu1WvXwKpLeZmOlEaXEBw=;
 b=H+iXtY1Yskk61Jtm/Dr32HBrafCKushhwe60DZVJWPdj6+0OR4rdHF3nQayiY2hTGIYD3zxbAK4H/OElRwBcdm3x502Wyc8yNXy+ACVl97JRJPDYGHvKWM3x3vI9x8EfC8r7NaXtx5Bagne03rLi6cboWWRYGxzfCWUQH7KJ/vs=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB7086.namprd04.prod.outlook.com (10.186.147.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Thu, 5 Dec 2019 07:10:55 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 07:10:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 1/5] scsi: Adjust DBD setting in mode sense for caching
 mode page per LLD
Thread-Topic: [PATCH v6 1/5] scsi: Adjust DBD setting in mode sense for
 caching mode page per LLD
Thread-Index: AQHVqxG7B53GU4JD7EG9S3YG2hVoAaerH8+w
Date:   Thu, 5 Dec 2019 07:10:54 +0000
Message-ID: <MN2PR04MB6991724DFB7DCEF5DA43EC5AFC5C0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1575512052-15999-1-git-send-email-cang@codeaurora.org>
 <0101016ed3d643f9-ffd45d6c-c593-4a13-a18f-a32da3d3bb97-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ed3d643f9-ffd45d6c-c593-4a13-a18f-a32da3d3bb97-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: be21af21-b7bf-4cea-c38a-08d779524527
x-ms-traffictypediagnostic: MN2PR04MB7086:
x-microsoft-antispam-prvs: <MN2PR04MB70868783B04C52BBFD93FD88FC5C0@MN2PR04MB7086.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(189003)(199004)(7736002)(71190400001)(33656002)(71200400001)(81166006)(52536014)(305945005)(81156014)(5660300002)(74316002)(2501003)(86362001)(2906002)(8936002)(2201001)(14454004)(99286004)(66556008)(8676002)(6116002)(6246003)(7416002)(9686003)(102836004)(66446008)(11346002)(478600001)(55016002)(26005)(186003)(76116006)(66476007)(316002)(6506007)(229853002)(66946007)(7696005)(54906003)(4326008)(25786009)(110136005)(64756008)(6436002)(3846002)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7086;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v9PyyAifFUir3hD2J15nKS+d3e/NCl0Juvpb+FaPyUXFMPMnJivWkHqPkckPuwnXN/X/hNcXH2W59UL6SGxFI0gnGmq/3wBCYnpwu6bqp30hOXNoD0iV22iDftzPSllEg1bLu9oqQa3JOPPnOD+okJ6NAQuLDIIK6OrejJydFxRSgOv+KeUHo++VJf3AE2MhVIFZ02z+5FDzbQEpNBnHtQLFLDxCkA2xu+NDHqPVOqY08l++0Zp7CpIMG8eMgDjIzEYYCdFuxfEA3Vl5ny43fhBG90F4WhV7HhegEJ8yIdWuoJs2bIohVDbVsUAXP55uiyjIBwtDTwxsQC9sj/n79liqkoR0Icxrl63c/ijX5PewZ9O6OkNB4QX6oxhDJvKqzJadorz4AqUoqLu+VZBuTMOkCa2FycMkDt7u5yS4xqMLBSfOABicFEV5J4n90vcE
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be21af21-b7bf-4cea-c38a-08d779524527
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 07:10:54.9921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 96tCtPYAJ9ZV+LsBLsaqpli7vor4doQee/v/9p7oLEnkwWJkBLEoDNKAX4tH34sLKEUk8/na0Ai3GO0cM2SdVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7086
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> UFS JEDEC standards require DBD field to be set to 1 in mode sense comman=
d.
> This patch allows LLD to define the setting of DBD if required.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/scsi_lib.c    | 2 ++
>  include/scsi/scsi_device.h | 1 +
>  2 files changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
> 5447738..3812e90 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2108,6 +2108,8 @@ void scsi_exit_queue(void)
>=20
>         memset(data, 0, sizeof(*data));
>         memset(&cmd[0], 0, 12);
> +
> +       dbd =3D sdev->set_dbd_for_ms ? 8 : dbd;
>         cmd[1] =3D dbd & 0x18;    /* allows DBD and LLBA bits */
>         cmd[2] =3D modepage;
>=20
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h inde=
x
> 3ed836d..f8312a3 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -172,6 +172,7 @@ struct scsi_device {
>                                      * because we did a bus reset. */
>         unsigned use_10_for_rw:1; /* first try 10-byte read / write */
>         unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select =
*/
> +       unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
>         unsigned no_report_opcodes:1;   /* no REPORT SUPPORTED OPERATION
> CODES */
>         unsigned no_write_same:1;       /* no WRITE SAME command */
>         unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(1=
0) */
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

