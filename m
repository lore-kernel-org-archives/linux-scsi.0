From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: HBA self selection
Date: Thu, 13 Apr 2006 11:13:32 -0500
Message-ID: <5CCF5F0F2514664CBE20FD24BCE17614044BF9@cceexc17.americas.cpqcorp.net>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net> <20060413152419.GD24104@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:30896 "EHLO
	ccerelbas02.cce.hp.com") by vger.kernel.org with ESMTP
	id S1751031AbWDMQNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2006 12:13:53 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org


When you say it never used to work with sym2, you mean
what?  Didn't work at all, or just the prcoessor device at id 7?

I think that most people using an MSA30 don't 
particularly care if they can't talk to the processor devices on
that box, and are unaware of its existence.  They can still access 
the disks just fine. (the MSA30 is a scsi JBOD, essentially.)
Pretty much only HP's SNMP storage agents try to talk
to that processor device, I think, so unless you're running them,
you won't notice or care, so long as the disks are working.

I think we originally saw the problem with an LSI card,
but I forget exactly which one, it used the mptlinux driver,
I think.  

-- steve

-----Original Message-----
From: Matthew Wilcox [mailto:matthew@wil.cx]
Sent: Thu 4/13/2006 10:24 AM
To: Cameron, Steve
Cc: linux-scsi@vger.kernel.org
Subject: Re: HBA self selection
 
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

