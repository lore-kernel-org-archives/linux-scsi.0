From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6] target: Fix quiese during transport_write_pending_qf
 endless loop
Date: Wed, 8 Nov 2017 15:29:27 -0600
Message-ID: <6892cffb-3734-7bd7-aa42-1d91b70ee57b@linux.vnet.ibm.com>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
 <1510115512-15617-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753035AbdKHV3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 16:29:35 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vA8LNsSj110360
        for <linux-scsi@vger.kernel.org>; Wed, 8 Nov 2017 16:29:34 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2e48fr4bj3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Nov 2017 16:29:33 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Wed, 8 Nov 2017 16:29:33 -0500
In-Reply-To: <1510115512-15617-4-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Potnuri Bharat Teja <bharat@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>


> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch fixes a potential end-less loop during QUEUE_FULL,
> where cmd->se_tfo->write_pending() callback fails repeatedly
> but __transport_wait_for_tasks() has already been invoked to
> quiese the outstanding se_cmd descriptor.
>
> To address this bug, this patch adds a CMD_T_STOP|CMD_T_ABORTED
> check within transport_write_pending_qf() and invokes the
> existing se_cmd->t_transport_stop_comp to signal quiese
> completion back to __transport_wait_for_tasks().
>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
> Cc: Potnuri Bharat Teja <bharat@chelsio.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>
Reviewed-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
