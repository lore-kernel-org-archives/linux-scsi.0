Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D33FC0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 12:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbjGZMl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 08:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjGZMl0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 08:41:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32921FC4
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 05:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690375240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5fpy3uf16L5jWl3A9n09ZhtqPu40Emy0OctKG7C31qA=;
        b=b8s2yNX194mwX2kACZ/LBMgCPAf11FVeou7z0679GZ4CIcCYF6dr6ZnJeQmxRyYlEPAxm1
        gLnLagVpPBxx2jG/qWdRGyOkWGMyhw5j0TaFJJao05AeiONIbU4E/K3gcs3p6GIdc4TmTA
        7yCFc/y9V0vOqkTmlKQGPM7/zr1eiOs=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-B-BZbtwdODeTDedSz4SsPg-1; Wed, 26 Jul 2023 08:40:39 -0400
X-MC-Unique: B-BZbtwdODeTDedSz4SsPg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1b439698cd8so12160611fac.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 05:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690375239; x=1690980039;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5fpy3uf16L5jWl3A9n09ZhtqPu40Emy0OctKG7C31qA=;
        b=BD+larJya/Kp94A2SbMa+omHo+HHzNVZ0MTaYyyyAw4sW4idd6rE0JmwKfn/y8ed6A
         SOYMZKmziFsZgtrESb4yKAN54B7d2+0pZNq2V6k4xJfTPb+VyUX0OpvmQk1OGQyz9kqA
         aqf0hWYhmR22hbilH+6RgbfyNsI31jd0x/JAxuK/hbbxq0Pyh+TOY7qSRdUYKUyoaLOF
         zazDIe593bBNXgB7qfFLRGz5oy458Rv3KMJdX0XMLCWugi0tXY4bIkz2LTkd1pyALPZq
         leAXegXvXAfmD7C3shVCLbLy5+cegkBWVpQby0g4AqxSXIfxTnnIceegbNb4HPP7f9tW
         8Z2A==
X-Gm-Message-State: ABy/qLaFnXtvDgi7UJ8/8PTJnpEOMee/BY3tARG66YM03yOILASvrIed
        3MssTOhOVI1sd3Tc72AzmImnp/G/nxUqr/iRXNbIAZcfeDIjVx0pzwhIQ5w9r/oEa794YM/fIW/
        /4QWTqoNPPTcSbGjLiWdSXA==
X-Received: by 2002:a05:6870:6488:b0:1b7:2edd:df6d with SMTP id cz8-20020a056870648800b001b72edddf6dmr2395893oab.10.1690375238752;
        Wed, 26 Jul 2023 05:40:38 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFDDOMPbwL1wRk2nLrKhuC7u3e/wnaFaI5HPljpUAYP/ts9jgJgI7RZxXQYccnHEX5NrXsruQ==
X-Received: by 2002:a05:6870:6488:b0:1b7:2edd:df6d with SMTP id cz8-20020a056870648800b001b72edddf6dmr2395884oab.10.1690375238489;
        Wed, 26 Jul 2023 05:40:38 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:2613:173:a68a:fce8? ([2600:6c64:4e7f:603b:2613:173:a68a:fce8])
        by smtp.gmail.com with ESMTPSA id z7-20020a056870e14700b001b3d67934e9sm6418254oaa.26.2023.07.26.05.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 05:40:38 -0700 (PDT)
Message-ID: <072c496c98e84a9dcafc21a8de72c53e109f54ff.camel@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx avoid a panic due to BUG() if a
 WRITE_SAME command  is sent to a device that has no protection
From:   Laurence Oberman <loberman@redhat.com>
To:     Quinn Tran <qutran@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jpittman@redhat.com" <jpittman@redhat.com>
Date:   Wed, 26 Jul 2023 08:40:36 -0400
In-Reply-To: <2b32f4404ab90a8842d27f0d8c0c0474c2dd984a.camel@redhat.com>
References: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
         <yq1r0plkc4x.fsf@ca-mkp.ca.oracle.com>
         <e27a1fe9be4778a9114dd7e5349ecac107d45e7b.camel@redhat.com>
         <6f7c0c5a86ca6e36babea3847288820b08354c3b.camel@redhat.com>
         <BY5PR18MB3345E19940FBB7F603AE0B8AD536A@BY5PR18MB3345.namprd18.prod.outlook.com>
         <2b32f4404ab90a8842d27f0d8c0c0474c2dd984a.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-07-12 at 09:25 -0400, Laurence Oberman wrote:
> On Wed, 2023-07-12 at 00:34 +0000, Quinn Tran wrote:
> > Hello Nilesh and Marvell
> >=20
> > Any chance to get comments/eyes on this please.
> > Given its causing system crashes we need to decide how best to deal
> > with it.
> >=20
> > QT:=C2=A0 Laurence,
> > In understanding the severity,=C2=A0 Does end customer uses
> > sg_write_same
> > as the mechanism to move data?
> > Other than the sg_write_same utility, how common is end customer
> > uses
> > 32Byte CDB?=C2=A0=C2=A0 It seems like upper layer doesn't=C2=A0 have su=
pport for
> > 32Bytes CDB at this time.
> >=20
> > The code path you're modifying is for the T10-PI disk.=C2=A0 This disk
> > is
> > "non-T10-PI" where it may create some confusion for next reader n
> > Martin on why we've wander down this code path.
> >=20
> > Will queue up a patch that plug this hole.
> >=20
> >=20
> >=20
>=20
> OK, Thank you
> In this case the customer was specifically using sg_write_same. I am
> not sure if it was part of a script or some other use case.
> They were of the opinion it was severe enough of an issue to warrant
> fixing so they logged a case with us.
> Thanks for looking into this.
>=20
> Regards
> Laurence
Hello QT

Did I miss an update to this. Was another fix sent.
We need to deal with this at Red Hat as soon as possible please.

Regards
Laurence

