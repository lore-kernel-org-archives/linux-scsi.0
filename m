From: Baruch Even <baruch@ev-en.org>
Subject: Re: [PATCH] mpt2sas: don't handle broadcast primitives
Date: Wed, 24 Jul 2013 23:42:22 +0300
Message-ID: <CAC9+anJ47nx+KyKvp7MT1Hanh-8YNDmSQwtM542dpeOdCVVoUw@mail.gmail.com>
References: <20130719220659.GF29404@logfs.org> <20130719221143.GG29404@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:54446 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3GXUmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jul 2013 16:42:44 -0400
Received: by mail-ea0-f178.google.com with SMTP id l15so482796eak.23
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jul 2013 13:42:43 -0700 (PDT)
In-Reply-To: <20130719221143.GG29404@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Support <support@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, mit@purestorage.com

On Sat, Jul 20, 2013 at 1:11 AM, J=C3=B6rn Engel <joern@logfs.org> wrot=
e:
> On Fri, 19 July 2013 18:06:59 -0400, J=C3=B6rn Engel wrote:
>>
>> The handling of broadcast primitives involves
>> _scsih_block_io_all_device(), which does what the name implies.  I h=
ave
>> observed cases with >60s of blocking io on all devices, caused by a
>> single bad device.  The downsides of this code are obvious, while th=
e
>> upsides are more elusive.
>
> And since this patch looks more like an April fools joke: I have
> gathered a few machine-months of testing, including tortures that
> specifically stress the removed codepaths.  This is a serious
> submission and unless someone can show me a _very_ good reason for
> keeping the deleted code, I would like to get it merged.

This would seem to cause an IO pause through the host whenever there
is a disk removal/insertion or SES (SAS expander) change which seems
like a bad proposition indeed. The part of the work that this code
seems to handle is that when such a change happens something needs to
detect the dead IOs (f.ex. surprise disk removal) but I believe that
the SAS HBA firmware will do that internally already so I do think
this code is needless.

The only thing I'd like not to lose is the actual notification and
ability to log the fact that there was a broadcast notification on the
SAS network.

Baruch
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
