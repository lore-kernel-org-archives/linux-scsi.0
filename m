From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 15/17] drivers/scsi: Use DIV_ROUND_UP
Date: Mon, 22 Sep 2008 18:43:45 -0600
Message-ID: <20080923004345.GC27204@parisc-linux.org>
References: <200809222156.m8MLupx2032307@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52936 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYIWAoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 20:44:06 -0400
Content-Disposition: inline
In-Reply-To: <200809222156.m8MLupx2032307@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, julia@diku.dk

On Mon, Sep 22, 2008 at 02:56:51PM -0700, akpm@linux-foundation.org wrote:
>  
>  		one_clock = esp->ccycle / 1000;
>  		rounded_up = (period << 2);
> -		rounded_up = (rounded_up + one_clock - 1) / one_clock;
> +		rounded_up = DIV_ROUND_UP(rounded_up, one_clock);
>  		stp = rounded_up;
>  		if (stp && esp->rev >= FAS236) {
>  			if (stp >= 50)

Is this not exactly equivalent to:

		one_clock = esp->ccycle / 1000;
		stp = DIV_ROUND_UP(period << 2, one_clock);

(rounded_up is local to this if condition).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
