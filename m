From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Linux distribution versions
Date: Tue, 30 Apr 2002 16:50:05 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020430165005.B1284@mea-ext.zmailer.org>
References: <3CCE77BC.5090903@galileo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3CCE77BC.5090903@galileo.co.il>; from rabeeh@galileo.co.il on Tue, Apr 30, 2002 at 01:53:48PM +0300
List-Id: linux-scsi@vger.kernel.org
To: Rabeeh Khoury <rabeeh@galileo.co.il>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, rgooch@atnf.csiro.au

On Tue, Apr 30, 2002 at 01:53:48PM +0300, Rabeeh Khoury wrote:
> Hi List,
> 
> A Linux-SCSI newbie question -

  The tone of the question is giving an impression of "I want to publish
  binary-only driver"..  maybe it is just my ears, nevertheless...

  I suggest Linux-Kernel Mailing List FAQ items:

    http://www.tux.org/lkml/#s8-7
    http://www.tux.org/lkml/#s10-12

  There is no item fully covering this particular topic, thus I will
  Cc: the FAQ maintainer, who could adapt this text into a topic of
  its own...

> If I have developed a working SCSI driver, and rapidly tested it under a 
> certain distribution (say RedHat 7.2), will it work with other 
> distributions (say Mandrake 8.0 ) ?

  There are minor detail changes in between each kernel version
  (even in stable series, see LKML-faq), and depending on what
  configuration options are used (basically SMP or not), certain
  things like spinlocks may or may not reserve space in structures,
  and may or may not need to be called (are even optimized away in
  non-SMP systems), meaning that binary compiled for SMP MIGHT NOT
  work at non-SMP kernel. (And vice versa.)

  Also different vendors tend to inject different things into their
  kernel patch-sets, which again may subtly change data layouts, etc.
  In stable kernel series great pains are suffered at maintenance so
  that data layouts of in-kernel APIs (and API calls themselves) are
  not changed.  Nevertheless something may change making binary drivers
  to fail in mysterious ways.

  Subtle memory things may appear with i386-PAE mode (large memory
  machines which can't map all of RAM into the kernel at the same time.)

> What is the distinguisher between SCSI subsystems (and maybe other parts 
> in the kernel) that prevents or makes it possible to a certain SCSI 
> driver to work ?

  The problems that are encountered are most likely very general,
  e.g. things said above will match.

> Thank you,
> Rabeeh

  Aiming to publish BINARY driver modules is (in general) a support 
  nightmare.

  Publishing the driver is source (see LKML FAQ items about compile
  and linking) will make the driver publication a lot more simpler.

  Supplying obfuscated(*) lowlevel driver code with clean upper layers
  will give change to fix problems, like spinlocks, memory management
  call goofups etc.  ( (*) Obfuscation meaning "write this decimal value
  at that register, no explanatory comments" -- NOT "here is .o file
  with some compiled i386 object code" )

  Others than the driver author might not know what exactly is wrong
  in low-level, but things at more general levels may even get ported
  onwards, when kernel introduces new APIs for e.g. memory management
  at i386-PAE mode, etc.  .. and the driver works as is at a system
  with little-endian processors.

/Matti Aarnio
