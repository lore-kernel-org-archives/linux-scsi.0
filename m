From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [LSF/MM TOPIC] Sparseness in storage
Date: Wed, 02 Feb 2011 12:07:23 -0500
Message-ID: <4D498F4B.3050207@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55660 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab1BBRHg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 12:07:36 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 1010E1037EE
	for <linux-scsi@vger.kernel.org>; Wed,  2 Feb 2011 18:07:34 +0100 (CET)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8c03k7Cr5J4a for <linux-scsi@vger.kernel.org>;
	Wed,  2 Feb 2011 18:07:29 +0100 (CET)
Received: from [192.168.48.66] (ip-89.51.99.216.dsl-cust.ca.inter.net [216.99.51.89])
	by smtp.infotech.no (Postfix) with ESMTPA id DA6361037EB
	for <linux-scsi@vger.kernel.org>; Wed,  2 Feb 2011 18:07:25 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

There are a lot of zeros out there. Efficient use of sparseness
involves techniques to detect large quantities of zeros in
advance rather than just reading them all. And on the write side
there are standard techniques to append zeros to a file without
actually writing them.

Seems a damn shame to read a terabyte of zeros and then write them
to another device or file. Carrying the idea further: if we know
random data has no meaning *** and we are asked to copy it,
why not "write" zeros to the output file?

Over the last few years various commands have been added to the
SCSI and ATA command sets to better handle sparseness (and
trim/unmap/write_same can be viewed in this light). File systems
are improving their sparseness handling as well, with Linux
playing "catch up" to NTFS in this regard (e.g. the new
FALLOC_FL_PUNCH_HOLE flag in fallocate() ).

So I am proposing a discussion of the:
   - existing SCSI commands to support sparseness
   - existing ATA commands to support sparseness
   - suggestions for more sparseness support to be
     added to the SCSI and ATA command sets
   - user space tools that support sparseness
   - file system support for sparseness

Perhaps the latter point should involve the file system track as
well.

Doug Gilbert
20100202


*** For example: after ATA CRYPTO SCRAMBLE EXT command (which
     is one of the "sanitize device" commands and is fast) the
     data read will be random and meaningless. If the disk does
     "read zero after trim" why not follow the scramble with a
     trim/unmap of the whole disk?
