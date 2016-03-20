From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] uas: Limit qdepth at the scsi-host level
Date: Sun, 20 Mar 2016 14:28:26 +0100
Message-ID: <56EEA57A.9050107@redhat.com>
References: <1458377952-12567-1-git-send-email-hdegoede@redhat.com>
 <1458407176.2288.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1458407176.2288.5.camel@HansenPartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 19-03-16 18:06, James Bottomley wrote:
> On Sat, 2016-03-19 at 09:59 +0100, Hans de Goede wrote:
>> Commit 64d513ac31bd ("scsi: use host wide tags by default") causes
>> the scsi-core to queue more cmnds then we can handle on devices with
>> multiple LUNs, limit the qdepth at the scsi-host level instead of
>> per slave to fix this.
>
> Help me understand this bug a bit more.  Are you saying that the commit
> you identify is causing the block layer to queue more commands than
> you've set the per-lun limit to?  In which case we have a serious
> problem for more than just UAS.  Or are you saying that UAS always had
> a global command limit, but it just didn't get set correctly; however,
> it mostly worked until the above commit exposed the problem?

The latter. UAS has always had a global command limit, which so far
was enforced via a shared tag map rather then setting can_queue
correctly. The identified commit removed the usage of a shared
tag map which causes the core to queue more commands *in total*
then the global limit. I've no reason to believe that the core was
exceeding the per-lun limit on a single lun, but for uas exceeding
the limit when counting all queued commands per lun combined is just
as bad, since it really always was a global limit.

This theory is supported by the only bug report for 4.4 being a
(rare) multi-lun uas disk enclosure.

Regards,

Hans
