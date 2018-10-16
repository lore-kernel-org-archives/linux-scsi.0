From: Feng Li <lifeng1519@gmail.com>
Subject: Re: [Qemu-devel] virtio-console downgrade the virtio-pci-blk performance
Date: Tue, 16 Oct 2018 10:26:08 +0800
Message-ID: <CAEK8JBDpy+AvCfEZ5UAM+FojFBK2Cy1BqsrctkX-6QD6jvTK4w@mail.gmail.com>
References: <CAEK8JBDPNqTap-LnoBxUZh4Bj9b+VgrsPm53QAivfOsLG7wuGw@mail.gmail.com>
 <20181001114146.GA2508@work-vm> <CAEK8JBBDPxTe0k8Nf=7PQ6gjYv4xyqQu=bef5VXmgaLVGw3JUg@mail.gmail.com>
 <CAEK8JBC-HKGb43UynWx69Lj-y48Em038eNMpOb7G72XfLF_mDg@mail.gmail.com> <20181015185115.GA3247@grmbl.mre>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181015185115.GA3247@grmbl.mre>
Sender: linux-kernel-owner@vger.kernel.org
To: amit@kernel.org
Cc: dgilbert@redhat.com, virtualization@lists.linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>, qemu-discuss@nongnu.org, qemu-devel@nongnu.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Amit,

Thanks for your response.

See inline comments.

Amit Shah <amit@kernel.org> =E4=BA=8E2018=E5=B9=B410=E6=9C=8816=E6=97=A5=E5=
=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=882:51=E5=86=99=E9=81=93=EF=BC=9A
>
> On (Thu) 11 Oct 2018 [18:15:41], Feng Li wrote:
> > Add Amit Shah.
> >
> > After some tests, we found:
> > - the virtio serial port number is inversely proportional to the iSCSI
> > virtio-blk-pci performance.
> > If we set the virio-serial ports to 2("<controller
> > type=3D'virtio-serial' index=3D'0' ports=3D'2'/>), the performance down=
grade
> > is minimal.
>
> If you use multiple virtio-net (or blk) devices -- just register, not
> necessarily use -- does that also bring the performance down?  I

Yes. We just register the virtio-serial, and not use it, it brings the
virtio-blk performance down.

> suspect it's the number of interrupts that get allocated for the
> ports.  Also, could you check if MSI is enabled?  Can you try with and
> without?  Can you also reproduce if you have multiple virtio-serial
> controllers with 2 ports each (totalling up to whatever number that
> reproduces the issue).

This is the full cmd:
/usr/libexec/qemu-kvm -name
guest=3D6a798fde-c5d0-405a-b495-f2726f9d12d5,debug-threads=3Don -machine
pc-i440fx-rhel7.5.0,accel=3Dkvm,usb=3Doff,dump-guest-core=3Doff -cpu host -=
m
size=3D2097152k,slots=3D255,maxmem=3D4194304000k   -uuid
702bb5bc-2aa3-4ded-86eb-7b9cf5c1e2d9 -drive
file.driver=3Discsi,file.portal=3D127.0.0.1:3260,file.target=3Diqn.2016-02.=
com.smartx:system:zbs-iscsi-datastore-1537958580215k,file.lun=3D74,file.tra=
nsport=3Dtcp,format=3Draw,if=3Dnone,id=3Ddrive-virtio-disk0,cache=3Dnone,ai=
o=3Dnative
-device virtio-blk-pci,scsi=3Doff,bus=3Dpci.0,addr=3D0x6,drive=3Ddrive-virt=
io-disk0,id=3Dvirtio-disk0,bootindex=3D1,write-cache=3Don
-drive file.driver=3Discsi,file.portal=3D127.0.0.1:3260,file.target=3Diqn.2=
016-02.com.smartx:system:zbs-iscsi-datastore-1537958580215k,file.lun=3D182,=
file.transport=3Dtcp,format=3Draw,if=3Dnone,id=3Ddrive-virtio-disk1,cache=
=3Dnone,aio=3Dnative
-device virtio-blk-pci,scsi=3Doff,bus=3Dpci.0,addr=3D0x7,drive=3Ddrive-virt=
io-disk1,id=3Dvirtio-disk1,bootindex=3D2,write-cache=3Don
-device virtio-balloon-pci,id=3Dballoon0,bus=3Dpci.0,addr=3D0x8 -vnc
0.0.0.0:100 -netdev user,id=3Dfl.1,hostfwd=3Dtcp::5555-:22 -device
e1000,netdev=3Dfl.1 -msg timestamp=3Don   -device
virtio-serial-pci,id=3Dvirtio-serial0,bus=3Dpci.0,addr=3D0x5

qemu version: qemu-kvm-2.10.0-21

I guess the MSI is enabled, I could see some logs:
[    2.230194] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    3.556376] virtio-pci 0000:00:05.0: irq 24 for MSI/MSI-X

The issue could reproduce easily, using one virtio-serial with 31
ports, and this is the default port num.
I think it's not necessary to reproduce with multiple controllers.

>
>                 Amit
>
> >
> > - use local disk/ram disk as virtio-blk-pci disk, the performance
> > downgrade is still obvious.
> >
> >
> > Could anyone give some help about this issue?
> >
> > Feng Li <lifeng1519@gmail.com> =E4=BA=8E2018=E5=B9=B410=E6=9C=881=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=8810:58=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hi Dave,
> > > My comments are in-line.
> > >
> > > Dr. David Alan Gilbert <dgilbert@redhat.com> =E4=BA=8E2018=E5=B9=B410=
=E6=9C=881=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=887:41=E5=86=99=E9=81=
=93=EF=BC=9A
> > > >
> > > > * Feng Li (lifeng1519@gmail.com) wrote:
> > > > > Hi,
> > > > > I found an obvious performance downgrade when virtio-console comb=
ined
> > > > > with virtio-pci-blk.
> > > > >
> > > > > This phenomenon exists in nearly all Qemu versions and all Linux
> > > > > (CentOS7, Fedora 28, Ubuntu 18.04) distros.
> > > > >
> > > > > This is a disk cmd:
> > > > > -drive file=3Discsi://127.0.0.1:3260/iqn.2016-02.com.test:system:=
fl-iscsi/1,format=3Draw,if=3Dnone,id=3Ddrive-virtio-disk0,cache=3Dnone,aio=
=3Dnative
> > > > > -device virtio-blk-pci,scsi=3Doff,bus=3Dpci.0,addr=3D0x6,drive=3D=
drive-virtio-disk0,id=3Dvirtio-disk0,bootindex=3D1,write-cache=3Don
> > > > >
> > > > > If I add "-device
> > > > > virtio-serial-pci,id=3Dvirtio-serial0,bus=3Dpci.0,addr=3D0x5  ", =
the virtio
> > > > > disk 4k iops (randread/randwrite) would downgrade from 60k to 40k=
.
> > > > >
> > > > > In VM, if I rmmod virtio-console, the performance will back to no=
rmal.
> > > > >
> > > > > Any idea about this issue?
> > > > >
> > > > > I don't know this is a qemu issue or kernel issue.
> > > >
> > > > It sounds odd;  can you provide more details on:
> > > >   a) The benchmark you're using.
> > > I'm using fio, the config is:
> > > [global]
> > > ioengine=3Dlibaio
> > > iodepth=3D128
> > > runtime=3D120
> > > time_based
> > > direct=3D1
> > >
> > > [randread]
> > > stonewall
> > > bs=3D4k
> > > filename=3D/dev/vdb
> > > rw=3Drandread
> > >
> > > >   b) the host and the guest config (number of cpus etc)
> > > The qemu cmd is : /usr/libexec/qemu-kvm --device virtio-balloon -m 16=
G
> > > --enable-kvm -cpu host -smp 8
> > > or qemu-system-x86_64 --device virtio-balloon -m 16G --enable-kvm -cp=
u
> > > host -smp 8
> > >
> > > The result is the same.
> > >
> > > >   c) Why are you running it with iscsi back to the same host - why =
not
> > > >      just simplify the test back to a simple file?
> > > >
> > >
> > > Because my ISCSI target could supply a high IOPS performance.
> > > If using a slow disk, the performance downgrade would be not so obvio=
us.
> > > It's easy to be seen, you could try it.
> > >
> > >
> > > > Dave
> > > >
> > > > >
> > > > > Thanks in advance.
> > > > > --
> > > > > Thanks and Best Regards,
> > > > > Alex
> > > > >
> > > > --
> > > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > >
> > >
> > >
> > > --
> > > Thanks and Best Regards,
> > > Feng Li(Alex)
> >
> >
> >
> > --
> > Thanks and Best Regards,
> > Feng Li(Alex)
>
>                 Amit
> --
> http://amitshah.net/



--=20
Thanks and Best Regards,
Feng Li(Alex)
