Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4A6C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080A320815
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jeWyFsPn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="M0cx9G1m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfKYHpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 02:45:07 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10348 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfKYHpH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 02:45:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574667907; x=1606203907;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=veR5xcsh46CAFCSGHhbKyQjYagkOVqrWozEmXOW5TIk=;
  b=jeWyFsPnq4tzwRis9xZqQDnynsV6OCTh1wQ6HKUS9grdhGjhtundgEF7
   3jlp8JKMABbi7+etRCFr5YpfsYCNK3KVvrwsk8QwUxVYMpi37fG2BogVr
   ZFTgDzN36P25/P5ddFAxAVl7279Dde4pUduO8HvD0t047UAToSg9MUSFR
   Wfym1qak4bx98RqUVMPFDSuor7D3M2Q/2b3GmSZ6LCvpHUyHbJgD73TW0
   cZrLc6MyiTMK2zEPEE9NxVNtorqtNUZxKHOA0CAWRugoAlrxcnrtyMVXQ
   kY82pAvACytJ+ycOOG0/xv0ny9wJ+65wpZILsHGF2sGXaYwh6bnSS1Afl
   g==;
IronPort-SDR: REp4/Egt//ZzzfmY0NRy6+lvPfbbRUBHqApR4XE67Ffhjkv/XbG50KC52ky4cwrmpvBQlCrdwr
 22IAuhUAswg062TEWqCLx0O7YTe7fGf3/+W003grf9biwfROtVmNg3410e5XllqViJQsXqkOoP
 gfJctgpQ10lRsCLWtJ5amrPM0hod5WDq5PXYi7JaixuZ0MrOX0a8n6F/RFntj5I2s3IYTd37VC
 6ejLMQ0bpWq5443ZAoDcbIlj52CrfGkY00HBzacveSgwTOAQ2doQVb3Qh5gkspTv/QPvjeAi3E
 2kk=
X-IronPort-AV: E=Sophos;i="5.69,240,1571673600"; 
   d="scan'208";a="125523470"
Received: from mail-bn3nam01lp2059.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.59])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2019 15:45:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOQY7wVQU0q1q1kmnXvMMbKBdxfjyvDBtqC5hd4S58JcKh41RPWzEZ3POAtXaMZV7DNeE9KMCSFDAW1yoySheIsP83r5RkP/MWBtPlk8NRpZjBqRuh4F2FE097gLnqZMacs+fhcrUF4/AnLw7S59LWOhlNq5kAz/x0HOV1CTfOhtIvqAqNiYHKzf45PllqCvfHWQ0F2xZuKsoGj8gSOMh6MUZ3iW5e6mzbTM2VtHFrjtoPn0sJCijUOFalsYZAHU4WjA46KjwzRG7hk+ddkce135RVe0BwEiFJpLCifBY3q7p6p9QjR4hUgUlHLhNGUknK/vVW7SiY12WEL1y8gY/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veR5xcsh46CAFCSGHhbKyQjYagkOVqrWozEmXOW5TIk=;
 b=oDj1Sio/Dvh7O2cjrFQ9bmiOKCHCVmajIJkqHmRCTVlRiHTu0MDY150ErEJEnO80ifBMPoYOFTtM3vFHlYG83fvyHnErZ2XQMcfa5R+YrxGa8Ts+9sdgIcKQ17alRBbK5lbMwJoCnK1QBhkRu4SCuW8tKSbyr/QzkKT3tgd3uWmmIjLuiFctYXb4gZNIoWAcWYmqQrz1We5PAymD8Oj3UoK+EMmunrcu2GgwPmO6R1Yd8Tkni0y5pYdcdSkAlOOm9ZpRJEzvigW0R6NHvlRD9eJYmodJWdzvykEJ+0pBDBxe7Lve01eHY6kepHWm5hbHdUQ8hKMb8s/cKQkexHEETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veR5xcsh46CAFCSGHhbKyQjYagkOVqrWozEmXOW5TIk=;
 b=M0cx9G1mceMjmhX4MeE6MEBSycsbmeQ7KBqQ9/vRRytpL6jMZWY9B6uoWLSrowMIj0D296Xq/wwXg2lBNgeHAJW5io1bjIrAvwZaqDmn4KuNJBC1pRVFCC3COozHwepYdYJpQkxkyo6JA6kqt6Ya/ujONlNJeymrz9hkZofZ/tY=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5662.namprd04.prod.outlook.com (20.179.20.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.22; Mon, 25 Nov 2019 07:45:03 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 07:45:03 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 5/5] scsi: ufs: Do not free irq in suspend
Thread-Topic: [PATCH v4 5/5] scsi: ufs: Do not free irq in suspend
Thread-Index: AQHVmee9U/BswetsqkSHgDuGmRZmjqeUO0QQgAdZC4CAAAAzMA==
Date:   Mon, 25 Nov 2019 07:45:02 +0000
Message-ID: <MN2PR04MB6991EB241D59FD4221CDA65FFC4A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-6-git-send-email-cang@codeaurora.org>
 <MN2PR04MB69913C6C9ED425F99302D870FC4F0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016ea18429ac-d170e670-bde4-4769-a6c1-6767fae70534-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ea18429ac-d170e670-bde4-4769-a6c1-6767fae70534-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 41558e4d-4c16-4d1b-b925-08d7717b61bd
x-ms-traffictypediagnostic: MN2PR04MB5662:
x-microsoft-antispam-prvs: <MN2PR04MB56623E53C6DBD7EF68CF4ABBFC4A0@MN2PR04MB5662.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(199004)(189003)(5640700003)(54906003)(316002)(99286004)(478600001)(2501003)(11346002)(4001150100001)(14454004)(446003)(6916009)(14444005)(25786009)(256004)(186003)(2906002)(15650500001)(81156014)(81166006)(8936002)(53546011)(76176011)(66946007)(66476007)(9686003)(7696005)(66556008)(64756008)(66446008)(33656002)(7736002)(305945005)(55016002)(3846002)(6116002)(6506007)(6246003)(26005)(7416002)(2351001)(4326008)(52536014)(76116006)(71200400001)(102836004)(66066001)(229853002)(6436002)(74316002)(71190400001)(5660300002)(86362001)(8676002)(1730700003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5662;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?oDRpCTDoWI905nMEClP0xqj3aWACBIKKMRvmthcc26spIF1e4oo+fxeULze9?=
 =?us-ascii?Q?Wm/GNYc09wSD0l56sVxloSLjER2WZ38XokypHd6ZgFAwpS2szXaZ/eM8rfcS?=
 =?us-ascii?Q?0KidD4trJqWcp1WCZXy7NQkTQ2qi88R33I+cp3AMzAvgMo9B8GaWcD5PlWl7?=
 =?us-ascii?Q?yPdyX7WueO9KAbBtqWO72VjJ+ExT/qPqe+BEIocTIETOKh7FUVBQxObBOWXN?=
 =?us-ascii?Q?Lkj+EppLqRyMd4Qi3MKxzYfw2GEk2PHIViXj9u9i1GSsd/N4gZ72HDeWYzj7?=
 =?us-ascii?Q?IoOpRebTnRpnPrZZNOQXpoFxaZ4vWrzbaCPi5HD6EqaHFfGP0BdN9H5YNU5i?=
 =?us-ascii?Q?opAVr7WjXcTeSL9y8hb+pkqNPaWyPgWWAXXhceHURTu9O3J9K8FUJkFul02K?=
 =?us-ascii?Q?Cn9RWpmPemx6QzERIz03k8Znqh1B3+GTT/vkujvmCoUrgTOg5wmw3/d0dyB6?=
 =?us-ascii?Q?aPhKmaCW3mVcAgB4rON1QgMoEjeC2usvS7mk5blMa5MkHygOtdSNlobT9wUI?=
 =?us-ascii?Q?4BNQPP8Eh4MAO5KVkMXAga7EGhum3tXMhlf1vC6SCH4ME5yM5RrlotUtxyky?=
 =?us-ascii?Q?x3ZRiKEdLNX3om99TI4CuVZgxxb+jhlPMFU9bEy4XX9ZZgyR+ugqYtfC7FSE?=
 =?us-ascii?Q?1S8irubDxbvLlqU/EJOjDeFvhRuPEBcdX+vUd8Q/pZnE63dtsa5dPS2RxuKy?=
 =?us-ascii?Q?zJ/nWjk/7lQzvcm7HkdjGLSlDZODQhhasYRcrl0t1r7GkfvOPAvbv5opJdC0?=
 =?us-ascii?Q?nHeQNM4H41f54V+zZNOb4SiQe1dBtxxAgrZNfoGYl2XNChTgypYgiYC9u0Mf?=
 =?us-ascii?Q?pa+MQNWBN0CJpBHKgxA+oDT3XAL3WELq1V+LFaQ2HxdGAjx6s1z4XTcvMs9a?=
 =?us-ascii?Q?MiqUH9GPASSGczcS3lRYjzr3PDx0Sv6kO3vHQzLoyrnrLiqMZnrs7PP9VAae?=
 =?us-ascii?Q?lirbfjbNPKeuk3MFH+AMpUkDLmOUoe7ik0mwNbdJXHSpaVlq5fqfDMyFOozW?=
 =?us-ascii?Q?L27eW3cejK9jf1fEDUceQpxoHLb1MAqmBoPPMWl1BnP6BwbiE1DnQr0xjM3c?=
 =?us-ascii?Q?pmbrxnE5LdDXcOlz+tISpKpSTEqM6YHVlZZmt2wOpdSfmNSlfcyjbZHBYl+l?=
 =?us-ascii?Q?qBYKk95tTg/HmwiqYtk3XjZ6YauwKtW8IXtALRAxew8o9OCvtsSWmiL53436?=
 =?us-ascii?Q?Fqi1O73MqmBDUpAjWUuRkk9WNPRjLXC8CU4etM/OX4eSibZ5TNxf00r9rf0S?=
 =?us-ascii?Q?9SShZwniPUFq0WzNEeewyYYNZ5cNIP45Nw5YnltbWDJdj2zWWhUR1V97nL7f?=
 =?us-ascii?Q?kjMEPmcIoGmmPLP67hHsefluvFzzARaw1zUbrUMOEXi0ERKGjBdqyiM27vh1?=
 =?us-ascii?Q?/ZrbEVtFcwFEhm46qhkW4ONzZPuUZy/qv+MNkire2XZNJ8dvGs/wYwn29E/C?=
 =?us-ascii?Q?pKHeLuuNbK7mrbu0LgzRi7xl3/aGdrKvKrp5rD8vv0ZPN8Fcb6mZVDbzTYYJ?=
 =?us-ascii?Q?EDH0ZjDV0bvrBj8O8Z8q1E3+fbfOdh2YePTuL84TptEfpKEQ7qgtpEAXuyQ7?=
 =?us-ascii?Q?gMds9BkuTusADG2MFPpFw75ORSQguMJI1XUM0m7E7m/JgtF7EIXYw3OsSgm+?=
 =?us-ascii?Q?9DVX99wOxe+9JIDnKRshjgw0yHgfTd9VCpnI80kQovhanWcSH1u68lUl5kYE?=
 =?us-ascii?Q?y2aDeL8FMoMdUG4StVfM3Cp0OB9rLFJG1/d29SMU/+8NQ+SKMoNeMm4exa64?=
 =?us-ascii?Q?fcnxmO9PYWjrJLLe+/mNxGhmir4sjeVFDIcLhc9M9Xjw28nxgl7rC/1MKhhV?=
 =?us-ascii?Q?hN3lIMjNYfROEpToiA9c4Cfu6OFLvBXSeUI0C5asVRq8OQVgN7o+kdgz9+5F?=
 =?us-ascii?Q?hw9A+NIGoerXOoYpgcaMiykoBGU28ARFiH8sq/mvTfaxhmbx03/khd5agRHE?=
 =?us-ascii?Q?x08ZFbeQMtqFSAdc+9E7dg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41558e4d-4c16-4d1b-b925-08d7717b61bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 07:45:03.0058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ebvx7kgw33qQMeea/JuMaqSQQFGoOlNrimVcHiLsLyEF6G5TsbELkDlY8knzl4QVe13VXtfDb0MJ9/wEc1kPXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5662
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> On 2019-11-20 23:36, Avri Altman wrote:
> >>
> >> If PM QoS is enabled and we set request type to PM_QOS_REQ_AFFINE_IRQ
> >> then freeing up the irq makes the free_irq() print out warning with
> >> call stack.
> >> We don't really need to free up irq during suspend, disabling it
> >> during suspend and reenabling it during resume should be good enough.
> >>
> >> Signed-off-by: Can Guo <cang@codeaurora.org>
> > Your approach seems reasonable,
> > However I failed to locate in the kernel PM_QOS_REQ_AFFINE_IRQ, Just
> > in codeaurora.
> >
> > Is the WARN_ON in free_irq still applies?
> >
> > Thanks,
> > Avri
>=20
> Hi Avri,
>=20
> Thanks for pointing. It seems PM_QOS_REQ_AFFINE_IRQ is not present on
> upstream yet. But this change is still applicable.
> How about changing the commit message to below?
>=20
> "Since ufshcd irq resource is allocated with the device resource manageme=
nt
> aware IRQ request implementation, we don't really need to free up irq dur=
ing
> suspend, disabling it during suspend and reenabling it during resume shou=
ld be
> good enough."

Looks good to me.
Thanks,
Avri

>=20
> Thanks,
> Can Guo
