From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] tcm: Add VARIABLE_LENGTH_CMD support w/	XDWRITE_READ_32
 emulation
Date: Mon, 20 Sep 2010 12:14:54 +0200
Message-ID: <4C97341E.5090501@panasas.com>
References: <1284701695-18367-1-git-send-email-nab@linux-iscsi.org>	 <4C95FF76.4040005@panasas.com> <1284973101.13344.444.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284973101.13344.444.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On 09/20/2010 10:58 AM, Nicholas A. Bellinger wrote:
> On Sun, 2010-09-19 at 14:17 +0200, Boaz Harrosh wrote:
>> On 09/17/2010 07:34 AM, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>
>>> This patch updates transport_generic_cmd_sequencer() to properly support
>>> VARIABLE_LENGTH_CMD w/ service action XDWRITE_READ_32 emulation.  This
>>> patch follows the original XDWRITE_READ_10 patch, and uses the new 32-byte
>>> CDB extraction callers from commit 39a347ca2d88.  Note this patch uses the
>>> same transport_xor_callback() assignment callback as XDWRITE_READ_10.
>>>
>>> Also note that this patch enforces the following > TCM_MAX_COMMAND_SIZE check
>>> for VARIABLE_LENGTH_CMD CDBs in transport_generic_cmd_sequencer():
>>>
>>> 	<SNIP>
>>>         /*
>>>          * Check the additional CDB length (+ 8 bytes for header) does
>>>          * not exceed our TCM_MAX_COMMAND_SIZE.
>>>          */
>>>          if ((cdb[7] + 8) > TCM_MAX_COMMAND_SIZE) {
>>>                 printk(KERN_INFO "Only %u-byte extended CDBs currently"
>>>                          " supported for VARIABLE_LENGTH_CMD, received:"
>>>                          " %d for service action: 0x%04x\n",
>>>                          TCM_MAX_COMMAND_SIZE, cdb[7], service_action);
>>>                 return TGCS_INVALID_CDB_FIELD;
>>>          }
>>> 	<SNIP>
>>>
>>> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
>>> ---
>>>  drivers/target/target_core_transport.c |   50 +++++++++++++++++++++++++++----
>>>  1 files changed, 43 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>>> index a3016f7..a20a4a9 100644
>>> --- a/drivers/target/target_core_transport.c
>>> +++ b/drivers/target/target_core_transport.c
>>> @@ -5401,6 +5401,7 @@ static int transport_generic_cmd_sequencer(
>>>  	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
>>>  	int ret, sector_ret = 0;
>>>  	u32 sectors = 0, size = 0, pr_reg_type = 0;
>>> +	u16 service_action;
>>>  	u8 alua_ascq = 0;
>>>  	/*
>>>  	 * Check for an existing UNIT ATTENTION condition
>>> @@ -5572,6 +5573,48 @@ static int transport_generic_cmd_sequencer(
>>>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
>>>  		ret = TGCS_DATA_SG_IO_CDB;
>>>  		break;
>>> +	case VARIABLE_LENGTH_CMD:
>>> +		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>>> +		service_action = (cdb[8] << 8) | cdb[9];
>> get_unaligned_be16
> 
> Fixed
> 
>>> +		/*
>>> +		 * Check the additional CDB length (+ 8 bytes for header) does
>>> +		 * not exceed our TCM_MAX_COMMAND_SIZE.
>>> +		 */
>>> +		if ((cdb[7] + 8) > TCM_MAX_COMMAND_SIZE) {
>>
>> 		scsi_varlen_cdb_length(cdb)
>> it's in scsi.h
> 
> Fixed
> 
>>
>>> +			printk(KERN_INFO "Only %u-byte extended CDBs currently"
>>> +				" supported for VARIABLE_LENGTH_CMD, received:"
>>> +				" %d for service action: 0x%04x\n",
>>> +				TCM_MAX_COMMAND_SIZE, cdb[7], service_action);
>>> +			return TGCS_INVALID_CDB_FIELD;
>>> +		}
>>> +		switch (service_action) {
>>> +		case 0x0007: /* XDWRITE_READ_32 */
>>
>> Is it about time to define all these service_action codes. I have the OSD defines
>> in an OSD header. So I'm GUILTY just as much.
>> (but I do have an enum in a public header, at least)
>>
> 
> Yes, I was being a bit lazy here instead of just adding them to
> include/scsi/scsi.h, but I will add them into the forth-coming RFCv2
> series..
> 
> Btw, I have not been able to find a definitive list of the service
> actions of VARIABLE_LENGTH_CMD for TYPE_DISK in the SBC3 spec that need
> to be added to scsi.h.  Have you come across one in your own readings
> for these..?
> 

Sorry, no, I'm only an OSD guy. Perhaps Martin or Matthew

> Thanks!
> 

Boaz
