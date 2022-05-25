Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FD2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 19:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiEYTGY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 15:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiEYTGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 15:06:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DF615F9C
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 12:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653505575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s4V+1dwA3uXx8Ba80aIYNyURshc9KYWIc3MT8hNZxKQ=;
        b=hVD5UthWHrF+k6TUMCIAFd1OP0fbnoXOXcoUwtIc7kmA9FpLKP25sgWuRJohjbs1GG1kDK
        og+YMlXMPk6n0jEKvDcnWJV1jJzkZofP55EsFWU/8oM+QtvDa8J06rLMTdTNRgLuBD2nDr
        trQRaqBPeu/grHmDRjgCltCn/pm57Xk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-km3E3Ho0PFOwE0wfZ56N8w-1; Wed, 25 May 2022 15:06:13 -0400
X-MC-Unique: km3E3Ho0PFOwE0wfZ56N8w-1
Received: by mail-il1-f199.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so13215571ilu.14
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 12:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s4V+1dwA3uXx8Ba80aIYNyURshc9KYWIc3MT8hNZxKQ=;
        b=AgxkeHoWcucAOfZ1gEHkNlIKYmTnkOVLcZSKOZRULAZUcKJKzGRm0bDGRZ1Y8c/4Vq
         As4FkTTT4umzSeupcaespbcrDPXJHFXNsZ0TUAJqdVbPQUTNh1GYY6LWcEWlmlABb4Yf
         Q2jcXm76aZYGgw4605eI+dYo0kXFHgeIya/AZ16TvHZFVT3p+a/SziebVC2GsBKIOyt5
         em+L/FGmew+q9a6ydWLTOTI4FXmW8ZkkdeXDxHeRzPCLW6M/cIbaV/8ILxt+1EMIZzKG
         zoSwfgoojHCZ4USlTKoaiOSzBUtnJxUffug3PYuk9j2H1YXcqhKHWoIKVO5rA7ZUWV1j
         JoIA==
X-Gm-Message-State: AOAM533hN5DKRRy5lpuw+9eVXpmb8LbokZThe6nQJP4/RB65wYryEoUg
        mlIJdUivsxOw5h9tvbxblD1UrhyqCFRTOC9fPLj7pvKzf/jEqrwmYd1R4Mzx4wTCABnkCE6V4C4
        7vD3xpgFnjC5GRgZhEdfTn5fcn4RbbyRItXWM/Q==
X-Received: by 2002:a05:6e02:1bce:b0:2d1:3fd2:645d with SMTP id x14-20020a056e021bce00b002d13fd2645dmr16754776ilv.299.1653505572085;
        Wed, 25 May 2022 12:06:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw05QqWPzRdmEvePo2rOxBHXHW9FHDD6wTppmLgHIpoWiIcoFbn+xUS0ysi4214FN/1NZAcxjNsJTQsxUBprLc=
X-Received: by 2002:a05:6e02:1bce:b0:2d1:3fd2:645d with SMTP id
 x14-20020a056e021bce00b002d13fd2645dmr16754764ilv.299.1653505571903; Wed, 25
 May 2022 12:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220512111236.109851-1-hare@suse.de> <20220512111236.109851-7-hare@suse.de>
 <CAGtn9rkR02KF8QikQ0J6MskocA6VQ385ajoz36Q7RH32VXBjGg@mail.gmail.com> <86d7ebc9-bb33-7f11-1e77-38b9f855d04d@suse.de>
In-Reply-To: <86d7ebc9-bb33-7f11-1e77-38b9f855d04d@suse.de>
From:   Ewan Milne <emilne@redhat.com>
Date:   Wed, 25 May 2022 15:06:01 -0400
Message-ID: <CAGtn9rk_rc0x+DdPuiZZBVFexp9s41sc0zZtB0cCBJEtBFSd2A@mail.gmail.com>
Subject: Re: [PATCH 06/20] qedf: use fc rport as argument for qedf_initiate_tmf()
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        James Smart <james.smart@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Well, fc_remote_port_chkready() has in the _ONLINE and _MARGINAL case:

                if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
                        result =3D 0;
                else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
                        result =3D DID_IMM_RETRY << 16;
                else
                        result =3D DID_NO_CONNECT << 16;
                break;

which fc_block_rport() does not have.  Admittedly, I would have thought tha=
t
the rport would be blocked while devloss was pending but there is code in
fc_timeout_deleted_rport() that indicates otherwise, maybe this only happen=
s
if there is a role change.

-Ewan


On Fri, May 20, 2022 at 2:50 AM Hannes Reinecke <hare@suse.de> wrote:
>
> On 5/19/22 11:22, Ewan Milne wrote:
> > The patch changes the data type of the 'lun' argument to qedf_flush_act=
ive_ios()
> > to a u64, but the remaining code still uses a wildcard of -1, perhaps
> > this needs a
> > #define or enum of a value that is unsigned also?
> >
> Ah, no, I went slightly overboard there. That needs to be changed back
> to be an 'int'.
>
> > Removing the call to fc_remote_port_chkready() in qedf_initiate_tmf()
> > will result
> > in different semantics for whether the TMF will be issued.
> >
> Really? 'fc_remote_port_chkready()' just evaluates the port state;
> this is also done by fc_block_rport().
> So dropping the first shouldn't make a difference.
>
> > Changing the debug logging in qedf_eh_target_reset() and qedf_eh_device=
_reset()
> > might make identifying the target more difficult, although
> > qedf_initiate_tmf() will
> > also log a message, the rport->scsi_target_id is not the same value as
> > the sdev->id.
> >
> Sigh. Yes, the error logging is suboptimal.
> Will be updating it.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andre=
w
> Myers, Andrew McDonald, Martje Boudien Moerman
>

