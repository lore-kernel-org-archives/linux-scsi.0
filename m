From: Willem Riede <wrlk@riede.org>
Subject: Re: blocksize limitations in scsi tape driver (st) when used with DLT1 tape drives?
Date: Thu, 5 Sep 2002 20:00:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020906000041.GW9630@linnie.riede.org>
References: <Pine.LNX.4.44.0209060009560.1912-100000@kai.makisara.local> <3D77D776.7040408@fl.priv.at>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (linnie.riede.org [192.168.2.2])
	by serve.riede.org (8.11.6/8.9.3) with ESMTP id g8600fB08811
	for <linux-scsi@vger.kernel.org>; Thu, 5 Sep 2002 20:00:42 -0400
Content-Disposition: inline
In-Reply-To: <3D77D776.7040408@fl.priv.at>; from fl@fl.priv.at on Thu, Sep 05, 2002 at 18:15:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2002.09.05 18:15 Friedrich Lobenstock wrote:
> Kai Makisara wrote:
> > On Thu, 5 Sep 2002, Friedrich Lobenstock wrote:
> > 
> >>Now I told arkeia to use a blocksize of 65536, 32768 and 16384 and it
> >>could not write to the tape. All I got in the log was:
> >>
> >>Sep  4 22:08:41 filesrv kernel: st0: Incorrect block size.
> >>Sep  4 22:08:45 filesrv kernel: st0: Write not multiple of tape block size.
> > 
> >                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > The write() byte count from Arkeia is not a multiple of the tape block
> > size. If you use fixed block size, you must take care that this constraint
> > is not violated. When you set the block size to 8192 or something that
> > multiplies to 8192, this constraint is obeyed. If Arkeia sets the block
> > size, I don't know why it does not obey the constraint. Seems to be an
> > application problem.
> > 
> > In most cases, it is best to use variable block mode
> > (i.e., mt setblk 0) and let the application to decide the tape block size.
> > In order to have good efficiency, you should make sure that the
> > application uses large enough byte counts in its write() calls, i.e., set
> > the Arkeia block size to 65536.
> 
> Hmmm...I whish I could, but LTO and as it seems DLT drives too do not
> cope well with variable block sizes.
> 
> All blocksizes greater than 8192 do make troubles. At and below this
> value all is fine.

I had a run in with Arkeia some time ago when used with osst tape devices,
and if I remember correctly, it is best to not tell Arkeia anything about
the block size to use. It will use multiples of 8192 in that case. Given
that you say the DLT drive is happy with 8192 block size that should work.

Regards, Willem Riede.
