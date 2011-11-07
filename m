From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Mon, 7 Nov 2011 08:33:46 +0100
Message-ID: <CAO+b5-paS698V61BA8e4ZYstdqR4AKda2EKx4DHqv4gtR2ocPA@mail.gmail.com>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Anton Blanchard <anton@samba.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 7, 2011 at 7:24 AM, Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> I get lots more of these. =A0The obvious commit to point the finger a=
t
> is 3308511c93e6 ("[SCSI] Make scsi_free_queue() kill pending SCSI
> commands") but the root cause may be something different.

It's probably the combination of commit 3308511c93e6 and patch
http://marc.info/?l=3Dlinux-scsi&m=3D132027101521282 that's triggering
that warning: the first commit changed scsi_free_queue() such that it
expects that its callers reset the queuedata pointer but the second
patch introduced a new scsi_free_queue() call that doesn't reset the
queuedata pointer first.

Bart.
