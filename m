From: Ric Wheeler <rwheeler@redhat.com>
Subject: mpt2sas logged messages
Date: Tue, 18 Aug 2009 09:18:30 -0400
Message-ID: <4A8AAA26.9090706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804AbZHRNQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 09:16:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Cc: Tom Coughlan <coughlan@redhat.com>


We have a new toy to test very large & slow storage with built up from 5 
SAS expansion shelves (Promise Vtrak J-Class) with 60 S-ATA drives and 
16 SAS drives (the S-ATA drives each have a Promise Vtrak S-ATA MUX 
adapter daughter card in the disk sled).

The basic idea is to build a cheap & slow test bed for file & storage 
system scalability. Collectively, we have about 120TB (raw) of capacity 
to play with in one server.

As we work through various issues, a couple of oddities popped out.

The first is that udev grumbles during boot about "file name too long" 
like the following:

Aug 17 06:49:58 megadeth udevd-event[20447]: unable to create db file 
'/dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:04.0\x2f0000:17:00.0\x2f0000:18:0a.0\x2f0000:1f:00.0\x2fhost11\x2fport-11:0\x2fexpander-11:0\x2fport-11:0:0\x2fexpander-11:1\x2fport-11:1:0\x2fexpander-11:2\x2fport-11:2:17\x2fexpander-11:3\x2fport-11:3:1\x2fend_device-11:3:1\x2fbsg\x2fend_device-11:3:1': 
File name too long

The second is that the mpt2sas driver spews various messages like:

Aug 17 06:55:17 megadeth kernel: mpt2sas0: log_info(0x31120102): 
originator(PL), code(0x12), sub_code(0x0102)

Any insight into whether these are issues worth pursuing is appreciated, 
thanks!

Ric


