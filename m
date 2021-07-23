Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DBAC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 17:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F4D960EB5
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 17:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhGWQmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 12:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhGWQmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jul 2021 12:42:08 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4EEC061575;
        Fri, 23 Jul 2021 10:22:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gt31so4586576ejc.12;
        Fri, 23 Jul 2021 10:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MEQCVop6cPBpgy2Y5Ip01XHU/jGOau6kU5gyPBsKTIc=;
        b=iC8yPQ3hj9pherQ3A204v9L8QDQ+/OEoo9xlq0hZvJb2Lra35Fs/HQQHKo6aTBydx8
         Seppj14NB9J9COH3Op5ppPzuveKkebPf0zc2/7pNf1H7/uaco3/1hOoq9tANzz2bumBR
         Q/kweD+XKiswm4j7oJh82n5V0S+342h7tYF1cynMUhZ11HIt7lHe741Nfu/g3j6lsz6y
         SPFMyrNnQDt7ySb8p8EHV/yYe8n9vgObaHxdz6bsEz7RBoa25v1njVXrXE6kOA0BOBMj
         enLCQIos5AvSbWw7bMQz9PDUMmtzHqvlBW6/pNfV6B0W91+Z2gnC+Rd4zF+uvNHVIgVj
         vR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MEQCVop6cPBpgy2Y5Ip01XHU/jGOau6kU5gyPBsKTIc=;
        b=HCbIZ8w/1QukYPlsDFA+6krTSnbqOX7Vs+sxTa7BYZd0TsprEX4/Jti6LSoyuWOpfv
         XPdR5Ygubze2ncg3dblh4ZnrFZYB1i25hsM1eyam7qpJOQ0RPz6sUfdnRiHKHhO4s5O6
         T4xa6/j2V035z0v3fTV4GNRg3NPfgnkwsaTPVVwb4Fjv0lqXIs/rdQtifIo5wbm8BDqg
         A5UJA+8Q1wqPKLl/lURU7df9++Jf5tXp7aLTKq4yAHO2xsOJyrxO1Z2Q/XZwFvobLyt4
         9fUdIdKTQwDFbkAJHYGLIetHaEGymZIYZuCWcyt429sGCWomYy4sYDptMxA5aC1EGECF
         1qHw==
X-Gm-Message-State: AOAM532rCu4Y0RWzA9njBaBZz2gfBPvgkXJxXDAKyTr/EFaiEtHjnbE1
        V8ozb8wU2y+VqiK5XCvPoIE=
X-Google-Smtp-Source: ABdhPJxdw70WOUVY8zWtFbCxGn1hJG94OxVV9ng2g1kYmOiDEIYRc0g1A8m+H/GFKXev9hwhDtVOrw==
X-Received: by 2002:a17:906:3b0b:: with SMTP id g11mr5764276ejf.286.1627060958793;
        Fri, 23 Jul 2021 10:22:38 -0700 (PDT)
Received: from pc ([196.235.233.206])
        by smtp.gmail.com with ESMTPSA id k3sm14342229edv.2.2021.07.23.10.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 10:22:38 -0700 (PDT)
Date:   Fri, 23 Jul 2021 18:22:35 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gregkh@linuxfoundation.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] scsi: aacraid: aachba: replace if with max()
Message-ID: <20210723172235.GA78880@pc>
References: <20210722173212.GA5685@pc>
 <09202d04-d066-a552-7a33-6c4c3b669107@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09202d04-d066-a552-7a33-6c4c3b669107@linux.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 23, 2021 at 06:56:51PM +0200, Steffen Maier wrote:
> On 7/22/21 7:32 PM, Salah Triki wrote:
> > Replace if with max() in order to make code more clean.
> > 
> > Signed-off-by: Salah Triki <salah.triki@gmail.com>
> > ---
> >   drivers/scsi/aacraid/aachba.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> > index 46b8dffce2dd..330224f08fd3 100644
> > --- a/drivers/scsi/aacraid/aachba.c
> > +++ b/drivers/scsi/aacraid/aachba.c
> > @@ -485,8 +485,8 @@ int aac_get_containers(struct aac_dev *dev)
> >   	if (status != -ERESTARTSYS)
> >   		aac_fib_free(fibptr);
> > 
> > -	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
> > -		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
> > +	maximum_num_containers = max(maximum_num_containers, MAXIMUM_NUM_CONTAINERS);
> > +
> 
> Haven't really looked closely, but isn't the old code more like a min()
> rather than a max()? maximum_num_containers being at least
> MAXIMUM_NUM_CONTAINERS or higher?
> 

In the old code, maximum_num_containers gets the value MAXIMUM_NUM_CONTAINERS if
it is less than this value.

Thanx
