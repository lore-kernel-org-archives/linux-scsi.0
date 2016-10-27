From: Christoph Hellwig <hch@lst.de>
Subject: Re: A question regarding "multiple SGL"
Date: Thu, 27 Oct 2016 09:10:09 +0200
Message-ID: <20161027071009.GA6434@lst.de>
References: <20161027005230.9904DC00097@webmail.sinamail.sina.com.cn> <20161027064115.GA5864@lst.de> <B78D1A958924E54594997EFF975251625BD49445@szxeml592-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B78D1A958924E54594997EFF975251625BD49445@szxeml592-mbx.china.huawei.com>
Sender: linux-block-owner@vger.kernel.org
To: "Qiuxin (robert)" <qiuxin@huawei.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith Busch <keith.busch@intel.com>, Doug Ledford <dledford@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Laurence Oberman <loberman@redhat.com>, Tiger zhao <tiger.zhao@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Hi Robert,

please explain your use cases that isn't handled.  The one and only
reason to set MSDBD to 1 is to make the code a lot simpler given that
there is no real use case for supporting more.

RDMA uses memory registrations to register large and possibly
discontiguous data regions for a single rkey, aka single SGL descriptor
in NVMe terms.  There would be two reasons to support multiple SGL
descriptors:  a) to support a larger I/O size than supported by a single
MR, or b) to support a data region format not mappable by a single
MR.

iSER only supports a single rkey (or stag in IETF terminology) and has
been doing fine on a) and mostly fine on b).   There are a few possible
data layouts not supported by the traditional IB/iWarp FR WRs, but the
limit is in fact exactly the same as imposed by the NVMe PRPs used for
PCIe NVMe devices, so the Linux block layer has support to not generate
them.  Also with modern Mellanox IB/RoCE hardware we can actually
register completely arbitrary SGLs.  iSER supports using this registration
mode already with a trivial code addition, but for NVMe we didn't have a
pressing need yet.
