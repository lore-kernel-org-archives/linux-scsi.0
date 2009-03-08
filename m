From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: export bsg.h header to user-mode
Date: Sun, 08 Mar 2009 12:05:25 +0200
Message-ID: <49B39865.3060106@panasas.com>
References: <496E11D6.20705@panasas.com> <49B2A2E5.9050802@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:22333 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751319AbZCHKHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2009 06:07:30 -0400
In-Reply-To: <49B2A2E5.9050802@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, open-osd mailing-list <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> Boaz Harrosh wrote:
>> Hi TOMO.
>>
>> I'm using bsg.ko to submit SG_IO version-4 commands to scsi devices
>> from user-mode application. (version-4 for use of bidi and varlen).
>>
>> I have not found a bsg.h header in my fedora-10 distribution. Is
>> bsg.h exported in kernel-headers-package in latest Kernels? If not
>> should we, and how to do it?
>>
>> Meanwhile I will manually copy it to /usr/include/linux/bsg.h and see
>> if I need to fix any thing so it can be compiled from user-mode.
>>
>> Also do you have a small libbsg or something to make it easier for
>> use by application? should we maintain such a package?
>>
>> Pete from the OSC osd project has his set of headers and library
>> which I used now. Should I clean it up and send it? Or should I just 
>> keep it as part of the osd project for now? what are the sas and fc
>> guys using?
> 
> I have been trying to incorporate bsg support into sg3_utils
> and need to cope with the /usr/include/linux/bsg.h header being
> present or not. It may be present elsewhere (e.g.
> /lib/modules/<kernel_version>/build/include/linux/bsg.h ).
> Either way bsg.h is still a pain in the user space. The reason
> is the kernel's (non standard) "__int" types.
> 
> An autotools rule like this to see if linux/bsg.h is present:
>     AC_CHECK_HEADERS(linux/bsg.h)
> creates a lot of noise because it claims bsg.h is not well
> formed. The reason is those "__int" types. The solution is to
> add this non obvious rule:
>     AC_CHECK_HEADERS([linux/types.h linux/bsg.h], [], [],
>       [[#ifdef HAVE_LINUX_TYPES_H
>       # include <linux/types.h>
>       #endif
>       ]])
> 
> So my suggestion is to add '#include <linux/types.h>' to bsg.h
> (or clean up the types).
> 

I agree, bsg.h is missing the '#include <linux/types.h>'.
Do you want to send a patch? I thought 'make check_headers' should warn
about that.

> Doug Gilbert
> 

Have you noticed that we added linux/bsg.h to exported headers
for 2.6.29 and stable?

Thanks
Boaz
 
