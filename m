From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SCSI: fix isa/pcmcia compile problem
Date: Sat, 19 Jan 2008 08:27:42 +0900
Message-ID: <479135EE.2090009@gmail.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>	 <478F7F2B.9000801@linux.vnet.ibm.com>	 <20080117111104.3baa878e.akpm@linux-foundation.org>	 <47904927.1040000@linux.vnet.ibm.com>  <47905348.1000709@gmail.com> <1200668315.3111.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:46897 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbYARX1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jan 2008 18:27:52 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1026253rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2008 15:27:50 -0800 (PST)
In-Reply-To: <1200668315.3111.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fischer@norbit.de, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, Samuel Ortiz <samuel@sortiz.org>

James Bottomley wrote:
> On Fri, 2008-01-18 at 16:20 +0900, Tejun Heo wrote:
>> aha152x.c and fdomain are built twice - once for the isa driver and
>> once for the PCMCIA one.  Through #ifdefs, the compiled codes are
>> slightly different; thus, global symbols need to be given different
>> names depending on which flavor is being built.  This patch adds
>> GLOBAL() macro to aha152x.h and fdomain.h which change the symbol
>> depending on PCMCIA.
>>
>> This bug has always existed but has been masked by the fact the
>> drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
>> drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus
>> avoided the duplicate symbols during compilation.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> ---
>> Ah... missed that one.  Here's the updated version.
> 
> Actually, isn't the better fix just to return to the original behaviour?
> 
> As you pointed out, using the subdir instead of obj meant that although
> the modules were built, the drivers were never linked into the main
> kernel.  According to the records, this has been the default forever, so
> there can be no-one anywhere relying on these drivers being built in.
> Actually, as old style pcmcia drivers, I'm not sure there's much value
> building them into the kernel anyway.
> 
> So just modify scsi/pcmcia/Kconfig to make them all depend on m.

Yeap, there is no problem if you don't allow them to be linked into the
kernel.  If that's how you want it, please go ahead.

I personally think it's a bit odd to disallow building into kernel
because of the peculiarity of the implementation (including c files and
compiling them slightly differently) and also no one reporting doesn't
necessarily mean no one has attempted it and failed.

Thanks.

-- 
tejun
