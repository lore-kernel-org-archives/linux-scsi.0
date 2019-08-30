Return-Path: <SRS0=dBT0=W2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71295C3A5A3
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 06:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3797821874
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 06:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ClV2Qe9U";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="cxrxfYKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfH3Gnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Aug 2019 02:43:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33358 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726510AbfH3Gny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Aug 2019 02:43:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7U6f3fB009750
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2019 23:43:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=gA5GrPJsLSEvb8SoZm1Lfo1LhcDSCs8JP6Z86a349iY=;
 b=ClV2Qe9UjqzRtmyR6GoJ7TXiHg9rhDLvPg15Dplvyoczw04rzDqwrLWHgn4mJTf1XbvY
 PXHaicUSHjFflBr8etn+OfYT1VJcNFMq85h2R0NS7G4b4wfiF5yC31Jzitrlho0JmZa3
 xLcLVWpIGHKXzHg6WkFARpAmoZuA8oZ61Uw8OL5FD0h7isAcPEmA7ga8d25uCUid/XrX
 twmOkRd73vesrmKOS3lrChzvEXbBNlo21xGHXtoPeaeZyD5pXozTkP/XKzPoYvFZt9pE
 hIQ6nJO2szLenSdTXgwSqFN3bBzXZX4we8gOZdl7ZsAYBjPAjtByTZ5pLwT1uh9mnn2I AQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2upmepj509-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2019 23:43:53 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 29 Aug
 2019 23:43:52 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.57) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 29 Aug 2019 23:43:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNVBllL0B1W9LW0CUdPSo6FOUsZ9MVWcZjjAyw7NMAZgQsoWYFDPsX+2WKdjSz9W0BG7vYpvJU2gQGlobLfztS3rVa2GSFOBYUKKgHJGokiYGOimAVpvxu4VywJ9y/XcHmebg6mPIdcUm9CwXD7Bb34VQ65gJvnLMSmgftRI9nNR6s6X4N1Vqmp2zhaR86LFRjiiKYQi72O+YXOhtFryxP0zopJqD+C/QnlzDbz5z5Cw3V49MoPD+hNqWEOP5YQSfnb8NjNIlNBCNBl2JpbzxEbfQzuiNpsVs2JuZgLxL1k3DY+JZ4JhBK9I/2vpt5EM0vC4ykKM4C/98GbpuQSAoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA5GrPJsLSEvb8SoZm1Lfo1LhcDSCs8JP6Z86a349iY=;
 b=NnwhAn6/PRckXovqu7U03aC1OOOM8+jlTwrf8cl1MirjqjjGMkou4IAbM4td0n7iRBtSnhQQd5zlwQEkjhSFppH5mwgoa3IEjFxsOPlyeJzmpx9Guvvcp12blYsCKV34JDKCXSTrBFbY3MsylWhibnhMNFMbJToW5yJ+0KYCE+7h4qad1in5z9KAvbd3E0NVtcEbd6Wihni5mWqYvTtTxOnYC8y5U9QRAnYbFR45otoj57pSC0IpmHIuiCckvV1RcvsKz9BuZ28Iaf0OrQQYzzza3H8vobonGqJgPaK5M5zr40WxNMaMOFXPT/UpdUFtqmu1tt6CLv66ZppUKtCokw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA5GrPJsLSEvb8SoZm1Lfo1LhcDSCs8JP6Z86a349iY=;
 b=cxrxfYKNinDLD28uO9bRqzENx/did+4jVjDFHgJTG29NEAZADXtvh8BYXjub5qe28Evw82XNMshQBtFWq8+QZXz9U+NxK4OEoS4zloQYD31gO0LXq9n+D/fVl/kzQ8seHIvYXyO3OHihT4zsS/sIUC8cndA0orVz6cUgAUg5OZg=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (20.179.82.202) by
 MN2PR18MB3262.namprd18.prod.outlook.com (10.255.237.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Fri, 30 Aug 2019 06:43:49 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::849c:fe5a:a645:5668]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::849c:fe5a:a645:5668%7]) with mapi id 15.20.2178.023; Fri, 30 Aug 2019
 06:43:49 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Girish Basrur <gbasrur@marvell.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/14] qedf: Miscellaneous fixes.
Thread-Topic: [PATCH 00/14] qedf: Miscellaneous fixes.
Thread-Index: AQHVWZiKJrA1SUl7e0auZjS6bR0ExKcSxZkxgADf4wA=
Date:   Fri, 30 Aug 2019 06:43:49 +0000
Message-ID: <D98EC344.19787%skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
 <yq1r253potq.fsf@oracle.com>
In-Reply-To: <yq1r253potq.fsf@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9a94c89-a6c4-437f-efda-08d72d156a63
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3262;
x-ms-traffictypediagnostic: MN2PR18MB3262:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB326203037470227FE0554A04D2BD0@MN2PR18MB3262.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(189003)(199004)(81156014)(8676002)(76116006)(81166006)(91956017)(229853002)(86362001)(6486002)(66066001)(2906002)(66476007)(4326008)(25786009)(53936002)(4744005)(66446008)(6512007)(66556008)(64756008)(5660300002)(6246003)(2616005)(26005)(478600001)(14454004)(76176011)(186003)(102836004)(53546011)(6506007)(6916009)(476003)(446003)(11346002)(14444005)(256004)(36756003)(71200400001)(71190400001)(486006)(6436002)(54906003)(99286004)(316002)(66946007)(6116002)(305945005)(3846002)(7736002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3262;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: A+5cEGiIBEhexGnGSAPSA7w4vfQOGEdOk01JWOMDQWxuS5E3IkqD+uBRVeIZNp9VsClZlKgAxwp3vbjlwCTJ9DWnzHlrnEK/P2J/Hz4GpW5M7Vo6UZPEUhQ8U2THH6h6PfUjpdC2Uw1Fo46Vwyao8oYFD2l7hZUhEK9IqznI19cp4mysde/a3+POHKUUeVjZ+RWMHtFiMo73nlf4t4+e7tfIH6jwMkHjd9eEGM29lt8mKHkhPd5Pwm0stjrT3xW1O176YmI9hzTZ7CwxbgAJ7voWdubXypmCt5rSKI3CbL15doztRVdya11DTmban9Fb9mQQ5nS1E+VAAB7W787VuL0qtu5fiCMf1g4VYtQYEAhATY0xj8gTLW2dY7FAjvQ7lyzADHIcujy86+XYVzIohQIPvMY/lyJRpjQLLE8pIeY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC7865FDC63A5D45B9D73FC976C0B6F6@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a94c89-a6c4-437f-efda-08d72d156a63
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 06:43:49.7832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bnw3sAaZvDOK1pJV32atzcyhMjcg+Jba7qBKHMhD20eARB4ouNoPTInvb0kuugP0e0DJBr69eKuwdFG4ZsfSNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3262
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_03:2019-08-29,2019-08-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 30/08/19, 4:22 AM, "Martin K. Petersen" <martin.petersen@oracle.com>
wrote:

>
>Saurav,
>
>> This series have bug fixes and improve the log messages for better
>> debugging.
>>
>> Kindly apply this series to scsi-queue at your earliest convenience.
>
>Applied to 5.4/scsi-queue. I fixed a warning in patch #8. Please
>verify. Thanks!

The change make sense.

Thanks,
~Saurav
>
>--=20
>Martin K. Petersen	Oracle Linux Engineering

