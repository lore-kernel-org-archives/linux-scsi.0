From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH,RESEND] scsi: use __uX types for headers exported to
 user space
Date: Thu, 07 Jan 2010 09:40:29 -0500
Message-ID: <1262875229.3025.4.camel@mulgrave.site>
References: <1262874005-25089-1-git-send-email-jacmet@sunsite.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50921 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab0AGOkf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jan 2010 09:40:35 -0500
In-Reply-To: <1262874005-25089-1-git-send-email-jacmet@sunsite.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 15:20 +0100, Peter Korsgaard wrote:
> Commit 9e4f5e29 (FC Pass Thru support) exported a number of header fi=
les
> in include/scsi to user space, but didn't change the uX types to the
> userspace-compatible __uX types. Without that you'll get compile erro=
rs
> when including them - E.G.:
>=20
> /tmp/include/scsi/scsi.h:145: error: expected specifier-qualifier-lis=
t
> before =E2=80=98u8=E2=80=99
>=20
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
> ---
>  No feedback since 27/11, resending.

OK, so to summarise the list discussion, the current status is that the
SCSI exports are irrelevant because glibc currently ignores the
include/scsi namespace provided by the kernel.  So, we have three
options:

     1. Bring our exports up to the point where they can replace glibc'=
s
        include/scsi/scsi.h and the rest.  This requires a line by line
        analysis of what's in glibc and an update to our include to
        provide or remove as necessary.  After this is done we can try
        to persuade the glibc people to turn over the include/scsi
        namespace to us.
     2. Kill the kbuild exports and make everyone go via the glibc tree
        (current state).
     3. Move the kernel include/scsi to a more conventional namespace
        (like inside include/linux) so glibc will pick it up.

So far we've had people supporting all three.  I'm inclined to say that
I'd favour 1, but the first patch trying to do any of them would be the
best starting ground for a discussion.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
