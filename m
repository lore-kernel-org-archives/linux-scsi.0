From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] target: Fix QUEUE_FULL + SCSI task attribute handling
Date: Wed, 8 Nov 2017 15:29:45 -0600
Message-ID: <c46a9035-85fa-6322-beb5-ae38d90ccb49@linux.vnet.ibm.com>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
 <1510115512-15617-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510115512-15617-2-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch fixes a bug during QUEUE_FULL where transport_complete_qf()
> calls transport_complete_task_attr() after it's already been invoked
> by target_complete_ok_work() or transport_generic_request_failure()
> during initial completion, preceeding QUEUE_FULL.
>
> This will result in se_device->simple_cmds, se_device->dev_cur_ordered_id
> and/or se_device->dev_ordered_sync being updated multiple times for
> a single se_cmd.
>
> To address this bug, clear SCF_TASK_ATTR_SET after the first call
> to transport_complete_task_attr(), and avoid updating SCSI task
> attribute related counters for any subsequent calls.
>
> Also, when a se_cmd is deferred due to ordered tags and executed
> via target_restart_delayed_cmds(), set CMD_T_SENT before execution
> matching what target_execute_cmd() does.
>
> Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
> Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>
Reviewed-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
