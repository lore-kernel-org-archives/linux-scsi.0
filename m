Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03F0C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 21:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD2902072D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 21:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCSVK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 17:10:29 -0400
Received: from smtp.infotech.no ([82.134.31.41]:46462 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSVK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Mar 2020 17:10:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B3BD5204153
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2020 22:10:25 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jWFHN3gJH0Cw for <linux-scsi@vger.kernel.org>;
        Thu, 19 Mar 2020 22:10:20 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 6DB3420414B
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2020 22:10:20 +0100 (CET)
Reply-To: dgilbert@interlog.com
To:     SCSI development list <linux-scsi@vger.kernel.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] smp_utils-0.99 available
Message-ID: <53caf1f9-83ea-966f-9a0b-e7ec95b387b1@interlog.com>
Date:   Thu, 19 Mar 2020 17:10:19 -0400
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

smp_utils is a package of command line utilities for invoking SMP functions
to monitor and manage SAS expanders. SMP is the Serial Attached SCSI (SAS)
Serial Management Protocol. A SAS Host Bus Adapter (HBA) includes a SMP
initiator (along with SSP and STP initiators). A SAS expander contains a
SMP target. Most SAS HBAs have a SMP pass through interface that can be
used to send SMP requests and receive the responses. This package is
designed to work with the Linux kernel (lk) 2.6, 3, 4 and 5 series;
FreeBSD 9.0 (and later) and recent Solaris versions.

Three interfaces are available for Linux: "sgv4", "mptctl" and "aac".
The "sgv4" interface uses the bsg driver. The "aac" interface requires
a recent aacraid driver and firmware in the controller.

The SAS-4 standard is broken into two parts. The latest freely accessible
electrical and physical part is sas410b.pdf . The upper layers are found in
the "SAS Protocol Layer" (SPL) document: spl5r09.pdf . Both pdfs can
be found at https://www.t10.org/ .

These utilities should be SAS-4 ready. SAS-4's baud rate of 22.5 Gbps is
referred to as "G5" in SPL. Note that some SAS specific utilities required
for SAS management can be found in other packages. For example the sdparm
utility (package name: sdparm) lists SAS VPD pages (e.g. Protocol Specific
LU/Port pages) and accesses SAS mode pages (e.g. select wide port
connections with the "Shared Port Control" mode page). The sg_logs utility
in sg3_utils decodes several SAS specific log pages.

For an overview, examples and downloads of smp_utils see:
http://sg.danny.cz/sg/smp_utils.html


Changelog for smp_utils-0.99 [20200305] [svn: r171]
   - smp_discover(_list): add --dsn option to show
     device slot number in single line per phy summary
     - attached SAS device type, word SAS added (spl4r01)
     - add SAS connector types, shared with NVMe (ses3r8)
     - add buffered phy burst size field (spl4r07)
     - add attached apta capable field
     - update phy capabilities decode (spl5r02)
     - use Report general to get number phys rather
       than loop until an error occurs
   - smp_rep_general: add extended fairness field
     - add initial time to delay expander forward open
       indication field
     - add external port field (spl5r02)
   - smp_phy_test: change default linkrate from 3 to 6 Gbps
     which is value 0xa
   - smp_conf_phy_event: fix file pointer leak
   - add G5 (22.5 Gbps for SAS-4) settings [spl4r06]
   - convert many two valued ints to bools
   - smp_lib:
     - add smp_get_connector_type_str(), smp_get_num_nomult()
       and smp_get_llnum_nomult()
     - add dStrHexErr() and dStrHexStr()
     - add hex2stdout, hex2stderr and hex2str
     - add smp_is_big_endian(), smp_all_zeros() and
       smp_all_ffs()
     - add sg_unaligned.h and sg_pr2serr.h headers
     - change connector name: 'SAS SlimLine' to 'SlimSAS'
   - sync with spl5r08
   - cleanup configure.ac + Makefile.am
   - update BSD license from 3 to 2 clause aka FreeBSD
     license (without reference to FreeBSD project)
   - debian: bump compat file contents from 7 to 10

Changelog for smp_utils-0.98 [20140526] [svn:r138]
....


Doug Gilbert
