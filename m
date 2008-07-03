From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: SG_IO permissions
Date: Thu, 3 Jul 2008 19:57:55 +0200
Message-ID: <20080703175755.GB1513@luba>
References: <1215004850.5058.101.camel@pcitfio23.cern.ch> <1215010262.3330.19.camel@localhost.localdomain> <E7F3663B89B60B478C6997C0A0671F8B0D58A9@cernxchg45.cern.ch> <E7F3663B89B60B478C6997C0A0671F8B0D58AB@cernxchg45.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ninsei.hu ([212.92.23.158]:56603 "EHLO ninsei.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbYGCS1L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 14:27:11 -0400
Received: from luba (lns-bzn-35-82-250-199-26.adsl.proxad.net [82.250.199.26])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id CA020785F
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2008 19:57:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <E7F3663B89B60B478C6997C0A0671F8B0D58AB@cernxchg45.cern.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

* Arne Wiebalck (arne.wiebalck@cern.ch) [20080702 20:40]:

> The user process in my case is forked by another process which
> runs as root. But since this process does not have CAP_SETPCAP
> it cannot set the child's capabilities (which is how I naively
> thought one could implement this).

There is no need.  Your problem is that setuid() clears the
permissible capability set.  This should do the trick:

	/* ...in child after fork()... */
	prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0);
	setuid(...);
	cap_set_proc(cap_from_text("cap_sys_rawio+ep"));

HTH,
Peter

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=C3=A9ter     /       \       /       \     Peter.Kelemen@cer=
n.ch
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
