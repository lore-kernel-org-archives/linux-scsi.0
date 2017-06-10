From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: remove useless variable assignment
Date: Sat, 10 Jun 2017 14:12:17 -0700
Message-ID: <1497129137.3598.6.camel@linux.vnet.ibm.com>
References: <20170518003043.GA5664@embeddedgus>
         <1495082398.2840.14.camel@linux.vnet.ibm.com>
         <20170518124107.Horde.TAwM83c0HSIrAfOVg_W7two@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170518124107.Horde.TAwM83c0HSIrAfOVg_W7two@gator4166.hostgator.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-05-18 at 12:41 -0500, Gustavo A. R. Silva wrote:
> Hi James,
> 
> Quoting James Bottomley <jejb@linux.vnet.ibm.com>:
> 
> > On Wed, 2017-05-17 at 19:30 -0500, Gustavo A. R. Silva wrote:
> > > Remove this assignment once the value stored in variable _k_ is
> > > overwritten after a few lines.
> > > 
> > > Addresses-Coverity-ID: 1226927
> > > Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> > > ---
> > >  drivers/scsi/qlogicfas408.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/qlogicfas408.c
> > > b/drivers/scsi/qlogicfas408.c
> > > index c3a9151..269440a 100644
> > > --- a/drivers/scsi/qlogicfas408.c
> > > +++ b/drivers/scsi/qlogicfas408.c
> > > @@ -329,7 +329,6 @@ static unsigned int ql_pcmd(struct scsi_cmnd
> > > *cmd)
> > >  		 */
> > >  		if ((k = ql_wai(priv)))
> > >  			return (k << 16);
> > > -		k = inb(qbase + 5);	/* should be 0x10,
> > > bus
> > > service */
> > 
> > That doesn't look right to me.  inb() is a statement which has an
> > effect on the I/O device regardless of whether the returned value
> > is
> > used or discarded.  In this case I think it's being used to clear
> > pending interrupts, so removing it will likely cause a phase error.
> > 
> 
> You are right, I get it.
> 
> In this case I think a patch to ignore the return value could be
> applied:
> 
> index c3a9151..8f5339a 100644
> --- a/drivers/scsi/qlogicfas408.c
> +++ b/drivers/scsi/qlogicfas408.c
> @@ -329,7 +329,7 @@ static unsigned int ql_pcmd(struct scsi_cmnd
> *cmd)
>                   */
>                  if ((k = ql_wai(priv)))
>                          return (k << 16);
> -               k = inb(qbase + 5);     /* should be 0x10, bus
> service */
> +               inb(qbase + 5); /* should be 0x10, bus service */
>          }
> 
> What do you think?

Really, no ... fix coverity.  The pattern of <var> = inX(something) is
perfectly correct kernel code even if the actual value of <var> is
never used again.  Unless there's some security bug possibility I'm not
seeing, I don't think the pattern needs altering.

In theory (void)inX() is the slightly more correct way to do this in
that it tells the compiler you need to read from here and you're
deliberately discarding the value but I don't see any value to
enforcing that.

James
