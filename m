From: Zhu Lingshan <lszhu@suse.com>
Subject: Re: how to test pscsi with vhost
Date: Mon, 4 Jul 2016 22:02:45 +0800
Message-ID: <37b51089-f884-664e-b7d0-2ffdedde462d@suse.com>
References: <CAMj5BkgpyoBY0GLoqbDdOa5LeYXsWNVxQUBRaH3AYgERzP-VMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:58787 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbcGDOC6 (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Mon, 4 Jul 2016 10:02:58 -0400
In-Reply-To: <CAMj5BkgpyoBY0GLoqbDdOa5LeYXsWNVxQUBRaH3AYgERzP-VMw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhangfei Gao <zhangfei.gao@gmail.com>, linux-scsi@vger.kernel.org

Hi Zhangfei,

I am also interested in pscsi, you can try kvm, seems you can create a=20
virtualized pscsi device in kvm / virt-manager. I haven't tried that=20
yet, hope this can help.

Thanks,
BR
Zhu Lingshan
=E5=9C=A8 2016/7/4 15:32, Zhangfei Gao =E5=86=99=E9=81=93:
> I am testing with pscsi, but fail to find any block device under /dev=
 to mount.
> The scsi_probe_lun seems can not return correctly, scsi scan: INQUIRY=
 failes.
>
> Is this usage correct?
>
> /backstores/pscsi> create name=3Dpscsi_backend dev=3D/dev/sdb
> Note: block backstore recommended for SCSI block devices
> Created pscsi storage object pscsi_backend using /dev/sdb
>
> /backstores/pscsi> cd /vhost
> /vhost> create wwn=3Dnaa.60014052cc816bf4
> /vhost> cd naa.60014052cc816bf4/tpg1/luns
> /vhost/naa.60...bf4/tpg1/luns> create /backstores/pscsi/pscsi_backend
> Selected LUN 0.
> Created LUN 0.
>
> /vhost/naa.60...bf4/tpg1/luns> cd /
> /> ls
> o- / ................................................................=
=2E.... [...]
>    o- backstores ....................................................=
=2E..... [...]
>    | o- fileio ............................................... [0 Sto=
rage Object]
>    | o- iblock ............................................... [0 Sto=
rage Object]
>    | o- pscsi ................................................ [1 Sto=
rage Object]
>    | | o- pscsi_backend .................................... [/dev/sd=
b activated]
>    | o- rd_mcp ............................................... [0 Sto=
rage Object]
>    o- iscsi .........................................................=
 [0 Targets]
>    o- loopback ......................................................=
 [0 Targets]
>    o- vhost .........................................................=
=2E [1 Target]
>      o- naa.60014052cc816bf4 ........................................=
=2E... [1 TPG]
>        o- tpg1 ........................................... [naa.60014=
05030badd8a]
>          o- luns ....................................................=
=2E... [1 LUN]
>            o- lun0 ............................. [pscsi/pscsi_backend=
 (/dev/sdb)]
> />
>
> /> saveconfig
>
>
> qemu.git/aarch64-softmmu/qemu-system-aarch64 \
>      -enable-kvm -nographic -kernel Image \
>      -device vhost-scsi-pci,wwpn=3Dnaa.60014052cc816bf4 \
>      -m 512 -M virt -cpu host \
>      -append "earlyprintk console=3DttyAMA0 mem=3D512M"
>
>
> root@(none)$ ls /dev
> autofs              ptyp8               tty30               tty62
> console             ptyp9               tty31               tty63
> cpu_dma_latency     ptypa               tty32               tty7
> cuse                ptypb               tty33               tty8
> full                ptypc               tty34               tty9
> fuse                ptypd               tty35               ttyAMA0
> input               ptype               tty36               ttyS0
> kmem                ptypf               tty37               ttyS1
> kmsg                random              tty38               ttyS2
> loop-control        snd                 tty39               ttyS3
> loop0               tty                 tty4                ttyp0
> loop1               tty0                tty40               ttyp1
> loop2               tty1                tty41               ttyp2
> loop3               tty10               tty42               ttyp3
> loop4               tty11               tty43               ttyp4
> loop5               tty12               tty44               ttyp5
> loop6               tty13               tty45               ttyp6
> loop7               tty14               tty46               ttyp7
> mem                 tty15               tty47               ttyp8
> memory_bandwidth    tty16               tty48               ttyp9
> net                 tty17               tty49               ttypa
> network_latency     tty18               tty5                ttypb
> network_throughput  tty19               tty50               ttypc
> null                tty2                tty51               ttypd
> port                tty20               tty52               ttype
> psaux               tty21               tty53               ttypf
> ptmx                tty22               tty54               urandom
> ptyp0               tty23               tty55               vcs
> ptyp1               tty24               tty56               vcs1
> ptyp2               tty25               tty57               vcsa
> ptyp3               tty26               tty58               vcsa1
> ptyp4               tty27               tty59               vga_arbit=
er
> ptyp5               tty28               tty6                vhost-scs=
i
> ptyp6               tty29               tty60               zero
> ptyp7               tty3                tty61
>
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
