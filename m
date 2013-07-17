From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH V3 1/2] scsi: ufs: Add support for host assisted background
 operations
Date: Wed, 17 Jul 2013 17:13:56 +0900
Message-ID: <001b01ce82c5$95332bd0$bf998370$%jun@samsung.com>
References: <1373361336-30713-1-git-send-email-sthumma@codeaurora.org>
 <1373361336-30713-2-git-send-email-sthumma@codeaurora.org>
 <002701ce7d71$c76a4510$563ecf30$%jun@samsung.com>
 <51DE81A2.7010700@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13801 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab3GQIOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jul 2013 04:14:04 -0400
In-reply-to: <51DE81A2.7010700@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

On Thu, July 11, 2013, Sujit Reddy Thumma wrote:
> On 7/10/2013 7:01 PM, Seungwon Jeon wrote:
> > I'm not sure that BKOPS with runtime-pm associates.
> > Do you think it's helpful for power management?
> > How about hibernation scheme for runtime-pm?
> > I'm testing and I can introduce soon.
> 
> Well, I am thinking on following approach when we introduce
> power management.
> 
> ufshcd_runtime_suspend() {
> 	if (bkops_status >= NON_CRITICAL) { /* 0x1 */
> 		ufshcd_enable_auto_bkops();
> 		hibernate(); /* only the link and the device
> 			should be able to cary out bkops */
> 	} else {
> 		hibernate(); /* Link and the device for more savings */
> 	}
> }
> 
> Let me know if this is okay.
I still consider whether BKOPS is proper behavior with runtime-pm or not.
How about this scenario? It seems more simple.
If we concern a response latency of transfer requests, BKOPS can be disabled by default.
And then BKOPS can be enabled whenever device requests in some exception.
If you have any idea, let me know.

Thanks,
Seungwon Jeon

