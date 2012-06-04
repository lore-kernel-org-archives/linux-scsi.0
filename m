From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Different WARNING:
	drivers/scsi/fcoe/libfcoe.o(.init.text+0x1a): Section mismatch in
	reference from the function init_module() to the function
	.exit.text:fcoe_transport_exit()
Date: Mon, 4 Jun 2012 21:17:57 +0200
Message-ID: <20120604191757.GA21821@merkur.ravnborg.org>
References: <20120602161502.GW16584@smp.if.uj.edu.pl> <20120604143643.GJ32472@redhat.com> <20120604163556.GA12303@merkur.ravnborg.org> <20120604190857.GB16584@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120604190857.GB16584@smp.if.uj.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Robert Love <robert.w.love@intel.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x1a): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit()
> The function __init init_module() references
> a function __exit fcoe_transport_exit().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __exit annotation of
> fcoe_transport_exit() so it may be used outside an exit section.
> 
>   CC      arch/x86/crypto/crc32c-intel.mod.o
>   LD [M]  arch/x86/crypto/crc32c-intel.ko
>   CC      arch/x86/crypto/salsa20-i586.mod.o
>   LD [M]  arch/x86/crypto/salsa20-i586.ko
>   CC      arch/x86/crypto/serpent-sse2-i586.mod.o
>   LD [M]  arch/x86/crypto/serpent-sse2-i586.ko
> 
> 
> 
> (I'm dropping previous CC list, as this warning is easier to solve,
> probably just following this instructions - dropping __exit from
> fcoe_transport_exit() should be fine, especially if indeed it is needed
> from init_module in error path).

Correct - dropping __exit is the fix here.

	Sam
