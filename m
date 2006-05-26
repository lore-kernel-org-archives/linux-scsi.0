From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: PATCH: Bogus disk geometry on large disks
Date: Fri, 26 May 2006 11:57:13 -0600
Message-ID: <20060526175713.GB19587@parisc-linux.org>
References: <1148660965.20856.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45468 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750895AbWEZR5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 May 2006 13:57:15 -0400
Content-Disposition: inline
In-Reply-To: <1148660965.20856.35.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org

On Fri, May 26, 2006 at 05:29:25PM +0100, Alan Cox wrote:
>  
> -	if (ret == -1) {
> +	if (ret == -1 && capacity < (1ULL << 32)) {
>  		/* pick some standard mapping with at most 1024 cylinders,

won't that provoke a gcc warning when sector_t is 32-bit?  how about ...

+	if (ret == -1 && ((capacity >> 16) >> 16) > 0)

instead?
