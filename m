From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [Qemu-devel] Testing NPIV Feature with Qemu-KVM
Date: Thu, 5 Sep 2013 16:15:58 +0200
Message-ID: <CAJSP0QUEPjqti5ZuJGZs-9o4yXSQWebVJ1O8HMAbf6iv+9FdGw@mail.gmail.com>
References: <20130902123444.GA25765@oc2505588478.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130902123444.GA25765@oc2505588478.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: chandrashekar shastri <cshastri@oc2505588478.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 2, 2013 at 2:34 PM, chandrashekar shastri
<cshastri@oc2505588478.ibm.com> wrote:
> I am testing NPIV feature on upstream Qemu, I have configured the zone
> and able to see the created vport on the storage array.
>
> Since, I am learning on how to setup the NPIV, I haven't created the different zone for
> the vport and the array, I just added in the existing zone.
>
> Now, how do pass the LUN to the qemu, from Dr. Hannes Reineckei mail thread I got to know that lspci command on the host doesn't show the virtual HBA.
>
> I didn't understand why there is limitation on that and if I specify
> /usr/libexec/qemu-kvm -enable-kvm Fedora19 -m 3000 -smp 2 -net nic -net
> \ user -vnc 127.0.0.1:0 -drive if=scsi,file=/dev/sdj
>
> How do I make sure that qemu is using the virtual HBA or (vport)?

>From my limited knowledge of NPIV, after you create the vport on the
host you'll have a new "SCSI host" which scans LUNs.  That means new
SCSI devices appear on the host.

You can use "ls -al /sys/class/scsi_host" to see the SCSI hosts that are active.

You can use "virsh nodedev-list --tree" to see the details of the devices.

This should help you find the NPIV LUNs which can be passed to QEMU.

Stefan
