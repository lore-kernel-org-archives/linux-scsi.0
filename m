From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
 error messages on trace
Date: Wed, 27 Aug 2014 16:23:14 +0200
Message-ID: <53FDE9D2.6070100@suse.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <53E4CB7B.7020705@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934408AbaH0OXR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 10:23:17 -0400
In-Reply-To: <53E4CB7B.7020705@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Christoph Hellwig <hch@lst.de>

On 08/08/2014 03:07 PM, Douglas Gilbert wrote:
> On 14-08-08 01:50 PM, Yoshihiro YUNOMAE wrote:
>> Hi All,
>>
>> This patch set introduces new traceevents in order to output
>> continuous error
>> messages. Current SCSI printk messages in upstream kernel can be
>> divided by and
>> mixed with other messages. Even if each error message has its
>> device id,
>> sometimes we can easily be lost in mixed logs because the
>> message's device id
>> is separated from it's body. To avoid it, I'd like to use
>> traceevents to
>> store error messages into the ftrace or perf buuffer, because
>> traceevents
>> are atomically commited to the buffer.
>>
>> In this patch set, all printk messages are removed based on a local
>> discussion with Hannes, but I think printk messages should be kept
>> because all
>> users don't enable traceevents and rsyslog can store as files.
>>
>> However, if printk of logging branch is kept, the messages are
>> duplicate and
>> it can induce stack overflow by using local buffer(*1).
>>
>>   (*1) https://lkml.org/lkml/2014/5/20/742
>>
>> So, my suggestion is follows:
>>
>> 1) printk
>> Keeps current implemntation of upstream kernel.
>> The messages are divided and can be mixed, but all users can check
>> the error
>> messages without any settings.
>>
>> 2) traceevents
>> To get the complete messages, we can use ftrace or perf (or
>> something on them).
>> Users can always understand correct messages, but they need to set
>> up the
>> tracers.
>>
>> This patch set is based on Hannes' logging branch:
>> http://git.kernel.org/cgit/linux/kernel/git/hare/scsi-devel.git/log/=
?h=3Dlogging
>>
>>
>> [1/10] ~  [6/10]: just cleanup for logging branch
>> [7/10] ~ [10/10]: introduce new traceevents
>>
>> Any comments are welcome!
>
> In sg3_utils there are now string yielding equivalents
> to the sense buffer "print" functions. They take a form
> like this:
>    char * get_sense_str(const unsigned char * sense_buffer,
>                         int sb_len, int blen, char * b);
>
> So this just does the hard work of decoding the sense buffer
> (or saying it is invalid) the result of which it places in
> buffer 'b'. And 'b' is returned (so this function can be in
> the arguments of a driver's printing function).
>
> Adding such string functions would give other parts of the
> SCSI subsystem the capability of tailoring their own
> messages that include sense data information.
>
>
> Existing sense buffer "print" function could be kept and
> implemented using the newer "_str" variants. Would that
> be worth the trouble?
>
Hmm. Probably not.

I would rather go the approach we've been taking with the
VPD pages, and do _not_ decode any sense code data
(except from the usual sense key/ASC/ASCQ values, of course).
Instead we should rather ensure that we can get to the raw
sense code values from userspace so that we can interpret
it later with userspace tools.

My plan for updating scsi logging is:

- move all lone 'printk' statements into dev_printk() variants
   and ensure they are printed in one line to avoid breaking
   logging statements up under high load
- Update scsi_trace to use the functionality from constants.c
- Convert the current scsi_logging mechanism over to tracepoints.

The first bit is mostly done; I'll be sending the patchset for review.
The hard part is the third bit; would be really grand if we can
model this with the existing scsi_logging_level interface intact.
But not sure if that's possible nor if it's desirable.

Btw, _now_ would be a good chance to send an update of constants.c
with latest SPC bits ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
