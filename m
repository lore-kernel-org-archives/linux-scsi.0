From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Fri, 5 Oct 2007 13:00:19 -0700
Message-ID: <20071005130019.b928c42b.akpm@linux-foundation.org>
References: <11913765421743-git-send-email-matthew@wil.cx>
	<11913765432770-git-send-email-matthew@wil.cx>
	<20071005120355.8986ca0a.akpm@linux-foundation.org>
	<20071005193450.GX12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761069AbXJEUAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 16:00:22 -0400
In-Reply-To: <20071005193450.GX12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, willy@linux.intel.com

On Fri, 5 Oct 2007 13:34:50 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Oct 05, 2007 at 12:03:55PM -0700, Andrew Morton wrote:
> > This isn't right.  resource_size_t can be 64-bit so should be cast to
> > unsigned long long and printed with %llx.
> 
> But it's a 32-bit BAR.

Which gets stored in a 64-bit variable.

> > If it is known that this driver will never encounter a 64-bit address here
> > then this optimisation should be accompanied by a comment at every place
> > where it is employed so that people do not copy the wrong code into other
> > drivers.
> 
> Tell you what, I'll fix it properly when we have a better solution than
> 'cast resource_size_t to long long for printing'.

The code is wrong, that's all.  If people copy it, their printks will print
incorrect (ie: truncated) information on some platforms.

As I said, if the code is knowingly wrong then there should be a cautionary
comment at each known-to-be-wrong site.

