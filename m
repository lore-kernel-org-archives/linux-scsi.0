From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 26 Jun 2014 08:08:32 -0700
Message-ID: <20140626150832.GA31800@infradead.org>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
 <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
 <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
 <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
 <20140611133736.GA12240@infradead.org>
 <1403201159.17294.13.camel@dabdike.int.hansenpartnership.com>
 <20140625131344.GA13094@infradead.org>
 <1403791367.3572.1.camel@dabdike>
 <20140626150055.GB11199@infradead.org>
 <1403795096.3572.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaFZPId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 11:08:33 -0400
Content-Disposition: inline
In-Reply-To: <1403795096.3572.8.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, Jun 26, 2014 at 11:04:56AM -0400, James Bottomley wrote:
> Right, but look what we do for the specials.  The only difference is the
> ULD has a hook to generate the CDB.  For everything else we follow the
> BLOCK_PC path, including error handling and sense data processing.

No, we don't use the BLOCK_PC path for anything but a tiny bit of setup
code right now.  We will with your patch, which will cause all kinds of
behavior change.  See my last mail for the list of differences, which
includes the introduction of a major memory leak.

