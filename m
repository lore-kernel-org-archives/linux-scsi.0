From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH v6 9/9] snic:Add Makefile, patch Kconfig, MAINTAINERS
Date: Wed, 27 May 2015 14:25:11 +0300
Message-ID: <5565A997.9070604@plexistor.com>
References: <1432711182-17530-1-git-send-email-nmusini@cisco.com> <1432711182-17530-10-git-send-email-nmusini@cisco.com> <55658BAC.5000009@plexistor.com> <D18B9001.266AC%nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34318 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbE0LZO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2015 07:25:14 -0400
Received: by wicmc15 with SMTP id mc15so90561381wic.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2015 04:25:13 -0700 (PDT)
In-Reply-To: <D18B9001.266AC%nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

On 05/27/2015 01:02 PM, Narsimhulu Musini (nmusini) wrote:
<>
>>> +ifeq ($(CONFIG_SCSI_SNIC_DEBUG_FS), y)
>>> +ccflags-y +=3D -DSNIC_DEBUG_FS
>>
>> Why do you need an extra define here just use
>> CONFIG_SCSI_SNIC_DEBUG_FS in source code directly
> Agree, I just want to use a shorter macro in the source.

Don't do this. It is a convention that if a programmer
sees a CONFIG_XXX he knows that this is settable by a
Kconfig. By making it shorter the programmer will think that
this is dead code because it is not set anywhere.

>>
>>> +snic-y +=3D snic_debugfs.o \
>>> +		snic_trc.o
>>> +endif
>>>
>>
>> snic-$(CONFIG_SCSI_SNIC_DEBUG_FS) +=3D snic_debugfs.o
> If CONFIG_SCSI_SNIC_DEBUGFS is not set, then it leaves a build variab=
le
> =C2=B3snic-" in build system. ifeq() avoids such thing.

That is fine. This is done all over the Kernel Makefile.
There are two tons of these "do nothing make variables"

It the way we do it in the Kernel. (I actually like it)

>>
>> You do not the  ifeq () thing at all
>>
>> Cheers
>> Boaz
>>
> Thanks
> simha
>>
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
