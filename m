From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [0/4 ver2] Last 3 patches for bidi support
Date: Thu, 08 Nov 2007 18:49:46 +0200
Message-ID: <47333E2A.7020307@panasas.com>
References: <4730ACAA.2060007@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa9.bezeqint.net ([192.115.104.23]:44376 "EHLO sa9.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002AbXKHQt5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 11:49:57 -0500
In-Reply-To: <4730ACAA.2060007@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@osdl.org>

On Tue, Nov 06 2007 at 20:04 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> [1]
> I propose a small change to scsi_tgt_lib.c that will make
> tgt completely neutral to the scsi_data_buffer patch. And will
> make it all that more ready for bidi, too. TOMO is this OK?
> 
> (Can you do without the GFP_KERNEL allocation flag? It could
> make the code a bit more simple)
> 
> [2]
> scsi_data_buffer patch. 
> As requested by TOMO the all patch is squashed into one, 600 
> and some lines. TOMO if it makes you happy, OK, here it is.
> 
> There is one hunk from libsrp.c that I really hate. and from what 
> I understand of the code, only the "request_bufflen =" is really used, 
> All users of "request_buffer = addr" pass NULL, as far as I can see.
> If you would like to make me happy, and it is at all possible, please 
> clean it.
> 
> [3]
> Once scsi_data_buffer is in, then scsi bidi support can be applied. 
> (Block bidi was already merged 3 kernels ago). It makes no changes
> to scsi_cmnd and only adds some, not-at-all-dangerous, code to scsi_lib.
> So I don't see any reason to wait. please all review.
> 
> If ACKed by all parties and applied for inclusion for 2.6.25, 
> then they will have a long time to sit in MM and collect
> compilation breakage reports from ARCHs we never compiled.
> 
> I wish these make everybody happy this time
> 
> Boaz Harrosh
> 

Version 2, fixed as of Tomo's comments. Thanks Tomo.

[0]
   Remove dead code from sd.c & sr.c. It was conceived by programmers
   in the passed that rq_data_dir() could perhaps be expanded to 2 bits
   and return READ/WRITE/BIDI. But we have decided long ago that a bidi
   request is when blk_bidi_rq() == true, and in that case 
   rq_data_dir() == WRITE. So now we can be sure of what the compiler knew
   for a long time. (The future is already here)

[1] [2] [3]
See above

I must insist again they should have time to sit in -mm. 
For posible compilation breakage of other ARCHs.

Boaz

