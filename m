Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9124C3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 21:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60A620870
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 21:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgCEVm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 16:42:58 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47601 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgCEVm6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 16:42:58 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1E740204190;
        Thu,  5 Mar 2020 22:42:55 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mobywGpSBefm; Thu,  5 Mar 2020 22:42:48 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id E74B320417C;
        Thu,  5 Mar 2020 22:42:47 +0100 (CET)
To:     SCSI development list <linux-scsi@vger.kernel.org>
Reply-To: dgilbert@interlog.com
Cc:     Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>,
        David Sommerseth <davids@redhat.com>,
        Hannes Reinecke <hare@suse.de>, delphij@delphij.net
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] sdparm 1.10 available
Message-ID: <afdc68bc-3deb-6434-1eec-3570fc6fe64c@interlog.com>
Date:   Thu, 5 Mar 2020 16:42:46 -0500
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

sdparm is a command line utility designed to get and set SCSI device
parameters (cf hdparm for ATA disks). The parameters are held in
mode pages. Apart from SCSI devices (e.g. disks, tapes and enclosures)
sdparm can be used on any device that uses a SCSI command set. sdparm
also can decode VPD pages including the device identification page.
Commands to start and stop the media; load and unload removable media
and some other housekeeping functions are supported. sdparm supports
the Linux kernel 2.6, 3, 4 and 5 series with ports to FreeBSD, Solaris,
Android and Windows.

For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html

There is a github mirror (or my subversion repository) at:
     https://github.com/doug-gilbert/sdparm


ChangeLog for sdparm-1.11 [20200303] [svn: r334]
   - Allow ZBC mode pages to use existing SBC mpages
     as permitted by zbc2r04 chapter 6.4.1 table 70
   - add --out_mask=OM option for mode page control
     bitmask (current, changeable, default and/or saveable)
   - add --examine option to iterate over mode+vpd pages
   - add Out of band management control mpage (spl5r01)
   - expand SAS configure port mode page [0x19,0x2] with
     configure port mode fields (spl5r07)
   - accept additional transport acronyms (e.g. ib for srp)
   - power condition mpage: rename fields IDLE->IDLE_A;
     STANDBY->STANDBY_Z; ICT->IACT and SCT->SZCT
   - device configuration extension mpage: expand PEWS
     field with added PE_UN (PEWS units) field (ssc5r05)
   - add Zoned block device control mpage (zbc2r04a)
   - --defaults option can be used twice: reverts all
     pages to their defaults (new in spc5r11, RTD bit)
   - vpd: decode TransportIDs in SCSI port page
     - --all option used twice lists all VPD pages
     - decode SCSI Feature sets page (spc5r16)
     - extended inquiry data, sync with spc5r09 + sbc4r11
     - 3 party copy page improvements including
       Copy group identifier
     - block limits and block limit extension VPD pages:
       add extra info about corner cases
     - add maximum inquiry|mode_page change logs fields
       to extended inquiry vpd page (spc5r17)
     - fully implement Device constituents VPD page
   - command=capacity with --long force read capacity(16)
     with full reporting of response
   - --wscan option: expand bus type to include NVMe
   - mode page output with -HHH suitable for --inhex=
   - add flexible geometery page (obsolete) sbc2r00
   - point svn:externals to rev 843 of sg3_utils [v 1.45]
   - convert many two valued 'int's to bool
   - shellcheck corrections on scripts
   - upgrade automake to version 1.15 (U16.04)
   - rework configure.ac and src/Makefile.am
   - add --enable-debug to ./configure
   - update BSD license from 3 to 2 clause aka FreeBSD
     license (without reference to FreeBSD project)
   - debian: bump compat file contents from 7 to 10

ChangeLog for sdparm-1.10 [20160222] [svn: r279]
....


Doug Gilbert

