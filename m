Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FE3C43461
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 10:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A9AD2168B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 10:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bkatyXE0";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Zw/JlOX5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgIGKoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 06:44:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2686 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728580AbgIGKoR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 06:44:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087AewCG002489
        for <linux-scsi@vger.kernel.org>; Mon, 7 Sep 2020 03:44:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=1UzDWS2ftuPNK4Veu4eddHRDlJR0eMhJZ/cgWBmuYss=;
 b=bkatyXE0pDaH2ysCLImT8Zr+ILXrbbdvq1SkQiX5c8AoTOthEumQpJDJ/Ua1u8o1T4Cm
 l6CuXljhWwqo5Wf2ye002B6mhnX8ChQlbAZZD8ncDGhLTfO/uhkQ7fwr6ZtYNdLprvum
 xwJiPK6PcmePVe/1EyFIxfAbM+0mowhDkG8XoqOs46a+7Ipq3btjjYN/PhPEOZjdq9q9
 SKBG9UJY/rfyPfVKdXCRYbVvyqwGVSLfToguui5QQB5ZdLmtHNgTiMMBAk1XSVkUP3vF
 cOyC6I1ojApBTxUrey4aLlRpUzUkGH63m1eYH/wiYxPrcVe/zMqZY3zhMiFRE24hrSSN tA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pqmex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 03:44:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 03:44:09 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 03:44:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 7 Sep 2020 03:44:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXRoZh10+pnjvVJpdKtjVrQVUnmZ+MfClsueeb51yMzI1Lm6qZZc5/cDl6b3cAvg35X0cPEsGTuKX2FAnNcAnOuTyD7HIkTiEiZOwX3xZjTgteYI9zzD8TAtCBQzvLUCXgmOVkOqJfmwKBYVB50Zp5RiyS9l93ZcxW3SD/pE6rkbppbu0YJJgeM5r/oSB1QAxLcIVCKN40c/1oq8Xg8tjs909Kiyv0O0YkG/F4gsYRDkAXJzgf567T3zxtO03a6eUPM7DYamxxvi5qHlEqLSzIbNXZXKdzq50MWvKAuXt/hVxxqoa8LLpcyobSqxyB3hN1Tu1hPzmUXci9gkxF5m5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UzDWS2ftuPNK4Veu4eddHRDlJR0eMhJZ/cgWBmuYss=;
 b=lPuynOLwXqiYgUBPCGuOazqsvNQMu6pynUeYUt9sRxEmCqk5m4LNT/ywFoWE4DiT7Fy/BCVx63T/dNrIN+sEWaBZLIx+biX38qb0S9pNyOa2/6fn/pw9fNc1oesyx5onA1TT3W5lew8QavkFwB/38aHq8xv90GUs7tldQDLzmWOVLcZZ43lB59nW070F+FD+M8jDTAcRA5uv+2A3xTHi/FeaNUdvuMZ5nLOoxNyTK3HTDPYaUbGz+YU5OltsR+haWAImbv2xf3mPR3tcJUkEFWEwGpNNjvOXedwubsGaxaQIcwIuysEYyVV05sfvM4lZ0jQleq1wskj712vhoJ3L8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UzDWS2ftuPNK4Veu4eddHRDlJR0eMhJZ/cgWBmuYss=;
 b=Zw/JlOX5TlCjfqxMMea+vBK2UbSAvhADFW4uR8RvGlBRvqInm7l5yLeN+hkbnqtoVch1DkTmECqbgoJ8DIBO8+RyZ5IGiRJTB1Hp5t+OIedB6rUQhAQzfrIH+75iigFM/SHjNKjcVW7atKMLUmUtRwdJa81BugDUBDkY8k+5cFo=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM6PR18MB3403.namprd18.prod.outlook.com (2603:10b6:5:1cc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 10:44:05 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::905a:ebb4:369c:ae1b]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::905a:ebb4:369c:ae1b%7]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:44:05 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 0/2] SAN Congestion Management (SCM) statistics
Thread-Topic: [PATCH 0/2] SAN Congestion Management (SCM) statistics
Thread-Index: AQHWZjhMrgcFZD1E10agzucUNAA04KldOfTg
Date:   Mon, 7 Sep 2020 10:44:05 +0000
Message-ID: <DM6PR18MB3052C2991B834B3A93D96E69AF280@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200730061116.20111-1-njavali@marvell.com>
In-Reply-To: <20200730061116.20111-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.90.36.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9ee38fb-160f-489c-5c1a-08d8531af18d
x-ms-traffictypediagnostic: DM6PR18MB3403:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3403001226D545D801AEC4A4AF280@DM6PR18MB3403.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:514;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q4o9eCeg7kZgF6dv3mchisMUTB0gwC3nyUoju5rVNx+RBScltlfCSXEngu/YPAm/c3eZbBLIy+m52dftiOBJ8Q36jLQoAASy/qzAlTxO4jiKMFgceVfG3ev+Ms8L4gKGYXvZYLE/eC8szJOwu1kbIGH88Z7lOT8skh+e4a2S5cxZsvVvR42weH7REn0CtEJYIJFfUlVFBfaywQbs0udgVzi1+ZFtPUZQYwB7B54qsn4ppyEMPFcSwRdQTytffzzHXbH11Bc2n9Q/yXH3XhwQbNIVUWQdOUUVXzWzeCpxCyDazqd+a1LxifIy1fC1nGBB0FZt4sxUu44/EO++LKQfQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(6506007)(53546011)(316002)(186003)(26005)(2906002)(55016002)(54906003)(8676002)(6916009)(9686003)(4326008)(107886003)(8936002)(7696005)(33656002)(66446008)(52536014)(71200400001)(83380400001)(86362001)(66556008)(5660300002)(66946007)(478600001)(64756008)(66476007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: kpkvcOZ7xxENbnoFugLiK/j41gr41Fyue9yKeubek4IONmq+oVIYHsF1jG1h79EEOInw+euOcSI+5JRrbrtPrIa/UZzhZF7Fgp+8qX2ne8PEyVkoCK+XSLzX6rTAx0ERJWOACURvij4HSqkRmU+c8Z8pW9qrcpTj176Uwfcy25w2Ie7TCHbt70WhM9qm4N//wU5FiAXbkPpbr8spfRAyJny5qOzO3hZXh6LmTOxsZ4m6T8jBjxA7WOMBqWydWH/RFTqCOcP08Ha9+TcfNY3oRLea4PD4+95nI7WoZjuo1gW9GT3dl32ZVfhOXmimlW9Ckult5AqnI/GMAKr5dKXR9zlNvdiRTR7mTRVBSFcb61B4SQQwMjdibZ1EZiS2GdtIgKGfmQK0AvkMr2J4fEzLE3WM6f5KvqeJpg+AQDuyqSoqDFDHd7+oyhMahbFBl1V+uNcWMw953Q1X8Z++hGbOoq0VUf7MIvD9O+14nJzRirzqc9JgKfkAV8HSDgIXL+U1kdGpVt1y34d9TK2ccxAfdFuU1cw7MQ0HWlQ3kk4zbHCKgIVkiQvVudMmUuchvhkJHLre7qN2mP1gOpIAJk5OZ8PlJ/gkqY67e1RwIg2VNTvqNe0vK+8qFqfPaSun26YRqHmkcSAO5TdJBcYy8edCJw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ee38fb-160f-489c-5c1a-08d8531af18d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2020 10:44:05.8454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +nqV5817HLfbfaF9+wwGiUJRU8T3/pr6J5uJ3U72JNshDV8VR0iMMu5fXLwEkFsZJe++/bgDI4FBEt2l42cNlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3403
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_04:2020-09-07,2020-09-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A gentle reminder to review this patch set.

Thanks,
Nilesh

> -----Original Message-----
> From: Nilesh Javali <njavali@marvell.com>
> Sent: Thursday, July 30, 2020 11:41 AM
> To: martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>
> Subject: [PATCH 0/2] SAN Congestion Management (SCM) statistics
>=20
> Martin,
>=20
> Please apply the attached patchset implementing the SAN Congestion
> Management (SCM) statistics to the scsi tree at your earliest convenience=
.
>=20
> Thanks,
> Nilesh
>=20
> Shyam Sundar (2):
>   scsi: fc: Update statistics for host and rport on FPIN reception.
>   scsi: fc: Update documentation of sysfs nodes for FPIN stats
>=20
>  Documentation/ABI/testing/sysfs-class-fc_host |  23 +
>  .../ABI/testing/sysfs-class-fc_remote_ports   |  23 +
>  drivers/scsi/lpfc/lpfc_attr.c                 |   2 +
>  drivers/scsi/qla2xxx/qla_attr.c               |   2 +
>  drivers/scsi/scsi_transport_fc.c              | 411 +++++++++++++++++-
>  include/scsi/scsi_transport_fc.h              |  34 +-
>  include/uapi/scsi/fc/fc_els.h                 | 114 +++++
>  7 files changed, 606 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
>  create mode 100644 Documentation/ABI/testing/sysfs-class-
> fc_remote_ports
>=20
>=20
> base-commit: 3c330f187ea84b13a0c66311115c8fd449dd25a1
> --
> 2.19.0.rc0

