From: Mikhail Yakshin <greycat@altlinux.org>
Subject: Einarc - unified hardware RAID management
Date: Sun, 25 Nov 2007 03:54:07 +0300
Message-ID: <4748C7AF.80102@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scirus.benran.ru ([83.149.196.70]:1287 "EHLO scirus.benran.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbXKYBP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Nov 2007 20:15:56 -0500
Received: from greycat.house28.ru (localhost.localdomain [127.0.0.1])
	by scirus.benran.ru (Postfix) with ESMTP id B749468D40
	for <linux-scsi@vger.kernel.org>; Sun, 25 Nov 2007 03:54:09 +0300 (MSK)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings,

Not so far ago, I've faced a problem of accessing and managing multiple 
hardware RAIDs in Linux. That is, there are multiple servers with 
various controllers that I need to:

1. Manage RAID arrays (create / change attributes / delete / add 
physical discs, etc)
2. Monitor these arrays

Given that I wasn't dealing with RAIDs before (started about a year 
ago), it came to great surprise to me that hardware RAIDs lack any 
standardization at all. Generally, only thing they're supposed to do is 
providing SCSI discs and there's absolutely no way to know what this 
logical disc consists of, create it, monitor it, etc, without 
proprietary controller utilities supplied by a vendor. These utilities 
are generally a mess: each one has it's own interface, switches, CLI 
language, etc, and even concepts differ (for example, LSI deals with 
physical-logical drives, Areca deals with physical-raidsets-volumesets).

After a bit of intricate search, I've only found 2 references to this 
problem:

1. Proprietary ManageEngine OpStor product that costs a fortune, is 
licensed per-device and doesn't seem to fulfill my needs 100%.

2. OpenBSD's initiative named "bioctl" that generally seems to implement 
such a unified management interface, but it development seems to be 
stalled. It only supports older versions of LSI MegaRAID controller they 
call "ami" and

So, I've came to an idea that I should try to implement such interface 
myself. It was implemented as Einarc project, now hosted at

http://www.inquisitor.ru/doc/einarc/

The concept seems to have succeeded and I've already using it in 2 
production projects. It works by downloading all these proprietary 
controller CLIs and then it just translates calls and data from 
proprietary data model to unified one and back, for example:

einarc -t areca adapter info

gets translated into

/usr/local/lib/areca/cli sys info

Sadly, I don't have access to any possible controller at the market and 
it only supports a limited number of current hardware controllers 
(Areca, older LSI, newer LSI, Adaptec). I'd like to ask several things:

1. Are there any existing implementations of such thing I've missed?
2. Are there any RAID/storage controllers around that don't fit into 
Einarc's current object scheme? What needs to be extended/fixed?
3. Anyone needs support for more hardware contollers in Einarc? Would it 
be useful?
4. Any known open-source methods to access these hardware controllers 
without translating queries to proprietary CLIs? I guess, at least old 
MegaRAID queries can be ported from OpenBSD bioctl?

-- 
WBR, Mikhail Yakshin AKA GreyCat
