From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [RFC][PATCH]SCSI signal(I/O) failure causes no response
Date: Wed, 14 Apr 2004 11:23:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570442C1A5@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36042 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264252AbUDNPXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Apr 2004 11:23:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org

The original request from Masao Fukuci was this:


 * than an unsolicited DID_ABORT.
 */
   sc->result = DID_RESET << 16;
+  if (++did_reset_cnt >= 5) {
+	sc->result = DID_SOFT_ERROR << 16;
+	did_reset_cnt = 0;
+  }


I wasn't too comfortable for the LLD to handle
retry count with DID_RESET, to transition to
DID_SOFT_ERROR. My thoughts were the DID_RESET logic
in scsi-mid layer should be handling retry count
to address infinite loop, as this same issue would
occur to any LLD.

Eric



On Tuesday, April 13, 2004 7:08 PM, Masao Fukuchi wrote:

> 
> 
> Hi all,
> 
> We are planning to use linux for enterprise server.
> Since the response time on hardware failure is important factor,
> we are measuring the response time in case of the error by making
> pseudo errors.
> 
> We generated some SCSI signal failure in the test.
> When I cut the I/O signal during read command from host, 
> I expected the command finished with error soon.
> But the result was the command didn't finish forever(and no error
> message was displayed).
> 
> I added some messages in order to investigate what has occurred.
> From the messages, the sequence was:
> 
> 1.Fusion MPT driver issues read command to its firmware.
>   (our server has LSI53C1030 as SCSI adapter)
>   Then the firmware returns protocol error for the command.
>   Fusion MPT driver makes DID_RESET status by protocol error 
>   and sends it to SCSI midlayer.
> 
> 2.SCSI midlayer analyzes the status from LLD.
>   SCSI midlayer schedules command retry because the status is just
>   DID_RESET status.
>   (When the status has DID_RESET plus some sense code, the retry
>    sequence depends on the sense code. But when the status has only
>    DID_RESET, SCSI midlayer schedules command retry)
> 
> Sequence 1. and 2. are repeated infinitely and it causes no response.
> 
> To prevent this problem, I proposed Eric Moore to change the DID_RESET
> status to DID_SOFT_ERROR in fusion MPT driver.
> But he suggested me to change SCSI midlayer to prevent infinite loop.
> 
> So, I made following patch to prevent the problem.
> (patch is based on kernel 2.6.5)
> 
> Comments welcome.
> 
> Thanks,
> Masao Fukuchi
> 
> ///
> diff -uarN linux-2.6.5/drivers/scsi/scsi_lib.c 
> linux-didreset/drivers/scsi/scsi_lib.c
> --- linux-2.6.5/drivers/scsi/scsi_lib.c	2004-04-13 
> 18:53:52.000000000 +0900
> +++ linux-didreset/drivers/scsi/scsi_lib.c	2004-04-13 
> 20:32:23.000000000 +0900
> @@ -852,8 +852,10 @@
>  		 * recovery reasons.  Just retry the request
>  		 * and see what happens.  
>  		 */
> -		scsi_requeue_command(q, cmd);
> -		return;
> +		if (++cmd->retries < cmd->allowed) {
> +			scsi_requeue_command(q, cmd);
> +			return;
> +		}
>  	}
>  	if (result) {
>  		printk("SCSI error : <%d %d %d %d> return code 
> = 0x%x\n",
> 
