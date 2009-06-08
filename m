From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 8 Jun 2009 09:21:04 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
References: <200906061959.55592.chris2553@googlemail.com>  <200906062215.30571.chris2553@googlemail.com>  <1244381140.30664.12.camel@ht.satnam>  <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>  <1244413881.18742.31.camel@ht.satnam>
 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>  <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>  <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>  <1244460875.12644.2.camel@ht.satnam>
 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351AbZFHQXg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 12:23:36 -0400
In-Reply-To: <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Clayton <chris2553@googlemail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>



On Mon, 8 Jun 2009, Chris Clayton wrote:
>=20
> OK. I reversed that change and built and installed the kernel. It has
> withstood 100 reboots without a panic. Additionally, I pulled the
> latest changes (that will be rc8-git5, I think) from kernel.org,
> reversed the change to that kernel and built and installed it. That
> too withstood 100 reboots without a panic.
>=20
> Let me know if there's anything else I can do to help fix this.

That's already pretty convincing.

James, Arjan? The original oops message is here (a jpg screen capture,=20
unable to open initial console):

	http://lkml.org/lkml/2009/6/6/142

and it's this bug entry:

	Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=3D13474
	Subject         : Oops whilst booting
	Submitter       : Chris Clayton <chris2553@googlemail.com>
	Date            : 2009-06-06 18:59 (2 days old)
	References      : http://marc.info/?l=3Dlinux-kernel&m=3D1244314879242=
54&w=3D4

and now bisected down to=20

>> commit d5a877e8dd409d8c702986d06485c374b705d340
>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date: =A0 Sun May 24 13:03:43 2009 -0700
>>
>> =A0 =A0 async: make sure independent async domains can't accidentall=
y entangle

please advice. Otherwise I'll have to revert.

		Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
