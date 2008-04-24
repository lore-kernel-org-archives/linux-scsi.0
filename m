From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH]qla4xxx:Add support for Async Message PDUs
Date: Thu, 24 Apr 2008 11:40:56 -0500
Message-ID: <4810B818.8040301@cs.wisc.edu>
References: <1208551487.5159.5.camel@d5102avq18960.qlogic.org>	 <480E1063.2060308@cs.wisc.edu> <1209052918.6212.4.camel@d5102avq18960.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59261 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbYDXQlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 12:41:04 -0400
In-Reply-To: <1209052918.6212.4.camel@d5102avq18960.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> On Tue, 2008-04-22 at 11:20 -0500, Mike Christie wrote:
>> David C Somayajulu wrote:
>>> +int qla4xxx_conn_close_sess_logout(struct scsi_qla_host * ha,
>>> +	   uint16_t fw_ddb_index, uint16_t connection_id, uint16_t option)
>>> +{
>>> +	uint32_t mbox_cmd[MBOX_REG_COUNT];
>>> +	uint32_t mbox_sts[MBOX_REG_COUNT];
>>> +
>>> +	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
>>> +	memset(&mbox_sts, 0, sizeof(mbox_sts));
>>> +
>>> +	mbox_cmd[0] = MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
>>> +	mbox_cmd[1] = fw_ddb_index;
>>> +	mbox_cmd[2] = connection_id;
>>> +	mbox_cmd[3] = LOGOUT_OPTION_RESET;
>>> +
>>> +	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
>>> +		&mbox_sts[0]) != QLA_SUCCESS) {
>>> +		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_CONN_CLOSE_SESS_LOGOUT "
>>> +			      "option %04x failed sts %04X %04X",
>>> +			      ha->host_no, __func__,
>>> +			      option, mbox_sts[0], mbox_sts[1]));
>>> +		if (mbox_sts[0] == 0x4005)
>>> +			DEBUG2(printk("%s reason %04X\n", __func__,
>>> +				      mbox_sts[1]));
>>> +	}
>>> +	return QLA_SUCCESS;
>>
>> Does this logout function logout a session and stop it from being logged 
>> back in, or does it logout the session then the firmware tries to log 
>> back in?
> Once the session is logged out, it stays in that state till the user
> initiates a login. The firmware does not automatically try to login
> again.

I think we want to login in this case. Did you guys test with this 
Equalogic boxes, or what boxes did you try that send a logout request 
and always do not want you to relogin?

EQL boxes have that magic target load balancing, where if they detect a 
problem the box will send the async logout request. It then expects the 
initiator to try a relogin, and at that time it will use the login 
redirect feature to send us to a new portal.
