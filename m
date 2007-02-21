From: Srdjan Todorovic <todorovic.s@googlemail.com>
Subject: initio.h header user confusion
Date: Wed, 21 Feb 2007 16:12:06 +0000 (GMT)
Message-ID: <Pine.LNX.4.63.0702211558220.5167@thor.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:22404 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161297AbXBUQLM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 11:11:12 -0500
Received: by nf-out-0910.google.com with SMTP id o25so245257nfa
        for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 08:11:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm working on a set of patches for the initio scsi driver and I found
some strangeness with its header file, initio.h. I noticed that
sun3_scsi.c and sun3_scsi_vme.c include the header, and it uses defines
such as SCSI_ABORT_SNOOZE (defined in initio.h).

I did some grepping and am now confused. Grepping the entire kernel tree
like so:

  grep -r SCSI_ABORT_ ~/kernelcoding/linux-2.6-rc-latest/*

gives me a handful of scsi drivers that use these defines.

Grepping the kernel source for these defines like so:

   grep -r SCSI_ABORT_ ~/kernelcoding/linux-2.6-rc-latest/* | grep define

only gives me drivers/scsi/initio.h, so they are only defined in
initio.h

Grepping the whole kernel source for drivers/headers that include
initio.h like so:
   grep -r "initio.h" ~/kernelcoding/linux-2.6-rc-latest/*

only gives me 3 results - initio.c, sun3_scsi.c and sun3_scsi_vme.c.

So how is it possible that other drivers such as aha1542.c use these defines?

Can anyone please explain this as it's really confused me, and I want
to make sure that my patches don't break other drivers when I post
them here.

Many thanks,

Srdjan
