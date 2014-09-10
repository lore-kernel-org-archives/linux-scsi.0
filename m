From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 00/21] uas: rewrite error handling for robustness + misc cleanups
Date: Wed, 10 Sep 2014 13:46:30 +0200
Message-ID: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Greg, et al,

Since we've been receiving multiple bug reports with crashes / oopses related
to uas error handling, I've spend the last 7 days rewriting the error handling
code. This new code has been extensively tested, doing externally triggered
usb-device-resets and scsi bus resets while having multiple io streams
active. It has all seen some serious shakedown in my attempts to get the
ASM1051 to work, which would throw all kind of fun errors.

Without this series (and without the blacklist) connecting an ASM1051 device
causes a lockup 30 seconds after plug-in (so when the first scsi timeout
fires), with this series it goes into error handling (*) for ages before
finding the disk (and then some more with some disks), but it actually
works somewhat, and the system does not crash (nor oopses).

Greg, baring review turning up any issues, can you please queue this up for
3.18 ?

Thanks & Regards,

Hans


*) Because the ASM1051 chokes on report opcodes
