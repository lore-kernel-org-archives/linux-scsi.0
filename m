From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Date: Tue, 3 Nov 2009 19:12:33 +0000
Message-ID: <20091103191233.0c3ba736@lxorguk.ukuu.org.uk>
References: <1257273488.9427.27.camel@mulgrave.site>
	<20091103105921.160d5599.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34116 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754315AbZKCTKv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 14:10:51 -0500
In-Reply-To: <20091103105921.160d5599.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

> static inline void strsrip_tail(char *str)
> {
> 	char *x __used;
> 	x = strstrip(str);
> }

Bikeshed time but its cleaner to do

static inline __must_check void strstrip(char *str)
{
	return strim(str);
}

and make strim() the old strstrip function without the check requirement


Alan
