From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH V3 1/2] scsi: ufs: Add support for host assisted background
 operations
Date: Fri, 19 Jul 2013 23:56:22 +0530
Message-ID: <51E984CE.3010207@codeaurora.org>
References: <1373361336-30713-1-git-send-email-sthumma@codeaurora.org> <1373361336-30713-2-git-send-email-sthumma@codeaurora.org> <002701ce7d71$c76a4510$563ecf30$%jun@samsung.com> <51DE81A2.7010700@codeaurora.org> <001b01ce82c5$95332bd0$bf998370$%jun@samsung.com> <51E7659C.8050400@codeaurora.org> <001e01ce8487$c246e300$46d4a900$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <001e01ce8487$c246e300$46d4a900$%jun@samsung.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


>>>>>>> I'm not sure that BKOPS with runtime-pm associates.
>>>>>>> Do you think it's helpful for power management?
>>>>>>> How about hibernation scheme for runtime-pm?
>>>>>>> I'm testing and I can introduce soon.
>>>>>
>>>>> Well, I am thinking on following approach when we introduce
>>>>> power management.
>>>>>
>>>>> ufshcd_runtime_suspend() {
>>>>> 	if (bkops_status >= NON_CRITICAL) { /* 0x1 */
>>>>> 		ufshcd_enable_auto_bkops();
>>>>> 		hibernate(); /* only the link and the device
>>>>> 			should be able to cary out bkops */
>>>>> 	} else {
>>>>> 		hibernate(); /* Link and the device for more savings */
>>>>> 	}
>>>>> }
>>>>>
>>>>> Let me know if this is okay.
>>> I still consider whether BKOPS is proper behavior with runtime-pm or not.
>>
>> The BKOPS is something that host allows the card to carry out
>> when the host knows it is idle and not expecting back to back requests.
>> Runtime PM idle is the only way to know whether the device is
>> idle (unless we want to reinvent the wheel to detect the idleness of
>> host and trigger bkops). There was a discussion on this in MMC mailing
>> list as well, and folks have agreed to move idle time bkops to runtime
>> PM (http://thread.gmane.org/gmane.linux.kernel.mmc/19444/)
> It looks like different.
> eMMC cannot execute BKOPS itself unlike UFS.
> That's the way eMMC's host should trigger the BKOPS manually.
>

I guess it is not much of a difference for UFS as far as we concern
only about idle time bkops. In UFS one can still disallow the device to
not carry out BKOPS and hence the case where UFS device also cannot
execute BKOPS itself and a idle timer is needed to allow BKOPS
sporadically so that device doesn't go into URGENT_BKOPS state.

>>
>>> How about this scenario? It seems more simple.
> 	> > If we concern a response latency of transfer requests, BKOPS can be disabled by default.
>>> And then BKOPS can be enabled whenever device requests in some exception.
>>> If you have any idea, let me know.
>>
>> Exceptions are raised only when the device is in critical need for
>> bkops. Also the spec. recommends, host should ensure that the device
>> doesn't go into such states.
>>
>> With your suggestion, when we disable bkops, the exception is raised and
>> we enable bkops after which there is no way to disable it again?
> Yes, it's difficult to find proper time.
> Maybe, BKOPS can be disabled when request comes up.
>
In cases where there are back-to-back heavy data write requests then it
is not proper to enable/disable BKOPS as soon as the new request comes
up. It may happen that the card will then move from PERFORMANCE_IMPACT
state to CRITICAL and ultimately start failing the requests. The point
is that we should never get into state where we need URGENT_BKOPS.

-- 
Regards,
Sujit
