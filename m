From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 07/17] hpsa: do not give up retry of driver cmds after only 3 retries
Date: Tue, 1 May 2012 13:20:11 -0500
Message-ID: <20120501182011.GS11802@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com> <20120501164240.11705.10308.stgit@beardog.cce.hp.com> <20120501172634.GA11302@andi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:46705 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2EASUQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 14:20:16 -0400
Content-Disposition: inline
In-Reply-To: <20120501172634.GA11302@andi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Cc: scameron@beardog.cce.hp.com

On Tue, May 01, 2012 at 07:26:34PM +0200, Andi Shyti wrote:
> Hi,
> 
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -1380,17 +1380,24 @@ static void hpsa_scsi_do_simple_cmd_core_if_no_lockup(struct ctlr_info *h,
> >  	}
> >  }
> >  
> > +#define MAX_DRIVER_CMD_RETRIES 25
> >  static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
> >  	struct CommandList *c, int data_direction)
> >  {
> > -	int retry_count = 0;
> > +	int backoff_time = 10, retry_count = 0;
> >  
> >  	do {
> >  		memset(c->err_info, 0, sizeof(*c->err_info));
> >  		hpsa_scsi_do_simple_cmd_core(h, c);
> >  		retry_count++;
> > +		if (retry_count > 3) {
> > +			msleep(backoff_time);
> 
> for 10ms isn't it better to avoid using msleep?

[...] 
> > +			if (backoff_time < 1000)
> > +				backoff_time *= 2;

Eh, maybe.  from Documentation/timers-howto.txt

                        msleep(1~20) may not do what the caller intends, and
                        will often sleep longer (~20 ms actual sleep for any
                        value given in the 1~20ms range). In many cases this
                        is not the desired behavior.

Sleeping longer (~20ms instead of 10ms) in this instance is fine, as I don't
really care too much exactly how long it sleeps, and it backs off to up to
1280ms eventually anyway.  The idea is, "wait a bit, and retry, and then if
that doesn't work, wait twice as long, and retry, etc."  *exactly* how long
"a bit" is is not super important.  I could change the initial back_off time
to 20 or 30 to satisfy the letter of the advice in Documentation/timers-howto.txt,
if doing so is important.

This is kind of a corner case of a corner case, I don't expect
things will ordinarily end up waiting that long, because normally
one of the 1st 3 retries will succeed.  I just wanted to make it 
a little more robust and not just give up immediately if the 3
initial retries don't succeed, the specific number of retries,
wait times, etc, I just made up.  It still does eventually give up
though, and then probably doesn't do anything good after that
(same as current behavior, just somewhat less likely to get to
that point.)  I'm not actually aware of any complaints of the 
retries failing though (apart from the complaint that prompted
the patch prior to this one, that we didn't retry on getting
SAM_STAT_BUSY.)

-- steve

> > +		}
> >  	} while ((check_for_unit_attention(h, c) ||
> > -			check_for_busy(h, c)) && retry_count <= 3);
> > +			check_for_busy(h, c)) &&
> > +			retry_count <= MAX_DRIVER_CMD_RETRIES);
> >  	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
> >  }
