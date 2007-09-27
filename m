From: Steve Calfee <stevecalfee@hotmail.com>
Subject: RE: [linux-usb-devel] question on flushing buffers and spinning
	down disk
Date: Thu, 27 Sep 2007 13:54:43 -0700
Message-ID: <BAY119-W38D77E53399EF6B34689B0B6B10@phx.gbl>
References: <200709272126.47558.oliver@neukum.org>
 <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay0-omc1-s38.bay0.hotmail.com ([65.54.246.110]:14252 "EHLO
	bay0-omc1-s38.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635AbXI0Uyn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 16:54:43 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <james.bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org



> Date: Thu, 27 Sep 2007 16:26:56 -0400
> From: stern@rowland.harvard.edu
> To: oliver@neukum.org
> CC: James.Bottomley@steeleye.com; linux-usb-devel@lists.sourceforge.n=
et; linux-scsi@vger.kernel.org
> Subject: Re: [linux-usb-devel] question on flushing buffers and spinn=
ing down disk
>
> On Thu, 27 Sep 2007, Oliver Neukum wrote:
>
>>>> 1. autosuspend should not be specific to USB
>>>
>>> Correct. Which means support for it should be added to the SCSI
>>> drivers. SCSI autosuspend shouldn't be kluged into usb-storage in a
>>> way that basically ignores what the SCSI layer is doing.
>>
>> It isn't. The decision to autosuspend is based on activity on the bu=
s.
>> Now you might argue that the decision to do an autosuspend should
>> always propagate upwards from the lowest level of the device tree.
>> Then I ask why?



>> Err, why? After all, there's a central instance in userspace that de=
cides
>> that the whole system isn't used right now. I see no reason to not u=
se
>> this model for parts of the device tree.
>
> Autoresume is the major complication.
>
> There's also a philosophical objection. Who is in a better position t=
o
> judge when a device like a SCSI drive should be autosuspended: its ow=
n
> driver (sd) or someone else (usb-storage)?
>

Isn't power saving a policy decision? Should it not be left to userspac=
e to control?

Doesn't userspace decide to blank the video based on user preferences? =
Userspace could jump through all sorts of hoops to wait for disks to sp=
in down, etc on the way to powersaving.

If we really need the capability to suspend a mouse/keyboard etc after =
2-n seconds of no use, shouldn't it be userspace that enables the "auto=
suspend"? Has the battery life impact of the various device shutdowns b=
een measured and found useful?

Just a bunch of questions, but it seems to me that what is really neede=
d is a mechanism for userspace to do fine grained power control.

Regards, Steve
_________________________________________________________________
Connect to the next generation of MSN Messenger=A0
http://imagine-msn.com/messenger/launch80/default.aspx?locale=3Den-us&s=
ource=3Dwlmailtagline-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
