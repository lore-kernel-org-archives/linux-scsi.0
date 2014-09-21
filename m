From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: SCSI test tool for linux (and others)
Date: Sun, 21 Sep 2014 08:58:49 -0700
Message-ID: <CAN05THQ9Z0sMgJ5gFZhLBP9JH+pmFYNVBr0KrgCCYF9=haFKbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:62363 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaIUP6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Sep 2014 11:58:51 -0400
Received: by mail-la0-f46.google.com with SMTP id q1so4958579lam.33
        for <linux-scsi@vger.kernel.org>; Sun, 21 Sep 2014 08:58:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

List,

I have recently converted my iscsi based test suite to allow running
it against /dev/sg* devices in addition to iscsi targets.

The purpose here is to create a tool that can be used by vendors to
test that their device will be well supported by the Linux SCSI stack.
To have a tool that you can
send to vendors and ask that "please run these tests, if you pass you
have higher
probability to interoperate well with us".

In order to do this I added a new "Family" of tests to my tool, which
I called LINUX.
The tests in this tool are divided up in Families/Suites/Testarea and you/we/I
can add whatever tests we need or want to the LINUX family.

For example, while T10 does not require that you MUST put a proper
SPC/SBC standard in the inquiry standards page/version descriptions I
can't really add such tests to the SCSI family since that would imply
compliance to the T10 specs.
But adding such a test to the LINUX family is perfectly fine.


./test-tool/iscsi-test-cu --list | grep LINUX

will list all the tests in the Linux family.
For now I populated it with a bunch of tests I copied fro the SCSI family.
Some, not all, tests.
Missing are a whole bunch of tests that require that you have multiple
I_T nexuses,
such as all the persistent reservation tests, which would be difficult
to implement on /dev/sg* devices. (all users of a specific /dev/sg*
device ends up on the same nexus, right, the nexus for kernel<->device
?)

To run all the Linux tests you can do :
   sudo ./test-tool/iscsi-test-cu /dev/sg2 --test LINUX.*.* --usb -V

To just run the Read10 suite, you can do
   sudo ./test-tool/iscsi-test-cu /dev/sg2 --test LINUX.Read10.* --usb -V

etc etc.

The --usb flag is used to tell the test suite that we use a USB device and thus
we need to clamp any I/O to <= 120kbyte.
(Which is a restriction of the USB transport in Linux, and which also
is a restriction that is DIFFICULT to discover automagically due to
lack of a proper ioctl() to discover this. I will send you a patch to
add such an ioctl at some stage, but for now you will have to live
with : use --usb if the device is usb attached.)


-V is to get extra verbose output. This makes the tool print every
scsi cdb it sends and what it expects. This makes it easier to see
what the tool does but the output gets pretty busy so drop -V if you
want.


When things fail, it is reasonably easy to see why.
This is an example of a device that does not respect the RDPROTECT
field in the READ CDBs.
...
Suite: Read10
  Test: ReadProtect ...
    Test READ10 with non-zero RDPROTECT
    Device does not support/use protection information. All commands
should fail.
...
    Send READ10 (Expecting CHECK_CONDITION) LBA:0 blocks:1 rdprotect:7
dpo:0 fua:0 fua_nv:0 group:0
    [FAILED] READ10 successful but should have failed with
ILLEGAL_REQUEST(0x05)/INVALID_FIELD_IN_CDB(0x2400)
FAILED
...
--Run Summary: Type      Total     Ran  Passed  Failed
               suites        1       1     n/a       0
               tests         1       1       0       1
               asserts       7       7       0       7
Tests completed with return value: 0

Lots of low end devices have a lot more interesting failures, but I am
lazy and don't feel like looking for an example right now.
However, if you plan to start using the VERIFY10/12/16 commands at some stage,
lots of low end devices always return SUCCESS even when you know there
is a miscompare there :-)  So beware :-)


What now then?
==============
LINUX.*.* currently runs some >150 different suites/tests and hundreds
of thousands of individual checks/asserts.
For most USB devices most of these tests will be automatically skipped
since they don't support much of the more interesting opcodes, like
OrWrite, CompareAndWrite or WriteSame10/16. So all those tests are
automagically [SKIPPED].

It may be that you don't want/need many of these tests and then I can
drop them from the LINUX tests. But they will do no harm either other
than distract from more
important issues.

Right now, I would like feedback and users to use this tool.
I am also very interested in starting a dialogue with you guys, if you
think this is worthwhile,  to find test cases for things that cause
you pain and you would like to see in a Linux "compliance" test suite.

Anything you want to test I can try to add.
At some stage later we could then end up with a tool you guys can send
to the vendors and ask them "run this, pass the tests,  and linux scsi
guys gives two thumbs up".





To install:
========
The main repository is here :
https://github.com/sahlberg/libiscsi

I had to export some extra symbols from the library to do the /dev/sg*
support so you need to build and 'sudo make install' the library.


The /dev/sg* support itself is currently in a separate branch for this
project, so :
git checkout sgio
make

and that should build the tool.


regards
ronnie sahlberg
