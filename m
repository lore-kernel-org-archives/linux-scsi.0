From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 0/7] libsas error handling + discovery v6
Date: Mon, 23 Jan 2012 12:57:13 -0800
Message-ID: <CAA9_cmd6FVVjm-wMAGRrUH-i-dC3ZtiYLsO5K-0F4dm=064JHA@mail.gmail.com>
References: <20120121014910.24930.54011.stgit@localhost6.localdomain6>
	<491F29790D474988ACF0C10BF277BC3B@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <491F29790D474988ACF0C10BF277BC3B@usish.com.cn>
Sender: linux-ide-owner@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 20, 2012 at 10:12 PM, Jack Wang <jack_wang@usish.com> wrote=
:
>> Changes since v5: http://marc.info/?l=3Dlinux-scsi&m=3D1326564758296=
37&w=3D2
>>
>> 1/ Reworked "libsas: let libata recover links that fail to transmit
> initial
>> =A0 =A0sig-fis" to better handle problematic expanders and slow to a=
ttach ata
>> =A0 =A0devices. =A0libsas will now validate linkrate and take 'devic=
e-type' into
>> =A0 =A0account when determining if a new device is attached.
>>
>> 2/ Added support for asynchronously scanning ata devices.
>>
>> 3/ Reworked "libsas: fix sas_unregister_ports vs sas_drain_work" as
> lockdep
>> =A0 =A0complained about the original.
>>
>> 4/ New patch "libsas: fix sas port naming" makes direct-attached dev=
ice
> naming
>> =A0 =A0more predictable and consistent with expander attached device=
 naming.
>>
>> 5/ Made scan order more predictable by ensuring that regardless of d=
evice
> type
>> =A0 =A0we always attach in discovery order. =A0Slow to link devices =
will still
> be
>> =A0 =A0scanned out of order, link needs to be in at least the 'stp p=
ending'
> state
>> =A0 =A0before the device will be considered attached.
>>
> [Jack Wang]
> Asynchronously scan really make the discovery far more quickly, with =
v4
> reset expander will need more than 3 minites to get discovered, with =
this v6
> patchset it takes less than 5 seconds.

Great!

> Dear Dan,
>
> Could you share how you test procedure to find out these bugs?
>

These fixes have primarily been driven by libsas ata error handling as
robust as libata, and teaching libsas that ata links need more care
and handling than it was giving before.

In the case of async probing, this is something that libata has had
since 2.6.29, but was never added to libsas.

--
Dan
