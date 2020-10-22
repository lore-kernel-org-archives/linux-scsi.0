Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06AFC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B767223BF
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lgy5N1zr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="j7Zpq4hn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894403AbgJVAv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:51:29 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10624 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442801AbgJVAv2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603327889; x=1634863889;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=clb5MlM+CXok+/xDSyuDCfYM1wmyJCpUebxR50WUymE=;
  b=lgy5N1zr6+FzqmNImJY0csQSHu/0As2upIyfEoww0bo/OECCBy66wPTU
   QwZr27Gl0p5zSmH8RuX3r3KwuELK/V4cKP45mySpdXzW+su/W8e5fhgl7
   kxmGJxVyqO0/FMSpE2Xs9GpL0rQlpBH2X3GXZAH/u/EIFk6XEjYNLNo9I
   PpUHJ3VPwqA7L3II8Ilc7pQpPzUJVrG3GnyJUXeX8UOInL5Vlb4/51Nzl
   5fWcAgpUck8YiIDqUBshn23UmG2QauZBd/LTtDQj8FWhN/Js06ooWZTAC
   DDbtxOLevwB+Cssh3cpnJdj2HkXn2EfONBoW3Hr3xQLPOHiecVCx2JAqQ
   Q==;
IronPort-SDR: 1mzjrhzHCyMe/DvZG3c8YUWuoWgFkmJUz3/Jd5j4SdTwW8ToXYWOs/FtuQFnZGrsmajkUfIMwl
 CyDznp75cRd+2Q9bh1ccYjjRg+N66iHZl+nRvCbM0PhBRGN6+Tcd71jLIlxvU2wRJS6u29s8c/
 YUWgTp4mpAaiDeYlhu1s8wlhH9kBgrA+bCvsgzM+Z9L9XSebD96m7UiDlwuZFxYWE/ex2PvE4D
 tCvFekbH7mjOATLOIduolUfec4Gwx+RM3TPA6E1Gs4EvuMW3YuoqHGRjhwJB6ENjxutLYKX1LM
 K70=
X-IronPort-AV: E=Sophos;i="5.77,402,1596470400"; 
   d="scan'208";a="155005387"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2020 08:51:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCegf8YWPlWQ/yaTv9BxCwSLONMjvRDI7i+77XDWN8zsQK76WpqgIqDmB7iTxjYLqhJdO0Og5Rga2UtEmTn6pAuJYu9lttEU5IHkGL7wwhBu71Yzgn99NNVRYoIKar2r6re5wuIAspFYpt/hF1azW2kwnqy5s59mNLS56eLirtGOvcxSfoORWL4Jvn6q60v1vR1S59u67ULOGj3Ddk472jHecVhV0xC8hx+K1sQ5PXvirDvMJxf8gyoaKC5xrgXA3MBu2z3taQ+UqpM9kIyzcktgcgToqLDTVjINL1Q6IjRgEPb36yWmkRYoUc/r9MNEZEEv5Qi3jPvDVdjKtKnHyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clb5MlM+CXok+/xDSyuDCfYM1wmyJCpUebxR50WUymE=;
 b=OlMvY86+s3Y/VS35bNfS0mqI8dYSLeoaOUvcu++bB4wyCm5O5ts5NKtpPlPS8uXH+R7ZHbbqVQ5FNyQbGSOOXvl2x5SiW3cEW8GT9wtmDLKeLgyaaUA1ukdVrwb4oqJ3vxqxUxzOl4TKHX0KL0b5xlM9qfhfs3q7pNiZWKJ0S3Arie4np6oBlJ36peL2lMDhTV+3YrqFjOOZAw7BqE70FqheonTYGWNjlKSxhMCeXamdP1iUMSc6dSSkKTf0433iv7QGIJRurT99W5F+46154lhof+U3iFoH9S8N+Jilkys79jVOZMxZAX8fk0rqFINvyEIWkG45fPPJmByVjhEbnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clb5MlM+CXok+/xDSyuDCfYM1wmyJCpUebxR50WUymE=;
 b=j7Zpq4hn53IADN1WmSCwp/OsmjyzWo+mngMgYAJSqEznm2/hipbXAYpSsM7gnRFGYPEo3kZeleU8cXyUFZTC4S+t1GOAm7sBSoTCCQUgV1Y3KjvoGrJTmaoBHYXATPvL5Dxrc9j11DyIuQMej/pGVIKE8WbuDFj//x4HmWauOb8=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6552.namprd04.prod.outlook.com (2603:10b6:a03:1d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.26; Thu, 22 Oct
 2020 00:51:25 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3477.029; Thu, 22 Oct 2020
 00:51:25 +0000
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
Subject: Re: [PATCH 02/17] vhost: remove work arg from vhost_work_flush
Thread-Topic: [PATCH 02/17] vhost: remove work arg from vhost_work_flush
Thread-Index: AQHWqAs6k3Dw2TcIYECQgg/ZbIRTxA==
Date:   Thu, 22 Oct 2020 00:51:25 +0000
Message-ID: <BYAPR04MB496583F88923E12239752032861D0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-3-git-send-email-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 086729bb-e4c6-46f8-14bf-08d876249a92
x-ms-traffictypediagnostic: BY5PR04MB6552:
x-microsoft-antispam-prvs: <BY5PR04MB655232FBBE07AEE94D7F2BD1861D0@BY5PR04MB6552.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQryYoTMvkJBG62tMGs+cZ0e0aQyAAEOcmO42PgRhJcPtjBwQ0+Dya9y8k93Jfgh5A27yTZAwe7y7IOWwhMkBwvRXKSrkTuqtm6kQ28VpwOZomWz/z0Vf/OaBXnVfN7sJPVFJGPnCdoIpHUzjIpJWUKcxAHS/e3p5GV8IXdY/AS7qq/muWhnDSiepl+DKEhsaa/NXVvYSldtTD08ATu5NOavKOKM234w1eHEntgflc/ac6WoiEp/w0x7ssF6kb64kWQJhjjR2OIUvbnIxv5zufFLM+AgZevj8L+gv5QxGfdv9tbqfNY83DUA1u3hrTytafnjmBfab2LzU/y8YmV5Ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(4744005)(66446008)(66476007)(64756008)(55016002)(66556008)(478600001)(5660300002)(7696005)(8676002)(33656002)(186003)(26005)(316002)(2906002)(76116006)(66946007)(110136005)(9686003)(8936002)(53546011)(71200400001)(86362001)(6506007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OdOnDqj4ICC2K9rn75rUuSqciKTVCHOsNQFW3z1wwswKNbh9OYWWdbRMPj2KKcW5TIONIagv1mZORNQraHQ54MEtuE+cwWxJ8kcO+j+iMIwfIJeMJH0mvSlak2GVp0Tzs2kuv6OtD5J9WVeSbccfY+9qdv5PlIvBoj+awsaZT8e6KeNd2KXGwMbn9fUMsy/QGZu2SVfvlbfMoLNHzTZywCEqw5V7u2CfYDaG71Rb5sJPwuTsvJoosK3yKo6hJGgGAMx+eIRM8X5iFsU9JzhE8nIOFNbb/B8MzFqQeozeQQd4cdRyK4GWhZ5z5qAXEtfCq4rXF8LXbeTpfvL4hi8wto0G7ayISnKM+lSIuwTkxVFWZMdJ3rAMt3eEQX447B+Mj7KIXxyK5rUSmIl6ucjcjWEd1N1QuotWcm7BJy0DCxePHmPHCEtgRzRcMM/Uup0jjFbkYFw1fNnEVWaHvIpS2HsJvXx9QVUsxpb8bWuDLwLcYo80rWOo7m9wCLemxwQL1OaQuJZ5qwiEV4AbjoZaDbWBA3MFh7GRHcOKXK06JKFQLyQ6LluwJeJk/iHqhmNTU6beGM2TKdNWCPVAPRWjBJ4x+Nfb8Zyy4Be36vfjRlFFA0jadcwT0zPBlauYN/LPV/YM6l/cL98nkUeYNf0F2Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 086729bb-e4c6-46f8-14bf-08d876249a92
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 00:51:25.6140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dQm77/0z6P/qNJFG14UtJOQOM23sNQwl5MqwdH8180tJT8rKQQ/JlpfG6PZY/9d0VLLdlAjiUIobSmE7Dze2197Rk28E5dfIn1X4kDzW6ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6552
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/20 17:35, Mike Christie wrote:=0A=
> vhost_work_flush doesn't do anything with the work arg. This patch drops=
=0A=
> it and then renames vhost_work_flush to vhost_work_dev_flush to reflect=
=0A=
> that the function flushes all the works in the dev and not just a=0A=
> specific queue or work item.=0A=
>=0A=
> Signed-off-by: Mike Christie <michael.christie@oracle.com>=0A=
> Acked-by: Jason Wang <jasowang@redhat.com>=0A=
=0A=
Apparently it used local flush.work, not sure if it supposed to=0A=
=0A=
use work as an argument instead of local variable, if so looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
