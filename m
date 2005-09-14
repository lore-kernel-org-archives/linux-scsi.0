From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [2.6.14-rc1] sym scsi boot hang
Date: Wed, 14 Sep 2005 11:52:13 -0500
Message-ID: <4328553D.10501@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0509141052410.5064-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030278AbVINQw1@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0509141052410.5064-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Anton Blanchard <anton@samba.org>, James Bottomley <James.Bottomley@SteelEye.com>, Dipankar Sarma <dipankar@in.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 14 Sep 2005, Anton Blanchard wrote:
> 
> 
>>Hi,
>>
>>
>>>If that's the cause, it's probably a double down of the host scan
>>>semaphore somewhere in the code.  alt-sysrq-t should work in this case,
>>>can you get a stack trace of the blocked process?
>>
>>It appears to be this patch:
>>
>>  [SCSI] SCSI core: fix leakage of scsi_cmnd's
>>
>>  From:         Alan Stern <stern@rowland.harvard.edu>
> 
> 
>>And in particular it looks like the scsi_unprep_request in
>>scsi_queue_insert is causing it. The following patch fixes the boot
>>problems on the vscsi machine:
> 
> 
> In general the scsi_unprep_request routine is correct and needs to be
> there.  The one part that might be questionable is the assignment to
> req->special.  It may turn out that the real solution is to have
> scsi_execute set req->special to NULL; I assumed it would be NULL already
> but perhaps I was wrong.

I think we have scsi_execute and friends setting REQ_SPECIAL. This is 
could cause a problem becuase it does not have a scsi_request.
