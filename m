From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [PATCH] scsi: properly export media change notification capability
   in block device flags
Date: Sun, 11 Oct 2009 14:12:07 -0600
Message-ID: <4AD23C17.4010201@gmail.com>
References: <4AD237E3.6000206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751020AbZJKUMu@vger.kernel.org>
In-Reply-To: <4AD237E3.6000206@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/11/2009 01:54 PM, Robert Hancock wrote:
> Due to some oversight, the SCSI capability for reporting media change
> notifications was never actually translated into setting the appropriate
> GENHD_FL_MEDIA_CHANGE_NOTIFY flag. HAL uses this flag to detect whether the
> block device supports change notifications and so it never actually got
> detected. Set the flag when appropriate in sd and sr.
>
> Signed-off-by: Robert Hancock<hancockrwd@gmail.com>
>
> ---
>
> Gaah, am I disappointed in finding this one. Apparently people went to the
> trouble of adding ATAPI AN support, and adding the appropriate flags to indicate
> to userspace that it was supported, but nobody ever tested to make sure that
> the support worked all the way through to actually make HAL stop polling
> optical drives that support AN, which to my dismay, it doesn't. In fact even
> with this patch it still doesn't seem to, but that's presumably some HAL bug.
> HAL does now report that storage.removable.support_async_notification = true,
> however.

To follow up on the above, from what I can see from the HAL code, it has 
code to detect the capability from sysfs and set its flag, but there's 
no code to actually disable polling based on the flag. Seems like plenty 
of epic fail to go around on this one :-)
