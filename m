Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCFDC001DC
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 13:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjGaNDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 09:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjGaNDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 09:03:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F58DB0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 06:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690808576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oB/6Dw9oBXzBWfOZqL5p67VYB6V8gUZZfJBgQJdcdPw=;
        b=hnJkpy3Q3Or/AOYjfPVVyFUUVjoALjybcFyJB2bWq83/OTG4Iv8WboqLS+KochkSgR0hgn
        6k3zrMqu89qBo9LHRjL1UaPCovJBQJ2zk6BgSWhUSgpcAn/tZnCC5UxiyQ2e4Z+UYc/DTJ
        QsEegpzhpC624WPH0IzsgfozTfi8CcM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-qbdclVDwN5ejyPMynuC-IA-1; Mon, 31 Jul 2023 09:02:54 -0400
X-MC-Unique: qbdclVDwN5ejyPMynuC-IA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-63d09e8bc06so34142746d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 06:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690808574; x=1691413374;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oB/6Dw9oBXzBWfOZqL5p67VYB6V8gUZZfJBgQJdcdPw=;
        b=AT01xSHxnpkWYd/isNBpsWowH6R+3N6vZgezN0aASCrBFtlykSU599DxoJuwI8HUGT
         chDOEkXLxi+cEutq6XNR3jxnNVVP+kPhEhDWidPVHdrkRkzl6fTJqEh0xpHfWFY7j1hU
         IZgKprqy2IFZ+4m0tOBj45mIO2hGVsu86KrXolrRN94vzQoEbG50VHkOVy56n4jp6Vtw
         6cVP1NFunJe2vcwqFm1HDndPCQsuzG1emRKSKoScwOi3sxEqI7uPqjuw7OpzcMCsCw3M
         6ypGcH+66eBy3j/uHNS6stBwu36pdehgAe8InvBubGA9t6PHFc3B29skDEau2pH+0Csd
         KWtw==
X-Gm-Message-State: ABy/qLZy87Hw2LcqKD9WcJfX7S1EslIQ7oIQmJTgjPIYJSRGkwb6ghvb
        v5zJv35Zvepx9JyN8E241dXZO3o7QlqZkNii49qL6aM3VJurCclBYlT7O3VV5HpyQn42VM5uCdk
        5kXRRCoef0jj/t602xHMOqw==
X-Received: by 2002:a0c:b39a:0:b0:631:f6f1:87e7 with SMTP id t26-20020a0cb39a000000b00631f6f187e7mr7192823qve.58.1690808574149;
        Mon, 31 Jul 2023 06:02:54 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFG7i7zXx55Ghhvh9pE7o3oxIcnFeD8Xg5y9v23E6xZBuyoPDt+Q0Bel0JKnZXaWqC1K0Ls9Q==
X-Received: by 2002:a0c:b39a:0:b0:631:f6f1:87e7 with SMTP id t26-20020a0cb39a000000b00631f6f187e7mr7192776qve.58.1690808573670;
        Mon, 31 Jul 2023 06:02:53 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:2613:173:a68a:fce8? ([2600:6c64:4e7f:603b:2613:173:a68a:fce8])
        by smtp.gmail.com with ESMTPSA id f12-20020a0cf3cc000000b006362c5760f8sm3746898qvm.139.2023.07.31.06.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 06:02:53 -0700 (PDT)
Message-ID: <2471a07d0599962e8a341e06f86e1e92d55928cf.camel@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx avoid a panic due to BUG() if a
 WRITE_SAME command  is sent to a device that has no protection
From:   Laurence Oberman <loberman@redhat.com>
To:     Quinn Tran <qutran@marvell.com>, njavalai@marvell.com,
        Emilne@redhat.com
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jpittman@redhat.com" <jpittman@redhat.com>
Date:   Mon, 31 Jul 2023 09:02:51 -0400
In-Reply-To: <072c496c98e84a9dcafc21a8de72c53e109f54ff.camel@redhat.com>
References: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
         <yq1r0plkc4x.fsf@ca-mkp.ca.oracle.com>
         <e27a1fe9be4778a9114dd7e5349ecac107d45e7b.camel@redhat.com>
         <6f7c0c5a86ca6e36babea3847288820b08354c3b.camel@redhat.com>
         <BY5PR18MB3345E19940FBB7F603AE0B8AD536A@BY5PR18MB3345.namprd18.prod.outlook.com>
         <2b32f4404ab90a8842d27f0d8c0c0474c2dd984a.camel@redhat.com>
         <072c496c98e84a9dcafc21a8de72c53e109f54ff.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-07-26 at 08:40 -0400, Laurence Oberman wrote:
> On Wed, 2023-07-12 at 09:25 -0400, Laurence Oberman wrote:
> > On Wed, 2023-07-12 at 00:34 +0000, Quinn Tran wrote:
> > > Hello Nilesh and Marvell
> > >=20
> > > Any chance to get comments/eyes on this please.
> > > Given its causing system crashes we need to decide how best to
> > > deal
> > > with it.
> > >=20
> > > QT:=C2=A0 Laurence,
> > > In understanding the severity,=C2=A0 Does end customer uses
> > > sg_write_same
> > > as the mechanism to move data?
> > > Other than the sg_write_same utility, how common is end customer
> > > uses
> > > 32Byte CDB?=C2=A0=C2=A0 It seems like upper layer doesn't=C2=A0 have =
support for
> > > 32Bytes CDB at this time.
> > >=20
> > > The code path you're modifying is for the T10-PI disk.=C2=A0 This dis=
k
> > > is
> > > "non-T10-PI" where it may create some confusion for next reader n
> > > Martin on why we've wander down this code path.
> > >=20
> > > Will queue up a patch that plug this hole.
> > >=20
> > >=20
> > >=20
> >=20
> > OK, Thank you
> > In this case the customer was specifically using sg_write_same. I
> > am
> > not sure if it was part of a script or some other use case.
> > They were of the opinion it was severe enough of an issue to
> > warrant
> > fixing so they logged a case with us.
> > Thanks for looking into this.
> >=20
> > Regards
> > Laurence
> Hello QT
>=20
> Did I miss an update to this. Was another fix sent.
> We need to deal with this at Red Hat as soon as possible please.
>=20
> Regards
> Laurence

QT=20
WStillw aiting on you guys and we need to get thjis fixed,
Please send the fix upstream that you were thinking of today.
Regards
Laurence

