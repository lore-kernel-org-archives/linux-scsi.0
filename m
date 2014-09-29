From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 26/38] seq_buf: Move the seq_buf code to lib/
Date: Mon, 29 Sep 2014 16:08:08 +0200
Message-ID: <542967C8.7060709@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>	<1411991947-130166-27-git-send-email-hare@suse.de> <20140929100438.36abd4ef@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbaI2OIL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 10:08:11 -0400
In-Reply-To: <20140929100438.36abd4ef@gandalf.local.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On 09/29/2014 04:04 PM, Steven Rostedt wrote:
> On Mon, 29 Sep 2014 13:58:55 +0200
> Hannes Reinecke <hare@suse.de> wrote:
>=20
>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>
>> The seq_buf functions are rather useful outside of tracing. Instead
>> of having it be dependent on CONFIG_TRACING, move the code into lib/
>> and allow other users to have access to it even when tracing is not
>> configured.
>>
>> The seq_buf utility is similar to the seq_file utility, but instead =
of
>> writing sending data back up to userland, it writes it into a buffer
>> defined at seq_buf_init(). This allows us to send a descriptor aroun=
d
>> that writes printf() formatted strings into it that can be retrieved
>> later.
>>
>> It is currently used by the tracing facility for such things like tr=
ace
>> events to convert its binary saved data in the ring buffer into an
>> ASCII human readable context to be displayed in /sys/kernel/debug/tr=
ace.
>>
>> It can also be used for doing NMI prints safely from NMI context int=
o
>> the seq_buf and retrieved later and dumped to printk() safely. Doing
>> printk() from an NMI context is dangerous because an NMI can preempt
>> a current printk() and deadlock on it.
>>
>> Link: http://lkml.kernel.org/p/20140619213952.058255809@goodmis.org
>=20
> I don't know where this is going, but I'm currently rewriting this
> code. Please don't add it yet to the kernel yet. I'm working on getti=
ng
> seq_buf and seq_file to be more inlined with each other. A much bette=
r
> sell if we can remove code with this change.
>=20
Hmm. I guess I'll be removing the respective patches then.
I can get quite the same results with using scnprintf(); the seq_buf
abstraction was just a nice way of coding.
No substantial difference here.

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
