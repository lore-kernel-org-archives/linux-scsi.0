From: santosh prasad nayak <santoshprasadnayak@gmail.com>
Subject: Re: [PATCH] [SCSI] sd: set BIO_MAPPED_INTEGRITY bit correctly in sd_dif_prepare().
Date: Wed, 7 Mar 2012 21:37:01 +0530
Message-ID: <CAOD=uF6nG=r9GLtzdds8T_67RmOyOhD756Kj_EGXsuDgfQR7nA@mail.gmail.com>
References: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120307155624.GC19570@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44226 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CGQHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2012 11:07:02 -0500
In-Reply-To: <20120307155624.GC19570@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, mkp@mkp.net

On Wed, Mar 7, 2012 at 9:26 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Mar 07, 2012 at 08:11:35PM +0530, santosh nayak wrote:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>> Value of BIO_MAPPED_INTEGRITY is 11. Intention was to set the 11th b=
it.
>
> Also, can we introduce:
>
> #define bio_set_flag(bio, flag) ((bio)->bi_flags |=3D (1 << (flag)))
>

  set_bit() can do the same task.
  Can you please explain why do we need a new macro ?


> Then hunt down and kill all the places that manipulate bi_flags by ha=
nd?
> We might also need:
>
> #define bio_set_flag_atomic(bio, flag) set_bit(&(bio)->bi_flags, (fla=
g))

for atomic operation we have __set_bit() . Is there any need to define
to new macro ?


Regards
Santosh

>
> --
> Matthew Wilcox =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Int=
el Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours. =A0We can't possibly take s=
uch
> a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
