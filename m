Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A61DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21BB611C7
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhIJQde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:33:34 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:16506 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhIJQdd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 12:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631291541; x=1662827541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W2Rj1x+VKrVOVgNZAWwOfBJpsAen/Guv5+obSdu5vo4=;
  b=nplCUoCKcWI1w+0swdZsroYn8zU/tKFhmpGlzIeg+Um82TCk5wluJA7f
   UaYbonBgPc27id+QrzbpfomCuUWsu9LwCQqKCcgQnZKJD7Nzrc9fUOUne
   P9yXkQlUDPdlKRSUNvs+zuIlz+T+BlOsaLtfFam2wBEN7UFbSrxOqy3E+
   Ldo/06qB3CD58dOUdrAmeCwAluzYGnc3fd2zPJ8hOZf24/s0rvPFl9SYB
   Vm3bVn74s1uzY1TgXonXXrPuw1YzKa78DYaTcbVUQv4kNUCO1KYTCIgYO
   P1MExewHCBJNmvxusU0NeEi0agaj9U5TIEmrR5s5N5gYxABj8TrUgU0W7
   g==;
X-IronPort-AV: E=Sophos;i="5.85,283,1624291200"; 
   d="scan'208";a="179692914"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 11 Sep 2021 00:32:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwNylAq/+MwpxHJaFLl0uGmck8UkwX2N8Bml9y1YtNnDo+twe3fnaG8k6IkGW9Ongst4nnpE9FIAyl1ySQC4UPbkC8rw9CRlZyWGcfNPhZvY7G4Gk4y9c9hOPjWHgksJLBO9tBjvDaNwAOTBB3DPiX+2FzsBXdzxJe3OOzyuoLhNzrHFUPldGSERChDPtyj8VPahXlTWzJ2FGBLEwLPoTauqYRU+snaqHbMH/o7c3ig0VmInz4cEc1chL30xz3OMVqdsInJcDUouWoLdcx1rhQFRGd6rH3n0b5QxyqwJYvwsfu25bNwkrnrW6badOAQVaseCn5vxsaSkT+MTJndzEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=W2Rj1x+VKrVOVgNZAWwOfBJpsAen/Guv5+obSdu5vo4=;
 b=dR7qaOBtTMJrzTXMNT5Z2SdA1cq1wucOGfwTTMmfBvwYNIKn/YSA8+nWPF0A/2GDE5GGnk0j6cQNin0CKs7vnUw6OSUTw9SrY4sovZe9AXquhTznWlm+NCSCV7oxrTce+yPdJRCIPsHCBr+HGJp2apBmMDtMlV0yzLQdTRbMukWXr7MBZs9UH2PjbF8ZWL7Sp5T1E8aVrgElA000cN2LfpMJbXC8U+C8HZOowf3tt4xBHlJQny258Mn9AwMbEuUiDmj2TibGdvZvruV2dM6Cv/gJn0mCuTSENM62jUUqvLofm5FnADNrBPTFlN4PGc2Gjyoqaj7JOy3MnpRoNdc17w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2Rj1x+VKrVOVgNZAWwOfBJpsAen/Guv5+obSdu5vo4=;
 b=opmgMt0N/x5DMANzGlnFZmszoTegxugb1k2WW0Buq8cnkJodcKQsp9HPoP3Jzxy+akVjx037+qjT6oqbhwo8lNEL0Qc+SfWy3gTvb4U+a1IcBm1b2aTJD1/IUMp0dEeyyKDI/N3yVKcg4ey46c4RBQTlPmqLn1n9pphldshBNa0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0268.namprd04.prod.outlook.com (2603:10b6:3:6d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Fri, 10 Sep 2021 16:32:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86%7]) with mapi id 15.20.4457.024; Fri, 10 Sep 2021
 16:32:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2 2/2] scsi: ufs: Add temperature notification exception
 handling
Thread-Topic: [PATCH v2 2/2] scsi: ufs: Add temperature notification exception
 handling
Thread-Index: AQHXpUTrgMJYFhcl1Uyw+SiYRgJphaub7C2AgAGL2VA=
Date:   Fri, 10 Sep 2021 16:32:20 +0000
Message-ID: <DM6PR04MB657584129D49F3C90CA0C462FCD69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210909063444.22407-1-avri.altman@wdc.com>
 <20210909063444.22407-3-avri.altman@wdc.com>
 <20210909165431.GB3973437@roeck-us.net>
In-Reply-To: <20210909165431.GB3973437@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84731aad-d173-40a4-96ce-08d974788fbe
x-ms-traffictypediagnostic: DM5PR04MB0268:
x-microsoft-antispam-prvs: <DM5PR04MB026878FD0ACA3085B73A01DEFCD69@DM5PR04MB0268.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +8apCUOv5UVl+UMg3+8Qv4U14/uWVWSEo+L2xo9SvpFnf2oYD0lMq6kEbWBqiWcwxfl1YmeOi2CK3NRqBvM4Vqx0fH29gcXiZei4Aca4z7k7hip9yRk8Gq5bmHmETKe2S4RMNdnGxkXM+lyocqh9lpNnmCsZD0gqEI/JUZ4XkR31a5aVSSjm+2TRllFzrytrAwe5HkNEidRTF8A4+j3WUkNkI9jp4u+dvF8Xprlimd5j2pURuZRkLJh9PzIH94h1x180c5knpNHR3YAEZ/ahowPHxEEZ+ZtA7uRPEVwgrxbhwoFkkRjNCeoUXIXxiCawJGLFFT1AVMrPnMGW4Z6/UmGvX/1tVCmYJqUFN7r0D3OR3Ok4T3NRCTZQQ4gwVB4afX/qUvgzgSHcqmVWirbdE2pFD+lLceXxWkzzHX0Y40UblLojga62hjrPxKdaNTubhBmS/tCi9y1t/mKGuNVe8y0rWGRtaKRYlBk3Po7WuTm3hsbMkcQhGmaKXit+AUdWV1Yqu/iIU8SXihDmTMN831Kb5cOkAfRCYl3klNfCuBFHXLOAoQPk5ADiXPhB/Ntzy6xcESFAUhLU/qTxRnY761MTt2vzp6VqoI/1E5NKWq57gJ13sN8mP6ZSUnx+ivYr2RplBY7LkZgwAijEPJrnE7k0ocVAwR62NubZ9GvVCo4+7z4JSRFMHxSW2Ws7qssHBzml6TW4IOlAsUmBM1JVnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(66556008)(122000001)(8936002)(76116006)(38100700002)(4326008)(66446008)(86362001)(64756008)(5660300002)(54906003)(2906002)(316002)(71200400001)(66946007)(8676002)(33656002)(26005)(9686003)(55016002)(6916009)(38070700005)(66476007)(7696005)(52536014)(83380400001)(6506007)(478600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHZVWStVU3ZDR1crL1dTSEpZMkQyL0tMMlVQaVVVQWZZbmFrdFFCSExnNWNo?=
 =?utf-8?B?aVZyQzlLaVZmdzl1eUtKalEzVDdpTkZLT2tSM3ljaFh5aW5CUkFES2M5bzIz?=
 =?utf-8?B?SFRwQXBCYWVvNHYrVE8rWVlTWFoxVEh6RFRQWjFhbUJnZFErZ3ByTkphV0Fv?=
 =?utf-8?B?YmY5TnJFRDh4WEJXQ3J5eVgxVGVLekVLRmZXN053OWt5WU83TnJtaEVXQVVv?=
 =?utf-8?B?VDBsTWFBaTBES2VITHhBS0Z2OUlSWFZhdUQ0UzVXR0pES1Y0WkUybkp3QW5n?=
 =?utf-8?B?VWkwOEhPQ1AzM1hkRGhoNjZ6RVExVzFJeTZ1QUdQcmg1WTlsaWlxaEpYYnlE?=
 =?utf-8?B?TVNpS1RXeWJxUnQ3ejNidVhRbU5WQ1hFM2wyVWhkd2hHN2tabXNjUVVUbHI1?=
 =?utf-8?B?THNkUFFqRGJOL2lrNzA0NWRZVW52WER0Qk82aGc2bjU3Q0FIWkhaKzZPSzZG?=
 =?utf-8?B?QkdjTWxYSm1seDFFbTY5S3ZaUjYyYm5uT1huZ1pYQWhuSDJ5QmRyUldOY0xI?=
 =?utf-8?B?NTRmQ21xVkkyejY5dlAycCs5VU5RV29KSEtYajhiSFhqdWhEbUNUYVVWVzNa?=
 =?utf-8?B?N1BOSWYvWURRa2dtblk2Y0pFeWtFTEZvbjdwTUlCZU4yc24vZUUvM2g4YVdi?=
 =?utf-8?B?OS9JWVM2MnpySFRaUnlDVGVRYmZqNE5zTGEwWWplVlFUNFpDaW13WGprcVlL?=
 =?utf-8?B?c1pwVlJycysxVnk1MnZvNnNnSU5QMGtNNmd1bmRYbkVBaVJPTE4wanJWL3Jx?=
 =?utf-8?B?R2NFeWJ1RURyWTBPL1YzcFBvWG5OVHJETE5yZFoyRVZ4TTNWQjIyYUFkL1lr?=
 =?utf-8?B?cEZVMnFiZ2NOcWptTzBMcHJHYjZxbmhyTmlkeW42T3pYVVJvUVRqeElJM29t?=
 =?utf-8?B?SFdmVjZtN2ZDRjJ1Z0ZTUTNVbEM2MTVNUXRkU1U1WEVkSFZQcHkycHVDWFFp?=
 =?utf-8?B?bCtzdlk5bFB6UjV1M1hzOWRlYjZxejEyVVR2ZFUyRFRQekR3S1ovbEovdWl2?=
 =?utf-8?B?d2FjOE5vMlBYcjJrUmFYQ0FsQ2tDVzJueEN0SjhSbGxmZWRzcE9WeDRYbFZR?=
 =?utf-8?B?Wkkwc2c1eHQrcDJQaVJtdDl1NFVmWCtqb3VPY25sVnZacUNjR1oxbU9RR2Vj?=
 =?utf-8?B?YWh0cG5yemp4V3hyUkU4Z2s4cy8rY2UrRmc0Q25STHl4enlOWm9Zems4QWdP?=
 =?utf-8?B?bEtXV2I4ZEthVnNFY2FaUTU2TktMU2VhS1BMdzNXcnBlRXRSM2VrM1Yydjk4?=
 =?utf-8?B?RnAxSDZWN2F5SmRGVGYzT0pGbVJoU2VDbjM2Kzg1MTFCaG51ZE9xT0lHWm5z?=
 =?utf-8?B?YjlseGxibUZvQzJiVEdodE1uOVZyTXQ2Mit2azNpT1YzakFTd0pVWmlIbXo1?=
 =?utf-8?B?dFFqbCtiS3BHcDdDZGhxTzF3RnltSXVLaWJadUJVUk1DTEhNTUNIUXlDVUF2?=
 =?utf-8?B?aHNoWU5yUitDbUpCWEVCa29NYmFtTjlDSEh1aGxjdit2K3o3Tm5rZFlhQlV1?=
 =?utf-8?B?Qk1IRGRRUlNWZDN4c3lOcUVYNG9WTDYyTnFnbDYzdDcwTk1DdWdOTW0zc05Z?=
 =?utf-8?B?Mk5jc09yd2YyWnlWQ3FENEc5K1dnbVo0RCthb1gvNFZvUExRckszUkpDeERB?=
 =?utf-8?B?WVhiQmJtWkZNSXZHNFhnNndjUkx4QW9iTnowWmFxaU5qZGF3bzhJcG5CTUlC?=
 =?utf-8?B?NXdDblprWklqM01vams5MVFwc0pEb3JsdWRUWlRCR2ZHM0JkRndmdmx2bUZY?=
 =?utf-8?Q?+cQUv3/8CBipTF/CFDeLi4WhRo++N/V+JDeeuiZ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84731aad-d173-40a4-96ce-08d974788fbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 16:32:20.5140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQZQDWffLj7eQolIPknxna99eGOGz8Fn47BESvZXqucWEw+N6nZy+jtLRF5bad4uD3PrNysUJ22oE6jx4AVDmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0268
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICtzdGF0aWMgdm9pZCB1ZnNoY2RfdGVtcF9leGNlcHRpb25fZXZlbnRfaGFuZGxlcihzdHJ1
Y3QgdWZzX2hiYSAqaGJhLA0KPiA+ICt1MTYgc3RhdHVzKSB7DQo+ID4gKyAgICAgdTMyIHZhbHVl
Ow0KPiA+ICsNCj4gPiArICAgICBpZiAodWZzaGNkX3F1ZXJ5X2F0dHIoaGJhLCBVUElVX1FVRVJZ
X09QQ09ERV9SRUFEX0FUVFIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIFFVRVJZ
X0FUVFJfSUROX0NBU0VfUk9VR0hfVEVNUCwgMCwgMCwgJnZhbHVlKSkNCj4gPiArICAgICAgICAg
ICAgIHJldHVybjsNCj4gPiArDQo+ID4gKyAgICAgZGV2X2luZm8oaGJhLT5kZXYsICJleGNlcHRp
b24gVGNhc2UgJWRcbiIsIHZhbHVlIC0gODApOw0KPiA+ICsNCj4gDQo+IEl0IHdvdWxkIHByb2Jh
Ymx5IG1ha2Ugc2Vuc2UgdG8gY2FsbCBod21vbl9ub3RpZnlfZXZlbnQoKSBoZXJlLg0KWWVzLiAg
VGhhbmsgeW91Lg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IEd1ZW50ZXINCj4gDQo+ID4gKyAg
ICAgLyoNCj4gPiArICAgICAgKiBBIHBsYWNlaG9sZGVyIGZvciB0aGUgcGxhdGZvcm0gdmVuZG9y
cyB0byBhZGQgd2hhdGV2ZXIgYWRkaXRpb25hbA0KPiA+ICsgICAgICAqIHN0ZXBzIHJlcXVpcmVk
DQo+ID4gKyAgICAgICovDQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyBpbnQgX191ZnNoY2Rf
d2JfdG9nZ2xlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgc2V0LCBlbnVtDQo+ID4gZmxhZ19p
ZG4gaWRuKSAgew0KPiA+ICAgICAgIHU4IGluZGV4Ow0KPiA+IEBAIC01ODIxLDYgKzU4MzcsOSBA
QCBzdGF0aWMgdm9pZA0KPiB1ZnNoY2RfZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIoc3RydWN0IHdv
cmtfc3RydWN0ICp3b3JrKQ0KPiA+ICAgICAgIGlmIChzdGF0dXMgJiBoYmEtPmVlX2Rydl9tYXNr
ICYgTUFTS19FRV9VUkdFTlRfQktPUFMpDQo+ID4gICAgICAgICAgICAgICB1ZnNoY2RfYmtvcHNf
ZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIoaGJhKTsNCj4gPg0KPiA+ICsgICAgIGlmIChzdGF0dXMg
JiBoYmEtPmVlX2Rydl9tYXNrICYgTUFTS19FRV9VUkdFTlRfVEVNUCkNCj4gPiArICAgICAgICAg
ICAgIHVmc2hjZF90ZW1wX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKGhiYSwgc3RhdHVzKTsNCj4g
PiArDQo+ID4gICAgICAgdWZzX2RlYnVnZnNfZXhjZXB0aW9uX2V2ZW50KGhiYSwgc3RhdHVzKTsN
Cj4gPiAgb3V0Og0KPiA+ICAgICAgIHVmc2hjZF9zY3NpX3VuYmxvY2tfcmVxdWVzdHMoaGJhKTsN
Cj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQo=
