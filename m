From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: [RFC PATCH] SCSI: Correct UA being ignored when notifying of
 media-changed
Date: Tue, 09 Aug 2011 07:50:07 +0900
Message-ID: <4E40681F.2010306@jp.fujitsu.com>
References: <1312378758-17308-1-git-send-email-revers@redhat.com>	 <1312410128.2855.94.camel@mulgrave>  <4E39CC32.70305@cs.wisc.edu> <1312410999.2855.97.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57596 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab1HHWuE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2011 18:50:04 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id A35A13EE081
	for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2011 07:50:02 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8C80D45DE7E
	for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2011 07:50:02 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6A26845DE61
	for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2011 07:50:02 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 5DB1E1DB803A
	for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2011 07:50:02 +0900 (JST)
Received: from m020.s.css.fujitsu.com (m020.s.css.fujitsu.com [10.0.81.60])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 2E9121DB802C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2011 07:50:02 +0900 (JST)
In-Reply-To: <1312410999.2855.97.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: michaelc@cs.wisc.edu, revers@redhat.com, linux-scsi@vger.kernel.org

Hi James,

I posted a patch (as below) last year about this.
  http://www.kerneltrap.org/mailarchive/linux-scsi/2010/12/22/6887895

I intended to distinguish UA caused by media change from UA caused by
other reasons like resetting a device. First, it should be notified to upper
layer driver, sr, but the other must be retried as scsi_error.c coded.

At least SCSI driver should not squash all UAs, I think.

-- 
taruisi

(2011/08/04 7:36), James Bottomley wrote:
> On Wed, 2011-08-03 at 17:31 -0500, Mike Christie wrote:
>> On 08/03/2011 05:22 PM, James Bottomley wrote:
>>> On Wed, 2011-08-03 at 09:39 -0400, Rob Evers wrote:
>>>> Unit attention commands are getting ignored when a dvd is
>>>> replaced, resulting in errors when accessing the new dvd.
>>>>
>>>> This problem occurred when a system is booted in rescue
>>>> mode via dvd and the dvd is then replaced with another dvd.
>>>> Subsequent commands to a filesystem on the dvd, such as
>>>> 'fsck' and 'restore' report errors.
>>>>
>>>> Solution suggested by Mike Christie.
>>>>
>>>> Signed-off-by: Rob Evers <revers@redhat.com>
>>>> ---
>>>>  drivers/scsi/scsi_error.c |    4 ++++
>>>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>>> index a4b9cdb..725cc11 100644
>>>> --- a/drivers/scsi/scsi_error.c
>>>> +++ b/drivers/scsi/scsi_error.c
>>>> @@ -294,6 +294,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>>>>  		 */
>>>>  		if (scmd->device->expecting_cc_ua) {
>>>>  			scmd->device->expecting_cc_ua = 0;
>>>> +				if (sdev->removable) {
>>>> +					sdev->changed = 1;
>>>> +					return SUCCESS;
>>>> +				}
>>>
>>> Are you sure about this?  We only set expecting_cc_ua if the device was
>>> reset in error handling ... and there we definitely *don't* want to
>>> trigger a medium change.
>>>
>>
>> What is happening is that we have a quirky device, and when you switch
>> CD/DVDs the first command times out, so the scsi error handler runs.
>> That is why the above code was modified. Before the patch the scsi layer
>> would just retry the IO, and sr would not see the sense and so it would
>> not detect the media changed. So the above code was meant to work like
>> UA code in scsi_io_completion.
> 
> The SCSI standard requires all SCSI devices to return UA after a reset
> (that's the reason for the code).  So, if I put this patch in, every
> removable device would be flagged as having changed media if we go into
> an error handling situation and reset it.  I don't think that's a good
> idea to fix a single non-standard CD.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

