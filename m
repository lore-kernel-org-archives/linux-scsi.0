Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBAAC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 05:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91FD564F3B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 05:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhCLFvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 00:51:24 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:20640 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhCLFvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 00:51:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615528266; x=1647064266;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uQzitpQuZZN6zT9EtZPuj7k9okIcwzzW49DnhDjX10Y=;
  b=lZGYktBvVJ0w+g7TA5E70lRapuGnTi0PnxjRZm1u23GfwOtaXzggz+KE
   svm3iRvWodftpxXtP/J2htkcPJab89MPT73JbFDnoyUeTDQtSjqnKL/YH
   rvIKmx924iJ/RFv6MknHFYVMiuDn/oqlLcsL0DjC/5+bsmvM4U+Hl3qgE
   sZz9xktC+z8hyKBhShVXJi3cNmLS+IpmyvnhBVSgy347D5adBthdk7Qzq
   MYTBgVl7DK+fl3ASFYDjw1yJeAsx+QoG6l4RthaZj9LypEpLzTrwMuiL+
   4uULh1RlQvXL/v509i4MdNWKv+PRIOG9LcxGq7jugDnR2HvzlEHzwJZeb
   g==;
IronPort-SDR: WTf0jpBQ3KInbC+7NJsGlLA8bo644Cf1lk7Z2gNpD0p+eN8EJEGwyEtaCiPHv27muT/le7rCQf
 kwQ8PiANjBtaG+KfCw51NSry0PTyHwu/sz0Cwrb+e4iu4gIlEuKSfDmJyEXg5bNZlt1+RS3hiZ
 /hcqzt1NQoJjy1lRJn0LypZwC7DGhmQD/aWD3v8W7KxOaMNsOHf0be0rQGEueYtTofS5ovgExI
 ifBUnBVfd19uoRkXcFz3hNV2tVxJveUO2UbV25ErmFcOUiY9MlGkME6TkhXuoCmhO5vcgof+vT
 ndU=
X-IronPort-AV: E=Sophos;i="5.81,242,1610380800"; 
   d="scan'208";a="163138300"
Received: from mail-bl2nam02lp2050.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.50])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 13:51:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoeTN+47vKXoPYl+67Jh6XioDRFZxIoMNfC0bJ7rQ56+s2bL/oZpPDEMj1MggKg4D+vZj+t6728EtTQE/ROoJWmAzL+Ohs2RdvHUTr/bw3KL+a/Pp4axqo7YMCAP+KzCNcyrHOfYpVOBTPG6f/CV10+iSmpcWoZVWu7c3yhUt08IwipvMEOBMAwWMRx10PHhhbCv1Yswr9KyZguS0JuS3y3SLpCtZIIhBldESJO1jwE8WjySyp2dABucDMVdjH7s42gGUtHc5CnQ2mlglxv+Gj3VHE8qgU0eXbFtXgc5sjY4+fWncF9oQKflCPcf6tynsmVEmqv9azWxgaHGavDlQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQzitpQuZZN6zT9EtZPuj7k9okIcwzzW49DnhDjX10Y=;
 b=SQ4F+LJTC+BPXrMv3WtWs5LQATISiKdzmpe7NB4l33kcSMteLxF32VDChhumswoSZrkmCjwBiPnYOQean7Ddjbk22krGTrs+UpB/zT0dNCDdvqPgBi+phdphC0jiUybQtwHP8Jktefpqgm7o0axiVvG2EnrZv2rHeb68AQ8Ofin80/UmIyxwgH3JLDqbaRWFPTw92nIruw5LmplxZLAezLkFXpmiz5OrTt7KNKu/Vt48Dbw1Fs/iWyYfec5XNR6bBybzcdwvYnhfMtFQKvL4R9HS2/x2oQcmC11JHMh5f74K3I0gFLl0vp0yW4T/O3mhIZT6n7nV1lGh6BxhZhZddQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQzitpQuZZN6zT9EtZPuj7k9okIcwzzW49DnhDjX10Y=;
 b=u8u7ovE9b1ZL1/Om2vKaxHiR4bBZ8LmK5KbQGv4MAqd6/+m8i2qGtvkyNom4mfkVBgCBZr6kWTFxekHHI47qO0Eu9Waa6pfjPqG660Ke+//XNWZvVBPP/lVO2xjBJssfttYt8IpTaCfl05C7bUnv3fgyBO0pxyup+mfGZFY4nIY=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 05:51:03 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 05:51:03 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Fri, 12 Mar 2021 05:51:02 +0000
Message-ID: <PH0PR04MB7416F2CBA2F6E02CDF871C6A9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:5840:9cdd:b1cc:ef31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e9da1be3-a31a-4f17-727f-08d8e51ad223
x-ms-traffictypediagnostic: PH0PR04MB7416:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB741646BB92EDEA8A493823CF9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: soaFTZMCx2iQ7CSpbvYWOLPQXkLl8fv4oQYeE6+um+EqfIApJ6OlkDWYrypwDNprwnhlmRC/f5owmIk+DfMHGvhOfiA8/+1ZfltoeSWW9I4+ci3dxetvSXZubo7uyq9ZeWLMaFDU2AFvarg+7/5E6rrcHeHXL7zpI/MVHs2+QzZGnN6uU52Uwui6qCUNVeLnNPDxdon24TJ0emxfAm83/k1jfletPtggkbvxYOww3Y3zVGb8BcoLp0VUZEzPtqANGyOUg2O3EpO7F+mgp7APPYkXPMerkPfU573RIE4RJeqpyF3l2gSQJ7s+RB45dg0ZMOXfzO5hVlpN1VZUB8py2sd9L7u1XJWCyIqLnDq40QajZrfHvqZI1qS9hQkxeZ9lQbY8EGtHwfFIuo6MKx8kuHq5znCmaaNbtPT400PA4xw+nMkJbPDZqUULhEnF7wGMdF8dQPRtMZ/CG2Gs8F/yVJ42xrfGLSKlP459c+FmQUPzZ6rF7+UKL8yfSVJRt7eGBWYIJSomXO+wYcIT0kbqCf9ZgiFf9MZtHIxiX0oWhMz6aYD05xsLiI+AnYal2lQY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(8936002)(76116006)(91956017)(4744005)(316002)(83380400001)(71200400001)(9686003)(86362001)(55016002)(4326008)(52536014)(53546011)(478600001)(186003)(66946007)(6862004)(66556008)(33656002)(64756008)(54906003)(66476007)(2906002)(6636002)(8676002)(66446008)(6506007)(5660300002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QzXrHczq2rwxV0VVEm/Zdchx8ho4B6ESiyjZqlGDlfwAQsCvp40FMOKDwG55?=
 =?us-ascii?Q?+HeHAXnj/Rf5398mtQ3HLSAhVAJj85K0aksfQsMiSNEsMNfw4Y1wBKuCJR3b?=
 =?us-ascii?Q?VD/kxKvj+rYwHzn1x8zogKfjEEPDKBH7zTE2Q7nqnadU44/aooeYhDW+oDaQ?=
 =?us-ascii?Q?f1ApDp9gFWSQUI4zCi4DWzUk4MM6PJ7fBlOS1ant0oqaQ/xizq6Tpqk+Ws0W?=
 =?us-ascii?Q?Rk/g49l77c9adbwGoMdS1LgQvy8Wy7KJfubrG1LcOt62P3oouBq7dKzcUrYA?=
 =?us-ascii?Q?WU2O0wEz/eZWYnhz1iE6Z8Mr7fsKtSaFUAsYGEGKnoOkGeFUNBISkDe4wS+h?=
 =?us-ascii?Q?sURHe2gHUeS1v0FoUARFfXpwqHt4pU8lZP32c7XpDqnIz2lq2gEtb3h7/FWT?=
 =?us-ascii?Q?fzenP5spSjqApX88sBDwn1dD4lCpSZn3AHUgV/xX0bZIhQvq1SZBFvTY+Jee?=
 =?us-ascii?Q?L1OA9nMzPZtKnT4X4IdRzRzWZyESg9Neu4Ac7pG6wjASez1J8kf0kI64yMRG?=
 =?us-ascii?Q?f0007p+br9IUZgBuLhzsWvCH59uk8bnsBJ7hkd578+w3ZnHavCZx9KHmkjAS?=
 =?us-ascii?Q?VuLv1JjlPq0oyNJZpBQ7I9i/dIHxPi1NlRFRui4uO2cuq5HYYkk3RyCp4BSV?=
 =?us-ascii?Q?p8gYDy1nx+hFBhGgujV9QxGg4p7BuPnpVetitVS1TMrwEuUfQqzEaLZcsjqi?=
 =?us-ascii?Q?QMgYiP+2VEWHEJpbnXFpA1aUb67uISlPDPqRpiw4vYCSW9MKxcMVH4LXk+Sq?=
 =?us-ascii?Q?0PUdUxQFlqIs+/LQhJ32C/dFXBcwZsi/TwF39cWL09nmptmmNGy89bn/Kp9G?=
 =?us-ascii?Q?Vna2xEKdMiAVDgd72BPl8ndZW/zJrqrmonmXLkBjZmcmHKoP6Sirk9UCu/6C?=
 =?us-ascii?Q?H8Gt8A0AsOicGQmaUhILDmLH12VIyIed0LPfM/BpFMBN6IIhTCFFoRU1qur3?=
 =?us-ascii?Q?IS3xYdnYlC1QxMK3fzexGrKRvHxJvInQcRrgfoOhUVcaczr+mvjIjFjTS/FN?=
 =?us-ascii?Q?p16qz2lbHQVHgRWUh94ySTVHkEPmMl0uWPyMH8X2PKa9IgBUmjsjpSG1f/Jc?=
 =?us-ascii?Q?tb0U94XckEGbZi2tdCEnLFau1u7KyZ8ljQNxP7dxWE/oKY2N+rCmdALrjW8f?=
 =?us-ascii?Q?ufO6uK48E9uKcuvhpTgsm+9mnPwFA82LzLHH//m/yxQKDOSgskYR0qxeP1pq?=
 =?us-ascii?Q?1buEsfzhwezNjWdmR80stDVpTjh7+Jnn+Fh/DZ6ltoUcJt89SU1OWrw/3Bvn?=
 =?us-ascii?Q?vcZX/dhOAIYyP3UWZhiRifSFnqABXyVnXTgygcYm1vssWS/CnuQtToI2QuwN?=
 =?us-ascii?Q?hLMgcBZHoJTpmJwUC7TR4KDqY3wZ573mG2CEy94/V1Xy+0uS642hxeTWCA2t?=
 =?us-ascii?Q?rsqWnhffJY1MjZgTgx5sDgfb7nrXW1sIa3OwI7aG2CwIcVIvyA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9da1be3-a31a-4f17-727f-08d8e51ad223
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 05:51:02.8900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6zPNfeYkFufSo1GPlbMsowT6/fcwW1vVvd+rWGLD8PDCpbjQF1ftLOuEfr+4v6jeWS6ZQdEH6zPARbXN+KoMTwXQXL+Nc+JUeK5ptdG4gPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7416
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/03/2021 05:38, Shinichiro Kawasaki wrote:=0A=
> The WARNING was found in kernel v5.12-rc2 test with a SAS SMR drive and H=
BA=0A=
> Broadcom 9400. It can be recreated by running blktests block/004 on the d=
rive=0A=
> (after reboot). It is also recreated with SATA SMR drive with the HBA, bu=
t not=0A=
> observed with SATA drives connected to AHCI.=0A=
> =0A=
> I reverted the commit 664f0dce2058, then the WARNING disappeared. I suppo=
se=0A=
> it indicates that the commit changed HBA driver behavior.=0A=
=0A=
=0A=
Alright then it's:=0A=
Fixes: 664f0dce2058 ("scsi: mpt3sas: Add support for shared host tagset for=
 CPU hotplug")=0A=
=0A=
Martin, can you pick it up for the fixes queue?=0A=
