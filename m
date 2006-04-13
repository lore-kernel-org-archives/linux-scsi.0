From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: HBA self selection
Date: Thu, 13 Apr 2006 09:24:19 -0600
Message-ID: <20060413152419.GD24104@parisc-linux.org>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41091 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750814AbWDMPYV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 11:24:21 -0400
Content-Disposition: inline
In-Reply-To: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Apr 13, 2006 at 09:58:50AM -0500, Cameron, Steve wrote:
> There exist some target devices which depend on the adapter being
> able to do self selection.  The HP MSA30 presents a processor device
> at ID 7, for instance.
> 
> The processor device at ID 7 will generally not be accessible, because
> the HBA is generally at this ID.  The processor device doesn't care that the
> HBA is at id 7.  He says, "hmm, the adapter is talking to himself,
> that means, he's talking to me."   It's just a way to put a processor
> device on the bus without really "using up" a scsi id, since there
> are only a few of them.

Hmm.  That means it never used to work with sym2 -- has anyone ever
tested the MSA30 with an LSI 1010/896 card?  I appreciate it's an U320
device, so that's probably not a common configuration.

I can take the code out that prevents us talking to the bus; it's pretty
much a one-liner:

-        if (sdev->id == np->myaddr) {
-                sym_xpt_done2(np, cmd, DID_NO_CONNECT);
-                return 0;
-        }

but I'd like this change tested, if you wouldn't mind.  After the
midlayer's fixed, of course ;-)

> This used to work, I'm pretty sure.  Could do 
> "echo scsi add-single-device 0 0 7 0 > /proc/scsi/scsi" and 
> the processor device would show up.  Now it doesn't.
> 
> -- steve
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
