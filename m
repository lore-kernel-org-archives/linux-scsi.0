From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: [LSF/MM TOPIC] Extended copy
Date: Thu, 19 Apr 2018 18:13:59 +0000
Message-ID: <e044c73b5287f0a2a72378573a91c6e8d111706f.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-ID: <787694C8420FD84C88CBC50BDBE4CB3E@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

During a recent discussion about peer-to-peer PCIe transfers it was brought
up that it would be desirable to invoke this functionality from user space.
One possible approach is to add support for an "extended copy" operation to
the block layer and to make it possible to use that functionality from user
space. So far two different approaches have been proposed to add such
functionality to the block layer:
1. Implement extended copy as a single block layer operation. This is not
   compatible with the current device mapper design.
2. Implement extended copy as two separate block layer operations (read +
   write). With this approach there is a risk of starvation, namely if
   resources are low and only one of the two operations is propagated down
   to lower layers.

I propose to discuss this further during the LSF/MM, e.g. whether or not we
should modify the device mapper such that approach (1) can be followed.

More information is available at:
* Jake Edge, Copy Offload, LWN.net, 24 April 2013
  (https://lwn.net/Articles/548347/).
* Jake Edge, Copy Offload, LWN.net, 2 April 2014
  (https://lwn.net/Articles/592094/).
* Martin Petersen, Copy Offload, linux-scsi, 28 May 2014
  (https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg28998.html).
* Mikulas Patocka, ANNOUNCE: SCSI XCOPY support for the kernel and device
  mapper, 15 July 2014
  (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg686111.html).
* Mikulas Patocka, SCSI XCOPY support for the kernel and device mapper,
  linux-scsi mailing list, 22 October 2014
  (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg749113.html /
   https://lkml.org/lkml/2014/10/22/317 /
   http://thread.gmane.org/gmane.linux.kernel/1811151 /
   http://people.redhat.com/~mpatocka/patches/kernel/xcopy/current/).
* Jake Edge, Copy Offload, 25 March 2015 (https://lwn.net/Articles/637436/).
* Mikulas Patocka, [PATCH 0/15] copy offload patches, 10 December 2015
  (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1039890.html /
   https://lkml.org/lkml/2015/12/10/517 /
   https://www.redhat.com/archives/dm-devel/2015-December/msg00117.html).
* Logan Gunthorpe, [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory, 30
  March 2017 (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1367097.html).
* Logan Gunthorpe, [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI
  Memory, 28 February 2018
  (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1623231.html).
* Logan Gunthorpe, [PATCH v3 00/11] Copy Offload in NVMe Fabrics with P2P PCI
  Memory, 12 March 2018
  (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1634545.html).
