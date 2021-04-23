Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958CDC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 20:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A7A6613D8
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 20:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhDWUTc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 16:19:32 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:46380 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhDWUTb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 16:19:31 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 6C8322EA192;
        Fri, 23 Apr 2021 16:18:53 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id N-Woe15gkI2Y; Fri, 23 Apr 2021 15:58:58 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 9CEFA2EA176;
        Fri, 23 Apr 2021 16:18:52 -0400 (EDT)
Reply-To: dgilbert@interlog.com
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] ddpt, version 0.97 available
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
        Tomas Fasth <tomfa@debian.org>, Hannes Reinecke <hare@suse.de>,
        alexander Motin <mav@FreeBSD.org>
Message-ID: <372732b0-e8b9-e5db-d5d8-78cba93dbe62@interlog.com>
Date:   Fri, 23 Apr 2021 16:18:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ddpt is yet another variant of the venerable Unix dd command line utility.
It offers more precise control over a storage copy and can bypass upper
layers to use SCSI commands like READ, WRITE, WRITE AND VERIFY, WRITE
ATOMIC or offloaded copy mechanisms to move the data. ddpt supports the
Linux kernel 2.6, 3, 4 and 5 series with ports to FreeBSD, Solaris,
Android and Windows.

There is a little SNTL hiding in the sg3_utils library used by this
utility. That can now translate SCSI READ, WRITE and VERIFY(BytChk=1)
to NVM(e) Read, Write and Compare commands. Since NVMe doesn't have
separate pass-through device nodes, the default action of ddpt is to
treat a NVMe device node (e.g. /dev/nvme0n1) as a normal block device.
The 'pt' flag is needed on NVMe devices to use that SNTL. Note that
--verify only works when OFILE is a pt device; the cmp utility can be
used in other cases.


For more information and downloads see:
     https://sg.danny.cz/sg/ddpt.html   or
     https://doug-gilbert.github.io/ddpt.html
     https://sg.danny.cz/sg/ddpt_xcopy_odx.html

There is a github mirror (of my subversion repository) at:
     https://github.com/doug-gilbert/ddpt


Changelog for released ddpt-0.97 [20210421] [svn: r388]
   - ddpt: add cdl operand for command duration limits
   - ddpt: add oflag=nocreat and conv=nocreat that require
     OFILE to exist, it won't be created
   - ddpt: warn if disk has protection type 2 and cdbsz!=32
     has not been used (it is required according to SBC-4)
   - ddpt: cdbsz= operand can now take 2 comma-separated numbers
   - NVMe devices can now be accessed via iflag=pt or oflag=pt
     without those flags they will be accessed as block devices
   - now accept --progress or -p as shorter form of
     status=progress [borrowed from FreeBSD's dd]
   - fix progress reporting when OFILE is /dev/null
   - start using autoconf 2.70
   - point svn:externals to sg3_utils release 1.46 (rev 891)

Changelog for ddpt-0.96 [20200303] [svn: r375]
...


Doug Gilbert
