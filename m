From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: JMS56x not working reliably with uas driver
Date: Tue, 27 Dec 2016 23:52:42 +0530
Message-ID: <ab607030-bb4f-f6ac-755b-f38e7cd13be7@caviumnetworks.com>
References: <Pine.LNX.4.44L0.1612271015100.21478-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0081.outbound.protection.outlook.com ([104.47.33.81]:40543
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752673AbcL0SiT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Dec 2016 13:38:19 -0500
In-Reply-To: <Pine.LNX.4.44L0.1612271015100.21478-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>
Cc: hdegoede@redhat.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

Hi Alan,


On Tuesday 27 December 2016 08:50 PM, Alan Stern wrote:
> On Tue, 27 Dec 2016, Oliver Neukum wrote:
>
>> On Thu, 2016-12-22 at 17:44 -0500, Alan Stern wrote:
>>> I don't see how this patch fixes anything.  Unless I'm mistaken, it
>>> just avoids the problem by preventing the system from issuing the
>>> command that provokes the error, rather than really fixing the
>>> underlying error.
>> Please clarify. If a reset leads to a disconnect, isn't that
>> exactly what we want?
> I didn't express myself clearly enough.  Yes, if a reset leads to a
> disconnect then avoiding the reset will avoid problems.
>
> But the _real_ error here is that xhci-hcd says "ERROR Transfer event
> for disabled endpoint or incorrect stream ring" when the disconnect
> occurs during reset.
I think there is some misunderstanding of the issues.

"ERROR Transfer event for disabled endpoint or incorrect stream ring" This particular message is during the connect of the device and not during the disconnect.
To avoid this message the unusual_uas.h patch was sent earlier.

During disconnect of the device I get   "scsi host4: uas_post_reset: alloc streams error -19 after reset" and 
I dont get the same with the modified patch which Alan suggested, 
instead I get a proper disconnect.

> That shouldn't happen, no matter what quirks the
> device has.  It indicates a bug either in uas or in xhci-hcd.
>
> Alan Stern
>
Regards, -George
