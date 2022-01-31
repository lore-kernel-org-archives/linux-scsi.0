Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00828C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347217AbiAaLtD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:49:03 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26918 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351497AbiAaLqu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:46:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629610; x=1675165610;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=od8bL8ma8kJYitnfjijIEGF/mApIl8GckqMkvZR+WKl2PIO0tNS8XVSD
   QQh5ig5AMRBM4f88GhQe+RKWBRO1jL/3HZz9K48NrCGM/eA4DPApuJ/H3
   KEu4u1+FTpBN6M8fkJIONjC26CDSpgqjj6icbKCBJDklRSq13QNmo0e7d
   cDMXQC8GF4v53F0pyDjt24S+SIvIheADoMYzNF5AXBp1kJOnZpHDcaLCf
   6jnCHBiObg1SjnGbqlIMPc4DAvtAliXf3Tn1KNl1B9N3lr7mfW/DPOehQ
   j6LKC7PX3Kq/0TU1Q2usI/0sMtt/Htyxnkcwhgkok7wg34SpRTQk3i7dD
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="190747629"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:46:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIWlj/m1XDcCp71wiAeuw++hjn+To8udZAhGNnho1x7yybqKm/RZTgLfYCX4D5E17EREF4ik/+OgCgVvalYEd8zPuoma5C/WV5R/+h6bR/WkmqTB6zUoJwb876VJIqGID0Q2/cLtcfdPKtANUhw72gt5H+HklXIAGvtC1fq1mrRN/XvsFBJo115hwnC0LKCY/nbxvDK4SYKkM9PXLh2Qmg75DKrVYTc4TcXblID0Z/QwJbkXO8Qff9ljrRkrkjqn/x3jG1zlU817/Q4drX82/IBF/wLCiw8jGYH08oq7e828NmslYfNqTSL5AYorfbEZdUFESfrY/a83vqByOukEuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=jDQD1nxeyyCxjtkooS/ehozIUg7D+eXSf8ghJorjajVaZK7U8bTiPVg4gvFWRGg7yGobsvZJPKG55AItHIuiKohvHtX+XLeUlOUzEx+jQsR7tpQfsOIDsvVdFuV+/mU7Ddc72W0NuYu1N+FCZLgksYVX6OD56EnNGIzxYJlMMuXMA6r2nvwM6W+anr8wugr6TzrL7/P6JPuajEIg1JrDxlhMi50PheccIfXVWfY7o8+kmVsW7+kohKsk3F5rmXfwRPfrg7MYShboRm5fq8N9n3r2CcZXGopMImhwI7lT0e+ptL//6qkJtQB4sZTPnqeoIWguNrj0pHNuHamDfL5zbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=xghzRqPLWm/ZLXhNwgQR8MtJRquqD+PNPVUvaXIWtBIRnSJG657/n/1W5v8wZUHlFhe+ovqubDjqnrlDmBVCBLm5ifpV4dzi0mpQlDi4FWDGeTpi7sguXdvsn0X5SYSnaUPVCB46/dfxoE9NJge2IVIxnIKYZ7TaQUv/3SZciQw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CY4PR0401MB3651.namprd04.prod.outlook.com (2603:10b6:910:8f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 11:46:41 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:46:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "deller@gmx.de" <deller@gmx.de>
Subject: Re: [PATCH 43/44] zalon: Stop using the SCSI pointer
Thread-Topic: [PATCH 43/44] zalon: Stop using the SCSI pointer
Thread-Index: AQHYFJWOFtnmrWFWgEeqgM3oNNOKfax9B0AA
Date:   Mon, 31 Jan 2022 11:46:41 +0000
Message-ID: <f835897bf868f73ada0431e6ce640c01b20b3776.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-44-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-44-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc132943-c833-4d5a-79f1-08d9e4af58ea
x-ms-traffictypediagnostic: CY4PR0401MB3651:EE_
x-microsoft-antispam-prvs: <CY4PR0401MB36510967106780A515A743219B259@CY4PR0401MB3651.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3a25F2iZ04/0NCG7NJ0duNoqGnm0g/CzL7cNSWdxbHaXhE7OxupkZI7S5aWInDO+wPQ4ZywPhiu+FzKX3bpDnR1ICHsLyIGeUUn2BwgPx9gRuf3NnM0l+4aewwcAGm9hzeh3NmXJT3fv/YvhkUpKcTvO+tFnsL7zxJ8cFKtesOjNnxfY7AvssNTTXhlbnLpAD89ElRxx8CY7sjbJ7QmVtln0/n3LDZpGVgO24MWk9KKfaNmoJ1h2D/MWCbO4jwnt2Lcx/HToQB8tgjTim1/tgOPdkObUO+wSyeSqLS4N+T0ZN2amF+rB7YBTcG31bfOBsfwbDPLMulyE/c0CerHMCtRgbCQqx7PoG/ELUC0oje5eAI0kgx8eSmaFIVIwZSJd5djfxMgsNMsVyQCgTm45/+LUWl20I5NnWzYsmo8X6a6UVlfeZcb2qa3ynoTy7/N1Hc92pXpW4o4sGRF2JTVDwo/FaPzwOjxvcvJVFVw3opaHSTdj2ep/BNBC61Y9xlNT2MnCVl7o8EmZcrnVxQzh5bi1o71sqlizY+qLU/XEpFhRiBPMf2ofZbZni1Tf3JZaNB8ZKLlyB+XOMHAppcT/AtHtVj1oy0kbQlXwhY4K3xw2zUGIPHlQY4at/Tdq/0/ZRKvdBYbw1+9PF0Z6VII8TbTyYLOUtv5ZvodMD/esJYeq6XAOrCcte/MHB4JI5tVgJnhCpKbl5V2+KpZf22gjQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(19618925003)(6512007)(186003)(71200400001)(2616005)(6506007)(4270600006)(36756003)(508600001)(6486002)(5660300002)(26005)(558084003)(82960400001)(86362001)(38070700005)(38100700002)(122000001)(316002)(8936002)(76116006)(91956017)(64756008)(8676002)(4326008)(110136005)(66446008)(54906003)(66476007)(66556008)(66946007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TS9HdWQ4YnVwc0tRWXJWVUVUbm1zUTg1a2hQYW4zTkY1RkYzZXdrdVlmSGMw?=
 =?utf-8?B?eW83OUlKSFBLR3dlUVJyaUg4eW11QVBiNnViMnNaK2VlSStLemFVbHB0QmxO?=
 =?utf-8?B?Q05lSVRqUkZaenY2L0U5ODY3blVWdjM2VVlYWWpCODA3RGtPNmF1blRPaElh?=
 =?utf-8?B?ZURYZ0hkMW9NMlpySXh1eFRHMXE3NlRsM1FaUVFQQUxnSWZ4Y0VJSlJqdmxu?=
 =?utf-8?B?eG1heDRtZFFlREF3dVc1NCtCVE1hVFV6N0VjemZoZXV1dU1DQXNvWFhKVGIr?=
 =?utf-8?B?OHBGWGVIcFRYejFsaStNWWRJMTU3eldkNDFXK0MreHNtK1V4OGkxRVhNdWdO?=
 =?utf-8?B?cTZQbmlKK2l0T21EZGZmS2M3dWFjSDhUbm5ZRlRJb2tIa3p6aUkrMTN0ak8x?=
 =?utf-8?B?OXhQdVhkVXNNRE1LVkdreWdudFhaeDA0VnFsYmxweFNZcmpvS1BRUHkzdm9S?=
 =?utf-8?B?MEpUWWx1UXJ6V2c4RWNodGFYeU9nU2V0Ti9JbXdTeHhpTmJpekZOOWFERnhx?=
 =?utf-8?B?S3JpTW1laHBCdGJLeFNFY3k3NXQyMmozZE9HV2ttVEkxYUhCUWhlM1lFNytJ?=
 =?utf-8?B?NmhZWER2SWpVSGwwNWpjbEYzRStmdUhOVWkwQWlGU0NmTGorU05VcDBLOEZa?=
 =?utf-8?B?MzNCMTBlMVJvbWtuVGRmT2hURGtQdWxCMTg2cjJIdHc1bjVScGdHVnZNUTNJ?=
 =?utf-8?B?b3ZiNS9uZHdPbFNqY3hDQ1IwTjlIV1oyRnpEekl5L3ZrMXAxUGF5RGU4cEpY?=
 =?utf-8?B?b2FEcXdsdW1OR2hRNlVQRndnYlE2Q2JmUzZLd3pXVktHV0VmbHRFM2tWM2k2?=
 =?utf-8?B?QUlkU3RWWS9QS00zNDRwTExDc3NvNjZnRVpTRFpWckdnRXhwOHNOemtFbEVL?=
 =?utf-8?B?bng3M1F2TEVyR2htQWRSUjU0UUx5WGd5TFNiQ1pMaVFnQUk3VENyUit5Y3Zl?=
 =?utf-8?B?NW1SUkpvUWhJdVpIOVBuYjNreDkvaHJ6QXZNZUxIWURNT1BOcXA2WHlzUkVp?=
 =?utf-8?B?MDEwZSt1cHlBbGhXaW9KOWZoa01zVDN4dDcyYmc0Q2lwczE0VlJGMjVIZldT?=
 =?utf-8?B?L0FoMkpGYllTOUdEbFlkTzdJZzZUaFZDQm10T3psa0FjV1VGSWhzRVNkZWE5?=
 =?utf-8?B?ZkFFNkZOVjkyeVlwU01PMmY5cG5RSW12TUN3VkpMUjhRZThkbndSNjNwSGxs?=
 =?utf-8?B?OU9rblRiM2I5MDJld1owSG5ZOUlZNkNFaUJOdDk3SnhZejJISU5HekFkZU1s?=
 =?utf-8?B?cFdoOEFNaW5SMkw4L05yK0hjQXlqK0FMdjBXc3hNeWp1ZTlhcVVmNFRiZmxa?=
 =?utf-8?B?Ri9JNEdKWGNyRDhhMHV4eXJvVitxYkpjL0t5TDJueTJWTXFFUG1tTWY0Zm9a?=
 =?utf-8?B?NE5kcTd5b0VXM1FpRXJSZXRBbTRHUmlXVytQdGN3OUl1NzlDaDMvUFdDMG9B?=
 =?utf-8?B?ZHYvVmxlUEpFRnJtV25Uek1zZmFrTWVVdUdZTU1qWGNRWnhJMmlCcmw2NHYw?=
 =?utf-8?B?TS9qdWtWZ0ZMbkN4UmVVS0ptL2lMTjdFQ1hpb1FmVFdFZ3p1NklMVy9PTWN4?=
 =?utf-8?B?cjBLM1JNdU5NWmdiSytvZ3JCZlNZOXpsTHpQTndiTVNGNWJOa0d4YXE0SFpF?=
 =?utf-8?B?dGY5Nms2L25wQmdjUjF4VmlkYTFGZS9nS0ZCR1F2T2xuRW5hcFptOWRJcE12?=
 =?utf-8?B?N3ZWaGRxOHgwL3g3c3pud0VkeDkvak5yY3J5Vldwam1RbUNKUkNNY3hEaU54?=
 =?utf-8?B?ZFRROGdwTEVhUStJRUMrc2dSMUkzTzNNNUc2OHNGV1JMUlFtdklWekJqVVVi?=
 =?utf-8?B?WmlzbzlUMDQzdndZOHR1Vk10bmtTczBzSHRNS1dnV1ZUQ0lnZ0RXcXFmRHUz?=
 =?utf-8?B?Y21TUWNiZlZOQWpwL0hlVnl4ZE1VN25acTJQMlNza0srNWw2d3dRWXdZK2Nn?=
 =?utf-8?B?U0VnZHRwcHFGRVJ5SWJ4VFVjWXVEcXgyNUpzTFREVzRKajFZWTlZTi9jOU5Z?=
 =?utf-8?B?OHhoRUVKR0JwdVFHeXZENmc2L2JJT0Y4NkpEdWxvVFRjb1dKNFl6QTVRdEUz?=
 =?utf-8?B?ZE1mcHBabUFiLzFQSWRiUzNVUWdHM2NGZWh4NkRjUUJWbk1IY3g1RWtHN1hT?=
 =?utf-8?B?SjVBM1FOTXJqNXZGcFErb3hOWDVlRGY2QnVzNFF3MDZNK2JSeTdrYkQwRDF4?=
 =?utf-8?B?K0Z5ZktBWVVPNWFEbmR0TkwrNkJhVU9GejJCL2JwUGt1UDdUNmNnSEoxdkla?=
 =?utf-8?Q?xgfGQf6dP5gMDdDPQ1dZSDP4uNrfz25bpeXRTxstdk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC5B7CE932C7E3498FB9E3FC2AA2D1CE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc132943-c833-4d5a-79f1-08d9e4af58ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:46:41.0713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ViQ4cz4OHrEtJBTD8rrZU/KQdeA4etxhKBbDKC/yL7zrxn8WvpX0cR3tZLTSXUug4pUdDg0MAEzfpAYfKv/jJ696cKQY6l3sP10ekYaEzm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3651
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
