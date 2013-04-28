From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: SCSI testing/USB devices are amazing
Date: Sun, 28 Apr 2013 09:19:36 -0700
Message-ID: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58884 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3D1QTg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Apr 2013 12:19:36 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so2830882pdi.33
        for <linux-scsi@vger.kernel.org>; Sun, 28 Apr 2013 09:19:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi List,

Interested in SCSI tests?


I have a reasonable SCSI (mainly SBC) testsuite at
https://github.com/sahlberg/libiscsi
while I am mainly interested in testing of iSCSI targets, most of my
tests so far are for the SCSI protocol
so they work quite well on devices connected to any kind of transport,
as long as you re-export them via iSCSI.
(For example using a simple passthrough device with TGT.)
At some stage I will redo some of the framework so that it can
optionally talk directly to a /dev/sg* device, but reexporting via TGT
works well enough for now.


The test suite is fairly comprehensive for SBC so far, you can find a
list of all the current tests at
https://sites.google.com/site/libiscsitarballs/libiscsitarballs/

Based on hearing about the problems with USB devices, I added a
special family with the tests I think would be relevant to USB SBC
devices.

Oh boy, I thought soft iSCSI targets were bad...
USB seems like a completely new level of badness.
In testing some random sticks I had I found no usb stick actually
claiming SBC support in the standard inq page,  but one stick claimed
support for SSC !
Another stick never really reported LBA OUT OF RANGE and it just kept
wrapping the LBA once you wrote beyond the end of the stick.
I.e. write at LBA modulo size-of-stick.
Another one didnt supported VERIFY10 with bytchk set (whats the point
supporting VERIFY10 at all then?),   and if you sent too many VERIFY10
to it it would lock up completely.

Wow. And I thought iSCSI targets were bad.



I added changes to the tests so that IF a device claims SBC-3 support
then both READCAPACITY16 and READ16 are mandatory so the tests will
fail if the commands are missing. If SBC-3 is not claimed, I allow
these commands to fail and just skip that particular test.

To get an overview of what it tests so far for SCSI-USB-SBC  I have
pasted the output of
./bin/iscsi-test-cu iscsi://127.0.0.1/iqn.ronnie.test/3 --dataloss -V
--usb --test SCSI-USB-SBC
also at
https://sites.google.com/site/libiscsitarballs/libiscsitarballs/


I think this could be very useful for testing USB devices  and maybe
if you can get vendors to test their devices before release ?

I am very happy to add more tests for specific pain point you have
with devices but since I have little experience with USB devices
I would need your help to identify what I should add tests for.


So to sum it up:
* please have a look at the tests and the test results I linked to
above. I currently have quite a few tests but am happy to add more.
* do you think this is something you guys could find useful ?
* then if so, do you want to work with me to improve it so it tests
and flags the problem areas you find with usb (and other) devices ?


regards
ronnie sahlberg
