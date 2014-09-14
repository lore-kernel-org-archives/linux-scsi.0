From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/20] scsi_error: format abort error message
Date: Sun, 14 Sep 2014 12:49:35 +0200
Message-ID: <541572BF.5040502@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de> <1409738775-80876-21-git-send-email-hare@suse.de> <20140906003305.GA18426@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958C77D3B@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbaINKtj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Sep 2014 06:49:39 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C77D3B@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/13/2014 03:07 AM, Elliott, Robert (Server Storage) wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
>> Sent: Friday, 05 September, 2014 7:33 PM
>> Subject: Re: [PATCH 20/20] scsi_error: format abort error message
>>
>> On Wed, Sep 03, 2014 at 12:06:15PM +0200, Hannes Reinecke wrote:
> ...
>>> Decode the return value if the command abort failed.
>>> @@ -157,8 +157,8 @@ scmd_eh_abort_handler(struct work_struct *work)
>>>   		} else {
>>>   			SCSI_LOG_ERROR_RECOVERY(3,
>>>   				scmd_printk(KERN_INFO, scmd,
>>> -					    "scmd %p abort failed, rtn %d\n",
>>> -					    scmd, rtn));
>>> +					    "scmd %p abort failed, rtn %s\n",
>>> +					    scmd, scsi_retval_string(rtn)));
> ...
>> I've not seen an answer to my question in reply to the previous vers=
ion
>> of this.  Why would you do pretty printing of a variable that can ju=
st
>> return SUCCESS or FAILURE?
>
> Is there anything prohibiting the scsi_eh_abort_handler provided by
> the LLD from returning any of the other values like NEEDS_RETRY?
>
> #define NEEDS_RETRY     0x2001
> #define SUCCESS         0x2002
> #define FAILED          0x2003
> #define QUEUED          0x2004
> #define SOFT_ERROR      0x2005
> #define ADD_TO_MLQUEUE  0x2006
> #define TIMEOUT_ERROR   0x2007
> #define SCSI_RETURN_NOT_HANDLED   0x2008
> #define FAST_IO_FAIL    0x2009
>
There is not, and hence I've added this patch.
Although the intention here would be that we should be
enforcing it, either by stating it in the description
of the function or programmatically.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
