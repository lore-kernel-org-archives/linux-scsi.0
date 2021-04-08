Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6617C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 15:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92CB861151
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 15:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhDHP5I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 11:57:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231712AbhDHP5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 11:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617897416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0CzPEB2sWhRCA2R6HzN6pOgyEN8jebt+NeJC6nKy88=;
        b=Xnvkt0ATM0lUxkgJuK2+dspSTuJzHbyVaQNTEULRVtA4wA2eeXssKRz6QBI2ItaQJh63t5
        VjXLb3We1xl97buKBQ+Vy1wjudy0a3Z0vb9fClwYuetc1vuE9y8bimIICswh7+Z6ZzMEtF
        RXuZyqNKp2zyl0hUBVH7QW34p+hN0uk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-3cgb24KSOLCAzw5JjHN6yQ-1; Thu, 08 Apr 2021 11:56:54 -0400
X-MC-Unique: 3cgb24KSOLCAzw5JjHN6yQ-1
Received: by mail-qv1-f72.google.com with SMTP id p5so1409046qvr.4
        for <linux-scsi@vger.kernel.org>; Thu, 08 Apr 2021 08:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H0CzPEB2sWhRCA2R6HzN6pOgyEN8jebt+NeJC6nKy88=;
        b=XC7LIoJOjVIAnPJ0Ngt6oKETou9hYJ8G6NS/03zkLMv0xcaNm1r8AA2v8kdMlWMrrf
         Acbt46lR2xGBYX1zm6wNnSattgUBqCaKH/EPESoArzgYN9TBOH+owrDe+e3NNFobNv9I
         0OQoiBPJVwW73T5NjqRF6g3nSWkJttLSTqW+xciSfXCqk/kZE3Z/zp+Dd23DPGNdg4gt
         jhvSSkVBQpapBmK5UvalGZzfL++r/yto+mWHZwdoTQMstja2KiY3wYHlIIhwh6YGUsZ4
         IUQd2lM/dgLvM55IgzQMGxI0bwDNqjDrOzY8idIcRQUeUXeDC2CNpwqbYmRYQPi3XiJ0
         3ZIQ==
X-Gm-Message-State: AOAM533fiVZDkpUZtJ0e6Ismx/qHVaEXzHhaKts75QznNbMqzFexhJD0
        KKT+Lrz3sProW0K6EyZhX1Oq9Hx5IF0qJZwIm4CN1SAmSoaSWZ1wA//JTCPn9vINjb8zBoevesJ
        q31VtYo7T0i9Fu2AVuZ3afA==
X-Received: by 2002:a37:a785:: with SMTP id q127mr8851436qke.425.1617897413982;
        Thu, 08 Apr 2021 08:56:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrJnI5wXesdPpOGCbJ8oMy7bjx9xiEj1V/Fd24KikeDzGrAdl31h+Qbq5RiUVjf5r3S5cNxA==
X-Received: by 2002:a37:a785:: with SMTP id q127mr8851414qke.425.1617897413751;
        Thu, 08 Apr 2021 08:56:53 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id s6sm18870317qtn.15.2021.04.08.08.56.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Apr 2021 08:56:53 -0700 (PDT)
Message-ID: <3579fa05385e8f13b15b3e2ca184a33619dd627d.camel@redhat.com>
Subject: Re: [PATCH] scsi_mod: Add a new parameter to scsi_mod to control
 storage logging
From:   Laurence Oberman <loberman@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        hare@suse.de, emilne@redhat.com, martin.petersen@oracle.com,
        jpittman@redhat.com, djeffery@redhat.com,
        dgilbert <dgilbert@interlog.com>, axboe@fb.com, hch@lst.de
Date:   Thu, 08 Apr 2021 11:56:52 -0400
In-Reply-To: <3a8e9cfadbb646ed5a520d4972c1f450aae6b5d2.camel@redhat.com>
References: <1617325783-20740-1-git-send-email-loberman@redhat.com>
         <3ab37563-c620-395c-bd12-74376962728d@acm.org>
         <3a8e9cfadbb646ed5a520d4972c1f450aae6b5d2.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-04-02 at 08:37 -0400, Laurence Oberman wrote:
> On Thu, 2021-04-01 at 18:33 -0700, Bart Van Assche wrote:
> > On 4/1/21 6:09 PM, Laurence Oberman wrote:
> > >  #define sd_printk(prefix, sdsk, fmt, a...)			
> > > 	
> > > \
> > > -        (sdsk)->disk ?						
> > > 	\
> > > -	      sdev_prefix_printk(prefix, (sdsk)->device,		\
> > > +	do {								
> > > \
> > > +		if (!storage_quiet_discovery)				
> > > \
> > > +		 (sdsk)->disk ?						
> > > \
> > > +			sdev_prefix_printk(prefix, (sdsk)->device,	\
> > >  				 (sdsk)->disk->disk_name, fmt, ##a) :	
> > > \
> > > -	      sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> > > +			sdev_printk(prefix, (sdsk)->device, fmt, ##a);	
> > > \
> > > +	} while (0)
> > 
> > The indentation inside the above macro looks odd to me. I guess
> > that
> > you
> > want to avoid deep indentation? Consider using if (...) break;
> > instead
> > to reduce the indentation level. Additionally, please change the
> > ternary
> > operator into an if-condition since the result of the ternary
> > operator
> > is not used. How about rewriting the above macro as follows?
> > 
> > do {
> > 	if (storage_quiet_discovery)
> > 		break;
> > 	if ((sdk)->disk)
> > 		[ ... ]
> > 	else
> > 		[ ... ]
> > } while (0)
> > 
> > Thanks,
> > 
> > Bart.
> > 
> 
> Hi Bart
> Yes, Thanks I can try that option for the macro and clean it up.
> I will wait a bit for others to review so I can attend to all changes
> at once.
> 
> Note that the original version was indented like that too and has the
> ternary.
> 
> See here:
> #define sd_printk(prefix, sdsk, fmt,
> a...)                              \
>         (sdsk)->disk
> ?                                                  \
>               sdev_prefix_printk(prefix, (sdsk)-
> > device,                \
> 
>                                  (sdsk)->disk->disk_name, fmt, ##a)
> :   \
>               sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> 

Hi Bart the original macro is the same so I think best not to change it
other than the wrapper I added. What are your thoughts.

Gentle ping for any other reviews:

We are actively using this at some customers so it would be good to
know if others upstream will NAK this or have any comments.

Sincerely
Laurence Oberman


