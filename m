From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.5 current bk fix setting scsi queue depths
Date: Wed, 30 Oct 2002 11:17:52 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200210301717.g9UHHs902706@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Wed, 30 Oct 2002 08:58:44 PST." <20021030085844.A11040@eng2.beaverton.ibm.com>
To: Linus Torvalds <torvalds@transmeta.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> This patch fixes a problem with the current linus bk tree setting scsi
> queue depths to 1. Please apply. 

This patch causes the depth specification to be retained when we release 
commandblocks.  Since releasing command blocks is supposed only to be done 
when we give up the device (and therefore, is supposed to clear everything), 
your fix looks like it's merely masking a problem, not fixing it.

Is the real problem that this controller is getting a release command blocks 
and then a reallocate of them after slave_attach is called?  If so, that's 
probably what needs to be fixed.

James
