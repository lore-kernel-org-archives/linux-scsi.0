Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C30C433C1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 17:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52951619F9
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 17:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhCZRrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 13:47:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61068 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230152AbhCZRrB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Mar 2021 13:47:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12QHksjO030707;
        Fri, 26 Mar 2021 10:46:58 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 37h11jkmmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 10:46:58 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12QHkwXN030763;
        Fri, 26 Mar 2021 10:46:58 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-0016f401.pphosted.com with ESMTP id 37h11jkmmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 10:46:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdS6EcWkFLpPlWItnrbMrblpGRhPe/o1yWuWN62VuGiz4uSllUxglQ/8nGYPapSQMjoFEFsRvKNOAwROYmZPcpLT1hKLULKU+Z1QeyPEp7BvgWRMocrQoY3fe/ZWYRSudhAJUrl/PGW04N5oMrjaklFuf0Bmzy68puP0PGqkyMkkbG324Re0vgce44lOjI0YjaHY8N1lvwisrHagc8XuhYQD0qm0LJB/jeBszpb3vWobtGCQskhED35NDiMhlKG2oOhOqksHy3f7AuDGvBV8TxDViWzWR9iriXmmvC+f0i2mp17CKxNFL6kUKJQEovjnI1jyETAEE6Xu/GoySn7AAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04C0dMjaJ4vs4U7SMiq7UMh9ClVeKn2plIH2WMmgwbs=;
 b=GLenARzFsmGITv7fc1TXQmaPgbJJ7K9fIpbTVNUqCeJid4LOVHTzRQXuGog3+RQ6NhwDLq/747qDkC2F1A68OdCdjqBEvw+birN6ZA+T4pAwERKeP8Z44sW4fjI9ZMpv8U9V/2yrA/1214zSQYopaH69/1ZnmZqQ6E7jHTuCVCkx/rxTbaCVC6O1zJBUIcQzy5jmEBmUIDmrlkL1ucuPnAvf3MRBg7hIdwdUI+B34gnjfBVqwapLHe/JOBXLb4cautkIjCrDRv16EV7IBiEWO6uVVW1lpddmupR6X6ar3ONw9MquC3XGwtclhNjVhbEp9ysyl+s2fboKzGvstFR+lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04C0dMjaJ4vs4U7SMiq7UMh9ClVeKn2plIH2WMmgwbs=;
 b=KiMqOIx4H8rbU8nn16DZsZnhjmmvgxEeJp7OgC1LKIWzOeNdSpxAjg9eI9ifmPfxn6eCBSOYIW3advnSgLme8p2Bg0mhwt2HtI/afwWF4nAapQ7RgGBwTZwQ2/pYH5NA4ffrydaevSNF3AXlzx6gE1Wbe9AMptGcH7oXoBCOLt8=
Received: from BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30)
 by SJ0PR18MB3930.namprd18.prod.outlook.com (2603:10b6:a03:2ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 17:46:56 +0000
Received: from BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::ac7d:1720:5c99:fc42]) by BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::ac7d:1720:5c99:fc42%3]) with mapi id 15.20.3977.025; Fri, 26 Mar 2021
 17:46:56 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 03/11] qla2xxx: fix stuck session
Thread-Topic: [PATCH 03/11] qla2xxx: fix stuck session
Thread-Index: AQHXH587zNzIWhkmR0KhJg/+YRES/aqRxLsAgAGHm4CAA0PG8A==
Date:   Fri, 26 Mar 2021 17:46:56 +0000
Message-ID: <BY5PR18MB3345D49A244A704C3C70EE2CD5619@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-4-njavali@marvell.com>
 <bd9dd526-776b-87a4-9b81-634ce687e393@acm.org>
 <97BE89B8-9B44-4AAB-AF5F-62E7E3A6D622@oracle.com>
In-Reply-To: <97BE89B8-9B44-4AAB-AF5F-62E7E3A6D622@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [98.164.229.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75e39967-8517-458c-da6e-08d8f07f2647
x-ms-traffictypediagnostic: SJ0PR18MB3930:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB393027EA6D28AA1D6DDE1014D5619@SJ0PR18MB3930.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xmn5ywK0eLnxMxSaCpYWFy6hK8dcFaBKrTngKcvbmOSFXt9EOnRRzZayw2jH8dWXpCZvByK0+VwxtTJAf+2gh4OfpVXrFDVg4x7dpE1ivbzIxDS3LVUnIcebzLmpxg4ZLUmporr+RzZmIv9Y5HaPWroKfFKbry+jIY7KbnmyhF15jSKYradDSyg4tv76JcZ6UZXG9Jn5yxrlc0s3KgsQL6ZMB0yv4q44ZkchZul0gr8Rtr/fQ4R7UFz0TMYRR8n4FQlfDQbYUBEwZPCvSQmtKw3/Bvcq2Fny195qkz2IQrtO7W40miJxcRbrG0mgf+8ozUDABGzXmfBCAPAzdN/HgixhaPyOZ8ZeS2xpWnpRz192/gZa4RFMopNrArFS6cHly2besEazh955W6B0DDk1HTEui/GotGC8rJ2ZRmRHYquNUewTA4Swd9IvrlTfGrb5bpqvSI5ohYmikOeVE1xk86nwigUgAKFQysyUTgIqnURlROMEMz/PlMXQmuDnFXo0OlIS2lOMd/Xy2Y7KDXlUAB1Zsadv3SCzqJSatgv5F33AWcR/tpcqdjOGI8ymgTZSeMUB2BXqmZaqyZsg9yznM5MStW5jJ6ZZVq6taGA1EeDXOA/SLPZXo4bOO3URNR5G5vGg4/R8FOnZxCoNcSP21b7JdX1djuO5upRZaHnv7rA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3345.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(7696005)(33656002)(186003)(53546011)(6506007)(66556008)(64756008)(4326008)(66946007)(110136005)(2906002)(83380400001)(5660300002)(8936002)(66476007)(66446008)(26005)(55016002)(71200400001)(86362001)(54906003)(9686003)(6636002)(107886003)(316002)(478600001)(76116006)(38100700001)(8676002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ofAbYOi5stmD+GP9R2xaOA72Es7/rmpJdk0ZjOd5WfDOVcBw1d7iz3A23yb3?=
 =?us-ascii?Q?CSKPiGFlcNaIOjU0f1vN+adpi3OuM3s2ju5/alrWF+9Fey8Y9lXHr/P7tX7n?=
 =?us-ascii?Q?Ajph58PRzCS3A3vREkreInNE3bkQi7NdxIGpwL7WBwVe4+2ioMG5HbyPjxOk?=
 =?us-ascii?Q?ezt76Xzng9vMzQX2hlL+lnjcFaF4Uicq1G0andB7CNse6/E2F534AIZGWBR3?=
 =?us-ascii?Q?z0Xow8r96+DaVwlEfvGTn0Z9+XTmcH+4zQtT3lv7H4z5UQzFofq6I0wiNZ8d?=
 =?us-ascii?Q?Su92L5uwYbcwgsQAgR/8KeFoHlOoLElHfu9xh9lA6a99wcSk9Vebo743x1hp?=
 =?us-ascii?Q?vesl6eDxjwY4S6YNbdNT5wpgyaMBRRKUAhe8Bxvjeu2ClzPX7lZBLXY5sJAq?=
 =?us-ascii?Q?uYkVO5jIvEglZrdYlqZmWXRyQyGOzlNO8uIQbmH0R7rkk7JLhE0UIkIgszzM?=
 =?us-ascii?Q?1c2jSjaPAQPJPdlly7gP1z6B2XZUKYbUEBjzbVcP84VnyCMTTGx3gy66W+gI?=
 =?us-ascii?Q?GkxhCYzTIL+mAReaStNE7YuzYHK1NrBCLQafKtNExzNIQVWzX98ko4Wo/zpo?=
 =?us-ascii?Q?hDsshmmYfbAeGLdD1leNky/pkJq5xP0+UzLQSCdaQ0OWflNJ01YcXigI99uO?=
 =?us-ascii?Q?5AQ644aop/eebEZHXAUZfqGve72Q6fNKbzz9eTepC0R5esgvzZV10iuoA/g6?=
 =?us-ascii?Q?S62PB8bipLwUGPyN1nmFpcTa/yuMboRxZWHOpQcXmYfJlq+1WvppBsqCLdI0?=
 =?us-ascii?Q?ugn6WnXFKOOCnYMq4jyKW9DujGalnjxe2fCbcIe49AwkvAyp8GqBlK38DpvB?=
 =?us-ascii?Q?1Q5x80X2njPuW3O185yBC0PkFwsd/vcEUVTrpiL+XgyL/45NTk+pIGxwM1CP?=
 =?us-ascii?Q?CAlD0N9J+sG0wgmni5k7BNu2XpOuH95zVChLGa4Bz7qM4oftuLV7wCJ17Loe?=
 =?us-ascii?Q?/EGClPSVuz3rJA8ZV7xTbU4Lt1F46p8zYXXMJFy6WDWjItX/mVW1k1qImxLu?=
 =?us-ascii?Q?mmAp9HvvEZOjcX+MHcvqyFYzZa12RMuLDxHP9SBmEklU1Hjdec3RZ5qkSfim?=
 =?us-ascii?Q?59BvonUlShYBzbNHOH6WFQV97HvgDJAMoUVXQ3Xmp4L+KSE2v9Z9QcYyDyNw?=
 =?us-ascii?Q?oHDqqaCwhdQFdK91ka1x336tItnN9aVNGMhX8fKli3Oeup2TDfnMHqcMBCoU?=
 =?us-ascii?Q?F0EFxPF8Wc3DF/4HUzabC79zRuJPjLzqcI1yhLYkQ1QVgdrQktZPOJQX+aKb?=
 =?us-ascii?Q?EOvBFIzQ0W4moWCDVSSmlynGu5Bt5ahIW8ObNKjyXDUJU6PwxByt3rtYlm85?=
 =?us-ascii?Q?GcHptm7i0zgcYSKa5QltbKUY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3345.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e39967-8517-458c-da6e-08d8f07f2647
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 17:46:56.4782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B1mzTibaSxzrg2dSQMi/4W0CcPi/c7E7oBgwpaLpI4o+7JNakOwVawnQWrf5C/ZrlaHEsQ8pyhnQQlgFfeAHDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3930
X-Proofpoint-GUID: mvCO8_k_x3PN3aphIEBRiadXnCc4A0sP
X-Proofpoint-ORIG-GUID: vNbh1F_6V18tsib0iwBRGlOyufPyLEqf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_08:2021-03-26,2021-03-26 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 23, 2021, at 11:31 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 3/22/21 9:42 PM, Nilesh Javali wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_target.c=20
>> b/drivers/scsi/qla2xxx/qla_target.c
>> index c48daf52725d..fa8c4dae8dce 100644
>> --- a/drivers/scsi/qla2xxx/qla_target.c
>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>> @@ -1029,7 +1029,7 @@ void qlt_free_session_done(struct work_struct *wor=
k)
>> 			}
>> 			msleep(100);
>> 			cnt++;
>> -			if (cnt > 200)
>> +			if (cnt > 230)
>> 				break;
>> 		}
>=20
> One magic constant is changed into another magic constant and that is=20
> sufficient to fix a bug? Please add a comment that explains the=20
> meaning of that constant.
>=20

Agree with Bart here.=20

How did you come up with this new count value?  Some more details (either i=
n commit message or actual comment in code) would definitely help understan=
d. If you have some log message snippet or stack trace add that to commit m=
essage.

QT:  FW timeout is 20seconds (cnt=3D200).  Driver time out is set at 22 sec=
onds (220) to monitor the logout (2 seconds pad for worst case).   Changing=
 from 200 -> 230 to allow the logout thread to finish its sequence before a=
dvancing the state.   Previous setting at 200/20s create a race condition w=
here driver was allow to advance to relogin, while the logout completion st=
raddles behind and modifies fields that interfere with the relogin.  This l=
ed to session being stuck.


