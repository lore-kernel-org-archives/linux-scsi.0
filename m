From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage -
	pass	larger receive buffer
Date: 13 Nov 2003 17:55:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068771306.2851.42.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:19866 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261768AbTKNAzj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 19:55:39 -0500
In-Reply-To: <1068768796.3fb41e1c8d075@webmail.netregistry.net>
List-Id: linux-scsi@vger.kernel.org
To: dmitrik@users.sourceforge.net
Cc: linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org

> I don't have W2K. I tried to get a trace on XP, it didn't work. 
> USB Snoopy does not seem to work on XP. Let me know if you know 
> of a better tool. 

Myself?  No.  My friends, yes.  Just now I tried generic x 08 06 50 =
bInterfaceClass ...SubClass ...Protocol, specifically an Iomega Zip
drive with no disk.  Transcribing the trace by hand I may have seen:

1: -i x24 -y "12 00:00:00 24 00" // standard Inquiry

2: -i xFC -y "23 00 00:00:00:00 00 00:FC 00" // Read Format Cap
residue xFC
autosense: -i x12 -y "03 00:00:00 12 00"
sk asc = x 6 29 Reset

3: -i xFC -y "23 00 00:00:00:00 00 00:FC 00" // Read Format Cap
residue xE8

4: -i x24 -y "12 00:00:00 24 00" // standard Inquiry

5: -i xFC -y "25 00 00:00:00:00 00 00:00 00" // Read Capacity
residue x08
autosense: -i x12 -y "03 00:00:00 12 00"
sk asc = x 2 04 02 Please Start

6: -y "1B 00:00:00 01 00" // Start Unit

7: -y "00 00:00:00 00 00" // Test Unit Ready
autosense: -i x12 -y "03 00:00:00 12 00"
sk asc = x 2 3A Disc Absent

8: -i xFC -y "25 00 00:00:00:00 00 00:00 00" // Read Capacity
residue x08
autosense: -i x12 -y "03 00:00:00 12 00"
sk asc = x 2 3A Disc Absent

9: -i x200 -y "28 00 00:00:00:00 00 00:01 00" // Read Blocks
residue x200
autosense: -i x12 -y "03 00:00:00 12 00"
sk asc = x 2 3A Disc Absent

10: -i xC0 -y "1A 00:1C:00 C0 00" // Mode Sense (6)
autosense: -i x12 -y "03 00:00:00 12 00"
sk asc = x 5 24 CDB Unknown

11: -i xC0 -y "1A 00:3F:00 C0 00" // Mode Sense (6)
residue x7A

12: -o x18 -y "15 10:00:00 18 00" // Mode Select (6)
residue xA8

13: -i xFC -y "25 00 00:00:00:00 00 00:00 00" // Read Capacity
residue x08
autosense: -i x12 -y "03 00:00:00 12 00"
sk asc = x 2 3A Disc Absent
14: (same as 13)
15: (same as 13)

16: (same as 7)
17: (same as 7)

18: (same as 13)
19: (same as 13)
20: (same as 13)
21: (same as 13)
22: (same as 13)

23: (same as 7)
24: (same as 7)
25: (same as 7)

26: -i x0C -y "1A 00:00:00 0C 00" // Mode Sense (6)
27: (same as 26)

28: (same as 13)
29: (same as 7)
30: (same as 26)
31: (same as 13)
32: (same as 13)
33: (same as 7)

34: -i x0C -y "1A 00:3F:00 0C 00" // Mode Sense (6)

35: (same as 13)
36: (same as 13)
37: (same as 7)
38: (same as 26)
39: (same as 7)
40: (same as 26)
...


