From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 3/3] [SCSI] ufs: Process SCSI command for UFS device
Date: Mon, 23 Apr 2012 10:44:12 +0530
Message-ID: <CALMYJDtBrh6G3=Aq6grV5O3s1VmH33FzinS2uX_Wfiw3d4Xszw@mail.gmail.com>
References: <1334999359-3181-1-git-send-email-santoshsy@gmail.com>
 <1334999359-3181-3-git-send-email-santoshsy@gmail.com> <1335005949.3081.6.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36012 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2DWFOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 01:14:36 -0400
Received: by iadi9 with SMTP id i9so1518140iad.19
        for <linux-scsi@vger.kernel.org>; Sun, 22 Apr 2012 22:14:36 -0700 (PDT)
In-Reply-To: <1335005949.3081.6.camel@dabdike.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com

On Sat, Apr 21, 2012 at 4:29 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sat, 2012-04-21 at 14:39 +0530, Santosh Y wrote:
>> UFS Spec specifies that the SCSI CDB fields, that are not
>> supported by UFS should be set to zero. It also mentions
>> that some of the CDB fields should be set to default
>> values before issuing the command to a UFS device.
>> Ex: Mode Select - Page Format bit should be set to 1.
>>
>> If the fields are not set to values mentioned in UFS spec,
>> strict CDB checking UFS device may complete the commands
>> with a check condition.
>
> Altering CDB field values in the driver is a bad idea. =A0If you tamp=
er
> with commands in the driver unexpected things will be returned to
> userspace. =A0The general principle is that the mid layer tries to be=
 as
> correct and conservative as possible, but we don't forbid users from
> sending out of spec commands because sometimes that's required.
>
> Are you actually trying to fix a bug, or is this just theoretical? =A0=
If

At this point it is theoretical, since the UFS spec mentions it.
But I guess soon enough I'll run into this problem when I'll start
testing with updated firmwares. Which may strictly follow UFS spec
and expect some of the SCSI CDB fields must be set to UFS specific
default values.

> the former, the way to fix it is to get the mid layer to be more
> conservative about what it does (or possibly add a quirk flag).

As you suggested, will try to find a better approach.

> James
>

--=20
~Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
