From: Feng Li <lifeng1519@gmail.com>
Subject: Re: [Qemu-devel] virtio-console downgrade the virtio-pci-blk performance
Date: Mon, 1 Oct 2018 22:58:24 +0800
Message-ID: <CAEK8JBBDPxTe0k8Nf=7PQ6gjYv4xyqQu=bef5VXmgaLVGw3JUg@mail.gmail.com>
References: <CAEK8JBDPNqTap-LnoBxUZh4Bj9b+VgrsPm53QAivfOsLG7wuGw@mail.gmail.com>
 <20181001114146.GA2508@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001114146.GA2508@work-vm>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@redhat.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, qemu-discuss@nongnu.org, qemu-devel@nongnu.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Dave,
My comments are in-line.

Dr. David Alan Gilbert <dgilbert@redhat.com> =E4=BA=8E2018=E5=B9=B410=E6=9C=
=881=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=887:41=E5=86=99=E9=81=93=EF=
=BC=9A
>
> * Feng Li (lifeng1519@gmail.com) wrote:
> > Hi,
> > I found an obvious performance downgrade when virtio-console combined
> > with virtio-pci-blk.
> >
> > This phenomenon exists in nearly all Qemu versions and all Linux
> > (CentOS7, Fedora 28, Ubuntu 18.04) distros.
> >
> > This is a disk cmd:
> > -drive file=3Discsi://127.0.0.1:3260/iqn.2016-02.com.test:system:fl-isc=
si/1,format=3Draw,if=3Dnone,id=3Ddrive-virtio-disk0,cache=3Dnone,aio=3Dnati=
ve
> > -device virtio-blk-pci,scsi=3Doff,bus=3Dpci.0,addr=3D0x6,drive=3Ddrive-=
virtio-disk0,id=3Dvirtio-disk0,bootindex=3D1,write-cache=3Don
> >
> > If I add "-device
> > virtio-serial-pci,id=3Dvirtio-serial0,bus=3Dpci.0,addr=3D0x5  ", the vi=
rtio
> > disk 4k iops (randread/randwrite) would downgrade from 60k to 40k.
> >
> > In VM, if I rmmod virtio-console, the performance will back to normal.
> >
> > Any idea about this issue?
> >
> > I don't know this is a qemu issue or kernel issue.
>
> It sounds odd;  can you provide more details on:
>   a) The benchmark you're using.
I'm using fio, the config is:
[global]
ioengine=3Dlibaio
iodepth=3D128
runtime=3D120
time_based
direct=3D1

[randread]
stonewall
bs=3D4k
filename=3D/dev/vdb
rw=3Drandread

>   b) the host and the guest config (number of cpus etc)
The qemu cmd is : /usr/libexec/qemu-kvm --device virtio-balloon -m 16G
--enable-kvm -cpu host -smp 8
or qemu-system-x86_64 --device virtio-balloon -m 16G --enable-kvm -cpu
host -smp 8

The result is the same.

>   c) Why are you running it with iscsi back to the same host - why not
>      just simplify the test back to a simple file?
>

Because my ISCSI target could supply a high IOPS performance.
If using a slow disk, the performance downgrade would be not so obvious.
It's easy to be seen, you could try it.


> Dave
>
> >
> > Thanks in advance.
> > --
> > Thanks and Best Regards,
> > Alex
> >
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK



--=20
Thanks and Best Regards,
Feng Li(Alex)
