From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib: replace ambiguous "Unhandled error code"
 messages.
Date: Wed, 28 May 2014 18:27:52 +0400
Message-ID: <1401287272.2288.29.camel@dabdike>
References: <1401099204-18050-1-git-send-email-mlombard@redhat.com>
	 <20140526162506.GB18319@infradead.org>
	 <20140526192715.GA2271@dhcp-27-189.brq.redhat.com>
	 <20140528110018.GA30751@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33203 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191AbaE1O14 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 10:27:56 -0400
In-Reply-To: <20140528110018.GA30751@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>, linux-scsi@vger.kernel.org

On Wed, 2014-05-28 at 04:00 -0700, Christoph Hellwig wrote:
> On Mon, May 26, 2014 at 09:27:15PM +0200, Maurizio Lombardi wrote:
> > > How about simple not setting description at all for this case?
> > > 
> > 
> > It has already been proposed before but James didn't like the idea.
> > 
> > http://markmail.org/message/dumujpz4gfp3s4fp#query:+page:1+mid:dumujpz4gfp3s4fp+state:results
> 
> James never replied to Robs question.  I can't think of any value add
> that "Unhandled XYZ" adds when we already get a usesul message from the
> same error.
> 
> James, care to comment what'd you like to see printed here?

I'm happy with eliminating "Unhanndled Error Code" because that is
misleading ... we should only get there if we have a DID_X return and
they're all fatal errors which will be printed.

I'm less happy removing "Unhandled Sense Code".  The danger is that we
get some harmless sense code we should have handled and instead error
the command.  Since for this error we know the next print will be the
sense code, what about changing it to "Failing Command with sense code:"

James


