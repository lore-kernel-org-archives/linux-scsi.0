Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E602DC83007
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 06:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C04902076B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 06:49:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="UdChwq/W";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="YzLcYxLE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgD2Gth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 02:49:37 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:33564 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgD2Gth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 02:49:37 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7ADD9400B7;
        Wed, 29 Apr 2020 06:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1588142976; bh=RYxGGEj2u2rnj5h/5KUwDifzYlx65h9bt6dyazoqM3w=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=UdChwq/WPp4FjYt3gwj2OKItNzVq0xrJzkMm2jOug+Z2hWLgRkOAQIvEgpBN2Mz0a
         EryeHcL01xRPxRYFre9zclps3tLgCHnuzXy0qOQEW83txtYiyKfuj26eBcWTI9wDWS
         lF/9tmJN7LSzz2iAstGybOyIrIqAyH3zlSFrft0syOfNcrMKBG8ZZqo9CpLHn/R418
         bB+6ky/TPLGPh4XiMr0VE3a1thPgoOtuJ37QPvsmw78BfUHcJftr1piDDRt+Q/8Ryi
         U34OtetEO5ZuiwC4d+onvrlpTE8C6koHPXCL6aGwe3MTgvUEzntSne+1Tze718/rZL
         yvf2+nI/nyhhw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id EB249A008E;
        Wed, 29 Apr 2020 06:49:26 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 28 Apr 2020 23:49:11 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 28 Apr 2020 23:49:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7lxZgd6A7o/rCaBwgmeUVKhIJvq4j74VoBGjepgvVddbMfyPMwb3grpfeyE/IFFdLV6JF4KMqvYEMajy4QHhFB478htrCIO8zMKibPSmIB3sXVHzrWeIU64TUudvSuNI87Lik/TrJDZJ4E6rJDlowafnr48bTrCqhl54oW5vNw+ckVb4bE5lRgGVaksTKGEAIoISe2enyVT46jPNgjw9nbC3X6MemZaVww1+Let0BuGyYnaA88XugFAGiiCC0iLg8LTp0B0MRRQ6eJ5wfub1g6yYfH+V56wfzeJ5weK83AcNuD5DNExzIRYiF8xu8y+ZnNhY1XbY7eY3DJxdwp2IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgTFOBGtvDyfwJfmjmqG1+yE4zkRy/vgLA/LVes2y5s=;
 b=Mwxz+GTK7GEXdQE3F3Bay7YFgYklN7FhZmtIAhNq5+FT6V3eKFiQuU07R6TEJeF4W1myD6D3bilI2AFQdaso5Kb+tHNbn+Cj8fNJbW+IRsPMoOLRWcC6OC5KB2m9Z+4jAO0rsttgpuOnjiNJgLAMsSiIrw4pjb13PxnN17focLudS3CYjGEa36heCjR8uKBJmZV7ycBPCoG66GA2uJe/aZEYFLVFCXj/Db1ALtLhunb1On+ApB9IvczPTBX9JiJeQ8Sbmhuzie7rfbaK37hELpLTsqIY0WpQS4bxuS5ImssDVoAfrEWfFD7xS+nSP4NmwE6mNIIvAgTp5wD2NhVLkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgTFOBGtvDyfwJfmjmqG1+yE4zkRy/vgLA/LVes2y5s=;
 b=YzLcYxLEbYnyJWSGXzVbdetSmScRn5JHzbuygATnnjxG/6vA8r4pQbTwOtxsCL4EhrO7w1iHlfC3QaPdDCTDTZYBgvqtWMYKl/3V69Cttb7JlVnj7b/HKa629LmL5g8Rto7bfXzCBnBXBhvNaggBiHRxkAgXj/Wetl073OHRd1k=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3041.namprd12.prod.outlook.com (2603:10b6:408:46::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 06:49:09 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 06:49:09 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Topic: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Index: AQHWGj6lcVDTF+IaKE20nlDb1NNdr6iIbYWAgAdCRuA=
Date:   Wed, 29 Apr 2020 06:49:09 +0000
Message-ID: <BN8PR12MB3266D1F9B038EF821FA8D503D3AD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
 <c006813f8fc3052eef97d5216e4f31829d7cd10b.1587735561.git.Jose.Abreu@synopsys.com>
 <SN6PR08MB5693C397D88D16EC43E85490DBD00@SN6PR08MB5693.namprd08.prod.outlook.com>
In-Reply-To: <SN6PR08MB5693C397D88D16EC43E85490DBD00@SN6PR08MB5693.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: micron.com; dkim=none (message not signed)
 header.d=none;micron.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d0840c5-f206-4877-c6d4-08d7ec096b6a
x-ms-traffictypediagnostic: BN8PR12MB3041:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3041AFA119419723CDCEB223D3AD0@BN8PR12MB3041.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(39840400004)(346002)(396003)(366004)(66556008)(64756008)(66476007)(66946007)(110136005)(66446008)(4744005)(8936002)(8676002)(86362001)(186003)(316002)(52536014)(54906003)(4326008)(478600001)(5660300002)(33656002)(71200400001)(6506007)(9686003)(26005)(55016002)(2906002)(7696005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cng34zzhep+swBT8af++BDlRkWahPKLnZ+R3rVByxE4Ni4GA7dSYTGVK0fkH4pWFTW7jcnXQ2sNEjgCJ5ydxpKNQ45XJMWUEKrzxWmUPTa33b1xHqFCyaigMgkuhq4XsCU7SvOVOvlqM4+SShrb3erJi6QyyOr8Ix/8fhnTbFTxcIar5ZYRr7qmwTbu2UboXhhp+um86vCIgb/ftooh5cW25r6x6lZcWbVLHq+zq3CoUEivWoqVWk3a/G/Bp4YxIMX48fP3dBTNMT5lzmL7IPXLXSRvhfA6lXzkkBbjw65qGbEE43Zl7076mCrs+cJ4CPOQk4p9zB2B0UbaxGd8GJwyzuzBnaTfi1w1qu1xjfSz7S7/rKwbPWOPsQ9VNziqSsdWaOxckEqFLNHJdDB9kcJgZnJQe+jR6ybKWw9Sg9pFYedXisesjwdZkcOXanEAG
x-ms-exchange-antispam-messagedata: 5CrHFwFS9AeEINceAyS2YqJEH6PLcg4UzHsq1lAKUtGKhTLaIXDhvG1jr83355zvlTkLysNg5Y1TQCe9WdIBzFHNHW2d3A9rQ3zn4kARu0aIx/8+vbhoL++pBf9Q8bS4gFnroAN5tj/ze4HQx7q5O0Pass93gi4NEHSK1DvSmPO6RNgYCXSPjNBg+AfqEQ1EtdoYp0wxwl866UlYkbM2WMVZTdiqmWuL3E6N83DSUleJlKkYKutEqKJPy+dzhz4MFFDTtm4l8GdLa8snyhORlfyWneh05zwoNo5SuLbCwXFhUd6SwiGYBcD2C4A6HaVS9bMTsp5YijwfbjrGLwPdmaM/H75a2XMp4/7rZIwm4CKHl3VwnN2pzxKNgGZ7rlNG2it858dwFRuTMqAmnP+aerUXjI0l7H+j4fh/zjxisR22L15iZL3csg9BSCfw+KH8ww3/4fTe1jaU9T5H3P6+HpO1ECGuL8YhsMS7E/VT2Ak8iVmV5/JQXoR63vO3IMsEv57uTEd8Mt+3I4NcnI7mTBKq//0HSWwmfPr659GCQgcUSre+PlqQjc09hpwiujmVMzjqY791VYK4PAW+J7+NBqXFpgHDMPSsiODkbNENx+HeOCqemgbrovEPl1lD58jsU1I1HXZlSVZkJFIGFfhUTgCBBivqLaDN94dlW08nv/o5dqPH2Wos2BIokNhJKYhuSqAiBlM2XW9UsYGE9VmTv3oKaMehayPnKXABmzxHWONAMpzuN3Ly8aNgrP5Lve3d0o0aNj8TUKhHEUZjhJgFo5aMwPzkuhXPowrY/K3lgoU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0840c5-f206-4877-c6d4-08d7ec096b6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 06:49:09.5855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e8m/inskQGAK2eEbUnjuUEzQoHpPmdIL7Fu7bVAtAwJRsGlLU3d6O5ryxeRta6GqGN3rdwZiEqGWd5ZqQ5Rrjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3041
X-OriginatorOrg: synopsys.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo (beanhuo) <beanhuo@micron.com>
Date: Apr/24/2020, 16:57:07 (UTC+00:00)

> Hi, Jose
>=20
> > @@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> > *mmio_base, unsigned int irq)
> >  	if ((hba->ufs_version !=3D UFSHCI_VERSION_10) &&
> >  	    (hba->ufs_version !=3D UFSHCI_VERSION_11) &&
> >  	    (hba->ufs_version !=3D UFSHCI_VERSION_20) &&
> > -	    (hba->ufs_version !=3D UFSHCI_VERSION_21))
> > +	    (hba->ufs_version !=3D UFSHCI_VERSION_21) &&
> > +	    (hba->ufs_version !=3D UFSHCI_VERSION_30))
>=20
> I don't think these checkups of UFSHCI version is necessary,  does the UF=
SHCI have other version number except these?
> Is there somebody still v1.0 and v1.1?

Probably. I think we can leave them or change the dev_err to a dev_warn.=20
This way we have logs in case someone is using a non-supported version.

What do you think ?

---
Thanks,
Jose Miguel Abreu
