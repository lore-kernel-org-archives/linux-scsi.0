From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 17:57:12 +0200
Message-ID: <BANLkTi=G4d4JPyt=Q38bGsQJ2K5VPzOhBA@mail.gmail.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com>
 <1308256290.2436.143.camel@mulgrave> <20110617052523.GB741@kroah.com> <4DFB75A4.8070405@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DFB75A4.8070405@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 17, 2011 at 17:41, Douglas Gilbert <dgilbert@interlog.com> =
wrote:
> On 11-06-17 01:25 AM, Greg KH wrote:
>> As for "expediency", it has been a full year since the last time thi=
s
>> was proposed. =C2=A0All userspace tools that would need to be change=
d to
>> implement this in userspace have had updates released for them in th=
at
>> year, and the changes needed to make to them could have been done
>> already.
>
> Could you elaborate taking one user space tool as an
> example and tell us what changes you think should be
> made?
>
> Are you talking about low level tools such as hdparm,
> smartmontools and mine or tools further up the "food
> chain"?

I think the only thing really missing is a smarter 'syslog' that has
context, and not just a stream of almost random free-text packets.

Ideally the main source would be a _structured_ and properly machine
readable error/debug log from the kernel, maintained in userspace as
an indexable database, and constant merging of userspace state
information into it.

Debug/error messages from the kernel would need proper classification
and if needed can carry additional data structures, even binary data,
that contain dumps of sense results or firmware data.

I doubt there can be any really useful kernel only solution to
enterprise storage needs. Especially not based on printk().

I'm sure, we should really start to think in that direction instead of
extending things that are unlikely to solve the underlying  problem
ever.

Userspace tools can already query the udev database very easily, it's
almost free, no IPC, no fork() involved, it's just a few libudev calls
which read files out of tmpfs. If they want to show names they can do
that already today. Making the kernel decide which one of the names is
the single one to choose, just can't work, I think.

Kay
