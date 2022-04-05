Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CECC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 10:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiDEKzR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 06:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348193AbiDEJrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 05:47:12 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D108EA778
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 02:33:26 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qh7so15405040ejb.11
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2022 02:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=3DOTWF+v7LKn4npCmHoiswZmBh92qJ6RD1XtNsMouFs=;
        b=TwbRgC8xhEgVLicRhUYJGvH3qVh8nfglMkeLYFUlz83Irf8mLjU5vY8vhpjI8DcFwe
         2dl8MASt+2fCbcos0VGehTdOsw7oXVdQVKz/O8UNV+qZGw5axMkkIhudGfDDGzabfnws
         Gsf+THg++vzkdM1OanLhwm/BW4EMmbEvJQlVfVfddwfH1A9zyU+qRda3KGELOlVj+k8e
         TYujERd7Z7p10xqZ1W7qNTPacJHEc8kF76o0ts45oUtOaTFIl9CXnyWSX1yIFR7fMwzb
         rt3mQrDKqVxKPzs+dy9rd0lEAdLriWr2ZVQ1VLaJOz6Im1XHmBn5mtw8sMlfxqW4UcBf
         OWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=3DOTWF+v7LKn4npCmHoiswZmBh92qJ6RD1XtNsMouFs=;
        b=PbdNqaJ82yyaHIrHdBBqAP6PAoIcqDW4oWvRgbPt3wPFhqn3pxEhhVShS2nqmWhquX
         NCygU9b/7bcKw608R0AIsx7Jr+eD8ObujRiprKoR5YDjZSMbGs0TkdFDSx0fUO/udVwU
         9CpwtiBA/2n11LOaHa2elkaQWZy04cH3k7Lg9RNtGC/RMtu0FRw11mwRZA09z+oXehTX
         fKa4ycZbGqhBMYF8xfeVNgCFAZ23zjzfgqU7ABI5JHDbOyVYc9gQH5gSHn6jzfJLsa5m
         sLhc6GCUSqqX7G6CFgQrHLIpogtdUP5099nFQxNpRsPYYLqcgPhSwSEOAGxUT2E0lv+D
         w8fQ==
X-Gm-Message-State: AOAM532mTyfQsV2csj7pmieK7vpN9IgnitMCLtPivDdHuw+Ho6RsUCjs
        apxTl4WafCcPCv26EeyYtBQ=
X-Google-Smtp-Source: ABdhPJzolNvDKMa49b2Tiy5fBDrtAD+7x5c8KcaxxP6HP2R3x3gu9aHG+jzwpKPHfJNhPCDRfdXC+Q==
X-Received: by 2002:a17:906:c0d6:b0:6ca:457e:f1b7 with SMTP id bn22-20020a170906c0d600b006ca457ef1b7mr2506558ejb.399.1649151204815;
        Tue, 05 Apr 2022 02:33:24 -0700 (PDT)
Received: from p200300c58701849e9101f49281d8361b.dip0.t-ipconnect.de (p200300c58701849e9101f49281d8361b.dip0.t-ipconnect.de. [2003:c5:8701:849e:9101:f492:81d8:361b])
        by smtp.googlemail.com with ESMTPSA id j26-20020a1709064b5a00b006e808a933f4sm647421ejv.123.2022.04.05.02.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 02:33:24 -0700 (PDT)
Message-ID: <2eea6ffcd83233a93a8a7ebfc24a58516cd6e79a.camel@gmail.com>
Subject: Re: [PATCH 00/29] UFS patches for kernel v5.19
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        quic_cang@quicinc.com
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Tue, 05 Apr 2022 11:33:23 +0200
In-Reply-To: <5073d69e-20c4-0fce-a045-47c52e2d3424@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
         <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
         <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
         <DM6PR04MB6575DBC3CFAD57F5AA19DCF8FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
         <9bff98fa4a4a8a61a5c46830ef9515a7dfddcb89.camel@gmail.com>
         <ebf3cc31-9cd1-3615-b033-06bfc7d25b9a@acm.org>
         <94902f1e26a18ff7774dc429502bef7d54f23b5d.camel@gmail.com>
         <5073d69e-20c4-0fce-a045-47c52e2d3424@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Mon, 2022-04-04 at 14:13 -0700, Bart Van Assche wrote:
> On 4/4/22 01:12, Bean Huo wrote:
> > Very interested in this design. I'm assuming you're still going to
> > continue parsing SCSI commands. Can we also shorten the UFS command
> > path?
> >=20
> > Meaning we convert block requests directly to UFS UPIU commands?
> > instead of like the current one: block request -> CDB -> UPIU.
>=20
> Hi Bean,
>=20
> Is there any data that shows that the benefits of shortening the UFS=20
> command path outweigh the disadvantages?=C2=A0


For performance improvement, according to my test, if we abandon SCSI
command parsing, we can get 3%~5% performance improvement. Maybe this
is little or no improvement? Yes, reliability issues outweigh this
performance improvement. Error handling and UFS probes should also be
rebuilt. But most importantly, it makes UFS more scalable. How do you
think about adding an immature development driver to drever/staging
first? name it driver/staging/lightweight-ufs?


> For other SCSI LLDs the cost of=20
> atomic operations and memory barriers in the LLD outweighs the cost
> of=20
> the operations in the SCSI core and sd drivers. I'm not sure whether=20
> that's also the case for the UFS driver.
>=20

I didn't take this into account, maybe it's not a big deal, since the
UFS driver might use its own lock/serialization lock.

Kind regards,
Bean.

> Thanks,
>=20
> Bart.

