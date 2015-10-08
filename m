From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH for-next] scsi: qla2xxx: Hide unavailable firmware
Date: Fri, 9 Oct 2015 10:10:25 +1100
Message-ID: <CAGRGNgXAO-ROeJ-OEcUH6v-1T5A+wkdQBk3sQAw0ytRt3K+ASQ@mail.gmail.com>
References: <1432252831-7551-1-git-send-email-julian.calaby@gmail.com>
 <CAGRGNgVSuMD3B4B0Jr-TOT5Kr4NRvJR=0e3tu71OxUzQtrq2sg@mail.gmail.com>
 <56153682.1030801@gmail.com> <CAGRGNgUBWaxVi6dWG=NAb3t+U_J+EBrV=pgxRmNqKtsKSsEWCg@mail.gmail.com>
 <D23B3DD9.BA955%himanshu.madhani@qlogic.com> <1444321066.2312.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34729 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbbJHXKp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2015 19:10:45 -0400
Received: by igcpb10 with SMTP id pb10so26270874igc.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2015 16:10:44 -0700 (PDT)
In-Reply-To: <1444321066.2312.1.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Firmware Maintainers <linux-firmware@kernel.org>

Hi James,

On Fri, Oct 9, 2015 at 3:17 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2015-10-08 at 15:46 +0000, Himanshu Madhani wrote:
>>
>> On 10/7/15, 4:41 PM, "Julian Calaby" <julian.calaby@gmail.com> wrote:
>>
>> >Hi Xose,
>> >
>> >On Thu, Oct 8, 2015 at 2:13 AM, Xose Vazquez Perez
>> ><xose.vazquez@gmail.com> wrote:
>> >> On Fri, May 22, 2015 at 10:00 AM, Julian Calaby
>> >><julian.calaby@gmail.com> wrote:
>> >>
>> >>> Some qla2xxx devices have firmware stored in flash on the device,
>> >>> however for debugging and triage purposes, Qlogic staff like to
>> >>> be able to load known-good versions of these firmwares through
>> >>> request_firmware().
>> >>>
>> >>> These firmware files were never distributed and are unlikely to ever
>> >>> be released publically, so to hide these missing firmware files from
>> >>> scripts which check such things, (e.g. Debian's initramfs-tools) put
>> >>> them behind a new EXPERT Kconfig option.
>> >>
>> >>
>> >> What is state of this patch ?
>> >
>> >Apparently nobody cared, either from qLogic or linux-scsi.
>> >
>> >I'm not overly fussed whether it goes in or not, it was more a point
>> >in the discussion that proceeded it, however it does solve the
>> >problems in the discussion that preceded it.
>>
>> This patch Looks good.
>>
>> Acked-By: Himanshu Madhani <himanshu.madhani@qlogic.com>
>
> Actually, this isn't helpful.  You now add another option over which the
> distributions have to make a choice.  Is this interface necessary and
> useful?  If yes, then it should be compiled in and if not, just remove
> it ... don't do death by 1000 Kconfig options.

The original issue here was that the qla2xxx driver specifies two
firmware files which are not publicly available.

They aren't publicly available because the hardware that uses them
always stores it's firmware in flash.

The firmware files are specified in the driver because qLogic support
likes to be able to load a known-good firmware file from disk for
debugging faulty hardware.

Some distributions (Debian is a good example) will complain vocally
about missing firmware files when installing kernels or producing
initramfs images.

This patch was intended as an ugly compromise between all of this.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
