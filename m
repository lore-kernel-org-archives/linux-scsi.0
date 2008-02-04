From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9880] dma_free_coherent in arcmsr when calling areca tools
Date: Sun,  3 Feb 2008 20:36:41 -0800 (PST)
Message-ID: <20080204043642.04242108018@picon.linux-foundation.org>
References: <bug-9880-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbYBDEhN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Feb 2008 23:37:13 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m144agPc019086
	for <linux-scsi@vger.kernel.org>; Sun, 3 Feb 2008 20:36:43 -0800
In-Reply-To: <bug-9880-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D9880





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2008-02-03 20:3=
6 -------
Reply-To: david-b@pacbell.net

On Sunday 03 February 2008, James Bottomley wrote:
> That's caused by this commit:
>=20
> commit aa24886e379d2b641c5117e178b15ce1d5d366ba
> Author: David Brownell <david-b@pacbell.net>
> Date: =A0 Fri Aug 10 13:10:27 2007 -0700
>=20
> =A0 =A0 dma_free_coherent() needs irqs enabled (sigh)
> =A0 =A0=20
> I've cc'd the people responsible for this apparent bit of idiocy. =A0=
Since
> the API addition to dma_alloc_coherent() was the GFP flags so you cou=
ld
> call it from interrupt context with GFP_ATOMIC if so desired,
> (pci_dma_alloc_consistent always has GFP_ATOMIC semantics), why on ea=
rth
> would the corresponding free routine require non-atomic semantics?

That was my reaction ... but I was told this would not be fixed.

See also 8a3c1f573c771e60f67ef172d2392d1a28385b4a ... several other
controller drivers needed similar logic at one point.  (I eventually
ripped that programming interface out, or *EVERY* driver would have
needed crap like that.  The interface was mostly misused anyway, so
it was no big loss.)


> Is it seriously true that you can call dma_alloc_coherent() from atom=
ic
> context on arm, but not dma_free_coherent()?

Lacking a tasklet in dma_free_coherent() analagous to that omap_udc com=
mit
I referenced ...


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
