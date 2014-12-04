From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH qla2xxx] Race in handling rport deletion in Qlogic driver
 during recovery causes panic
Date: Thu, 4 Dec 2014 00:44:37 -0800
Message-ID: <20141204084437.GA12187@infradead.org>
References: <66112100.3203938.1416924145624.JavaMail.zimbra@redhat.com>
 <827904999.3215615.1416925002571.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaLDIoi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 03:44:38 -0500
Content-Disposition: inline
In-Reply-To: <827904999.3215615.1416925002571.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, Chad Dupuis <cdupuis@redhat.com>

On Tue, Nov 25, 2014 at 09:16:42AM -0500, Laurence Oberman wrote:
> When we have an rport disconnect we race during rport deletion and re-connection resulting in a panic.
> When we do this, we call fc_remote_port_del() just before we do the calls to re-establish the session with 
> the FC transport with fc_remote_port_add() and then fc_remote_port_rolechg().
> 
> If we remove the call to fc_remote_port_del() before re-establishing the connection this prevents the race.
> This patch has resolved this for multiple customers via test kernels.
> 
> Suggested by Chad Dupuis, implemented and tested by Laurence Oberman.

Chad, can you review this one?  Or do you plan to send it to me with the
next qla2xxx update?  Note that the 3.19 merge window is about to end.
