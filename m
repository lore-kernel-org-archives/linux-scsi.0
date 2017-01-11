From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 16:08:31 +0000
Message-ID: <1484150893.2619.1.camel@sandisk.com>
References: <20170111134312.GH6286@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170111134312.GH6286@linux-x5ow.site>
Content-Language: en-US
Content-ID: <1E81A403EF88A24CB57CFF6E30F3B5CD@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "Linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-11 at 14:43 +0100, Johannes Thumshirn wrote:
> I'd like to attend LSF/MM and would like to discuss polling for block
> drivers.
>=20
> Currently there is blk-iopoll but it is neither as widely used as NAPI in
> the networking field and accoring to Sagi's findings in [1] performance
> with polling is not on par with IRQ usage.
>=20
> On LSF/MM I'd like to whether it is desirable to have NAPI like polling i=
n
> more block drivers and how to overcome the currently seen performance
> issues.
>=20
> [1] http://lists.infradead.org/pipermail/linux-nvme/2016-October/006975.h=
t
> ml

A typical Ethernet network adapter delays the generation of an interrupt
after it has received a packet. A typical block device or HBA does not dela=
y
the generation of an interrupt that reports an I/O completion. I think that
is why polling is more effective for network adapters than for block
devices. I'm not sure whether it is possible to achieve benefits similar to
NAPI for block devices without implementing interrupt coalescing in the
block device firmware. Note: for block device implementations that use the
RDMA API, the RDMA API supports interrupt coalescing (see also
ib_modify_cq()).

An example of the interrupt coalescing parameters for a network adapter:

# ethtool -c em1 | grep -E 'rx-usecs:|tx-usecs:'
rx-usecs: 3
tx-usecs: 0

Bart.=
