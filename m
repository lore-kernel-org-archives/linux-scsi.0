From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/10] iscsi: data digest page cache usage fix
Date: Fri, 13 Jan 2006 18:14:27 +0000
Message-ID: <20060113181427.GM20718@infradead.org>
References: <1137128913.9508.37.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48515 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422788AbWAMSO1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:14:27 -0500
Content-Disposition: inline
In-Reply-To: <1137128913.9508.37.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 12, 2006 at 11:08:33PM -0600, Mike Christie wrote:
> >From FUJITA Tomonori <tomof@acm.org>:
> 
> Users can write to a page while we are sending it and making
> digest calculations. This ends up causing us to retry the command
> when a digest error is later reported. By using sock_no_sendpage
> when data digests are calculated we can avoid a lot of (not all but it
> helps) the retries becuase sock_no_sendpage is not zero copy.

This sounds like it'd kill performance badly when using data digests.
But using lock_page from an LLDD sounds pretty bad aswell, so I don't
know anything better.

