Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F992C4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34A7421D91
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:59:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="a6NqaiW6";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="fvPmUg5T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgIYG7D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 02:59:03 -0400
Received: from alln-iport-3.cisco.com ([173.37.142.90]:37887 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgIYG7D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2020 02:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1317; q=dns/txt; s=iport;
  t=1601017142; x=1602226742;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BEM4EVmFnXsGR097QSMgvtxz1Ke7LGGJ29vEKdhNuNo=;
  b=a6NqaiW64Ww2VMzAx9NxEVESBK5YcyHg6dyeMbbk4/V/jFx++6p7QXxz
   iF3OQJj1dKENpsZgBOFrwCCjDye+9puf2gAhTmTVLHCiv+N2u3poFF+py
   IlwLnT1HioIyd+WZ4LLlfESI7ceitbStANTCygw/k29k/4ToISFQpkunT
   4=;
X-IPAS-Result: =?us-ascii?q?A0AlCgDWlG1f/51dJa1fHgEBCxIMQIMhUQeBSS8siAIDj?=
 =?us-ascii?q?XqYdoJTA1ULAQEBDQEBLQIEAQGESwKCLgIkOBMCAwEBAQMCAwEBAQEFAQEBA?=
 =?us-ascii?q?gEGBG2FXAyFcgEBAQQSKAYBATcBCwQCAQgRBAEBHxAyHQgCBAENBQgahVADL?=
 =?us-ascii?q?gGsagKBOYhhdIE0gwEBAQWFNhiCEAmBOIJyijwbggCBVIIfLj6EP4NIgi2mL?=
 =?us-ascii?q?5ENCoJnmnihD44uhFegBQIEAgQFAg4BAQWBayOBV3AVgyRQFwINjh+DcYpWd?=
 =?us-ascii?q?DcCBgoBAQMJfI8JAQE?=
IronPort-PHdr: =?us-ascii?q?9a23=3AbueWvxU59AG3gsku1c5q4yAlMpvV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSBNyFufJZgvXbsubrXmlTqZqCsXVXdptKWl?=
 =?us-ascii?q?dFjMgNhAUvDYaDDlGzN//laSE2XaEgHF9o9n22Kw5ZTcD5YVCBomC78jMTXB?=
 =?us-ascii?q?74MFk9KuH8AIWHicOx2qi78IHSZAMdgj27bPtyIRy6oB+XuNMRhN5pK706zV?=
 =?us-ascii?q?3CpX4bdg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.77,301,1596499200"; 
   d="scan'208";a="540312339"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 25 Sep 2020 06:59:01 +0000
Received: from XCH-RCD-001.cisco.com (xch-rcd-001.cisco.com [173.37.102.11])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 08P6x1dS026314
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 25 Sep 2020 06:59:01 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-RCD-001.cisco.com
 (173.37.102.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 25 Sep
 2020 01:59:00 -0500
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 25 Sep
 2020 01:59:00 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 25 Sep 2020 01:59:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PR+pGPMrjJXrx8iJe/vi6YPA9bu4uPqha+MjjjB/M0dm/fw42BzRGb4c1cyXnYC/OPkP+x+JEwJlhGZnsCOJNucMgNJ+kumaw2acyjwI21Dj7CQBg5chVO2gyfez/9vL/4wMhchyy1qA8eGzS4OJCCCfb0n0TPgMorPBgcPRBW8t+weqVDSsYAzO28j8HLNC1mcqFvwpIEDOfJVZS45gsusph5Tn9K4d0rOaXuHDICAGIJnyJfVptTvDCNntSnlfNjjlrVwEK4kL8vSdqdgjvEfooLcK3EvOlY+q0JBIKrNf3i7BgH0ob5QthHJwOLzRGxHOMZbPLicQ185IUXhzLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2GSE2w+iBtas70vugsbANlIF/G+Kp0wOR78CMlrMyk=;
 b=UgavWNplrWiC3XEjft01QWem52aT/Floi36mfAn/WqyidhkiXqCtS4UguDRQbZVwFBjzPxZ9x3fk9gQuf8xY8Yc66DpXO5LX3z1T/0yMzD/62jYlhLSxrKseJYRzznynwzW8jWL+iZoguaqakqzBbIRQ8TDolU4KKbOOXldaGVxGJHSt+a1I2JU4YJEnLf7ulZYz4M4kPiD/zVMW6Dq2FB3csbma+7f5EVd+gqCn3+k67foYzfCIRHRajD5nW/BObpTHIgke+jItc+DOkyCeGcB1PvG+vO6S6pBp9SGgEV1md7gKeW2ahYSPA5gb963v44Flhsen4q42qUPqD4oVdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2GSE2w+iBtas70vugsbANlIF/G+Kp0wOR78CMlrMyk=;
 b=fvPmUg5TLKgKgXBGpkZp2yPKpYbtOVdsZylMjLUmeJhTXYJhb1jH1/D5rAQYxJuGNbjVY/A+pxMh5R1cBLPPOix+/9fdvczfJudgf79PkQbBchnn7D1n+Sy6X9kX6sTusBhmFs6RkHeDaRD8FiMTac202s2j6JPTo5Qo7V5dQro=
Received: from BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28)
 by BY5PR11MB3942.namprd11.prod.outlook.com (2603:10b6:a03:188::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 25 Sep
 2020 06:58:59 +0000
Received: from BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::9d18:47d5:1a4f:3e08]) by BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::9d18:47d5:1a4f:3e08%4]) with mapi id 15.20.3370.032; Fri, 25 Sep 2020
 06:58:59 +0000
From:   "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: snic: Remove unnecessary condition to simplify the
 code
Thread-Topic: [PATCH] scsi: snic: Remove unnecessary condition to simplify the
 code
Thread-Index: AQHWkwJCBsIPwvv2WkCY7N+hS1iMFKl47HJQ
Date:   Fri, 25 Sep 2020 06:58:59 +0000
Message-ID: <BY5PR11MB38631F80136B45251549AC02C3360@BY5PR11MB3863.namprd11.prod.outlook.com>
References: <20200925060754.156599-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200925060754.156599-1-jingxiangfeng@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2600:1700:ce00:1710:9c27:1581:1258:cc43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 364a37c9-cea9-44b1-df0c-08d861207a83
x-ms-traffictypediagnostic: BY5PR11MB3942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB39429E2A727F8723EF1B10DCC3360@BY5PR11MB3942.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aROirSl7tJ3Rd4+/yf5HibVqkSixwHpkRzhsIyj4CMUnmBvnYHG8Mp0F+jX6lUmOJ9r2MPwfzYvOyCMcmPYUXSNRIQYZs2ZwhsxpTwktfucWM0i5og31YhtWwi6nPWkSdjwrCtkJp2hXjw0sQp8GnPOvibiU7tltJJLkf0zYJreG99f/mu2/ImORC3To4GRLoAHbhGQJR5hrlwen93YMk1GMXmn6etw7AaGL6kTniQumy2f1Y0hUChLYZGyNmewJ40iIFcSF5TVoc1EVj2SGVTTcYsWl1y3apnbjSzgW/L57kbpoIxNP6332lsJt5yqQB6c3DkTSsXrxCOhVuQWTNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3863.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(346002)(39860400002)(4326008)(110136005)(316002)(76116006)(54906003)(33656002)(86362001)(7696005)(66476007)(9686003)(83380400001)(64756008)(66446008)(55016002)(71200400001)(66556008)(66946007)(8676002)(478600001)(8936002)(5660300002)(2906002)(6506007)(53546011)(186003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ifNizuParxFHwazcv7+PxskAX9pxOcH42Vmv0x6o9qMnxt3d42f9MuJMHu7hgXh0v9zjkRDoa6lqPs1Kl0gG1gm7G2sAPIfcdtdMDUbcbNJPOklejCpZ9awYTiUMs6/72aLufWQ9lCcxBu0f4EJAHEjk2DuSN8XEKfgJZ8jB/oLrc4bhlhDMu8Xu5arpH07WaD9M0omRYE+YKn0CFKBVdLiY5Yyzt10Fg6N9sQwr60IABRxFXU+7oy9eTfCA9Ti8pBHYRil2dvW8vRA2BaStEKWFVx3NNM3rmZTEywNPE35BPWDUdfo7V5x53icFHKUuOFpIaHrXt5u+aJoN4Efit0Oo2w8PNoa11DU9yZ0rGInrfwLZZa33Xsv533f/fuDQDMZ92h9/3k7KWFYlzybR+1mH6L4Qk1973dWY2ReV7z1Hb0WMcCPa9nPzI0XMLtFrlqMeBuuKtDIDXl81yyrp4vjMb5pFl7Ox/L6egiJWniemzEetMcRFCA67bka5AGFYAGDOACB1KDVInuEbZK5wdjfd3ek6Ld5y2zPnTBkokWLyD3MsVcDIEb0Lprc2E68yPlGyvGyBC7MTTwgNpkarDFUZ3R0j6RkbW7nPz7bEUqZV+oPrCEs7Wi41DBUT1fbtwRX6BLVHcjv0FwhHP3q3cSueprWBlWifk1X+3V8UC+1DZ1DsXeW1KnGBYoB4iVUh2pd1SESLig9oWcK2sM5llw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3863.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 364a37c9-cea9-44b1-df0c-08d861207a83
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 06:58:59.2976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wezYTsz3xzZvvke/Xnr8O4u9zAFbiud2+UyZ9LBMjZqI39zRiK3fpiGkg2d2+mUSwMDZQu+wJm8/7xi4syLX8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3942
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.11, xch-rcd-001.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good to me.

Signed off by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan

-----Original Message-----
From: Jing Xiangfeng <jingxiangfeng@huawei.com>=20
Sent: Thursday, September 24, 2020 11:08 PM
To: Karan Tilak Kumar (kartilak) <kartilak@cisco.com>; Sesidhar Baddela (se=
baddel) <sebaddel@cisco.com>; jejb@linux.ibm.com; martin.petersen@oracle.co=
m
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; jingxiangfeng=
@huawei.com
Subject: [PATCH] scsi: snic: Remove unnecessary condition to simplify the c=
ode

ret is always zero or an error in this code path. So the assignment to ret =
is redundant, and the code jumping to a label is unneed.
Let's remove them to simplify the code. No functional changes.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/scsi/snic/snic_scsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c =
index b3650c989ed4..0c2f31b8ea05 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1387,10 +1387,6 @@ snic_issue_tm_req(struct snic *snic,
 	}
=20
 	ret =3D snic_queue_itmf_req(snic, tmreq, sc, tmf, req_id);
-	if (ret)
-		goto tmreq_err;
-
-	ret =3D 0;
=20
 tmreq_err:
 	if (ret) {
--
2.17.1

