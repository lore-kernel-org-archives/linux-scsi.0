From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Date: Thu, 23 Oct 2014 10:03:31 +0100
Message-ID: <CALjAwxjKED_5MEEN_=UPHAGWqm3kKDkFD_0Y8GjEoJYHYrwbhw@mail.gmail.com>
References: <20141010074901.GA32028@sucs.org>
 <yq1r3ya6t0i.fsf@sermon.lab.mkp.net>
 <20141021041707.GA11691@sucs.org>
 <yq1a94nwo4h.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq1a94nwo4h.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 23 October 2014 02:50, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
>
> Sitsofe> 2. On top of the above, when a disk is "small" (has less than
> Sitsofe>    2^32 sectors which is typically < 2 TBytes in size) READ
> Sitsofe>    CAPACITY(16) won't be triggered.
>
> static int sd_try_rc16_first(struct scsi_device *sdp)
> {
>         if (sdp->host->max_cmd_len < 16)
>                 return 0;
>         if (sdp->try_rc_10_first)
>                 return 0;
>         if (sdp->scsi_level > SCSI_SPC_2)
>                 return 1;
>         if (scsi_device_protection(sdp))
>                 return 1;
>         return 0;
> }

Yes but since SCSI_SPC_2 was being advertised by the Hyper-V virtual
disk (and presumably device protection isn't advertised either) this
function was returning 0. That's why the patch in
https://lkml.org/lkml/2014/10/10/49 added yet another quirk. If if
SPC_3 were correctly advertised on Hyper-V  virtual disks would
TRY_VPD_PAGES still be needed to cope correctly with passthrough
disks?

What I didn't realise was that the TRY_VPD_PAGES quirk was purely to
fix WRITE_SAME Hyper-V issues and not to address anything thin
provisioning related. Having said that, why was the TRY_VPD_PAGES
quirk back-ported 3.14 without any users -
https://lkml.org/lkml/2014/9/15/733 ?

-- 
Sitsofe | http://sucs.org/~sits/
