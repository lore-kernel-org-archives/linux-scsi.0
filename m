From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: On patch "Let scsi_cmnd->cmnd use request->cmd buffer"
Date: Sun, 04 May 2008 16:46:04 +0300
Message-ID: <481DBE1C.90701@panasas.com>
References: <tkrat.5db1d90bfe8d480e@s5r6.in-berlin.de> <481DA8EF.3010405@panasas.com> <tkrat.46744b15c43493a1@s5r6.in-berlin.de> <tkrat.4814bd8a1738df8c@s5r6.in-berlin.de> <481DBBE7.3060602@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4238 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752729AbYEDNqj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 09:46:39 -0400
In-Reply-To: <481DBBE7.3060602@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> Stefan Richter wrote:
>> On  4 May, Stefan Richter wrote:
>>> Boaz Harrosh wrote:
>>>> cmd->cmd_len is now guarantied to be set properly at all cases.
>>>> And some commands you want to support will not be set correctly
>>>> by COMMAND_SIZE().
>> ...
>>> --- linux.orig/drivers/ieee1394/sbp2.c
>>> +++ linux/drivers/ieee1394/sbp2.c
>> ...
>>>      memset(orb->cdb, 0, 12);
> 
> if you are at it?
> -     memset(orb->cdb, 0, 12);
> +     memset(orb->cdb, 0, sizeof(orb->cdb));
> 
>>> -    memcpy(orb->cdb, scsi_cmd, COMMAND_SIZE(*scsi_cmd));
>>> +    memcpy(orb->cdb, SCpnt->cmnd, SCpnt->cmd_len);
>> ...
>>
>> Wait a minute...
>>
>> drivers/ieee1394/sbp2.[ch] and drivers/firewire/fw-sbp2.c hardwire the
>> maximum size of the command descriptor block (command_block field in the
>> command block ORB as per SBP-2 clause 5.1.2) to 12 bytes.
>>
>> We need to use BLK_MAX_CDB there, don't we?
>>
>> (Besides, we should keep an eye on unit_characteristics.ORB_size as per
>> SBP-2 clause 7.4.8, but that's another story.)
> 
> I'm not sure what you mean. But orb->cdb is 12 bytes, and setting 
> max_cmd_len in
> host template insures midlayer will never send a command bigger then 
> that. So
> ->cmd_len will never be bigger then host->max_cmd_len. BLK_MAX_CDB 
> should not
> be used here.
> 
> But I don't see .max_cmd_len set in this file, is it set elsewhere?
> 
> Boaz

Oops sorry its fine not to set .max_cmd_len. If not set the midlayer will
assume 12. So the code you sent is fine as is.

Boaz
