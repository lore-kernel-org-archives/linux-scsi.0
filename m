From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Wed, 18 Nov 2009 18:18:00 +0900
Message-ID: <20091118181740H.fujita.tomonori@lab.ntt.co.jp>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
	<200911171056.nAHAuapC012669@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46528 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbZKRJSF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Nov 2009 04:18:05 -0500
In-Reply-To: <200911171056.nAHAuapC012669@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@jmbreuer.net

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
