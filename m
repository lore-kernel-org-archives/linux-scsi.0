From: Hannes Reinecke <hare@suse.de>
Subject: Re: SCSI: usage of DID_REQUEUE vs DID_RESET for returning SCSI
 commands to be retried
Date: Wed, 14 Dec 2016 16:36:35 +0100
Message-ID: <bfeac833-00f8-98a5-fe62-b9a98a2d81ab@suse.de>
References: <a7bffd458a08ca13972064edaedef71a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57975 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932612AbcLNPgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Dec 2016 10:36:38 -0500
In-Reply-To: <a7bffd458a08ca13972064edaedef71a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 12/13/2016 02:19 PM, Sumit Saxena wrote:
> Hi all,
>
> I have query regarding usage of host_byte DID_REQUEUE vs DID_RESET
> returned by LLD to SCSI mid layer.
>
> Let me give some background here.
> I am using megaraid_sas controller. megaraid_sas driver returns all
> outstanding SCSI commands back to SCSI layer with DID_RESET host_byte
> before resetting controller.
> The intent is- all these commands returned with DID_RESET before
> controller reset should be retried by SCSI.
>
> In few distros, I have observed that if SYNCHRONIZE_CACHE command(should
> be applicable for all non Read write commands) is outstanding before
> resetting controller  and driver returns those commands back with
> DID_RESET then SYNCHRONIZE_CACHE command not retried but failed to upper
> layer
> but other READ/WRITE commands were not failed but retried. I was running
> filesystem IOs and SYNHRONIZE_CACHE returned with error cause filesystem
> to go in READ only mode.
>
> Later I checked and realized below commit was missing in that distro
> kernel and seems to cause the problem-
>
> a621bac scsi_lib: correctly retry failed zero length REQ_TYPE_FS commands
>
> But distro kernel has below commit-
>
> 89fb4cd scsi: handle flush errors properly
>
> Issue does not hit on the kernels which don't have both commits but hits
> when commit- "89fb4cd scsi: handle flush errors properly " is there
> but commit-  "a621bac scsi_lib: correctly retry failed zero length
> REQ_TYPE_FS commands" is missing.
>
> This issue is observed with mpt3sas driver as well and should be
> applicable to all LLDs returning non read write commands with DID_RESET.
>
> Returning DID_REQUEUE instead of DID_RESET from driver solves the problem
> irrespective of whether these above mentioned commits are there or not in
> kernel.
> So I am thinking to use DID_REQUEUE instead of DID_RESET in megaraid_sas
> driver for all SCSI commands(not only limited to SYNCHRONIZE_CACHE or non
> read write commands)
> before resetting controller. As I mentioned intent is those outstanding
> commands returned by driver before doing controller reset should be
> retried and as soon as reset is complete,
> driver will be processing those commands. There is no sense key associated
> with SCSI commands returned.
>
> I browsed SCSI code and get to know DID_REQUEUE causes command to be
> retried by calling- scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY).
> This seems to be good enough for our requirement of commands to be
> re-tried by SCSI layer.
>
> Please provide feedback if anyone forsee any issue with using DID_REQUEUE
> for this use case.
> I will be doing some testing with DID_REQUEUE in place of DID_RESET in
> megaraid_sas driver.
>
> I have attached here a proposed patch for megaraid_sas driver.
> If there are no concerns, I will send this patch to SCSI mailing list.
>
Hmm.

DID_RESET is meant to be an indicator to the SCSI midlayer that the host 
/ device was reset, and the command _should_ be retried.
DID_REQUEUE OTOH is an indicator to the SCSI midlayer to retry the command.

The problem with DID_RESET is that it's slightly underspecified; there 
is no indication if the command has been processed (and if so, up to 
which parts?)
DID_REQUEUE, OTOH, will always cause a retry.

So yeah, I guess DID_REQUEUE is a better choice here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
