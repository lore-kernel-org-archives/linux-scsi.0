From: Pat LaVarre <p_lavarre@yahoo.com>
Subject: Re: [PATCH] CDC_MMC_WR
Date: Sun, 12 Oct 2003 06:33:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031012133316.24581.qmail@web21105.mail.yahoo.com>
Reply-To: p.lavarre@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21105.mail.yahoo.com ([216.136.227.107]:4718 "HELO
	web21105.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261869AbTJLNdR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Oct 2003 09:33:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: p.lavarre@ieee.org, linux-scsi@vger.kernel.org

Jens A:

> in general I like it ...

Good to hear, thanks for saying we progress.

I interpret your remarks as follows, please tell me
where I err.

> > ... linux/drivers/ide/ide-cd.c ...
> > - devinfo->mask = 0;
> > + devinfo->mask = CDC_MMC_WR;
>
> Must be left-over junk,
> should still be 0 here ...
>
> > ... linux/drivers/scsi/sr.c ...
> > - cd->cdi.mask = 0;
> > + cd->cdi.mask = CDC_MMC_WR;
>
> Ditto, why are you changing this?! Why do you
> think CDC_MMC_WR is special compared to the
> other mask flags?

I guess you mean we should:

1) Unmask CDC_MMC_WR in ide-cd and sr when and only
when unmasking CDC_DVD_RAM.  Start with mask = 0 same
as before, but substitute (CDC_DVD_RAM|CDC_MMC_WR)
when we mask &= ~CDC_DVD_RAM and when we mask |=
CDC_DVD_RAM.

2) Unmask CDC_MMC_WR in cdrom if trying op x46
GPCMD_GET_CONFIGURATION discovers a random writable
profile.

Correct?

If Not correct, then perhaps I erred by failing to say
only ide-cd/sr unmask CDC_MMC_WR.  If yes correct,
then I erred mainly by trying to say only cdrom
unmasks CDC_MMC_WR.  In any case I ask:

Do we want this patch or a second patch soon after to
move the mode sense of page x2A
GPMODE_CAPABILITIES_PAGE into cdrom.c register_cdrom
from ide-cd and sr?

Perhaps no?

I think No mainly because I see ide-cd
ide_cdrom_get_capabilities tries buflen = x18 usually,
x1C sometimes, and sr get_capabilities always tries
buflen = x80.  I see no easy way to preserve that
difference if we move this code to cdrom.

In passing, I think the sr variation actually provokes
devices to copy in less than the buflen of data, why
that works reliably thru usb/ storage/ I do not yet
know, I will pursue and report back.

> From: p_lavarre@yahoo.com

Please forgive the aggressive line breaks in this
email from me, please forgive my intermittently broken
>From address.  Reply-to header should correctly
suggest p.lavarre@ieee.org, bur also reply-to-from
should work if you try it.

> > +static void cdrom_get_cdc(
> > struct cdrom_device_info *cdi)
> > +{
> > +    cdinfo(CD_REG_UNREG, "cdrom_get_cdc\n");
> > +    if (CDROM_CAN(CDC_DVD_RAM)) {
> > +        cdi->mask &= ~CDC_MMC_WR;
> > +    } else if (cdrom_get_capabilities(cdi)) {
> > +        cdinfo(CD_WARNING,
> > "GET_CAPABILITIES not\n");
> > +    } else {
> > +        if (cdrom_get_configuration(cdi)) {
> > +            cdinfo(CD_WARNING,
> > "GET_CONFIGURATION not\n");
> > +        }
> > +    }
> > +}
>
> Ugly flow here. And what is the point of the
> cdrom_get_capabilities() call? If you just want to
> see if it's supported, the probe sequence in
> ide-cd/sr should already have done that.

To my eye, these remarks again raise the same issues
discussed above.

For the sake of offering immediate discussion, let's
suppose we do change ide-cd/sr to unmask CDC_MMC_WR
for CDC_DVD_RAM and we add no cdinfo.  Then I think I
see the ugly flow improves slightly:

if (!CDROM_CAN(CDC_MMC_WR)) {
    if (!cdrom_get_capabilities(cdi)) {
            (void) cdrom_get_configuration(cdi);
    }
}

But is this what we want?

Please tell me how often we wish to try op x46
GPCMD_GET_CONFIGURATION, new since 1999?

I'm guessing the less often the better, for the sake
of compatibility with old fragile devices.  I'm
guessing don't risk op x46 unless
!CDROM_CAN(CDC_MMC_WR), since as yet that risk buys us
nothing.  I'm guessing don't risk op x46 unless the
ide-cd/sr mode sense of page x2A
GPMODE_CAPABILITIES_PAGE did succeed, since without
such success the 1999 mmc standard that defines op x46
does not apply.

Regretfully I agree here as yet I have actually
written something slightly different.  Here I see I
have written don't risk op x46 unless
!CDROM_CAN(CDC_DVD_RAM) &&
!cdrom_get_capabilities(cdi).

I have written that only because I don't yet know how
cdrom may test to see if ide-cd/sr mode sense of page
x2A GPMODE_CAPABILITIES_PAGE did succeed.  When first
I looked I only found some seemingly illegit ways e.g.
capability bits that today get set only if a mode
sense of page x2A GPMODE_CAPABILITIES_PAGE did
succeed.

My bottom line remains: please tell me how often we
wish to try op x46 GPCMD_GET_CONFIGURATION, new since
1999?

> > +        cdinfo(CD_WARNING,
> > "GET_CAPABILITIES not\n");
> > +    } else {
>
> Ugly flow here. And ...

Please also tell me how much/little cdinfo we wish to
add?  I included cdinfo in every branch in the belief
that all change breaks some devices.

> I'd greatly prefer something ala:
> static void cdrom_get_cdc(
> struct cdrom_device_info *cdi)
> {
>     cdrom_get_configuration(cdi);
>     if (CDROM_CAN(CDC_DVD_RAM))
>         cdi->mask &= ~CDC_MMC_WR
> }

Please say again if yes still we prefer precisely this
(with unbroken lines of course).  My copy of your
original had an additional blank line, please say if
we want that too.

> > ... linux/drivers/scsi/sr.c ...
> > +    if (!cd->device->writeable) {
> > +        if ((cd->cdi.mask & CDC_MMC_WR) != 0) {
> > +            return 0;
> > +        }
> > +        cd->device->writeable = 1;
> > +    }
>
> This is ugly, don't hack around it like that ...
> Needs to go.

Yes please.

> If CDC_MMC_WR set, sr should have set
> device->writeable as well.

To my eye, these remarks again raise the same issues
discussed above.

I wonder: should sr alone, cdrom alone, or do both
unmask CDC_MMC_WR?

If cdrom ever does unmask CDC_MMC_WR, how then should
cdrom arrange for sr to set device->writeable?

May we delete device->writeable altogether, and have
sr trust cdrom to check CDC_MMC_WR, just as ide-cd
trusts cdrom to check CDC_MMC_WR?

> Lots of small nits,

Honestly I did try to copy style, thanks for telling
me specifically where I failed.

> > + struct cdrom_generic_command cgc0;
> > + struct cdrom_generic_command * cgc = &cgc0;
> > + ... cgc->...
>
> I see this repeated, what is the point? ...
> wasting 4/8 bytes on the stack each time.

I wrote cgc-> where I could have written cgc0. so that
I could copy more lines of code without changing them.
 I'm too new to know yet what actually equivalent C
idioms we tell gcc to accept as equivalent.  I thought
I had accurately copied this seemingly pointless waste
from other cdrom/cdrom.c and scsi/sr.c code.  

I see cgc-> appears without init_cdrom_command in
cdrom_mode_sense, cdrom_mode_select, etc.  Now that
you prompt me to look, I find cgc. appears with
init_cdrom_command in cdrom_read_subchannel. 
Hereafter I will block-copy-edit from there instead.

> ... sizeof(*cgc); ...
> ... sizeof(buf) ...
> init_cdrom_command() ... please use ...
> No need for ret, either ...

All these follow from choices like cdrom_mode_sense
vs. cdrom_read_subchannel choice, will try to comply.

> ret must be 0 ... so return 0 to make that clear.

Style, will comply.  The other camp on this one likes
all return statements to appear identical, to help gcc
understand how often we write return when we mean
goto.

> > +   3.13 Oct 10, 2003 - Jens Axboe <axboe@suse.de>
> > +  -- Pass writes thru to all CDC_MMC_WR profiles,
> not just CDC_DVD_RAM.
>
> That should be you :)

Sorry in my newbie ignorance I do not know what the :)
smiley means in this context.  Unless you say
different, in my next version of this patch I will
leave the explicit credit/ blame/ copyright as in my
last version, so that you can easily choose to correct
it again or not.

Pat LaVarre
p.lavarre@ieee.org


__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
