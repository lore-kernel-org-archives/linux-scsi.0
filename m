Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89286C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 08:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7156861076
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 08:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhJLI6y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 04:58:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235263AbhJLI6x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 04:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634029011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2306l8O15sU1vcu4B6Ll737E6aqM79YcUvAzT+nrE/0=;
        b=efiObAT8+PjasR9TZVEz8ABLa6QMjdiv2fzpfg0XpHLAHd1oHeIpiv6TTOy60aZo8HaCtV
        mhJ5Li/mR4G4DYs7TYdZpbnDifKA1vy3Kypb9K6UV2AXiconluXTBI48iPXnrmnXeJB6hS
        Bw6gmwnnP6+gqrqJSj8gP3Tp2CWB/OE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-2TKPlEZKPMC2eHI4f6bFCA-1; Tue, 12 Oct 2021 04:56:49 -0400
X-MC-Unique: 2TKPlEZKPMC2eHI4f6bFCA-1
Received: by mail-il1-f199.google.com with SMTP id r18-20020a056e02109200b0025920bc2e5eso6346865ilj.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 01:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2306l8O15sU1vcu4B6Ll737E6aqM79YcUvAzT+nrE/0=;
        b=SwDAHP5dVJZ0Bl1Up5b8/fH6nM63t9MUvyeLj561sW57gRW+X4VTdLltmJnkzQCwqT
         oOiNEERBJBllWSw/5VhdlSmcdgDR83pAAa9cwogBjqfrWvPZe1SpmQpfd6hcwwQK+eJL
         3Q4lWjTZUi5wYmdgTy03wV6iKHzEb2nZUPxn06YnpNNEE1Rwxy5MKOQ0SXE44yVCB9rv
         2j0uN/tYTmrCdPDDR/lhWIHfRYkoBY4Nt/E+B5znkFMr5fAECbTC9LGugUs1R7KlcruO
         cG59Fklo/joeNqtqQOozxIQvY83PZQRdM1iF34YkqIEsYNShKe4670oDMpiry4L/llvB
         z/+g==
X-Gm-Message-State: AOAM532vjQ63xiZScSQruBpYZttbW6vBeGBJ0IigUs8eGpMTaIKXIzSZ
        PgCq8+iccq9qQSmIsnX86/z9YMxjACdmRwWfgH7eTUJsBlJKJ9+nW1QM5l2Iob4+ke2jZuw/mAY
        6nfe3xiiS7Wr/A3AjQ9eKSgoYcwKtPgTYhGCK3w==
X-Received: by 2002:a02:c7d0:: with SMTP id s16mr22392935jao.135.1634029008798;
        Tue, 12 Oct 2021 01:56:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUkRepXJb8nIg4Y5/prL0OUv2135zbuWmGtHT2J9bKutX3pXKM/gmZMmJRALFncDg4NHaIrKzMurpt7NQlWTA=
X-Received: by 2002:a02:c7d0:: with SMTP id s16mr22392901jao.135.1634029008278;
 Tue, 12 Oct 2021 01:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210927193814.79111-1-mlombard@redhat.com> <c9f869c7-9e83-6485-e256-f9e6886eb01b@oracle.com>
In-Reply-To: <c9f869c7-9e83-6485-e256-f9e6886eb01b@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 12 Oct 2021 10:56:37 +0200
Message-ID: <CAFL455=8Sv1AaPvK1tjouko5ReVgaw_6Y7iLap1ywHeRgN+_tg@mail.gmail.com>
Subject: Re: [PATCH] target: allow setting dbroot as a module parameter
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, Bodo Stroesser <bostroesser@gmail.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        lduncan@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,

po 11. 10. 2021 v 18:50 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> On 9/27/21 2:38 PM, Maurizio Lombardi wrote:
> > The target driver prevents the users from changing
> > the database root directory if a target module like ib_srpt
> > has already been loaded during boot.
>
> Why is that not allowed if we have a fabric driver loaded?
>
> It looks like we don't start using the db_root until we have created
> a device (alua and pr metadata)

Your solution would work perfectly for me but I still have a doubt:

CC: Lee Duncan

I think that changing db_root is not allowed if we have a fabric driver loa=
ded
because the latter could have potentially used the core's dbroot
attribute to access the
directory's content.

See the description of the commit that introduced the configurable dbroot:
--------
commit a96e9783e05851d5f06da0ae7635aec55a228e3d
Author: Lee Duncan <lduncan@suse.com>
    target: make target db location configurable

    This commit adds the read-write attribute "dbroot",
    in the top-level CONFIGFS (core) target directory,
    normally /sys/kernel/config/target. This attribute
    defaults to "/var/target" but can be changed by
    writing a new pathname string to it. Changing this
    attribute is only allowed when no fabric drivers
    are loaded and the supplied value specifies an
    existing directory.

    Target modules that care about the target database
    root directory will be modified to use this
    attribute in a future commit.
--------

Maurizio

