Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBE2C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 18:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5C7220786
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 18:28:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EWejs//l";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Bktaw3JJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgGKS2k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 14:28:40 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:7168 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgGKS2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 14:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594492118; x=1626028118;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=0BNPgj3P5az4YJYKX0z3fnXghzG7AvYqAuaeUJ5GsHo=;
  b=EWejs//l3ygvthhxoMD3LOx1vmpCq01Vx6RtFqimhYa0SlSSi/t4DckO
   ByivPv1eLDXzHcJblQLmsXuZRrisv+fPoeLCvBv5VsanAk1+Iw+tXQ+gL
   rMfz6dpjzROSrIrA/8F/Lk3ehp+/uT3G2kIT3kyzk7Pr5S9O5t35Kxk0m
   5vR55UpvR8EOZGBBbHUeow89fP747uTsIrXvhksix5hiPH12hpuFDVHMO
   bTDH+nlGQyFm63V0WhTTF6/fEwqqafqbIj6lM0BgLM6bACmU3cOIOBTp/
   bqhPQRGhdDXKwk26c/YNXuuWFv4mSQSE6K/BMj3AO6P1ZK0xbJXXFbMVQ
   w==;
IronPort-SDR: rUOOTTCW9E/Z5JRr8AsJ1fSC5Uo+kqafK2ltJWXh04lbXMht19cTRQZ8yhnKmmnAVE/WgImkMD
 XV8NeZMi9kogP+bpRFifkWGcagZw68BXj+1BK0SzG3WXusx8JEnW+7sLUv5+bGSyWjUD80rRt9
 +MyujHIh1gMYd+TvTYo+NkiX/HADQrLLrb6+XkdD2UPNW4rwJNgiBBMxLhAgkfi5gmqILerrOA
 mIdMijpbBexYiXZQCc6GhV1E3yzXYGwYqA2cy6LTgofJpm7x77nXa+RAZjJk1kMYX1iel52NSq
 4Mg=
X-IronPort-AV: E=Sophos;i="5.75,340,1589212800"; 
   d="scan'208";a="142213489"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2020 02:28:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOJaeAYUCaTBCbyDlAo5iPa+g3D6mG0PFJhJp/jw54I0rzeOK5JpQ4jVrxh5k5Gndoyh+d872iB0C5L7y2+C8G67u5KjfeijThaUjK7ZTaeki6Aoor5OnaS5pIbGfI907PI55pLzC6RyqhuocqdqoRj0ARwsodRegu9Ugmvr1NkhqQoCxgj6d8rAtVWh7dFMlNh2CUeJwK+/x4g/YNqUxURelySEp3DFJRawp1L2Sr+zcAVFWwk7r2Db3RsZPkRXyjkuMpOjQVxpi58QpfTjPAy923+jO+koJjXTsMDliIW4iCqSMqzQO1EZ+khGYL0B1FMvdznt7ARt8YmClIoW3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siPA2i/JWZmcNIMGmoE9Kwsitz/TiEYc+fcK0fVF0zU=;
 b=YGnCXy3BhRCuyZYpWjvEtjd9Kv6sp33d7CnDdeN2eC7exr6ya8+PPZpwW8hDSirZ0/Zy4XZ6NZm8tNTq/9KAudKrO4m6BtJ5GJNfWRoNYJ6RWRCW9A5yZxMV+/iSoUWef6MyEbOx3WeQzofn14mt52Qo9xwpW15l2iLhkcP8HxOGo8y3W3LzSc5y+TBhCKvGJC0bajToNIValmZWvSifE1fZcwJOJsTi9wMdKqI/yFWGMEdWeysNiOB+Mpt3J/FK5hse8bm3QfmI4o0CMoGGXrkfFt/6Hf79VMWOYek+V76SuENExfac1V6b8ZfPgKfW2POX8IwegEvBESWFX7FQZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siPA2i/JWZmcNIMGmoE9Kwsitz/TiEYc+fcK0fVF0zU=;
 b=Bktaw3JJjvkeMPSG8VQ3wtMfh3CWM+qx9uRUrOHEuaQEFYNfUTf2CU56MfYy8xbexIqZ2hiPeYD0KnTcp9WxxHguwTtqVfOaVoM2rrikXJTMoGw2huIgG661/Wa7qwit5cXOQNUU1eTLD3/pNosoPv/mAuwGllMGXTZs6g+EMkg=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4039.namprd04.prod.outlook.com (2603:10b6:a02:ab::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sat, 11 Jul
 2020 18:28:35 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3174.024; Sat, 11 Jul 2020
 18:28:35 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: target: Remove unused variable 'tpg'
Thread-Topic: [PATCH -next] scsi: target: Remove unused variable 'tpg'
Thread-Index: AQHWVeU35bOmlLnOa0qTwCDZ6iUnvg==
Date:   Sat, 11 Jul 2020 18:28:35 +0000
Message-ID: <BYAPR04MB496584475C53DE2B9B9ABA8786620@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200709114636.69256-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c54a7530-3ea5-418e-d08d-08d825c83928
x-ms-traffictypediagnostic: BYAPR04MB4039:
x-microsoft-antispam-prvs: <BYAPR04MB40393EA613FBA206EDE826EA86620@BYAPR04MB4039.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:12;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zLmZ/+USfYt4nvJGuGxmHYecXtDiOY7wYdW2hICmobdt4sL6P47hsl/XuHna29sCfhRPlnk/ENCj1P2hY/BtoI9XAvVOHzuRV7zIW/yKTXMovyk9BPR/cP+E1Xul9zp2nRib50LTvopkExGsW8a+gYyAsvUC7i8kzxaY2jqh1vll2fB5u1cXWLLONfaF15NA21DjHa5p39IDgo4UGEBpCpMYvvlM1AL99PAAtt0+hvMfGTR/Tyq9WBIqUHBUkd/y6c7yViwkBc9npliUoxARSxQ8zRpSBeay8TBugceSKmfcrOslBajHIRP2hLqjT0+pFML/Fj9f80adCBOLstxD5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(66446008)(8676002)(5660300002)(86362001)(7696005)(8936002)(71200400001)(4744005)(83380400001)(76116006)(52536014)(186003)(6506007)(478600001)(53546011)(26005)(316002)(66556008)(66476007)(64756008)(66946007)(33656002)(2906002)(55016002)(4326008)(54906003)(110136005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mZyxhuyi19sN4hMWQua/BjIyu/r3dhmb7MNPaq34JFA7wgm57nzto+SzFF3es/arKk6hB4VFbepctJwDh7DE37nCY9IE0uYAMjRc/jZ0mTRib9djMl65IWnN4MFFANTjJowCBM9WxZp/H3DpOu1z8sUBV8/hdGlqQ/PMKM/mE+9gXNKKXVYB3m8ZgEd4Z56/6NRJq2dxqqEdpvhDDQ0KRFsfu0KngPVS9hDal5fkOkpUDp7vfsPPuQeuWxd2IZ4IPUJz2LW8sC15UjAQ4jjd/L2NK4YHTJshUyq0wiq819cr43aPr/Q8yPvG4HlgISheY03VYOOPXW78/YeWnm7MU4I2LZl6uKWaGxQLNjeGAnsxIh4i7CgpUat/kx7hdb7riW4ATQuQINjqJEZucAXgvTPrDBGGqGGwoIRafxJccK0ZrTZMYniYVIBCEDQIFfDEGTmUJIEhi9YC4c92WPHRcpxVWFO07bQYKx7JMskC9EM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c54a7530-3ea5-418e-d08d-08d825c83928
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2020 18:28:35.3409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4cm/0pH9uEFP3+tDQFh/KAsz76hSYl3sssqLlc1NCuFzWUU9UAPlQGzKLY8rgdo4PngCB5IeXrkaFFEEPE2E2DOD/ceiZFG9to/9itPAWbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4039
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/9/20 04:36, Wei Yongjun wrote:=0A=
> Gcc report warning as follows:=0A=
> =0A=
> drivers/target/target_core_pr.c:1162:26: warning:=0A=
>   variable 'tpg' set but not used [-Wunused-but-set-variable]=0A=
>   1162 |  struct se_portal_group *tpg;=0A=
>        |                          ^~~=0A=
> =0A=
> After commit 63c9ffe473d3 ("scsi: target: Check enforce_pr_isids=0A=
> during registration"), 'tpg' is never used, so removing it to=0A=
> avoid build warning.=0A=
> =0A=
> Reported-by: Hulk Robot<hulkci@huawei.com>=0A=
> Signed-off-by: Wei Yongjun<weiyongjun1@huawei.com>=0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
