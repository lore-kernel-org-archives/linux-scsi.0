Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70375C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 18:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbiDYSxD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 14:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244614AbiDYSxC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 14:53:02 -0400
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50CD89CF8
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 11:49:55 -0700 (PDT)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay.digdes.com
 (172.16.96.24) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 25 Apr
 2022 21:49:52 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Mon, 25 Apr 2022 21:49:52 +0300
Received: from smtp.digdes.com (172.16.96.24) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Mon, 25 Apr 2022 21:49:52 +0300
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (104.47.17.108)
 by relay.digdes.com (172.16.96.24) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Mon, 25 Apr 2022 21:49:51 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQ40VxRxgKY52cse9DWfY4JdnAQAvCEi/QUHg1JmODgKUciKibA67vTR3omkGfbirai8RH1wt2cQbmEnGzTkDhjBdOsSVKDEgHkgwWIaeGp4tHKW03V30yihi+2Kz6hc96K/dnnEdF0BMNXpC3VOeHYzcmzfvViReDMoGrtyCL7XwUejEfuhZJO6PEp8sz/o5Yz41tPSNaCGVjlAAtoNEwiGbvrt54FNinc1gQ4ZsqqOySEkwmnRs1SktkEVivxGPHFAaiAfyXv63m7YuyWLLKYka1DqgTju7jl7FqRvDt6cZcS+XpLf9FX96biSlCkaHDRsSDsj3JRrP1cn7StgNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUKu3dfpuSdMF8z3RQ7ZLkiyijkxbINOMuSLQuZeOLE=;
 b=GOePADR7mMyvj2k7C8mTrIKlWWf9af8zbdDuXlW8yVCmKaG50EkgBgAim8o6ftHfaNpqA+KLu43hnULx1N8TWtBiuIoLOJpEQ0zOy5x8aOI5zSy6lwFGHesadPAjnTKj9PJzJ9mjdn67CJ3uhM5/2CTAiQnWPKtzwFxK7zmTQVNk8z+9QmEJ89fdIEgcPaguqpG9HJJf7e8O/BVzUbzXikuejHywT/MKPhd+NAERGeAtRycW3Sbp5yq8vkuqOJvfGRBogXtQ7/9A7+z+4qCsr7gxzb/NHCjhpaFwJGoVPVkLBFYygwK/YohKgqobBOEcsNHiV8gA27ksOTENGLQkXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUKu3dfpuSdMF8z3RQ7ZLkiyijkxbINOMuSLQuZeOLE=;
 b=ZHjz97Tz7FgZdsDcrh+nNEXg1X2mP5xSjXN5fJz1n05DfxnG0h7J8qwehocC8KsQ5/SEqd9GDolay4ZqxVjirI4Xp7TGe+ruTxPncKnwNsloNwyjt0/Kv8YrXjbv60fbPQwsurK1wUoE3H64YD/bVc1r+7pPJLRnbDU6vp1X5hs=
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:403::6)
 by VI1PR1001MB1216.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:67::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 18:49:48 +0000
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::74ca:aa66:a112:d987]) by AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::74ca:aa66:a112:d987%3]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 18:49:47 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Topic: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Index: AQHYUMYtkLBbKidY90SJACyXGZHZ2Kz3qV6AgAE75LiAAE2AgIAHyTkk
Date:   Mon, 25 Apr 2022 18:49:47 +0000
Message-ID: <AS8PR10MB495233A032E7425D1DAE9D549DF89@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
References: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
 <4FA3632A-690C-470F-8DEF-663F9AC0CFC8@oracle.com>
 <AS8PR10MB4952FA41BCC382A6464D842A9DF59@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
 <F1592489-7C94-454B-8EF3-BF5C56F48A10@oracle.com>
In-Reply-To: <F1592489-7C94-454B-8EF3-BF5C56F48A10@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 758f5d18-c5f0-fe4b-7bad-9d86faae232b
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b765c74-f144-4cf6-9f1c-08da26ec5f29
x-ms-traffictypediagnostic: VI1PR1001MB1216:EE_
x-microsoft-antispam-prvs: <VI1PR1001MB1216448481579480D4FCD25E9DF89@VI1PR1001MB1216.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTOxVIF1NoAwfpyOP1K57qse4zRAfRpSZ6kbKm2bLAtWKmAGVNe0J5l23K5aQJi3IWAEPrAJO0vIOr6BqVCnJnAjg9A51cynDVjaI+UzduNTO4RcCGJeg3UqRTacFuDGV/wBkI8a5gGXgsS1Ob2305kOxlqLeuVKzy33IeFyE/+Azkll3l2MM0/xVypJ73mQJTy1M9d5eTzDpN79wMljMMZkO3W5gVTaaCcu/AzXf8f8rzaMARbfwwaTkyT2IzJhv2ThGVaRUVkJtgW2ndCcWwCfKbT5gO4b7sHRwe57Q+fNZDtSibAKoU/z4/yX74BPHzGZN3obE6xZ0ZHQAuCbACC9zKrgNUdDmZZfV4CU73shwPPoM+aAUVNa8rGvqcKqGVg+izCt31ljJZIc3dQaQ6SI7DhQi9Si582W41/C0SzX/K8yoDuL7/eJBXDMb7ntPI97Mr1sIPK0u2r6fVVdOr16/A2aS1m6sUFjDSS7OilavfWQSbfr5bOhxxhydljm3Vgn266zgiy6KujNzeOSyk4xecODrEVy2qaM9I0TOtaEN/vZmEc4mHw6Y/cpy3dPrbt5EZbPsEOUi3C53+iMqmC8+I/klUPKtarAtj0aT1UHuu88oic6nOVvB6k1fI3zFbC8FbV5UybUqL3OjWLENgzQqs37kxHPSzhdvcDMiyaFbk33dC6HQuz3pWu6pOPzDaA94HhRlaXeRkioCVqwdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66446008)(64756008)(66556008)(66946007)(5660300002)(8676002)(186003)(38070700005)(91956017)(38100700002)(6506007)(26005)(6916009)(9686003)(53546011)(7696005)(316002)(122000001)(76116006)(86362001)(33656002)(55016003)(2906002)(83380400001)(52536014)(508600001)(71200400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NotL7rp59miDbCBxd1TqtV54vmNDQIaIDLQ8zDMUBrHwWsjw7QJ27dN4NL?=
 =?iso-8859-1?Q?8HDhGUSV1xNMM5XgBgxdopVTo0Uipql+jfUHRevx5c+YVCea1aV21LT26k?=
 =?iso-8859-1?Q?IBd6Qn0BP4hHhRxB2L4Ei8gktxXb53Ad1ge12nB6XVVpnRbTr1Ye1hQ5AE?=
 =?iso-8859-1?Q?M99AWZZeGS9rAkCVuyZ1Ou6uNEPtSsjW+ypb96sGXvUoqZAAM6m2Ky2x7w?=
 =?iso-8859-1?Q?83VNb6K6ChinEnTOeGHxSkww6ZG00K/l/jwcrdAsyV3KJ8ai0ciYfn8BQE?=
 =?iso-8859-1?Q?1GERRCTXMJPOgnoUPEoEdVm7JXJmWCjSVNz8cGV0B/4fWoj0QA0ZZwl57D?=
 =?iso-8859-1?Q?4ZBMl4o5g53H+Vf7mnDA+oxKvvu62CY/n2vZvq6aEa5im7/WEkfMa/81Sa?=
 =?iso-8859-1?Q?4CfoSqiOrcZ/VOBdOUMr9GRtvxVbDk9vJ7K9h5g3RrkNR44jCJOFUAMSCf?=
 =?iso-8859-1?Q?LMAkh9Ogyc2oXwt/GrTg9l6O+HPaqxA5WcfzGguB8bjrlXH7y5da1lyXNg?=
 =?iso-8859-1?Q?mPDr0uara3W+J8U4PFGnUMdidlxBtB8NWbkwQ7uTD91Ox9t1YH+7l2vErM?=
 =?iso-8859-1?Q?9KMOXlLOR7amvCZoZZldAOWq6xqdRdKVmGPRhGN0pusvVwCQWK8dTnw6Ox?=
 =?iso-8859-1?Q?RQHq40q8ENK+IDgeigtzecygBdAtf3CyYDqniv3qBcE/aOMzACKYk4mlss?=
 =?iso-8859-1?Q?c66vHxq9izv3T/pfijep5pHYMupJLsaOE6Q7p4jF/n0wqlc4xssrCx0l+2?=
 =?iso-8859-1?Q?IxHdyI/9VS+5BBbymAnIMSwMvV7VmpxyssFoqh7eBrfibjPPKeaUMRfa1h?=
 =?iso-8859-1?Q?x0aXIMo7JcV1GWXxlHDroCoqzH0gC83GJb1V4KAPPlpO2ZBrBcli6sXkDA?=
 =?iso-8859-1?Q?2NSh4egI05AHzEaItxKMoOPcibly1Wx3ZhmIA+VFUG+wXMDOOZrd2EZ4Yo?=
 =?iso-8859-1?Q?w7QtI+V/iaTj6R3dsXX4rfQp9zGLPlTrj0r5dq8gisZ9NE7YxjsXncoXVg?=
 =?iso-8859-1?Q?vOBAbxWJmdrlN1oLqYfeAKYdz4VwbZvpekuOlZhX52UhVG19GgT0LNS5I6?=
 =?iso-8859-1?Q?zRVREd0LFOAFzExnkoBsj4oUcz5200mPjdlT61ez4pjR0I5uG/9EE8Fn/9?=
 =?iso-8859-1?Q?F9dgDC5dCZhGt6KWGXfam7xF5qGZbuqBqqmVUSgoiyRWKgbR9+06a2hGTJ?=
 =?iso-8859-1?Q?RPAmmlQ9jlW9cuhrBlu34HSVl0GQLeqEQ4IKU7bZrS2AI9lvvRNvOfgf1U?=
 =?iso-8859-1?Q?dPfHJIiaCO+Q0xxpnV5FnxomPIrbkfYzllN+yNQ3hdmOlVxXvCWOiP+e4I?=
 =?iso-8859-1?Q?iH3HiSQAHLxKhkwixnFnGvHtbztFeuk/BLoxDVjk8N+8Y/SsAncHVtffMZ?=
 =?iso-8859-1?Q?9f8YmWJ/rMp/xjXp1rJdQ3xAeezfweUq3unv9lZZ9X4I95t4Bq7aX2Aznx?=
 =?iso-8859-1?Q?ltPRS97dwhhY2JdQKEvyy8r3i2ORyHlH6WWAOuU4fWtcY0elkKMa7WJBsN?=
 =?iso-8859-1?Q?7mLp9XejsmfPFKGEWq5P9QmvLT6SSBIcvV1di1aKwBydKlyKz6w2tgu6bY?=
 =?iso-8859-1?Q?lSl2f9ttfsDGBIWdwOJXbpO0P+LISKS+XeOuDkEric5Qavm9cs4NEcNPys?=
 =?iso-8859-1?Q?jnBrUVieYF0jxyNZaNgEZeFEcGjphUr2Lz4R83wLJVwUXyGG9KCbzwwnva?=
 =?iso-8859-1?Q?dtllpr9/naUNpWQzmlnwwmkv8VXpjnYl95YPZ/U2fJqTB5bBRjGOz/p5pM?=
 =?iso-8859-1?Q?v0lpMGkLJWvmrZqBx47UA2dDzOjrpxBADhEAs9Y8CMADaFboHbiadDjVJN?=
 =?iso-8859-1?Q?POX9lcvg4g=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b765c74-f144-4cf6-9f1c-08da26ec5f29
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 18:49:47.6734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aDBTlJCluJYp6t5JySoHoV8YabPeg+tqa8QYaHdhM4nRbOFL2WQ9zTO7KDWzcofM0Rg3xOf1BtpPSH4pkkebqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR1001MB1216
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> On Apr 20, 2022, at 7:42 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wro=
te:=0A=
>> =0A=
>>> Do you have a log showing this error sequence?=0A=
>> =0A=
>> Yes, I have, but the problem is that I have a different target stack, no=
t LIO. So the Call Trace basically contains code sequence from this target =
stack only,=0A=
>> except for the call of the qlt_free_cmd() that trigger BUG: BUG_ON(cmd->=
sg_mapped).=0A=
>> Regardless, I think the problem lies on the qlogic driver side, because =
it is responsible for management to map/unmap sgl list.=0A=
>=0A=
> Agree. Am curious to understand the test case/steps that would trigger th=
is issue in your env. If you can share your test scenario would be a bit mo=
re helpful. =0A=
>>=0A=
>> =0A=
>>> Can you share more details?=0A=
>> =0A=
>> What I am observing:=0A=
>> =0A=
>> 1) Command processing calls qlt_rdy_to_xfer(), maps sgl and sends a comm=
and to the firmware=0A=
>> 2) Qlogic adapter reset occurs=0A=
>> =0A=
>> qla2xxx [0000:82:00.1]-5003:13: ISP System Error - mbx1=3D110eh mbx2=3D1=
0h mbx3=3Ddh mbx4=3D0h mbx5=3D8a1h mbx6=3D0h mbx7=3D0h.=0A=
>=0A=
> This message indicates there was a firmware crash. Qlogic/Marvell folks s=
hould be able to help you capture/save dump. That firmware dump might give =
you clues on what is the cause of the firmware crash. =0A=
>=0A=
>> qla2xxx [0000:82:00.1]-d01e:13: -> fwdump no buffer=0A=
>=0A=
>> qla2xxx [0000:82:00.1]-00af:13: Performing ISP error recovery - ha=3Dfff=
f9dd7d6058000.=0A=
>> =0A=
>=0A=
>> 3) Somehow the command is being aborted, so that means the command's abo=
rt flag has already been set.=0A=
>> I think it may happens something like this:=0A=
>> qla2x00_abort_isp_cleanup() --> qla2x00_abort_all_cmds()=0A=
>> =0A=
>=0A=
> I think this is the aftereffect of a firmware crash and the driver is jus=
t recovering from that. A good firmware analysis will shed more light on th=
is issue. =0A=
>=0A=
>> 4) The target stack calls qlt_abort_cmd(), and since aborted flag has al=
ready been set, this call ended as multiple abort.=0A=
>> =0A=
>> 5) The target stack calls xmit_response, and since command has already b=
een aborted, this call starts the code sequence to release the command that=
 ended > with qlt_free_cmd()=0A=
>> =0A=
>> I think I could try to reproduce the problem with LIO target stack, but =
I have special case with my target stack that lead to reset of qlogic adapt=
er (ISP error recovery) and this is one important part of the error sequenc=
e. So, I think I will not be able to reproduce the problem with the LIO unt=
il I find out how to similarly reset qlogic adapter during processing activ=
e commands that have already been sent to the firmware.=0A=
>=0A=
>=0A=
> Himanshu Madhani=A0=A0=A0=A0=A0=A0=A0 Oracle Linux Engineering=0A=
=0A=
I seem to know the cause of the firmware crash. This is an abnormal sg list=
 that is generated by my backend driver and passed to the Qlogic driver via=
 target stack. The abnormal state of the sg list in my case means that it c=
ontains more than a thousand nents. So apparently Qlogic adapter does not k=
now how to work with such buffers.=0A=
=0A=
In any case, I think that the main thing is not to find the cause of the fi=
rmware crash or fix it (because it actually comes from my side), but to fix=
 the crash during recovery the Qlogic driver after a firmware crash.=0A=
=0A=
I have special case that allows me to reproduce the problem, but perhaps it=
 can be reproduced in other cases that cause a firmware crash. Maybe there =
is a way to manually cause the firmware crash and it will allow to artifici=
ally reproduce the problem?=
