From: "Zhao Forrest" <forrest.zhao@gmail.com>
Subject: Re: MPTSAS Driver and scatter gather lists
Date: Tue, 11 Dec 2007 16:18:38 +0800
Message-ID: <ac8af0be0712110018s647b0d04o5dc96dbe318a9759@mail.gmail.com>
References: <47557600.5040902@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:34657 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbXLKISk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2007 03:18:40 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3863212wah
        for <linux-scsi@vger.kernel.org>; Tue, 11 Dec 2007 00:18:40 -0800 (PST)
In-Reply-To: <47557600.5040902@austin.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org

Steve,
Do you use a 10k RPM SAS hard drive? Could you share that what test
tools(or test cases) are you using to do the block IO test? We have a
LSI SAS1068E chip and 10k RPM SAS hard drive in our lab. I'll find
some time to reproduce the issue and do some investigation.

Thanks,
Forrest

On 12/4/07, Steven Pratt <slpratt@austin.ibm.com> wrote:
> I was doing some performance comparisons between the aic94xx sas adapter
> and the mptsas (lsi1078 chip) and saw that performance was slightly
> lower on lsi using the same drive. One thing I noticed the mptsas driver
> was only setting sg_tablesize to 40 which restricts the maximum size of
> the IO to 160kb.  This is inefficient and so I changed it to 255 (max
> value) for testing purposes.  The results were not what I expected.
> While CPU efficiency was improved at the larger block sizes (like I had
> hopped), there were drastic improvements at small (<16k) block sizes
> which is completely surprising).  So I decided to see where all the time
> was being spent.  When doing oprofile, loss of idle ticks was confusing
> things so I booted with idle=poll, and magically the original mptsas
> driver now performs like the modified version at the small block sizes.
> My suspicion is that we have some some sleep delay which is minimized by
> going into poll mode, but I have no idea why changing the sg_tablesize
> gives the same results regardless of poll mode.  I should reiterate that
> I am not talking about small difference. This is 2x performance at 1/3 cpu.
>
> Also, is there any reason we can't increase sg_tablesize for mptsas?
>
> Any thoughts or experiments to try are welcome.
> Steve
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
