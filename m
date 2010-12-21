From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer
 derefs in scsi_error.c and reduce size as well
Date: Tue, 21 Dec 2010 11:37:50 -0600
Message-ID: <1292953070.3034.12.camel@mulgrave.site>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
	 <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com>
	 <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
	 <AANLkTim1MChiEa9rBL0ZfSCak6G2x4ivK47Svd6swEBS@mail.gmail.com>
	 <alpine.LNX.2.00.1011202127131.24071@swampdragon.chaosbits.net>
	 <AANLkTi=_r2YvDv0wj6qY_DqXntvHwfKNavTv8AKF+iXm@mail.gmail.com>
	 <alpine.LNX.2.00.1011211941240.19813@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1011211941240.19813@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, "David S. Miller" <davem@davemloft.net>, Mike Anderson <andmike@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2010-11-21 at 19:48 +0100, Jesper Juhl wrote:
> On Sat, 20 Nov 2010, Linus Torvalds wrote:
> 
> > On Sat, Nov 20, 2010 at 12:30 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > >
> > > Ok, I tried doing that (see patch below)
> > 
> > Actually, you kind of chose exactly the reverse of the functions I'd
> > have chosen.
> > 
> > Try doing the added parameter to the small static helper functions.
> > Those are the ones that tend to get inlined, and then the parameter
> > should actually result in _fewer_ pointer reloads.
> > 
> > So the ones like this:
> > 
> > >  static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
> [...]
> 
> I see your point now.
> 
> I tried this with most of the functions where it seemed that it could 
> possibly be a gain, but in the end it turned out that only the one you 
> pointed out above actually saw any benefit, so that's the only one I 
> changed.
> 
> In the end, the object size is down to this:
> 
>    text    data     bss     dec     hex filename
>   18713     128    4704   23545    5bf9 drivers/scsi/scsi_error.o
> 
> from this:
> 
>    text    data     bss     dec     hex filename
>   18790     128    4712   23630    5c4e drivers/scsi/scsi_error.o
> 
> 
> and the patch looks like this now:
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

This is rejecting against scsi-misc:

patching file drivers/scsi/scsi_error.c
Hunk #9 FAILED at 610.
Hunk #10 FAILED at 647.
Hunk #11 succeeded at 850 (offset -22 lines).
Hunk #12 succeeded at 970 (offset -22 lines).
Hunk #13 succeeded at 1013 (offset -22 lines).
Hunk #14 succeeded at 1067 (offset -22 lines).
Hunk #15 succeeded at 1167 (offset -33 lines).
Hunk #16 succeeded at 1184 (offset -33 lines).
Hunk #17 succeeded at 1226 (offset -33 lines).
Hunk #18 succeeded at 1379 (offset -33 lines).
Hunk #19 succeeded at 1976 (offset -33 lines).
2 out of 19 hunks FAILED -- saving rejects to file
drivers/scsi/scsi_error.c.rej

It looks like changes caused by 

    commit 459dbf72e4d2b4aa13620e6b70d54f098547bf13
    [SCSI] Eliminate error handler overload of the SCSI serial number

Could you respin so it applies, please?

Thanks,

James
