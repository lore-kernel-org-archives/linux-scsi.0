From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH -tip][SCSI] scsi: scsi_transport_iscsi.c initialize the
	variable before it get used
Date: Tue, 26 May 2009 10:28:29 -0500
Message-ID: <1243351709.2815.33.camel@localhost.localdomain>
References: <1243351161.31783.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55509 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358AbZEZP22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 11:28:28 -0400
In-Reply-To: <1243351161.31783.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, 2009-05-26 at 20:49 +0530, Jaswinder Singh Rajput wrote:
> I am watching this problem from long time in -tip.
>=20
> Subject: [PATCH] scsi: scsi_transport_iscsi.c initialize the variable=
 before it get used
>=20
> In some cases, err will be used uninitialized.

What cases?  A simple theoretical analysis shows that this variable is
always set.

>  CC      drivers/scsi/scsi_transport_iscsi.o
> drivers/scsi/scsi_transport_iscsi.c: In function =E2=80=98iscsi_add_s=
ession=E2=80=99:
> drivers/scsi/scsi_transport_iscsi.c:678: warning: =E2=80=98err=E2=80=99=
 may be used
> uninitialized in this function

My version of gcc (4.3.3) correctly sees that the variable cannot be
uninitialised ... what version are you using?

If it's a popular version, we can always do the uninitialised_var()
thing, but if it's just a non-standard compiler, I'd rather not mess up
the source code to please gcc.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
