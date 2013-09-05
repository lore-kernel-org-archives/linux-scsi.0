From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Re: [Qemu-devel] Testing NPIV Feature with Qemu-KVM
Date: Thu, 5 Sep 2013 14:59:08 +0000
Message-ID: <52289C3B.5080602@intel.com>
References: <20130902123444.GA25765@oc2505588478.ibm.com>
 <CAJSP0QUEPjqti5ZuJGZs-9o4yXSQWebVJ1O8HMAbf6iv+9FdGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28531 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab3IEO7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 10:59:11 -0400
In-Reply-To: <CAJSP0QUEPjqti5ZuJGZs-9o4yXSQWebVJ1O8HMAbf6iv+9FdGw@mail.gmail.com>
Content-Language: en-US
Content-ID: <D9C5CB467A8B284CAD36F0F36735146E@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: chandrashekar shastri <cshastri@oc2505588478.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 13-09-05 07:15 AM, Stefan Hajnoczi wrote:
> On Mon, Sep 2, 2013 at 2:34 PM, chandrashekar shastri
> <cshastri@oc2505588478.ibm.com> wrote:
>> I am testing NPIV feature on upstream Qemu, I have configured the zone
>> and able to see the created vport on the storage array.
>>
>> Since, I am learning on how to setup the NPIV, I haven't created the different zone for
>> the vport and the array, I just added in the existing zone.
>>
>> Now, how do pass the LUN to the qemu, from Dr. Hannes Reineckei mail thread I got to know that lspci command on the host doesn't show the virtual HBA.
>>
>> I didn't understand why there is limitation on that and if I specify
>> /usr/libexec/qemu-kvm -enable-kvm Fedora19 -m 3000 -smp 2 -net nic -net
>> \ user -vnc 127.0.0.1:0 -drive if=scsi,file=/dev/sdj
>>
>> How do I make sure that qemu is using the virtual HBA or (vport)?
>  From my limited knowledge of NPIV, after you create the vport on the
> host you'll have a new "SCSI host" which scans LUNs.  That means new
> SCSI devices appear on the host.
>
> You can use "ls -al /sys/class/scsi_host" to see the SCSI hosts that are active.
>
> You can use "virsh nodedev-list --tree" to see the details of the devices.
>
> This should help you find the NPIV LUNs which can be passed to QEMU.
>

Also, there will be a /sys/class/fc_host, associated with the scsi_host. 
It will have a port_type, that when read, should show "NPIV VPORT".

//Rob