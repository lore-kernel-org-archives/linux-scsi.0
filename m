From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] scsi_debug: support scsi-mq, queues and locks
Date: Mon, 14 Jul 2014 10:00:13 -0400
Message-ID: <53C3E26D.4050702@interlog.com>
References: <53BAA104.6090207@interlog.com> <94D0CD8314A33A4D9D801C0FE68B402958BA045E@G9W0745.americas.hpqcorp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39638 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaGNOAT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2014 10:00:19 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BA045E@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>, Hannes Reinecke <hare@suse.de>

On 14-07-13 06:55 PM, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Douglas Gilbert
>> Sent: Monday, 07 July, 2014 8:31 AM
>> To: SCSI development list
>> Subject: [PATCH v2] scsi_debug: support scsi-mq, queues and locks
>>
>> Resend, looks like the list does not like html attachments.
>>
>>
>> This v2 patch is against Christoph's core-for-3.17 branch which
>> includes scsi-mq V2. Here is a link to a partially updated
>> version of the scsi_debug html page.
>>     http://sg.danny.cz/scsi/sdebug26.html
>
> Reviewed-by: Robert Elliott <elliott@hp.com>
>
> A few minor concerns:
> 1. In scsi_debug_abort, does num_aborts needs to be atomic - can
> the SCSI midlayer have concurrent .eh_abort_handler calls
> in progress?
>
> +static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
> +	++num_aborts;
>
> (I don't think this patch changes that from before...)
>
> 2. Same question for:
> 	num_dev_resets
> 	num_target_resets
> 	num_bus_resets
> 	num_host_resets
>
> (I don't think this patch changes that from before...)

These are only informational (i.e. only consumed by
'cat /proc/scsi/scsi_debug/<host_id>'). This could be addressed
if more meat is added to the various ".eh*" entry points.
I'd look for help from Hannes (cc-ed) in this area.

> 3. schedule_resp includes this comment about the new TASK SET
> FULL injection code:
> +	/* if (tsf) simulate device reporting SCSI status of TASK SET FULL.
> +	 * Might override existing CHECK CONDITION. */
>
> If a TASK SET FULL is injected over a CHECK CONDITION/
> UNIT ATTENTION created by check_readiness():
> +	k = find_first_bit(devip->uas_bm, SDEBUG_NUM_UAS);
> ...
> +		clear_bit(k, devip->uas_bm);
>
> then it looks like that unit attention is lost forever.

Yes. The driver could make the distinction between SCSI
errors found early in device server processing (e.g. UAs
and Illegal Requests) from errors found later such as
Medium Error. But that adds complexity. The simplest
approach would be to skip TSF injection if any error is
being reported. In the rare case where the driver wants
to delay the response and has no space (i.e. an attempt
to exceed CAN_QUEUE/scsi_debug_max_queue) the error could
take precedence by skipping the delay and doing an
in-thread scsi_done() call.

> 4. In scsi_debug_show_info:
> +		"num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
>
> and the modparam string describing that variable:
> MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
>
> the units are really MiB, not MB.
>
> (I don't think this patch changes that from before...)

Yes.

> 5. For the UNMAP command, this modparam:
> 	MODULE_PARM_DESC(lbprz, "unmapped blocks return 0 on read (def=1)");
> always causes unmap_region to zero out the blocks:
>                          if (scsi_debug_lbprz) {
>                                  memset(fake_storep +
>                                         lba * scsi_debug_sector_size, 0,
>                                         scsi_debug_sector_size *
>                                         scsi_debug_unmap_granularity);
>                          }
>
> That doesn't recognize that unmap requests via UNMAP commands are just
> hints/suggestions, not mandatory.  The same is true in ATA for the
> DATA SET MANAGEMENT/TRIM command.
>
> Zeroing out is fine for when resp_write_same is the caller of
> unmap_region and either NDOB=1 or the Data-Out Buffer contains all
> zeros - if WRITE SAME with UNMAP=1 doesn't cause an unmap, it
> still writes all zeros to the blocks.
>
> When resp_unmap is the caller, though, there is no guarantee that
> the data will change.
>
> Maybe another modparam should be included to cause the driver
> to purposely ignore unmap requests?  That might help more people
> realize the danger in these commands.  (e.g., I think mdraid
> assumes UNMAP will result in zeros for RAID-5/6 volumes,
> which means parity will be calculated wrong if the drive
> doesn't really unmap).
>
> (I don't think this patch changes that from before...)

I consider the PI+LBP parts of this driver to be maintained
by Martin Petersen (cc-ed) and I'm hoping he will look at
this area (and its lock safety) when the dust settles.


I noticed that scsi_debug is reporting SPC-3 compliance and
that probably should be upped to SPC-4.


In summary, I would like to leave this oversized "v2" patch
as is. Then address some of the issues raised here as
a series of small, follow-up patches including some input
from those cc-ed in this reply.


BTW The driver documentation at:
   http://sg.danny.cz/sg/sdebug26.html
has been updated reflecting this v2 patch. There was a temporary
version at: http://sg.danny.cz/scsi/sdebug26.html
which will be removed (or made a symlink to the former).

Doug Gilbert

