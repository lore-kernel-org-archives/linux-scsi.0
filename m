From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Fri, 06 Mar 2015 15:10:43 -0800
Message-ID: <1425683443.28579.31.camel@haakon3.risingtidesystems.com>
References: <54B7E70C.8020304@sandisk.com>
	 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
	 <54E7112F.2080901@sandisk.com>
	 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
	 <54ED8B38.10904@sandisk.com>
	 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
	 <54F1ADAF.90808@sandisk.com>
	 <1425279574.13530.53.camel@haakon3.risingtidesystems.com>
	 <54F6DD3B.4030207@sandisk.com> <20150305132337.GA32341@infradead.org>
	 <54F87F17.30207@sandisk.com> <54F8A2B0.70202@redhat.com>
	 <54F9565A.2080103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54F9565A.2080103@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-03-06 at 08:25 +0100, Bart Van Assche wrote:
> On 03/05/15 19:39, Andy Grover wrote:
> > On 03/05/2015 08:06 AM, Bart Van Assche wrote:
> >> If we would do what Nic proposed - modify SCST such that it uses
> >> configfs instead of sysfs - then that would result in the removal of at
> >> least one SCST feature that is important to its users, namely automatic
> >> population of the configuration filesystem with hardware target port
> >> information. Apparently Nic does not want to convert LIO from configfs
> >> to sysfs.
> > 
> > Clearly configfs is here to stay, but is there anything that says LIO 
> > couldn't have both? Besides the issue at hand, there are some other bits 
> > of useful info in LIO that aren't available because of configfs' 
> > limitations, but that would be possible via sysfs.
> 
> (resending my reply since apparently my previous e-mail didn't make it
> to the lists)
> 
> Hello Andy,
> 
> Let's have a look at FC HBAs. Most FC HBAs have a PCIe connector and
> support NPIV. If an NPIV WWN is configured then that WWN is passed from
> user space to the kernel. The PCIe specification supports hot-plugging.
> Although I'm not sure there exist FC HBAs that support hot-plugging,
> upon hot removal of a PCIe HBA the kernel is notified of this and must
> remove all NPIV WWNs from the filesystem that is used to configure the
> SCSI target subsystem. Since it is not allowed to remove configfs
> directories from inside the kernel I think NPIV is an example of a use
> case that cannot be handled properly when using configfs for configuring
> a SCSI target subsystem, even when combined in some way with sysfs.

Not exactly.  configfs in this context works similar to hotplug remove
of a FC HBA in initiator mode (or a USB drive even) with a mounted
filesystem on one of the LUNs.

That is, a kobject reference is obtained on Scsi_Host->shost_gendev at
/sys/kernel/config/target/qla2xxx_npiv/$NPIV_WWPN/ creation time,
preventing the final device_release() from being called until the last
reference is dropped via rmdir ../target/qla2xxx_npiv/$NPIV_WWPN/.

The practical method is to use a udev script called at hotplug remove
time (similar to USB) to drop the NPIV configfs groups associated with
device(s) being removed, allowing the underlying kernel data structures
to be released.

--nab
