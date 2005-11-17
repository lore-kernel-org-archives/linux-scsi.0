From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Thu, 17 Nov 2005 09:53:00 -0500
Message-ID: <437C994C.50206@hp.com>
References: <437BA36F.10600@hp.com> <437BA45B.20809@geizhals.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:49595 "EHLO atlrel6.hp.com")
	by vger.kernel.org with ESMTP id S1750982AbVKQOqE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 09:46:04 -0500
In-Reply-To: <437BA45B.20809@geizhals.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Renner <michael.renner@geizhals.at>
Cc: linux-scsi@vger.kernel.org

Michael Renner wrote:

> Alan D. Brunelle wrote:
>
>> I'm seeing what looks to be the same problem (see: U320 SCSI 
>> negotiation problem in Linux 2.6.13 and later implementations on LSI 
>> Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI 
>> (rev 08)). [[I think I have a patch (perhaps suspect, but it works 
>> for me), if you're interested.]]
>
>
> Yeah, I'd like to see it. Interestingly another box with the same 
> hardware setup and very slightly different .config works fine with 
> 2.6.14.
>
> best regards,
> michael
>
It doesn't surprise me that a different .config or hardware change would 
affect this. If I understand the problem correctly, then it depends upon 
timing - and changing things (hw or sw) could affect the outcome.

The posting by

The following works for me - but as noted previously, it may be suspect 
in general: I'm concerned about the indefinate delay (theoretical).

diff -ur linux-2.6.14.mm2/drivers/message/fusion/mptbase.c 
linux-2.6.14.mm2.adb/drivers/message/fusion/mptbase.c
--- linux-2.6.14.mm2/drivers/message/fusion/mptbase.c   2005-11-17 
09:17:15.000000000 -0500
+++ linux-2.6.14.mm2.adb/drivers/message/fusion/mptbase.c       
2005-11-17 10:11:52.000000000 -0500
@@ -4994,7 +4994,9 @@
        if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
                dcprintk((MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",
                                ioc->name));
-               return -EAGAIN;
+               do {
+                       msleep(25);
+               } while ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) 
== NULL);
        }
        pReq = (Config_t *)mf;
        pReq->Action = pCfg->action;

