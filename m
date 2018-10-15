From: Amit Shah <amit@kernel.org>
Subject: Re: virtio-console downgrade the virtio-pci-blk
 performance
Date: Mon, 15 Oct 2018 20:51:15 +0200
Message-ID: <20181015185115.GA3247@grmbl.mre>
References: <CAEK8JBDPNqTap-LnoBxUZh4Bj9b+VgrsPm53QAivfOsLG7wuGw@mail.gmail.com>
	<20181001114146.GA2508@work-vm>
	<CAEK8JBBDPxTe0k8Nf=7PQ6gjYv4xyqQu=bef5VXmgaLVGw3JUg@mail.gmail.com>
	<CAEK8JBC-HKGb43UynWx69Lj-y48Em038eNMpOb7G72XfLF_mDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <CAEK8JBC-HKGb43UynWx69Lj-y48Em038eNMpOb7G72XfLF_mDg@mail.gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org
Sender: "Qemu-devel"
	<qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
To: Feng Li <lifeng1519@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, amit@kernel.org, qemu-devel@nongnu.org, linux-kernel <linux-kernel@vger.kernel.org>, qemu-discuss@nongnu.org, virtualization@lists.linux-foundation.org, dgilbert@redhat.com
List-Id: linux-scsi@vger.kernel.org

On (Thu) 11 Oct 2018 [18:15:41], Feng Li wrote:
> Add Amit Shah.
> 
> After some tests, we found:
> - the virtio serial port number is inversely proportional to the iSCSI
> virtio-blk-pci performance.
> If we set the virio-serial ports to 2("<controller
> type='virtio-serial' index='0' ports='2'/>), the performance downgrade
> is minimal.

If you use multiple virtio-net (or blk) devices -- just register, not
necessarily use -- does that also bring the performance down?  I
suspect it's the number of interrupts that get allocated for the
ports.  Also, could you check if MSI is enabled?  Can you try with and
without?  Can you also reproduce if you have multiple virtio-serial
controllers with 2 ports each (totalling up to whatever number that
reproduces the issue).

		Amit

> 
> - use local disk/ram disk as virtio-blk-pci disk, the performance
> downgrade is still obvious.
> 
> 
> Could anyone give some help about this issue?
> 
> Feng Li <lifeng1519@gmail.com> 于2018年10月1日周一 下午10:58写道：
> >
> > Hi Dave,
> > My comments are in-line.
> >
> > Dr. David Alan Gilbert <dgilbert@redhat.com> 于2018年10月1日周一 下午7:41写道：
> > >
> > > * Feng Li (lifeng1519@gmail.com) wrote:
> > > > Hi,
> > > > I found an obvious performance downgrade when virtio-console combined
> > > > with virtio-pci-blk.
> > > >
> > > > This phenomenon exists in nearly all Qemu versions and all Linux
> > > > (CentOS7, Fedora 28, Ubuntu 18.04) distros.
> > > >
> > > > This is a disk cmd:
> > > > -drive file=iscsi://127.0.0.1:3260/iqn.2016-02.com.test:system:fl-iscsi/1,format=raw,if=none,id=drive-virtio-disk0,cache=none,aio=native
> > > > -device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x6,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1,write-cache=on
> > > >
> > > > If I add "-device
> > > > virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x5  ", the virtio
> > > > disk 4k iops (randread/randwrite) would downgrade from 60k to 40k.
> > > >
> > > > In VM, if I rmmod virtio-console, the performance will back to normal.
> > > >
> > > > Any idea about this issue?
> > > >
> > > > I don't know this is a qemu issue or kernel issue.
> > >
> > > It sounds odd;  can you provide more details on:
> > >   a) The benchmark you're using.
> > I'm using fio, the config is:
> > [global]
> > ioengine=libaio
> > iodepth=128
> > runtime=120
> > time_based
> > direct=1
> >
> > [randread]
> > stonewall
> > bs=4k
> > filename=/dev/vdb
> > rw=randread
> >
> > >   b) the host and the guest config (number of cpus etc)
> > The qemu cmd is : /usr/libexec/qemu-kvm --device virtio-balloon -m 16G
> > --enable-kvm -cpu host -smp 8
> > or qemu-system-x86_64 --device virtio-balloon -m 16G --enable-kvm -cpu
> > host -smp 8
> >
> > The result is the same.
> >
> > >   c) Why are you running it with iscsi back to the same host - why not
> > >      just simplify the test back to a simple file?
> > >
> >
> > Because my ISCSI target could supply a high IOPS performance.
> > If using a slow disk, the performance downgrade would be not so obvious.
> > It's easy to be seen, you could try it.
> >
> >
> > > Dave
> > >
> > > >
> > > > Thanks in advance.
> > > > --
> > > > Thanks and Best Regards,
> > > > Alex
> > > >
> > > --
> > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >
> >
> >
> > --
> > Thanks and Best Regards,
> > Feng Li(Alex)
> 
> 
> 
> --
> Thanks and Best Regards,
> Feng Li(Alex)

		Amit
-- 
http://amitshah.net/
