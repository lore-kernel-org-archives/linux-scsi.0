From: Steven Haber <steven@qumulo.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Mon, 30 Jun 2014 11:45:31 -0700
Message-ID: <CAPK7rjcmujziT580t2O_dQnNPn8eyq7CTBxAgbqHYNobZCTxjQ@mail.gmail.com>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	<20140626150208.GA14887@infradead.org>
	<1403808734.6440.12.camel@dabdike>
	<20140627075553.GB21799@infradead.org>
	<CAPK7rjdpxAALA-oLZJ3wDBPc3kr5Nw4jLALLxEaT0zSiAOD+wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58518 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaF3Spc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2014 14:45:32 -0400
Received: by mail-oa0-f43.google.com with SMTP id o6so9413239oag.16
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2014 11:45:31 -0700 (PDT)
In-Reply-To: <CAPK7rjdpxAALA-oLZJ3wDBPc3kr5Nw4jLALLxEaT0zSiAOD+wg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Our qual rig is having some woes. I'll let you know how the test works
out after I finish resuscitating it.

On Mon, Jun 30, 2014 at 11:44 AM, Steven Haber <steven@qumulo.com> wrote:
> Our qual rig is having some woes. I'll let you know how the test works out
> after I finish resuscitating it.
>
>
> On Fri, Jun 27, 2014 at 12:55 AM, Christoph Hellwig <hch@infradead.org>
> wrote:
>>
>> On Thu, Jun 26, 2014 at 02:52:14PM -0400, James Bottomley wrote:
>> > > +   } else if (req->cmd_flags & REQ_FLUSH) {
>> > > +           /*
>> > > +            * Flush request don't transfer data, so we can't try
>> > > +            * to complete the good bytes first before checking
>> > > +            * the error.
>> > > +            */
>> > > +           if (result && !sense_deferred)
>> > > +                   error = __scsi_error_from_host_byte(cmd, result);
>> >
>> > Well, no, that's wrong.  To catch all of the corner cases that slip
>> > through here, the check is for a zero length command with and error
>> > otherwise we get the same problem for failed discards.
>>
>> It's correct for the current code base where FLUSH is the only zero
>> length !BLOCK_PC case.  Your version is fine too, except for the
>> incorrect comment:
>>
>> > +     } else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
>> > +             /*
>> > +              * Certain non BLOCK_PC requests are commands that don't
>> > +              * actually transfer anything (FLUSH, DISCARD), so cannot
>> > use
>> > +              * good_bytes == 0 as the signal for an error.  This sets
>> > the
>> > +              * error explicitly for the problem case
>> > +              */
>>
>> There aren't BLOCK_PC commands, otherwise they wouldn't end up here.
>>
>> Note that REQ_DISCARD has been rewritten into either an WRITE_SAME or
>> UNMAP at this point, which always transfer data.
>>
>
