Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 856D5C17441
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 23:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F375215EA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 23:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AmL+qiKg";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="YezbIU34"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKHXis (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 18:38:48 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44500 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726231AbfKHXis (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 18:38:48 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8NZ2E8013400;
        Fri, 8 Nov 2019 15:38:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=eViaOVsCaFFE0ahYXiQhbSoShWVs02Rd+t6Paduqg98=;
 b=AmL+qiKgOZxYSBaWhyydRVQ7yMUhZnir6cYLWsL8R+NxewmwJGI13Ywo9Ovj6FXU0y11
 q3k0ZGXzRdgQyya+wj7XJqfbKzXCiXz35rXXVDiuZiGVeOG//1zT6W+P4ug0FVNna0iD
 SG23QLqyrJR66lJ8L8glP1dgEO2smQ0Ptrn99cWfVluDzj014F1xHbsIX6kOpA7p5HRB
 PmIwG8qXgTKLmK+lBP9f87OUgGOSUGVbVFWqpFj2ejWr4MwUGel6zX6pWkftetA5olf7
 squOp9FXJC0wHbxqg7u2QbDVAhiGk8ygLpLUvguZWJ00KbkbJHqt743HteLB7/HUMdhV oA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w5hgjr4e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 15:38:32 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 8 Nov
 2019 15:38:31 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 8 Nov 2019 15:38:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mN/VuIZwQ+3NjnWY0tDDXsqhM6itTQnLrdXeVyCCIqWM0X0dRCpqB3s0gKicDR0R/x1aY/AhqAfAoQD5hYbjAXhMEY7fYXqPB/XmMzjcVsDc2o08uN0SDfjX30MMEu/6kg8uoWHj31rPi9eZLwNWgChtjvdIm25MUVnZ7rgK++OOVjMuoZPaLqvtVwOZicbcJK0niP3z2V9gJEOowOsGgQtMKLdj6o6yuLXODdM9o5WYBFvC/SCNAWe9z8fqUhdId0+CpG8FsBS9StGZtGo8yHBv0oqC8pLi1UnaYWNVbhgvGY7cHYod7EHwRL/3poW6QWsPG+X1Kkzo8LFFhZ1hFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eViaOVsCaFFE0ahYXiQhbSoShWVs02Rd+t6Paduqg98=;
 b=RHCE6EK0MYE1rnAEcr7RFdzp1YLFYjnUQW/NAiizgJWxtk2GPJ1xmrwfD6hzBgZMdkDLncH6bxrY2mw3jyhtLcnLaQ6fqnTyUK4VJDpHqfL1WrwRDSreRAU737RdDVThmbAmNuMvUSpnKqFaG7wsj/hpgK977hyQK0a0+XEEniXRvEIJtBq18bAeeUx/y4gG02GlCMakf3/4OLzIy08iDkl9Q45HCAS7pd3gD4WHMCABv5BxygBXzNCKvkO4/2vnv4Gonq03jJeX1ci3Z/f3B63y7RO+68q5Z9DFv2L3aeM5PNnapYNvfY/4dLwGKI2/aR5Hg89UHcWQ2YgWeKqEug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eViaOVsCaFFE0ahYXiQhbSoShWVs02Rd+t6Paduqg98=;
 b=YezbIU34CnOj6bQFTkIeunzpfdagb2h+4uYxLc4j9kdnhgVou8L9doMvrUHab4vjBugAJcnbiVo0diVeM1TiV3OAxCjx8YW9zwpz40sQWPMlZUD4qEmfoP85o6iVDtjcIq/xazN44mV8TJAB+9I1NMMsW+WajTDdcOTouFpk1ZY=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3085.namprd18.prod.outlook.com (20.179.21.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 23:38:29 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 23:38:29 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "<James.Bottomley@hansenpartnership.com>" 
        <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] [PATCH 4/8] qla2xxx: Fix driver unload hang
Thread-Topic: [EXT] [PATCH 4/8] qla2xxx: Fix driver unload hang
Thread-Index: AQHVlo2f7OgiXp46aEiT1/1V3GOGrA==
Date:   Fri, 8 Nov 2019 23:38:29 +0000
Message-ID: <1516C4D6-198B-45E1-82E8-5FDE39BEDAEB@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
 <20191105150657.8092-5-hmadhani@marvell.com>
 <f4c6df6c-f1b1-d465-dc41-dc8e63df56e2@acm.org>
 <83CC0DDF-4907-41A2-91EC-1569A07A6BA9@marvell.com>
 <10b38f34-128a-fd71-1542-9025dc107f62@acm.org>
 <cff0bb9a-4495-1064-dffc-5a15dcb30dbd@acm.org>
In-Reply-To: <cff0bb9a-4495-1064-dffc-5a15dcb30dbd@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2600:1700:211:eb30:759a:ca40:26ef:315c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22d92a10-c584-4852-6477-08d764a4c254
x-ms-traffictypediagnostic: MN2PR18MB3085:
x-microsoft-antispam-prvs: <MN2PR18MB308521370B602E61F0BFA8C5D67B0@MN2PR18MB3085.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(199004)(189003)(51444003)(86362001)(6116002)(305945005)(71190400001)(71200400001)(6506007)(7736002)(478600001)(6512007)(8676002)(14444005)(76176011)(4326008)(2906002)(6486002)(6916009)(6436002)(81166006)(81156014)(99286004)(256004)(50226002)(316002)(446003)(229853002)(64756008)(53546011)(66476007)(66556008)(66446008)(33656002)(76116006)(91956017)(25786009)(5660300002)(6246003)(486006)(476003)(2616005)(186003)(102836004)(46003)(11346002)(8936002)(66946007)(14454004)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3085;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uJPd0r6nUHTPANcBlLud5cuzOdD7/lzTggnM+Xoa4R5VK+BaYiu4yYj+Hd3LaxVOQCpLkE4CZhrLDE9H+I0teyl1YN8POTXHa0H/mTEvRP8rntAkW3Idy5tr91p8aP/ITHkswAy1Z4ahgw+GNxI0tvGjqcR+qs+fr/Kx1d6KLQ9FfTbrMnvnIEdZvV++Q18gC1Bu1EOa6ulryAAQ8jb7dO9naOUSoR46AF5yUzqtS8q3vUALsBumWo8+h2ZSOTbuDJcuRgNyp08mGtJILY875k+R8W3njq2icLd1jqpiwo4nqf8MUjazPq7OGeZX8cQFTSF0MMlNT/fWS++BtRCVPPYqU3XVhA82vbTf1z4bDnHp5Z/Yl5e7JrbHTTCzCU0w8wZGGwZ8B/kmwWTetkrudsZdcrcJGU+u2Ww21dnl/rr53XHQ55rTPxiSHqgbKjmD
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DEB431B0989E7245BBAF220E36A15D26@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d92a10-c584-4852-6477-08d764a4c254
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 23:38:29.3409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L3fLDdGmuA9fQ56CIw33kv6CtG7iCoAKIvz0LlsczePXIhX9oXtv5km3ghSFOD8fbdr8EEtO9bBxsBGo47Vaqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3085
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_09:2019-11-08,2019-11-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,=20

> On Nov 7, 2019, at 12:30 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On 11/7/19 9:58 AM, Bart Van Assche wrote:
>> Does your answer mean that this hang has not yet been root-caused fully
>> and hence that it is possible this patch is only a workaround but not a
>> fix of the root cause?
>=20
> Answering my own question: I think that a qpair refcount leak is a severe=
 problem and not something that should be ignored. How about changing the w=
hile loop into something like the following:
>=20
> 	if (atomic_read(&qpair->ref_count))
> 		msleep(500);
> 	WARN_ON_ONCE(atomic_read(&qpair->ref_count));
>=20
> Thanks,
>=20
> Bart.

Since we had seen this hang in a specific cluster environment and refcount =
leak was observed, I would like to add this patch as is and will consider y=
our suggestion to verify if adding WARN_ON_ONCE will make any difference. I=
f we discover that adding WARN_ON_ONCE indeed helps, then I will add a patc=
h with fixes tag during rc window.=20

Let me know if you disagree.=20

Thanks,
Himanshu=
