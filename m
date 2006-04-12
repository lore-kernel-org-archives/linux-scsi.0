From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Wed, 12 Apr 2006 11:21:34 +0900
Message-ID: <443C642E.5090106@gmail.com>
References: <20060401103857.GG13172@htj.dyndns.org> <442EDF1F.6000001@pobox.com> <442F25BD.8040000@gmail.com> <20060402160414.GM13172@htj.dyndns.org> <443BEA65.7020800@pobox.com> <20060411212830.GA9234@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060411212830.GA9234@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Tue, Apr 11, 2006 at 01:41:57PM -0400, Jeff Garzik wrote:
>> Tejun Heo wrote:
>>> + * scsi_eh_schedule_cmd - schedule scsi cmd for error handling.
>>> + * @scmd:	scmd to run eh on.
>>> + *
>>> + * Description:
>>> + *	This function is used by LLDDs which don't use standard SCSI
>>> + *	EH to schedule scmd for EH.
>>> + *
>>> + * Return value:
>>> + *	0 on failure.
>>> + **/
>>> +int scsi_eh_schedule_cmd(struct scsi_cmnd *scmd)
[--snip--]
>>
>> ACK, though this patch makes me think that there are some non-libata 
>> pieces of code that could use this function.
>>
>> Unfortunately for libata, we are stuck waiting on linux-scsi people to 
>> return and give their opinion.  If nobody complains, I'll apply it, if 
>> it doesn't appear in scsi-misc-2.6 sometime vaguely soon.
> 
> Per other email it should be called scsi_req_abort_cmd() or such, as that
> is the only reason to call it, correct?

Well, it's named this way is to keep it consistent with 
scsi_eh_schedule_host().  Either name is okay with me but driver which 
use this function probably have interest in schedule_host() but not in 
other SCSI EH functions.  So, considering that, I think the current 
naming is okay.

> Any other handling can be completed by calling the ->done function.
> 
> Even the abort/cancel could be done in the driver without this, I assume
> it is avaiable so the driver can use the eh process and existing code
> paths rather than duplicate similar code.

Yeap, as I noted earlier, passing scmds to EH is possible without this 
function but it has to be done in a quite hackish way.  My earlier 
libata EH implementation did this by completing the scmd with CHECK 
CONDITION but without sense data which makes SCSI midlayer invoke EH to 
acquire sense data, at which point libata EH can take over and do EH. 
It's just ugly.  Again, I'm okay with whatever that works, but things 
are much simpler this way.

-- 
tejun
