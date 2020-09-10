Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B56EC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 22:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E75A208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 22:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IXPzXoEI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TPnEuglN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725294AbgIJWQW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 18:16:22 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6495 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgIJWQN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 18:16:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599776172; x=1631312172;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=bQ8FO9lUqLnvAnZD0KDKlsieCxoxyrlyl1dOsOLzGLg=;
  b=IXPzXoEIRHlfemUC6PaO+jW4YfUGRTY1bceofBh9VEvl5TDqMKjJ9Dlt
   k2RV1LxfRVCjuOD8r0Vrbc60TjOh7vGdCFTbIkyrHUJ1H5Sayy/ukt2Fq
   uprewVSagk7HKjsQMO+Hq6v5RbQnrvwrY418F1/UAsmersgLmERQgqkDs
   w10RMwnrEKf10bXDIMhogGmDXm5eJA+wpk/Yc0ZMrG6eBPNYk9Aw2ShIr
   OF+0tuQfD5oqyGeBkFVjiNl2mBYaSybAffQC6Wo4oySlPulb+efJbMYYc
   3WhDkUxAT9o0nrbxmt4U/Y345xF7lJDHSotjfSAvHX19fUZv2Of3B1Imo
   A==;
IronPort-SDR: uiO9MCbje0EAXAKbQmWxn5FHsx2FPVNkbg8jdoVEJ4CROzu3V0DjhvJFuHkFMDITw/J1MNX6XT
 A6etnYlagm6Rwk28jLHRqCsaqeOByYA8BYP/QkE+WTWhQe1zB16+h/Ruwwys/R4rNzrkMt9irs
 p8ZtNo59zmuXRsovUTFF0MIXyIwVBU6QzP9VYTgr/U2Y4uj2jtjpWJmJMBZ3PiUY0hKE84GYl+
 wpkitOwEpb/PtH3HoKlw32bskEw/dc3nghs8dPw1YiZlzEeLlmE2eBtpWn8+SNA04iQGdQE3lm
 kpE=
X-IronPort-AV: E=Sophos;i="5.76,413,1592841600"; 
   d="scan'208";a="148303551"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 11 Sep 2020 06:16:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoCJwJ/0gE4arRWM4pqdG8z21buT3GhRe34tYSoCeAKTUK4LT/hFIaZE4cI3zd3AS9TsnIOx1KfmwdV3cUCSRP+gZ54M8tVo7CrC/e9Z9x+e8oViUhgGLmNRj8IbZvc5vpIdXfujbm9LHKYlWFzOA6kd5CbUcm6Kkh+LpAT6M29L3GToQPDNcwUn3a1hkk0RI4ljFv9sUTNZkpwaSIwbeSOT+0t+/N3nPuL9Bm5BN/IXBZO6FiiwvGiyMUheVwbwbt3sSMWFOkYKNwSUUCcQQSur/FaXQixasKhA/S3fra0B+YaC6uzCtY85Q6hx5LKIi80M0x8ZBUHfUvsEypP7aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yaGB/F4F2XqeG2BXQUi8G5gWIRVLOzDdUwJzB/wRO3Y=;
 b=SC/AiFD/05QQJvEiw6qcNGFEBup3DlRhqpAIH015LHw+WLS0ncy1iLr+nvB3nWiaJQiIxXv9Nk5/NugZuxJwgWbZe2Pj2HMSkvXuiGLrJ4V3vodLzmpsd20Nc66CmVZY5MkvPxREGWHTPsl7eurG8KqTQeVvAp7gfVF+WpExVocZrveovZmRFhIsNWhE2le76tsqinTB9l3VZWvS/MTF2euOIv0aAsHjV6k/jVc/UFOReE1V7Yzzm9nrs4OuJVByB/cnk4+BKxD1c4oEgVgV//6evybRUt/ZD4NROBDCqRxCuLDkkfq2NIBLyilZYEwAw+8RUNZLKSonlKnmUSxJ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yaGB/F4F2XqeG2BXQUi8G5gWIRVLOzDdUwJzB/wRO3Y=;
 b=TPnEuglNqieW8sGZlMFxzdqRVt+Eo3h6m+CGxF6CuFfiFGRC63nAWBa0dS+zTP4uUp1Ai+4QORkxrJX/Pw+Zo/Nw9xb09UGR0++w12/u2kZHXhbUXvp7uPBNc5ZJeAUlSFI5mSt6WbrV0gR4HSGt4ZVZUpmusDqWMEg2ptbMSbg=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1049.namprd04.prod.outlook.com (2603:10b6:910:56::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 22:16:10 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 22:16:10 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: handle zone resources errors
Thread-Topic: [PATCH 3/3] scsi: handle zone resources errors
Thread-Index: AQHWh0WozMaHZqBYmUGA3Kt7Awy17g==
Date:   Thu, 10 Sep 2020 22:16:10 +0000
Message-ID: <CY4PR04MB3751DC5CE39454498FBFA05BE7270@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200910073952.212130-1-damien.lemoal@wdc.com>
 <20200910073952.212130-4-damien.lemoal@wdc.com>
 <20200910175343.GA9539@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:dc48:bbfc:f5cc:32c6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e1fb0f8-3283-418d-f52d-08d855d71f4c
x-ms-traffictypediagnostic: CY4PR04MB1049:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CY4PR04MB104964945B4D65DBF4673FAEE7270@CY4PR04MB1049.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4iDyMrNHpaOm3oAo44P1ij8UdXFAdrfvnE4MffXNA+WLSwQHrXxT0LVR/hyAnFVinzAQLmVtfb+w1OgsJ0RyAs+Na0u/gciNJpw211uu9asXO6H+EB6ow59S5AfzOJMU8H88cgCfyhCykmZgk5Hd4YNJSEhirvneZTFSxCu555FYkwU6LLi+zjoA1b1uyMvTASp6WgiTmJWO/Ko4Xby/qec2OVTNIZWrZwtUqgoG/XDwBfEAySj0NNjNE+rh7z9aDMQ9rtyZqEZ/gPanaCKUYx17V6e+u3v9WlaPSGbB0X0JSElyJo/UBGt/sv/Zmcm5GsgFqeX51zQy/widKNz82A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(52536014)(54906003)(6916009)(316002)(55016002)(7696005)(186003)(8936002)(4326008)(2906002)(71200400001)(33656002)(83380400001)(66556008)(76116006)(64756008)(9686003)(66476007)(86362001)(66446008)(5660300002)(66946007)(6506007)(8676002)(53546011)(478600001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UGvZ2Bc0GYfG8G3yTcZdiegZcEYkV/UUF1XTeI6DEcTEcUBwIFAFuReoieu0FYD7F6snUDfzLhmyC3F+PM3iLquGwN1DsBcBnbpg6AfV6dKPd3ieLU0cr7jk0PRLmBkTt42Zqrlj/BIdDtBfUhG8ZfpPslJkFRBrqPyb7/FJgLwTSCDBN/iaPo9Hk2TnTITQ1+rpZ5LJ3iY33YNhyJPGkp2LEUBxhZEdabWrMkPA7XREWxleOhBxlVw9eUFxzYFBcwvb5YTBCh9hIq39uGQDFHtPrD6/o8xy74J66I38TWUuEaQhps7fNnNdCXA8+bShqW6PPsts42PdfZKQZN+dnXdzpFiN+pWoxa/a6Mif1u1Q4Uh9f+4JIKG7etIOgWyAn4yti3dRZSjMgDQ5m28Q8ha6+pKvLeUOfMy+jHyTfhZBqrR1rEZ1EETybZm4VDEnjrzFN6zk44Segx91ahKxMM7/IWnkqyT/XM+ZNQuOx+JHG0EYyShHSBdMSaWZoMnDf57o4eXkMsj7+o/7y+JC+oq8BCOCiMa7S5e20h/kLJUM2JHG7FfYvESaar/QQ2ZCgW2Kv5X+MTGjyjXgT+hHmj2cf6EosOl2Bh9GFBJFfVw3tAAFX/QYlDV5Ih9Z3HK2NjFMJbK6EIUB39gI6YefFiVyvvvw3MopeC//K2chN6UYsWZPBpo0w4ry09Br437NoHuRF+F8Edbhl/soBgpwvQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1fb0f8-3283-418d-f52d-08d855d71f4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 22:16:10.4072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tw+e1xJ4iZ3mLiYIAHYqRwV8AaIXjW1GikAQmq6lb/c1v51rNxwWuusSOCMQszJMxOAnqe3TnEbb0JnEtLKvtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1049
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/11 2:54, Christoph Hellwig wrote:=0A=
> On Thu, Sep 10, 2020 at 04:39:52PM +0900, Damien Le Moal wrote:=0A=
>> +		case DATA_PROTECT:=0A=
>> +			sdev_printk(KERN_INFO, cmd->device,=0A=
>> +				    "asc/ascq =3D 0x%02x 0x%02x\n",=0A=
>> +				    sshdr.asc, sshdr.ascq);=0A=
>> +			action =3D ACTION_FAIL;=0A=
>> +			if ((sshdr.asc =3D=3D 0x0C && sshdr.ascq =3D=3D 0x12) ||=0A=
>> +			    (sshdr.asc =3D=3D 0x55 &&=0A=
>> +			     (sshdr.ascq =3D=3D 0x0E || sshdr.ascq =3D=3D 0x0F))) {=0A=
>> +				/* Insufficient zone resources */=0A=
>> +				blk_stat =3D BLK_STS_DEV_RESOURCE;=0A=
> =0A=
> BLK_STS_DEV_RESOURCE is a magic error code leading to a retry on the=0A=
> particular request_queue once it isn't busy any more.  Please don't=0A=
> abuse it for random other conditions.=0A=
=0A=
Yes, but that is for the submission path, isn't it ? This change is in the=
=0A=
completion path and action is set to ACTION_FAIL, so the request is termina=
ted=0A=
right away without any retry (tested). More importantly, this leads to the =
block=0A=
layer returning -EBUSY which allows the user to differentiate this=0A=
temporary/trivial error from the potentially more serious -EIO.=0A=
=0A=
Keith sent a patch for NVMe ZNS doing something similar, which will result =
in=0A=
the block layer returning -EBUSY for zone resource errors. I would like to =
unify=0A=
scsi and nvme behavior for these recoverable zone resource errors.=0A=
=0A=
So should we define a new BLK_STS_BUSYERR status to differentiate from the=
=0A=
default BLK_STS_IOERR and not overload BLK_STS_DEV_RESOURCE (or=0A=
BLK_STS_ZONE_RESOURCE) ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
