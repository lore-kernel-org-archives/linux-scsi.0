From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: erase invalid data returned by device
Date: Wed, 16 Jul 2008 16:12:37 +0200
Message-ID: <87prpd5356.fsf@denkblock.local>
References: <804dabb00806232109k32437d04jeed373b7d38abdb3@mail.gmail.com>
	<Pine.LNX.4.44L0.0806241402020.2166-100000@iolanthe.rowland.org>
	<87vdz63q1b.fsf@denkblock.local>
	<1216216541.3230.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:43183 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbYGPOM4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 10:12:56 -0400
In-Reply-To: <1216216541.3230.4.camel@localhost.localdomain> (James
	Bottomley's message of "Wed, 16 Jul 2008 08:55:41 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2008-07-16 at 15:41 +0200, Elias Oltmanns wrote:
>> Alan Stern <stern@rowland.harvard.edu> wrote:
[...]
>> > +		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
>> 
>> Sorry, I don't understand that line at all. Surely, we want to zero out
>> either the excess data, i.e. buffer -> buffer + req->data_len, or the
>> residue, i.e. buffer + req->data_len -> buffer + bufflen. Your patch
>> implies that there are bufflen - req->data_len bytes of valid data at
>> the beginning of buffer. If this is intentional, please bear with me and
>> explain. Otherwise, what about the following patch to 2.6.26? On the
>> other hand, the same could probably be achieved by setting req->data_len
>> to 0. Oh dear, it would appear that I'm completely lost here.
>
> I think all you don't understand is simply that for a REQ_BLOCK_PC, the
> residue (that's the amount of untransferred, or at least bogus, data) is
> returned in req->data_len.  Thus, after such a request completes, you
> have bufflen-req->data_len good bytes.

Oh, I see. The name fooled me there, I suppose. So, the meaning of
req->data_len is inverted, as it were, when the LLDD performs the data
transfer, right?

Thanks for explaining,

Elias
