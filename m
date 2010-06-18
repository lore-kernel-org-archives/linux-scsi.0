From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 5/5 v2]scsi:hosts.c Fix warning: variable 'rval' set	but
 not used
Date: Fri, 18 Jun 2010 14:24:54 -0700
Message-ID: <4C1BE426.30606@gmail.com>
References: <1276892167-24161-1-git-send-email-justinmattock@gmail.com> <20100618204730.GL9298@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:39711 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab0FRVYy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2010 17:24:54 -0400
Received: by pxi12 with SMTP id 12so598756pxi.19
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2010 14:24:54 -0700 (PDT)
In-Reply-To: <20100618204730.GL9298@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 06/18/2010 01:47 PM, Matthew Wilcox wrote:
> On Fri, Jun 18, 2010 at 01:16:07PM -0700, Justin P. Mattock wrote:
>> @@ -420,7 +419,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>>   	shost->ehandler = kthread_run(scsi_error_handler, shost,
>>   			"scsi_eh_%d", shost->host_no);
>>   	if (IS_ERR(shost->ehandler)) {
>> -		rval = PTR_ERR(shost->ehandler);
>> +		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error = %ld\n",
>> +			shost->host_no, PTR_ERR(shost->ehandler));
>
> Surely this should simply be:
>
> 		shost_printk(KERN_WARNING, shost, "error handler thread failed"
> 				"to spawn (%ld)\n", PTR_ERR(shost->ehandler));
>
>>   		goto fail_kfree;
>>   	}
>>
>> --
>> 1.7.1.rc1.21.gf3bd6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


the above change goes through without a warning message.. should I resend?

Justin P. Mattock
