From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Can someone explain "Data Phase Error"
Date: Mon, 20 Dec 2004 13:06:16 -0500
Message-ID: <87f94c3704122010064805a533@mail.gmail.com>
References: <87f94c3704121713233f8499d8@mail.gmail.com>
	 <311601c904121920015071cfac@mail.gmail.com>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.193]:38017 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261602AbULTSGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 13:06:19 -0500
Received: by wproxy.gmail.com with SMTP id 58so49170wri
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2004 10:06:16 -0800 (PST)
In-Reply-To: <311601c904121920015071cfac@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I believe I found the problem.

Somehow one of the servers was built with a Adaptec 2940 controller,
and the other with a Adaptec 29160.

Since the 2940 does not support LVD (only SE), I'm pretty sure that is
the issue.

I'm actually surprised that the 2940 based system worked so well.  I
successfully wrote out 300+GB of data and those tapes were restorable
by the 29160-based system.

It was only the restores that were unreliable, and that was true
regardless of where the tapes were written.

Is there a LINUX - SCSI troubleshooting guide that provides advice for
the various SCSI kernel error mesages?  Does it cover this situation?

Greg
-- 
Greg Freemyer


On Sun, 19 Dec 2004 21:01:20 -0700, Eric Mudama <edmudama@gmail.com> wrote:
> are these tapes new?
> 
> I've been told you have to write them 3-4 times before they can be
> written to reliably, since the heads remove particle contamination or
> something like that in those initial passes.
> 
> 
> On Fri, 17 Dec 2004 16:23:24 -0500, Greg Freemyer
> <greg.freemyer@gmail.com> wrote:
> > All,
> >
> > Environment:
> > kernel - 2.6.8-24  (from SUSE 9.2)
> > tape drive - IBM LTO-1 (scsi-wide)
> > scsi controller - Adaptec 2940
> >
> > Issue:
> > I am trying to build a pair of new Linux based tape servers.
> >
> > I have written exactly one tape on each, I then swapped the tapes
> > beween the units and tried to do a restore.  One seems to be working
> > fine on this first test, but with the other I get:
> >
> > Dec 17 08:52:04 linux kernel: st0: Error with sense data: Info
> > fld=0x40000, ILI Current st0: sense = f0 2b
> > Dec 17 08:52:04 linux kernel: Additional sense: Data phase error
> >
> > I would suspect a bad tape, but a simple "dd if=/dev/st0 of=/dev/null
> > bs=256k" fails at a different number of blocks each time.
> >
> > i.e. I have 130 GB of data on the tape, but I have not yet read back
> > more than 6 GB of it.  The data itself is unimportant, I'm just
> > testing the process.
> >
> > I am continueing to test and am now trying another tape, but I want to
> > understand this initial failure if I can.
> >
> > Thanks for any help.
> > Greg
> > --
> > Greg Freemyer
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
