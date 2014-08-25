From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi logging future directions, was Re: [RFC PATCH -logging 00/10]
 scsi/constants: Output continuous error messages on trace
Date: Mon, 25 Aug 2014 13:30:55 +0200
Message-ID: <53FB1E6F.7080803@suse.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <94D0CD8314A33A4D9D801C0FE68B402958C1A9E5@G9W0745.americas.hpqcorp.net> <20140824204454.GA11423@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140824204454.GA11423@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

On 08/24/2014 10:44 PM, Christoph Hellwig wrote:
> On Fri, Aug 22, 2014 at 12:39:59AM +0000, Elliott, Robert (Server Sto=
rage) wrote:
>> If you trigger hundreds of errors (e.g., hot remove a device
>> during heavy IO), then all the prints to the linux serial console
>> bog down the system, causing timeouts in commands to other
>> devices and soft lockups for applications.
>>
>> Some changes that would help are:
>> 1. Put them under SCSI logging level control
>> 2. Use printk_ratelimited so an excessive number are trimmed
>>
>> Would you like to include something like this in your
>> patch set?
>
> I think we should come to an agreement where we want to go with scsi
> logging first before doing various smaller adjustments.  (Although yo=
ur
> example is one that's urgent enough that I'd like to put it in ASAP,
> I had issues with it a few times).
>
> I had a chat with Martin at Linuxcon about these issues, and we were
> both in favor of getting rid of the old scsi logging mechansisms and
> instead replace it by an extended version of the scsi tracepoints tha=
t
> cover all places, and dump all data from the old logging mechanism
> that people find useful.
>
> In a few places we'd still want to log normal dev_printk style errors=
,
> and the I/O completion is one of them, even if they really need to be
> ratelimited and condensed.
>
> If someone has arguments in favour of keeping the old logging code
> I'd love to hear them, but in practive the traceevent code has huge
> benefits:
>
>   - almost zero overhead if disabled
>   - can easily be used without any tools through configs, but can be =
used
>     even better with tools like trace-cmd or perf
>   - allows both fine and coarse grained selections of events to trace
>   - allows to capture statistics on each trace point without event en=
abling the
>     output
>   - doesn't have any of the console lockup problems.
>
I've already been working on updating scsi logging infrastructure,=20
removing old cludges and streamlining it.
I'm all in favour of moving things over to scsi tracing; in fact I've=20
already moved all the current SCSI_ML_XXX statements to tracepoints in
my current patchset.

Unfortunately I haven't found time to test things out there, and there'=
s=20
the patchset from Yoshihiro which needs review and integration.

As of now I've treated this as rather low priority as no-one seemed to=20
mind and the patchsets will be touching each and every driver.

I'll be updating the patchset and send it for review.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
