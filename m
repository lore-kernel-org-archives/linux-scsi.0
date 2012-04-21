From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 03/12] libata, libsas: introduce sched_eh and end_eh port
 ops
Date: Sat, 21 Apr 2012 02:19:28 -0400
Message-ID: <4F925170.3080705@garzik.org>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com> <20120413233706.8025.56546.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120413233706.8025.56546.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 04/13/2012 07:37 PM, Dan Williams wrote:
> When managing shost->host_eh_scheduled libata assumes that there is a
> 1:1 shost-to-ata_port relationship.  libsas creates a 1:N relationship
> so it needs to manage host_eh_scheduled cumulatively at the host level.
> The sched_eh and end_eh port port ops allow libsas to track when domain
> devices enter/leave the "eh-pending" state under ha->lock (previously
> named ha->state_lock, but it is no longer just a lock for ha->state
> changes).
>
> Since host_eh_scheduled indicates eh without backing commands pinning
> the device it can be deallocated at any time.  Move the taking of the
> domain_device reference under the port_lock to guarantee that the
> ata_port stays around for the duration of eh.
>
> Cc: Tejun Heo<tj@kernel.org>
> Acked-by: Jacek Danecki<jacek.danecki@intel.com>
> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
> ---
>   drivers/ata/libata-core.c           |    4 ++
>   drivers/ata/libata-eh.c             |   57 ++++++++++++++++++++++++++++-------
>   drivers/scsi/libsas/sas_ata.c       |   38 +++++++++++++++++++++--
>   drivers/scsi/libsas/sas_discover.c  |    6 ++--
>   drivers/scsi/libsas/sas_event.c     |   12 ++++---
>   drivers/scsi/libsas/sas_init.c      |   14 ++++-----
>   drivers/scsi/libsas/sas_scsi_host.c |   27 +++++++++++++----
>   include/linux/libata.h              |    4 ++
>   include/scsi/libsas.h               |    4 ++
>   include/scsi/sas_ata.h              |    5 +++
>   10 files changed, 134 insertions(+), 37 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>



