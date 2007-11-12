From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] Fix problem with size of allocation in libsas
Date: Mon, 12 Nov 2007 01:48:07 +0100
Message-ID: <9a8748490711111648n25669b34s3be3b48b5725398e@mail.gmail.com>
References: <200711120024.54773.jesper.juhl@gmail.com>
	 <1194825603.3445.21.camel@localhost.localdomain>
	 <9a8748490711111613s50f9e212k18f8106ee127e809@mail.gmail.com>
	 <1194827826.3445.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:17124 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbXKLAsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Nov 2007 19:48:07 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1352866wah
        for <linux-scsi@vger.kernel.org>; Sun, 11 Nov 2007 16:48:07 -0800 (PST)
In-Reply-To: <1194827826.3445.32.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 12/11/2007, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2007-11-12 at 01:13 +0100, Jesper Juhl wrote:
> > On 12/11/2007, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> > > On Mon, 2007-11-12 at 00:24 +0100, Jesper Juhl wrote:
> > > > From: Jesper Juhl <jesper.juhl@gmail.com>
> > > >
> > > > in sas_get_phy_change_count(), the line
> > > >       disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
> > > > will allocate 56 bytes due to this define:
> > > >       #define DISCOVER_RESP_SIZE 56
> > > > But, the struct is actually 60 bytes in size.
> > > >
> > > > So change the define to be
> > > >       #define DISCOVER_RESP_SIZE sizeof(struct smp_resp)
> > > > so we always get the correct size even when people
> > > > fiddle with the structure.
> > > >
> > > > This change also fixes the same problem in
> > > > sas_get_phy_attached_sas_addr()
> > > >
> > > > (Found by the Coverity checker. Compile tested only)
> > >
> > > Well, your fix is definitely wrong.
> > >
> > > Could you explain the problem a little more?  The discover response SMP
> > > frame is 56 bytes as mandated by the standard.  I don't see anywhere in
> > > the code where we're actually using a value beyond the 56th byte ...
> > > where is the problem use?
> > >
> >
> > I haven't found any actual problem *use*, I just looked at the size of
> > 'struct smp_resp' and noticed that coverity seemed to be right that 56
> > bytes are not sufficient to hold the members of the struct.
>
> There are 11 current (well, as of the 1.1 standard) SMP frame responses.
> Each of them is actually a different length.  This driver treats SMP
> frame response underruns as errors, so the fix you propose would cause
> the whole discovery process to collapse.
>
> >   There are
> > 32 bytes in the first members + the union and I don't see how that can
> > ever stay at 56 bytes...?  So, we are allocating memory and storing it
> > in a 'struct smp_resp *', but we are allocating less than
> > sizeof(smp_resp) - how is that not a (potential) problem?
>
> We're not storing anything.  We're allocating a byte area for the driver
> to deposit a response frame, we know we just sent a SMP DISCOVER
> request, so we'd better get a discover response back (and the driver
> will error on underrun or overrun, so we know if it returns successfully
> that's exatly what we have).  The struct smp_resp contains the SMP
> invariant header and then a union of all the other response data types,
> so as long as we use either the header or the disc piece of the union,
> there's no possibility of error, is there?
>
No, as long as the driver will err on underrun and overrun (of 56
bytes) and we only use those parts of the structure that lie within
the first 56 bytes, then I don't see how it could fail.

But it still makes the hairs on the back of my head stand on end to
see memory allocated, and pointed to by a "struct foo *", that is less
than "sizeof(struct foo)"...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
