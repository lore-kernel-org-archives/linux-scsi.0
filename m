Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06599C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 07:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC8E364FC3
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 07:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhCKHfu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 02:35:50 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:36592 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbhCKHfa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 02:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615448129; x=1646984129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uNOFyr6vzeSfqmHXYe63cxEUXzwumFi5eOt3mFEJ3xk=;
  b=qM1MHfeko2xa+LVEJtNCfTxI/Pd4OLHiIVAFDIqaqmHOnFWrSE6ai+6u
   fX8TmU9kVYJKQEFfwT7XkOrJPIq1nzqLucFhb40eUSGHp31YxxXMzUIJx
   ejLv7PM4y/h4/eJ+N8ku8t1N3KxtYixvbUl+nDZdt+IEWQ4z3X4cgVHBE
   Am1CZI6NZpV3DpYQkKfJuo8VPJfb2JznExyNHtcqSIgcBJ1vRPo6XPjYb
   sJvcPFAaGnvo+9DnvR/rQsJEUdq+uOrIs3ve9p22DrVcn25hGyWS9z0R3
   hU832lHOO7I2dn8nTYtOTq4JDhu4vZambLWuRqENe/m7QRyoqtU18qI2W
   Q==;
IronPort-SDR: dpeCfjli4H4ugwE6TVJOSe3EOVbZf98c8pZPNCU0SoUzTyXR24baqJeQgpDwpmefit7Jsmm3aV
 AYRTNO4mUlS/pXrUGu7Hp6QzySIhmunrJSAAncP3/dTj8BH1yDZ2G1Ow6Y01GzHTnk86pa6TPo
 bhfK5KsW825n7toTqrBQd6NLoBi1u4T+l7uvjUyRyMA28gxUlZoQ0YznfVsymy+ypZLtNT4fda
 e3zar0ArMDme+pIU93ppJX/+erzOe73jY/yt8CLYtoJVQRvLGVn/hMhafBTdY+d3LvJK+ptfDq
 PSs=
X-IronPort-AV: E=Sophos;i="5.81,239,1610380800"; 
   d="scan'208";a="272578019"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 15:35:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOAtTKH6j7LCgxj9q5BXGwc0b6mtKUuv7zdXwYz966cfJYKzMEpEdUAslHzFJP6uqrfxJF7YRL90h+djTbC6rA2B4tG43O8Ctz1wGukjekhyucbC9C9AFD3KV/VjKYycx8g5pH8FPOC2P/m44xfORdT4b8aQzRBXo4pjjtN84Xtxr9MGik8ztrFBiahAvok4c1DNKr6tOrI/LEQ+SwaAjkZF6ycgsyk94gDi3D7SS06DQisEBy4aD6x7QsplMPWLV39hvXeIuP+VmxdXogK2RdOXDcmPdeRxDnS6IP/928xIN1RN1gnXx/Kbundhn/eXpyFlgHtExRwPj7V4IHtN/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNOFyr6vzeSfqmHXYe63cxEUXzwumFi5eOt3mFEJ3xk=;
 b=AZl7NfvG09UOkqk+Z/y7ropVdMf1njeBcNu8rnfvafw11a18PTj2NLe4visV9Ox9qCACw9XMGoqyHxJUkexyZqr2J+jx6lXZRxN+jerJDege7iTQ6Ak/2ZdGyG7cOCZsk2cu843+JdNiHoIHzGCj2+xa9gs6VBQX9NHLPZlL+0veV44dccnC/I80/adhTbbqzilmTXlg69UZPCdREekhIp4UYpIzh7R+NBU+vZr19X/FmdFu6gsT3yeB9pHsxZHrT9Rw8b2tXjFMSbDgMA81fjsxa/BEFn5Rg8mjdpBwsuZ8eWhhlYUousOs72cLH0jlqXKp6brx4/r0yk1rIBHNTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNOFyr6vzeSfqmHXYe63cxEUXzwumFi5eOt3mFEJ3xk=;
 b=ykaLGJ5Vhi2y7t54uCyCrON/PDDXHl8o7YXfFHIcCloHDef8RCl7YpoFatRwOd6lV/S0ibZ1wmDz4vImDrAhRypeCeBGV9g9lj3p1C+xKAaq0yAlXrBb5Ay3nVErx8xqgX4tJyEQFq/7e/Zt81mn7NI87ZFKR4+82zHiqTa5hXs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5451.namprd04.prod.outlook.com (2603:10b6:5:109::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.19; Thu, 11 Mar 2021 07:35:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.039; Thu, 11 Mar 2021
 07:35:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Caleb Connolly <caleb@connolly.tech>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "ejb@linux.ibm.com" <ejb@linux.ibm.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH v3 1/3] scsi: ufshcd: use a function to calculate versions
Thread-Topic: [PATCH v3 1/3] scsi: ufshcd: use a function to calculate
 versions
Thread-Index: AQHXFcLILBOEKkzP8UyE0CzAmv03v6p9af6wgAAJ4ACAAPCGMA==
Date:   Thu, 11 Mar 2021 07:35:27 +0000
Message-ID: <DM6PR04MB657599A46A10F959FCC23485FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210310153215.371227-1-caleb@connolly.tech>
 <20210310153215.371227-2-caleb@connolly.tech>
 <DM6PR04MB65757AE022DFB7C1DA9B6D87FC919@DM6PR04MB6575.namprd04.prod.outlook.com>
 <f8284c73-34d1-e1a7-6c47-563a0057a9c0@connolly.tech>
In-Reply-To: <f8284c73-34d1-e1a7-6c47-563a0057a9c0@connolly.tech>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: connolly.tech; dkim=none (message not signed)
 header.d=none;connolly.tech; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bf308161-7967-4a58-6234-08d8e4603e02
x-ms-traffictypediagnostic: DM6PR04MB5451:
x-microsoft-antispam-prvs: <DM6PR04MB545180296C0531EF27939C4AFC909@DM6PR04MB5451.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A8v9+WRvvH47Tj2LgMPlzhpcnPfTD4Bvkc+kw0L69Q2K2Ox19kMG5z1qORBXRkobkL6WJN3+dcH9DBcB/EUVsjj4xTi4gJpDKYxU0t84pKLQdG0053uUOFxLe94q/DcvVm+KWRklSgnw9xh3pjv0j8/pRJDZBJTF9yPMDRhbOxwzUN/93+uo7QVa7UvlsabnlUvBBSbqHOBteSJ9IviQE9/Jv/CAXWymQo8QSD/D/WkHi9rkY5mDmmKEuZUxWPR1uIeOToFvFnMWrXT6jAClOjGjc8R/Jyg65CGytQ8FAK22mPFfHAapZhrhvB12WtKOqqTI+sdLSd9ggruXHuFTOLGCWFmjipY9qvK9kq6FmK08ydzT3gIqV7NGWspP/8WYZ17auCcJ/rZ7UHMWJAXSkSiUKgKNNbhvHb0ERllvXWvnloXs/3DX5chBhlj0TcuPfDaAdCsGYtth5seTZvBqjkBySWS70UyCpUwCd82kQXGoAi3/WyEN77pBqSUrXtpczq0+wMXJnatmgxRNA9mnGXWgKON/9Pm18hTS73SeBOB4Gl76/AzPE31fo2JJoPeOrzL71w0Jce8gHdZaEot5WIxKcPjI+vn6f6ZOfAvTjT8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(5660300002)(26005)(7416002)(53546011)(66476007)(2906002)(83380400001)(52536014)(8936002)(186003)(66946007)(316002)(54906003)(66556008)(66446008)(76116006)(4326008)(86362001)(7696005)(6506007)(8676002)(478600001)(33656002)(966005)(71200400001)(9686003)(55016002)(110136005)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?KzZnRVFQMGU0TlZJNWRXcXByOTlJRWErV3hramNxdmhqeWZNT25YcThKTHZC?=
 =?utf-8?B?V1hGczBLY0VZWXhadC9NaEZnQmtNbjgxSkI1cUdKRzU4RmIraUpHMGJpWlor?=
 =?utf-8?B?bEZPU28wNlg0cTRVLzNrT0N3eW5LN015dG1QMllYY3N5bmlaR3kxcjI4REJk?=
 =?utf-8?B?dGgwTStNTWRiTTAvSzc2QlIxR28wbG9UL2RWc3kwdDRhS09xL3drSFFQZjVi?=
 =?utf-8?B?WXNHSDJ5TU0zdUN0UGFDVDBEWG1FdkJqSHAzUnVqbzh2MTRhb09vVzRxV3M1?=
 =?utf-8?B?emJGQjFTUkJIdUpOM1F0b2JEZ1Zoc0VwdWJGTk9yM2FWcnlEVXVHNEpkRjln?=
 =?utf-8?B?TEtuaU56akNrUVBpcGYzY1FhVlBTeWFTTnpKZEx3clV2VUZjM0ZHWkRiZE5k?=
 =?utf-8?B?UHBzVUhTMDh2YmpTeHdQMUlST1JxT1NraXJrS0ZuL0NHc2FFYWMzSjhZVzU3?=
 =?utf-8?B?V2IyZS9MUFZBRkx2bG5LSFFBY1BvbS9NdDJsVXN2QXNtK3JHSXlSeWRWcmpD?=
 =?utf-8?B?aXczZnFBS3Rrc1JPU0phcUU4YmtNL3ZUUHVyQkxZUDE2QlZZcFUwM0RMWjlQ?=
 =?utf-8?B?ODNYbXo3dGRDQ2ZrM0NkR0RSczhWbWt4cGZ5MUhlUC9XVm50aXJNVDBLakJX?=
 =?utf-8?B?aWVBamNjcnltcncycFNjQ2xPRFgwRjRFSGE5RFg2UlQwZnN1cWJxUHNZNXRO?=
 =?utf-8?B?MldFTklVL1ZlUGUyUzJvNEhsVmFIWUE0bFVVSU13c1pGOTJLbVo1cFpoenZH?=
 =?utf-8?B?YzBsaUlkSjRtYlNwczdIbTR3Sm81YXF0UXNYZ24rSTRHazJIVWgrL2EvNU1s?=
 =?utf-8?B?QWNmOWZteWlaclpQUnBRUDFLNEN2Q3NUSDR5Smh2dXRVdTBXUzVaUVg1N0Jp?=
 =?utf-8?B?YVF0UzlPRzcrY1k5VTdBT1Q0OXBDOW51NXlSMytCTHo0cXNyYXp5OGZ1aGxk?=
 =?utf-8?B?dk5VdjNCTSt2alo5cjNoMWJJS0Ezd0VhQUVFL3N5RkF1cHdGU1RmV1oreTQ3?=
 =?utf-8?B?Y2JmT2wxSGx5ZEhBSW1UYmJGa1VMMnJuQWluRm9zOWowWnFmck5wNVpvNW1o?=
 =?utf-8?B?enRvTHJ6d094ejZyVi80UXlPZUxhVG1yV2lVWkU2SU5XSHpXcmdhTkNiL3pT?=
 =?utf-8?B?WG1jT3VzZ1krSHRQRHBUWS9abmlIV0U5azREWnhHNjB3SWNjZVNsTURPd2gz?=
 =?utf-8?B?dkUxQTU4TzRFRzdFYlAwKzlPdWgxTDNYV0Zjb0dvTGQrcVpjTDhZa2RteDhv?=
 =?utf-8?B?QjFHdURtbUtjaFVTMVFWR1FzU3kveWowUVVpci9Md3VWeTV1bS9nZlJ2Tysv?=
 =?utf-8?B?a3hzSGtIcTllNjY0VU1rdlE3SjM3TkNKS0s1Z3ZSd0QzeklDMWx0SWlGdU9l?=
 =?utf-8?B?SjhScTJyejZHczZERGV2YU1UbFpQUEV4cmxyN3cyUU95NjJDNEk1U2pIbVBG?=
 =?utf-8?B?MWtGVzF0ZDBnY1V2L0xuK044TXVlRHFPbmIweE5yV0xKUnJOVzI5OHFIaS9n?=
 =?utf-8?B?N3gwOS9EcllKVElIenJGTk9qVnVuUXFaaGlKNCtNWDFJMy9SbU01MnIyZHpR?=
 =?utf-8?B?MHR2VmhnZ1BEam5NVFIraHM0d0RzVUJxWFVaYjUwcXlVNjdRb0poNHFQRGlE?=
 =?utf-8?B?Zzd4TjkrMk10bk1DcmxmdjFKNlYvYkhLRzJaaGpmTlBORUVmOC9xR2ZHSU55?=
 =?utf-8?B?eEVmeDROZ1JEbzZQbFROZ24zS0RYaEJRNUZpTVNWOVlqRU5oNTIrSk1mbHVL?=
 =?utf-8?Q?+GmG7SrpezxGCZA9y/yGh3PWMO2ESwydPHJE3NF?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf308161-7967-4a58-6234-08d8e4603e02
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 07:35:28.0057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S+5sxqaNHPQa4qn/kkyw5qhWUWJVsQ3SwcM8CrDqT6doT24ArlVBl59Xl/xmM7W9zabj91EyLaFMljpoIorMAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5451
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSBBdnJpLA0KPiANCj4gT24gMTAvMDMvMjAyMSA0OjM0IHBtLCBBdnJpIEFsdG1hbiB3cm90
ZToNCj4gPj4gQEAgLTkyOTgsMTAgKzkyOTEsNyBAQCBpbnQgdWZzaGNkX2luaXQoc3RydWN0IHVm
c19oYmEgKmhiYSwgdm9pZA0KPiBfX2lvbWVtDQo+ID4+ICptbWlvX2Jhc2UsIHVuc2lnbmVkIGlu
dCBpcnEpDQo+ID4+ICAgICAgICAgIC8qIEdldCBVRlMgdmVyc2lvbiBzdXBwb3J0ZWQgYnkgdGhl
IGNvbnRyb2xsZXIgKi8NCj4gPj4gICAgICAgICAgaGJhLT51ZnNfdmVyc2lvbiA9IHVmc2hjZF9n
ZXRfdWZzX3ZlcnNpb24oaGJhKTsNCj4gPj4NCj4gPj4gLSAgICAgICBpZiAoKGhiYS0+dWZzX3Zl
cnNpb24gIT0gVUZTSENJX1ZFUlNJT05fMTApICYmDQo+ID4+IC0gICAgICAgICAgIChoYmEtPnVm
c192ZXJzaW9uICE9IFVGU0hDSV9WRVJTSU9OXzExKSAmJg0KPiA+PiAtICAgICAgICAgICAoaGJh
LT51ZnNfdmVyc2lvbiAhPSBVRlNIQ0lfVkVSU0lPTl8yMCkgJiYNCj4gPj4gLSAgICAgICAgICAg
KGhiYS0+dWZzX3ZlcnNpb24gIT0gVUZTSENJX1ZFUlNJT05fMjEpKQ0KPiA+PiArICAgICAgIGlm
IChoYmEtPnVmc192ZXJzaW9uIDwgdWZzaGNpX3ZlcnNpb24oMSwgMCkpDQo+ID4+ICAgICAgICAg
ICAgICAgICAgZGV2X2VycihoYmEtPmRldiwgImludmFsaWQgVUZTIHZlcnNpb24gMHgleFxuIiwN
Cj4gPj4gICAgICAgICAgICAgICAgICAgICAgICAgIGhiYS0+dWZzX3ZlcnNpb24pOw0KPiA+IEhl
cmUgeW91IHJlcGxhY2VzIHRoZSBzcGVjaWZpYyBhbGxvd2FibGUgdmFsdWVzLCB3aXRoIGFuIGV4
cHJlc3Npb24NCj4gPiBUaGF0IGRvZXNuJ3QgcmVhbGx5IHJlZmxlY3RzIHRob3NlIHZhbHVlcy4N
Cj4gDQo+IEkgdG9vayB0aGlzIGFwcHJvYWNoIGJhc2VkIG9uIGZlZWRiYWNrIGZyb20gcHJldmlv
dXMgcGF0Y2hlczoNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LQ0KPiBzY3Np
L2QxYjIzOTQzYjZiM2FlNmMxZjZhZjA0MWNjNTkyOTMyQGNvZGVhdXJvcmEub3JnLw0KPiANCj4g
aHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjAvNC8yNS8xNTkNCj4gDQo+IA0KPiBQYXRjaCAzIG9m
IHRoaXMgc2VyaWVzIHJlbW92ZXMgdGhpcyBjaGVjayBlbnRpcmVseSwgYXMgaXQgaXMgbmVpdGhl
cg0KPiBhY2N1cmF0ZSBvciB1c2VmdWwuDQpJIG5vdGljZWQgdGhhdC4NCg0KPiANCj4gVGhlIGRy
aXZlciBkb2VzIG5vdCBmYWlsIHdoZW4gcHJpbnRpbmcgdGhpcyBlcnJvciwgbm9yIGlzIHRoZSBs
aXN0IG9mDQo+ICJ2YWxpZCIgVUZTIHZlcnNpb25zIGhlcmUga2VwdCB1cCB0byBkYXRlLCBJIHN0
cnVnZ2xlIHRvIHNlZSBhIHNpdHVhdGlvbg0KPiBpbiB3aGljaCB0aGF0IGVycm9yIG1lc3NhZ2Ug
d291bGQgYWN0dWFsbHkgYmUgaGVscGZ1bC4gUmVzcG9uc2VzIHRvDQo+IHByZXZpb3VzIHBhdGNo
ZXMgKGFib3ZlKSB0aGF0IGFkZGVkIFVGUyAzLjAgdG8gdGhlIGxpc3QgaGF2ZSBhbGwNCj4gc3Vn
Z2VzdGVkIHRoYXQgcmVtb3ZpbmcgdGhpcyBjaGVjayBpcyBhIG1vcmUgc2Vuc2libGUgYXBwcm9h
Y2guDQpPSy4NCg0KVGhhbmtzLA0KQXZyaQ0K
