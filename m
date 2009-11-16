From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bug 14563] New: SCSI tape driver: Spurious EIO and kernel
 OOPS
Date: Mon, 16 Nov 2009 21:19:18 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0911162109350.17241@kai.makisara.local>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:46844 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbZKPT1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 14:27:18 -0500
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Mon, 9 Nov 2009, bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14563
,,,
> Overview:
> 
> Performing tape backups using amanda 2.6.0-p2 [using 512kB block size] leads to
> spurious 'EIO' errors when writing to the tape; most of the time a kernel BUG
> is hit shortly thereafter.
> 

Can you try this with debugging enabled in st? (Edit st.c to
'#define DEBUG 1' and recompile the module.) This might give more 
information about the source of the EIO and the code path it uses.

...
> Amanda should correctly write to tape during backup as it does using kernels <=
> 2.6.27.10.
> 
> 
> Affected versions:
> 
> The oldest kernel I tried which DOES exhibit the problem is 2.6.29.4; other
> kernels exhibiting this problem are 2.6.30.3 and 2.6.31.5.
> 

There were major changes to the code performing the SCSI commands at 
2.6.29. The changes were mostly done by Fujita Tomonori and I added him to 
the cc list.

Kai
