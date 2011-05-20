From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Remove 32-bit versions of readq()/writeq()
Date: Fri, 20 May 2011 13:44:54 +0200
Message-ID: <20110520114454.GD14745@elte.hu>
References: <20110519181500.GF6139@elte.hu>
 <1305849293-25437-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:40601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab1ETLpO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2011 07:45:14 -0400
Content-Disposition: inline
In-Reply-To: <1305849293-25437-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Milton Miller <miltonm@bga.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Hitoshi Mitake <h.mitake@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, Len Brown <lenb@kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Matthew Garrett <mjg@redhat.com>


* Roland Dreier <roland@kernel.org> wrote:

> From: Roland Dreier <roland@purestorage.com>
> 
> The presense of a writeq() implementation on 32-bit x86 that splits
> the 64-bit write into two 32-bit writes turns out to break the mpt2sas
> driver (and in general is risky for drivers as was discussed in
> <http://lkml.kernel.org/r/adaab6c1h7c.fsf@cisco.com>).  To fix this,
> revert 2c5643b1c5c7 ("x86: provide readq()/writeq() on 32-bit too")
> and follow-on cleanups.
> 
> This unfortunately leads to pushing non-atomic definitions of readq()
> and write() to various x86-only drivers that in the mean time started
> using the definitions in the x86 version of <asm/io.h>.  However as
> discussed exhaustively, this is actually the right thing to do,
> because the right way to split a 64-bit transaction is hardware
> dependent and therefore belongs in the hardware driver (eg mpt2sas
> needs a spinlock to make sure no other accesses occur in between the
> two halves of the access).
> 
> Build tested on 32- and 64-bit x86 allmodconfig.
> 
> Link: http://lkml.kernel.org/r/x86-32-writeq-is-broken@mdm.bga.com
> Cc: Hitoshi Mitake <h.mitake@gmail.com>
> Cc: Kashyap Desai <Kashyap.Desai@lsi.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Ravi Anand <ravi.anand@qlogic.com>
> Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  arch/x86/Kconfig                 |    2 --
>  arch/x86/include/asm/io.h        |   24 ++----------------------
>  drivers/acpi/apei/einj.c         |    8 ++++++++
>  drivers/acpi/atomicio.c          |    4 ++++
>  drivers/edac/i3200_edac.c        |   13 +++++++++++++
>  drivers/platform/x86/ibm_rtl.c   |   13 +++++++++++++
>  drivers/platform/x86/intel_ips.c |   13 +++++++++++++
>  drivers/scsi/qla4xxx/ql4_nx.c    |   21 +++++++++++++++++++++
>  8 files changed, 74 insertions(+), 24 deletions(-)

Hm, this patch is wider than i thought - might be better to do this via one of 
the driver trees or -mm?

The x86 bits are:

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
