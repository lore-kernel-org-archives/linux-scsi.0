Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6556BC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 08:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiFBI5I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 04:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiFBI5G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 04:57:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5232F35
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 01:57:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuH34ccxCxCpg371WAw7fbAPM0suuYHpsu6xtR0vU4RoHDjQZ2QG9SUW81Qw3/c5iepKc0nk8IklsXRy0nu91EoSmJZsRa63LEPCHbBQ33fVwnuzDXK3wgycocEgi4V/aOhl3cS991blX5Qz75iYYQdPxzP4139Ifdej8W/OZuG0T2IPHCe4biSNZ/t6KVGapvIk6CKWck4nZK1MDVHHfWpfbuV3iicG8OI/W5UfJUg4/i5XZdOTcAk0fW79F25eGZ5ZH6OCzlFEUgmbfPG9SX65b/+HjYIK8kJDiwORsmSOZRe2kqhbVp6wFPSTDDvqS6cu/vcugIFvIIdqUXRGmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vk13EULuVbDezr9CXZbU+TmpI6PSNyZKZbyOgtfBD8=;
 b=ITmNqylMmo/RQtfMIqT4xdzr5E95sd/ysQFdi3JU9zrRb1Z2C053zovZBkyznV1TpSIP3C1b6EBDcUMMRQM3fGB3C+XaY6Y+DeAZ0qooYFFUms76N7tg+SDOn+1MFGFAwflGA2ReAec4MP82+M5UU6oE0QMt2jysdOCACwjntW6fOASEUvZ2KVB6ONb9uaL+9Q9OmrNHnN6W+DAYNMTynb5NviEy7ksRlFZolaO+GXXVR2vfnkYmNw3hke+nLzRnFHFVU149oXavXnaeLnTQOWlvwHt4At2K5THMoG2JAxNl1/harbfOs5KxSRi/3dEvol73tOrjnOugGsFxazMXnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vk13EULuVbDezr9CXZbU+TmpI6PSNyZKZbyOgtfBD8=;
 b=l9w39PJYIWvyg8hDlOvLCjprcc9mETvqfKhz7oDgitSMXq17VZmuYJ/d4iNsfSHUfCiQsKfXxNTrtMhNuMAw5u/VZ9bWsbA3FsTzevk40qoJpfQHymVdyawQhsr3RnnqpVODEC+zkb7Ua9mk6XDpwc5SPZAfXw3kaROjKDKHKcs=
Received: from CO1PR05MB8411.namprd05.prod.outlook.com (2603:10b6:303:e6::5)
 by SA1PR05MB8147.namprd05.prod.outlook.com (2603:10b6:806:1b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.9; Thu, 2 Jun
 2022 08:57:00 +0000
Received: from CO1PR05MB8411.namprd05.prod.outlook.com
 ([fe80::11ed:5bdd:d41f:6d0b]) by CO1PR05MB8411.namprd05.prod.outlook.com
 ([fe80::11ed:5bdd:d41f:6d0b%5]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 08:57:00 +0000
From:   Matt Wang <wwentao@vmware.com>
To:     Vishal Bhakta <vbhakta@vmware.com>
CC:     Pv-drivers <Pv-drivers@vmware.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Elaine Zhao <yzhao@vmware.com>, Carrie Yang <yangm@vmware.com>,
        Dingyan Li <ldingyan@vmware.com>
Subject: [PATCH] vmw_pvscsi: expand vcpuHint to 16 bit.
Thread-Topic: [PATCH] vmw_pvscsi: expand vcpuHint to 16 bit.
Thread-Index: AQHYdl64RbrSQc+sK0qpMs/Mf/uOfA==
Date:   Thu, 2 Jun 2022 08:57:00 +0000
Message-ID: <EF35F4D5-5DCC-42C5-BCC4-29DF1729B24C@vmware.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.61.22050700
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d497ad1c-54c8-4600-45ec-08da4475daf2
x-ms-traffictypediagnostic: SA1PR05MB8147:EE_
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <SA1PR05MB814747C159BFD2342619A7D3DEDE9@SA1PR05MB8147.namprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wmpmVtNWcn0S2WiWWfpXbva7PZfwZoMYpAYJH8vMz+proOgQtqz75qCWc9/+bgQr5uVIFVIGXoM0Owbzz3d+K7AIiXOAh/X/UFXvK4+Hv2BBf9ebI/0DcyzknB8MTpwTOL6kL3UqNn4q621FtxVK/MwcljEUnP4UO9baJUjRimDc0SFlnqvKC+VU1NXjo9zseq2kDfw/UpeAlorQLTsyegRFpo0CvvsZaycOXxgO7pVQoEBGSD/UvQOk6K4ZZfj1xQrX6QDIHtiCwtKzCntm0W4UqZtlya8fvTr4bGjJjWYZDc7PFJHjXg1CuW39azQ86zGQhe2qi7L9uK79O5VtynXt8JEgOMTcihZNf6iFiRi14qouy8GDy3Mdv0+rucCwRadeSP1hktm0/PWz+O1XAq1uuzBMScpfzI+gMzfgkXAecPoqmvgFOvTG3cz6ishLQSJ+VHruhL+5r6hB32ssdv3N80kFZZ5b3IR+FnzLbJaHHpB4nI7rmEe/+HZZw0T3OQZ4ONjS3RKhzbI3zR7d3MeuIGADqq8F76QhH68z/wNOuU4mCMLZpWK680a5tKn6J8g1Bc+ElVzp26xkJreTU7152YY+jXdYKFxwF0ezReqFhCc3DwAK0gkdYqrUM89iTGkZeA6y6fr27Uu74CYjpLGj4sDPXJ+4fOmDm4ArPIA2BEJZs7eMAsqqrCpmc7b+ISV7r9k0156ZTgFBweLHuGuQJWuVk3yv95meylXxwnC1q3mwr4LEawwAYWLFHv1nlyIged1ToO294/8IJe2x/+ICHw2BC+vTkfzRJc3V/fg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR05MB8411.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(91956017)(54906003)(2616005)(107886003)(186003)(71200400001)(36756003)(6512007)(83380400001)(26005)(6506007)(53546011)(86362001)(37006003)(508600001)(76116006)(64756008)(122000001)(8676002)(2906002)(6862004)(4326008)(66446008)(316002)(66946007)(66556008)(5660300002)(66476007)(4744005)(38070700005)(8936002)(38100700002)(6636002)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDcybTc2dnBibGgwaVFJY3RXdmhXM3hPQlBlbGVaZjRhdEtZdVFncEcvaEhz?=
 =?utf-8?B?QngzcnN4UVQvVm5EUkF5WEhIWnpIQWMxMXFWRkk3K2YxZWhXWWtSeXNDdnBC?=
 =?utf-8?B?Wm00QXJEQkJLM2g4ejAyRkxyb2RDeU5iY0E1N05wQXJ3MWxFOVpFVjYwbWt5?=
 =?utf-8?B?ZmxOVHgzSktMRlBFU3E3YjVwSStKbk0xVHBEWTF0cHVRQlZ5cUpjcTFENHJz?=
 =?utf-8?B?anZRbUNXNUxReDNLVnFaTERiQVJHdCs3TkZEQnBjVkxoSTh0ZndZbjJIQ0Za?=
 =?utf-8?B?YjNpcHNSUjFFbE1tNVlmaTlxNS9WL2h4TnFvOExkL05Fcm1lZTdvTGZTMmhq?=
 =?utf-8?B?VmRPSGxqOTlVRi9BT3JVNjJTKzBTdEkrbzJXbm9nNExKN1VBdTZhTmNqTVYw?=
 =?utf-8?B?aTJhenpOcFdxY24xZHY3WXFPdGcyMzU0VTVpVFRYU0tHK0djNkxPNlNRd09h?=
 =?utf-8?B?ci82aXd2b3lqN3JPMkMwYUN4RHEwRThsM29Hd3JlNHF5MXBzZWs5elp2aWE0?=
 =?utf-8?B?TTJCb2tSd1E0b3BrRzhRc0lmQkY5T2Q2dnZzYjd0S2dUbTJ6NU1aR2dHcGpt?=
 =?utf-8?B?WG9OZ3BNaFBkQ2ZjMUJKU0swbEFkck0wMnZBQTBJaXFNanYyMWRjYXRrbWtV?=
 =?utf-8?B?RTEzWDBCbkNnSnJuUVY5b2hGWGd6NlREVjJBVENiL3owbFVEaDNHbCtzMitx?=
 =?utf-8?B?T0cyRG5DU3V6bDlCTnVNbFphNE5pTlpyM2RnTVBUekF5bFNSTEEwaGpyK3Qv?=
 =?utf-8?B?Q0tvd2VKd1M4L0FsRWRKaGxxaEtpZmhUN3pjOE1CaU8yMnFIVWlFOThneW5k?=
 =?utf-8?B?a0JSZXg2aXliSHV0WVkxZGsrZ1BOVm8xNjNZM1ZrNWJnMzFtdGRCL0J4WFR2?=
 =?utf-8?B?bXpBUHNrRHRmZG8ydWdOOXd3UVkzSWVncDNlN05jMUZXa2RzYXd4RkwxUy96?=
 =?utf-8?B?UTJ4alRzUlZRdTdaaTJBM2FQNTBYZXdnRWg2R21vNk5Ta2UxRU5QcjNldXJN?=
 =?utf-8?B?Nm1PNEpLYkdDcFY4VENEcHlWOGFOZ0kwWDRaZ2I1aHp4a3J5UG1kNnZoNFpD?=
 =?utf-8?B?RFUrS1hjQTcxNWx5bzQ4ZjgyMHRhVU1JQWRLU3ZwcDNkbTkrQzlGeDE0VlZi?=
 =?utf-8?B?MktWWTJWM0xmbWxRZUViS0t4eU52OGF4d1NlRGZHRjcxbERRQTRGVjFVVDEz?=
 =?utf-8?B?bENTUmUvRnBia2luWmg2NWpadHdvMjA1TWYyMW1DUW1WbkFqV1BqTjFTUXd5?=
 =?utf-8?B?RkpOYjZidzl3eldBU081OGZHQXNRZ2Z2eTdrbXZxZGVHbk5WbWd4U0dBMm9y?=
 =?utf-8?B?dUo3MkJ3R2tCSkZZUTVocVFNdUp2enljSXY2OGhiZXlvL0pPNlRYMUJZMGw4?=
 =?utf-8?B?KzA3dFl0MHNrYlhkajV3TXdlc3ZRUTZnZFpWYUZKR0hnbnhlS2NTYXF6SFZN?=
 =?utf-8?B?USs2RnVRMWNRcXBkOU02TDJzWjFrNEQveDUwcm04a2hnOTlVMjJhdUg1YWZm?=
 =?utf-8?B?YUNZYjJ3NDJ0NlNxTW53SFBwMm5TQVFZbTdCSmIxakc3MmN4WGdEZmJtbmFZ?=
 =?utf-8?B?SzMzRlFYUVpKYUxJc2V1UVg0Y3dXUWZtSjJsZWFMT21mYkhYa3o2cUxiWFpO?=
 =?utf-8?B?bStvd3ZjUnlyVEFtZW5ZU2ZaVmdOUll5VThCazNhRzQ2amhqcFppcTkwb3BU?=
 =?utf-8?B?SFVoRlZtZm1RK1N2cnRSdXUzb1o0T0Z4dmVyZ2RCVDE5YVJ6UkpIQVJZN3Vr?=
 =?utf-8?B?Si8zUG5Ed1V6ZitUa3dSVUUrOW1MR2RuMzFYeGdNMElUVzl6Yk1uRGEzcm0w?=
 =?utf-8?B?eFhiZkNsVWVIOFc5ZEpZUXExYldqai9kbnM4M3dhYko0cUwxUWI4OXFYek15?=
 =?utf-8?B?SFBZbzVhcVpOQlNVSjQzVnJiRVVtTERaMWpQYUpmenFUbVNuMVAwTVJzdUMx?=
 =?utf-8?B?NSsxUWVhSmpESUtTaXJ4eEpzVjN1dFcva3V0OExIZGJFclRNM3ZSRlpjMTJL?=
 =?utf-8?B?RFlOZmIzUDYyWDFrL1pqNXVZZ3FFYlJ6akRCVVpidVE5YlFKUWhOQlFvMXZF?=
 =?utf-8?B?ZngyM2dVSnJjY2pZRzlaYjIyV1dhOVhvZ1EwZ1JTc21jZW1NcFVwYnBjenpz?=
 =?utf-8?B?OUZFd0pwakZrWWZwU3RUVW1ucG9NQW5GVmEwZ3RJUzNwZmlBaFVwcXpDZUhU?=
 =?utf-8?B?VFhaR2pTZ0EyYmFMWTVsVFdTVHhZbGM5bWJpT2xuU2I3U0NuUVR5VHFXOFZr?=
 =?utf-8?B?eHE0cFVrM3RoOXBqejVYOG1VLytiZ2gzQU5XRDV3ZVIzWXhkbHpJNHpaSjdR?=
 =?utf-8?B?d0l3QXdLRXJ2eDd1NjJzZmV1QXpXZ25HKzhnZXV2dU4yRCtsTjdLRTFweUdZ?=
 =?utf-8?Q?3VcqxNNJ0u5QD7IQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31CF508683F285498FA4886FD5744202@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR05MB8411.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d497ad1c-54c8-4600-45ec-08da4475daf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 08:57:00.1206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZXfg+za2XSq20MNF9thz7D2BWHnx5Vug8ypMM4yrhQmtPRXu5gmVn7ZBb0inmAKr7DlPfhH5soUWwiD15sfvtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8147
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbSA0NDQ1MDdhZmIxOWYwMzg0YTNhZDgyZmRlMDRiNzhmNDM5YjQyZjBiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogV2VudGFvIFdhbmcgPHd3ZW50YW9Adm13YXJlLmNvbT4NCkRh
dGU6IFRodSwgMiBKdW4gMjAyMiAxMTo0Mjo0NCAtMDQwMA0KU3ViamVjdDogW1BBVENIXSB2bXdf
cHZzY3NpOiBleHBhbmQgdmNwdUhpbnQgdG8gMTYgYml0Lg0KDQp2Y3B1SGludCBoYXMgYmVlbiBl
eHBhbmRlZCB0byAxNiBiaXQgb24gaG9zdCB0byBlbmFibGUgdG8gcm91dGUgdG8NCm1vcmUgQ1BV
cywgZ3Vlc3Qgc2lkZSBzaG91bGQgYWxpZ24gd2l0aCB0aGUgY2hhbmdlLg0KVGhpcyBjaGFuZ2Ug
aGFzIGJlZW4gdGVzdGVkIHdpdGggaG9zdHMgd2l0aCA4IGJpdCBhbmQgMTYgYml0DQp2Y3B1SGlu
dCwgb24gYm90aCBwbGF0Zm9ybSBob3N0IHNpZGUgY2FuIGdldCBjb3JyZWN0IHZhbHVlLg0KDQpT
aWduZWQtb2ZmLWJ5OiBXZW50YW8gV2FuZyA8d3dlbnRhb0B2bXdhcmUuY29tPg0KLS0tDQogZHJp
dmVycy9zY3NpL3Ztd19wdnNjc2kuaCB8IDQgKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdm13
X3B2c2NzaS5oIGIvZHJpdmVycy9zY3NpL3Ztd19wdnNjc2kuaA0KaW5kZXggNTFhODJmNzgwM2Qz
Li45ZDE2Y2Y5MjU0ODMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdm13X3B2c2NzaS5oDQor
KysgYi9kcml2ZXJzL3Njc2kvdm13X3B2c2NzaS5oDQpAQCAtMzMxLDggKzMzMSw4IEBAIHN0cnVj
dCBQVlNDU0lSaW5nUmVxRGVzYyB7DQogCXU4CXRhZzsNCiAJdTgJYnVzOw0KIAl1OAl0YXJnZXQ7
DQotCXU4CXZjcHVIaW50Ow0KLQl1OAl1bnVzZWRbNTldOw0KKwl1MTYJdmNwdUhpbnQ7DQorCXU4
CXVudXNlZFs1OF07DQogfSBfX3BhY2tlZDsNCiANCiAvKg0KLS0gDQoyLjMwLjINCg0KDQo=
