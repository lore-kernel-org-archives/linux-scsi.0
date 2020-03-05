Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914A3C3F2D2
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 21:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE2A2072A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 21:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgCEV7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 16:59:40 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47669 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgCEV7k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 16:59:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4117C204190;
        Thu,  5 Mar 2020 22:59:38 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dyK+nvyoYSSa; Thu,  5 Mar 2020 22:59:31 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id EC84120417C;
        Thu,  5 Mar 2020 22:59:30 +0100 (CET)
Reply-To: dgilbert@interlog.com
To:     SCSI development list <linux-scsi@vger.kernel.org>
Cc:     Tomas Fasth <tomfa@debian.org>,
        David Sommerseth <davids@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        alexander Motin <mav@FreeBSD.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] ddpt, version 0.96 available
Message-ID: <d9bc3710-68b3-6628-3de4-912283742937@interlog.com>
Date:   Thu, 5 Mar 2020 16:59:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ddpt is yet another variant of the venerable Unix dd command
line utility. It offers more precise control over a storage
copy and can bypass upper layers to use SCSI commands like READ,
WRITE, WRITE AND VERIFY, WRITE ATOMIC or offloaded copy
mechanisms to move the data. ddpt supports the Linux kernel
2.6, 3, 4 and 5 series with ports to FreeBSD, Solaris,
Android and Windows.

Significant new features are generalizing the skip= and seek=
operands to take scatter gather lists and the --verify option
to compare rather than copy IFILE and OFILE.


For more information and downloads see:
     http://sg.danny.cz/sg/ddpt.html
     http://sg.danny.cz/sg/ddpt_xcopy_odx.html

There is a github mirror (of my subversion repository) at:
     https://github.com/doug-gilbert/ddpt


Changelog for ddpt-0.96 [20200303] [svn: r375]
   - allow scatter gather lists for skip= and seek= where they can
     reasonably be implemented
   - add status=progress option, report every 2 minutes
     -add status=sgl option to print internal sgls
   - add --dry-run, --flexible and --quiet options
   - add iflag=00 and iflag=ff for fill bytes
   - add oflag=wstream for WRITE STREAM(16) on OFILE, STR_ID provided
     by list_id=LID operand
   - require job file to contain 'ddpt' argument as sanity check:`
     either 'ddpt=<version_number>' or 'ddpt=r<revision_number>'
   - add ddpt_sgl utility for list manipulations
   - add support for Receive copy status(lid4) command
   - add prefer_rcs flag and conversion for xcopy(odx)
   - add support for locally assigned UUIDs in VPD page 0x83 (spc5r08)
   - third party (extended) copy: add support for "point in time -
     copy on write" type RODs, spc5r20
   - add 'delta' throughput calculation (e.g. since previous report
     with status=progress)
   - add testing directory and scripts
     - prepare.sh to test ddpt
     - test_sgl.sh to test ddpt_sgl
   - add --verify option to change from doing WRITE(OFILE) to doing
     VERIFY(OFILE,BYTCHK=1)
   - add --prefetch option to add PRE-FETCH(OFILE,IMMED) command to
     the --verify seqeunce of commands
   - change oflag=verify to oflag=wverify to distinguish it from the
     new --verify option
   - improve device designator descriptor handling
   - resubmit IOs if EAGAIN, report count at completion if > 0
   - fix SCSI recovered errors stopping copy
   - align pass-through buffers to page boundaries
   - fix reading fifo (stdin) and writing to regular file
   - rework pr2serr() handling
   - use sg_pt::set_scsi_pt_packet_id() with ascending counter, helps
     debugging (mainly Linux)
   - improve xcopy(odx) error reporting
   - point svn:externals to rev 843 of sg3_utils (version 1.45)
   - convert many two valued 'int's to bool
   - upgrade automake to version 1.15 (U16.04)
     - cleanup configure.ac + Makefile.am
   - update BSD license from 3 to 2 clause aka FreeBSD
     license (without reference to FreeBSD project)
   - debian: bump compat file contents from 7 to 10

Changelog for ddpt-0.95 [20141226] [svn: r307]
...


Doug Gilbert

