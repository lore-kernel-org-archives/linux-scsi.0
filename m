From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Thu, 16 Jun 2011 20:31:12 +0200
Message-ID: <BANLkTi=eDA1Oa1cVdVNozYu-K5Z0i1uv2g@mail.gmail.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com>
 <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com> <4DFA44D4.2010602@interlog.com>
 <BANLkTimHMM6gNcFFP62eU-SUfaCPyhWE_A@mail.gmail.com> <4DFA485C.4090300@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DFA485C.4090300@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 16, 2011 at 20:15, Douglas Gilbert <dgilbert@interlog.com> =
wrote:
> On 11-06-16 02:05 PM, Kay Sievers wrote:
>>> The kernel's device naming (following from how devices are
>>> discovered) is topological. However at higher levels
>>> the user is interested in the device identity. So if
>>> unique device names were used as preferred names and
>>> preferred names were unique (in a Linux system at any
>>> given time) then any subsequent path to an existing device
>>> would be highlighted. [That is because subsequent attempts
>>> to create its preferred name would fail because it is
>>> already there.]
>>>
>>> You don't need thousands of dollars of equipment to
>>> demonstrate this point. An external single disk
>>> SATA enclosure with a USB and eSATA interface will do.
>>
>> Udev does that already since quite a while. This is my cheap laptop:
>> =C2=A0 # find /dev/disk/ -name "wwn*"
>> =C2=A0 /dev/disk/by-id/wwn-0x50015179593f3038-part1
>> =C2=A0 /dev/disk/by-id/wwn-0x50015179593f3038-part4
>> =C2=A0 /dev/disk/by-id/wwn-0x50015179593f3038-part3
>> =C2=A0 /dev/disk/by-id/wwn-0x50015179593f3038-part2
>> =C2=A0 /dev/disk/by-id/wwn-0x50015179593f3038
>
> That is my point, if that disk is eSATA and USB connected
> which transport is that link pointing to? I would
> prefer eSATA over USB any day but is udev that smart? Or
> are we just seeing a symlink to the first (or perhaps last)
> path discovered?

I don't know if any bridge supports both connections at the same time.
Mine doesn't.

If two kernel devices fight for the same link, the last one wins,
unless there are link-priorities specified in udev rules.

Kay
