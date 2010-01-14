From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Thu, 14 Jan 2010 11:12:22 GMT
Message-ID: <201001141112.o0EBCMeL017653@demeter.kernel.org>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55567 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab0ANLMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 06:12:23 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0EBCMSL017654
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 11:12:22 GMT
In-Reply-To: <bug-15007-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007





--- Comment #3 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-01-14 11:12:21 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Thu, 14 Jan 2010 10:54:44 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=15007
> 
> 
> 
> 
> 
> --- Comment #2 from nick cheng <nick.cheng@areca.com.tw>  2010-01-14 10:54:42 ---
> Thanks for reply.
> I am sure that hardware and firmware can handle 1024 scatter gather
> entries.
> I can not limit the AP to dispatch a write command with 128 sg entries.
> I just execute mkfs.ext3 /dev/sdX and print it out as the sg entry number is
> 128. I found the 128th entry indeed has no data.

So 'no data sg entry' is the cause of hardware reset?

>From a quick look at the driver, I found one bug about scatter-gather
handling.

static int arcmsr_build_ccb(struct AdapterControlBlock *acb,struct
CommandControlBlock *ccb,struct scsi_cmnd *pcmd)
{
(snip)...
                    arccdbsize += sizeof(struct SG32ENTRY);
                }else{
                    struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;

                    pdma_sg->addresshigh = address_hi;
                    pdma_sg->address = address_lo;
                    pdma_sg->length = length|cpu_to_le32(IS_SG64_ADDR);
                    psge += sizeof(struct SG64ENTRY);
                    arccdbsize += sizeof(struct SG64ENTRY);
                }
                sl++;

The last line doesn't work. Use sl = sg_next(sl); Using
scsi_for_each_sg() is even better (as the driver in mainline
does). With this bug, 129th sg entry is broken. If your analysis is
correct, there should be other bugs..

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
