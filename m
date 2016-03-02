From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v1 2/3] PM / sleep: try to runtime suspend for direct complete
Date: Wed, 2 Mar 2016 10:26:44 +0100
Message-ID: <CAPDyKFqPpZ18ZJ27GU9O4aLH54C5L4Tudkx_bgjULvjRe32RuA@mail.gmail.com>
References: <1456359089-19807-1-git-send-email-dbasehore@chromium.org>
	<1456359089-19807-2-git-send-email-dbasehore@chromium.org>
	<CAPDyKFqjLuy63fsZQGE7DSR818dUt4Z+rTLPOG_gbsrQ0-htHw@mail.gmail.com>
	<CAGAzgsocODbT9+sKE0tR1W5V=68FkX=O6_mvSwhzu7Lq9E7NtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGAzgsocODbT9+sKE0tR1W5V=68FkX=O6_mvSwhzu7Lq9E7NtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "dbasehore ." <dbasehore@chromium.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Len Brown <len.brown@intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2 March 2016 at 09:31, dbasehore . <dbasehore@chromium.org> wrote:
>
> On Mar 1, 2016 12:41, "Ulf Hansson" <ulf.hansson@linaro.org> wrote:
>>
>> On 25 February 2016 at 01:11, Derek Basehore <dbasehore@chromium.org>
>> wrote:
>> > This tries to runtime suspend devices that are still active for direct
>> > complete. This is for cases such as autosuspend delays which leaves
>> > devices able to runtime suspend but still active. It's beneficial in
>> > this case to runtime suspend the device to take advantage of direct
>> > complete when possible.
>>
>> Unfortunate this doesn't work. In the device_prepare() phase the PM
>> core prevents runtime suspend via a call to pm_runtime_get_noresume().
>>
>> Kind regards
>> Uffe
>>
>
> A call to pm_runtime_put_sync_suspend should work. We can't do this
> earlier, because we don't know if the device will actually use
> direct_complete due to its children. Calling pm_runtime_put_noidle may
> allow another pm_runtime_put to runtime suspend the device, but we're
> trying to do that anyways. Also, we can't just call ...put_sync since that
> might not suspend due to autosuspend delays.
>
> We just need to balance the call with another get_noresume after. Am I
> missing anything?

Yes.

The important part that you need to take into consideration is the
sysfs intererface for runtime PM of devices. It allows userspace to
prevent runtime PM suspend (pm_runtime_forbid()). Therefore, you
simply can not rely on the regular runtime PM APIs to put a device
into low power state during system PM.

In cases of a runtime PM centric subsystem/driver, it can instead use
pm_runtime_force_suspend().

Kind regards
Uffe
