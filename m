From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v4 1/2] mpt2sas: Refcount sas_device objects and fix
 unsafe list usage
Date: Tue, 25 Aug 2015 14:03:27 -0700
Message-ID: <1440536607.23178.1.camel@haakon3.risingtidesystems.com>
References: <1438405334-1153698-1-git-send-email-calvinowens@fb.com>
	 <1439516890-3548744-1-git-send-email-calvinowens@fb.com>
	 <c4742680984986864719f36e691883815e6b5d55.1439510240.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c4742680984986864719f36e691883815e6b5d55.1439510240.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Hi Calvin,

On Thu, 2015-08-13 at 18:48 -0700, Calvin Owens wrote:
> These objects can be referenced concurrently throughout the driver, we
> need a way to make sure threads can't delete them out from under each
> other. This patch adds the refcount, and refactors the code to use it.
> 
> Additionally, we cannot iterate over the sas_device_list without
> holding the lock, or we risk corrupting random memory if items are
> added or deleted as we iterate. This patch refactors _scsih_probe_sas()
> to use the sas_device_list in a safe way.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Joe Lawrence <joe.lawrence@stratus.com>
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> ---
> Changes in v4:
> 	* Fix lack of put() in non-SATA case in _scsih_change_queue_depth()
> 	* Fix lack of put() in the non-error case in _scsih_check_device()
> 	* Add missing put() at bottom of _scsih_add_device()
> 	* Add put for ->hostdata pointer in _scsih_target_destroy() for the
> 	  get() in _scsih_target_alloc()
> 
> Changes in v3:
> 	* Drop the sas_device_lock while enabling devices, and leave the
> 	  sas_device object on the list, since it may need to be looked up there
> 	  while it is being enabled.
> 	* Drop put() in _scsih_add_device(), because the ->hostdata now keeps a
> 	  reference (this was an oversight in v2).
> 	* Be consistent about calling sas_device_put() while holding the
> 	  sas_device_lock where feasible.
> 	* Take and assert_spin_locked() on the sas_device_lock from the newly
> 	  added __get_sdev_from_target(), add wrapper similar to other lookups
> 	  for callers which do not explicitly take the lock.
> 
> Changes in v2:
> 	* Squished patches 1-3 into this one
> 	* s/BUG_ON(!spin_is_locked/assert_spin_locked/g
> 	* Store a pointer to the sas_device object in ->hostdata, to eliminate
> 	  the need for several lookups on the lists.
> 
>  drivers/scsi/mpt2sas/mpt2sas_base.h      |  22 +-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 480 +++++++++++++++++++++----------
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |  12 +-
>  3 files changed, 360 insertions(+), 154 deletions(-)
> 

Looks good.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
