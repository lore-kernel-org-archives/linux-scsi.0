From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch 01/19] scsi: add __init/__exit macros to ibmvstgt.c
Date: Thu, 31 Dec 2009 16:59:08 +0100
Message-ID: <e2e108260912310759k3348b423r734800d6910df6bf@mail.gmail.com>
References: <200912220027.nBM0Rcrj005361@imap1.linux-foundation.org>
	 <200912220806.32904.PeterHuewe@gmx.de>
	 <1261500404.2774.15.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57869 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZLaP7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Dec 2009 10:59:11 -0500
Received: by ewy19 with SMTP id 19so4734992ewy.21
        for <linux-scsi@vger.kernel.org>; Thu, 31 Dec 2009 07:59:09 -0800 (PST)
In-Reply-To: <1261500404.2774.15.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Peter Huewe <PeterHuewe@gmx.de>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au, trivial@kernel.org

On Tue, Dec 22, 2009 at 5:46 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> On Tue, 2009-12-22 at 08:06 +0100, Peter Huewe wrote:
> > Am Dienstag 22 Dezember 2009 01:27:38 schrieb akpm@linux-foundation=
=2Eorg:
> > [ ... ]
> > this patch is floating around for almost half a year (2009/06/23) a=
nd I was
> > wondering if there is anything wrong with it, or why it doesn't get=
 merged
> > upstream.
>
> well, it still has to be tested. =A0I'd guess IBM is putting out othe=
r
> fires, since it's really just cosmetic, even in terms of memory savin=
gs.

I'm not sure that's a valid reason for holding up ibmvscsi patches. If
IBM not having time to retest ibmvscsi was a valid reason for blocking
ibmvscsi patches, then all patches that touch any kernel subsystem
used by ibmvscsi should be rejected. Examples of subsystems used by
ibmvscsi are libsrp and kfifo.

By the way, srp_iu_pool_alloc() in libsrp passes max * sizeof(void *)
to the size argument of kfifo_init(), and kfifo_init() tests the size
argument as follows:

BUG_ON(!is_power_of_2(size));

The function srp_iu_pool_alloc() in libsrp neither verifies that 'max'
is a power of two nor rounds up 'max' to the next power of two.
Doesn't look very good ...

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
