From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Sat, 19 Jan 2013 16:55:03 +0800
Message-ID: <50FA5F67.4080102@intel.com>
References: <Pine.LNX.4.44L0.1301181017070.1988-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1301181017070.1988-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/18/2013 11:24 PM, Alan Stern wrote:
> On Fri, 18 Jan 2013, Aaron Lu wrote:
>
>>> Aaron, have you checked whether this patch works okay when you play a
>>> track on an audio-only CD on the computer?  The block interface looks
>>> okay but I'm not sure about the cdrom_device interface.
>>
>> Just verified it works OK with the whole patchset applied using 2 audio
>> CDs.
>>
>> After the ODD has been put into zero power state, insert an audio cd.
>> ODD will be resumed, gvfs will automatically mount the disc, and a
>> dialog titled "Audio Disc" asks me what to do. Press OK, the rhythmbox
>> application will get started. Press the Play button of rhythmbox, songs
>> will start to play, and runtime_usage is 2. Eject the disc, the ODD will
>> be put to zero power state some time later.
>
> What happens if you use a non-ZP drive?
>
> What happens if you're not running a desktop graphical environment, so
> gvfs doesn't mount the disc?  Basically, I'm worried that the drive may
> remain suspended after sr_open() returns.

Tried on my notebook with a normal ODD, using mplayer under console
mode, no GUI environment running, works fine.

The usage count will be incremented by the app, and get decreased
only when it exits. So the ODD will not be in runtime suspended state
when the app is running.

>
> What happens if you use a program other than rhythmbox?  There are (or
> used to be) programs which would issue the PLAY AUDIO command and then
> exit.  The drive would continue playing even while the device file was

Then we indeed have a problem. But I didn't find any such app in
Fedora's repo or by searching the internet. But of course such apps can
exist since the Mount Fuji spec defined such a command.

> closed.  Do we want to drop support for that kind of behavior?

I don't think we should drop such support.
And the safest way to avoid such break is we refine the suspend
condition for ODD, and using what ZPODD defined condition isn't that
bad to me:
- for tray type, no media inside and tray close;
- for slot type, no media inside.
While whether tray is closed or not may not be that important, but at
least we should make sure there is no media inside.

Thoughts?

Thanks,
Aaron

