Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BEAC4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 22:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 428892075F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 22:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="auvLQ6N6";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="OFRmF0pC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731520AbgI3WZT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:25:19 -0400
Received: from alln-iport-1.cisco.com ([173.37.142.88]:40523 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731067AbgI3WZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2020 18:25:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2135; q=dns/txt; s=iport;
  t=1601504706; x=1602714306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=55IUn+Bu5UrLKgLKxa5UNgZhgYCW4CMWY9jXFdvvP1s=;
  b=auvLQ6N6/p4sMLJS1UOzi72RBXOop6hjYoUy50KPbOHdrw+jG4yWzrNa
   UJPftGrvPZIKi5ANR7PESGy5dGTeSXk6+4LGwS1d+B8bQ962Mffj75jj1
   AxiZ2t7h9mZ7eBE4UBxK34pr6HewPrMlopiD6oN8J9Ytq9Fluk/P145de
   Y=;
IronPort-PHdr: =?us-ascii?q?9a23=3AkmN/WRXFPTbTuhtz4ePWbcABvUXV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSBNyFufJZgvXbsubrXmlTqZqCsXVXdptKWl?=
 =?us-ascii?q?dFjMgNhAUvDYaDDlGzN//laSE2XaEgHF9o9n22Kw5ZTcD5YVCBomC78jMTXB?=
 =?us-ascii?q?74MFk9KuH8AIWHicOx2qi78IHSZAMdgj27bPtyIRy6oB+XuNMRhN5pK706zV?=
 =?us-ascii?q?3CpX4bdg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CgDgBeBXVf/40NJK1ggQmBUYFQUQe?=
 =?us-ascii?q?BSS8siAMDjX+Yd4JTA1ULAQEBDQEBLQIEAQGESwKCMQIlOQUNAgMBAQsBAQU?=
 =?us-ascii?q?BAQECAQYEbYVcDIVyAQEBBBIVEwYBATcBCwQCAQgRBAEBHxAyHQgCBAENBQg?=
 =?us-ascii?q?ahVADLgGqdAKBOYhhdIEBM4MBAQEFhQcYghAJgTiCcoo8G4IAgVSCHy4+hD+?=
 =?us-ascii?q?DSIItt0cKgmeaeoMOjzqOTS2SXaAOAgQCBAUCDgEBBYFsIoFXcBWDJFAXAg2?=
 =?us-ascii?q?OVoM6ilZ0NwIGCgEBAwl8jgsBAQ?=
X-IronPort-AV: E=Sophos;i="5.77,322,1596499200"; 
   d="scan'208";a="551078211"
Received: from alln-core-8.cisco.com ([173.36.13.141])
  by alln-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 30 Sep 2020 22:25:05 +0000
Received: from XCH-RCD-002.cisco.com (xch-rcd-002.cisco.com [173.37.102.12])
        by alln-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 08UMP5Hl009687
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 30 Sep 2020 22:25:05 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-RCD-002.cisco.com
 (173.37.102.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 17:25:04 -0500
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 17:25:03 -0500
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 30 Sep 2020 17:25:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5fCV7gLKc65344pIG8NnP3rbcs0QBKcJupZI+h3FTnuOLDFw0+ctVHK9W4TmLHutrbTUboYzI92VeEbaENyjSLZgSsnvl2f4dEhthRGD+hYPO+VWhmtWt/BiCBlM0RzDAdwnsVuu4dR6NeBa2tmOpa3v4ZOPMShhHRymYoZOSDZF19KH5LOWatxmLXtHL81sXzNAqanRXjUUZaWaMOJ63qMQ2xk3+uhXkRlo3wuLoR//kM7fDGA8O6qY542kbaO0RiXUM11cae+o5tZYgrt3F0sMN9ttQiBQFPXMYNRU6mzGN7DFnfEqdqi1hW0byERs+fctqm3BXVIxOlStxuU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsEoeeS1c0LBhW3cCFzdJhVa2r2z85vx0Es5Bg8cV5Y=;
 b=G+G6iGXxcmpYyOuXLcauN61TfkH2pBt8IKHOe90J5dbRQ0TvtvNUR5TnOiFtmLvOQ2Y+oC4OAm3J2/vaFbmP2CHOj1H2BZqQU4o1V7XzeRvnoMt42CVBiQlPNdHogz1DZYYFaJHK1WgNoVmP863ywh4WWuNCe27Ciq/bZiFtX6XNzLSUqePkjEi/ysVBk9N3ikeLN9oiyLDg+WYKjY2+nO30JHLUKjI8OClKo47i24ugUP3IwOcRz3W5ya3eGzuo40ZavvWMksmccOuSYZ6shHecIVZ15ksZgAuhHj1dox0tWIlyI4ziTOxnOM5pZ4XhpNAZqbI3EqPtwLoPph3jBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsEoeeS1c0LBhW3cCFzdJhVa2r2z85vx0Es5Bg8cV5Y=;
 b=OFRmF0pCgSOPj6j9L5YTYGf4lXrGC7hGbwfU0CgNhDVc83ckjkKfS6rhP4dE4Hh7vIVocwjD6khhCwMqZ5P4uFihKoFupaoKMM18ZBgy69lr1RkdfI6jryGfXwvQgCGZ/5PlebhA/TximU9KLo+Qce8Kl8inBJ/2Ebo2a0ZdP5o=
Received: from BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28)
 by BYAPR11MB2709.namprd11.prod.outlook.com (2603:10b6:a02:be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 30 Sep
 2020 22:25:02 +0000
Received: from BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::6cf2:4989:a3a6:7f95]) by BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::6cf2:4989:a3a6:7f95%7]) with mapi id 15.20.3412.025; Wed, 30 Sep 2020
 22:25:02 +0000
From:   "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To:     Ye Bin <yebin10@huawei.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: RE: [PATCH] scsi: fnic: Fix inconsistent of format with argument type
 in fnic_debugfs.c
Thread-Topic: [PATCH] scsi: fnic: Fix inconsistent of format with argument
 type in fnic_debugfs.c
Thread-Index: AQHWltAWq4py2DrvrEOqrQZRgOgLVKmAcpSAgAFQmsA=
Date:   Wed, 30 Sep 2020 22:25:02 +0000
Message-ID: <BY5PR11MB386360CB684157B0F9F48864C3330@BY5PR11MB3863.namprd11.prod.outlook.com>
References: <20200930021919.2832860-1-yebin10@huawei.com>
 <20200930021919.2832860-2-yebin10@huawei.com>
In-Reply-To: <20200930021919.2832860-2-yebin10@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2600:1700:ce00:1710:4dd0:6a3f:6895:7d53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 089c90e0-0b36-4e53-0fa8-08d8658face3
x-ms-traffictypediagnostic: BYAPR11MB2709:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2709EC98CF4898B80FF661DAC3330@BYAPR11MB2709.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:177;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cEirw/t84+Ti6y57Gdhh8SBxBon8LT9RgQliwp7Sr09e9OdkeHqDvc/rRXT5AeQt5u0CHpC7TnuRc3jMsLY1jwzjMYIk/1CH3NGTf4vyEH8B09nlDoudBu9HzcKg5nFZuwVtW5LWVWq4iPQf27g4pEmUBa5fHY1j2vQHE9og4FZ9iTcT7QL+BJYmP/18CSzJrStCNjo+F7GgFP7PA8L9/Ay5+Kqj3A5BRWZe5rScvhiFnOkllUTNassm+NgjSP1i+1M5PdI1Aq7m1Ai9KkFthYohNylQmmh9sriQN9iEbtUfMcKCAji+E7/A49CoZnPpJFYtXeBtH70CDjwqWFf8Xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3863.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(346002)(39860400002)(52536014)(110136005)(33656002)(64756008)(76116006)(66556008)(66476007)(2906002)(66446008)(66946007)(4326008)(71200400001)(8936002)(8676002)(316002)(478600001)(53546011)(6506007)(86362001)(5660300002)(55016002)(9686003)(7696005)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fCmzrkiIVV5j0/2S5kAjC99smOk+HxgGd3W/vB9OmSs/KYNDQr5hmcVOXheMy14LBXBOo/vqGvaUAJUC/ad0GQUigPXzdLVnjRiPFVXUHYjjseKmN5rZIWGLcjZnPB99olIBW7ko/mHGrKiMuGZULF2wk+5n2qloNgZ/ipHGwEDjZ4TaVzDBTHmu9WB1qhzu4rtLXOEFn/ugD/W4T4vRifTmmLvLOptqDJt3S9MUJomkYpo1HEp3jMgFfC7RG9bgXsqLoJYdewqXv4Isl5PXIIH2BwmgY6YS8jASOdEnpvn/mkI6cWk1mkXitPWxB6uQIRVKdwaIWj5kkhgSG/zXz6PiYhnQkeLYvzAcMACJ+9ZkEuu1lOcPVwpVi2vHivfMkiMuqDe5UaHvKWrUZDaX+juIoTusCe/zxzsAr6rFO8Pwbm31ykSSzRzpZNcSFEvYC2fbLa0uBBLTXr7I/pf8IxIMQlS13mYIj0iArMEEcoGkCov5GJ5PwEX4gLe3hlvyvbw9X9BKp7I50/K6QmEqVwVOG5P6lXWJG4OPZIcrtqNqDJ/E8RYo3l/TR2s3GLZ9v/WSs6x7bVvldug7PjcLnYchx24akdXxlZURvpg+/1Ilgsr36Rftp/PxDXw2t6a2QuglXAmgLDl3OVXdqwRU3AH5DhrL/GQ7lWjNw6xXe9npkzI1sxuZAW/2CL7mIxd6ro5rq911OBEXCjIizf7uwg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3863.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 089c90e0-0b36-4e53-0fa8-08d8658face3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 22:25:02.6216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6j1JhILsMhxzaDjMZSrE9FYqe9iO89Tm+Cdi/j6O9Sjww2A7WnLAyOOjPXDgZISY1urEEEPCXgL6aEDnbHr4yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2709
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.12, xch-rcd-002.cisco.com
X-Outbound-Node: alln-core-8.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The fix looks good. Approved.

Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan

-----Original Message-----
From: Ye Bin <yebin10@huawei.com>=20
Sent: Tuesday, September 29, 2020 7:19 PM
To: Satish Kharat (satishkh) <satishkh@cisco.com>; Sesidhar Baddela (sebadd=
el) <sebaddel@cisco.com>; Karan Tilak Kumar (kartilak) <kartilak@cisco.com>=
; linux-scsi@vger.kernel.org
Cc: Ye Bin <yebin10@huawei.com>; Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: fnic: Fix inconsistent of format with argument type =
in fnic_debugfs.c

fix follow warnings:
[drivers/scsi/fnic/fnic_debugfs.c:123]: (warning) %u in format string (no. =
1)
	requires 'unsigned int' but the argument type is 'int'.
[drivers/scsi/fnic/fnic_debugfs.c:125]: (warning) %u in format string (no. =
1)
	requires 'unsigned int' but the argument type is 'int'.
[drivers/scsi/fnic/fnic_debugfs.c:127]: (warning) %u in format string (no. =
1)
	requires 'unsigned int' but the argument type is 'int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/fnic/fnic_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debu=
gfs.c
index 13f7d88d6e57..6c049360f136 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -120,11 +120,11 @@ static ssize_t fnic_trace_ctrl_read(struct file *filp=
,
 	len =3D 0;
 	trace_type =3D (u8 *)filp->private_data;
 	if (*trace_type =3D=3D fc_trc_flag->fnic_trace)
-		len =3D sprintf(buf, "%u\n", fnic_tracing_enabled);
+		len =3D sprintf(buf, "%d\n", fnic_tracing_enabled);
 	else if (*trace_type =3D=3D fc_trc_flag->fc_trace)
-		len =3D sprintf(buf, "%u\n", fnic_fc_tracing_enabled);
+		len =3D sprintf(buf, "%d\n", fnic_fc_tracing_enabled);
 	else if (*trace_type =3D=3D fc_trc_flag->fc_clear)
-		len =3D sprintf(buf, "%u\n", fnic_fc_trace_cleared);
+		len =3D sprintf(buf, "%d\n", fnic_fc_trace_cleared);
 	else
 		pr_err("fnic: Cannot read to any debugfs file\n");
=20
--=20
2.25.4

