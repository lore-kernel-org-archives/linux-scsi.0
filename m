From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: Disable WRITE SAME for RAID and virtual host adapter drivers
Date: Wed, 23 Oct 2013 12:29:32 -0400
Message-ID: <yq1sivsdk7n.fsf@sermon.lab.mkp.net>
References: <yq1eh7cffmj.fsf@sermon.lab.mkp.net>
	<20131023161137.GA31895@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38145 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3JWQ36 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 12:29:58 -0400
In-Reply-To: <20131023161137.GA31895@infradead.org> (Christoph Hellwig's
	message of "Wed, 23 Oct 2013 09:11:37 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> @@ -3625,6 +3625,7 @@ int ata_scsi_add_hosts(struct ata_host *host,
>> struct scsi_host_template *sht)
shost-> max_lun = 1; max_channel = 1; max_cmd_len = 16;
>> + shost->no_write_same = 1;

Christoph> Unless I miss something this will disable TRIM support in
Christoph> libata entirely.

The flag effectively disables advertising REQ_WRITE_SAME support to the
block layer (max_write_same_sectors). It doesn't prevent anyone from
issuing write same commands in general. Such as the sd discard prep_fn
and users of sg/bsg.

-- 
Martin K. Petersen	Oracle Linux Engineering
