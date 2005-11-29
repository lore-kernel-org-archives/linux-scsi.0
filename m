From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Tue, 29 Nov 2005 17:11:42 +1000
Message-ID: <438BFF2E.20407@torque.net>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B76@xbl3.emulex.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:61925 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751338AbVK2HKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 02:10:37 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B76@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@infradead.org, stefanr@s5r6.in-berlin.de, linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
>>So you this storage vendor please provide us this test case 
>>as a start?
> 
> 
> Basic test case:
>  - start load on the fc disks
>  - run sg_reset -b /dev/sgX or sg_reset -d /dev/sgX
> 
> 
>>That beeing said I mentioned that we need to do SG-based 
>>resets via the
>>EH thread aswell.  As Emulex apparently cares about the above 
>>case would
>>you mind implementing it?
> 
> 
> Well - we would prefer the vendor test the system as it should behave
> in normal circumstances rather than test-suite-derived conditions.
> 
> Yes, we will sign up for this. However, we have several items on our
> plate so we won't be on this quickly. I would hope there would be no
> issue with accepting the patch as is and backing out the relatived code
> as part of the eventual patch.  We'll also be contacting the SG maintainer
> to get his/her thoughts.

While on the subject of resets, linux still has a
fuzziness around a "device" reset. There should be
two resets around this level:
  - target reset: reset a target device, its ports and
    all logical units within it [transport level]
  - logical unit reset: reset a logical unit only
    [this is a mandatory SCSI task management function]

If changes are being made in this area, then perhaps
this fuzziness should be addressed.

Doug Gilbert

