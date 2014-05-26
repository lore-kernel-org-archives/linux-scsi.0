From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: Re: [PATCH RESEND] scsi: Output error messages using structured
 printk in single line
Date: Mon, 26 May 2014 17:09:36 +0900
Message-ID: <5382F6C0.3040407@hitachi.com>
References: <20140227041738.31316.14684.stgit@yunodevel> <1400638922.2481.18.camel@dabdike> <94D0CD8314A33A4D9D801C0FE68B402956F1CF5A@G4W3202.americas.hpqcorp.net> <537C4822.6000204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <537C4822.6000204@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Prarit Bhargava <prarit@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kay Sievers <kay@vrfy.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

(2014/05/21 15:30), Hannes Reinecke wrote:
> On 05/21/2014 05:18 AM, Elliott, Robert (Server Storage) wrote:
>>
>>
>>> -----Original Message-----
>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>> owner@vger.kernel.org] On Behalf Of James Bottomley
>>> Sent: Tuesday, May 20, 2014 9:22 PM
>>> To: Yoshihiro YUNOMAE
>>> Cc: Hannes Reinecke; Prarit Bhargava; linux-scsi@vger.kernel.org; Kay
>>> Sievers; linux-kernel@vger.kernel.org; Hidehiro Kawai; yrl.pp-
>>> manager.tt@hitachi.com; Masami Hiramatsu
>>> Subject: Re: [PATCH RESEND] scsi: Output error messages using structured
>>> printk in single line
>>>
>>> On Thu, 2014-02-27 at 13:17 +0900, Yoshihiro YUNOMAE wrote:
>>>> +/* Maximum size of a local buffer for structured printk */
>>>> +#define SCSI_LOG_LINE_MAX 512
>>>> +
>>>> +/* Local buffer for structured printk */
>>>> +struct scsi_log_line {
>>>> +    int offset;
>>>> +    char buf[SCSI_LOG_LINE_MAX];
>>>> +};
>>>
>>> This piece isn't going to fly; it's an on stack allocation of 0.5kb;
>>> that's too much for small stack kernels.  Just changing this to a kalloc
>>> is going be problematic too because we're in the io paths and the
>>> allocation may fail.  So I appreciate the problem, but I don't think the
>>> solution works.  Could we just tag the messages and use grep to put them
>>> back together?
>>>
>>> James
>>>
>>
>> When the system gets busy, I've seen CDB bytes strung out with each
>> byte getting its own timestamp, with messages from different devices
>> and threads interleaved together, so like the idea of printing each
>> line with a single printk() call.
>>
>> Most lines aren't anywhere near 512 bytes long.  Can this be coded to
>> let the calling function define an appropriate buffer size for
>> whatever it is printing, with sizeof() used to bounds check?
>>
>>
> As mentioned several times, I'm working on a patchset to update
> scsi logging.
>
> The original patchset tried to convert any logging message into a single
> statement, which wouldn't be broken up even under heavy load.
>
> While this works reasonably well for most things, printing out decoded
> sense with just one line (and not end up in massive switch()
> statements) is near impossible.
>
> Plus you'll end up having to use a static buffer at one point, which
> again increases the stack size.
>
> The alternative approach as discussed at LSF is to move scsi_logging
> over to tracing. There is already some coding for scsi tracing, but

Oh, I didn't attend the meeting, so I didn't know it.
Did you completely change the development from fixing scsi_logging
to using tracing?

> in most cases it just duplicates existing logging statements.
> So if we were to replace the entire scsi_logging infrastructure
> with scsi tracing most of the issues (like chopped-up CDBs) would
> be gone.
> Plus we would have a far better control about _what_ is being printed.
>
> And yes, I do have some patches for that :-)

I would like to develop the feature together because this
is an important problem.
Would you upload the patches to your tree?
And, would you share current status and issues with us?

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
