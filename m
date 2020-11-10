Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E8AC5517A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 16:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 821CB20781
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 16:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="W2qHrwbo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgKJQ5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 11:57:22 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:41440 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726152AbgKJQ5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Nov 2020 11:57:22 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E29F741276;
        Tue, 10 Nov 2020 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-id:content-type
        :content-type:content-language:accept-language:in-reply-to
        :references:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1605027436; x=
        1606841837; bh=lyyCQd61cTHyfkB6+pOWirRKcJczrnPDZV7NOfvCBZw=; b=W
        2qHrwbou8w/VqwuaTCJNgq3Oe4fNliW7q9x9CeSmPdHQLMzUshjGLzprAAJMs4L7
        lYhhG3FJhZMaWtEP5o053QNylOPcCAdEBWBn2lKKssHbJOeaVGjh0rUXkM6HptzE
        ASs3RLJCEK9VBy+3pzNK9XVLQ0LmM8HZ9JAregEWnI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jvnyh2Avl7Sh; Tue, 10 Nov 2020 19:57:16 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E232641206;
        Tue, 10 Nov 2020 19:57:16 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 10 Nov 2020 19:57:16 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Tue, 10 Nov 2020 19:57:15 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        "Bodo Stroesser" <bostroesser@gmail.com>
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Thread-Topic: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Thread-Index: AQHWqJer8uRmzb6rtkKkiM47xnEK3Kml8vEAgACHroCAAMyHgIACaKwAgADicoCAAWEVgIAAQZuAgBVMpoA=
Date:   Tue, 10 Nov 2020 16:57:15 +0000
Message-ID: <45E2175E-EE3A-473C-93DD-8ED3168198CA@yadro.com>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
 <20201026131226.GA88490@SPB-NB-133.local>
 <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
 <20201027234639.GB88490@SPB-NB-133.local>
 <c3dac124-301e-df94-9d64-b3c46d4eafb9@acm.org>
In-Reply-To: <c3dac124-301e-df94-9d64-b3c46d4eafb9@acm.org>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.17.204.63]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1FD59EA1F212CD4B82679523F5CDC097@yadro.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28 Oct 2020, at 06:41, Bart Van Assche <bvanassche@acm.org> wrote:
> On 10/27/20 4:46 PM, Roman Bolshakov wrote:
>> Thanks for raising the point about overlength/underlength. If you wish
>> we can add an extra check that fails DMA_TO_DEVICE && DATA with
>> residuals only for SBC devices but note that before the series,
>> underflow/overflow for WRITE didn't return GOOD status. The particular
>> patch only changes sense code to more meaningful from the former INVALID
>> FIELD IN CDB.
>>=20
>> Theoretically, it could be good to have a configurable switch how LIO
>> handles overflows/underflows for a LUN. Then it'd be possible to
>> configure desired behaviour on a per-LUN basis. But there should be a
>> clear need & demand for the feature to avoid maintenance of dead code.
>>>> An additional question is what behavior other operating systems than
>>> Linux expect? There are probably setups in which another operating
>>> system than Linux communicates with a LIO SCSI target?
>>=20
>> TBH I don't know any hosts that do SBC WRITE with residuals as normal
>> course of operation. They wouldn't be able to work with LIO because it
>> never returns GOOD status on WRITE with residuals. I can send an update
>> later if the series works fine with modern hosts (~1 month, after a few
>> cycles of system testing).
>=20
> Hi Roman,
>=20
> I'm not sure adding a new kernel switch is the best choice. That would
> be an additional parameter users have to know about and have to learn
> how to use.
>=20
> Bodo seems to be in favor of this patch series. Are there other people
> who want to share their opinion about this patch series?

Hi Bart,

Is this patch series good enough to be accepted in this form, without
the kernel switch? As far as i can see, no one has shared their opinion
about this changes.=20

Thanks,

Anastasia
