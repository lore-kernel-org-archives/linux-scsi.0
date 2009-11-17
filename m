From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Tue, 17 Nov 2009 10:56:36 GMT
Message-ID: <200911171056.nAHAuapC012669@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42365 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZKQK4b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 05:56:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHAuafx012670
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2009 10:56:36 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #8 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-17 10:56:33 ---
I've recreated the problem in 2.6.30.3 with '#define DEBUG 1' in st.c.

Attached is the console log with a few annotations interspersed:
st-debug-2.6.30.3-mtblk0.txt.

The buffer sizes of 4096 and 516096 look most suspicious to me, as amanda uses
512kB (== 524288 bytes) blocks. I tried again with 'mt setblk 524288', but the
same result: EIO followed by BUG. The corresponding console log is attached as
st-debug-2.6.30.3-mtblk512k.txt.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
