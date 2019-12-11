Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FEEC00454
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 13:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73DCC20836
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 13:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="b97Et81E";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tcTHlkZP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbfLKNoo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 08:44:44 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:14682 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfLKNoo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 08:44:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576071883; x=1607607883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=08r/6kSTUcHE5176MIN7Ad5BW9jE2WOcIol1zgTl9JI=;
  b=b97Et81E78JX/nR2WggWm9eIsUVBM/7V96rerXEF4euCPSkA8GFLxj3E
   zQiOihPMi57kcrPRhavrU5VJ5JqkSDsvaG574YDmGiM0/OXIoqjuta2d0
   JuC0hBuhtECNDvA1wMwizPBo+55NUnWgYkbEZRNJt+0mBt1Orbu3ouB5F
   dDupBsH64jef6Y8fXOqkUU+yKd/hoZxdcvTAwRdwbirFQ+i2+9zDUPzz4
   6QGsRWyvySvn1gUoq378dvv5QdAyiVTPpiXXuWgpdzgXCXT9VZYpj2oCI
   u1ByB+MjI8fp+g89eQg3ju3yiVN1qnibpruUlpyMx9KPoT9haA2gV+6WQ
   Q==;
IronPort-SDR: /7h9dDGyCNmLBWEqTlJatD62BdEyGnfuqShqPGj0b1bPOoYTUjbK9psjO56oFlU8cZYO2sxCLN
 +PZXegs/W3eh+nQB5AnD8b7W608brjQNJT4LnAP9CXlRqBI8hTdmznYN/BpK1HBlIlq+E/DfIl
 8iah3KD50SReGFk5+LaQMz39fU0Ef92muevnCqFVIRcqwDRqu4Sa1SL/48fP/ltZQ2gT5SUlv3
 9uO43VaLCfhQE8WgL6uKxGerTM8mCwljgiC81/gQgs72nNFLyw8qP588hJ4eIHaVe/Z4W8r7aG
 uFI=
X-IronPort-AV: E=Sophos;i="5.69,301,1571673600"; 
   d="scan'208";a="125095290"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
  by ob1.hgst.iphmx.com with ESMTP; 11 Dec 2019 21:44:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vvd+myRbMXk4tYttMn3FSNnHOE6eEqc1VZJMs1fBBEauc6t+vcRgFpd6+Lm5ZONCwc6gV+5E0s+J12G8eCqw5JJKn9cAtKwb3ib1eZLf1zjPELNlLEantcXHCfiEeX/Fc8Dm6Xr4SKKYcSiMWMYmINYEJBnt9OpG6KENVXVgc2Wn0G0e6wRpoCjIyicHSOhRYmdAaNjVwFPs3pX4TPy5OAVKW4sMViiXY7kg6vuct4RxX+Szu8s8j9uNa6iczi8GmuQCcGJus54XZdNxQx4jDozGOlWfbqCTnXHx/Gi6gUHBAjk5HFASUI7AlwnWCU0B+rKVC2SoWzPf1tkz9LXCEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSDP9P+JCOqDgWcSMC9XNenG3LcHvKbh64HBcEZ9XYU=;
 b=GQ2nZ6YbEZmDvR/DylBjzOytBAIwmRSIu6rKYY0tIVKwcr+iGKvVDXtrVEMe5WAa4taoMiruiZSsHguKLCyX4plqnyG7LQwnnMqaTMpOkGxxq38Ax6jghJ204V4CXBy6bqAMgB/DdsP5LdCgdhX/ln1QEPfxq+D1K8JTHZV2+8UHo9dHixf+cO8pwEn3YxWGgmOSaEkssdFuE6xSvi7ialz1iisvO0UOXSpv8qBPDN9C7R4ccExpt6jXNq/qpUnywx7G8lj/tzRC1vzaxlE/uobWJHFWb4JAgijSKcNJyTEf34B1yQ3navnfsMzpleB+7mCiwsNskpQm8OuzP2xiFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSDP9P+JCOqDgWcSMC9XNenG3LcHvKbh64HBcEZ9XYU=;
 b=tcTHlkZPuFfHlQuoUCscGSIeyrNksZUIzAQyEmEF5pm1eEFuc17fe5TNaW+0BhWlWASZZGuYsQNBfcz8IlXuyHLoFC9Ob06pRjKmYL6jjgk6DXMFogdsH3TbeAZcbLSsu1KWQonN5DACa0AelBfF5uebLnCvf9Q2nQRKft1y7iw=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5533.namprd04.prod.outlook.com (20.178.247.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 11 Dec 2019 13:44:41 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.012; Wed, 11 Dec 2019
 13:44:41 +0000
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
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: Put SCSI host after remove it
Thread-Topic: [PATCH v2 1/3] scsi: ufs: Put SCSI host after remove it
Thread-Index: AQHVr//RJYxYdS3dXUmhxTnGX2MLCqe0vdGQgAAIXgCAAANkQIAABwUAgAAhY6A=
Date:   Wed, 11 Dec 2019 13:44:40 +0000
Message-ID: <MN2PR04MB6991CC9F97E4AE9992F96A09FC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef4259a7c-76bdf010-88b1-4309-ba24-8c874734184e-000000@us-west-2.amazonses.com>
 <MN2PR04MB699184D76E7F9BABA923043AFC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016ef4a3e5f5-915372c8-5e1e-4db5-b3da-f97f7ca963e4-000000@us-west-2.amazonses.com>
 <MN2PR04MB6991754758E2840B6D529112FC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016ef4c6065b-3e4428fc-71f8-40cf-a7fa-bc633a2b9fda-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ef4c6065b-3e4428fc-71f8-40cf-a7fa-bc633a2b9fda-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 887b97b0-8898-41db-583a-08d77e4045da
x-ms-traffictypediagnostic: MN2PR04MB5533:
x-microsoft-antispam-prvs: <MN2PR04MB5533E33759C7FD721EB14AD5FC5A0@MN2PR04MB5533.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(199004)(189003)(81166006)(81156014)(2906002)(478600001)(8676002)(316002)(4326008)(8936002)(9686003)(86362001)(7696005)(53546011)(54906003)(6916009)(6506007)(5660300002)(55016002)(7416002)(66556008)(186003)(26005)(33656002)(76116006)(66946007)(4001150100001)(66446008)(52536014)(71200400001)(66476007)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5533;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xmq3uvacXpYs5nd72qhD57i4XuPd31uxliThdWuKJIYb1c9Q3ajbuWKr6caRsLDxM03pI1qOIw3J8tZ9fVzOg1er00l9GNMEFaPIbV4iw7Bakj82GCb4rayxONwCjA94dGqPesyVlS5mi/llzCyI4A2xqDN6C/R0Yi4ll31DkRXb/d7fbsrpy0Ey43Z50spclTJhrbODZQ3KsTWptk7rWNe1GpJLs4d0v10s5Nc3udFaH25MtEOMkoClvjb8mpXrtEAzkUs4v/7GIUkoOW3cYHmDkfTZgaA44LAtbGl7XM1Sp/kWc7inCK2AT3pz6BlYRplw+cBsq7M6Q0JBJvsKY84DNS8eLio2UF1ZY08yKAeGdXNPXEVUBHdzWiWak5O//iNBNvujstEKF9qtflRQe8w/bFT39vpNHc9hZ2IW1RzkuuPGVG7zrUmqxM+g4Pom
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 887b97b0-8898-41db-583a-08d77e4045da
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 13:44:40.9306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: srvY+REwMzvsWVnzWdpR04gd/844jq7XnqlEPrVdmozOKg1ug7MPV+5Q6cNbMULlB53cWo5p8nZPv6HPPEhTMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5533
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> On 2019-12-11 19:22, Avri Altman wrote:
> >>
> >>
> >> On 2019-12-11 18:37, Avri Altman wrote:
> >> >>
> >> >> In ufshcd_remove(), after SCSI host is removed, put it once so
> >> >> that its resources can be released.
> >> >>
> >> >> Signed-off-by: Can Guo <cang@codeaurora.org>
> >> >
> >> > This is not really part of this patchset, is it?
> >> >
> >>
> >> Hi Avri,
> >>
> >> I put this change in the same patchset due to #1. The main patch has
> >> dependency on it #2. Consider a scenario where platform driver is
> >> also compiled as a module, say ufs_qcom.ko.
> >>      In this case, we have two modules, ufs-qcom.ko and ufs-bsg.ko.
> >> If do insmod ufs-qcom.ko
> >>      then rmmod ufs-qcom.ko and do insmod ufs-qcom.ko again, without
> >> this change, because scsi
> >>      host was not release, the new scsi host will have a different
> >> host number, meaning
> >>      hba->host->host_no will be 1, but not 0. Now if do insmod
> >> ufs-bsg.ko now, the ufs-bsg dev
> >>      created in /dev/bsg/ will be ufs-bsg1, but not ufs-bsg0. If keep
> >> trying these operations,
> >>      the ufs-bsg device's name will be messed up. This change make
> >> sure after ufs- qcom.ko is removed
> >>      and installed back, its hba->host->host_no stays 0, so that
> >> ufs-bsg device name stays same.
> > Looks like we needed to manage the ufs-bsg nodes using an IDA, instead
> > of host_no?
> >
> >
>=20
> Marking one ufs-bsg dev with host_no still has its advantage. If we have =
more
> than one hba host, we can find the right ufs-bsgX dev by reading the sg/s=
d/bsg
> device's host->host_unique_id (through SCSI_IOCTL_GET_IDLUN for example).
> But If ufs-bsg has its own ID, we will lost this "mapping".
OK.
