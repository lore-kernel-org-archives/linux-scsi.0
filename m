Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BA7CCA481
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiGIALm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGIALl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:11:41 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F20820E8;
        Fri,  8 Jul 2022 17:11:40 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 34F51C0D67;
        Sat,  9 Jul 2022 00:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657325500; bh=HAc3/tzg65fLVtWCbSc44i2ml2azNHmM1aa/Onztfxg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=fbElT4It/wbeo9O6sfazDFW/o8/Qwjse4KV83Nc6QDsKnrojJf/RJQdqchdyF6Y6D
         xGmOdbU6bL3iSFjEKCiky+XzE4aNWLOTE8QzU217AdkFUCuGSo3I4eTRs/PnGPGLme
         nY0O9abp5ZYOHBLQ6hYTxPtQUtWJcvgBuGMXMYwyfksp7QOiSfsZ5mKQeZPSzsUFJv
         lK8+FB8S64wzcxJ59B9SBrkM70g2VHhV64LStTT6LhNqVRMHpAva3gXnagOHQqLINH
         lvYtsH7g/GkNmI7RyRui4bG96P1GcwnPjQ7B+dICaChOJWebnpP6fcYARC+D4XepAQ
         DcHewgSUMD6Tg==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 92929A00A0;
        Sat,  9 Jul 2022 00:11:39 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 3A0F140053;
        Sat,  9 Jul 2022 00:11:39 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Kb9y3cZB";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGy+mDh4L8HInjI+TCVcSk8r/qYkF4ZlCc4xR8C5GudeVaeo6oyv8v/BuMKdPzROF80RE2DUxnEyNVP0x3JuYb9bMaVOrvEdLSrXpCPZJxOULXsr8snPnfYNV07XXD8P1BaEfICsEKPYxnrtZLSFh2m7iRgkDPys0ODsq+iNKTZ7Tp/V1hjQNfhPHqq+9gQbK9GqzkkQqxhkM3SBJDWfqxcqoPMWpRwPlTv2L4lo58KC9gWADiYZz6DGz37FP3VmafVQWAVFSyRvXrWKdp8DJIWEZ3/o18mZKmIFQUTIu6nWKGUG5aEFGR6Jcy3GgyuDu7JzAuGi2Duqw1V+mWTEyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAc3/tzg65fLVtWCbSc44i2ml2azNHmM1aa/Onztfxg=;
 b=iirrmOiddlALk2bFuiNOBHcqq+FTLJ13qLmAheKup1zkcSfEyPSoN1qphjJNjUkWVN3Py1Apem+wpxbBtQH0fiyLNUAENS6ibthWBG3u8MgFiXVKsnVaLnD/wcZbKI1dRrscN8jzuZH707fjOpmUr9M92KhohOY9KygUNvQn0WtvT1nyDuW5BFKBFtR0E/LI72iWBFX3XIVykGZ3slP1J/7xxr90jswedN1eMTBB0sPbkOZZ+OxPH9wJH9P19Fd6kN6MG9LcZ3Av7hMj54GVTpb1xmHlLR01wylgQqpmyaJZYDuY2kH2B1Ld97QOzbKYV9rxSJ7ClF6lYZYoL9TzNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAc3/tzg65fLVtWCbSc44i2ml2azNHmM1aa/Onztfxg=;
 b=Kb9y3cZB6F/lghNMSZyD5410fOneTYMwzwTAjP5Hb6ERqEh8xyhOaZAQ9qkyye4vGvLXg932GXP2m/GbLGm9FV7lcbDC5SIzQx1qQbx1PgB1INFxmjLnNJInZzvkCTwcruAkbsnWQ6GuQdYTfHzXrydF6AiIlc8PLs1WZpTU/Wo=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MN2PR12MB3728.namprd12.prod.outlook.com (2603:10b6:208:167::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 9 Jul
 2022 00:11:36 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Sat, 9 Jul 2022
 00:11:35 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 12/36] target: Properly set Sense data length when copy
 sense
Thread-Topic: [PATCH 12/36] target: Properly set Sense data length when copy
 sense
Thread-Index: AQHYkZEbhJBI/uVyDEWLiCis6SoJoa1zZACAgAHJwwA=
Date:   Sat, 9 Jul 2022 00:11:35 +0000
Message-ID: <b9047058-47cc-9427-ed16-b19029dec0a4@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <9cb2ee13f6edbcfd9b719e4b4b53f7cec0080d3b.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707205311.GJ23838@yadro.com>
In-Reply-To: <20220707205311.GJ23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 533dfc00-202f-4f58-6b92-08da613f95ef
x-ms-traffictypediagnostic: MN2PR12MB3728:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tvkWOjovMzEg5QN8w/gpjyF6+3PHhEl+lYh7TfuZ6aBVwSbv00vkggReQOpydd3bBVLTnFah/O3k3AkMEP1DgDOHWafe8+k7JFlkoshHuBOP5js1BzLxUuNaTJtLHAA8G726WVV4yd7Rm3AC9ABNdMbWZxPn7F6722rnaQxu425QumLWkvtjb3UVD+NsYHtCkJ1oFiKG3g6+/wozmy9j3lvDyDX0Zj8+DBWffV9VCcA7wiU8HBXE6DZtqnTMp4UoF+wiJT9SWHjSsdRGh1Y9rwshK/NHVY6w0/vDKpZGR2C5gpkVZskXeTirahJ/N49N0XaAjmnWxVYdQJVIhW3UlfxrbBo2Ox9sW909j/QzX+rG7AZA/7QNwk0uMbFbaZP2w3HsfQWtTu726x8S2SDzdZX/7P0W0gHeRnTDq2ulQZ66Hk9IK95h3UQ7e4tDObN8zsv1Dh94mj4Fdnmt75LyM1Jd8JHq56pZHFW3UDA/S/PetmHmmucH+Q0pPYu6h0qFs2ngQJOo5HHH1UTzG0KFTSWlI+U0mK6plL+eHj2aU0aijCPJ/byICZ4i2VBs3hoZ2bOS3FKExLtNkcx1YYFTPwqpl7W5vsj6P5PVazXYbPRuVShZAu+snxPSpGG+UjCQuyjnjDb1TmpbA/et8ZzBbbsNfH69J0O9a9UVc8WeNf6NEULpFZMW84+9MSmS/fIHNk28zVsN2GDpRhdishnOLA5kQagsEnowaUhjmuaNZOhersY3Z9wi8uXlsBHnf4GTDbKODE6q6XQBOxPUY8LwVkvSvh2TqRflaWUFkLiqxQUsJdq3MzdZk5NEaIHnt39kAqw1oCeLf2XrkcMzUXf7UafdOtJx0p4bN5ap8a3LybJYcbv6I/VWfjlNieoXBdlK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(136003)(346002)(376002)(66556008)(54906003)(2616005)(83380400001)(316002)(64756008)(122000001)(38070700005)(186003)(31686004)(110136005)(71200400001)(8676002)(66446008)(66476007)(76116006)(38100700002)(66946007)(4326008)(36756003)(86362001)(31696002)(6506007)(478600001)(6486002)(5660300002)(8936002)(2906002)(41300700001)(6512007)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEdyNHZPbWFhRmVkN01nWFNrLzR2L05jUkZzVDNweVBnTUJHb0xOQUFFbVJK?=
 =?utf-8?B?YU9LQWxyK0lpZ1M1WStYOHNOZG1ibElOb0EwekpRRWNmTEY4cFFtdkZHaTFp?=
 =?utf-8?B?Y094enRQOXpJc0VBR0xBMFpuK0UwbGZ6S3doemY1R2JpWmdKekVoTUNDTDIv?=
 =?utf-8?B?ODZzcGFQRWFvNko1dVhpL3lzUEQ5L1c4NVNxNGVFMjVjdmxaWUZ3Wk9vLzFU?=
 =?utf-8?B?UlZBQTFXUU56Q1pKWk5vODVxU1RKSVIwTnc0KzFTMEVPRUtLRDZubnFOaTAw?=
 =?utf-8?B?QXAyUDdWNjhoVFVPb2ZlVlc1Y3VXVUkvWldJcml5UUlaUXJEdjlWZGhDOVpL?=
 =?utf-8?B?NUVMMGx6WitXYnBQWVIzcUEyQ0w4NHVaeE1oYzRHajdOTzA1R1E0a2Rmb2RT?=
 =?utf-8?B?OGgzT2dSYjVOV08vUXpsWjNCUjRDN285elJ4UjNUelVxVkVuT1BmUk92U3BO?=
 =?utf-8?B?ODgyUG51REtpaGZWWVg3K2g0VnpTZEt5UFZ6cFFpV0NHbk53M1B0THkwWkpG?=
 =?utf-8?B?ZHA1UnRzdWl5K0pEWnFuS0ZaOExzS3lvbVBJZUJwaWcxNWFXVU9zeDBTY25y?=
 =?utf-8?B?S1E5MDZXQmRjd0dkekptYnR4M1BnT2NFZmptTzlRRllDeVFHbGZlYWM0UEFw?=
 =?utf-8?B?QzRpSkJlRnhiUllVR1h1NXV1cXM0Zitham55bEYxalF6cDRKOHlEb3VGQy9J?=
 =?utf-8?B?N01JVHUvOWhrbWo2VUVKQTVwTnBTaGJSM1B0M3c1bjg3UnduVzhNNUJGMnUr?=
 =?utf-8?B?M0NtZE0rNGtYcHlpcWMxSyttRVB3bEZ3eWcwSGhQQk1zZVpDZDg2c2RHWGoz?=
 =?utf-8?B?dUVLWWlUQ1FwaHFubFJJaDZvd29DNjJ6bE8yRE00cHZyK0xtY1BsYXJ3eDFM?=
 =?utf-8?B?eitVYkZSWC9qVVBMWGRyc1BwR1pzMktjZlRhWmtaR1gzY0dyNlZDZEJWWU85?=
 =?utf-8?B?Z2JhbDBKdHRyVHVDNk1LaEpTNXB0UTJZUUpsa1I3V0hGd0ZtN0pMYmhPQy92?=
 =?utf-8?B?TUdoa2xVTWpNSEp5ZUY2bzIyT3k5V1RkemtjSU9aUU1rblErM0JETUpJNk1w?=
 =?utf-8?B?d3VnbDBqRHZudlArWm1MZTFzMzU3Z2pkOG92VVhyYXpFUGI4cnFYVzRkQ0Jh?=
 =?utf-8?B?ODJqNGZxcUxQVWQ0UGxZbUorU3JGZmtxSW5LRHkvYmdSekxaSmcwWTdObVA2?=
 =?utf-8?B?K2JIMDV6VmNaSjAraDBSL3kvOG9nQVRUbzRRVm5iRytVQnFMa2dmL1NDMnhj?=
 =?utf-8?B?L2NHaW0ySHk2dnNDMm1KT2k4bUxVMTk3QWhQWWRISThXbkxrdEoydm1teWRC?=
 =?utf-8?B?RTArQnRDSUorSGN5MkVxV3lDUUtFVFhWb2lXY0pFelV0aEFzZVY3enRoVXlw?=
 =?utf-8?B?aFBDZEFlazJxdk1zbE5XRnNNNEhOaDhGM051bFhORmhpeWhCaXV6VUxSei9Y?=
 =?utf-8?B?VEE4MVJwaW5iN25rRmljYmw5Ykg4Q3EvVzZXSGZxdHNETkFkaDVLL1phb0Vj?=
 =?utf-8?B?eTloTVBwYnRLYVFKbmhCc2swWGlCeGd6NHVYcDJtRWtJSzZ5V2ZYVFViQTR3?=
 =?utf-8?B?aWRjS3JscnZmdEJ6VTA3eDJ4eHNLSlp6VndZMGlFNHdaNUVqYzhNMXg0VGMw?=
 =?utf-8?B?cUNoWTFuOU5UNnYvY2dWRDNmc0w5VmhDN0VPUHdRdDZlb0h0cWl3M2duMGZv?=
 =?utf-8?B?QlFtY2Y5TXhZbXJaOEN5WURwMFpHNEl4aEVKM1IwQ2grK1VrcGh5Z1QrNE5P?=
 =?utf-8?B?am1FTUJoQStYSUVSOG5tbWNwcXZJUmJVM2IvNkZDbmlxU1ViOEFZVTVnZnBF?=
 =?utf-8?B?djRZMUp5dnlXWVJjN3ZRUDFRVXpJSGdtVklkeWhmbnltcXBjNDhOdzZRb0xQ?=
 =?utf-8?B?WXFYVzJ1ZjFFUUNOTWowL0FaVHF2RlRhT1lNMXpXQ2JtMDFQK0ZxcU5BUzh0?=
 =?utf-8?B?NzRJYTBaa1BOSXo2d2lDWTFVRURRcDRIZGRhdVpVQTY0SVQyZkNTRmZUYTZj?=
 =?utf-8?B?dUVTbnhPbCtuM0R2Mkh2YjZLQ1JoOVFWcE4vQTFWUVMxdVF1SUhiZ2d6T0Z0?=
 =?utf-8?B?T3hteWpkcTEwcFBFOERpa2oxd0JHUmJaYk5QV0RDZCt0QzM2clRFR1ArVDU4?=
 =?utf-8?Q?o0LyY0ieCr7o7i3aRoobdUZdw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB9802FC97274041AE97A236A4B87D54@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533dfc00-202f-4f58-6b92-08da613f95ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 00:11:35.2363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 78KPcaU0yeeu5fTx3jO7LPfPgI0t+qY0eHhzqIbO6ONwl6I2Ezegv2rfHU+Z6TT43EgRF9qt5GppeDyep8rltQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3728
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+IE9uIFdl
ZCwgSnVsIDA2LCAyMDIyIGF0IDA0OjM1OjM4UE0gLTA3MDAsIFRoaW5oIE5ndXllbiB3cm90ZToN
Cj4+IFRoZSB0cmFuc3BvcnRfZ2V0X3NlbnNlX2J1ZmZlcigpIHNldHMgc2Vuc2UgZGF0YSBsZW5n
dGggdG8gYmUgdGhlDQo+PiBhbGxvY2F0ZWQgc2Vuc2UgYnVmZmVyIGxlbmd0aCBUUkFOU1BPUlRf
U0VOU0VfQlVGRkVSLiBIb3dldmVyLCB0aGUgc2Vuc2UNCj4+IGRhdGEgbGVuZ3RoIGlzIGRlcGVu
ZGluZyBvbiB0aGUgc2Vuc2UgZGF0YSBkZXNjcmlwdGlvbi4gQ2hlY2sgdGhlIHNlbnNlDQo+PiBk
YXRhIGZvciBjbWQtPnNjc2lfc2Vuc2VfbGVuZ3RoLg0KPj4NCj4+IFNlZSBTUEM0LVIzNyBzZWN0
aW9uIDQuNS4yLjEuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogVGhpbmggTmd1eWVuIDxUaGluaC5O
Z3V5ZW5Ac3lub3BzeXMuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvdGFyZ2V0L3RhcmdldF9j
b3JlX3RyYW5zcG9ydC5jIHwgOSArKysrKystLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90
YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29y
ZV90cmFuc3BvcnQuYw0KPj4gaW5kZXggOTczNDk1MmE2MjI4Li4yZmM0YmExODE0YzYgMTAwNjQ0
DQo+PiAtLS0gYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90cmFuc3BvcnQuYw0KPj4gKysr
IGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMNCj4+IEBAIC03NzEsOCAr
NzcxLDYgQEAgc3RhdGljIHVuc2lnbmVkIGNoYXIgKnRyYW5zcG9ydF9nZXRfc2Vuc2VfYnVmZmVy
KHN0cnVjdCBzZV9jbWQgKmNtZCkNCj4+ICAgCWlmIChjbWQtPnNlX2NtZF9mbGFncyAmIFNDRl9T
RU5UX0NIRUNLX0NPTkRJVElPTikNCj4+ICAgCQlyZXR1cm4gTlVMTDsNCj4+ICAgDQo+PiAtCWNt
ZC0+c2NzaV9zZW5zZV9sZW5ndGggPSBUUkFOU1BPUlRfU0VOU0VfQlVGRkVSOw0KPj4gLQ0KPj4g
ICAJcHJfZGVidWcoIkhCQV9bJXVdX1BMVUdbJXNdOiBSZXF1ZXN0aW5nIHNlbnNlIGZvciBTQU0g
U1RBVFVTOiAweCUwMnhcbiIsDQo+PiAgIAkJZGV2LT5zZV9oYmEtPmhiYV9pZCwgZGV2LT50cmFu
c3BvcnQtPm5hbWUsIGNtZC0+c2NzaV9zdGF0dXMpOw0KPj4gICAJcmV0dXJuIGNtZC0+c2Vuc2Vf
YnVmZmVyOw0KPj4gQEAgLTc5MSw3ICs3ODksMTIgQEAgdm9pZCB0cmFuc3BvcnRfY29weV9zZW5z
ZV90b19jbWQoc3RydWN0IHNlX2NtZCAqY21kLCB1bnNpZ25lZCBjaGFyICpzZW5zZSkNCj4+ICAg
CX0NCj4+ICAgDQo+PiAgIAljbWQtPnNlX2NtZF9mbGFncyB8PSBTQ0ZfVFJBTlNQT1JUX1RBU0tf
U0VOU0U7DQo+PiAtCW1lbWNweShjbWRfc2Vuc2VfYnVmLCBzZW5zZSwgY21kLT5zY3NpX3NlbnNl
X2xlbmd0aCk7DQo+PiArCW1lbWNweShjbWRfc2Vuc2VfYnVmLCBzZW5zZSwgVFJBTlNQT1JUX1NF
TlNFX0JVRkZFUik7DQo+PiArDQo+PiArCS8qIFNlbnNlIGRhdGEgbGVuZ3RoID0gbWluIHNlbnNl
IGRhdGEgKyBhZGRpdGlvbmFsIHNlbnNlIGRhdGEgbGVuZ3RoICovDQo+PiArCWNtZC0+c2NzaV9z
ZW5zZV9sZW5ndGggPSBtaW5fdChpbnQsIDggKyBjbWRfc2Vuc2VfYnVmWzddLA0KPj4gKwkJCQkg
ICAgICAgVFJBTlNQT1JUX1NFTlNFX0JVRkZFUik7DQo+IExvb2tzIGEgYml0IHN0cmFuZ2UgLSB0
byBjb3B5IGJpZyBhbW91bnQgb2YgZGF0YSBhbmQgdGhlbiB0byByZWR1Y2UgdGhlDQo+IGxlbmd0
aC4gQmV0dGVyIHZpY2UgdmVyc2EgLSBzZXQgY29ycmVjdCBsZW5ndGggYW5kIGNvcHkgb25seSB0
aGF0IGRhdGEuDQoNClN1cmUsIEknbGwgZG8gdGhhdC4NCg0KVGhhbmtzLA0KVGhpbmgNCg0KPj4g
Kw0KPj4gICAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY21kLT50X3N0YXRlX2xvY2ssIGZsYWdz
KTsNCj4+ICAgfQ0KPj4gICBFWFBPUlRfU1lNQk9MKHRyYW5zcG9ydF9jb3B5X3NlbnNlX3RvX2Nt
ZCk7DQoNCg==
