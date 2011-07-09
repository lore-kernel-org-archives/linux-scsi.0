From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Sat, 09 Jul 2011 15:11:45 +0900
Message-ID: <4E17F121.3030601@hitachi.com>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp> <20110708145408.GA2283@kroah.com> <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com> <20110708154736.GA7320@kroah.com> <1310140451.3282.85.camel@mulgrave> <CAPXgP12dA72a3ja659GH6uW+ZCMfL6iECaY6ORXwOQ6S5eTvaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56339 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1GIGL5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jul 2011 02:11:57 -0400
In-Reply-To: <CAPXgP12dA72a3ja659GH6uW+ZCMfL6iECaY6ORXwOQ6S5eTvaQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jcm@redhat.com, dle-develop@lists.sourceforge.net, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de

(2011/07/09 1:15), Kay Sievers wrote:
> On Fri, Jul 8, 2011 at 17:54, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> 
>> Yes, we did.  Everyone agrees structured logging would be the best long
>> term solution.  However, it's at least 10x the work presented here, plus
>> it would be a long process getting everyone to agree.
> 
> Maybe even 100 times :)
> 
>> This looks like a
>> good 95% interim solution and it can be removed when structured logging
>> makes everything "just work(tm)".
> 
> I don't really see that. I think it does not add any real value on top
> of a simple udev logging at device discovery.
> 
> You would see that in the log:
>   [78441.742634]: udevd: sdc: \
>   disk/by-id/ata-INTEL_SSDSA1M080G2GN_CVPO0363030V080EGN \
>   disk/by-id/scsi-SATA_INTEL_SSDSA1M08CVPO0363030V080EGN \
>   disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0 \
>   disk/by-id/wwn-0x50015179593f3038
> 
> and know exactly _all_ names and all identifiers of the disk at that time.
> 
> Then you see this:
>   [78441.742634] storage: really bad things happened to: sdc
> 
> and with the earlier message we have all we need to know without any
> pretty-name hacks.

Hmm, yes, we CAN do that, if user carefully sets the udev log-level
high, and saves udev log every boot or device change.

I think the main point of this attempt is to reduce the cost of
those operation, as like as users have done with old un*x way.

If we can use a same device name for same device and can see the
same name on the kernel log, we don't need to pay additional cost
for searching and picking correct entry from udev log.
Of course, it needs updates on some tools too.


> All that can be done today already with a single udev rule, even on
> many years old distros.
> 
>> I have also seen a couple of other attempts at structured logging which
>> both failed when the people proposing the patches realised how much work
>> it actually was, so I'm a bit sceptical we'll ever get there.
> 
> The more paper-over we add the more unlikely it gets. That's what I fear. :)
> 
>> But hey,
>> you have the enthusiasm, propose it as a KS topic to get agreement that
>> we should do it and what the format should be and we can go from there.
> 
> Sure, I'll do that. If needed, I can even make half or a third of it
> possible I guess.

BTW, I'm also interested in that structured error events, from the long
term view and viewpoint of tracers :)
I think we could expand current TRACE_EVENT macro to define those error
events.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
