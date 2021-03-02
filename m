Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80332C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F8D164F07
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581407AbhCBSvM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:51:12 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47871 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378991AbhCBJd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 04:33:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614677637; x=1646213637;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ye0JNLtYKX4YaaopZ7tU7/zfwYk0X0/UJqL5QAEVD5k=;
  b=HS+LA3+pgMxAIdM7FpWd7n0ApfvmBkrnZE2fYMuCj04UTffFj8pSmw71
   YxpquRVKetn4jUgBe50eRQagT60RazaMv2JWDp/nfH6Fe9PPBfP37+waR
   fMmsrLojdLUy8tf398Rs3WZiDENaLqZvcRMbiq24XCkg8qihsRl2MYjML
   OfPKkmtzpTWKr0eHa6JuuEHOooAcpkbnnBgSJaJpD8XQ9Ckhkwdb0cgkX
   s2UwUpSPuVOT7su9s26NCr1CeUZRvfYXbJc37ztjSRbx2f/kGIofgZTBQ
   PSUQAGSmOD1ETPSzTLfsAtaSUZDW1U4cLUwglk94r5IcWvfTdf96c++4R
   g==;
IronPort-SDR: BPEKopwI2zsqaLg602yFIsAksSGfpRmlzYU2fKXiQZzyJhuFSKJc5yVbZiK0ByiheDtghy+g/d
 a8HbR1fDNYPjcbAtpxyRHyZDaz4tOdIVt3BqgfJ+6doziZL6RkWSbfxTJSbXbKjjGyriS1vafL
 kOwZBG6v0L+SnHOwmy4Ycq0PqgTo7T6nj+lS+e+ukW0mvyCzZj0ketre/WTZ89LcHldNlsQN4k
 KB89AikZy1xeNn7+QqRUFiVazCeOcRVZhtD7HCVZdpbnjWSB6xtXLvObxv/fM6AJMJvs9g7ooz
 tNU=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="162312275"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 17:32:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rd11XS54OUML1sUbBM1S6CfP7RVrSn18LZdD6isSrPCsTIAKF/WPYxVINH43tSNiaml2L2MBmLrXtwS5CKb4WfFeByWpI2aXXe9fO74G2YQK7REPlnCbnbkJXhHVQFJqn5EKbJ44k9Am3pjAw89vFqp9LK2wikcIqLOCSsgDJn0Fx8o+TlKxlLyFMyV9KkQ+bwoq3J3xe25E7fvRqVHEF6oaGkKuVdGqnj0JscTtmBOXX5JGQ2pVRheJ4hDDtgv0NIyedCFzFmeZvk76RF1uWcbBaKRemaNayaFDH2Cyl+aT71iycYEs4LF6DSig7l77oH6kXuotQ5jYk//95/FctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ye0JNLtYKX4YaaopZ7tU7/zfwYk0X0/UJqL5QAEVD5k=;
 b=iJv+PRy5OVovvWNTRUJ4ltac2yWM8vd2zYhmYqMyxS48m8e15FVvXrrY9zUWeJHoU+lEfMg/EDPSnbnmasOYL3F4tgdMbomtMheeMVlQl3DXrfQv9r9gff7Yq6aZXxPDkeZWEnYV5U4Ts8nCpxZPAQMcZfv4rWci7Rh8dY8Z+CQTtj4CrC0JklcnxeLW33C03t2mVZ3Bhjr1+UP08KDrNm8JFulzNtOy8Ygx72Yg4iHYMr4zIA1uhO1bS7BvvTckd1rDLRtATQFGswqHh3RMseZgUCULrq4eFMj0qq3yvRH0nxHzpIucVlCs/BKHNVjbEqiySy6tac3ZCOfpilBFoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ye0JNLtYKX4YaaopZ7tU7/zfwYk0X0/UJqL5QAEVD5k=;
 b=ols/mkCkZB9Bs6oaueTJOyu5rlAE5rs/5G9pAofGHNMmTBw3wawG684AJkSF42dOEDTU1WO58Xft1MHlXqnsGFi8iUyaZCVHC+y8yF+AQAqtxrSWKPBspNZq2ok5j7Q9GIyJirObU+Ku/vj28OlnZGsp6xmYmDQfIs2KGTOb81Q=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4428.namprd04.prod.outlook.com (2603:10b6:5:9b::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Tue, 2 Mar 2021 09:32:42 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.030; Tue, 2 Mar 2021
 09:32:42 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v4 6/9] scsi: ufshpb: Add hpb dev reset response
Thread-Topic: [PATCH v4 6/9] scsi: ufshpb: Add hpb dev reset response
Thread-Index: AQHXDBo/LCB2rl6Je0WNJnfKtkW+SapwYZkAgAATqWA=
Date:   Tue, 2 Mar 2021 09:32:42 +0000
Message-ID: <DM6PR04MB65752B178AD8CC166D165882FC999@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210226083300.30934-7-avri.altman@wdc.com>
        <20210226083300.30934-1-avri.altman@wdc.com>
        <CGME20210226083447epcas2p2f68ef00a935d25bd2cfc930d1ef1f4f7@epcms2p3>
 <2038148563.21614673682593.JavaMail.epsvc@epcpadp4>
In-Reply-To: <2038148563.21614673682593.JavaMail.epsvc@epcpadp4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 875a57e5-42ae-4a56-f9b1-08d8dd5e2104
x-ms-traffictypediagnostic: DM6PR04MB4428:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB44282CC01C68F8CCB5F66205FC999@DM6PR04MB4428.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:612;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xPqe09keYEaQI6CBwHz0s+SBdIRXwjtfW1WbD8Lcm3d8ov32yUAemlTi9VDl9DMeQDX+BOAB5nNQwhgfeQZyG6SxQZR3lahCSask4CKqhCZ+tEUhxhRDL1WD8reFzKndVJ+v3cmaM6Alyqgwm+90Hp5YDZewvZnadO1qE9u3YNPkcaV/EwVH+mEkV4q7A1fEcC4anS74PeLIlZAqttqB9tuI8X7oXVv6XTOvfPu/dO78GVcmaJS77WQyXwzV+IaFkt4QWg8SuvDYmNLXTswxZ4LLGbt68R8LmTfFxL0I8J+hLc7ZIPRJZZZpBtPdQauwLy5xUdyqyj7Oh+IqL7Xi1MRQkBU2fn+ipwNVrfF4GscBWXl1R4yTf2ayy6SRl0O+zr1OB0abCloGcQ3/EYMp0u0o9WXCdnMVeGAKql6H922M9/hbBW64YPK8oJgQ0VJwcZH9OclfsjWM6OsGhVma5pu4koo2UivqQQ3zi2YaGXVpeTxdijM+oCVKZh2pYB27sIcKzBOSAU19k2D6RMz6OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(66556008)(2906002)(71200400001)(316002)(9686003)(110136005)(8676002)(86362001)(55016002)(7416002)(4326008)(33656002)(7696005)(54906003)(66476007)(5660300002)(6506007)(64756008)(478600001)(4744005)(83380400001)(66446008)(66946007)(186003)(52536014)(8936002)(76116006)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R2pmdmMrK2N5SzU5a2E4ckJjMllhaVRmaDV4dHpSRTd2dnY0WnRLZmhEVzZQ?=
 =?utf-8?B?VzhsNTVDQklYaFFNSE5QZXc4cE5lT08wWGpaZ053SndnbDVrNC9LS0hvUVNP?=
 =?utf-8?B?NEg0eUxBOWJJVjhCekEvVjF0REVjNGMwNHcrdEJTbFhEdWVlT0pxYVR5UGwr?=
 =?utf-8?B?a3MzRlcrT3h2SlJDeVUxWFV4NnRYS2ZGNHFOWlFoWHF3bXNOb09ZVUNtblZ4?=
 =?utf-8?B?KzJBaUR5VjR3RVJPdlE2VGtXRmxFMnRPOVMrMlZtVXJJTGNqRlM1MkczN0lU?=
 =?utf-8?B?Y0hFd3I5ajFzVWpTYzYyTHBudnlQUEZZcEoxL1lnWmtabnd4d0VDc2tyMnFG?=
 =?utf-8?B?b2RYdlZHL3RpWG41R1U2cmRDWG55SXhoUzF4dm5XOU8vNGZCTlViblRRL3g0?=
 =?utf-8?B?OGUrclMyU2xiYk1FVUI3VWJ1UllUdkxrdjRTTDA2QldPSzJ3SDMxNDRsL1d2?=
 =?utf-8?B?T1k4U2lqQlZmbnVKdVlaV3dSWVNhUENFNDF2UjhHQXd3V0dCa0ExRUVRbURN?=
 =?utf-8?B?akRFcVNoR3gvT0xJNzFJUEZPUFFuRWdYcXFFWGNDYkdPeUZ6TVRlajJxMmpt?=
 =?utf-8?B?alYzdGlzQStwaGRBVTdvaGF6ZkExUHVualdhOU5LNDZDS2tJVk1NdytFb0w0?=
 =?utf-8?B?a3FSM1o1YXpyZ283QnRYM1NYakh6R25TeDQ3MlduTkRZdTVwelRRc3JXSnBZ?=
 =?utf-8?B?ZnB6UG5CQ0VnVFZTbDl3TitwYUhYaEl4dFpaaERQMlFaSkI4V29jZmVFcmlU?=
 =?utf-8?B?eStTN3pqZGt6eU9rZ3ZlTjUrUU5uVmIxZHdKK00zZDlneXhWaFQ0OVdRRFU5?=
 =?utf-8?B?TCtiQVpVYVhMcXFQMGhXSUNYZkNCdktTbmRYUE5NWDJIdTlET3ZjZEc2NHl2?=
 =?utf-8?B?cDlnTVcyWlo1WkZPcVNNNkpJVjE1WW5zUVhKd0Rram82NEhOZkRrNlhhbm8y?=
 =?utf-8?B?MDRNTGxlR0MwQ28yYkF4N1BaZmk0K3FldDFIZXBoRk9Namt5ckE5V0FybUIr?=
 =?utf-8?B?b3NkQ055aS9Ed254dlE0ejBSME8rY0gvaVFKajFNS3pYdW1UTmZPYk1EZmhW?=
 =?utf-8?B?V080RmRwZEVnSEhsUEQvaDFQRkEvOUl2eWVlT1hBdWNrWUtEaFQ4NWZIYmY4?=
 =?utf-8?B?eS82aUliQStzWVZVcUNhSVhwaFVCUUFtNUJWODViQXhORXBrc0VkbEZXQnJt?=
 =?utf-8?B?M1BpemsrK202NnNNTENxQnJXeWJJMCtqRTl4elgreWZ2QUdaTDZmM3FpQUxo?=
 =?utf-8?B?RlBuQlcxNUdtcTBtSnI3SVJUMGRIT0xacmQ2azlDVDVUQktCNkp5dTE2a2Zu?=
 =?utf-8?B?d085cUFLTlBxZG5Id3FCdDduNmZTRWZFVXNpSWtibFhUaTlKZFVZR0Y0SURp?=
 =?utf-8?B?dml0L0tJdTZJaW5FOVFFTmNSWHZPMlc4RVFrakxSamtFTHZxbHExVklwSEd1?=
 =?utf-8?B?V1RuSWZaQ2JyRnNvOGxxSmNBck1la1ZTUzF2QVZkaHVVT3NRZEFTNWVsWGp2?=
 =?utf-8?B?dFFNOXZrQTRqQk5pV0x2L2xlK0NtWUp4dUl3TmVGMml2aU9obWFXZnc5UTFS?=
 =?utf-8?B?UmY0MHJ5L0s0Um4xWjdrNXo0cWxvRCtCVnJMbzhIYktsNmNCd0NickcxSDMw?=
 =?utf-8?B?T2liTjVDQzBqM1U1Y3MrZURURFpvSTJ3dDJiU2wzaHJuL1lldkh2VmhSNmFm?=
 =?utf-8?B?amFrd2pTdXdOb0kvRExrc2g3MkZYNTZvdm5jT0lZL1A1SVVDc2QzdkZqeU5n?=
 =?utf-8?Q?srniZcDkJ/+QCKwXzdKOVrPb3bKURTzMC9gNL9y?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 875a57e5-42ae-4a56-f9b1-08d8dd5e2104
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 09:32:42.3304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rXHZQIb4doZ651O7BVSHIoFgwbRWRC8PkMO/nx9n0lnIvYVZwfy2HNvrPs3WPSNUpprtKbpa/NJEYI+7zCtFwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4428
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGkgQXZyaSwNCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aHBiLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jDQo+ID4gaW5kZXggY2Y3MDRiODJlNzJh
Li5mMzNhYTI4ZTBhMGEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIu
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmMNCj4gPiBAQCAtNjQyLDcgKzY0
Miw4IEBAIGludCB1ZnNocGJfcHJlcChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QNCj4gdWZz
aGNkX2xyYiAqbHJicCkNCj4gPiAgICAgICAgICAgICAgICAgIGlmIChyZ24tPnJlYWRzID09IEFD
VElWQVRJT05fVEhSRVNIT0xEKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICBhY3RpdmF0
ZSA9IHRydWU7DQo+ID4gICAgICAgICAgICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZy
Z24tPnJnbl9sb2NrLCBmbGFncyk7DQo+ID4gLSAgICAgICAgICAgICAgICBpZiAoYWN0aXZhdGUp
IHsNCj4gPiArICAgICAgICAgICAgICAgIGlmIChhY3RpdmF0ZSB8fA0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgIHRlc3RfYW5kX2NsZWFyX2JpdChSR05fRkxBR19VUERBVEUsICZyZ24tPnJnbl9m
bGFncykpIHsNCj4gDQo+IEhvdyBhYm91dCBtZXJnZSByZ24tPnJnbl9mbGFncyB0byByZ25fc3Rh
dGU/DQpUaGlzIHdpbGwgYWN0dWFsbHkgbm90IHdvcmssIGJlY2F1c2UgYSByZWdpb24gY2FuIGJl
IGUuZy4gYWN0aXZlL2luYWN0aXZlIGFuZCBkaXJ0eSwNCkFuZCBJIGRvbid0IHdhbnQgdG8gbWVz
cyB3aXRoIHRoZSByZWdpb25zIHN0YXRlIG1hY2hpbmUuDQoNClRoYW5rcywNCkF2cmkNCg0KPiAN
Cj4gVGhhbmtzLA0KPiBEYWVqdW4NCg==
