From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Infinite retries reading the partition table
Date: Tue, 5 Dec 2006 21:00:20 -0800 (PST)
Message-ID: <794609.32071.qm@web31811.mail.mud.yahoo.com>
References: <4575D951.3010705@sgi.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:45943 "HELO
	web31811.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760091AbWLFFAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 00:00:21 -0500
In-Reply-To: <4575D951.3010705@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

--- Michael Reed <mdr@sgi.com> wrote:
> Luben Tuikov wrote:
> ...snip...
> > This statement in scsi_io_completion() causes the infinite retry loop:
> >    if (scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)
> >          return;
> 
> The code in 2.6.19 is "result==0", not "!!result", which is logically
> the same as "result!=0".  Did you mean to change the logic here?
> Am I missing something?

Hmm, I think my trees have !!result from an earlier patch I posted.

In this case it would appear that the second chunk of the patch
wouldn't be necessary, since result==0 would be false, and it
wouldn't retry.

    Luben



