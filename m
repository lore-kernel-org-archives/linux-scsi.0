From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 11:38:10 -0500
Message-ID: <432D97F2.5040508@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>	 <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>	 <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>	 <1126974325.10413.5.camel@max>	 <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>	 <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>	 <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local> <1127061365.800.1.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41170 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932163AbVIRSiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 14:38:15 -0400
In-Reply-To: <1127061365.800.1.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> On Sun, 2005-09-18 at 20:40 +0300, Kai Makisara wrote:
> 
>>The command triggering these problems is a 6-byte read of 10240 bytes. It 
>>should not a this point return anything but finish with some sense data.
>>
>>I am debugging the problem but it is going slowly because the system disk 
>>is a SCSI disk. I have to be careful with the debugging output and changes 
>>outside st.c require a reboot ;-) So far I have found out that 
>>scsi_check_sense() is called correctly and returns SUCCESS as it should. 
>>What happens after that is a mystery.
>>
> 
> 
> I think something like this would give us something like the old
> behavior back. This way we do not let scsi_io_completion further process
> the error.
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1126,7 +1126,7 @@ static int scsi_issue_flush_fn(request_q
>  static void scsi_generic_done(struct scsi_cmnd *cmd)
>  {
>  	BUG_ON(!blk_pc_request(cmd->request));
> -	scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);
> +	scsi_io_completion(cmd, cmd->bufflen, 0);
>  }
>  
>  static int scsi_prep_fn(struct request_queue *q, struct request *req)
> 

this is over 1-6 of my other patches.
