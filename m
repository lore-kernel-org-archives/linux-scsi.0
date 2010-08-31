From: adam radford <aradford@gmail.com>
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
Date: Tue, 31 Aug 2010 11:15:23 -0700
Message-ID: <AANLkTi=s5LusUgDFY4+qeWg4nfXZzF34UEafqZwEG+AM@mail.gmail.com>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan>
	<AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com>
	<alpine.DEB.2.00.1008271306100.24692@p34.internal.lan>
	<alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
	<alpine.DEB.2.00.1008310717260.4858@p34.internal.lan>
	<alpine.DEB.2.00.1008310732120.5156@p34.internal.lan>
	<alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Justin,

There were no changes in the driver other than to force a 60 second I/O
timeout.  You probably have a udev rule that was already giving you 60
second timeouts for all scsi devices, so this patch did absolutely noth=
ing.

More likely is that there is an I/O pattern change between the kernels
that is causing a 3ware firmware issue (or drive firmware issue) on
your configuration.
I have forwarded your case to 3ware firmware support.

-Adam


On Tue, Aug 31, 2010 at 5:23 AM, Justin Piszcz <jpiszcz@lucidpixels.com=
> wrote:
>
>
> On Tue, 31 Aug 2010, Justin Piszcz wrote:
>
>>
>>
>> On Tue, 31 Aug 2010, Justin Piszcz wrote:
>>
>>>
>>>
>>> On Sun, 29 Aug 2010, Justin Piszcz wrote:
>>>
>>>> On Fri, 27 Aug 2010, Justin Piszcz wrote:
>>
>> Per my earlier message, both cards were resetting, scsi0 and scsi1 u=
nder
>> kernel 2.6.35(.x), with 2.6.34, the lag problem is gone and my machi=
ne is
>> back to normal again. =A0It is unlikely that both cards would be at =
fault,
>> in addition I spent several hours trying different things, removing =
the
>> BBU
>> modules for example, but always staying on the 2.6.35 kernel.
>>
>> I am now able to run rss2email (which ALWAYS caused the machine to l=
ockup
>> and freeze until one of the controllers reset) without any problems =
using
>> 2.6.34.
>>
>> 2.6.34.1 =3D good
>> 2.6.35.x =3D has 3ware bug
>>
>> There appears to be a bug in the commit for the 3w-9xxx updates.
>>
>> On 2.6.34 now and no problems so far, I am continuing to test.
>>
>> http://marc.info/?l=3Dlinux-kernel&m=3D127419418304483&w=3D2
>>
>> Adam Radford (2):
>> =A0 =A0 3ware maintainers update
>> =A0 =A0 3w-xxxx, 3w-9xxx: force 60 second timeout
>>
>>
>> Justin.
>
>
> Latest-- 2.6.34.x seems to fix the issue, no lag whatsoever, the syst=
em is
> very responsive when running rss2email, again no lag, have run 10-15 =
tests
> without a single incident. =A0I also re-enabled msi and put my optimi=
zation
> script back in init.d, everything continues to work perfectly.
>
> Will wait for Adam on what went wrong with the 2.6.35 3w-9xxx update.
>
> Justin.
>
>
