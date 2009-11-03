From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Date: Tue, 3 Nov 2009 10:59:21 -0800
Message-ID: <20091103105921.160d5599.akpm@linux-foundation.org>
References: <1257273488.9427.27.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZKCS71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 13:59:27 -0500
In-Reply-To: <1257273488.9427.27.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 03 Nov 2009 12:38:08 -0600
James Bottomley <James.Bottomley@suse.de> wrote:

> strstrip strips whitespace from the beginning and end of a string.  I
> agree you have to take the returned pointer if you want to strip from
> the beginning.  However, if you wish to keep the whitespace at the
> beginning and only wish strstrip to remove it from the end, then it's
> entirely legitimate to discard the returned pointer.
> 
> This is what we have in drivers/scsi/ipr.c and the patch to make
> strstrip __must_check is now causing SCSI spurious warnings in that
> code.
> 

Would prefer to keep the warning and to patch ipr.c, please.  We found
I think three call sites which were incorrectly ignoring the strstrip()
return value and it's reasonable to fear that others will make the same
mistake in the future.

And maybe ipr.c _should_ be patched.  Right now it's assuming that the
string coming back from the device has no leading whitespace.  Why trim
any possible trailing whitespace but not trim any possible leading
whitespace?

Or..

/*
 * Comment goes here
 */
static inline void strsrip_tail(char *str)
{
	char *x __used;
	x = strstrip(str);
}
