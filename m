From: Sakurai Hiroomi <sakurai_hiro@soft.fujitsu.com>
Subject: Re: [BUG][RFC][PATCH] dpt_i2o driver in 2.4
Date: Thu, 20 Jan 2005 17:21:54 +0900
Message-ID: <0IAL00GBAWF2YH@simsproxy3.soft.fujitsu.com>
References: <60807403EABEB443939A5A7AA8A7458BA3C4AB@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:64165 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S262074AbVATISl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 03:18:41 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72]) by fgwmail6.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id j0K8IdqK010363 for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2005 17:18:39 +0900
	(envelope-from sakurai_hiro@soft.fujitsu.com)
Received: from s6.gw.fujitsu.co.jp by m2.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id j0K8Idf1005346 for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2005 17:18:39 +0900
	(envelope-from sakurai_hiro@soft.fujitsu.com)
Received: from s6.gw.fujitsu.co.jp (s6 [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id E28A23CE3DA
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2005 17:18:38 +0900 (JST)
Received: from simsproxy3.soft.fujitsu.com (simsproxy3.soft.fujitsu.com [10.124.20.12])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id A00E23CE3DB
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2005 17:18:38 +0900 (JST)
Received: from simsproxy2.soft.fujitsu.com ([10.124.103.64])
 by simsproxy3.soft.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0IAL00GB8WEZYH@simsproxy3.soft.fujitsu.com> for
 linux-scsi@vger.kernel.org; Thu, 20 Jan 2005 17:18:38 +0900 (JST)
In-reply-to: <60807403EABEB443939A5A7AA8A7458BA3C4AB@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, hiroomi sakurai <sakurai_hiro@soft.fujitsu.com>

Thank you Mark,

I appreciate your quick response.


Best Regards
Hiroomi Sakurai


"Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:

> I am pouring through the inspection. The Adaptec branch (which works in
> both 2.4 and 2.6 kernels, and in 64 bit architectures) of the driver has
> been patched to some of these suggestions and has been included for your
> information.
> 
> 1) The driver is capable of instantiating a subset of the available
> adapters, doing the adpt_i2o_sys_shutdown and/or returning 0 on a single
> failure to instantiate would break that feature. The Adapter has not
> gone through startup until after adpt_i2o_activate_hba, there is no
> reason to do an adpt_i2o_sys_shutdown. The linux community may not wish
> that a driver instantiate a subset of the hardware without failing, so
> your point may be entirely valid; I am hoping for some community
> comment.
> 
> 2) A valid concern, but the architectural decision at this point was
> that adpt_inquiry would never fail. And if it did, it still did not
> represent a reason to fail the adapter in the absence of all other
> failures. It was an `informational' request for an adapter name. We had
> versions of (internal) firmware that failed this call and still
> functioned properly in all other respects.
> 
> 3) Our latest driver has this patch in another form regarding the check
> for pScsi_dev null. This patch is a requirement; we have seen this
> failure mode.
> 
> 4) Good catch, I have added your patch that prevents falling through to
> the instantiating code when exceeding the maximum number of adapters to
> the Adaptec branch. I agree, a better choice is to have no limits, but I
> was bit once by a pci bus that had *multitudes* of the adapter
> replicated :-) The management applications have the same hard-coded
> limit (that is no reason for the driver to match it though)
> 
> 5) Good catch, I had added your patch that checks the id parameter.
> 
> 6) Good catch. We have never experienced this possible data corruption
> from the adapter, but one can never be too paranoid in this case since
> it is a subsystem that could misbehave. Checking the bus_no and scsi_id
> is highly recommended and has been added to the Adaptec Branch of the
> driver (except that I switched to the C style comment).
> 
> 7) Out latest driver already has this patch in another form regarding
> the check for pScsi_dev null. This patch is a requirement; we have seen
> this failure mode.
> 
> 8) It is not a failure to be unable to acquire the blinkLED or debug
> buffers from the adapter. By itself, this failure does not justify
> failing the adapter, especially since there are older (DPT PM2554)
> adapters that did not have this scalar.
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: Salyzyn, Mark 
> Sent: Tuesday, January 18, 2005 8:34 AM
> To: 'Sakurai Hiroomi'
> Subject: RE: [BUG][RFC][PATCH] dpt_i2o driver in 2.4
> 
> The driver Adaptec has in its maintained branch is enclosed. I will take
> the inspection report and apply it to this driver.
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Sakurai Hiroomi
> Sent: Tuesday, January 18, 2005 12:41 AM
> To: linux-scsi@vger.kernel.org
> Cc: hiroomi sakurai
> Subject: [BUG][RFC][PATCH] dpt_i2o driver in 2.4
> 
> Dear Mark,
> 
> Our Linux server uses adaptec ASR-2010S and we are using dpt_i2o driver.
> To raise the reliability of the server, we reviewd the dpt_i2o driver.
> # The version of driver is 2.4 Build 5 in linux-2.4.28.
> 
> We found some problems and questions.
> 
> Please see the attached the dpt_i2o_problem_document.txt about the
> problems. 
> And also I made a patch agains the driver(dpt_i2o.diff).
> 
> I'm not participated in the linux-scsi mailing list.
> Please reply to the following addresses. 
> 
>     E-Mail : sakurai_hiro@soft.fujitsu.com
> 
> Best Regards
> Hiroomi Sakurai
> 


_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
  サーバシステム事業本部
  Linuxソフトウェア開発統括部
  櫻井 宏臣 (Hiroomi Sakurai)
  E-mail:sakurai_hiro@soft.fujitsu.com
_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

