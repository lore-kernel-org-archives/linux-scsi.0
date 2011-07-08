From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Fri, 8 Jul 2011 18:15:18 +0200
Message-ID: <CAPXgP12dA72a3ja659GH6uW+ZCMfL6iECaY6ORXwOQ6S5eTvaQ@mail.gmail.com>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
 <20110708145408.GA2283@kroah.com> <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com>
 <20110708154736.GA7320@kroah.com> <1310140451.3282.85.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43768 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1GHQPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 12:15:40 -0400
In-Reply-To: <1310140451.3282.85.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jcm@redhat.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de

On Fri, Jul 8, 2011 at 17:54, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> Yes, we did. =C2=A0Everyone agrees structured logging would be the be=
st long
> term solution. =C2=A0However, it's at least 10x the work presented he=
re, plus
> it would be a long process getting everyone to agree.

Maybe even 100 times :)

> This looks like a
> good 95% interim solution and it can be removed when structured loggi=
ng
> makes everything "just work(tm)".

I don't really see that. I think it does not add any real value on top
of a simple udev logging at device discovery.

You would see that in the log:
  [78441.742634]: udevd: sdc: \
  disk/by-id/ata-INTEL_SSDSA1M080G2GN_CVPO0363030V080EGN \
  disk/by-id/scsi-SATA_INTEL_SSDSA1M08CVPO0363030V080EGN \
  disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0 \
  disk/by-id/wwn-0x50015179593f3038

and know exactly _all_ names and all identifiers of the disk at that ti=
me.

Then you see this:
  [78441.742634] storage: really bad things happened to: sdc

and with the earlier message we have all we need to know without any
pretty-name hacks.

All that can be done today already with a single udev rule, even on
many years old distros.

> I have also seen a couple of other attempts at structured logging whi=
ch
> both failed when the people proposing the patches realised how much w=
ork
> it actually was, so I'm a bit sceptical we'll ever get there.

The more paper-over we add the more unlikely it gets. That's what I fea=
r. :)

> But hey,
> you have the enthusiasm, propose it as a KS topic to get agreement th=
at
> we should do it and what the format should be and we can go from ther=
e.

Sure, I'll do that. If needed, I can even make half or a third of it
possible I guess.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
