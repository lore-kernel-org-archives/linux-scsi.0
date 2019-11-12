Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBC3C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 15:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5957E2084F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 15:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="UDAUugqa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKLPnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 10:43:33 -0500
Received: from mail-eopbgr820052.outbound.protection.outlook.com ([40.107.82.52]:54880
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726376AbfKLPnc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 10:43:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjvxDburQH3zz8Dhlh0N4aIfFDo9Nqs5LAH4/VBYefojqGUBZU6zFDmgWH3mw8g2mLmOo4RmE3Bwme/U30Egzgs8ZUoKZBldxMA5igtx/fuzOrNmd5D8h6KMvoG8OyYv2LAXReu33rLuWIG58cwUBshaFi0/MnZJfQKaZ8uBuu3F1eDiGmjrBjoh+YnD41C+xOTGvMjjTNOZKmyeNtNRF0QxyC67EmEvoGPdj62Fb0yT+8XEujRA5jjge9QZCmyz2zGgPs3HV/uKVkWNnFfNIfc76pQjV2WjL6ymEy2UChP/T00Nm8au5k6Bxw6dAFLL8D5eL0ZdgSqBOMIGy5rg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhlNTJK7iEjwlDCA4EPBrxu1B3zvyDsJrpJaHBOKmik=;
 b=FKcejKTfjgY/odJmny1AjGu59ADGQXRg6A5+/uO5oTdX0gfiDpUZf4AyPPJRKgsyHVFgz1g5MVKbRCbsww73nV+n5tUlGlTVfw8vCaW6hHYltY7gF4t2KAr+bOA5v3tfHayNizsZyOt1OsEPyl01djjyRylJFwOCHYnaLRp9aCdbDP6HdR+afxnwVQYv6fEkR1g8a7uFTnOFRJJ+/frNO0HDYzGaYqPclox8jqn40stRSCxP0Pw2NPcEdvUj6noEFDjfglWlXSE0K7FMIcqjh4zVfnodE6xtXfjvkJW0Mw5dtJwGMHCigIfOAgoXuR69rPIh3ZuoaK9Vod0BpCIg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhlNTJK7iEjwlDCA4EPBrxu1B3zvyDsJrpJaHBOKmik=;
 b=UDAUugqaDHfybyRd0UWGu98EwmwdvKNlZx2vkcqdzsr1O0aNOMBRsHn3xXUFQ9qh22R8e2aTMzY7NcM7hsM4GscsUhCCkbJ9nWlE/eistiwiDVpmaE1sD5NULun/88UC9Zq6zQPnkT+2+aehe059VSXssv7wdCoHZTVsL/HJDWo=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4996.namprd08.prod.outlook.com (20.176.27.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Tue, 12 Nov 2019 15:43:29 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 15:43:29 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] Re: [PATCH v4 3/3] ufs: Simplify the clock scaling
 mechanism implementation
Thread-Topic: [EXT] Re: [PATCH v4 3/3] ufs: Simplify the clock scaling
 mechanism implementation
Thread-Index: AQHVmTh6UUiNBx8CnEuBeNGP7lPB1KeHrHUQ
Date:   Tue, 12 Nov 2019 15:43:29 +0000
Message-ID: <BN7PR08MB5684F921576D9E73ED5A18DDDB770@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191111174841.185278-1-bvanassche@acm.org>
 <20191111174841.185278-4-bvanassche@acm.org>
 <f9432876516560c76c27184362592757@codeaurora.org>
In-Reply-To: <f9432876516560c76c27184362592757@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTJhOTNhYTE2LTA1NjMtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwyYTkzYWExOC0wNTYzLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9Ijc3MCIgdD0iMTMyMTgwNDcwMDcyNzc4ODkwIiBoPSJkL2xnaU0yZElpZld3MkNlSHRZVk85NHdKKzQ9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ef40b7e-36dc-4600-258a-08d7678710fb
x-ms-traffictypediagnostic: BN7PR08MB4996:|BN7PR08MB4996:|BN7PR08MB4996:
x-microsoft-antispam-prvs: <BN7PR08MB499621342995ED5D337ED5C9DB770@BN7PR08MB4996.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(189003)(199004)(8676002)(6436002)(2906002)(66476007)(3846002)(8936002)(229853002)(81166006)(66946007)(66556008)(6116002)(99286004)(64756008)(66446008)(76116006)(110136005)(54906003)(81156014)(316002)(6246003)(4744005)(52536014)(5660300002)(33656002)(478600001)(14454004)(7696005)(4326008)(76176011)(71200400001)(66066001)(256004)(25786009)(9686003)(11346002)(446003)(86362001)(74316002)(71190400001)(486006)(186003)(7736002)(476003)(55016002)(2501003)(6506007)(102836004)(26005)(7416002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4996;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1tGBlz8essRjd70nlOJdf/1+lr7przcckHsJUDZTG6PoQUtq9cotA9DPFDu551KBGzuynI1gGhsx9k9uYC6AW2CN4TT89cMGYQ2MFU9NkA2Qe1dHB2ocXcEKr5j6UGA3wLdmfSWnbgKj5Z/fcCRh66H9UNDElTuYKpeo4/Yn9stPvNVKHXgKkegc63kTQ0b3CmFDgcSHWpt07ZnJaVBkAtnafKrZsppsq0zWokpcYBqSZgq8X+/rTyFopXSaM+uOtha+tmUYRwjYdT36oYG+abhM7fKSxwHADRyv2XKi7IbbNqJoRy049C55gmLdPLEEcV2b/W62B3aIcihZicO/Pibr1hJK3EXlo9KEO0YpAjcBjJ3twEgN+7VWybPzUnqozqHSxeegPwNV3Czm+OsaqSASfqJiMKNLXePAQEsogY6VbJcS/zd+aYZ159WWb2yh
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef40b7e-36dc-4600-258a-08d7678710fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 15:43:29.8222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ltjlyqw+CtYJqg2mzzufSaABLDJnL+XBdUN3l7DVuFfDh7mKrrlGxV6PYk0bvnzSL1gd/iyPoYypyfYC4rG6+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4996
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Bart

> >  		/* handle fatal errors only when link is functional */
> >  		if (hba->ufshcd_state =3D=3D UFSHCD_STATE_OPERATIONAL) {
> > -			/* block commands from scsi mid-layer */
> > -			ufshcd_scsi_block_requests(hba);
> > +			/* block all commands, incl. SCSI commands */
> > +			ufshcd_block_requests(hba, ULONG_MAX);
> >
>=20
> ufshcd_block_requests() may sleep, but ufshcd_check_errors is called from
> IRQ(atmic) context.
>=20
> Regards,
> Can Guo.

[Bean Huo]=20
Can Guo's comment is correct, I triggered an error manually, my UFS being k=
illed.
And removing this patch, no problem. Please take this seriously.
Thanks,

//Bean


