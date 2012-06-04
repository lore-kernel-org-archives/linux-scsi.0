From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: Different WARNING:
	drivers/scsi/fcoe/libfcoe.o(.init.text+0x1a): Section mismatch in	reference
 from the function init_module() to the function
	.exit.text:fcoe_transport_exit()
Date: Mon, 4 Jun 2012 20:52:43 +0000
Message-ID: <138EA028228D124A900F5E6746F3C216286EA866@ORSMSX102.amr.corp.intel.com>
References: <20120602161502.GW16584@smp.if.uj.edu.pl>
 <20120604143643.GJ32472@redhat.com>
 <20120604163556.GA12303@merkur.ravnborg.org>
 <20120604190857.GB16584@smp.if.uj.edu.pl>
 <20120604191757.GA21821@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3080 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab2FDWXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jun 2012 18:23:40 -0400
In-Reply-To: <20120604191757.GA21821@merkur.ravnborg.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>, Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: "Love, Robert W" <robert.w.love@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> 
> > WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x1a): Section mismatch
> in reference from the function init_module() to the
> function .exit.text:fcoe_transport_exit()
> > The function __init init_module() references
> > a function __exit fcoe_transport_exit().
> > This is often seen when error handling in the init function
> > uses functionality in the exit path.
> > The fix is often to remove the __exit annotation of
> > fcoe_transport_exit() so it may be used outside an exit section.
> >
> >   CC      arch/x86/crypto/crc32c-intel.mod.o
> >   LD [M]  arch/x86/crypto/crc32c-intel.ko
> >   CC      arch/x86/crypto/salsa20-i586.mod.o
> >   LD [M]  arch/x86/crypto/salsa20-i586.ko
> >   CC      arch/x86/crypto/serpent-sse2-i586.mod.o
> >   LD [M]  arch/x86/crypto/serpent-sse2-i586.ko
> >
> >
> >
> > (I'm dropping previous CC list, as this warning is easier to solve,
> > probably just following this instructions - dropping __exit from
> > fcoe_transport_exit() should be fine, especially if indeed it is needed
> > from init_module in error path).
> 
> Correct - dropping __exit is the fix here.
> 
> 	Sam

> 	Sam
However, fcoe_transport_exit() is called only in module *exit* path by the
module exit func libfcoe_exit(), not in the init_module error path. Let me 
take a objdump of the libfcoe.o to see where your above section mismatch warning
is from. Is this on 32bit only?

yi

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
