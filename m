From: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Thu, 21 Aug 2014 10:41:02 -0400
Message-ID: <53F604FE.8040301@interlog.com>
References: <Pine.LNX.4.44L0.1408201507280.1959-100000@iolanthe.rowland.org>
Reply-To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1408201507280.1959-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tiziano Bacocco <tiziano.bacocco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 14-08-20 03:15 PM, Alan Stern wrote:
> On Tue, 19 Aug 2014, Christoph Hellwig wrote:
>
>> On Thu, Aug 07, 2014 at 11:58:37AM -0400, Alan Stern wrote:
>>>> On Wed, Aug 06, 2014 at 04:02:22PM -0400, Alan Stern wrote:
>>>>>> I doubt either of them forces users to hack up flags for these cases.
>>>>>
>>>>> Why was this change needed in the first place?  There's no explanation
>>>>> in the patch itself.
>>>>
>>>> Which chance?  The one to not support SG_FLAG_LUN_INHIBIT?
>>>
>>> No, the patch that started this Bugzilla entry.  Tiziano says it is
>>> needed in order to send vendor-specific commands that use the LUN bits
>>> in CDB[1].
>>
>> Yes, I'd really like to know the exact scenario.  What kind of command
>> is this and who sends it?
>
> I don't know what the command is, but Tiziano is sending it via the
> SCSI-generic (sg) interface.
>
> In the meantime, I have made a little progress with Windows.  It turns
> out there are two reasons my earlier test didn't work:
>
> 	I didn't bother to set up a valid serial number for the test
> 	device, and Windows wants to see the serial number.
>
> 	Windows wants at least one of the logical units to be
> 	removable.
>
> After those issues were fixed, the host did recognize both logical
> units.  I tested with two devices, one reporting an ANSI SCSI level of
> 0 and the other 2.  In both cases, Windows 7 does _not_ stick the LUN
> value into the high bits of CDB[1].
>
> This suggests that we shouldn't be doing that either, for USB
> mass-storage devices.  But I'm reluctant to change it because of the
> possibility of regressions, not to mention the fact that it would
> violate the SCSI spec.
>
> Suggestions?

Perhaps we could add another bit flag in struct
scsi_host_template such as:
     unsigned int transport_says_dont_scsi2_lun_cmd:1;

then drivers/usb/storage/scsiglue.c could set that
bit in its usb_stor_host_template and
drivers/scsi/scsi.c could take heed (and not mask
cmd->cmnd[1] with the LUN).

Doug Gilbert


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
