From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] sd: Handle ZBC drives correctly
Date: Mon, 21 Jul 2014 13:51:26 +0200
Message-ID: <53CCFEBE.8080400@suse.de>
References: <1405931241-92015-1-git-send-email-hare@suse.de> <1405931241-92015-5-git-send-email-hare@suse.de> <20140721112904.GB15455@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140721112904.GB15455@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomely <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 07/21/2014 01:29 PM, Christoph Hellwig wrote:
> On Mon, Jul 21, 2014 at 10:27:21AM +0200, Hannes Reinecke wrote:
>> ZBC drives are close to disk devices, so update sd.c to handle
>> ZBC drives correctly.
>
> While the other patches all look fine with me I strongly disagree wit=
h
> this one.  Devices reporting the ZBC device type must have sequential
> required zones, so they are _not_ anywhere close to disk devices,
> and writes to them will cause errors that we aren't evenable able to
> handle yet.
>
> If it makes some sort of experiment easier for you we can add a way t=
o
> force ZBC devices to use sd.c conditionally.  Do you have a test devi=
ce
> that this works with?
>
Yes, I have.

I was actually considering implementing a module option for sd
(eg attach_zbc) to allow zac/zbc devices to be attached to the sd=20
driver.
Which will be off per default, so your concern should be addressed.

However, zbc devices _are_ similar to normal 'sd' devices; it's only=20
that some commands might fail unexpectedly.
But all the usual commands from sbc are supported, so I found it a=20
bit odd having to implement my own device driver (which would be a=20
clone of 'sd' anyway).

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
