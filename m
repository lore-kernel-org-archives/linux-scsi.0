From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] iscsi: Fix some debug printf types
Date: Tue, 13 Jan 2009 09:20:37 -0800
Message-ID: <496CCD65.3030000@oracle.com>
References: <496B621A.6000300@panasas.com> <200901130811.29281.list2008@lunch.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:35871 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbZAMRWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2009 12:22:18 -0500
In-Reply-To: <200901130811.29281.list2008@lunch.za.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew McGill <list2008@lunch.za.net>
Cc: open-iscsi@googlegroups.com, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>

Andrew McGill wrote:
> My man page for (glibc) printf says that "Z" is specific to libc5, and 
> that "z" is better -- man -P 'less -p" z "' fprintf   Does the underlying 
> printf support "Z" rather than "z"?
> 
> QOTD>>
>  z 
>   A following integer conversion corresponds to a size_t or ssize_t argument.
>   (Linux libc5 has Z with this meaning. Don't use it.)
> 
> &:-)

Agreed.  We are trying to use small z instead of big Z in Linux
since small z is ANSI C.

> 
> On Monday 12 January 2009 17:30:34 Boaz Harrosh wrote:
>> A couple of prints at lib/iscsi_tcp had the %Z missing from the
>> kprint format string. Just to show that debug_prints are not enabled
>> much.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/iscsi_tcp.c    |    2 +-
>>  drivers/scsi/libiscsi_tcp.c |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
>> index 23808df..a566aa9 100644
>> --- a/drivers/scsi/iscsi_tcp.c
>> +++ b/drivers/scsi/iscsi_tcp.c
>> @@ -415,7 +415,7 @@ iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn
>> *conn, void *data, struct hash_desc *tx_hash = NULL;
>>  	unsigned int hdr_spec_len;
>>
>> -	debug_tcp("%s(%p, datalen=%d%s)\n", __func__, tcp_conn, len,
>> +	debug_tcp("%s(%p, datalen=%Zd%s)\n", __func__, tcp_conn, len,
>>  		  conn->datadgst_en? ", digest enabled" : "");
>>
>>  	/* Make sure the datalen matches what the caller
>> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
>> index a745f91..12354c5 100644
>> --- a/drivers/scsi/libiscsi_tcp.c
>> +++ b/drivers/scsi/libiscsi_tcp.c
>> @@ -356,7 +356,7 @@ iscsi_segment_seek_sg(struct iscsi_segment *segment,
>>  	struct scatterlist *sg;
>>  	unsigned int i;
>>
>> -	debug_scsi("iscsi_segment_seek_sg offset %u size %llu\n",
>> +	debug_scsi("iscsi_segment_seek_sg offset %u size %Zu\n",
>>  		  offset, size);
>>  	__iscsi_segment_init(segment, size, done, hash);
>>  	for_each_sg(sg_list, sg, sg_count, i) {


-- 
~Randy
