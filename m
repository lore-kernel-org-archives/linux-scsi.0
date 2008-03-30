From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 12/17] ips.c: fix build warning
Date: Sun, 30 Mar 2008 12:07:22 -0500
Message-ID: <1206896842.4224.46.camel@localhost.localdomain>
References: <200803282148.m2SLmeDg012249@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48242 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbYC3RH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 13:07:26 -0400
In-Reply-To: <200803282148.m2SLmeDg012249@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, aacraid@adaptec.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org

On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> powerpc:
> 
> drivers/scsi/ips.c: In function 'ips_issue_copperhead':
> drivers/scsi/ips.c:5436: warning: large integer implicitly truncated to unsigned type
> 
> it doesn't seem necessary to do outw(cpu_to_le32(...), ...) anyway.

Actually, it's not only not necessary ... it's an actual bug on BE
platforms.  Both writeX and outX/inX automatically convert from native
to bus endian (usually simply to LE since the bus is PCI).  Therefore if
you add a cpu_to_leX, you actually write the wrong value on a BE system.

Mark, it looks like the correct fix is simply to strip all of these ...
has this driver actually been tested on a BE platform (like parisc or
PPC)?

James


