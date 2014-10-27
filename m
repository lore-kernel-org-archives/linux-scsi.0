From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] scsi: TUR path is down after adapter gets reset in
 multipath configuration(scsi_dh_alus.c)
Date: Mon, 27 Oct 2014 17:48:04 -0500
Message-ID: <544ECBA4.4040907@linux.vnet.ibm.com>
References: <20141027180147.030955587@linux.vnet.ibm.com> <20141027180347.045407862@linux.vnet.ibm.com> <94D0CD8314A33A4D9D801C0FE68B40295933E15D@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49889 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbaJ0Wv4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2014 18:51:56 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 27 Oct 2014 18:51:55 -0400
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 64FB2C9003C
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 18:40:35 -0400 (EDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9RMm6jp38862870
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 23:48:06 +0100
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9RMm5w9003767
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 16:48:06 -0600
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295933E15D@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/27/2014 02:56 PM, Elliott, Robert (Server Storage) wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of wenxiong@linux.vnet.ibm.com
>> Sent: Monday, 27 October, 2014 1:02 PM
>> To: James.Bottomley@HansenPartnership.com
>> Cc: hch@infradead.org; linux-scsi@vger.kernel.org;
>> brking@linux.vnet.ibm.com
>> Subject: [PATCH 2/2] scsi: TUR path is down after adapter gets reset
>> in multipath configuration(scsi_dh_alus.c)
>>
>> This patch also fixes the 02/04/02 K/C/Q check in alua_check_sense
>> handler.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> Teste-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> 
> Missing a d
> 
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> Index: b/drivers/scsi/device_handler/scsi_dh_alua.c
>> ===================================================================
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c	2014-10-23
>> 13:00:45.000000000 -0500
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2014-10-23
>> 13:04:16.152079004 -0500
>> @@ -474,6 +474,13 @@ static int alua_check_sense(struct scsi_
>>  			 * LUN Not Ready -- Offline
>>  			 */
>>  			return SUCCESS;
>> +		if (sdev->allow_restart &&
>> +		    (sense_hdr->asc == 0x04) && (sense_hdr->ascq ==
>> 0x02))
> 
> The coding style in that function does not include the extra 
> parenthesis, as shown by the next excerpt:

I just lifted this bit from scsi_error.c without noticing the
coding style difference. We can certainly change this.

> 
>> +			/*
>> +			 * if the device is not started, we need to wake
>> +			 * the error handler to start the motor
>> +			 */
>> +			return FAILED;
>>  		break;
>>  	case UNIT_ATTENTION:
>>  		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
> 
> Thus function is used several places:
> * installed as the scsi_device_handler .check_sense function 
> * called to parse the response to REPORT TARGET PORT GROUPS
>   in alua_rtpg
> * called to parse the response to SET TARGET PORT GROUPS
>   in stpg_endio
> 
> I'm not sure that adding NOT READY/LOGICAL UNIT NOT READY,
> INITIALIZING COMMAND REQUIRED (2h/04h/02h) is a good idea
> for the second case. The expected way to handle that 
> response is to send START STOP UNIT with START=1.
> 
> There are conditions in which REPORT TARGET PORT GROUPS
> is allowed and START STOP UNIT with START=1 is not allowed:
> * CbCS (capabilities-based command security) only allows 
>   START STOP UNIT if physical access (PHY ACC) is enabled,
>   while REPORT TARGET PORT GROUPS is always allowed.
> * the standby or unavailable asymmetric access states only 
>   guarantee that REPORT TARGET PORT GROUPS is allowed, not
>   START STOP UNIT.  The device is permitted to support START
>   STOP UNIT, but it's not required.
> 
> So, it's really not a response that should be returned for
> that command.
> 
> Any device that does return that response must also support
> START STOP UNIT or it's misleading the application client.
> In that case, falling through to the EH to send START STOP
> UNIT is the right thing to do.
> 
> SET TARGET PORT GROUPS is questionable too; it also has 
> different CbCS permissions and asymmetric access state
> requirements than START STOP UNIT with START=1.
> 
> Perhaps that new "return FAILED" should be skipped if the
> opcode is REPORT TARGET PORT GROUPS or SET TARGET PORT
> GROUPS?

I'm fine with that.

Wendy - do you want to make these changes and resend?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


