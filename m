From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: STANDBY IMMEDIATE failed on NVIDIA MCP5x controllers when system suspend
Date: Mon, 11 Mar 2013 13:30:32 -0600
Message-ID: <CADLC3L0nM+3ttR8V8cCOZWGY+eJqGZdmKiTRieYr_d+Xqh36UA@mail.gmail.com>
References: <513D52BE.7040307@intel.com>
	<1362991742.2395.9.camel@dabdike.int.hansenpartnership.com>
	<CADLC3L1+z=Nx_MFBz60z3Ow_98hetLYDjK5On-zxwdpUf+quzA@mail.gmail.com>
	<1363013464.2395.63.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1363013464.2395.63.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Aaron Lu <aaron.lu@intel.com>, bladud@gmail.com, Joe Sapp <nixphoeni+kernel@gmail.com>, Alberto Mattea <support.intranet@libero.it>, Peter Dons Tychsen <donpedro@tdcadsl.dk>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 11, 2013 at 8:51 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2013-03-11 at 08:35 -0600, Robert Hancock wrote:
>> (resending due to GMail mess-up, sorry)
>>
>> On Mon, Mar 11, 2013 at 2:49 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Mon, 2013-03-11 at 11:42 +0800, Aaron Lu wrote:
>> >> Hi all,
>> >>
>> >> I've seen some reports on STANDBY IMMEDIATE failed on NVIDIA MCP5x
>> >> controllers when system goes to suspend(this command is sent by scsi sd
>> >> driver on system suspend as a SCSI STOP command, which is translated to
>> >> STANDBY IMMEDIATE ATA command). I've no idea of why this happened, so
>> >> I wrote this email in hope of getting some new idea.
>> >>
>> >> The related bug report:
>> >> https://bugzilla.kernel.org/show_bug.cgi?id=48951
>> >>
>> >> And google search showed that Peter reported a similar problem here:
>> >> http://marc.info/?l=linux-ide&m=133534061316338&w=2
>> >>
>> >> And bladud has found that, disable asyn suspend for the scsi target
>> >> device can work around this problem.
>> >>
>> >> Please feel free to suggest what can possibly be the cause, thanks.
>> >
>> > I sometimes despair of people getting PM stuff right.  What on earth is
>> > the point of refusing to suspend if the disk refuses to stop?  In theory
>> > it gives the device more time to park its head, but almost no modern
>> > drive requires this.  The next action suspend will take (if allowed) is
>> > to power down peripherals which will forcibly stop the device.  The stop
>> > request is purely informational for the device.  If it ignores it, then
>> > the bigger hammer still works.
>>
>> This really does matter. Especially on laptop hard drives (but on many
>> desktop ones as well), we really want to stop the drive, and therefore
>> unload the heads, before the power is shut off. Drives are often rated
>> for a much lower number of emergency head unloads (caused by power
>> loss) over their lifespan than normal software-commanded ones. So over
>> a long period of time, repeatedly failing to stop the drive before
>> power off will shorten its life. Maybe aborting suspend for this is a
>> bit harsh but it's not something that should be ignored.
>
> Where do you get this information from?  The only smart parameter
> tracking this is the power off retract count (it may originally have
> been the emergency head retract count, but it was renamed a while ago),
> and that happens for any head unload, however caused.  I know SCSI
> devices long ago ceased caring about this, because the in-drive
> capacitance is sufficient to achieve a head unload before the device
> completely spins down in forced power off (I admit the really old IDE
> devices ... the ones that required the OS to do everything did have a
> nasty habit of crashing their heads onto the surface, but they stopped
> being manufactured years ago) ... I really don't see how any modern SATA
> device would fail to do this.

They do still unload the heads if you cut power (I seem to recall
hearing that some of them actually used the rotational energy in the
spinning platters as a power source to do this). But it's not nearly
as nice for the drive as the normal commanded unload. You can kind of
tell just from the sound of it that it's not really the same at all.

Many drives do track these separately in SMART attributes. The one for
normal unloads is Load_Cycle_Count, the other is
Power-Off_Retract_Count. The drive on the machine I'm on right now,
for example, has a Load_Cycle_Count of 88 and Power-Off_Retract_Count
of 27. I haven't seen what the actual cycle limits are for these but
I'm willing to bet that the power-off retract count limit is a lot
lower.

>
>> Just to add to this point, it doesn't just matter for rotational
>> drives, either. A lot of SSDs use the "standby now" command to do some
>> kind of cleanup before power off. Some drives document that a
>> subsequent power up may take longer for the drive to be ready if it
>> wasn't "spun down" prior to the last power off. It's conceivable that
>> in some crappy drives, lack of proper power-off sequence could even
>> cause data loss.
>
> Well, no, they shouldn't ... not unless the drive violates its data
> integrity commitment, which is going to cause a whole load of FS
> corruption.  All our Jornalled FS guarantees rely on this data integrity
> commitment.  If they're violated, we have a whole boat load of data
> safety issues.

I'm sure there are some SSDs that do violate their data integrity
commitments - a while ago some tests were done (don't have a link
handy and I don't think they identified the actual vendor/model of the
drives in any case) but there were definitely some SSDs that did do
nasty things like trash unrelated data if power was lost while
writing, etc. So we definitely don't want to risk this sort of thing
occurring on a normal power-off or suspend.

There's a reference to this in SMART here, for example:
http://www.thomas-krenn.com/en/wiki/SMART_attributes_of_Intel_SSDs
They refer to what's normally called "Power-off Retract Count" for
HDDs as "Unsafe Shutdown Count ": "The raw value reports the
cumulative number of unsafe (unclean) shutdown events over the life of
the device. An unsafe shutdown occurs whenever the device is powered
off without STANDBY IMMEDIATE being the last command."
