From: Andrea Arcangeli <andrea@suse.de>
Subject: Re: [PATCH] sd varyio fix
Date: Mon, 29 Jul 2002 00:28:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020728222833.GB1201@dualathlon.random>
References: <20020715221604.GA10274@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020715221604.GA10274@nbkurt.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linux SCSI list <linux-scsi@vger.kernel.org>, Dave Jones <davej@suse.de>

On Tue, Jul 16, 2002 at 12:16:04AM +0200, Kurt Garloff wrote:
> Hi Marcelo,
> 
> another one: The bit shift for vary io in the sd driver was wrong.
> I don't know whether it has much impact, but it should be fixed anyway.
> 
> Patch against 2.4.19rc1 attached.
> 
> Regards,
> -- 
> Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
> Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
> Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
>  (See mail header or public key servers for PGP2 and GPG public keys.)

> --- drivers/scsi/sd.c.orig	Wed Jun 12 11:39:47 2002
> +++ drivers/scsi/sd.c	Tue Jul 16 00:12:40 2002
> @@ -1345,7 +1345,7 @@
>  	if (SDp->host->hostt->can_do_varyio) {
>  		if (blkdev_varyio[SD_DISK_MAJOR(i)] == NULL) {
>  			blkdev_varyio[SD_DISK_MAJOR(i)] = 
> -				sd_varyio + ((i / SCSI_DISKS_PER_MAJOR) >> 8);
> +				sd_varyio + ((i / SCSI_DISKS_PER_MAJOR) << 8);
>  		}
>  		memset(blkdev_varyio[SD_DISK_MAJOR(i)] + (devnum << 4), 1, 16);
>  	}

I avoided to check this scsi part of the varyio patch when I merged it
so it's not surprising we have problems there. This isn't so nice
because it can enable rawio on devices that doesn't explicitly say that
varyio is supported by them. This part of the code is horrible and
impossible to understand without full context of the scsi band aid over
band aid so this is a second reason I'm not so surprised we bugs there.

For istance this doesn't make any sense to me:

@@ -1268,6 +1277,8 @@ static int sd_detect(Scsi_Device * SDp)
 	return 1;
 }
 
+#define SD_DISK_MAJOR(i)	SD_MAJOR((i) >> 4)
+
 static int sd_attach(Scsi_Device * SDp)
 {
         unsigned int devnum;

Why doesn't SD_DISK_MAJOR match SD_MAJOR and there is this magic
hardcoded ">> 4" of difference. why the SD_MAJOR is different from the
SD_DISK_MAJOR? The major is only one thing, you cannot shift it right of
4.

I'm not going to spend time learning this horror code myself, I'm busy
with other things at the moment, so I would appreciate if somebody with
prior knowledge  on this code could explain the above nosense with a few
words and I'd rely on somebody who just studied it and that confirms me
that the above is completely correct, I'm not very confortable by only
applying the above << 8, I don't see why it's not using the same logic
as:


	for (i = 0; i < N_USED_SD_MAJORS; i++) {
		blksize_size[SD_MAJOR(i)] = sd_blocksizes + i * (SCSI_DISKS_PER_MAJOR << 4);
		hardsect_size[SD_MAJOR(i)] = sd_hardsizes + i * (SCSI_DISKS_PER_MAJOR << 4);
		max_sectors[SD_MAJOR(i)] = sd_max_sectors + i * (SCSI_DISKS_PER_MAJOR << 4);
	}


infact I would be much more confortable if the initialization of the
[SD_MAJOR] arrays would be done over there rather than at sd_attach time.
the sd_attach should only memset/memclear the array. Furthmore I don't
see any memset back to zero at sd_detach and that's another potentail
runtime breakage as severe as the current bug (actually more severe
since it can trigger with only one device at time).

So I would appreciate a full audit of the scsi part of the varyio patch
with some explanations of those bits of the scsi code (i.e.
SD_DISK_MAJOR semantics).

If nobody can explain why the above is fully correct (including the
sd_detach that should memset the array back to zero and that I don't
see) I guess I will rewrite the sd.c thing sanely so that those >> 4  << 8
devnum << 4, memset(16) hardcoded numbers goes all away from the scsi
code so that there will be a chance for a non full time scsi developer
to read that code without spending some hour to reverse engeneer the
implicit dependencies.

Comments?

Andrea
