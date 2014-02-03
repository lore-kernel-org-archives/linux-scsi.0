From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 3 Feb 2014 21:11:42 +0000
Message-ID: <1391461902.30735.12.camel@dabdike.int.hansenpartnership.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
	 <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>
	 <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>
	 <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com>
	 <52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com>
	 <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:45706 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaBCVMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 16:12:19 -0500
In-Reply-To: <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
Content-Language: en-US
Content-ID: <BEEDA9A2F42C3A4D8A374F6C71001F0C@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "kay@vrfy.org" <kay@vrfy.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "hare@suse.de" <hare@suse.de>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On Mon, 2014-02-03 at 21:51 +0100, Kay Sievers wrote:
> On Mon, Feb 3, 2014 at 4:08 PM, Jeremy Linton <jlinton@tributary.com> wrote:
> > On 2/3/2014 9:06 AM, Hannes Reinecke wrote:
> >
> >> That's due to udev. Udev is getting events for each device it should create
> >> a device node for. So for 'st' it'll get a series of events for 'stX', and
> >> another series of events for 'nstX'. Udev will treat each of these events
> >> separately, with distinct worker programs handling them. Each of those
> >> workers run fully asynchronous and cannot access information from other
> >> workers.
> >
> >         So whats wrong with the simple solution? You throw the ones for st away, and
> > create the st handles from the nst worker.
> 
> This is not simple and not going to happen. Sibling devices in /sys
> cannot have a relationship in udev, there are only parent/child
> dependencies.
> 
> Hannes, can't you just drop the weird auto-rewinding device matches
> from the persistent rules, is that really useful today?

Regardless of the outcome of these discussions about adding a rewind
ioctl, we can't just kill the auto-rewind devices because that would be
an ABI break (the consequence would be people's backup scripts would
break and nothing annoys sysadmins more than failed backups).

James

