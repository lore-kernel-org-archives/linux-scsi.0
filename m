Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC22C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 13:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB9AE206F2
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 13:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GSQ3QpIJ";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="aSBY8Dk/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgC0Nhc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 09:37:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26382 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbgC0Nhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 09:37:32 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RDbJuR014006;
        Fri, 27 Mar 2020 06:37:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=yvnihTeqFSwAUk/5BVTFr94XOqjAZpkX//U3hhCRNWw=;
 b=GSQ3QpIJGe8C/ir2u2lOEv+UpM0qgaCD0qKKTM3DQrnBvAzItOUIziOdaoS+sqVPptAd
 qE92iJ7MDg4/zMEyOtNGHQE/nFT58SqEqsDaRKsvmLNh6RDknVolribNeObK+mYaPIgp
 qbzaQHyvlLLxiz3pCOEoplu7mPJt6YOXymWoxvrJA6v+VWmj3kJqil6zk91sFfyKEsTo
 dpKNqKLJYRCekjRZGRyLD9dvyZ4cvnZxc2YNR08INYTjPVAvK4oSHbKCbAosgeE5ATcS
 /aC9xqM8tnwRoGd6islFV2BvPRGCTLc2UVjbQ3ZtoWoWHwpFjyLc64XUyV5TZsfSyN+Y 8g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9p2ykw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Mar 2020 06:37:28 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 06:37:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 27 Mar 2020 06:37:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVOxEhN8gIW+pU6kD5OnewZTlGvYOLGVWnywsrHKIEW1MjmBvRPXKG+Kk5G/DmhMUW02y/vMJ3mq4HFRpjBgX9ae+F7iXd6fcl0IMJ0wAzMHxLmErHFU2F38NL/VHYqk1+8xtDZbIOc7DRs6j6/Mc/GNJYpeGK5372ZK3g6KyT0Dy90xTy9Mu8HUqCzmWBL9oBDslB6urnkb6cxcwfbaOqfyijMoeVL/cc7CF0/JfZmXBNbt++KZP17RuMwu72eE3vyif+4Euf3Z1FMx7HbVE7MQHtbRz8mhvBC/k0xhJFtQGLJ2XW8xybC3ggQt4RD376/aBvynGdQTBr4zf/8PAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvnihTeqFSwAUk/5BVTFr94XOqjAZpkX//U3hhCRNWw=;
 b=BTQxI9oS8jqQw9J7ev1krWlpAnMRnjmJ7H4T+lfohZnXp71AKasgWdo/WNmw4A1t8slkv5oy1AALGXZu8KM5JYICFcKTw5GzUA3QKntt+niK3denM5S5nEHBqB1R35E6Si5vb3yuKzkWcqCbD7+gwreksU+x+TuUKkcdCOmai13RsQIQjCrHMd2rXdY+DvMYd89SyCni3skTx0NFjcSwo6pKxQhlVTVTmcUiuolp+Zreph/0VmAlCpE+hzTUdcXp9DX8di0X3xRWo9C5uZ8bAJmwpmfusVrc4tSKEBeXBhUu7+zCtkZQZJ8XhbSndy/rv+PpG45q8Yw9VJ6d10weqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvnihTeqFSwAUk/5BVTFr94XOqjAZpkX//U3hhCRNWw=;
 b=aSBY8Dk/XpiakKDdTFkmM1/2nfq85ZzTwNancLl6O49ylExxM/kTpYBKiFcojM+3AKxOHMtgxN9+eXVsAk2n5HKsuhujsgkmCg2aJ19t98SoY/FMm/1SX3u6DzwPkb/g6hjrqPxEzySWPQV4kOsrLs9uKZBjE0qtUSgllTBVKHo=
Received: from CH2PR18MB3160.namprd18.prod.outlook.com (2603:10b6:610:24::30)
 by CH2PR18MB3192.namprd18.prod.outlook.com (2603:10b6:610:26::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Fri, 27 Mar
 2020 13:37:25 +0000
Received: from CH2PR18MB3160.namprd18.prod.outlook.com
 ([fe80::10e7:f4e9:face:3455]) by CH2PR18MB3160.namprd18.prod.outlook.com
 ([fe80::10e7:f4e9:face:3455%7]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 13:37:25 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "emilne@redhat.com" <emilne@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 0/3] qla2xxx: Updates for the driver
Thread-Topic: [PATCH 0/3] qla2xxx: Updates for the driver
Thread-Index: AQHWBCJUKaeR1aY6l0SPkQ/TUoN3A6hccKgw
Date:   Fri, 27 Mar 2020 13:37:24 +0000
Message-ID: <CH2PR18MB31606AF63FF4B58A81B3B11CAFCC0@CH2PR18MB3160.namprd18.prod.outlook.com>
References: <20200327102730.22351-1-njavali@marvell.com>
In-Reply-To: <20200327102730.22351-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bad359c-2720-42ab-60c6-08d7d253fc3c
x-ms-traffictypediagnostic: CH2PR18MB3192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3192400EC4B67B32D36E7192AFCC0@CH2PR18MB3192.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(4326008)(66946007)(9686003)(107886003)(5660300002)(55016002)(186003)(26005)(52536014)(33656002)(2906002)(86362001)(8936002)(7696005)(71200400001)(8676002)(110136005)(81166006)(6506007)(66476007)(66446008)(76116006)(53546011)(316002)(478600001)(15650500001)(54906003)(66556008)(81156014)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR18MB3192;H:CH2PR18MB3160.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cxMnLrRZq08J3cEe/WHE+Y8wjaapipsyJYu5Tv+MGymA85x1C2pnHX4GZZDV7Txk4e/YVf1KIgycEgVEgUmFq9a157ePKQ4cZoczM3WmESAXZINAA2ZLdRSA/xENLqAxzNJm/uzsXa7yxh/sHU5RIpflv17MNoSzqUuKjTP91cU8r/Yzbkxp8bO4lRNYd/a1te7bld7sL4HLzgISa8qW6VYy9b3GvBvMx7q0LEPtDxBhx5J0rGSu9Ol2BEtGD8EIO7UK4RUsuY2fT/epRfKR79SUdGbr+93FXyI52WOCI4e6G4BO4kte+G7y3CKqT5rkmKKp5MlmS7poQX6mew0Z6DFi0aB9XxAVwHIEJzALVBZH3u0vfkjZQkWUt6qerUx9CDHbm3tytmqcTDLzlN519DF73zL3M/cJzd1PJxVr6ZXecORwjwcZjzxfQBha4ubZ
x-ms-exchange-antispam-messagedata: yMPyDKu2nJ/vatiNDWjVmWGyecTncXqDWpsT7YACNtZumgxNGGFRZXIMkXAxIBJRqemzX56XjSE1MU/PX+oBDuIBBKvzXyyEFgT/qRuBsgbzdNj6+Aq6uSwLVnmkgmKNPAa38oGDlMnQLEBT47RrIQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bad359c-2720-42ab-60c6-08d7d253fc3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 13:37:25.0649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rQRVit3BKKuOf2pR+lb/5e85utLmEODy9OCPTDgpSNRTGcbywOc+QheoysdpMp7eXpIEmGDg2FQSKa7roQ/3hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3192
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_04:2020-03-27,2020-03-27 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The patch 1/3 looks incomplete. I will send the v2 version of the series.
Please ignore this series.

Thanks,
Nilesh

-----Original Message-----
From: Nilesh Javali <njavali@marvell.com>=20
Sent: Friday, March 27, 2020 3:57 PM
To: martin.petersen@oracle.com; emilne@redhat.com
Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Stora=
ge-Upstream@marvell.com>
Subject: [PATCH 0/3] qla2xxx: Updates for the driver

Hi Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your earliest
convenience.

Thanks,
Nilesh

Arun Easi (2):
  qla2xxx: Fix MPI failure AEN (8200) handling.
  qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV.

Quinn Tran (1):
  qla2xxx: delete all sessions before unregister local nvme port

 drivers/scsi/qla2xxx/qla_attr.c |  32 +++++++--
 drivers/scsi/qla2xxx/qla_def.h  |  13 +++-
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 +
 drivers/scsi/qla2xxx/qla_init.c |   2 +
 drivers/scsi/qla2xxx/qla_isr.c  |  54 ++++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |   2 +-
 drivers/scsi/qla2xxx/qla_os.c   |   6 ++
 drivers/scsi/qla2xxx/qla_tmpl.c | 118 ++++++++++++++++++++++++++------
 8 files changed, 187 insertions(+), 43 deletions(-)

--=20
2.19.0.rc0

