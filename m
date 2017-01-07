From: "Kwan (Hingkwan) Huen" <kwan.huen@samsung.com>
Subject: RE: [LSF/MM TOPIC] status update on stream IDs
Date: Sat, 07 Jan 2017 01:38:19 +0000
Message-ID: <87B8B7C67ECB1048AE5FA3C64D62B73E1CA94715@SSIEXCH-MB3.ssi.samsung.com>
References: <E86FC13D-0058-473C-B9D6-36B988ABEFFE@dilger.ca>
 <CGME20170106235940epcas4p1b4e8c499548496e1bfabb83e818d5b71@epcas4p1.samsung.com>
 <7B0B6B53-D692-4084-AC63-55138132F509@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-reply-to: <7B0B6B53-D692-4084-AC63-55138132F509@dilger.ca>
Content-language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

It's been a while since Jens posted the write stream ID patches.

https://lwn.net/Articles/679136/

As recall, these patches provide the framework enabling applications to write data along with the stream ID hint. Writes with the same stream ID indicate that data being written related to each other. This simple ID hint allows SSD to organize data more efficiently internally, resulting better performance of the device in the long run and longer device lifespan. However, without a mature spec describing how the device works, and a device that can be easily acquired for testing, these patches were too early back then.

With the new NVMe v1.3 spec draft available now, which includes the latest streams directive feature, and we already have the device available on hand, would like to bring this up again discuss this with the community for opinions. Here are some ideas we have in mind based on what's been done in Jens' patch from the link above. Any comments and suggestions are welcome and appreciated.

Jens' patches already provides the frame work that passes the stream ID from Application to kernel with new system call streamid().  What's needed is that the block device driver will need to pick up the stream ID from the bio and attached to the write command to the device. This completes the whole data path.

The stream management (enable/allocate/open/close, etc.) can go through functions mapped via backing device info (bdi) to allow same function all from application to manage streams in either a SCSI or NVMe device. The actual functions will be implemented in the block device driver and stream status and statistics can be stored, accessed and updated in gendisk struct. 

If anyone wants kernel to assign the ID, the write requests will need to be intercepted to collect statistics of the workload pattern, run some algorithm that determines and applies the write requests to appropriate stream. Or Kernel maintainers would have already good idea for the stream ID assignment. In this case they can just implement it without adding extra stream detection modules. These can be done in the block device with stream mapping stored in gendisk struct.

Regards, 
kwan
________________________________________
From: Linux-nvme [linux-nvme-bounces@lists.infradead.org] on behalf of Andreas Dilger [adilger@dilger.ca]
Sent: Friday, January 06, 2017 3:58 PM
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel; linux-block@vger.kernel.org; linux-nvme@lists.infradead.org; linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] status update on stream IDs

[resend to include other relevant lists]

On Jan 6, 2017, at 4:54 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>
> At LSF/MM'16 and Linux FAST (https://lwn.net/Articles/685499/) there were
> discussions about adding stream IDs to the block/device layer to allow higher
> layers (filesystems, applications) to identify IO streams so lower layers
> (SSDs, hybrid storage, etc.) can make better allocation/placement decisions.
>
> It would be useful to get an update on the state of this work, and discuss
> any obstacles that need to be resolved for getting this code landed.


Cheers, Andreas





