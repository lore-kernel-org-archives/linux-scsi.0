From: David Milburn <dmilburn@redhat.com>
Subject: Re: [RFC PATCH 2/6] isci: task (libsas interface support)
Date: Wed, 09 Feb 2011 09:01:46 -0600
Message-ID: <4D52AC5A.7020206@redhat.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6> <20110207003445.27040.67152.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1BIPBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2011 10:01:45 -0500
In-Reply-To: <20110207003445.27040.67152.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Dan Williams wrote:
> libsas interface routines and infrastructure.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/isci/task.c | 1691 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/isci/task.h |  368 ++++++++++
>  2 files changed, 2059 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/isci/task.c
>  create mode 100644 drivers/scsi/isci/task.h
> 
> diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
> new file mode 100644
> index 0000000..5e6f558
> --- /dev/null
> +++ b/drivers/scsi/isci/task.c
> @@ -0,0 +1,1691 @@
> +/*
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
> + *
> + * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + * The full GNU General Public License is included in this distribution
> + * in the file called LICENSE.GPL.
> + *
> + * BSD LICENSE
> + *
> + * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + *   * Redistributions of source code must retain the above copyright
> + *     notice, this list of conditions and the following disclaimer.
> + *   * Redistributions in binary form must reproduce the above copyright
> + *     notice, this list of conditions and the following disclaimer in
> + *     the documentation and/or other materials provided with the
> + *     distribution.
> + *   * Neither the name of Intel Corporation nor the names of its
> + *     contributors may be used to endorse or promote products derived
> + *     from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +#include <linux/completion.h>
> +#include "scic_task_request.h"
> +#include "scic_remote_device.h"
> +#include "scic_io_request.h"
> +#include "scic_sds_remote_device.h"
> +#include "scic_sds_remote_node_context.h"
> +#include "isci.h"
> +#include "request.h"
> +#include "sata.h"
> +#include "task.h"
> +
> +
> +/**
> + * isci_task_execute_task() - This function is one of the SAS Domain Template
> + *    functions. This function is called by libsas to send a task down to
> + *    hardware.
> + * @task: This parameter specifies the SAS task to send.
> + * @num: This parameter specifies the number of tasks to queue.
> + * @gfp_flags: This parameter specifies the context of this call.
> + *
> + * status, zero indicates success.
> + */
> +int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
> +{
> +	struct isci_host *isci_host;
> +	struct isci_request *request = NULL;
> +	struct isci_remote_device *device;
> +	unsigned long flags;
> +	unsigned long quiesce_flags = 0;
> +	int ret;
> +	enum sci_status status;
> +
> +
> +	dev_dbg(task->dev->port->ha->dev, "%s: num=%d\n", __func__, num);
> +
> +	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
> +
> +		isci_task_complete_for_upper_layer(
> +			task,
> +			SAS_TASK_UNDELIVERED,
> +			SAM_STAT_TASK_ABORTED,
> +			isci_perform_normal_io_completion
> +			);
> +
> +		return 0;  /* The I/O was accepted (and failed). */

Dan, is this the right status to return to libsas?

Looks like it checks (->lldd_execute_task) for non-zero result.

> +	}
> +	if ((task->dev == NULL) || (task->dev->port == NULL)) {
> +
> +		/* Indicate SAS_TASK_UNDELIVERED, so that the scsi midlayer
> +		 * removes the target.
> +		 */
> +		isci_task_complete_for_upper_layer(
> +			task,
> +			SAS_TASK_UNDELIVERED,
> +			SAS_DEVICE_UNKNOWN,
> +			isci_perform_normal_io_completion
> +			);
> +		return 0;  /* The I/O was accepted (and failed). */

Same here?

> +	}
> +	isci_host = isci_host_from_sas_ha(task->dev->port->ha);
> +
> +	/* Check if we have room for more tasks */
> +	ret = isci_host_can_queue(isci_host, num);
> +
> +	if (ret) {
> +		dev_warn(task->dev->port->ha->dev, "%s: queue full\n", __func__);
> +		return ret;
> +	}
> +



> +/**
> + * isci_task_send_lu_reset_sas() - This function is called by of the SAS Domain
> + *    Template functions.
> + * @lun: This parameter specifies the lun to be reset.
> + *
> + * status, zero indicates success.
> + */
> +static int isci_task_send_lu_reset_sas(
> +	struct isci_host *isci_host,
> +	struct isci_remote_device *isci_device,
> +	u8 *lun)
> +{
> +	struct isci_tmf tmf;
> +	int ret = TMF_RESP_FUNC_FAILED;
> +
> +	dev_dbg(&isci_host->pdev->dev,
> +		"%s: isci_host = %p, isci_device = %p\n",
> +		__func__, isci_host, isci_device);
> +	/* Send the LUN reset to the target.  By the time the call returns,
> +	 * the TMF has fully exected in the target (in which case the return
> +	 * value is "TMF_RESP_FUNC_COMPLETE", or the request timed-out (or
> +	 * was otherwise unable to be executed ("TMF_RESP_FUNC_FAILED").
> +	 */
> +	isci_task_build_tmf(&tmf, isci_device, isci_tmf_ssp_lun_reset, NULL,
> +			    NULL);
> +
> +	#define ISCI_LU_RESET_TIMEOUT_MS 2000 /* 2 second timeout. */

Maybe move #define to isci_task.h?

> +	ret = isci_task_execute_tmf(isci_host, &tmf, ISCI_LU_RESET_TIMEOUT_MS);
> +
> +	if (ret == TMF_RESP_FUNC_COMPLETE)
> +		dev_dbg(&isci_host->pdev->dev,
> +			"%s: %p: TMF_LU_RESET passed\n",
> +			__func__, isci_device);
> +	else
> +		dev_dbg(&isci_host->pdev->dev,
> +			"%s: %p: TMF_LU_RESET failed (%x)\n",
> +			__func__, isci_device, ret);
> +
> +	return ret;
> +}
> +
> +/**

> +
> +/*	 int (*lldd_clear_nexus_port)(struct asd_sas_port *); */
> +int isci_task_clear_nexus_port(struct asd_sas_port *port)
> +{
> +	return TMF_RESP_FUNC_FAILED;
> +}
> +
> +
> +
> +int isci_task_clear_nexus_ha(struct sas_ha_struct *ha)
> +{
> +	return TMF_RESP_FUNC_FAILED;
> +}
> +
> +int isci_task_I_T_nexus_reset(struct domain_device *dev)
> +{
> +	return TMF_RESP_FUNC_FAILED;
> +}
> +

These will be used during libsas error handling.


> +/**
> + * isci_task_abort_task() - This function is one of the SAS Domain Template
> + *    functions. This function is called by libsas to abort a specified task.
> + * @task: This parameter specifies the SAS task to abort.
> + *
> + * status, zero indicates success.
> + */
> +int isci_task_abort_task(struct sas_task *task)
> +{
scic_lock, flags);


> +
> +		#define ISCI_ABORT_TASK_TIMEOUT_MS 500 /* half second timeout. */

Maybe move this #define to isci_task.h?

> +		ret = isci_task_execute_tmf(isci_host, &tmf,
> +					    ISCI_ABORT_TASK_TIMEOUT_MS);
> +
> +		if (ret == TMF_RESP_FUNC_COMPLETE) {
> +			old_request->complete_in_target = true;
> +
> +			/* Clean up the request on our side, and wait for the aborted I/O to
> +			 * complete.
> +			 */
> +			isci_terminate_request_core(isci_host, isci_device, old_request,
> +						    &aborted_io_completion);
> +
> +			/* Set the state on the task. */
> +			isci_task_all_done(task);
> +		} else
> +			dev_err(&isci_host->pdev->dev,
> +				"%s: isci_task_send_tmf failed\n",
> +				__func__);
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * isci_task_abort_task_set() - This function is one of the SAS Domain Template
> + *    functions. This is one of the Task Management functoins called by libsas,
> + *    to abort all task for the given lun.
> + * @d_device: This parameter specifies the domain device associated with this
> + *    request.
> + * @lun: This parameter specifies the lun associated with this request.
> + *
> + * status, zero indicates success.
> + */
> +int isci_task_abort_task_set(
> +	struct domain_device *d_device,
> +	u8 *lun)
> +{
> +	return TMF_RESP_FUNC_FAILED;
> +}
> +
> +
> +/**
> + * isci_task_clear_aca() - This function is one of the SAS Domain Template
> + *    functions. This is one of the Task Management functoins called by libsas.
> + * @d_device: This parameter specifies the domain device associated with this
> + *    request.
> + * @lun: This parameter specifies the lun	 associated with this request.
> + *
> + * status, zero indicates success.
> + */
> +int isci_task_clear_aca(
> +	struct domain_device *d_device,
> +	u8 *lun)
> +{
> +	return TMF_RESP_FUNC_FAILED;
> +}
> +
> +
> +
> +/**
> + * isci_task_clear_task_set() - This function is one of the SAS Domain Template
> + *    functions. This is one of the Task Management functoins called by libsas.
> + * @d_device: This parameter specifies the domain device associated with this
> + *    request.
> + * @lun: This parameter specifies the lun	 associated with this request.
> + *
> + * status, zero indicates success.
> + */
> +int isci_task_clear_task_set(
> +	struct domain_device *d_device,
> +	u8 *lun)
> +{
> +	return TMF_RESP_FUNC_FAILED;
> +}

More libsas error recovery functions.

Thanks,
David
