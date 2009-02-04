From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: iscsi_add_session() warning
Date: Tue, 3 Feb 2009 23:50:04 -0800
Message-ID: <20090203235004.0377e4de.akpm@linux-foundation.org>
References: <20090203160900.38506c47.akpm@linux-foundation.org>
	<20090204001238.GG19327@bombadil.infradead.org>
	<20090203162224.7c80d962.akpm@linux-foundation.org>
	<4989465B.9060109@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbZBDHuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2009 02:50:22 -0500
In-Reply-To: <4989465B.9060109@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Kyle McMartin <kyle@infradead.org>, linux-scsi@vger.kernel.org

On Wed, 04 Feb 2009 01:40:11 -0600 Mike Christie <michaelc@cs.wisc.edu> wrote:

> When there are no ids for some object left, what is the stadard Exxxx 
> value to return? Would ENOSPC make sense? Here ENOSPC would mean no 
> space in id space left instead of space on a device?

Drivers often do that sort of thing.  I don't like it personally -
ENOSPC means "No space left on device".  IOW, "your disk is full".

Co-opting that code just because something kinda-sorta-similar happened
seems abusive to me.  Plus the first thing poor old user is going to do
is run `df' and ask wtf?

So what's left?  EINVAL is a sort of generic something-went-wrong error
code (in Linux, at least).  But perhaps EBUSY ("Device or resource
busy") is suitable here.

Dunno, hard.

