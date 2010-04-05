From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 10/21] m68k/scsi: a2091 - Kill ugly DMA() macro
Date: Mon, 5 Apr 2010 21:42:39 +0200
Message-ID: <s2o10f740e81004051242r27951fcftefe2ca3d1425ff66@mail.gmail.com>
References: <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
	 <20100405062529.GA28950@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20100405062529.GA28950@infradead.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 5, 2010 at 08:25, Christoph Hellwig <hch@infradead.org> wrote:
> Instead of abusing the ScsiHost base field I'd prefer if you stick

I wouldn't call it abuse: it's a (MM)IO base address anyway.
But I see that field was indeed marked `legacy crap' in an otherwise
innocent looking
commit to split the SCSI include files... by you ;-)

> a properly typed pointer into the device specific host data.

You mean shost_priv()? That field already contains a pointer to the
struct WD33C93_hostdata.

But I'll create a new a2091_hostdata struct that contains both the
WD33C93_hostdata and the a2091_scsiregs pointer (and do the same
for gvp11.c and a3000.c). It's a bit similar to what sgiwd93.c does, albeit that
one also uses the legacy base field.

Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
