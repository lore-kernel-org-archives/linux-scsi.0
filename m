From: Roland Dreier <roland@kernel.org>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Fri, 8 Jul 2011 13:47:18 -0700
Message-ID: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
References: <Pine.LNX.4.44L0.1107071653010.1687-100000@iolanthe.rowland.org> <1310144667.3282.94.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55987 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1GHUrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 16:47:39 -0400
Received: by iwn6 with SMTP id 6so2076556iwn.19
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2011 13:47:38 -0700 (PDT)
In-Reply-To: <1310144667.3282.94.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Fri, Jul 8, 2011 at 10:04 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> So when I asked Jens, he agreed block. =A0The problem we've been runn=
ing
> into is that the teardown state (QUEUE_FLAG_DEAD) isn't really checke=
d
> where it should be, so the early teardown SCSI now does runs into a l=
ot
> of these missing checks.

So I guess my dm-multipath case also needs to sprinkle a bunch of check=
s
of block queue state into dm.c too... I'll look at doing that.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
