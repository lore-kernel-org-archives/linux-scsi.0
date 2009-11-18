From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Wed, 18 Nov 2009 09:18:06 GMT
Message-ID: <200911180918.nAI9I6oT009154@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49692 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbZKRJSA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 04:18:00 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAI9I61W009155
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 09:18:06 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #11 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-11-18 09:18:05 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Tue, 17 Nov 2009 10:56:36 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14563
> 
> 
> 
> 
> 
> --- Comment #8 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-17 10:56:33 ---
> I've recreated the problem in 2.6.30.3 with '#define DEBUG 1' in st.c.
> 
> Attached is the console log with a few annotations interspersed:
> st-debug-2.6.30.3-mtblk0.txt.

Thanks for the logs.

> The buffer sizes of 4096 and 516096 look most suspicious to me, as amanda uses
> 512kB (== 524288 bytes) blocks.

Can you get the log with a working kernel (2.6.27?) and '#define DEBUG
1' in st.c? Then we could see what are different with the same
commands.


> I tried again with 'mt setblk 524288', but the
> same result: EIO followed by BUG. The corresponding console log is attached as
> st-debug-2.6.30.3-mtblk512k.txt.

Looks like that the kernel crashes in both logs right after dio
transfer? What happens with the kernel module parameter 'try_rdio = 0
try_wdio=0'?

Thanks,

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
