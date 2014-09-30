From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 23/23] scsi_trace: add tracepoint for completion
Date: Tue, 30 Sep 2014 20:22:34 +0200
Message-ID: <542AF4EA.3030008@suse.de>
References: <1412077852-40893-1-git-send-email-hare@suse.de> <1412077852-40893-24-git-send-email-hare@suse.de> <20140930152123.GD28330@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaI3SWh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 14:22:37 -0400
In-Reply-To: <20140930152123.GD28330@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On 09/30/2014 05:21 PM, Christoph Hellwig wrote:
> On Tue, Sep 30, 2014 at 01:50:52PM +0200, Hannes Reinecke wrote:
>> A tracepoint should be inserted upon completion to make tracing
>> equivalent to logging.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_lib.c     |  1 +
>>   drivers/scsi/scsi_trace.c   | 16 ++++++++++++++++
>>   include/trace/events/scsi.h | 31 +++++++++++++++++++++++++++++++
>>   3 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 2df485f..5c67e4e 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1626,6 +1626,7 @@ static void scsi_softirq_done(struct request *=
rq)
>>   	}
>>
>>   	scsi_log_completion(cmd, disposition);
>> +	trace_scsi_cmd_completion(cmd, disposition);
>>
>>   	switch (disposition) {
>>   		case SUCCESS:
>> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
>> index 503594e..51a7737 100644
>> --- a/drivers/scsi/scsi_trace.c
>> +++ b/drivers/scsi/scsi_trace.c
>> @@ -286,3 +286,19 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsig=
ned char *cdb, int len)
>>   		return scsi_trace_misc(p, cdb, len);
>>   	}
>>   }
>> +
>> +const char *
>> +scsi_trace_mlreturn_name(struct trace_seq *p, int rtn)
>> +{
>> +	const char *ret =3D trace_seq_buffer_ptr(p);
>> +	const char *mlstr =3D scsi_mlreturn_string(rtn);
>> +
>> +	if (mlstr)
>> +		trace_seq_printf(p, "%s", mlstr);
>> +	else
>> +		trace_seq_printf(p, "UNKNOWN (0x%x)", rtn);
>> +
>> +	trace_seq_putc(p, 0);
>> +
>> +	return ret;
>> +}
>
> Nak, again this doesn't do the right thing for binary tracing.  Pleas=
e
> use __print_symbolic instead.
>
Okay, will be dropping it. It's of no consequence for the patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
