From: Pat LaVarre <p.lavarre@ieee.org>
Subject: bCWBCBLength is cb length no when
Date: 05 Dec 2003 10:18:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070644705.12411.153.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312050954360.850-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:45956 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264387AbTLERSg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 12:18:36 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312050954360.850-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

> Incidentally, Pat, can you confirm whether bInterfaceSubClass x01 = RBC 
> (Reduced Block Commands, T10 project 1240-D) uses 0-padding of commands to 
> 12 bytes or not?  The Linux usb-storage driver seems to think that it 
> doesn't.

I can neither concisely confirm, nor concisely deny, sorry.

Want a discussion?

I believe we're asking:

---

Is the bCWBCBLength the length of the "cdb" or is it the length of the
cdb "plus pad"?  Specifically when we see bInterfaceSubClass equal to
the hex we've chosen to name "RBC"?

---

I have nine answers:

a) So far as I know as yet there is no public specification in English
that claims one answer or the other.

b) I personally know "cdb" length = "cb" "length" = bCBWCBLength was
original intent, first sketched one afternoon in a window-free West-side
room in August 1998, inherited from the Dos Aspi tradition.

c) I agree "plus pad" design traditions have arisen to assault us.

d) I'm sorry to see the "plus pad" traditions arise, because, by
definition, a transport that cannot know cdb length cannot accurately
report whether copying the cdb out worked or not.  I see the "plus pad"
traditions as indefensible oversimplifications.  To be "conservative in
what you send", hosts should pad with something determine, like zeroes
or a copy of the cb length.  Rumour i.e. truth or slander says mfst has
been seen to write noisy pad in place of the cdb[cb_length - 1] byte.

e) msft in bus traces sends 12 byte op x03 Request Sense cdb's in auto
sense of bInterfaceSubClass x06 SCSI.  That means "to work with Windows 
we have to miscompare": we have to quietly discard bytes of data a
portion of the cdb mfst claims to be asking us to send.  Welcome to the
real world.

f) msft on the web tells us "cdb" for bInterfaceSubClass x06 T10 SPC
SCSI, else "plus pad", except this "else" only clearly includes the
by-msft-generic bInterfaceSubClass x02|05.

g) rbc scsi may be mostly a firewire thing.

h) sff scsi over ide (aka atapi) has a "plus pad" tradition we could
blame for the "plus pad" msft design choice of bInterfaceSubClass
x02|05.

i) scsi over firewire has a "plus pad" tradition, I think. 
[Specifically I argue as detailed in the e-mail of this morning quoted
in full below.]

---

I cannot conclude confidently either way.

By a+b+d I say "cdb" for RBC, as for all forms of T10 SPC SCSI over USB.

By c+e+f+g+h+i I say "plus pad" for RBC, as for all forms of SFF/ T10
MMC SCSI over USB.

I feel a+b+d >= c+e+f+g+h+i.  Perhaps only because of my personal
involvement in b.  Perhaps those sums appear less equally balanced to
you?

Pat LaVarre
-----Forwarded Message-----


From: Pat LaVarre <p.lavarre@ieee.org>
To: stds-1394@ieee.org
Subject: sbp cdb length max 12 rumoured
Date: 05 Dec 2003 08:44:54 -0700

Hi.  I think I remember scsi over firewire by design chokes over cdb
longer than 12 bytes and bus traces cannot b=distinguish between such
cdb lengths as 6, 10, and 12.

Do I remember falsely?

More specifically I think I remember normative annex b of sbp 2 copies
out the cdb via the last three quadlets of an orb, with no explicitly
redundant indication of orb length to tell us more than three quadlets
might be there, and no redundant indication of cdb length to tell us how
many of the bytes at the end of the three quadlets are noise.

I actually at first failed to remember all this detail myself without
first querying a friend face to face.

Do we remember falsely?

Anyone willing to comment?

Perhaps you can tell I long ago forgot the url's to the (final draft?)
English that would give me this answer on the web.

Thanks in advance, Pat LaVarre

P.S. I ask by way of relaying a question from a Linux USB RBC developer.

P.P.S. Once upon a time people here were interested on how impossible it
is to defeat the sometimes selected Microsoft Outlook default of
uuencoding mail.  I believe the technique I'm using here now can work on
any PC, by rebooting via DVD/ CD into Knoppix Linux in place of
Windows.  Mind you, I'm not completely confident that this e-mail is not
uuencoded, since by now I have also forgotten the url of the web service
that bounces a plain text copy of my headers and mail body to me.


