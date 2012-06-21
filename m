From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 2/7] Revert "usb/uas: one only one status URB/host on
 stream-less connection"
Date: Thu, 21 Jun 2012 10:41:21 +0200
Message-ID: <4FE2DE31.6030006@redhat.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com> <1340092494-18876-3-git-send-email-kraxel@redhat.com> <20120620235644.GD31520@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838Ab2FUIlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jun 2012 04:41:25 -0400
In-Reply-To: <20120620235644.GD31520@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/21/12 01:56, Greg KH wrote:
> On Tue, Jun 19, 2012 at 09:54:49AM +0200, Gerd Hoffmann wrote:
>> This reverts commit ceb3f91fd53c9fbd7b292fc2754ba4efffeeeedb.
>>
>> IMO the real bug is assigning status urbs to scsi requests.  First there
>> is no such link in the non-stream case.  Also there isn't nessesarely a
>> scsi request in the first place, for example when submitting task
>> management requests.
>>
>> This patch just papers over the real bug and introduces different status
>> urb handling in the stream/non-stream case for no good reason.
>>
>> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>>  drivers/usb/storage/uas.c |   70 ++++++--------------------------------------
>>  1 files changed, 10 insertions(+), 60 deletions(-)
> 
> Same here, should this also be reverted in 3.4-stable?

Well, even though the reverted patch is clumsy and takes the wrong
direction, it actually does the job and fixes the issue at hand.

When reverting in stable patch #3 of this series (which fixes the issue
in a better way) must be cherry-picked into stable too, otherwise we'll
get a regression.

I'd tend to not revert this one in stable though.

cheers,
  Gerd


