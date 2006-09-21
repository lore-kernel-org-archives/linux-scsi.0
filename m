From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] [PATCH] qla4xxx driver resubmission
Date: Thu, 21 Sep 2006 14:11:28 -0400
Message-ID: <4512D5D0.2040209@emulex.com>
References: <0BB3E5E7462EEA4295BC02D49691DC074144B0@AVEXCH1.qlogic.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:24448 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751434AbWIUSMD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 14:12:03 -0400
In-Reply-To: <0BB3E5E7462EEA4295BC02D49691DC074144B0@AVEXCH1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>



David Somayajulu wrote:
>> Why does your LLD need to reach up into the block layer to find an i/o
> ?
> Block layer tagging was the gating item in the previous submission.
> Going over the conversation on the linux-scsi reflector on STEX driver
> in this aspect, led us to believe that there should not be any driver
> level book-keeping of outstanding commands to the HBA. This was the
> reason for creating scsi_host_find_tag() in scsi_tcq.h (in the patch
> titled [RFC] [PATCH] helper function for retrieving scsi_cmd given
> hostbased block layer tag)
> http://marc.theaimsgroup.com/?l=linux-scsi&m=115871027627964&w=2
> 
> James, would you mind letting us know if block-layer tagging in your
> opinion simply meant using the scsi_cmd->request->tag and let the driver
> do the book-keeping of out-standing commands to HBA (like stex driver)
> or is it along the lines we have implemented.

Well, in general, I've been working on stuff that has little use for the
tags, so they aren't that meaningful. I can certainly see some implementations
that can benefit.

But, on a newish transport like iSCSI, I'm surprised. There's lots of
house-keeping that has to be done with resets and task management that makes
me believe it's better/easier with local structures. I also know that I like
to double-check my hardware (based on local structure) rather than blindly
trusting job handles. I also believe there will be locking issues or data
structures in flight issues between the block layer and LLDD that will
be ugly.

I wanted some justification. The new block layer function hasn't been needed
in the past and I thought it a rather odd thing to add.

-- james
