Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2754C55178
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52FFF222E9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=permerror (0-bit key) header.d=wdc.com header.i=@wdc.com header.b="EkTHR4t/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ilzWsMNC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894411AbgJVAp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:45:58 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24986 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442661AbgJVAp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603328751; x=1634864751;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=WOWoeT9AKTPNHjW8Rq1aUNiy0OKiZtYIC6R1c2Tfic8=;
  b=EkTHR4t/8tVejYyDi1yDpwf5fqrdv/ezyM+PkvmpI0MJvpBcH9XkNi0Y
   tCzhSdEMz+RwPtmm34+ugH1ipZ1wbG2xoGhMqYoDuFysCw73CIAt/m/86
   WgZCNUcNxp4uRejVfwA6s0fHgx0LxGRMUGfkE2jQL7Yw+9argIfw+0vC7
   HYT6wQ13IHvXpDhf/0Kl3lgXUCfSe25xhIsHoiguqDcFdyPew+zWiIMe/
   Vzk2vCN9hlFpJ9pXaa9uAUzDXjMKAhZteqQk4dvol8puDSmNH2jKEliy0
   RWDzzofJXZW7Xkg3q4Ba3f1GTe7/OVZVP5t7rNU99e3uK3elTNPxAumpO
   Q==;
IronPort-SDR: 6/mYtrAUc9ARuFo+ed+V4CyOGS82al8Ee0ZMnhSHgun+FWM9SRjPtGsEicdOwBjb3nSDNVjVxX
 rYZwD16AOFM5wK4I0YrCOcoa091030TfY48vmEEa7VxhSKWhB3rKok2S9H0ItDJNgfAZrIZ0dV
 FiqYQ2KGxVgnH7WbIdiYiCXVao0eTLCK/oXYZZ1ZaSA2AcGkXX6ouBLDlXf9rwoL6TO8Hca2z9
 kHQjGpRXvqS4uyEaQNlpnHTgPMsdARLKUO1/kuKne94mijQOg1pL28/6veHdEAQJxmzV1UiJ54
 4do=
X-IronPort-AV: E=Sophos;i="5.77,402,1596470400"; 
   d="scan'208";a="254067788"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2020 09:05:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUDV2CbuVCRykZrkhH0MyOve+hVP1EILr7lQTCXLWwkA6LXuuFdVA+c+n1C/6rCU3guww0lCw1oXAF/XaJYhF4A7rmXGj58DOEgTTLXd7uUQfgKIDmHjqlNq1XaSW0YyBJ9ZbtFpaEgdPNhG9zTbNLtreymrqcfVLVFlNh86/m1vwPcA+3vmgKOtxbehPWhyjtXSCrGp67rD8aLa3QnVSOclDWUg5kbyG9q0tbKvBxvc7mFSb/RobvyslL+wIu2BgL/YsV5CQiNovckP8QoigGkF9iHEl2bCrlSexjEZikzD2ChvmkPRpptlOmI7DRvXQe2lMkQYvKyyx3DU5IyY+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOWoeT9AKTPNHjW8Rq1aUNiy0OKiZtYIC6R1c2Tfic8=;
 b=jeSyllP8uoX5Q6N0y7XgCGAOfiyYUCxxkDWUdqqN86yJgEntQ40gtOymmJ8LrFZVsiz1gF2lSKSQJuPMgZd3Y8lgdeeBxc1gY6ublKzcFlvq2m5lAJ9eCq0DwhQkTbzgy3fehtcIQntbWZ9w2pBTtF5Dk1/qDg4+xXZL28fwAWE3rWfdHvtIg1eAbjis4A95SBJ5cUxX4xCC5fgpKXWNjveqlGXH3pOgRzLc+mW6VyDV+ZL+WuEOVUCldkS2OAQY+eDVySJWifnVzsLJec0nJfOnm/JORySddrJnI4lC1uOYHdyuZZTLWTq0j64iQ5CwiBLsViFFQup7OHXdQ0SV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOWoeT9AKTPNHjW8Rq1aUNiy0OKiZtYIC6R1c2Tfic8=;
 b=ilzWsMNC2v2ELXYtt9ECaKQH1wi5qnaf/lO2aHvnACO9D5lD/hTbUEqMKg40hJXWNUz1vyWuwJTk1ENasjtFph+PhX6fpDI4oJ5h58mxaLj9Ra6wcQtBaRQ7JJK0cXFRzRGPmOE75sjiFt/Q1Z3LP9Uju5K15Y/3t92+P1z0rUQ=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB3960.namprd04.prod.outlook.com (2603:10b6:a02:ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Thu, 22 Oct
 2020 00:45:55 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3477.029; Thu, 22 Oct 2020
 00:45:55 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 03/17] vhost net: use goto error handling in open
Thread-Topic: [PATCH 03/17] vhost net: use goto error handling in open
Thread-Index: AQHWqAs7F53Pr+1n3k+YD9NahuhlRg==
Date:   Thu, 22 Oct 2020 00:45:55 +0000
Message-ID: <BYAPR04MB4965B45205A531226FAD1843861D0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-4-git-send-email-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 715f6b5b-aa23-4697-21a5-08d87623d5a1
x-ms-traffictypediagnostic: BYAPR04MB3960:
x-microsoft-antispam-prvs: <BYAPR04MB396060C85A179C0E4EC2F761861D0@BYAPR04MB3960.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X1Cub/EN39NaPKA1BPY/lNlA+d5QhW4JHoehLypDsLmpqUoqzvK8Zh13sjw0ruiyM2MvDJwhYrHpXJXldvthaqa4Qu4MAbr3VuBQPdcB0oLjDgaNtYm5t6cDMDLViGAq06cO8zWVhsi1zl/Cp5IKCokJJFVq5+w1sOysES6NxdKxw3GaWJqBoqM5a6/OhhPOxCw4kEasfhin2i1q2hzjlhhOxTdwVhM4cyzldugH97PLg/Vr9C/z7Qpm7s+lhdClYIdKLpwnkOHaks339ah20J+oIA1sJtZzQXtFVqmowQfDAo+6FEAj9B5y+7VRqOgYiDjXgRKca42HdHFCVg97Zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(55016002)(2906002)(316002)(83380400001)(110136005)(26005)(8676002)(6506007)(5660300002)(52536014)(71200400001)(9686003)(7696005)(33656002)(4744005)(186003)(8936002)(478600001)(86362001)(66476007)(76116006)(66446008)(64756008)(66946007)(53546011)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: o3Ho4j3mS9X/AscvZ1c01pwYShyZ2IjoHpvPOP4hO6ligyOpIq6JUSILbSiZIA7nYXCatXU1NLyVf5kKtROYOpM+9rTocLA66jlJX8D/FKxZuMZ3/C8R9BnpdGOQIxofJR6eOZeS50QXYvDtb7KqVowhV5B5+S/7xc84aLgFff257+n6vg7f3bK4315nAunvhN1Bk9xDO4vtC72GDJXPkEShRXns/ju9JWuJDtDjbezm8xddDy9AmHKQZa6HFLuRoS6O8iSgYxyJz39ntzURSGe0ATUZY/c8t+rC71jvz+YcpPFc0BP9o06JFtLObTTRs9jjIUoKq7/wVdDlNZKCLxodD7ZXJbBTYC9vqi8Ny7WCgWJMriimwmG972ZRXim97D1J25ClfzhWedwcxM2ozB1sG0Nw5weXcVtUqqL7h4uevhmEqRqLWhulqIA5Qp9kUyRj+igMhk9jPvCjjyp+z+QVQ+8vtiWgy4cipuvuIBbZ6PNEGzSkQ5vxMA5FBsERXLy83dVehd46k6Hqox2w3qPF2fprXM2oTvGKhsr3/6+ejS7eZv0nVqGZyd+1hFD/gjrVpTmUycnYNfNkQdWjGBb5mhOUlMfAWsHgCF31ag7Hyq5CDQxfZ+LtzIv4HhhcOmAM24YSu1Mkh1FOF1ZZYw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715f6b5b-aa23-4697-21a5-08d87623d5a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 00:45:55.2185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCcz2UWiqwTNg/vS5oDemBQBRwwE/1gTI/wiInCl1j/r9bBrA4yIVwL6rrHY163kTSDSX3ylC9+06YfdlzdNv/6V7ILn3ecM0v4U1xdic7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3960
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/20 17:35, Mike Christie wrote:=0A=
> In the next patches vhost_dev_init will be able to fail. This patch has=
=0A=
> vhost_net_open use goto error handling like is done in the other vhost=0A=
> code to make handling vhost_dev_init failures easier to handle and=0A=
> extend in the future.=0A=
>=0A=
> Signed-off-by: Mike Christie <michael.christie@oracle.com>=0A=
> ---=0A=
=0A=
Also, not it reduces the repeated kfree() calls in the code for vqs and=0A=
=0A=
n, looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
