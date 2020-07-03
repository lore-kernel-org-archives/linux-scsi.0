Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAE4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4294E20724
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="xr3YmH1f";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="hIMMgjrX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgGCEdV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:33:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725648AbgGCEdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:33:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0634XIeC029068;
        Thu, 2 Jul 2020 21:33:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=CbtrAjSbqCTPPQYSGhBb8NroulCW4wr67K0L9MDwLR4=;
 b=xr3YmH1fS3H7sHj0u+V3Uix+KJVIamLwEjp/OY0Onm9zlw2Nr0Z9KVAVE3FrdVeIAJTv
 sP7eC/r9BLvvjWPIM1qJ19SThd95aKUmc7uR4H0Zipwrht3DPg2Gg0XCfhAVmYuY1O4b
 onAYyZZVD/gtVVnHYZS4QzGxg7NZIXLXe/R2ciQ/8fCFluMta8y5NK5t9VgJ0csdQXnc
 8adp6ErEMHXrF1etvmYQpVF+n7DfD6g8XOvHrHXaXJkm2qMB1eKLz2soaMblmQVkw9M3
 ogVvJqOfz3X+X2XAQS9ZmQUZMlB8S8XVEbApf1Q+7UV5+mbMZPtrI6r4LUTgLQmrB4VB Kg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mp0bju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 21:33:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 21:33:16 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 21:33:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 2 Jul 2020 21:33:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlcjyGE9oZM9BGE1CAsLQARThrjKCYG3yTV1I4DnM0bpkvDj6pTueq2O4kpNfW5O/751cl0BRZ0G55/KYEs3ckZuR4EbTfAzcJVttfg4YFL1Hc0QVIB+7W4cU17MlOBgZ+MEYrfgyrM48RBx2U+4QveKU4BYO2s7j7EQSnUaHYukn5pYv6JUoXllsOLPjms/rhPAQQnTg0nxEI3SsRQ1RZoKbR11dI6sVUEIhwWQEbcr5G/RV3fwhPgoA5fUmLRO2t6jhcBIgxgv0/KjKNxMt97ZjhlGPW2jLm+ANIoR/OvkGx63m4yk+kKt2m56WWcasIA7YvkbvsfJ0nsCDW/6aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbtrAjSbqCTPPQYSGhBb8NroulCW4wr67K0L9MDwLR4=;
 b=PSfEoK/ih4gnGrBMrh6LKGtpB3a7BvESq8XSJKO19eH8fEHG0YiUQrLDLHD/p0OGyo0stTkCHMkQSZjn9hit95h/4G0dUNugto/Z59dEWY5s0pmdZICs6sfww/ThtKe3Fw/aDuT7xY2n6qkV731g5iMvE0trsn8vO5wJ0dG5jnwd40BiHKtJ+ZJAjjHJIws1hGgxc6N3ly1zEhNj3E0FQpheBuMLsvrtIdWoFdjodzoxXMwuwvGA/YXCa68QBgpY65sviAo54SOQGNSbPib+ovj9PrDyUNhR2SZerhwF9AqqxweOXRkgteaPydBJp6U4oda8vguNRJmzwO9Jht4ZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbtrAjSbqCTPPQYSGhBb8NroulCW4wr67K0L9MDwLR4=;
 b=hIMMgjrXyrLhFFvMPK3BRvBJ7Zb5QJszo+ooc6czq5tcV4aMEGeizOuE+19SnJ1Ow0hDdfxMO9nBCIcKcwaRqSbioC9jD+KRLiLX6Erdkw7KHjXk2BaxOLmAKcSgPin6m5gMngYFooBLIjHl2FGMD2fjZLG2UxV7iL08UHP79lc=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BYAPR18MB3751.namprd18.prod.outlook.com (2603:10b6:a03:a2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Fri, 3 Jul
 2020 04:33:14 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b%7]) with mapi id 15.20.3153.022; Fri, 3 Jul 2020
 04:33:14 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v4 2/2] qla2xxx: SAN congestion management(SCM)
 implementation.
Thread-Topic: [PATCH v4 2/2] qla2xxx: SAN congestion management(SCM)
 implementation.
Thread-Index: AQHWTsiZXWb0GstOW0WJZJcXdXykBKj1R60AgAAA4YA=
Date:   Fri, 3 Jul 2020 04:33:14 +0000
Message-ID: <EBB03D42-D976-4889-90C5-8190EF7938D8@marvell.com>
References: <20200630102229.29660-1-njavali@marvell.com>
 <20200630102229.29660-3-njavali@marvell.com>
 <eceec220-f9ac-5854-0377-a4d2293ba35c@acm.org>
In-Reply-To: <eceec220-f9ac-5854-0377-a4d2293ba35c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:f8e0:2a43:7144:81c5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fd0ba4f-3e6f-4f3c-4f4d-08d81f0a332b
x-ms-traffictypediagnostic: BYAPR18MB3751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB3751AC6521E4A8E6879232A1B46A0@BYAPR18MB3751.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q1s24A89DngTSGpk9l8n83zjp6/l2EQ3IqVfvcwZgzOGM6+O845XEqV/UmTVnedvy8ujPYaZ7VF7VU2GK2DLaxkwQbveOmSpquPffUvUPNSeTOroFO3opQScTM7Ipj+irduvWL2RdGh4zgr7soXscwpcqWCPl1gXmaOjxkNyVufaQ5xj3S9A2FHMz01PWqadNvSi0Bioktwbcht41tJiAp7DmzSLXxt0Wo4flOSUEGtXiru8eRsDf0nN8d4UHFqk5vpYV4yoWB18mL0jUzIcUxo20zEqNOWEc4S5JiQg8FnaBR7JV9UGDW8Fr4dwlJEd1Mrt+ygUHZom/W2fRPOWJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(6486002)(2906002)(2616005)(66446008)(66556008)(64756008)(66476007)(4744005)(66946007)(86362001)(5660300002)(36756003)(76116006)(6916009)(71200400001)(6512007)(316002)(4326008)(107886003)(186003)(8676002)(8936002)(6506007)(53546011)(33656002)(54906003)(478600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BjjKYkUePfEmh5BDYJNMRTwxgKLCQqDMG9Z84Yc0j3/J5AuVH6a9DnvE4V+IuY8CJN6rUAZqfWr1I7KcYrOQIWekdAon0XsQY1ROJPmOhIXZo6TU++XyRoivkp88ypWQZ9kt7yZkdR+9ZqjQC3ij2lcgxIW+KJPBhv+s95p3p5ZTpUhk6tBBLVlSHyMvXfXd4Q2hqBdVw89GKP/nd1YRL/XPe08ZslbUTQaDBzyLfeAfVz/xErWIUyHGIgw6dUqXonlx8Ht9EC0ai8DEu+h9iXMJqhI+ij36If83/IDoY6x6vLaHjjsXbK463HJNiEg8Dg4mWHLeJG5Ry/iBZHZD5M24b75BJsTdxncK2iovZ4HsEvav40TSwMoK//YzeD8IFr2B39AmHXSzYjCfniiUrDECl+sXpeXKHxmspkKpPHZtP/HMgOXSvjIQ3XO1erCnlWdhDyjXBCJkiFGXbw6K+FviriRmHkBf0Ukv1iqGSLDmF26GuHgvUe1G4LX0pBIEn3w59iTBeBitlRxzuro2YjUZDfW4H34H7vEE+twQbE1xBlZC0ji/zfzDjHFdFFlb
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A115B4529688AF46AD09DBCFBACE38C1@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2805.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd0ba4f-3e6f-4f3c-4f4d-08d81f0a332b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 04:33:14.0226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eudT2X+7FHU19L+H1TCJdEq7m9quPo5Hwox3nrdTDuQdUgcRZYqU+8zHOb00PT5jitHLemcnIDz7l4+C3I+vhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3751
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_18:2020-07-02,2020-07-02 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart,
    Thanks. Will send out a patch to address this issue shortly.

> On Jul 2, 2020, at 9:30 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 2020-06-30 03:22, Nilesh Javali wrote:
>> +	total_bytes =3D le16_to_cpu(purex->frame_size & 0x0FFF)
>> +	    - PURX_ELS_HEADER_SIZE;
>=20
> This assignment triggers two new sparse warnings:
>=20
> drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: restricted __le16 degrade=
s to integer
> drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: cast to restricted __le16
>=20
> Please fix these.
>=20
> Thanks,
>=20
> Bart.

