Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED94C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 17:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FB961075
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 17:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhKKRFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 12:05:37 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:52715 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbhKKRFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 12:05:36 -0500
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 08A162EA1B3;
        Thu, 11 Nov 2021 12:02:47 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id GCTPuOKQKJdA; Thu, 11 Nov 2021 12:02:40 -0500 (EST)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 17A122EA475;
        Thu, 11 Nov 2021 12:02:40 -0500 (EST)
Reply-To: dgilbert@interlog.com
To:     SCSI development list <linux-scsi@vger.kernel.org>
Cc:     =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
        Martin Pitt <mpitt@debian.org>, Hannes Reinecke <hare@suse.de>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>,
        Martin Wilck <mwilck@suse.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.47 available
Message-ID: <d872a3ae-48f2-9431-a16f-8fe976ae89f1@interlog.com>
Date:   Thu, 11 Nov 2021 12:02:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending SCSI commands
to storage devices. In some contexts it can send ATA and/or NVMe commands.
The package targets the Linux 5, 4, 3, 2.6 and 2.4 kernel series. It has
ports to FreeBSD, Android, Solaris, and Windows (cygwin and MinGW). There
is now a dummy port for unsupported OSes (e.g. NetBSD) which will permit
decoding of some SCSI command responses via the --inhex=FN option.

For an overview of sg3_utils and downloads see either of these pages:
     https://sg.danny.cz/sg/sg3_utils.html
     https://doug-gilbert.github.io/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     https://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     https://sg.danny.cz/sg/p/sg3_utils.ChangeLog
     https://doug-gilbert.github.io/p/sg3_utils.ChangeLog
This github mirror needs to be updated:
     https://github.com/hreinecke/sg3_utils
Plus the author's own github mirror:
     https://github.com/doug-gilbert/sg3_utils

That last mirror is up-to-date and has git tags going back to "r1.20"
which is sg3_utils 1.20 released 15 years ago.


Here is the top of that ChangeLog, stopping at the previous release:

Changelog for released sg3_utils-1.47 [20211110] [svn: r919]
   - sg_rep_zones: add support for REPORT ZONE DOMAINS and
     REPORT REALMS in this utility
   - sg_raw: fix prints of NVMe NVM command names
   - sg_ses: fix Windows problem "No command (cdb) given"
     - fix crash when '-m LEN' < 252
     - guard against smaller '--maxlen=' values
   - sg_logs: additions to Volume statistics lpage [ssc5r05c]
     - additions to Command duration limits statistics log
       page [spc6r06]
   - sg_vpd: fix do_hex type on some recent pages
     - zoned block dev char vpd: add zone alignment mode and
       zone starting LBA granularity [zbc2r11]
   - sg_read_buffer: fix --length= problem
   - sg_dd, sgm_dd, sgp_dd: don't close negative file descriptors
   - sg_dd: srand48_r() and mrand48_r() are GNU libc specific,
     put conditional in so non-reentrant version used otherwise
     - 'iflag=00,ff' places the 32 bit block address (big endian)
       into each block
   - sgp_dd: major rework, fix issue with error being ignored
     - new: --chkaddr which checks for block address in each block
     - add check for stdatomic.h presence in configure.ac
   - sg_xcopy: tweak CSCD identification descriptor
   - sg_get_elem_status: fix issue with '--maxlen=' option
     - add 2 depopulation revocation health attributes [sbc5r01]
   - transport error handling improved. To fix report of a
     BAD_TARGET transport error but the utility still continued.
     - introduce SG_LIB_TRANSPORT_ERROR [35] exit status
   - several utilities: override '--maxlen=LEN' when LEN
     is < 16 (or 4), take default (or 4) instead
   - scripts: 55-scsi-sg3_id.rules remove outdated rule
   - sg_lib: add sg_scsi_status_is_good(),
     sg_scsi_status_is_bad() and sg_get_zone_type_str()
   - pt_linux: fix verify(BytChk=0) which Linux SNTL translated
     to write, other SNTL cleanups
   - pt_linux_nvme: fix fua setting
   - pt: check_pt_file_handle() add return value of 5 for
     FreeBSD for nvme(cam)
   - pt: new configure option --enable-pt_dummy builds the
     library with sg_pt_dummy.c instead of OS specific code;
     for experimenting with --inhex= decoding on netbsd
   - pt: add Haiku OS support
   - gcc -fanalyzer fixes: in sg_pt_linux.c + sg_write_x.c
   - sg_pt_dummy.c: add list of functions that a new pt
     needs to define
   - configure.ac: tweak to accept uclinux as linux
   - move some hex files from examples to inhex directory
   - major rework of lib/sg_pt_freebsd.c; make SNTL as similar
     as practical to the Linux implementation
   - add testing/sg_take_snap
   - change links to http://sg.danny/cz/sg/* to https

Changelog for released sg3_utils-1.46 [20210329] [svn: r891]
...


Doug Gilbert
