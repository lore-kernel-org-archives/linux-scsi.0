From: Tejun Heo <tj@kernel.org>
Subject: Re: PMP and SEMB messages to SEP
Date: Mon, 17 Jan 2011 16:40:42 +0100
Message-ID: <20110117154042.GG27123@htj.dyndns.org>
References: <20110113192558.GE16039@MAIL.13thfloor.at>
 <20110114142018.GA978@htj.dyndns.org>
 <20110114165957.GH16039@MAIL.13thfloor.at>
 <20110114170407.GE978@htj.dyndns.org>
 <20110114173759.GI16039@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110114173759.GI16039@MAIL.13thfloor.at>
Sender: linux-ide-owner@vger.kernel.org
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(cc'ing linux-scsi)
Hello,

On Fri, Jan 14, 2011 at 06:37:59PM +0100, Herbert Poetzl wrote:
> Fair enough, let's start with a bunch of simple questions
> I got from looking at the code (which I did just recently,
> so don't expect deep understanding of the inner workings,
> or even intelligent questions FWIW :)
> 
> - libata is used in the kernel for ata, sata and to some
>   extend for scsi (via (s)ata), as a helper library.

The (s) there is Serial not SCSI, but yes some SAS drivers use libata
to drive SATA devices attached to SAS controllers.

>   is there any counterpart in userspace to communicate
>   with (s)ata host/devices or how are the interfaces to
>   userspace designed to work?

SG_IO is the standard way to issue custom commands.  You need to wrap
ATA command inside a SCSI SCSI-ATA passthrough command.  Take a look
at hdparm, smartctl or any other tool which issues direct commands.

> - the SiI3726 supports SAF-TE and SES protocols for the
>   SEMB/SEP and the EMCs are sent through the SATA interface
>   (according to the docu, SEP_ATTN in the command register
>   and SEP command code in the features register)
> 
>   + how would I send such a command and retrieve the result
>     (if there is one) from within the kernel (maybe with
>     libata or from the ahci layer)?

If it's a proper command SAT passthrough via SG_IO should work but I'm
not sure whether it is.  Is it?

> - the SiI3726 supports GPIO pins, which can be reached via
>   the General Status and Control Register [130] and accoring
>   to the docu, the Read/Write Port Multiplier command can
>   be used to read/write that register.
>  
>   + how would I go about issuing such a command and where
>     should it be done? i.e. what about interference with
>     other commands? what about retrieving return values?

The problem is that the PMP device itself is currently not allocated a
userland visible device, so it doesn't have any /dev/* node.  Hmmm...

> > There also was something added to ahci which is exported through
> > sysfs.
> 
> I saw that the ahci driver uses *em_message* which I
> think might be related to sending activity messages and
> it also lists capabilities (which include 'ems') on
> host adapters, but I'm not entirely sure this is SEMB
> related (yet)

The message sent there can be of any format and that's why it was
added as a separate sysfs node.

ISTR there's a SCSI enclosure management driver.  Maybe SCSI people
have better clues about how enclosure management should be done?

Thanks.

-- 
tejun
