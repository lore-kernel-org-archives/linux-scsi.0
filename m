From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: How does a SCSI device gets a target ID?
Date: Wed, 9 Mar 2005 13:45:45 -0500
Message-ID: <OFDD349AB8.88468402-ON85256FBF.0065CD37-88256FBF.0066B5E2@us.ibm.com>
References: <267988DEACEC5A4D86D5FCD780313FBB0575F03B@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58066 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262189AbVCISpw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 13:45:52 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j29IjkJd014153
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 13:45:46 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j29Ijk15233014
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 13:45:46 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j29IjkN5002252
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 13:45:46 -0500
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB0575F03B@exch-03.noida.hcltech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajat Jain, Noida" <rajatj@noida.hcltech.com>
Cc: linux-scsi@vger.kernel.org

It's not clear what you're asking.  You start off with the question

>When a new SCSI device is added to a SCSI channel, how can we find out 
what
>is the target ID of that device? 

That's clear enough, except I don't know who "we" is.  Depending on who 
you are, i.e. from what perspective you're looking, you would get this 
information differently.

But then you give two hypotheses that describe how a device comes to have 
its target ID, not how someone finds out what target ID it has.

>1) If a channel supports 8 SCSI devices, then each of the 8 ports will 
have
>a specific Target ID. And any device attached to that port will have that
>Target ID.

>2) Is it done one the fly? I mean (starting from zero), the SCSI device 
is
>given a target ID that is 1 greater that the last SCSI device's ID. Who
>assigns this ID?

Others have read a particular question into your question and answered it, 
but it might not be what you were looking for.

Let me give a shot at answering a few of the questions that it might be:

A device traditionally gets its target ID from a physical switch on the 
device.  The person who installs the device sets the switch and can tell 
the target ID by looking at it the switch.  That person chooses the target 
IDs to be anything he wants, but makes sure that no two devices plugged 
into the same bus have the same target ID.

In modern times, some devices (disk devices, anyway) get their target ID 
by being plugged into a backplane or cable in a certain place.  In that 
case, you can tell the target ID by noting where it's plugged in and 
knowing how the thing you plugged it into is configured.  SCA is one 
standard for allowing this kind of target ID assignment.

Some devices even get their target IDs dynamically with SCAM, but I don't 
know anything about SCAM.

If you're inside the computer and trying to figure out what target ID an 
attached device has, all you can do is search the namespace.  You try each 
target ID and if a device answers, you can ask it for information about 
itself (model, serial number, etc.).  But you don't necessarily ever know 
what target ID a particular device has -- you just know that there exists 
a device with a certain target ID.

At various levels of Linux, matching up target IDs with devices is done 
via various interfaces, most of them quite tortured.

