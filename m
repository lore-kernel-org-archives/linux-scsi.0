From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module
Date: Mon, 6 Sep 2010 08:06:40 -0700
Message-ID: <AANLkTi=r6Zc351P6z87jYKXiYPsf+dduGBC6zWtbWt6D@mail.gmail.com>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
	<20100905203006.GD18411@core.coreip.homeip.net>
	<1283723479.556.135.camel@haakon2.linux-iscsi.org>
	<20100906050816.GD17212@core.coreip.homeip.net>
	<20100906051703.GA2891@suse.de>
	<1283750480.556.196.camel@haakon2.linux-iscsi.org>
	<20100906053845.GG17212@core.coreip.homeip.net>
	<1283752861.556.200.camel@haakon2.linux-iscsi.org>
	<20100906062625.GI17212@core.coreip.homeip.net>
	<AANLkTimhHt78GFbxxjy1tosmebMVg-vKCNoJuqVa+iLH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53620 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab0IFPGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 11:06:41 -0400
In-Reply-To: <AANLkTimhHt78GFbxxjy1tosmebMVg-vKCNoJuqVa+iLH@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Greg KH <gregkh@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, Sep 6, 2010 at 7:48 AM, Richard Sharpe
<realrichardsharpe@gmail.com> wrote:
>> I think what you need is root_device_create() which will allocate a
>> device structure and assign ->release() that is implemented outside =
of
>> your module. This way your module may be unloaded even if there are
>> outstanding references to tcm_loop_primary device.
>
> I am embarrassed to admit that scst_local (or whatever its new name
> will be) probably has the same fault, as it too was based on
> scsi_debug ...
>
> However, I did a search of the 2.6.24.1 source tree and could not fin=
d

Typo alert: 2.6.34.1!

> any instances of root_device_create() being called nor defined. I jus=
t
> double and triple checked the spelling.
>
> Ahhh, I see why. A slightly different search suggests that it is
> root_device_register(const char *name).
>
> From include/linux/device.h:
>
> static inline struct device *root_device_register(const char *name)
> {
> =A0 =A0 =A0 =A0return __root_device_register(name, THIS_MODULE);
> }
>
> Was that the one you were thinking of?
>
>> The rest of devices you create needs to increment module counter or
>> otherwise ensure that their methods stay available until they are
>> cleaned up (->release() is called).
>
> OK, I need to check out how this is done.
>
>> Hope this helps.
>
> Sure does.
>
> --
> Regards,
> Richard Sharpe
>



--=20
Regards,
Richard Sharpe
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
