From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH V3 1/2] scsi: ufs: Add support for host assisted background
 operations
Date: Fri, 19 Jul 2013 22:56:25 +0900
Message-ID: <001e01ce8487$c246e300$46d4a900$%jun@samsung.com>
References: <1373361336-30713-1-git-send-email-sthumma@codeaurora.org>
 <1373361336-30713-2-git-send-email-sthumma@codeaurora.org>
 <002701ce7d71$c76a4510$563ecf30$%jun@samsung.com>
 <51DE81A2.7010700@codeaurora.org>
 <001b01ce82c5$95332bd0$bf998370$%jun@samsung.com>
 <51E7659C.8050400@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52026 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760523Ab3GSN40 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 09:56:26 -0400
In-reply-to: <51E7659C.8050400@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

On Thu, July 18, 2013, Sujit Reddy Thumma wrote:
> >>> > >I'm not sure that BKOPS with runtime-pm associates.
> >>> > >Do you think it's helpful for power management?
> >>> > >How about hibernation scheme for runtime-pm?
> >>> > >I'm testing and I can introduce soon.
> >> >
> >> >Well, I am thinking on following approach when we introduce
> >> >power management.
> >> >
> >> >ufshcd_runtime_suspend() {
> >> >	if (bkops_status >= NON_CRITICAL) { /* 0x1 */
> >> >		ufshcd_enable_auto_bkops();
> >> >		hibernate(); /* only the link and the device
> >> >			should be able to cary out bkops */
> >> >	} else {
> >> >		hibernate(); /* Link and the device for more savings */
> >> >	}
> >> >}
> >> >
> >> >Let me know if this is okay.
> > I still consider whether BKOPS is proper behavior with runtime-pm or not.
> 
> The BKOPS is something that host allows the card to carry out
> when the host knows it is idle and not expecting back to back requests.
> Runtime PM idle is the only way to know whether the device is
> idle (unless we want to reinvent the wheel to detect the idleness of
> host and trigger bkops). There was a discussion on this in MMC mailing
> list as well, and folks have agreed to move idle time bkops to runtime
> PM (http://thread.gmane.org/gmane.linux.kernel.mmc/19444/)
It looks like different.
eMMC cannot execute BKOPS itself unlike UFS.
That's the way eMMC's host should trigger the BKOPS manually.

> 
> > How about this scenario? It seems more simple.
	> > If we concern a response latency of transfer requests, BKOPS can be disabled by default.
> > And then BKOPS can be enabled whenever device requests in some exception.
> > If you have any idea, let me know.
> 
> Exceptions are raised only when the device is in critical need for
> bkops. Also the spec. recommends, host should ensure that the device
> doesn't go into such states.
> 
> With your suggestion, when we disable bkops, the exception is raised and
> we enable bkops after which there is no way to disable it again?
Yes, it's difficult to find proper time. 
Maybe, BKOPS can be disabled when request comes up.

Thanks,
Seungwon Jeon
> 
> --
> Regards,
> Sujit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

