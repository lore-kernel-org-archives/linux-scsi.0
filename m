From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v4 2/2] mpt2sas: Refcount fw_events and fix unsafe list
 usage
Date: Tue, 25 Aug 2015 14:06:15 -0700
Message-ID: <1440536775.23178.2.camel@haakon3.risingtidesystems.com>
References: <c4742680984986864719f36e691883815e6b5d55.1439510240.git.calvinowens@fb.com>
	 <5710d5e272a19c252db0171133a1092be00208f2.1439510240.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5710d5e272a19c252db0171133a1092be00208f2.1439510240.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-08-13 at 18:48 -0700, Calvin Owens wrote:
> The fw_event_work struct is concurrently referenced at shutdown, so
> add a refcount to protect it, and refactor the code to use it.
> 
> Additionally, refactor _scsih_fw_event_cleanup_queue() such that it
> no longer iterates over the list without holding the lock, since
> _firmware_event_work() concurrently deletes items from the list.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> ---
> Changes in v4: None
> 
> Changes in v3:
> 	* Add a break condition to the REMOVE_UNRESPONDING_DEVICES fw_event,
> 	  which can loop over a sleep forever (5m+ at least) at unloading. I
> 	  don't think anything prevented this before, but taking the fw_event
> 	  object off the list at the top of _firmware_event_work() seems to have
> 	  made it more likely to happen.
> 
> Changes in v2:
> 	* Squished patches 4-6 into one patch
> 	* Remove the fw_event from fw_event_list at the start of
> 	  _firmware_event_work()
> 	* Explicitly seperate fw_event_list removal from fw_event freeing
> 
> drivers/scsi/mpt2sas/mpt2sas_scsih.c | 112 ++++++++++++++++++++++++++++-------
>  1 file changed, 91 insertions(+), 21 deletions(-)
> 

Looks good.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
