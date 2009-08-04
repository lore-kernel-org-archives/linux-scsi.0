From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: FCP target reset
Date: Tue, 04 Aug 2009 10:38:28 -0400
Message-ID: <4A7847E4.8090304@interlog.com>
References: <20090803162302.GA9872@schmichrtp.de.ibm.com> <4A774AC8.8080805@emulex.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51858 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbZHDOie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Aug 2009 10:38:34 -0400
In-Reply-To: <4A774AC8.8080805@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

It looks like "target reset" is being phased out of SCSI
terminology and being partially replaced by "hard reset".

The third paragraph in the introduction of draft SAM-5
(sam5r02.pdf section 1.1) states:

"The following concepts from previous versions of this
  standard are made obsolete by this standard:
    a)    support for the SPI-5 SCSI transport protocol;
    b)    Contingent Allegiance;
    c)    the TARGET RESET task management function;
    d)    basic task management model;
    e)    untagged tasks; and
    f)    linked command function."

The TARGET RESET task management function last appeared
in SAM-2 (ANSI INCITS 366-2003).

A "hard reset" is associated with a power cycle at an
initiator, target or somewhere in between. There is no
SCSI task management function to generate a hard reset.

Some transports have the ability to generate hard resets
via non-SCSI protocols. For example in SAS a target can
be reset with a SMP PHY CONTROL request to an expander
phy attached to a phy on that target. SAS also has a lower
order "link reset" which is invisible at the SCSI protocol
level.

So is there a "hard reset" hook somewhere in FCP-3 ?

Doug Gilbert


James Smart wrote:
> Just because a newer rev of the spec doesn't do something does not mean 
> that all the targets/environments stopped using it...  Target Reset was 
> a mandatory item for FCP-2 compliance, which is what most of the stuff 
> in the field is at.   So, I recommend that the header be updated with 
> the older definition - It can be flagged any way you desire (/* 
> Deprecated as of FCP-3 */).
> 
> As for use in LLD's - there's nothing else (TMF-wise) that works at the 
> I_T nexus level to map to the shost eh_target_reset_handler.  Thus, I'd 
> continue to use it for the entrypoint. You can always choose to not 
> implement the entry point, but my recommendation is to support it if 
> possible. It's much better than having to resort to a "bus" or "adapter" 
> reset after a lun reset fails.
> 
> -- james s
> 
> Christof Schmitt wrote:
>> While trying to replace the Fibre Channel protocol definitions in
>> zfcp with the definitions in include/scsi/fc i came across the FCP
>> target reset flag.
>>
>>> From what i understand, older versions of the FCP standard defined the
>> target reset flag, but newer versions do not. Adhering to the newer
>> standard, the file include/scsi/fc/fc_fcp.h does not define the target
>> reset.
>>
>> Does this mean that FC device drivers should not issue target resets
>> any more?
>>
>> Some FC device drivers in Linux define the flag:
>>
>> grep -r FCP_TARGET_RESET *
>> drivers/s390/scsi/zfcp_dbf.h:    zfcp_scsi_dbf_event(flag == 
>> FCP_TARGET_RESET ? "trst" : "lrst", tag, 1,
>> drivers/s390/scsi/zfcp_def.h:#define FCP_TARGET_RESET    0x20
>> drivers/s390/scsi/zfcp_scsi.c:    return 
>> zfcp_task_mgmt_function(scpnt, FCP_TARGET_RESET);
>> drivers/scsi/lpfc/lpfc_scsi.c: FCP_TARGET_RESET);
>> drivers/scsi/lpfc/lpfc_scsi.c: FCP_TARGET_RESET);
>> drivers/scsi/lpfc/lpfc_scsi.h:#define  FCP_TARGET_RESET    0x20    /* 
>> bit 5 */
>>
>> If the target reset is not required, i would remove it from zfcp. If
>> it is still required, would adding it to include/scsi/fc/fc_fcp.h make
>> sense, probably flagged as "obsolete"?
>>
>> -- 
>> Christof Schmitt
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

