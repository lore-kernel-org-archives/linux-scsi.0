Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0663BC76195
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 16:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjC0QN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 12:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbjC0QN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 12:13:27 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE3FBF
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 09:13:24 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id eh3so38322038edb.11
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 09:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679933603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yddYuOcGFwZsVxVxzE1ik0M+7TVWHIEaDoUMvAHe2to=;
        b=cp3MqQV/yeZj6mo9+Hoj4KUw0cPRX7fONEfi5K7Qzz6fIedkuYKvvN0CdTQ9qEdZyy
         X1TnRF38eMlaKtyifbdDgGrA4Vjh0QIwlcB1iQF/2hnjRyGOYhmEqqBUdl740LVsm9fx
         WcvItoqkw3lo/cdUeLtLEwsyVoayQ+yvPlqBxypOtr332XBnOKcwFavfyOBlkZAyhi5b
         Z3Ty7i6tMklkSCWQzKX9ZrY6gni7qSoSjY/kt6dbOBqRRSA2g8BvY0U51zkEL62KNJ9J
         ZAtnWDQ8Kt1vRQhUKODO9SQR8XC5nXosufzjapEaihWFf+4BbqY7bbdLp/DiUU8z2MeC
         YEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679933603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yddYuOcGFwZsVxVxzE1ik0M+7TVWHIEaDoUMvAHe2to=;
        b=bxudLcxUmRxT4qmV1J3HVrYissVzbRMdArfO8zO0+4WUMqHayI1878bq9keYLd96tB
         7e0nbUaQmIgIKPP+l6F+0MEeeHWkKChU/PHX9lDLQIvFb3aukF6Le8nf8DNpQtnXcvyQ
         oh8IAiiLU+5kw3mmRaxL3bcKEhJA2KXPq7Y0JVffXewY56cdVeEF/teX0OILPAkgUK0u
         mbfXixn7CI/Rep+P60OfNa3M2mNXZjHiR6FH8njeJFFr4BXr6IwBd5GcUKH19huZfZ6H
         oLSW8gd65dwBNJRPE0UtZzK0usrvvsIXvYMzMpMyZ0bECb93iDajy7kkZNWCOgFcrPKX
         rOAw==
X-Gm-Message-State: AAQBX9fHxSBzd3S6o4iQDrqQ6PBeuBpcgQwLX3ctPueBCzaUXYGeLFNs
        SITZhAjplVj/X/J4X5fmeUY=
X-Google-Smtp-Source: AKy350bEH0qeqif1xlrAfDcRxtgBaFJbNMxKjGlMNNTHGduRDoGA8XZZZRCLqPs9jF4lEzucqHVqTQ==
X-Received: by 2002:a17:907:7787:b0:939:90ee:e086 with SMTP id ky7-20020a170907778700b0093990eee086mr12651979ejc.28.1679933603040;
        Mon, 27 Mar 2023 09:13:23 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id pv15-20020a170907208f00b0091ec885e016sm14189725ejb.54.2023.03.27.09.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:13:22 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 9501CBE2DE0; Mon, 27 Mar 2023 18:13:21 +0200 (CEST)
Date:   Mon, 27 Mar 2023 18:13:21 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/6] This patchset contains critical Bug fixes
Message-ID: <ZCHAoUJaJLRRB9wf@eldamar.lan>
References: <20230228140835.4075-1-ranjan.kumar@broadcom.com>
 <167815780205.2075334.9513188954583912224.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167815780205.2075334.9513188954583912224.b4-ty@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Mon, Mar 06, 2023 at 09:57:26PM -0500, Martin K. Petersen wrote:
> On Tue, 28 Feb 2023 06:08:29 -0800, Ranjan Kumar wrote:
> 
> > This patchset contains critical Bug fixes
> > 
> > Ranjan Kumar (6):
> >   mpi3mr: IOCTL timeout when disable/enable Interpt
> >   mpi3mr: Driver unload crash host when enhanced logging is enabled
> >   mpi3mr: Wait for diagnostic save during controller init
> >   mpi3mr: appropriate return values for failures in firmware init path
> >   mpi3mr: NVMe commands size greater than 8K fails
> >   mpi3mr: Bad drive in topology results kernel crash
> > 
> > [...]
> 
> Applied to 6.3/scsi-fixes, thanks!

Will those be backported as well as needed to at least 6.1.y where
impacted? It was noticed that the patches do not contain Fixes tags
and no CC to stable@ so they might not be picked automatically for
stable series.

Regards,
Salvatore
