From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 1/3] libata, libsas: kill pm_result and related cleanup
Date: Tue, 18 Mar 2014 09:48:12 -0700
Message-ID: <CAPcyv4j=rndWzuA2M7Ctnj8BO-Z62n9KuJtay0yJBTTzF=k5KA@mail.gmail.com>
References: <20140314205204.1269.44402.stgit@viggo.jf.intel.com>
	<20140314205248.1269.33730.stgit@viggo.jf.intel.com>
	<20140318160356.GC3642@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:51412 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCRQsN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Mar 2014 12:48:13 -0400
Received: by mail-vc0-f178.google.com with SMTP id im17so7466920vcb.23
        for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2014 09:48:12 -0700 (PDT)
In-Reply-To: <20140318160356.GC3642@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>, Phillip Susi <psusi@ubuntu.com>, Todd Brandt <todd.e.brandt@intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>

On Tue, Mar 18, 2014 at 9:03 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Mar 14, 2014 at 01:52:48PM -0700, Dan Williams wrote:
>> Tejun says:
>>   "At least for libata, worrying about suspend/resume failures don't make
>>    whole lot of sense.  If suspend failed, just proceed with suspend.  If
>>    the device can't be woken up afterwards, that's that.  There isn't
>>    anything we could have done differently anyway.  The same for resume, if
>>    spinup fails, the device is dud and the following commands will invoke
>>    EH actions and will eventually fail.  Again, there really isn't any
>>    *choice* to make.  Just making sure the errors are handled gracefully
>>    (ie. don't crash) and the following commands are handled correctly
>>    should be enough."
>>
>> The only libata user that actually cares about the result from a suspend
>> operation is libsas.  However, it only cares about whether queuing a new
>> operation collides with an in-flight one.  All libsas does with the
>> error is retry, but we can just let libata wait for the previous
>> operation before continuing.
>>
>> Other cleanups include:
>> 1/ Unifying all ata port pm operations on an ata_port_pm_ prefix
>> 2/ Marking all ata port pm helper routines as returning void, only
>>    ata_port_pm_ entry points need to fake a 0 return value.
>> 3/ Killing ata_port_{suspend|resume}_common() in favor of calling
>>    ata_port_request_pm() directly
>> 4/ Killing the wrappers that just do a to_ata_port() conversion
>> 5/ Clearly marking the entry points that do async operations with an
>>   _async suffix.
>>
>> Reference: http://marc.info/?l=linux-scsi&m=138995409532286&w=2
>>
>> Cc: Phillip Susi <psusi@ubuntu.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Suggested-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Can somebody ack the sas part?
>

Hmm I'd just as soon self-ack at this point.  I'm cleaning up code I
wrote a couple years ago, and libsas bugs at this point are
self-inflicted.

Top-5 in drivers/scsi/libsas by changeset in the past 5 years:
    75  Dan Williams
    12  James Bottomley
     9  Linus Torvalds
     7  Tejun Heo
     4  Sergei Shtylyov

--
Dan
