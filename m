From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi_debug: Fix endianess in partition table
Date: Wed, 13 Feb 2013 16:16:31 +0100
Message-ID: <1360768591.6893.17.camel@br8ggx07.de.ibm.com>
References: <1360604094.24863.1.camel@br8ggx07.de.ibm.com>
	 <1360659837.11990.9.camel@br8ggx07.de.ibm.com>
	 <511A5589.1060709@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:54686 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544Ab3BMPSE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 10:18:04 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Wed, 13 Feb 2013 08:18:03 -0700
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 68DF1C901BA
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2013 10:17:07 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r1DFH71f28573822
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2013 10:17:07 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r1DFH6ir029772
	for <linux-scsi@vger.kernel.org>; Wed, 13 Feb 2013 10:17:06 -0500
In-Reply-To: <511A5589.1060709@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2013-02-12 at 09:45 -0500, Douglas Gilbert wrote:
> However since SCSI is big endian and you are introducing
> some "le" code then a line or so of explanation (comments)
> in your revised patch might be helpful.

I would argue that the definition of struct partition itself should be
sufficient explanation. Only scsi_debug failed to assign values in a
correct manner. 

> BTW Finding a big endian architecture to test this patch on is
> not easy.

No big deal ;-) I can help out with test data from my System z (aka
s390x).


Without fix:

[root@zzzzzzzz ~]# xxd -l 512 /dev/sda
<snip>
00001b0: 0000 0000 0000 0000 0000 0000 0000 0001  ................
00001c0: 0100 8307 203f 0000 0020 0000 3fe0 0000  .... ?... ..?...
00001d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00001e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.


With fix:

[root@zzzzzzzz ~]# xxd -l 512 /dev/sda
<snip>
00001b0: 0000 0000 0000 0000 0000 0000 0000 0001  ................
00001c0: 0100 8307 203f 2000 0000 e03f 0000 0000  .... ? ....?....
00001d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00001e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.


Which makes it exactly look like the table seen on my laptop:

root@xxxxxxxx:~# xxd -l 512 /dev/sdb
<snip>
00001b0: 0000 0000 0000 0000 0000 0000 0000 0001  ................
00001c0: 0100 8307 203f 2000 0000 e03f 0000 0000  .... ? ....?....
00001d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00001e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.


Assuming:
modprobe scsi_debug physblk_exp=3 lowest_aligned=7 num_parts=1

