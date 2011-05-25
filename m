From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
Date: Wed, 25 May 2011 13:03:38 -0700
Message-ID: <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com>
 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com>
 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
 <4DDD55D6.1080909@fusionio.com> <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>
Sender: linux-kernel-owner@vger.kernel.org
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 25, 2011 at 12:52 PM, Parag Warudkar <parag.lkml@gmail.com>=
 wrote:
>
> +static inline int sdev_early_check(struct scsi_device *sdev)
> +{
> + =A0 =A0 =A0 if (!sdev || sdev->sdev_state =3D=3D SDEV_DEL
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 || sdev->sdev_state > SDEV_QUIESCE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENXIO;
> + =A0 =A0 =A0 return 0;
> +}

Can somebody explain why it's those states, and nothing else?

Quite frankly, if it's about "don't oops on sdev->queue not existing",
then test for that. Not for some random and uncommented list of
states.

                          Linus
