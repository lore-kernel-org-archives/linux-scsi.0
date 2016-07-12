From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v3 2/2] libata-scsi: better style in ata_msense_caching()
Date: Wed, 13 Jul 2016 01:54:27 +0800
Message-ID: <CAGnHSE=ye+gf8PdBs4A-cyEFD=mF_D67YsNgx1XHN2xMOny-mQ@mail.gmail.com>
References: <5784f28c.c4d0620a.69372.3df2@mx.google.com> <20160712144824.GD3190@htj.duckdns.org>
 <CAGnHSEn-S1G55uNE9Wm9026Gny0f_Udu6F2auvDJksEKg3p_=g@mail.gmail.com> <20160712172052.GL3190@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:33159 "EHLO
	mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbcGLRye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 13:54:34 -0400
In-Reply-To: <20160712172052.GL3190@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Sure. I was checking whether other MODE SENSE functions have the same
problem. It turns out the recently rewritten ata_msense_ctl_mode() is
actually bugged, seemingly because of the original arcane style. Sent
the patch for that, fixing it in the original style.

So I am wondering if I should further fix the style of
ata_msense_ctl_mode() when I resend this patch. If so, how should I
make `dev->flags & ATA_DFLAG_D_SENSE` a boolean, so that it can be bit
shifted? Double negation? Type casting? Or should I just use an `else
if` clause?

On 13 July 2016 at 01:20, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Jul 13, 2016 at 12:20:40AM +0800, Tom Yan wrote:
>> First of all "changeable" is the "version" of mode page requested by
>> the user, while ata_id_*_enabled(id) are the value of setting reported
>> by the device. I think it's ugly and confusing to check values of
>> totally different nature "together".
>>
>> The worse thing is, since we have implemented MODE SELECT /
>> ata_mselect_caching() to serve exclusively the write cache feature,
>> the difference in the two if-conditions made the code look even more
>> arcane.
>>
>> In my version, it is clear that when the user request the changeable
>> mode page, the value for the WCE bit will always be "1" / "y", since
>> we've made (only) it changeable in ata_mselect_caching(); and when the
>> user request the current / default page, the values reflect the
>> settings from the drive.
>
> Can you please put the rationale in the patch description and repost?
>
> Thanks.
>
> --
> tejun
