From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] 2.4.21 fix race condition in sg.c
Date: Fri, 27 Jun 2003 11:38:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <002b01c33cc2$2a353d40$e0019d89@cybernetics.com>
References: <1056726720.1825.27.camel@mulgrave>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:21253 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S264810AbTF0PYS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 11:24:18 -0400
In-Reply-To: <1056726720.1825.27.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>
Cc: 'Alan Cox' <alan@lxorguk.ukuu.org.uk>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, marcelo@conectiva.com.br, dougg@torque.net

> > Isn't smp_wmb() necessary to prevent the CPU from 
> > re-ordering the stores?
> 
> Ah, OK.  The answer's yes and no.  Your example is true for lockless
> access, but horribly racy (which is why, in practice, it's 
> almost never
> done).  The original code had locked access to done which prevents the
> race.  If we've lost the locked access, I don't think the fix can be
> correct.

I looked at the locking before attempting the patch, but I didn't see
anything protecting the done flag or status return fields.  It is true
that the done flag was set (without the patch) holding sg_dev_arr_lock,
but the code that looks at the done flag doesn't touch that lock.

If you think it needs a spinlock to be correct, then I will wait for
Doug's input, since he knows how it is supposed to work.

Anthony J. Battersby
Cybernetics

