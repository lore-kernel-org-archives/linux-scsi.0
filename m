From: Matthias Eble <psychotrahe@gmail.com>
Subject: Open/INQUIRY fails on RESERVE'd tape device
Date: Thu, 23 Jan 2014 23:02:57 +0100
Message-ID: <CAKbOo_KDVtCw1U7wD7L=aE-qug-3UwQQkDjuvyG2_xVEA8tnvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46154 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaAWWC7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2014 17:02:59 -0500
Received: by mail-lb0-f181.google.com with SMTP id z5so1909333lbh.26
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2014 14:02:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi list,

When a tape device is reserved with old reserve/release commands,
we see inquiry only works on the scsi generic device. For scsi tape devices
open() fails already:

# lsscsi -g | grep st15
[2:0:6:0]    tape    HP       Ultrium 5-SCSI   I5DZ  /dev/st15  /dev/sg17

# sg_vpd -vvv /dev/st15
  open /dev/st15 with flags=0x800
  error opening file: /dev/st15: Input/output error

# sg_vpd -vvv /dev/nst15
  open /dev/nst15 with flags=0x800
  error opening file: /dev/nst15: Input/output error

# sg_vpd -vvv /dev/sg17
open /dev/sg17 with flags=0x800
Supported VPD pages VPD page:
    inquiry cdb: 12 01 00 00 fc 00
      duration=2 ms
    inquiry: requested 252 bytes but got 22 bytes
   [PQual=0  Peripheral device type: tape]
  Supported VPD pages [sv]
  Unit serial number [sn]
  ...


So: should open() fail on a reserved tape device?
SPC2 states that INQUIRY should never conflict.
Or does that only apply to the generic device?
Okay, it doesn't conflict, but open fails. A SunOS st man page I found
states, INQUIRY shall be possible with reserved devices.

Of course the inquiry succeeds, after the reservation is being released.


Thanks in advance
Matthias
