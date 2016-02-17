From: Tom Yan <tom.ty89@gmail.com>
Subject: ses: wrongly error out for Simple Subenclosures
Date: Wed, 17 Feb 2016 09:44:16 +0800
Message-ID: <CAGnHSEmX=8vcg4Os5GpS9CPXMxXA+ePwJVx9YdYymYQbGpmkcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33758 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbcBQBvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2016 20:51:09 -0500
Received: by mail-yw0-f178.google.com with SMTP id u200so2184824ywf.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Feb 2016 17:51:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a WD My Passport that has a SES device with it:

[tom@localhost ~]$ lsscsi -g
...
[7:0:0:0]    disk    WD       My Passport 083A 1065  /dev/sdc   /dev/sg3
[7:0:0:1]    enclosu WD       SES Device       1065  -          /dev/sg4

which is a Simple Subenclosure, as documented in SES-3 (Rev. 11a) Section 4.3.3.

Currently the kernel spam the following error for it:

scsi 7:0:0:1: Wrong diagnostic page; asked for 1 got 0
scsi 7:0:0:1: Failed to get diagnostic page 0xffffffea
scsi 7:0:0:1: Failed to bind enclosure -19

However, according to the the aforementioned documentation, Simple
Subenclosure is a device that does NOT support any SES diagnostic
page, except the Short Enclosure Status diagnostic page.

And my device is doing pretty much exactly the right thing:

[tom@localhost ~]$ sudo sg_ses /dev/sg4
  WD        SES Device        1065
Supported diagnostic pages:
  Supported Diagnostic Pages [sdp] [0x0]
  Short Enclosure Status (SES) [ses] [0x8]
  <unknown> [0x80]
  <unknown> [0x83]
  <unknown> [0x84]
  <unknown> [0x85]

[tom@localhost ~]$ sudo sg_ses -p 0x8 -vvv /dev/sg4
open /dev/sg4 with flags=0x802
    inquiry cdb: 12 00 00 00 24 00
      duration=0 ms
  WD        SES Device        1065
    enclosure services device
    Receive diagnostic results cmd for Short Enclosure Status (SES) page
    Receive diagnostic results cmd: 1c 01 08 ff fc 00
      duration=0 ms
    receive diagnostic results: pass-through requested 65532 bytes
(data-in) but got 4 bytes
    receive diagnostic results: response
08 00 00 00
Short enclosure status diagnostic page, status=0x0

The content of the Short Enclosure Status page (08 00 00 00) is
correct as documented in SES-3 (Rev. 11a) Section 6.1.11 too.
