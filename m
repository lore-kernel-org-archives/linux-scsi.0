From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] silence gcc warning about possibly uninitialized use of variable in scsi_scan
Date: Sun, 26 Feb 2006 19:23:55 +0100
Message-ID: <9a8748490602261023j46eb39f2peaa080d737fee5e1@mail.gmail.com>
References: <200602261639.15657.jesper.juhl@gmail.com>
	 <1140978084.3692.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.195]:1401 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751381AbWBZSX4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 13:23:56 -0500
Received: by wproxy.gmail.com with SMTP id i11so990592wra
        for <linux-scsi@vger.kernel.org>; Sun, 26 Feb 2006 10:23:56 -0800 (PST)
In-Reply-To: <1140978084.3692.6.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org, Eric Youngdale <ericy@cais.com>, Eric Youngdale <eric@andante.org>, linux-scsi@vger.kernel.org

On 2/26/06, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Sun, 2006-02-26 at 16:39 +0100, Jesper Juhl wrote:
> > Gcc can't see that 'result' will always be initialized inside the for loop
> > and thus it warns
> >   drivers/scsi/scsi_scan.c:445: warning: 'result' might be used uninitialized in this function
> > This patch silences the warning by initializing 'result' to zero.
>
> Really, this is a gcc bug.  My version of the compiler:
>
> gcc version 4.0.3 20051201 (prerelease) (Debian 4.0.2-5)
>
> Doesn't give this warning.  And, since the loop has fixed parameters,
> gcc should see not only that it's always executed, but that it could be
> unrolled.
>
> Which version is causing the problem?
>
2.6.16-rc4-mm2 build with gcc 3.4.5

and I agree that gcc really should be noticing, but in fact it
doesn't. It's no big deal, I just thought we might want to shut gcc up
and give people one less warning to worry about.

--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
