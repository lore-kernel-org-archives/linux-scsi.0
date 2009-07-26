From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Don't export scsi kernel variables in userspace
	headers.
Date: Sun, 26 Jul 2009 16:14:24 -0600
Message-ID: <20090726221424.GA3711@parisc-linux.org>
References: <20090725021026.GA6942@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57472 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbZGZWOY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2009 18:14:24 -0400
Content-Disposition: inline
In-Reply-To: <20090725021026.GA6942@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Fri, Jul 24, 2009 at 10:10:26PM -0400, Dave Jones wrote:
> +++ b/include/scsi/scsi.h
> @@ -156,7 +156,9 @@ scsi_varlen_cdb_length(const void *hdr)
>  	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
>  }
>  
> +#ifdef __KERNEL__
>  extern const unsigned char scsi_command_size_tbl[8];
> +#endif
>  #define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
>  
>  static inline unsigned

Probably should move that #endif down -- it's not like userspace can
use the COMMAND_SIZE macro (should headers_check also check for this?)

Also scsi_command_size() isn't usable by userspace either, since it uses
COMMAND_SIZE.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
