From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [PATCH] 2.4.21 fix race condition in sg.c
Date: 27 Jun 2003 10:11:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056726720.1825.27.camel@mulgrave>
References: <002a01c33cbc$5e45d960$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:57860 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264503AbTF0O5t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 10:57:49 -0400
In-Reply-To: <002a01c33cbc$5e45d960$e0019d89@cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: 'Alan Cox' <alan@lxorguk.ukuu.org.uk>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, marcelo@conectiva.com.br, dougg@torque.net

On Fri, 2003-06-27 at 09:57, Tony Battersby wrote:
> > I don't believe any of the above applies to the sg request 
> > pointer done flag.
> 
> I see a situation analogous to this:
> 
> CPU #0:
> foo = result;
> smp_wmb();
> done = 1;
> 
> CPU #1:
> if (done)
> 	return foo;

> Isn't smp_wmb() necessary to prevent the CPU from re-ordering the stores?

Ah, OK.  The answer's yes and no.  Your example is true for lockless
access, but horribly racy (which is why, in practice, it's almost never
done).  The original code had locked access to done which prevents the
race.  If we've lost the locked access, I don't think the fix can be
correct.

James


