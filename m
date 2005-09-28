From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: Re: [PATCH 1/3] Add disk hotswap support to libata RESEND #5
Date: Wed, 28 Sep 2005 15:46:40 -0400
Message-ID: <355e5e5e050928124651ba8947@mail.gmail.com>
References: <355e5e5e0509261801613c9bdb@mail.gmail.com>
	 <433AE72B.1060708@pobox.com>
Reply-To: Lukasz Kosewski <lkosewsk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.203]:65226 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750733AbVI1Tql convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2005 15:46:41 -0400
Received: by zproxy.gmail.com with SMTP id i11so1710nzi
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2005 12:46:40 -0700 (PDT)
In-Reply-To: <433AE72B.1060708@pobox.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 9/28/05, Jeff Garzik <jgarzik@pobox.com> wrote:
> > +     PDC2_SATA_PLUG_CSR      = 0X60, /* SATAII Plug control/status reg */
>
> Did you actually compile and test this?  :)

Yes.  And it works, which is why the compiling and testing doesn't
catch it :P  I'll change it.

> > +     case board_40518:
> > +             /* Override hotplug offset for SATAII150 */
> > +             hp->hotplug_offset = PDC2_SATA_PLUG_CSR;
>
> add a comment /* fall through */ here

OK.

> > -     /* FIXME: check ata_device_add return value */
> > +     /* FIXME: check ata_device_add return value.  If 0, kfree(hp) */
> >       ata_device_add(probe_ent);
>
> Just leave the comment as is.  You made it worse:
>
> * if ata_device_add() returns zero, then everything is OK.
>
> * if ata_device_add() returns non-zero, then an error occured.
> kfree(hp) is but one of several things that need to be cleaned up on
> failure.

No.  ata_device_add returns nonzero on success; so say the docs. 
Since the return value is not checked here, and whether on success or
failure all of the data structures allocated in that method stick
around, I assumed that something was in the works for this.  I'll
change this to kfree(hp) on returning 0.  Please advise if I should do
something else.

> Finally, please fix the format of your subject line per
>         http://linux.yyz.us/patch-format.html
>
> Most notably, each Subject should be unique for each patch.  e.g.
>
> [PATCH 1/3] sata_promise: fix hotplug register offset
> [PATCH 2/3] libata: add device hotplug infrastructure
> [PATCH 3/3] sata_promise: add device hotplug support

OK.

Luke
