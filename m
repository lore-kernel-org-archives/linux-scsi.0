Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5037C54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 07:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802C9214D8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 07:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="K8vdhN0S";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="TMw0CK5n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgD0Huj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:50:39 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:33396 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726243AbgD0Hui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 03:50:38 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E426AC0337;
        Mon, 27 Apr 2020 07:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587973837; bh=1C2HbxlT3dCL6gSFX9Ep3+IfwBkiHQXrhJ/z+tVQ7y0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=K8vdhN0SQhuqLV3uaj7djM7mTSawys2ZUftLvQix92egBQOOZ/POHGPa06n4LuUdE
         nrfRL96nqUMoZpQ8nAmPsCDHOQCi9n2IyHF56X4Q1UOlxq9Q+gLvd6TAHwsztz5m7k
         3TuXestaTgud9mvpEeA+2AKVJ6fJ/ITAs8b9SkaZXXvVUF8fjzKr88XX1HJIfVXy8e
         NueLWjSPu899VNlcPz+lptJJiEiHyt0ZGVhH9BYVyFCINCu1JVbSOsArevnbhvVF4D
         O+TsXqEflu1nPMjetwMtmzp7VCiXV3xPXq9qO6FRE+mbwmWvdFqhrWqgyq1i4B227Q
         eqcZ7sADihUJg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id ABCA6A0083;
        Mon, 27 Apr 2020 07:50:34 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 27 Apr 2020 00:50:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 27 Apr 2020 00:50:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRUWiH/uBahgfxuuNoBImMOZdNNhM2chRAvOhTiOhFjg4TYkdT0dZOvFVZM2YCsFFWysnC2EW7FeeQptRWOIk4BQe7ZhlUbfM++Q3OG0+0Asdkvu7ui93fStZo2DvWHRMkNcT56Nh5Eo1y1ikcEhWhqj5UDkg0tJk5mACUeCsoU9gjR66t3HRfM2BxlEki6k4mVDRUE2EhaUDtJDNyJE/arSEfmmaaXnnmEHAjLJYT4RVCCDxojYVFaCixTu2CVcpHX4OP4rdzt6xdFCXkD73QRmaJ5p37AKSbC+gtbbtywmEFrTK5FK9paj3/s2jufJRWkd+p7kMtknlhB8KJ4Q+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vz6JMz4t3XQjM816MpH69q8Jgd7TglftLFHWJcL7TFk=;
 b=N9Bkhk9Q+sK7+ucBNH6t6FPTH1IGVm/UtXKRO0RZFD2/C2E9CUJQlhb9vLd8l6w/8KOCXtaHPS2E/MT6LxtKpGZDR9v+5uV4xsB7sQ0FS1XuQ6LkI2sDDWg/WWFTN1GnZBdL58Aq3M6O9fiP8yQwZMIu1dja6zDxNTs5gN1CJ4Geb8Sr94Nvu5BbRpK8GWrEL8U/+PpZIcmPM8eA4GbbQQyo2ARgI+L09fjf3W+k4Hb0yzhqwIInzhUrpMLZ1LmC+NWLUYrqhHk4DomkxBUX54xX6lc0bpT47WqmzgYGXBpaHcZvwkQ0yyJ+HjPTFNHkALjnxp7YmzCjteENxk761w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vz6JMz4t3XQjM816MpH69q8Jgd7TglftLFHWJcL7TFk=;
 b=TMw0CK5nIUwz8i7v+7+lXNmt7C/UnB+lHXMluV0NFwhidSm/JriZ/nOPsemDSy1koDqX7WA8Q0C9+Zk1Qe+VTZhand5FnWPGweKkzfD/4P53X23kIJbxEurRrtCSLieSQiHBjqVz9OfwL0JsalIapMwlI1GQSuenj/oHMGNJilA=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3089.namprd12.prod.outlook.com (2603:10b6:408:40::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 07:50:32 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2937.023; Mon, 27 Apr 2020
 07:50:32 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Topic: [PATCH 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Index: AQHWGizK1kUc/ISWPkaEfUWaN7uIfKiJsAgAgALsH5A=
Date:   Mon, 27 Apr 2020 07:50:32 +0000
Message-ID: <BN8PR12MB3266F56D240A7BF0FC82B5B8D3AF0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
 <5c4281080538b74ca39cedb9112ffe71bf7a80b5.1587727756.git.Jose.Abreu@synopsys.com>
 <20200425111056.GA3384@infradead.org>
In-Reply-To: <20200425111056.GA3384@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ca30708-5687-4f18-c4b4-08d7ea7fa9e3
x-ms-traffictypediagnostic: BN8PR12MB3089:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB308940FBDF2EBD34D14BCF7ED3AF0@BN8PR12MB3089.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(396003)(366004)(346002)(376002)(136003)(54906003)(55016002)(2906002)(478600001)(9686003)(86362001)(5660300002)(6916009)(6506007)(26005)(66446008)(64756008)(71200400001)(33656002)(186003)(8936002)(81156014)(66946007)(76116006)(316002)(7696005)(4326008)(52536014)(66476007)(8676002)(66556008);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /aSGZ9m5k5RuPW19BRy0GpRWW4Qvh3Sx1lA8AQ9zpIu6jcxU5kKIn2fsnEl/OOl46rIGoHhWCxnnGctyzax4XVCxauPS1MwTa/yPu0dL2aAiSBG2UUUfuXxCWpMU3sk/SF08KiLQ9orZ37OUoZzM4SvM3q6ELlV/cNyHsJFoZsTd0LM30WQ7GFzTHd771qnDMGldvxBF7Nf+RD8HoTu4Its1bYpGOvV3rOOWBNu+B/tp0ARudI1p3EmVoms0ftNH0gU7bF4R99yVNkxzUAYkz+UqHeOjd+G/Xf9f+lyEFDG7fSS2lOP5FQM1zdhzL50RfcrD0+YOLa1oyw5IBjqVC+Bnw7lFR4Aw4MG5zs7VeWMcY2MRY9K/+AO9KtB2Ll8cfW13fqK61xEBRQ8KsLw3b+ApdcLFUtvO5LFMWEAffe1/qRfp/e06Ntei51E7AR1+
x-ms-exchange-antispam-messagedata: xNLtxVGIzhRNJJp5Gb/Sw+E0jdEtH6+x0n2gfIXnBZaLzO62jfTf6R54FnPTrmPAn79FK+a3sZ9iMrqldlpWCiNh9BH9T2CH5QA/Zntf0FkU8r1MAZVPcHXyGHAtIYXa1/p2zNPReOf+HTzvw3otAoxgyRIoWirkkJX07uSqvCx4MAXLnEaeZRlQFZ4oCMOnZu4vVG6i9uHu8wkX4sYI1HJ0HlgvSAuEuPE4a5hrZewBThpqct1xlcm31XPrseiTkg24mjLcpWRhIjOq9Nj5DSVRIYMM32E3e5hjKeYCeokFB7k987CH0Y1CcmtiXEKyF7WGey9oJC8gvbx410tIst/KXDXJcjWgJDy7uP/5/EZEcyRgwBiQnx0D8T/AoM5NH5kxRlxaeKt4vGJRLGzyoQYBaqkX2oY7qovwVKhzL3ePb1jAWeu6PuuyoW40VIvd7JlPxtgN7iLti9AJ1I6pK2YAcBxnkCa5u4qf3rsQNZD24Q+xf1YQ80dz2BmT5AdLa1hlQ44S0/e9CtfjNtLeNs4+a5WaaQwup/TSIWLXzd5GcZH+CBi2xDHg7VVTT/9WBTv8+yPEKLll8wfdFStQ5i3SGSVLI2tSp5gs4RHZzAdc9e2fKnTQjSJp3Wztf/ndXVOJ7RDHUfoW1K/SkUwKdpjyh0blkKV9YUE3PGIno3AwhYo/QifR8/J3JoVf3G1byavAJTXOMX0La2E9h1bWDuT/tx5//kefg2HINQSvRFlJNiTVOjTOWEfbDwZQ1Wr3qCC7PEHYBVRaXGNxwprN7jypXvX6Ll7LyY50yHTgYvM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca30708-5687-4f18-c4b4-08d7ea7fa9e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 07:50:32.7237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HG5qToh+K3uN0BzBZJmxwK4y9qLeQUvOmWRR/a3UXc4UrIAyG4zwH3PVeAD8W0eoemZhy5tQiW6QaK7ffM2eaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3089
X-OriginatorOrg: synopsys.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Apr/25/2020, 12:10:56 (UTC+00:00)

> On Fri, Apr 24, 2020 at 01:36:56PM +0200, Jose Abreu wrote:
> > Add a define for UFS version 3.0 and do not print an error message upon
> > probe when using this version.
>=20
> This doesn't really scale.  Version checks only make sense for a minimum
> supported version.  Rejecting newer versions is just a bad idea.
>=20
> > @@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
> >  	if ((hba->ufs_version !=3D UFSHCI_VERSION_10) &&
> >  	    (hba->ufs_version !=3D UFSHCI_VERSION_11) &&
> >  	    (hba->ufs_version !=3D UFSHCI_VERSION_20) &&
> > -	    (hba->ufs_version !=3D UFSHCI_VERSION_21))
> > +	    (hba->ufs_version !=3D UFSHCI_VERSION_21) &&
> > +	    (hba->ufs_version !=3D UFSHCI_VERSION_30))
>=20
> i.e. this should become
>=20
> 	if (hba->ufs_version < UFSHCI_VERSION_10)
>=20
> as an additional cleanup I think it makes more sense t use a UFSHCI_VER()
> macro similar to KERNEL_VERSION() or NVME_VS() instead of adding a new
> define for every version.

Yeah, unfortunately I don't think this can be done because of this:

enum {
	UFSHCI_VERSION_10 =3D 0x00010000, /* 1.0 */
	UFSHCI_VERSION_11 =3D 0x00010100, /* 1.1 */
	UFSHCI_VERSION_20 =3D 0x00000200, /* 2.0 */
	UFSHCI_VERSION_21 =3D 0x00000210, /* 2.1 */
};

So, version 1.0 and 1.1 have higher values of 2.0 and 2.1 in terms of=20
absolute value.

---
Thanks,
Jose Miguel Abreu
