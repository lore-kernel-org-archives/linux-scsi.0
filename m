From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
Date: Tue, 16 Nov 2010 22:44:14 -0800
Message-ID: <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
References: <20101117062958.GA2894@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101117062958.GA2894@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 16, 2010 at 10:29 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> + =A0 =A0 =A0 spin_lock(shost->host_lock);
> + =A0 =A0 =A0 scsi_cmd_get_serial(shost, cmd);
> =A0 =A0 =A0 =A0spin_unlock(shost->host_lock);

This is just sad.

How important is that serial number? So important that we need to do a
spinlock over it here? And it _must_ be per-shost?

Because if you made it per-ap, you could easily just move that logic
down to after you get the ap lock.

Just add a "unsigned int serial_number" into the ata_port struct, and
do the same (trivial) logic for getting a non-zero serial number
there:

  n =3D ap->serial_number;
  if (!++n)
    n =3D 1
  ap->serial_number =3D n;
  cmd->serial_number =3D n;

or something. And then you'd _really_ not need to touch that totally
pointless host lock at all.

               Linus
