From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH] fix warning and missing failure handling for scsi_add_host in aic7xxx driver
Date: Wed, 14 Dec 2005 09:02:27 +0100
Message-ID: <9a8748490512140002s8daf671h6db51bff1c06c834@mail.gmail.com>
References: <200512140007.20046.jesper.juhl@gmail.com>
	 <1134534839.3133.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751299AbVLNIC3@vger.kernel.org>
In-Reply-To: <1134534839.3133.2.camel@mulgrave>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Daniel M. Eischen" <deischen@iworks.interworks.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 12/14/05, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Wed, 2005-12-14 at 00:07 +0100, Jesper Juhl wrote:
> > +     if (retval) {
> > +             printk(KERN_ERR "aic7xxx: scsi_add_host failed\n");
> > +             goto free_and_out;
> > +     }
> > +
> >       scsi_scan_host(host);
> > -     return (0);
> > +
> > +out:
> > +     return retval;
> > +free_and_out:
> > +     scsi_remove_host(host);
> > +     goto out;
>
> I'm not incredibly keen on all this jumping around for no reason.  If
> there's a normal out and an error out, then fine, but in this case the
> if (retval) { } could contain the entirety of the error path with an
> else for the normal path.
>
Ok, I'll change that.

> scsi_remove_host() is the wrong API, it should be scsi_host_put() (for
> an allocated but un added host).
>
Ohh, I misunderstood things then, I'll correct that.

I'll send a new patch later today when I get home from work.

Thank you for taking a look at the patch and your feedback.

--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
