From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type storag
 edevices?
Date: Wed, 10 Mar 2004 17:43:58 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0403101722270.962-100000@ida.rowland.org>
References: <1078952324.5156.266.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:14084 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262658AbUCJWoC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 17:44:02 -0500
In-Reply-To: <1078952324.5156.266.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>

On 10 Mar 2004, Pat LaVarre wrote:

> > > I hear Windows starts with page x08, not x3F.
> > 
> > That's not so.  Windows 2000 asks for page x1C, then page x3F.  Windows XP 
> > does the same and then asks for page x08.
> 
> Did we see Win fetch page x3F after finding page x1C?

More accurately, we see Win fetch page x3F after receiving an error trying 
to fetch page x1C.  I believe I've seen it fetch page x3F after succeeding 
in reading page x1C, but I no longer have those trace files on hand.

> > > SCSI Pass-Through Mode Sense Command May Crash the Computer
> > > http://support.microsoft.com/?kbid=813908
> > > 
> > > suggests Talk-like-Windows excludes 4 bytes, by saying -i 4 -y "1A
> > > xx:xx:xx 04 00" crashes the Win 2K kernel for much Atapi, just as -y "12
> > > 00:00:00 00 00" crashes some lk for much Usb.
> > 
> > I don't think so.  That web page actually states that a bug in Windows' 
> > atapi.sys storage port driver causes the crash and
> 
> Eh?  Why don't you "think so"?  What did I say that contradicts that
> elaboration?

The page doesn't say that reading 4 bytes crashes the kernel; it says that
it _used_ to crash the kernel but the kernel has now been fixed.  Also, it
is misleading to claim that the page implies Talk-Like-Windows excludes
4-byte reads, since we already know that TLW means excluding everything
but 192-byte reads (for USB devices).

> > an update is available to fix the problem.
> 
> Yes, but you mentioning this fact interests me greatly.
> 
> Can you concisely say why we care if an update is available for a
> massively distributed Microsoft bug or no?  Personally I've never yet
> understood why Microsoft bothered to write that Win 2K update. 
> Microsoft already had shipped Win XP when it appeared.

Shucks, some people might say that Win XP is an update for a massively 
distributed Microsoft bug, i.e., Win 2000. :-)

In any case, I don't care about that update.  It doesn't matter, since I'm 
not claiming that we should or shouldn't use 4-byte reads in general.  All 
I'm saying is that for USB devices, we should try using 192-byte MODE 
SENSE transfers.

> > So it's no longer relevant.
> 
> Eh?  Relevance I still see includes:
> 
> a) Talk-SCSI-like-Windows probably doesn't include -i 4 -x "1A xx xx xx
> 04 00", even for the many significantly different test cases for which
> we have not collected bus traces.
> 
> b) Device folk who test with net-disconnected labs full of gold Win 2K
> are not sending -i 4 -x "1A xx xx xx 04 00" to their Atapi devices.
> 
> c) ...
> 
> Win 2K was and remains Massively Distributed, of course.

It may be relevant to what you want (and maybe relevant to Patrick's 
question) but it's not relevant to the main point of this thread.

> > > Also some hosts hang when D < H.
> > 
> > Not USB hosts.
> 
> No lk ever?

No current ones as far as I know.  Of course, there may be cases where it
happens that I'm not aware of.  Bear in mind, software hangs can easily be
fixed; hardware and firmware problems are much harder to deal with -- and
there's no evidence of any such problems with them.

> I know some hosts choke over the CSW stall that commonly distinguishes D
> < H from D = H in BBB.  The detail of hang vs. fail doesn't always reach
> me e.g. maybe I no longer accurately remember how lk rejected -y "12
> 00:00:00 00 00" Inquiry for zero.

That was a plain and simple bug in the usb-storage driver; it has since 
been fixed.

> > For PDT x00, Windows appears to use the same technique that we do: look at
> > the header from a page x3F response.
> 
> Ah.  Maybe we can teach lk to properly distinguish my write-protected
> PDT x00 disks.  Hmmm.

That's what I hope to accomplish.

Alan Stern

