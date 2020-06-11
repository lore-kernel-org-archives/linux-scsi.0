Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207E0C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 17:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB87D20836
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 17:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="BrT7EtJZ";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="JSchxh/l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgFKRm0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 13:42:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3396 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727088AbgFKRmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 13:42:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05BHVfQ2011479;
        Thu, 11 Jun 2020 10:42:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=CJTnvWjXRBOSCAHRMrXGG6mpV9F0NIAJV0u1wLdRM7Y=;
 b=BrT7EtJZGvFGz9gzvg6jk7ZdPIm+VDlShPor4C+X+x/kh95Li4f97K++2mFdG1/jurjV
 Qc7kFdB1WHPcjlwOa8nUM7dT5OsyuRbtkPdOUSIF4CaVHWz0584bMOLaKtMdz7YI5ovU
 DZxYLKp4PjfZbXPvw82tpHcOEehL0aslN6wCqMymQWi2994W4n03B3IC8iopJcAO9LMt
 TeSgy+opUae7vjiGnoXvvH60fP4EeqshFiPZcel83mZ55tw+EFsEWSj2Siy4Gk8QWTNs
 CVgWsjrDBJCLjxaVa4ebReQN/snXvuYZlESfHCqCzOdd4u6uxwZucahx17qwBSygUDkN mQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 31j77dtyck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 10:42:22 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Jun
 2020 10:42:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Jun 2020 10:42:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ss/RUzzGl0cxgO00EfOeRRdvMqusuABuyj6ScbupvIw+9sZQ9KqLKOeWeSNLh50rnaARD62ZewiiMYsg7+fmdN3RlL/A6Wo0aVyi+Oxt59WrYiNN14ryj1fkxzSHDzpyoBgCCkpxani8uLrQmhvS/bciYeN7XLzyo8hhRIyZH6PtQqNke0oEld+O8AvyNLSV0JFWCZnOd3vhVXHpEMwZ7+GaDXdoTx0d9QWx7j5Kbd7l0Hc6pELrzws0dQppOL3SCQvVVoUucsib4RXMQOmaTJaq7IUdBMiC//HkJCELmsbcUcV4BqMIkp30IF33EnpTwi8A4FvlMzhP+MfYNWuB4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJTnvWjXRBOSCAHRMrXGG6mpV9F0NIAJV0u1wLdRM7Y=;
 b=jvgYYbA1itV2S/NeuKGS1m79484/yrlrq+ydmFX1n7PqZFwDqNOYMOThAOq5KEyKKrv79Gk1IAt/ebY24s11Exv6Z3qNMXm9WvSJTVesSegZQBLRzclrhKaX8TwrdLtNrpTEOK6YISq+tFVC/08zB7lXVddy03ijSOkSnRJb84yfbzLcXoLUMp7NfOT/BunmVUIqmY0c6lVCKC3O7Bc1cG5+ZscFDyqqn9qtLOUFhRn9Qi5TS9A1hn7p+P7reNuNg3QAXA8QNEEBKcL4gCyLYOzYjxZvxRYtmdO26AiOkeT1JG12bui+oQp+lsPCFbaPOJA07T2OrizyUf7+sZISUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJTnvWjXRBOSCAHRMrXGG6mpV9F0NIAJV0u1wLdRM7Y=;
 b=JSchxh/l4/MPpxtTb1HZn3KAI2FXaoofKWWfpRYOBEMWPut1491UcyoW9+Fh2oB8G/YBZm/+TJ7gcRcKI3uZ2bU2IVhZ2VQBDnHPLNgd6tKzPqRySqJQtWwSuaH8okx8ny9b0xiv253Za9OBO1+YyuV1IAPJM/ObHilouJ/81MI=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BY5PR18MB3202.namprd18.prod.outlook.com (2603:10b6:a03:1ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 17:42:19 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::7116:4e95:9e72:a48f]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::7116:4e95:9e72:a48f%3]) with mapi id 15.20.3066.023; Thu, 11 Jun 2020
 17:42:19 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     "james.smart@broadcom.com" <james.smart@broadcom.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [PATCH 2/3] qla2xxx: SAN congestion management(SCM)
 implementation.
Thread-Topic: [PATCH 2/3] qla2xxx: SAN congestion management(SCM)
 implementation.
Thread-Index: AQHWNepxgIiivm6IzE6bpoC1uckRgKjTw3gA
Date:   Thu, 11 Jun 2020 17:42:19 +0000
Message-ID: <351333B3-F666-420F-A9D3-DB86D2617156@marvell.com>
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-3-njavali@marvell.com>
 <927c2cbd-682f-a80e-bd2e-2e5bd012ab2d@broadcom.com>
 <CA+ihqdiA7AN05k5MjPG=o8_pf=L-La6UigY4t0emKgJMXm=hnQ@mail.gmail.com>
 <BYAPR18MB2805AEA357302FCFA20D2B57B48F0@BYAPR18MB2805.namprd18.prod.outlook.com>
In-Reply-To: <BYAPR18MB2805AEA357302FCFA20D2B57B48F0@BYAPR18MB2805.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:8052:efe1:2c2d:60e7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd11091d-2e12-4b51-d7eb-08d80e2eca21
x-ms-traffictypediagnostic: BY5PR18MB3202:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3202EA010A24FAFD5C6EF2ACB4800@BY5PR18MB3202.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XSrptMVm/oLv++9VsG/pVp7ktEE3e1nCEl4IoXcEV+g4MegAWZfCSRLq+IIpMXy2ChF6ymmvXWdlccoCIcJhM2OGZRm+fN8RqvbZ16KtNsmfbWXuJ7b18IIXiQPHLbnfB/MD1tSFTQEEca/o5uhGZrDMVzrDQnZivLdtUCDx8sqhl8XdC6S5Jivu+ho/SuFEfudkr4ITeN110ABj5aUHsD4Wlw762VFYK+NLlMXJs5I5CPhyuYZ6kRshZdVUk9fx4Ilb9z33ejLWVHIrUWZ4LjfvWikVzznGGI6WSRJOzA5N4CUbH+zIpnJqs6K+75f7wd9RbXsAbfuNgIyYVqaNVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(6506007)(5660300002)(83380400001)(66946007)(64756008)(30864003)(6512007)(53546011)(478600001)(86362001)(66556008)(2616005)(66446008)(6916009)(76116006)(4326008)(66476007)(107886003)(8936002)(54906003)(71200400001)(6486002)(36756003)(186003)(8676002)(2906002)(33656002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wY6X/I2PC4BlmnYv6tcT+qpGy9wzl3R+b5yBzq8oZLsOT+XQklGqRgvRZRFZmlL9l/Tl+03DdfVqQI7E00OOr49vcZi+uVF/jmfkl5NbAZDIdLhjnXGsMgPwyuAn/LmU5Uba0TBVmIR9sk6mrvbStctjL9EV42ADUb1InlZ3dY2//dzfikiwQz4mhYcWvu5AHmLPsasKbmD+Lm4tAZ2o/c3emSU83MR9nTWJfxFTKpPWBXWopfk9mnPmglwi2U6nSiMl2IU6js1mrqMxXcwLVMl0tzYEbJFixV7rqxFTwGfFmdRt9lr+e+SEpb1cPD2GSAXYTF6nsVtH4wQmJePnm9I/UsVFbqIpFfR42XXmpBXn/XvCmGXD7Su0RWwTx2qNrTIQidlFmwpzYYO7Zsktsz8+AgYo8ZUZrGsi0Xdu41GD+sn5MMmxOZeuhwUTuhU4vAUFQu4LI/nGENX63TsVzTtSDn+Btq91926OvBNbIaxX9dr6ewFM6prGMnZydzCApdhdE4VJlHnGFA63ZoHowRXF3heZj89fDZxFlvzKyl8PpDC7SPGIX/RFZv0Nw0NH
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8A781F9C09C520408F456D366E1D4AC9@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cd11091d-2e12-4b51-d7eb-08d80e2eca21
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 17:42:19.3816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IgsaoIb3Y4KbP3nAt5xPD3DcukrrVppQyQhAgRrM6bAfrFOc+BlsLG52yqTwFLIYrjKnApLssYyKwCLq9AXx4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3202
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-11_18:2020-06-11,2020-06-11 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seems like this (and a previous email) never made it to the reflector, rese=
nding.

The suggestions make sense to me, and I have made most of the recommended c=
hanges.
I was looking for some guidance on placements of the sim stats structures.

> On May 29, 2020, at 11:53 AM, Shyam Sundar <ssundar@marvell.com> wrote:
>=20
> James,
>      I was thinking of adding a structures for tracking the target FPIN s=
tats.
>=20
> struct fc_rport_statistics {
> uint32_t link_failure_count;
> uint32_t loss_of_sync_count;
> ....
> }
>=20
> under fc_rport:
>=20
> struct fc_rport {
>=20
> /* Private (Transport-managed) Attributes */
> struct fc_rport_statistics;
>=20
>      For host FPIN stats (essentially the alarm & warning), was not sure =
if I should add them to the fc_host_statistics or
> define a new structure under the Private Attributes section within the fc=
_host_attrs/fc_vport.
>=20
>      In theory, given that the host stats could be updated both via signa=
ls and FPIN, one could argue that it would make sense
> to maintain it with the current host statistics, but keeping it confined =
to transport will ensure we have a uniform way of handling
> congestion and peer congestion events. =20
>=20
>     Would appreciate your thoughts there.
>=20
> Thanks
> Shyam
>   =20
> ---------- Forwarded message ---------
> From: James Smart <james.smart@broadcom.com>
> Date: Fri, May 15, 2020 at 3:51 PM
> Subject: Re: [PATCH 2/3] qla2xxx: SAN congestion management(SCM) implemen=
tation.
> To: Nilesh Javali <njavali@marvell.com>, <martin.petersen@oracle.com>
> Cc: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com=
>
>=20
>=20
>=20
>=20
> On 5/14/2020 3:10 AM, Nilesh Javali wrote:
> > From: Shyam Sundar <ssundar@marvell.com>
> >
> > * Firmware Initialization with SCM enabled based on NVRAM setting and
> >    firmware support (About Firmware).
> > * Enable PUREX and add support for fabric performance impact
> >    notification(FPIN) handling.
> > * Support for the following FPIN descriptors:
> >       1. Link Integrity Notification.
> >       2. Delivery Notification.
> >       3. Peer Congestion Notification.
> >       4. Congestion Notification.
> > * Mark a device as slow when a Peer Congestion Notification is received=
.
> > * Allocate a default purex item for each vha, to handle memory
> >    allocation failures in ISR.
>=20
> In general, there's a lot of generic things here that are done in=20
> driver-specific manners.
>=20
> All the FPIN statistics should be added to the scsi fc transport objects=
=20
> and transport routines created to parse the fpin payloads and set=20
> statistics.  Also, statistics can be reported via sysfs on the transport=
=20
> object rather than creating vendor-specific bsg requests to obtain them.
>=20
> In line with this - FPIN definitions should use the existing the=20
> existing common headers in include/uapi/fc/fc_els.h.  The file doesn't=20
> have the congestion fpin definitions, so rather than putting in a driver=
=20
> header - put the structure definitions in the common header.
>=20
>=20
> >
> > Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> > Signed-off-by: Arun Easi <aeasi@marvell.com>
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> > ---
> >   drivers/scsi/qla2xxx/qla_bsg.h  | 115 +++++++
> >   drivers/scsi/qla2xxx/qla_dbg.c  |  13 +-
> >   drivers/scsi/qla2xxx/qla_def.h  |  89 ++++++
> >   drivers/scsi/qla2xxx/qla_fw.h   |   7 +-
> >   drivers/scsi/qla2xxx/qla_gbl.h  |   1 +
> >   drivers/scsi/qla2xxx/qla_init.c |   9 +-
> >   drivers/scsi/qla2xxx/qla_isr.c  | 532 ++++++++++++++++++++++++++++++-=
-
> >   drivers/scsi/qla2xxx/qla_mbx.c  |  45 ++-
> >   drivers/scsi/qla2xxx/qla_os.c   |  18 ++
> >   9 files changed, 795 insertions(+), 34 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_=
bsg.h
> > index 7594fad7b5b5..0b308859047c 100644
> > --- a/drivers/scsi/qla2xxx/qla_bsg.h
> > +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> > @@ -290,4 +290,119 @@ struct qla_active_regions {
> >       uint8_t reserved[32];
> >   } __packed;
> >  =20
> > +#define SCM_LINK_EVENT_UNKNOWN                       0x0
> > +#define SCM_LINK_EVENT_LINK_FAILURE                  0x1
> > +#define SCM_LINK_EVENT_LOSS_OF_SYNC                  0x2
> > +#define SCM_LINK_EVENT_LOSS_OF_SIGNAL                0x3
> > +#define SCM_LINK_EVENT_PRIMITIVE_SEQ_PROTOCOL_ERROR  0x4
> > +#define SCM_LINK_EVENT_INVALID_TX_WORD               0x5
> > +#define SCM_LINK_EVENT_INVALID_CRC                   0x6
> > +#define SCM_LINK_EVENT_DEVICE_SPECIFIC               0xF
> > +#define SCM_LINK_EVENT_V1_SIZE                       20
>=20
> These should be the existing defines in the common fc_els.h header. Also=
=20
> make sure SCM_LINK_EVENT_V1_SIZE is actually used.
>=20
> > +struct qla_scm_link_event {
> > +     uint64_t        timestamp;
> > +     uint16_t        event_type;
> > +     uint16_t        event_modifier;
> > +     uint32_t        event_threshold;
> > +     uint32_t        event_count;
> > +     uint8_t         reserved[12];
> > +} __packed;
> > +
> > +#define SCM_DELIVERY_REASON_UNKNOWN          0x0
> > +#define SCM_DELIVERY_REASON_TIMEOUT          0x1
> > +#define SCM_DELIVERY_REASON_UNABLE_TO_ROUTE  0x2
> > +#define SCM_DELIVERY_REASON_DEVICE_SPECIFIC  0xF
> > +struct qla_scm_delivery_event {
> > +     uint64_t        timestamp;
> > +     uint32_t        delivery_reason;
> > +     uint8_t         deliver_frame_hdr[24];
> > +     uint8_t         reserved[28];
> > +
> > +} __packed;
> > +
> > +#define SCM_CONGESTION_EVENT_CLEAR           0x0
> > +#define SCM_CONGESTION_EVENT_LOST_CREDIT     0x1
> > +#define SCM_CONGESTION_EVENT_CREDIT_STALL    0x2
> > +#define SCM_CONGESTION_EVENT_OVERSUBSCRIPTION        0x3
> > +#define SCM_CONGESTION_EVENT_DEVICE_SPECIFIC 0xF
> > +struct qla_scm_peer_congestion_event {
> > +     uint64_t        timestamp;
> > +     uint16_t        event_type;
> > +     uint16_t        event_modifier;
> > +     uint32_t        event_period;
> > +     uint8_t         reserved[16];
> > +} __packed;
> > +
> > +#define SCM_CONGESTION_SEVERITY_WARNING      0xF1
> > +#define SCM_CONGESTION_SEVERITY_ERROR        0xF7
> > +struct qla_scm_congestion_event {
> > +     uint64_t        timestamp;
> > +     uint16_t        event_type;
> > +     uint16_t        event_modifier;
> > +     uint32_t        event_period;
> > +     uint8_t         severity;
> > +     uint8_t         reserved[15];
> > +} __packed;
>=20
> I expect many of these defines also should map to std-defined defines,=20
> thus should be added to fc_els.h
>=20
>=20
> > +
> > +#define SCM_FLAG_RDF_REJECT          0x00
> > +#define SCM_FLAG_RDF_COMPLETED               0x01
> > +#define SCM_FLAG_BROCADE_CONNECTED   0x02
> > +#define SCM_FLAG_CISCO_CONNECTED     0x04
> > +
> > +#define SCM_STATE_CONGESTION 0x1
> > +#define SCM_STATE_DELIVERY           0x2
> > +#define SCM_STATE_LINK_INTEGRITY     0x4
> > +#define SCM_STATE_PEER_CONGESTION    0x8
> > +
> > +#define QLA_CON_PRIMITIVE_RECEIVED   0x1
> > +#define QLA_CONGESTION_ARB_WARNING   0x1
> > +#define QLA_CONGESTION_ARB_ALARM     0X2
> > +struct qla_scm_port {
> > +     uint32_t                        current_events;
> > +
> > +     struct qla_scm_link_event       link_integrity;
> > +     struct qla_scm_delivery_event   delivery;
> > +     struct qla_scm_congestion_event congestion;
> > +     uint64_t                        scm_congestion_alarm;
> > +     uint64_t                        scm_congestion_warning;
> > +     uint8_t                         scm_fabric_connection_flags;
> > +     uint8_t                         reserved[43];
> > +} __packed;
> > +
> > +struct qla_scm_target {
> > +     uint8_t         wwpn[8];
> > +     uint32_t        current_events;
> > +
> > +     struct qla_scm_link_event               link_integrity;
> > +     struct qla_scm_delivery_event           delivery;
> > +     struct qla_scm_peer_congestion_event    peer_congestion;
> > +
> > +     uint32_t        link_failure_count;
> > +     uint32_t        loss_of_sync_count;
> > +     uint32_t        loss_of_signals_count;
> > +     uint32_t        primitive_seq_protocol_err_count;
> > +     uint32_t        invalid_transmission_word_count;
> > +     uint32_t        invalid_crc_count;
> > +
> > +     uint32_t        delivery_failure_unknown;
> > +     uint32_t        delivery_timeout;
> > +     uint32_t        delivery_unable_to_route;
> > +     uint32_t        delivery_failure_device_specific;
> > +
> > +     uint32_t        peer_congestion_clear;
> > +     uint32_t        peer_congestion_lost_credit;
> > +     uint32_t        peer_congestion_credit_stall;
> > +     uint32_t        peer_congestion_oversubscription;
> > +     uint32_t        peer_congestion_device_specific;
> > +     uint32_t        link_unknown_event;
> > +     uint32_t        link_device_specific_event;
> > +     uint8_t         reserved[48];
> > +} __packed;
> > +
>=20
> Q: what purpose are these shorter "meta" event structures serving ? Why=20
> hold onto (what I assume is) the last event.  Wouldn't something=20
> monitoring netlink and use of the existing fc_host_fpin_rcv() interface=20
> be enough ? it should see all events.
>=20
>=20
> >  =20
> > +#define SCM_EDC_ACC_RECEIVED         BIT_6
> > +#define SCM_RDF_ACC_RECEIVED         BIT_7
> > +#define SCM_NOTIFICATION_TYPE_LINK_INTEGRITY 0x00020001
> > +#define SCM_NOTIFICATION_TYPE_DELIVERY               0x00020002
> > +#define SCM_NOTIFICATION_TYPE_PEER_CONGESTION        0x00020003
> > +#define SCM_NOTIFICATION_TYPE_CONGESTION     0x00020004
> > +#define FPIN_DESCRIPTOR_HEADER_SIZE  4
> > +#define FPIN_ELS_DESCRIPTOR_LIST_OFFSET      8
> > +struct fpin_descriptor {
> > +     __be32 descriptor_tag;
> > +     __be32 descriptor_length;
> > +     union {
> > +             uint8_t common_detecting_port_name[WWN_SIZE];
> > +             struct {
> > +                     uint8_t detecting_port_name[WWN_SIZE];
> > +                     uint8_t attached_port_name[WWN_SIZE];
> > +                     __be16 event_type;
> > +                     __be16 event_modifier;
> > +                     __be32 event_threshold;
> > +                     __be32 event_count;
> > +                     __be32 port_name_count;
> > +                     uint8_t port_name_list[1][WWN_SIZE];
> > +             } link_integrity;
> > +             struct {
> > +                     uint8_t detecting_port_name[WWN_SIZE];
> > +                     uint8_t attached_port_name[WWN_SIZE];
> > +                     __be32 delivery_reason_code;
> > +             } delivery;
> > +             struct {
> > +                     uint8_t detecting_port_name[WWN_SIZE];
> > +                     uint8_t attached_port_name[WWN_SIZE];
> > +                     __be16 event_type;
> > +                     __be16 event_modifier;
> > +                     __be32 event_period;
> > +                     __be32 port_name_count;
> > +                     uint8_t port_name_list[1][WWN_SIZE];
> > +             } peer_congestion;
> > +             struct {
> > +                     __be16 event_type;
> > +                     __be16 event_modifier;
> > +                     __be32 event_period;
> > +                     uint8_t severity;
> > +                     uint8_t reserved[3];
> > +             } congestion;
> > +     };
> > +};
>=20
> The fpin descriptor is already in the common fc_els.h header. Use it. =20
> And feel free to extend the common header definitions for the=20
> congestion/delivery events.
>=20
>=20
> >  =20
> > +void
> > +qla_link_integrity_tgt_stats_update(struct fpin_descriptor *fpin_desc,
> > +                                 fc_port_t *fcport)
> > +{
> > +     ql_log(ql_log_info, fcport->vha, 0x502d,
> > +            "Link Integrity Event Type %d for Port %8phN\n",
> > +            be16_to_cpu(fpin_desc->link_integrity.event_type),
> > +            fcport->port_name);
> > +
> > +     fcport->scm_stats.link_integrity.event_type =3D
> > +         be16_to_cpu(fpin_desc->link_integrity.event_type);
> > +     fcport->scm_stats.link_integrity.event_modifier =3D
> > +         be16_to_cpu(fpin_desc->link_integrity.event_modifier);
> > +     fcport->scm_stats.link_integrity.event_threshold =3D
> > +         be32_to_cpu(fpin_desc->link_integrity.event_threshold);
> > +     fcport->scm_stats.link_integrity.event_count =3D
> > +         be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +     fcport->scm_stats.link_integrity.timestamp =3D ktime_get_real_sec=
onds();
> > +
> > +     fcport->scm_stats.current_events |=3D SCM_STATE_LINK_INTEGRITY;
> > +     switch (be16_to_cpu(fpin_desc->link_integrity.event_type)) {
> > +     case SCM_LINK_EVENT_UNKNOWN:
> > +             fcport->scm_stats.link_unknown_event +=3D
> > +                 be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +             break;
> > +     case SCM_LINK_EVENT_LINK_FAILURE:
> > +             fcport->scm_stats.link_failure_count +=3D
> > +                 be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +             break;
> > +     case SCM_LINK_EVENT_LOSS_OF_SYNC:
> > +             fcport->scm_stats.loss_of_sync_count +=3D
> > +                 be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +             break;
> > +     case SCM_LINK_EVENT_LOSS_OF_SIGNAL:
> > +             fcport->scm_stats.loss_of_signals_count +=3D
> > +                 be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +             break;
> > +     case SCM_LINK_EVENT_PRIMITIVE_SEQ_PROTOCOL_ERROR:
> > +             fcport->scm_stats.primitive_seq_protocol_err_count +=3D
> > +                 be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +             break;
> > +     case SCM_LINK_EVENT_INVALID_TX_WORD:
> > +             fcport->scm_stats.invalid_transmission_word_count +=3D
> > +                 be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +             break;
> > +     case SCM_LINK_EVENT_INVALID_CRC:
> > +             fcport->scm_stats.invalid_crc_count +=3D
> > +                 be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +             break;
> > +     case SCM_LINK_EVENT_DEVICE_SPECIFIC:
> > +             fcport->scm_stats.link_device_specific_event +=3D
> > +                 be32_to_cpu(fpin_desc->link_integrity.event_count);
> > +             break;
> > +     }
> > +}
> > +
>=20
> A prime example of a routine that should be put into the fc transport=20
> and a list of statistics that should be visible via sysfs on the=20
> transport host (aka port) object.
>=20
>=20
> > +void
> > +qla_scm_process_link_integrity_d(struct scsi_qla_host *vha,
> > +                              struct fpin_descriptor *fpin_desc)
> > +{
> > ...
> > +}
> > +
> > +void
> > +qla_delivery_tgt_stats_update(struct fpin_descriptor *fpin_desc,
> > +                           fc_port_t *fcport)
> > +{
> > ...
> > +}
> > +
> > +/*
> > + * Process Delivery Notification Descriptor
> > + */
> > +void
> > +qla_scm_process_delivery_notification_d(struct scsi_qla_host *vha,
> > +                                     struct fpin_descriptor *fpin_desc=
)
> > +{
> > ...
> > +}
> > +
> > ...
> > +
> > +void
> > +qla_peer_congestion_tgt_stats_update(struct fpin_descriptor *fpin_desc=
,
> > +                                  fc_port_t *fcport)
> > +{
> > ...
> > +}
> > +
> > +/*
> > + * Process Peer-Congestion Notification Descriptor
> > + */
> > +void
> > +qla_scm_process_peer_congestion_notification_d(struct scsi_qla_host *v=
ha,
> > +                                     struct fpin_descriptor *fpin_desc=
)
> > +{
> > ...
> > +}
> > +
> > +/*
> > + * qla_scm_process_congestion_notification_d() - Process
> > + * Process Congestion Notification Descriptor
> > + * @rsp: response queue
> > + * @pkt: Entry pointer
> > + */
> > +void
> > +qla_scm_process_congestion_notification_d(struct scsi_qla_host *vha,
> > +                                       struct fpin_descriptor *fpin_de=
sc)
> > ...
> > +}
>=20
> Same comment as prior - should be in scsi fc transport routines and=20
> stats set on appropriate transport object
>=20
> -- james

