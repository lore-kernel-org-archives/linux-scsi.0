Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30F0C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 13:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADAC520718
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 13:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="RMapJQLx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfKNND3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 08:03:29 -0500
Received: from mail-eopbgr800052.outbound.protection.outlook.com ([40.107.80.52]:7732
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726318AbfKNND2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Nov 2019 08:03:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BapJkBnRPCaqa06Vo1cKNkeiRqMF8H6CLqJpXurC90xIU97t09QiPPbtTGYeOy8LVqM9CKbITHE5eyMPWscbwUr6+KVcCC/IQGDouejHHG6WtZtY8ezmZrHREsfqmCydWQsVeLF8fK7JHyeBQm8AUR7UNSfv+CYiXiPZprQtPCpA2Ayxg4LAZ2/w4MXaYCWNl1tjqVKiLJ6pyfr+WMnWM02vLABdIwQ0Ayx4SgQxytV5QxHAsHsuA6PIg2fAIroy6gqcYaaguJwB4AvcFPl26AwSsl57b+gWzD0tTAxlmp01SSc17e2P43JNpiYhKX6ZZFudxa7lEO+8qIOYTS2MYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrOXTYNNHHa03TcrwwI6AOXoa5aTiczoBhGQ09IpLJk=;
 b=e3H41fy7ctOTFmavxC4y3/R7sgFEUIkDkmpUr9VtIrwW1aWsGOS/P2KhZuCOJpzmcYSlx39y3/5rNxQH/XbNlbaweCxayKnJPfTACI1586yMogDvWAzskp59hFIwBnpreYx5rcG2ykGSvGeSmTpK8moXqhm1gi7eArao3FFprzN5i4hF6VSjCa3d7+ajKoiDV77URdMC7iRf1ROnrPJyXYRjMxRlm5aLpzVlzZBoJxd3OwPjwKCuPSo7NTcG2nv8mHEwxfWPYsRhyINP+sj5aSCq1LBbQdD4k+VPAzNzYYoY4S4Ie3TFQK2/oI095442kuAyx9CJwSpnCjidq6aYOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrOXTYNNHHa03TcrwwI6AOXoa5aTiczoBhGQ09IpLJk=;
 b=RMapJQLxYYYDfZ0yqpNFguHJDZe+x6G/jSiYakn5eWi6zELLprEkUI29tGcy/4S/7oJw5Dw7Sof/SzUcViwCxaPYkpkEo1CXCCPDXzVA9wVj3gQTg99uYxfC01kXZN6bUl0PVOxNAwUQcA/BniYRgepMRziQS0K0JhglQLATnxU=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3907.namprd08.prod.outlook.com (52.132.219.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 13:03:25 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 13:03:25 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1 5/5] scsi: ufs: Complete pending requests in host
 reset and restore path
Thread-Topic: [EXT] [PATCH v1 5/5] scsi: ufs: Complete pending requests in
 host reset and restore path
Thread-Index: AQHVlgzPbiOALT34b0a4wX/4UETvQqeKqxKg
Date:   Thu, 14 Nov 2019 13:03:25 +0000
Message-ID: <BN7PR08MB5684427D1D717E9B5F9B1617DB710@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-6-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573200932-384-6-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTIzMTQ4MDBlLTA2ZGYtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwyMzE0ODAxMC0wNmRmLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI2NCIgdD0iMTMyMTgyMTAyMDM0NDgxMTYxIiBoPSJwc2tnakdqUVM5M2tkVWVyaFdJWjJocHYwSk09IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d75b478b-a78c-4259-a512-08d769030906
x-ms-traffictypediagnostic: BN7PR08MB3907:|BN7PR08MB3907:|BN7PR08MB3907:
x-microsoft-antispam-prvs: <BN7PR08MB3907B62D99EAA0BCD22E6D03DB710@BN7PR08MB3907.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(199004)(189003)(2906002)(110136005)(74316002)(558084003)(71190400001)(54906003)(6246003)(99286004)(256004)(7736002)(66446008)(64756008)(316002)(86362001)(52536014)(14454004)(305945005)(2201001)(71200400001)(66476007)(66556008)(66946007)(7416002)(66066001)(5660300002)(76116006)(33656002)(6436002)(446003)(478600001)(9686003)(186003)(229853002)(3846002)(476003)(6116002)(81156014)(2501003)(6506007)(7696005)(81166006)(26005)(4326008)(55016002)(8936002)(8676002)(486006)(76176011)(55236004)(102836004)(25786009)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3907;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k1aMkY22iJISSE/OoEZmqTdOS+ThEw/LSXjwNqOo/bocsTI9VeL24fJQdwe/cABlaZPokXmTAy1Qw7zCnN1Flik1xC3H6J/M/Sw7MQVU1uuZ3L7jQyJgOZ9g04YQp6Wj92hh6tA6/snbLHo4v6RxgEa6f/vD/aWQXcTY3ynqF7MGxpd8F8cZq0LbcgmN5qBKSHHkQ2YYbURclFge7Wp/4ZM4CqsdyT1fDC9XIugHHe5IxWzd3xj4w9FLYd4oRZySNkHbyVg2XpJw1Xgk7+1Ub9nDjWMkG+GjPDJw2RQjIjCTCvxIXCqD++HIzRrbaNJYm9HS5Aq/yaAKk6vMYANpAKkoz9S8+M3an8SSbEgXWfyFyb/vL2RnhCqejj4zQcfTyogshxiBSxmt7TcxWnt/RAyN8is67HkZdVHB6OREIaH9Xfzi1jOkOHo3oE5HwvOB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d75b478b-a78c-4259-a512-08d769030906
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 13:03:25.1504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpPkLaApmwCSm9vt7SbOd600NNFMvCubZqZQcAlWnddSLN4ShvP19x1sHs7R/XnbdcALw0ztCRcnCGCNKLuq9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3907
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>


