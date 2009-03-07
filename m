From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: export bsg.h header to user-mode
Date: Sat, 07 Mar 2009 11:37:57 -0500
Message-ID: <49B2A2E5.9050802@interlog.com>
References: <496E11D6.20705@panasas.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41161 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZCGQiG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2009 11:38:06 -0500
In-Reply-To: <496E11D6.20705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, open-osd mailing-list <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> Hi TOMO.
> 
> I'm using bsg.ko to submit SG_IO version-4 commands to scsi devices
> from user-mode application. (version-4 for use of bidi and varlen).
> 
> I have not found a bsg.h header in my fedora-10 distribution. Is
> bsg.h exported in kernel-headers-package in latest Kernels? If not
> should we, and how to do it?
> 
> Meanwhile I will manually copy it to /usr/include/linux/bsg.h and see
> if I need to fix any thing so it can be compiled from user-mode.
> 
> Also do you have a small libbsg or something to make it easier for
> use by application? should we maintain such a package?
> 
> Pete from the OSC osd project has his set of headers and library
> which I used now. Should I clean it up and send it? Or should I just 
> keep it as part of the osd project for now? what are the sas and fc
> guys using?

I have been trying to incorporate bsg support into sg3_utils
and need to cope with the /usr/include/linux/bsg.h header being
present or not. It may be present elsewhere (e.g.
/lib/modules/<kernel_version>/build/include/linux/bsg.h ).
Either way bsg.h is still a pain in the user space. The reason
is the kernel's (non standard) "__int" types.

An autotools rule like this to see if linux/bsg.h is present:
    AC_CHECK_HEADERS(linux/bsg.h)
creates a lot of noise because it claims bsg.h is not well
formed. The reason is those "__int" types. The solution is to
add this non obvious rule:
    AC_CHECK_HEADERS([linux/types.h linux/bsg.h], [], [],
      [[#ifdef HAVE_LINUX_TYPES_H
      # include <linux/types.h>
      #endif
      ]])

So my suggestion is to add '#include <linux/types.h>' to bsg.h
(or clean up the types).

Doug Gilbert

