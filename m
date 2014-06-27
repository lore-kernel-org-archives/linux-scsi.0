From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/7] scsi_error: do not use command list for host reset
Date: Fri, 27 Jun 2014 12:42:57 +0200
Message-ID: <53AD4AB1.6080205@linux.vnet.ibm.com>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <1403850425-89297-8-git-send-email-hare@suse.de> <20140627075839.GC21799@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:48077 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0KnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 06:43:08 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Fri, 27 Jun 2014 11:43:06 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0A12B219004D
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 11:42:53 +0100 (BST)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5RAh52b28573798
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 10:43:05 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5RAh0PF016023
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 04:43:03 -0600
In-Reply-To: <20140627075839.GC21799@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 06/27/2014 09:58 AM, Christoph Hellwig wrote:
>> @@ -771,7 +770,7 @@ static int scsi_try_host_reset(struct scsi_cmnd =
*scmd)
>>   		if (!hostt->skip_settle_delay)
>>   			ssleep(HOST_RESET_SETTLE_TIME);
>>   		spin_lock_irqsave(host->host_lock, flags);
>> -		scsi_report_bus_reset(host, scmd_channel(scmd));
>> +		scsi_report_bus_reset(host, -1);
>
> The old code report a bus reset for every device on the channel this
> command was on, and the new one will not report anything because
> scsi_report_bus_reset doesn't treat -1 as a wild card.  To keep the o=
ld
> behaviour you'll have to pass a channel argument here.  It's not quit=
e
> clear to me if ->eh_host_reset_handler is only supposed to reset a
> "channel" or the whole HBA, but if we want to change behavior here
> it should be a separate well documented patch.

I think Hannes' change down below in his same patch introduces a channe=
l=20
of -1 as wild card for the host reset which affects all rports of the=20
host, so I assume this would work as before?:

> @@ -2245,7 +2233,7 @@ void scsi_report_bus_reset(struct Scsi_Host *sh=
ost, int channel)
>  	struct scsi_device *sdev;
>
>  	__shost_for_each_device(sdev, shost) {
> -		if (channel =3D=3D sdev_channel(sdev))
> +		if (channel =3D=3D -1 || channel =3D=3D sdev_channel(sdev))
>  			__scsi_report_device_reset(sdev, NULL);
>  	}
>  }

--=20
Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
