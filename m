From: Mark Lord <kernel-R6A+fiHC8nRWk0Htik3J/w@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 07 Apr 2010 18:49:49 -0400
Message-ID: <4BBD0C0D.5060606@teksavvy.com>
References: <Pine.LNX.4.44L0.1004071516260.5760-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1004071516260.5760-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Mark Lord <liml-gsilrlXbHYg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 07/04/10 03:18 PM, Alan Stern wrote:
> On Wed, 7 Apr 2010, Mark Lord wrote:
>
>> Errr.. yes and no.
>>
>> Yes, because nobody else is likely to do anything about it,
>> so I will work around the hardware bug by updating hdparm.
>>
>> But no, there's no funky missing data length issue there.
>> Just a bridge chip that doesn't understand ATA_16 commands.
>
> Did you look at this comment and the following one:
>
> https://bugs.launchpad.net/ubuntu/+source/linux-fsl-imx51/+bug/431963#25
>
> Is the engineer from Genesys Logic totally off-base?
..

Yes.  As discussed already, there is *no* sector count parameter
for the (S)ATA "IDENTIFY" command.  Other USB/SATA bridges handle
this correctly in SAT mode, just not this specific model.

No big deal, we'll work around it.
It's low priority for me, though.

I do have a pre-release HDPARM that uses ATA_12 for IDENTIFY,
as this is reported to work on this hardware, even though it is
otherwise _identical_ to the command issue via ATA_16.
That's another indication of a buggy/inconsistent bridge chip.

And I've also added a sector count of "1" to hdparm's IDENTIFY
commands.  Properly implemented hardware/software will just ignore it
as usual, but this bridge might benefit from it.

Anyone want to give this second update a try?

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
