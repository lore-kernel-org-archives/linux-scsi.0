From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: 3.2.57 regression: isci driver broken: Unable to reset I T nexus?
Date: Mon, 28 Apr 2014 12:24:38 -0700
Message-ID: <CAPcyv4hzaDq61aM2eYayKbW1FX9KC-X32rvHXqYqePGXgo2xQQ@mail.gmail.com>
References: <201404281303.24977.linux@rainbow-software.org>
	<57283945f737477b90e5ae31b9403799@fmsmsx156.amr.corp.intel.com>
	<1398703903.97992.10.camel@djiang5-desk1.amr.corp.intel.com>
	<201404281922.19399.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201404281922.19399.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>
List-Id: linux-scsi@vger.kernel.org

[ adding Ben ]

On Mon, Apr 28, 2014 at 10:22 AM, Ondrej Zary
<linux@rainbow-software.org> wrote:
> On Monday 28 April 2014 18:51:44 Jiang, Dave wrote:
>> On Mon, 2014-04-28 at 16:28 +0000, Ondrej Zary wrote:
>> > On Monday 28 April 2014 17:50:29 Jiang, Dave wrote:
>> > > On Mon, 2014-04-28 at 13:03 +0200, Ondrej Zary wrote:
>> > > > Hello,
>> > > > just upgraded a server running 3.2.54-2 to 3.2.57-3 (Debian Wheezy)
>> > > > and it does not boot anymore because of isci driver breakage.
>> > >
>> > > I would not run anything less than 3.8 for the isci controller. 3.2 is
>> > > VERY old for that particular driver and likely very unstable. The
>> > > product version of that driver plus libsas started with 3.8. Also I'm
>> > > concerned that you aren't using the platform OEM parameters. You need
>> > > to turn your OROM or EFI driver on for the SAS controller.
>> >
>> > It's a Cisco UCS C22 M3 server with a crappy LSI fakeraid that cannot
>> > even be disabled. It was a pain to make it boot properly - had to use
>> > dmraid. But it has been working fine since then (2012). Until now.
>>
>> Yes but just because it has been working doesn't mean it is a good idea
>> to run unstable code.... You need the driver updates and the libsas
>> updates for it to function properly. Does this fail on 3.14? If it is
>> that patch I have a feeling it may be interacting badly with whatever is
>> was in 3.2 libsas that may not be a problem with latest kernels.... It
>> is odd to see all those hard resets however.... Did you have them when
>> it was working for you?
>
> Didn't know that it was unstable - it worked with no problems, better than
> some products marked as stable :)
> 3.13 works fine - I've installed it from wheezy-backports to work-around the
> bug.
>
> The log from working 3.2.54 is below (at the end) - there's one reset for each
> port.
>

I think the right answer for 3.2 is to drop commit 584ec1226519 "isci:
fix reset timeout handling".

libsas and its libata interaction went through significant overhaul
after 3.2 so it's not surprising that a change to reset handling
regresses like this.

Ideally there would be a backport of latest libsas available for 3.2,
but no one to my knowledge is working on that.

--
Dan
