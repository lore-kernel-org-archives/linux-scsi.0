Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED09FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 06:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8581610E8
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 06:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhJRGfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 02:35:48 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:40133 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhJRGfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 02:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634538815; x=1666074815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k44WZw8yddEkPXAPYtanWxBfZG0Q2rdSE/NYJx0w9qs=;
  b=XB3QTyCrNpPk7oVJ2AF1KgFJ33d5CXYkdkhSfwSu1mGYHKwELu4VdUja
   JbcxY/2Vxjx6hooaZXXJQcntNpGatSKYt5a2g46RUrxZdcboW1GtCo5aY
   bdU7bd3VWLkUD3m5uI7J8MQETaRuEGCnwOX6PLJcidkmBfrblF2UOW4EZ
   O8OzZOKa49KFgJMdiE8xPDp7W0EnoZkefycjUukcdli6gBQgY8idylXl4
   gefog+eGlqotNFCauNHhgCGFE+fKyvUxG5QaXQsemxd5XW3Ys7rrfo9NW
   4hU2XZABfpNuMC9Mvks2lOohpJ6lSr1TjLsTMOGzpumhXMwDHQeQ5PHio
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,381,1624291200"; 
   d="scan'208";a="187930857"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2021 14:33:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2/4k+cq22oaDJnzF7dkqk384jKLOx0DFEEyDLqBujQG9cncUAn1f8IoghJb+XVQdpzPC8Paml95tPfK32+zLkrdX1JHM0qgVI3D3+Q2Dhq2P2XvS+dNPXPWe0vALFFV4CYwzQOZzTJk0+c173ucofDQnHEx9ohY5nc3zQY+Z+4DvgFQHflrBMAfXImH4CznDkTw0vuvuOYUkeDuzowrR8rYDl49OiT5QBfj0DzFUE5mhUJXh9S8kAbgiKCWlVa3/SmDPp3CY4N7c9pR3AOjLl0FMGliL3RFXjzmh3F1bO8gn/nOO8f1ui5FhG9ClfonYRue0yfDTcmHycwVW5pvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k44WZw8yddEkPXAPYtanWxBfZG0Q2rdSE/NYJx0w9qs=;
 b=eP35IbbGkyyNonESaQfVLLzD8GnNd0FeI8+0HYgX6SY1f1myQ71Nsrofu+QgMUVdi/gKnWVbEmwRR0gjJvb29RphTlEb01u6tk/O3efPNyEHmfqG73hOYTons1csWYG74IzNGpBz7juOOHG1i4KVfrCi4RZ8/mrahgylAIvCDu9XbwDLsIwdWfYMDFDumvDY2ypnhuIKc3vxRtV2QU6Hs567JzoRPeBa0E5O4kjxSQ3jfJT/Ay23316p5A4i23UiN8M4II1/BjnYotN1Rdur65sxj1xcIgEiblZKUohuL3yPpPesIW/DGubtVTtDe6+Oz6q/fABlJDM0G/z1jyMlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k44WZw8yddEkPXAPYtanWxBfZG0Q2rdSE/NYJx0w9qs=;
 b=bVhqlmkfg2JWsaP7aLzNZLWAQx5DX4RHmAVBXTH2l38DRrvqa6Do4Y7Qvs6ca8weRJ4wRb0j9onNplbaIipdLlTI/YDZ76CdT/b+KZwn61FEotaSgBI1XKqsMebSxjLTgYz/R90lxrDuyFCuXl0D8tnCK81Jk44udWQR5Q11HJE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0266.namprd04.prod.outlook.com (2603:10b6:3:6e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.17; Mon, 18 Oct 2021 06:33:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 06:33:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH] scsi: ufs: ufs-exynos: correct timeout value setting
 registers
Thread-Topic: [PATCH] scsi: ufs: ufs-exynos: correct timeout value setting
 registers
Thread-Index: AQHXw+nSivtqF5aY70ieg9ipQEt4rKvYTCaQ
Date:   Mon, 18 Oct 2021 06:33:34 +0000
Message-ID: <DM6PR04MB6575C71656DE3B5966FE4E94FCBC9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20211018063117epcas2p28bfc50a5d793abadf37291942e139448@epcas2p2.samsung.com>
 <20211018062841.18226-1-chanho61.park@samsung.com>
In-Reply-To: <20211018062841.18226-1-chanho61.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00621419-88bf-4345-8b04-08d9920135be
x-ms-traffictypediagnostic: DM5PR04MB0266:
x-microsoft-antispam-prvs: <DM5PR04MB0266317214727AEECDCBDE84FCBC9@DM5PR04MB0266.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VJ0FkrQbPJb5EuBJCM6TDgc14rSMenme1EJ0r0fy4FsOKo0JVphf8CjQJSGxMuvXypDIbTubchxBjV5EUm48JhXQGuEeqWArfcgcGUh344ONxFsV1yOn2nWjjEUpCYafSxfhJvONJGFh0LstDdkfMBZr3vMHV73DrC/L+f5HJI5kxFp5Sm4tJJ9gJC7243XveBNd9cYPUnqcJryotSXrGgziOPI0Eca1beScZl1VXj9UgyWs9y9oDsd31QcAb0Dhiodl7iqRcDQL7Zs/GBWqWoexm/cRAh1Ms0tyvzCNatfbm3/mVY5SZEf+2VTQwWbRXnGmL5XfUJhTAscEv2AB3eCIlklU0fmtCNJMdHRk64wYp9hRlKRBAyxWSYvsTaXYfuaSW3EKwu6ucLMyNBYLs3pEuh4VMcAhnYouwyNeey4QlhvF3/yyg2Jv32jG3V1/Z0s+jF6IZrTPlpnQwmSWEOZKVUVOjMxc08SVYQpBZYFPTmgCji6ce59d8sdvs7jaPh7d1cQMB/yH6kAKDiLwHS31mVyv1hsc+IUEetY1XUaK+JWs1nciuToaTf/pryzne2h9U87lnfEEYbe11USqAkiSKQru01YNcorZ/1PuwEVFqSF291GlIT9WpGreMbzQf1SU5xUHgMkcULOyAAoVjAY/yykMuUWCeEg6eiIXGDjcGJa/pB2mh+7VS+WYTNjY6j95L759zzr2EEwlyXNjMbn9VSVSFa3zE1lkxbMsZwfjzECsf6cmpsiLh1TpCAhs0AelULs8/B84fay91CXXfqgOojpntg0jGpuU5Yp4B+4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(8676002)(66446008)(64756008)(66556008)(66946007)(4326008)(38070700005)(5660300002)(7416002)(52536014)(2906002)(66476007)(122000001)(9686003)(7696005)(26005)(55016002)(6506007)(316002)(8936002)(33656002)(110136005)(38100700002)(186003)(82960400001)(86362001)(83380400001)(54906003)(508600001)(71200400001)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTgyMXFXcnBuSjBQdFhTeXNJNVl4MGh4eFZrWE9HZEQ1QXdNL21ySnJ1ZUt6?=
 =?utf-8?B?ODl3SlB0Q1pqQk9seWl1UDN1YzV2aUtQWHlpWW5BL3ZMWnVMdXFKSGZVRE9E?=
 =?utf-8?B?aGRsS3cwSHJUSElYRFc4b1JjQmRsenR4MzdiNUdma2p5ay9rV2U5RE5aVWNu?=
 =?utf-8?B?NmtLa3lYTDRFcnhlaUNwOWlyQnQwV0NDQ3FSblk2M2M3cjgzaHA4a0k5S2Rr?=
 =?utf-8?B?cGc5TlkrMHVYdnZnYmJoR2ZmQ0h0MThXT2kvTXpmVHppNEtmdVdtVC9wYnZq?=
 =?utf-8?B?NERGTjd3MHpyaDR3ZTZGTDBGOEsvczlaN1BmWW1mc1dMUDVIZWRwNlk5TG8v?=
 =?utf-8?B?VGxOSjg3ald1V2pqRnFlSmZRTHhoNmZTVGJ0TUhMUmpINTUvdnZiT2hDQ1RJ?=
 =?utf-8?B?L2kvZ1VYMXZJRVdBUytGTFUyalB0RGRheFN1SlVpejNHdXV4RG9EUit1OXlu?=
 =?utf-8?B?bFM1UkdWdjZiVmdQc1g5NkMzSVhwM0RIdTZ5SG16aXlZc1VpMUxYR2REZE9t?=
 =?utf-8?B?ZTBjQ2RlbEFzR2tQZzhKRVpaS2kwQlFhd3AxYTU2ZWFMQXdlaU5IaGkzUnVY?=
 =?utf-8?B?YThzOTRjNENTVmJxY0FJdVlPdEFuV3NacG96d0E5NGVTL21nWTdOS09mWkpu?=
 =?utf-8?B?MnNZcXRWYS93bEs1eHdjckVTcWptVWlxV3Y0RDJ5Z2t2bE1IV3hlUmVqT25x?=
 =?utf-8?B?eWNWRDVqVVYxV2RpMW5adW1uaVB1UnBUS0hqbThWTFA1MU1HKzBZcGdFN2pi?=
 =?utf-8?B?Q2hyNmp3bUV3QVhLU1AvNzJQeXlZWExHN3hibTluaG05K2p1TElSZEJxdkhO?=
 =?utf-8?B?cWJIY1JxdVFlZWV1YWxMYk5IQ0JaYVVEOU9HNS91Kzl4YklvSm1vYWNHV0tR?=
 =?utf-8?B?TW50NmxKbkQzeUR4UlZFRmRyK2xLSm80Qi9aS3Y1bFhJdU54SFJuK05JSSs1?=
 =?utf-8?B?NURyd0h0WmZOeVgyV0VROTZOUkpRdEkxTnkwT1BVL3piSTQ3d0l4V3hSMHE3?=
 =?utf-8?B?elVFdUlMWFRjdmpiQ0w4M2NSMFRKbWRoUmlXOXdhVjRVNUlocjJERldkNVM3?=
 =?utf-8?B?VlFXNUpJSjRUYkNtU2lJS0V6OE1DMTdLT0JmcmpWYkZKTDVCcHRKVHRLUHd0?=
 =?utf-8?B?R2hFbWFsaEYvS3VHclJzUXI1NFhuSVhMbHY1Z3BldVV5NFVSdEIzcVd4YkJY?=
 =?utf-8?B?clB3MWNvQjFyNmxuZDlZWUR1Q1VHYmloWUZic09rOGtZTTRjOTliZDAvR2o1?=
 =?utf-8?B?RTlBaG5MVDlNMkoyYk9CaTByaTdqWFo4ZUIvMlgvK2Rmb0xQREVBRTdmS0lu?=
 =?utf-8?B?Ukl1U2w3RXIyTjFGY1JSeDhtdHdTZ2lKbnV6clhIbjNNT2Uzd2RobFRQRjd2?=
 =?utf-8?B?VTJNbW9NQkNJVmx6aGdSQUpvVnhhVjZNMkNsQUJLNlcxenVhcGxpUE10dTFW?=
 =?utf-8?B?WGJiMDNvUE4yMS94bUVyQ1QyaUhLbnZrYmk1RG40bTl5allpTWRmRXZMRiti?=
 =?utf-8?B?Si8wSFp5QTlWbm5pV0ZFT3d0WGdjQmdHU0lDcmtaVjZFYnhzelZGS2k2azlo?=
 =?utf-8?B?ZUNsejJWbWVBU1V5aUQwdUV3SGViQnJHckc5R0RSaXZoRlgwM0dVTWtCakow?=
 =?utf-8?B?azVsZDkxRTFvNnBIU0NTUkVTS2FucGh4a3E5bHhhTXBPUXM0clZsNjVZTFlh?=
 =?utf-8?B?UzdZS1g5eDVwOFBWdEJQNmJZamxFTjVBMjQ0UTl4NjNDWkdhS202cmxZMXpK?=
 =?utf-8?Q?jtxwBITIdJYlqgPpKwbEEMT32VTqyuJVentsXa2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00621419-88bf-4345-8b04-08d9920135be
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 06:33:34.3281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7YjVxEq66HuuJr+8NGUek3dQwUzSqve2lTXVsnuRTNI0Za2B5+or3Ie5ks2yFChaKc0kWN72Tlh66EtCVoZtIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gUEFfUFdSTU9ERVVTRVJEQVRBMCAtPiBETF9GQzBQUk9UVElNRU9VVFZBTA0KPiBQQV9Q
V1JNT0RFVVNFUkRBVEExIC0+IERMX1RDMFJFUExBWVRJTUVPVVRWQUwNCj4gUEFfUFdSTU9ERVVT
RVJEQVRBMiAtPiBETF9BRkMwUkVRVElNRU9VVFZBTA0KPiANCj4gQ2M6IEFsaW0gQWtodGFyIDxh
bGltLmFraHRhckBzYW1zdW5nLmNvbT4NCj4gQ2M6IEtpd29vbmcgS2ltIDxrd21hZC5raW1Ac2Ft
c3VuZy5jb20+DQo+IENjOiBLcnp5c3p0b2YgS296bG93c2tpIDxrcnp5c3p0b2Yua296bG93c2tp
QGNhbm9uaWNhbC5jb20+DQo+IEZpeGVzOiBhOTY3ZGRiMjJkOTQgKCJzY3NpOiB1ZnM6IHVmcy1l
eHlub3M6IEFwcGx5IHZlbmRvci1zcGVjaWZpYyB2YWx1ZXMgZm9yDQo+IHRocmVlIHRpbWVvdXRz
IikNCj4gUmV2aWV3ZWQtYnk6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogQ2hhbmhvIFBhcmsgPGNoYW5obzYxLnBhcmtAc2Ftc3VuZy5jb20+
DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQoNCg0KPiAt
LS0NCj4gLSBTZXBhcmF0ZWQgdGhpcyBwYXRjaCBmcm9tIFsxXSBhcyBzdWdnZXN0ZWQgYnkgQXZy
aSBBbHRtYW4uDQo+IFsxXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtc2NzaS8yMDIx
MTAwNzA4MDkzNC4xMDg4MDQtMS0NCj4gY2hhbmhvNjEucGFya0BzYW1zdW5nLmNvbS8NCj4gDQo+
ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1leHlub3MuYyB8IDYgKysrLS0tDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtZXh5
bm9zLmMgaW5kZXgNCj4gZDgxYTJlYjg5NGFkLi4yMjZlN2U2NGZhZDQgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLWV4eW5vcy5jDQo+IEBAIC02NDMsOSArNjQzLDkgQEAgc3RhdGljIGludCBleHlub3NfdWZz
X3ByZV9wd3JfbW9kZShzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLA0KPiAgICAgICAgIH0NCj4gDQo+
ICAgICAgICAgLyogc2V0dGluZyBmb3IgdGhyZWUgdGltZW91dCB2YWx1ZXMgZm9yIHRyYWZmaWMg
Y2xhc3MgIzAgKi8NCj4gLSAgICAgICB1ZnNoY2RfZG1lX3NldChoYmEsIFVJQ19BUkdfTUlCKFBB
X1BXUk1PREVVU0VSREFUQTApLCA4MDY0KTsNCj4gLSAgICAgICB1ZnNoY2RfZG1lX3NldChoYmEs
IFVJQ19BUkdfTUlCKFBBX1BXUk1PREVVU0VSREFUQTEpLA0KPiAyODIyNCk7DQo+IC0gICAgICAg
dWZzaGNkX2RtZV9zZXQoaGJhLCBVSUNfQVJHX01JQihQQV9QV1JNT0RFVVNFUkRBVEEyKSwNCj4g
MjAxNjApOw0KPiArICAgICAgIHVmc2hjZF9kbWVfc2V0KGhiYSwgVUlDX0FSR19NSUIoRExfRkMw
UFJPVFRJTUVPVVRWQUwpLCA4MDY0KTsNCj4gKyAgICAgICB1ZnNoY2RfZG1lX3NldChoYmEsIFVJ
Q19BUkdfTUlCKERMX1RDMFJFUExBWVRJTUVPVVRWQUwpLA0KPiAyODIyNCk7DQo+ICsgICAgICAg
dWZzaGNkX2RtZV9zZXQoaGJhLCBVSUNfQVJHX01JQihETF9BRkMwUkVRVElNRU9VVFZBTCksDQo+
IDIwMTYwKTsNCj4gDQo+ICAgICAgICAgcmV0dXJuIDA7DQo+ICBvdXQ6DQo+IC0tDQo+IDIuMzMu
MA0KDQo=
