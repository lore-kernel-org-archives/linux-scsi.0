From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [BKPATCH] SCSI sync
Date: 27 Sep 2003 16:20:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064697623.2217.476.camel@mulgrave>
References: <Pine.LNX.4.44.0309271110550.22923-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:54277 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262224AbTI0VUj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2003 17:20:39 -0400
In-Reply-To: <Pine.LNX.4.44.0309271110550.22923-100000@home.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, geert@linux-m68k.org
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2003-09-27 at 13:13, Linus Torvalds wrote:
> what's this? It's the only place in the whole source file that has 
> "phases". 

OK, after a bit of a paperchase, this is the problem:

hangeSet 1.1217.10.7 2003/09/12 09:52:45 geert@linux-m68k.org
  [PATCH] NCR5380.c warning
  
  NCR5380: `phases' is used inside the #ifdef NDEBUG only, so move its
definition
  inside as well.

It wasn't realised that NCR5380.c is #included into g_NCR5380.c and
provided the phases[] array for that as well.

James


