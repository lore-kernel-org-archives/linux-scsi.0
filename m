Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABFCC54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 15:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 276F2206CD
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 15:57:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="ZJ0Yq5Lu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgDXP5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 11:57:11 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:6057
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727050AbgDXP5K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 11:57:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCvGmF+TyADEL0qPCoCO+QirhePKWf2RVeWaeuyfxl3TRF/8/f9Aez8V1/B069cYGpFsv3R8ZtZAWKsdeG+ZiluOUmhA7Wi9G7zIVbrjYJ8K8eSPLhfBeGCQmO7miOumnshP556BvxdBk4jFGOj39GI/TMt4yM5LfAdtmVcsZN8Hr/ZzD2iWeksgwf+lD0UVj0p+mjOAsWOZkXxwkINqtijQbg0eO4fnpwkC8z/vntcxvyIJQsUmWO1ChMqlCQ6DR2hI7hkT/kctjtFYc2DFu1jaUVLZxn90fvLIm50pYW9uOHMJQ22InAxyXNyIUExIe9qO9zOB80FM6tSAkIuVig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W01EC5/z1kilm8YM/Gbru8Kwc8Qz2Q5lBMqMUZB/6I=;
 b=OtLjf8peTGLSe8eueyQsQE/k0P3xBGz1LZ6dSxUu9E6Gr498GcVLuf+0Kf4Tn1bc7+Z+q9u+C62//05surhg42SxmiTGX56f0pO/A+tD8AnqBeC/RLTwxH/Ha3NZ+xUUXWrnC/+F2yzlOpiuCQXKHoSEpzrw+fZTjR2kJMnAYMXObquAD9Ccn1xfHWAyH1tqe8c/IyuqE6YHPG0ZYYh/n1CTbG0sNoCkzqRfAJxhkaxbWbzqB6PNf+R/fyB/QtOAlepZrh1JDZyx+tAxs1z7vSOS6yIf6HbAsxUCaHZvM4H+yLRwt6qU/IVl6mkAOUK1OEDRwlSFJ1Gl0XX7/3ALHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W01EC5/z1kilm8YM/Gbru8Kwc8Qz2Q5lBMqMUZB/6I=;
 b=ZJ0Yq5LuoruMR/Yf+LARMLZiEyJKEkcQOTOeRhjuBHH2/q5SetDA4eJhPD9ASZ60rQeF6tvDPMXm4kRvlNP3IHZZKPlN5kotKvss5agGH5wGSvjDM1NTTH0MTM7cmQnvdRTn79o29nNH5HRNyQ3+lBqOn8izOMNiFNbNlWQ7AeY=
Received: from SN6PR08MB5693.namprd08.prod.outlook.com (2603:10b6:805:f8::33)
 by SN6PR08MB5072.namprd08.prod.outlook.com (2603:10b6:805:78::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Fri, 24 Apr
 2020 15:57:08 +0000
Received: from SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::cca2:ac08:1fe6:732e]) by SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::cca2:ac08:1fe6:732e%6]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 15:57:08 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Topic: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Index: AQHWGj6R0nTpmn6fGEWz3ZvyHz0xNaiIaq7A
Date:   Fri, 24 Apr 2020 15:57:07 +0000
Message-ID: <SN6PR08MB5693C397D88D16EC43E85490DBD00@SN6PR08MB5693.namprd08.prod.outlook.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
 <c006813f8fc3052eef97d5216e4f31829d7cd10b.1587735561.git.Jose.Abreu@synopsys.com>
In-Reply-To: <c006813f8fc3052eef97d5216e4f31829d7cd10b.1587735561.git.Jose.Abreu@synopsys.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTNjNzU0MTJjLTg2NDQtMTFlYS04YjkyLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwzYzc1NDEyZC04NjQ0LTExZWEtOGI5Mi1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9Ijk1NCIgdD0iMTMyMzIyMTc0MjI5NTQ2NTMwIiBoPSJxNys0MDIwTmNmY1oyeHdKVnBhaFVvNlhWRmM9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUFpQnR6K1VCcldBZUZZWTFBbUtDMjA0VmhqVUNZb0xiUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQWYzT0VLUUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f760825-f4ad-4215-e82c-08d7e868245d
x-ms-traffictypediagnostic: SN6PR08MB5072:|SN6PR08MB5072:|SN6PR08MB5072:
x-microsoft-antispam-prvs: <SN6PR08MB50728FA33E29D061795D5550DBD00@SN6PR08MB5072.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR08MB5693.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(7696005)(81156014)(26005)(6506007)(71200400001)(8676002)(4326008)(316002)(186003)(8936002)(55236004)(33656002)(478600001)(86362001)(52536014)(66946007)(76116006)(64756008)(9686003)(66476007)(66446008)(66556008)(2906002)(4744005)(5660300002)(54906003)(55016002)(110136005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iwAz+eYjFSQ/AYuthL+j4LYuZ5B0tVuNl1MabNVXeV7BcQM11fol+VGu5ajuFABKxViYGn7Q1Yc5/RKFMyjgbw4ThRMzxiyLEPFozU3UPgcwK70uuN/2puewOXMQOMF+IzC+UrH/pJgbM8wjEcJTkLlef2FLJMtEaw8oHyWDftibcsI1N9ciFoQQrUO8jvsy4XMJq25Qt2TYxL5btS2EE0eFxpZ5OuOoNa/hiQbKYBOHWGu9iVXK72+x7D6RssbhAfGAcLHeJsiAvutPgYGvcxPLkPSJvQ4iG+DOKurmGcun6J93sN3nYPayV6bqkNDSEQ5PZ2e70ytdDMIFNQWsm7onrRbSVFQBYd/7v5lHxiVnWCoG02f/GC3XEfhTn22CrS+quubcgF7EBbiYPsnsJ/aGm6BnSLQa9TJOXdnJisu09GLNhEF7QvoEJjYn9/TL
x-ms-exchange-antispam-messagedata: LjpujA2SSCsJbNzI8/KA9ViCleT4B+YvJPUDdl29FZxeB80A0CrbDKekrNrcA00BQ2SvO7Bhyfep2ToHmdnKo0Ia4vr2Klgk6vWiOP7ImXB30NHIzuymrz2wdTl0C5lp4f3G6ZdQR0lxTIiztWpDsw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f760825-f4ad-4215-e82c-08d7e868245d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 15:57:07.8712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9cGRMcmQSVx+XHnZ1VH1Od1ut0od6D//5adIvBi3eXHnKlHiYBmBYS4SPJRWMbBy1pSnY+fNCi77vnSHGgerw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR08MB5072
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Jose

> @@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>  	if ((hba->ufs_version !=3D UFSHCI_VERSION_10) &&
>  	    (hba->ufs_version !=3D UFSHCI_VERSION_11) &&
>  	    (hba->ufs_version !=3D UFSHCI_VERSION_20) &&
> -	    (hba->ufs_version !=3D UFSHCI_VERSION_21))
> +	    (hba->ufs_version !=3D UFSHCI_VERSION_21) &&
> +	    (hba->ufs_version !=3D UFSHCI_VERSION_30))

I don't think these checkups of UFSHCI version is necessary,  does the UFSH=
CI have other version number except these?
Is there somebody still v1.0 and v1.1?


> @@ -104,6 +104,7 @@ enum {
>  	UFSHCI_VERSION_11 =3D 0x00010100, /* 1.1 */
>  	UFSHCI_VERSION_20 =3D 0x00000200, /* 2.0 */
>  	UFSHCI_VERSION_21 =3D 0x00000210, /* 2.1 */
> +	UFSHCI_VERSION_30 =3D 0x00000300, /* 3.0 */
>  };
>=20
>  /*
> --
> 2.7.4

//Bean

