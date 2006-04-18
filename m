From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 2/2] libata: Use scsi_device max_cmd_len (resend)
Date: Tue, 18 Apr 2006 09:01:59 -0500
Message-ID: <4444F157.2010504@us.ibm.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com> <44441B41.40206@us.ibm.com> <44441C3D.80906@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <44441C3D.80906@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Brian King wrote:
>> @@ -4573,7 +4567,7 @@ static void ata_host_init(struct ata_por
>>  	host->max_lun = 1;
>>  	host->max_channel = 1;
>>  	host->unique_id = ata_unique_id++;
>> -	host->max_cmd_len = 12;
>> +	host->max_cmd_len = ATAPI_CDB_LEN;
>>  
> 
> 
> Have you audited the code paths to ensure that a CDB of length 15 is 
> _NEVER_ sent, before ata_scsi_dev_config() is called?

Yes. I don't see any problems. slave_configure is called before any
upper layer drivers are attached and before anything shows up in sysfs,
so that limits us to libata initiated commands issued as part of the
port probe process and scsi core initiated commands issued as part of
device scanning. All the commands libata issues as part of the port
probe process are issued through ata_exec_internal, which does not go
through scsi core, so there is no protection there today. scsi core
only issues inquiry and report luns commands as part of scanning, both
of which are not an issue.

> The current code intentionally uses the minimum -- 12 -- and then raises 
> it if both device and host are capable of more.

Actually, the current code does not allow for an ata host to limit the
max CDB length. ata_host_init initializes host->max_cmd_len to 12, then 
ata_dev_configure zeroes out ap->host->max_cmd_len, then sets it to the
maximum CDB length supported by any of the devices on that host. The obvious
followup patch to this one would be to change all the users of libata
to have them initialize scsi_host_template->max_cmd_len and remove that code
from ata_host_init.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
