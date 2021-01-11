Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF69C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 02:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4217D227C3
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 02:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbhAKCHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 21:07:21 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:34648 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbhAKCHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 21:07:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610330839; x=1641866839;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=gI/87ItPBjesG5AtnFSnIy8lth146aH0sYHayJi1W+4=;
  b=jNJNj6dStccdYphhsoQ2tyMVeaWBU4gbnM+8zS6vM41GqEbpvXHTU41Z
   Mu6VcbyNmujaEO0xMt1Rhx6dHnYO0uSCGWO1pd6RpdSVOmCqulaT5TpKp
   rH9YiE3y9Ig1seXfZJAm0wYeYyW3sy2w//X7t3NZ55iBoqSZpGSMLmGCA
   BF7jUllaXwLGU6nRcNKNokS/AeXW8IABgDSdQmds3T/EF/9rr03kIN8xj
   65ysWLS0mUMUxiRshxtiLa0HTlBtfPej3wL6VvyjDmO7i8x57lRGrgpgm
   hjs2/zpNgyYotDumoqBQy43sS5sm0A1FzjTIBCgS/IY5tHuqPe9LIlCYl
   g==;
IronPort-SDR: T7i9qUDUyKLTaYhcFz9jrwsMcDLUDytq88T1klXoqrE+WaaE6zwq9O8C08/phTV5F5mAOJVJug
 UDlTPdMi9P1NSXJY8RB6vDoTO5NCPE/f1QSZitoW31CcfqM8EUcLpLdFbwDU4tlFXa4FGbt56Y
 R0/tAXN5J73FLnaZhfmvopE62cUdUudMJu+boPi8JeQq0nN7RadS/0I0TgphxKoToLJVpQfbkd
 4tfp30JsffwUoeo7MwGT4pHReiM6aFyUh7sR4lkT67xXEGyaM1n/QxYTvyW0+RJZVe98Y7mbG5
 kIo=
X-IronPort-AV: E=Sophos;i="5.79,337,1602518400"; 
   d="scan'208";a="157109830"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2021 10:06:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZaID0KnqxzgSWuGhSQduTwGnfPXPCex/ZBQ4/wemxNQ/RvX8ZiJobmmC+aOK2CrLSwgovbrVxHETQ69DkQc7yLZpNh7IDomVtisjTJsjTK4uBXeUdao4ZljdFkMf+JJ1HEJPI3cschcpoLYPpkTIB4SdV1rMo2GuZgilLAguWRjmZSD81NBlnGSJMru8LMgZ2B9X2zEhJadhXI9WLlhtk39ob0VaFSGhNpztojFYaOayZWSgE5PBKKF2CZoWlp4oQVpgZ0CKXnfuq6UTduMLHhLbNwZRYBEka2wYkT84xchfW3Ko0Efk5Cu0tLLRRLiINpNcKtK5kn/0EKto2nBMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gI/87ItPBjesG5AtnFSnIy8lth146aH0sYHayJi1W+4=;
 b=SBNifqlj+IsErCx4jOwW+iDtnsBscCHmRIpY4nf0JBbgCyL6H9FFigAF5xZft10cUkwezYHpnh6wqgdN5XDNieBZCStD0NBGuGDoQp4pgXnkOCiVRBRcGY67Jzv7x1KG6gd3SmX6LCygQVk0t6Uj/f23s0PC1WiSU9Lp1DZ5MLmjpc6dH5kZokMm3fnCJNfMPM8PpRJyUIV8Im/9uTiwWBmWauHncwQKvJ89WAdxtXlmdZR6ZyJydaEvl/Vu4kJ2fEDpw0n37NHCe61m4bXkEzx0Na3N2dDYp9tvXf2fyfYbIaTk4bE/2HZn5asrLaU1afsg12LQkk1Sqm4Bcg0t/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gI/87ItPBjesG5AtnFSnIy8lth146aH0sYHayJi1W+4=;
 b=NIT7WJNyIv8U9LNDCuY9F2o9vG9JOpT0PfH5HBnhOwpqW4xCGkrhYM3f3qDUjCDEAZpzS8oHDTwARRJhcZ7/JZefhUWdELAkpcsD3qIzSKhZtFXW8q0uEhJ+Vh6J/qy0hYe2u+QlsU4klFRsq9p15swxUtC/Iz2l5O+IsJiyEEo=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5334.namprd04.prod.outlook.com (2603:10b6:a03:c8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 02:06:12 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 02:06:12 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
Thread-Topic: [PATCH] target/file: don't zero iter before iov_iter_bvec
Thread-Index: AQHW5qBkaWm3Wnjfmk+XiYs/GS5+eQ==
Date:   Mon, 11 Jan 2021 02:06:11 +0000
Message-ID: <BYAPR04MB4965E008861D5B29B9E757D186AB0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
 <BYAPR04MB4965F4DCF59E5225CF17322D86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <4d063dde-c710-44e3-31b9-8fb6b7e1d952@gmail.com>
 <BYAPR04MB49653C92C7925B8C3EAEF3CE86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <b9558bf8-a7e3-c2f9-ce00-3fc2b90dcc87@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 17a077a6-4864-4eff-b479-08d8b5d57835
x-ms-traffictypediagnostic: BYAPR04MB5334:
x-microsoft-antispam-prvs: <BYAPR04MB53346B09010BFE5B7FF80D1A86AB0@BYAPR04MB5334.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KtfT562tRKKS4fyHR36t3HTlaGLemikqHg1JVI8n8uXfzqt+5ZyBCkxPDWvIx5zjYNJEDKo48bBwSymYaz6kHrwrQYiOYsDrnktDH4TdKN53iESNsOjlxDpDdjLsruPqKeL8yuFHHTG+z82Uu74797xQz7c4/+gVLfVTeD+abglio8Zpwsa7UMSP7Ajvjbjpw2xL1cMo/gShpFIe4QO8Cx7gGW6y80h9pHxgd7Gl2TkJIRccIDfMM/jkDsT7Nz7TzrMBirfVgedIMEpWa6N25Hc2XQYTruMq69GelqVMkcaf/bdADX1FXJCTbRodXsnfvgBTlMDJ4mR7T1F+QxjxW1pqF9/54lXcv3R+kBsME/98gdHXWyG2CWG3ynZqqfnsEbPsLYgsThch7wBbCikwYwZkC4yAezXp0LjwQi2WX5VhbyS9KDdjq1sCCDwFAlXmvsBh2G04+152l7XIHun3Kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(4326008)(83380400001)(186003)(86362001)(52536014)(26005)(54906003)(66446008)(478600001)(64756008)(6506007)(966005)(9686003)(110136005)(33656002)(8936002)(76116006)(66556008)(66476007)(2906002)(53546011)(66946007)(8676002)(316002)(5660300002)(7696005)(71200400001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5mgma7cQmu5I4OhPoriBdHzVNJE0TQ9jrqTvZB64QoZQ6+Qt9JuflYFrVizU?=
 =?us-ascii?Q?jP5Pv34W0VIa9VdVJdAbtO5nefw/Zz6oVvN3K9iomdvSqeqkMuRldf8RcrhP?=
 =?us-ascii?Q?PbDiy1pERytbyhPhEPCIUJEDXgxNFaTqEwzUJU5cw/ktmhvcIB3NH3AxtENj?=
 =?us-ascii?Q?y0+yLxfmqUGrOkzoMRlGT3KSl7JFfIRx6ThclhbxANGFOnSYlvqr2VmcCerK?=
 =?us-ascii?Q?utenkoDnMManLxJFZriinkttibeDN79zjTRMERkIUBMe3Yizb4LDxvFCX51f?=
 =?us-ascii?Q?VFdFVJ/u2oC+mcrNm7saX8D09bxdGLC503Qf46jRR3ZbdDhzBxTrLRls3E4i?=
 =?us-ascii?Q?lwHb1oUZ9jMUd0GeurCrPJsBt7ndq42eY62Ud3E4cjmjNLjOv8XnVSAR7PfR?=
 =?us-ascii?Q?vxDaFsLS8ypSxPS81l3tsg3A1eZvsGtfM3YCZbo1eupDWDiNVD98/10aWPe/?=
 =?us-ascii?Q?IM+b/Iv0BuS1tNRi5cQ5gvte0ECJCqV4M0HYEdt+/onYLVi9qXiBo+cJqL51?=
 =?us-ascii?Q?E1HSTEIgN/brdzShiMw5NCfLid0yDbrfcqYnv5h/IH9W2pQBL2FOHwj8P5g1?=
 =?us-ascii?Q?bVW8cIaP4rVkF3UbuwBjgmPDtUO8zHHHMRElV0/etMeWXuteS1G3Ip4lujq8?=
 =?us-ascii?Q?FF75wt+A6ECUTq+tNyIjLq2DI8lj0WNNGoDQlH0t3uad1F4YL50cVkAl1Ws7?=
 =?us-ascii?Q?udk0CBud5fk82uWj6yE5vEB830CNqeBh8l9JpfYFzR5LQKkxvnqj8ro06wud?=
 =?us-ascii?Q?GylF6W4JNPeVLiyPm5wJk8ibpyI1+1Tj/l+9RceebajQf1UrccBf4BjG7jay?=
 =?us-ascii?Q?FAsqiMG00Jr9Alx+m204cHrW+d3SE7ObGk7+gaB62RqIFyWdNjiLqcY3QINr?=
 =?us-ascii?Q?MDXFfJVZoM3mjuuymVg3GYzVQPEtEBtJnUIIjEs8F4OweZr0/Y79Fu0iAV/6?=
 =?us-ascii?Q?LO3FsQhle+8+HHXcyR/vHpBV+Fl4D7OqK3W+INvptSEyRNKxhQc1l9a5vG+4?=
 =?us-ascii?Q?5U6h?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a077a6-4864-4eff-b479-08d8b5d57835
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 02:06:12.1114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0qqlWQ0aoPkb0O/77uIvbdeFli0T5fs61zBKPB7Q0iQ45seJzB97jhiLGNPYZ0jFF9BP3l6GxxGOuu0r/ga7EgZ6/9Jxe3ZD7957GD/e3zU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5334
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/9/21 13:29, Pavel Begunkov wrote:=0A=
> On 09/01/2021 20:52, Chaitanya Kulkarni wrote:=0A=
>> On 1/9/21 12:40, Pavel Begunkov wrote:=0A=
>>> I expect you won't find any, but such little things can pile up=0A=
>>> into a not-easy-to-spot overhead over time.=0A=
>> That is what I suspected with the resulting assembly. The commit log=0A=
>> needs to document that there is no direct impact on the performance=0A=
> It's obvious that 3-4 extra mov $0 off(%reg) won't change performance=0A=
> but still hasn't been formally confirmed ...=0A=
This is obvious for you and me since we spent time into looking into=0A=
resulting assembly not every reviewer is expected to do that see [1].=0A=
>=0A=
>> which can be seen with this patch, but this is nice to have=0A=
> ... so if you don't mind, I won't be resending just for that.=0A=
As per commit log guidelines [1] you have to quantify the optimization.=0A=
=0A=
Since you cannot quantify the optimization modify the commit log explaining=
=0A=
that there is not significant performance benefit observe.=0A=
> -- Pavel Begunkov=0A=
[1] https://www.kernel.org/doc/html/v4.10/process/submitting-patches.html=
=0A=
