From: James Smart <James.Smart@Emulex.Com>
Subject: Re: FCP target reset
Date: Mon, 3 Aug 2009 16:38:32 -0400
Message-ID: <4A774AC8.8080805@emulex.com>
References: <20090803162302.GA9872@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53158 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbZHCUif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 16:38:35 -0400
In-Reply-To: <20090803162302.GA9872@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Just because a newer rev of the spec doesn't do something does not mean that 
all the targets/environments stopped using it...  Target Reset was a mandatory 
item for FCP-2 compliance, which is what most of the stuff in the field is at. 
   So, I recommend that the header be updated with the older definition - It 
can be flagged any way you desire (/* Deprecated as of FCP-3 */).

As for use in LLD's - there's nothing else (TMF-wise) that works at the I_T 
nexus level to map to the shost eh_target_reset_handler.  Thus, I'd continue 
to use it for the entrypoint. You can always choose to not implement the entry 
point, but my recommendation is to support it if possible. It's much better 
than having to resort to a "bus" or "adapter" reset after a lun reset fails.

-- james s

Christof Schmitt wrote:
> While trying to replace the Fibre Channel protocol definitions in
> zfcp with the definitions in include/scsi/fc i came across the FCP
> target reset flag.
> 
>>From what i understand, older versions of the FCP standard defined the
> target reset flag, but newer versions do not. Adhering to the newer
> standard, the file include/scsi/fc/fc_fcp.h does not define the target
> reset.
> 
> Does this mean that FC device drivers should not issue target resets
> any more?
> 
> Some FC device drivers in Linux define the flag:
> 
> grep -r FCP_TARGET_RESET *
> drivers/s390/scsi/zfcp_dbf.h:	zfcp_scsi_dbf_event(flag == FCP_TARGET_RESET ? "trst" : "lrst", tag, 1,
> drivers/s390/scsi/zfcp_def.h:#define FCP_TARGET_RESET	0x20
> drivers/s390/scsi/zfcp_scsi.c:	return zfcp_task_mgmt_function(scpnt, FCP_TARGET_RESET);
> drivers/scsi/lpfc/lpfc_scsi.c: FCP_TARGET_RESET);
> drivers/scsi/lpfc/lpfc_scsi.c: FCP_TARGET_RESET);
> drivers/scsi/lpfc/lpfc_scsi.h:#define  FCP_TARGET_RESET    0x20	/* bit 5 */
> 
> If the target reset is not required, i would remove it from zfcp. If
> it is still required, would adding it to include/scsi/fc/fc_fcp.h make
> sense, probably flagged as "obsolete"?
> 
> --
> Christof Schmitt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
