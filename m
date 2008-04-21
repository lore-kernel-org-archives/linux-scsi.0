From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 2/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 21 Apr 2008 07:10:03 +0200
Message-ID: <200804210710.03694.vda.linux@googlemail.com>
References: <200803230440.40685.vda.linux@googlemail.com> <4804BE68.4000704@suse.de> <200804152210.03160.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:47949 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbYDUFKt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Apr 2008 01:10:49 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1632008fgb.17
        for <linux-scsi@vger.kernel.org>; Sun, 20 Apr 2008 22:10:48 -0700 (PDT)
In-Reply-To: <200804152210.03160.vda.linux@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Hi Hannes,

Apologies for being so nasty, but I am pinging you again.

Which tree and with which .config file is known to correctly
rebuild aic7xxx firmware?

On Tuesday 15 April 2008 22:10, Denys Vlasenko wrote:
> I'm afraid I will continue to bug you - it does not work. :(.
> 
> I applied your patch and I still couldn't get it to compile.
> I thought that it may be caused by me using not the latest scsi-misc-2.6
> git tree, so I downloaded the tree and retried. Alas, same result.
> 
> I followed your instructions:
> 
> > Anyway, you'll have to enable the firmware build for aic7xxx / aic79xx
> > and do a diff between the files used for compiling and the *_shipped
> > files.
> > Then fixup the assembler in aicasm/* to print out the files in the way
> > you'd like it.
> > Once you're done you copy the generated files over to the *_shipped
> > files and send the diff.
> 
> See attached .config file with firmware build options enabled.
> 
> Since I want *_shipped files regenerated, they, obviously, should not
> take part in the build, so I renamed tham all to *_shipped-OFF,
> intending later to rediff them against newly-generated files.
> 
> Then I ran "make bzImage" (64-bit x86) and got this error:
> 
> ...
>   LD      drivers/power/built-in.o
>   CC      drivers/scsi/scsi.o
>   CC      drivers/scsi/hosts.o
>   CC      drivers/scsi/scsi_ioctl.o
>   CC      drivers/scsi/constants.o
>   CC      drivers/scsi/scsicam.o
>   CC      drivers/scsi/scsi_error.o
>   CC      drivers/scsi/scsi_lib.o
>   CC      drivers/scsi/scsi_lib_dma.o
>   CC      drivers/scsi/scsi_scan.o
>   CC      drivers/scsi/scsi_sysfs.o
>   CC      drivers/scsi/scsi_devinfo.o
>   CC      drivers/scsi/scsi_sysctl.o
>   CC      drivers/scsi/scsi_proc.o
>   CC      drivers/scsi/scsi_tgt_lib.o
>   CC      drivers/scsi/scsi_tgt_if.o
>   CC      drivers/scsi/sd.o
>   CC      drivers/scsi/sr.o
>   CC      drivers/scsi/sr_ioctl.o
>   CC      drivers/scsi/sr_vendor.o
>   LD      drivers/scsi/scsi_mod.o
>   LD      drivers/scsi/scsi_tgt.o
>   CC      drivers/scsi/scsi_transport_spi.o
>   CC      drivers/scsi/scsi_transport_sas.o
> drivers/scsi/aic7xxx/aicasm/aicasm -Idrivers/scsi/aic7xxx -r drivers/scsi/aic7xxx/aic79xx_reg.h \
>                       -p drivers/scsi/aic7xxx/aic79xx_reg_print.c -i aic79xx_osm.h -o drivers/scsi/aic7xxx/aic79xx_seq.h \
>                       drivers/scsi/aic7xxx/aic79xx.seq
> drivers/scsi/aic7xxx/aicasm/aicasm: Stopped at file drivers/scsi/aic7xxx/aic79xx.seq, line 263 - Invalid bit(s) 0xffffff00 in immediate wr
> itten to ACCUM
> drivers/scsi/aic7xxx/aicasm/aicasm: Removing drivers/scsi/aic7xxx/aic79xx_seq.h due to error
> drivers/scsi/aic7xxx/aicasm/aicasm: Removing drivers/scsi/aic7xxx/aic79xx_reg.h due to error
> make[3]: *** [drivers/scsi/aic7xxx/aic79xx_seq.h] Error 65
> make[2]: *** [drivers/scsi/aic7xxx] Error 2
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> 
> This was on today's unmodified scsi-misc-2.6 git tree.
> 
> Please help.
> --
> vda
