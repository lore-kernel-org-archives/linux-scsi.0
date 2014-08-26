From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
 error messages on trace
Date: Tue, 26 Aug 2014 16:23:07 +0200
Message-ID: <53FC984B.7040805@suse.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <53E4CB7B.7020705@interlog.com> <53EAD7CC.8030408@hitachi.com> <53F79FE8.7030406@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53F79FE8.7030406@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 08/22/2014 09:54 PM, Douglas Gilbert wrote:
> On 14-08-12 11:13 PM, Yoshihiro YUNOMAE wrote:
>> Hi Douglas,
>>
>> Thank you for your comment.
>>
>> (2014/08/08 22:07), Douglas Gilbert wrote:
>>> On 14-08-08 01:50 PM, Yoshihiro YUNOMAE wrote:
>>>> Hi All,
>>>>
>>>> This patch set introduces new traceevents in order to output
>>>> continuous error
>>>> messages. Current SCSI printk messages in upstream kernel can be
>>>> divided by and
>>>> mixed with other messages. Even if each error message has its
>>>> device id,
>>>> sometimes we can easily be lost in mixed logs because the message'=
s
>>>> device id
>>>> is separated from it's body. To avoid it, I'd like to use
>>>> traceevents to
>>>> store error messages into the ftrace or perf buuffer, because
>>>> traceevents
>>>> are atomically commited to the buffer.
>>>>
>>>> In this patch set, all printk messages are removed based on a loca=
l
>>>> discussion with Hannes, but I think printk messages should be kept
>>>> because all
>>>> users don't enable traceevents and rsyslog can store as files.
>>>>
>>>> However, if printk of logging branch is kept, the messages are
>>>> duplicate and
>>>> it can induce stack overflow by using local buffer(*1).
>>>>
>>>>   (*1) https://lkml.org/lkml/2014/5/20/742
>>>>
>>>> So, my suggestion is follows:
>>>>
>>>> 1) printk
>>>> Keeps current implemntation of upstream kernel.
>>>> The messages are divided and can be mixed, but all users can
>>>> check the
>>>> error
>>>> messages without any settings.
>>>>
>>>> 2) traceevents
>>>> To get the complete messages, we can use ftrace or perf (or
>>>> something
>>>> on them).
>>>> Users can always understand correct messages, but they need to
>>>> set up the
>>>> tracers.
>>>>
>>>> This patch set is based on Hannes' logging branch:
>>>> http://git.kernel.org/cgit/linux/kernel/git/hare/scsi-devel.git/lo=
g/?h=3Dlogging
>>>>
>>>>
>>>>
>>>> [1/10] ~  [6/10]: just cleanup for logging branch
>>>> [7/10] ~ [10/10]: introduce new traceevents
>>>>
>>>> Any comments are welcome!
>>>
>>> In sg3_utils there are now string yielding equivalents
>>> to the sense buffer "print" functions. They take a form
>>> like this:
>>>    char * get_sense_str(const unsigned char * sense_buffer,
>>>                         int sb_len, int blen, char * b);
>>>
>>> So this just does the hard work of decoding the sense buffer
>>> (or saying it is invalid) the result of which it places in
>>> buffer 'b'. And 'b' is returned (so this function can be in
>>> the arguments of a driver's printing function).
>>>
>>> Adding such string functions would give other parts of the
>>> SCSI subsystem the capability of tailoring their own
>>> messages that include sense data information.
>>>
>>>
>>> Existing sense buffer "print" function could be kept and
>>> implemented using the newer "_str" variants. Would that
>>> be worth the trouble?
>>
>> I have already sent the idea using local buffer on this February,
>> but it was rejected by James (*1). By using stack region for local
>> buffer, stack overflow can occur. So, I implemented this feature
>> to atomically output an error message with device information.
>>
>> (*1) https://lkml.org/lkml/2014/5/20/742
>
> Hi,
> In the "_str" variants that I referred to, the caller provides
> the buffer and its length. The responsibility of the
> implementation of those "_str" variants is to use that
> buffer, not exceed it, and make sure that it is null terminated
> on return.
>
> Can't see any inherent threat to the stack size there, and if
> there is then that is just bad design by the caller.
>
> The advantage of the "_str" variants is that the caller can
> supply context and print/log a more useful message, perhaps
> including the caller's __func__ . That message could include
> sense information (perhaps truncated to 128 bytes, say),
> and be output as a single unit.
>
> IMO too many log messages are multi-line and in a noisy,
> misbehaving system those messages can be interleaved
> with other "noise" making them difficult to decipher.
>
Precisely, and that is what my patchset is trying to address.

I'm currently porting it to core-for-3.18, will be posting it
for review once it's done.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
