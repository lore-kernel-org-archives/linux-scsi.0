From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC][PATCH linux-firmware] isci: Add firmware blob and sources
Date: Sun, 18 Dec 2011 16:15:53 -0800
Message-ID: <CAA9_cmdSE7njUQgEZkA+WKP=0is3fRiaxCMvPxg7i=vgn1Auuw@mail.gmail.com>
References: <1324142068.2825.341.camel@deadeye>
	<CAA9_cmd9KMS3UBsQJ0WxT0rtQJVWceVwxvyXtRD+PuzwjUHUGA@mail.gmail.com>
	<1324243556.2844.22.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324243556.2844.22.camel@deadeye>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 18, 2011 at 1:25 PM, Ben Hutchings <ben@decadent.org.uk> wr=
ote:
> On Sun, 2011-12-18 at 10:59 -0800, Dan Williams wrote:
>> On Sat, Dec 17, 2011 at 9:14 AM, Ben Hutchings <ben@decadent.org.uk>=
 wrote:
>> > isci requires a parameter blob which is usually found in NVRAM, bu=
t it
>> > can fall back to loading with request_firmware(). =A0These files a=
re
>> > taken from the Linux source tree where they were wrongly added in
>> > Linux 3.0.
>>
>> Oh, I was of the impression that the external firmware tree was for
>> license incompatible firmware images?
>
> firmware/README.AddingFirmware doesn't say that the licence makes a
> difference.

Sorry, missed that readme.  Yes, should have been added to
firmware.git directly.

>> > ---
>> > I'm a bit unclear on the purpose and use of isci_firmware.bin. =A0=
Is it
>> > needed for production hardware?
>>
>> It's a stop gap for platforms with missing or broken oem parameters.
>> It is meant to become vestigial once the platform revisions quiet
>> down.
>>
>> > Does it need to be customised
>> > per-system, or are module parameters sufficient for that? =A0(If n=
ot, why
>> > isn't it built into the driver?)
>>
>> It is customized per system to meet EMI and signal integrity targets
>> of a given platform.
>
> Given this, does it make sense to distribute a binary at all?
>

It defaults to something that is reasonable for a reference platform
and if you end up needing to customize it is easier to distribute a
new binary then move all these settings to module parameters.  That
said, the intent was to start using WARN_TAINT_ONCE() if it ever got
used and phase it out once the platform support stabilized.  It was
certainly convenient to have it in the same tree in the early days of
the driver.  Its use should be waning now.

--
Dan
