From: "Shirron, Stephen" <Stephen.Shirron@lsi.com>
Subject: RE: LSI Logic 40919o fibre channel: scsi works ip not
Date: Thu, 20 Sep 2007 11:48:18 -0600
Message-ID: <F6F6225F9738D94FB5B5876E3707A9190195946C@NAMAIL2.ad.lsil.com>
References: <200702152306.25374.mgiammarco-ml@4warding.com> <eaa59be00703051138r1a2382cfmec9d8c3258e557ae@mail.gmail.com> <F6F6225F9738D94FB5B5876E3707A919011B4D9C@NAMAIL2.ad.lsil.com> <200709201734.13350.mgiammarco-ml@4warding.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42794 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbXITR4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 13:56:04 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200709201734.13350.mgiammarco-ml@4warding.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mario Giammarco <mgiammarco-ml@4warding.com>
Cc: Mario Giammarco <mgiammarco@gmail.com>, "Hickerson, Roger" <Roger.Hickerson@lsi.com>, linux-scsi@vger.kernel.org

Hi Mario,

Our internal driver kits have been fixed, but there has been a
delay in pushing this fix (along with other required changes)
out to kernel.org.  We are anticipating that the fix for this
issue will show up in kernel 2.6.24 (2.6.23 is essentially
closed).

stephen 

-----Original Message-----
From: Mario Giammarco [mailto:mgiammarco-ml@4warding.com] 
Sent: Thursday, September 20, 2007 11:34 AM
To: Shirron, Stephen
Cc: Mario Giammarco; Hickerson, Roger; linux-scsi@vger.kernel.org
Subject: Re: LSI Logic 40919o fibre channel: scsi works ip not

Il Monday 05 March 2007 20:46:10 Shirron, Stephen ha scritto:
> The code should look like this, in mpt_lan_post_receive_buckets():
>
> 			goto out;
> 		}
> 		pRecvReq = (LANReceivePostRequest_t *) mf;
>
> 		i = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
> 		mpt_dev->RequestNB[i] = 0;
>
> 		count = buckets;
> 		if (count > max)
> 			count = max;
>
> If you send me mptlan.c, I will edit it for you.  Then there cannot
> be a mistake.
>
> stephen
>
> -----Original Message-----
> From: Mario Giammarco [mailto:mgiammarco@gmail.com]
> Sent: Monday, March 05, 2007 2:39 PM
> To: Shirron, Stephen
> Cc: Mario Giammarco; Hickerson, Roger
> Subject: Re: LSI Logic 40919o fibre channel: scsi works ip not
>
> Sorry for delay replying. I have seen kernel 2.6.18 and 2.6.20 source
> and these lines are missinig:
>
>    i = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
>                 mpt_dev->RequestNB[i] = 0;
>
> I do not understand where to put them. Perhaps inside the for loop (i
> is the loop variable...) but I do not understand if I can choose a
> random point or I have to put it in a specific place.
>
> Thanks again for interest!
>
>
> 2007/2/16, Shirron, Stephen <Stephen.Shirron@lsi.com>:
> Mario,
>
> There appears to be a bug in the driver.
>
> Go to mpt_lan_post_receive_buckets(), in mptlan.c.  Find:
>
>                 mf = mpt_get_msg_frame(LanCtx, mpt_dev);
>
> Later find:
>
>                 pRecvReq = (LANReceivePostRequest_t *) mf;
>
> Below that, should be:
>
>                 i =
le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
>                 mpt_dev->RequestNB[i] = 0;
>
> The above two lines of code are present in some versions of mptctl.c
> (the 2.06.xx versions and 3.02.xx versions) but are missing from some
> others (3.03.xx, 3.04.xx, and 4.00.xx).
>
> If you can add those two lines of code, rebuild mptctl.ko, and retest,
> I believe that should take care of your reported problems.
>
> Let me know, please.
>
> stephen


Hello,
month ago I replied to you saying that this patch solved my bug.

Today I am trying kernel 2.6.22 and I see that it does not contain yet
the 
patch.

Can you please put the patch in official driver?

Thank you very much!

Mario Giammarco
