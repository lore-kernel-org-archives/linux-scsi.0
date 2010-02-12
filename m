From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Fri, 12 Feb 2010 11:29:16 -0600
Message-ID: <4B758FEC.9090407@cs.wisc.edu>
References: <20100130062856.GG10274@linux-qf4p> <4B671BFC.90107@cs.wisc.edu> <20100211110852.GB8237@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53022 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0BLR3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2010 12:29:34 -0500
In-Reply-To: <20100211110852.GB8237@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 02/11/2010 05:08 AM, Ravi Anand wrote:
> On Mon, 01 Feb 2010, Mike Christie wrote:
>>
>> On 01/30/2010 12:28 AM, Ravi Anand wrote:
>>>
>>> -		msleep(2000);
>>> -	} while (max_wait_time--);
>>> +		if (got_ref&&   (atomic_read(&rp->ref_count) == 1)) {
>>> +			done++;
>>> +			break;
>>> +		}
>>> +
>>> +		msleep(ABORT_POLLING_PERIOD);
>>
>>
>> Did you want to use krefs for the refcounting?
>
> We will add it to our to do list and submit a patch later on.
> For right now we will like to stick to it as kref will require
> additional testing.
>

Please use krefs from the start. Other drivers like beiscsi have had to 
switch from its own refcount code to krefs, and have had to retest their 
patchsets. You have to change your code in some other patches and maybe 
this one too, so you have to retest everything either way.
