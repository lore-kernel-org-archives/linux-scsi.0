From: Tim Pepper <tpepper@gmail.com>
Subject: Re: Should multipath detect changed path UIDs?
Date: Sat, 29 Jan 2005 22:14:27 -0800
Message-ID: <eada2a0705012922144906efeb@mail.gmail.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A71B@SRMANNING.eng.emc.com>
Reply-To: Tim Pepper <tpepper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.199]:19769 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261650AbVA3GO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jan 2005 01:14:27 -0500
Received: by wproxy.gmail.com with SMTP id 67so432090wri
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jan 2005 22:14:27 -0800 (PST)
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A71B@SRMANNING.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "goggin, edward" <egoggin@emc.com>
Cc: 'dm-devel@redhat.com', "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, christophe varoqui <christophe.varoqui@free.fr>

Having the checker check for this change isn't a solution...it
shouldn't prevent any data corruption.  Even if you check prior to
every IO, you still have an obvious race between the check and the
subsequent IO.  You gain the ability to recognise the problem and
somehow magically warn the user (eg: disallow all subsequent IO to
catch the their attention).  So then what is a reasonable frequency
for the check?  How much corruption will you tolerate, because a lot
of IO can go out an FC connection in a short time.

Also, I'd think your #1 pre-requisite isn't quite right.  I'd say the
hole is wider and that you probably could have IO running heavily, as
long as none of it is failed by the lower layers in response to the
missing cable (and the default retries/timeouts could easily mask even
a clumsy cable swap).

Personally I'm also not inclined to think triggering hot plug events
on the cable removal/replacement is ideal.  I think fibre channel
isn't exactly intended as a dynamic environment and the SAN topology
is static or expected to be static from a given host's perspective. 
(I could be wrong.)  If this is the case, it would be helpful for a
host (or it's admin) to be able to know that topology and it's health
over time instead of only knowing the healthy portion of the topology
because the unhealthy parts are removed from its mappings.  Problem
determination seems like it's easier if you have a list of bad parts
instead of just a shrinking list of good parts.

Shouldn't the hba hardware/software be able to recognise and discern
between different classes of fabric failures, hba port link loss and
the return of a link that puts the port in a different place in the
SAN.  Does the HBA API give a common way to get detailed info out to
userspace daemons?
