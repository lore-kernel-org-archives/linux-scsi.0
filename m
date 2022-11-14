Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC21EC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 10:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiKNK6y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 05:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiKNK6x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 05:58:53 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DB5F59B
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 02:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668423532; x=1699959532;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kuRaM2rjQq3DOddK4SVWu1hrcei4jF1BaTgBQMcVRKk=;
  b=IvWDZjPF2X6s7z7yJfWQ72+Lm20JaomXvUXX6+2yOAju6ys5qSgMdhL9
   6RN9ox5OHv1aBAcchQ55QEqtgn+K93/dJWi2lC3KBA4XR3iQe1/SJ6386
   8sjbS6KQn5dEyhlQn2hHd/90IxL4gyKQtqNcdmBu+00/AOl34JtIG9lg7
   eqfFVwb1K4T1ftOIQTyrhCcholTdvxVxDPByMAivmMM353Oufx7nXX07e
   Y0VNPaxWsAnbxAqyro34kodPFEd+Ngn3fuF6T836dmwInMBJP3YioaVow
   zc98aPxc4nERd4wxZF7hgaYRF+qVTQo1VvQ2cOJk0lIS+uQys3iUOjfW9
   g==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="214483128"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 18:58:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klLFFFYPgyBjMCrwK39x6k0v+Q/gjNt4qJlNabGk+CbLcI/GB5+5ybpv4ATsIK5OubCxX0V6JHN1Mfe3cV3iY/zcB1c49a/ljMn5lhudQO8BjErYX3Nf72UwivHc/Wo848sUm144OEwqzbSeyyoKcCgMFAn9su6zbRsT90jiOwFhTtK5ibsBb1wagvI7po7VVhs2C3sX88APaZC2fJWbFwmmbcyqTiUs/3TKg2H/H0BWN3e2CfHA5cC4wKVdnDExIIBLqo1LKeY9JMwOtdft6GmoDr0mWAs/KC2j0nsRZakgp+YxQbiWh8Jkl9f72jB6bhskN/SUze/z8BT81l+XZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCF9yU2XqS4gVul2OGFsmSKg7KEMAkSOg4O4tchRry8=;
 b=OY/vATj4w2ZgzWZUA2OBhcSUBax6SHr3gC/PENMx484rF52Ap82w85lxJ6a6ucXdqq78ulNUProvW+h+sH+4aB5sBWNez7oL4DAPTi9fhD8Hd++wXd1ULDlGMR8DAB33y9sSjAqS+DK7x5V2UO+xhnytj8jdqh6J2Xbpd0UkDTYcFokp9vjEi8ZsTGLWAbZ+BxRogLPskS5MnynfB8W72oahh/vwcq+h6k8x0d/KTSrQ7hrfij6xfxm7rXz7R8+ctO1Q6kselp5no4B76fdJO80Lc9d9MRdybrQv3ssNlp6pi0kBYs4FubcZlXYiAywefy4vFcFllUOiJs72r6shjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCF9yU2XqS4gVul2OGFsmSKg7KEMAkSOg4O4tchRry8=;
 b=WGDn7ROj4PxGItayhIV/zH5n8giF+/Lgml5w1DNDM7w23juLxkwWDoo4602y+Kxts5It18x3SPbfNvFjudvn+ZISzuvFiOPbq0IVtwilokiBVtRO3zLRsSJxN7tJ3uZ5nXBWJnPbAJIJWeRBmVTDxGU1E9eO8EiYpTTnXbWyhvA=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH0PR04MB7969.namprd04.prod.outlook.com (2603:10b6:610:ea::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Mon, 14 Nov 2022 10:58:50 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%6]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 10:58:49 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 0/2] scsi: sd: use READ/WRITE/SYNC (16) commands per ZBC
Thread-Topic: [PATCH 0/2] scsi: sd: use READ/WRITE/SYNC (16) commands per ZBC
Thread-Index: AQHY8+dTcwmfg7ex7ESXffXNxEBulq42iAgAgADmEoCAAGRTAIAAA0wAgAZynQA=
Date:   Mon, 14 Nov 2022 10:58:49 +0000
Message-ID: <20221114105848.ygpd6q5n3jt56ygj@shindev>
References: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
 <Y2ue2rZzf74/1V+U@infradead.org> <20221110022009.xdfmlpdpw2kyu32x@shindev>
 <Y2y0AhBCm+O4HoRg@infradead.org>
 <797133cf-ed12-233e-8148-a08bf1261a35@opensource.wdc.com>
In-Reply-To: <797133cf-ed12-233e-8148-a08bf1261a35@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH0PR04MB7969:EE_
x-ms-office365-filtering-correlation-id: d8283dc7-355d-413b-8d69-08dac62f3615
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NMCuyDa08mqRIymAPMUEJCKqdM4dQZZdd88ssPffL7h2+iqpjmnFM9urbT/Sw6z1JenU2Z4xzkK0hsiD5FraHty/9g5cXVAjxfpx4u6Wom4UzKFyrCjv5jb6UOjJux3JLevouFKOSZFG3NpRClAlxVsG+Zjkon0Cag4jb8SkmiEVm+RlaNGTHhrdgDSEcpzUhQXTD5mZ+jsSq5a/wuuVL7vNBSpAQybWpXQPSiXjMgFqHLkLa0dp9U1Y67UdscuIn+2bpT3jCvfocYYrF2p5MRWWr2Q9nqaCLWvaSm2y5kyMvGPcNlmyiXxxCEXIbDS273BxkQSJMcpsnRafDXEE6TJxYPMkChcQRxdSRBQ9wKZIl9iwWjPVTWr/STucN5MkWTJlmjIaYDF2NGatMHOlYR65B0bYMQdlnClk3Ej01w0Hf6pT5oMeAXr2GSpZRY36Vi0uTgFqHR+/eBzOVPjay1wXKVPLAQWzAho9Me3mL9jR5s3GJ/iyBand4oEc/4edo0iJNUSW/mooJZGcfglmGSw8b5Kw6V/TloKs+QxrfllOZcgL8Sj+paMylCVsgoDORWvdrF14kI4Rsk+sLzNuqObXK7ECf3N/AKDA7uaCMIZ4bN5YI4NYHZxwQEBecnXSybgnxeAl2PibLmGJNTNKnbU5MBngbB3H2Q9oAngmIvTx719YQVcbgJI3DBSSdAJ01E3ylouBP6ZtFIy3rX6r8TE56ZGN7EsZRbeijUiqK8Qed5VHO5B6FFYecepY1M1P0KJh5413mGuQgM6vH5HS2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199015)(64756008)(4326008)(66446008)(76116006)(66556008)(66476007)(91956017)(8676002)(44832011)(9686003)(6512007)(66946007)(6862004)(8936002)(26005)(1076003)(5660300002)(186003)(41300700001)(316002)(122000001)(53546011)(38100700002)(82960400001)(86362001)(2906002)(33716001)(6486002)(71200400001)(38070700005)(6506007)(478600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GAgjwCq+1AZ7jOY+s/N0VW4OxDxY/io7NjueDAB82VXf4E6QbUuFHwjZTVoZ?=
 =?us-ascii?Q?L/OHPnwrcZmRo2KF5mGY4b2bbp7iXN3zo4jX1dwTm0Z1vPFK3us3XlCsZm8i?=
 =?us-ascii?Q?c0o9J1Qk/GzoPQaKfhoftTHnAmlh4yDGQujV4Q9O3m4Vwg9/JJOQ7CDk6vlJ?=
 =?us-ascii?Q?Jpo3n+pC7MPnSqwrWYwlvV+HzNnym1e+ejKt3HU/kb7oAAOkjhzDuReF7CHo?=
 =?us-ascii?Q?BiY3mtzJXmBTXEe9VMwhCNNKYiuH0HKydO+FXFtVjKdyiWLfzmNssC9G3Ade?=
 =?us-ascii?Q?RsAO2U3xBtlZ2sngmB3chF+IBdHsSxOaxrezy762ZP7Non9EEqoVH47uPTV8?=
 =?us-ascii?Q?QLGY3L/Ub2G1qu04JKKJvrdZOK7eigISUOdXS9ojKPiFU/Eo6l8ZOBe7heBK?=
 =?us-ascii?Q?6HRUbNz6GjqEUo6L3VWrsXOkS7K/fVHAI6Y131NigVFEUZi0VWNC31R4HXgY?=
 =?us-ascii?Q?w3VHXzyaNSbuYWUsnxV4MlZj96myMaRzGvh5K4q/G+G317hIexBEYGQzxUeq?=
 =?us-ascii?Q?qiY++g7Bym4DGvk+2r7DUfLyFGIyLiGN6xjbKJFRk4uzd38i6uzC5tZu0prI?=
 =?us-ascii?Q?fpwjsm2MeDTJbb50IOeETI6p7jjbIbSr3NvnWxUAlKts+drk5jNRHyb7DtFP?=
 =?us-ascii?Q?om2d/uOaZIK784YoC3ngiUWoUddAdw0oD1b/e4LuS8tAyZ8kqe3P7BPaIQVU?=
 =?us-ascii?Q?5umP+CdKHNjJWD0zffWQhHVFv+QUP3xziUpEp343uf8gv/T8OM0n30PxTJu9?=
 =?us-ascii?Q?y2FXcaiMb1x1Sbcn35DLVpBpHNRHNcTQw7PcBsR9DkBY+IQZYVMpj2ewi9zL?=
 =?us-ascii?Q?vOW/U+fH++IiCVM1oX0JpjhX5UcPnvbsAv0o2E1ZlwY3k11XikJ77JtDdgO5?=
 =?us-ascii?Q?lL/VLKpOdRCAGJq9oP+RXZzzEUQF8ygLz+58QnKQoG4nREwjq9QwH3Bd5MCY?=
 =?us-ascii?Q?YlXQeetm36TC8MmwwC6oKWVETpfBbrg+wrKCvr8EETCXrs8Sv20WrTupR18I?=
 =?us-ascii?Q?LY/raOwahPKa8ceU46BhqwbuV/ceU5RuLtNC4TR5p4h93yi6xjoWkLBZDpbe?=
 =?us-ascii?Q?rcqz37EsEdhJSOt1SN7niQ9OC4V8Gcf4KQsNnpLQUm4iijEpG/eqCYnIQ0S4?=
 =?us-ascii?Q?tt1Tcr8rKczeSDotqEDSrV5dY2ufSw2zwNS5iScQzLfq+wCgyz5ZZmfXEsZY?=
 =?us-ascii?Q?CYjsc0EeqebArtTCtckYrCfY4QgN4sT8gr2b/Rxngu3HNgSxrlpYp5DSaYG6?=
 =?us-ascii?Q?8hymAefrmKsEy05v3AUlyGMKaCzi5tM+NkW5gmVd21JYni0HwCIC3c1hRr0Z?=
 =?us-ascii?Q?B7MgZYSYUD1tu/I2ciV/pRsLhduVeNHlehtKbymeZTr9KsmKIzbPkk13uEyc?=
 =?us-ascii?Q?deTKcUjZCRZkUq1V27EO8QMF6DDW0+EFgw7MytHrhbKHEh6lusAHZYJqDfHa?=
 =?us-ascii?Q?/1doWaxmhVXsecTXAomWHUSxjPyqFj2V8ulMmgqcvXp4NPWiIgGZ5JKfMUi7?=
 =?us-ascii?Q?kStAnqBMOq/LCKIioSTbQ+RF1Upz3kNK8hkY60WTEmBa4acbqXrrp1UdjnLS?=
 =?us-ascii?Q?F0ir+HWFS3jHnVYDb439fQc6TfSkrbVK0z5cXtJXRnNRgJyC37HkA931A9W0?=
 =?us-ascii?Q?xs6LvmDHkH3fqkDsTuIOdxc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A5EAC6493791D4293C64F6C390E8763@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Jp0zZajEY0J0oWTUFoVQKQr4ENb1Q4aE/cGbdMuoavLy8RjL5OgS+zYztWQnKOlfsvTHX+S680DO/4ZUsamipKJa5bAiGQu9C0w9dTsuqiNguGAIysN90xqktd+Mq703pjvU0wFkATpflmgn4JmcPtvn6Tt9Kf5ZsGAZjmXmuw2/q0WdYI+EiYSZQl0liDcT4aVAZ9aHUxTnVje0vl/H2GQTKIwdhe9pdU3bSXH+oYkS99MdsFYWMra1FVmSKejm7+eEQnMsPvhDmnhyY2N5OLVOlwdVqJx1QobRmD9uucnl5BTYRiwH32ZoSAvq6JGP3BXHqb8OzeeJk7Ydd8uWFMoWbw3DVLZM1ObL0UzNBA4SgnCQGZw+1Rfuf+LAY1liy7Ggd2yjyDStlWj2964nBUa3TFt7Ahe+2r5+JP8NrOySxpVO9cFmqL3yeK1IatI9fS2od7RLPD3kXkjMoAj3mO5ETqlh9KBnr8XUG/uiJgn/rFbuIin89Zgf3Y+b42QCm9Ebl1a9vQZHC2x66kzlBDpsv8iMgmo2lhJPR+wQiYYRSsO3rPA7CSoIVX+VspDXYr0UWB/UezbFXI+w72v/IUvoyDfVX+zND5eGKuMlAkFa1Aw/exO++PVyctRLzl1CuDPSOR/ttrJGHZ0YPK050fngJ4FRp+TWrjUXCy4FRIzLNhN4/Z/Y2C4LVtTZ9zL4Zw9CfE5IPLsgDLKicW6O/Z6nuaniwwo7JPW7ZMlAuvuWqd6k04P9KXGr+oMP4/1UrpQ0Y5IHd/uLCffaujk/QbVp5NZYecs5P+7tAoRNNFbkh0654IU5drUexbQf7kfpo2jFMXPZkYx+zqYJm8n60aAkFdifpaPW60tj/NHXROo=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8283dc7-355d-413b-8d69-08dac62f3615
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 10:58:49.9010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uoshLMp3MqNIB9gwOyIwcGe2iS52bnnfaSJsifiAkjGYiK9CSj+Rft10SfWgf6ZXv/VpPMuccuKib0+LhYs4uUNF1CHa+ChZjeIlafOXvP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB7969
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Nov 10, 2022 / 17:31, Damien Le Moal wrote:
> On 11/10/22 17:19, hch@infradead.org wrote:
> > On Thu, Nov 10, 2022 at 02:20:09AM +0000, Shinichiro Kawasaki wrote:
> >> My point was to make the check strictly follow the ZBC spec. But now I=
 see that
> >> it's the better to keep enforcing 16 byte commands to host-aware devic=
es. I will
> >> drop the first patch and revise the second patch to enforce SYNC 16 on=
 both
> >> host-aware and host-managed devices.
> >=20
> > We don't "enforce" anything.  We just don't send the legacy commands fo=
r
> > devices that are guaranteed to be modern.

I see, the word "enforce" was not a good choice. Will rephrase it in v3.

> > What is the advantage of
> > ever sending 10 bytes commands (inluding SYNCHRONIZE CACHE) to a modern
> > device?
>=20
> The ZBC specs define SYNC 16 as optional while SYNC 10 is mandatory. So
> the device may not support SYNC 16 and we would get an invalid opcode
> error. For SYNC, no advantages between SYNC 10 and SYNC 16. Not even
> sure why they both exist. The point here is making sure we use the one
> that the drive MUST support. That is, SYNC 16 for host managed and SYNC
> 10 for host aware (but these likely all also support SYNC 16, but we
> cannot be sure of it).

Damien, thanks for the explanation. I think Christoph, Damien and I are on =
the
same page: we should call 16 byte WRITE/READ/SYNC commands to modern device=
s.
And both host-managed and host-aware ZBC devices are the modern devices.

Will prepare v3 based on this understanding.

--=20
Shin'ichiro Kawasaki=
