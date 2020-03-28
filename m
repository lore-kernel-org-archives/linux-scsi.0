Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49765C2D0EC
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 08:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EE0E2072F
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 08:38:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JR6alGKr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="R4EunRQM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgC1IiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 04:38:06 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:50261 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgC1IiG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Mar 2020 04:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585384686; x=1616920686;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=eHv902DcUdrf2i5ey7zPxOAzVVdFRv4RdEa86t7awJ0=;
  b=JR6alGKrRS5CiCWBREFlwYYiLVEVewdFX3mG28JcPoXv2P/A7ttUlkHA
   vHvUQ8MY/ZbkwG1zd2vCdr1XY81bzKYkNCMjYeRJx7JDV2hQk0yAfMEpe
   MPEludQlHYoDA0ZBKaw/+mt3dXPo+pUVVRTU46bU1Ru8OBQZaJd0LQFlz
   rAn7wG6KLvxrAtELIDv0B404lSfTqvq1LPVXZs3FQjfGyoAxMA6WMdreI
   7n5MQyN+vDzRFkaOOZDYnYmDQPi/hWlaqRSyNxY8wmwQB6Hx+rlvQSaVs
   aQ/cGFRdInyH3ndv8UpaqpgDZbnd3ZNYGzb4Gv8CfFR9XnZMKs9fz38Gy
   Q==;
IronPort-SDR: Z/U1x2nzYckfj32RpssTyhDo8F5GWIh1kUqyT3PMtq+KwO0nR2mJBsfYdGkVAigpo1P9S2B/p4
 wKe4mPgS7Zr/YhAa9PvQxLVOTnLe26CTCsGwH4fW1EhqU647X2bBXZmu0oXYnQtDh0cyXbtvj4
 kV2x3SlZRzuXjn+47bIkLkhrSNYGZbOXeuo0LVRoRJCMKRojzEAROQCe6xrgvQyPflZLX68g5m
 rkygi9AIy8N9FJSM8xEqGRphyD62hwSsy62oTPi6O9FDz0dCbsoeJO9l01x0IFeU/8bU71i1vS
 08o=
X-IronPort-AV: E=Sophos;i="5.72,315,1580745600"; 
   d="scan'208";a="135187490"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2020 16:37:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PM3KvR2nx79zi3MjYHmwS9BXR6ZUS0u75/7P1A++4yrM9VujPTourH6u+ihG/6/TrQUsA7bT9dvPXBS/gg5Dq+JfU0NKiE9eWJexxId8SZwB0gZjlIyfSUmU5IIWqTJ6h4Ee1MNP/IWPFURGmjUSpfKGvewesQwvBHKi6Y191I4dEmZSUK7GCC+NybCOIj9HLyaOHWASjg7gVhe8FuIfgYwBQkipXlNLqkFxRyLVNfGfpYGC04YTl9nGlNewA74wdrxYjcDV1kpwo3GBnSuGEiDfwdktOhw874is68lT4LLr8b4vqXzOpEL0t1By6hBt4wu/v8rQKaztO4jpjSTVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kViwJKpE9YYPFiH/2ar+zC1kzSlbQ+i7gb2flIt1Dw=;
 b=dhOSgfjUWkzlsZw5z5BtyQ4vMjbmLW7o0eQjVdOM1AIEnDfUaCu2qOC/YJ+1zT3W99fSqkMizQDC6Qqj+uRRglXOLm+eWe+fZrZ4fW1kVsje/BDTuzEIv68chyewCDTqFSVi+zeQTeY2TnU+ISjpV9mw5nMfW4g151j8U9HUq2o6/U6+NwcaC9Mq7EZA6QLTimPtbFClfpjMDtsW7JIt7DA78olUmlo11LVxBFREdkTTexyMBfsuD2mAL9g/HoDWs/DQ/aad8+jBFkPndJ+jfVix6T7A77hMnXPqtSqF/o4j5tCiIrTpw4ddj+KpTFD/p2Gn5O64Ra2uLVlCaTaXSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kViwJKpE9YYPFiH/2ar+zC1kzSlbQ+i7gb2flIt1Dw=;
 b=R4EunRQM5mxzPsnWylJIB0ZheY3VNnSuhGDsBzDMWCfiZPocbA8rEYJzIYfLfqL2wnFTSPtQCvekjhipRhOt1jg7XPmFki/MtLw2f+vy2Bp5vm7aHzqipdt+QUUPIo+izDV27R1hs+PVtod0ODbxck/6p21kxOepRWQNil5xdFE=
Received: from CO2PR04MB2343.namprd04.prod.outlook.com (2603:10b6:102:12::9)
 by CO2PR04MB2373.namprd04.prod.outlook.com (2603:10b6:102:e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Sat, 28 Mar
 2020 08:37:49 +0000
Received: from CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b]) by CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b%7]) with mapi id 15.20.2835.023; Sat, 28 Mar 2020
 08:37:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: all zones zone management operations
Thread-Topic: [PATCH] block: all zones zone management operations
Thread-Index: AQHWAydCbik6RfBk9kK4q1a4/Owqqw==
Date:   Sat, 28 Mar 2020 08:37:48 +0000
Message-ID: <CO2PR04MB23438CDC841857B211FF7866E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200326043012.600187-1-damien.lemoal@wdc.com>
 <20200326072800.GA21082@infradead.org>
 <CO2PR04MB23433C37660B9A8B53D95790E7CF0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200326093049.GB6478@infradead.org>
 <CO2PR04MB234368B6701C041B292DC872E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200328082211.GA32518@infradead.org>
 <CO2PR04MB234357A7ED343AD22375CD00E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200328083101.GA17417@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d371ea81-d58b-4b27-695d-08d7d2f34c00
x-ms-traffictypediagnostic: CO2PR04MB2373:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CO2PR04MB237353EEBE6E87799F82AA91E7CD0@CO2PR04MB2373.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03569407CC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO2PR04MB2343.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(9686003)(4326008)(53546011)(81166006)(6916009)(316002)(8676002)(186003)(81156014)(7696005)(55016002)(6506007)(54906003)(8936002)(26005)(2906002)(91956017)(5660300002)(71200400001)(33656002)(66946007)(66446008)(86362001)(66556008)(478600001)(52536014)(66476007)(64756008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T6E66yYR+AYyS2EZzD/Aey0Gy8M9+8BhpRCkp3qIDnV72UbWmJ8A84t07FrKTBNlHQVPEGymMP1mKVtrESXq5EJJ8NBY+32UQVyrf3IctUrDgQWP6Rumoi8/8boF6FHXpTRgFEocRBqr3glj/aNNHnw2zCEyGyPi3ZLcgZ4vjK19S+f4fG299WCcOXQktZ7CclBRP63W8kkDvvlLsUJseSMoIbUHhjCzYGn891O25Sx1C1FUdP6pqSfe/egqeeT44rNBzekPQpBNzOEa8k3yae7p3q0Rkq5NZkYknIwweFN4TsX3yoOm7HUrKNgr24R50mkkgwikPF069ffqDCf/QDK77FdpYohQCXmD77jGmjsBdeZAdoMifPVSHMR039ZH+EXGXq5EfHYdoLqQw13aUL11bPTwSLgadAI7lK7BU5iVg7HB+iVD3jC08T4xdnqN
x-ms-exchange-antispam-messagedata: aVBRF5oiawWtfMILPBhx1UIUNk2g6bXkj5tgbwW00eMTMY3vkH1Gwd+8FBqYP8a6XK14dJFORxL5lzCcujDROtHsPInhffu74UwAMDetJpXC+St3RZPbvDjTj/fNg2daQGBrb+jQvc7/xPK4z6Zjgg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d371ea81-d58b-4b27-695d-08d7d2f34c00
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2020 08:37:48.9186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h24eoqkxBuixt3dnniQXlJteD9IgqJ6IBssGIOX4GdEbadqPfb3K4cs35c0FNRnIOXRr0nMhdKwsFswggBBC3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2373
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/28 17:31, hch@infradead.org wrote:=0A=
> On Sat, Mar 28, 2020 at 08:27:09AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/03/28 17:22, hch@infradead.org wrote:=0A=
>>> On Sat, Mar 28, 2020 at 08:13:26AM +0000, Damien Le Moal wrote:=0A=
>>>> In any case, I think that the patch has value as a nice cleanup of the=
 reset vs=0A=
>>>> reset all request operations (the latter going away). The side effect =
of it=0A=
>>>> being that open/close/finish all come for free with it. I would like t=
o get it=0A=
>>>> in just for this nice cleanup.=0A=
>>>=0A=
>>> Well, this keeps about the same amount of core code (and I'm not sure=
=0A=
>>> it really is cleaner) while adding significantly more code in sd and=0A=
>>> null_blk.  Not my classic definition of a cleanup.=0A=
>>=0A=
>> sd is simplified (one less argument for setup of zone mgmt commands). Bu=
t yes,=0A=
>> agreed that null_blk does need more code.=0A=
>>=0A=
>> OK. Let's drop this for now then.=0A=
> =0A=
> FYI, if you think the flag is cleaner than a new op you could resubmit=0A=
> this but keep the flag reset specific for now.  That won't require new=0A=
> code in null_blk for a use cases no callers uses anyway.=0A=
=0A=
OK. I can do that.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
