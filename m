From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: regression: 2.6.9-rc2 (BK) tape error causes amanda to hang?
Date: Fri, 17 Sep 2004 10:36:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3y8j98f7d.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:25042 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S268534AbUIQIg1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 04:36:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id E1B503ECBA
	for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2004 10:36:26 +0200 (CEST)
Received: from mail.dt.e-technik.uni-dortmund.de ([127.0.0.1])
 by localhost (krusty [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 20697-05-3 for <linux-scsi@vger.kernel.org>;
 Fri, 17 Sep 2004 10:36:26 +0200 (CEST)
Received: from m2a2.dyndns.org (pD9FFB518.dip.t-dialin.net [217.255.181.24])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 9876A3EAFD
	for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2004 10:36:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by merlin.emma.line.org (Postfix) with ESMTP id C87DCCD85E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2004 10:36:22 +0200 (CEST)
Received: from merlin.emma.line.org ([127.0.0.1])
 by localhost (m2a2.dyndns.org [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 09368-03 for <linux-scsi@vger.kernel.org>;
 Fri, 17 Sep 2004 10:36:22 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

on Wednesday night (2100 UTC), I was missing my Amanda backup log I
should have received by mail around 1400 UTC.

I checked and amanda had two taper processes (the usual set) hung, and
checked dmesg to find that the tape drive had failed to write a block,
reporting Media Error/Excessive write errors. 

In SuSE's default 2.6.5+susehacks kernel and in vanilla 2.6.7, errors
are propagated properly back to the application, amanda logs the write
error, mails the report and quits. With 2.6.9-rc2, nothing like that,
the tapers just hung. Is there some return missing? The kernel was
compiled late on Sept 13 (UTC).

Relevant hardware:
* Asus A7V600-X PC mobo (VIA chipset), AMD Athlon XP Barton, 1/2 GB RAM
* Tekram DC-390F (UWSCSI adaptor based on SYMBIOS 53C875)
* Tandberg TDC4222 ("SLR 4 DC") firmware =07:28CREATED073196

(Other stuff on the bus is a Plextor PX-32TS 1.02, a Fujitsu MAH-3182MP
0114 and a Tandberg SLR6 "SLR 24" 0404D.)

I know I should exchange the broken tape and have spare cartridges in
the cupboard but I have seen so many quirks in Linux post-2.6.7 that
I'll leave the broken tape in the cycle so we can test possible fixes...

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
