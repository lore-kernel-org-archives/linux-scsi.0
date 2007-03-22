From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] aacraid: Add likely() and unlikely()
Date: Thu, 22 Mar 2007 10:24:28 +0100
Message-ID: <1174555468.1158.166.camel@laptopd505.fenrus.org>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF0172BF0A@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34016 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852AbXCVJ02 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2007 05:26:28 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF0172BF0A@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2007-03-21 at 15:43 -0400, Salyzyn, Mark wrote:
> Add some likely() and unlikely() compiler hints in some of the aacraid
> hardware interface layers. There should be no operational side effects
> resulting from this patch and the changes should be mostly benign on x86
> platforms.
> 
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
> handling of patches attachments.
> 
> This attached patch is against current scsi-misc-2.6

-               if((fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT)){
+               if(unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT)){
                        return -ETIMEDOUT;
                } else {
                        return 0;

while you're at it, please remove the extra {}'s as well

(I assume you're aware that likely/unlikely should only be used for 99:1
or higher ratios, this one looks correct for sure)

Also I suggest you don't add about half of these; they appear init time
only code, at which point adding likely/unlikely is just code noise that
clutters the driver...
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

