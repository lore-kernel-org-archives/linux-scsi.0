From: Roland Dreier <roland@kernel.org>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 6 Jul 2011 09:24:56 -0700
Message-ID: <CAL1RGDV4_th87PkobnsFNHUkn5aYiXT3uoT7wNaUvjXa4JLLOg@mail.gmail.com>
References: <CAL1RGDXFER5v08=Wy4Pv7CX0s1RqAThJmEy_0rpDfFCP9xjTJA@mail.gmail.com>
 <Pine.LNX.4.44L0.1107061013440.1995-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:37773 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753093Ab1GFQZR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2011 12:25:17 -0400
Received: by mail-qw0-f45.google.com with SMTP id 8so37326qwj.32
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2011 09:25:16 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1107061013440.1995-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Wed, Jul 6, 2011 at 7:20 AM, Alan Stern <stern@rowland.harvard.edu> =
wrote:
> Looks can be deceiving. =A0Although the scsi_free_queue() is higher u=
p in
> the source file, it actually runs later than this code. =A0That's bec=
ause
> __scsi_remove_device() -- this code -- gets called when the device is
> unregistered from the driver core, whereas
> scsi_device_dev_release_usercontext() -- where the scsi_free_queue() =
is
> moved to -- gets called when the last reference to the device is
> dropped.

OK, I see.  Sorry for the confusion, I just looked at the patch quickly=
 and
assumed that the line moved up in the same function.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
