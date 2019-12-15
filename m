Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90F2C2D0CD
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 17:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 851A42467F
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 17:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPR1bcxP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfLORpc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 12:45:32 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38136 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfLORpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2019 12:45:32 -0500
Received: by mail-pg1-f194.google.com with SMTP id a33so2327573pgm.5;
        Sun, 15 Dec 2019 09:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Q2WwaFCyRQa/w8Apj3A/MtAf1w2f53OCqsqyZSE7hvI=;
        b=UPR1bcxPy9Vjxp9/EG7tvaBtkGYkH8V33DwNjpuuBrBYihO6kXOTNdFc7uu8WzNBJo
         iXzJa5jV5DOkYYrxDgU2Hxocxq2RPziX5w4ffiiclSOMXuE5dxkKJB5dYiCTpBkXKcAI
         uqXjz9c2kjSF7QUqT3NP8XZWsuEwq7ik0vVC/yfWpj29k9l0IyzcHeLh6LoSpqIHgeMG
         cYsyjgNnFgUUnCh2jOqjxusVM8fISB2k1s7znnzdCqgsBLM+92ij3mJwdmS2seNWd+JT
         P03JYYrdmS6dD3g+J3s4WGB6OFJd2WLBr0O/aFyGLmq/Bd/C+0DWI5LIwdKyLoQ2Yglw
         r1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Q2WwaFCyRQa/w8Apj3A/MtAf1w2f53OCqsqyZSE7hvI=;
        b=s/eUA99AhPQGkmgjF2tKkzbcXGGpqKwhg1+d69IALtkEakuqeE7txhs1PKIbEwB43r
         OiU6nQojk+VkSEA7jYS2KSE8eZ6O2Fms2F+zIk4B1SAWSyiS/WPmuHEwCC5JFFDAvp4M
         lOxCBtwCaQ9zzqjlz1qVV2vhTXfF1IBhudpeny0VwaC087cOd9aLnzz+W+BeMSEmJ9MU
         n4y86QTiUjhy64GkgpabhX0V2cSsTJA2zdXYO6bwHQcKLHK3ThQ/WU7IZ1VXef5JoMwD
         RL5vbQavricPg7h7ebtnZu48XUqPg4dBEByG78kVJ1e7RUpXxJnva6pFzWLCztsjviql
         KWag==
X-Gm-Message-State: APjAAAUWmghPVQC0QikWKfFoNbK0NCPgVJZ05iAgXfO47chMPjHKC0ua
        OEdKqzHHMxrsoW2Ke9EgL0gJjk7R
X-Google-Smtp-Source: APXvYqxFiGWefbEIVcCYPhTCh7gewfvdKWTZpN6PJaI72C82uKc+6+kT+IXgGZB8J1d7lmkA1bTqhw==
X-Received: by 2002:a63:4503:: with SMTP id s3mr13240195pga.311.1576431930324;
        Sun, 15 Dec 2019 09:45:30 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3sm19335361pfg.94.2019.12.15.09.45.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Dec 2019 09:45:29 -0800 (PST)
From:   Guenter Roeck <linux@roeck-us.net>
To:     linux-hwmon@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 0/1] Summary: hwmon driver for temperature sensors on SATA drives
Date:   Sun, 15 Dec 2019 09:45:08 -0800
Message-Id: <20191215174509.1847-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the past, several attempts have been made to add support for reporting
SCSI/[S]ATA drive temperatures to the Linux kernel. This is desirable to
have a means to report drive temperatures to userspace without root
privileges and in a standard format, but also to be able to tie reported
temperatures with the thermal subsystem.

The most recent attempt was [1] by Linus Walleij. It went through a total
of seven iterations. At the end, it was rejected for a number of reasons;
see the provided link for details. This implementation resides in the
SCSI core. It originally resided in libata but was moved to SCSI per
maintainer request, where it was ultimately rejected.

The feedback on this approach suggests to use the SCSI Temperature log page
[0x0d] as means to access drive temperature information. It is unknown
if this is implemented in any real SCSI drive. The feedback also suggests to
obtain temperature from ATA drives, convert it into the SCSI temperature log
page in libata-scsi, and to use that information in a hardware monitoring
driver. The format and method to do this is documented in [3]. This is not
currently implemented in the Linux kernel.

An earlier submission of a driver to report SCSI/SATA drive temperatures
was made back in 2009 by Constantin Baranov [2]. This submission resides
in the hardware monitoring subsystem. It does not rely on changes in the
SCSI subsystem or in libata-scsi. Instead, it registers itself with the
SCSI subsystem using scsi_register_interface(). It was rejected primarily
because it executes ATA passthrough commands without verification that it
is actually connected to an ATA drive.

Both submissions use SMART attributes to read drive temperature information.
[1] also tries to identify temperature limits from those attributes.
Unfortunately, SMART attributes are not well defined, resulting in relative
complex code trying to identify the exact format of the reported data.

With the available information and feedback, we can make a number of
observations and conclusions.
a) Using available (S)ATA drive temperature information and convert it to
   a SCSI log page is an interesting idea. On the downside, it would add a
   substantial amount of complexity to libata-scsi. The code would either
   have to be optional, or it would have to be built into the kernel even
   if it is never used on a given system. Without access to SCSI drives
   supporting this feature, it would be all but impossible to test the code
   against such a drive. It would neither be possible to test correctness
   of the code in libata-scsi nor in the driver using that information.
   Overall it would be much easier and much less risky to implement such
   code on the receiving side (ie in a driver reporting the temperatures)
   instead of trying to convert the information from one format to another
   first. In summary, it is neither practical nor feasible. On top of that,
   there is no guarantee that code implementing this functionality would
   ever be accepted into the kernel for this very reason.
b) The code needed to read and analyze SCSI temperature log pages is quite
   complex (see smartmontools [5]). There is no existing support code
   in the Linux kernel; such code would have to be written. This makes
   the approach discussed in a) even more risky and less practical.
c) Overall, any attempt to report temperature information for anything
   but SATA drives in the kernel is not practical due to the complexity
   involved, and due to the inability to test the resulting code with
   non-SATA drives.
d) Using SMART data for anything but basic temperature reporting is not
   really feasible due to the lack of standardization. Any attempt to do
   this would add a substantial amount of code, ambiguity, and risk.

This submission implements a driver to report the temperature of SATA
drives through the hardware monitoring subsystem. It is implemented as
stand-alone driver in the hardware monitoring subsystem. The driver uses
the mechanism from submission [1] to register with the SCSI subsystem.
By using this mechanism, changes in the SCSI or ATA subsystems are not
required.  To reduce risk and complexity, it only instantiates after
reliably validating that it is connected to a SATA drive. It does not
attempt to report the temperature of non-SATA drives.

The driver uses the SCT Command Transport feature set as specified in
ATA8-ACS [4] to read and report the temperature as well as temperature
limits and lowest/highest temperature information (if available) for
SATA drives. If a drive does not support SCT Command Transport, the driver
attempts to access a limited set of well known SMART attributes to read
the drive temperature. In that case, only the current drive temperature
is reported.

---
v2: scsi_cmd variable is no longer static
    Fixed drive name in Kconfig 
    Describe heuristics used to select SCT or SMART in commit message
    Added Reviewed-by: from Linus Walleij

Note:
    I thought about waiting for more feedback, but maybe improvements
    can be made with follow-up patches.

---
References:
[1] https://patchwork.kernel.org/patch/10688021/
[2] https://lore.kernel.org/lkml/20090913040104.ab1d0b69.const@mimas.ru/
[3] http://www.t10.org/cgi-bin/ac.pl?t=f&f=sat5r02.pdf
    Information technology - SCSI / ATA Translation - 5 (SAT-5),
    section 10.3.8 (Temperature log page).
[4] http://www.t13.org/documents/uploadeddocuments/docs2008/d1699r6a-ata8-acs.pdf
    ANS T13/1699-D "Information technology - AT Attachment 8 - ATA/ATAPI Command
    Set (ATA8-ACS)"
[5] https://github.com/mirror/smartmontools.git
