From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Checkin 7404ad3b6d04efbd918e9e2e776bf560fbedf47d breaks boot
	on KVM
Date: Tue, 14 Oct 2008 14:35:42 -0400
Message-ID: <1224009342.12440.18.camel@localhost.localdomain>
References: <48F3E1C9.6030007@zytor.com>
	 <1223990609.12440.8.camel@localhost.localdomain>
	 <48F4DF3E.2050903@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59005 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbYJNSgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 14:36:05 -0400
In-Reply-To: <48F4DF3E.2050903@zytor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-10-14 at 11:04 -0700, H. Peter Anvin wrote:
> James Bottomley wrote:
> >>
> >> :040000 040000 98fc7ae95211b8d16e2e8ca46997be660ad9ba93 
> >> 2d35d0a2b6232411b840a9ccf6a52b946172566e M      drivers
> >>
> >> However, simply reverting this commit caused a panic on boot (not 
> >> entirely surprising.)
> > 
> > Actually, it is surprising.  That patch takes the default arithmetic for
> > calculating the disk size out of sd and uses a routine to do it more
> > efficiently in lib/string_helpers.c
> > 
> > So there are two problems:  Why does it panic on revert (could you post
> > the oops) and what does kvm object to in string_get_size ... it's a
> > fairly innocuous routine as I read it ... your symptoms sound like the
> > for loop isn't terminating.
> > 
> 
> Looks like it's trying to print a zero.  I made a diff to print out the 
> raw numbers, and did indeed get zero.
> 
> Now, *why* it is printing a zero is another matter (as is why using 
> ffz() instead of ilog2() there...).  Some quick investigation showed 
> that sdkp->capacity is a 32-bit quantity in this configuration, and 
> shifting it left by 9 of course ends up with zero; being a virtual disk, 
> it's an exact power of two.
> 
> Still, it is bad that string_get_size() hangs on passing zero.
> 
> The spinlock lockup is still happening, so I'm assuming it is an 
> unrelated bug that was masked by the string_get_size issue.
> 
> Patch series will follow shortly.

Does this fix it?

James

---

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 8347925..b5acbe9 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -45,7 +45,7 @@ int string_get_size(u64 size, const enum string_size_units units,
 		remainder = do_div(size, divisor[units]);
 
 	sf_cap = size;
-	for (j = 0; sf_cap*10 < 1000; j++)
+	for (j = 0; sf_cap != 0 && sf_cap*10 < 1000; j++)
 		sf_cap *= 10;
 
 	if (j) {


