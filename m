From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] 2.4.21 fix race condition in sg.c
Date: Fri, 27 Jun 2003 10:57:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <002a01c33cbc$5e45d960$e0019d89@cybernetics.com>
References: <1056723054.1825.16.camel@mulgrave>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:60685 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S264398AbTF0Om6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 10:42:58 -0400
In-Reply-To: <1056723054.1825.16.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Alan Cox' <alan@lxorguk.ukuu.org.uk>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, marcelo@conectiva.com.br, dougg@torque.net

> I don't believe any of the above applies to the sg request 
> pointer done flag.

I see a situation analogous to this:

CPU #0:
foo = result;
smp_wmb();
done = 1;

CPU #1:
if (done)
	return foo;

Isn't smp_wmb() necessary to prevent the CPU from re-ordering the stores?

In the actual code, "foo" corresponds to fields like the SCSI return status,
sense data, and the data transfer residual.

Sorry if I am wrong about this.  I couldn't find much documentation on the
proper use of barriers.

Anthony J. Battersby
Cybernetics

