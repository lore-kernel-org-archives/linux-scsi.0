From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux kernel security issuse scsi_report_lun_scan report
Date: Fri, 20 Nov 2015 13:24:38 -0800
Message-ID: <CA+55aFwHzeWy8oqMkscR0OLnk8Cq3cFGvZCsaHR4iNWL98mqpQ@mail.gmail.com>
References: <8159e011-35a9-4952-a0ef-be4dfb13983f.chengmiao.cj@alibaba-inc.com>
	<CA+55aFyn44rDnv3E9sSg_YGfeqhExvGz8yeAANU-BVghDHRFdA@mail.gmail.com>
	<1448044014.2168.34.camel@HansenPartnership.com>
	<CA+55aFxuts9UQb3XAVzq8TWQbfgBvftn_iOvo5+qb10RT65mrg@mail.gmail.com>
	<1448053036.2168.46.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35884 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759825AbbKTVYi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2015 16:24:38 -0500
Received: by iofh3 with SMTP id h3so137035610iof.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2015 13:24:38 -0800 (PST)
In-Reply-To: <1448053036.2168.46.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, Nov 20, 2015 at 12:57 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> It's done under the scan mutex, so there can only be one thread in that
> code at once.

Hmm. Looking at the call chain seems to confirm that.

But looking at the call chain I _also_ see that we have
scsi_free_host_dev() there, which seems to be some stale frame data
from a previous scan.

I'm wondering if that is a clue.  I find exactly two callers of that
functions, both in the gdth driver.

Maybe this is some odd refcount bug, brought on by reuse of a sdev.
Would that make more sense?

Why is that scsi_free_host_dev() used only by that one driver, and
nobody else wants it or needs it?

         Linus
