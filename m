From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] sym53c8xx module parameter passing not working (2.5.6)
Date: Fri, 1 Oct 2004 14:28:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001142837.6b2d0031.rddunlap@osdl.org>
References: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de>
	<20041001211136.GN16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:9682 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266603AbUJAVfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2004 17:35:32 -0400
In-Reply-To: <20041001211136.GN16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Heinzmann@cc-dresden.de, linux-scsi@vger.kernel.org

On Fri, 1 Oct 2004 22:11:36 +0100 Matthew Wilcox wrote:

| On Fri, Oct 01, 2004 at 05:26:21PM +0200, Heinzmann, Robert wrote:
| > The 2.6 version of sym53c8xx_2 did not read the module command line parameter properly. 
| > This was due to a missing call to sym53c8xx_setup().
| 
| I don't understand, actually.
| 
| #ifndef MODULE
| __setup("sym53c8xx=", sym53c8xx_setup);
| #endif
| 
| should cause sym53c8xx_setup to be called.

It should for the non-loadable-module case.  I think that Robert
is saying that it doesn't work for the loadable-module case.
I.e., these lines aren't doing what is expected:

#ifdef	MODULE
char *sym53c8xx;	/* command line passed by insmod */
MODULE_PARM(sym53c8xx, "s");
#endif

-- 
~Randy
