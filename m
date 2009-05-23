From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Convert scsi_scan to use generic async mechanism
Date: Sat, 23 May 2009 15:39:19 -0500
Message-ID: <1243111159.3630.36.camel@localhost.localdomain>
References: <20090428193557.GC21648@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41636 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbZEWUjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 May 2009 16:39:19 -0400
In-Reply-To: <20090428193557.GC21648@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Tue, 2009-04-28 at 13:35 -0600, Matthew Wilcox wrote:
> +	scsi_host_get(shost);
> +	cookie = async_schedule_domain(async_scsi_scan_host, shost,
> +								&scan_domain);
> +	if (strncmp(scsi_scan_type, "sync", 4) == 0)
> +		async_synchronize_cookie_domain(cookie, &scan_domain);

This last statement doesn't actually do anything.  It waits for all
prior scans to complete, but not this one, so we're not actually
synchronous here ... we don't wait for the scan we just kicked off to
complete.

Arjan suggests a way to hack around this might be
async_synchronize_cookie_domain(cookie + 1, &scan_domain);

James


