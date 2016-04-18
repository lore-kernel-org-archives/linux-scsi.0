From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force inlining of some byteswap operations)
Date: Mon, 18 Apr 2016 16:07:51 +0200
Message-ID: <4545519.Kr6IHPvbv3@wuerfel>
References: <20160413151500.tate3u6trg4agugo@treble> <20160416090332.GA30613@gmail.com> <20160418133932.cnpxai32qn665un3@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:58407 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbcDROIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2016 10:08:49 -0400
In-Reply-To: <20160418133932.cnpxai32qn665un3@treble>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, jamborm@gcc.gnu.org

On Monday 18 April 2016 08:39:32 Josh Poimboeuf wrote:
> 
> I agree.  So how should we work around the bug in this case?  There have
> been several suggestions:
> 
> - change wwn_to_u64() to __always_inline
> 
> - change qla2x00_get_host_fabric_name() to skip the unnecessary call to
>   wwn_to_u64()
> 
> - revert one of the two commits:
>   bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of some byteswap operations")
>   ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")

What about the patch to change get_unaligned_be64() that I posted?

I think we want to merge that anyway, I just don't know if that helps
with this particular problem as well.

	Arnd
