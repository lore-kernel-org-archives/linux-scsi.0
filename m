From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 4/8] lpfc 8.2.2 : Rework the lpfc_printf_log() macro
Date: Fri, 03 Aug 2007 11:36:31 -0400
Message-ID: <46B34B7F.4020208@emulex.com>
References: <1186067410.14374.21.camel@localhost.localdomain> <46B1852B.8090106@panasas.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47011 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761971AbXHCPis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 11:38:48 -0400
In-Reply-To: <46B1852B.8090106@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

Sorry, Attempting to sync our pools with the variance of upstream is difficult.

Leave this patch 4 in place. I'll submit a patch shortly to address you concern
and get the 8.2.2 sources in line.

-- james s

Boaz Harrosh wrote:
> Big NACK
> 
> The code was converted to Accessors. look Here:
> 
>> -			lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
>> -					"%d (%d):0717 FCP command x%x residual "
>> -					"underrun converted to error "
>> -					"Data: x%x x%x x%x\n",
>> -					phba->brd_no, vpi, cmnd->cmnd[0],
>> -					scsi_bufflen(cmnd),
>> -					scsi_get_resid(cmnd), cmnd->underflow);
>> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
>> +					 "0717 FCP command x%x residual "
>> +					 "underrun converted to error "
>> +					 "Data: x%x x%x x%x\n",
>> +					 cmnd->cmnd[0], cmnd->request_bufflen,
>> +					 scsi_get_resid(cmnd), cmnd->underflow);
> 
> you removed an scsi_bufflen(cmnd) and put cmnd->request_bufflen in its place.
> the scsi_get_resid(cmnd) you left as is.
> 
> Boaz Harrosh
> 
