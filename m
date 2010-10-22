From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Fri, 22 Oct 2010 19:03:30 +0900
Message-ID: <20101022185701H.fujita.tomonori@lab.ntt.co.jp>
References: <4CBD95C0.6060302@kernel.org>
	<4CBD95DC.8000001@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CBD95DC.8000001@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 19 Oct 2010 14:58:04 +0200
Tejun Heo <tj@kernel.org> wrote:

> SCSI is the only subsystem which uses execute_in_process_context().
> With the recent workqueue updates, unconditionally using work wouldn't
> cause deadlocks around execution resources and the two places where
> SCSI uses them are cold paths where using work unconditionally
> wouldn't make any difference.  Drop execute_in_process_context() and
> use work directly.
> 
> * scsi_device->ew is replaced with release_work.  scsi_target->ew is
>   replaced with reap_work.
> 
> * Both works are initialized with the respective release/reap function
>   during device/target init.  scsi_target_reap_usercontext() is moved
>   upwards to avoid needing forward declaration.
> 
> * scsi_alloc_target() now explicitly flushes the reap_work of the
>   found dying target before putting it instead of depending on
>   flush_scheduled_work().
> 
> This is in preparation of deprecation of flush_scheduled_work() and
> execute_in_process_context().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/scsi/scsi_scan.c   |   26 +++++++++++++-------------
>  drivers/scsi/scsi_sysfs.c  |    8 +++++---
>  include/scsi/scsi_device.h |    4 ++--
>  3 files changed, 20 insertions(+), 18 deletions(-)

Looks fine to me.
