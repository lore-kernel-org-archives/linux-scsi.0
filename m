From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings V2
Date: Wed, 21 Oct 2009 13:20:34 -0500
Message-ID: <4ADF50F2.80800@cs.wisc.edu>
References: <20091021181043.71aff47a@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47218 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZJUSUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 14:20:36 -0400
In-Reply-To: <20091021181043.71aff47a@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

Jayamohan Kalickal wrote:
> _____  
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
> Cc: linux-scsi@vger.kernel.org
> Sent: Wed, 21 Oct 2009 10:19:06 -0700
> Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings V2
> 
> Jayamohan Kallickal wrote:
>>  This patch
>>
>>  1) Turns on msix
>>  2) Adds mcc_ring support for sending FW commands
>>  3) Adds Support for Ring Mode of WRB Posting
>>  4) Adds sysfs for FW commands
> 
> 
> I think msix should be a separate patch from the fw command one, and the 
> ring mode changes could probably be in a separate patch too.
> 
> Will Do that
> 
>> +
>> +static void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
>> +		struct be_async_event_link_state *evt)
>> +{
>> +	switch (evt->port_link_status) {
>> +	case ASYNC_EVENT_LINK_DOWN:
>> +		SE_DEBUG(DBG_LVL_1, "Link Down on Physical Port %d \n",
>> +						evt->physical_port);
>> +		break;
> 
> 
> When you get a link down, does it cause the fw do start iscsi recovery 
> or does it send the driver a notification that a command is failed due 
> to the link down. For example if we were doing erl0, and the link is 
> gone, would the fw return some error for each command?
> 
> 
> For link down maybe you want to fire a iscsi conn error for each 
> session/connection on the port, so that way the iscsi layer can block 
> the sessions and start recovery.
> 
>  The FW will report LINKDOWN event almost immediately when the event is noticed.
> 
> Some thoughts on the implementation 
> 
> 1) Rather than immediately  shutting down all the sessions , wait for a predetermined
>  time ,say, 10 Secs(if the user has pulled the cable and is connecting it back ,for eg, to
> connect to a different port on the switch etc). Since IO's will not exceed the Queue  Depth,  this should be fine. However, for MPIO, we may need to load with a parameter (or something  better) so that we will fail immediately and IO's can be switched over to other port faster.
> 

We have a timer it is called the replacement_timeout/recovery_timeout. 
This will determine how fast we fail cmds upwards when handling these 
type of errors. When you call iscsi_session_failure or 
iscsi_conn_faulure it will start the timer. Today, users will set this 
very short for MPIO setups and very high for something else like root on 
iscsi.



> 2) Since this function to shutdown sessions will be used by many drivers , shall we make this
>    part of libiscsi. Can do this.
>

Yes, libiscsi is best. See bnx2i's 
iscsi_host_for_each_session+iscsi_session_failure use.


> 
> 2) Since this is 
> 
> 2)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> ___________________________________________________________________________________
> This message, together with any attachment(s), contains confidential and proprietary information of
> ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
> review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
> intended recipient of this message, please immediately advise the sender by reply email message and
> delete all copies of this message and any attachment(s). Thank you.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

