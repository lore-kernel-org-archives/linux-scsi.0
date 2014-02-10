From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCHv2] Add EVPD page 0x83 entries to sysfs
Date: Mon, 10 Feb 2014 12:06:45 -0600
Message-ID: <52F91535.4010905@tributary.com>
References: <1392030699-105348-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:58484 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaBJSGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 13:06:49 -0500
In-Reply-To: <1392030699-105348-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 2/10/2014 5:11 AM, Hannes Reinecke wrote:
> EVPD page 0x83 is used to uniquely identify the device. So instead of
> having each and every program issue a separate SG_IO call to retrieve this
> information it does make far more sense to display it in sysfs.

Tested-by: Jeremy Linton <jlinton@tributary.com>

	So, I just ran it in 3.14-rc2. No OOPS, that is good. It even survived
probing a SPC-2 device without a page 0x83.

I tested it with a fairly narrow set of devices, a couple IBM libraries with
LTO/359x and a VTL.

I did notice this on an old IBM raid adapter running in the machine

cat: ident_lun_scsi_name: Invalid argument

(that came from this device)
sg_inq --page=0x83 --hex /dev/sg2
VPD INQUIRY, page code=0x83:
 00     00 83 00 48 01 03 00 08  50 01 0b 90 00 12 1d 90    ...H....P.......
 10     61 93 00 08 50 01 0b 90  00 12 1d 8e 61 94 00 04    a...P.......a...
 20     00 00 00 01 61 a3 00 08  50 01 0b 90 00 12 1d 8d    ....a...P.......
 30     63 a8 00 18 6e 61 61 2e  35 30 30 31 30 42 39 30    c...naa.50010B90
 40     30 30 31 32 31 44 38 44  00 00 00 00                00121D8D....

And there may be a couple descriptors missing here and there. For example
3592E05 is missing the total port count (I think).

VPD INQUIRY, page code=0x83:
 00     01 83 00 5c 02 01 00 24  49 42 4d 20 20 20 20 20    ...\...$IBM
 10     30 33 35 39 32 45 30 35  20 20 20 20 20 20 20 20    03592E05
 20     30 30 30 30 30 37 38 33  36 33 32 33 01 03 00 08    000007836323....
 30     50 05 07 63 02 41 0c 2c  01 13 00 08 50 05 07 63    P..c.A.,....P..c
 40     02 81 0c 2c 01 14 00 04  00 00 00 02 01 23 00 08    ...,.........#..
 50     50 05 07 63 02 41 0c 2c  01 24 00 04 00 00 00 01    P..c.A.,.$......

/sys/class/scsi_tape/nst14/device # ls ident_*
ident_lun_naa  ident_lun_t10  ident_port_naa  ident_port_relport  ident_target_naa




This almost seems like a case where exporting the raw 0x83 data may be better...


Also, as I stated previously, my personal bias is to include the page 0x80
serial number data for tape devices as well. That seems to be the most
reliable. Mostly because a lot of the VTLs now just give you the same
wwnn/wwpn in 0x83 for multiple LUNs. Meaning you can't uniquely identify the
device over different physical ports.


The IBM devices are nice in that they export a T10 Vendor ID with the
man/model/serial in 0x83, but that is not common in my experience.

For example (old T10k)
VPD INQUIRY, page code=0x83:
 00     01 83 00 20 01 03 00 08  50 01 04 f0 00 93 ac f6    ... ....P.......
 10     01 13 00 08 50 01 04 f0  00 93 ac f7 01 14 00 04    ....P...........
 20     00 00 00 01                                         ....



