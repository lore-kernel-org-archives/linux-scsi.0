Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7509FC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FE8D24679
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="iYRMy9x7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfLTI4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 03:56:18 -0500
Received: from mail-eopbgr750058.outbound.protection.outlook.com ([40.107.75.58]:18499
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727174AbfLTI4R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Dec 2019 03:56:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXXDyt5CCVoxyEPGd/tRuTUjMAYGdk61RGSGKvS+nUzAMAu7uCjFRp3zXMh+59voJ1U9zeHdloFQgEtVSMLGeRtPm3fyEbN3FUzeR1F5gTHoRWYvIWApiBP25C7BzmWA1BkKjZetu+96h+vTZI3bql5P/tkKc3z9aZ1PGghaVt1yo9cccKUrLtqW/Zu0CaSmtWc4M3YfaFYKFI6aDEFhyXAGaExu7AOL+zvgIauJUrZERZZKR8q0ULH/+WwxHfuBoQlw/bD2ZuWcdhQilPW33nxUef/oBUXqnKLUZKhAZHoGq5sBAoquqUEP+9hhfYazJMAVq1IFC0wTV4lMM8CNsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Mwd/Z+9Mmp3hoR9xUXyrOgJ8/kIUSshjLuQmZUa7zE=;
 b=mZxXSFbe0RRxDWo3XWMg/utxgBbIjDjjGg7xYrAzSwx1bO3uGAXsd+8Jl+/h3dO2yISdC6GroBW4OwZMjmPLNS4GNmJz/6UMxZ/H+snjzw5myfv0z77gHuZ3gBiZUFXc2nMVkffZxXtmUZbtf+aQx/3bUNMFdnyuRYgTEzSGLKUnVtEsciJMQci0dTQ9dfi1jvz0yAmPH/2wMvV2gJcMIIfRlwerGRX92gH+2yknthWsUs3FZBxGOA0Xhds6Lq66jsq1WJ3GMsfj0C99llVe9vwGLkj/s3xdukN5VIoxKeiFRBWEfjL7Fikn0ag2VhYdx0o0l3mhgXzyIay2P5Ol4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Mwd/Z+9Mmp3hoR9xUXyrOgJ8/kIUSshjLuQmZUa7zE=;
 b=iYRMy9x7CfHK6x2r7EcOZ6yXimW8KyBkOd3snPJEwZvnUCuxBOnnJ+epjkqstT9fifbsC8G7+PHlTZn5jyd7obJSU2iswVJvF3+zd9FlKNGGNuxKu4WPa2H2k9zEV7lt6yJrjDuJSy6ckaBgdQMAfn6gvXTu9LYIOV8Q/n+C1E0=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (20.178.241.217) by
 MN2PR05MB6784.namprd05.prod.outlook.com (10.255.7.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.9; Fri, 20 Dec 2019 08:56:12 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::75e5:6ff0:553e:7401]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::75e5:6ff0:553e:7401%6]) with mapi id 15.20.2581.007; Fri, 20 Dec 2019
 08:56:12 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?iso-8859-1?Q?Thomas_Hellstr=F6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Vishal Bhakta <vbhakta@vmware.com>, Jim Gill <jgill@vmware.com>
Subject: Re: [PATCH RESEND 1/2] scsi: vmw_pvscsi: Fix swiotlb operation
Thread-Topic: [PATCH RESEND 1/2] scsi: vmw_pvscsi: Fix swiotlb operation
Thread-Index: AQHVqhA88VALO66GgU+znrgwAg1BSA==
Date:   Fri, 20 Dec 2019 08:56:12 +0000
Message-ID: <MN2PR05MB61418001C0180C55D4D72B45A12D0@MN2PR05MB6141.namprd05.prod.outlook.com>
References: <20191203193052.7583-1-thomas_os@shipmail.org>
 <yq1sglf8xv0.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-originating-ip: [155.4.205.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce1ed8f8-46b4-448a-431e-08d7852a76dc
x-ms-traffictypediagnostic: MN2PR05MB6784:|MN2PR05MB6784:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB67843547EB66F0117A1AA9A1A12D0@MN2PR05MB6784.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(5660300002)(52536014)(53546011)(33656002)(4744005)(54906003)(26005)(66476007)(66556008)(86362001)(9686003)(7696005)(55016002)(186003)(4326008)(107886003)(76116006)(6506007)(478600001)(71200400001)(66446008)(81166006)(8676002)(81156014)(316002)(110136005)(66946007)(91956017)(64756008)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6784;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y/QPFFoZyuIwsT46XUv0Fah9DDcUlQsiwmckPyWYJpnh9PecA1YY4LL9BpnclGaiM76vdNZjT0k312Ur2SJs9ADOgJXcYLcjJPDTnKytetvHxzVMYtkXiMt88F3jU5phAf4yCfT3YqlifLETUabvw8ly0a6SG/9J/KRrXCxpp3BFB3d3IBGb/eSpZ3AnsujKQuMNqDwA24Jlk/Mw3ls3uch12ZRDmuXzVGTfklQi+a7Wo4javc7c656WA4YoYDGE1d7cfbLh3BWJpJn5nF8PW9JkpdSm8XlRVgv48iWb3PxenjR8BWu7Aq8P3vzV9BrdgRmNxWMo5a5vc0Q0lQr8m3KTZHa558ZrT5dWoyNIsQ2aDmnm80SHe0oAEyeVGDrWlWvprVwD1Y3lPDtFrBMM/qHxqcELwXyvDukt+Qlu0sa/x/hl3CF31/w8Iv7wJgAe
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce1ed8f8-46b4-448a-431e-08d7852a76dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 08:56:12.3952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oYQOGx7nA8VVlre/2FjTYPcNykOjFCe7rdgY2vHrkrbR2YmpZ/J7YVZHcm9F0keUX+6Awqrb5OFAczA/SXGYSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6784
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 4:44 AM, Martin K. Petersen wrote:=0A=
> Thomas,=0A=
>=0A=
>> With swiotlb, the first byte of the sense buffer may in some cases be=0A=
>> uninitialized since we use DMA_FROM_DEVICE, and the device incorrectly=
=0A=
>> doesn't clear it. In those cases, clear it after DMA unmapping.=0A=
> Applied 1+2 to 5.6/scsi-queue, thanks!=0A=
>=0A=
Thanks!=0A=
=0A=
Thomas=0A=
=0A=
=0A=
