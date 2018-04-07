From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Sat, 7 Apr 2018 13:08:40 -0400
Message-ID: <20180407170840.GB2515@animx.eu.org>
References: <20180331221252.GA25573@animx.eu.org>
 <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
 <20180401113721.GA8471@animx.eu.org>
 <20180401163604.GB25011@animx.eu.org>
 <20180401182723.GA31755@animx.eu.org>
 <595a10cfb387e6b2ab4d2053b84fed9b3da9e079.camel@wdc.com>
 <20180406014644.GA16112@animx.eu.org>
 <20180406020651.GB16112@animx.eu.org>
 <fb0640c203409a84ab1bfbbc41078a5416138ad2.camel@wdc.com>
 <20180407165335.GA2515@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180407165335.GA2515@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Wakko Warner wrote:
> Bart Van Assche wrote:
> > On Thu, 2018-04-05 at 22:06 -0400, Wakko Warner wrote:
> > > I know now why scsi_print_command isn't doing anything.  cmd->cmnd is null.
> > > I added a dev_printk in scsi_print_command where the 2 if statements return.
> > > Logs:
> > > [  29.866415] sr 3:0:0:0: cmd->cmnd is NULL
> > 
> > That's something that should never happen. As one can see in
> > scsi_setup_scsi_cmnd() and scsi_setup_fs_cmnd() both functions initialize
> > that pointer. Since I have not yet been able to reproduce myself what you
> > reported, would it be possible for you to bisect this issue? You will need
> > to follow something like the following procedure (see also
> > https://git-scm.com/docs/git-bisect):
> 
> After doing 3 successful compiles with good/bad, I got this error and was
> not able to compile any more kernels:
>   CC      scripts/mod/devicetable-offsets.s
> scripts/mod/empty.c:1:0: error: code model kernel does not support PIC mode
>  /* empty file to figure out endianness / word size */
>  
> scripts/mod/devicetable-offsets.c:1:0: error: code model kernel does not support PIC mode
>  #include <linux/kbuild.h>
>  
> scripts/Makefile.build:153: recipe for target 'scripts/mod/devicetable-offsets.s' failed
> 
> I don't think it found the bad commit.

I forgot to mention my gcc version.
gcc (Debian 6.2.1-7) 6.2.1 20161215

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
