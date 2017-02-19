From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv2] scsi: use 'scsi_device_from_queue()' for
	scsi_dh
Date: Sun, 19 Feb 2017 00:59:06 -0500
Message-ID: <CAMM=eLfpNCxj4yegh3vNGYawh0X+-ya3ZHjoPC9ogRKGa8azFw@mail.gmail.com>
References: <1487257943-72264-1-git-send-email-hare@suse.de>
	<20170216170519.GA9630@localhost.localdomain>
	<c889eed7-6262-2e54-0b1e-1d833c033324@suse.de>
	<20170217082752.GA18258@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170217082752.GA18258@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 17, 2017 at 3:27 AM, Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Feb 17, 2017 at 09:06:14AM +0100, Hannes Reinecke wrote:
> > We could, but why?
> > ATM we're only having SCSI devices able to use device handler; adding
> > another layer of indirection doesn't solve anything here.
> > Moving the infrastructure one level up will only make sense if we're
> > getting non-SCSI device handler (ANA?), but until then I'd think it's
> > just overengineering.
>
> Agreed.  Independent of what does the balancing between queues hardware
> handler should be attached by the low-level driver for any future
> transport without any control from DM.

But doesn't Keith's abstraction makes a lot of sense given that you're
providing a device handler interface for NVMe?

The most important part of scsi_dh that DM uses is its calls to
scsi_dh_activate.  Attachment isn't interesting or the issue (DM's
call to scsi_dh_attach is purely legacy now that SCSI attaches the
proper scsi_dh during SCSI's device scan).
