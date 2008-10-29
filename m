From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 14/17] scsi: fix bad use of udelay in atp870u.c
Date: Wed, 29 Oct 2008 16:42:15 -0500
Message-ID: <1225316535.3257.16.camel@localhost.localdomain>
References: <200810292124.m9TLOk2b021279@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38229 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbYJ2VmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 17:42:20 -0400
In-Reply-To: <200810292124.m9TLOk2b021279@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, tbm@cyrius.com

On Wed, 2008-10-29 at 14:24 -0700, akpm@linux-foundation.org wrote:
> -       udelay(0x800);
> +       mdelay(2);
> +       udelay(48);

OK, this fix is obviously wrong ... the code holds off interrupts for
two ticks that's clearly completely bogus.  In this case silencing the
warning is hiding the bogosity ... now if only someone could actually
fix it ...

James


