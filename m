From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Sat, 5 Dec 2009 11:54:21 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912051116400.23464@uplift.swm.pp.se>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca>  <4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>  <alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se> <73e903670912031336n749c0bb4l5f2e46d5347e5875@mail.gmail.com>
  <alpine.DEB.1.10.0912041952370.23464@uplift.swm.pp.se> <73e903670912041108o32c28af3q5a61e5a2e33edd0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-360227408-1260008334=:23464"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <73e903670912041108o32c28af3q5a61e5a2e33edd0a@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-360227408-1260008334=:23464
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 4 Dec 2009, Kristleifur Daason wrote:

> Cheers for trying them out! For the record, I think they were made
> against 2.6.31, perhaps the original 2.6.31 rather than later 2.6.31.x
> releases.

It doesn't apply cleanly against vanilla 2.6.31, it does however apply 
cleanly against vanilla 2.6.32, but with the following compile error:

drivers/scsi/mvsas/mv_sas.c: In function ‚mvs_slave_configure‚:
drivers/scsi/mvsas/mv_sas.c:417: error: ‚SCSI_QDEPTH_DEFAULT‚ undeclared 
(first use in this function)
drivers/scsi/mvsas/mv_sas.c:417: error: (Each undeclared identifier is 
reported only once
drivers/scsi/mvsas/mv_sas.c:417: error: for each function it appears in.)
drivers/scsi/mvsas/mv_sas.c:417: error: too many arguments to function 
‚sas_change_queue_depth‚
make[4]: *** [drivers/scsi/mvsas/mv_sas.o] Error 1

When removing this extra option, it compiles with vanilla 2.6.32 just 
fine. I crashes the same way as the ubuntu kernel when hot-plugging a disk 
as well (this time I did it without gdm/x running and it oopses, but 
unfortunately the highest part of the oops scrolled off). It's 100% 
reproducible anyway, so basically the controller is a no-go in 2.6.31.6 
and 2.6.32 both vanilla and ubuntu versions, both without and including 
the nov09 mvsas patch (at least the original version of the patch as 
posted). Different failure scenarios though... With the stock kernel the 
controller seems to get stuck in writing and nothing more happens but at 
least the machine doesn't crash and burn like it does with the 
mvsas-patch.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-360227408-1260008334=:23464--
