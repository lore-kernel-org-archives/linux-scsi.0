From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: RE: How does a SCSI device gets a target ID?
Date: Thu, 10 Mar 2005 10:19:24 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB0575F562@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Received: from ngate.noida.hcltech.com ([202.54.110.230]:37812 "EHLO
	ngate.noida.hcltech.com") by vger.kernel.org with ESMTP
	id S262007AbVCJEt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 23:49:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>, "Rajat Jain, Noida" <rajatj@noida.hcltech.com>
Cc: linux-scsi@vger.kernel.org



BINGO !!!!!

That answered to a lot extent what I was looking for. Yes, I accept my
question was a little cloudy. I wanted to ask both the perspectives: How
does a SCSI device gets its ID ... And How can the software (kernel / user)
find out the target ID of the new disk.

I'm using a HS disk (Hot Swappable SCSI disk, they call it). I have 4 slots
in the front panel of my computer. And when ever I plug the disk into a
different port, the target ID changes. I wanted to confirm that the target
Ids are binded to the PORTS in my case. I got my answer, in my case, the
target ID depends upon which port you plug the disk into.

Every time I plug / unplug the disk, I have to echo "scsi
add-single-device"/"scsi remove single-device" (with correct traget ID) to
/proc/scsi/scsi. I wanted to automate this process, I wanted the disk to get
detected and installed the moment it is inserted / removed. Can I do that? I
don't mind writing a kernel module if need be.

Currently after reading the mail, what I am planning to do is to write a
user level script that would echo "add-single device" to the proc interface,
for ALL the possible target Ids on the Bus. But again, I would have to RUN
that script manually, and it will have to ITERATE on the the possible target
Ids. Is there a better way?

Thanx a ton,

Rajat
 

-----Original Message-----
From: Bryan Henderson [mailto:hbryan@us.ibm.com] 
Sent: Thursday, March 10, 2005 12:16 AM
To: Rajat Jain, Noida
Cc: linux-scsi@vger.kernel.org
Subject: Re: How does a SCSI device gets a target ID?

It's not clear what you're asking.  You start off with the question

>When a new SCSI device is added to a SCSI channel, how can we find out
what
>is the target ID of that device? 

That's clear enough, except I don't know who "we" is.  Depending on who you
are, i.e. from what perspective you're looking, you would get this
information differently.

But then you give two hypotheses that describe how a device comes to have
its target ID, not how someone finds out what target ID it has.

>1) If a channel supports 8 SCSI devices, then each of the 8 ports will
have
>a specific Target ID. And any device attached to that port will have 
>that Target ID.

>2) Is it done one the fly? I mean (starting from zero), the SCSI device
is
>given a target ID that is 1 greater that the last SCSI device's ID. Who 
>assigns this ID?

Others have read a particular question into your question and answered it,
but it might not be what you were looking for.

Let me give a shot at answering a few of the questions that it might be:

A device traditionally gets its target ID from a physical switch on the
device.  The person who installs the device sets the switch and can tell the
target ID by looking at it the switch.  That person chooses the target IDs
to be anything he wants, but makes sure that no two devices plugged into the
same bus have the same target ID.

In modern times, some devices (disk devices, anyway) get their target ID by
being plugged into a backplane or cable in a certain place.  In that case,
you can tell the target ID by noting where it's plugged in and knowing how
the thing you plugged it into is configured.  SCA is one standard for
allowing this kind of target ID assignment.

Some devices even get their target IDs dynamically with SCAM, but I don't
know anything about SCAM.

If you're inside the computer and trying to figure out what target ID an
attached device has, all you can do is search the namespace.  You try each
target ID and if a device answers, you can ask it for information about
itself (model, serial number, etc.).  But you don't necessarily ever know
what target ID a particular device has -- you just know that there exists a
device with a certain target ID.

At various levels of Linux, matching up target IDs with devices is done via
various interfaces, most of them quite tortured.
