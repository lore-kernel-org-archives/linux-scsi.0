From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20072] tapeinfo reports MaxBlock: 16777215  but writes with
 blocksize >2M fail
Date: Wed, 13 Oct 2010 09:50:28 GMT
Message-ID: <201010130950.o9D9oSY0018761@demeter1.kernel.org>
References: <bug-20072-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56912 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0JMJua (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2010 05:50:30 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o9D9oSto018762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2010 09:50:28 GMT
In-Reply-To: <bug-20072-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20072





--- Comment #2 from lkolbe@techfak.uni-bielefeld.de  2010-10-11 11:25:15 ---
This is what dmesg has to say about the earlier tries to write to the device
with higher than 2MiB blocksizes:

[92315.076956] st0: Block limits 1 - 16777215 bytes.
[92445.438048] st0: Can't allocate 15728640 byte tape buffer.
[92457.973733] st0: Can't allocate 16777215 byte tape buffer.
[92460.990589] st0: Can't allocate 16777214 byte tape buffer.

--- Comment #3 from lkolbe@techfak.uni-bielefeld.de  2010-10-13 09:50:22 ---
When instructing bacula to use the advertised tape blocksize of 16M, we get the
following errors everytime it tries to access the tape:

13-Oct 11:48 sd1.techfak JobId 2692: Error: block.c:1002 Read error on fd=5 at
file:blk 0:0 on device "drv2" (/dev/nst0). ERR=Cannot allocate memory.

Is there some limit/sysctl we might have to adapt to the native tape drive
blocksize of 16M?

regards,
Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
