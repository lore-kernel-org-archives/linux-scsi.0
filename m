From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3w-sas 0000:02:00.0: vpd r/w failed.
Date: Wed, 26 Jan 2011 15:40:05 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101261534460.13169@p34.internal.lan>
References: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan> <AANLkTikECrLeVGQt6ui0eHVdohgtW7-ksetrsKp4sRNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-673268266-1296074405=:13169"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikECrLeVGQt6ui0eHVdohgtW7-ksetrsKp4sRNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-673268266-1296074405=:13169
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 26 Jan 2011, adam radford wrote:

> On Wed, Jan 26, 2011 at 11:45 AM, Justin Piszcz <jpiszcz@lucidpixels.com>=
 wrote:
>>
>> [475380.769837] 3w-sas 0000:02:00.0: vpd r/w failed. =A0This is likely a
>> firmware bug on this device. =A0Contact the card vendor for a firmware u=
pdate.
>>
>
> Justin,
>
> pci_vpd_pci22_wait() uses 'HZ' and time_after() to detect a timeout of
> reading the vpd.
>
> Do you have your kernel compiled with the following?
>
> -# CONFIG_NO_HZ is not set
> -# CONFIG_ACPI_PROCESSOR is not set
> -# CONFIG_CPU_FREQ is not set
>
> -Adam
>

Hi,

Yes, exactly:

$ egrep '(CONFIG_NO_HZ|CONFIG_ACPI_PROCESSOR|CONFIG_CPU_FREQ)' .config
# CONFIG_NO_HZ is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_CPU_FREQ is not set

When I use the CPU_FREQ, two things occur:

1. The motherboard reduces the voltages to the PCI-e slots I am told unless
    you also specify: processor.max_cstate=3D2.  When this occurs, it can c=
ause
    RAID controllers, or other devices plugged into the PCI-e slots to have
    problems.  Therefore, I have kept these options disabled and the only
    problem I have had is no turbo boost but I am fine with that since my
    system is quiet and stable.

2. With cpufreq loaded, it also emits a very high pitch whining noise
    (I have two of these boards, it does not do that with Windows 7).

Does the driver require some combination of those options to be enabled? Or
does the 3ware card need a firmware update?  What is the recommended fix?

It appears this has happened two times, so 2.6.36 & 2.6.37:

Dec 24 17:38:54 p34 kernel: [ 5687.691080] 3w-sas 0000:02:00.0: vpd r/w fai=
led.  This is likely a firmware bug on this device.  Contact the card vendo=
r for a firmware update.
Jan 26 12:26:11 p34 kernel: [475380.769837] 3w-sas 0000:02:00.0: vpd r/w fa=
iled.  This is likely a firmware bug on this device.  Contact the card vend=
or for a firmware update.

Justin.


--655872-673268266-1296074405=:13169--
