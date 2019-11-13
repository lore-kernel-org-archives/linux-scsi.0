Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39257C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 15:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB99F205C9
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 15:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GUbzRoW1";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="WZFS9rSd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfKMPaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 10:30:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1894 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727968AbfKMPaA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 10:30:00 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xADFQeVF032055;
        Wed, 13 Nov 2019 07:29:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=PZ5OjELrAFpgyTIqzBNMp6UtLc6aWYO3Ps5gDmJJ+Og=;
 b=GUbzRoW1BqhuW5tCTEI5OJTL2wTbouSaMhPxlm+WkjTuBXO8YVpbxfwvZT1cYtDDAdXd
 cE7OlH+cI8qf9JjiMguks3NGny4QTLfynaJROSMGiR2XoqnHfmkXXVpX4RVUONoG21Z2
 0O8ROBWFTlpf8lzgjUGc+X6l5IP/qBBt4B7sFupE1QjCrUJdJQ+d96LjZPKsqIF0Sy+/
 +eQGMsp9wZ0YBSJfG+5FUArQLQfNLseaQTvkAYrqxffup1FHpvApvCreZAXldTvcBROZ
 3upAurFgeao3KrMceFVU5N/rf221mZ8TXC/ju75bfUurR2aJ67oZhMAqkgQW1iKrp+Tg WA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w8e2r1kgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Nov 2019 07:29:54 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 13 Nov
 2019 07:29:53 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.56) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 13 Nov 2019 07:29:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3kckAOvn3eXEK98oXOxCw6lCuar+UgMluwr3fq/W0fwZQtXpNfo25Ze1WgzNd4fVSLPrfI+nbEXMEPBQtquFARrfVGEwBAQvSArf9vLudfqHP/pQzuyW2EtrJwty0lwl1nru21oZ759bv0Uiy++zNdZ8RPrS+2XFEuWvNmBd4OZi9xH7nsbd/zh5pTIyud1jlrjaBM4ynBbxRrcMDct0zkkbZv7F4f8ndqDh/YHs+ERT3O+Sy+Udz4KYmt4+Yq8jzmf8TNS+U6hNOTGKJ0iye2e63jipXlQJggRsfShznmUflupchXLuvIgP4lE7aPxEac0G9MQ5yf9+zsZpGozoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZ5OjELrAFpgyTIqzBNMp6UtLc6aWYO3Ps5gDmJJ+Og=;
 b=mfGwMJhYkfNA3bqkjE6pcOFifc6AuI1wpK1d8e6jfPl1+vFmih5COr954sj9OC8u2Bh31fl51NDFuWtgRpAsilcKF2BK/jKOYBdnuCLX4BHBiEpV8NaYkzL5P6IfQkJQLK33t/Evzg1z7I4AvXqUwceYubpXbJ7DV2x5x2qRxuhNKi7PvUBqaG+xhG3gtsg+Q55p0I6hB8gz0qyk4v6nzXRcDgVtddlZSLr7tvYfnLt2xyPyjY659neNZui3vjLD2lxTRlpSAtPgHioYyu0K9dx+5EISspaJsKGop2hRrRGm6JrUKBozvCVHF551mQzsvEd2yU5trY8sa8nSllXCyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZ5OjELrAFpgyTIqzBNMp6UtLc6aWYO3Ps5gDmJJ+Og=;
 b=WZFS9rSduAzLBkxy4ns7bS90hEblLyUV+z58nbwbLr7/6xqvCoorzlVikoQJgQoADw0YsgG3TAQ4YjVBHLMtnWGBJ1fxYCf+pcxrUzblB2/Ku63Dq4Svh9r8Ts4Rlcgq4kBu3kpSqmbTEYCytX3U8nHadyqDUEwgDoahfVZnhQQ=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2445.namprd18.prod.outlook.com (20.179.83.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Wed, 13 Nov 2019 15:29:50 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 15:29:50 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Thread-Topic: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Thread-Index: AQHVlrU0VXoSA9b5+EaZjGKOtqlhIqeF2L8AgAEBHQCAAmcYgA==
Date:   Wed, 13 Nov 2019 15:29:50 +0000
Message-ID: <19433666-FCA3-4340-8A81-707F85B87F02@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <32187dd9-f222-fbed-cc93-1c6abca6e06c@acm.org>
In-Reply-To: <32187dd9-f222-fbed-cc93-1c6abca6e06c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [66.73.206.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2f41f1f-4447-4ac7-b34b-08d7684e52ef
x-ms-traffictypediagnostic: MN2PR18MB2445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2445943BF4026D5C088A1C46D6760@MN2PR18MB2445.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:311;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(189003)(199004)(71200400001)(26005)(107886003)(50226002)(6116002)(316002)(102836004)(6436002)(3846002)(99286004)(14444005)(25786009)(256004)(486006)(478600001)(71190400001)(4326008)(305945005)(86362001)(6916009)(81166006)(81156014)(54906003)(6246003)(8936002)(14454004)(36756003)(7736002)(8676002)(2906002)(4001150100001)(446003)(33656002)(2616005)(476003)(6512007)(5660300002)(66946007)(76176011)(229853002)(11346002)(186003)(6506007)(66066001)(53546011)(66446008)(66556008)(64756008)(66476007)(91956017)(76116006)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2445;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qwo7hdtUslSoht2NYPk3+h1HipAEeM2bYDWP9NCu7PLtxvm6oo4NfjqMcg6f/vKxV2cKj4mhvrdBajo5cXkX3TFJFOwXzm/v9MZWCCXSCAUo9Y/tuvyWUBiIpFYeTyZ5KdAiqt/c1zxFuMr6CFflPCu9FDC39oKPAGJXCKBIysR8f3D66tHW/Uh6HL8AVVgH3m3e2lxf7M5hkrp3VlYy0EymXmeLVa+lwgiQz/u6+iAzUuB9sPxa2oGEfhkbuueBmM7gdPjj18Eg8kZAXWg0GdBGgiN7qqBPfinLbGxIOTfrrTF4x78CL/pmbQXVtl54Hs5JxUdP238aOS/FMtPOopai1nch/WoLTr2LEaUxGpO661QbwIBXNighPhFHlTpvBKVTZQ88yBozT7axHfJsRejPPlrgHvC41JWHTe24VDxFh5HcnqwSQKvIuQ03acUr
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DE90A5E4EA562449A2DE3C6993C569C0@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f41f1f-4447-4ac7-b34b-08d7684e52ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 15:29:50.2763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ba6CW4PeNiR28uAH74Ba9PpiIyOeKskLBl4PssKKPOPZ08Njc2JjiUVgkjf1LBi64EB8LqXN0C4O/abmNfEQPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2445
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-13_04:2019-11-13,2019-11-13 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart/Roman,


> On Nov 11, 2019, at 8:48 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 2019-11-11 03:28, Roman Bolshakov wrote:
>> On Fri, Nov 08, 2019 at 08:21:35PM -0800, Bart Van Assche wrote:
>>> The commit mentioned in the subject breaks point-to-point mode for at l=
east
>>> the QLE2562 HBA. Restore point-to-point support by reverting that commi=
t.
>>>=20
>>> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
>>> Cc: Quinn Tran <qutran@marvell.com>
>>> Cc: Himanshu Madhani <hmadhani@marvell.com>
>>> Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value") > Sig=
ned-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>> drivers/scsi/qla2xxx/qla_iocb.c | 7 +++----
>>> 1 file changed, 3 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla=
_iocb.c
>>> index b25f87ff8cde..cfd686fab1b1 100644
>>> --- a/drivers/scsi/qla2xxx/qla_iocb.c
>>> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
>>> @@ -2656,10 +2656,9 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entr=
y_24xx *els_iocb)
>>> 	els_iocb->port_id[0] =3D sp->fcport->d_id.b.al_pa;
>>> 	els_iocb->port_id[1] =3D sp->fcport->d_id.b.area;
>>> 	els_iocb->port_id[2] =3D sp->fcport->d_id.b.domain;
>>> -	/* For SID the byte order is different than DID */
>>> -	els_iocb->s_id[1] =3D vha->d_id.b.al_pa;
>>> -	els_iocb->s_id[2] =3D vha->d_id.b.area;
>>> -	els_iocb->s_id[0] =3D vha->d_id.b.domain;
>>> +	els_iocb->s_id[0] =3D vha->d_id.b.al_pa;
>>> +	els_iocb->s_id[1] =3D vha->d_id.b.area;
>>> +	els_iocb->s_id[2] =3D vha->d_id.b.domain;
>>>=20
>>> 	if (elsio->u.els_logo.els_cmd =3D=3D ELS_DCMD_PLOGI) {
>>> 		els_iocb->control_flags =3D 0;
>>=20
>> The original commit definitely fixes P2P mode for QLE2700, the lowest
>> byte is domain, followed by AL_PA, followed by area. However the
>> fields are reserved in ELS IOCB for QLE2500, according to FW spec.
>>=20
>> Perhaps we should have a switch here for 2500 and the other one for
>> 2600/2700? Or, we should only set the fields only for QLE2700, to comply
>> with both specs.
> Himanshu, can you tell us which adapters and/or firmware versions need
> which version of the above code?
>=20
> Thank you,
>=20
> Bart.

All adapters with FW v4.4 will behave same. If you are running into issue w=
ith P2P connection,
it might be something different than specific to this code change. Original=
 code in the driver was not
following firmware spec. This code is now used in initiator mode as well du=
e to introduction of
FC-NVMe handling in the driver.  Also, can you tell me what version of firm=
ware you have on your=20
remote port.

Thanks,
Himanshu=
