From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Wed, 08 Jan 2003 00:13:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1BB382.5010504@splentec.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com> <20030107123301.A16378@beaverton.ibm.com> <3E1B513B.2090409@splentec.com> <20030107173633.A17825@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030107173633.A17825@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
>
>>You must agree that the tuple (COMMAND, (lun, target, channel))
>>doesn't say as much as (COMMAND, DEVICE). 
> 
> 
> Yes, but the current code simply sends a scsi_cmnd to the LLDD, and the
> LLDD need only reference the scsi_cmnd.

No, it doesn't necessarily have to. The advantages of
cmd->device->{lun, id, channel} far outweights
``LLDD need only reference the scsi_cmnd'',
as we've mentioned numerous times.

I think the networking code has similar well thought out abstractions.

> Having the LLDD use more data structures does not imply a better
> abstraction.  Again, a better abstraction would be to use interfaces to
> get the host/channel/target/lun. This could add overhead depending on the
> implementation.

Aaaah, this seems like a lost cause. You seem to be arguing this just
because of sake of your changing your multipath code.

Why can't you just make those macros in your code and see how
it works out -- who knows, maybe you'll get a better design idea...
 
> I have looked into putting multipath in the block layer, I've looked at
> md, at the T3 code, and at the qlogic multi-path code. Code in the block
> layer would be interesting, but might not solve problems with char
> devices, and would need further abstractions on top of some multi-path 
> in the scsi layer (someone has to find and represent the devices and
> paths, the block layer will not want to know about host/chan/target/lun,
> nor will the block layer want to know details about scsi device or
> transport errors).

And this is *not* an excuse to leave lun, target and channel into the
scsi command. A command belongs to a device, and a device belongs
to a host, which belongs to a pci bus, etc...

Remember we're talking about SCSI devices, not generic devices.
SCSI devices, as mentioned in my previous email have and have not
certain properties.

> Putting the multipath abstraction into scsi_request_fn is IMO the best way
> to go (as I've argued before) at least until other non-scsi block and

Please keep in mind what SCSI Core is all about. Please don't mix and
match.

>>Getting rid of redundancies in data design and code design is important.
>>
> 
> 
> As mentioned, using a scsi_device both for a list of paths and as a
> representation of scsi device duplicates data in multiple places.

We are *not* discussing multipathing here.

-- 
Luben


