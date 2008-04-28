From: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] qla2xxx: firmware semaphore to mutex
Date: Mon, 28 Apr 2008 12:54:58 -0700
Message-ID: <1209412498.12461.78.camel@localhost.localdomain>
References: <20080428174742.163523860@mvista.com>
	 <20080428180846.GX14990@parisc-linux.org>
	 <1209409033.12461.64.camel@localhost.localdomain>
	 <20080428190425.GY14990@parisc-linux.org>
	 <1209410518.12461.71.camel@localhost.localdomain>
	 <20080428192416.GZ14990@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:54903 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765978AbYD1TzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 15:55:00 -0400
In-Reply-To: <20080428192416.GZ14990@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org


On Mon, 2008-04-28 at 13:24 -0600, Matthew Wilcox wrote:
> On Mon, Apr 28, 2008 at 12:21:58PM -0700, Daniel Walker wrote:
> > Don't you need to return the -EINTR so the caller knows the nature of
> > the failure? You might also need to re-factor the caller of this
> > function so it properly reports the failure to userspace .. In this case
> > your just returning NULL .. 
> 
> The signal is _fatal_.  Userspace doesn't get to check the return value.
> It's dead.

Kernel space does still observe the failure, right? Otherwise you
wouldn't return anything from mutex_lock_killable() .. If that's the
case just returning NULL , is like just injecting a failure.. I'm not
against adding mutex_lock_killable() , I'm just wondering if your
changes are complete in this case..

Daniel

