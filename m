Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539C3C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 12:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 243DC6115C
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 12:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbhDBMhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 08:37:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhDBMhq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 08:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617367064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lSv5mXaC+mpT+lvyrOgIBsdUOaIJBNYcWD8c0vO8uQw=;
        b=SP79bcKX3jERxsDUg1doUyNcHj99lJuilsUX2Kf6Ux3A3DlfticmZkVxPjTA1fIHWpEudM
        4B5mr3VmH4lMWeYTtvei4AlpyygzBbuHw7zxwttIylsOOoeOKVy90cSrUAxZsAvLzub5QM
        /pDNzQ/nzhQRy0sAv1cI3q0TIqIDsz8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-8Ha9je8IPJ-WFT_5ZVo3BA-1; Fri, 02 Apr 2021 08:37:41 -0400
X-MC-Unique: 8Ha9je8IPJ-WFT_5ZVo3BA-1
Received: by mail-qk1-f198.google.com with SMTP id b136so5681562qkc.20
        for <linux-scsi@vger.kernel.org>; Fri, 02 Apr 2021 05:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lSv5mXaC+mpT+lvyrOgIBsdUOaIJBNYcWD8c0vO8uQw=;
        b=U9sAewoYs1Emt1aBUNbfWGGa3nHIJDt7fJFaa1eUDsexFamG1p0LcMH6UtnHHven+C
         hNe+oKb7NAK1OCY4dH5DD+jBzJ4eP3FM6+52yb5wkElQgoRXzOrY0sUJYcDGglnc/3Pm
         S7QEkMOYRpHK9NtfxY2nj9yExtH3YgpwcCU32uzQ/u/dWVlHLJq41ah9kxzwldxHaYzL
         05D2wzeh3TyNCU/jidA8IRT6T7jpFW37oWOOgP9GbKawhFz6q9d3xV7cel9/LvoX+E5r
         p1wLL2OoWjP+A0thybFuo8/De5kW/8MXK8ryfzA/n018g7irHziHEz+Sf/LAh7atM3HZ
         eyeQ==
X-Gm-Message-State: AOAM533+mf2xsYIIF4AsZIVl91bEdZ7km9KBpP9NoMf8eoY2irgE2xRO
        cEoCpVf1qpjn9LOy+z9Znc/zdPM8U6kup0NK9iT0bpPgmPzFu1XGKkee8TGyNfHlWgYoBnkfGtS
        LB3ii5n4JwNvDtaufETDsdA==
X-Received: by 2002:a37:638f:: with SMTP id x137mr12658666qkb.199.1617367060962;
        Fri, 02 Apr 2021 05:37:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXr/J4NSLO2p9duvA5SQDbFBHS+r9oJyMtk5PU9U5GRAFQK4B5QHMMlUTKX1jJZcElgUOtpw==
X-Received: by 2002:a37:638f:: with SMTP id x137mr12658639qkb.199.1617367060620;
        Fri, 02 Apr 2021 05:37:40 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id g186sm7494829qke.0.2021.04.02.05.37.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Apr 2021 05:37:40 -0700 (PDT)
Message-ID: <3a8e9cfadbb646ed5a520d4972c1f450aae6b5d2.camel@redhat.com>
Subject: Re: [PATCH] scsi_mod: Add a new parameter to scsi_mod to control
 storage logging
From:   Laurence Oberman <loberman@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        hare@suse.de, emilne@redhat.com, martin.petersen@oracle.com,
        jpittman@redhat.com, djeffery@redhat.com,
        dgilbert <dgilbert@interlog.com>, axboe@fb.com, hch@lst.de
Date:   Fri, 02 Apr 2021 08:37:39 -0400
In-Reply-To: <3ab37563-c620-395c-bd12-74376962728d@acm.org>
References: <1617325783-20740-1-git-send-email-loberman@redhat.com>
         <3ab37563-c620-395c-bd12-74376962728d@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-04-01 at 18:33 -0700, Bart Van Assche wrote:
> On 4/1/21 6:09 PM, Laurence Oberman wrote:
> >  #define sd_printk(prefix, sdsk, fmt, a...)				
> > \
> > -        (sdsk)->disk ?						
> > 	\
> > -	      sdev_prefix_printk(prefix, (sdsk)->device,		\
> > +	do {								
> > \
> > +		if (!storage_quiet_discovery)				
> > \
> > +		 (sdsk)->disk ?						
> > \
> > +			sdev_prefix_printk(prefix, (sdsk)->device,	\
> >  				 (sdsk)->disk->disk_name, fmt, ##a) :	
> > \
> > -	      sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> > +			sdev_printk(prefix, (sdsk)->device, fmt, ##a);	
> > \
> > +	} while (0)
> 
> The indentation inside the above macro looks odd to me. I guess that
> you
> want to avoid deep indentation? Consider using if (...) break;
> instead
> to reduce the indentation level. Additionally, please change the
> ternary
> operator into an if-condition since the result of the ternary
> operator
> is not used. How about rewriting the above macro as follows?
> 
> do {
> 	if (storage_quiet_discovery)
> 		break;
> 	if ((sdk)->disk)
> 		[ ... ]
> 	else
> 		[ ... ]
> } while (0)
> 
> Thanks,
> 
> Bart.
> 

Hi Bart
Yes, Thanks I can try that option for the macro and clean it up.
I will wait a bit for others to review so I can attend to all changes
at once.

Note that the original version was indented like that too and has the
ternary.

See here:
#define sd_printk(prefix, sdsk, fmt,
a...)                              \
        (sdsk)->disk
?                                                  \
              sdev_prefix_printk(prefix, (sdsk)-
>device,                \
                                 (sdsk)->disk->disk_name, fmt, ##a)
:   \
              sdev_printk(prefix, (sdsk)->device, fmt, ##a)


