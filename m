From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: mptscsih.c: discarded in section `.exit.text' from drivers/bu
	ilt-in.o
Date: Thu, 5 Feb 2004 15:15:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703D1A5D4@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48256 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266796AbUBEUPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 15:15:52 -0500
List-Id: linux-scsi@vger.kernel.org
To: Alex Williamson <alex.williamson@hp.com>
Cc: linux-scsi@vger.kernel.org

Are you using 2.6 or 2.4 kernel?  I have recently
posted different patches against both kernel trees.
I need to know with driver version your on.

Eric

On Thursday, February 05, 2004 12:53 PM, Alex Williamson wrote:
> 
>    The MPT Fusion driver seems to have developed a linker problem on
> ia64.  The latest linux-2.5 bk tree gives me the following:
> 
>   LD      .tmp_vmlinux1
> local symbol 0: discarded in section `.exit.text' from 
> drivers/built-in.o
> make: *** [.tmp_vmlinux1] Error 1
> 
> Running the reference discard checking tool:
> 
> $ ~/reference_discarded.pl 
> Finding objects, 858 objects, ignoring 0 module(s)
> Finding conglomerates, ignoring 81 conglomerate(s)
> Scanning objects
> Error: ./drivers/message/fusion/mptscsih.o .init.text refers 
> to 00000000000001e2 PCREL21B          .exit.text
> Done
> 
> And, sure enough, if I remove the __exits from mptscsih_exit() I get a
> linkable kernel.  Looks like the __exits ought to be removed.  Thanks,
> 
> 	Alex
> 
> -- 
> Alex Williamson                             HP Linux & Open Source Lab
> 
