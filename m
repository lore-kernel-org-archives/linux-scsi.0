From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] intermediate SCSI updates
Date: Mon, 13 Oct 2008 10:22:25 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
References: <1223909115.5566.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbYJMRW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 13:22:57 -0400
In-Reply-To: <1223909115.5566.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



On Mon, 13 Oct 2008, James Bottomley wrote:
>
> This represents all the pieces of SCSI which were depending on the
> already merged block tree.

Grr. And it doesn't actually compile.

  drivers/scsi/sd.c:579:27: error: macro "sd_dif_op" passed 4 arguments=
, but takes just 3
  drivers/scsi/sd.c: In function =A1sd_prep_fn=A2:
  drivers/scsi/sd.c:578: error: =A1sd_dif_op=A2 undeclared (first use i=
n this function)
  drivers/scsi/sd.c:578: error: (Each undeclared identifier is reported=
 only once
  drivers/scsi/sd.c:578: error: for each function it appears in.)

Hmm? Was this testedt AT ALL? It can never compile unless that idiotic=20
CONFIG_BLK_DEV_INTEGRITY option is set that no sane person would set ri=
ght=20
now, and which is even documented to not be enabled by default:

  If in doubt, say N.

yet it looks like it has not compiled since a commit that was put in in=
=20
the middle of September!

What part of "This is total untested crap" are we missing here?

Yeah, I'm grumpy. I expect to not be fed shit like this. It has apparen=
tly=20
been rebased several times, and all apparently with no testing=20
what-so-ever!

		Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
