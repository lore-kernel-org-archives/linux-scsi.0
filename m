Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285A3E81DF1
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 12:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjJFMy7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 08:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjJFMy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 08:54:58 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509DCD6;
        Fri,  6 Oct 2023 05:54:56 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9ad8a822508so402605666b.0;
        Fri, 06 Oct 2023 05:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696596895; x=1697201695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gecE+vOGFjARaQC/nlEr7rWoc3kbi1x64ECe3si5O9A=;
        b=YUTNZV0ZDZFg5hj6nfvgxV9ta43IFBVQvNHZM2Pb3zk5KXWSgHv4gfylS6Qf6DbcWy
         vk7Wl9sXQh/7mwxrGixlwA5g+ODP9MEQ0g31lj4nNOpo+k1sCNssJWBpLPVAgjyf048i
         nL1RXBWRYYrQnWAGIoKbT1bWH08BTw4a/D4s0JV7NeRRhwaHddIsq5leX4fNjsUJgrXc
         usDzGZ2i5aexRLf8XlVPhc3IaQ1GEC2ZxZmEGxVGVPTRCayjhzIPJE/mcofH/YzGX2Hv
         1+SxmpgvH5xqNyn0WN0z+5npgW2snvJ86+nGzaaYsdIu7ivUbiuO+RTaC4wMExgnRfH1
         Afwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696596895; x=1697201695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gecE+vOGFjARaQC/nlEr7rWoc3kbi1x64ECe3si5O9A=;
        b=ofXlhAqmVm0UySHyJPZJsJGUFMIiGFi0CO0bP1Th7xTkuc873LKqxDhKpIiryrD59B
         GeuFiOrkQ3WRT7Q6KcdeqEHizTjECOTyYK9JL3FUahgiFdtO6ld5EiXOSIcb7716/v82
         ClezAnacr3hdV8pt6+Dn2n7TnFuIkf3RcFFpuGnfVkG91yb5eHJ11hWopVlmAj5PRsk5
         9dVlwf+vYweU47Xd5V/RgJEps5loKtw/4mYXUfzSsqcUdp5WbcT4+nlPBg4rdn/m7U2L
         uE+uz9cmZNA3N+n/GeHUfTweWstOtihGaxgTqCBH31nYkKpOlhFDI03cyDWyk9GRpt9G
         2g0Q==
X-Gm-Message-State: AOJu0Yxjm46+L9bahak5SD4czhyuN/qqZzXp1dfsdhsvO31qXaTSAMGQ
        ep45hhUu7jSrzGcuJhDCVZp5gMTL3gv+qg==
X-Google-Smtp-Source: AGHT+IESjdKyA6s5OhJ7UTOKsi/fr9Zwv0a4+sM65k6PMfimI9UTYwlNKm7rSorMRoWRPGG+v7fOvA==
X-Received: by 2002:a17:906:1da1:b0:9ba:65e:752b with SMTP id u1-20020a1709061da100b009ba065e752bmr368474ejh.39.1696596894512;
        Fri, 06 Oct 2023 05:54:54 -0700 (PDT)
Received: from sauvignon.fi.muni.cz (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id p26-20020a1709060dda00b0099bc08862b6sm2894660eji.171.2023.10.06.05.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 05:54:53 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, stern@rowland.harvard.edu,
        oneukum@suse.com, jonathan.derrick@linux.dev,
        Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH 0/6] usb-storage,uas,scsi: Support OPAL commands on USB attached devices.
Date:   Fri,  6 Oct 2023 14:54:39 +0200
Message-ID: <20231006125445.122380-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset adds support for OPAL commands (self-encrypted drives)
through USB-attached storage (usb-storage and UAS drivers).

1) Patches 1-4 only add support for 64-bit quirks for USB storage
(unfortunately, USB device info can be 32-bit on 32-bit platforms,
and we are out of space for flags now).

2) Patches 5-6 enable OPAL commands on USB device and also adds
an ATA-12 pass-thru wrapper to support OPAL even on devices that
do not support SCSI SECURITY IN/OUT commands.
ATA-12 is already used by sedutils directly; this patch makes
internal kernel OPAL ioctl work with ATA-12 too.

As patch 6 introduced a new USB quirk that overflows 32-bit,
I posted all patches together - but logically, these solve two
separate issues.

More info

1) 64bit USB storage quirk flags

The quirks are transferred through the device info value, which
is unsigned long (and as a part of USB infrastructure, it cannot
be changed).
After discussion on USB list, I used high bit as an indicator
that the values need to be translated/unpacked to 64bit
(while lower values are used directly).

This is implemented through a host-compiled program that
generates device tables and translation function.
As both usb-storage and UAS drivers share a lot of headers and
definitions, we need to generate separate files for usb-storage,
UAS and flags translation function.

(I also tried to use a statically generated array for flags,
but this increased the size of drivers significantly, and
the code was quite ugly...)

2) Support for OPAL on USB attached storage.

The main support for OPAL on USB-attached storage is
straightforward. The patch 6
 - enables SCSI security flag for USB mass storage and UAS device
   by default.
 - adds an optional wrapper to the SCSI layer for the ATA-12
   pass-thru command as an alternative if SECURITY IN/OUT
   is unavailable.

During device detection, these steps are then done:
  1) USB driver (mass-storage, UAS) enables security driver flag
     by default if not disabled by quirk
  2) SCSI device enumerates SECURITY IN/OUT support. If detected,
     SECURITY ON/OUT wrapper is used (as in the current code).
     If not, the new ATA12 pass-thru wrapper is used instead.
  3) SED OPAL code tries OPAL discovery command for the device.
     If it receives correct reply, OPAL is enabled for the device.

Enabling support may uncover many issues, as OPAL-locked devices often
tend to generate errors on the locked range.

Anyway, cryptsetup will soon support OPAL devices, and I think support
for USB devices is a nice feature that enables users to unlock drives
even if they are attached through USB adapters.

But also, there are bugs in firmware, so I added a quirk flag that can
disable security commands for particular devices.

The last patch uses this quirk for Realtek 9210, which seems to support
OPAL commands, but after configuring OPAL locking range, it also sets
the write-protected flag for the whole device.
This is perhaps a bug in firmware (all versions I tried), and I will
report that later to Realtek.

Milan Broz (6):
  usb-storage: remove UNUSUAL_VENDOR_INTF macro
  usb-storage: make internal quirks flags 64bit
  usb-storage: use fflags index only in usb-storage driver
  usb-storage,uas: use host helper to generate driver info
  usb-storage,uas,scsi: allow to pass through security commands (OPAL)
  usb-storage,uas: Disable security commands (OPAL) for RT9210 chip
    family

 drivers/scsi/sd.c                   |  33 ++++-
 drivers/usb/storage/Makefile        |  25 ++++
 drivers/usb/storage/alauda.c        |   2 +-
 drivers/usb/storage/cypress_atacb.c |   2 +-
 drivers/usb/storage/datafab.c       |   2 +-
 drivers/usb/storage/ene_ub6250.c    |   2 +-
 drivers/usb/storage/freecom.c       |   2 +-
 drivers/usb/storage/isd200.c        |   2 +-
 drivers/usb/storage/jumpshot.c      |   2 +-
 drivers/usb/storage/karma.c         |   2 +-
 drivers/usb/storage/mkflags.c       | 212 ++++++++++++++++++++++++++++
 drivers/usb/storage/onetouch.c      |   2 +-
 drivers/usb/storage/realtek_cr.c    |   2 +-
 drivers/usb/storage/scsiglue.c      |   4 +
 drivers/usb/storage/sddr09.c        |   2 +-
 drivers/usb/storage/sddr55.c        |   2 +-
 drivers/usb/storage/shuttle_usbat.c |   2 +-
 drivers/usb/storage/uas-detect.h    |   4 +-
 drivers/usb/storage/uas.c           |  26 ++--
 drivers/usb/storage/unusual_devs.h  |  11 ++
 drivers/usb/storage/unusual_uas.h   |  11 ++
 drivers/usb/storage/usb.c           |  42 +++---
 drivers/usb/storage/usb.h           |   7 +-
 drivers/usb/storage/usual-tables.c  |  38 +----
 include/linux/usb_usual.h           |   2 +
 25 files changed, 346 insertions(+), 95 deletions(-)
 create mode 100644 drivers/usb/storage/mkflags.c

-- 
2.42.0

