From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Tue, 20 May 2008 11:36:41 -0600
Message-ID: <20080520173640.GP2638@parisc-linux.org>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com> <20080520030232.fc91b64e.akpm@linux-foundation.org> <a8e1da0805200405t10fae448w589449e75a5abec6@mail.gmail.com> <20080520103045.2bb0a033.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45432 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbYETRgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 13:36:42 -0400
Content-Disposition: inline
In-Reply-To: <20080520103045.2bb0a033.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, greg@kroah.com, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 20, 2008 at 10:30:45AM -0700, Andrew Morton wrote:
> Well what are these lockdep warnings?  Normally such a warning means that
> we have a locking bug. I _assume_ that you've determined that the warnings
> are false-positives?

Andrew, we already discussed this on the thread you started that you
then ignored ...

> The warning which Mariusz Kozlowski discovered ("Subject: Re:
> 2.6.26-rc2-mm1: possible circular locking dependency detected") was
> triggered by the "class semaphore to mutex" conversion and it looks
> like a real bug to me.  Would your patch prevent warnings such as that
> one from being available to us?

The problem is that you add one type of class which then adds devices
that are of another class.  This is not a bug.  My proposal is to give
each sysfs class its own lock class; Dave's is to only do it for the
two classes he knows about that do this.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
