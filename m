From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 03/14] target/sbc: Add sbc_check_prot + update sbc_parse_cdb
 for DIF
Date: Sun, 12 Jan 2014 13:59:52 +0200
Message-ID: <52D283B8.6050108@dev.mellanox.co.il>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	 <1389212157-14540-4-git-send-email-nab@daterainc.com>	 <52CEB901.6030504@mellanox.com> <1389337456.5567.412.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56859 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaALL75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 06:59:57 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so935088eei.7
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 03:59:56 -0800 (PST)
In-Reply-To: <1389337456.5567.412.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, oren Duer <oren@mellanox.com>

On 1/10/2014 9:04 AM, Nicholas A. Bellinger wrote:
> On Thu, 2014-01-09 at 16:58 +0200, Sagi Grimberg wrote:
>> On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>
>>> This patch adds sbc_check_prot() for performing various DIF
>>> related CDB sanity checks, along with setting SCF_PROT once
>>> sanity checks have passed.
>>>
>>> Also, add calls in sbc_parse_cdb() for READ_[10,12,16] +
>>> WRITE_[10,12,16] to perform DIF sanity checking.
>>>
>>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Hannes Reinecke <hare@suse.de>
>>> Cc: Sagi Grimberg <sagig@mellanox.com>
>>> Cc: Or Gerlitz <ogerlitz@mellanox.com>
>>> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
>>> ---
>>>    drivers/target/target_core_sbc.c |   39 ++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 39 insertions(+)
>>>
>>> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
>>> index 52ae54e..600ffcb 100644
>>> --- a/drivers/target/target_core_sbc.c
>>> +++ b/drivers/target/target_core_sbc.c
>>> @@ -563,6 +563,27 @@ sbc_compare_and_write(struct se_cmd *cmd)
>>>    	return TCM_NO_SENSE;
>>>    }
>>>    
>>> +bool
>>> +sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
>>> +{
>>> +	if (!dev->dev_attrib.pi_prot_type)
>>> +		return true;
>>> +
>>> +	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE2_PROT &&
>>> +	   (cdb[1] & 0xe0))
>>> +		return false;
>>> +
>>> +	if (!(cdb[1] & 0xe0)) {
>>> +		pr_warn("Target: Unprotected READ/WRITE to DIF device\n");
>>> +		return true;
>>> +	}
>>> +	if (!cmd->t_prot_sg || !cmd->t_prot_nents)
>>> +		return true;
>>> +
>>> +	cmd->se_cmd_flags |= SCF_PROT;
>> Isn't this the place to fill the se_cmd DIF execution parameters?
>> prot_op, prot_type, guard_type, initial_reftag, apptag etc...
>> Next, all parties interested in DIF execution should look in se_cmd
>> (backstore, transport).
> Yes, working on this for -v2 as well.  :)

OK, so just to be clear, both the transport and the backstore will be 
look in se_cmd protection attributes when executing IO correct?

