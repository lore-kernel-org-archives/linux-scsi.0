From: Jim Ramsay <jim.ramsay@gmail.com>
Subject: Re: [PATCH 3/3] Add disk hotswap support to libata RESEND #2
Date: Wed, 24 Aug 2005 09:11:01 -0600
Message-ID: <4789af9e05082408111c4a6294@mail.gmail.com>
References: <355e5e5e05080103021a8239df@mail.gmail.com>
	 <4789af9e050823124140eb924f@mail.gmail.com>
	 <4789af9e050823154364c8e9eb@mail.gmail.com>
	 <430BA990.9090807@mvista.com> <430BCB41.5070206@s5r6.in-berlin.de>
	 <355e5e5e05082407031138120a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.203]:64806 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751043AbVHXPLC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 11:11:02 -0400
Received: by zproxy.gmail.com with SMTP id r28so74265nza
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 08:11:01 -0700 (PDT)
In-Reply-To: <355e5e5e05082407031138120a@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org

On 8/24/05, Lukasz Kosewski <lkosewsk@gmail.com> wrote:
> On 8/24/05, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > >> Timers appear to operate in an atomic context, so timers should not be
> > >> allowed to call scsi_remove_device, which eventually schedules.
> > >>
> > >> Any suggestions on the best way to fix this?
> > >
> > > Workqueue, perhaps.
> 
> Perhaps.  Actually, of course :)

How about the existing ata_wq workqueue?  This makes sense.  When the
timer expires, it adds a task to this queue.

> The reason these aren't working is because they have never been
> tested.  I sent in my not-entirely-finished patches the night before I
> left for China for one month.

Well, I'm on a time-sensitive project right now, and they "need"
hotplug support, so maybe I'll patch your patches and do what testing
I can.  I'll post a fourth patch in a few days.

> When I get back to Waterloo (Ontario) in September, I should send in
> revised versions of these patches with the following fixes:
> 
> - mod_timer instead of delete_timer/change timeout/add_timer
That's easy.  I'll add it in my 'patch 4/3'

> - bunch of code cleanups
Haven't touched this, looks pretty clean to me

> - proper error handling
This may be something I'll have to stick my fingers in as I do more testing

> - actually making the patches work.
Hopefully I'll get this going.

[Update, 10 mins later] Hey, I've got unplugging working already!

-- 
Jim Ramsay
"Me fail English?  That's unpossible!"
