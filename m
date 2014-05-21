From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND] scsi: Output error messages using structured printk
 in single line
Date: Wed, 21 May 2014 08:30:58 +0200
Message-ID: <537C4822.6000204@suse.de>
References: <20140227041738.31316.14684.stgit@yunodevel> <1400638922.2481.18.camel@dabdike> <94D0CD8314A33A4D9D801C0FE68B402956F1CF5A@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaEUGbC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2014 02:31:02 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956F1CF5A@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Prarit Bhargava <prarit@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kay Sievers <kay@vrfy.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

On 05/21/2014 05:18 AM, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of James Bottomley
>> Sent: Tuesday, May 20, 2014 9:22 PM
>> To: Yoshihiro YUNOMAE
>> Cc: Hannes Reinecke; Prarit Bhargava; linux-scsi@vger.kernel.org; Ka=
y
>> Sievers; linux-kernel@vger.kernel.org; Hidehiro Kawai; yrl.pp-
>> manager.tt@hitachi.com; Masami Hiramatsu
>> Subject: Re: [PATCH RESEND] scsi: Output error messages using struct=
ured
>> printk in single line
>>
>> On Thu, 2014-02-27 at 13:17 +0900, Yoshihiro YUNOMAE wrote:
>>> +/* Maximum size of a local buffer for structured printk */
>>> +#define SCSI_LOG_LINE_MAX 512
>>> +
>>> +/* Local buffer for structured printk */
>>> +struct scsi_log_line {
>>> +	int offset;
>>> +	char buf[SCSI_LOG_LINE_MAX];
>>> +};
>>
>> This piece isn't going to fly; it's an on stack allocation of 0.5kb;
>> that's too much for small stack kernels.  Just changing this to a ka=
lloc
>> is going be problematic too because we're in the io paths and the
>> allocation may fail.  So I appreciate the problem, but I don't think=
 the
>> solution works.  Could we just tag the messages and use grep to put =
them
>> back together?
>>
>> James
>>
>
> When the system gets busy, I've seen CDB bytes strung out with each
> byte getting its own timestamp, with messages from different devices
> and threads interleaved together, so like the idea of printing each
> line with a single printk() call.
>
> Most lines aren't anywhere near 512 bytes long.  Can this be coded to
> let the calling function define an appropriate buffer size for
> whatever it is printing, with sizeof() used to bounds check?
>
>
As mentioned several times, I'm working on a patchset to update
scsi logging.

The original patchset tried to convert any logging message into a=20
single statement, which wouldn't be broken up even under heavy load.

While this works reasonably well for most things, printing out=20
decoded sense with just one line (and not end up in massive switch()
statements) is near impossible.

Plus you'll end up having to use a static buffer at one point, which
again increases the stack size.

The alternative approach as discussed at LSF is to move scsi_logging
over to tracing. There is already some coding for scsi tracing, but
in most cases it just duplicates existing logging statements.
So if we were to replace the entire scsi_logging infrastructure
with scsi tracing most of the issues (like chopped-up CDBs) would
be gone.
Plus we would have a far better control about _what_ is being printed.

And yes, I do have some patches for that :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
