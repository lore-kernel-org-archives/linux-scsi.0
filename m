From: Borislav Petkov <bp@suse.de>
Subject: Re: hpsa failure with 4.3.0-rc1
Date: Wed, 30 Sep 2015 11:14:11 +0200
Message-ID: <20150930091411.GA6045@pd.tnic>
References: <560B9202.9080703@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbbI3JOx (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 05:14:53 -0400
Content-Disposition: inline
In-Reply-To: <560B9202.9080703@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Don Brace <don.brace@pmcs.com>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Joerg Roedel <jroedel@suse.de>

On Wed, Sep 30, 2015 at 09:40:50AM +0200, Hannes Reinecke wrote:
> Hi all,
>=20
> trying to boot 4.3.0-rc1 on a system with hpsa results in a swiotlb
> failure:
>=20
> hpsa 0000:22:00.0: Logical aborts not supported
> hpsa 0000:22:00.0: HP SSD Smart Path aborts not supported
> hpsa 0000:22:00.0: swiotlb buffer is full (sz: 786432 bytes)
> swiotlb: coherent allocation failed for device 0000:22:00.0 size=3D
> 786432
> CPU: 43 PID: 566 Comm: systemd-udevd Not tainted 4.3.0-rc1-default+ #=
358
> Hardware name: HP ProLiant BL660c Gen8, BIOS I32 08/20/2012
>  ffff88181c314098 ffff8810194cba40 ffffffff8138fad2 00000000000c0
>  ffff8810194cba80 ffffffff813ba3d9 ffff881000000008 0000000000000
> 220
>  ffff88181c314098 00000000000c0000 ffff8810184101e8 ffff881018410
> 000
> Call Trace:
>  [<ffffffff8138fad2>] dump_stack+0x4b/0x69
>  [<ffffffff813ba3d9>] swiotlb_alloc_coherent+0x149/0x160
>  [<ffffffff8104b7ae>] x86_swiotlb_alloc_coherent+0x3e/0x50
>  [<ffffffffa030ef45>] hpsa_init_one+0x915/0x1c90 [hpsa]
>  [<ffffffff810d694c>] ? rcu_read_lock_sched_held+0x8c/0xa0
>  [<ffffffff813d8550>] local_pci_probe+0x40/0xa0
>  [<ffffffff813d951b>] ? pci_match_device+0xdb/0x100
>=20
> 4.2.0-rc3 worked fine here.
> Needless to say, enabling IOMMU makes the problem go away :-)

Hmm, I don't see anything relevant having changed in swiotlb since then=
:

$ git log --oneline v4.2-rc3..HEAD $(git ls-files arch/x86/ drivers/ in=
clude/ | grep swiotlb)
33e247c7e58d Merge branch 'akpm' (patches from Andrew)
6894258eda2f dma-mapping: consolidate dma_{alloc,free}_{attrs,coherent}
32e09870eedf xen: Make clear that swiotlb and biomerge are dealing with=
 DMA address

Maybe my regex is missing some or the problem is somewhere else...

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
