From: Sakurai Hiroomi <sakurai_hiro@soft.fujitsu.com>
Subject: Re: [PATCH] dpt_i2o underflow check (Was: dpt_i2o and sd driver's problem)
Date: Fri, 19 May 2006 09:54:51 +0900
Message-ID: <20060519005141.AB3171C00B@mail2-sv.soft.fujitsu.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F02727AF7@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47239 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S932154AbWESAvr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 20:51:47 -0400
Received: from m0.gw.fujitsu.co.jp ([10.0.50.70])
        by fgwmail6.fujitsu.co.jp (Fujitsu Gateway)
        with ESMTP id k4J0phUk020664 for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 09:51:43 +0900
        (envelope-from sakurai_hiro@soft.fujitsu.com)
Received: from smail (m0 [127.0.0.1])
	by outgoing.m0.gw.fujitsu.co.jp (Postfix) with ESMTP id F09A457808B
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 09:51:42 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (vs3.gw.fujitsu.co.jp [10.0.50.63])
	by m0.gw.fujitsu.co.jp (Postfix) with ESMTP id B354171807E
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 09:51:42 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1 [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 932D03B4175
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 09:51:42 +0900 (JST)
Received: from mail2-sv.soft.fujitsu.com (smtp.soft.fujitsu.com [10.124.20.53])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 0009D3B4176
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 09:51:41 +0900 (JST)
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F02727AF7@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Dear Mark,

Thank you.
I appreciate your quick response.

Best Regards
Hiroomi Sakurai

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:

> I agree, the math for underflow is flawed for block sizes other than
> 512, but I leave it up to the community to decide if there is some
> history behind this decision. This math has remained this way 'forever'.
> 
> The dpt_i2o driver should have the following (and more accurately
> enclosed) patch to match up with what other sections of code in this
> driver are doing with regards to the underflow check. Other drivers all
> appear to be performing the underflow check in this manner.
> 
>          len = cmd->request_bufflen;
> 
> -        if(cmd->underflow && len != cmd->underflow){
> +        if(cmd->underflow && len < cmd->underflow){
>                  printk(KERN_WARNING"Cmd len %08X Cmd underflow %08X\n",
>                          len, cmd->underflow);
>          }
> 
> Sincerely -- Mark Salyzyn
> 


