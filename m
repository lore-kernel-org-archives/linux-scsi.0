From: Jin Suh <jinssuh@yahoo.com>
Subject: Re: [2.4.25] scsi29160 card-aic7xxx, HP Ultrium 230 tape read/write failure
Date: Tue, 24 Feb 2004 11:46:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224194628.46548.qmail@web41211.mail.yahoo.com>
References: <Pine.LNX.4.58L.0402241729080.23951@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web41211.mail.yahoo.com ([66.218.93.44]:20593 "HELO
	web41211.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262413AbUBXTq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 14:46:29 -0500
In-Reply-To: <Pine.LNX.4.58L.0402241729080.23951@logos.cnet>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

It appears to be my mistake. At first, I doubt my terminator but I had it on
the back of the drive. I fixed it again and switched the scsi cable. It worked
OK. Sorry for the interruptions. 
Now, I have another problem. I am still using the 2.4.25 kernel with HP Ultrium
230 scsi tape drive. Could you take a look at the following:

st0: Error with sense data: Current st09:00: sns = 70  5
ASC=53 ASCQ= 2
Raw sense data:0x70 0x00 0x05 0x00 0x00 0x00 0x00 0x0e 0x00 0x00 0x00 0x00 0x53
0x02 0x00 0x00 0x1c 0x01 0x00 0x00 0x00 0x00 
scsi0: Someone reset channel A

I didn't touch any cable or drive. I got this message. I tested my tape drive
and it worked fine. Do you have any idea what is going on?

Thanks,
Jin

--- Marcelo Tosatti <marcelo.tosatti@cyclades.com> wrote:
> 
> 
> On Tue, 24 Feb 2004, Jin Suh wrote:
> 
> > Hello,
> >
> > I recently upgraded my kernel to 2.4.25. I have a strange error using
> 2.4.25
> > with Ultrium 230 tape drive. I wrote 4gb data unto the tape and read back
> to
> > verify md5sum value. It died when it read around 1.3gb data from tape
> saying
> > following:
> >
> > (scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x84)
> > SCSIRATE(0x98)
> > (scsi0:A:3:0): Unexpected busfree in Message-out phase
> > SEQADDR == 0x16b
> > st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > ........
> >
> > When I tried to read it again using:
> > dd if=/dev/st0 bs=1024 conv=noerror,sync | md5sum
> >
> > I got the following:
> > st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> > dd: opening '/dev/st0': Input/Output error
> >
> > I tested the same thing unto the HP Exabyte and HP SuperStore DAT24. Both
> > worked without problems. But it happened on the HP Ultrium 230 tape drive.
> > Everything used to work fine with 2.4.20 kernel before. Is there any patch
> for
> > 2.4.25? Do you have any idea?
> 
> Hi Jin,
> 
> CCing linux-scsi to get more input.
> 
> I dont have much clues unfortunately -- reading the SCSI error messages it
> looks like a parity error.
> 
> Can you try 2.4.20 again? Find out where this problem started.
> 
> It might be a physical drive problem too which was not failing when you
> ran 2.4.20.


__________________________________
Do you Yahoo!?
Yahoo! Mail SpamGuard - Read only the mail you want.
http://antispam.yahoo.com/tools
