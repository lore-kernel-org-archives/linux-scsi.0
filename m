From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Subject: 2.6.28-rc6-tip fails to build with gcc 4.4.0
Date: Mon, 24 Nov 2008 16:28:13 +0200
Message-ID: <492AB9FD.5010602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:11000 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYKXO2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2008 09:28:19 -0500
Received: by gv-out-0910.google.com with SMTP id e6so316293gvc.37
        for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2008 06:28:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>

Hi,

Using gcc version 4.4.0 20081120 (experimental) [trunk revision 142055]
I can't build latest tip/master (commit
b27fef5b222564b6e7ae71f7110c233b2fb45a38)

drivers/built-in.o: In function `sd_revalidate_disk':
sd.c:(.text+0x8bc76): undefined reference to `____ilog2_NaN'
make: *** [.tmp_vmlinux1] Error 1

Apparently gcc determines that sector_size can have an invalid constant
value as ilog2's parameter in sd_read_capacity.

I tried to narrow down, but all I found so far is that gcc 4.4.0 now
says that __builtin_constant_p() is true even in these cases:

a = .. constant value ...
if (cond) {
     a = ... constant value ...
}
__builtin_constant_p(a) ? ....

a = .. constant value ...
if (cond) {
     a = ... constant value ...
} else {
   a = ... another constant value ...
}
__builtin_constant_p(a) ? ....

I guess it clones the __builtin_constant_p for each branch, where a is
constant, gcc 4.3 doesn't seem to do that.

Did it find a real bug in sd.c, or is it a gcc bug?

Best regards,
--Edwin
