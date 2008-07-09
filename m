From: Jesper Krogh <jesper@krogh.cc>
Subject: Media autochanger driver changed behavior.
Date: Wed, 09 Jul 2008 22:51:05 +0200
Message-ID: <487524B9.7000203@krogh.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:56643 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbYGIUvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 16:51:07 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by shrek.krogh.cc (Postfix) with ESMTP id AE533197348
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2008 22:51:06 +0200 (CEST)
Received: from shrek.krogh.cc ([127.0.0.1])
	by localhost (shrek.krogh.cc [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A2gdf8W1WU4n for <linux-scsi@vger.kernel.org>;
	Wed,  9 Jul 2008 22:50:57 +0200 (CEST)
Received: from [192.168.1.8] (unknown [90.184.13.46])
	by shrek.krogh.cc (Postfix) with ESMTP id D75213BF4D5
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2008 22:50:56 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>

Hi.

Upgrading the OS from an quite old kernel to a newer (2.6.24) changed
the behavior of the "ch" driver. Now it does a inventory to the changer
on load. This command makes the barcode-reader scan the entire library
at driver load time.

This process takes around 7.5 minutes in my installations.

[  211.903066] ch0: type #1 (mt): 0x0+1 [medium transport]
[  211.903074] ch0: type #2 (st): 0x100+94 [storage]
[  211.903076] ch0: type #3 (ie): 0x500+6 [import/export]
[  211.903078] ch0: type #4 (dt): 0x80+2 [data transfer]
[  211.924873] ch0: dt 0x80: ID 2, LUN 0, name: HP       Ultrium 3-SCSI 
   G36Z
[  211.946835] ch0: dt 0x81: ID 2, LUN 0, name: HP       Ultrium 3-SCSI 
   G36Z
[  211.946844] ch0: INITIALIZE ELEMENT STATUS, may take some time ...
[  220.610904] eth0: no IPv6 routers present
[  270.903214] st: Version 20070203, fixed bufsize 32768, s/g segs 256
[  270.903243] Driver 'st' needs updating - please use bus_type methods
[  519.926380] ch0: ... finished
[  519.926422] ch 5:0:0:0: Attached scsi changer ch0
[  519.924693] st 5:0:2:0: Attached scsi tape st0
[  519.924702] st 5:0:2:0: st0: try direct i/o: yes (alignment 512 B)
[  519.924818] st 6:0:2:0: Attached scsi tape st1
[  519.924821] st 6:0:2:0: st1: try direct i/o: yes (alignment 512 B)
[  519.942415] st1: Block limits 1 - 16777215 bytes.
[  520.368971] st0: Block limits 1 - 16777215 bytes.


Have I misconfigured something or has the default behavior of this
driver changed? (can I get the old one back)

Earlier the driver-load just took less than a few seconds for both st 
and ch.

Jesper
-- 
Jesper
