From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 03 Feb 2014 16:16:07 -0500
Message-ID: <52F00717.5060106@interlog.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com> <52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59068 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbaBCVQh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Feb 2014 16:16:37 -0500
In-Reply-To: <52EFB0E7.3000504@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, Hannes Reinecke <hare@suse.de>, =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>
Cc: James Bottomley <jbottomley@parallels.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 14-02-03 10:08 AM, Jeremy Linton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 2/3/2014 9:06 AM, Hannes Reinecke wrote:
>
>> That's due to udev. Udev is getting events for each device it should create
>> a device node for. So for 'st' it'll get a series of events for 'stX', and
>> another series of events for 'nstX'. Udev will treat each of these events
>> separately, with distinct worker programs handling them. Each of those
>> workers run fully asynchronous and cannot access information from other
>> workers.
>
> 	So whats wrong with the simple solution? You throw the ones for st away, and
> create the st handles from the nst worker.

Doesn't seem to be any good solutions to this
problem. If you can't discovery something without
modifying its state, then what? For udev and/or
sg_inq to know about the special relationship
between st<i> nodes and nst<i> nodes seems
unreasonable IMO.

The cleanest way I can think of is for the st driver to
show this relationship via sysfs. But then why should
udev going mining for that relationship? A sysfs flag
from the st driver indicating a node is "undiscoverable"
might be a start.

A possible hack inside the st driver is to notice that
only the SG_IO ioctl is called on a file handle
between st_open(/dev/st*, O_RDONLY|O_NONBLOCK) and
st_release() then not auto-rewind it.

BTW Recent versions of sg_inq in Linux use
open(<dev>, O_RDONLY|O_NONBLOCK) unless 'sg_inq --block=1'
is given in which case open(<dev>, O_RDONLY) is used.


I just noticed that when scsi_debug makes a tape device,
the st driver silently ignores it, probably because
scsi_debug doesn't support a SSC command that st expects it
to respond to. IMO the st driver should make some noise if
it ever ignores a SCSI device with a PDT of 1 (i.e. a tape).

For example:
# lsscsi -g
[0:0:0:0]    disk    ATA      INTEL SSDSC2CW12 400i  /dev/sda   /dev/sg0
[8:0:0:0]    tape    Linux    scsi_debug       0004  -          /dev/sg1

with the st module loaded and no indication in dmesg.

Doug Gilbert
