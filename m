From: Lennart Poettering <lennart@poettering.net>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 19:03:12 +0200
Message-ID: <20100331170312.GA21369@tango.0pointer.de>
References: <Pine.LNX.4.44L0.1003311054500.1739-100000@iolanthe.rowland.org>
 <1270048801.16657.8.camel@localhost.localdomain>
 <4BB37454.8070808@interlog.com>
 <1270053444.16657.17.camel@localhost.localdomain>
 <20100331165807.GA20547@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:35260 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0CaRDp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2010 13:03:45 -0400
Content-Disposition: inline
In-Reply-To: <20100331165807.GA20547@tango.0pointer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Zeuthen <david@fubar.dk>
Cc: dgilbert@interlog.com, Alan Stern <stern@rowland.harvard.edu>, Jonas Schwertfeger <jschwertfeger@gmail.com>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 31.03.10 18:58, Lennart Poettering (lennart@poettering.net) wrote:

> > As I said above, I don't think it's ata_id that is the problem - I think
> > it's udisks-probe-ata-smart, via libatasmart, that is responsible for
> > submitting the SET FEATURES command:

Actually, libatasmart does not even call SET_FEATURES. We only issue
four types of commands:

IDENTIFY_DEVICE
IDENTIFY_PACKET_DEVICE
SMART
CHECK_POWER_MODE

the sources don't know about any other commands:

http://git.0pointer.de/?p=libatasmart.git;a=blob;f=atasmart.c;h=a4b60c0eedf8e4f1ebafd932b7070c030459ef16;hb=HEAD#l128

So the SET_FEATURES must come from somewhere else...

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
