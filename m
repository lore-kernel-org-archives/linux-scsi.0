From: Adam Bennett <abennett72@gmail.com>
Subject: [Solved] Re: SSD being put to sleep during boot-up when laptop on
 battery
Date: Sun, 4 Feb 2018 21:33:05 -0500
Message-ID: <cf496ae3-391e-cb9c-7e71-387c51be9a72@gmail.com>
References: <Pine.LNX.4.44L0.1712251124400.9922-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1712251124400.9922-100000@netrider.rowland.org>
Content-Language: en-US
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The problem was resolved upon upgrading laptop-mode-tools to 1.72.2.

Adam


On 12/25/2017 11:29 AM, Alan Stern wrote:
> On Sun, 24 Dec 2017, Adam Bennett wrote:
>
>> Alan,
>>
>> I have a Dell Precision 7520 with an Samsung SSD in addition to an NVMe
>> drive.  I'm currently running 4.14.8 but have seen the below problem
>> since I moved from 4.9 to 4.13.
>>
>> When I boot without AC plugged in, the SSD is stopped almost immediately
>> in the boot process, not allowing the boot to continue.
>>
>> I can boot on fine on AC.  When I unplug the cord, I see the "Stopping
>> disk" message, and the system is unresponsive until I plug the AC back in.
>>
>> I initially thought the problem was in user-space, but I set up
>> laptop-mode-tools to keep "control" as "on", and the problem still
>> persists.  Also, I don't see the issue in 4.9.
> It's entirely possible that the problem does lie in userspace, during
> boot-up.  Don't forget that your initramfs image could be causing this;
> have you tried to rebuild it with the new laptop settings?
>
>> I have temporarily worked around the problem by returning from
>> sd_suspend_runtime without calling sd_suspend_common in sd.c (obviously
>> not the true fix).
>>
>> I have tried a number of searches, and couldn't find any bug reports of
>> this nature, but I'm not that in-tune with the linux development process
>> to have searched all the correct places.
> This should be sent to the linux-pm and linux-scsi mailing lists
> (CC'ed).
>
>> I'd like to help track this problem down, do you have any suggestions or
>> is there some additional details I could provide?
> You can try bisecting between the 4.9 and 4.13 kernels to find the
> commit which first caused the problem.
>
> Alan Stern
>
