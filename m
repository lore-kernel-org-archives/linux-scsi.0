From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Fri, 01 Feb 2008 14:50:36 +0300
Message-ID: <47A3078C.10704@vlnb.net>
References: <adazluoe2t3.fsf@cisco.com> <20080130083239E.fujita.tomonori@lab.ntt.co.jp> <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com> <20080130195635T.tomof@acm.org> <1201785938.7280.105.camel@haakon2.linux-iscsi.org> <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com> <47A1EE54.6000005@vlnb.net> <47A1F67C.4020300@scalableinformatics.com> <e2e108260801310908k516f588cv51c18486b4a495d2@mail.gmail.com> <1201803135.21160.8.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:44454 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758781AbYBAMNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 07:13:47 -0500
In-Reply-To: <1201803135.21160.8.camel@lap75545.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, landman@scalableinformatics.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, fujita.tomonori@lab.ntt.co.jp, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, FUJITA Tomonori <tomof@acm.org>, torvalds@linux-foundation.org

David Dillow wrote:
> On Thu, 2008-01-31 at 18:08 +0100, Bart Van Assche wrote:
> 
>>If anyone has a suggestion for a better test than dd to compare the
>>performance of SCSI storage protocols, please let it know.
> 
> 
> xdd on /dev/sda, sdb, etc. using -dio to do direct IO seems to work
> decently, though it is hard (ie, impossible) to get a repeatable
> sequence of IO when using higher queue depths, as it uses threads to
> generate multiple requests.

This utility seems to be a good one, but it's basically the same as 
disktest, although much more advanced.

> You may also look at sgpdd_survey from Lustre's iokit, but I've not done
> much with that -- it uses the sg devices to send lowlevel SCSI commands.

Yes, it might be worth to try. Since fundamentally it's the same as 
O_DIRECT dd, but with a bit less overhead on the initiator side (hence 
less initiator side latency), most likely it will show ever bigger 
difference, than it is with dd.

> I've been playing around with some benchmark code using libaio, but it's
> not in generally usable shape.
> 
> xdd:
> http://www.ioperformance.com/products.htm
> 
> Lustre IO Kit:
> http://manual.lustre.org/manual/LustreManual16_HTML/DynamicHTML-20-1.html

