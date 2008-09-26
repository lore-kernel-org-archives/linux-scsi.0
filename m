From: Lin Tan <tammy000@gmail.com>
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before new_buffer_tape()
Date: Fri, 26 Sep 2008 12:06:24 -0500
Message-ID: <20080926170624.GA19223@carmen.cs.uiuc.edu>
References: <20080925174948.GA14180@carmen.cs.uiuc.edu> <20080926111300.1dd34009@lxorguk.ukuu.org.uk> <7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com> <20080926170937.2983fc29@lxorguk.ukuu.org.uk> <1222446056.3971.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753343AbYIZRGk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1222446056.3971.19.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kai.Makisara@kolumbus.fi, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> > > > Looks true to me for the current versions of the code. In fact it is only
> > > > ever called from the initialisation function that I can see so chunks of
> > > > the code could simply go away as well as bits of the comment. Ditto the
> > > > one in drivers/scsi/st.c
> > > >
> > > > Acked-by: Alan Cox <alan@redhat.com>
> > > >
> > > 
> > > I am sorry I didn't quite understand. You mean it is true that caller
> > > must hold os_scsi_tapes_lock?
> > 
> > Sorry - I mean what you claim is true - that the comment is incorrect.
> 
> So, I think I'm missing a piece of this:  There's no patch in this
> thread (I presume it's lurking somewhere on lkml).  Could someone repost
> the proposed patch and copy the tape maintainer: Kai Makisara
> <Kai.Makisara@kolumbus.fi> to get his input?
> 
> Thanks,
> 
> James
> 
>

The patch was in the orginal message. I am resending it now with Makisara CC-ed.

Lin 

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="new_tape_buffer.readytosend"

Removing the wrong comment.
The lock is needed before calling new_tape_buffer(), at least in some cases.
So the comment above new_tape_buffer() is inconsistent with the code and
may mislead developers.

I simply removed the wrong comment, as I am not sure if the lock is required
in all situations. If so, we should add "Caller must hold os_scsi_tapes_lock".

Signed-off-by: Lin Tan <tammy000@gmail.com>

---

--- a/drivers/scsi/osst.c	2008-09-25 11:53:09.000000000 -0500
+++ b/drivers/scsi/osst.c	2008-09-25 11:59:46.000000000 -0500
@@ -5209,7 +5209,7 @@
 

 /* Memory handling routines */
 
-/* Try to allocate a new tape buffer skeleton. Caller must not hold os_scsi_tapes_lock */
+/* Try to allocate a new tape buffer skeleton. */
 static struct osst_buffer * new_tape_buffer( int from_initialization, int need_dma, int max_sg )
 {
 	int i;

--gKMricLos+KVdGMg--
