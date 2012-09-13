From: Chris Leech <cleech@redhat.com>
Subject: future FCoE ideas (Re: [RFC PATCH 0/5] Reorganize libfcoe control interfaces)
Date: Thu, 13 Sep 2012 15:32:50 -0700
Message-ID: <CAHNqLyUCgrDLCXnchVAieP0y2n8QmWHD-Nr-V54aypgSDHnR0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58112 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2IMWcv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2012 18:32:51 -0400
Received: by vbbff1 with SMTP id ff1so4133426vbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 13 Sep 2012 15:32:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, linux-scsi@vger.kernel.org

<cutting down the CC list, as this bit isn't really about patch review anymore>

>> That being said, I'm glad this is being reworked.  Do you have any
>> other functionality in mind that this is laying the groundwork for?
>>
>
> I have one feature and a few ideas. I currently have a patch that adds
> a fabric selection feature. I add another RW attribute to the ctlr_X
> device. If the user writes fabric name to the file libfcoe uses it in
> it's FCF selection algorithm. Here's my commit message from that patch.
> I can share the patch if people would like to see it too. The current
> implementation also allows the user to force the login through a
> specific FCF.
>
>      libfcoe, bnx2fc, fcoe: Add 'selection' attribute
>
>     This patch adds a 'selection' attribute to the
>     fcoe_ctlr_device. The user can write either a
>     '0x' prefixed fabric name or a ':' separated
>     MAC address to this file. If a fabric name is
>     provided the fcoe ctlr will only consider FCFs
>     with the fabric name when choosing a FCF to login
>     to. If a MAC address is provided the initiator
>     will only login to a FCF with the given Ethernet
>     address. Only one selection is valid at a time.
>
>     There are corresponding changes to fcoe-utils
>     to take advantage of this kernel feature and
>     to make it more accessible for the user.
>
> To accompany this feature I created a new fipfcf application based on
> fipvlan that sends out a discovery solicitation and displays
> advertising FCFs.

Cool, I think you know that the lack of control over FCF selection has
bothered me for a while :)

Another option to think about, instead of configuring a preferred FCF
prior to discovery (using your command line tool to find out what's
available) what if it was possible to disable the auto-login behavior
(leaving it on by default) and then enable login to an FCF using the
representation you've added to sysfs?  Basically, allow a user-space
policy agent to disable the auto-selection and take control.

So the steps could be

1) create and FCoE controller for a network interface
2) configure the controller, disabling auto-fabric-selection
3) enable the controller, starting FCF discovery
4) select from the discovered FCF objects
5) enable fabric login on the desires FCFs

That could even work for native PCI-function FCoE devices, where
fipvlan/fipfcf have issues because the netdev might not be up (or even
have a driver loaded), as long as they support the interface and
provide the OS with information about discovered FCFs.

> I've also been talking with Mark Rustad about doing an 'auto' mode
> where Fabric discovery is attempted first and if it fails then it tries
> VN2VN discovery, but so for we've only had hallway conversations about
> it and nothing has been flushed out.

I'm trying to get caught up on what's getting traction with the
FC-BB-6 working group, but it looks like VN2VN for both true
point-to-point and multipoint might get nailed down.  As well as
establishing shortest-path connections between native FCoE endpoints
in fabric mode, to avoid shoving all data through the FCF if it
doesn't need to.  All exciting work to think about.

Do we have a better indication of what network interface an fc_host is
created on, or is parsing for 'fcoe v0.1 over <ifname>' in the
symbolic name still the best thing going?

Sorry if it seems like I've got lots of opinions but no patches right now :)
I'm testing your RFC patchset out, at least to the extent that I can
with VN2VN mode right now.

- Chris
