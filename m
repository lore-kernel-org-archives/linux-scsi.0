From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.36-rc3: EIP is at scsi_init_io+...
Date: Wed, 8 Sep 2010 17:12:37 -0700
Message-ID: <AANLkTikyv10vkg1g+G3LW+nu=0omBpc40KehOUH=YXk2@mail.gmail.com>
References: <20100830184620.GA4818@core2.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab0IIAN1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Sep 2010 20:13:27 -0400
In-Reply-To: <20100830184620.GA4818@core2.telecom.by>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jaxboe@fusionio.com>
Cc: akpm@linux-foundation.org, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hmm. No noise about this one.

Jens, Fujita, James, any comments?

On Mon, Aug 30, 2010 at 11:46 AM, Alexey Dobriyan <adobriyan@gmail.com>=
 wrote:
> Not much of a calltrace, it scrolled away because of hardlockup detec=
tor.
> On the bright side, radeon KMS worked correctly and actually showed i=
t.
>
> $ addr2line -e vmlinux ffffffff812d207b
> drivers/scsi/scsi_lib.c:1015
>
> =A01012 =A0err_exit:
> =A01013 =A0 =A0 =A0 =A0 =A0scsi_release_buffers(cmd);
> =A01014 =A0 =A0 =A0 =A0 =A0scsi_put_command(cmd);
> =A01015 =A0=3D=3D=3D> =A0 =A0cmd->request->special =3D NULL; <=3D=3D=3D
> =A01016 =A0 =A0 =A0 =A0 =A0return error;
> =A01017 =A0}
> =A01018 =A0EXPORT_SYMBOL(scsi_init_io);

I do have to say that it looks rather wrong that it accesses "cmd"
after it has done the "scsi_put_command(cmd)" on it.

I also note that that was introduced pretty recently by commit
610a63498f7 ("scsi: fix discard page leak"), merged during this merge
window. That does look suspicious to me.

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
