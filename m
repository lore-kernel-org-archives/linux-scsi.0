Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83825C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 19:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1681D64F84
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 19:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhBCTDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:03:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:13703 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhBCTDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 14:03:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612378994; x=1643914994;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MzFbD2rEdeuR3vQbGjFcmaApx+mFNkU0Dbpc+3nQgQs=;
  b=xEyNutDnswDLVDj67sVwsRvr3TOPecCGKjUcis922J1svLiX6PYQAyk/
   TQbqXyU7JE4tlOoGDKswB4rx0Yu55kxjHlLoYwylT/Y1QAKHzklEpSm7o
   7LErCqXSjuhcQtBeTu6X/TmePx2IzL6gxNHcp0OktqUscsSUlB3IQwOEV
   fxJQtJBD/N7oBS4eb8SSmCF9OYfAjbOBD91bfO+3csw/X6d89RYILfvRn
   PTOrdEgffiLy4rNt1yTyreHet7S79/Yrygisrxf1mbWRd+WU5odCEyAmW
   Lpzv2LcR2E29JP7f1gNoNWikr57KJ3HarPBDBx3voKTXlcy56/J6ahyAC
   Q==;
IronPort-SDR: 96wIctEmd3qL3aVzur5Cumwl1F7LQufE+uCzGiz7JwM+qf8C/JnXkPp+EpcyV1jcuspReNt5ai
 x3BXk1EFkku/9A6qsI5GnzwxYATcgvxgiJsCYmcXN0124Tg7As4OVRxQ1uNZ1qbTLtRsjek+nf
 dC7gXF2HdEJI0XFp2V7BG3NwbXVeOreHzylvATm6vYXIXhJo0DzCWlamK527I2r8jAwJVYMnjb
 S/Y20aDRhzAXCOen4IMxwUYcMBEe2uPQTQn0Gb7U0MK6t2BRfs5Vv0uf8GkZMiVqM4ApHpDagf
 cXU=
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="105295851"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2021 12:01:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Feb 2021 12:01:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 3 Feb 2021 12:01:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZjRqnxneFEtckiQzA+tct8UYvwVH+oJZ/iz9VxTX0JDXloGrt1P59bHhzOvf9RsbqLuKNwOv11TQEJq37BeJsFzHVLbupdNY86nlzUnFPk6hniywxey7bNzWxyiY4ihL+Xu13wottJ5JBch/o5tgyCHBCrNY5oXyDamjpY9+q54pkn/rKYzpf3SH7gFe7i2iJVwBDT351q/dKMTw9QgxqSmfeOtbUE4uXv2cur+5hO070r4pks3qLwdKRQJZARtcVU/omH1gFGN8SHePy7KLYta06ePerWRBB374ssFNIogz6Zt7H7YWb8bWCq+6nbcEIyF0huKCSQEhG8SbL1YRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzFbD2rEdeuR3vQbGjFcmaApx+mFNkU0Dbpc+3nQgQs=;
 b=gBb/qOG9N+Hmg1mcyCanMlw+u3OacQrphpuVBuEsnqw0FGlu5vRnQsDzqUpnwXQOip3vc/6K3RbGBG95S4vWqJ7GVPjYYeTIw7aY7VhtpIuB0D2FHOcXtAuOII35m/bZYq8FzcdYVpJQzXEB/J3ZmdxNQOCAVNCRzYHcqD1sU6a/adlwlAzkp3fEqjmOwkPaDe1h27Z1BgkVfYyM4goUIOCfp/br+Dvl4w96WfFFZpY6JH0kMwfCoYesuUbRkrsmtnFWSg5B82e5C8tNb4FxSKEuTes2LQOZZUaDcX7EpmUkc141fSnmNg3D1las3AI1+bLOYiMKQzStVP1ogAQItg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzFbD2rEdeuR3vQbGjFcmaApx+mFNkU0Dbpc+3nQgQs=;
 b=YKOXfpUQ3AhxO+Wlt3Dvn9v38tWTzUIe0fuBzv779cXnP8v+zjBd/Dl1kRjEyYF39R8YAM4EMRXZUlbPZanXrcQ2nnuusxJR6zLO4YpAWFV9b0NVnzfYnUx1AOCELgOYenPEvtpJMGFRlLq0710Zp5n2SmP/r4FhAinZvQs1Zng=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB5196.namprd11.prod.outlook.com (2603:10b6:806:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 19:01:28 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3825.020; Wed, 3 Feb 2021
 19:01:27 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <mwilck@suse.com>, <buczek@molgen.mpg.de>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>
CC:     <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>, <Kevin.Barnett@microchip.com>,
        <pmenzel@molgen.mpg.de>, <hare@suse.com>
Subject: RE: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Topic: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Index: AQHW71yKurA1STNSk0C6miEuXSSEDaow9juAgAEFWACAAAlxAIAAAq6AgAAFxoCAE1AKoIAADVGAgAE8SvCAAC4oAIAACYew
Date:   Wed, 3 Feb 2021 19:01:27 +0000
Message-ID: <SN6PR11MB28485DD81F22218CBA5AD032E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
 <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
 <73a25a53-db3d-c59e-b247-6533664673a4@huawei.com>
In-Reply-To: <73a25a53-db3d-c59e-b247-6533664673a4@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1aa5e8c-c680-43ed-c390-08d8c8761c4f
x-ms-traffictypediagnostic: SA2PR11MB5196:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5196ED6C575B4D6501DD4259E1B49@SA2PR11MB5196.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AWd6ylFNXZUjX1NYfW1ugxa1Fd+SrUJG5xfyI3F2JX+xIPnlDqbgqwwyvnntKIt9cSOSaLXPZ9xhUqelzWBTS7GV3KlPKcQoOgCQOrmREgC9Jkmt76JulJNZMn2T4L/sjs0eDgO0x0DjOuPPVqrm1SNPSVIFVqptb2Bwq2OxW0qesl/T8TO66usUGYv5PI4+gXkBbBRFLhPrahhBQrTdgwO3kTzBz7l0qipG38yHE29cN5Lj71+cEbQdvy5kgmIF+qLE+jR9ioOArBf61ZDWZpCQDbBukBw1q0750aKiHok1bJBm2WBQi/vPQpYBgT1/WiRMd6Z8FBoTBHwJhNPTDaJPK/lWIwg4o//uIAKg5Wxpv2MpF34JVbD76C3rl1AS0SEmZ8LierfWOit4/6niwOYWYznqGL0VjkIgXvaRcjgGWi+4QTTG86JCdT6kkyNkueZyujlaNpRWpIbh8gTuU5DHLe3R0hvP1+3UjqutLG9ra8O4w+dWBa/1tIj/fax9kppH+26/fKRQVZw3DuwRbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(186003)(8676002)(33656002)(86362001)(52536014)(66446008)(7416002)(26005)(478600001)(316002)(83380400001)(2906002)(8936002)(6506007)(71200400001)(110136005)(54906003)(4326008)(7696005)(64756008)(66946007)(66476007)(66556008)(76116006)(9686003)(53546011)(55016002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a0RWTE05MHMrai94ZTF2OEsxaUt3aThrRWRhb05rVnNqaFhkM0RUTkcvcncz?=
 =?utf-8?B?b1p6RkNUcCtDd3pSam90TDUyb0R5WlJjQSswTUk1ZXNYR3NFVVZ2eFRmMWdB?=
 =?utf-8?B?ZlBoaUhsTk14a2hJMjVub0huSTZmVUdBRHBoSnlvZ1JsR0F3QUFRSDh0b2Vk?=
 =?utf-8?B?bDg0RGxyTHpueGt0dUxWQ3JqZk54RmgwNzVQa2dack1ZaDl4SDVWR0hFRGUy?=
 =?utf-8?B?Y2xNdVhNNk93NDkxVHJvR0lrcG1QYk5FWHJvVkVtWm4wanBoNzh4aWVwNWJw?=
 =?utf-8?B?OXNIZFNTaG1WZ3hRNlJQS2tKTFZxNlNiMVEycFlvM3hNdXVNazhXdTNJLzJ2?=
 =?utf-8?B?UkhIYkErVjV2OEd0ZzZsOEJuMjlIZGFPNllRczlqZ3g0RWVCRVF1QnFvYitH?=
 =?utf-8?B?Q0JiUVNhb2NHdUdSWmt6bmZoMHNyYWQwTUw1YzlaYThMTnJhdzNQOUVkZVdh?=
 =?utf-8?B?YkFpYlRWZkwra0MvdTBDSTZKMllnMnFpcGhvbFliMWY4SDVGdFdaTlZIRFVJ?=
 =?utf-8?B?akVxQ2hzczExaTZNRnZZd0x3WWRjbHF5NU9IQzRzVGhnRVhYTnRZejkwUEZS?=
 =?utf-8?B?SHFkQmQwTUllQ2RNejlsVnFhT2FiTTRQNWd5c2czQlpRR3A2YXhHUnB6RzBn?=
 =?utf-8?B?M09USlY5ZVRXMUk0MExLTURud1BTMllSZ285YWlYSnFtTHdxeGZ5NkY0WlVV?=
 =?utf-8?B?VHhDdWNsdGcxSVB4K2VRMzRsT0pRdnA0cXdNeGxCRkdlQTBzVXZIanI3QWhv?=
 =?utf-8?B?clo2eU95NEI3RGQ2UkU0WFU1c3lNajh3ZzRYNWQvcHFiVUJDbDQvc2J5Qlpw?=
 =?utf-8?B?d2JrMXcvZXJCRXk5ZmZzVHJKckFWdGUvMGtJaE1sek5sSWJvNitWR3NBT1Nz?=
 =?utf-8?B?ZGV4d3NLV0VqVWJFMmUyZ3RTSUR6RkhjdisxUE9iS28zSTREMTlwVmtGdGV3?=
 =?utf-8?B?Z1IxYktuelJ6by91T0RmS3VMM2VpWDFZWnJQS29YZkhBSS8xdDM1MkV5aU5h?=
 =?utf-8?B?L3UwcTNDU0xSbEV3WE5zWkVvdHNDZDdZQ0ptbWVJL3lnaGkvV3JpdmNuYUEw?=
 =?utf-8?B?VEZBSTFEb0dDS1NmT0pkcFB3aTFrQ2J4ME8wcUJCQTV3SzBQbnZLSThyaDds?=
 =?utf-8?B?NVk1VlRlOVE0SVJoRmJRV3pnbXZvY0IwS2svRitlUUxhckJGRmZhblkrTW5W?=
 =?utf-8?B?MllUamhTRzhwcHhZVlVENVI0dU5lTkpuWUhubGhxWkxoK1JXWE5KZmRBaCt3?=
 =?utf-8?B?N0JzeG80T0lrRTBkU3JLSXJkRSsxZ1lCaytYanpwTHEzbXh3c1JYYlQ5Vlcy?=
 =?utf-8?B?OFdpaFZIZ1NCV1AvTjZlSHdFOHdUZlFscEx4c00vckplN0NJcGJJeko1amRr?=
 =?utf-8?B?a1Z0UTNWa20vWS9MWXZMQUJGMWJXaDhTYm1kMUNORUs4L1o3RXJSZ1lXaVdr?=
 =?utf-8?B?elg4Q2ZtQldPSENtRmVWNjRucThmT2d4LzQ5dkN1dGJHVzFXUW9yaVhyMUZH?=
 =?utf-8?B?NEsyVEE5R1F3cXdmZVN5QzVCQTRUYnpEbnU4SllkZjZ0NjdkQUJ6WjVwQmNj?=
 =?utf-8?B?bldvNmFORVJiTlZjMmhPU2VtWk5Pc0lKNG9ucmVtMUh0eEVWQ2EyclZZZStE?=
 =?utf-8?B?R3pjK0t4Qmh2M0JSdzNPcHlFbE9LT0ZFNEV6Yk1ka095TkRqdnFNRkJvYmpX?=
 =?utf-8?B?akVCRUpsVXJVb0txTmF4eEIyeFlVQTVQMFhzd0JFZnRXQURVQysrckZKeGFM?=
 =?utf-8?Q?cNAo6lCZrXqdnp9Qec=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1aa5e8c-c680-43ed-c390-08d8c8761c4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 19:01:27.7941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gQXnVAD4dTiycrwp5adlT0CnJ1hb46rUKYZY9Zo1s2xqhiHCyTWiVlUDLmKy1kTErAxVUv5NkFDQs62tL+QQAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaG4gR2FycnkgW21haWx0bzpqb2hu
LmdhcnJ5QGh1YXdlaS5jb21dIA0KU3ViamVjdDogUmU6IFtQQVRDSF0gc2NzaTogc2NzaV9ob3N0
X3F1ZXVlX3JlYWR5OiBpbmNyZWFzZSBidXN5IGNvdW50IGVhcmx5DQoNCkVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KDQpPbiAwMy8wMi8yMDIxIDE1OjU2LCBEb24uQnJhY2VAbWlj
cm9jaGlwLmNvbSB3cm90ZToNCj4gVHJ1ZS4gSG93ZXZlciB0aGlzIGlzIDUuMTIgbWF0ZXJpYWws
IHNvIHdlIHNob3VsZG4ndCBiZSBib3RoZXJlZCBieSB0aGF0IGhlcmUuIEZvciA1LjUgdXAgdG8g
NS45LCB5b3UgbmVlZCBhIHdvcmthcm91bmQuIEJ1dCBJJ20gdW5zdXJlIHdoZXRoZXIgc21hcnRw
cWlfZml4X2hvc3RfcWRlcHRoX2xpbWl0IHdvdWxkIGJlIHRoZSBzb2x1dGlvbi4NCj4gWW91IGNv
dWxkIHNpbXBseSBkaXZpZGUgY2FuX3F1ZXVlIGJ5IG5yX2h3X3F1ZXVlcywgYXMgc3VnZ2VzdGVk
IGJlZm9yZSwgb3IgZXZlbiBzaW1wbGVyLCBzZXQgbnJfaHdfcXVldWVzID0gMS4NCj4NCj4gSG93
IG11Y2ggcGVyZm9ybWFuY2Ugd291bGQgdGhhdCBjb3N0IHlvdT8NCj4NCj4gRG9uOiBGb3IgbXkg
SEJBIGRpc2sgdGVzdHMuLi4NCj4NCj4gRGl2aWRpbmcgY2FuX3F1ZXVlIC8gbnJfaHdfcXVldWVz
IGlzIGFib3V0IGEgNDAlIGRyb3AuDQo+IH4zODBLIC0gNDAwSyBJT1BTDQo+IFNldHRpbmcgbnJf
aHdfcXVldWVzID0gMSByZXN1bHRzIGluIGEgMS41IFggZ2FpbiBpbiBwZXJmb3JtYW5jZS4NCj4g
fjk4MEsgSU9QUw0KDQpTbyBkbyB5b3UganVzdCBzZXQgc2hvc3QubnJfaHdfcXVldWVzID0gMSwg
eWV0IGxlYXZlIHRoZSByZXN0IG9mIHRoZSBkcml2ZXIgYXMgaXM/DQoNClBsZWFzZSBub3RlIHRo
YXQgd2hlbiBjaGFuZ2luZyBmcm9tIG5yX2h3X3F1ZXVlcyBtYW55IC0+IDEsIHRoZW4gdGhlIGRl
ZmF1bHQgSU8gc2NoZWR1bGVyIGNoYW5nZXMgZnJvbSBub25lIC0+IG1xLWRlYWRsaW5lLCBidXQg
SSB3b3VsZCBob3BlIHRoYXQgd291bGQgbm90IG1ha2Ugc3VjaCBhIGJpZyBkaWZmZXJlbmNlLg0K
DQo+IFNldHRpbmcgaG9zdF90YWdzZXQgPSAxDQoNCkZvciB0aGlzLCB2NS4xMS1yYzYgaGFzIGEg
Zml4IHdoaWNoIG1heSBhZmZlY3QgeW91ICgyNTY5MDYzYzcxNDApLCBzbyBwbGVhc2UgaW5jbHVk
ZSBpdA0KDQo+IH42NDBLIElPUFMNCj4NCj4gU28sIGl0IHNlZW0gdGhhdCBzZXR0aW5nIG5yX2h3
X3F1ZXVlcyA9IDEgcmVzdWx0cyBpbiB0aGUgYmVzdCBwZXJmb3JtYW5jZS4NCj4NCj4gSXMgdGhp
cyBleHBlY3RlZD8gV291bGQgdGhpcyBhbHNvIGJlIHRydWUgZm9yIHRoZSBmdXR1cmU/DQoNCk5v
dCBleHBlY3RlZCBieSBtZQ0KDQpEb246IE9rLCBzZXR0aW5nIGJvdGggaG9zdF90YWdzZXQgID0g
MSBhbmQgbnJfaHdfcXVldWVzID0gMSB5aWVsZHMgdGhlIHNhbWUgYmV0dGVyIHBlcmZvcm1hbmNl
LCBhYm91dCA5NDBLIElPUFMuDQoNClRoYW5rcywNCkRvbiBCcmFjZQ0KDQoNCj4NCj4gVGhhbmtz
LA0KPiBEb24gQnJhY2UNCj4NCj4gQmVsb3cgaXMgbXkgc2V0dXAuDQo+IC0tLQ0KPiBbMzowOjA6
MF0gICAgZGlzayAgICBIUCAgICAgICBFRzA5MDBGQkxTSyAgICAgIEhQRDcgIC9kZXYvc2RkDQo+
IFszOjA6MTowXSAgICBkaXNrICAgIEhQICAgICAgIEVHMDkwMEZCTFNLICAgICAgSFBENyAgL2Rl
di9zZGUNCj4gWzM6MDoyOjBdICAgIGRpc2sgICAgSFAgICAgICAgRUcwOTAwRkJMU0sgICAgICBI
UEQ3ICAvZGV2L3NkZg0KPiBbMzowOjM6MF0gICAgZGlzayAgICBIUCAgICAgICBFSDAzMDBGQlFE
RCAgICAgIEhQRDUgIC9kZXYvc2RnDQo+IFszOjA6NDowXSAgICBkaXNrICAgIEhQICAgICAgIEVH
MDkwMEZESllSICAgICAgSFBENCAgL2Rldi9zZGgNCj4gWzM6MDo1OjBdICAgIGRpc2sgICAgSFAg
ICAgICAgRUcwMzAwRkNWQkYgICAgICBIUEQ5ICAvZGV2L3NkaQ0KPiBbMzowOjY6MF0gICAgZGlz
ayAgICBIUCAgICAgICBFRzA5MDBGQkxTSyAgICAgIEhQRDcgIC9kZXYvc2RqDQo+IFszOjA6Nzow
XSAgICBkaXNrICAgIEhQICAgICAgIEVHMDkwMEZCTFNLICAgICAgSFBENyAgL2Rldi9zZGsNCj4g
WzM6MDo4OjBdICAgIGRpc2sgICAgSFAgICAgICAgRUcwOTAwRkJMU0sgICAgICBIUEQ3ICAvZGV2
L3NkbA0KPiBbMzowOjk6MF0gICAgZGlzayAgICBIUCAgICAgICBNTzAyMDBGQlJXQiAgICAgIEhQ
RDkgIC9kZXYvc2RtDQo+IFszOjA6MTA6MF0gICBkaXNrICAgIEhQICAgICAgIE1NMDUwMEZCRlZR
ICAgICAgSFBEOCAgL2Rldi9zZG4NCj4gWzM6MDoxMTowXSAgIGRpc2sgICAgQVRBICAgICAgTU0w
NTAwR0JLQUsgICAgICBIUEdDICAvZGV2L3Nkbw0KPiBbMzowOjEyOjBdICAgZGlzayAgICBIUCAg
ICAgICBFRzA5MDBGQlZGUSAgICAgIEhQREMgIC9kZXYvc2RwDQo+IFszOjA6MTM6MF0gICBkaXNr
ICAgIEhQICAgICAgIFZPMDA2NDAwSldaSlQgICAgSFAwMCAgL2Rldi9zZHENCj4gWzM6MDoxNDow
XSAgIGRpc2sgICAgSFAgICAgICAgVk8wMTUzNjBKV1pKTiAgICBIUDAwICAvZGV2L3Nkcg0KPiBb
MzowOjE1OjBdICAgZW5jbG9zdSBIUCAgICAgICBEMzcwMCAgICAgICAgICAgIDUuMDQgIC0NCj4g
WzM6MDoxNjowXSAgIGVuY2xvc3UgSFAgICAgICAgRDM3MDAgICAgICAgICAgICA1LjA0ICAtDQo+
IFszOjA6MTc6MF0gICBlbmNsb3N1IEhQRSAgICAgIFNtYXJ0IEFkYXB0ZXIgICAgMy4wMCAgLQ0K
PiBbMzoxOjA6MF0gICAgZGlzayAgICBIUEUgICAgICBMT0dJQ0FMIFZPTFVNRSAgIDMuMDAgIC9k
ZXYvc2RzDQo+IFszOjI6MDowXSAgICBzdG9yYWdlIEhQRSAgICAgIFA0MDhlLXAgU1IgR2VuMTAg
My4wMCAgLQ0KPiAtLS0tLQ0KPiBbZ2xvYmFsXQ0KPiBpb2VuZ2luZT1saWJhaW8NCj4gOyBydz1y
YW5kd3JpdGUNCj4gOyBwZXJjZW50YWdlX3JhbmRvbT00MA0KPiBydz13cml0ZQ0KPiBzaXplPTEw
MGcNCj4gYnM9NGsNCj4gZGlyZWN0PTENCj4gcmFtcF90aW1lPTE1DQo+IDsgZmlsZW5hbWU9L21u
dC9maW9fdGVzdA0KPiA7IGNwdXNfYWxsb3dlZD0wLTI3DQo+IGlvZGVwdGg9NDA5Ng0KDQpJIG5v
cm1hbGx5IHVzZSBpb2RlcHRoIGNpcmNhIDQwIHRvIDEyOCwgYnV0IHRoZW4gSSBub3JtYWxseSBq
dXN0IGRvIHJ3PXJlYWQgZm9yIHBlcmZvcm1hbmNlIHRlc3RpbmcNCg0KPg0KPiBbL2Rldi9zZGRd
DQo+IFsvZGV2L3NkZV0NCj4gWy9kZXYvc2RmXQ0KPiBbL2Rldi9zZGddDQo+IFsvZGV2L3NkaF0N
Cj4gWy9kZXYvc2RpXQ0KPiBbL2Rldi9zZGpdDQo+IFsvZGV2L3Nka10NCj4gWy9kZXYvc2RsXQ0K
PiBbL2Rldi9zZG1dDQo+IFsvZGV2L3Nkbl0NCj4gWy9kZXYvc2RvXQ0KPiBbL2Rldi9zZHBdDQo+
IFsvZGV2L3NkcV0NCj4gWy9kZXYvc2RyXQ0KDQo=
