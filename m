Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87573C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 05:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55AFD224D2
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 05:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbhAKFZA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 00:25:00 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:35287 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbhAKFZA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 00:25:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610342698; x=1641878698;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=79h993Jl6+/qkRQI1EalaSmOGtQDGy0quYZPWB50PC4=;
  b=HDs9yPMNXzto4INWSCpM6idShddUph9EKfyq5p200TOk+kD1XXJlAu9m
   Y4BGIxeMeKmCLK6HQr5FaMtIs6oH8XceXxYeIkXj6yxuSikut+OBSnQT0
   MGIYWrjcZCFdI3hKe1EmMRWYh7ezaSDKD1gWikGDc0MFsy8DLnoS3y5Ae
   F3SKvUjc8PWx4e4tu9ylpPV+ZAsHI2DB0zumGgC7Oq8nc9HKvFM72JgWj
   a9r16iaWO4l3rLP7+WKcIibZgg1D5xh+Qc0Lk8ysT2/Jo62pue0MdeQPU
   2IDQIS5arQSYTW/u48jj4jzVNxFLutq5Ecupvg8mXEEhNJebJuJ8xOyJ6
   g==;
IronPort-SDR: +tTv24krX1JQEeQ6Z1zvSGv8izcYttkdBTpsVztJLNn04SDsavbfb6unt9smCqxKBGLfbwznAE
 zADMu5it7QXK14yduFN706iC1Ms3QNWOu6/yDHiXPRgm1fUjcQQpbeNogaSCiKbqZRk8ojFbYk
 cTY7GEg93p33S2/D5ZD+ZmOQ7ZHXffzXKpKAMnEw7XuaExdSIoBAk0Zt4ZGKiMqoVOt0YExBzk
 sHBUspBcM7qShxX5phDnB1bp9TbLdmKWyr4TJFN5XlINsr7hps5T/nvC+PEw6/S1Ur5SVdKQ7a
 e3U=
X-IronPort-AV: E=Sophos;i="5.79,337,1602518400"; 
   d="scan'208";a="157124335"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2021 13:23:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TS8wpydZ85ub8BKyD4BhI6q/srLeiVAzE1sCtfd885XEdda8k6rDh+uzbXPwpFf87GmQnOnxzW4sLvhiM8N+1gCxRL0qQpqe2N5L1vmcfR9JBBQyuRjuSpnRbAD/dOOOzkahvTFtZapzMm02GTnu3FWbfo+R5uzb5e4V+YMzaXjpEqvyLv8g3L6xjuk1Ae8aMklW0lZQVNdC6IlXydhC7BdhiqoJCvR8bE/RMV6XVPZlG8siyCdS88h+v2qTsyXoJFKqmXvzsW29yLlhKhcQNEl/Lhm/tQ6GT+CCbWdAQFVvb7h8u+m7II4s1EFMwxcmt2bWcL2Lp8jd8o9aDF6ndQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79h993Jl6+/qkRQI1EalaSmOGtQDGy0quYZPWB50PC4=;
 b=bigyqmx+CYQbHXT5tNvxlEO3S1fLAISbHGSehds+qjGm5N+qkJXQPI9uSVhCoEO6TH65uNxG/mOfnGtcqtiyDj+4kvK/Kdf0c4YPsD+AVd7CbWaGZ03Sdu7Yzt56AOpwKxPJkW+jsNCVo1TsHVuBpJtqw1nZ/xk+Rc+6rxVr7GdiSeiRXycBreOuZQtI/wEYnztP7YsA7CvPVxtDneoBn0N6+xTmFjOns0HyLanxoO763+rodIEYxTIrEVC9UMVONW86Z8XwP8p7/pxvfkb1/KSLda0WQ0RKx8M1RCys7x454y+2koiDoYL9nG3wrqMUP3AMJEKWkpWNVtJHAQs2hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79h993Jl6+/qkRQI1EalaSmOGtQDGy0quYZPWB50PC4=;
 b=0Cih/vmKDqZ1f4kVJ1cl2IS9dAVBJDsai9e2ZtnY98eO9TaE+u/zRYNHFnZLQUHm0Y768oj0KInv8HvLS1iw+Xlw/wvzCPJ4xzC78j27DH4K4uJ4I2A5e6f1UXGnsbju/9hhRgQWIYvqCw8KYH2Pxk3REfxHzwtD5kJoLsH7GbY=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4039.namprd04.prod.outlook.com (2603:10b6:a02:ab::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Mon, 11 Jan
 2021 05:23:50 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 05:23:50 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
Thread-Topic: [PATCH] target/file: don't zero iter before iov_iter_bvec
Thread-Index: AQHW5qBkaWm3Wnjfmk+XiYs/GS5+eQ==
Date:   Mon, 11 Jan 2021 05:23:50 +0000
Message-ID: <BYAPR04MB4965683837A93C9D863AAFAF86AB0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
 <BYAPR04MB4965F4DCF59E5225CF17322D86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <4d063dde-c710-44e3-31b9-8fb6b7e1d952@gmail.com>
 <BYAPR04MB49653C92C7925B8C3EAEF3CE86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <b9558bf8-a7e3-c2f9-ce00-3fc2b90dcc87@gmail.com>
 <BYAPR04MB4965E008861D5B29B9E757D186AB0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <68887abc-2ef4-035e-625b-84569c1b5b24@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9c4c04be-41c5-4666-d7c7-08d8b5f1147c
x-ms-traffictypediagnostic: BYAPR04MB4039:
x-microsoft-antispam-prvs: <BYAPR04MB40392F7D7D9B61B86483F7F886AB0@BYAPR04MB4039.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hDSsu2AWpng0Il9L0aaHa1c0PnS/btWnqAO01CR9ndkWWB4LwqtD74aLxHOFIdt0qgvK9x41W6WIOlgJ4BuZURtIPgmfDVCcXpskIa4HgUt/LHeP1YI1Z/Rtwry6Qh/ZKpr86MToRQMsDiqqxszPmZ5r5BuUZjnn6pL+IpXg1vatACHITDN8FnREp2apSiYRDl33qsLi1ldLaxBnkwzOKeWaK+ymYAEek34bN9lPRi97AQGq8sFZxQNZANoi9NddMyibRPmQyhsHNinTRXHtzsjAmNKiC+YNVZkFPWqEJtAsBOECdzm7dhWSqIWziiOzDevefZ8PA9q2iOHvkbrcf9F2isvGgG1jvoGKrDWkW98tGWfMxd243XUQ+yynlvowf3EzYiU+tRmP/SyAKZyfhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(83380400001)(53546011)(66556008)(6506007)(64756008)(316002)(8676002)(54906003)(66476007)(66946007)(5660300002)(76116006)(478600001)(71200400001)(66446008)(55016002)(2906002)(9686003)(8936002)(52536014)(6916009)(4326008)(186003)(7696005)(33656002)(86362001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?oF98f1p+LMDlvHN28CxE9Ri02UhDI0Pirt4zLkaraRAXOvaClVZsuwNJ?=
 =?Windows-1252?Q?GojheJhjVHF4KskVPf3ES7tXVWqjqPWhLTM1FEBsy3ktYj0hH9A2k1OR?=
 =?Windows-1252?Q?D7sRlmYcxZ2VPvKXELrThFhP3IR0qyIQx6wnQ5mbGyGfEZsr5KKtNSxa?=
 =?Windows-1252?Q?O1NxQM3f0r10FkQMlHqHJsLdj9jrnEZdBES84J+GmPPbDyEPFJ62HaNr?=
 =?Windows-1252?Q?Q8TJPanrUXJdWm6lVm7T9SXix0x/98gNCkT0pG8i+DkmdGam/bcRvbYh?=
 =?Windows-1252?Q?K70rAqXVdB+6fXLy6l+p3ifKs/CzXHiWznxI/Azzby3uyOLatnxHGohO?=
 =?Windows-1252?Q?QIJDSivu8g+EmPJPGmWElhD6V9rVCiyN6jrrQIdKlzFC8QzwP02T3Ugs?=
 =?Windows-1252?Q?qdT0ylNhj07IVES1K9OTKALQkkj1bnFvYx6CxiJMzzysiRlImr/X+reG?=
 =?Windows-1252?Q?DtkN7MdUPP+RzMNH/68TmjbNTXBgJjRIVPoyDwHvbuxCRk+2WCX4/1DI?=
 =?Windows-1252?Q?P1c20WkKOHhBbjkITKN0pkknuEJXbN1iIpmGUljuUKsIBDQdWIXYw5sR?=
 =?Windows-1252?Q?158e6YUozTfnGyU7CFva6LdNsHxL1lLqudybELqRhZfUFiHKQuVH0k/j?=
 =?Windows-1252?Q?XHZoLYvD2HIfaLpi/FvrRT8ny4/da3hobaba599UCVl67NNWq1YI+1eK?=
 =?Windows-1252?Q?pXKi7pkpJu6AgLtX6/ibFzu5Iwp0uOXzeDfLG9jwc4842e41RkR1pb5n?=
 =?Windows-1252?Q?7YfMDWXsiKMYy2Bu+kRIfaojJ3cCvW9wxZNOlOSoBIy85Ar3uxZyXdc1?=
 =?Windows-1252?Q?aqFzzwNdcpZe9PCVYZbTTKKJTa8u5pK2yNYBmoL3VABmWcvcjU38AqXf?=
 =?Windows-1252?Q?FnjSq7+2hH6xqnmRn1YMlZTFaJDzpfH37vu1BA4HWThzVUsU/9hJGpt4?=
 =?Windows-1252?Q?FpJGi973G5NtT/Sh246xwVVUvS3ep0npVhE5B0VURjmK1K5BRHckW8qa?=
 =?Windows-1252?Q?q3YOlQdoE6pRpQeLqB/X7KiDak/v9Xh5ZtN//vwK+p+JNvCG28KZdgQn?=
 =?Windows-1252?Q?/Gr5ZeRBEpLQTnft?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4c04be-41c5-4666-d7c7-08d8b5f1147c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 05:23:50.7488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: REG/LQIMpUcc3hQ/QpJTorPCo/Dk1ev7NsKjjocFi2ebmaOrcfbnfQPv4m4zCS55weQYFeNjlcCirft1E1SouTLuIo6BzQGTYxol6pWSgr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/10/21 18:32, Pavel Begunkov wrote:=0A=
> On 11/01/2021 02:06, Chaitanya Kulkarni wrote:=0A=
>> On 1/9/21 13:29, Pavel Begunkov wrote:=0A=
>>> On 09/01/2021 20:52, Chaitanya Kulkarni wrote:=0A=
>>>> On 1/9/21 12:40, Pavel Begunkov wrote:=0A=
>>>>> I expect you won't find any, but such little things can pile up=0A=
>>>>> into a not-easy-to-spot overhead over time.=0A=
>>>> That is what I suspected with the resulting assembly. The commit log=
=0A=
>>>> needs to document that there is no direct impact on the performance=0A=
>>> It's obvious that 3-4 extra mov $0 off(%reg) won't change performance=
=0A=
>>> but still hasn't been formally confirmed ...=0A=
>> This is obvious for you and me since we spent time into looking into=0A=
>> resulting assembly not every reviewer is expected to do that see [1].=0A=
>>>> which can be seen with this patch, but this is nice to have=0A=
>>> ... so if you don't mind, I won't be resending just for that.=0A=
>> As per commit log guidelines [1] you have to quantify the optimization.=
=0A=
>>=0A=
>> Since you cannot quantify the optimization modify the commit log explain=
ing=0A=
> And then you see "Optimizations usually aren=92t free but trade-offs=0A=
> between", and the patch doesn't fall under it.=0A=
First part applies to all the optimizations with and without tradeoffs=0A=
"Quantify optimizations and trade-offs."=0A=
The later part doesn't mean optimizations without trade-offs should be=0A=
allowed without having any supportive data.=0A=
>=0A=
> Let me be frank, I see it more like as a whim. If the maintainer agrees=
=0A=
> with that strange requirement of yours and want to bury it under=0A=
> bureaucracy, fine by me, don't take it, I don't care, but I haven't=0A=
> ever been asked here to do that for patches as this.=0A=
I didn't write the commit log guidelines, as a reviewer I'm following them.=
=0A=
The patch commit log claims optimization with neither having any data nor=
=0A=
having the supporting fact ("possibly no observable difference but in the=
=0A=
long term it matters") for the completeness.=0A=
> It's not "I cannot" but rather "I haven't even tried to and expect...".=
=0A=
> Don't mix, there is a huge difference between.=0A=
Then provide the numbers to support your claim.=0A=
