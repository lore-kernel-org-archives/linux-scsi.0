From: Uns Lider <unslider@miranda.org>
Subject: Re: sym53c8xx_2 ppr problems
Date: Tue, 11 Jan 2005 14:44:05 -0500 (EST)
Message-ID: <Pine.LNX.4.58.0501111431370.11687@miranda.org>
References: <Pine.LNX.4.58.0501111228530.30502@miranda.org>
 <20050111182136.GV27371@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.org ([209.58.150.153]:55967 "HELO miranda.org")
	by vger.kernel.org with SMTP id S262122AbVAKToG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 14:44:06 -0500
In-Reply-To: <20050111182136.GV27371@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 11 Jan 2005, Matthew Wilcox wrote:
> On Tue, Jan 11, 2005 at 12:37:53PM -0500, Uns Lider wrote:
> > FWIW... I just upgraded from 2.4.9 to 2.6.10. 2.6.10 kept printing phase
> > change 6-7 messages. I patched to sym53c8xx_2 2.1.18n, but that didn't
> > help. So I modified scsi_scan.c and sym_hipd.c sym_prepare_nego to never
> > try PPR. That made the messages go away.
> >
> > 00:0a.0 SCSI storage controller: Symbios Logic Inc. (formerly NCR) 53c1010 Ultra3 SCSI Adapter (rev 01)
> > (on a tekram dc390u3w)
> >   Vendor: SEAGATE   Model: SX150176LC        Rev: BA08
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > (=st150176lc, fast-40, lvd)
> >
> > It sounds like PPR only does anything for fast-80 and above drives so I
> > guess I'm OK now.
>
> Let me get this straight.  This drive is on an LVD bus,

I think so. It must be, to negotiate faster than 10 megatransfers, I
guess?

> capable of FAST-40,

Yes:
sym0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 15)
when PPR is disabled.

> reports being capable of PPR in its mode page

Not sure. Can scsiinfo or something report that? BTW it reports ANSI SCSI
revision 02, I don't know if that's SCSI-2 or SCSI-3.

> Googling for SX150176LC shows me several people with later revision
> firmware (BA09, BA0F, BA11, BA12), so maybe you can get a firmware
> upgrade out of Seagate.

I'm not going to mess with the firmware since disabling PPR seems like it
will keep things happy until I upgrade my hardware or kernel again, which
will probably not be for a few years.

> I'm a little disappointed that 2.1.18n didn't fix it though.  Could you
> revert your local changes, boot with "sym53c8xx.debug=0x200" and send
> me the results?

OK. I set log_buf_len=1M and sent dmesg output to a file, I guess this is
what you wanted. It's long so I'll email it to you off-list.

BTW, I think 2.4.19 used to print a few phase change messages at startup
and then continue normally, this might be an entirely different issue
though.

-- uns
