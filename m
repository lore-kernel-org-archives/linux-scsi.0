From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between runtime PM and
 system sleep (v2)
Date: Wed, 2 Nov 2011 22:00:39 +0100
Message-ID: <CACRpkdafpsgUi-0K5krr2_Hp+8GzCG8ZPu-HVNOK0_7uwURxdg@mail.gmail.com>
References: <201106260054.20578.rjw@sisk.pl>
	<201106292329.04163.rjw@sisk.pl>
	<201106292334.24518.rjw@sisk.pl>
	<CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
	<20111102191432.GC29355@kroah.com>
	<CACRpkdY8zAw_pdwn2yUEJPdfYPS+VCcLrpucZzhCyNsVPYehdg@mail.gmail.com>
	<20111102201101.GA5581@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43112 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1KBVAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2011 17:00:40 -0400
In-Reply-To: <20111102201101.GA5581@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org, Ulf Hansson <Ulf.Hansson@stericsson.com>

On Wed, Nov 2, 2011 at 9:11 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Nov 02, 2011 at 09:06:02PM +0100, Linus Walleij wrote:
>> On Wed, Nov 2, 2011 at 8:14 PM, Greg KH <greg@kroah.com> wrote:
>> > So, what specific git commits do you want to see in the 3.0-stable
>> > tree, and in what order should they be applied in?
>>
>> So to my untrained eye it looks like it should be applied like this =
(top to
>> bottom) using the reverse commit order from the mainline kernel:
>>
>> e529192 PM: Introduce generic "noirq" callback routines for subsyste=
ms (v2)
>> 455716e PM / Runtime: Update documentation of interactions with syst=
em sleep
>> 1e2ef05 PM: Limit race conditions between runtime PM and system slee=
p (v2)
>> f3393b6 PM / Runtime: Add new helper function: pm_runtime_status_sus=
pended()
>>
>> So (2) documents the problem, (3) fixes it, whereas (1) and (4) make=
s
>> it possible
>> to write proper _noirq() code that does not race, IIRC.
>
> But, after this, it's just adding new infrastructure that drivers wil=
l
> then be able to use. =A0As I'm not adding new drivers to 3.0, there w=
ill
> not be any users of this code, so why add it in the first place? =A0I=
t
> doesn't look like this follows the rules of the stable kernel tree at
> all, does it?

We'll have to get some feedback from Rafael, but the way I percieved
it, the patch (2) fixes a very real race, then fixing that makes it
necessary for drivers using runtime_pm to do things differently to
be on the safe side. But none were really fixed when first merging
it.

So on second thought you probably only want patch (2)
"PM: Limit race conditions between runtime PM and system sleep (v2)"
for stable.

Yours,
Linus Walleij
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
