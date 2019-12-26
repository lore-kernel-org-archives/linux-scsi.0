Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8010AC2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55DDF206CB
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5ZuHLCp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfLZRu7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 12:50:59 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36315 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfLZRu7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 12:50:59 -0500
Received: by mail-pf1-f196.google.com with SMTP id x184so13488564pfb.3;
        Thu, 26 Dec 2019 09:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Zpv7gMiVz+kvwZJc9LFUFQAnyOM81lFf+K9yvofQkYo=;
        b=F5ZuHLCp8nQcvsVAZguYSn+hKpqHCAH3uuekPnVyP4tqwXydkByKGGtKKJYMP+LoBi
         4a7qgdCAYnBgsWui85L2TfFMJ+iUG7yuglafVwwylH1HDaFV7LawwysiDDGslUIALg+E
         ow8pPkI6SYVfUqcVdvJEea7oQsJGwqOFF5nVhqzRUYJ4y02WuxD7cZxFO8WgOI6Qhwc0
         cnXu5UwippgMn1GSsc5P4qi9BT94LwCFhxbdV8qz90fiPtpX7up0vl8it44bAvoLiAYe
         QsKz9izLslZAXrayeJASemWfezXObqjG+Yrcu536fCNEnRSJOELpd1FbOqRAnW5DQEME
         bOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Zpv7gMiVz+kvwZJc9LFUFQAnyOM81lFf+K9yvofQkYo=;
        b=Uag/io5RH6A+PrUokVZ7obJzAzgy2ATcFAfM9zrP9FAb8JUPfmkjQf0BTABywr1W8f
         zHGWRx/6qXZo0uLg0SZnnyXproXAFHZgUP1q36W/vLhrJRxECRvZh9fMRXLII35HLWZA
         L/hGIoWJpPbf2isMYZcxylZVPgFD6hPTpE0RYm3zc9SrBbpVTbo4aQiceo0NEf4aOY2i
         RVOC7YiGOx0rRHCrTtEEfjsiu0GkwW0GaoFFR4VL32aa6lB1saUBFPPI1mL4ZfdMNl3Q
         Ol+KTuqQscBuGR/RHZ3Dwj9tLRmyCnFC894JMOZIkslBbgE/3QFRLLIqTN2OeoxePBgW
         D52Q==
X-Gm-Message-State: APjAAAU60zzG8RX1fh3cZQUnnINiZS8akIxSw7UVLNG6tGjOOwtTsujD
        09qQrvgIcWnm81NWA9HjfEdMVU60
X-Google-Smtp-Source: APXvYqwUsLBbciwsv7n6kUuYxxN1BeLJx7s78VVQnWHuOTVoV0KWR1d1UgGRJDZb7Gk7nQDKuUUWyg==
X-Received: by 2002:aa7:8699:: with SMTP id d25mr49735799pfo.139.1577382658330;
        Thu, 26 Dec 2019 09:50:58 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o7sm39389043pfg.138.2019.12.26.09.50.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Dec 2019 09:50:57 -0800 (PST)
From:   Guenter Roeck <linux@roeck-us.net>
To:     linux-hwmon@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFT PATCH v3 0/1] Summary: hwmon driver disk and solid state drives with temperature sensors
Date:   Thu, 26 Dec 2019 09:50:50 -0800
Message-Id: <20191226175051.31664-1-linux@roeck-us.net>
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

The driver does not currently report temperatures for SCSI drives. This
will be added with a subsequent patch.

---
v3: Rename satatemp -> drivetemp
    Use cached VPD page 89 data (available with v5.5 and later kernels)
    Relax ATA drive detection; still check if inquiry data is
    present, but don't use it for access detection.
    Modify VPD data analysis following guidance from Martin K. Petersen
    Separate SATA drive detection into separate function
    Marked as RFT. Martin K. Petersen reports:
    "I get a crash in the driver core during probe if the drivetemp module
     is loaded prior to loading ahci or a SCSI HBA driver. This crash is
     unrelated to my changes. Haven't had time to debug."
    This will require further testing before the patch is applied.

v2: scsi_cmd variable is no longer static
    Fixed drive name in Kconfig 
    Describe heuristics used to select SCT or SMART in commit message
    Added Reviewed-by: from Linus Walleij

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
