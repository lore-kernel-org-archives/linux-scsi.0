Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387DDEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 13:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjGLN0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 09:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGLN01 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 09:26:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43AAC0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 06:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689168343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eVPtJDAcVk341xZqba5HaBav8eMywlLGldbUkJyrWM4=;
        b=S+a0CHhq6LTDhQXS2V8MR0FDMSGE4Xg2ItWLuVc8HPm3Q1Ad87ff4ZMazl29k0be28w7JK
        q1/SYCqAg9SfnVhRlD+6t212UYaSZRU7Xkzp4ouOBAT/Fe+sVjDOoKCjh2GcWn+/No94y2
        X4sKNT1F6Ov3J8xRuldr4iHFpexLpyE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-LrZlzqhjM0KYGR2ObNrYCA-1; Wed, 12 Jul 2023 09:25:38 -0400
X-MC-Unique: LrZlzqhjM0KYGR2ObNrYCA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7675fc3333eso54221885a.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 06:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689168338; x=1691760338;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eVPtJDAcVk341xZqba5HaBav8eMywlLGldbUkJyrWM4=;
        b=lIe3xdZPo6AKWvFTdcFsjFdAQ5pmqlWAQdgaUCvIwK6sPVNeetq04XkoufER5qw+6e
         lPRa9N5QdxsDHIh59gbNv2i+ZzLs8Rhwz3wFYnOl5djK74VpmI54MiV69Geo6T0SX+a+
         2X05xl9Gw2LZF+wr7mBw3iTc8DKvwQqFBm2/joIhmNrHlxm+leN6p59mBWbL3rbbX7bP
         BZoe7yP9y2meC2kwrklWpJ7Vm5JxoGlBziTbMyMPFCUIN0Wh+fmFplRNHH2KERzyCgWI
         Il2iX+1Liqu0GPBlMij0OliwuuNq+5xvwwd1KO2a4QNoogtOEPvIB+fOKht6fHykk/5o
         QtXA==
X-Gm-Message-State: ABy/qLap50idffpKAbatUoo0k26+5OZLeYGfvsUhwcM5GjJDq5RIjokX
        s/J7V10RJ9fZoCHAnGgZWcyRrIcDbk/zjt/8MV2KPP4qOv7YPBBVgwthoOOxOf3BwJd0BXOh7FO
        OhvyCFS7QdQR83dDS0VufEg==
X-Received: by 2002:a05:620a:f12:b0:765:404b:b91a with SMTP id v18-20020a05620a0f1200b00765404bb91amr1771160qkl.31.1689168338355;
        Wed, 12 Jul 2023 06:25:38 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHxQRyWQmZbeYeMVBIrPOoSSGGzJT/FirOvnxMrmvb/Lff3NYeWwQi9ss9wJw7k8EEsqRan/g==
X-Received: by 2002:a05:620a:f12:b0:765:404b:b91a with SMTP id v18-20020a05620a0f1200b00765404bb91amr1771128qkl.31.1689168337898;
        Wed, 12 Jul 2023 06:25:37 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id w25-20020ae9e519000000b007676f3859fasm2131604qkf.30.2023.07.12.06.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 06:25:37 -0700 (PDT)
Message-ID: <2b32f4404ab90a8842d27f0d8c0c0474c2dd984a.camel@redhat.com>
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
Date:   Wed, 12 Jul 2023 09:25:35 -0400
In-Reply-To: <BY5PR18MB3345E19940FBB7F603AE0B8AD536A@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
         <yq1r0plkc4x.fsf@ca-mkp.ca.oracle.com>
         <e27a1fe9be4778a9114dd7e5349ecac107d45e7b.camel@redhat.com>
         <6f7c0c5a86ca6e36babea3847288820b08354c3b.camel@redhat.com>
         <BY5PR18MB3345E19940FBB7F603AE0B8AD536A@BY5PR18MB3345.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-07-12 at 00:34 +0000, Quinn Tran wrote:
> Hello Nilesh and Marvell
>=20
> Any chance to get comments/eyes on this please.
> Given its causing system crashes we need to decide how best to deal
> with it.
>=20
> QT:=C2=A0 Laurence,
> In understanding the severity,=C2=A0 Does end customer uses sg_write_same
> as the mechanism to move data?
> Other than the sg_write_same utility, how common is end customer uses
> 32Byte CDB?=C2=A0=C2=A0 It seems like upper layer doesn't=C2=A0 have supp=
ort for
> 32Bytes CDB at this time.
>=20
> The code path you're modifying is for the T10-PI disk.=C2=A0 This disk is
> "non-T10-PI" where it may create some confusion for next reader n
> Martin on why we've wander down this code path.
>=20
> Will queue up a patch that plug this hole.
>=20
>=20
>=20

OK, Thank you
In this case the customer was specifically using sg_write_same. I am
not sure if it was part of a script or some other use case.
They were of the opinion it was severe enough of an issue to warrant
fixing so they logged a case with us.
Thanks for looking into this.

Regards
Laurence

