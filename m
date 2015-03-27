From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] [RESEND] aic7xxx: replace kmalloc/memset by kzalloc
Date: Thu, 26 Mar 2015 17:38:17 -0700
Message-ID: <5514A679.5030005@free-electrons.com>
References: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net>	 <1427041891-2694-1-git-send-email-michael.opdenacker@free-electrons.com>	 <550FB9BE.5010801@suse.de> <5511CD10.6040709@free-electrons.com> <1427230622.12126.13.camel@perches.com> <94D0CD8314A33A4D9D801C0FE68B40295A8416C5@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:58106 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752524AbbC0AiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2015 20:38:23 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A8416C5@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Joe Perches <joe@perches.com>
Cc: Hannes Reinecke <hare@suse.de>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 03/24/2015 04:16 PM, Elliott, Robert (Server Storage) wrote:
>
> It was a reply to the original post on 2014-10-16, not the resend
> this month. 
>
> From http://permalink.gmane.org/gmane.linux.kernel/1808168:
>
> kcalloc is helpful when one of the values is a variable that 
> might cause the multiply to overflow during runtime.  Here, 
> two constants are being multiplied together, which can
> be done and checked by the compiler at compile time.  
>
> Since kcalloc and kmalloc_array are both static inline 
> functions:
> static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
> {
>         if (size != 0 && n > SIZE_MAX / size)
>                 return NULL;
>         return __kmalloc(n * size, flags);
> }
> static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> {
>         return kmalloc_array(n, size, flags | __GFP_ZERO);
> }
>
> a compiler that detects an overflow will probably just reduce
> that to an inlined "return NULL."
> 	
> BUILD_BUG_ON could be used to trigger a compile-time error,
> instead of building a kernel that returns a run-time error.

Ok, I hope we agree to get back to kzalloc() for which the compiler
won't miss size_t overflows.

Thanks for the reviews!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098


