From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas: Remove queuecommand wrapper
Date: Tue, 5 Jul 2011 20:25:43 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157E70F4A@inbmail01.lsi.com>
References: <20110704192713.GZ4061@linux.intel.com>
 <B2FD678A64EAAD45B089B123FDFC3ED70157FE25D8@inbmail01.lsi.com>,<20110705141434.GB389@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:55550 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145Ab1GEOzu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jul 2011 10:55:50 -0400
In-Reply-To: <20110705141434.GB389@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthew Wilcox <willy@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>



________________________________________
From: Matthew Wilcox [matthew@wil.cx]
Sent: Tuesday, July 05, 2011 10:14 AM
To: Desai, Kashyap
Cc: Matthew Wilcox; linux-scsi@vger.kernel.org; DL-MPT Fusion Linux
Subject: Re: [PATCH] mpt2sas: Remove queuecommand wrapper

On Tue, Jul 05, 2011 at 10:16:25AM +0530, Desai, Kashyap wrote:
> Matthew, I am fine with the patch, but just wanted to double check we do have included  changes related to below conversation.
> Mpt2sas and mptsas driver wants IRQ and preemption disable when it enter in to qcmd callback.
>
> http://140.211.166.79/mailarchive/linux-scsi/2010/12/23/6887919

The piece I believe you're referring to:

YES. ! That is my concern..

> I have gone through another round of code walkthrough (for mpt2sas and mptfusion) to \
> find out dependency w.r.t new host lock less mode. In my opinion, w/ interrupts \
> disable is a good ideal. (Earlier, I mentioned that mpt2sas is safe even if \
> interrupts are enabled)  In real scenario, *preemption* disable is more IMP for \
> mpt2sas/mptfusion driver than interrupts disable.

> e.a if scsih_qcmd_xxx has executed half of the code and (due to preemption is not \
> disable for the same CPU), Scheduler can execute any other process on the SAME cpu \
> (Though IRQ is disable). Consider Error handling is kicked off on the same CPU and as \
> part of EH, it executed HBA reset. As part of HBA reset Driver has return back all \
> pending Scsi command to mid-layer, and once control come back to original \
> scsih_qcmd_xxx LLD drive will see bad results (Kernel crash/Data corruption/h/w hung \
> or anything critical.....)

I don't believe this scenario can happen.  Error handling will not
commence until all commands are returned to the midlayer, which requires
that queuecommand is no longer running.

I was able to see this scenario when I intially started doing code review. Since host_lock is removed Error handling can remove code from queuecommand anytime ( I asssume preemption is not disable, only IRQ is disable).. I am almost sure if we are planning to remove host_lock from SML, we at least need irq and preemption disable for mpt2sas and mptfusion to work properly.

I am not sure we have done those changes in SML ? 



--
Matthew Wilcox                          Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."