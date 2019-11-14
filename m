Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBEBC43141
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80A90206D9
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:47:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="J81DYSFX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aHlDLeyY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKNKre (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:47:34 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22657 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfKNKre (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 05:47:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573728454; x=1605264454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rCad15nLeozgoWeoOilqvvr394UBmmpbDxyHldBwgr8=;
  b=J81DYSFX9zsDDG+kD1QNUr+UbD8+6XDv+NAfpHgqqEmK1raXbGZxjhoo
   Fwy5YCBfwuwijCSsBg4glPORDmcXzPQgTH50EGrPXuWyDslLsEeveqU35
   iFHu7VMQXZMykdi4IPrxgp79XcbizdgkV85klmRCR0+jJ7+nHcTFuCy85
   imlkrPfYNFA+6PuKbCGkd4HBAR1/SE+YpDuCqRd8tCN6lvb7+rlzZdQLQ
   WqR0z5Emi7y5lyAbcNjjt6/u+WCHSfSPagqVmKLUc8P1VLf9GS7ExGc3y
   FpSKKvIz0E0MOMNGSgXdruYry2rIjP5amQI5ll6gkwoRjvcnxPgsYCB9u
   g==;
IronPort-SDR: BswEbV58jOs3v70GyonWBoHOd2jRTqt3QwE60dQPxQVcMzSU0g3narn8PIQloe1Sfix7MhX4In
 kuosv6GPSHaCL1P4gkCPYF4Pq/Ggr//qzWcoCAMa9okzInLct0ErDq6iQHqIJfpaTJ5LWW2Py3
 MZSzVQ4I8OctYslcxxS8cyId67bish6HW3GpG8A3PAuTVDW9lVTzdna5Iy1VYdi/Nph+KfUPyK
 0CTKk2gWMD6ILmzpGs/7cBMwlCaSBJ/DRSJW2oC9pxj+L08wl7Tdqz5Ygc5vgrhUBv1LPw8zzR
 oJU=
X-IronPort-AV: E=Sophos;i="5.68,304,1569254400"; 
   d="scan'208";a="127435420"
Received: from mail-dm3nam03lp2050.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.50])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2019 18:47:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVuzoCBuj2Jn5hXtFd3LsXlYX9x+/udpGmpOCv/ZWC0ee0wvD5jKNyiP9otorGsVJfDNuM4iFBCwo7p1E3MSopC0IfqiJCEVmt6UJgl4Hk1Dgx5nVVIpH6MuuP7Mke84pqdalo52gAT2D5UBjHWfVWkVQUE/4M3YKFdX9PIhzMtfSldEwWxfkmZar+P6Tm/ymT6rxjjrqBTj41lRLKmJQ5KwlLZN2b/fveolrlDRPi68LCdwJ2nIFkoRzRR1qjE8QUaSjY2rk9d62uG4pqUIxgat6liJ6j9E0bwtrPtbTatX8lTtpce28F6LIZ3wZ0azL39Zou5TD06Gp4LjRHQl2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCad15nLeozgoWeoOilqvvr394UBmmpbDxyHldBwgr8=;
 b=VOs53Yev+0TVum262FK903wIf+aDNOJ2P+OZ4Y9zvKKPMegTUup7pWhGswqg1ccMkIyeg05W7lTxe39DP4oy9W1pc/GVjG80EnkWc0VlFjaya67J2IGtgomGGvmF7ef/GvgzrLqo2Gi4J0zhw2biQulB55f1+WajfrU4+7YWT00avi4StSEUAD0+x2jEn7u0VV8grMHUJhfDxZay1HpqGJkMhY3vIts4u9R2QI2pTRpyUud4NKLQypvUGsv51NHyKCp6Z/XGnSzFcsOssQ5UBEEsDkdfYgeHINc7z6EXwYAoF433vvYC3BQi0i/QBzAqcOT/Iw/veAq1FhFWzN37ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCad15nLeozgoWeoOilqvvr394UBmmpbDxyHldBwgr8=;
 b=aHlDLeyY8Vi0mzGwa91Kw8BW5tvhCHMPx6kka/Q+m1vOABXtuKIwUfWy7dT/C2gYqjkdfyeDiTJNEOHGFPVmDNFNNBQi/jcXW3KkF0w6k+LE3daD08lBq+0xbx1C3CezxlNu8C70KYMEQIIq24hIwtv4eTJM7E9QZyaM8NhoebU=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6287.namprd04.prod.outlook.com (10.255.232.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Thu, 14 Nov 2019 10:47:08 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Thu, 14 Nov 2019
 10:46:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 6/7] scsi: ufs: Abort gating if clock on request is
 pending
Thread-Topic: [PATCH v4 6/7] scsi: ufs: Abort gating if clock on request is
 pending
Thread-Index: AQHVme41otrdkvllCEa0ODfuGcqFQaeKfX1A
Date:   Thu, 14 Nov 2019 10:46:41 +0000
Message-ID: <MN2PR04MB6991F767627D4E63AFFC360AFC710@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
 <1573627552-12615-7-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573627552-12615-7-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c4d8a95f-c8fd-4edb-205f-08d768efef07
x-ms-traffictypediagnostic: MN2PR04MB6287:
x-microsoft-antispam-prvs: <MN2PR04MB6287B508B86963D9BD7D5950FC710@MN2PR04MB6287.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(199004)(189003)(6246003)(64756008)(66446008)(66946007)(7736002)(6506007)(66556008)(66476007)(71190400001)(71200400001)(14454004)(498600001)(102836004)(4326008)(26005)(7696005)(52536014)(305945005)(2501003)(186003)(5660300002)(76176011)(33656002)(558084003)(99286004)(229853002)(86362001)(74316002)(3846002)(6116002)(25786009)(9686003)(55016002)(8676002)(2906002)(81166006)(8936002)(81156014)(2201001)(6436002)(66066001)(486006)(54906003)(476003)(11346002)(14444005)(256004)(76116006)(446003)(7416002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6287;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBrcrF2tmJg5D42nA+uuifMFYvuN8QW52kdLpLAnNzBAZ4MasUNpviK8NSK+Dk08O4WwC3yQ7COi7FQR3hDU0BPhSAJXT6RMfa6NxAv+h6rC76OnGWpkWT+I4WjIEed/nrK5166VISotJUtdR3Hq9Ea+avGt2gGUz1aE9nhsuEDLVQlepLfdQsCPYORiDnEJwAbPRPqTwBp9jgMyu55B8OEWtrjqoML1xapnK09SPySLy9xUVXItJCejdJWRgvRVAUdNrRbQJ//HrTtJUyAOcQQYpkcP1JkiGE/dQ9lvIHSZzHeJ8O/jYaHhop4zxDBRgG8dgjIvYbFYE3NOv8Lel1s2EQFA2oj6OnS7FSWO9/EvH//8+Fm7HvHunG16pCjVuTIuvRnyuOY+m9PjJSlWauVIDQGmbIZY5gKZBxPJtpiBmB/ouCO7ZByxBm9cmmHz
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d8a95f-c8fd-4edb-205f-08d768efef07
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 10:46:41.2072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GiBFBYELnktM/7z8iU5z8kBP1fBYDGckmXLoB4j1tQiE33DurYS10ulHEYTEuA7xtgPHkoKHXXW14ALIXNlc7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6287
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> From: Asutosh Das <asutoshd@codeaurora.org>
>=20
> This change attempts to abort gating of clocks if a request to turn-on cl=
ocks is
> pending.
> This would in turn avoid turning OFF and back ON the clocks.
>=20
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
You forgot to add the Reviewed-by tag from Bean.
