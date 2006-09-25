From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] fix idiocy in asd_init_lseq_mdp()
Date: Mon, 25 Sep 2006 15:59:37 +0100
Message-ID: <20060925145937.GJ29920@ftp.linux.org.uk>
References: <20060925015722.GF29920@ftp.linux.org.uk> <4517EBF7.4020508@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750877AbWIYO7j@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4517EBF7.4020508@torque.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Several of us have reported a degenerate mode, that
> I term as "tmf timeout", in which a aic94xx based card
> becomes inoperable. Alas, the same hardware running another
> OS does not exhibit that problem (or at least not as much).

> >  	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq),
> > -			    (u16) LmM0INTEN_MASK & 0xFFFF0000 >> 16);
> > +			    (u16) ((LmM0INTEN_MASK & 0xFFFF0000) >> 16));
> >  	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq) + 2,
> >  			    (u16) LmM0INTEN_MASK & 0xFFFF);
> >  	asd_write_reg_byte(asd_ha, LmSEQ_LINK_RST_FRM_LEN(lseq), 0);
 
> BTW Luben was pointing out that the call you patched
> and the following call can be combined into a less
> trouble prone asd_write_reg_dword() call.

In that case there's another bug - we should write upper 16 bits to
addr + 2, not the lower ones.

IOW, the old code was
	broken attempt to write upper 16 bits to addr (ends up writing _lower_
16 bits)
	writing lower 16 bits to addr + 2

With this patch we get the first call do what it clearly intended to do
(unless it's a deliberate obfuscation from hell).  _IF_ we really want
to write the damn thing little-endian, the order should be reverted on
top of that.  I.e.
  	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq),
  			    (u16) LmM0INTEN_MASK & 0xFFFF);
  	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq) + 2,
			    (u16) ((LmM0INTEN_MASK & 0xFFFF0000) >> 16));
or, indeed, asd_write_reg_dword().
