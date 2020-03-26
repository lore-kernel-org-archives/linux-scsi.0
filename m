Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D34C2D0E8
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 10:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A9920748
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 10:00:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="CT7cQYyY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgCZKA1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 06:00:27 -0400
Received: from mail-eopbgr770079.outbound.protection.outlook.com ([40.107.77.79]:48589
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727911AbgCZKA1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Mar 2020 06:00:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVlzFCAty504aq4q4q7EACMFYmLdOuR7nObGGifN1fSy5Vd+oz4nfkYTumCiX0O91QQhaZ4VFvlVuaRSXFfWU/0tMMZSndLlDaf2NZCXFC7uD0AskxuNYDUiGdrrYHEiS34JBM7fCc69/YVLdshXSS/hWm5k/5HGf9IFT7wHIZgbkCM8l6FAxZhc739lAWcc19Tr68Lt5rE8hDlMo/sBL1yDId4kUYZAfx9OuWRWNNjUmJ5abmzPSfpm9YbaCzlPZYy/jhvKiryGMSi0yII2jP62RKjCJlbY8FanpdpsBn4up7U1j/bMbIZht80bmHKgAiwMgBLiYqLY4GhknkZ2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29CoChswKg/0HvSystSfraAjgbA0l+boSM8FwLCXD1c=;
 b=OaBol+hRfR8lWnfyrVMsNtYYCud9f3jTnovtWj/AK/jak2FjnlmVAmpu9v21sb1Q3mLcokrvi+QG6keaF/Q+/YB+GljeYJ2T5R/rq50dvYRFI6yukkrR15px3ca2xykdB/RUJ4AUPpQrKmO5wVGQp4wrSpPAf+No37Ws7l2HJj1cjLRNOjWWwI3IfHy3XBqQw0pvpC+LK4jpBlIJo7rlBPuUHicelIRADbPy5gVpovYPjHNMq7R4ueYCQAZNHt70i0DHpFC04zqebe2WKA7ze+TxXpVFXiIdxb7G2OuyI5TK3fGfA6C04nldLf5xDeIGbN5ZhsR1wDXiggVO3BQLFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29CoChswKg/0HvSystSfraAjgbA0l+boSM8FwLCXD1c=;
 b=CT7cQYyYYO87xavg/+C+6Tl31TalEUe2Nk8OFUb1xZbEPnCHSmx3IRKcrMm1ne0ziAQq1Zq0zZU/HDi65kkgU8hRPwKRbgx88YBZLDSoAdtRBKwoWsnkVkcgxOGzhK0HQjSesUiJiCnQHb33JPVqMu4gxTcQStT3g1jAei5x00k=
Received: from SN6PR08MB5693.namprd08.prod.outlook.com (2603:10b6:805:f8::33)
 by SN6PR08MB3903.namprd08.prod.outlook.com (2603:10b6:805:17::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Thu, 26 Mar
 2020 10:00:24 +0000
Received: from SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::3437:908c:16a2:35f8]) by SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::3437:908c:16a2:35f8%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 10:00:24 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v6 1/2] scsi: ufs: Clean up ufshcd_scale_clks() and
 clock scaling error out path
Thread-Topic: [EXT] [PATCH v6 1/2] scsi: ufs: Clean up ufshcd_scale_clks() and
 clock scaling error out path
Thread-Index: AQHWA1CWrR3CYvPrC0W1MbnDB6wteahao+VA
Date:   Thu, 26 Mar 2020 10:00:24 +0000
Message-ID: <SN6PR08MB56936AFDC870FB0EAF6C52FCDBCF0@SN6PR08MB5693.namprd08.prod.outlook.com>
References: <1585214742-5466-1-git-send-email-cang@codeaurora.org>
 <1585214742-5466-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1585214742-5466-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTlhMjBkMDA3LTZmNDgtMTFlYS04YjkwLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw5YTIwZDAwOS02ZjQ4LTExZWEtOGI5MC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjM1MyIgdD0iMTMyMjk2OTA0MjEyNTk2NTM4IiBoPSJESjYrT3daWVlLVUw1alMvRE9KZzBGMG1QcGs9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUE2eDNsY1ZRUFdBVVNWdDNINWlwalhSSlczY2ZtS21OY0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTlybW53UUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f967b098-dd95-4785-0805-08d7d16c80e8
x-ms-traffictypediagnostic: SN6PR08MB3903:|SN6PR08MB3903:|SN6PR08MB3903:
x-microsoft-antispam-prvs: <SN6PR08MB3903EB561351DCD2CBD5CAEEDBCF0@SN6PR08MB3903.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:439;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(86362001)(66946007)(33656002)(7416002)(2906002)(8676002)(66476007)(110136005)(7696005)(54906003)(76116006)(66446008)(64756008)(5660300002)(558084003)(52536014)(66556008)(8936002)(4326008)(71200400001)(81156014)(55016002)(9686003)(186003)(81166006)(55236004)(316002)(478600001)(26005)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR08MB3903;H:SN6PR08MB5693.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z64h7hcD0CpAPhP0ZMP4QqPyXNwq98okZ8gta+3R0UU5tZVgYoFhdJ2RMaZlL4wVwzhAELSmr0XdZq71iXrv9nS/1u4YvaP+TJR1anDIJf+37w1X0TT1JDGr4MEfBtWaVDYkV0/X6bZE/bIJ3+0Q30SH1+D5AKgnbvrLeUIiBHj0bQwPA8Jdj5lIp03RI0HvEREfdtXsHTpzj4gEWIKcmS35FlhpMXItFtVw9Nh9A7e5azD98JQKr5XdylumxBt2mwRtPx36cf3PCd0Fn9I+IqiZ2v0TIA3T1vS6vFkknYl80r0t5n6rD9tob5cwDX9Az5m1F0l3wjbcbNM37eFJHdgCaTN7jI5vbrxe9Y+oJKkrl7PFRD9vSxD9TkHKQi9j+3/FjkqVNKUqh258X1vTDS78lLey92I5zCarzWVkUEYWUN+1aqxUGbhDydn7qKMl
x-ms-exchange-antispam-messagedata: Tf4xqtd2RqBxfWJMjLT+2s6bmjIsdw23LPDyJw99MG8lRLPVegk0it57Ok6gmNe1ehvARsmaMUn4KRUWwvha7pobgi+dfO3xyZaEkpOSV4FMDlLjmBGANaSF93VLzOJBiju/APU4BEii33MoNFZYEg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f967b098-dd95-4785-0805-08d7d16c80e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 10:00:24.4418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xSGTjJtpxgtFAIknbN/JzPn4nB4/YvyGYA9DKNxCIeODGs281U0R3LT2S7OHHYj0m1oWtPXahyBQCgG2R4rlkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR08MB3903
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Fixes: a3cd5ec55f6c ("scsi: ufs: add load based scaling of UFS gear")
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
