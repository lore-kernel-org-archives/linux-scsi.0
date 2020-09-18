Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4146BC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 00:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2021208DB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 00:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nHZ4tmSV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FcHS8tdc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgIRAhw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 20:37:52 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36784 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIRAhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 20:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600389471; x=1631925471;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SdQ+a9T7i6NNzaY5QysLkrVQr6p+rYhrMKmZPUhCVWo=;
  b=nHZ4tmSVgzQSLUR5JvORTO6GzJRXO8iAOpDar15/q6ghTjtQmzYL5RqG
   +JlUXZIWmNpwG2+40r3d4kZIbRk5LNjV93yWhEGeKkT5oHnGQeiQXvdQy
   ZCi79PPFc4Y080CwMrBan+vJBCiHW5YLuNQmnzcu1NfokFfrLRQExrVo0
   vjLo3QvD1Qz3rpVgdJXbbi86Fyts8F3qzT4GmBeXuvAvYrftHTwdPmF+n
   2fb93K1UI6r78+3rTqkNkIEI0tpSeBHOE8q4T73ZxHBJvthMMI2Bc/Rnw
   Jv+rsZtSecHSoVCHPD+w4klpveb5kT4Sf00i9yNxizfbGR23HZLVRoByf
   Q==;
IronPort-SDR: TbmZzufzTD0zvbwPKvEWFY+ThJ3V9zpI3hb6f/rxr+BGquBAez8NdIUyP+iQNB2wKOP2mw5iG+
 SQ9WB8ULt/1GwnwG1p30gyS1jSjC4jDpH/bqbMtLMPdKDSRTp/1S/4n48G50HPZYnEJh8U0JOL
 pSF3agh4RPz7oTY7weDnv2rq2rbYggcfu+mb18MYMQT+FGU7JYl+llh2aFyludte8w77qfu3aG
 jDdCQhe0FIXbyfKZ+PWeOz1u4tTziyl2X8+em5w/mxiXaxhR2/68CAqJnEKm8I9eGsUIp6TmPS
 mrU=
X-IronPort-AV: E=Sophos;i="5.77,272,1596470400"; 
   d="scan'208";a="152045615"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2020 08:37:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1zMC5pYmTLlcpjb95y1No5UiOl8WlSZxz6SZwrvqQjN/Y96yQkQp3ce+HzxEeTCszrfaIJSv+rqnp/RKd1gnKquQtjMJG9VdwlD4TVS2+QyXyb5G2vu3ngAT/7bcI0zP2+P3zkjxyX2VKmL3JSP/9Mpta41iuoPZPAE3661prGHPaG8Us2XPtQpoxhBQDCXP9Iwlou8ZQBrGXyyRQbBdY0YIE96CSczn4naucQxQ+7JHyYVkgWi2tXwz3EWYS84P0NBuVjsDOs9sKYIEruPsP30k5cm6zCmaK5H5YCkLLFRRQzBepLm/AbilEfHBlM4W4hD4D+JL3wfTzP/hz/pqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtMaZla2pDwUHqmxVJrvaYxjDdYv407oHbLfM/sjZ+Y=;
 b=ZCYkHc696wBL3oRvKu+QZey2yUU0T/gDZl0oIx1ipDOAqblwOkzQWGrI48AQTdA7yHJ7ViqiBFaxFw/X/Ar1t/EOVHs+/ziUSL5JyNFIlKHg5Q8hfI3kGpx1jy92gtpbyjZOGoKFMTIPBRK/D0bzz4SNjBH5A4L47aqi0J03UegfAxmmSQPuBh3JiYfg4doKEsuo+6fsJhWFCqyPK+UBAUKgf0V8Am/s5M7wK0x/3k88J9qBvVTagc82eXrijQrb/mz4NpJGJ4rIh+0ckqb4Ss9bbsMCPAz1XYPLMHrLlK+ofNVhOomq9bBkBu9zt5vXtE3EgAqjZ5eJTe1TkQftzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtMaZla2pDwUHqmxVJrvaYxjDdYv407oHbLfM/sjZ+Y=;
 b=FcHS8tdcH86xch2XxZMd8d6JIC1F/e4BVnkip7D3yoixCP1VHnnbiMiURwQXB/gkwYPkwi7oN0Ra0yllGd9N0uOT2/pUvTFFqAOpTOWm9ya7DotaAHMvPzvHRlksgFOhKiCYAvr+4KKlRbqARk66XBrAWrj44IEIrc57wV1KmT0=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0760.namprd04.prod.outlook.com (2603:10b6:903:ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 00:37:48 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3391.015; Fri, 18 Sep 2020
 00:37:48 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Keith Busch <kbusch@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCHv3 4/4] scsi: handle zone resources errors
Thread-Topic: [PATCHv3 4/4] scsi: handle zone resources errors
Thread-Index: AQHWjUjprU6FjACCZkqMdOabMh4vgw==
Date:   Fri, 18 Sep 2020 00:37:47 +0000
Message-ID: <CY4PR04MB3751016C986A95E69AFCBCA4E73F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200917231841.4029747-1-kbusch@kernel.org>
 <20200917231841.4029747-5-kbusch@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:c162:b6b0:12c6:8cc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: db47a65c-d7b0-44e9-023b-08d85b6b112c
x-ms-traffictypediagnostic: CY4PR04MB0760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB076050349A07F48104404528E73F0@CY4PR04MB0760.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ga8z2r5J1qcOiNtuzPB1wKPsFkCfwUZY/jaXbEgnq2UO5gLF9veIQXLq9TegRBoWCZvgGao2sbEOg8YbxsuNkmGk8/TTUny0t9yAZDpogSTWBWGzOiuk90q6zhFYWPbwamb+8sZ1y+AD9va89nC7jf8zNmZ1oJHrA/os5EkLlQajxjnUMJZi6EsQjs2NFpF0M6xvW2QjHn9jQ7WqDIMHpOT5Rw7PhSz8k0N56S4dSSQbd9+ZdbIP3kYxnx0lh72c7wEwiHH8WmPdC2tR2/Z6J/7mWYmtfRjIl6Ng6Uzi0Yah7PIFmf9QbZAX51Km9MU6hGhBHxZRboc+Vyzt7YA9bA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(66556008)(91956017)(76116006)(66476007)(64756008)(66446008)(54906003)(316002)(33656002)(186003)(478600001)(8936002)(110136005)(4326008)(7696005)(86362001)(83380400001)(52536014)(66946007)(71200400001)(55016002)(9686003)(53546011)(2906002)(5660300002)(6506007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8IqE1mY5SZ9rSqVpO8YZSht5rre9Wp46zwEhv/EwFrPFKSTyQy/C4Bl7A92M5PV1KBPpfiyuduzXRsNGED6g+WblIBQ7P97weA4u7tby8XBXxiSsRQTN0Xs75PgfX30+diEwVvRkWk2XaJS6uQNfrwCYzYXIqRRPe/A/PKVAZz+T1Rj29HzeoyrGDE8mDs0oEtvl7FWJcTBmHwPDRyGFs5EsYq5Xv2gqJ6mV55DZYqyvD0tq6jucxgU0aIjG2U0yIr00cjjHq9IlyNKt+6mCfq+ah6cOHEoOwgu3+0y/1TlMaSnRwsDSRQiPoW6Mv8ezLCsSCM/gWwppRlmkRxfsfDMdX9EXSrmlYQmcZLLx2LaLmBhoO0iEKsWUks5jkkfDAFCxat+On8DBbtx3fHZguRScV9z7Z57JRqnyh5gOHGFBHtbrS1XteXLwQBxBTrl6COGuA8SWpZTFpEbf/zY8rjDlN71qKkSPc6wAQcvQWGIscwd1/8YCgUtavgavULL/GJNeDLS6WW8Bwdi9el6Xh5WHFXuXHXLHp5cW2A6Rmsq6EVBaPvKPm4iGrmjhCObhBmzXEJCWZLjy6vWXg7H80n226S5DFxNbTvB6rJG9rRr5Lvq7I1paIZfik6aPAK+1GC7w23QQVlFZHVXvhuhZ7Y/m/BkxgZtcpJaqynW+B/FvhMMR6B9wNPVfpsUf9OAeYIYazkQKDgEtmZmsApGXcQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db47a65c-d7b0-44e9-023b-08d85b6b112c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 00:37:47.9570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipGZkZs5Oai3xA2C1GY4N0uOjRzzzeNo3RZFs56f9nSNRN/1a3XjxpYlCymNddjttr/4sLNulwzkMu2JoQs+0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0760
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/18 8:18, Keith Busch wrote:=0A=
> From: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> =0A=
> ZBC or ZAC disks that have a limit on the number of open zones may fail=
=0A=
> a zone open command or a write to a zone that is not already implicitly=
=0A=
> or explicitly open if the total number of open zones is already at the=0A=
> maximum allowed.=0A=
> =0A=
> For these operations, instead of returning the generic BLK_STS_IOERR,=0A=
> return BLK_STS_ZONE_OPEN_RESOURCE which is returned as -ETOOMANYREFS to=
=0A=
> the I/O issuer, allowing the device user to act appropriately on these=0A=
> relatively benign zone resource errors.=0A=
> =0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
Shouldn't you add your signed-off-by here ?=0A=
=0A=
> ---=0A=
>  drivers/scsi/scsi_lib.c | 9 +++++++++=0A=
>  1 file changed, 9 insertions(+)=0A=
> =0A=
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c=0A=
> index 7affaaf8b98e..c129ac6666da 100644=0A=
> --- a/drivers/scsi/scsi_lib.c=0A=
> +++ b/drivers/scsi/scsi_lib.c=0A=
> @@ -758,6 +758,15 @@ static void scsi_io_completion_action(struct scsi_cm=
nd *cmd, int result)=0A=
>  			/* See SSC3rXX or current. */=0A=
>  			action =3D ACTION_FAIL;=0A=
>  			break;=0A=
> +		case DATA_PROTECT:=0A=
> +			action =3D ACTION_FAIL;=0A=
> +			if ((sshdr.asc =3D=3D 0x0C && sshdr.ascq =3D=3D 0x12) ||=0A=
> +			    (sshdr.asc =3D=3D 0x55 &&=0A=
> +			     (sshdr.ascq =3D=3D 0x0E || sshdr.ascq =3D=3D 0x0F))) {=0A=
> +				/* Insufficient zone resources */=0A=
> +				blk_stat =3D BLK_STS_ZONE_OPEN_RESOURCE;=0A=
> +			}=0A=
> +			break;=0A=
>  		default:=0A=
>  			action =3D ACTION_FAIL;=0A=
>  			break;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
