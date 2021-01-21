Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9421AC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 17:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7ED22A83
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 17:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbhAURfG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 12:35:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49388 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388311AbhAUREv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 12:04:51 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10LGilEX019508
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jan 2021 09:03:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Hwc9ecwydPfa7lf4K4MepFITxRoBZ6b9qvMbDwQ+fpM=;
 b=O7/Pf6ROJP0j4VaLh9tBHlkHoFx6pVaqC1e9GrUGE4a/1y+UGn2YvXG0KsgUmWPfRCU3
 c10Gsmh/BGFUgQqbMgNnf/LjIieqBdTDcC74UJmWOEwpnuKDX1cb713s6Ewno79CawRa
 /VWokskHuVForR7K0D/hphGnkRx8MaU7U/euaVNdajFGmNqVCTfpcpWwjREhNQ1IeJO3
 4FHWuUHlDmbb5GmZwUtJ5fBpDYHRMgMFyCFL6k+xSrz/mGc0Z2ZmC5D5PqBXTIa6NF0I
 OW9d43kY8D8G5HmAavyrC/qDYfY6PRHFwj/zYZw/cYCmo5jakRq2vw46wX/KNOq68Qo5 gw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3668p7pw72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jan 2021 09:03:37 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 21 Jan
 2021 09:03:35 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 21 Jan
 2021 09:03:34 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 21 Jan 2021 09:03:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTqm06YlPiu27uKB5IA7htKnu1KgCN0Ewz1gpMOQpPPf7K7KsngTP9278fXX9zgFKtpJV8YdlTMC8Kb+iXe35LBLvn6GNL7Smnzj7pfNz+2y9+M2+rLvcnaBgci39I2/ky9vbBHGShUcWYV5FSwwBwaZfK4FagRdPrxaoccGi5W7N+RgOkYR+qUQZGIB1BZ1opVTaNOhJ6vQc1/F/Zi4VsBmXEvUo+tkIGOd7VL/uWzFZFK4ss2/pkCU9QgmYH1MJskDOw24qGKvfFLxAGCEludFZC1GEFFlD2qShI/SfWHcRpOL32oTAkcPGJ6sZGkQpHbbVjTOwgMtaCD/AAXcag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hwc9ecwydPfa7lf4K4MepFITxRoBZ6b9qvMbDwQ+fpM=;
 b=i3ZT/KJdGFRPpZwxO3oIPmiNc9VYImcpnYo1vsw6rmxQicF5pas8YBLg9fZC8usGdWUYapamgZTzd5zZGuF68HRFp1A9J+JMhIMWsFp2R0DXsVzBglvNSYeLTndtkdnZRpJ/vN3Z0SNYC0xA/JR9lY9zfCurAjmLRLdIbLtNLIVqHgd4fxFjbo5QxtNnLF/fzLNNtKnHyQ9A1y2WWhYlcpKOIUXGiPYdN6U+Hhw+LjfWOVPmiHr+lzrpl6Uf3uWblqAeWl1vUYgLFO7poprlGxsEp0MuEkgWeDe5hXxVKroUPX3/lnIDh6Rk5nm8gKUUEEc9WWs73vGWwdYQo+GMIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hwc9ecwydPfa7lf4K4MepFITxRoBZ6b9qvMbDwQ+fpM=;
 b=CNUyaok+bDE1WIr2l538dAXRjjgEwtHK1pxaSUVZZazdIHNgTjHjUdbRhZVheU47zXtgUTGRudHbp63q4jQCAPmeijhuXRGqe7UAXqj6DLhAwFhcrRCGMwljb4sJTowvcZE0ZoQ79u2rl0gZsMJ7Oe7JyjQf7ZqurLhATRU3/mM=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (2603:10b6:a03:10b::24)
 by BYAPR18MB3048.namprd18.prod.outlook.com (2603:10b6:a03:102::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 21 Jan
 2021 17:03:31 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::ccbc:ab3c:f576:10c9]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::ccbc:ab3c:f576:10c9%7]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 17:03:31 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [bug report] scsi: qla2xxx: Fix SRB leak on switch command
 timeout
Thread-Topic: [EXT] [bug report] scsi: qla2xxx: Fix SRB leak on switch command
 timeout
Thread-Index: AQHW7xtkpyHBsV0wo0qfUAh8mul3SqoyUC6A
Date:   Thu, 21 Jan 2021 17:03:31 +0000
Message-ID: <BYAPR18MB2759487EB5EC44983F826BE0D5A19@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <YAgMqa2/7ugeBKVW@mwanda>
In-Reply-To: <YAgMqa2/7ugeBKVW@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [98.164.229.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9907d317-4549-4809-ecd7-08d8be2e7b16
x-ms-traffictypediagnostic: BYAPR18MB3048:
x-microsoft-antispam-prvs: <BYAPR18MB30484FACAA749DD8B5BDEC31D5A11@BYAPR18MB3048.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9VV2heRCUeV1r+CN+jdG/fk3I0qkQIY42AA88+8itW4SeMyV25hrxLyvzT8fuu6yBcuT76L16xrhAa8rbKSrUQufw+Xpg8P6CweOXa1bCMf6HImI3hUJQ3HT4cqHhETQ07WTd0Xi0J6XhNUimyMY3KBV3u5VHClYO0415Gu450j46uNZmne79UxRbxMSlL5SmQffCdd5hfDVf6iEweMLPBtZG+0j+XumaHVTdE1Jrg1xtrsVMzcpK8tGT0OscKIL9uCh7FoiRiit1YvMQr4qYIKNIdBfmZtjYUZ0nwkPrPnVOlZBzdbS0utBlFwGDY6xeljfjs62G1KlAA/K4N2byx21SevnRI2JwfnOt3rVhdMYTQDqVdAbLhk4x79G8CTlUZTDeuUfED0uS2XiWKGOPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2759.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(8936002)(66446008)(52536014)(83380400001)(66946007)(2906002)(5660300002)(71200400001)(6916009)(26005)(66476007)(76116006)(6506007)(66556008)(33656002)(9686003)(478600001)(4326008)(86362001)(8676002)(7696005)(64756008)(186003)(53546011)(55016002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cKVvwbzuHCLG/syD9b2aIxx8aaYluTHR2j0cGl9b9rkTlgZp1rqAe5K4DqOI?=
 =?us-ascii?Q?ntxFqmeA+0htCdImcRLLyeXS0ZWTf61BwGdo3a4L335NMADd16dDxTUQSYbR?=
 =?us-ascii?Q?ioeDxsiS6oHPBLV0b7gu7tjcKR9DqPBt1aan1TRbfiovXuYEpTYfJ4BBVe+c?=
 =?us-ascii?Q?EL4L4lIL/zu9a4ez0CBQVLnF4nwIbvVLO05HrlTjzrPMsLv7TlgvdDL1hkft?=
 =?us-ascii?Q?PrZsGSr+tm7GAJfXTnBXpsqgojN8Q4kxHGzo+2q7/IqAV71vDw5DL74aWhrv?=
 =?us-ascii?Q?AhRcIyswfrYUMQDDhATW/jCV7yOCiqq87Dz0GYvQJioapyJx/gE6uTsUn/hS?=
 =?us-ascii?Q?iOh3abDgfWQMrlaWS2AIBKXyUKJl2KQBC/hkew3Qaz73tJeR879bQI8qOEqK?=
 =?us-ascii?Q?pmlqeu4oMq0/ayMcxjjByc5a3y3itylQW2H4yTu6cO5JEOdyJauFLuYlVohJ?=
 =?us-ascii?Q?FGC2V0EdoRVD4bu+VkL8HY+w09R1O2LwnIJ7768lXADUPqCOPf6zBey0QFvb?=
 =?us-ascii?Q?sCT8lQfb4I3kXOxh24QOjmhnkH0rqHHES55oIv6FQxMPok3r3ajWqyw/HG3k?=
 =?us-ascii?Q?2PjkJYJAuXLGmroxF79tHyXea84redhLWHL3qvTpdtSKXyIjnquwCfjNWlif?=
 =?us-ascii?Q?lqxsBd+x8fYoJ+AE+ECyA8VnFJGJbH43DpX6zDoSx3P6IIEl1sYnYLhVDtBy?=
 =?us-ascii?Q?y9VLUsstBG0AsZBWMZxfIWtJP2V9iSVWMZ2zq0oXL0NS97DuZNwr5YnV4xqc?=
 =?us-ascii?Q?lpHKs72DRxnopB/BNFFv6V7UB1QSpjIRyp6taq6TatV1m81y8IdphRyWoM+P?=
 =?us-ascii?Q?DTtNkP2WcmEjZasNbP5CCMqA61komAQ6wsDklMaTF2tbFiy/QHNEC2W6ggzh?=
 =?us-ascii?Q?9qE1XoJ2hxLa1u+vWYETwfaJXOenlAQ3efXBadwVGDqs2qyGxeelC0wPhzxW?=
 =?us-ascii?Q?j5E+j1K6vOiKIYUG71bbT3Ed25GLfdNPG1xHdhen6iE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2759.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9907d317-4549-4809-ecd7-08d8be2e7b16
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 17:03:31.3919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rYFIzNTCfeqCDic62W2VYBnDRSiDfUeK9R03MRQ9GYBfXm0l1O8fn8ryjlcPODlIZNqSkP4Msq9R3SkCrUK5lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3048
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_09:2021-01-21,2021-01-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dan, =20

Thanks for notification.  Will take a look.


Regards,
Quinn Tran

-----Original Message-----
From: Dan Carpenter <dan.carpenter@oracle.com>=20
Sent: Wednesday, January 20, 2021 2:58 AM
To: Quinn Tran <qutran@marvell.com>
Cc: linux-scsi@vger.kernel.org
Subject: [EXT] [bug report] scsi: qla2xxx: Fix SRB leak on switch command t=
imeout

External Email

----------------------------------------------------------------------
Hello Quinn Tran,

The patch af2a0c51b120: "scsi: qla2xxx: Fix SRB leak on switch command time=
out" from Nov 5, 2019, leads to the following static checker warning:

	drivers/scsi/qla2xxx/qla_os.c:1032 qla2xxx_mqueuecommand()
	error: dereferencing freed memory 'sp'

drivers/scsi/qla2xxx/qla_os.c
  1020 =20
  1021          return 0;
  1022
  1023  qc24_host_busy_free_sp:
  1024          sp->free(sp);
  1025
  1026  qc24_target_busy:
  1027          return SCSI_MLQUEUE_TARGET_BUSY;
  1028
  1029  qc24_free_sp_fail_command:
  1030          sp->free(sp);
  1031          CMD_SP(cmd) =3D NULL;
  1032          qla2xxx_rel_qpair_sp(sp->qpair, sp);

This seems like potentially a false positive but the code is weird.
In this case we know that ->free is qla2xxx_qpair_sp_free_dma().

Smatch isn't making that connection and it complains that half the free fun=
ctions call qla2xxx_rel_qpair_sp() and half don't.  These three free "sp"

qla2x00_sp_free()
qla2x00_els_dcmd_sp_free()
qla2x00_bsg_sp_free()

The free functions which don't free "sp" are:

qla2x00_sp_free_dma()
qla2xxx_qpair_sp_free_dma()
qla2xxx_rel_free_warning()

  1033
  1034  qc24_fail_command:
  1035          cmd->scsi_done(cmd);
  1036 =20
  1037          return 0;
  1038  }

regards,
dan carpenter
