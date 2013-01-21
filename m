From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Mon, 21 Jan 2013 19:55:20 +1100
Message-ID: <CAGRGNgWc2QTnY==NdMeZpw-7L3WwQfBFOwm=UZZ3Jcz+dp=h3g@mail.gmail.com>
References: <50FA5F67.4080102@intel.com> <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
 <CAGRGNgXMthaFSvj4aJ8KCZb2R70rvohh_kHPu2JY1tV_9veriQ@mail.gmail.com> <20130121081417.GB6904@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130121081417.GB6904@aaronlu.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Aaron,

On Mon, Jan 21, 2013 at 7:14 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> On Mon, Jan 21, 2013 at 02:31:50PM +1100, Julian Calaby wrote:
>> Hi Alan,
>>
>> On Sun, Jan 20, 2013 at 5:46 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Sat, 19 Jan 2013, Aaron Lu wrote:
>> >> > closed.  Do we want to drop support for that kind of behavior?
>> >>
>> >> I don't think we should drop such support.
>> >> And the safest way to avoid such break is we refine the suspend
>> >> condition for ODD, and using what ZPODD defined condition isn't that
>> >> bad to me:
>> >> - for tray type, no media inside and tray close;
>> >> - for slot type, no media inside.
>> >> While whether tray is closed or not may not be that important, but at
>> >> least we should make sure there is no media inside.
>> >>
>> >> Thoughts?
>> >
>> > That sounds reasonable to me, at least as a first step.  If people want
>> > their CD drive to suspend, they can eject the disc.
>>
>> Stupid question: does the kernel know if a CD has audio tracks?
>
> Yes, cdrom module knows that, but the block driver(e.g. sr) doesn't.
> See cdrom_count_tracks in cdrom.c.
>
> May I know if you have an use case that you want to runtime suspend the
> cd drive with a disc inside? That would help us to refine the runtime
> suspend condition.

The discussion seemed to be restricting when the drive would be
suspended to only occasions where the drive is empty and, where
applicable, closed. I'll admit that I hadn't followed the discussion
enough to know what the restrictions were before that, but this seemed
to be a further restriction, therefore I assumed that you were
originally planning to be able to suspend the drive with a disk
inside.

I asked my question in the hope of someone setting up the compromise:
"we could suspend the drive only if the drive is empty and closed, or
a data disc is inside and nobody's using it."

Personally, providing nobody's using it, and relevant state is stored,
I can't see any reason why you can't suspend a drive with a disc in
it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
