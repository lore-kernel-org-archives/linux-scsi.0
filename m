From: Douglas Gilbert <dougg@torque.net>
Subject: Re: scsi.h
Date: Fri, 23 May 2003 11:13:52 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECD75D0.6070107@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:42001 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262946AbTEWA7r
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 20:59:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, naviathan@yahoo.com
Cc: linux-kernel@vger.kernel.org

Jeremy Buseman wrote on lkml:
 > Summary:  When compiling cdrtools with 2.5.69-bk13
 > scsi.h causes errors at line 229 and 230.

That is the "u8" typedef that I tried to change to
something a little saner a while back.

Do we have any volunteers to discuss this matter with
Joerg Schilling? Even if he changes his next release,
he can't do much about the earlier releases.

As mentioned in the "RFC: move hosts.h and scsi.c" thread
started by Jeff Garzik on the lsml, some existing apps
(cdrecord/cdrtools and perhaps SANE) assume that the headers
in /usr/src/linux/include/scsi can be included safely in
their low level transports.
This was true but is no longer in the lk 2.5 series.

An ugly transition header included at the top of that
"scsi.h" could address this problem but my guess is some
will dislike this idea:

/* deprecated, this transition header will be removed in lk 2.8 */
#ifndef __KERNEL__
#define u8 int8_t
#define __user
....
#endif


Playing both sides of this debate, I recently added "__user"
qualifiers in sg.h (not yet released).

Doug Gilbert

