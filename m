From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Thu, 16 Jun 2011 19:20:07 +0200
Message-ID: <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 16, 2011 at 19:09, Kay Sievers <kay.sievers@vrfy.org> wrote=
:
> On Thu, Jun 16, 2011 at 18:25, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
>> > All userspace naming will be taken care of by the usual udev rules=
, so
>>> > for disks, something like /dev/disk/by-preferred/<fred> which wou=
ld be
>>> > the usual symbolic link.
>>>
>>> No, udev can not create such a link after the preferred name is set=
, as
>>> it has no way of knowing that the name was set.
>>
>> It can if we trigger a uevent. =C2=A0Note: I'm not advocating this .=
=2E. I'd be
>> equally happy having whatever sets the kernel name create the link (=
or
>> tickle udev to create it). =C2=A0We definitely require device links,=
 though,
>> to get this to work.

Guess all that would work now, including mount(8) not canonicalizing.
What would happen if we mount:
  /dev/disk/by-pretty/foo
and some tool later thinks the pretty name should better be 'bar', it
writes the name to /sys, we get a uevent, the old link disappears, we
get a new link, mount has no device node anymore for the mounted
device ...

So we basically get a one-shot additional pretty name? Guess, the
_single_ name changed anytime later just asks for serious problems. We
need to set it very early to be really useful, but how, where is it
coming from?

Kay
