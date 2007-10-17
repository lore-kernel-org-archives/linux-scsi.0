From: Willy Tarreau <w@1wt.eu>
Subject: Re: [Bug 3680] sym53c8xx_2 SMP deadlock on driver load
Date: Wed, 17 Oct 2007 17:52:56 +0200
Message-ID: <20071017155256.GA2820@1wt.eu>
References: <20071017013045.A19ED108036@picon.linux-foundation.org> <471621D2.5080806@cybernetics.com> <20071017152019.GA1871@1wt.eu> <47162DC8.5050700@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 1wt.eu ([62.212.114.60]:3172 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935869AbXJQQET (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 12:04:19 -0400
Content-Disposition: inline
In-Reply-To: <47162DC8.5050700@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, protasnb@gmail.com, bugme-daemon@bugzilla.kernel.org

On Wed, Oct 17, 2007 at 11:44:08AM -0400, Tony Battersby wrote:
> In 2.4, include/linux/init.h has the following:
> 
> #ifndef MODULE
> #define __init          __attribute__ ((__section__ (".text.init")))
> #else
> #define __init
> #endif
> 
> So __init has an effect only if it is built-in.

Ah yes, you're right.

> Apparently 2.6 also
> discards __init sections in modules after loading, but 2.4 doesn't.  Of
> course, it is still a bug.
> 
> Do you want me to redo the patch with __init taken out?

It would be better. As a general rule of thumb, an __init function should
not be called from a non __init, otherwise it is very hard to track the
call path.

Thanks,
Willy

