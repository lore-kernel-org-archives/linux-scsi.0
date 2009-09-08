From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/6] be2iscsi: iscsi hook in and handling codei
Date: Tue, 08 Sep 2009 12:20:13 -0500
Message-ID: <4AA6924D.9080204@cs.wisc.edu>
References: <20090908084007.GA19800@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58515 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZIHRUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2009 13:20:31 -0400
In-Reply-To: <20090908084007.GA19800@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sfr@canb.auug.org.au

Sorry for the virt_to_bus screw up.

On 09/08/2009 03:40 AM, Jayamohan Kallickal wrote:
> +struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
> +						 u16 cmds_max,
> +						 u16 qdepth,
> +						 u32 initial_cmdsn)
> +{
> +	struct Scsi_Host *shost;



> +	if (!cls_session)
> +		return NULL;
> +	sess = cls_session->dd_data;
> +	max_size = ALIGN(sizeof(struct be_cmd_bhs), 64) * cmds_max;


Instead of cmds_max you should use session->cmds_max like you do below.

> +	task = sess->cmds[0];
> +	io_task = task->dd_data;


The task and io_task assignment as not needed.

> +	vaddr = pci_alloc_consistent(phba->pcidev,
> +						max_size,
> +						&bus_add);
> +	pa_addr = (__u64) bus_add;
> +
> +	for (num_cmd = 0; num_cmd<  sess->cmds_max; num_cmd++) {
> +		task = sess->cmds[num_cmd];
> +		io_task = task->dd_data;
> +		io_task->cmd_bhs = vaddr;
> +		io_task->bhs_pa.u.a64.address = pa_addr;
> +		io_task->alloc_size = max_size;
> +		vaddr += ALIGN(sizeof(struct be_cmd_bhs), 64);
> +		pa_addr += ALIGN(sizeof(struct be_cmd_bhs), 64);
> +	}
> +	return cls_session;
> +}
> +
> +/**
> + * beiscsi_session_destroy - destroys iscsi session
> + * @cls_session:	pointer to iscsi cls session
> + *
> + * Destroys iSCSI session instance and releases
> + * resources allocated for it.
> + */
> +void beiscsi_session_destroy(struct iscsi_cls_session *cls_session)
> +{
> +	struct iscsi_task *task;
> +	struct beiscsi_io_task *io_task;
> +	struct iscsi_session *sess = cls_session->dd_data;
> +	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
> +	struct beiscsi_hba *phba = iscsi_host_priv(shost);
> +
> +	task = sess->cmds[0];
> +	io_task = task->dd_data;
> +	pci_free_consistent(phba->pcidev,
> +			    io_task->alloc_size,
> +			    io_task->cmd_bhs,
> +			    io_task->bhs_pa.u.a64.address);
> +	iscsi_session_teardown(cls_session);
> +}
> +
