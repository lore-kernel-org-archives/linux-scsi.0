From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 6/7] aacraid: unlock around kfree
Date: Thu, 4 Aug 2005 07:33:15 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B017931E7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51643 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262478AbVHDLfR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 07:35:17 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Good to know. I went through one too many code reviews and had no
defense against the request.

There is a follow-up to this one not yet submitted to MarkH where I
endeavor to pre-allocate with kmalloc(,GFP_ATOMIC|GFP_KERNEL) a pool
before entering a locked list traversal rather than risking making the
calls with the locks held. The code is in an independent kernel thread
handling deferred actions triggered by the interrupt. Am I barking up
the wrong tree?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Wednesday, August 03, 2005 7:07 PM
To: Mark Haverkamp
Cc: linux-scsi; Salyzyn, Mark
Subject: Re: [PATCH 6/7] aacraid: unlock around kfree

On Wed, 2005-08-03 at 15:39 -0700, Mark Haverkamp wrote:
> kfree has the possibility of sleeping. It is generally considered poor
> manners to hold on to a lock with the possibility of a system call
> induced sleep.

Erm, this isn't true ... we'd have no end of driver issues if kfree
could block.

James


