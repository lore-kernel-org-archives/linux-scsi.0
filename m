From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Possible bug in fusion mpt ip support
Date: Wed, 17 Dec 2003 13:35:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071664538.1370.14.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp4.tin.it ([212.216.176.224]:34443 "EHLO vsmtp4.tin.it")
	by vger.kernel.org with ESMTP id S264391AbTLQMfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2003 07:35:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, emoore@lsil.com, lstephen@lsil.com

Hello,

I have two computers:

cala    IP 10.0.1.1  HW 00:E0:8B:02:96:DC  HBA qlogic 2200
server  IP 10.0.1.10 HW 00:E0:3C:D0:12:89  HBA lsi logic 40909

I cannot make them communicate.

Route hardware etc. is all ok.

I used tcpdump utility to debug.

When I do ping from cala to server I obtain:

on cala:

13:26:35.801540 arp who-has 10.0.1.10 tell 10.0.1.1
                         0001 0800 0604 0001 00e0 8b02 96dc 0a00
                         0101 0000 0000 0000 0a00 010a
13:26:36.800519 arp who-has 10.0.1.10 tell 10.0.1.1
                         0001 0800 0604 0001 00e0 8b02 96dc 0a00
                         0101 0000 0000 0000 0a00 010a
13:26:37.800288 arp who-has 10.0.1.10 tell 10.0.1.1
                         0001 0800 0604 0001 00e0 8b02 96dc 0a00
                         0101 0000 0000 0000 0a00 010a
13:26:38.903212 arp who-has 10.0.1.10 tell 10.0.1.1
                         0001 0800 0604 0001 00e0 8b02 96dc 0a00
                         0101 0000 0000 0000 0a00 010a

on server:

13:20:02.037848 21:0:0:e0:8b:2 Broadcast 52:
                         96dc aaaa 0300 0000 0806 0001 0800 0604
                         0001 00e0 8b02 96dc 0a00 0101 0000 0000
                         0000 0a00 010a
13:20:02.037899 3c:d0:12:89:aa:aa 8b:2:96:dc:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0002 00e0
                         3cd0 1289 0a00 010a 00e0 8b02 96dc 0a00
                         0101
13:20:03.036611 21:0:0:e0:8b:2 Broadcast 52:
                         96dc aaaa 0300 0000 0806 0001 0800 0604
                         0001 00e0 8b02 96dc 0a00 0101 0000 0000
                         0000 0a00 010a
13:20:03.036656 3c:d0:12:89:aa:aa 8b:2:96:dc:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0002 00e0
                         3cd0 1289 0a00 010a 00e0 8b02 96dc 0a00
                         0101
13:20:04.036242 21:0:0:e0:8b:2 Broadcast 52:
                         96dc aaaa 0300 0000 0806 0001 0800 0604
                         0001 00e0 8b02 96dc 0a00 0101 0000 0000
                         0000 0a00 010a
13:20:04.036284 3c:d0:12:89:aa:aa 8b:2:96:dc:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0002 00e0
                         3cd0 1289 0a00 010a 00e0 8b02 96dc 0a00
                         0101

This shows that cala do not start to send ping packets because it cannot
resolve arp.
On server it seems that hardware addresses are mangled.

When I do ping from server to cala I obtain:

on cala:

NOTHING AT ALL

on server:

13:22:39.355118 3c:d0:12:89:aa:aa ff:ff:ff:ff:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0001 00e0
                         3cd0 1289 0a00 010a 0000 0000 0000 0a00
                         0101
13:22:40.353542 3c:d0:12:89:aa:aa ff:ff:ff:ff:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0001 00e0
                         3cd0 1289 0a00 010a 0000 0000 0000 0a00
                         0101
13:22:41.353547 3c:d0:12:89:aa:aa ff:ff:ff:ff:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0001 00e0
                         3cd0 1289 0a00 010a 0000 0000 0000 0a00
                         0101
13:22:42.357615 3c:d0:12:89:aa:aa ff:ff:ff:ff:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0001 00e0
                         3cd0 1289 0a00 010a 0000 0000 0000 0a00
                         0101
13:22:43.356049 3c:d0:12:89:aa:aa ff:ff:ff:ff:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0001 00e0
                         3cd0 1289 0a00 010a 0000 0000 0000 0a00
                         0101
13:22:44.356044 3c:d0:12:89:aa:aa ff:ff:ff:ff:0:e0 48:
                         0300 0000 0806 0006 0800 0604 0001 00e0
                         3cd0 1289 0a00 010a 0000 0000 0000 0a00
                         0101

So it seems that cala arp info is sent good.
Because cala do not receive anything it seems that is fusion mpt that
mangles hw addresses so the destination of packets is not cala anymore.


Please help me!

Thanks in advance for interest!

-- 
Mario Giammarco

