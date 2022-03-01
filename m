Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D80FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 20:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiCAUck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 15:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiCAUbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 15:31:42 -0500
X-Greylist: delayed 395 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 12:28:39 PST
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7698DB10A9;
        Tue,  1 Mar 2022 12:28:38 -0800 (PST)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id A610B61700;
        Tue,  1 Mar 2022 20:21:59 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id 9FCCA3F6AA;
        Tue,  1 Mar 2022 20:21:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id VKqcY77sAcE3; Tue,  1 Mar 2022 20:21:59 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id EFA7E3F6A5;
        Tue,  1 Mar 2022 20:21:58 +0000 (UTC)
Message-ID: <d098d626-6b69-1129-5574-860e41b6ac21@interlog.com>
Date:   Tue, 1 Mar 2022 15:21:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: dgilbert@interlog.com
Content-Language: en-CA
To:     SCSI development list <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] smartmontools version 7.3 released
Cc:     Christian Franke <Christian.Franke@t-online.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smartmontools is approaching its 20th anniversary. It fetches SMART and
related (meta) information from ATA, SCSI and NVMe storage devices.
To that list I could add SCSI Tape drives support (e.g. TapeAlert).

smartmontools comprises of two utilities:
   - smartd: designed to run as a daemon, periodically checking disks,
     reporting issues to the log and sending emails if configured
   - smartctl: command line utility for probing disks and reporting
     on what it finds

By default smartctl provides its output in human readable form. This is
not ideal for GUI programs that wrap smartctl (e.g. GSmarctControl).
To address this issue, the --json option, added in an earlier release,
has been extended.

The release announcement is here:
      https://www.smartmontools.org/

Since it is maintained by older hackers (original meaning) we prefer
to use subversion for source code control. However for the git
generation it is mirrored at:
    https://github.com/smartmontools/smartmontools
and other locations.

For detailed release information see:
     https://www.smartmontools.org/browser/tags/RELEASE_7_3/smartmontools/NEWS

or the ChangeLog at the same location.


As an example of its flexibility smartctl can "speak" NVMe to a M2 module
inside a USB-C attached small enclosure. Linux sees that as a SCSI device
but smartctl, with an option like --device=sntjmicron gets the SMART data
in native NVMe. That option is needed because no-one has yet standardized
a SNTL (SCSI to NVMe Translation Layer). In this case the Jmicron chip in
the M2 enclosure has done the job  ***.

Douglas Gilbert

*** via clever misuse of the SCSI ATA PASS THROUGH command
