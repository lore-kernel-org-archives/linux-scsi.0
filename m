Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8C5C17441
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 02:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA166214DB
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 02:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rUL/O/Fk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yCPAyMP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfKICTH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 21:19:07 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26007 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfKICTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 21:19:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573265947; x=1604801947;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=PkqSvSWU2uI2r/Lk+6apKhRVDteKpCB8n7kpMb12hbY=;
  b=rUL/O/FkCvaWzUohCmnlKCzY2hikfVHiVrPDNFlAahZcQ5jEMnkBJ5ls
   da5YIQRMQw4VZGh6r8YlbZCPV5lrWYWYwD5zObgqKnCV8vSEZ1gGb1JUq
   cmAYxyH/l9kOO1gbu3wyjxd6s3jYJe0cpr282i8GKCR7AyLKY+1K1Y3qf
   S5e4RgraaQ0lJ6FCgjfmMv40H0PvZTnXBBDSbwkkH+igHpEo89RCse8zF
   PudYn+MI6vMAce7dopA6PWaKdk15ntXJ7uZBk+swcSGf7wMYpC2Uu+8jE
   eLQ6yxnNQ2RloWlqeHSabzeTsxvQhgwHCohkI5VGZ0buysCbb7S2QGty4
   A==;
IronPort-SDR: hw5PfyYfH0pFsIFtGVgdKdK95EayI6s6Lis+9dPzJHprImcp6Kyu0fx2X37REp156zmqtPcp2A
 GyWDagbrhWkrOjdUzo3w9zBRGRqY3E03tcxkD9IXOuDhHQLQbGrDz3PlfEjBsPjTemgRB+yrVx
 zbfoHpQNUP9nyZSkE0raI5BElEh4clIhgfKxXo3ytW1q11XhgfPlLSRzRuqiOBWIwljyevR3GW
 sZHKC1kegxUFzpuOMj/3IBneFyGLAVqA+Zo+TgqSa5HnLzgdNoTGUue9JAJ+8jpkxEapIRA+zv
 QLs=
X-IronPort-AV: E=Sophos;i="5.68,283,1569254400"; 
   d="scan'208";a="124160111"
Received: from mail-co1nam03lp2058.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.58])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2019 10:19:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuXva8qyf2podCch7n/SYx6v8ZIJPuZVUctrxTvFvx4MfVbZ6xFoZ7XwDCD1lhDWged2VKOQekTvNin8fZTfMiLZ+xUIwJdKVP1ruL9JnBoJPhR/Cm3CXiNxtRO7CjjeEZLVxp9jXLMVb0xftoFgOzEu3Qs2LU9N59t4qOavIwWiysL5bsONJyi3EPInAJsc0dhCnYUhiJmNB+uelRaj3JIKEi0X/+AloB2Az7aR3DJ/6NBUuXBj05tUAvStf89EgqoooQF7BQnlYCh62hbPiBDUGWlvP4D910D8vDDBDgYijdiLTp+Xm4XePPCwnTGM6LhoZME8m+HWS0MwXGkDTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKj+9xB1RdSq0lbW3GL1NTLG3PUjwGsdYOeYxBQcc3E=;
 b=Ek1QoLpLkyu499PKQrWNpUcLcw2/Pu15LhNReY4EdqCA2cNEdlnrT60t9N/gkOqYDrSeXzuqqpnBSShYdxqC5fXXas6If4OyFACvdYmM20MrcVs1BmStIsdBvGdmx3ISET1lSZOH4uifdAIruwuBQgVZxyKsJpi092cUZUc2Go8XtELe4HH5KyeJGsVYdjjUhypJCBkoM/4KbYRt0Rt8aBXi8l2k4q7Vqn1Wd7/Rp47Et1eB1PF/TL3zqCBOl+qIKnMDICccL/STUDvTixdChdMPLujZAGldJA7bThLMyMj330bFyhCRv800zWbO2udlwHrWA4+iawo2Rw2Cxbgyrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKj+9xB1RdSq0lbW3GL1NTLG3PUjwGsdYOeYxBQcc3E=;
 b=yCPAyMP0JYKXv/PuGiVYbrDhcEyYpiQA/xR37lAlxPfd4VDIvguCv1sHqeeKVre6EWblbG/l4oWavYQxk64kbslLEftjEDH4eBFtneYE4jAXTIfsxh+QywhvT07Z0hjLz765LLu9f6q4JNhdVy9oGg9KtmojR8jwramkTB+PsJQ=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5607.namprd04.prod.outlook.com (20.178.207.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Sat, 9 Nov 2019 02:19:04 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2430.023; Sat, 9 Nov 2019
 02:18:43 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
Thread-Topic: [PATCH v2] target: core: Prevent memory reclaim recursion
Thread-Index: AQHVlg6XFUQZy170jEmoRrRClNfoDg==
Date:   Sat, 9 Nov 2019 02:18:43 +0000
Message-ID: <BYAPR04MB5816047492FC58019387A33CE77A0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
 <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [60.117.181.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c6f3af86-9072-417c-2abe-08d764bb24ac
x-ms-traffictypediagnostic: BYAPR04MB5607:
x-microsoft-antispam-prvs: <BYAPR04MB56070AD6049482F8D8691652E77A0@BYAPR04MB5607.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(189003)(199004)(81156014)(25786009)(486006)(229853002)(186003)(476003)(71200400001)(66066001)(33656002)(256004)(81166006)(71190400001)(446003)(6116002)(26005)(74316002)(52536014)(110136005)(5660300002)(6246003)(3846002)(91956017)(99286004)(102836004)(14454004)(7736002)(76176011)(4326008)(6506007)(9686003)(316002)(66556008)(8676002)(66946007)(66446008)(64756008)(66476007)(2501003)(53546011)(2906002)(6436002)(55016002)(76116006)(478600001)(305945005)(8936002)(86362001)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5607;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HtrlBqf9iqaeyB2yGhrgxzFdvcg1HocAhR9Z7oY2T+zsM7sGjC5L99Lklbywfv/6qTQu6WoZv9CPsLgHdrVn2TJXWdY+BBTD779lQv99yuinSZXsNyEGP4Uys2ZQ0ByB4X4ypZ+ek9X08P0vl8ZPD1L6ak4hGGn/1VSg2j5t8ALTT/JSo66a43KECFb4kgYNeMbsFrDVG8Blb5dn+NNLrFEGpz82/AG1Xri2hzeBt879ugok5/V5uXwPENoCAt5kcMjlBsEw4ln3Lfrzd2YP1rkBh7QBwoYrGf2W7vPYHA2JzRSJXj2V+udnlXSLkIoOQxMw55AobyEEApXiNXHKXwPeqBsrFXEAF8DZrDSRN4k8M7oWEKWpXJYAed3bPjqYuX+pdFLnxM+wapsZJ7U0SRwLtXpKuev6HFFQnVzTsQfzQe9jp4c4tfe+x+ii0WiM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f3af86-9072-417c-2abe-08d764bb24ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2019 02:18:43.1850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 05QeEeJk+Mwi7TRxIKHNIWTKBx9Qg2fYwPMjvOcYBcyO2UIx/fsyPyg5OKfXUXPbSl+3b1LdJcTb1vyqHtRL1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5607
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/09 1:22, Bart Van Assche wrote:=0A=
> On 11/8/19 12:29 AM, Damien Le Moal wrote:=0A=
>> Prevent recursion into the IO path under low memory conditions by using=
=0A=
>> GFP_NOIO in place of GFP_KERNEL when allocating a new command with=0A=
>> tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().=0A=
>>=0A=
>> Reported-by: Masato Suzuki <masato.suzuki@wdc.com>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>=0A=
>> Changes from v1:=0A=
>> * Added reported-by tag=0A=
>>=0A=
>>   drivers/target/target_core_user.c | 6 +++---=0A=
>>   1 file changed, 3 insertions(+), 3 deletions(-)=0A=
> =0A=
> The patch subject is weird. Shouldn't the patch subject start with =0A=
> "tcmu" instead of "target: core"?=0A=
=0A=
I was not sure what to put there since the file being touched is=0A=
target_core_user.c (it has both core and user). May be "target: user" is=0A=
better ?=0A=
=0A=
Martin,=0A=
=0A=
Please let me know if you want me to resend with a fixed header (and=0A=
what that header should be).=0A=
=0A=
> Has the recursion mentioned in the patch description been observed or is =
=0A=
> this a theoretical issue? I'm asking this because GFP_NOIO only prevents =
=0A=
> recursion if it is used inside a block driver or filesystem. The tcmu =0A=
> driver is neither - it submits block I/O or filesystem I/O instead of =0A=
> implementing a block driver or filesystem. Should we really disallow =0A=
> tcmu to use the swap subsystem?=0A=
=0A=
As Mike confirmed already, the problem was observed and actually fairly=0A=
easy to recreate. Our go-to setup to test this is:=0A=
=0A=
fio->XFS->dm-zoned->tcmu-runner ZBC handler (emulated ZBC=0A=
drive)->ext4->regular disk.=0A=
=0A=
Without this patch and Mike's proposed prctl() patch adding NOIO through=0A=
prctl() in tcmu-runner context, memory reclaim recursions causing=0A=
deadlocks are triggered very quickly.=0A=
=0A=
> =0A=
> Thanks,=0A=
> =0A=
> Bart.=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
